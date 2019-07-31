trigger Conge_Indispo_AfterInsert on Conge_Indispo__c (after insert) {
    
    AP05_Conge_Indispo ap05AfterInsert = new AP05_Conge_Indispo();
    if(Trigger.isAfter && Trigger.isInsert){
        ap05AfterInsert.insertInjoignabilite(Trigger.new); 
    }
    
    if(PAD.canTrigger('AP10_Account')) {
        // Call AP10_Account class wich iterate through all account's Conge/Indispo and update its Disponibility Tech fields
        AP10_Account.updateAccountCongeIndispoInformationFromTrigger(Trigger.New); 
    }
    
    if(PAD.canTrigger('AP08_Conge_Indispo')) {
        // Call AP08_Conge_Indispo class wich update case status to "terminee" if conge/indispo between july-august
        AP08_Conge_Indispo.UpdateCase(Trigger.New,Null); 
    }
    if(PAD.canTrigger('AP09_Conge_Indispo')) {
        AP09_Conge_Indispo.createCase(Trigger.New); 
    }
}