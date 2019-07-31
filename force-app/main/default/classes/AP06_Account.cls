/*
* The aim of this class is to create/close case if the criteria of the contract is not respected
* @author: Christine Bayssary
* @date: 02/05/2018
* @Test: AP06_Account_Test
*/
public class AP06_Account {
    
    /*--------------------------------------------------------------------------------------------------------------------------
      Author: Christine Bayssary
      Company: EI-technologies
      Description: Close case if the conditions of the contract are met
      Creation of case if the conditions of the contract are not met
      Inputs: list of modified accounts & map of the old values of the account
      Returns: -
    --------------------------------------------------------------------------------------------------------------------------*/
    public static void createCaseUpdate(list<account> listAccounts,map<id,account> mapOldAccount){
        Set<ID> casesRecordTypeIDs = new Set<Id>();
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel, ID_Requete_ContratNonRespecte__c 
                                                                            FROM Association_Record_Type_et_pays__mdt];
        system.debug('AP06_Account associationRTPays ' + associationRTPays);
        Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPays =  new Map<String,Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPays)
        {
            mapassociationRTPays.put(mdtRecord.MasterLabel, mdtRecord);
            if (mdtRecord.ID_Requete_ContratNonRespecte__c  != null)
            {                
                casesRecordTypeIDs.add(mdtRecord.ID_Requete_ContratNonRespecte__c );
            }
        }
        system.debug('AP06_Account casesRecordTypeIDs ' + casesRecordTypeIDs);
        list<id> listAccountIds = new list<id>();
        for(account acc : listAccounts){
            listAccountIds.add(acc.id);   
        }
        system.debug('AP06_Account listAccountIds ' + listAccountIds);
        list<case> listRequetCreation = new list<case>();
        map<id,account> mapCase = new map<id,account>([select id,name,(select id,subject,status  
                                                                       from cases
                                                                       where status <> :label.Requete_Terminee//= :label.Requette_En_attente_de_traitement
                                                                       /*and (Subject= :label.Requete_ObjetContratNonRespecte
                                                                            OR Subject = :label.Requete_HoraireInsuffisantsDuRelais)*/
                                                                       and recordtypeId in:casesRecordTypeIDs)
                                                       from account 
                                                       where id in:listAccountIds]);
        system.debug('AP06_Account mapCase ' + mapCase);
        system.debug('AP06_Account listAccounts ' + listAccounts);
        for(account account: listAccounts){
        system.debug('AP06_Account mapCase.get(account.id).cases.size() ' + mapCase.get(account.id).cases.size());
            if(account.ShippingCountry !='' && account.ShippingCountry != null){
                system.debug('AP06_Account 0');
                //BNL+Hungary
                if((account.Seuil_de_l_amplitude_horaire_respect__c .contains('Red') 
                    || account.Heure_fermeture_minimale_respectee__c .contains('Red') 
                    || account.Heure_ouverture_minimale_respect_e__c .contains('Red') 
                    || account.Duree_pause_dejeuner_respectee__c .contains('Red')
                    || (label.Pudo_ActiviteCommerciale.contains(';'+account.Activite_commerciale_principale__c+';')))
                   && mapCase.get(account.id).cases.size()==0
                   && (account.etat__c == '4' || account.etat__c == '5' || account.etat__c=='6')
                   && account.ShippingCountry != 'France'){
                       system.debug('AP06_Account 1');
                       case requete = new case();
                       requete.Subject=label.Requete_ObjetContratNonRespecte;
                       requete.Status = label.Requette_En_attente_de_traitement;
                       Association_Record_Type_et_pays__mdt temp_Association_R = mapassociationRTPays.get(account.ShippingCountry);
                       requete.RecordTypeId = temp_Association_R.ID_Requete_ContratNonRespecte__c;
                       requete.AccountId = account.id;
                       requete.ContactId = account.Contact_operationnel_1__c;
                       requete.Object_de_la_requete__c = 'Les relais actifs avec terme contrat non respecté';
                       listRequetCreation.add(requete);
                   }
                //France
                else if(mapCase.get(account.id).cases.size()==0
                        && (account.etat__c == '4' || account.etat__c == '5')
                        &&(account.Amplitude_horaire_du_relais__c < 35
                          /* || account.Heure_fermeture_minimale_respectee__c .contains('Red') 
                           || account.Heure_ouverture_minimale_respect_e__c .contains('Red') 
                           || account.Duree_pause_dejeuner_respectee__c .contains('Red')
                           || account.Heure_ouverture_matinee__c.contains('Red')*/)
                        && account.ShippingCountry == 'France'
                        && account.Type == '2'){
                            system.debug('AP06_Account 2');
                            case requete = new case();
                            requete.Subject= Label.Requete_HoraireInsuffisantsDuRelais;
                            requete.Status = '0';
                            Association_Record_Type_et_pays__mdt temp_Association_R = mapassociationRTPays.get(account.ShippingCountry);
                            requete.RecordTypeId = temp_Association_R.ID_Requete_ContratNonRespecte__c;
                            requete.AccountId = account.id;
                            requete.ContactId = account.Contact_operationnel_1__c;
                            requete.Object_de_la_requete__c = 'Les horaires insuffisants du relais';
                            requete.OwnerId = label.FileGestionContractuelle;
                            listRequetCreation.add(requete);
                            system.debug('AP06_Account listRequetCreation ' + listRequetCreation);
                        }
                else  if(account.Seuil_de_l_amplitude_horaire_respect__c .contains('Green')
                         && account.Heure_fermeture_minimale_respectee__c .contains('Green')
                         && account.Heure_ouverture_minimale_respect_e__c .contains('Green')
                         && account.Duree_pause_dejeuner_respectee__c .contains('Green')
                         && !label.Pudo_ActiviteCommerciale.contains(';'+account.Activite_commerciale_principale__c+';')
                         && account.ShippingCountry == 'France'
                         && mapCase.get(account.id).cases.size()>0)
                {
                    system.debug('AP06_Account 3');
                    list<case> listCases = mapCase.get(account.id).cases;
                    for(case requete : listCases){
                        requete.Status = label.Requete_Terminee;  
                        listRequetCreation.add(requete);
                    }      
                }
                else  if(account.Seuil_de_l_amplitude_horaire_respect__c .contains('Green')
                         && account.Heure_fermeture_minimale_respectee__c .contains('Green')
                         && account.Heure_ouverture_minimale_respect_e__c .contains('Green')
                         && account.Duree_pause_dejeuner_respectee__c .contains('Green')
                         && account.Heure_ouverture_matinee__c.contains('Green')
                         && account.ShippingCountry != 'France'
                         && mapCase.get(account.id).cases.size()>0)
                {
                    system.debug('AP06_Account 4');
                    list<case> listCases = mapCase.get(account.id).cases;
                    for(case requete : listCases){
                        requete.Status = label.Requete_Terminee;  
                        listRequetCreation.add(requete);
                    }      
                }
            }
            else if(account.ShippingCountry =='' || account.ShippingCountry == null)
            {
                account.addError(Label.Message_No_Shipping_Country);
            }}
        upsert listRequetCreation;
        system.debug('AP06_Account listRequetCreation ' + listRequetCreation);
    }
}