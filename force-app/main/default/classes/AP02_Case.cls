/*--------------------------------------------------------------------------
* Author: Chahid Khalil
* Company : EI Technologies Liban
* Description: trigger before update Requete
* Test Class: AP02_Case_Test
* Created Date: 4/05/2018
--------------------------------------------------------------------------*/
public class AP02_Case {
    
    public static void ValidateCanCloseCase(List<Case> newCases, map<id,Case> mapOldCases)
    {  
        System.debug('JMB AP02_Case ValidateCanCloseCase mapOldCases ' + mapOldCases);
        System.debug('JMB AP02_Case ValidateCanCloseCase newCases ' + newCases);
        List< Association_Record_Type_et_pays__mdt> associationRTPaysBNL = [Select Id, MasterLabel, ID_Requete_ContratNonRespecte__c, ID_Requete_Conge__c 
                                                                            FROM Association_Record_Type_et_pays__mdt
                                                                            where MasterLabel <> 'France'];
        Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPaysBNL =  new Map<String,Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPaysBNL)
        {
            mapassociationRTPaysBNL.put(mdtRecord.MasterLabel, mdtRecord);           
        }
        
        List<Case> CaseListoUpdate = new List<Case>();
        Set<Id> AccountIds = new Set<Id>();
        set<id> setAnomalies = new set<id>();
        for (Case CurrentCase : newCases)
        {
            if (CurrentCase.Status  == Label.Requete_Terminee) //mapOldCases.get(CurrentCase.id).Status != Label.Requete_Terminee
            {
                AccountIds.add(CurrentCase.AccountId);
                setAnomalies.add(CurrentCase.Anomalie__c);
            }
        }
        
        Map<Id, Account> mapId_Account = new Map<Id, Account> ([SELECT Seuil_de_l_amplitude_horaire_respect__c, Heure_fermeture_minimale_respectee__c,
                                                                Heure_ouverture_minimale_respect_e__c, Duree_pause_dejeuner_respectee__c,Activite_commerciale_principale__c,ShippingCountry
                                                                FROM Account
                                                                WHERE Id in : AccountIds]);
        
        List<Conge_Indispo__c> Conge_IndispoList =[SELECT Nom_du_compte__c 
                                                   FROM Conge_Indispo__c 
                                                   WHERE Nom_du_compte__c in :AccountIds and
                                                   TECH_Conges_Dispo_Juillet_Aout__c = true];
        //Map containing Account with conge List
        Map<Id,List<Conge_Indispo__c>> MapAccount_Conge = new Map<Id,List<Conge_Indispo__c>>();
        for (Conge_Indispo__c ci : Conge_IndispoList)
        {
            if(!MapAccount_Conge.containsKey(ci.Nom_du_compte__c))
            {
                MapAccount_Conge.put(ci.Nom_du_compte__c, new List<Conge_Indispo__c>());
            }              
            MapAccount_Conge.get(ci.Nom_du_compte__c).add(ci);
        } 
        
        List<Anomalie__c > anomalieList = [SELECT  Statut__c , PUDO__c
                                           FROM Anomalie__c
                                           WHERE id in :setAnomalies 
                                           and Statut__c = '1'
                                           and Type__c <> :label.Anomalie_TypeSyncPudo];
        
        Map<id, Anomalie__c> mapAccount_Anomalie = new  Map<id, Anomalie__c>();
        for(Anomalie__c current_anomalie :anomalieList )
        {
            mapAccount_Anomalie.put(current_anomalie.PUDO__c, current_anomalie);  
        }
        for (Case CurrentCase : newCases)
        {
            Account tempAccount = mapId_Account.get(CurrentCase.AccountId);                           
            if (tempAccount != null){
                if(tempAccount.ShippingCountry != null && tempAccount.ShippingCountry!=''){
                    Association_Record_Type_et_pays__mdt temp_Association_R = mapassociationRTPaysBNL.get(tempAccount.ShippingCountry);
                    
                    system.debug('AP02_Case mapassociationRTPaysBNL ' + mapassociationRTPaysBNL);
                    if(temp_Association_R != null)
                    {
                        
                        if (((tempAccount.Seuil_de_l_amplitude_horaire_respect__c.contains('Red') || tempAccount.Heure_fermeture_minimale_respectee__c.contains('Red') ||tempAccount.Heure_ouverture_minimale_respect_e__c.contains('Red') || tempAccount.Duree_pause_dejeuner_respectee__c.contains('Red') 
                              || (tempAccount.Activite_commerciale_principale__c != null 
                                  && label.Pudo_ActiviteCommerciale.contains(';' + tempAccount.Activite_commerciale_principale__c + ';'))) 
                             && CurrentCase.RecordTypeId == temp_Association_R.ID_Requete_ContratNonRespecte__c)
                            || (!MapAccount_Conge.containsKey(CurrentCase.AccountId) && CurrentCase.RecordTypeId == temp_Association_R.ID_Requete_Conge__c) 
                            || mapAccount_Anomalie.containsKey(CurrentCase.AccountId) )
                            
                        {                    
                            CurrentCase.Status = Label.ReQuette_En_attente_de_traitement;
                            system.debug('AP02_Case status cannot be Closed!!!!!');
                        } 
                        
                    }
                }
                else{
                    tempAccount.addError(Label.Message_No_Shipping_Country); 
                } 
            }            
        }        
    }    
}