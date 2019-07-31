global class Schedule_Batch12_AccountCase implements Schedulable { 
    global void execute(SchedulableContext sc) { 
        Batch12_AccountCase accountCaseBatch = new Batch12_AccountCase();
        database.executeBatch(accountCaseBatch);
    } 
}