@isTest
public class AP02_Account_TEST {
    
    static testMethod void testCheckRecordTypeAssignment()
    {
       	// retrieve ID of belgium
         List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_Conge__c,ID_CONGE__c
                                                                              FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
           associationRTPays.put(associationRT.MasterLabel, associationRT);  
        }
        //Create Custom Settings country sequence
        CountriesSequence__c cs = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE0001');
        try{
            insert cs;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        try{
            insert testContact;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        //Create Account France
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account1');
        account1.RecordTypeId = associationRTPays.get('France').ID_Prospect_Converti__c;
        account1.ShippingCountry ='France';
        account1.ShippingCountrycode ='FR';
        account1.Etat__c = '0';
        insert account1;
        account1.ShippingCountry ='Belgium';
        account1.ShippingCountryCode='BE';
        account1.Etat__c = '0';
        //Create Account BNL
        Account account2= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account1');
        account2.RecordTypeId = associationRTPays.get('Belgium').ID_Prospect_Converti__c;
        account2.ShippingCountry ='Belgium';
        account2.ShippingCountryCode='BE';
        account2.BillingCountry ='Belgium';
        account2.BillingCountryCode='BE';
        account2.Etat__c = '0';
        account2.Operateur_Global__c = 'DPD_BNL';
        account2.ShippingPostalCode = '1234';
        account2.BillingPostalCode = '1234';
        insert account2;
        //Create Account France and enter error
        Account account3= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account1');
        account3.RecordTypeId = associationRTPays.get('Belgium').ID_Prospect_Converti__c;
        account3.ShippingCountry ='Belgium';
        account3.ShippingCountryCode='BE';
        account3.Etat__c = '0';
        //Create Account BNL
        Account account4= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account1');
        account4.RecordTypeId =associationRTPays.get('France').ID_Prospect_Converti__c;
        account4.ShippingCountry ='France';
        account4.ShippingCountryCode ='FR';
        account4.Activite_commerciale_principale__c = null;
        account4.BillingCountry ='France';
        account4.BillingCountryCode ='FR';
        account4.BillingPostalCode ='12345';
        account4.Etat__c = '0';
    }
    
    static testMethod void testCreateConfigurationandCasierSite() {
        
        //Create Custom Settings country sequence
        CountriesSequence__c cs = new CountriesSequence__c(Name='France' , Sequence__c = 'FR0001');
        try{
            insert cs;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        try{
            insert testContact;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        
        Macroprofil__c testMacro= Utils_TestMethods.CreateMacroprofil('Test Macroprofil');
        try{
            insert testMacro;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        COnfiguration__c testConfig = Utils_TestMethods.createConfiguration('Config 1');
        try{
            insert testConfig;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        Type_de_casier__c testTypeDeCase = Utils_TestMethods.createTypeCasierKEBA('Test Type De Casier');
        try{
            insert testTypeDeCase;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        Configuration_Locker_Type__c testConfigurationLockerType = Utils_TestMethods.createConfigurationLockerType(testConfig.id, testTypeDeCase.id);
        try{
            insert testConfigurationLockerType;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        //Create Account
        List<Account> accountsToAdd = new List<Account>();
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account');
        account1.RecordTypeId = Label.PUS_RT_Consigne;
        account1.Recopie_Configuration__c = true;
        account1.Etat__c = '2';
        account1.ShippingPostalCode = '12345';
        account1.Nom_commercial_2__c = 'test nom commercial'; 
        account1.Date_d_installation__c = date.ValueOf('2017-12-13');
        accountsToAdd.add(account1);
        insert accountsToAdd;
        account1.Recopie_Configuration__c = true;
        account1.Configuration__c = testConfig.id;
        
        update account1;
        
        Account acc = [Select configuration_site__r.name
                       From Account
                       Where id = :accountsToAdd.get(0).id];
        system.assertEquals(acc.configuration_site__r.name, testConfig.Name);
        account1.Recopie_Configuration__c = true;
        account1.Configuration__c  = testConfig.id;
        try{
            update account1;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        account1.Recopie_Configuration__c = false;
        account1.Configuration_site__c  = null;
        try{
            update account1;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        acc = [Select configuration_site__r.name
               From Account
               Where id = :accountsToAdd.get(0).id];
        
    }
    
    static testMethod void testRecordTypeAssignment(){
        
                
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_Conge__c,ID_CONGE__c
                                                                              FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
           associationRTPays.put(associationRT.MasterLabel, associationRT);  
        }
        
        //Create Custom Settings country sequence
        CountriesSequence__c cs = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE0001');
        try{
            insert cs;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        try{
            insert testContact;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        /*List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];*/
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account');
        account1.recordTypeID = associationRTPays.get('Belgium').ID_Prospect_Converti__c;
        account1.Etat__c = '0';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        insert account1;
        system.debug('account1.recordTypeID '+account1.recordTypeID); 
        
        account1.Etat__c = '1';
        try{
            update account1;
            account1 = [Select recordTypeID
                        From Account
                        Where Id =: account1.Id];
            system.assertEquals(associationRTPays.get('Belgium').ID_Prospect_A_Valider__c, account1.RecordTypeId); 
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        account1.Etat__c = '2';
        account1.Nom_commercial_2__c='test';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCity='Belgium';
        account1.ShippingCountry='Belgium';
        account1.ShippingCountryCode='BE';
        account1.ShippingStreet='abc'; 
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Date_d_installation__c = date.ValueOf('2017-12-13');
        try{
            update account1;
            account1 = [Select recordTypeID
                        From Account       
                        Where Id =: account1.Id];
            system.assertEquals(associationRTPays.get('Belgium').ID_suivi_CO__c, account1.RecordTypeId);
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
    }
}