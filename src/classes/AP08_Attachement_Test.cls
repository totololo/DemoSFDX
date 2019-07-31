@isTest
public class AP08_Attachement_Test {
    private static Account retrieveAccount(Id accountId) {
        return [SELECT Id, Contrat_Joint__c
                FROM Account
                where Id = : accountId
               ];
    }
    
    /*
     * Coverage for contentDocumentLink Triggers : after insert/update/delete
     * to be modified : to add functions in utils method + add content document with title equals to reference international
     */ 
    static testmethod void testContentDocumentLink() {
        
        ContentVersion testContentInsert = new ContentVersion(); 
        testContentInsert.ContentURL='http://www.google.com';
        testContentInsert.Title ='Google.com'; 
        insert testContentInsert; 
        
        
        //Create MP
        Macroprofil__c mp =  Utils_TestMethods.CreateMacroprofil('MP');
        insert mp;
        //Create Contact
        Contact contact =  Utils_TestMethods.CreateContact('contact');
        insert contact;
        //Create Account
        Account account = Utils_TestMethods.CreateAccount(contact, mp , 'Account');
        account.Reference_internationale__c = 'FR1234';
        insert account;
        
        //Create Content Version
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'FR1234_test';      
        cv.PathOnClient ='test';           
        cv.VersionData = beforeblob;          
        insert cv;         

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        //Create ContentDocumentLink
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId = account.id;
        contentlink.ShareType= 'V'; // Viewer permission
        contentlink.ContentDocumentId= testcontent.ContentDocumentId; 
        insert contentlink;
         
        
        update contentlink;
        
        delete contentlink;
        
    }
    
    
    static testmethod void testAttachement() {
        
        //Create MP
        Macroprofil__c mp =  Utils_TestMethods.CreateMacroprofil('MP');
        insert mp;
        //Create Contact
        Contact contact =  Utils_TestMethods.CreateContact('contact');
        insert contact;
        //Create Account
        Account account = Utils_TestMethods.CreateAccount(contact, mp , 'Account');
        account.Reference_internationale__c = 'FR1234';
        insert account;
        
        //Create Non matching Attachment 
        Attachment attachment1 = Utils_TestMethods.createAttachment(account.Id , 'test body' , 'test');
        insert attachment1; 
        //System.assertEquals(false, retrieveAccount(account.Id).Contrat_Joint__c);
        
        //Create a matching Attachments
        Attachment attachment2 = Utils_TestMethods.createAttachment(account.Id , 'test body' , 'FR1234_Test1');
        insert attachment2;
        //System.assertEquals(true, retrieveAccount(account.Id).Contrat_Joint__c);
        
        //Update the matching Attachment
        attachment2.Name = 'test123';
        update attachment2;
        //System.assertEquals(false, retrieveAccount(account.Id).Contrat_Joint__c);
        
        //reUpdate the matching Attachment
        attachment2.Name = 'FR1234_GGG';
        update attachment2;
       // System.assertEquals(true, retrieveAccount(account.Id).Contrat_Joint__c);
        
        
        //deleting a matching attachment
        delete attachment2;
        //System.assertEquals(false, retrieveAccount(account.Id).Contrat_Joint__c);
        
    }
}