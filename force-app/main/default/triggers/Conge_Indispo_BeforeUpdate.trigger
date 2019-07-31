trigger Conge_Indispo_BeforeUpdate on Conge_Indispo__c (before update) { 
    
    if(PAD.canTrigger('AP06_Conge_Indispo')) {
        AP06_Conge_Indispo congeIndispoInstance = new AP06_Conge_Indispo();
    	congeIndispoInstance.checkCongeIndispoStatus(Trigger.New , Trigger.OldMap);
    }
    if(PAD.canTrigger('AP02_Conge_Indispo')) {
        AP02_Conge_Indispo ap02BeforeUpdate = new AP02_Conge_Indispo();
        if(Trigger.isBefore && Trigger.isUpdate){
            system.debug('test');
            ap02BeforeUpdate.indispoDateEnCours(Trigger.new, Trigger.oldMap);
            ap02BeforeUpdate.chevauchementDates(Trigger.new, Trigger.oldMap); 
        } 
    }
}