trigger LeadBeforeUpdate on Lead (before update) {
    system.debug('LeadBeforeUpdate '+ Trigger.new);
    for(Lead leadRecord : Trigger.new){ 
        //ON LEAD UPDATE
        leadRecord.Country = leadRecord.Country__c;
        leadRecord.CountryCode = leadRecord.Tech_CountryCode__c;
        // Si la création du lead se déclenche par le flux en premier
        if(Trigger.oldMap.get(leadRecord.id).street != leadRecord.street ){leadRecord.Street__c = leadRecord.street;}
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else{leadRecord.street = leadRecord.Street__c;}
        
        // Si la création du lead se déclenche par le flux en premier
        if(Trigger.oldMap.get(leadRecord.id).postalcode != leadRecord.postalcode ){leadRecord.Postal_Code__c = leadRecord.postalcode;}
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else{leadRecord.postalcode = leadRecord.Postal_Code__c;}
        
		// Si la création du lead se déclenche par le flux en premier
        if(Trigger.oldMap.get(leadRecord.id).city != leadRecord.city ){leadRecord.City__c = leadRecord.city;}
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else{leadRecord.city = leadRecord.City__c;}
        
        // Si la création du lead se déclenche par le flux en premier

        if(Trigger.oldMap.get(leadRecord.id).state != leadRecord.state ){leadRecord.State_Province__c = leadRecord.state; }
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else { leadRecord.state = leadRecord.State_Province__c; }
    }
    if(PAD.canTrigger('AP12_Lead'))
    {
        AP12_Lead.VRShippingCountryRT(Trigger.new, Trigger.oldMap);
    }
}