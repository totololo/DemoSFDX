/**
* @author John Boutros
* @date 3/20/2019
* @description Scheduler that runs every day at 4 A.M to update cases 
* in order to make them visible in list view 'mes requêtes en cours'
*/
global class Schedule_Batch11_ScheduleDACases implements Schedulable{
    /**
	* @author John Boutros
	* @date 3/20/2019
	* @description Scheduler execute method that executes Batch11_ScheduleDACases
	* Ticket 144210
	* @param SchedulableContext
	* @return None
	*/
    global void execute(SchedulableContext sc) {
        Batch11_ScheduleDACases batchCases = new Batch11_ScheduleDACases();
        database.executebatch(batchCases, 200);
    }
}