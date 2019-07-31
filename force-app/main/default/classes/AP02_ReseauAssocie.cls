public class AP02_ReseauAssocie {
    
    public static void checkAssociations(Set<Id> setAccountIds)
    {
        //Check if the number of transporteur_associe is equal to 1, i.e. it's coming from the GUI so no need to call the batch 
        //else if the number is bigger than 1 than we need to call the trigger in order not to hit the limits.
        if(!System.isBatch()){
            list<Account> listAccounts = [select Id, Macroprofil_de_reference__c,Macroprofil_actuel__c, Type, Industry, Partenaire__c, Etat__c, RecordTypeId, 
                                          Horaire_Ouverture_Reference__c, Horaire_Fermeture_Reference__c, Poids_maximal_accepte_par_colis__c
                                          from Account where Id in : setAccountIds];
            System.debug('###gho listAccounts : ' + listAccounts);
            set<Id> setMacroprofilIds = new set<Id>();
            for(Account acc : listAccounts){
                setMacroprofilIds.add(acc.Macroprofil_actuel__c);
            }
            System.debug('###gho setMacroprofilIds : ' + setMacroprofilIds );
            AP04_Account ap04Acc = new AP04_Account();
            ap04Acc.UpdateReseauAssociations(listAccounts, setMacroprofilIds);
        }else{      
            //If size>1 the batch lunched from AP02_MacroprofilTransporteur or AP03_MacroptofilService should handle it
          
        }
    }
}