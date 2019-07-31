/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: MAJ si un email est envoyé depuis le compte rendu rempli
History
2018-06-07  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

public class AP03_Task {
    
    public static void CheckCRREmailSent(List<Task> TasksList){
        
        List<Id> WhatIdsList = new List<Id>();
        
        for(Task task : TasksList){
            if (task.TaskSubtype == 'Email' && task.WhatId.getSObjectType() == Compte_rendu_rempli__c.sObjectType){
                WhatIdsList.add(task.WhatId);
            }
        }
        
        List<Compte_rendu_rempli__c> CRRList = [SELECT Id, Envoi_email__c 
                                                FROM Compte_rendu_rempli__c 
                                                WHERE Id IN :WhatIdsList];
        System.debug('CRRList: ' + CRRList);
        
        for(Compte_rendu_rempli__c CRR : CRRList){        
            CRR.Envoi_email__c = true;
        }
        
        if(CRRList.size()>0){
            try{update CRRList;} catch(DMLException ex){system.debug(ex.getMessage());}
        }
        
    }

}