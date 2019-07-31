trigger TransporteurAssocieBeforeUpdate on Transporteur_Associe__c (before update) {
    if(PAD.canTrigger('Utils_PUS')){
       Utils_PUS.checksObjectNonModifiable(trigger.new, trigger.oldMap, Label.TRAA_ErrorNonModifiable);
    }
}