trigger ServiceAssocieBeforeUpdate on Service_Associe__c (before update) {
    if(PAD.canTrigger('Utils_PUS')){
        Utils_PUS.checksObjectNonModifiable(trigger.new, trigger.oldMap, Label.SERA_ErrorNonModifiable);
    }    
}