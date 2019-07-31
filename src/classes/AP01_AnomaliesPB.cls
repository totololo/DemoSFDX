/*
* @Description	: Classe pour remplacer le process builder de l'anomalie (ANOM_PB_01_Telecollecte)
* 				  Crée de nouveaux requêtes ou des congés indispo selon les critères des anomalies
* @author		: TMAEITL FEK
* @Test Class	: 
* 
* 
* TODO : Create a batch for the planned actions
*/
public class AP01_AnomaliesPB {
    
    public static void ANOM_PB_01_Telecollecte(List<Anomalie__c> LAnomalies){
        list<Id> listIDs = new list<Id>();
        list<Id> listAccountIDs = new list<Id>();
        for(Anomalie__c a:LAnomalies){
            listIDs.add(a.Id);
            listAccountIDs.add(a.PUDO__c);
        }
        ANOM_PB_01_Telecollecte(listIDs, listAccountIDs);
    }
    
    public static void ANOM_PB_01_Telecollecte(List<Id> LAnomalies,List<Id> listAccountIDs){
        List<Case> LCasesToInsert = new List<Case>();
        List<Case> LCasesToInsert1 = new List<Case>();
        List<Case> LCasesToUpdate = new List<Case>();        
        List<Conge_Indispo__c> LCongesIndispoToInsert = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> LCongesIndispoToUpdate = new List<Conge_Indispo__c>();
        
        List< Association_Record_Type_et_pays__mdt> associationRTPaysBNL = [Select Id, MasterLabel, ID_AnomalieSynchro__c, ID_ManagerQueue__c, ID_WebHelpQueue__c,ID_Indisponibilite_standard__c,ID_Indisponibilit_partenaire__c,ID_MoyenScan_Actif_Sans__c,ID_File_service_line__c 
                                                                            FROM Association_Record_Type_et_pays__mdt];
        Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPaysBNL =  new Map<String,Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPaysBNL)
        {
            mapassociationRTPaysBNL.put(mdtRecord.MasterLabel, mdtRecord);
        }
        List<Anomalie__c> LAnomaliesWDetails = [SELECT Id, Type__c, Statut__c, Description__c,Tech_ContactPudo__c, PUDO__c,PUDO__r.type, PUDO__r.Contact_operationnel_1__c, PUDO__r.RecordType.DeveloperName,PUDO__r.ShippingCountry,                                                
                                                (SELECT Id, Status FROM Requ_tes__r),
                                                (SELECT Id, Date_de_fin__c FROM Cong_s_disponibilit_s_indisponibilit_s__r)
                                                FROM Anomalie__c
                                                WHERE Id IN :LAnomalies
                                               ];
        
        //added for 144271
        List<String> listOfIndisStand = Label.CongInd_RT_IndispoStandard_ALL.split(';');
        map<id,Account> mapAccount = new map<id,account>([select id,name, 
                                                          (select id,casenumber,account.ShippingCountry,recordtypeid from cases 
                                                           where Status <> 'Terminée'),
                                                          (select id,Type_d_indisponibilite__c
                                                           from Conges__r 
                                                           where statut__c = :label.CongeIndispo_En_Cours
                                                           //commented for 144271
                                                           /*and ( Type_d_indisponibilite__c = '2'
                                                                or Type_d_indisponibilite__c = '3'
                                                                or Type_d_indisponibilite__c = '4')*/
                                                           and recordtypeId in :listOfIndisStand)
                                                          from account 
                                                          where id in :listAccountIDs]);
        
        system.debug('LAnomaliesWDetails '+LAnomaliesWDetails);
        for(Anomalie__c anom : LAnomaliesWDetails){
            if(anom.Type__c == 'SyncPudo' && anom.Statut__c == '1'){
                list<case> listCases = mapAccount.get(anom.PUDO__c).cases;
                list<case> listCaseSynchro = new list<case>(); 
                for(case requete : listCases){
                    
                    if(requete.recordTypeId == mapassociationRTPaysBNL.get(requete.account.ShippingCountry).ID_AnomalieSynchro__c){
                        listCaseSynchro.add(requete);
                    }
                    
                }                
                list<Conge_Indispo__c> listIndispos = mapAccount.get(anom.PUDO__c).Conges__r; 
                list<Conge_Indispo__c> listInjoignables = new list<Conge_Indispo__c>();
                for(Conge_Indispo__c indispo : listIndispos){
                    if(indispo.Type_d_indisponibilite__c == '3'){
                        listInjoignables.add(indispo);  
                    }
                }

                if(listCaseSynchro.size() == 0 && listIndispos.size() == 0){
                    // if anomalie's account is not France
                    if(anom.PUDO__r.ShippingCountry != 'France'){
                        system.debug('AP01_AnomaliePB here ');
                        //Hungary + BNL
                            LCasesToInsert.add(new Case(AccountId = anom.PUDO__c, Anomalie__c = anom.Id, ContactId = anom.PUDO__r.Contact_operationnel_1__c,
                                                        OwnerId = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_File_service_line__c, RecordTypeId = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_AnomalieSynchro__c, Status = '0',  Subject = Label.Case_Subject_AnomalieDeSynchro
                                                        ,Object_de_la_requete__c = 'Anomalie de synchronisation d’un relais'
                                                       ));
                        
                    }
                    // if anomalie's account is  France
                    else if(anom.PUDO__r.ShippingCountry == 'France' && listInjoignables.size()==0)
                    {
                        LCasesToInsert.add(new Case(AccountId = anom.PUDO__c, Anomalie__c = anom.Id, ContactId = anom.PUDO__r.Contact_operationnel_1__c,
                                                    OwnerId = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_WebHelpQueue__c, RecordTypeId = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_AnomalieSynchro__c, Status = Label.Case_Status_AttenteDeTraitement,  Subject = Label.Case_Subject_AnomalieDeSynchro,
                                                    Object_de_la_requete__c = 'Anomalie de synchronisation d’un relais'
                                                   ));
                    }
                    //ID_AnomalieSynchro__c
                }
            }else if(anom.Type__c == 'SyncPudo' && anom.Statut__c == '0'){
                system.debug('JMB AP01_AnomaliesPB SyncPudo 0');
                for(Case c : anom.Requ_tes__r){
                    c.Status = 'Terminée'; LCasesToUpdate.add(c);
                }
            }else if(anom.PUDO__r.RecordType.DeveloperName != 'PUS_FR_Consigne' && anom.PUDO__r.RecordType.DeveloperName != 'DPD_BNL_Consigne' && anom.Type__c == 'NoDevice' && anom.Statut__c == '1'){
                system.debug('JMB AP01_AnomaliesPB NoDevice 1 FR');
                if(Label.RT_France_Compte.contains(anom.PUDO__r.recordtypeId)){
                    LCongesIndispoToInsert.add(new Conge_Indispo__c(Nom_du_compte__c = anom.PUDO__c, Anomalie__c = anom.Id, Commentaires__c = anom.Description__c,
                                                                    Date_de_debut__c = System.today(), RecordTypeId = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_Indisponibilite_standard__c, Type_d_indisponibilite__c = '4'
                                                                   ));
                }else if(Label.RT_INT_Compte.contains(anom.PUDO__r.recordtypeId) || Label.RT_INT_Compte2.contains(anom.PUDO__r.recordtypeId)){
                    //Hungary + BNL
                        LCasesToInsert.add(new Case (status = 'En attente de traitement',
                                                     subject = 'Relais actif sans moyen de scan associé',
                                                     Object_de_la_requete__c ='Relais actif sans moyen de scan associé',
                                                     recordtypeID = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_MoyenScan_Actif_Sans__c,
                                                     accountid = anom.PUDO__c,
                                                     contactid = anom.Tech_ContactPudo__c,
                                                     Point_relais_ne_repond_pas__c = false,
                                                     Anomalie__c = anom.id));
                    if(anom.PUDO__r.type =='2'){
                        LCongesIndispoToInsert.add(new Conge_Indispo__c(Type_d_indisponibilite__c ='4',
                                                                        Sous_type__c ='Pas de PDA associé',
                                                                        Nom_du_compte__c = anom.pudo__c,
                                                                        Anomalie__c = anom.id,
                                                                        recordtypeID = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_Indisponibilite_standard__c,
                                                                        Date_de_debut__c = date.today()
                                                                       ));
                        
                    }else if(anom.PUDO__r.type =='3') {
                        LCongesIndispoToInsert.add(new Conge_Indispo__c(Type_d_indisponibilite__c ='4', Sous_type__c ='Pas de PDA associé', Nom_du_compte__c = anom.pudo__c, Anomalie__c = anom.id,recordtypeID = mapassociationRTPaysBNL.get(anom.PUDO__r.ShippingCountry).ID_Indisponibilit_partenaire__c,Date_de_debut__c = date.today()
                                                                       ));}}
            }else if(anom.Type__c == 'NoDevice' && anom.Statut__c == '0'){
                system.debug('JMB AP01_AnomaliesPB NoDevice 0');
                for(Conge_Indispo__c c : anom.Cong_s_disponibilit_s_indisponibilit_s__r){
                    c.Date_de_fin__c = System.today();LCongesIndispoToUpdate.add(c);}
                for(Case c : anom.Requ_tes__r){
                    c.Status = 'Terminée'; LCasesToUpdate.add(c);}
            }
        }
        
        Map<Integer, List<sObject>> MLsObjectsToInsertUpdate = new Map<Integer, List<sObject>>();
        Map<Integer, List<sObject>> MLsObjectsToInsertUpdate1 = new Map<Integer, List<sObject>>();
        Map<Integer, Boolean> MisUpdate = new Map<Integer, Boolean>();
        Map<Integer, Boolean> MisUpdate1 = new Map<Integer, Boolean>();
        Integer i = 0;
                system.debug('MisUpdate ' + MisUpdate);
        system.debug('LCongesIndispoToInsert ' + LCongesIndispoToInsert);
        system.debug('LCongesIndispoToUpdate ' + LCongesIndispoToUpdate);
        
        if(LCasesToInsert.size() > 0){
            system.debug('case insert');
            MLsObjectsToInsertUpdate.put(i, LCasesToInsert);
            MisUpdate.put(i++, false);
        }//System.enqueueJob(new Queue_AsyncExecution(LCasesToInsert, false));}//insert LCasesToInsert;}
        if(LCasesToUpdate.size() > 0){
            system.debug('case update');
            MLsObjectsToInsertUpdate.put(i, LCasesToUpdate);
            MisUpdate.put(i++, true);
        }//System.enqueueJob(new Queue_AsyncExecution(LCasesToUpdate, true));}//update LCasesToUpdate;}
        if(LCongesIndispoToInsert.size() > 0){
            system.debug('conge insert');
            MLsObjectsToInsertUpdate.put(i, LCongesIndispoToInsert);
            MisUpdate.put(i++, false);
        }//System.enqueueJob(new Queue_AsyncExecution(LCongesIndispoToInsert, false));}//insert LCongesIndispoToInsert; }

        if(LCongesIndispoToUpdate.size() > 0)
        {
            system.debug('conge update');
            MLsObjectsToInsertUpdate.put(i, LCongesIndispoToUpdate);
            MisUpdate.put(i++, true);
        }//System.enqueueJob(new Queue_AsyncExecution(LCongesIndispoToUpdate, true));}// update LCongesIndispoToUpdate;}
        system.debug('MLsObjectsToInsertUpdate '+MLsObjectsToInsertUpdate);
        system.debug('MLsObjectsToInsertUpdate.size() '+MLsObjectsToInsertUpdate.size());
        System.enqueueJob(new Queue_AsyncExecution(MLsObjectsToInsertUpdate, MisUpdate, 0));
        
        
    }
}