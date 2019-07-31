public class AP02_Conge_Indispo {
    
    Id congeRTypeId = Label.CongeRT_15;
    Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    Id dispoRTypeId = Label.DispoRT_15;
    
    // Méthode qui affiche un message d'erreur si la modification concerne une indisponibilité qui a déjà débutée
    public void indispoDateEnCours(List<Conge_Indispo__c> newConges, Map<Id, Conge_Indispo__c> mapOldConges){
        
        List<Conge_Indispo__c> listeIndispoInjoignables = new List<Conge_Indispo__c>();
        
        for(Conge_Indispo__c cong : newConges){ 
            if(mapOldConges == null || cong.Tech_Treated__c == mapOldConges.get(cong.Id).Tech_Treated__c) {
                 if(cong.Date_de_debut__c <= Date.today() && cong.RecordTypeId == indispoStandardRTypeId 
               		|| cong.Date_de_debut__c <= Date.today()&& cong.RecordTypeId == indispoConsigneRTypeId){
                   
                       if(cong.Injoignable__c && cong.Injoignable__c == mapOldConges.get(cong.Id).Injoignable__c 
                          && cong.Injoignable_depuis_le__c == mapOldConges.get(cong.Id).Injoignable_depuis_le__c 
                          && cong.Duree_totale_injoignabilite__c == mapOldConges.get(cong.Id).Duree_totale_injoignabilite__c
                          && cong.Date_de_fin__c == mapOldConges.get(cong.Id).Date_de_fin__c){
                              cong.addError(Label.indispo_update_dateEnCours + ' ' + cong.Date_de_debut__c.format()); 
                       }
                 }
            } 
        }          
    }
    
   
    // Méthode qui contrôle s'il existe déjà un congé/Dispo/Indispo existant au mêmes dates que le congé/Dispo/Indispo à modifier 
    public void chevauchementDates(List<Conge_Indispo__c> newConges, Map<Id, Conge_Indispo__c> mapOldConges){
        List<Conge_Indispo__c> listeDeConges = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listeDeDispo = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listeIndispo = new List<Conge_Indispo__c>();
        List<Id> listeRT = new List<Id>();  
        
        // cas où seulement les dates ont été modifiées
        for(Conge_Indispo__c cI : newConges){
            if( (cI.Date_de_debut__c != mapOldConges.get(cI.Id).Date_de_debut__c || cI.Date_de_fin__c != mapOldConges.get(cI.Id).Date_de_fin__c
                 || cI.Type_d_indisponibilite__c != mapOldConges.get(cI.Id).Type_d_indisponibilite__c)){
               //&& ( cI != mapOldConges.get(cI.Id) && cI.Date_de_fin__c != null && mapOldConges.get(cI.Id) == null)
                   if(cI.RecordTypeId == congeRTypeId){ listeDeConges.add(cI); }
                   if(cI.RecordTypeId == dispoRTypeId){ listeDeDispo.add(cI); }
                   if(cI.Type_d_indisponibilite__c != Label.pas_de_PDA_assos && cI.RecordTypeId == indispoStandardRTypeId 
                      || (cI.Type_d_indisponibilite__c != Label.pas_de_PDA_assos && cI.RecordTypeId == indispoConsigneRTypeId )){ 
                          listeIndispo.add(cI); 
                      }                 
               }
            system.debug('AP02_Conge_Indispo listeDeConges' + listeDeConges);
            system.debug('AP02_Conge_Indispo listeDeDispo' + listeDeDispo);
            system.debug('AP02_Conge_Indispo listeIndispo' + listeIndispo);
            // vérifie quel est le type d'enregistrement de l'objet à modifier et appel la méthode chevauchementParRtype()
            if(!listeDeConges.isEmpty()){
                listeRT.clear();
                listeRT.add(congeRTypeId);
                listeRT.add(dispoRTypeId);
                chevauchementParRtype(listeDeConges, listeRT);}
             if(!listeDeDispo.isEmpty()){ 
       			 listeRT.clear(); 
       			 listeRT.add(congeRTypeId); 
        		 listeRT.add(dispoRTypeId);
        		 chevauchementParRtype(listeDeDispo, listeRT);}
            if(!listeIndispo.isEmpty()){ 
                listeRT.clear(); 
                listeRT.add(indispoStandardRTypeId); 
                listeRT.add(indispoConsigneRTypeId);
                chevauchementParRtype(listeIndispo, listeRT);}
            
        }
    }
    
    // Méthode privée qui vérifie la présence d'un chevauchement des dates en fonction du type d'enregistrement (Congé/Disponibilité/Indisponibilité standard/Indisponibilité Consigne)
    private void chevauchementParRtype(List<Conge_Indispo__c> congesEtIndispo, List<Id> recordTypes){
        Map<Id, Id> mapAccountConges = new Map<Id, Id>();
        List<Conge_Indispo__c> congesMemeDates = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> dispoMemeDates = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> dispoMemeDatesToDelete = new List<Conge_Indispo__c>();
        Map<Id, List<Conge_Indispo__c>> mapCongesExistants = new Map<Id, List<Conge_Indispo__c>>();  
        Conge_Indispo__c congeSuivant = new Conge_Indispo__c();
        
        for(Conge_Indispo__c c : congesEtIndispo){
            mapAccountConges.put(c.Id, c.Nom_du_compte__c); 
        }
        
        // Requête de tous les congés/Dispo/Indispo existants pour le même compte et pour un type d'enregistrement donné
        List<Account> comptesCongesDispo = [SELECT Id, (SELECT Id, Name, Date_de_debut__c, Date_de_fin__c, RecordTypeId from Conges__r
                                                        WHERE Id NOT IN:congesEtIndispo
                                                        AND RecordTypeId IN:recordTypes AND Type_d_indisponibilite__c !=:Label.pas_de_PDA_assos) 
                                            FROM Account WHERE Id IN:mapAccountConges.values()];  
        
        system.debug('christine comptesCongesDispo '+comptesCongesDispo);
        for(Account a : comptesCongesDispo){       
            mapCongesExistants.put(a.Id, a.conges__r); 
        }
        
        for(Conge_Indispo__c cong : congesEtIndispo){  
            
            if(mapCongesExistants.get(cong.Nom_du_compte__c).size() != 0){
                for(Conge_Indispo__c autreCong : mapCongesExistants.get(cong.Nom_du_compte__c)){
                    
                    if((cong.RecordTypeId == indispoStandardRTypeId || cong.RecordTypeId == indispoConsigneRTypeId)&& cong.Date_de_fin__c == null && autreCong.Date_de_debut__c >= cong.Date_de_debut__c ){
                        system.debug('christine here 2 ....');
                        cong.addError(Label.indispo_sans_dateDeFin);              
                    }
                    
                    system.debug('AP02_Conge_Indispo cong.Date_de_debut__c ' + cong.Date_de_debut__c);
                    system.debug('AP02_Conge_Indispo cong.Date_de_fin__c ' + cong.Date_de_fin__c);
                    system.debug('AP02_Conge_Indispo autreCong.Date_de_debut__c ' + autreCong.Date_de_debut__c);
                    system.debug('AP02_Conge_Indispo autreCong.Date_de_fin__c ' + autreCong.Date_de_fin__c);
                    if(cong.Date_de_debut__c >= autreCong.Date_de_debut__c && cong.Date_de_debut__c <=autreCong.Date_de_fin__c && cong.Date_de_fin__c != date.today()
                       || cong.Date_de_fin__c >= autreCong.Date_de_debut__c && cong.Date_de_fin__c <=autreCong.Date_de_fin__c && cong.Date_de_fin__c != date.today()
                       || cong.Date_de_debut__c <= autreCong.Date_de_debut__c && cong.Date_de_fin__c >= autreCong.Date_de_fin__c && cong.Date_de_fin__c != date.today()
                       || (cong.RecordTypeId == indispoStandardRTypeId || cong.RecordTypeId == indispoConsigneRTypeId) && autreCong.Date_de_fin__c == null 
                       && (cong.Date_de_debut__c >= autreCong.Date_de_debut__c || cong.Date_de_fin__c   >= autreCong.Date_de_debut__c ) && cong.Date_de_fin__c != date.today()){
                           congesMemeDates.add(autreCong);  
                           // si modif des dates d'un congé et qu'une ou plusieurs disponibilités sont déjà existantes aux mêmes dates alors suppression des dispo 
                           if(cong.RecordTypeId == congeRTypeId && autreCong.RecordTypeId == dispoRTypeId ){
                               dispoMemeDates.add(autreCong);
                           }                      
                       }   
                }  
                system.debug('AP02_Conge_Indispo congesMemeDates ' + congesMemeDates);
                if(!congesMemeDates.isEmpty()){
                    // messages d'erreur en fonction du RecordType 
                    if(cong.RecordTypeId == congeRTypeId && dispoMemeDates.isEmpty()){
                        cong.addError(Label.conge_dates_existantes);
                    }else if(cong.RecordTypeId == dispoRTypeId){ 
                        cong.addError(Label.dispo_dates_existantes);
                    }
                    else if(cong.RecordTypeId == indispoStandardRTypeId || cong.RecordTypeId == indispoConsigneRTypeId){
                        system.debug('AP02_Conge_Indispo cong.RecordTypeId ' + cong.RecordTypeId);
                        cong.addError(Label.indispo_dates_existantes);
                    }
                }else{ 
                    mapCongesExistants.get(cong.Nom_du_compte__c).add(cong);
                }
            }else{ 
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
    
    
    
}