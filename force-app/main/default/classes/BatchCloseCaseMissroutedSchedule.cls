/**
 * @author Gildas ADOUKONOU
 * @date 28/02/2019
 * @description : Scheduler for BatchDeleteAlert 
 */
global class BatchCloseCaseMissroutedSchedule implements Schedulable { 
    global void execute(SchedulableContext sc) { 
        BatchCloseCaseMissRoutedPart CaseMissRoutedPartBatch = new BatchCloseCaseMissRoutedPart ();
        database.executeBatch(CaseMissRoutedPartBatch);
    }
}