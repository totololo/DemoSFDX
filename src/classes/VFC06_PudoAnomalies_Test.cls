@isTest
public class VFC06_PudoAnomalies_Test {

    static testmethod void getPudoAnomalies_Test() {
      
        Contact contact = Utils_TestMethods.CreateContact('Test Contact');
        insert contact;
         
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('Test Macroprofil');
        insert mp;
         
        Account account = Utils_TestMethods.CreateAccount(contact, mp, 'Test Account');
        account.Reference_internationale__c = 'FR12345';
        insert account;
      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPudoAnomalies());
        ApexPages.StandardController sc = new ApexPages.StandardController(account);
        VFC06_PudoAnomalies accountExt = new VFC06_PudoAnomalies(sc);
        
        PageReference pageRef = Page.VFP06_PudoAnomalies;
        Test.setCurrentPage(pageRef);
        accountExt.getPudoAnomalies();
        Test.stopTest();
    } 
}