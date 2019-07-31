trigger LeadBeforeInsert on Lead (before insert) {
    system.debug('LeadBeforeInsert '+ Trigger.new);
    for(Lead leadRecord : Trigger.new){ 
        system.debug('leadRecord.CountryCode '+leadRecord.CountryCode);

        //added by JMB to populate standard Address by custom Address
        //ON LEAD INSERT
        leadRecord.Country = leadRecord.Country__c;
        leadRecord.CountryCode = leadRecord.Tech_CountryCode__c;
        system.debug('JMB leadRecord.street '+leadRecord.street);
        system.debug('JMB leadRecord.City '+leadRecord.City);
        
        system.debug('JMBB leadRecord.Country '+leadRecord.Country);
        system.debug('JMBB leadRecord.CountryCode '+leadRecord.CountryCode);
        system.debug('JMBB leadRecord.Country__c '+leadRecord.Country__c);
        system.debug('JMBB leadRecord.Tech_CountryCode__c '+leadRecord.Tech_CountryCode__c);
        
        system.debug('JMB leadRecord.PostalCode '+leadRecord.PostalCode);

        // Si la création du lead se déclenche par le flux en premier
        if(leadRecord.Street__c == null)
        {
            leadRecord.Street__c = leadRecord.street;
        }
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else{leadRecord.street = leadRecord.Street__c; }
        
        // Si la création du lead se déclenche par le flux en premier
        if(leadRecord.Postal_Code__c == null) {leadRecord.Postal_Code__c = leadRecord.postalcode;}
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else {leadRecord.postalcode = leadRecord.Postal_Code__c;}
        
        // Si la création du lead se déclenche par le flux en premier
        if(leadRecord.City__c == null) {leadRecord.City__c = leadRecord.City;}
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else{leadRecord.City = leadRecord.City__c;}
        
        // Si la création du lead se déclenche par le flux en premier
        if(leadRecord.State_Province__c == null){leadRecord.State_Province__c = leadRecord.state;}
        // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
        else{leadRecord.state = leadRecord.State_Province__c;}
        
        system.debug('JMB leadRecord '+leadRecord);
        
        system.debug('JMB leadRecord.Street__c '+leadRecord.Street__c);
        system.debug('JMB leadRecord.City__c '+leadRecord.City__c);
        system.debug('JMB leadRecord.Country__c '+leadRecord.Country__c);
        system.debug('JMB leadRecord.Postal_Code__c '+leadRecord.Postal_Code__c);
    }
    if(PAD.canTrigger('AP12_Lead'))
    {
        system.debug('entered LeadBeforeInsert AP12_Lead');
        AP12_Lead.VRShippingCountryRT(Trigger.new, null);
    }
}