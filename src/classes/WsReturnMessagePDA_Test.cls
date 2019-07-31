@isTest
public class WsReturnMessagePDA_Test {
    @isTest
    static void TestRestCallMsgPDA(){
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
        compte.recordtypeId=objectRecordTypeId ;
        insert compte;
        Alert__c testAlert = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='1');
        insert testAlert;
        //Alert__c testAlert1 = new Alert__c(pudo__c=compte.Id,ALERT_TYPE__C='2',MISSGUIDED_TYPE__C='2',recurrence_index__c=2 );
        //insert testAlert1;
        testAlert.MessagePDA_ID__c='1234';
        update testAlert;
        //testAlert1.MessagePDA_ID__c='12345';
        //update testAlert1;
        set<ID> Setids = new Set<ID>();
        Setids.add(testAlert.id);
        //Setids.add(testAlert1.id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        WSCallMessagePDA.MsgPDACallout(Setids);
        Test.stopTest();
        List<WsReturnMessagePDA.ResponseMessagePDA> listresponse = new List<WsReturnMessagePDA.ResponseMessagePDA>();
        WsReturnMessagePDA.ResponseMessagePDA firstResponse = new WsReturnMessagePDA.ResponseMessagePDA();
        WsReturnMessagePDA.ResponseMessagePDA secondResponse = new WsReturnMessagePDA.ResponseMessagePDA();
        firstResponse.IDMessagePDA=testAlert.MessagePDA_ID__c;
        firstResponse.response_overload_capacity_reach='A';
        firstResponse.response_new_temporary_threshold='20';
        firstResponse.response_new_Contractual_threshold='22';
        listresponse.add(firstResponse);
        //secondResponse.IDMessagePDA=testAlert1.MessagePDA_ID__c;
        //secondResponse.response_missguided_full_cause_closure='B';
        //listresponse.add(secondResponse);
        RestRequest request = new RestRequest();
        RestContext.request = request;
        //Set request properties
        request.requestUri ='https://test.salesforce.com/services/apexrest/ReturnMsgPDA/';  
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"listResponse":[{"IDMessagePDA":"1234","response_overload_capacity_reach":"A","response_new_temporary_threshold":"12"},{"IDMessagePDA":"12345","response_missguided_full_cause_closure":"B"}');
        RestContext.request = request;
        Boolean testRetour =WsReturnMessagePDA.updateAlertByMessagePDA(listresponse);
        System.assertEquals(testRetour, False);
        
    }
}