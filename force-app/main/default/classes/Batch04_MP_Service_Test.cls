@isTest
public class Batch04_MP_Service_Test {
    
    
    static testMethod void testBatch() {
        
        // create Macroprofil
        Macroprofil__c mp1 = Utils_TestMethods.CreateMacroprofil('MP1');
        insert mp1;
        
        // Create Service
        Service__c serv1  = Utils_TestMethods.CreateService('Service1');
        insert serv1;
        
        // Create MP-Service
        Macroprofil_Service__c mp1serv1 = Utils_TestMethods.CreateMacroprofilService(mp1, serv1);
        mp1serv1.Techatraiter__c = true;
        insert mp1serv1;
        
        // create contact
        Contact contact = Utils_TestMethods.CreateContact('Contact 1');
        insert contact;
        
        // Create Account
        Account acc = Utils_TestMethods.CreateAccount(contact, mp1, 'Account 1');
        acc.Macroprofil_de_reference__c = mp1.Id;
        insert acc;
        
        Test.startTest();
        Id batchJobId = Database.executeBatch(new Batch04_MP_Service(), 200); 
        Test.stopTest();
    }
    
}