trigger MacroprofilTransporteurBeforeUpdate on Macroprofil_Transporteur__c (before update) {
	for(Macroprofil_Transporteur__c neww : trigger.new){         
         Macroprofil_Transporteur__c old = trigger.oldMap.get(neww.Id);
         if(old.Active__c != neww.Active__c || old.Modifiable__c != neww.Modifiable__c|| old.Exclut__c != neww.Exclut__c || old.Interdit__c != neww.Interdit__c) //TODO :add the other fields
         {
            neww.Techatraiter__c = true;
         }
    }
}