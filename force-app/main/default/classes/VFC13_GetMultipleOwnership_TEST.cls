@isTest
public class VFC13_GetMultipleOwnership_TEST {
    static testMethod void testGetOwnership() {
        // retrieve ID of belgium
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        //Create Custom Settings country sequence
        CountriesSequence__c cs = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE0001');
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        try{
            insert testContact;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        //Create Account BNL
        Account account2= Utils_TestMethods.CreateAccount(null, null, 'Test Account1');
        account2.RecordTypeId = associationRTPays[0].ID_Prospect_Converti__c;
        account2.ShippingCountry ='Belgium';
        account2.ShippingCountryCode='BE';
        account2.BillingCountry ='Belgium';
        account2.BillingCountryCode='BE';
        account2.Etat__c = '4';
        account2.Operateur_Global__c = 'DPD_BNL';
        account2.ShippingPostalCode = '1234';
        account2.BillingPostalCode = '1234';
        account2.Type ='2';
        insert account2;
        List<Case> listTestCase = new List<Case>();
        Case testCase = Utils_TestMethods.createRequete('En attente de rappel',null);
        testCase.Subject = 'Injoignabilité - Problème opérationnel Sinistre / Travaux / Santé';
        testCase.AccountId = account2.id;
        testCase.Date_de_rappel_planifiee__c = system.today()-1;
        listTestCase.add(testCase);
        insert listTestCase;
       
        ApexPages.StandardsetController sc = new ApexPages.StandardsetController(listTestCase);
        sc.setSelected(listTestCase);
        VFC13_GetMultipleOwnership controller = new VFC13_GetMultipleOwnership(sc);
        VFC13_GetMultipleOwnership.getOwnership();
        VFC13_GetMultipleOwnership.cancel();
    }
    static testMethod void testGetOwnershipRefused() {
        
        // if not in the predefined list views
        Case testCase1 = Utils_TestMethods.createRequete('en attente d\'attribution',null);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(testCase1);
        VFC13_GetMultipleOwnership controller1 = new VFC13_GetMultipleOwnership(sc1);
        //insert testCase1;
        VFC13_GetMultipleOwnership.getOwnership();
    }
}