trigger MacroprofilReseauBeforeUpdate on Macroprofil_Reseau__c (before update) {
    for(Macroprofil_Reseau__c neww : trigger.new){         
        Macroprofil_Reseau__c old = trigger.oldMap.get(neww.Id);
        if(old.Active__c != neww.Active__c || old.Modifiable__c != neww.Modifiable__c) //TODO :add the other fields
        {
            neww.Techatraiter__c = true;
        }
    }
}