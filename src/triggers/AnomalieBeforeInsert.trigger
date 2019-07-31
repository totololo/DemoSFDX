trigger AnomalieBeforeInsert on Anomalie__c (before insert) {
    System.debug('@Telecollecte AnomalieBeforeInsert Trigger.new.size(): ' + Trigger.new.size());
    if(PAD.canTrigger('AP03_Anomalie')){
        AP03_Anomalie.extractTypeAndDeviceID(Trigger.New);
    }
    
    
}