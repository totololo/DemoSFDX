/*
* @description	: Batch to update the status and the owner of a case with recordtype "Anomalie de synchronisation" after 3 days of its creation date if the status is not "Terminée"
* 				  Complément de la classe "AP01_AnomaliesPB"
* @author		: TMAEITL FEK & MJE
* @test class	: Batch09_CaseType_AnomSync_Test 93%
**/
global class Batch09_CaseType_AnomSync implements Database.Batchable<sObject> {
    String queryAnomalie = 'SELECT Id,pudo__r.ShippingCountry, (SELECT Id, Status, OwnerId,Operateur__c'
        + ' FROM Requ_tes__r'
        + ' WHERE Status <> \'Terminée\' '
        + ') '
        + ' FROM Anomalie__c ';
    
    public Batch09_CaseType_AnomSync(){
        if(!Test.isRunningTest()){ queryAnomalie+=' WHERE CreatedDate = LAST_N_DAYS:3 and CreatedDate < last_N_Days:2' ;
        }
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('Batch09_CaseType_AnomSync Starting...');
        return Database.getQueryLocator(queryAnomalie);
    }
    
    //prerequist	: the conditions in the query
    global void execute(Database.BatchableContext bc, List<Anomalie__c> LAnomalies){
        List<Case> LCases = new List<Case>();
        for(Anomalie__c an : LAnomalies){
            for(Case c : an.Requ_tes__r){
                if(an.pudo__r.ShippingCountry == 'France')
                {
                    c.OwnerId = Label.FileGestMat_ID_FR;//'00G580000016rF2';
                    c.Status = '0'; //En attente d'attribution
                    LCases.add(c);//00G6E000002Hk9JUAS
                }
            }
        }
        
        update LCases;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('Batch09_CaseType_AnomSync finished.');
    }
    
}