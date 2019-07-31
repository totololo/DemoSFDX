global class Batch01_Account implements Database.Batchable<sObject> {
    
    AP07_Conge_Indispo congeIndispo = null;
    String errorAccountIds = '';
    private Id congeRTypeId = Label.CongeRT_15;
    private Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    private Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    private Id dispoRTypeId = Label.DispoRT_15;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = ' Select Date_de_debut__c, Date_de_fin__c, Statut__c ,Nom_du_compte__c, RecordTypeId From Conge_Indispo__c  ' + 
            		   ' WHERE Statut__c = \'' + Label.CongeIndispo_En_Cours + '\' OR Statut__c = \'' + Label.CongeIndispo_A_Venir + '\'' +
            		   ' OR (Statut__c = \'' + Label.Conge_Indispo_Passe + '\' )' ; 
	    return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC , List<sObject> scope) {
        congeIndispo = new AP07_Conge_Indispo(); 
    	congeIndispo.updateAccountCongesIndispo(scope , null , true); 
    }
    
    global void finish(Database.BatchableContext BC){ 
       
    } 
}