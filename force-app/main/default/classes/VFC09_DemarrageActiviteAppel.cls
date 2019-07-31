public class VFC09_DemarrageActiviteAppel {
    private static Case currentRequest;    
    @auraEnabled
    public static Case getCaseStatus (String caseId){
        system.debug('caseId '+ caseId);
        Case queryCase = [select id, caseNumber,  toLabel(status), AccountId
                          from case
                          where id =: caseId];
        system.debug('queryCase.Status ' + queryCase.Status);
        /*//select le dernier compte rendu avec un status entre 1 et 6
        List<Historique_des_Comptes_Rendus__c> retrievedHistoriqueCompteRendu = [Select id, Contact_Name__c,Contact_Name__r.name
                                                                                 From Historique_des_Comptes_Rendus__c
                                                                                 Where Cases__c =: caseId];
        system.debug('retrievedHistoriqueCompteRendu.size '+retrievedHistoriqueCompteRendu.size());*/
        //String retVal = queryCase;/* + '_' + retrievedHistoriqueCompteRendu[retrievedHistoriqueCompteRendu.size()-1].Contact_Name__c + '_' + retrievedHistoriqueCompteRendu[retrievedHistoriqueCompteRendu.size()-1].Contact_Name__r.name;
        //*/system.debug('retVal '+retVal);
        return queryCase;
    }
    //cette methode est appelee lorsqu'on clique sur le premier boutton
    @auraEnabled
    public static Historique_des_Comptes_Rendus__c goToNextPage2 (string SelectedRadioBoxValue, String CaseStatus, String CaseIDRetrieved)
    {
        //String caseStatusNumber = CaseStatus.substring(CaseStatus.length() -1);
        String caseStatusNumberForQuery = '%'+ CaseStatus.substring(CaseStatus.length() -1) + '%';
        system.debug('CaseStatus '+CaseStatus);
        system.debug('caseStatusNumberForQuery '+caseStatusNumberForQuery);
        //String caseStatusNumberForQuery1 = '%'+ (Integer.valueOf(CaseStatus.substring(CaseStatus.length() -1)) -1) + '%';
        List <String> arrayOfStatusNumber = new List <String>{'1','2','3','4','5','6'};
            //si le relais ne repond pas
            if(SelectedRadioBoxValue == Label.DA_NonRelaisRepond)
        {
            currentRequest = [select id, Status, Point_relais_ne_repond_pas__c, Operateur__c, ContactId, AccountId,Date_de_rappel_planifiee__c,Tech_Is_Manual_Modif__c
                              from Case 
                              where id =: CaseIDRetrieved];
            //update field for view
            currentRequest.Point_relais_ne_repond_pas__c = true;
            update currentRequest;
            createTask(CaseIDRetrieved, currentRequest.ContactId, Label.DA_Tache_NeRepondPas, Label.DA_Tache_StatutTraite, null);
        }
        //si le relais repond
        else if(SelectedRadioBoxValue == Label.DA_OuiRelaisRepond)
        {
            //select le dernier compte rendu avec un status entre 1 et 6
            List<Historique_des_Comptes_Rendus__c> retrievedHistoriqueCompteRendu = [Select id, Contact_Name__c,Contact_Name__r.name, Compte_rendu__c, name, Date_Du_Rappel__c, Traitement_interrompu__c
                                                                                     From Historique_des_Comptes_Rendus__c
                                                                                     Where Cases__c =: CaseIDRetrieved
                                                                                     AND Name LIKE  :caseStatusNumberForQuery
                                                                                     Limit 1];
            system.debug('retrievedHistoriqueCompteRendu '+retrievedHistoriqueCompteRendu);
            for(String status : arrayOfStatusNumber)
            {
                //si il y a un compte rendu pour la requete
                if(retrievedHistoriqueCompteRendu.size() > 0)
                {
                    retrievedHistoriqueCompteRendu.get(0).Traitement_interrompu__c = false;
                    retrievedHistoriqueCompteRendu.get(0).Date_Du_Rappel__c = null;
                    return retrievedHistoriqueCompteRendu.get(0);
                }
                //creer un nouveau compte rendu
                else{
                    return new Historique_des_Comptes_Rendus__c(cases__c = CaseIDRetrieved, Status__c = CaseStatus);
                }
            }
        }
        return null;
    }
    //cette methode est appelee lorsqu'on clique sur le deuxieme boutton
    @auraEnabled
    public static String insertCompteRendu (Historique_des_Comptes_Rendus__c historiqueObj,  string SelectedRadioBoxValue1, String CaseStatus, String CaseIDRetrieved, String ContactValue, String isContactWrong)
    {
        system.debug('CaseStatus '+CaseStatus);
        
        String caseStatusNumber = CaseStatus.substring(CaseStatus.length() -1);
        system.debug('SelectedRadioBoxValue1 '+SelectedRadioBoxValue1);
        historiqueObj.Resultat_d_appel__c = SelectedRadioBoxValue1;
        historiqueObj.Name = Label.DA_APPEL +' '+ caseStatusNumber;
        historiqueObj.Status__c = CaseStatus;
        historiqueObj.Contact_Name__c = ContactValue;
        currentRequest = [select id, Status, Point_relais_ne_repond_pas__c, Operateur__c,
                          ContactId, AccountId,Date_de_rappel_planifiee__c,Tech_Is_Manual_Modif__c
                          from Case 
                          where id =: CaseIDRetrieved];
        system.debug('currentRequest '+currentRequest);
        system.debug('historiqueObj.Contact_Name__c ' + historiqueObj.Contact_Name__c);
        system.debug('historiqueObj.Traitement_interrompu__c ' + historiqueObj.Traitement_interrompu__c);
        system.debug('isContactWrong ' + isContactWrong);
        if(historiqueObj.Contact_Name__c == null && historiqueObj.Traitement_interrompu__c == true && isContactWrong == '{}')
        {
            system.debug('historiqueObj.Contact_Name__c ' + historiqueObj.Contact_Name__c);
            return 'Fail';
        }
        else
        {
            upsert historiqueObj;
            //si traitement interrompu est cochee
            if(historiqueObj.Traitement_interrompu__c == true)
            {
                //si le champ date du rappel n'est pas vide
                if(historiqueObj.Date_Du_Rappel__c != null){
                    //conversion from DateTime to Date
                    DateTime retrieveddT = historiqueObj.Date_Du_Rappel__c;
                    Date dateInterr = date.newinstance(retrieveddT.year(), retrieveddT.month(), retrieveddT.day());
                    interrompuSave(CaseIDRetrieved, currentRequest, true, dateInterr);
                }
                //si le champ date du rappel est vide
                else{
                    interrompuSave(CaseIDRetrieved, currentRequest, false, null);
                }
            }
            //si traitement interrompu n'est pas cochee
            else{
                List<String> stringNumberList = new List<String>{'1','2','3','4','5','6'};
                    // si En attente appel 1 et passage suivant 
                    if(caseStatusNumber == stringNumberList.get(0) && SelectedRadioBoxValue1 == '3')
                {
                    createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_AttenteAppel1, Label.DA_Tache_StatutTraite, null);
                    currentRequest.Status = '2';//Label.DA_EnAttenteAppel2Statut2;
                    currentRequest.Date_appel_1__c = date.newinstance(system.now().year(),system.now().month(),system.now().day()) ;
                }
                // si En attente appel 2 et passage suivant 
                else if(caseStatusNumber == stringNumberList.get(1) && SelectedRadioBoxValue1 == '3')
                {
                    createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_AttenteAppel2, Label.DA_Tache_StatutTraite, null);
                    currentRequest.Status = '3';//Label.DA_EnAttenteAppel3Statut3;
                    currentRequest.Date_appel_2__c = date.newinstance(system.now().year(),system.now().month(),system.now().day()) ;
                }
                // si En attente appel 3 et passage suivant 
                else if(caseStatusNumber == stringNumberList.get(2) && SelectedRadioBoxValue1 == '3')
                {
                    createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_AttenteAppel3, Label.DA_Tache_StatutTraite, null);
                    currentRequest.Status = '12';//Label.DA_AttenteAppel4;
                    currentRequest.Date_appel_3__c = date.newinstance(system.now().year(),system.now().month(),system.now().day()) ;
                }
                // si En attente appel 4 et passage suivant 
                else if(caseStatusNumber == stringNumberList.get(3) && SelectedRadioBoxValue1 == '3')
                {
                    createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_AttenteAppel4D, Label.DA_Tache_StatutTraite, null);
                    currentRequest.Status = '13';//Label.DA_EnAttenteAppel5Statut5S;
                    currentRequest.Date_appel_4__c = date.newinstance(system.now().year(),system.now().month(),system.now().day()) ;
                    
                }
                // si En attente appel 5 et passage suivant 
                else if(caseStatusNumber == stringNumberList.get(4) && SelectedRadioBoxValue1 == '3')
                {
                    createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_AttenteAppel5, Label.DA_Tache_StatutTraite, null);
                    currentRequest.Status = '14';//Label.DA_AttenteAppel6;
                    currentRequest.Date_appel_5__c = date.newinstance(system.now().year(),system.now().month(),system.now().day()) ;
                }
                else
                {
                    
                    Boolean enteredDemandeExclusion = false;
                    for(integer i = 0 ; i < stringNumberList.size(); i++)
                    {
                        //Demande d'exclusion PUDO
                        if(caseStatusNumber == stringNumberList.get(i) && SelectedRadioBoxValue1 == '4')
                        {
                            createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_BilanExclus, Label.DA_Tache_StatutTraite, null);
                            currentRequest.Status = Label.DA_EnAttenteExclusion;
                            enteredDemandeExclusion = true;
                            break;
                        }
                    }
                    // Fin de suivi du démarrage d'activité
                    if(enteredDemandeExclusion == false)
                    {
                        Account accountToBeUpdated = [Select Mode__c, Etat__c,id
                                                      From Account
                                                      Where ID =: currentRequest.AccountId];
                        createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_BilanValide, Label.DA_Tache_StatutTraite, null);
                        currentRequest.Status = Label.DA_Termine;
                        currentRequest.Date_appel_6__c = date.newinstance(system.now().year(),system.now().month(),system.now().day()) ;
                        accountToBeUpdated.Mode__c = '300';
                        accountToBeUpdated.Etat__c = '5';
                        
                        
                        update accountToBeUpdated;
                    }
                }
                update currentRequest;
            }
            return 'Success';
        }
    }
    //function to create task
    public static void createTask(string whatId, string whoId, string subject, string status, date datePlannifiable){
        Task tacheToInsert = new Task();
        tacheToInsert.WhatId = whatId;
        tacheToInsert.WhoId = whoId;
        tacheToInsert.Subject = subject;
        tacheToInsert.status = status;
        if(datePlannifiable != null){
            tacheToInsert.ActivityDate = date.newinstance(datePlannifiable.year(),datePlannifiable.month(),datePlannifiable.day()) ;
            tacheToInsert.IsReminderSet = true;
            tacheToInsert.ReminderDateTime = datePlannifiable;
        }else{
            tacheToInsert.ActivityDate = date.today();
        }
        tacheToInsert.OwnerId = UserInfo.getUserId();
        insert tacheToInsert;
    }
    // Method to save the questionnaire (as interrompu)
    public static void interrompuSave(String CaseIDRetrieved , Case currentRequest, Boolean SelectedChechBoxValue1, Date SelectedDateValue){
        //call the update and/or creation of the questionnaire rempli and reponse objects
        //send to method status interrompu
        createTask(CaseIDRetrieved,  currentRequest.ContactId, Label.DA_TacheTraitementInterrompu, Label.DA_Tache_StatutTraite, SelectedDateValue);
        //update field for view
        currentRequest.Planifier_un_rappel__c = SelectedChechBoxValue1;
        currentRequest.Date_de_rappel_planifiee__c = SelectedDateValue;
        currentRequest.Traitement_interrompu__c = true;
        currentRequest.Point_relais_ne_repond_pas__c = true;
        update currentRequest;
    }  
}