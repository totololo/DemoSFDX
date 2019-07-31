/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: MAJ du MacroProfil du compte si le statut du compte rendu rempli est 'Terminé'
History
2018-06-08  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

public class AP01_CompteRenduRempli {
    
    public static void UpdateMPifCRRTermine(Set<Id> CRRIds, Map<Id, Compte_rendu_rempli__c> oldCRRMap){

        Map<Id, Account> AccountsToUpdate = new Map<Id, Account>();
        Map<Id, String> AccMPMap = new Map<Id, String>();
        Map<String, Id> MPNameIdMap = new Map<String, Id>();
        
        List<Compte_rendu_rempli__c> CRRList = [SELECT Id, Compte__c, compte__r.Macroprofil_actuel__c, compte__r.Hauteur_cm__c, compte__r.Largeur_cm__c, 
                                                compte__r.Profondeur_cm__c, compte__r.Nombre_detageres__c, compte__r.Seuil_contractuel__c,
                                                Hauteur__c, Largeur__c, Profondeur__c, Nombre_d_etageres__c, Seuil_contractuel__c,
                                                (SELECT id, Changement_macro_profil__c, Reponse__c FROM Reponses_CR__r)
                                                FROM Compte_rendu_rempli__c
                                                WHERE Id IN :CRRIds]; 
        system.debug('1*** CRRList: '+CRRList);
       system.debug('1*** oldCRRMap: '+oldCRRMap);
        for(Compte_rendu_rempli__c CRR : CRRList){
            
            Compte_rendu_rempli__c oldCRR;
            Account acc = new Account(Id = CRR.Compte__c);
            
            if(oldCRRMap != null && oldCRRMap.containsKey(CRR.Id)){ 
                oldCRR = oldCRRMap.get(CRR.Id);
            }
            //if(oldCRRMap == null || (oldCRRMap != null && CRR.Hauteur__c != oldCRRMap.get(CRR.Id).Hauteur__c)){ 
                acc.Hauteur_cm__c = CRR.Hauteur__c;
            //}
           // if(oldCRRMap == null || (oldCRRMap != null && CRR.Largeur__c != oldCRRMap.get(CRR.Id).Largeur__c)){ 
                acc.Largeur_cm__c = CRR.Largeur__c;
           // }
           // if(oldCRRMap == null || (oldCRRMap != null && CRR.Profondeur__c != oldCRRMap.get(CRR.Id).Profondeur__c)){ 
                acc.Profondeur_cm__c = CRR.Profondeur__c;
            //}
           // if(oldCRRMap == null || (oldCRRMap != null && CRR.Nombre_d_etageres__c != oldCRRMap.get(CRR.Id).Nombre_d_etageres__c)){ 
                acc.Nombre_detageres__c = CRR.Nombre_d_etageres__c;
            //}
           // if(oldCRRMap == null || (oldCRRMap != null && CRR.Seuil_contractuel__c != oldCRRMap.get(CRR.Id).Seuil_contractuel__c)){ 
                acc.Seuil_contractuel__c = CRR.Seuil_contractuel__c;
           // }
            
            System.debug('');
            for(Reponse_CR__c reponse : CRR.Reponses_CR__r){
                
               // if(reponse.Changement_macro_profil__c && reponse.Reponse__c != Label.VAVAP_Autre && !String.isBlank(reponse.Reponse__c)){
                       // AccMPMap.put(acc.Id, reponse.Reponse__c);
               // }
            }
            AccountsToUpdate.put(acc.Id, acc);
        }
 
        if(AccountsToUpdate.size()>0){
      
              update AccountsToUpdate.values();  
           
        }
    }
    
}