trigger AnomalieAfterInsert on Anomalie__c (after insert) {
    System.debug('@Telecollecte AnomalieAfterInsert Trigger.new.size(): ' + Trigger.new.size());
    if(PAD.canTrigger('AP01_AnomaliesPB')){
        AP01_AnomaliesPB.ANOM_PB_01_Telecollecte(Trigger.New);
    }
    
    if(PAD.canTrigger('AP02_Anomalie')){
        AP02_Anomalie.anomMoyensScan(Trigger.New, null);
    }
}