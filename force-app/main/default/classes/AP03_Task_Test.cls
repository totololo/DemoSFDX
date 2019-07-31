/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: Test class for AP03_Task
History
2018-06-07  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class AP03_Task_Test {

    @isTest
    public static void testEmailSent(){
        
        Account compte = Utils_TestMethods.CreateAccount(null, null, 'compte');
        insert compte;
        
        Compte_rendu_rempli__c CRR = Utils_TestMethods.createCompteRenduRempli(compte.Id, 'Terminé');
        CRR.Envoi_email__c = false;
        insert CRR;
        
        Task email = Utils_TestMethods.createEmailTask(CRR.Id, 'Email');
        
        Test.startTest();
        insert email;
        Test.stopTest();
        
        Compte_rendu_rempli__c CRRUpdated = [SELECT Id, Envoi_email__c
                                             FROM Compte_rendu_rempli__c 
                                             WHERE Id = :CRR.Id
                                             LIMIT 1];
        
        System.assertEquals(true, CRRUpdated.Envoi_email__c);
        
    }
    
}