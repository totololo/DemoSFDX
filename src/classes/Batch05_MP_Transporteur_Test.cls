@isTest
public class Batch05_MP_Transporteur_Test {
    
    
    static testMethod void testBatch() {
        // create Macroprofil
        Macroprofil__c mp1 = Utils_TestMethods.CreateMacroprofil('MP1');
        insert mp1;   
        
        // Create transporteur
        Transporteur__c trans1 = Utils_TestMethods.CreateTransporteur('Transporteur1');
        insert trans1;
        
        // Create MP-Transporteur
        Macroprofil_Transporteur__c mptrans = Utils_TestMethods.CreateMacroprofilTransporteur(mp1, trans1);
        mptrans.Techatraiter__c = true;
        insert mptrans;
        
        // create contact
        Contact contact = Utils_TestMethods.CreateContact('Contact 1');
        insert contact;
        
        // Create Account
        Account acc = Utils_TestMethods.CreateAccount(contact, mp1, 'Account 1');
        acc.Macroprofil_de_reference__c = mp1.Id;
        insert acc;
        
        Test.startTest();
		Id batchJobId = Database.executeBatch(new Batch05_MP_Transporteur(), 200);         
        Test.stopTest();
    }
}