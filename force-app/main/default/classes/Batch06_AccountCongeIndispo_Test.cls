@isTest
public class Batch06_AccountCongeIndispo_Test {
    
    private static Id congeRTypeId = Label.CongeRT_15;
    private static Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    private static Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    private static Id dispoRTypeId = Label.DispoRT_15;
    
    static testmethod void testBatch() {
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassWorkflow__c, BypassApex__c, BypassValidationRule__c
                           from User
                           where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = true;
        currentUser.BypassWorkflow__c = true;
        currentUser.BypassValidationRule__c = true;
        currentUser.BypassApex__c = 'AP02_Conge_Indispo;AP06_Conge_Indispo';
        update currentUser;
       
        // Create Contact 
        Contact contact = Utils_TestMethods.CreateContact('contact');
        insert contact;
        
        // Create Macroprofil
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('mp');
        insert mp;
        
        // Create Account 
        Account account = Utils_TestMethods.CreateAccount(contact, mp,'Account');
        insert account;
        
        // Create Conge en cours
        Conge_Indispo__c conge1 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, account.Id, Date.today() , Date.today().addDays(10));
        insert conge1;
        
        // Create Conge a venir before the old one
        Conge_Indispo__c conge5 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, account.Id, Date.today().addDays(17) , Date.today().addDays(17));
        insert conge5;
        

        // Create Account 2 with no conges
        Account account2 = Utils_TestMethods.CreateAccount(contact, mp, 'Account 2');
        account2.Tech_date_debut_conge_en_cours__c = Date.Today();
        account2.Tech_date_debut_indisp_en_cours__c  = Date.today();
        account2.Tech_date_debut_conge_a_venir__c = Date.today().addDays(10);
        account2.Tech_date_debut_disp_a_venir__c = Date.today().addDays(11);
        insert account2;
      
        
        // Create Account3 with conge that became passé
        Account account3 = Utils_TestMethods.CreateAccount(contact, mp, 'Account 3');
        account3.Tech_date_debut_conge_en_cours__c = Date.Today();
        account3.Tech_date_debut_indisp_en_cours__c  = Date.today();
        account3.Tech_date_debut_conge_a_venir__c = Date.today().addDays(10);
        account3.Tech_date_debut_disp_a_venir__c = Date.today().addDays(11);
        insert account3;
        
       	Conge_Indispo__c conge6 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, account3.Id, Date.today() , Date.today().addDays(10));
        insert conge6;
     
      
         Test.startTest();
        Batch06_AccountCongeIndispo batchAccount = new Batch06_AccountCongeIndispo();
        Database.executeBatch(batchAccount,50); 
        Test.stopTest();
        
    }
}