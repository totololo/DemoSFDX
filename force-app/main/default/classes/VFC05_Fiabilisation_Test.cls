@isTest
private class VFC05_Fiabilisation_Test {
	
 
    public static testmethod void test_valideAddress() {
        
        // Create Custom Settings
        Amabis__c settingsOK = new Amabis__c();
        settingsOK.Name = 'OKMO';
        settingsOK.Statut__c = 'Adresse valid'; 
   		insert settingsOK;
        
        Amabis__c settingsAV = new Amabis__c();
        settingsAV.Name = 'AVMW1';
        settingsAV.Statut__c = 'Suggestions'; 
   		insert settingsAV;
        
        // create MP
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('MP1');
        insert mp;
        
        // create contact
        Contact contact = Utils_TestMethods.CreateContact('Contact Contact');
        insert contact;
        
        
        // create account and fill its billing and shipping fields
        Account account = Utils_TestMethods.CreateAccount(contact, mp,'Account1');
        account.ShippingPostalCode = '12345';
        account.ShippingCity       = 'Paris';
        account.ShippingStreet     = '92 BLR\n ligne2\n ligne3';
        account.ShippingCountry    = 'FRANCE';
        account.Long_Lat_adresse_de_livraison__Latitude__s=62;
        account.Long_Lat_adresse_de_livraison__Longitude__s=21;        
        insert account;
        
        
        // set the current page reference 
        PageReference pageRef = Page.VFP05_Fiabilisation;
        pageRef.getParameters().put('addressId','0');
        Test.setCurrentPage(pageRef);

        
        // call the extension and start the test 
        ApexPages.StandardController sc = new ApexPages.StandardController(account);
       
        Test.startTest();
        MockFiabilisationGenerator.correctAnswer = false;
        Test.setMock(WebServiceMock.class, new MockFiabilisationGenerator());
        VFC05_Fiabilisation fiabilisationAccount = new VFC05_Fiabilisation(sc); 
       
        
        fiabilisationAccount.suggestAddresses(); 
        
        fiabilisationAccount.keepOriginalAddress();
        Account modifiedAccount = [select Id , ShippingCity
                                   from account
                                   where id =: account.Id];
        System.assertEquals('Paris',account.ShippingCity);
		
        MockFiabilisationGenerator.correctAnswer = true; 
        Test.setMock(WebServiceMock.class, new MockFiabilisationGenerator());
        
        
        fiabilisationAccount.suggestAddresses();  
        System.assertEquals(1, fiabilisationAccount.listAddresses.size());
        fiabilisationAccount.closeScreen();
        
        fiabilisationAccount.applyForBilling  = true;
        fiabilisationAccount.applyForDelivery = true;
        
        fiabilisationAccount.submitAddresses();     
        
        modifiedAccount = [select Id , Adresse_de_livraison_fiabilisee__c
                           from account
                           where id =: account.Id];
        
        //System.assertEquals(true,modifiedAccount.Adresse_de_livraison_fiabilisee__c);
        test.stopTest();
    }
    
}