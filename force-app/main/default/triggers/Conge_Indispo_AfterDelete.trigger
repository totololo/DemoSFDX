trigger Conge_Indispo_AfterDelete on Conge_Indispo__c (after delete) { 
    if(PAD.canTrigger('AP10_Account')) {
        // Call AP10_Account class wich iterate through all account's Conge/Indispo and update its Disponibility Tech fields
        AP10_Account.updateAccountCongeIndispoInformationFromTrigger(System.Trigger.old); 
    } 	
}