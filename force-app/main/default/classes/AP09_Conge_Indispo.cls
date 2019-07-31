/*
* The aim of this class is to create cases for unavailabilities
* @author: Christine Bayssary
* @date: 23/08/2018
* @Test: AP09_Conge_Indispo_Test
*/
public class AP09_Conge_Indispo {    
    /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
     Company: EI-technologies
     Description: Case creation for the unavailability
     Inputs: list of new unavailabilities
     Returns: -
    --------------------------------------------------------------------------------------------------------------------------*/    
    public static void createCase (list<Conge_Indispo__c> listIndispo){
        
        list<id> listIndispoSinistre = new list<id>();
        list<case> listCasestoInsert = new list<case>();
        list<id> listAccountIds = new list<id>();
        
        for(Conge_Indispo__c indispo : listIndispo){
            listAccountIds.add(indispo.Nom_du_compte__c);
        }
        
        map<id,account> mapAccount = new map<id,Account>([select id,Contact_operationnel_1__c
                                                            from account where id in:listAccountIds]);
        
                
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel,ID_Indisponibilite_standard__c,ID_Indisponibilite_PB_Op_STS__c,ID_WebHelpQueue__c,ID_Indisponibilite_PB_Op_Qualite__c,
                                                                                       ID_Indisponibilite_PB_PDA_Panne__c,ID_Indisponibilite_PB_PDA_Synchro__c,ID_Injoignable_Indisponible__c
                                                                             FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
           associationRTPays.put(associationRT.MasterLabel, associationRT);  
        }
        
        for(Conge_Indispo__c indispo : listIndispo){
            if(indispo.Type_d_indisponibilite__c  == '1' 
               && indispo.sous_type__c == 'Sinistre / Travaux / Santé'
               && indispo.date_de_debut__c != null
               && indispo.recordtypeId == associationRTPays.get('France').ID_Indisponibilite_standard__c) {
                   case requete = new case();
                   requete.AccountId = indispo.Nom_du_compte__c;
                   requete.ContactId = mapAccount.get(indispo.Nom_du_compte__c).Contact_operationnel_1__c;
                   requete.Indisponibilite__c = indispo.id;
                   requete.OwnerId = associationRTPays.get('France').ID_WebHelpQueue__c;
                   requete.Status = 'En attente de traitement';
                   requete.Object_de_la_requete__c = 'Indisponibilité Problème opérationnel Sinistre / Travaux / Santé';
                   requete.RecordTypeId = associationRTPays.get('France').ID_Indisponibilite_PB_Op_STS__c;
                   requete.Subject = Label.Subject_Case_STS;
                   listCasestoInsert.add(requete);
               }
            else if(indispo.Type_d_indisponibilite__c  == '2' 
                    && indispo.sous_type__c == 'Problème de synchronisation'
                    && indispo.date_de_debut__c != null
                    && indispo.recordtypeId == associationRTPays.get('France').ID_Indisponibilite_standard__c){
                        case requete = new case();
                        requete.AccountId = indispo.Nom_du_compte__c;
                        requete.ContactId = mapAccount.get(indispo.Nom_du_compte__c).Contact_operationnel_1__c;
                        requete.Indisponibilite__c = indispo.id;
                        requete.OwnerId = Label.FileGestMat_ID_FR;
                        requete.Status = '0';
                        requete.Object_de_la_requete__c = 'Indisponibilité Problème PDA / Problème de synchronisation';
                        requete.RecordTypeId = associationRTPays.get('France').ID_Indisponibilite_PB_PDA_Synchro__c;
                        requete.Subject = label.Subject_Case_Prob_Synchro;
                        listCasestoInsert.add(requete);
                    } 
            else if(indispo.Type_d_indisponibilite__c  == '2' 
                    && indispo.sous_type__c == 'Panne PDA'
                    && indispo.date_de_debut__c != null
                    && indispo.recordtypeId == associationRTPays.get('France').ID_Indisponibilite_standard__c){
                        case requete = new case();
                        requete.AccountId = indispo.Nom_du_compte__c;
                        requete.ContactId = mapAccount.get(indispo.Nom_du_compte__c).Contact_operationnel_1__c;
                        requete.Indisponibilite__c = indispo.id;
                        requete.OwnerId = Label.FileGestMat_ID_FR;
                        requete.Status = '0';
                        requete.Object_de_la_requete__c = 'Indisponibilité Problème PDA / Panne PDA';
                        requete.RecordTypeId = associationRTPays.get('France').ID_Indisponibilite_PB_PDA_Panne__c;
                        requete.Subject = label.Subject_Case_Panne_PDA;
                        listCasestoInsert.add(requete);
                    }
            else if(indispo.Type_d_indisponibilite__c  == '1' 
                    && indispo.sous_type__c == 'Injoignabilité'
                    && indispo.date_de_debut__c != null
                    && indispo.recordtypeId == associationRTPays.get('France').ID_Indisponibilite_standard__c){
                        case requete = new case();
                        requete.AccountId = indispo.Nom_du_compte__c;
                        requete.ContactId = mapAccount.get(indispo.Nom_du_compte__c).Contact_operationnel_1__c;
                        requete.Indisponibilite__c = indispo.id;
                        
                        if(indispo.Raison_d_appel__c == 'Anomalie de synchronisation' || indispo.Raison_d_appel__c == 'Indisponibilité problème PDA'){
                            requete.OwnerId = label.FileGestMat_ID_FR;
                            requete.Status = '0';}
                        else{
                        requete.OwnerId = associationRTPays.get('France').ID_WebHelpQueue__c;
                        requete.Status = 'En attente de traitement'; }
                        requete.Object_de_la_requete__c = 'Indisponibilité problème opérationnel - Injoignabilité';
                        requete.RecordTypeId = associationRTPays.get('France').ID_Injoignable_Indisponible__c;
                        requete.Subject = label.Subject_Case_Indispo_Injoignabilit;
                        listCasestoInsert.add(requete);
                    } 
        }
        insert listCasestoInsert;      
    }
}