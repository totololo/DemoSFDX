/*
* Author : gho
* Class called from : Batch (Batch06_AccountCongeIndispo) and Triggers (Conge_Indispo__c --> after insert , update , delete)
* Check Conges for each account and modify its disponibilities fields
* exemple : If we add conge on an account for the current day the field conges_en_cours__c will be filled with Today
*/
public class AP10_Account { 
    
    // Conge Indispo Record Types
    static Id congeRTypeId = Label.CongeRT_15;
    static Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    static Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    static Id indispoStandardRTypeIdBNL = Label.RT_BNL_Indisponibilite_standard;
    static Id indispoPartnenaireRTypeIdBNL = Label.RT_BNL_Indisponibilit_partenaire;
    static Id dispoRTypeId = Label.DispoRT_15;
    
    // Map of each account with all its CongeIndispo
    private static Map<Id,List<Conge_Indispo__c>> mapAccountCongeIndispo = new Map<Id,List<Conge_Indispo__c>>();
    
    static List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_Converti__c
                                                                                 FROM Association_Record_Type_et_pays__mdt];
            
    
    //private static List<Account> lstAccountsToBeUpdated = new List<Account>();
    
    public static map<string, Association_Record_Type_et_pays__mdt> getAssociationRTPays(){
      map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
      for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
              associationRTPays.put(associationRT.MasterLabel, associationRT);
      }
       
        return associationRTPays;
    }
    
    
    private static void getCongeIndispoByAccount(List<Account> lstAcounts) {
        // This method gets all the CongeIndispo records for all the accounts
        // Records Concerned : Conge (en cours and a venir) , Indispo en cours and Dispo a venir
        for(Conge_Indispo__c congeIndispo : [Select id , date_de_debut__c , date_de_fin__c,Statut__c ,Nom_du_compte__c, RecordTypeId 
                                               From Conge_Indispo__c
                                               Where Nom_du_compte__c IN : lstAcounts AND (
                                                   RecordTypeId =: congeRTypeId
                                                   OR ((RecordTypeId =: indispoStandardRTypeId 
                                                      OR RecordTypeId =: indispoConsigneRTypeId 
                                                      OR RecordTypeId =: indispoStandardRTypeIdBNL 
                                                      OR RecordTypeId =: indispoPartnenaireRTypeIdBNL ) AND Statut__c =:  Label.CongeIndispo_En_Cours )
                                                 OR (RecordTypeId =: dispoRTypeId AND Statut__c =: Label.CongeIndispo_A_Venir)
                                             )]) {
                                                 if(!mapAccountCongeIndispo.containsKey(congeIndispo.Nom_du_compte__c)) {
                                                     mapAccountCongeIndispo.put(congeIndispo.Nom_du_compte__c, new List<Conge_Indispo__c>());
                                                 }
                                                 mapAccountCongeIndispo.get(congeIndispo.Nom_du_compte__c).add(congeIndispo);
                                             }
    } 
    
    public static void updateAccountCongeIndispoInformation(List<Account> lstAccounts) { 
        getCongeIndispoByAccount(lstAccounts);       
        Conge_Indispo__c congeAvenir;
        Conge_Indispo__c dispoAVenir; 
        boolean bCongeEnCoursAssigned;
        boolean bIndispoEnCoursAssigned;
        for(Account compte : lstAccounts) { 
            if(mapAccountCongeIndispo.containsKey(compte.Id)) {
                congeAvenir = null;
                dispoAVenir = null; 
                bCongeEnCoursAssigned 	= false;
                bIndispoEnCoursAssigned = false;
                for(Conge_Indispo__c congeIndisp : mapAccountCongeIndispo.get(compte.Id)) {
                    if(congeIndisp.Statut__c == Label.CongeIndispo_En_Cours) {
                        if(congeIndisp.RecordTypeId == congeRTypeId) {
                            // conge en cours
                            bCongeEnCoursAssigned = true;
                            if(compte.Tech_date_debut_conge_en_cours__c != congeIndisp.Date_de_debut__c || compte.Tech_date_fin_conge_en_cours__c != congeIndisp.Date_de_fin__c){ 
                                compte.Tech_date_debut_conge_en_cours__c = congeIndisp.Date_de_debut__c;
                                compte.Tech_date_fin_conge_en_cours__c   = congeIndisp.Date_de_fin__c;
                                //lstAccountsToBeUpdated.add(compte);
                            }
                            
                        } else if(congeIndisp.RecordTypeId == indispoStandardRTypeId || congeIndisp.RecordTypeId == indispoConsigneRTypeId
                                  || congeIndisp.RecordTypeId == indispoStandardRTypeIdBNL || congeIndisp.RecordTypeId == indispoPartnenaireRTypeIdBNL) {
                            // indispo en cours 
                            bIndispoEnCoursAssigned = true;
                            if(compte.Tech_date_debut_indisp_en_cours__c != congeIndisp.Date_de_debut__c || compte.Tech_date_fin_indisp_en_cours__c != congeIndisp.Date_de_fin__c) {
                                compte.Tech_date_debut_indisp_en_cours__c = congeIndisp.Date_de_debut__c;
                                compte.Tech_date_fin_indisp_en_cours__c   = congeIndisp.Date_de_fin__c;
                                //lstAccountsToBeUpdated.add(compte);
                            }
                            
                        }
                    } else if(congeIndisp.Statut__c == Label.CongeIndispo_A_Venir) {
                        
                        // get the soonest conge or dispo
                        if(congeIndisp.RecordTypeId == congeRTypeId && (congeAvenir == null || congeIndisp.Date_de_debut__c < congeAvenir.Date_de_debut__c)){
                            // conge a venir
                            congeAvenir = congeIndisp;
                        } else if (congeIndisp.RecordTypeId == dispoRTypeId && (dispoAVenir == null || congeIndisp.Date_de_debut__c < dispoAVenir.Date_de_debut__c)){
                            // dispo a venir
                            dispoAVenir = congeIndisp;
                        }
                    }
                }
                
                if(!bCongeEnCoursAssigned) { 
                    // empty the conge en cours tech fields in case the account does not have any conge en cours but the tech fields are still filled for some reason
                    if(compte.Tech_date_debut_conge_en_cours__c != null || compte.Tech_date_fin_conge_en_cours__c != null) {
                        compte.Tech_date_debut_conge_en_cours__c = null;
                        compte.Tech_date_fin_conge_en_cours__c   = null;   
                        //lstAccountsToBeUpdated.add(compte);
                    } 
                }
                
                if(!bIndispoEnCoursAssigned) {
                    // empty the indispo en cours tech fields in case the account does not have any indispo en cours but the tech fields are still filled for some reason
                    if(compte.Tech_date_debut_indisp_en_cours__c != null || compte.Tech_date_fin_indisp_en_cours__c != null) {
                        compte.Tech_date_debut_indisp_en_cours__c = null;
                        compte.Tech_date_fin_indisp_en_cours__c = null; 
                        //lstAccountsToBeUpdated.add(compte);
                    }
                    
                }
                
                // Same for congeAvenir and DispoAVenir
                // We may face some cases (deleted by user with byPass for ex) where tech fields contains data but the actuel conge/Indispo is deleted
                if(congeAvenir != null) {
                    if( compte.Tech_date_debut_conge_a_venir__c != congeAvenir.Date_de_debut__c || compte.Tech_date_fin_conge_a_venir__c  != congeAvenir.Date_de_fin__c) {
                        compte.Tech_date_debut_conge_a_venir__c = congeAvenir.Date_de_debut__c;
                        compte.Tech_date_fin_conge_a_venir__c   = congeAvenir.Date_de_fin__c;
                        //lstAccountsToBeUpdated.add(compte);
                    }
                    
                } else {
                    if(compte.Tech_date_debut_conge_a_venir__c != null || compte.Tech_date_fin_conge_a_venir__c != null) {
                        compte.Tech_date_debut_conge_a_venir__c = null;
                        compte.Tech_date_fin_conge_a_venir__c   = null;
                        //lstAccountsToBeUpdated.add(compte);
                    } 
                }
                
                
                if(dispoAvenir != null) {
                    if (compte.Tech_date_debut_disp_a_venir__c != dispoAvenir.Date_de_debut__c || compte.Tech_date_fin_disp_a_venir__c != dispoAvenir.Date_de_fin__c) {
                        compte.Tech_date_debut_disp_a_venir__c = dispoAvenir.Date_de_debut__c;
                        compte.Tech_date_fin_disp_a_venir__c   = dispoAvenir.Date_de_fin__c;
                        //lstAccountsToBeUpdated.add(compte);
                    }
                    
                } else {
                    if(compte.Tech_date_debut_disp_a_venir__c != null || compte.Tech_date_fin_disp_a_venir__c != null) {
                        compte.Tech_date_debut_disp_a_venir__c = null;
                        compte.Tech_date_fin_disp_a_venir__c = null;
                        //lstAccountsToBeUpdated.add(compte);
                    }
                    
                }
                
            } else {
                // Check if the account had a CongeIndispo which was deleted by a user with byPass. Then the tech fields still contains values.
                //boolean bToUpdate = false;
                if(compte.Tech_date_debut_conge_en_cours__c != null) {
                    compte.Tech_date_debut_conge_en_cours__c = null;
                    compte.Tech_date_fin_conge_en_cours__c = null;
                    //bToUpdate = true; 
                }
                if(compte.Tech_date_debut_conge_a_venir__c != null) {
                    compte.Tech_date_debut_conge_a_venir__c = null;
                    compte.Tech_date_fin_conge_a_venir__c = null;
                    //bToUpdate = true; 
                }
                if(compte.Tech_date_debut_indisp_en_cours__c != null) {
                    compte.Tech_date_debut_indisp_en_cours__c = null;
                    compte.Tech_date_fin_indisp_en_cours__c = null;
                    //bToUpdate = true;
                    //lstAccountsToBeUpdated.add(compte);
                }
                //if(bToUpdate) {
                    //lstAccountsToBeUpdated.add(compte);
                //}
            }
        }
        
        if(lstAccounts.size() > 0) {
            Database.SaveResult[] srList = Database.update(lstAccounts,false);
            if(Label.is_Batch_Logs_Active == 'true'){
                List<Batch_Log__c> LBatchLogs = new List<Batch_Log__c>();
                //for (Database.SaveResult sr : srList) {
                for (Integer i = 0; i < lstAccounts.size(); i++) {
                    Database.SaveResult sr = srList[i];
                    Account origRecord = lstAccounts[i];
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            LBatchLogs.add(new Batch_log__c(Status_Code__c = '' + err.getStatusCode(),
                                                            Message__c = err.getMessage(),
                                                            Fields__c = '' + err.getFields(),
                                                            ID__c = origRecord.Id
                                                           ));
                        }
                    }
                }
                if(LBatchLogs.size() > 0){
                    insert LBatchLogs;
                }
            }
        }
        
    }
    
    public static void updateAccountCongeIndispoInformationFromTrigger(List<Conge_Indispo__c> lstCongeIndispo) {
        // This method is called from CongeIndispo Triggers (after insert/update/delete)
        Set<Id> setAccountIds = new Set<Id>();
        for(Conge_Indispo__c objConge : lstCongeIndispo) {
            if(objConge.Nom_du_compte__c!= null)
                setAccountIds.add(objConge.Nom_du_compte__c);
        }
        if(setAccountIds!= null && setAccountIds.size()>0){
            String query =  'Select Id , Name , Tech_date_debut_conge_en_cours__c , Tech_date_fin_conge_en_cours__c , ' + 
                'Tech_date_debut_conge_a_venir__c , Tech_date_fin_conge_a_venir__c , '+
                'Tech_date_debut_disp_a_venir__c , Tech_date_fin_disp_a_venir__c , '+
                'Tech_date_debut_indisp_en_cours__c , Tech_date_fin_indisp_en_cours__c ' + 
                'From Account where Id IN : setAccountIds';
            List<Account> lstAccounts = Database.query(query);
            if(lstAccounts!= null && lstAccounts.size()>0)
                updateAccountCongeIndispoInformation(lstAccounts);
        }
        
    }
    
}