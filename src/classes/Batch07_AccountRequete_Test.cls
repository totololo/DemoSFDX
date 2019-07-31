@isTest
public class Batch07_AccountRequete_Test {
    
    public static testMethod void testBatch(){
        
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassValidationRule__c, BypassWorkflow__c
                           from User
                           where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = true;
        currentUser.BypassValidationRule__c = true;
        currentUser.BypassWorkflow__c = true;
        update currentUser;
        
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('MP12');
        insert mp;
        
        Contact cont = Utils_TestMethods.CreateContact('Test Contact');
        insert cont;
        
        Account acc = Utils_TestMethods.CreateAccount(cont, mp, 'Account Test');
        acc.Type = '2';
        acc.ShippingStreet = acc.BillingStreet = 'Sesame Street';
        acc.ShippingCity = acc.BillingCity = 'Paris';
        acc.ShippingCountry = acc.BillingCountry = 'France';
        acc.ShippingPostalCode = acc.BillingPostalCode = 'NA';
        acc.RecordTypeId = Label.PUS_RT_NonSuiviParCO;
        acc.Reference_internationale__c = 'F1234';
        insert acc;
        
        Case cas = Utils_TestMethods.createRequete('1', mp.id);
        cas.AccountId = acc.Id;
        cas.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PUS_FR_Indisponibilité PB PDA Synchro').getRecordTypeId();
        insert cas;
        
        Account account2 = Utils_TestMethods.CreateAccount(cont, mp, 'Account2');
        account2.Type = '21';
        account2.ShippingStreet = acc.BillingStreet = 'Sesame Street';
        account2.ShippingCity = acc.BillingCity = 'Paris';
        account2.ShippingCountry = acc.BillingCountry = 'France';
        account2.ShippingPostalCode = acc.BillingPostalCode = 'NA';
        account2.RecordTypeId = Label.PUS_RT_NonSuiviParCO;
        account2.Reference_internationale__c = 'F1235';
        insert account2;
        
        Test.startTest();
        Batch07_AccountRequete batchAccountRequete = new Batch07_AccountRequete();
        Database.executeBatch(batchAccountRequete); 
        Test.stopTest();

    }

}