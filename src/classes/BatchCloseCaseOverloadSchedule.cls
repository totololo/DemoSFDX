/**
 * @author Gildas ADOUKONOU
 * @date 28/02/2019
 * @description : Scheduler for BatchDeleteAlert 
 */
global class BatchCloseCaseOverloadSchedule implements Schedulable { 
    global void execute(SchedulableContext sc) { 
        BatchCloseCaseOverload CaseOverloadBatch = new BatchCloseCaseOverload ();
        database.executeBatch(CaseOverloadBatch);
    }
}