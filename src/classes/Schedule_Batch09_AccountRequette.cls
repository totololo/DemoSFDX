global class Schedule_Batch09_AccountRequette implements Schedulable { 
    global void execute(SchedulableContext sc) { 
        Batch09_AccountRequette accountCaseBatch = new Batch09_AccountRequette();
        database.executeBatch(accountCaseBatch);
    } 
}