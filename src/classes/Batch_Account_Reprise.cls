/**
 * @author		: TMAEIL AHA
 * @Description	: Batch to replace Process Builders 'PB07 - Changement Etat/Mode 6-7', 'CONS_PB01_Date_FDA_renseignee' and 'PUDO_PB14_Retour_EtatMode'
 * @Test Class	: Batch_Account_Reprise_Test
 */

global class Batch_Account_Reprise implements Database.Batchable<sObject>{
    string query;


    global Batch_Account_Reprise(){
        
        query = 'SELECT Id, RecordTypeId, Date_de_fin_d_activite__c, Contexte__c, Etat__c, Mode__c, En_attente_de_courrier__c'
            + ' FROM Account'
            + ' WHERE Date_de_fin_d_activite__c <> NULL';    
    }
    
     global Batch_Account_Reprise(String id){
        query = 'SELECT Id, RecordTypeId, Date_de_fin_d_activite__c, Contexte__c, Etat__c, Mode__c, En_attente_de_courrier__c'
            + ' FROM Account'
            + ' WHERE Date_de_fin_d_activite__c <> NULL'
            + ' AND Id=\'' + id + '\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //TODO: needs bypass?
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
    	AP11_Account.changerEtatModeSelonDFA(scope); 
    }
    
    global void finish(Database.BatchableContext BC){
    }
}