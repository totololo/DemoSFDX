public class AP05_Conge_Indispo {

    Id congeRTypeId = Label.CongeRT_15;
    Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    Id dispoRTypeId = Label.DispoRT_15;

    
    // Cas où suite à la création d'une indisponibilité, il y a création de l'injoignabilité correspondante si la case 'Injoignable' est cochée
    public void insertInjoignabilite(List<Conge_Indispo__c> newIndispo){
        
        List<Conge_Indispo__c> listeIndispoInjoignables = new List<Conge_Indispo__c>();
        
        for(Conge_Indispo__c cong : newIndispo){
            System.debug(' Injoignabilite : new ' + cong.Injoignable__c  );
            
            if(cong.RecordTypeId == indispoStandardRTypeId || cong.RecordTypeId == indispoConsigneRTypeId){
                   
                   System.debug('Appel méthode de création d\'une injoignabilité pour indispo nouvellement créee : ' + cong);
                   listeIndispoInjoignables.add(cong);
               }
        }
        
        
        if(listeIndispoInjoignables.isEmpty() != true ){ 
            newInjoignabilite(listeIndispoInjoignables); }
    }
    
    
    
    public void newInjoignabilite(List<Conge_Indispo__c> listeIndispoInjoignables){
        
        List<Historique_Injoignabilites__c> injoignabiliteToInsert = new List<Historique_Injoignabilites__c>();
     
        for(Conge_Indispo__c indispo : listeIndispoInjoignables){
            if( indispo.Injoignable__c == true){
                // si le champs 'Injoignable_depuis_le__c' (= date de debut de l'injoignabilité) est renseigné ou non 
                if(indispo.Injoignable_depuis_le__c != null){
                    Historique_Injoignabilites__c inj = new Historique_Injoignabilites__c( Compte__c = indispo.Nom_du_compte__c , Indisponibilite__c = indispo.Id, 
                                                                                          Date_de_debut1__c = indispo.Injoignable_depuis_le__c, Date_de_fin1__c = null);
                    injoignabiliteToInsert.add(inj);
                    system.debug(' nouvel injoignabilité avec date de début indiquée : ' + inj);
                }else{
                    Historique_Injoignabilites__c inj = new Historique_Injoignabilites__c( Compte__c = indispo.Nom_du_compte__c , Indisponibilite__c = indispo.Id, Date_de_debut1__c = indispo.Date_de_debut__c, Date_de_fin1__c = null);   
                    injoignabiliteToInsert.add(inj);
                    system.debug(' nouvel injoignabilité sans date de début indiquée : ' + inj);
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
         
    }
    
}