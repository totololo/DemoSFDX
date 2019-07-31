@isTest
public class Batch09_CaseType_AnomSync_Test {
    
    public static testmethod void  Btch09Test(){
        
        //Create Contact
        Contact c = Utils_TestMethods.CreateContact('c1');
        Insert c;
        
        //Create Macroprofil
        Macroprofil__c m1 = Utils_TestMethods.CreateMacroprofil('m1');
        insert m1;
        
        //Create Account
        Map<String, Id> mapRecordTypeDevNameToId = new Map<String, Id>();
        for(RecordType rt : [SELECT Id, DeveloperName
                             FROM RecordType
                             WHERE DeveloperName='PUS_FR_Pickup_Contact' or  DeveloperName='PUS_FR_Point_non_Suivi_par_le_CO' OR DeveloperName = 'PUS_FR_Consigne' OR DeveloperName = 'PUS_FR_Point_non_Suivi_par_le_CO' OR DeveloperName = 'PUS_FR_PUDO_Suivi_CO'])
        {
            mapRecordTypeDevNameToId.put(rt.DeveloperName, rt.Id);
        }
        
        Id PUS_FR_Pickup_Contact = mapRecordTypeDevNameToId.get('PUS_FR_Pickup_Contact');
       
        Account newaccount = Utils_TestMethods.CreateAccount(c,m1, 'a2');
		newaccount.Operateur_Global__c = 'PUS_FR';
        insert newaccount;

        Test.startTest();
        Anomalie__c newa=new Anomalie__c();
        newa.Name='newatest';
        newa.PUDO__c=newaccount.id;
        newa.Statut__c='0';
        newa.Type__c='SyncPudo';
        insert newa;

        Case newcas = Utils_TestMethods.createRequete('1', m1.id);
        newcas.AccountId = newaccount.Id;
        newcas.Anomalie__c = newa.id;
        //cas.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PUS_FR_Indisponibilité PB PDA Synchro').getRecordTypeId();
        insert newcas;
        
        Batch09_CaseType_AnomSync batchAnomSync = new Batch09_CaseType_AnomSync();
        Database.executeBatch(batchAnomSync); 
        test.stopTest();
        List<Case> CaseList = [select id,OwnerId from Case where  id =: newcas.id];
        for(Case currentcas:CaseList)
        {
          system.assertEquals(Label.FileGestMat_ID_FR, currentcas.OwnerId);
        }
    }
}