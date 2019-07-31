@isTest
public class VFC02_LeadConversionControllerInter_TEST {
    public static  testmethod void  convertLeadsLightning()
    {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_Piste__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];        
        CountriesSequence__c cs = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE00001');
        insert cs;
        leadConversionTest(associationRTPays);
    }
    public static void leadConversionTest(List< Association_Record_Type_et_pays__mdt> associationRTPays){
        Lead lead1 = Utils_TestMethods.createLead('John','Boutros','EI-Technologies','Qualifie');
        lead1.RecordTypeId = associationRTPays[0].ID_Piste__c;
        lead1.Country__c   = 'Belgium'; 
        lead1.Street__c    =  'lead street';
        lead1.Activite_commerciale_principale__c = null;
        lead1.Postal_Code__c ='1234';
        insert lead1;      
        system.debug('aaaa '+[Select id, country, countrycode From lead where id = :lead1.id]);
        VFC02_LeadConversionControllerInter.convertLeadAndRedirectToAccountLightning(lead1.id);
        test.startTest();
        VFC02_LeadConversionControllerInter.convertLeadAndRedirectToAccountLightning(lead1.id);
        test.stopTest();
        
        Lead lead2 = Utils_TestMethods.createLead('John','Boutros','EI-Technologies','Qualifie');
        lead2.Postal_Code__c = '1235';
        lead2.RecordTypeId = associationRTPays[0].ID_Piste__c;
        lead2.Country__c   = 'Belgium'; 
        lead2.Street__c    =  'lead street';
        lead2.Activite_commerciale_principale__c = null;
        insert lead2;
        Contact testContact = Utils_TestMethods.CreateContact('testt');
        CountriesSequence__c cs1 = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE00002');
        insert cs1;
        Account account2= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account1');
        account2.RecordTypeId = associationRTPays[0].ID_Prospect_Converti__c;
        account2.ShippingCountry ='Belgium';
        account2.ShippingCountryCode ='BE';
        account2.BillingCountry ='Belgium';
        account2.BillingCountryCode ='BE';
        account2.Etat__c = '0';
        account2.Reference_internationale__c = cs1.Sequence__c;
        account2.ShippingPostalCode = '1234';
        account2.BillingPostalCode = '1234';
        account2.Operateur_Global__c = 'DPD_BNL';
        insert account2;
        VFC02_LeadConversionControllerInter.convertLeadAndRedirectToAccountLightning(lead2.id);
    }
}