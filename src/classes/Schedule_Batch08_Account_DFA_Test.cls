/**
 * @author		: TMAEITL FEK
 * @Description	: Test class pour Schedule_Batch08_Account_DFA_Test
 */
@isTest
public class Schedule_Batch08_Account_DFA_Test {
    
	static testMethod void testSchedule() {
        Test.startTest();
        Schedule_Batch08_Account_DFA sb = new Schedule_Batch08_Account_DFA();
        System.schedule(sb.Description + '_test', sb.cronExpression, sb);
        Test.stopTest();
    }
}