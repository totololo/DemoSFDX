trigger MacroprofilReseauBeforeInsert on Macroprofil_Reseau__c (before insert) {

    for(Macroprofil_Reseau__c mpr : Trigger.New) {
        mpr.Techatraiter__c = true;
    }
}