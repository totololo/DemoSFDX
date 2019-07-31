/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: Trigger on compte rendu after insert
History
2018-06-08  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

trigger CompteRenduRempliAfterInsert on Compte_rendu_rempli__c (after insert) {
    
    if(PAD.canTrigger('AP01_CompteRenduRempli')){
        
        Set<Id> CCRIds = new Set<Id>();        
        for(Compte_rendu_rempli__c CRR : trigger.new){
            system.debug('*** Inset CRR.Statut__c: '+CRR.Statut__c);
             if(CRR.Statut__c == Label.VAVAP_statutTermine){
                CCRIds.add(CRR.Id);
            }
        }
        if(CCRIds.size()>0){
                      
              AP01_CompteRenduRempli.UpdateMPifCRRTermine(CCRIds, null);
            
          
        }
    }

}