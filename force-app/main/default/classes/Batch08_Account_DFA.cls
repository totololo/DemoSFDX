/**
 * @author		: TMAEITL FEK
 * @Description	: Batch to replace Process Builders 'PB07 - Changement Etat/Mode 6-7', 'CONS_PB01_Date_FDA_renseignee' and 'PUDO_PB14_Retour_EtatMode'
 * 				: Batch pour changer l'état et le mode d'un PUDO en fonction de sa date de fin d'activité
 * 				: Updates Etat__c, Mode__c, Contexte__c, En_attente_de_courrier__c on Object Account
 * @Test Class	: Batch_Account_Reprise_Test
 * @Scheduler	: Schedule_Batch08_Account_DFA
 */
global class Batch08_Account_DFA implements Database.Batchable<sObject>{
	string query;
    String today21;
    String today56;
    
    global Batch08_Account_DFA(){
        today21 = System.now().addDays(21).format('yyyy-MM-dd');
        today56 = System.now().addDays(56).format('yyyy-MM-dd');
        
        query = 'SELECT Id, RecordTypeId, Date_de_fin_d_activite__c, Contexte__c, Etat__c, Mode__c, En_attente_de_courrier__c'
            + ' FROM Account'
            + ' WHERE Date_de_fin_d_activite__c <> NULL '
            + ' AND( '
            + ' (Date_de_fin_d_activite__c = TODAY AND (Etat__c <> \'' + Label.Account_Etat_7 + '\' OR Mode__c <> \'' + Label.Account_Mode_Inactif + '\'))'
            + ' OR ((Date_de_fin_d_activite__c > TODAY AND Date_de_fin_d_activite__c <= ' + today21 + ') AND (Etat__c <> \'' + Label.Account_Etat_6 + '\''
            			+ ' OR (Mode__c <> \'' + Label.Account_Mode_ExclusionNonSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Exclusion + '\') OR (Mode__c <> \'' + Label.Account_Mode_ResiliationNonSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Resiliation + '\')))'
            + ' OR ((Date_de_fin_d_activite__c > ' + today21 + ' AND Date_de_fin_d_activite__c <= ' + today56 + ') AND (Etat__c <> \'' + Label.Account_Etat_6 + '\''
            			+ ' OR (Mode__c <> \'' + Label.Account_Mode_ExclusionSuggere + '\' AND Contexte__c =\' ' + Label.Account_Contexte_Exclusion + '\') OR (Mode__c <> \'' + Label.Account_Mode_ResiliationSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Resiliation + '\')))'
            + ' OR (Date_de_fin_d_activite__c > ' + today56 + ' AND Account.RecordTypeId = \'' + Label.AccountConsigneRT_15 + '\' AND (Etat__c <> \'' + Label.Account_Etat_6 + '\''
            			+ ' OR (Mode__c <> \'' + Label.Account_Mode_ExclusionSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Exclusion + '\') OR (Mode__c <> \'' + Label.Account_Mode_ResiliationSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Resiliation + '\')))'
            + ' ) ';
    }
    
    global Batch08_Account_DFA(String id){
        today21 = System.now().addDays(21).format('yyyy-MM-dd');
        today56 = System.now().addDays(56).format('yyyy-MM-dd');
        
        query = 'SELECT Id, RecordTypeId, Date_de_fin_d_activite__c, Contexte__c, Etat__c, Mode__c, En_attente_de_courrier__c'
            + ' FROM Account'
            + ' WHERE Date_de_fin_d_activite__c <> NULL '
            + ' AND( '
            + ' (Date_de_fin_d_activite__c = TODAY AND (Etat__c <> \'' + Label.Account_Etat_7 + '\' OR Mode__c <> \'' + Label.Account_Mode_Inactif + '\'))'
            + ' OR ((Date_de_fin_d_activite__c > TODAY AND Date_de_fin_d_activite__c <= ' + today21 + ') AND (Etat__c <> \'' + Label.Account_Etat_6 + '\''
            			+ ' OR (Mode__c <> \'' + Label.Account_Mode_ExclusionNonSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Exclusion + '\') OR (Mode__c <> \'' + Label.Account_Mode_ResiliationNonSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Resiliation + '\')))'
            + ' OR ((Date_de_fin_d_activite__c > ' + today21 + ' AND Date_de_fin_d_activite__c <= ' + today56 + ') AND (Etat__c <> \'' + Label.Account_Etat_6 + '\''
            			+ ' OR (Mode__c <> \'' + Label.Account_Mode_ExclusionSuggere + '\' AND Contexte__c =\' ' + Label.Account_Contexte_Exclusion + '\') OR (Mode__c <> \'' + Label.Account_Mode_ResiliationSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Resiliation + '\')))'
            + ' OR (Date_de_fin_d_activite__c > ' + today56 + ' AND Account.RecordTypeId = \'' + Label.AccountConsigneRT_15 + '\' AND (Etat__c <> \'' + Label.Account_Etat_6 + '\''
            			+ ' OR (Mode__c <> \'' + Label.Account_Mode_ExclusionSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Exclusion + '\') OR (Mode__c <> \'' + Label.Account_Mode_ResiliationSuggere + '\' AND Contexte__c = \'' + Label.Account_Contexte_Resiliation + '\')))'
            + ' ) '
            + ' AND Id=\'' + id + '\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //TODO: needs bypass?
        System.debug('query: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        if(scope.size() > 0){
            AP11_Account.changerEtatModeSelonDFA(scope); 
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}