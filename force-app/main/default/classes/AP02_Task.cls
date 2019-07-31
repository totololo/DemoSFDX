/*
* Author: John Boutros
* Modified By: -
* Date : 30/04/2018
* 
* Test classe: AP02_Task_Test
Coverage : 100%
*/
public class AP02_Task {
    public static void showCaseOnLV(List<Task> newTasks, Map<Id, Task> oldTasks)
    {
        Map<String, Date> mapCaseIDTaskDate = new Map<String, Date>();
        // looping over inserted/updated tasks and putting their ID's in a set
        for(Task recordTask : newTasks)
        {
            //if updating
            if(oldTasks!= null && oldTasks.ContainsKey(recordTask.Id))
            {
                if(oldTasks.get(recordTask.Id).ActivityDate != recordTask.ActivityDate)
                {
                    mapCaseIDTaskDate.put(recordTask.whatid,  + recordTask.ActivityDate);
                }
            }
            // if inserting
            else
            {
                mapCaseIDTaskDate.put(recordTask.whatid,  + recordTask.ActivityDate);
            }
        }
        //List of Recordtypes DA 
        List<String> listIDsDA = new List<String>();
        //List of Recordtypes TM
        List<String> listIDsTM = new List<String>();
        //Looping over MDT
        for(Association_Record_Type_et_pays__mdt associationRTPays: [Select Id,MasterLabel, ID_DemarrageActivite__c, ID_TicketManager__c
                                                                     FROM Association_Record_Type_et_pays__mdt])
        {
            //Adding RT DA and RT TM in lists
            listIDsDA.add(associationRTPays.ID_DemarrageActivite__c);
            listIDsTM.add(associationRTPays.ID_TicketManager__c);
        }
        /*List<Case>  retrievedCasesList= [Select id, Date_de_rappel_planifiee__c, Point_relais_ne_repond_pas__c, account.shippingCountry
From Case
Where ID in :mapCaseIDTaskDate.keyset()
AND recordtypeID not in : Label.RT_Ticket_Manager.split(';')
AND recordtypeID not in : Label.RT_DA_Requete.split(';')];*/
        system.debug('AP02_Task mapCaseIDTaskDate '  +mapCaseIDTaskDate);
        system.debug('AP02_Task listIDsDA '  +listIDsDA);
        system.debug('AP02_Task listIDsTM '  +listIDsTM);
        List<Case>  retrievedCasesList= [Select id, Date_de_rappel_planifiee__c, Point_relais_ne_repond_pas__c, 
                                         account.shippingCountry
                                         From Case
                                         Where ID in :mapCaseIDTaskDate.keyset()
                                         AND recordtypeID not in : listIDsDA
                                         AND recordtypeID not in : listIDsTM];
        system.debug('AP02_Task retrievedCasesList '  +retrievedCasesList);
        List<Case> listCasesToUpdate = new List<Case> ();
        for(Case caseTopUpdate : retrievedCasesList)
        {
            system.debug('AP02_Task mapCaseIDTaskDate.get(caseTopUpdate.id) ' + mapCaseIDTaskDate.get(caseTopUpdate.id));
            system.debug('AP02_Task caseTopUpdate.account.shippingCountry ' + caseTopUpdate.account.shippingCountry);
            if(mapCaseIDTaskDate.get(caseTopUpdate.id) != null && caseTopUpdate.account.shippingCountry != 'France')
            {
                caseTopUpdate.Date_de_rappel_planifiee__c = mapCaseIDTaskDate.get(caseTopUpdate.id);
                caseTopUpdate.Point_relais_ne_repond_pas__c = false;
                listCasesToUpdate.add(caseTopUpdate);
            }
        }
        if(listCasesToUpdate.size() > 0)
        {
            update listCasesToUpdate;
        }
    }
}