@isTest
public class Schedule_Batch03_Account_Test {
    
    static testMethod void testSchedule() {
        Test.startTest();
        Schedule_Batch03_Account sb = new Schedule_Batch03_Account();
        String sch = '0 0 0 1/1 * ? *';
        system.schedule('Batch To Manage Accounts CongeIndispo Information', sch, sb);
        Test.stopTest(); 
    }
}