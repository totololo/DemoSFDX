trigger AlertTrigger on Alert__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if(PAD.canTrigger('AlertTriggerHandler')){
        if(Trigger.isBefore && Trigger.isInsert) {
            AlertTriggerHandler.handleBeforeInsert(Trigger.new); 
            
        } 
        if(Trigger.isAfter && Trigger.isInsert) {
            AlertTriggerHandler.handleAfterInsert(Trigger.new);
        }
        if(Trigger.isAfter && Trigger.isUpdate) {
            AlertTriggerHandler.handleAfterUpdate(Trigger.new);
        }
    }
}