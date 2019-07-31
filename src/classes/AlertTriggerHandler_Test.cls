@isTest
public class AlertTriggerHandler_Test {

    public testMethod static void TestTrigger(){
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
        Alert__c testAlert2 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='2',MISSGUIDED_TYPE__C='1',recurrence_index__c=0 );
        insert testAlert2;
        Alert__c testAlert3 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='1',recurrence_index__c=0 );
        insert testAlert3;
        set<ID> Setids = new Set<ID>();
        Setids.add(testAlert1.id);
        Setids.add(testAlert2.id);
        Setids.add(testAlert3.id);
        Setids.add(testAlert1.id);
        //Alert__c testAlert4 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='2',MISSGUIDED_TYPE__C='2',recurrence_index__c=2 );
        //nsert testAlert4;
        //testAlert4.MessagePDA_ID__c='1234';
        //update testAlert4;
        Alert__c testAlert5 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='1',recurrence_index__c=2 );
        insert testAlert5;
        testAlert5.MessagePDA_ID__c='12345';
        update testAlert5;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        WSCallMessagePDA.MsgPDACallout(Setids);
        Test.stopTest();
        //Alert__c testAlert2 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='2',MISSGUIDED_TYPE__C='1',recurrence_index__c=1, CARRIER_NAME__C='Colissimo',MISSGUIDED_REASON_PUDO__C='1',MISSGUIDED_REASON__C='1');
        //insert testAlert2;
        //Alert__c testAlert3 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='1',recurrence_index__c=2 );
        //insert testAlert3; 
    }
}