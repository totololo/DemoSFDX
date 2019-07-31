trigger MacroprofilServiceBeforeInsert on Macroprofil_Service__c (before insert) {
    for(Macroprofil_Service__c neww : trigger.new){
 		neww.Techatraiter__c = true;       
    }
}