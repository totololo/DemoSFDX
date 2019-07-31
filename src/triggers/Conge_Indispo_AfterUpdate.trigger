trigger Conge_Indispo_AfterUpdate on Conge_Indispo__c (after update) {   
    
    AP04_Conge_Indispo ap04AfterUpdate = new AP04_Conge_Indispo();
    
    if(Trigger.isAfter && Trigger.isUpdate){
        ap04AfterUpdate.insertInjoignabilite(Trigger.new, Trigger.oldMap);
    }
    
    if(PAD.canTrigger('AP10_Account')) {
        // Call AP10_Account class wich iterate through all account's Conge/Indispo and update its Disponibility Tech fields
        AP10_Account.updateAccountCongeIndispoInformationFromTrigger(Trigger.New); 
    }
    
    if(PAD.canTrigger('AP08_Conge_Indispo')) {
        // Call AP08_Conge_Indispo class wich update case status to "terminee" if conge/indispo between july-august
        AP08_Conge_Indispo.UpdateCase(Trigger.New,Trigger.oldMap); 
    }
}