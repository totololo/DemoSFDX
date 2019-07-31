/*
* Class to fill the Questionnaire of VA / VAP
* @author: Mohamad El Kebbi
* @date: 5/28/2018
* @Test: VFC14_DemarrageCompteRenduRempli_Test
*/
public with sharing class VFC14_DemarrageCompteRenduRempli {
    public boolean disabled{get;set;}
    public boolean inConsole{get;set;}
    public Account theAccount{get;set;}
    public Contact otherContact{get;set;}
    public String selectedRT {get;set;}
    public Compte_rendu_rempli__c CRR {get;set;}
    public boolean isInterrompu{get;set;}
    public boolean secondBlock {get;set;}
    public boolean generalInfoSec {get;set;}
    public boolean isVA {get;set;}
    public boolean newCRR {get;set;}
    public boolean enAttenteDeTraitement{get;set;}
    public boolean enCoursDePrep{get;set;}
    public boolean showLookup{get;set;}
    public boolean statutTermine{get;set;}
    public Date dateDeVisite {get;set;}
    public String accountId {get;set;}
    public List<Questions_CR__c> lstQuestions  {get;set;}
    public List<wrapperQuestion> listWrapperQuestions {get; set;}
    public List<Reponse_CR__c> listReponses {get; set;}
    public List<Reponse_CR__c> listReponsesToUpdate {get; set;}
    public id CRRid {get;set;}
    //Do not display the questions if no questionnaire exists or case Id not passed in parameter or if status is not correct
    public boolean renderQuestionnaire {get; set;}
    //Questionnaire that have MP and status like the one on case
    public List<Association_CR_CRR__mdt> ListAssociation_CR_CRR {get; set;}
    public Map<string,string> mapCR_CRR {get; set;}
    public Map<string,string> mapCRR_CR {get; set;}
    public Map<Id,Reponse_CR__c> oldReponsesMap{get;set;}
    public Map<String,String> numeroReponseMap{get;set;}
    public list<Contact> lstContacts {get;set;}
    public list<id> lstContactsId {get;set;}
    //Constructor
    public VFC14_DemarrageCompteRenduRempli(ApexPages.StandardController controller) {
        disabled = true; 
        CRR = (Compte_rendu_rempli__c)controller.getRecord();
        
        ListAssociation_CR_CRR = [SELECT DeveloperName, CR__c, CRR__c FROM Association_CR_CRR__mdt ];
        mapCR_CRR = new Map<string,string>();
        mapCRR_CR = new Map<string,string>();
        for(Association_CR_CRR__mdt ass:ListAssociation_CR_CRR){
            mapCR_CRR.put(ass.CR__c,ass.CRR__c);
            mapCRR_CR.put(ass.CRR__c,ass.CR__c);
        }
        statutTermine = false;
        // NEW Compte Rendu Rempli
        
        if(CRR.id==null) {
            accountId = CRR.Compte__c;
            
            if(string.isBlank(accountId)){
                accountId= apexpages.currentpage().getparameters().get('accId');
            }
            
            list<Account> listAccounts  = [SELECT Reference_internationale__c , Secteur__c, Date_de_visite__c ,Hauteur_cm__c, 
                                           Seuil_calcule__c,  Largeur_cm__c, Nombre_detageres__c,  Profondeur_cm__c, Seuil_contractuel__c,
                                           Contact_operationnel_1__c, Contact_operationnel_1__r.LastName,Contact_operationnel_1__r.FirstName, 
                                           Contact_operationnel_1__r.Email, Contact_operationnel_1__r.Phone, Contact_operationnel_1__r.MobilePhone,
                                           Responsable_facturation__c, Responsable_facturation__r.LastName,Responsable_facturation__r.FirstName, 
                                           Responsable_facturation__r.Email, Responsable_facturation__r.Phone, Responsable_facturation__r.MobilePhone, 
                                           Nom_Responsable_magasin__c, Nom_Responsable_magasin__r.LastName,Nom_Responsable_magasin__r.FirstName, 
                                           Nom_Responsable_magasin__r.Email, Nom_Responsable_magasin__r.Phone, Nom_Responsable_magasin__r.MobilePhone,
                                           Macroprofil_actuel__c, Macroprofil_actuel__r.Name
                                           FROM Account 
                                           WHERE id =:accountId];
            lstContacts = [SELECT id, Account.id , name FROM Contact WHERE Account.id =:accountId];
            System.debug('@VFC14_DemarrageCompteRenduRempli | lstContacts : ' + lstContacts);
            system.debug('@VFC14_DemarrageCompteRenduRempli | ### accId' + accountId);
            if(listAccounts.size() > 0){
                theAccount = listAccounts[0];
                CRR = new Compte_rendu_rempli__c();
                CRR.Compte__c = theAccount.Id;
                CRR.Statut__c = Label.VAVAP_enCoursDePrep;
            }
            newCRR = true;
            inConsole = false;
            enAttenteDeTraitement = true;
            showLookup = false;
            secondBlock = false;
            renderQuestionnaire = true;
            lstContactsId = new List<Id>();
            for(Contact con: lstContacts){
                lstContactsId.add(con.id);
            }
        }
        // Editing CRR
        else{
            newCRR = false;
            inConsole = false;
            // directly open the questionnaire
            secondBlock = true;
            renderQuestionnaire = true;
            /*CRR = [SELECT id, name, RecordTypeId , Numero_de_point_relais__c, Compte__c ,Compte_rendu__c,Statut__c,Contact__c ,Commentaires_divers_Relais__c,Date_de_la_visite__c ,
Commentaires_divers_Pickup__c,Hauteur__c ,Seuil_calcule__c , Largeur__c,Nombre_d_etageres__c,Profondeur__c,Seuil_contractuel__c,Prenom_CR__c,
Nom_CR__c,Email_CR__c,Telephone_fixe_CR__c,Telephone_portable_CR__c,Contact_operationnel_rencontre__c ,Responsable_facturation_rencontre__c, 
Responsable_magasin_rencontre__c,Notes_de_preparation__c,Hauteur_initiale__c, Seuil_calcule_initial__c, Largeur_initiale__c, Interrompu__c,
Nombre_d_etageres_initial__c, Profondeur_initiale__c, Seuil_contractuel_initial__c,Notes_internes__c , Type_de_compte_rendu__c , Motif_d_interruption__c,Motif__c
FROM Compte_rendu_rempli__c 
WHERE id =:CRR.Id ];*/
            CRR = [SELECT id, name, RecordTypeId , Numero_de_point_relais__c, Compte__c ,Compte_rendu__c,Statut__c,Contact__c ,Commentaires_divers_Relais__c,Date_de_la_visite__c ,
                   Commentaires_divers_Pickup__c,Hauteur__c ,Seuil_calcule__c , Largeur__c,Nombre_d_etageres__c,Profondeur__c,Seuil_contractuel__c,Prenom_CR__c,
                   Nom_CR__c,Email_CR__c,Telephone_fixe_CR__c,Telephone_portable_CR__c,Contact_operationnel_rencontre__c ,Responsable_facturation_rencontre__c, 
                   Responsable_magasin_rencontre__c,Notes_de_preparation__c, Interrompu__c,Profondeur_initiale1__c,Seuil_calcul_initial1__c,Seuil_contractuel_initial1__c,
                   Notes_internes__c , Type_de_compte_rendu__c , Motif_d_interruption__c,Motif__c, Hauteur_initiale1__c,Largeur_initiale1__c,Nombre_d_etageres_initial1__c
                   FROM Compte_rendu_rempli__c 
                   WHERE id =:CRR.Id ];//add fields to query JK
            theAccount  = [SELECT Reference_internationale__c , Secteur__c, Date_de_visite__c ,Hauteur_cm__c,  Seuil_calcule__c,
                           Largeur_cm__c, Nombre_detageres__c,  Profondeur_cm__c, Seuil_contractuel__c,
                           Contact_operationnel_1__c, Contact_operationnel_1__r.LastName,Contact_operationnel_1__r.FirstName, 
                           Contact_operationnel_1__r.Email, Contact_operationnel_1__r.Phone, Contact_operationnel_1__r.MobilePhone,
                           Responsable_facturation__c, Responsable_facturation__r.LastName,Responsable_facturation__r.FirstName, 
                           Responsable_facturation__r.Email, Responsable_facturation__r.Phone, Responsable_facturation__r.MobilePhone, 
                           Nom_Responsable_magasin__c, Nom_Responsable_magasin__r.LastName,Nom_Responsable_magasin__r.FirstName, 
                           Nom_Responsable_magasin__r.Email, Nom_Responsable_magasin__r.Phone, Nom_Responsable_magasin__r.MobilePhone,
                           Macroprofil_actuel__c, Macroprofil_actuel__r.Name
                           FROM Account 
                           WHERE Id =: CRR.Compte__c] ;
            lstContacts = [SELECT id, Account.id FROM Contact WHERE Account.id =:theAccount.id];
            lstContactsId = new List<Id>();
            
            isInterrompu = CRR.Interrompu__c;        
            // Getting the list of contact ids that are related to the corresponding account
            for(Contact con: lstContacts){
                lstContactsId.add(con.id);
            }
            //selectedRT is the id of the chosen record Type VA/VAP
            selectedRT = CRR.RecordTypeId;
            showLookup = false;
            if(CRR.Statut__c==Label.VAVAP_statutTermine){
                statutTermine = true;
            }
            if(CRR.Statut__c==Label.VAVAP_EnAttenteDeVisite){
                showLookup = true;
            }
            
            redirectToQuestionnaire();
        }
        
        
    }
    //Fills the Record Type pickList VA/VAP
    public List<SelectOption> getCRTypes() 
    {
        List<SelectOption> typesNames = new List<SelectOption>();
        List<RecordType> lstCRTypes = [select id,Name, SobjectType from RecordType where SobjectType =:Label.VAVAP_compteRenduRempliLabel];
        typesNames.add(new SelectOption('', Label.VAVAP_Aucun));
        for(RecordType crtype : lstCRTypes)
        {
            typesNames.add(new SelectOption(crtype.id,crtype.Name));
        }
        return typesNames;
    }
    //Getting the Compte Rendu rempli types depending on the chosen record Type
    public void getPickListValues(){
        
        if(!String.isBlank(selectedRT))
        {
            selectedRT = selectedRT.substring(0, selectedRT.length() -3);
            CRR.RecordTypeId = selectedRT;
            CRR.Type_de_compte_rendu__c = '';
            disabled= false;
        }
        else
        {  
            CRR.Type_de_compte_rendu__c = '';
            disabled=true;
        }
    }
    
    //display questionnaire page
    public PageReference redirectToQuestionnaire(){
        // Error Record Type or Compte Rendu Rempli Type
        if(CRRid==null && ( String.isBlank(selectedRT) || String.isBlank( CRR.Type_de_compte_rendu__c))){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorType);
            ApexPages.addMessage(msg);
            return null;
        }
        secondBlock = true;
        renderQuestionnaire = true;
        
        
        //general information Section:
        
        generalInfoSec = true;
        // selected RT always has the value of CR
        if(selectedRT.contains(Label.VAVAP_recordTypeVA) ){
            isVA = true;  
        }else{
            isVA = false;
        }
        
        if(newCRR){
            CRR.Date_de_la_visite__c = System.today();
            // Questionnaire section
            lstQuestions = [SELECT Compte_rendu__c, Options_de_reponses__c,Type_de_reponse__c, Tech_Question_Order__c, Questions__c,
                            Follow_up__c,Changement_macro_profil__c,		//ajouté par FEK
                            Reponse_FollowUp__c, Numero_Question_Parent__c,Obligatoire__c, Facultatif__c, Ordre_d_affichage__c
                            FROM Questions_CR__c  
                            WHERE Compte_rendu__c IN (SELECT id 
                                                      FROM Compte_rendu__c 
                                                      WHERE RecordTypeId =:mapCRR_CR.get(selectedRT.substring(0,selectedRT.length()-3))
                                                      AND Type_de_compte_rendu__c = : CRR.Type_de_compte_rendu__c) 
                            ORDER BY Ordre_d_affichage__c ];
            
            listWrapperQuestions = new list<wrapperQuestion> ();
            // WrapperQuestion contains all the questions , number, type etc..
            for(Questions_CR__c ques:lstQuestions){
                wrapperQuestion wq = new wrapperQuestion();
                String rep = '';
                wq.Id = ques.Id;
                wq.obligatoire = ques.Obligatoire__c;
                wq.facultatif = ques.Facultatif__c ;
                wq.CompteRendu = ques.Compte_rendu__c;
                wq.numero = string.valueOf(ques.Tech_Question_Order__c);
                wq.showMPName = false;
                if(CRR.Type_de_compte_rendu__c ==Label.VAVAP_VALP && ques.Tech_Question_Order__c==1 ){
                    wq.showMPName =true;
                }
                wq.question = ques.Questions__c;
                wq.type = ques.Type_de_reponse__c;
                wq.repsuggere = parseReponseOptions(ques.Options_de_reponses__c ,ques.Type_de_reponse__c );
                wq.reponse = rep;
                wq.changementMacroProfil = ques.Changement_macro_profil__c;
                // follow up handling
                wq.followUp = ques.Follow_up__c; 
                wq.questionParent =String.valueOf(ques.Numero_Question_Parent__c);
                wq.reponseFollowUp = ques.Reponse_FollowUp__c;
                wq.OrdreDAffichage = ques.Ordre_d_affichage__c;
                
                listWrapperQuestions.add(wq);
            }
        } 
        // Case of Update
        else{
            oldReponsesMap = new Map<Id,Reponse_CR__c>();
            listReponses = [SELECT Compte_rendu_rempli__c, Id, Question__c, Reponse__c, Type_de_r_ponse__c, Questions_CR__r.Tech_Question_Order__c,
                            Questions_CR__r.Options_de_reponses__c,
                            Follow_up__c,Changement_macro_profil__c,	//FEK
                            Reponse_FollowUp__c, Numero_Question_Parent__c ,Obligatoire__c , Facultatif__c, Ordre_d_affichage__c
                            FROM Reponse_CR__c
                            WHERE Compte_rendu_rempli__c =: CRR.Id
                            ORDER BY Ordre_d_affichage__c
                           ];
            listWrapperQuestions = new list<wrapperQuestion> ();
            // getting the old responses in case of Edit mode
            for(Reponse_CR__c rp : listReponses){
                wrapperQuestion wq = new wrapperQuestion();
                oldReponsesMap.put(rp.Id, rp);
                wq.Id = rp.Id;
                wq.obligatoire = rp.Obligatoire__c;
                wq.facultatif = rp.Facultatif__c ;
                wq.numero = string.valueOf( rp.Questions_CR__r.Tech_Question_Order__c);
                wq.question = rp.Question__c;
                wq.type = rp.Type_de_r_ponse__c;
                wq.repsuggere = parseReponseOptions(rp.Questions_CR__r.Options_de_reponses__c ,rp.Type_de_r_ponse__c );
                if(wq.type ==Label.VAVAP_multichoix){
                    wq.multiReponse = handleMultiPicklist(rp.Reponse__c);
                } else{
                    wq.reponse = rp.Reponse__c;  
                }
                wq.showMPName = false;
                if(CRR.Type_de_compte_rendu__c =='VALP' &&  rp.Questions_CR__r.Tech_Question_Order__c==1 ){
                    wq.showMPName =true;
                }
                wq.changementMacroProfil = rp.Changement_macro_profil__c;
                wq.followUp = rp.Follow_up__c; 
                wq.questionParent =rp.Numero_Question_Parent__c;
                wq.reponseFollowUp = rp.Reponse_FollowUp__c;
                wq.OrdreDAffichage = rp.Ordre_d_affichage__c;
                
                listWrapperQuestions.add(wq);
            }
        }
        
        //added by JK
        if(isVA && (newCRR || CRR.Statut__c != 'Terminé')){
            CRR.Hauteur_initiale1__c = theAccount.Hauteur_cm__c;
            CRR.Largeur_initiale1__c = theAccount.Largeur_cm__c;
            CRR.Nombre_d_etageres_initial1__c = theAccount.Nombre_detageres__c;
            CRR.Profondeur_initiale1__c = theAccount.Profondeur_cm__c;
            CRR.Seuil_calcul_initial1__c = theAccount.Seuil_calcule__c;
            CRR.Seuil_contractuel_initial1__c = theAccount.Seuil_contractuel__c;
        }
        if(!isVA || newCRR){ // Modified by TMAEITL FEK - Ticket 130250 | condition was isVa && newCRR
            CRR.Hauteur__c = theAccount.Hauteur_cm__c;
            CRR.Largeur__c = theAccount.Largeur_cm__c;
            CRR.Nombre_d_etageres__c = theAccount.Nombre_detageres__c;
            CRR.Profondeur__c = theAccount.Profondeur_cm__c;
            CRR.Seuil_contractuel__c = theAccount.Seuil_contractuel__c;
            CRR.Seuil_calcule__c = theAccount.Seuil_calcule__c;
        }
        
        return null;
    }
    // Getting the contact for the other Contact Lookup field
    public  PageReference getOtherContact(){
        
        System.debug('@VFC14_DemarrageCompteRenduRempli | lstContactsId : ' + lstContactsId);
        System.debug('@VFC14_DemarrageCompteRenduRempli | CRR.Contact__c : ' + CRR.Contact__c);
        System.debug('@VFC14_DemarrageCompteRenduRempli | lstContactsId.contains(CRR.Contact__c) : ' + lstContactsId.contains(CRR.Contact__c));
        if(CRR.Contact__c!=null){
            
            if(lstContactsId.contains(CRR.Contact__c)) {
                
                otherContact = [Select LastName, Account.id , FirstName, Email, MobilePhone, Phone from Contact where  Contact.id =: CRR.Contact__c];
                
                CRR.Prenom_CR__c = otherContact.FirstName;
                CRR.Nom_CR__c = otherContact.LastName;
                CRR.Email_CR__c = otherContact.Email;
                CRR.Telephone_fixe_CR__c = otherContact.Phone;
                CRR.Telephone_portable_CR__c = otherContact.MobilePhone;
            }
            else{
                //clear the fields if error
                CRR.Contact__c=null;
                CRR.Prenom_CR__c = '';
                CRR.Nom_CR__c = '';
                CRR.Email_CR__c = '';
                CRR.Telephone_fixe_CR__c = '';
                CRR.Telephone_portable_CR__c = '';
                
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorContact);
                ApexPages.addMessage(msg);
            }
        }else{
            //clear the fields
            CRR.Prenom_CR__c = '';
            CRR.Nom_CR__c = '';
            CRR.Email_CR__c = '';
            CRR.Telephone_fixe_CR__c = '';
            CRR.Telephone_portable_CR__c = '';
            
            //  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorContact);
            //  ApexPages.addMessage(msg);
        }
        return null;
        
    }     
    
    public PageReference saveResponse(){
        numeroReponseMap = new Map<String,String>();
        
        //Statut Aucun
        if( String.isBlank(CRR.Statut__c)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_aucunStatut );
            ApexPages.addMessage(msg);
            return null;
        }
        
        Boolean questionError = false;
        String erroredQuestions = '';
        
        for(wrapperQuestion wq : listWrapperQuestions){
            if(wq.type != Label.VAVAP_TypeReponseTitre){
                Boolean added = false;
                if(wq.multiReponse != null && wq.multiReponse.size()>0 ){
                    wq.reponse = multiToString(wq.multiReponse); 
                    system.debug('### wq.multiReponse' + wq.multiReponse);
                } 
                //added by jk
                else 
                    if(wq.multiReponse != null && wq.multiReponse.size()==0 ){
                        wq.reponse =''; 
                        system.debug('### wq.multiReponse' + wq.multiReponse);
                        
                    }
                numeroReponseMap.put(wq.numero, wq.reponse);
                // statut termine Condtition Obligatoire    
                if(CRR.Interrompu__c==false && wq.obligatoire && String.isBlank(wq.reponse) && (CRR.Statut__c==Label.VAVAP_statutTermine /*||CRR.Statut__c==Label.VAVAP_EnAttenteDeVisite tfs-129226*/ ) ){
                    /*ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_questionObligatoire + wq.numero);
ApexPages.addMessage(msg);
return null;*/
                    if(String.isBlank(erroredQuestions)) erroredQuestions += wq.numero;
                    else erroredQuestions += ', ' + wq.numero;
                    questionError = true;
                    added = true;
                }  
                //Statut Termine
                if(!added && CRR.Interrompu__c==false && CRR.Statut__c==Label.VAVAP_statutTermine && String.isBlank(wq.reponse) && !wq.followUp && !wq.facultatif ){
                    /*ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorTerminer + LABEL.VAVAP_questionNumero + wq.numero);
ApexPages.addMessage(msg);
return null;*/
                    if(String.isBlank(erroredQuestions)) erroredQuestions += wq.numero;
                    else erroredQuestions += ', ' + wq.numero;
                    questionError = true;
                }
                
                // Added by Fadi T.
                
                if(wq.changementMacroProfil && !String.isBlank(wq.reponse) && wq.reponse == theAccount.Macroprofil_actuel__r.Name && statutTermine==false){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorMacroProfil);
                    ApexPages.addMessage(msg);
                    return null;
                } 
            }
        }
        
        /* if(questionError){
ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorTerminer + LABEL.VAVAP_questionNumero + erroredQuestions);
ApexPages.addMessage(msg);
//return null;
}*/
        
        //validate the other contact on save as well
        System.debug('@VFC14_DemarrageCompteRenduRempli | lstContactsId : ' + lstContactsId);
        System.debug('@VFC14_DemarrageCompteRenduRempli | CRR.Contact__c : ' + CRR.Contact__c);
        System.debug('@VFC14_DemarrageCompteRenduRempli | lstContactsId.contains(CRR.Contact__c) : ' + lstContactsId.contains(CRR.Contact__c));
        if(CRR.Contact__c!=null && !lstContactsId.contains(CRR.Contact__c)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorContact);
            ApexPages.addMessage(msg);
            return null;
        }
        // atleast one contact checked Condtition
        if((CRR.Statut__c==Label.VAVAP_EnAttenteDeVisite || CRR.Statut__c==Label.VAVAP_statutTermine/*tfs-129226*/) && CRR.Contact_operationnel_rencontre__c==false && CRR.Responsable_facturation_rencontre__c==false && CRR.Responsable_magasin_rencontre__c==false ){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_atleastOneContact);
            ApexPages.addMessage(msg);
            return null;
        }
        
        // Follow Up Conditions
        if(CRR.Interrompu__c == false)
            for(wrapperQuestion wq : listWrapperQuestions){
                //commentaire case. 
                /* if(wq.followUp && wq.reponseFollowUp == '*' && !String.isBlank(numeroReponseMap.get(wq.questionParent)) && String.isBlank(wq.reponse) ){
System.debug('@VFC14_DemarrageCompteRenduRempli | Commentaire case');
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorFollowUp  + LABEL.VAVAP_questionNumero+ wq.numero));
return null;   
}*/
                if(wq.type != Label.VAVAP_TypeReponseTitre){
                    System.debug('VFC14_DemarrageCompteRenduRempli | wq.numero ' + wq.numero);
                    System.debug('VFC14_DemarrageCompteRenduRempli | wq.reponse ' + wq.reponse);
                    if(!String.isBlank(numeroReponseMap.get(wq.questionParent))){
                        if(wq.followUp && numeroReponseMap.get(wq.questionParent).contains(wq.reponseFollowUp) && String.isBlank(wq.reponse) ){
                            if(String.isBlank(erroredQuestions)) erroredQuestions += wq.numero;
                            else erroredQuestions += ', ' + wq.numero;
                            questionError = true;
                        }
                    }
                }
            }
        
        if(questionError){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorFollowUp  + LABEL.VAVAP_questionNumero + erroredQuestions));
            return null;
        }
        
        // Interrompu Condtition
        if(CRR.Interrompu__c==true && String.isBlank(CRR.Motif_d_interruption__c) ){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_ErrorInterrompu);
            ApexPages.addMessage(msg);
            return null;
        }
        // Date Condtition
        if((CRR.Date_de_la_visite__c == null ) && (CRR.Statut__c==Label.VAVAP_enCoursDePrep || CRR.Statut__c==Label.VAVAP_enAttente || CRR.Statut__c==Label.VAVAP_statutTermine) ){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_dateErreur);
            ApexPages.addMessage(msg);
            return null;
        }
        // Autre Motif
        if((String.isBlank(CRR.Motif__c)) && (CRR.Motif_d_interruption__c==Label.VAVAP_Autre) ){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_errorMotif);
            ApexPages.addMessage(msg);
            return null;
        }
        // seuil contractuel
        if(CRR.Statut__c==Label.VAVAP_statutTermine && (CRR.Seuil_contractuel__c==0)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_seuilContractuel);
            ApexPages.addMessage(msg);
            return null;
        }
        
        listReponsesToUpdate = new List<Reponse_CR__c>();
        system.debug('@@@ ' + theAccount);
        CRR.Numero_de_point_relais__c = theAccount.Reference_internationale__c;
        Savepoint sp = Database.setSavepoint();
        // Filling the CRR fields for the first time (will be automatically filled in case of update)
        if(newCRR){
            CRR.Compte_rendu__c = listWrapperQuestions[0].CompteRendu;  
            /*CRR.Hauteur__c = theAccount.Hauteur_cm__c;
            CRR.Seuil_calcule__c = theAccount.Seuil_calcule__c;
            CRR.Largeur__c = theAccount.Largeur_cm__c;
            CRR.Nombre_d_etageres__c = theAccount.Nombre_detageres__c;
            CRR.Profondeur__c = theAccount.Profondeur_cm__c;
            CRR.Seuil_contractuel__c = theAccount.Seuil_contractuel__c;*/
            //CRR.Hauteur_initiale__c = CRR.Hauteur__c;
            //CRR.Largeur_initiale__c= CRR.Largeur__c;
            //CRR.Nombre_d_etageres_initial__c =  CRR.Nombre_d_etageres__c;
            //CRR.Profondeur_initiale__c =  CRR.Profondeur__c ;
            //CRR.Seuil_contractuel_initial__c = CRR.Seuil_contractuel__c;  
        }   
        if(isVA &&(CRR.Hauteur__c<0 ||  CRR.Largeur__c<0 ||  CRR.Nombre_d_etageres__c <0 ||  CRR.Profondeur__c <0 || CRR.Seuil_contractuel__c <0)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_valeurNegatif);
            ApexPages.addMessage(msg);
            return null;
        }
        // Seuil Calcule
        Decimal sContra = CRR.Seuil_contractuel__c;
        if(CRR.Hauteur__c!=null && CRR.Largeur__c!=null && CRR.Profondeur__c!=null ){
            Decimal sCalcu = ((((CRR.Hauteur__c* CRR.Largeur__c* CRR.Profondeur__c) / 1000) / 21) / 3);
            System.debug('@VFC14_DemarrageCompteRenduRempli | sCalcu : ' + sCalcu);
            System.debug('@VFC14_DemarrageCompteRenduRempli | sContra : ' + sContra);
            if(isVA &&(sContra> sCalcu)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, Label.VAVAP_seuilCalcule);
                ApexPages.addMessage(msg);
                return null;
            }
            CRR.Seuil_calcule__c = Math.round(sCalcu);
        }
        
        CRR.Contact_operationnel__c = theAccount.Contact_operationnel_1__c;
        CRR.Email_du_contact_operationnel__c = theAccount.Contact_operationnel_1__r.Email;
        CRR.Tel_fixe_du_contact_operationnel__c = theAccount.Contact_operationnel_1__r.Phone;
        CRR.Tel_portable_du_contact_operationnel__c = theAccount.Contact_operationnel_1__r.MobilePhone;
        
        CRR.Responsable_facturation__c = theAccount.Responsable_facturation__c;
        CRR.Email_du_responsable_facturation__c = theAccount.Responsable_facturation__r.Email;
        CRR.Tel_fixe_du_responsable_facturation__c = theAccount.Responsable_facturation__r.Phone;
        CRR.Tel_portable_du_responsable_facturation__c = theAccount.Responsable_facturation__r.MobilePhone;
        
        CRR.Responsable_magasin__c = theAccount.Nom_Responsable_magasin__c;
        CRR.Email_du_responsable_magasin__c = theAccount.Nom_Responsable_magasin__r.Email;
        CRR.Tel_fixe_du_responsable_magasin__c = theAccount.Nom_Responsable_magasin__r.Phone;
        CRR.Tel_portable_du_responsable_magasin__c = theAccount.Nom_Responsable_magasin__r.MobilePhone;
        
        if(CRR.Contact__c != null && otherContact != null) {
            CRR.Prenom_CR__c = otherContact.FirstName;
            CRR.Nom_CR__c = otherContact.LastName;
            CRR.Email_CR__c = otherContact.Email;
            CRR.Telephone_fixe_CR__c = otherContact.Phone;
            CRR.Telephone_portable_CR__c = otherContact.MobilePhone;
        }
        // Inserting New CRR
        if(CRR.id == null){           
            listReponses = new List<Reponse_CR__c>();
            selectedRT = selectedRT.substring(0, selectedRT.length() -3);
            //CRR.RecordTypeId = mapCR_CRR.get(selectedRT);
            try {
                insert CRR;
            } catch(DmlException e) {
                System.debug('e.getMessage() : ' + e.getMessage());
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error ,'The following exception has occurred: ' + e.getMessage());
                ApexPages.addMessage(msg);
                Database.rollback(sp);
            }
            for(wrapperQuestion wq : listWrapperQuestions){
                Reponse_CR__c rp = new Reponse_CR__c();
                rp.Compte_rendu_rempli__c = CRR.Id;
                rp.Question__c = wq.question;
                rp.Reponse__c = wq.reponse;
                rp.Type_de_r_ponse__c = wq.type;
                rp.Obligatoire__c = wq.obligatoire;
                rp.Facultatif__c = wq.facultatif;
                rp.Questions_CR__c = wq.id;
                rp.Follow_up__c = wq.followUp; 
                rp.Reponse_FollowUp__c = wq.reponseFollowUp; 	
                rp.Numero_Question_Parent__c = wq.questionParent ; 	
                rp.Changement_macro_profil__c  = wq.changementMacroProfil;	
                listReponses.add(rp);
            }
            try {
                insert listReponses;
            } catch(DmlException e) {
                System.debug('e.getMessage() : ' + e.getMessage());
                ApexPages.Message msg = new ApexPages.Message( ApexPages.Severity.Error, 'The following exception has occurred: ' + e.getMessage());
                ApexPages.addMessage(msg);
                Database.rollback(sp);
                
            }
        } 
        // Edit old CRR
        else{
            update CRR;
            //each account and its contacts
            
            for(wrapperQuestion wq : listWrapperQuestions) {
                Reponse_CR__c rp = oldReponsesMap.get(wq.id);
                rp.Reponse__c = wq.reponse;
                listReponsesToUpdate.add(rp) ;
            }
            try {
                update listReponsesToUpdate;
            } catch(DmlException e) {
                System.debug('e.getMessage() : ' + e.getMessage());
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error ,'The following exception has occurred: ' + e.getMessage());
                ApexPages.addMessage(msg);
                Database.rollback(sp);
                
            }
        }
        //PageReference nextPage = new PageReference('/' + theAccount.Id);
        PageReference nextPage = new PageReference('/' + CRR.Id);
        return nextPage;
        
        
    }
    // 
    List<SelectOption> parseReponseOptions(String reponse, String typeDeReponse){
        if(reponse != null){
            List<String> tmpOptions = reponse.split(';');
            List<SelectOption> tmpSelectOption = new List<SelectOption>();
            if(tmpOptions.size() > 0){
                if(typeDeReponse ==Label.VAVAP_choix) {
                    tmpSelectOption.add(new SelectOption('', Label.VAVAP_Aucun)); 
                }
                for(String option : tmpOptions){
                    tmpSelectOption.add(new SelectOption(option.trim(), option.trim()));
                }
                return tmpSelectOption;
            }
        }
        return null;
    }
    public List <String> handleMultiPicklist(String reponse){
        if(reponse != null){
            List<String> tmpReponses = reponse.split(';'); 
            List<String> tmpSelectOption = new List<String>();
            if(tmpReponses.size() > 0){
                for(String rep : tmpReponses){
                    tmpSelectOption.add(rep.trim());
                }
                return tmpSelectOption;
            }
        }
        return null;
    }
    public String multiToString(List<String> reponsesMulti){
        String myReponse ='';
        for(String rep:reponsesMulti){
            myReponse += rep + ';';
        }
        myReponse = myReponse.substring(0, myReponse.length()-1);
        return myReponse;
    }
    public PageReference closePage(){
        PageReference nextPage = new PageReference('/' + theAccount.Id);
        return nextPage;
    }
    
    //wrapper class for question to display on the VF page
    public class wrapperQuestion {
        public string id {get; set;}
        public string CompteRendu {get; set;}
        public string numero {get; set;}
        public string question {get; set;}
        public string type {get; set;}
        public List<SelectOption> repsuggere {get; set;}
        public string reponse {get; set;}
        public List<string> multiReponse {get; set;}
        public Boolean changementMacroProfil {get; set;}	
        public string questionParent {get; set;}	
        public String reponseFollowUp {get; set;}
        public Boolean followUp {get; set;}	
        public Boolean obligatoire {get; set;}	
        public Boolean showMPName {get; set;}
        public Boolean facultatif {get; set;}
        public Decimal OrdreDAffichage {get; set;}
    }
}