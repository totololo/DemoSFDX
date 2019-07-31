trigger ServiceBeforeInsert on Service__c (before insert) {
    for(Service__c serviceRecord :trigger.new){
        //ticket 131288
        serviceRecord.Tech_Operateur__c = serviceRecord.Operateur__c;
    }
}