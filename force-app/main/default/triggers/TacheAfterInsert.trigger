trigger TacheAfterInsert on Task (after insert) {
    system.debug('Entered trigger TacheAfterInsert ');
    if(PAD.canTrigger('AP02_Task')){
        AP02_Task.showCaseOnLV(Trigger.new, null);
    }
    if(PAD.canTrigger('AP03_Task')){
        AP03_Task.CheckCRREmailSent(trigger.new);
    }
}