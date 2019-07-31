@isTest
public class VFC08_GenerateLien_Test {
    
    public static testmethod void test_sendCreationMessage() {
        
        // create MP
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('MP1');
        insert mp;
        // create contact
        Contact contact = Utils_TestMethods.CreateContact('Contact Contact');
        insert contact;
        
        Account account = Utils_TestMethods.CreateAccount(contact, mp,'Account1');
        account.Reference_internationale__c = 'FR1234';
        account.ShippingPostalCode = '12345';
        account.ShippingCity       = 'Paris';
        account.ShippingStreet     = '92 BLR\n ligne2\n ligne3';
        account.ShippingCountry    = 'FRANCE';
        account.Type_de_device__c = 'PDA Android';
        account.Reference_internationale__c ='FE1212';
        insert account; 
        account acc = [select id ,Identifiant_android_du_Pudo__c,Nom_Responsable_magasin__r.Email
                       ,Reference_internationale__c
                        from account 
                       where id =: account.id limit 1];
        
        
        // set the current page reference 
        PageReference pageRef = Page.VFP08_GenerateLien_RM;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        Test.startTest();
        WS_GenerateLienAndroid_MockImpl.correctAnswer = false;
        Test.setMock(WebServiceMock.class, new WS_GenerateLienAndroid_MockImpl());
        VFC08_GenerateLien generateLien = new VFC08_GenerateLien(sc); 
        generateLien.sendEmailRM();
        pageRef = Page.VFP08_GenerateLien_CU;
        Test.setCurrentPage(pageRef);
        generateLien.sendEmailCU();
        generateLien.sendEmailTest();
        WS_GenerateLienAndroid_MockImpl.correctAnswer = true;
        generateLien.sendEmailCU();
        generateLien.goToAccountpage();
         
    }
    
}