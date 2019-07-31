public class AP03_Conge_Indispo {
    
    Id congeRTypeId = Label.CongeRT_15;
    Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    Id dispoRTypeId = Label.DispoRT_15;
    
    // vérifie si le congé est en cours, si c'est le cas sa suppression est impossible
    public void datesEnCours(List<Conge_Indispo__c> congesToDelete){
        //congeIndispo.Statut__c.equals(Label.CongeIndispo_En_Cours
        for(Conge_Indispo__c c : congesToDelete){  
            //if(c.Date_de_debut__c <= Date.today() && c.Type_d_indisponibilite__c != Label.pas_de_PDA_assos ){
                if(c.Date_de_debut__c <= Date.today() ){
                    if(c.Statut__c.equalsIgnoreCase(Label.CongeIndispo_En_Cours)) {
                        c.addError( Label.Suppression_date_en_cours);
                    } else if(c.Statut__c.equalsIgnoreCase(Label.Conge_Indispo_Passe)){
                        c.addError( Label.supp_cong_date_passe);
                    }
                }
            }
        }   
    }