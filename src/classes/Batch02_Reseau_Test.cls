@isTest
public class Batch02_Reseau_Test {
	
    
   static testMethod void testBatch() {
       
       // insert Macroprofil
       Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('MP 001');
       insert mp;
        
       // create reseau 
       Reseau__c reseau = Utils_TestMethods.CreateReseau('RES 001');
       reseau.Techatraiter__c = true;
       insert reseau;
        
       // create reseau par defaut
       Macroprofil_Reseau__c mpRes = Utils_TestMethods.CreateMacroprofilReseau(mp.Id, reseau.Id);
       insert mpRes;
       
       
       // create Account and assign it to the created MP
       Account pudo = Utils_TestMethods.CreateAccount(null, mp, 'PUDO 1');
       pudo.Macroprofil_de_reference__c = mp.Id;
       insert pudo;
       
       Test.startTest();
       Id batchJobId = Database.executeBatch(new Batch02_Reseau(), 200);
       Test.stopTest();
   }
   
    
    
}