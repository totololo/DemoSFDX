/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: Trigger on compte rendu after update
History
2018-06-08  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

trigger CompteRenduRempliAfterUpdate on Compte_rendu_rempli__c (after update) {
    
    if(PAD.canTrigger('AP01_CompteRenduRempli')){
        
        Set<Id> CCRIds = new Set<Id>();      
        Map<Id, Compte_rendu_rempli__c> oldCRRMap = new Map<Id, Compte_rendu_rempli__c>();
        for(Compte_rendu_rempli__c CRR : trigger.new){
            system.debug('*** Update CRR.Statut__c: '+CRR.Statut__c);
            if(CRR.Statut__c != trigger.oldMap.get(CRR.Id).Statut__c && CRR.Statut__c == Label.VAVAP_statutTermine){
                CCRIds.add(CRR.Id);
                oldCRRMap.put(CRR.Id, trigger.oldMap.get(CRR.Id));
            }
        }        
        if(CCRIds.size()>0){
            AP01_CompteRenduRempli.UpdateMPifCRRTermine(CCRIds, oldCRRMap);
        }
    }
    
}