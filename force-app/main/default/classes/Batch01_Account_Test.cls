@isTest
public class Batch01_Account_Test {
    private static Id congeRTypeId = Label.CongeRT_15;
    private static Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    private static Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    
    static testmethod void testBatch() {
 
        //create conge indispo that meets the query crieterias
        
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('M1');
        insert macroprofil;
        Contact contact = Utils_TestMethods.CreateContact('Contact1');
        insert contact;
        Account account = Utils_TestMethods.CreateAccount(contact, macroprofil, 'Account 1');
        insert account;
        Conge_Indispo__c congeIndispo = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, account.Id , Date.today() , Date.today().addDays(10));
        insert congeIndispo;
        
        Test.startTest();
        Batch01_Account batchAccount = new Batch01_Account();
        Database.executeBatch(batchAccount);
        Test.stopTest();
        
        account = [SELECT Tech_date_debut_conge_en_cours__c
                   FROM Account 
                   Where Id =: account.Id
                  ]; 
        System.assertEquals( account.Tech_date_debut_conge_en_cours__c , Date.today());
        
    }
}