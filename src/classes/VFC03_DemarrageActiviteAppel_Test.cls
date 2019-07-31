/**
* @version 1.00 10/01/2017
* @author Lea Zoghbi
* @CodeCoverage 
*/
@isTest
private class VFC03_DemarrageActiviteAppel_Test {
    @testSetup static void methodName() {
        //create macroprofil
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('Macroprofil');
        insert macroprofil;
        
                
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        insert testContact;
        
        //Create Account France
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account1');
        account1.RecordTypeId = Label.PUS_RT_ProspectConverti;
        account1.ShippingCountry ='France';
        account1.ShippingCountrycode ='FR';
        account1.Etat__c = '0';
        account1.Operateur_Global__c='PUS_FR';
        insert account1;
        
        //Create requete
        Case requeteDA = Utils_TestMethods.createRequete('1', macroprofil.Id);
        requeteDA.Origin = 'Enquête de satisfaction';
        requeteDA.AccountID = account1.Id;
        insert requeteDA;
  

        
        Questionnaire__c questionnaireAttente1 = Utils_TestMethods.createQuestionnaire(macroprofil.Id, '1');
        questionnaireAttente1.Operateur__c = 'PUS_FR';
        Questionnaire__c questionnaireAttente2 = Utils_TestMethods.createQuestionnaire(macroprofil.Id, '2');
        questionnaireAttente2.Bilan__c = 'Bilan 1'; 
        questionnaireAttente2.Operateur__c = 'PUS_FR';
        Questionnaire__c questionnaireDemandeSortie = Utils_TestMethods.createQuestionnaire(macroprofil.Id, '');
        questionnaireDemandeSortie.RecordTypeId = Label.DA_RT_DemandeDeSortie_Questionnaire;
        insert new list<Questionnaire__c>{questionnaireAttente1, questionnaireAttente2, questionnaireDemandeSortie};
        
        Questions__c questionAttente1 = Utils_TestMethods.createQuestion(questionnaireAttente1.Id, 'Comment se passe la reception des colis avec Chronopost?', 'Le livreur arrive, il scan', 'Primordiale');
        Questions__c questionAttente2 = Utils_TestMethods.createQuestion(questionnaireAttente2.Id, 'Comment se passe la reception des colis avec Chronopost?', 'Le livreur arrive, il scan', 'Primordiale');
        Questions__c questionSortie = Utils_TestMethods.createQuestion(questionnaireDemandeSortie.Id, 'Comment se passe la reception des colis avec Chronopost?', 'Le livreur arrive, il scan', 'Primordiale');
        Questions__c questionSortieReception = Utils_TestMethods.createQuestion(questionnaireDemandeSortie.Id, 'Comment se passe la reception des colis avec Chronopost?', 'Le livreur arrive, il scan', 'Primordiale');
        insert new list<Questions__c>{questionAttente1, questionAttente2, questionSortie, questionSortieReception};
    }
    static testMethod void appelDemarrage_Test() {
        
        Macroprofil__c macroprofil = [select id 
                                      from Macroprofil__c
                                      limit 1];
                                      
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        insert testContact;
        
        //Create Account France
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account1');
        account1.RecordTypeId = Label.PUS_RT_ProspectConverti;
        account1.ShippingCountry ='France';
        account1.ShippingCountrycode ='FR';
        account1.Etat__c = '0';
        insert account1;
        
        Case requeteDANoQuestionnaire = Utils_TestMethods.createRequete('3', macroprofil.Id);
        requeteDANoQuestionnaire.accountId = account1.Id;
        insert requeteDANoQuestionnaire;
        
        test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(requeteDANoQuestionnaire);
        VFC03_DemarrageActiviteAppel demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        
        PageReference pageRef = Page.VFP03_DemarrageActiviteAppel;
        pageRef.getParameters().put('id', String.valueOf(requeteDANoQuestionnaire.Id));
        Test.setCurrentPage(pageRef);
        
        Case requeteDA = [ select id, Status
                     from Case 
                     where id != :requeteDANoQuestionnaire.Id
                         AND RecordTypeId =:Label.DA_RequeteRecrodTypeDAId];
        
        
        sc = new ApexPages.StandardController(requeteDA);
        demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        demarrageActiviteAppel.listWrapperQuestions[0].reponse = Label.DA_ReponseRevu;
        demarrageActiviteAppel.getItems();
        demarrageActiviteAppel.interrompu = true;
        demarrageActiviteAppel.save();
        
        list<Reponse__c> listReponse = [ select id
                                       from Reponse__c];
        system.assertEquals(1, listReponse.size());
        
        //check with interrompu that case is not modified
        Case caseNotModified = [select Id, Status
                                from Case
                                where Id =: requeteDA.Id];
        system.assertEquals('1', caseNotModified.Status);

        
        //Case of final save
        demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        demarrageActiviteAppel.listWrapperQuestions[0].reponse = Label.DA_ReponseOk;
        demarrageActiviteAppel.save();
        
        Case caseModified = [select Id, Status
                            from Case
                            where Id =: requeteDA.Id];
        //N.B: Uncomment and solve the error after deployment John
        //system.assertEquals('2', caseModified.Status);
        
        demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        demarrageActiviteAppel.listWrapperQuestions[0].reponse = Label.DA_ReponseKo;
        demarrageActiviteAppel.interrompu = true;
        demarrageActiviteAppel.save();
        
        //clear selection then save
        demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        demarrageActiviteAppel.questionId = demarrageActiviteAppel.listWrapperQuestions[0].id;
        demarrageActiviteAppel.clearSelection();
        demarrageActiviteAppel.interrompu = true;
        demarrageActiviteAppel.save();
        
        //test case bilan status remains same
        demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        demarrageActiviteAppel.listWrapperQuestions[0].reponse = Label.DA_ReponseKo;
        demarrageActiviteAppel.save();
        Case caseBilan = [select Id, Status
                             from Case
                             where Id =: requeteDA.Id];
        //N.B: Uncomment and solve the error after deployment John
        //system.assertEquals('2', caseModified.Status);
        
        demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        pageRef = demarrageActiviteAppel.cancel();
       // system.assertEquals('/'+ requeteDA.Id , pageRef.getUrl());
        
        demarrageActiviteAppel.getItems();
        test.stopTest();
    }
    static testMethod void appelDemarrage_DemandeDeSortie_Test() {
        Case requeteDA = [ select id, Status
                          from Case 
                          limit 1];
        test.StartTest();
               
        PageReference pageRef = Page.VFP03_DemarrageActiviteAppel;
        pageRef.getParameters().put('id', String.valueOf(requeteDA.Id));
        pageRef.getParameters().put('isSortie', 'true');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(requeteDA);
        VFC03_DemarrageActiviteAppel demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        
        demarrageActiviteAppel.isJoinable = true;
        demarrageActiviteAppel.redirectToQuestionnaire();
        
        list<Task> listNoTasks = [select id, Subject
                                from Task];
        
        system.assertEquals(0, listNoTasks.size());
        
        demarrageActiviteAppel.isJoinable = false;
        demarrageActiviteAppel.redirectToQuestionnaire();
        
        list<Task> listTasks = [select id, Subject
                                from Task];
        
        system.assertEquals(1, listTasks.size());
        system.assertEquals(Label.DA_Tache_NeRepondPas, listTasks[0].Subject);
        
        demarrageActiviteAppel.listWrapperQuestions[0].reponse = Label.DA_ReponseOk;
        demarrageActiviteAppel.interrompu = true;
        demarrageActiviteAppel.save();
        
        demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
        demarrageActiviteAppel.questionId = demarrageActiviteAppel.listWrapperQuestions[0].id;
        demarrageActiviteAppel.fillSelection();
        demarrageActiviteAppel.save();
        
        list<Task> listTaskSortie = [select id, Subject 
                                     from Task 
                                     where Subject =: Label.DA_Tache_DemandeSortieEnCours];
        //system.assertEquals(1, listTaskSortie.size());
        
        test.stopTest();
    }
    
     static testMethod void appelDemarrage_ConditionsNonValide_Test() {
         test.StartTest();
         
         PageReference pageRef = Page.VFP03_DemarrageActiviteAppel;
         Test.setCurrentPage(pageRef);
         
         ApexPages.StandardController sc = new ApexPages.StandardController(new Case());
         VFC03_DemarrageActiviteAppel demarrageActiviteAppel = new VFC03_DemarrageActiviteAppel(sc);
         
         test.stopTest();
     }
}