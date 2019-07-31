trigger AnomalieAfterUpdate on Anomalie__c (after update) {
    System.debug('@Telecollecte AnomalieAfterUpdate Trigger.new.size(): ' + Trigger.new.size());
    if(PAD.canTrigger('AP01_AnomaliesPB')){
        List<Anomalie__c> LAnomaliesToTreat = new List<Anomalie__c>();
        for(Anomalie__c a : Trigger.New){
            if(a.Type__c != Trigger.OldMap.get(a.Id).Type__c || a.Statut__c != Trigger.OldMap.get(a.Id).Statut__c){
                LAnomaliesToTreat.add(a);
            }
        }
        if(LAnomaliesToTreat.size()>0) AP01_AnomaliesPB.ANOM_PB_01_Telecollecte(LAnomaliesToTreat);
    }
    if(PAD.canTrigger('AP02_Anomalie')){
        AP02_Anomalie.anomMoyensScan(Trigger.New, Trigger.oldmap);
    }
}