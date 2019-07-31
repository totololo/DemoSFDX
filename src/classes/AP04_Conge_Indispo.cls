public class AP04_Conge_Indispo {
    
    Id congeRTypeId = Label.CongeRT_15;
    Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    Id dispoRTypeId = Label.DispoRT_15;
    
 // Cas où suite à la modification d'une indisponibilité, il y a création de l'injoignabilité correspondante si la case 'Injoignable' est cochée
    public void insertInjoignabilite(List<Conge_Indispo__c> newIndispo, Map<Id, Conge_Indispo__c> mapOldIndispo){
        
        List<Conge_Indispo__c> listeIndispoInjoignables = new List<Conge_Indispo__c>();
        
        for(Conge_Indispo__c cong : newIndispo){
           if(mapOldIndispo == null || cong.Tech_Treated__c == mapOldIndispo.get(cong.Id).Tech_Treated__c) {
            if(cong.Date_de_debut__c <= Date.today() && cong.RecordTypeId == indispoStandardRTypeId 
               || cong.Date_de_debut__c <= Date.today() && cong.RecordTypeId == indispoConsigneRTypeId){
                   
                   System.debug('Appel méthode de création d\'une injoignabilité pour indispo suivante : ' + cong);
                   listeIndispoInjoignables.add(cong);
               }
           }
        }
        
        
        if(listeIndispoInjoignables.isEmpty() != true ){ 
            newInjoignabilite(listeIndispoInjoignables, mapOldIndispo); }
    }
    
    
    
    public void newInjoignabilite(List<Conge_Indispo__c> listeIndispoInjoignables, Map<Id, Conge_Indispo__c> mapOldConges){
        
        List<Historique_Injoignabilites__c> injoignabiliteToInsert = new List<Historique_Injoignabilites__c>();
        List<Historique_Injoignabilites__c> injoignabiliteToUpdate = new List<Historique_Injoignabilites__c>();
        Map<Id, List<Historique_Injoignabilites__c>> mapInjoignabiliteACloturer = new Map<Id, List<Historique_Injoignabilites__c>>();  
        
        List<Conge_Indispo__c> indispoDecoches = [SELECT Id, (SELECT Id, Compte__c, Indisponibilite__c, Date_de_debut1__c, Date_de_fin1__c 
                                                              from Historique_Injoignabilites__r
                                                              WHERE Date_de_fin1__c = null) 
                                                  FROM Conge_Indispo__c WHERE Id IN:listeIndispoInjoignables]; 
        
        if(indispoDecoches.isEmpty() != true){
            for(Conge_Indispo__c c : indispoDecoches){  
                mapInjoignabiliteACloturer.put(c.Id, c.Historique_Injoignabilites__r);
                System.debug(' size de la map de conges existant : ' + mapInjoignabiliteACloturer.size() + ' conges__r de account ' +  c.Historique_Injoignabilites__r );
            }
        } 
        
        
        for(Conge_Indispo__c indispo : listeIndispoInjoignables){
            // Cas où la case 'Injoignable__c ' est cochée puis cas où la date de debut est renseignée ou non
            if( mapOldConges.get(indispo.Id).Injoignable__c == false && indispo.Injoignable__c == true){
                if(indispo.Injoignable_depuis_le__c != null){
                    Historique_Injoignabilites__c inj = new Historique_Injoignabilites__c( Compte__c = indispo.Nom_du_compte__c , Indisponibilite__c = indispo.Id, 
                                                                                          Date_de_debut1__c = indispo.Injoignable_depuis_le__c, Date_de_fin1__c = null);
                    injoignabiliteToInsert.add(inj);
                    system.debug(' nouvel injoignabilité avec date de début indiquée : ' + inj);
                }else{
                    Historique_Injoignabilites__c inj = new Historique_Injoignabilites__c( Compte__c = indispo.Nom_du_compte__c , Indisponibilite__c = indispo.Id, Date_de_debut1__c = Date.today(), Date_de_fin1__c = null);   
                    injoignabiliteToInsert.add(inj);
                    system.debug(' nouvel injoignabilité sans date de début indiquée : ' + inj);
                }
           	// Cas où la case 'Injoignable__c' est décochée puis renseignement de la date de fin de l'injoignabilité correspondante
            }else if(mapOldConges.get(indispo.Id).Injoignable__c == true && indispo.Injoignable__c == false){
                system.debug(' size de la liste injoignabilite de : ' +  mapOldConges.get(indispo.Id).Historique_Injoignabilites__r  + ' ' +  mapInjoignabiliteACloturer.get(indispo.Id)  );
                for(Historique_Injoignabilites__c hi : mapInjoignabiliteACloturer.get(indispo.Id)){                
                    hi.Date_de_fin1__c = Date.today();
                    injoignabiliteToUpdate.add(hi); 
                    System.debug(' update de l\'injoignabilité ' + hi);
                }
                // Cas où la case 'Injoignable__c' est déjà cochée et la date de début a été nouvellement renseignée
            }else if( mapOldConges.get(indispo.Id).Injoignable__c == indispo.Injoignable__c && indispo.Injoignable__c == true
                     && mapOldConges.get(indispo.Id).Injoignable_depuis_le__c != indispo.Injoignable_depuis_le__c ){
                         for(Historique_Injoignabilites__c hi : mapInjoignabiliteACloturer.get(indispo.Id)){
                             hi.Date_de_debut1__c = indispo.Injoignable_depuis_le__c;
                             injoignabiliteToUpdate.add(hi);
                             System.debug(' update de la date de debut de l\'injoignabilité ' + hi);
                         }
                         
                     }
        }
        
        
        
        if(injoignabiliteToInsert.IsEmpty() != true){ 
            try{
                insert injoignabiliteToInsert;
            }catch(Exception e){
                System.debug(LoggingLevel.Error, e.getMessage());
            }
        }    
        
        
        if(injoignabiliteToUpdate.isEmpty() != true){ 
            try{
                update injoignabiliteToUpdate;  
            }catch(Exception e){
                System.debug(LoggingLevel.Error, e.getMessage());
            }
            
        }
        
        
    }
    
    
}