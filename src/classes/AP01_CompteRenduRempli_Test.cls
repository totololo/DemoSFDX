/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: Test Class for AP01_CompteRenduRempli
History
2018-06-08  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class AP01_CompteRenduRempli_Test {
    
    @isTest
    public static void testUpdateAccount(){
        
        Id CompteRendu_RTId = [SELECT id FROM RecordType WHERE DeveloperName = 'VA' AND SobjectType = 'Compte_rendu__c' LIMIT 1].Id;
        
        Macroprofil__c MP = Utils_TestMethods.CreateMacroprofil('MP1-Standard');
        MP.Name = 'MP1-Standard';
        insert MP;
        
        Account compte = Utils_TestMethods.CreateAccount(null, null, 'compte');
		compte.Type = '2';
        compte.Operateur_Global__c='PUS_FR';
        insert compte;
        
        System.debug('***compte : ' + compte);
        Compte_rendu_rempli__c CRR1 = Utils_TestMethods.createCompteRenduRempli(compte.Id, Label.VAVAP_statutEnAttente);
        Compte_rendu_rempli__c CRR2 = Utils_TestMethods.createCompteRenduRempli(compte.Id, Label.VAVAP_statutTermine);
        insert new List<Compte_rendu_rempli__c> {CRR1, CRR2};
        
        Compte_rendu__c CR = Utils_TestMethods.createCompteRendu('Compte Rendu', CompteRendu_RTId);
        insert CR;
        
        Questions_CR__c ques = Utils_TestMethods.createQuestionsCR(CR.id, 'Oui;Non', 'test?', 'Choix');
        insert ques;
 
        Reponse_CR__c Reponse = Utils_TestMethods.createReponseCR(CRR1.id, ques.Id, 'Question', 'MP1-Standard');
        Reponse.Changement_macro_profil__c = true;
        insert Reponse;
        
        CRR1.Statut__c = Label.VAVAP_statutTermine;
        CRR1.Hauteur__c = 250;
        CRR1.Largeur__c = 155;
        CRR1.Profondeur__c = 40;
        CRR1.Nombre_d_etageres__c = 1;
        CRR1.Seuil_contractuel__c = 20;
        
        Test.startTest();
        update CRR1;
        Test.stopTest();
        
        Account acc = [SELECT Id, Macroprofil_actuel__c, Hauteur_cm__c, Largeur_cm__c, 
                       Profondeur_cm__c, Nombre_detageres__c, Seuil_contractuel__c
                       FROM Account 
                       WHERE Id = :compte.Id LIMIT 1];
        
        //system.assertEquals(MP.Id, acc.Macroprofil_actuel__c);
        system.assertEquals(CRR1.Hauteur__c, acc.Hauteur_cm__c);
        system.assertEquals(CRR1.Largeur__c, acc.Largeur_cm__c);
        system.assertEquals(CRR1.Profondeur__c, acc.Profondeur_cm__c);
        system.assertEquals(CRR1.Nombre_d_etageres__c , acc.Nombre_detageres__c);
        system.assertEquals(CRR1.Seuil_contractuel__c, acc.Seuil_contractuel__c);
        
    }

}