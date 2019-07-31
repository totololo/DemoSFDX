/**
* @author John Boutros
* @date 3/20/2019
* @description Batch that runs every day at 4 A.M to update cases 
* in order to make them visible in list view 'mes requêtes en cours'
*/
global class Batch11_ScheduleDACases implements Database.Batchable<sObject>{
    String queryDAInter = '';
    String casesIDLabel = Label.RT_DA_Requete.replace(';', '\',\'' );
    /**
	* @author John Boutros
	* @date 3/20/2019
	* @description Scheduler start method that queries INTER DA cases that has a call scheduled 
	* Ticket 144210
	* @param SchedulableContext
	* @return None
	*/
    global Batch11_ScheduleDACases ()
    {
        queryDAInter = 'SELECT id, Date_de_rappel_planifiee__c, Traitement_interrompu__c, Planifier_un_rappel__c ' +
            'FROM Case '+
            'WHERE RecordtypeID in (\'' + casesIDLabel + '\') ' +
            'AND Account.shippingcountry != \'France\' ' +
            'AND Date_de_rappel_planifiee__c != null'; 
    }
    global Batch11_ScheduleDACases (ID idCase)
    {
        queryDAInter = 'SELECT id, Date_de_rappel_planifiee__c, Traitement_interrompu__c, Planifier_un_rappel__c ' +
            'FROM Case '+
            'WHERE RecordtypeID in (\'' + casesIDLabel + '\') ' +
            'AND Account.shippingcountry != \'France\' ' +
            'AND Date_de_rappel_planifiee__c != null '+
            'AND Id=\'' + idCase + '\'';
    }
    /**
	* @author John Boutros
	* @date 3/20/2019
	* @description Scheduler start method that queries INTER DA cases that has a call scheduled 
	* Ticket 144210
	* @param SchedulableContext
	* @return None
	*/
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(queryDAInter);
    }
    
	/**
	* @author John Boutros
	* @date 3/20/2019
	* @description Scheduler execute method that queries INTER DA cases that has a call scheduled 
	* Ticket 144210
	* @param SchedulableContext
	* @return None
	*/
    global void execute(Database.BatchableContext BC, List<Case> scopeCasesListCasesList){
        List<Case> daCasesList = new List<Case>();
        for(Case caseFiltered : scopeCasesListCasesList){
            System.debug('Batch11_ScheduleDACases caseFiltered ' + caseFiltered);            
            if(caseFiltered.Date_de_rappel_planifiee__c == system.today()){
                caseFiltered.Traitement_interrompu__c= false;
                caseFiltered.Planifier_un_rappel__c= false;
                caseFiltered.Date_de_rappel_planifiee__c = null;
                caseFiltered.Point_relais_ne_repond_pas__c = false;
                daCasesList.add(caseFiltered);
            }
        }
        System.debug('Batch11_ScheduleDACases daCasesList '+daCasesList);
        if(daCasesList.size() > 0) {
            Database.SaveResult[] srList = Database.update(daCasesList,false);
            List<Batch_Log__c> batchLogsList = new List<Batch_Log__c>();
            for (Integer i = 0; i < daCasesList.size(); i++) {
                Database.SaveResult sr = srList[i];
                Case origRecord = daCasesList[i];
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        batchLogsList.add(new Batch_log__c(Status_Code__c = '' + err.getStatusCode(),Message__c = err.getMessage(),Fields__c = '' + err.getFields(),ID__c = origRecord.Id));
                    }
                }
            }
            if(batchLogsList.size() > 0){
                insert batchLogsList;
            }
        }
    }
    
	/**
	* @author John Boutros
	* @date 3/20/2019
	* @description Scheduler finish method that checks if job is Done succesfully
	* Ticket 144210
	* @param SchedulableContext
	* @return None
	*/
    global void finish(Database.BatchableContext BC){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
        System.debug('Batch11_ScheduleDACases  >>>> finish ' + job.Status);
    }
    
}