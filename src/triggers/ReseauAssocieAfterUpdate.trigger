trigger ReseauAssocieAfterUpdate on Reseau_Associe__c (after update) {
    if(PAD.canTrigger('AP03_ReseauAssocie')){
        AP03_ReseauAssocie.calculateReseauSeuil(Trigger.newMap,Trigger.oldMap);
    }
}