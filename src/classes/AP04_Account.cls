/*
* Class to verify reseau association creation on Account
* @author: Lea Zoghbi
* @date: 19/12/2016
* @Test: AP04_Account_TEST
*/
public class AP04_Account {
    public  list<Macroprofil_Reseau__c> listMacroprofilReseau {get; set;}
    public  set<Id> setReseauIds{get; set;}
    public  map<Id, map<Reseau__c, Macroprofil_Reseau__c>> mapMacroprofilReseauId {get; set;}
    
    public  static boolean isFirstRun = false;
    
    public  void UpdateReseauAssociations(List<Account> listAccountsInvolved, set<Id> setMacroprofils){
        System.debug(';;;gho listAccountsInvolved : ' + listAccountsInvolved);
        System.debug(';;;gho setMacroprofils : ' + setMacroprofils);
        if(!isFirstRun){
            Utils_PUS.firstAllRun = true;
            //get from the Macroprofil the Macroprofil reseau
            listMacroprofilReseau = [select id, Macroprofil__c, Reseau__c, Active__c, Modifiable__c,Exclu__c,Interdit__c
                                     from Macroprofil_Reseau__c
                                     where Macroprofil__c in: setMacroprofils];
            System.debug(';;;gho listMacroprofilReseau : ' + listMacroprofilReseau.size());
            //fill macroprofil reseau set, map
            fillMacroprofilReseau();
            manipulateMacroprofilReseau(listAccountsInvolved, true);
        }
        isFirstRun = true;
    }
    
    public  void checkServiceConditions(List<Account> listAccountsInvolved){
        //obtain all service associe for all accounts that are ACTIVE
        map<Id, list<Id>> mapAccountServiceAssocie = new map<Id, list<Id>>();
        map<Id, Service_Associe__c> mapServiceServiceAssocie = new map<Id, Service_Associe__c>();
        //fill the service associe per account in a map
        Id accountID = null;
        Id svId = null;
        
        //To manage queries bigger than 200000
        integer iteration = 8;
        for(list<Service_Associe__c> raList : [ select Id, Active__c, Compte__c, Macroprofil__c, Service__c
                                               from Service_Associe__c
                                               where Compte__c in : listAccountsInvolved]){
                                                   for(Service_Associe__c ra : raList){
                                                       accountID = ra.Compte__c;
                                                       if(!mapAccountServiceAssocie.containsKey(accountID)){
                                                           mapAccountServiceAssocie.put(accountID, new list<Id>());
                                                       }
                                                       svId = ra.Service__c;
                                                       mapAccountServiceAssocie.get(accountID).add(svId);
                                                       mapServiceServiceAssocie.put(svId, ra);
                                                   }
                                               } 
        
        // get the service associe au reseau                                                     
        //By dany
        map<Id, list<Id>> mapReseauIdReseauService = new map<Id, list<Id>>();
        for(List<Reseau_Service__c> reseauList :  [select id, Reseau__c, Service__c
                                                   from Reseau_Service__c 
                                                   where Reseau__c in:setReseauIds]){
                                                       // fill them in a map reseauId list of service Ids           
                                                       Id reseauId = null;
                                                       for(Reseau_Service__c rs : reseauList){
                                                           reseauId = rs.Reseau__c;
                                                           if(!mapReseauIdReseauService.containsKey(reseauId)){
                                                               mapReseauIdReseauService.put(reseauId, new list<Id>());
                                                           }
                                                           mapReseauIdReseauService.get(reseauId).add(rs.Service__c);
                                                       }
                                                   }
        
        
        if(mapReseauIdReseauService.size() > 0){
            
            map<Id, list<Id>> mapMacroProfilReseauService = new map<Id, list<Id>>();
            Id macroprofil = null; 
            map<Id,Macroprofil_Reseau__c> mapReseauMPReseau = new map<Id,Macroprofil_Reseau__c>();
            list<Id> listReseauServiceOfMP = new list<Id>(); 
            
            //By dany  
            map<Id,List<Id>> map_MP_Res = new map<id,List<Id>>();
            for(Macroprofil_Reseau__c mpr : listMacroprofilReseau){
                macroprofil = mpr.Macroprofil__c;
                List<Id> intenalList = new List<Id>();
                if(map_MP_Res.containsKey(macroprofil))
                    intenalList = map_MP_Res.get(macroprofil);
                intenalList.add(mpr.Reseau__c);
                map_MP_Res.put(macroprofil, intenalList);
            }
            
            
            set<Id> setReseauServiceAccount = new set<Id>();
            set<Id> setServiceAssocieAccount = new set<Id>();
            
            list<Id> listServiceIdsVerified = new list<Id>();
            
            //set of service who are not verified
            set<Id> setServiceIdsNotVerified = new set<Id>();
            
            // checks for every account in trigger if condition 1 is met
            // Les services associés au réseau doivent exister parmi les services activés sur le PUDO.
            String strActEtat = '';
            boolean bActuel = false;
            for(Account acc : listAccountsInvolved){ 
                strActEtat = acc.Etat__c;
                 if((!strActEtat.equals('0') &&  !strActEtat.equals('1') && !strActEtat.equals('2') && label.RT_France_Compte.contains(acc.recordTypeId)) || label.RT_INT_Compte.contains(acc.recordTypeId) || label.RT_INT_Compte2.contains(acc.recordTypeId)) {
                    bActuel = true;
                 }
                //reinitializations per account
                setReseauServiceAccount = new set<Id>();
                setServiceAssocieAccount = new set<Id>();
                // get the service ids from reseau services per account
                // DANY
                if( (bActuel && map_MP_Res.containsKey(acc.Macroprofil_actuel__c)) || map_MP_Res.containsKey(acc.Macroprofil_de_reference__c)){
                    List<Id> reseauIds = null;
                    if(bActuel) { 
                        reseauIds = map_MP_Res.get(acc.Macroprofil_actuel__c);
                    } else {
                        reseauIds = map_MP_Res.get(acc.Macroprofil_de_reference__c);
                    }
                    
                    for(Id reseauId: reseauIds){
                        list<Id> internalList = null;
                        if(mapReseauIdReseauService.containsKey(reseauId)) {
                            internalList = mapReseauIdReseauService.get(reseauId);
                        }
                        if(internalList != null)
                            setReseauServiceAccount.addAll(internalList);
                    } 
                    // setReseauServiceAccount = new Set<String>(mapMacroProfilReseauService.get(acc.Macroprofil_de_reference__c));
                }

                //get the service Id from service Associe per account
                if(mapAccountServiceAssocie.containsKey(acc.Id)){
                    setServiceAssocieAccount = new Set<Id>(mapAccountServiceAssocie.get(acc.Id));
                }
                //check condition 1  
                for(Id sa: setReseauServiceAccount){
                    if(setServiceAssocieAccount.contains(sa)){
                        if(mapServiceServiceAssocie.containsKey(sa) && mapServiceServiceAssocie.get(sa).Active__c){
                            listServiceIdsVerified.add(sa);
                            //if(setServiceIdsNotVerified.contains(sa)) {
                            //   setServiceIdsNotVerified.remove(sa);
                            // }
                        }else{
                            setServiceIdsNotVerified.add(sa);
                        } 
                    }else{
                        setServiceIdsNotVerified.add(sa);
                    }
                }
                for(Id verified : listServiceIdsVerified) {
                    if(setServiceIdsNotVerified.contains(verified)) {
                        setServiceIdsNotVerified.remove(verified);
                    }
                }
                
            }
            
            
            list<Reseau_Service__c> listReseauServiceNotVerified = [select id, Service__c, Reseau__c 
                                                                    from Reseau_Service__c
                                                                    where Service__c in: setServiceIdsNotVerified];
            set<Id> setReseauIdsToRemove = new set<Id>();
            for(Reseau_Service__c rs : listReseauServiceNotVerified){
                setReseauIdsToRemove.add(rs.Reseau__c);
            }
            
            listMacroprofilReseau = new list<Macroprofil_Reseau__c>();
            
            //get list of reseaux Ids
            set<Id> tempReseauIds = new set<Id>();
            for(Id rsId : setReseauIds){
                if(!setReseauIdsToRemove.contains(rsId)){
                    tempReseauIds.add(rsId);
                }
            }
            setReseauIds = new set<Id>();
            setReseauIds = tempReseauIds;
            
            listMacroprofilReseau = [ select id, Macroprofil__c, Reseau__c, Active__c, Modifiable__c,Exclu__c,Interdit__c
                                     from Macroprofil_Reseau__c
                                     where Reseau__c in: setReseauIds ]; 
        }
    }
    
    public  void checkTransporteurConditions(List<Account> listAccountsInvolved){
        //obtain all transporteur associe for all accounts 
        list<Transporteur_Associe__c> listTransporteurAssocie = [ select Id, Active__c, Compte__c, Macroprofil__c, Transporteur__c
                                                                 from Transporteur_Associe__c
                                                                 where  Compte__c in : listAccountsInvolved]; //Active__c = true and
        
        
        
        map<Id, list<Id>> mapAccountTransporteurAssocie = new map<Id, list<Id>>();
        map<Id, Transporteur_Associe__c> mapTransporteurTransporteurAssocie = new map<Id, Transporteur_Associe__c>();
        //fill the transporteur associe per account in a map
        Id accountID = null;
        Id transId = null;
        set<Id> setAccountIdsToRemove = new set<Id>();
        for(Transporteur_Associe__c ta : listTransporteurAssocie){
            accountID = ta.Compte__c;
            if(!mapAccountTransporteurAssocie.containsKey(accountID)){
                mapAccountTransporteurAssocie.put(accountID, new list<Id>());
            }
            transId = ta.Transporteur__c;
            mapAccountTransporteurAssocie.get(accountID).add(transId); 
            
            mapTransporteurTransporteurAssocie.put(transId, ta);
        }
        
        // fill them in a map reseauId list of transporteur Ids
        map<Id, list<Id>> mapReseauIdReseauTransporteur = new map<Id, list<Id>>();                                                     
        for(list<Reseau_Transporteur__c> listReseauTransporteur : [ select Id, Reseau__c, Transporteur__c
                                                                   from Reseau_Transporteur__c
                                                                   where Reseau__c in: setReseauIds]){
                                                                       for(Reseau_Transporteur__c rt : listReseauTransporteur){
                                                                           Id reseauId = rt.Reseau__c;
                                                                           if(!mapReseauIdReseauTransporteur.containsKey(reseauId)){
                                                                               mapReseauIdReseauTransporteur.put(reseauId, new list<Id>());
                                                                           }
                                                                           mapReseauIdReseauTransporteur.get(reseauId).add(rt.Transporteur__c);
                                                                       }
                                                                   }                                                            
        
        
        
        if(mapReseauIdReseauTransporteur.size() > 0){
            
            map<Id,List<Id>> map_MP_Trans = new map<id,List<Id>>();
            for(Macroprofil_Reseau__c mpr : listMacroprofilReseau){
                Id macroprofil = mpr.Macroprofil__c;
                List<Id> intenalList = new List<Id>();
                if(map_MP_Trans.containsKey(macroprofil))
                    intenalList = map_MP_Trans.get(macroprofil);
                intenalList.add(mpr.Reseau__c);
                map_MP_Trans.put(macroprofil, intenalList);
            }
            
            set<Id> setReseauTransporteurAccount = new set<Id>();
            set<Id> setTransporteurAssocieAccount = new set<Id>();
            
            // here to do map based on reseau
            list<Id> listTransporteurIdsVerified = new list<Id>();
            
            //set of transporteur who are not verified
            set<Id> setTransporteurIdsNotVerified = new set<Id>();
            
            // checks for every account in trigger if condition 2 is met
            // Les transporteurs associés au réseau doivent exister parmi les transporteurs activés sur le PUDO
            String strActEtat = '';
            boolean bActuel = false;
            for(Account acc : listAccountsInvolved){
                strActEtat = acc.Etat__c;
                // A partir de l'état 4 on prends le MP actuel en considération
                if(!strActEtat.equals('0') &&  !strActEtat.equals('1') && !strActEtat.equals('2')) {
                    bActuel = true;
                }
                //reinitializations per account
                setReseauTransporteurAccount = new set<Id>();
                setTransporteurAssocieAccount = new set<Id>();
                if( (bActuel && map_MP_Trans.containsKey(acc.Macroprofil_actuel__c)) || map_MP_Trans.containsKey(acc.Macroprofil_de_reference__c)){
                    List<Id> reseauIds = null;
                    if(bActuel) {
                        reseauIds = map_MP_Trans.get(acc.Macroprofil_actuel__c);
                    } else {
                        reseauIds = map_MP_Trans.get(acc.Macroprofil_de_reference__c);
                    }
                    for(Id reseauId: reseauIds){
                        list<Id> internalList = mapReseauIdReseauTransporteur.get(reseauId);
                        if(internalList != null)
                            setReseauTransporteurAccount.addAll(internalList);
                    }
                }
                
               
                //get the transporteur Id from transporteur Associe per account
                if(mapAccountTransporteurAssocie.containsKey(acc.Id)){
                    setTransporteurAssocieAccount = new Set<Id>(mapAccountTransporteurAssocie.get(acc.Id));
                }
                
                //check condition 2
                for(Id ta: setReseauTransporteurAccount){
                    if(setTransporteurAssocieAccount.contains(ta)){
                        if(mapTransporteurTransporteurAssocie.containsKey(ta) && mapTransporteurTransporteurAssocie.get(ta).Active__c){
                            listTransporteurIdsVerified.add(ta);
                            //if(setTransporteurIdsNotVerified.contains(ta)){
                            //    setTransporteurIdsNotVerified.remove(ta);
                            //}
                        }
                        else {
                            setTransporteurIdsNotVerified.add(ta);
                        }
                    }
                    else{
                        setTransporteurIdsNotVerified.add(ta);
                    }
                }
                for(Id verified : listTransporteurIdsVerified) {
                    if(setTransporteurIdsNotVerified.contains(verified)) {
                        setTransporteurIdsNotVerified.remove(verified);
                    }
                }
                
            }
            
            list<Reseau_Transporteur__c> listReseauTransporteursNotVerified = [select id, Transporteur__c, Reseau__c 
                                                                               from Reseau_Transporteur__c
                                                                               where Transporteur__c in: setTransporteurIdsNotVerified];
            set<Id> setReseauIdsToRemove = new set<Id>();
            for(Reseau_Transporteur__c rt : listReseauTransporteursNotVerified){
                setReseauIdsToRemove.add(rt.Reseau__c);
            }
            
            listMacroprofilReseau = new list<Macroprofil_Reseau__c>();
            
            //get list of reseaux Ids
            
            set<Id> tempReseauIds = new set<Id>();
            for(Id rsId : setReseauIds){
                if(!setReseauIdsToRemove.contains(rsId)){
                    tempReseauIds.add(rsId);
                }
            }
            setReseauIds = new set<Id>();
            setReseauIds = tempReseauIds;
            
            listMacroprofilReseau = [ select id, Macroprofil__c, Reseau__c, Active__c, Modifiable__c,Interdit__c,Exclu__C
                                     from Macroprofil_Reseau__c
                                     where Reseau__c in: setReseauIds];
        }
    }
    
    public void fillMacroprofilReseau(){
        
        // get from MacroprofilReseau the Reseau Ids
        setReseauIds = new set<Id>();
        map<Id, map<Id,Macroprofil_Reseau__c>> mapMacroprofilMPReseau = new map<Id, map<Id,Macroprofil_Reseau__c>>();
        Id macroprofil = null;
        Id reseauId = null;
        
        for(Macroprofil_Reseau__c mpr : listMacroprofilReseau){
            reseauId = mpr.Reseau__c;
            setReseauIds.add(reseauId);
            
            macroprofil = mpr.Macroprofil__c;
            if(!mapMacroprofilMPReseau.containsKey(macroprofil)){
                mapMacroprofilMPReseau.put(macroprofil, new map<Id,Macroprofil_Reseau__c>());
            }
            mapMacroprofilMPReseau.get(macroprofil).put(reseauId, mpr);
        } 
        
        //get map Id and reseaux from set reseaux Ids 
        map<Id, Reseau__c> mapReseau = new map<Id, Reseau__c>([select id, Type_de_point__c, Domaine_d_activite__c, Horaire_d_ouverture_de_reference__c, 
                                                               Horaire_de_fermeture_de_reference__c, Partenaire__c, Poidsmaxacceptparcolis__c
                                                               from Reseau__c 
                                                               where id in:setReseauIds]); 
                                                               
       
        
        mapMacroprofilReseauId = new map<Id, map<Reseau__c, Macroprofil_Reseau__c>>();
        map<Reseau__c, Macroprofil_Reseau__c> mapReseauMacroProfil = new map<Reseau__c, Macroprofil_Reseau__c>();
        
        //from macroprofil reseau obtained after condition 1 and 2 satisfied, fill map
        //map: key: macroprofil Id and value: map <ReseauId , MP record>
        
        for(Macroprofil_Reseau__c mpr : listMacroprofilReseau){
            if(!mapMacroprofilReseauId.containsKey(mpr.Macroprofil__c)){
                mapMacroprofilReseauId.put(mpr.Macroprofil__c, new map<Reseau__c, Macroprofil_Reseau__c>());
            }
            mapReseauMacroProfil = mapMacroprofilReseauId.get(mpr.Macroprofil__c);
            if(mapReseau.containsKey(mpr.Reseau__c)){
                mapReseauMacroProfil.put(mapReseau.get(mpr.Reseau__c), mpr);
            }
            mapMacroprofilReseauId.put(mpr.Macroprofil__c, mapReseauMacroProfil);
        }
        
    }
    
    public void manipulateMacroprofilReseau(list<Account> listAccountsInvolved, boolean checkOthers){
        
        if(!isFirstRun){
            
            // Condition 1: Les services associés au réseau doivent exister parmi les services activés sur le PUDO
            // Return accounts that satisfy condition 1
            
            checkServiceConditions(listAccountsInvolved);
            fillMacroprofilReseau();             
            //Condition 2: Les transporteurs associés au réseau doivent exister parmi les transporteurs activés sur le PUDO.
            // Return accounts that satisfy condition 2
            checkTransporteurConditions(listAccountsInvolved);
            fillMacroprofilReseau();
            
            //Reseau Associe existants sur le compte
            list<Reseau_Associe__c> listReseauAssocies = [select Id, Compte__c, Reseau__c ,Modifiable__c, Active__c, tech_bypassNonModifiableCheck__c ,Exclu__c,Interdit__c 
                                                          from Reseau_Associe__c 
                                                          where Compte__c in: listAccountsInvolved]; 
            
            
            map<Id,map<Id,Reseau_Associe__c>> mapAccountReseau = new map<Id,map<Id,Reseau_Associe__c>>();
            map<Id,Reseau_Associe__c> mapReseauIdReseauAssocie = new map<Id, Reseau_Associe__c>();
            Id compteId = null;
            //fill reseaux associe in map: key: compteID and value : map<reseauId, Reseau Associe>
            for(Reseau_Associe__c ra : listReseauAssocies){ 
                compteId = ra.Compte__c;
                if(!mapAccountReseau.containsKey(compteId)){
                    mapAccountReseau.put(compteId, new map<Id,Reseau_Associe__c>());
                }
                mapAccountReseau.get(compteId).put(ra.Reseau__c, ra);
            }        
            
            //declerations and initializations
            map<Reseau__c , Macroprofil_Reseau__c> mapReseauMacroProfilAccount = new map<Reseau__c , Macroprofil_Reseau__c>();
            set<Id> setExistingReseauAssocie = new set<Id>();
            list<Reseau_Associe__c> listReseauAssocieToAdd = new list<Reseau_Associe__c>();
            set<Id> setReseauIdsIncluded = new set<Id>();
            boolean toIncludeReseau = true;
            map<Id, Reseau_Associe__c> mapReseauIdRA =new map<Id, Reseau_Associe__c>();
            Reseau_Associe__c reseauAssocie;
            Macroprofil_Reseau__c macroprofilReseau;
            map<Id,Reseau_Associe__c> mapReseauIdReseauAssocieofAccount; 
            
            //for each account satisfying coniditions 1 and 2
            String strActEtat = '';
            boolean bActuel = false;
            for(Account acc :listAccountsInvolved){
                strActEtat = acc.Etat__c;
                  if((!strActEtat.equals('0') &&  !strActEtat.equals('1') && !strActEtat.equals('2') && label.RT_France_Compte.contains(acc.recordTypeId)) || label.RT_INT_Compte.contains(acc.recordTypeId) || label.RT_INT_Compte2.contains(acc.recordTypeId)) {
                    bActuel = true;
                }
                toIncludeReseau = true;
                //reinitializations per account
                mapReseauMacroProfilAccount = new map<Reseau__c , Macroprofil_Reseau__c>();
                setExistingReseauAssocie = new set<Id>();
                mapReseauIdRA = new map<Id, Reseau_Associe__c>();
                setReseauIdsIncluded = new set<Id>();
                mapReseauIdReseauAssocieofAccount = new map<Id,Reseau_Associe__c>();
                
                //get the Reseau associe existing on this current account
                
                //if reseau trying to add does not exist, create it based on Macroprofil reseau and add it to the Reseaux associes if condition 3 is met
                //if reseau trying to add already exists, update it on Macroprofil reseau and add it to the Reseaux associes if condition 3 is met
                //if reseau no longer exists or condition no longer met -> deactivate it in reseau associe 
                
                if(mapAccountReseau.containsKey(acc.Id)){
                    mapReseauIdReseauAssocieofAccount = mapAccountReseau.get(acc.Id);
                    setExistingReseauAssocie = mapReseauIdReseauAssocieofAccount.keyset();
                }
                
                if( (bActuel && mapMacroprofilReseauId.containsKey(acc.Macroprofil_actuel__c)) || mapMacroprofilReseauId.containsKey(acc.Macroprofil_de_reference__c)){
                    if(bActuel) {
                        mapReseauMacroProfilAccount = mapMacroprofilReseauId.get(acc.Macroprofil_actuel__c);
                    } else {
                        mapReseauMacroProfilAccount = mapMacroprofilReseauId.get(acc.Macroprofil_de_reference__c);
                    }
                    for(Reseau__c reseau : mapReseauMacroProfilAccount.keySet()){ 
                       
                        macroprofilReseau = mapReseauMacroProfilAccount.get(reseau);
                        toIncludeReseau = true;
                        //Condition 3: Les paramètres du PUDO (les valeurs de certains champs), 
                        //doivent correspondre aux critères de filtres du réseau (valeurs des champs sur la fiche du réseau).
                        //Si aucune valeur n’est renseignée dans un champ dans la fiche réseau, le système ne prend pas en considération 
                        //ce champ dans les critères de recherche.
                        
                        if((!string.isBlank(reseau.Type_de_point__c) && !string.isBlank(acc.Type) && !(';' + reseau.Type_de_point__c + ';').contains(';' + acc.Type + ';') ) || (!string.isBlank(reseau.Type_de_point__c) && string.isBlank(acc.Type))){
                            toIncludeReseau = false;
                        }
                        
                        if((!string.isBlank(reseau.Domaine_d_activite__c) && !string.isBlank(acc.Industry) && !(';' + reseau.Domaine_d_activite__c + ';').contains(';' + acc.Industry + ';') ) || (!string.isBlank(reseau.Domaine_d_activite__c) && string.isBlank(acc.Industry))){
                            toIncludeReseau = false;
                        }
                         
                        if((!string.isBlank(reseau.Partenaire__c) && !string.isBlank(acc.Partenaire__c) && !(';' + reseau.Partenaire__c + ';').contains(';' + acc.Partenaire__c + ';') ) || (!string.isBlank(reseau.Partenaire__c) && string.isBlank(acc.Partenaire__c))){
                            toIncludeReseau = false;
                        }
                        
                        if( (!string.isBlank(reseau.Horaire_d_ouverture_de_reference__c) && !string.isBlank(acc.Horaire_Ouverture_Reference__c) && acc.Horaire_Ouverture_Reference__c > reseau.Horaire_d_ouverture_de_reference__c) || (!string.isBlank(reseau.Horaire_d_ouverture_de_reference__c) && string.isBlank(acc.Horaire_Ouverture_Reference__c) )){
                            toIncludeReseau = false;
                        }
                        
                        if( (!string.isBlank(reseau.Horaire_de_fermeture_de_reference__c) && !string.isBlank(acc.Horaire_Fermeture_Reference__c) && acc.Horaire_Fermeture_Reference__c < reseau.Horaire_de_fermeture_de_reference__c ) || (!string.isBlank(reseau.Horaire_de_fermeture_de_reference__c) && string.isBlank(acc.Horaire_Fermeture_Reference__c))){
                            toIncludeReseau = false;
                        }
                         
                        if((!string.isBlank(reseau.Poidsmaxacceptparcolis__c) && !string.isBlank(acc.Poids_maximal_accepte_par_colis__c) && acc.Poids_maximal_accepte_par_colis__c != reseau.Poidsmaxacceptparcolis__c) || (!string.isBlank(reseau.Poidsmaxacceptparcolis__c) && string.isBlank(acc.Poids_maximal_accepte_par_colis__c)) ){
                            toIncludeReseau = false;
                        }
                         
                        
                        // if no existing RA or if there exists RA on account but not for this specific reseau => if condition 3 is true => create the RA
                        if(setExistingReseauAssocie == null || (setExistingReseauAssocie != null && !setExistingReseauAssocie.contains(reseau.Id) )){
                            // if all conditions 1 2 and 3 are ok => and no RA exisiting on this account with this reseau => create RA
                            if(toIncludeReseau){
                                Reseau_Associe__c ra = new Reseau_Associe__c();
                                ra.Reseau__c = reseau.Id;
                                ra.Compte__c = acc.Id; 
                                //ra.Active__c = true;
                                ra.Active__c = macroprofilReseau.Active__c; 
                                ra.Modifiable__c = macroprofilReseau.Modifiable__c;
                                //TMA:MJE TFS-102633
                                ra.Interdit__c = macroprofilReseau.Interdit__c; 
                                ra.Exclu__c = macroprofilReseau.Exclu__c;
                                //
                                listReseauAssocieToAdd.add(ra);
                            }
                        } else{ 
                            // if all conditions 1 2 and 3 are ok => and RA exisiting on this account with this reseau => update RA with Macroprofilreseau 
                            // else deactivate the RA if not all conditions met
                            if(mapReseauIdReseauAssocieofAccount.containsKey(reseau.Id)){
                                Reseau_Associe__c ra = mapReseauIdReseauAssocieofAccount.get(reseau.Id);
                                if(toIncludeReseau){ // all conditions ok 
                                    //ra.Active__c = true;
                                    ra.Active__c = macroprofilReseau.Active__c;  
                                    ra.Modifiable__c = macroprofilReseau.Modifiable__c;
                                    
                                    //TMA:MJE TFS 102633
                                    ra.Interdit__c = macroprofilReseau.Interdit__c;
                                    ra.Exclu__c = macroprofilReseau.Exclu__c;
                                    //
                                }else{ // not all conditions ok
                                    ra.Active__c = false;
                                    ra.Interdit__c = false;
                                    ra.Exclu__c = false;
                                    ra.Modifiable__c = macroprofilReseau.Modifiable__c;
                                }
                                ra.tech_bypassNonModifiableCheck__c = !ra.tech_bypassNonModifiableCheck__c;
                                listReseauAssocieToAdd.add(ra);
                            }
                            // add the reseau id in case it already exists on the account so that we deactivate all RA 
                            // that do not exist anymore
                            setReseauIdsIncluded.add(reseau.Id); 
                        }
                    }
                } 
                if(setReseauIdsIncluded != null && setExistingReseauAssocie != null && checkOthers){
                    
                    //Remove from set reseau Id existing on the account the reseau Ids that are still linked 
                    //on the MP in question
                    setExistingReseauAssocie.removeAll(setReseauIdsIncluded);
                    if(mapAccountReseau.containsKey(acc.Id)){
                        mapReseauIdRA = mapAccountReseau.get(acc.Id);
                        
                        // Modification by : gho 
                        // purpose : copy the field Modifiable__c from MPReseau
                        Id compteMPId = null;
                        if(bActuel) {
                           compteMPId = acc.Macroprofil_actuel__c;
                        } else {
                           compteMPId = acc.Macroprofil_de_reference__c;
                        }
                        
                        List<Macroprofil_Reseau__c> lstMPReseau = [SELECT Id, Reseau__c ,Macroprofil__c ,Active__c ,Modifiable__c
                                                                   FROM Macroprofil_Reseau__c
                                                                   where Macroprofil__c =: compteMPId AND Reseau__c IN : setExistingReseauAssocie
                                                                  ];
                        map<Id,Macroprofil_Reseau__c> mapReseauMPReseau = new Map<Id,Macroprofil_Reseau__c>();
                        for(Macroprofil_Reseau__c mpRes : lstMPReseau) {
                            mapReseauMPReseau.put(mpRes.Reseau__c ,mpRes);
                        }
                        
                        boolean bModifiable = null;
                        
                        //Reseau Associe to deactivate
                        for(Id resId : setExistingReseauAssocie){
                            bModifiable = false;
                            if(mapReseauIdRA.containsKey(resId)){
                                reseauAssocie = mapReseauIdRA.get(resId);
                                reseauAssocie.Active__c = false;
                                
                                //TMA:MJE TFS_102633
                                reseauAssocie.Interdit__c = false;
                                reseauAssocie.Exclu__c = false;
                                //
                                // Modification by : gho 
                                // purpose : copy the field Modifiable__c from MPReseau
                                if(mapReseauMPReseau.containsKey(resId)) {
                                    bModifiable = mapReseauMPReseau.get(resId).Modifiable__c;
                                }
                                reseauAssocie.Modifiable__c = bModifiable;
                                reseauAssocie.tech_bypassNonModifiableCheck__c = !reseauAssocie.tech_bypassNonModifiableCheck__c;
                                listReseauAssocieToAdd.add(reseauAssocie);
                            }
                        }
                    }
                }
            }
            //update Reseau associe list
            if( listReseauAssocieToAdd.size() > 0){ 
                upsert listReseauAssocieToAdd; 
            }
            isFirstRun = true;
        }
    }
}