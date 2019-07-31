/*
* Author : TMA fek
* Test Class : Batch07_AccountRequete_Test
* Runs to update the field "Nb_de_requete_indispo_pb_synchro_en_cour" in Account
* Fields : List<Case>
* Fields Updated : Nb_de_requete_indispo_pb_synchro_en_cour__c
*/
global class Batch07_AccountRequete implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassValidationRule__c, BypassWorkflow__c
                           from User
                           where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = true;
        currentUser.BypassValidationRule__c = true;
        currentUser.BypassWorkflow__c = true;
        update currentUser;
        
        String query =  'Select Id , Name , Nb_de_requete_indispo_pb_synchro_en_cour__c, ' +
            			'(SELECT Id FROM Cases WHERE RecordType.Name = \'PUS_FR_Indisponibilité PB PDA Synchro\' AND Status <> \'Terminée\') ' +
            		    'From Account';
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC , List<sObject> scope) {
        Account tmpAcc;
        for(sObject acc : scope){
            tmpAcc = (Account) acc;
            tmpAcc.Nb_de_requete_indispo_pb_synchro_en_cour__c = tmpAcc.Cases.size();
        }
        update scope;
    }
    
    
    global void finish(Database.BatchableContext BC){
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassValidationRule__c, BypassWorkflow__c
                           from User
                           where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = false;
        currentUser.BypassValidationRule__c = false;
        currentUser.BypassWorkflow__c = false;
        update currentUser;
        
    }
}