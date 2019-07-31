@isTest
public class VFC04_PudoDevicesSynchro_Test {
	
    static testMethod void test_syncDevices() {
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassValidationRule__c, BypassApex__c
                              from User
                             where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = true;
        currentUser.BypassValidationRule__c = true;
        update currentUser;
        
        Contact contact   = Utils_TestMethods.CreateContact('Contact');
        insert contact;
        
        // retrieve ID of belgium
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];        
        Account newAccount= Utils_TestMethods.CreateAccount(contact, null, 'Test Account');
        newAccount.RecordTypeId = associationRTPays[0].ID_Prospect_A_Valider__c;
        newAccount.ShippingCountry ='Belgium';
        newAccount.ShippingCountryCode='BE';
        newAccount.Reference_internationale__c = 'BE43033';
        newAccount.Etat__c = '0';
        newAccount.Operateur_Global__c = 'DPD_BNL';
        newAccount.ShippingPostalCode = '1234';
        newAccount.Type ='2';
        newAccount.Tech_Has_Device__c = true;
        insert newAccount;
        newAccount.Etat__c ='8';
        update newAccount;
        
        test.startTest();
        PageReference pageRef = Page.VFP04_PudoDevices; 
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newAccount);
        VFC04_PudoDevicesSynchro pudoDevices = new VFC04_PudoDevicesSynchro(sc); 
        
        Test.setMock(HttpCalloutMock.class, new MockPudoDevicesGenerator());
        pudoDevices.syncDevices();
        pudoDevices.nextPage();
        pudoDevices.lastPage();
        pudoDevices.firstPage();
        pudoDevices.previousPage();
        
        System.assertEquals(1,pudoDevices.listdevicesSort.size());
        
        VFC04_PudoDevicesSynchro.Device device = pudoDevices.listdevicesSort.get(0);
        System.assertEquals('FR43033', device.internationalSiteId);
        System.assertEquals('1234', device.deviceNumber);
        System.assertEquals('2017-02-08T15:22:22.277', device.ConnectedAt);
        System.assertEquals('1.0', device.ApplicationVersion);
        System.assertEquals('chrome', device.Browser);
        System.assertEquals('CT50', device.DeviceBrand);
        System.assertEquals('Mozilla/5.0 (Linux; Android 4.4.4; CT50 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Crosswalk/21.51.546.7 Mobile Safari/537.36', device.userAgent);
        System.assertEquals('3.0.0.63707.0', device.contentVersion);
        System.assertEquals('Android', device.os);
        System.assertEquals('4.4.4', device.OsVersion);
        System.assertEquals('MobileApp', device.deviceType);
        System.assertEquals('test', device.deviceEnvironment);
        
        test.stopTest();
        
    }
}