@isTest
private class BatchCloseCaseOverload_Test {

    static testmethod void test() {        
        Test.startTest();
        Id accountRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' and developerName='PUS_FR_PUDO_Suivi_CO'].Id;
        Id CaseRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Case' and developerName='TM_FR'].Id;
        Macroprofil__c MP = Utils_TestMethods.CreateMacroprofil('MP1-Standard');
        MP.Name = 'MP1-Standard';
        insert MP;
        
        Contact acontact = Utils_TestMethods.CreateContact('contactPudo');
        insert acontact;
        Secteur__c asecteur= Utils_TestMethods.createSectorFR('secteurFR');
        insert asecteur;
        Account compte = Utils_TestMethods.CreateAccountPUS_FR_SuiviCo(acontact, MP, 'compte',asecteur );
        compte.Operateur_Global__c='PUS_FR';
        compte.Contact_operationnel_1__c=acontact.Id;
        compte.recordtypeId=accountRecordTypeId ;
        insert compte;
        Case testCase = new CAse(AccountId=compte.Id,reason='Vie du relais', status='0',Sous_motif_1__c='Surcharge', Sens_du_contact__c='Sortant',recordtypeId=CaseRecordTypeId);
        insert testCase;
        
        BatchCloseCaseOverload batchCloseCaseOverload = new BatchCloseCaseOverload();
        Database.executeBatch(batchCloseCaseOverload);
        Test.stopTest();

    }
     public static testMethod void testschedule() {
        Test.StartTest();
        BatchCloseCaseOverloadSchedule testsche = new BatchCloseCaseOverloadSchedule ();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
    
}