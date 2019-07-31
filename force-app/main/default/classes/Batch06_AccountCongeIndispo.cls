/*
* Author : gho
* Test Class : Batch06_AccountCongeIndispo_Test
* Daily Batch called by the schedule : Schedule_Batch03_Account
* Runs at mid-night and iterate through all accounts and modify their disponibilities
* Fields : Conge en cours , Indispo en cours, dispo en cours 
* Tech Fields Updated : Tech_date_debut_conge_en_cours__c , Tech_date_fin_conge_en_cours__c ...
* Lot size : 50 
*/
global class Batch06_AccountCongeIndispo implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        UpdateUser(true, Label.BatchBypass);
        
        // iterate through all accounts because Account's dispo changes on a daily basis
        String query =  'Select Id , Name , Tech_date_debut_conge_en_cours__c , Tech_date_fin_conge_en_cours__c , ' + 
           			    'Tech_date_debut_conge_a_venir__c , Tech_date_fin_conge_a_venir__c , '+
            			'Tech_date_debut_disp_a_venir__c , Tech_date_fin_disp_a_venir__c , '+
            		    'Tech_date_debut_indisp_en_cours__c , Tech_date_fin_indisp_en_cours__c ' + 
            		    'From Account';
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC , List<sObject> scope) {
        AP10_Account.updateAccountCongeIndispoInformation(scope); 
    }
    
    
    global void finish(Database.BatchableContext BC){
        UpdateUser(false, '');
    }
    
    private void UpdateUser(Boolean BypassworkflowProcessVR,String BypassTrigger){
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassWorkflow__c, BypassApex__c, BypassValidationRule__c
                           from User
                           where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = BypassworkflowProcessVR;
        currentUser.BypassWorkflow__c = BypassworkflowProcessVR;
        currentUser.BypassValidationRule__c = BypassworkflowProcessVR;
        currentUser.BypassApex__c = BypassTrigger;
        update currentUser;
    }
}