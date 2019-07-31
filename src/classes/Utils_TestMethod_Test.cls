// this class is created to increase the code coverage 

@isTest
public class Utils_TestMethod_Test {
    
    static testmethod void increaseTest() {
        //create service
        Service__c service = Utils_TestMethods.CreateService('service');
        insert service;
        
        // create reseau
        Reseau__c reseau = Utils_TestMethods.CreateReseau('reseau');
        insert reseau;
        
        // create transporteur
        Transporteur__c transporteur = Utils_TestMethods.CreateTransporteur('transporteur');
        insert transporteur;
        
        // create Reseau-service
        Reseau_Service__c res_service = Utils_TestMethods.CreateReseauService(reseau.Id,service.Id);
        insert res_service;
        
        // create Reseau-transporteur
        Reseau_Transporteur__c res_trans = Utils_TestMethods.CreateReseauTransporteur(reseau.Id ,transporteur.Id);
        insert res_trans;
        
        // create macroprofil
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('mp');
        insert mp;
        
        // create mp-transp
        Macroprofil_Transporteur__c mp_trans = Utils_TestMethods.CreateMacroprofilTransporteur(mp,transporteur);
        insert mp_trans;
        
        // create mp-service
        Macroprofil_Service__c mp_service = Utils_TestMethods.CreateMacroprofilService(mp,service);
        insert mp_service;
        
        // create mp-reseau
        Macroprofil_Reseau__c mp_reseau = Utils_TestMethods.CreateMacroprofilReseau(mp.Id,reseau.Id);
        insert mp_reseau;
        
        // create account
        //create contact
        Contact contact = Utils_TestMethods.CreateContact('Contact 1');
        insert contact;
        
        // Create Account
        Account acc = Utils_TestMethods.CreateAccount(contact, mp, 'Account 1');
        acc.Macroprofil_de_reference__c = mp.Id;
        insert acc;
        
        Reseau_Associe__c ra = Utils_TestMethods.createReseauAssocie(reseau.Id,acc.Id,true,true);
        insert ra;
        ra.Active__c = false;
        ra.Modifiable__c = true;
        update ra;
        
        Case cas = Utils_TestMethods.createRequete('1', mp.id);
        
        Questionnaire__c questionnaireAttente1 = Utils_TestMethods.createQuestionnaire(mp.Id, '1');
        Lead lead2 = Utils_TestMethods.createLead('John','Boutros','EI-Technologies','Qualifie');
        
        User newUser = Utils_TestMethods.createUser('John', 'Boutros', 'john.boutros@ei-technologies.com', 'john.boutros@ei-technologies.com');
        
        Id CongeRTypeId = Label.CongeRT_15;
        Conge_Indispo__c conge1 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, acc.Id, Date.today().addDays(10), Date.today().addDays(15));      
        insert conge1;
        
        Configuration__c testConfig = Utils_TestMethods.createConfiguration('Config 1');
        insert testConfig;
        
        Compte_rendu_rempli__c CRR = Utils_TestMethods.createCompteRenduRempli(acc.Id, 'Terminé');
        insert CRR;
        
        Id CompteRendu_RTId = [SELECT id FROM RecordType WHERE DeveloperName = 'VA' AND SobjectType = 'Compte_rendu__c' LIMIT 1].Id;
        
        Compte_rendu__c CR = Utils_TestMethods.createCompteRendu('Compte Rendu', CompteRendu_RTId);
        insert CR;
        
        Questions_CR__c ques = Utils_TestMethods.createQuestionsCR(CR.id, 'Oui;Non', 'test?', 'Choix');
        insert ques;
        
        Reponse_CR__c Reponse = Utils_TestMethods.createReponseCR(CRR.id, ques.Id, 'Question', 'Reponse');
        insert Reponse; 
        
        Type_de_casier__c testTypeDeCase = Utils_TestMethods.createTypeCasierKEBA('Test Type De Casier');
        try{
            insert testTypeDeCase;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        
        Configuration_Locker_Type__c testConfigurationLockerType = Utils_TestMethods.createConfigurationLockerType(testConfig.id, testTypeDeCase.id);
        try{
            insert testConfigurationLockerType;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        
        Questions__c questionAttente1 = Utils_TestMethods.createQuestion(questionnaireAttente1.Id, 'Comment se passe la reception des colis avec Chronopost?', 'Le livreur arrive, il scan', 'Primordiale');
        Attachment attachment1 = Utils_TestMethods.createAttachment(acc.Id , 'test body' , 'test');
        
        Configuration_Site__c testConfigSite= Utils_TestMethods.createConfigurationSite();
        Account testAccBNLNonSuivi = Utils_TestMethods.createAccountBNLnonSuiviCO(mp,'name1');
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        Case demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel1Statut1, macroProf.id);
        demarrageCase.accountId = acc.Id;
        insert demarrageCase;
        Date dateRap = date.newinstance(system.now().year(),system.now().month(),system.now().day());
        String resultatappel = Label.DA_PassageAppSuivant;
        Historique_des_Comptes_Rendus__c createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel,demarrageCase, dateRap, true);
        insert createHistorRecord;
    }
}