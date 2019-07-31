public class VFC02_LeadConversionController 
{
    private ApexPages.StandardController controller; 
    private Id recordId;
    public boolean showLink {get;set;}
    public String errorMessage {get;set;}
    public String waitingMessage {get;set;}
    private Lead lead = null;
    
    public VFC02_LeadConversionController(ApexPages.StandardController stdController) {

        //this link should be visible only if an error occured
        //redirectleto the ad page
        this.showLink = false;
        this.controller = stdController; 
        lead = (lead) this.controller.getRecord();
        recordId = this.controller.getRecord().Id; 
    }
    
    /*
* Check if Lead already converted 
* Case of lead opened in two tabs at the same time
*/
    private boolean checkIfLeadAlreadyConverted() {
        return [SELECT Id, IsConverted 
                FROM LEAD 
                WHERE ID = : recordId
               ].IsConverted; 
    }
    
    public PageReference convertLeadAndRedirectToAccount() {
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassValidationRule__c, BypassWorkflow__c
                            from User
                            where id =: UserInfo.getUserId()];
        currentUser.BypassValidationRule__c = true;
        update currentUser;
        Lead lead = [SELECT Id , Partenaire__c , Address, RecordTypeId, Country,Reseau_Concurrent__c , Type_de_point__c, 
                     Activite_commerciale_principale__c, Industry, LeadSource, Langue_Principale_de_l_adresse__c,Tech_Operateur__c,
                     Email, Country__c, city__c, Street__c, State_Province__c,Postal_Code__c, Tech_CountryCode__c
                     FROM Lead 
                     Where Id =: recordId];
        string reseauConcurrent = lead.Reseau_Concurrent__c;
        string activiteCommercialePrincipale = lead.Activite_commerciale_principale__c;
        string partenaire = lead.Partenaire__c;
        string typeDePoint = lead.Type_de_point__c;
        String industry = lead.Industry;
        String languePrincipale =lead.Langue_Principale_de_l_adresse__c; 
        String operateur = lead.Tech_Operateur__c ;
        String Country = lead.Country__c;
        String CountryCode = lead.Tech_CountryCode__c;
		String StateProvince = lead.State_Province__c;
        system.debug('Country '+Country);
        system.debug('CountryCode '+CountryCode);
        system.debug('StateProvince '+StateProvince);
        PageReference acctPage = null;
        try {
            
            boolean isConverted = checkIfLeadAlreadyConverted();
            system.debug('isConverted'+ isConverted);
            // map added to put values of the picklists of the lead
            if(!isConverted) {
                
                lead.Reseau_Concurrent__c= '';  
                lead.Activite_commerciale_principale__c = '';
                lead.Type_de_point__c = '';
                lead.Partenaire__c = '';
                lead.Industry = '';
                lead.Langue_Principale_de_l_adresse__c = '';
                lead.Tech_Operateur__c = '';
                update lead;
                lead = [SELECT Id , Partenaire__c , Address, RecordTypeId, Country, Type_de_point__c,
                        Activite_commerciale_principale__c,Industry, email, Street__c, City__c, Postal_Code__c
                        FROM Lead 
                        Where Id =: recordId];
                system.debug('lead.Address '+lead.Address);
                String leadCountry = Country;
                leadCountry = leadCountry.substring(0, 1).toUpperCase() + leadCountry.substring(1).toLowerCase();
                CountriesSequence__c countryInstance = CountriesSequence__c.getInstance(leadCountry); 
                System.debug('!!!!! I am here countryInstance !!!!' + countryInstance);
                if(countryInstance != null) {
                    List<Account> listAccounts = [SELECT Id 
                                                  FROM Account
                                                  Where Reference_internationale__c =: countryInstance.Sequence__c 
                                                 ];
                    System.debug('!!!!! I am here 1 !!!!');
                    if(listAccounts.size() > 0) {
                        String error = Label.LeadConversionErrorMessage + ' (' + Label.Duplicate_Reference + ')'; 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,error));
                        showLink = true;
                    } else {
                        waitingMessage = 'Converting';
                        System.debug('!!!!! I am here 2 !!!!');
                        //create instance from leadConvert
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(recordId);
                        System.debug('!!!!! I am here 3 !!!!');
                        LeadStatus convertStatus = [SELECT Id, MasterLabel
                                                    FROM LeadStatus 
                                                    WHERE IsConverted = true LIMIT 1];
                        System.debug('!!!!! I am here convertStatus !!!!' + convertStatus);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        //conversion should only include new account and contact.
                        lc.setDoNotCreateOpportunity(true);
                        System.debug('!!!!! I am here 4 !!!!');
                        system.debug('lc '+lc);
                        //convert the lead using LeadConvert instance
                        Database.LeadConvertResult lcr = Database.convertLead(lc);
                        System.assert(lcr.isSuccess());
                        system.debug('RT_Prospect_INTER '+Label.RT_Prospect_INTER);
                        system.debug('lead.RecordTypeId '+lead.RecordTypeId);
                        
                        System.debug('!!!!! I am here 5 !!!!');
                        //redirect to the new account view page
                        //waitingMessage = 'Waiting';
                        Id newAccountId = lcr.getAccountId(); 
                        if(label.RT_Prospect_France.contains(lead.RecordTypeId)){
                            Map<String, Association_Record_Type_et_pays__mdt> associationRTPaysMap = new Map<String, Association_Record_Type_et_pays__mdt>();
                            List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_Converti__c
                                                                                             FROM Association_Record_Type_et_pays__mdt]; 
                            
                            for(Association_Record_Type_et_pays__mdt assRTPays : associationRTPays){
                                associationRTPaysMap.put(assRTPays.MasterLabel, assRTPays);
                            }
                            if(associationRTPaysMap.containskey(lead.Country)){
                                System.debug('lead.Country' + lead.Country ); 
                                Account acct = new Account (Id = newAccountId, 
                                                            Type = typeDePoint, 
                                                            RecordTypeId = associationRTPaysMap.get(lead.Country).ID_Prospect_Converti__c, 
                                                            etat__c = '0', 
                                                            mode__c = 'En attente de signature',
                                                            //JMB
                                                            Activite_commerciale_principale__c = activiteCommercialePrincipale,
                                                            Reseau_Concurrent__c = reseauConcurrent,
                                                            Partenaire__c = partenaire,
                                                            Industry = industry,
                                                            Langue_Principale_de_l_adresse__c = languePrincipale,
                                                            Operateur_Global__c = Operateur,
                                                            Langue_secondaire_de_l_adresse__c =null,
                                                            Email_du_magasin__c = lead.Email,
                                                            
                                                            //Tech_CountryCode__c = Countrycode,
                                                            shipping_Country__c = Country,
                                                            shipping_street__c = lead.Street__c,
                                                            Shipping_City__c = lead.City__c,
                                                            Shipping_Zip_Postal_Code__c = lead.Postal_Code__c,
                                                            Shipping_State_Province__c = StateProvince,
                                                            billing_Country__c = Country,
                                                            billing_street__c = lead.Street__c,
                                                            billing_City__c = lead.City__c,
                                                            billing_Zip_Postal_Code__c = lead.Postal_Code__c,
                                                            billing_State_Province__c = StateProvince
                                                            //JMB
                                                           );
                                
                                if(typeDePoint == '-3'){
                                  acct.RecordTypeId = label.RT_ProspectConvertiPickupContact_Compte;
                                  acct.Version_de_contrat__c = 'V1116';
                                  acct.Grille_tarifaire__c = 'GTCONTACT';
                                  acct.Macroprofil_actuel__c=Label.Macroprofil_MP2; 
                                  acct.Macroprofil_de_reference__c = Label.Macroprofil_MP2;
                                }
                                update acct;
                            }
                        }
                        lead.Activite_commerciale_principale__c = activiteCommercialePrincipale;
                        lead.Reseau_Concurrent__c = reseauConcurrent;
                        lead.Type_de_point__c = typeDePoint;
                        lead.Partenaire__c = partenaire;
                        lead.Industry = industry;
                        lead.Langue_Principale_de_l_adresse__c = languePrincipale;
                        lead.Tech_Operateur__c = operateur;
                        update lead;
                        acctPage =  new PageReference('/' + newAccountId);
                        acctPage.setRedirect(true);
                    }
                }  
            } else {
                showLink = true;
                errorMessage = Label.Lead_Already_Converted;
            }
        }
        catch(Exception e) { 
            lead.Activite_commerciale_principale__c = activiteCommercialePrincipale;
            lead.Reseau_Concurrent__c = reseauConcurrent;
            lead.Type_de_point__c = typeDePoint;
            lead.Partenaire__c = partenaire;
            lead.Industry = industry;
            lead.Langue_Principale_de_l_adresse__c = languePrincipale;
            lead.Tech_Operateur__c = operateur;
            update lead;
            currentUser.BypassValidationRule__c = true;
            update currentUser;
            String ex = e.getMessage(); 
            System.debug('!!!gho exception : ' + e.getMessage());
            errorMessage = System.Label.LeadConversionErrorMessage;
            System.debug('!!!gho Label.Lead_FirstName : ' + Label.Lead_FirstName);
            if(ex.contains(Label.Lead_FirstName)) {
                errorMessage += ' : ' + Label.Lead_FillField + ' ' + Label.Lead_FirstName; 
            }
            showLink = true;  
        }
        
        currentUser.bypassValidationRule__c = false;
        update currentUser;
        
        return acctPage;
    } 
    
    public PageReference redirectToLead() {
        PageReference leadPage = new PageReference('/' + recordId); 
        leadPage.setRedirect(true);
        return leadPage;
    }
    
}