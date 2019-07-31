global class Schedule_Bacth02_Account implements Schedulable { 
    global void execute(SchedulableContext sc) {  
        Batch02_Account accountBatch = new Batch02_Account();
        database.executeBatch(accountBatch,Integer.valueOf(Label.Lot_Batch06_AccountCongeIndispo));
    } 
}