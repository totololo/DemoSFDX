/*
* Author: Gildas ADOUKONOU
* Modified By: -
* Date : 17/07/2018
* Test classe: BatchUpdateAlert_Test
*/
global class BatchCloseAlert implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<ID> setRT = new Set<ID>();
        //Date EndDate = Date.Today().addDays(-7);
        //Date EndDate = Date.Today().addDays(-2);
        String query ='select id, CreatedDate, Age_Alert__c, status__c, response_overload_capacity_reach__c, response_missguided_part_cause_refuse__c, response_missguided_full_cause_refuse__c,response_missguided_full_cause_closure__c,response_missguided_Part_cause_closure__c from Alert__c ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC , List<Alert__c> scope) {
        list<Alert__c> listAlertToUpdate = new list<Alert__c>();
        For(Alert__c  alertRecord : scope){
            if((alertRecord.Age_Alert__c > 7) ){
                alertRecord.Status__c = '5';
            }
            
            listAlertToUpdate.add(alertRecord);
        }
        if(listAlertToUpdate.size() > 0) {
            Database.SaveResult[] srList = Database.update(listAlertToUpdate,false);
        }
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Batch Alert executed');
    }
}