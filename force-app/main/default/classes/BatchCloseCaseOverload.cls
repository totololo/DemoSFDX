/*
* Author: Gildas ADOUKONOU
* Modified By: - 
* Date : 16/03/2019
* Test classe: BatchCloseCaseOverload_Test
*/
global class BatchCloseCaseOverload implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query ='Select id,Age_de_la_requete__c,recordtypeId, status, Sous_motif_1__c,Sens_du_contact__c from Case Where status=\'0\' AND Sous_motif_1__c=\'Surcharge\' AND Sens_du_contact__c=\'Sortant\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC , List<Case> scope) {
        Id CaseRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Case' and developerName='TM_FR'].Id;
        list<Case> listCaseToClose= new list<Case>();
        For(Case  caseRecord : scope){
            if(caseRecord.Age_de_la_requete__c>=6 && caseRecord.recordtypeId==CaseRecordTypeId ){
                caseRecord.Status = 'Terminée';
                caseRecord.Traite__c='Non';
                listCaseToClose.add(caseRecord);
            }
            
        }
        if(listCaseToClose.size() > 0) {
            Database.SaveResult[] srList = Database.update(listCaseToClose,false);
        }
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Batch executed ');
    }
}