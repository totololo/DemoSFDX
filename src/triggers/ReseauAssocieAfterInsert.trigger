trigger ReseauAssocieAfterInsert on Reseau_Associe__c (after insert) {
    if(PAD.canTrigger('AP03_ReseauAssocie')){
        AP03_ReseauAssocie.calculateReseauSeuil(Trigger.newMap,null);
    }
}