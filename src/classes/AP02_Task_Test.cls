@isTest
public class AP02_Task_Test {
    static testMethod void showCaseOnLVTest()
    {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = associationRTPays[0].ID_suivi_CO__c;
        account1.Etat__c = '0';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        insert account1;
        //Create Contact
        Contact testContact = Utils_TestMethods.CreateContact('c1');
        testContact.AccountId =account1.id;
        Insert testContact;
        List< Association_Record_Type_et_pays__mdt> associationRTPaysBNL = [Select Id, ID_AnomalieSynchro__c
                                                                            FROM Association_Record_Type_et_pays__mdt
                                                                            Where MasterLabel ='Belgium'
                                                                            order by MasterLabel ];
        Case caseTest = Utils_TestMethods.createRequete('0', null);
        caseTest.RecordTypeId = associationRTPaysBNL[0].ID_AnomalieSynchro__c;
        caseTest.Object_de_la_requete__c ='Anomalie de synchronisation d’un relais';
        caseTest.Priority = '1';
        caseTest.Subject ='test subject';
        caseTest.AccountId =account1.id;
        caseTest.ContactId =testContact.id;
        insert caseTest;
        
        
        Task taskTest = Utils_TestMethods.createTask(caseTest, testContact1);
        Test.startTest();
        insert taskTest;
        Task taskTest1 = Utils_TestMethods.createTask(caseTest, testContact1);
        insert taskTest1;
        Date myDate = date.newinstance(system.now().year(),system.now().month(),system.now().day());
        taskTest1.ActivityDate = myDate;
        update taskTest1;
        Test.stopTest();
        
    }
}