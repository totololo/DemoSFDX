trigger TacheAfterUpdate on Task (after update) {
    if(PAD.canTrigger('AP02_Task')){
        AP02_Task.showCaseOnLV(Trigger.new, Trigger.oldMap);
    }
}