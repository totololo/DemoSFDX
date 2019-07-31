@isTest
public class Schedule_Bacth01_Account_Test {
    
    static testMethod void testSchedule() {
        Test.startTest();
        Schedule_Bacth01_Account sb = new Schedule_Bacth01_Account();
        String sch = '0 0 0 1/1 * ? *';
        system.schedule('Batch To Manage Accounts CongeIndispo Information', sch, sb);
        Test.stopTest();
        
    }
}