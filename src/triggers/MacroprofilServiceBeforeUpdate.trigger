trigger MacroprofilServiceBeforeUpdate on Macroprofil_Service__c (before update) {
	for(Macroprofil_Service__c neww : trigger.new){         
         Macroprofil_Service__c old = trigger.oldMap.get(neww.Id);
         if(old.Active__c != neww.Active__c || old.Modifiable__c != neww.Modifiable__c|| old.Exclu__c != neww.Exclu__c || old.Interdit__c != neww.Interdit__c) //TODO :add the other fields
         {
            neww.Techatraiter__c = true;
         }
     }
}