@istest
public class Schedule_Batch12_AccountCase_TEST{ 
    static testMethod void testSchedule() {
        Test.startTest();
        Schedule_Batch09_AccountRequette sb = new Schedule_Batch09_AccountRequette();
        String sch = '0 45 8 ? * *';
        system.schedule('Account Case', sch, sb);
        Test.stopTest();
    }
}