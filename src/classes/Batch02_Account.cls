global class Batch02_Account implements Database.Batchable<sObject> {
    
    String soqlQuery = 'SELECT Id, Tech_Number_Closing_Hour__c , Tech_Number_End_Lunch_Hour__c , Tech_Number_Now__c , Tech_Number_Opening_Hour__c , Tech_Number_Start_Lunch_Hour__c ,' +
        			   'Mardi__c , Mardi_Ouverture__c , Mardi_Fermeture__c , mardi_debut_pause_dejeuner__c , mardi_fin_pause_dejeuner__c , ' +
        			   'Mercredi__c , Mercredi_Ouverture__c , Mercredi_Fermeture__c , Mercredi_debut_pause_dejeuner__c , Mercredi_fin_pause_dejeuner__c ,' +
        	           'Jeudi__c , Jeudi_Ouverture__c , Jeudi_Fermeture__c , Jeudi_debut_pause_dejeuner__c , Jeudi_fin_pause_dejeuner__c ,' +
        			   'Vendredi__c , Vendredi_Ouverture__c , Vendredi_Fermeture__c , Vendredi_debut_pause_dejeuner__c , Vendredi_fin_pause_dejeuner__c ,' +
        			   'Samedi__c , Samedi_Ouverture__c , Samedi_Fermeture__c , Samedi_debut_pause_dejeuner__c , Samedi_fin_pause_dejeuner__c ,' +
        			   'Dimanche__c , Dimanche_Ouverture__c , Dimanche_Fermeture__c , Dimanche_debut_pause_dejeuner__c , Dimanche_fin_pause_dejeuner__c ,' +
        			   'Lundi__c , Lundi_Ouverture__c , Lundi_Fermeture__c , Lundi_debut_pause_dejeuner__c , Lundi_fin_pause_dejeuner__c , ' +
        			   'Dimanche_ferme__c,Lundi_ferme__c,Mardi_ferme__c,Mercredi_ferme__c,Jeudi_ferme__c,Vendredi_ferme__c,Samedi_ferme__c, ' + 
        			   'Horaire_Ouverture_Reference__c,Horaire_Fermeture_Reference__c,Debut_pause_dejeuner__c,Fin_pause_dejeuner__c ' +
          			   'FROM Account';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        UpdateUser(true, Label.BatchBypass);
        return Database.getQueryLocator(soqlQuery);    
    }
    
    global void execute(Database.BatchableContext BC , List<sObject> scope) { 
        AP09_Account.defineAccountDailyDisponibility(scope, true); 
    }
     
    
    global void finish(Database.BatchableContext BC){ 
        UpdateUser(false, '');
        Database.executeBatch(new Batch06_AccountCongeIndispo(),Integer.valueOf(Label.Lot_Batch06_AccountCongeIndispo) );
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