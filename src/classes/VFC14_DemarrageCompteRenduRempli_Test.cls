@isTest
public class VFC14_DemarrageCompteRenduRempli_Test {
    static testMethod void DemarrageCompteRenduRempli_Test() {
        
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_Converti__c
                                                                                  FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
          associationRTPays.put(associationRT.MasterLabel, associationRT);}
        
        //Create Macro Profil
        Macroprofil__c MP = Utils_TestMethods.CreateMacroprofil('Name');
        insert MP;
        
        //Create Account France
        Account account1= Utils_TestMethods.CreateAccount(null, null, 'Test Account1');
        account1.RecordTypeId = associationRTPays.get('France').ID_Prospect_Converti__c;
        account1.ShippingCountry ='France';
        account1.ShippingCountrycode ='FR';
        account1.Etat__c = '0';
        account1.Operateur_Global__c='PUS_FR';
        account1.Reference_internationale__c ='121212';
        account1.Date_de_visite__c =Date.today();
        account1.Hauteur_cm__c = 250;
        account1.Largeur_cm__c=155;
        account1.Nombre_detageres__c=1;
        account1.Profondeur_cm__c=40;
        account1.Seuil_contractuel__c=1;
        account1.Macroprofil_actuel__c = MP.Id;
        insert account1;
        
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        testContact.AccountId = account1.id; 
        insert testContact;
        account1.Contact_operationnel_1__c =  testContact.id;
        account1.Responsable_facturation__c = testContact.id;
        account1.Nom_Responsable_magasin__c = testContact.id;
        update account1; 
        
        Id selectedRTT = [select id from RecordType where id =:id.valueOf(Label.VAVAP_recordTypeVA) limit 1].id;
        //Create CRobjectType =:Label.VAVAP_compteRenduRempliLabel
        Compte_rendu__c CR = new Compte_rendu__c(RecordTypeId = [select id, Name, SobjectType from RecordType where SobjectType ='Compte_rendu__c'  and Name ='VA'limit 1].id);
        CR.Name = 'name1';	
        CR.Type_de_compte_rendu__c = 'VA Standard';
        insert CR;
        
        Questions_CR__c ques = new Questions_CR__c();
        ques.Compte_rendu__c = CR.id;
        ques.Options_de_reponses__c = 'Oui;Non';
        ques.Questions__c = 'test?';
        ques.Type_de_reponse__c = 'Choix';
        ques.Follow_up__c = false;
        
        insert ques;
        
        Compte_rendu_rempli__c myCRR = new Compte_rendu_rempli__c();
        myCRR.Compte__c = account1.id;
        myCRR.Compte_rendu__c = CR.id;
        myCRR.RecordTypeId = Label.VAVAP_recordTypeVA;
        myCRR.Type_de_compte_rendu__c = 'VA Standard';
        myCRR.Statut__c = 'En attente de traitement';
        
        insert myCRR;
        
        Questions_CR__c quesMP = new Questions_CR__c();
        quesMP.Compte_rendu__c = CR.id;
        quesMP.Questions__c = 'test?';
        quesMP.Changement_macro_profil__c = false;
        insert quesMP;
        
        Reponse_CR__c rep = Utils_TestMethods.createReponseCR(myCRR.Id, quesMP.Id, '', 'MPFR_Consigne');
        insert rep;
        
        test.StartTest();
        PageReference pageRef = Page.VFP14_DemarrageCompteRenduRempli;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(new Compte_rendu_rempli__c( Compte__c = account1.Id));
        VFC14_DemarrageCompteRenduRempli demarrageCRR = new VFC14_DemarrageCompteRenduRempli(sc);
        demarrageCRR.CRR.Compte__c = account1.id;
        demarrageCRR.getCRTypes();
        demarrageCRR.selectedRT= selectedRTT;
        demarrageCRR.CRR.Contact_operationnel_rencontre__c = true;
        //demarrageCRR.CRR.Contact__c =  testContact.id;
        demarrageCRR.getOtherContact();
        demarrageCRR.getPickListValues();
        demarrageCRR.selectedRT= selectedRTT;
        demarrageCRR.CRR.Type_de_compte_rendu__c = 'VA Standard';
        demarrageCRR.redirectToQuestionnaire();
        demarrageCRR.selectedRT= selectedRTT;
        demarrageCRR.listWrapperQuestions[0].reponse='MPFR_Consigne';
        demarrageCRR.saveResponse();
        String myString;
        List<string> myList = new List<string>();
        myList = demarrageCRR.handleMultiPicklist('Testing');
        myString = demarrageCRR.multiToString(myList);
       
        // test Update
        PageReference pageRef2 = Page.VFP14_DemarrageCompteRenduRempli;
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(myCRR);
        VFC14_DemarrageCompteRenduRempli demarrageCRR2 = new VFC14_DemarrageCompteRenduRempli(sc2); 
        demarrageCRR2.redirectToQuestionnaire();
        demarrageCRR2.saveResponse();
        
        
        myCRR.Date_de_la_visite__c = null;
        myCRR.Statut__c=Label.VAVAP_statutTermine;
        PageReference pageRef3 = Page.VFP14_DemarrageCompteRenduRempli;
        Test.setCurrentPage(pageRef3);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(myCRR);
        VFC14_DemarrageCompteRenduRempli demarrageCRR3 = new VFC14_DemarrageCompteRenduRempli(sc3); 
    
        demarrageCRR3.redirectToQuestionnaire();
        demarrageCRR.listWrapperQuestions[0].reponse='Autre';
        demarrageCRR.CRR.Contact__c =  '0035E00000SEx3D';
        demarrageCRR.getOtherContact();
        demarrageCRR.CRR.Contact__c =  null;
        demarrageCRR.getOtherContact();
        demarrageCRR3.saveResponse();
        demarrageCRR3.closePage();
        test.stopTest();
    }
}