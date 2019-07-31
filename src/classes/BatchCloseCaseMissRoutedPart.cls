/*
* Author: Gildas ADOUKONOU
* Modified By: -
* Date : 04/03/2019
* Test classe: BatchCloseCaseMissRoutedPart _Test
*/
global class BatchCloseCaseMissRoutedPart implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query ='select id,recordtypeId,Age_de_la_requete__c, status,Sous_motif_1__c, Sens_du_contact__c from Case Where  Sous_motif_1__c=\'Dévoyés partiels cause relais\' AND Sens_du_contact__c=\'Sortant\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC , List<Case> scope) {
        list<Case> listCaseToClose= new list<Case>();
        Id CaseRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Case' and developerName='TM_FR'].Id;
        For(Case  caseRecord : scope){
            if(caseRecord.recordtypeId==CaseRecordTypeId ){
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
        System.debug('Batch executed');
    }
}