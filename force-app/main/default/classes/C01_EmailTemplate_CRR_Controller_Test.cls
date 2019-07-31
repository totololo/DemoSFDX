/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: TestClass C01_EmailTemplateController
History
2018-06-05  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class C01_EmailTemplate_CRR_Controller_Test {    
    
    @isTest
    public static void EmailTemplateTest(){
        
        Id CompteRendu_RTId = [SELECT id FROM RecordType WHERE DeveloperName = 'VA' AND SobjectType = 'Compte_rendu__c' LIMIT 1].Id;
        
        Account compte = Utils_TestMethods.CreateAccount(null, null, 'compte');
        insert compte;
        
        Compte_rendu_rempli__c CRR = Utils_TestMethods.createCompteRenduRempli(compte.Id, Label.VAVAP_statutTermine);
        insert CRR;
        
        Compte_rendu__c CR = Utils_TestMethods.createCompteRendu('Compte Rendu', CompteRendu_RTId);
        insert CR;
        
        Questions_CR__c ques = Utils_TestMethods.createQuestionsCR(CR.id, 'Oui;Non', 'test?', 'Choix');
        insert ques;
        
        Reponse_CR__c Reponse = Utils_TestMethods.createReponseCR(CRR.id, ques.Id, 'Question', 'Reponse');
        insert Reponse; 
        
        Folder folder = [SELECT id, Name FROM Folder WHERE DeveloperName  = 'EmailTemplates']; system.debug('folder: '+folder);
        Document header = Utils_TestMethods.createDocument('Header', 'HeaderTest', folder.Id);
        Document footer = Utils_TestMethods.createDocument('Footer', 'FooterTest', folder.Id);
        insert new List<Document>{header, footer};
        
        Test.startTest();
        C01_EmailTemplate_CRR_Controller ETC = new C01_EmailTemplate_CRR_Controller();
        ETC.CompteRenduRempli = CRR;
        ETC.setListReponses(new List<Reponse_CR__c>{Reponse});
        List<Reponse_CR__c> reponses = ETC.getListReponses();
        String HeaderUrl = ETC.getHeaderUrl();
        ETC.HeaderUrl='header';
        String FooterUrl = ETC.getFooterUrl();
        ETC.FooterUrl='footer';
        Test.stopTest();
        
        System.assertEquals(Reponse.Question__c, reponses[0].Question__c);
        System.assertEquals(Reponse.Reponse__c, reponses[0].Reponse__c);
        
    }

}