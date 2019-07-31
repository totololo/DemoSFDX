@isTest
public class Batch03_Reseau_Test {
    
    static testMethod void testBatch() {
        
        // create Macroprofil
        Macroprofil__c mp1 = Utils_TestMethods.CreateMacroprofil('MP1');
        insert mp1;
        
        // create service
        Service__c ser1 = Utils_TestMethods.CreateService('ser1');
        insert ser1;
        
        // create Transporteur
        Transporteur__c trans1 = Utils_TestMethods.CreateTransporteur('trans1');
        insert trans1;
        
        // create Reseau
        Reseau__c res1 = Utils_TestMethods.CreateReseau('res1');
        insert res1;
        
        
        // create Reseau-Service
        Reseau_Service__c res1ser1 = Utils_TestMethods.CreateReseauService(res1.Id,ser1.Id );
        insert res1ser1;
        
        // create Reseau-Transporteur
        Reseau_Transporteur__c res1trans1 = Utils_TestMethods.CreateReseauTransporteur(res1.Id	, trans1.Id);
        insert res1trans1;
            
            
        
        // Create Mp-Service
        Macroprofil_Service__c mp1ser1 = Utils_TestMethods.CreateMacroprofilService(mp1, ser1);
        mp1ser1.Techatraiter__c = true;
        insert mp1ser1;
        
        
        // Create Mp-Transporteur
        Macroprofil_Transporteur__c mp1trans1 = Utils_TestMethods.CreateMacroprofilTransporteur(mp1, trans1);
        mp1trans1.Techatraiter__c = true;
        insert mp1trans1;
        
        // Create Mp-Reseau
        Macroprofil_Reseau__c mp1res1 = Utils_TestMethods.CreateMacroprofilReseau(mp1.Id, res1.Id);
        mp1res1.Techatraiter__c = true;
        insert mp1res1;
        
        //create contact
        Contact contact = Utils_TestMethods.CreateContact('Contact 1');
        insert contact;
        
        // Create Account
        Account acc = Utils_TestMethods.CreateAccount(contact, mp1, 'Account 1');
        acc.Macroprofil_de_reference__c = mp1.Id;
        insert acc;
        
        
        Test.startTest();
        Id batchJobId = Database.executeBatch(new Batch03_Reseau(), 200); 
        Test.stopTest();  
    }
    
    
}