/* Author       : Sami Diab
* Date          : 2016-11-14
* Description   : This class is made to check the Service and Transporteur associations 
*/
public class AP01_Account {
    
    public static boolean firstRun = true;
    private static Id PUDO_RT_Converti_PickupContact = Label.PUDO_RT_Prospect_Converti_Pickup_Contact_18;
    
    public static void UpdateAssociations(List<Account> oldAccounts, List<Account> newAccounts){
        
        
        //The list of accounts that associations will be updated
        List<Account> listAccountsInvolved = new List<Account>();
        List<Account> listAccountsReseau = new List<Account>();
        //Macroprofils involved
        Set<Id> setMacroprofils = new Set<Id>();
        //Get the accounts that their Macroprofil has changed
        if (oldAccounts == null)
            oldAccounts = new List<Account>();
        Map<Id,Account> mapOldAccounts = new Map<Id,Account>(oldAccounts);
        Account oldAccount;
        String strActEtat = '';
        boolean bActuel = false;
        for (Account newAccount : newAccounts){ 
            System.debug(';;;gho account id : ' + account.Id);
            oldAccount =  mapOldAccounts.get(newAccount.Id);
            strActEtat = newAccount.Etat__c;
            // A partir de l'état 4 on prends le MP actuel en considération
            if((!strActEtat.equals('0') &&  !strActEtat.equals('1') && !strActEtat.equals('2') && label.RT_France_Compte.contains(newAccount.recordTypeId)) || label.RT_INT_Compte.contains(newAccount.recordTypeId) || label.RT_INT_Compte2.contains(newAccount.recordTypeId) ) {
                bActuel = true;
            }
            if(oldAccount <> null){ 
                if(oldAccount.Macroprofil_de_reference__c != newAccount.Macroprofil_de_reference__c
                   || oldAccount.Macroprofil_actuel__c != newAccount.Macroprofil_actuel__c){
                       listAccountsInvolved.add(newAccount);
                       if(bActuel) {
                           setMacroprofils.add(newAccount.Macroprofil_actuel__c);
                       } else {
                           setMacroprofils.add(newAccount.Macroprofil_de_reference__c);
                       }
                }
                
                //ischanged any of the 6 fields on account do the check on reseau LZO
                if(oldAccount.Type != newAccount.Type || oldAccount.Industry != newAccount.Industry  || oldAccount.Partenaire__c != newAccount.Partenaire__c 
                   || oldAccount.Horaire_Ouverture_Reference__c != newAccount.Horaire_Ouverture_Reference__c  || oldAccount.Horaire_Fermeture_Reference__c != newAccount.Horaire_Fermeture_Reference__c
                   || oldAccount.Poids_maximal_accepte_par_colis__c != newAccount.Poids_maximal_accepte_par_colis__c 
                   || oldAccount.Macroprofil_de_reference__c != newAccount.Macroprofil_de_reference__c
                   || oldAccount.Macroprofil_actuel__c != newAccount.Macroprofil_actuel__c
                  ){
                      listAccountsReseau.add(newAccount);
                      if(bActuel) {
                          setMacroprofils.add(newAccount.Macroprofil_actuel__c);
                      } else {
                          setMacroprofils.add(newAccount.Macroprofil_de_reference__c);
                      }
                  }
            }
            else{ 
                listAccountsInvolved.add(newAccount);
                if(bActuel) {
                    setMacroprofils.add(newAccount.Macroprofil_actuel__c);
                } else {
                    setMacroprofils.add(newAccount.Macroprofil_de_reference__c);
                }
                listAccountsReseau.add(newAccount);
            }
        } 
        
        
        
        // modified by : gho
        // modification date : 15/05/2017
        // modification purpose : Pickup Contacts are converted from a lead. 
        //                        MPs are not filled in first run. They are filled through the PB : PRO_PB01_ConversionMappageProspectCompte
        
        boolean isPickUpContact = false;
        if(listAccountsInvolved.size() == 1  && oldAccounts.size() == 1 ) {            
            Account acct = listAccountsInvolved.get(0);
            Account oldAcct = mapOldAccounts.get(acct.Id);  
             
            if(acct.RecordTypeId == PUDO_RT_Converti_PickupContact && acct.RecordTypeId != oldAcct.RecordTypeId) { 
                isPickUpContact = true;  
            }
        }
        
        
        
        boolean insideLoop = false;
        Account pickupAccount = null;
        if(listAccountsInvolved.size() > 0 ){
            if(firstRun || isPickUpContact){
                insideLoop = true;
                AP04_Account.isFirstRun=true;
                UpdateTransporteurAssociations(listAccountsInvolved,setMacroprofils);
                AP04_Account.isFirstRun=true;
                UpdateServiceAssociations(listAccountsInvolved,setMacroprofils);
                AP04_Account.isFirstRun=false;
            } 
        }
        System.debug(';;;gho listAccountsReseau : ' + listAccountsReseau.size());
        if(listAccountsReseau.size() > 0){ 
            if(PAD.canTrigger('AP04_Account')) {  
                if(firstRun || isPickUpContact){
                    insideLoop = true;
                    AP04_Account ap04Acc = new AP04_Account();
                    ap04Acc.UpdateReseauAssociations(listAccountsReseau, setMacroprofils); //LZO
                }
            } 
        }
        User currentUser = [Select BypassApex__c , BypassProcessBuilder__c , BypassWorkflow__c
                            from User 
                            where Id=:UserInfo.getUserId()];
        if(insideLoop && !currentUser.BypassProcessBuilder__c && !currentUser.BypassWorkflow__c){
            firstRun = false;
        }
        
        
    }
    
    private static void UpdateTransporteurAssociations(List<Account> listAccountsInvolved, set<Id> setMacroprofils){
        //Set of AccountIds
        Set<Id> setAccountIds = new Map<Id,Account>(listAccountsInvolved).keySet();
        //Get list of Macroprofil_Transporteur__c
        List<Macroprofil_Transporteur__c> listMacroprofilTransporteurs = [Select Id, Macroprofil__c, Transporteur__c, Active__c, Exclut__c, Interdit__c, Modifiable__c  From Macroprofil_Transporteur__c Where Macroprofil__c in: setMacroprofils];         
        //Get all Transporteur Associations that exist
        List<Transporteur_Associe__c> listTransporteurAssocies = [Select Id, Compte__c, Transporteur__c,Modifiable__c, Active__c, tech_bypassNonModifiableCheck__c  From Transporteur_Associe__c Where Compte__c in: setAccountIds]; 
        Map<Id,Set<Id>> mapMacroprofilTransporteurs = new Map<Id,Set<Id>>();
        Map<Id,List<Transporteur_Associe__c>> mapAccountTransporteurs = new Map<Id,List<Transporteur_Associe__c>>();
        Map<Id,map<Id,Macroprofil_Transporteur__c>> mapMacroprofilIdTransporteurMPT = new Map<Id,map<Id,Macroprofil_Transporteur__c>>();
        //Map Macroprofil et Transporteur
        string macroprofil = '';
        string transporteurId = '';
        for(Macroprofil_Transporteur__c mt : listMacroprofilTransporteurs) {  
            macroprofil = mt.Macroprofil__c;  
            transporteurId = mt.Transporteur__c;
            if(mapMacroprofilTransporteurs.containsKey(macroprofil)){
                mapMacroprofilTransporteurs.get(macroprofil).add(transporteurId);
            }else{
                mapMacroprofilTransporteurs.put(macroprofil, new Set<Id>{transporteurId});
                //mapIdMacroprofilIdTransporteurMT.put(mt.Macroprofil__c, new map<Id,Macroprofil_Transporteur__c>{mt});
            }
            
            //LZO Start 
            if(!mapMacroprofilIdTransporteurMPT.containskey(macroprofil)){
                mapMacroprofilIdTransporteurMPT.put(macroprofil, new map<Id,Macroprofil_Transporteur__c>());
            }
            map<Id,Macroprofil_Transporteur__c> mapTranporteurMPT = mapMacroprofilIdTransporteurMPT.get(macroprofil);
            if(!mapTranporteurMPT.containsKey(transporteurId)){
                mapTranporteurMPT.put(transporteurId, mt);
            }
            mapMacroprofilIdTransporteurMPT.put(macroprofil, mapTranporteurMPT);
            //LZO End
        }
        
        //Map Account et Transporteur
        for(Transporteur_Associe__c ta : listTransporteurAssocies){ 
            if(mapAccountTransporteurs.containsKey(ta.Compte__c)){
                mapAccountTransporteurs.get(ta.Compte__c).add(ta);
            }else{
                mapAccountTransporteurs.put(ta.Compte__c, new List<Transporteur_Associe__c>{ta});
            }
        }
        List<Transporteur_Associe__c> listTAToUpsert = new List<Transporteur_Associe__c>();
        Set<Id> setTransporteursAlreadyExist;
        List<Transporteur_Associe__c> listTransporteursExistant;
        Set<Id> setTransporteursActifs;
        map<Id, Macroprofil_Transporteur__c> mapTransporteurMPT = new map<Id, Macroprofil_Transporteur__c>();
        Macroprofil_Transporteur__c mt = null;
        String strActEtat = '';
        boolean bActuel = false;
        for(Account acc : listAccountsInvolved){
            strActEtat = acc.Etat__c;
            // A partir de l'état 4 on prends le MP actuel en considération
            if((!strActEtat.equals('0') &&  !strActEtat.equals('1') && !strActEtat.equals('2') && label.RT_France_Compte.contains(acc.recordTypeId)) || label.RT_INT_Compte.contains(acc.recordTypeId) || label.RT_INT_Compte2.contains(acc.recordTypeId)) {
                bActuel = true;
            }
            setTransporteursAlreadyExist = new Set<Id>();
            listTransporteursExistant = new List<Transporteur_Associe__c>();
            setTransporteursActifs = new Set<Id>();
            
            listTransporteursExistant = mapAccountTransporteurs.get(acc.Id);
            if(bActuel) {
                setTransporteursActifs =  mapMacroprofilTransporteurs.get(acc.Macroprofil_actuel__c);
            } else {
                setTransporteursActifs =  mapMacroprofilTransporteurs.get(acc.Macroprofil_de_reference__c);
            } 
            
            //Set<Microprofil_Transporteur__c> setMT = mapIdMacroprofilMT.get(acc.Macroprofil_de_reference__c);
            //Map<Id,Microprofil_Transporteur__c> mapTranporteurMT = new Map<Id,Microprofil_Transporteur__c>();
            if(listTransporteursExistant != null){
                for(Transporteur_Associe__c ta : listTransporteursExistant){
                    //To be used for the fields to propagate
                    // (mapIdMacMacroprofil_Transporteur__c mt =roprofilIdTransporteurMT.get(acc.Macroprofil_actuel__c)).get(ta.Transporteur__c);
                    
                    //If Transporteur no longer exists on MacroProfil -> deactivate it
                    if((setTransporteursActifs!=null && !setTransporteursActifs.contains(ta.Transporteur__c) && ta.Active__c) || (setTransporteursActifs == null) ){
                        ta.Modifiable__c = false;
                        ta.Active__c = false;
                        ta.tech_bypassNonModifiableCheck__c = !ta.tech_bypassNonModifiableCheck__c;
                        listTAToUpsert.add(ta);
                    }else{
                        //LZO
                        if( ((!strActEtat.equals('0') &&  !strActEtat.equals('1') && !strActEtat.equals('2')) && mapMacroprofilIdTransporteurMPT.containsKey(acc.Macroprofil_actuel__c)) || mapMacroprofilIdTransporteurMPT.containsKey(acc.Macroprofil_de_reference__c)){
                            
                            if(bActuel) {
                                mapTransporteurMPT = mapMacroprofilIdTransporteurMPT.get(acc.Macroprofil_actuel__c);
                            } else {
                                mapTransporteurMPT = mapMacroprofilIdTransporteurMPT.get(acc.Macroprofil_de_reference__c);
                            }
                            if(mapTransporteurMPT.containsKey(ta.Transporteur__c)){
                                mt = mapTransporteurMPT.get(ta.Transporteur__c);
                                ta.Active__c = mt.Active__c;
                                ta.Modifiable__c = mt.Modifiable__c;
                                ta.Exclu__c = mt.Exclut__c;
                                ta.Interdit__c = mt.Interdit__c;
                                ta.tech_bypassNonModifiableCheck__c = !ta.tech_bypassNonModifiableCheck__c; 
                                listTAToUpsert.add(ta);
                            }
                        }
                        setTransporteursAlreadyExist.add(ta.Transporteur__c);
                    }
                }
            }
            if(setTransporteursActifs != null){
                
                setTransporteursActifs.removeAll(setTransporteursAlreadyExist);  
                for(Id transporteur : setTransporteursActifs){
                    //LZO 
                    if( (bActuel && mapMacroprofilIdTransporteurMPT.containsKey(acc.Macroprofil_actuel__c)) || mapMacroprofilIdTransporteurMPT.containsKey(acc.Macroprofil_de_reference__c)){
                        if(bActuel) {
                            mapTransporteurMPT = mapMacroprofilIdTransporteurMPT.get(acc.Macroprofil_actuel__c);
                        } else {
                            mapTransporteurMPT = mapMacroprofilIdTransporteurMPT.get(acc.Macroprofil_de_reference__c);
                        }
                        if(mapTransporteurMPT.containsKey(transporteur)){
                            mt = mapTransporteurMPT.get(transporteur);
                            Transporteur_Associe__c ta = new Transporteur_Associe__c();
                            ta.Transporteur__c = transporteur;
                            ta.Compte__c = acc.Id;
                            ta.Active__c = mt.Active__c;
                            ta.Modifiable__c = mt.Modifiable__c;
                            ta.Exclu__c = mt.Exclut__c;
                            ta.Interdit__c = mt.Interdit__c;
                            listTAToUpsert.add(ta);
                        }
                    }
                }
            }
        }
        if(listTAToUpsert.size() > 0){
            upsert listTAToUpsert;
        }
    }
    
    private static void UpdateServiceAssociations(List<Account> listAccountsInvolved, set<Id> setMacroprofils){
        //Set of AccountIds
        Set<Id> setAccountIds = new Map<Id,Account>(listAccountsInvolved).keySet();
        
        //Get list of Macroprofil_Service__c
        List<Macroprofil_Service__c> listMacroprofilServices = [Select Id, Active__c, Modifiable__c, Exclu__c, Interdit__c, Macroprofil__c, Service__c From Macroprofil_Service__c Where Macroprofil__c in: setMacroprofils]; 
        Map<Id,Macroprofil_Service__c> mapIdMacroprofilServices = new Map<Id,Macroprofil_Service__c>(listMacroprofilServices);
        
        //Get all Service Associations that exist
        List<Service_Associe__c> listServiceAssocies = [Select Id, Compte__c, Service__c,Modifiable__c, Active__c, tech_bypassNonModifiableCheck__c  From Service_Associe__c Where Compte__c in: setAccountIds]; 
        
        Map<Id,Set<Id>> mapMacroprofilServices = new Map<Id,Set<Id>>();
        Map<Id,List<Service_Associe__c>> mapAccountServices = new Map<Id,List<Service_Associe__c>>();
        Map<Id,map<Id,Macroprofil_Service__c>> mapMacroprofilIdServiceMPT = new Map<Id,map<Id,Macroprofil_Service__c>>();
        //Map Macroprofil et Service
        string macroprofil = '';
        string serviceId = '';
        for(Macroprofil_Service__c mt : listMacroprofilServices){ 
            macroprofil = mt.Macroprofil__c;  
            serviceId = mt.Service__c;
            if(mapMacroprofilServices.containsKey(macroprofil)){
                mapMacroprofilServices.get(macroprofil).add(serviceId);
            }else{
                mapMacroprofilServices.put(mt.Macroprofil__c, new Set<Id>{serviceId});
            }
            //LZO Start 
            if(!mapMacroprofilIdServiceMPT.containskey(macroprofil)){
                mapMacroprofilIdServiceMPT.put(macroprofil, new map<Id,Macroprofil_Service__c>());
            }
            map<Id,Macroprofil_Service__c> mapServiceMPT = mapMacroprofilIdServiceMPT.get(macroprofil);
            if(!mapServiceMPT.containsKey(serviceId)){
                mapServiceMPT.put(serviceId, mt);
            }
            mapMacroprofilIdServiceMPT.put(macroprofil, mapServiceMPT);
            //LZO End
        }
        
        //Map Account et Service
        for(Service_Associe__c ta : listServiceAssocies){ 
            if(mapAccountServices.containsKey(ta.Compte__c)){
                mapAccountServices.get(ta.Compte__c).add(ta);
            }else{
                mapAccountServices.put(ta.Compte__c, new List<Service_Associe__c>{ta});
            }
        }
        
        
        List<Service_Associe__c> listTAToUpsert = new List<Service_Associe__c>();
        
        
        Set<Id> setServicesAlreadyExist;
        List<Service_Associe__c> listServicesExistant;
        Set<Id> setServicesActifs;
        
        map<Id, Macroprofil_Service__c> mapServiceMPT = new map<Id, Macroprofil_Service__c>();
        Macroprofil_Service__c ms = null;
        String strActEtat = '';
        boolean bActuel = false;
        for(Account acc : listAccountsInvolved){
            strActEtat = acc.Etat__c;
            if((!strActEtat.equals('0') &&  !strActEtat.equals('1') && !strActEtat.equals('2') && label.RT_France_Compte.contains(acc.recordTypeId)) || label.RT_INT_Compte.contains(acc.recordTypeId) || label.RT_INT_Compte2.contains(acc.recordTypeId)) {
                bActuel = true;
            }
            
            //To be used for the fields to propagate
            if(bActuel) {
                Macroprofil_Service__c mt = mapIdMacroprofilServices.get(acc.Macroprofil_actuel__c);
            } else {
                Macroprofil_Service__c mt = mapIdMacroprofilServices.get(acc.Macroprofil_de_reference__c);
            }
            
            setServicesAlreadyExist = new Set<Id>();
            listServicesExistant = new List<Service_Associe__c>();
            setServicesActifs = new Set<Id>();
            
            listServicesExistant = mapAccountServices.get(acc.Id);
            if(bActuel) {
                setServicesActifs =  mapMacroprofilServices.get(acc.Macroprofil_actuel__c);
            } else {
                setServicesActifs =  mapMacroprofilServices.get(acc.Macroprofil_de_reference__c);
            }
            
            if(listServicesExistant != null){
                for(Service_Associe__c ta : listServicesExistant){
                    if((setServicesActifs != null && !setServicesActifs.contains(ta.Service__c) && ta.Active__c) || (setServicesActifs == null)){
                        ta.Modifiable__c = false;
                        ta.Active__c = false;
                        ta.tech_bypassNonModifiableCheck__c = !ta.tech_bypassNonModifiableCheck__c;
                        listTAToUpsert.add(ta);
                    }else{
                        //LZO
                        if( (bActuel && mapMacroprofilIdServiceMPT.containsKey(acc.Macroprofil_actuel__c)) || mapMacroprofilIdServiceMPT.containsKey(acc.Macroprofil_de_reference__c)){
                            if(bActuel) {
                                mapServiceMPT = mapMacroprofilIdServiceMPT.get(acc.Macroprofil_actuel__c);
                            } else {
                                mapServiceMPT = mapMacroprofilIdServiceMPT.get(acc.Macroprofil_de_reference__c);
                            }
                            if(mapServiceMPT.containsKey(ta.Service__c)){
                                ms = mapServiceMPT.get(ta.Service__c);
                                ta.Active__c = ms.Active__c;
                                ta.Modifiable__c = ms.Modifiable__c;
                                ta.Exclu__c = ms.Exclu__c;
                                ta.Interdit__c = ms.Interdit__c;
                                ta.tech_bypassNonModifiableCheck__c = !ta.tech_bypassNonModifiableCheck__c;
                                listTAToUpsert.add(ta);
                            }
                        }
                        setServicesAlreadyExist.add(ta.Service__c); 
                    }
                }
            }
            
            if(setServicesActifs != null){
                setServicesActifs.removeAll(setServicesAlreadyExist);   
                for(Id Service : setServicesActifs){
                    //LZO 
                    if( (bActuel && mapMacroprofilIdServiceMPT.containsKey(acc.Macroprofil_actuel__c)) || mapMacroprofilIdServiceMPT.containsKey(acc.Macroprofil_de_reference__c)){
                        if(bActuel) {
                            mapServiceMPT = mapMacroprofilIdServiceMPT.get(acc.Macroprofil_actuel__c);
                        } else {
                            mapServiceMPT = mapMacroprofilIdServiceMPT.get(acc.Macroprofil_de_reference__c);
                        }
                        if(mapServiceMPT.containsKey(Service)){
                            ms = mapServiceMPT.get(Service);
                            Service_Associe__c ta = new Service_Associe__c();
                            ta.Service__c = Service;
                            ta.Compte__c = acc.Id;
                            ta.Active__c = ms.Active__c;
                            ta.Modifiable__c = ms.Modifiable__c;
                            ta.Exclu__c = ms.Exclu__c;
                            ta.Interdit__c = ms.Interdit__c;
                            listTAToUpsert.add(ta);
                        }
                    }
                }
            }
        }
        
        if(listTAToUpsert.size() > 0){
            upsert listTAToUpsert;
        }
    }
}