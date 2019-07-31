/*--------------------------------------------------------------------------
*Author: Chahid Khalil
*Company : EI Technologies Liban
*Description: Helper class for Conge_Indispo trigger (after insert and after update)
			  Case to status "Terminee" if criteria met
*Test Class: AP08_Conge_Indispo_Test
*Created Date: 30/04/2018
--------------------------------------------------------------------------*/
public class AP08_Conge_Indispo {
    
    public static void UpdateCase(List<Conge_Indispo__c> newConge_Indispo, map<id,Conge_Indispo__c> mapOldConge_Indispo){	
        set<Id> AccountIds = new set<Id>();
        Set<ID> congesRecordTypeIDs = new Set<Id>();
        List< Association_Record_Type_et_pays__mdt> associationRTPaysBNL = [Select Id, MasterLabel, ID_Requete_Conge__c
                                                                            FROM Association_Record_Type_et_pays__mdt];
        Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPaysBNL =  new Map<String,Association_Record_Type_et_pays__mdt>();
        
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPaysBNL)
        {
            mapassociationRTPaysBNL.put(mdtRecord.MasterLabel, mdtRecord);
            congesRecordTypeIDs.add(mdtRecord.ID_Requete_Conge__c);
        }
        for (Conge_Indispo__c current_Conge_Indispo : newConge_Indispo)
        {
            if (mapOldConge_Indispo != Null)//case update
            {
                Conge_Indispo__c OldConge_Indispo = mapOldConge_Indispo.get(current_Conge_Indispo.id);
                if(current_Conge_Indispo.TECH_Conges_Dispo_Juillet_Aout__c == true && 
                   OldConge_Indispo.TECH_Conges_Dispo_Juillet_Aout__c == false)
                {
                    AccountIds.add(current_Conge_Indispo.Nom_du_compte__c);
                }
            }
            else //case insert
            {
               if(current_Conge_Indispo.TECH_Conges_Dispo_Juillet_Aout__c == true  )
                {
                    AccountIds.add(current_Conge_Indispo.Nom_du_compte__c);
                } 
            }
        }
        List<Case> Cases = [SELECT id, status
                            FROM Case
                            WHERE AccountId in:AccountIds and
                            RecordTypeId in : congesRecordTypeIDs];
        for(case current_case : Cases) 
        {
            current_case.status = Label.Requete_Terminee;//no translation needed
        }  
        update Cases;
    }
    
}