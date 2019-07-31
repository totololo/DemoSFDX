@istest
public class Schedule_Batch11_ScheduleDACases_TEST {
    static testMethod void testSchedule() {
        Test.startTest();
        //Execute Schedule_Batch11_ScheduleDACases
        Schedule_Batch11_ScheduleDACases sbTest = new Schedule_Batch11_ScheduleDACases();
        String schTest = '0 00 4 ? * *';
        system.schedule('Case DA', schTest, sbTest);
        Test.stopTest();
    }
}