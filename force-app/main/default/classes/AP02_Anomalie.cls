/*
* Author: John Boutros
* Modified By: -
* Date : 14/05/2018
* 
* Test classe: AP02_Anomalie_Test
Coverage : 100%
*/
public class AP02_Anomalie {
    static List<Case> listCasesToInsert = new List<Case>();
    static List<Conge_Indispo__c> listIndispoToInsert = new List<Conge_Indispo__c>();
    
    static List<Case> listCasesToUpdate;
    static List<Conge_Indispo__c> listIndispoToUpdate;
    
    static List<Anomalie__c> caseIdRelatedAnomalieListActifPlusScan;
    static List<Anomalie__c> caseIdRelatedAnomalieListInactScan;
    static List<Anomalie__c> caseIdRelatedAnomalieListActSansMoyenScan;
    static List<Anomalie__c> caseIdRelatedAnomalieListActSansForm;
    
    static Set<ID> anomalieSurAttributionID;
    static Set<ID> anomalieDecommissionnementDeDeviceID;
    static Set<ID> anomalieAbsenceDeDeviceAssocieID;
    static Set<ID> anomalieAssociationATortEtat2ID;
    
    static List<Anomalie__c> anomalieList;
    static Set<Anomalie__c> anomalieSet;
    static List<Anomalie__c> anomalieListFiltered;
    static List<Anomalie__c> clonedAnomalieList;
    
    static Boolean isUpdate = false;
    static boolean testingB = false;
    
    static Map<ID, Account> mapAccount;
    static Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPays;
    
    public static void anomMoyensScan(List<Anomalie__c> newAnomalieList, Map<Id, Anomalie__c> oldAnomalie)
    {
        listCasesToInsert = new List<Case>();
        listIndispoToInsert = new List<Conge_Indispo__c>();
        
        listCasesToUpdate = new List<Case>();
        listIndispoToUpdate = new List<Conge_Indispo__c>();
        
        caseIdRelatedAnomalieListActifPlusScan = new List<Anomalie__c>();
        caseIdRelatedAnomalieListInactScan = new List<Anomalie__c>();
        caseIdRelatedAnomalieListActSansMoyenScan = new List<Anomalie__c>();
        caseIdRelatedAnomalieListActSansForm = new List<Anomalie__c>();
        
        anomalieSurAttributionID = new Set<ID>();
        anomalieDecommissionnementDeDeviceID = new Set<ID>();
        anomalieAbsenceDeDeviceAssocieID = new Set<ID>();
        anomalieAssociationATortEtat2ID = new Set<ID>();
        
        anomalieList = new List<Anomalie__c>();
        anomalieSet = new Set<Anomalie__c>();
        anomalieListFiltered = new List<Anomalie__c>();
        clonedAnomalieList = new List<Anomalie__c>();
        
        Set<ID> setAccountID = new Set<ID>();
        for(Anomalie__c newAnomalie : newAnomalieList)
        {
            setAccountID.add(newAnomalie.PUDO__c);
        }
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel, ID_AnomalieSynchro__c,ID_MoyenScan_Actif_Sans__c,ID_File_service_line__c
                                                                         ,ID_MoyenScan_Actif_Sans_Formation_Scan__c,ID_MoyenScan_Inactif_Avec__c,ID_MoyenScan_Actif_Plusieurs__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        mapassociationRTPays =  new Map<String,Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPays)
        {
            mapassociationRTPays.put(mdtRecord.MasterLabel, mdtRecord);
        }
        
        mapAccount = new Map<ID, Account>([SELECT recordtypeID,shippingCountrycode,shippingCountry From account where ID in :setAccountID]);
        for(Anomalie__c newAnomalie : newAnomalieList)
        {
            //if(Label.RT_INT_Compte.contains(mapAccount.get(newAnomalie.pudo__c).recordtypeID) || Label.RT_INT_Compte2.contains(mapAccount.get(newAnomalie.pudo__c).recordtypeID) ){
                //if updating
                if(oldAnomalie!= null && oldAnomalie.ContainsKey(newAnomalie.Id))
                {
                    if(oldAnomalie.get(newAnomalie.id) != newAnomalie)
                    {
                        isUpdate = true;
                        fillSetsID(newAnomalie);
                    }
                }
                // if inserting
                else
                {
                    system.debug('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
                    system.debug('newAnomalie '+newAnomalie);
                    fillSetsID(newAnomalie);
                }
                
            //}
            
        }
        
        //Retrieve case actifPlusieursMoyenScan
        if(anomalieSurAttributionID.size() > 0)
        {
            if(isUpdate == false)
            {
                
                //JMB
                anomalieList = [SELECT id,PUDO__c, Type__c
                                FROM Anomalie__c
                                Where id in :anomalieSurAttributionID];
                checkIfAnomalieSameTypeExists(anomalieList);
                caseIdRelatedAnomalieListActifPlusScan = [Select Id, Tech_ContactPudo__c
                                                          From Anomalie__c
                                                          Where id =: new Set<Anomalie__c>(clonedAnomalieList)];
                //JMB
                
            }
            else
            {
                
                caseIdRelatedAnomalieListActifPlusScan = [Select Id,
                                                          (SELECT Id, Status, recordtypeid FROM Requ_tes__r)
                                                          From Anomalie__c
                                                          Where id =: anomalieSurAttributionID];
            }
        }
        //Retrieve case inactifavecMoyenScan
        if(anomalieDecommissionnementDeDeviceID.size() > 0)
        {
            if(isUpdate == false)
            {
                //JMB
                anomalieList = [SELECT id,PUDO__c, Type__c
                                FROM Anomalie__c
                                Where id in :anomalieDecommissionnementDeDeviceID];
                checkIfAnomalieSameTypeExists(anomalieList);
                caseIdRelatedAnomalieListInactScan = [Select Id, Tech_ContactPudo__c
                                                      From Anomalie__c
                                                      Where id =: new Set<Anomalie__c>(clonedAnomalieList)];
                //JMB
            }
            else
            {
                caseIdRelatedAnomalieListInactScan = [Select Id,
                                                      (SELECT Id, Status FROM Requ_tes__r WHERE RecordTypeID in (:Label.RT_MoyenScan_Inactif_Avec))
                                                      From Anomalie__c
                                                      Where id =: anomalieDecommissionnementDeDeviceID];
            }
        }
        //Retrieve case actifSansformationScan
        if(anomalieAssociationATortEtat2ID.size() > 0)
        {
            if(isUpdate == false)
            {
                //JMB
                anomalieList = [SELECT id,PUDO__c, Type__c
                                FROM Anomalie__c
                                Where id in :anomalieAssociationATortEtat2ID];
                checkIfAnomalieSameTypeExists(anomalieList);
                caseIdRelatedAnomalieListActSansForm = [Select Id, Tech_ContactPudo__c
                                                        From Anomalie__c
                                                        Where id =: new Set<Anomalie__c>(clonedAnomalieList)];
                //JMB
            }
            else
            {
                caseIdRelatedAnomalieListActSansForm = [Select Id,
                                                        (SELECT Id, Status, recordtypeid FROM Requ_tes__r)
                                                        From Anomalie__c
                                                        Where id =: anomalieAssociationATortEtat2ID];
            }
        }
        
        //Retrieve case actifSansMoyenScan
        if(anomalieAbsenceDeDeviceAssocieID.size() > 0)
        {
            if(isUpdate == false)
            {
                anomalieList = [SELECT id,PUDO__c, Type__c
                                FROM Anomalie__c
                                Where id in :anomalieAbsenceDeDeviceAssocieID];
                system.debug('anomalieAbsenceDeDeviceAssocieID '+anomalieAbsenceDeDeviceAssocieID);
                checkIfAnomalieSameTypeExists(anomalieList);
                caseIdRelatedAnomalieListActSansMoyenScan = [Select Id, PUDO__r.type, Tech_ContactPudo__c
                                                             From Anomalie__c
                                                             Where id =: new Set<Anomalie__c>(clonedAnomalieList)];
                system.debug('caseIdRelatedAnomalieListActSansMoyenScan '+caseIdRelatedAnomalieListActSansMoyenScan);
            }
            else
            {
                caseIdRelatedAnomalieListActSansMoyenScan = [Select Id, PUDO__r.type, 
                                                             (SELECT Id, Status FROM Requ_tes__r WHERE RecordTypeID in (:Label.RT_MoyenScan_Actif_Sans)),
                                                             (SELECT ID, Date_de_fin__c FROM Cong_s_disponibilit_s_indisponibilit_s__r)
                                                             From Anomalie__c
                                                             Where id =: anomalieAbsenceDeDeviceAssocieID];
            }
        }
        
        checkAnomalieType(newAnomalieList, isUpdate, caseIdRelatedAnomalieListActifPlusScan, caseIdRelatedAnomalieListInactScan, caseIdRelatedAnomalieListActSansMoyenScan, caseIdRelatedAnomalieListActSansForm);
        
        Map<Integer, List<sObject>> MLsObjectsToInsertUpdate = new Map<Integer, List<sObject>>();
        Map<Integer, Boolean> MisUpdate = new Map<Integer, Boolean>();
        Integer i = 0;
        
        if(listCasesToInsert.size() > 0)
        {
            system.debug('listCasesToInsert '+listCasesToInsert);
            MLsObjectsToInsertUpdate.put(i, listCasesToInsert);
            MisUpdate.put(i++, false);
        }
        if(listCasesToUpdate.size() > 0)
        {
            system.debug('listCasesToUpdate '+listCasesToUpdate);
            MLsObjectsToInsertUpdate.put(i, listCasesToUpdate);
            MisUpdate.put(i++, true);
        }
        
        if(listIndispoToInsert.size() > 0)
        {
            system.debug('listIndispoToInsert '+listIndispoToInsert);
            MLsObjectsToInsertUpdate.put(i, listIndispoToInsert);
            MisUpdate.put(i++, true);
        }
        
        System.enqueueJob(new Queue_AsyncExecution(MLsObjectsToInsertUpdate, MisUpdate, 0));
        
    }
    private static void fillSetsID(Anomalie__c newAnomalie)
    {
        if(newAnomalie.Type__c == 'TooManyDevices')
        {
            anomalieSurAttributionID.add(newAnomalie.id);
            system.debug('anomalieSurAttributionID '+anomalieSurAttributionID);
        }
        if(newAnomalie.Type__c == 'NoDecommissioned')
        {
            system.debug('newAnomalie.Type__c = NoDecommissioned');
            anomalieDecommissionnementDeDeviceID.add(newAnomalie.id);
        }
        if(newAnomalie.Type__c == 'Association à tort Etat 2')
        {
            anomalieAssociationATortEtat2ID.add(newAnomalie.id);
        }
        if(newAnomalie.Type__c == 'NoDevice')
        {
            system.debug('christine newAnomalie.Type__c '+newAnomalie.Type__c);
            anomalieAbsenceDeDeviceAssocieID.add(newAnomalie.id);
        }
    }
    private static void checkAnomalieType(List<Anomalie__c> newAnomalieList, Boolean isUpdate, List<Anomalie__c> caseIdRelatedAnomalieListActifPlusScan, List<Anomalie__c> caseIdRelatedAnomalieListInactScan, List<Anomalie__c> caseIdRelatedAnomalieListActSansMoyenScan, List<Anomalie__c> caseIdRelatedAnomalieListActSansForm)
    {
        for(Anomalie__c anomRecord : newAnomalieList)
        {
            //si une anomalie est de type Surattribution de device
            if(caseIdRelatedAnomalieListActifPlusScan.size() > 0 && anomRecord.Type__c =='TooManyDevices')
            {
                actifPlusieursMoyenScan(anomRecord, isUpdate, caseIdRelatedAnomalieListActifPlusScan, mapAccount.get(anomRecord.PUDO__c).ShippingCountryCode, mapassociationRTPays.get(mapAccount.get(anomRecord.PUDO__c).ShippingCountry).ID_MoyenScan_Actif_Plusieurs__c);
            }
            //si une anomalie est de type Décommissionnement de device
            if(caseIdRelatedAnomalieListInactScan.size() > 0 && anomRecord.Type__c =='NoDecommissioned')
            {
                inactifavecMoyenScan(anomRecord, isUpdate, caseIdRelatedAnomalieListInactScan,mapAccount.get(anomRecord.PUDO__c).ShippingCountryCode, mapassociationRTPays.get(mapAccount.get(anomRecord.PUDO__c).ShippingCountry).ID_MoyenScan_Inactif_Avec__c);
            }
            //si une anomalie est de type Association à tort Etat 2
            if(caseIdRelatedAnomalieListActSansForm.size() > 0 && anomRecord.Type__c =='Association à tort Etat 2')
            {
                actifSansformationScan(anomRecord, isUpdate, caseIdRelatedAnomalieListActSansForm,mapAccount.get(anomRecord.PUDO__c).ShippingCountryCode, mapassociationRTPays.get(mapAccount.get(anomRecord.PUDO__c).ShippingCountry).ID_MoyenScan_Actif_Sans_Formation_Scan__c);
            }
            
            if(caseIdRelatedAnomalieListActSansMoyenScan.size() > 0 && anomRecord.Type__c =='NoDevice')
            {
                if(mapAccount.get(anomRecord.PUDO__c).ShippingCountryCode == 'FR'){
                    actifSansMoyenScan(anomRecord, isUpdate, caseIdRelatedAnomalieListActSansMoyenScan,mapAccount.get(anomRecord.PUDO__c).ShippingCountryCode,mapassociationRTPays.get(mapAccount.get(anomRecord.PUDO__c).ShippingCountry).ID_MoyenScan_Actif_Sans__c);
                }
            }
        }
        //}
    }
    private static void actifPlusieursMoyenScan(Anomalie__c newAnomalie, Boolean isUpdate, List<Anomalie__c> caseIdRelatedAnomalieListActifPlusScan,string shippingCountryCode,string recordtypeID)
    {
        //si une anomalie est ouverte (ALWAYS ON AFTER INSERT)
        if(newAnomalie.Statut__c == '1' && isUpdate == false)
        {
            // création automatique de la requête avec l'objet "Relais actif avec plusieurs moyens de scan associés " 
            // avec le statut "en attente de traitement" à partir de l'anomalie ouverte "Surattribution de device"
            
            //France
            if(shippingCountryCode == 'FR'){
                listCasesToInsert.add(new Case (status = '0',
                                                subject = 'Relais actif avec plusieurs moyens de scan associés',
                                                Object_de_la_requete__c = 'Relais actif avec plusieurs moyens de scan associés',
                                                recordtypeID = recordtypeID,
                                                accountid = newAnomalie.PUDO__c,
                                                contactid = newAnomalie.Tech_ContactPudo__c,
                                                Point_relais_ne_repond_pas__c = false,
                                                ownerid = Label.FileGestMat_ID_FR,
                                                Anomalie__c = newAnomalie.id));
                
            }
            //BNL + Hungary
            else{
                listCasesToInsert.add(new Case (status = 'En attente de traitement',
                                                subject = 'Relais actif avec plusieurs moyens de scan associés',
                                                Object_de_la_requete__c = 'Relais actif avec plusieurs moyens de scan associés',
                                                recordtypeID = recordtypeID,
                                                accountid = newAnomalie.PUDO__c,
                                                contactid = newAnomalie.Tech_ContactPudo__c,
                                                Point_relais_ne_repond_pas__c = false,
                                                Anomalie__c = newAnomalie.id));                  
            }
        }
        //si une anomalie est fermée (ALWAYS ON AFTER UPDATE)
        else if(newAnomalie.Statut__c == '0' && isUpdate == true)
        {
            for(Anomalie__c anomalieRetrieved : caseIdRelatedAnomalieListActifPlusScan)
            {
                if(anomalieRetrieved.Requ_tes__r.size() > 0)
                {
                    for(Case caseToUpdate : anomalieRetrieved.Requ_tes__r)
                    {
                        if(Label.RT_MoyenScan_Actif_Plusieurs.contains(caseToUpdate.RecordTypeId))
                        {
                            caseToUpdate.status ='Terminée';
                            listCasesToUpdate.add(caseToUpdate);
                        }
                    }
                }
            }
        }
    }
    private static void inactifavecMoyenScan(Anomalie__c newAnomalie, Boolean isUpdate, List<Anomalie__c> caseIdRelatedAnomalieListInactScan,string shippingCountryCode,string recordtypeID)
    {
        //si une anomalie est ouverte (ALWAYS ON AFTER INSERT)
        if(newAnomalie.Statut__c == '1' && isUpdate == false){
            //création automatique de la requête avec l'objet "Relais inactif avec moyens de scan associés " 
            //avec le statut "en attente de traitement" à partir de l'anomalie ouverte "Décommissionnement de device"
            
            //France
            if(shippingCountryCode == 'FR'){
                listCasesToInsert.add(new Case (status = 'En attente de traitement',
                                                subject = 'Relais inactif avec moyens de scan associés',
                                                Object_de_la_requete__c = 'Relais inactif avec moyens de scan associés',
                                                recordtypeID = recordtypeID,
                                                accountid = newAnomalie.PUDO__c,
                                                Point_relais_ne_repond_pas__c = false,
                                                ownerid=label.FileGestionContractuelle,
                                                Anomalie__c = newAnomalie.id));
                
            }
            //BNL + Hungary
            else{ 
                listCasesToInsert.add(new Case (status = 'En attente de traitement',
                                                subject = 'Relais inactif avec moyens de scan associés',
                                                Object_de_la_requete__c = 'Relais inactif avec moyens de scan associés',
                                                recordtypeID = recordtypeID,
                                                accountid = newAnomalie.PUDO__c,
                                                Point_relais_ne_repond_pas__c = false,
                                                Anomalie__c = newAnomalie.id));    
                
            }
        }
        //si une anomalie est fermée (ALWAYS ON AFTER UPDATE)
        else if(newAnomalie.Statut__c == '0' && isUpdate == true){
            system.debug('newAnomalie.Statut__c '+newAnomalie.Statut__c);
            for(Anomalie__c anomalieRetrieved : caseIdRelatedAnomalieListInactScan)
            {
                system.debug('anomalieRetrieved '+anomalieRetrieved);
                system.debug('anomalieRetrieved,Requ_tes__r '+anomalieRetrieved.Requ_tes__r);
                if(anomalieRetrieved.Requ_tes__r.size() > 0){
                    for(Case caseToUpdate : anomalieRetrieved.Requ_tes__r){
                        system.debug('caseToUpdate '+caseToUpdate);
                        caseToUpdate.status ='Terminée';
                        listCasesToUpdate.add(caseToUpdate);}
                }
            }
        }
    }
    private static void actifSansFormationScan(Anomalie__c newAnomalie, Boolean isUpdate, List<Anomalie__c> caseIdRelatedAnomalieListActSansForm,string shippingCountryCode,string recordtypeID)
    {
        //si une anomalie est ouverte (ALWAYS ON AFTER INSERT)
        if(newAnomalie.Statut__c == '1' && isUpdate == false){
            //création automatique de la requête avec l'objet "Relais actif sans formation avec moyen de scan associé "
            // avec le statut "en attente de traitement" à partir de l'anomalie ouverte "Association à tort Etat 2"
            
            // France
            if(shippingCountryCode == 'FR'){
                listCasesToInsert.add(new Case (status = 'En attente de traitement',
                                                subject = 'Relais actif sans formation avec moyen de scan associé',
                                                Object_de_la_requete__c ='Relais sans formation avec moyens de scans associés',
                                                recordtypeID = recordtypeID,
                                                accountid = newAnomalie.PUDO__c,
                                                contactid = newAnomalie.Tech_ContactPudo__c,
                                                Point_relais_ne_repond_pas__c =false,
                                                ownerid = label.FileGestMat_ID_FR,
                                                Anomalie__c =newAnomalie.id));  
                
            }
            //BNL + Hungary
            else{
                listCasesToInsert.add(new Case (status = 'En attente de traitement',
                                                subject = 'Relais actif sans formation avec moyen de scan associé',
                                                Object_de_la_requete__c ='Relais sans formation avec moyens de scans associés',
                                                recordtypeID = recordtypeID,
                                                accountid = newAnomalie.PUDO__c,
                                                contactid = newAnomalie.Tech_ContactPudo__c,
                                                Point_relais_ne_repond_pas__c =false,
                                                Anomalie__c =newAnomalie.id));
            }
        }
        //si une anomalie est fermée (ALWAYS ON AFTER UPDATE)
        else if(newAnomalie.Statut__c == '0' && isUpdate == true)
        {
            for(Anomalie__c anomalieRetrieved : caseIdRelatedAnomalieListActSansForm)
            {
                if(anomalieRetrieved.Requ_tes__r.size() > 0)
                {
                    for(Case caseToUpdate : anomalieRetrieved.Requ_tes__r)
                    {
                        if(Label.RT_MoyenScan_Actif_Sans_Formation_Scan.contains(caseToUpdate.RecordTypeId))
                        {
                            caseToUpdate.status ='Terminée';
                            listCasesToUpdate.add(caseToUpdate);
                        }
                    }
                }
            }
        }
    }
    private static void actifSansMoyenScan(Anomalie__c newAnomalie, Boolean isUpdate, List<Anomalie__c> caseIdRelatedAnomalieListActSansMoyenScan,string shippingCountryCode,string recordtypeID)
    {
        //si une anomalie est ouverte (ALWAYS ON AFTER INSERT)
        if(newAnomalie.Statut__c == '1' && isUpdate == false)
        {
            //création automatique de la requête avec l'objet "Relais actif sans moyen de scan associé"
            // avec le statut "en attente de traitement" à partir de l'anomalie ouverte
            // France
            if(shippingCountryCode == 'FR'){
                listCasesToInsert.add(new Case (status = 'En attente de traitement',
                                                subject = 'Relais actif sans moyen de scan associé',
                                                Object_de_la_requete__c ='Relais actif sans moyen de scan associé',
                                                recordtypeID = recordtypeID,
                                                accountid = newAnomalie.PUDO__c,
                                                contactid = newAnomalie.Tech_ContactPudo__c,
                                                Point_relais_ne_repond_pas__c =false,
                                                ownerid = label.FileGestMat_ID_FR,
                                                Anomalie__c =newAnomalie.id)); 
                
                listIndispoToInsert.add(new Conge_Indispo__c(Type_d_indisponibilite__c ='2',
                                                             Sous_type__c ='Pas de PDA associé',
                                                             Nom_du_compte__c = newAnomalie.pudo__c,
                                                             Anomalie__c = newAnomalie.id,
                                                             recordtypeID = Label.RT_FR_Indisponibilite_PB_PDA_Panne,
                                                             Date_de_debut__c = date.today()
                                                            ));
                
            }
        }
        //si une anomalie est fermée (ALWAYS ON AFTER UPDATE)
        else if(newAnomalie.Statut__c == '0' && isUpdate == true && shippingCountryCode == 'FR')
        {
            for(Anomalie__c anomalieRetrieved : caseIdRelatedAnomalieListActSansMoyenScan)
            {
                if(anomalieRetrieved.Requ_tes__r.size() > 0)
                {
                    for(Case caseToUpdate : anomalieRetrieved.Requ_tes__r)
                    {
                        caseToUpdate.status ='Terminée';
                        listCasesToUpdate.add(caseToUpdate);
                    }
                }
            }
        }
    }
    private static void checkIfAnomalieSameTypeExists(List<Anomalie__c> anomalieList)
    {
        
        system.debug('anomalieList '+anomalieList);
        
        anomalieSet.addAll(anomalieList);
        anomalieListFiltered.addAll(anomalieSet);
        clonedAnomalieList = anomalieList.clone();
        
        Integer count;
        if(anomalieList.size() > 0)
        {
            for(Anomalie__c testAnomFiltered : anomalieListFiltered)
            {
                count = 0;
                for(Anomalie__c testAnom : anomalieList)
                {
                    if(testAnomFiltered.PUDO__c == testAnom.PUDO__c && testAnomFiltered.Type__c == testAnom.Type__c)
                    {
                        count++;
                    }
                    system.debug('count '+count);
                    if(count > 1)
                    {
                        if(clonedAnomalieList.size() > 1)
                        {
                            system.debug('clonedAnomalieList.size before '+clonedAnomalieList.size());
                            clonedAnomalieList.remove(clonedAnomalieList.indexOf(testAnom));
                            system.debug('clonedAnomalieList.size after'+clonedAnomalieList.size());
                        }
                    }
                }
            }
        }
        
    }
    
}