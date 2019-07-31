/**
 * @author Gildas ADOUKONOU
 * @date 28/02/2019
 * @description : Scheduler for BatchDeleteAlert 
 */
global class BatchCloseAlertSchedule implements Schedulable { 
    global void execute(SchedulableContext sc) { 
        BatchCloseAlert alertCloseBatch = new BatchCloseAlert ();
        database.executeBatch(alertCloseBatch);
    }
}