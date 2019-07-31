@istest
public class Batch11_ScheduleDACases_TEST {
    static testMethod void runPositiveTestCases() {
        Test.startTest();
        Integer numberOfRecords = 40;        
        //Create Contacts
        List<Contact> contactsToInsertList = Utils_TestMethods.createMultipleContacts(numberOfRecords);
        insert contactsToInsertList;
        //Create Accounts
        List<Account> accountsToInsertList = Utils_TestMethods.createMultipleDAIntAccounts(contactsToInsertList.size(), contactsToInsertList);
        insert accountsToInsertList;
        //Create Macroprofils
        Macroprofil__c macroProfTest = Utils_TestMethods.createMacroprofil('Test Macro');
        insert macroProfTest;
        //Create Cases DA
        List<Case> casesToInsertList = Utils_TestMethods.createMultipleDAIntCases(accountsToInsertList.size(), macroProfTest, accountsToInsertList);
        system.debug('Batch11_ScheduleDACases_TEST casesToInsertList ' + casesToInsertList);
        insert casesToInsertList;
        //Update Cases DA Date_de_rappel_planifiee__c
        List<Case> casesToUpdateList = updateMultipleDAIntCases(casesToInsertList.size(), casesToInsertList);
        update casesToUpdateList;
        Set<ID> idCasesSet = new Set<ID>();
        for(Case caseUpdated: casesToUpdateList)
        {
            idCasesSet.add(caseUpdated.id);
        }
        //Execute Batch11_ScheduleDACases
        Database.executeBatch(new Batch11_ScheduleDACases(), 200);
        //Execute Batch11_ScheduleDACases for one record
        Database.executeBatch(new Batch11_ScheduleDACases(casesToUpdateList[0].id), 200);
        Test.stopTest();
        List<Case> caseDAAssertList = [Select id, Traitement_interrompu__c, Planifier_un_rappel__c, Date_de_rappel_planifiee__c
                                   From Case
                                   Where id in :idCasesSet];
        system.debug('Schedule_Batch11_ScheduleDACases_TEST caseDAAssertList ' + caseDAAssertList);
        system.assertEquals(caseDAAssertList.size(), numberOfRecords);
        system.assertEquals(caseDAAssertList[0].Traitement_interrompu__c, false);
        system.assertEquals(caseDAAssertList[0].Planifier_un_rappel__c, false);
        system.assertEquals(caseDAAssertList[0].Date_de_rappel_planifiee__c, null);
    }
    public static List<Case> updateMultipleDAIntCases(Integer numberOfCases, List<Case> casesInsertedList)
    {
        List<Case> caseListToUpdate = new List<Case>();
        for(Case caseToUpdate : casesInsertedList)
        {
            caseToUpdate.Traitement_interrompu__c= true;
            caseToUpdate.Planifier_un_rappel__c= true;
            caseToUpdate.Date_de_rappel_planifiee__c = system.today();
            caseListToUpdate.add(caseToUpdate);
        }
        return caseListToUpdate;
    }
}