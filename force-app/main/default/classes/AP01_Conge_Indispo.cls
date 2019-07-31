// Classe déclenchée par le trigger : Conge_InDispo_BeforeInsert
public class AP01_Conge_Indispo{
    
    Id congeRTypeId = null;
    Id dispoRTypeId = null;
    Id indispoID = null;
    public static Map<String, String> mapOfSousTypeValues {get;set;}
    public Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPays;
    public void fillMetadata ()
    {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel,
                                                                         ID_Disponibilite__c, ID_Indisponibilite_standard__c,
                                                                         ID_Indisponibilit_partenaire__c, ID_Indisponibilit_consigne__c,
                                                                         ID_Conge__c 
                                                                         FROM Association_Record_Type_et_pays__mdt];
        mapassociationRTPays =  new Map<String,Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPays)
        {
            mapassociationRTPays.put(mdtRecord.MasterLabel, mdtRecord);
        }
    }
    // Méthode qui contrôle s'il existe déjà un congé/Dispo/Indispo existant au mêmes dates que le nouveau congé/Dispo/Indispo à insérer 
    public void chevauchementDates(List<Conge_Indispo__c> newConges){
        system.debug('JMBBB newConges '+newConges);
        List<Conge_Indispo__c> listeDeConges = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listeDeDispo = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listeIndispo = new List<Conge_Indispo__c>();
        List<Id> listeRT = new List<Id>();
        fillMetadata();
        mapOfSousTypeValues = getPickListValuesIntoMap();
        

        for(Conge_Indispo__c cI : newConges){
            system.debug('JMBBBB cI.Tech_Compte_ShippingCountry__c ' + cI.Tech_Compte_ShippingCountry__c );
            if(cI.RecordTypeId == mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Conge__c){ listeDeConges.add(cI);}
            if(cI.RecordTypeId == mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Disponibilite__c){ listeDeDispo.add(cI);}
            system.debug('JMBBBB cI.Type_d_indisponibilite__c ' + cI.Type_d_indisponibilite__c + '  ' + Label.pas_de_PDA_assos);
            system.debug('JMBBBB cI.RecordTypeId ' + cI.RecordTypeId + ' : ' + mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Indisponibilite_standard__c);
            system.debug('JMBBBB cI.RecordTypeId ' + cI.RecordTypeId + ' : ' + mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_partenaire__c);
            system.debug('JMBBBB cI.RecordTypeId ' + cI.RecordTypeId + ' : ' + mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_consigne__c);
            if( cI.Type_d_indisponibilite__c != Label.pas_de_PDA_assos 
               && ( cI.RecordTypeId == mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Indisponibilite_standard__c
                   || cI.RecordTypeId == mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_partenaire__c
                   || cI.RecordTypeId == mapassociationRTPays.get(cI.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_consigne__c)
               /*(cI.RecordTypeId == indispoStandardRTypeId || cI.RecordTypeId == indispoStandardRTypeIdBNL 
|| cI.RecordTypeId == indispoConsigneRTypeId || cI.RecordTypeId == indispoPartnenaireRTypeIdBNL 
|| cI.RecordTypeId == label.RT_HUN_Indisponibilite_standard || cI.RecordTypeId == label.RT_HUN_Indisponibilit_partenaire)*/
              ){ 
                  system.debug('JMBBBB CI ' + CI);
                  listeIndispo.add(cI);
              } 
        }       
       
        // vérifie quel est le type d'enregistrement de l'objet à insérer et appel la méthode chevauchementParRtype()
        if(!listeDeConges.isEmpty()){
            listeRT.clear();
            listeRT = fillListRecordtypesDispoCong();
            system.debug('JMBBBBB listeRT 1 '+listeRT);
            chevauchementParRtype(listeDeConges, listeRT);}
        if(!listeDeDispo.isEmpty()){ 
            listeRT.clear(); 
            listeRT = fillListRecordtypesDispoCong();
            system.debug('JMBBBBB listeRT 2 '+listeRT);
            chevauchementParRtype(listeDeDispo, listeRT);}
        if(!listeIndispo.isEmpty()){ 
            listeRT.clear(); 
            listeRT = fillListRecordtypesIndispo();
            system.debug('JMBBBBB listeRT 3 '+listeRT);
            chevauchementParRtype(listeIndispo, listeRT);}
        
    }  
    
    private List<Id> fillListRecordtypesDispoCong()
    {
        Map<String,Schema.RecordTypeInfo> mapOfInfoRTCongeIndispo = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByDeveloperName();
        List<Schema.RecordTypeInfo> listOfInfoRTCongeIndispo = mapOfInfoRTCongeIndispo.values();
        List<ID> listeRTInFill = new List<ID> ();
        for(Schema.RecordTypeInfo infoRTCongeIndispo : listOfInfoRTCongeIndispo)
        {
            if(mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getDeveloperName().contains('Conge'))
            {
                congeRTypeId = mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getRecordtypeID();
                listeRTInFill.add(congeRTypeId);
            }
            if(mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getDeveloperName().contains('Dispo')
               && !mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getDeveloperName().contains('Indispo'))
            {
                dispoRTypeId = mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getRecordtypeID();
                listeRTInFill.add(dispoRTypeId);
            }
            if(mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getDeveloperName().contains('Indispo'))
            {
                dispoRTypeId = mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getRecordtypeID();
                listeRTInFill.add(dispoRTypeId);
            }
        }
        return listeRTInFill;
    }
    private List<Id> fillListRecordtypesIndispo()
    {
        Map<String,Schema.RecordTypeInfo> mapOfInfoRTCongeIndispo = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByDeveloperName();
        List<Schema.RecordTypeInfo> listOfInfoRTCongeIndispo = mapOfInfoRTCongeIndispo.values();
        List<ID> listeRTInFill = new List<ID> ();
        for(Schema.RecordTypeInfo infoRTCongeIndispo : listOfInfoRTCongeIndispo)
        {
            if(mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getDeveloperName().contains('Indispo'))
            {
                indispoID = mapOfInfoRTCongeIndispo.get(infoRTCongeIndispo.getDeveloperName()).getRecordtypeID();
                listeRTInFill.add(indispoID);
            }
        }
        return listeRTInFill;
    }
    // Méthode privée qui vérifie la présence d'un chevauchement des dates en fonction du type d'enregistrement (Congé/Disponibilité/Indisponibilité standard/Indisponibilité Consigne)
    private void chevauchementParRtype(List<Conge_Indispo__c> congesEtIndispo, List<Id> recordTypes){
        system.debug('here -1');
        // Map<Integer, Id> mapAccountConges = new Map<Integer, Id>();
        Set<Id> setAccountCongesId = new Set<Id>();
        List<Conge_Indispo__c> congesMemeDates = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> dispoMemeDates = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> dispoMemeDatesToDelete = new List<Conge_Indispo__c>();
        Map<Id, List<Conge_Indispo__c>> mapCongesExistants = new Map<Id, List<Conge_Indispo__c>>();  
        Conge_Indispo__c congeSuivant = new Conge_Indispo__c();
		system.debug('JMB AP01_Cong_Indispo congesEtIndispo ' + congesEtIndispo);
        for(Conge_Indispo__c c : congesEtIndispo){ 
            setAccountCongesId.add(c.Nom_du_compte__c);
            //mapAccountConges.put(i, c.Nom_du_compte__c);
            
        }  
		system.debug('JMB AP01_Cong_Indispo setAccountCongesId ' + setAccountCongesId);
        // Requête de tous les congés/Dispo/Indispo existants pour le même compte et pour un type d'enregistrement donné
        List<Account> comptesCongesDispo = [SELECT Id, (SELECT Id, Date_de_debut__c, Date_de_fin__c, Tech_Compte_ShippingCountry__c, RecordTypeId , Statut__c, Sous_Type__c, Type_d_indisponibilite__c from Conges__r 
                                                        WHERE RecordTypeId IN:recordTypes AND Type_d_indisponibilite__c !=:Label.pas_de_PDA_assos) 
                                            FROM Account WHERE Id IN: setAccountCongesId]; 
		system.debug('JMB AP01_Cong_Indispo comptesCongesDispo ' + comptesCongesDispo);
        
        for(Account a : comptesCongesDispo){       
            mapCongesExistants.put(a.Id, a.conges__r); 
        }
        system.debug('JMB AP01_Cong_Indispo setAccountCongesId ' + mapCongesExistants);
        for(Conge_Indispo__c cong : congesEtIndispo){  
            system.debug('JMB here 0'); 
            system.debug('JMBBBB mapCongesExistants.get(cong.Nom_du_compte__c) ' + mapCongesExistants.get(cong.Nom_du_compte__c));
            system.debug('JMBBBB mapCongesExistants.get(cong.Nom_du_compte__c).size() ' + mapCongesExistants.get(cong.Nom_du_compte__c).size());
            if(mapCongesExistants.get(cong.Nom_du_compte__c) != null && mapCongesExistants.get(cong.Nom_du_compte__c).size() != 0){
                system.debug('JMB here 1');   
                for(Conge_Indispo__c autreCong : mapCongesExistants.get(cong.Nom_du_compte__c)){
                    
                    if((cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilite_standard__c || cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_consigne__c) && cong.Date_de_fin__c == null && autreCong.Date_de_debut__c >= cong.Date_de_debut__c ){
                        cong.addError(Label.indispo_sans_dateDeFin);              
                    }
                    
                    if(cong.Date_de_debut__c >= autreCong.Date_de_debut__c && cong.Date_de_debut__c <=autreCong.Date_de_fin__c
                       || cong.Date_de_fin__c >= autreCong.Date_de_debut__c && cong.Date_de_fin__c <=autreCong.Date_de_fin__c 
                       || cong.Date_de_debut__c <= autreCong.Date_de_debut__c && cong.Date_de_fin__c >= autreCong.Date_de_fin__c
                       || (cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilite_standard__c 
                           || cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_consigne__c 
                           || cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_partenaire__c)
                       && autreCong.Date_de_fin__c == null && (cong.Date_de_debut__c >= autreCong.Date_de_debut__c  || cong.Date_de_fin__c >= autreCong.Date_de_debut__c) ){
                           // si insert d'un congé et qu'une ou plusieurs disponibilités sont déjà existantes aux mêmes dates alors suppression des dispo 
                           if(cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Conge__c && autreCong.RecordTypeId == mapassociationRTPays.get(autreCong.Tech_Compte_ShippingCountry__c).ID_Disponibilite__c ){
                               // modified by gho
                               String auteCongStatut = autreCong.Statut__c; 
                               if(auteCongStatut.equals('En cours')) { 
                                   cong.addError(System.Label.Disponibilite_En_Cours);
                               } else {
                                   system.debug('here');
                                   congesMemeDates.add(autreCong);
                                   dispoMemeDates.add(autreCong);
                               } 
                           } else { 
                               system.debug('cong.Sous_type__c '+cong.Sous_type__c);
                               system.debug('autreCong.Sous_type__c '+autreCong.Sous_type__c);
                               if(cong.Sous_type__c == autreCong.Sous_type__c || 
                                  (cong.Sous_type__c != 'Injoignabilité' && autreCong.Sous_type__c != 'Injoignabilité') ){
                                      congesMemeDates.add(autreCong);
                                  }
                               
                           }       
                       }   
                } 
                system.debug('congesMemeDates ' + congesMemeDates);
                if(!congesMemeDates.isEmpty()){ 
                    system.debug('here 2'); 
                    // messages d'erreur en fonction du RecordType 
                    if(cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Conge__c && dispoMemeDates.isEmpty()){ 
                        cong.addError(Label.conge_dates_existantes);
                    }else if(cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Disponibilite__c){                   
                        cong.addError(Label.dispo_dates_existantes);
                    }else if( (cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilite_standard__c
                               || cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_consigne__c 
                               || cong.RecordTypeId == mapassociationRTPays.get(cong.Tech_Compte_ShippingCountry__c).ID_Indisponibilit_partenaire__c) ){
                                   system.debug('here 3');   
                                   cong.addError(Label.indispo_dates_existantes);
                               }
                }else{ 
                    mapCongesExistants.get(cong.Nom_du_compte__c).add(cong);
                }
            }else{ 
                mapCongesExistants.put(cong.Nom_du_compte__c, new List<Conge_Indispo__c>());
                mapCongesExistants.get(cong.Nom_du_compte__c).add(cong);
            }        
        }   
        
        
        if(dispoMemeDates.isEmpty() != true){
            try{ 
                delete dispoMemeDates;
            }catch(Exception e){
                System.debug(LoggingLevel.Error, e.getMessage());
            }
            
        }   
        
    } 
    
    public Map<String, String> getPickListValuesIntoMap(){
        Map<String, String> pickListValuesMap = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Conge_Indispo__c.sous_type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesMap.put(pickListVal.getLabel(), pickListVal.getLabel());
        }     
        return pickListValuesMap;
    }
}