/*
* @description	: Scheduler for batch "Batch09_CaseType_AnomSync"
* @author		: TMAEITL FEK & MJE
* @test class	: Schedule_Batch09_CaseType_AnomSync_Test 100%
**/
global class Schedule_Batch09_CaseType_AnomSync implements Schedulable {
    global String cronExpression = '0 0 6 1/1 * ? *';				//Chaque jour à 6:00 heure du matin
    global String Description = 'Batch pour faire la maj de l\'état et le propriétaire d\'une requête anomalie de synchro après 3 jours. ref: ANOM_PB_01_Telecollecte';

    global void execute(SchedulableContext sc) {  
        database.executeBatch(new Batch09_CaseType_AnomSync(), 50);
    } 
}