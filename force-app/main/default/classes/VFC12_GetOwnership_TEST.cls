@isTest
public class VFC12_GetOwnership_TEST {
    static testMethod void testGetOwnership() {
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
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        Case testCase = Utils_TestMethods.createRequete('en attente d\'attribution',null);
        testCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        testCase.AccountId =account1.id;
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VFC12_GetOwnership controller = new VFC12_GetOwnership(sc);
        insert testCase;
        apexpages.currentpage().getparameters().put('id', testCase.id);
        VFC12_GetOwnership.getOwnership();
    }
}