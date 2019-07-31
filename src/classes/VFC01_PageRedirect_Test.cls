@isTest
public class VFC01_PageRedirect_Test {
    public static  testmethod void redirectToInternationalReference(){
        
        PageReference pageRef = Page.VFP01_SalesForceRedirect;
        Test.setCurrentPage(pageRef);
        
        // Add parameters (ref) to page URL 
        // Invalid reference number
        ApexPages.currentPage().getParameters().put('ref' , 'FR0000');
        
        // Initiate the controller with the pagereference parameters
        VFC01_PageRedirect controller = new VFC01_PageRedirect();
         
        Test.startTest();
        controller.redirect();
        System.assertEquals(System.Label.Invalid_International_Reference + ' : FR0000', controller.strErrorMessage);       
        // Send empty reference number from URL 
        ApexPages.currentPage().getParameters().put('ref' , ''); 
        controller.redirect();
        System.assertEquals(Label.Empty_Reference_Number,controller.strErrorMessage);        
		
        
        // Create account with CN5000 as International Reference
        Contact contact = Utils_TestMethods.CreateContact('Georges');
        insert contact;
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('Macroprofil 1');
        insert macroprofil;
        Account account = Utils_TestMethods.CreateAccount(contact, macroprofil, 'account1 ');
		account.Reference_internationale__c = 'FR00001';
        account.Operateur_Global__c = 'PUS_FR';
        insert account;
        
        // Pass reference number from Visual Force Page 
        controller.vfReferenceInt = 'FR00001';
        controller.redirect();
        System.assertEquals(true,controller.isValidReferenceNumber);        
        Test.stopTest();
    }
}