trigger ServiceBeforeUpdate on Service__c (before update) {
    for(Service__c serviceRecord :trigger.new){
        //ticket 131288
        serviceRecord.Tech_Operateur__c = serviceRecord.Operateur__c;
    }
}