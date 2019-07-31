global class Schedule_Bacth01_Account implements Schedulable { 
    global void execute(SchedulableContext sc) { 
        Batch01_Account accountBatch = new Batch01_Account();
        database.executeBatch(accountBatch);
    } 
}