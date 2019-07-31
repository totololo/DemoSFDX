/*
* Author : gho
* Schedule to call Batch06_AccountCongeIndispo daily at mid-night
* Lot size : 50 
*/
global class Schedule_Batch03_Account implements Schedulable {
    global void execute(SchedulableContext sc) { 
        Batch06_AccountCongeIndispo accountBatch = new Batch06_AccountCongeIndispo();
        database.executeBatch(accountBatch,50);
    } 
}