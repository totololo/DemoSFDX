public class LC02_ConsignerUnAppel_Controller {
    @auraEnabled
    public static String getCaseStatus (String caseId){
        system.debug('caseId'+ caseId);
        Case queryCase = [select id, caseNumber,  toLabel(status)
                          from case
                          where id =: caseId];
        
        String retVal = queryCase.status;
        system.debug('retVal '+retVal);
        return retVal;
    }
    @auraEnabled
    public static string consignerUnappelController (string SelectedRadioBoxValue, String CaseIDRetrieved )
    {
        Case currentRequest = [select id, Object_de_la_requete__c, Subject, Status, Point_relais_ne_repond_pas__c, Operateur__c, ContactId, AccountId,Date_de_rappel_planifiee__c,Tech_Is_Manual_Modif__c
                               from Case 
                               where id =: CaseIDRetrieved];

        system.debug('SelectedRadioBoxValue'+ SelectedRadioBoxValue);
        system.debug('Label.DA_OuiRelaisRepond'+ Label.DA_OuiRelaisRepond);
        string objet = '';
        
        if(currentRequest.Object_de_la_requete__c == null || currentRequest.Object_de_la_requete__c == ''){
            objet = currentRequest.Subject; 
             system.debug('christine enter 1');
            
        }
        else{
             system.debug('christine enter objet '+objet);
             objet = currentRequest.Object_de_la_requete__c; 
            }
        
         system.debug('christine enter objet '+objet);
        if(SelectedRadioBoxValue == Label.DA_OuiRelaisRepond)
        {
            createTask(CaseIDRetrieved, currentRequest.ContactId, objet +' - '+ Label.CA_contactEffLb, Label.DA_Tache_StatutTraite, null); //change to label
            //currentRequest.Sous_statut__c = '';
            //update currentRequest;
            return 'repond';
        }
        //si le relais ne repond pas
        else if(SelectedRadioBoxValue == Label.DA_NonRelaisRepond) {
            createTask(CaseIDRetrieved, currentRequest.ContactId, objet +' - '+ Label.CA_NRPLb, Label.DA_Tache_StatutTraite, null); //change to label
            //currentRequest.Sous_statut__c = 'NRP';
            currentRequest.Point_relais_ne_repond_pas__c = true;
            update currentRequest;
            return 'ne repond pas';
        }
        
        else if (SelectedRadioBoxValue == Label.DA_InterrompuLbl){
            createTask(CaseIDRetrieved, currentRequest.ContactId, objet +' - '+ Label.DA_InterrompuLbl, Label.DA_Tache_StatutTraite, null); //change to label
            //currentRequest.Sous_statut__c = 'Traitement interrompu';
            currentRequest.Traitement_interrompu__c  = true;
            update currentRequest;
            return 'interrompu';
        }
        return 'Task Created';
    }
    
    public static void createTask(string whatId, string whoId, string subject, string status, date datePlannifiable){
        Task tacheToInsert = new Task();
        tacheToInsert.WhatId = whatId;
        tacheToInsert.WhoId = whoId;
        tacheToInsert.Subject = subject;
        tacheToInsert.status = status;
        tacheToInsert.ActivityDate = date.today();
        tacheToInsert.OwnerId = UserInfo.getUserId();
        system.debug(tacheToInsert);
        insert tacheToInsert;
    }
    
}