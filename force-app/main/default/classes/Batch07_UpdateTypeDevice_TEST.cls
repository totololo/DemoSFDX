@isTest
public class Batch07_UpdateTypeDevice_TEST {
    public static testmethod void testBatchUpdateTypeDevice(){
        // Step 1 : Set Up
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        Account testAccount3 = new Account();
        insert testContact;
        system.debug('contact inserted testContact '+testContact);
        List<Account> accountsToAdd = new List<Account>();
        for(Integer i = 0; i < 4; i++)
        {
            testAccount3 = Utils_TestMethods.CreateAccount(testContact, null, 'Test Account');
            testAccount3.Type_de_device__c ='PDA Windows';
            accountsToAdd.add(testAccount3);
        }
        test.startTest();
        insert accountsToAdd;
        Batch07_UpdateTypeDevice updateTypeDev = new Batch07_UpdateTypeDevice();
        Database.QueryLocator ql = updateTypeDev.start(null);
        updateTypeDev.execute(null,accountsToAdd);
        updateTypeDev.Finish(null);
        test.stopTest();
        
        // Step 2 : Actual Test
        
        /*
        Id batchJobId = Database.executeBatch(new Batch07_UpdateTypeDevice(), 100);
        
        
        // Step 3 : Assert
        */
        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [Select count()
                                From Account 
                                Where Type_de_device_Selected__c = null]);
        
    }       
}