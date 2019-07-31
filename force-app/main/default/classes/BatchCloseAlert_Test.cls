@isTest
private class BatchCloseAlert_Test {

    static testmethod void test() {        
        Test.startTest();
        Id objectRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' and developerName='PUS_FR_PUDO_Suivi_CO'].Id;
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
        compte.recordtypeId=objectRecordTypeId ;
        insert compte;
        Alert__c testAlert1 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='2',MISSGUIDED_TYPE__C='2',recurrence_index__c=0 );
        insert testAlert1;
        set<ID> Setids = new Set<ID>();
        Setids.add(testAlert1.id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        WSCallMessagePDA.MsgPDACallout(Setids);
        BatchCloseAlert batchAlert = new BatchCloseAlert();
        Database.executeBatch(batchAlert );
        BatchCloseAlertSchedule testsche = new BatchCloseAlertSchedule ();
        Test.stopTest();
        
    }
    public static testMethod void testschedule() {
        Test.StartTest();
        BatchCloseAlertSchedule  testsche = new BatchCloseAlertSchedule ();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
    
}