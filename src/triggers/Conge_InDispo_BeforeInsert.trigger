trigger Conge_InDispo_BeforeInsert on Conge_Indispo__c (before insert) {
    
    AP01_Conge_Indispo ap01BeforeInsert = new AP01_Conge_Indispo();
    
    System.debug('#####DEBUG Conge_InDispo_BeforeInsert : trigger.new : ' + Trigger.new);
    if(PAD.canTrigger('AP01_Conge_Indispo')){
	    if(Trigger.isBefore && Trigger.isInsert){
	        ap01BeforeInsert.chevauchementDates(Trigger.new); 
	    }
    }
    
}