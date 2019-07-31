/**
 * @author		: TMAEITL FEK & MJE
 * @Description	: Test class pour Schedule_Batch09_CaseType_AnomSync
 */
@isTest
public class Schedule_Batch09_CaseType_AnomSync_Test {
    
	static testMethod void testSchedule() {
        Test.startTest();
        Schedule_Batch09_CaseType_AnomSync sb = new Schedule_Batch09_CaseType_AnomSync();
        System.schedule(sb.Description + '_test', sb.cronExpression, sb);
        Test.stopTest();
    }
}