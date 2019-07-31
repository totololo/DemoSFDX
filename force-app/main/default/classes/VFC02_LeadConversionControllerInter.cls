public without Sharing class VFC02_LeadConversionControllerInter {
    @AuraEnabled
    public static String convertLeadAndRedirectToAccountLightning(String prospectId) {
        String errorMessage = '';
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassValidationRule__c, BypassWorkflow__c, ProfileId
                            from User
                            where id =: UserInfo.getUserId()];
        return doConversion(currentUser, prospectId, errorMessage);
    } 
    
    @AuraEnabled
    public static String doConversion(User currentUser, String prospectId, String errorMessage)
    {
        update byPassValidationForUser(currentUser, true);
        Map<ID,String> picklistMap = new Map<ID,String>();
        
        Lead lead = [SELECT Id , Partenaire__c , Address, RecordTypeId, Country,Reseau_Concurrent__c , Type_de_point__c, 
                     Activite_commerciale_principale__c, Industry, LeadSource, Langue_Principale_de_l_adresse__c,Tech_Operateur__c,
                     Email, Country__c, city__c, Street__c, State_Province__c,Postal_Code__c, Tech_CountryCode__c, Zone_d_implantation__c
                     FROM Lead 
                     Where Id =: prospectId];
        
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
        id zoneImp = lead.Zone_d_implantation__c;
        
        try {
            
            boolean isConverted = checkIfLeadAlreadyConverted(prospectId);
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
                lead.Zone_d_implantation__c = null;
                //lead.Country__c ='';
                //lead.Tech_CountryCode__c ='';
                //lead.State_Province__c = '';
                update lead;
                system.debug('Entered !isConverted'+ isConverted);
                system.debug('lead.Address.getCountry() ' + lead.Address.getCountry());
                String leadCountry = lead.Address.getCountry();

                //leadCountry = leadCountry.substring(0, 1).toUpperCase() + leadCountry.substring(1).toLowerCase();
				
                CountriesSequence__c countryInstance = CountriesSequence__c.getInstance(leadCountry); 
                /*if(countryInstance == null)
                {
                    List<String> countrySplitList = lead.Address.getCountry().split(' ');
                    String leadCountryAllFirstsCapital = '';
                    for(String countrySplit : countrySplitList)
                    {
                        leadCountryAllFirstsCapital += (countrySplit.substring(0, 1).toUpperCase() + countrySplit.substring(1).toLowerCase() + ' ');
                    }
                    system.debug(leadCountryAllFirstsCapital);
                    leadCountry = leadCountryAllFirstsCapital.substring(0, 1).toUpperCase() + leadCountryAllFirstsCapital.substring(1).toUpperCase();
                    countryInstance = CountriesSequence__c.getInstance(leadCountry);
                }*/
                System.debug('!!!!! I am here countryInstance !!!!' + countryInstance);
                if(countryInstance != null) {
                    List<Account> listAccounts = [SELECT Id 
                                                  FROM Account
                                                  Where Reference_internationale__c =: countryInstance.Sequence__c 
                                                 ];
                    system.debug('VFC02_LeadConversionControllerInter ' + listAccounts);
                    System.debug('!!!!! I am here 1 !!!!');
                    if(listAccounts.size() > 0) {
                        String error = Label.LeadConversionErrorMessage + ' (' + Label.Duplicate_Reference + ')'; 
                        update updateLead(lead, activiteCommercialePrincipale, reseauConcurrent,  typeDePoint, 
                                          partenaire,  industry,  languePrincipale,  Operateur);
                        update byPassValidationForUser(currentUser, false);
                        return error;
                    } else {
                        //waitingMessage = 'Converting';
                        System.debug('!!!!! I am here 2 !!!!');
                        //create instance from leadConvert
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(prospectId);
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
                        system.debug('John here 1 '+lcr);
                        
                        System.debug('!!!!! I am here 5 !!!!');
                        //redirect to the new account view page
                        //waitingMessage = 'Waiting';
                        Id newAccountId = lcr.getAccountId();
                        String sequenceNumber = '';
                        if(label.RT_Prospect_INTER.contains(lead.RecordTypeId)){
                            Map<String, Association_Record_Type_et_pays__mdt> associationRTPaysMap = new Map<String, Association_Record_Type_et_pays__mdt>();
                            List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_Converti__c
                                                                                             FROM Association_Record_Type_et_pays__mdt]; 
                            
                            for(Association_Record_Type_et_pays__mdt assRTPays : associationRTPays){
                                associationRTPaysMap.put(assRTPays.MasterLabel, assRTPays);
                            }
                            
                            countryInstance = null;
                            String reference = '';
                            List<CountriesSequence__c> listcountryInstances = CountriesSequence__c.getAll().values();
                            set<CountriesSequence__c> setCS = new set<CountriesSequence__c>();
                            list<CountriesSequence__c> listCS = new list<CountriesSequence__c>();
                            map<id,CountriesSequence__c> mapCS = new map<id,CountriesSequence__c>();
                            system.debug('JMB here '+newAccountId);
                            
                            Account acc =[SELECT id, reference__C , Tech_CountryCode__c
                                          From Account
                                          Where ID = :newAccountId];  
                            
                            
                            System.debug('### I am Here ' + listcountryInstances);
                            //Loop over the custom setting CountriesSequence__c values 
                            for(CountriesSequence__c csBNLPFR: listcountryInstances)
                            {
                                System.debug('### I am Here 2');
                                system.debug('VFC02_LeadConversionControllerInter acc ' + acc);
                                system.debug('VFC02_LeadConversionControllerInter acc.Reference__c ' + acc.Reference__c);
                                system.debug('VFC02_LeadConversionControlleSrInter csBNLPFR.Sequence__c ' + csBNLPFR.Sequence__c);
                                //Check if the current CountriesSequence__c is Belgium
                                if(acc.reference__C != null && csBNLPFR.Sequence__c.substring(0,2) == acc.Reference__c.substring(0,2))
                                {
                                    system.debug('VFC02_LeadConversionControlleSrInter entered 1');
                                    //Decrement Current Sequence in Custom Setting
                                    csBNLPFR.Sequence__c = csBNLPFR.Sequence__c.substring(0,2)+String.valueOf(Integer.valueOf(csBNLPFR.Sequence__c.substring(2,csBNLPFR.Sequence__c.length()))-1);  
                                    setCS.add(csBNLPFR);
                                    mapCS.put(csBNLPFR.id,csBNLPFR);
                                }
                                system.debug('JMB lead ' + lead);
                                system.debug('JMB lead.Country ' + lead.Country);
                                system.debug('JMB csBNLPFR.name ' + csBNLPFR.name);
                                if(lead.Country == csBNLPFR.name)
                                {
                                    system.debug('VFC02_LeadConversionControlleSrInter entered 1');
                                    //Increment account reference__c
                                    reference = lead.Tech_CountryCode__c + String.valueOf(Integer.valueOf((String.valueOf(csBNLPFR.Sequence__c).split(String.valueOf(csBNLPFR.Sequence__c).substring(0,2)))[1]));
                                    //Increment Luxembourg Sequence in Custom Setting
                                    csBNLPFR.Sequence__c = lead.Tech_CountryCode__c + String.valueOf(Integer.valueOf((String.valueOf(csBNLPFR.Sequence__c).split(String.valueOf(csBNLPFR.Sequence__c).substring(0,2)))[1]) + 1);
                                    setCS.add(csBNLPFR);
                                    mapCS.put(csBNLPFR.id,csBNLPFR);
                                }
                                
                            } 
                            
                            System.debug('=== Account converted using the following values ===');
                            System.debug('Lead Country :'+lead.Country);
                            System.debug('Metadata mapping :'+associationRTPaysMap.containskey(lead.Country));
                            System.debug('Account Prospect Country Id used '+associationRTPaysMap.get(lead.Country).ID_Prospect_Converti__c);
                            System.debug('=====================================================');
                            
                            if(associationRTPaysMap.containskey(lead.Country)){
                                AP01_Account.firstRun = true; //so we associate the services, transporteurs, etc... to the account
                                //sequenceNumber.replace(sequenceNumber.substring(0,2), account.Tech_CountryCode__c+'');
                                Account acct = new Account (Id = newAccountId, 
                                                            Type = typeDePoint, 
                                                            RecordTypeId = associationRTPaysMap.get(lead.Country).ID_Prospect_Converti__c, 
                                                            etat__c = '0', 
                                                            mode__c = 'En attente de signature',
                                                            Activite_commerciale_principale__c = activiteCommercialePrincipale,
                                                            Reseau_Concurrent__c = reseauConcurrent,
                                                            Partenaire__c = partenaire,
                                                            Industry = industry,
                                                            Langue_Principale_de_l_adresse__c = languePrincipale,
                                                            Operateur_Global__c = Operateur,
                                                            Langue_secondaire_de_l_adresse__c =null,
                                                            Email_du_magasin__c = lead.Email,
                                                            Zone_dimplantation__c = zoneImp,
                                                            
                                                            Tech_CountryCode__c = Countrycode,
                                                            shipping_Country__c = Country,
                                                            shipping_street__c = lead.Street__c,
                                                            Shipping_City__c = lead.City__c,
                                                            Shipping_Zip_Postal_Code__c = lead.Postal_Code__c,
                                                            Shipping_State_Province__c = StateProvince,
                                                            //ShippingCountryCode = countryCode,
                                                            
                                                            billing_Country__c = Country,
                                                            billing_street__c = lead.Street__c,
                                                            billing_City__c = lead.City__c,
                                                            billing_Zip_Postal_Code__c = lead.Postal_Code__c,
                                                            billing_State_Province__c = StateProvince,
                                                            Piste_convertie_vers_compte__c  =true,
                                                            //billingCountryCode = countryCode,                                                            
                                                            reference__c = reference,
                                                            reference_internationale__c = reference
                                                           );
                                
                                update acct;
                                for(id id : mapCS.keyset()){
                                    listCS.add(mapCS.get(id));  
                                }
                                update listCS;
                                if(acct.id != null)
                                {
                                    List<Historique_Etat_Mode__c> hmdList = [select id,compte__c,etat__c from Historique_Etat_Mode__c
                                                                             where compte__c = : acct.id];
                                    for(Historique_Etat_Mode__c hmd:hmdList)
                                    {
                                        hmd.Etat__c = '0';
                                        hmd.Mode__c = 'En attente de signature';
                                    }
                                    update hmdList;      
                                }
                                
                                
                                /*Historique_Etat_Mode__c hmd = new Historique_Etat_Mode__c(Compte__c = acct.Id,
Creerpar__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName(),
Datedecreation__c = DateTime.now(),
Etat__c = '0',
Mode__c = 'En attente de signature'
);
//insert hmd;*/
                                
                                
                            }
                        }
                        update updateLead(lead, activiteCommercialePrincipale, reseauConcurrent,  typeDePoint, 
                                          partenaire,  industry,  languePrincipale,  Operateur);
                        update byPassValidationForUser(currentUser, false);
                        return newAccountId;
                    }
                    
                }  
            } else {
                update byPassValidationForUser(currentUser, false);
                errorMessage = Label.Lead_Already_Converted;
                return errorMessage;
            }
        }
        catch(Exception e) { 
            update updateLead(lead, activiteCommercialePrincipale, reseauConcurrent,  typeDePoint, 
                              partenaire,  industry,  languePrincipale,  Operateur);
            update byPassValidationForUser(currentUser, false);
            String ex = e.getMessage(); 
            System.debug('!!!gho exception : ' + e.getMessage());
            errorMessage = System.Label.LeadConversionErrorMessage;
            System.debug('!!!gho Label.Lead_FirstName : ' + Label.Lead_FirstName);
            if(ex.contains(Label.Lead_FirstName)) {
                errorMessage += ' : ' + Label.Lead_FillField + ' ' + Label.Lead_FirstName; 
            }
            
            return errorMessage;
        }
        update byPassValidationForUser(currentUser, false);
        return null;
    }
    @auraEnabled
    public static boolean checkIfLeadAlreadyConverted(String prospectId)
    {
        return [SELECT Id, IsConverted 
                FROM LEAD 
                WHERE ID = : prospectId
               ].IsConverted; 
    }
    
    @auraEnabled
    public static lead updateLead(Lead leadToUpdate, String activiteCommercialePrincipale, String reseauConcurrent, String typeDePoint, 
                                  String partenaire, String industry, String languePrincipale, String Operateur )
    {
        leadToUpdate.Activite_commerciale_principale__c = activiteCommercialePrincipale;
        leadToUpdate.Reseau_Concurrent__c = reseauConcurrent;
        leadToUpdate.Type_de_point__c = typeDePoint;
        leadToUpdate.Partenaire__c = partenaire;
        leadToUpdate.Industry = industry;
        leadToUpdate.Langue_Principale_de_l_adresse__c = languePrincipale;
        leadToUpdate.Tech_Operateur__c = Operateur;
        return  leadToUpdate;
    } 
    @auraEnabled
    public static user byPassValidationForUser(User user, Boolean bypassValidation )
    {
        user.BypassValidationRule__c = bypassValidation;
        return  user;
    }
    
}