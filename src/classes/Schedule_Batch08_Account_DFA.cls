/**
 * @author		: TMAEITL FEK
 * @Description	: Schedule pour le batch Batch08_Account_DFA
 * @Test Class	: Schedule_Batch08_Account_DFA_Test
 */
global class Schedule_Batch08_Account_DFA implements Schedulable {
    global String cronExpression = '0 0 1 1/1 * ? *';				//Chaque jour à 1:00 heure du matin
    global String Description = 'Batch pour changer l\'état et le mode d\'un PUDO en fonction de sa date de fin d\'activité';
    
	global void execute(SchedulableContext sc) {  
        database.executeBatch(new Batch08_Account_DFA(), 50);
    } 
}