public class AP07_Conge_Indispo { 
    
    private String errorAccountIds;
    
    private String ddCongeAVenir   = 'Tech_date_debut_conge_a_venir__c';
    private String dfCongeAVenir   = 'Tech_date_fin_conge_a_venir__c';
    private String ddCongeEnCours  = 'Tech_date_debut_conge_en_cours__c';
    private String dfCongeEnCours  = 'Tech_date_fin_conge_en_cours__c';
    private String ddIndispEnCours = 'Tech_date_debut_indisp_en_cours__c';
    private String dfIndispEnCours = 'Tech_date_fin_indisp_en_cours__c';
    private String ddDispAVenir    = 'Tech_date_debut_disp_a_venir__c';
    private String dfDispAVenir    = 'Tech_date_fin_disp_a_venir__c'; 
        
    Id congeRTypeId = Label.CongeRT_15;
    Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    Id dispoRTypeId = Label.DispoRT_15;
    
    Map<Id ,Conge_Indispo__c> mapCongesIndispo = null;
    Map<Id ,Account> mapAccounts = null;
    Map<Id ,List<Conge_Indispo__c>> mapAccountCongesIndispo =  null;
    
    
    private Account account;
    private boolean bUpdate;

    
    /*
     * filter the list of conge indispo :
     * conge : en cours + a venir 
     * disponibilite : a venir
     * indisponibilite : en cours
     */
    private Map<Id ,Conge_Indispo__c> filterCongesIndispo(List<Conge_Indispo__c> lstCongeIndispo) {
        Map<Id ,Conge_Indispo__c> mapCongesIndispo = new Map<Id ,Conge_Indispo__c>();
        for(Conge_Indispo__c congeIndispo : lstCongeIndispo) { 
            mapCongesIndispo.put(congeIndispo.Id, congeIndispo); 
        }
        return mapCongesIndispo;
    }
    
    /*
     * get the accounts for all filtered congeIndispo
     * relation between congeIndispo and account called : Nom_du_compte__c
     */
    private Map<Id ,Account> getAccounts(Map<Id ,Conge_Indispo__c> mapCongesIndispo){ 
        Set<Id> setAccountIds = new Set<Id>();
        for(Id congeIndispoId : mapCongesIndispo.keySet()) {
            setAccountIds.add(mapCongesIndispo.get(congeIndispoId).Nom_du_compte__c);
        }      
        Map<Id ,Account> mapAccounts = new Map<Id ,Account>([SELECT ID , Conges_en_cours__c ,Conges_a_venir__c,
                                                             Disponibilite_a_venir__c,Indisponibilite_en_cours__c,
                                                             Tech_date_debut_conge_en_cours__c,
                                                             Tech_date_fin_conge_en_cours__c,
                                                             Tech_date_debut_conge_a_venir__c,
                                                             Tech_date_debut_indisp_en_cours__c,
                                                             Tech_date_fin_indisp_en_cours__c,
                                                             Tech_date_fin_conge_a_venir__c,
                                                             Tech_date_debut_disp_a_venir__c,
                                                             Tech_date_fin_disp_a_venir__c
                                                             FROM Account
                                                             where Id IN : setAccountIds
                                                            ]); 
        return mapAccounts; 
    }
    
    /*
     * Map each account with its related congeIndispo
     * RecordTypes will be checked in the function instead of creating 3 maps
     */
    private Map<Id ,List<Conge_Indispo__c>>  mapAccountCongeIndispo(Set<Id> AccountIds) {
        Map<Id ,List<Conge_Indispo__c>> mapAccountConges = new Map<Id ,List<Conge_Indispo__c>>();
        List<Conge_Indispo__c> lstCongesIndispo = [SELECT Id , Nom_du_compte__c , Date_de_debut__c , Date_de_fin__c , RecordTypeId,Statut__c
                                                   FROM Conge_Indispo__c 
                                                   WHERE Nom_du_compte__c IN : AccountIds
                                                  ];      
        for(Conge_Indispo__c congeIndispo : lstCongesIndispo){
            if(! mapAccountConges.containsKey(congeIndispo.Nom_du_compte__c)) {
                mapAccountConges.put(congeIndispo.Nom_du_compte__c , new List<Conge_Indispo__c>());
            }
            mapAccountConges.get(congeIndispo.Nom_du_compte__c).add(congeIndispo);
        } 
        return mapAccountConges;
    }
 
    
    private boolean isLastCongeIndispo(Conge_Indispo__c congeIndispo){
        boolean bRet = true;      
        if(mapAccountCongesIndispo.size() > 0 ) { 
            List<Conge_Indispo__c> listCongeIndispo = mapAccountCongesIndispo.get(congeIndispo.Nom_du_compte__c);
            if(listCongeIndispo != null) {
            	 for(Conge_Indispo__c congeItem : listCongeIndispo) { 
                    if(congeIndispo.RecordTypeId == congeItem.RecordTypeId ) { 
                        bRet = false;
                        break;
                    }
                 }     
            } 
        }
       
        return bRet;
    }
    
    public void deleteAccountCongesIndispo(List<Conge_Indispo__c> lstCongeIndispoDeleted ) { 
      	mapCongesIndispo = filterCongesIndispo(lstCongeIndispoDeleted);
        mapAccounts = getAccounts(mapCongesIndispo);
        mapAccountCongesIndispo =  mapAccountCongeIndispo(mapAccounts.keySet());
        
        Set<Id> setAccountsToBeAdded = new Set<Id>();
        List<Account> listAccountsToBeUpdated = new List<Account>();
        
        for(Conge_Indispo__c congeIndispo : mapCongesIndispo.values()) {
            bUpdate = false;
            account = mapAccounts.get(congeIndispo.Nom_du_compte__c);  
            Id recordTypeId = congeIndispo.RecordTypeId;
            if(recordTypeId == congeRTypeId ) { 
                if(congeIndispo.Statut__c.equals(Label.CongeIndispo_A_Venir)) { 
                    if(isLastCongeIndispo(congeIndispo)) { 
                        account.Tech_date_debut_conge_a_venir__c = null;
                        account.Tech_date_fin_conge_a_venir__c = null;
                        bUpdate = true;
                    } else {
                        updateAcountAVenirField(recordTypeId,ddCongeAVenir,dfCongeAVenir); 
                    } 
                } 
            }else if(recordTypeId == dispoRTypeId) {
                if(isLastCongeIndispo(congeIndispo)) {
                    bUpdate = true; 
                    account.Tech_date_debut_disp_a_venir__c = null;
                    account.Tech_date_fin_disp_a_venir__c = null;
                }else {
                    updateAcountAVenirField(recordTypeId,ddDispAVenir,dfDispAVenir);
                }
            } 
            if(bUpdate) {
                 setAccountsToBeAdded.add(account.Id); 
            }
        } 
        if(setAccountsToBeAdded.size() > 0) {    
            for(Id accountId : setAccountsToBeAdded) {
                listAccountsToBeUpdated.add(mapAccounts.get(accountId));
            }
            Database.update(listAccountsToBeUpdated,false);
            //update listAccountsToBeUpdated;
        }

    }
    
    public void updateAccountCongesIndispo(List<Conge_Indispo__c> lstCongeIndispo , Map<Id ,Conge_Indispo__c> mapOldCongeIndispo , boolean fromBtach) {
        mapCongesIndispo = filterCongesIndispo(lstCongeIndispo); 
        mapAccounts = getAccounts(mapCongesIndispo);
        mapAccountCongesIndispo =  mapAccountCongeIndispo(mapAccounts.keySet());
        errorAccountIds = '';
        Set<Id> setAccountsToBeUpdated = new Set<Id>();
        List<Account> listAccountsToBeUpdated = new List<Account>(); 
      
        // case if batch stopped for more than 1 day.
        List<Conge_Indispo__c> listCongeIndispoTreated = new List<Conge_Indispo__c>();
        
        
        bUpdate = false;
 		Conge_Indispo__c oldConge = null; 
        Conge_Indispo__c congeToCompare = null;
        for(Conge_Indispo__c congeIndispo : mapCongesIndispo.values()) { 
            //if(mapOldCongeIndispo == null || congeIndispo.Tech_Treated__c == mapOldCongeIndispo.get(congeIndispo.Id).Tech_Treated__c) { 
            
                account = mapAccounts.get(congeIndispo.Nom_du_compte__c);   
                Id recordTypeId = congeIndispo.RecordTypeId;  
                if(recordTypeId == congeRTypeId ) { 
                    if(congeIndispo.Statut__c.equals(Label.Conge_Indispo_Passe) || congeIndispo.Statut__c.equals(Label.CongeIndispo_A_Venir)) {
                        boolean wasEnCours; 
                        if(mapOldCongeIndispo != null) {
                            congeToCompare = mapOldCongeIndispo.get(congeIndispo.Id);
                        } else {
                            congeToCompare = congeIndispo;
                        }
                        
                        wasEnCours = compareDates(account.Tech_date_debut_conge_en_cours__c , 
                                                  account.Tech_date_fin_conge_en_cours__c,
                                                  congeToCompare.Date_de_debut__c ,
                                                  congeToCompare.Date_de_fin__c
                                                 );
 						 
                        if(wasEnCours) {
                            account.Tech_date_debut_conge_en_cours__c = null;
                            account.Tech_date_fin_conge_en_cours__c = null;
                            bUpdate = true; 
                        }  
                    } else if(congeIndispo.Statut__c.equals(Label.CongeIndispo_En_Cours)) { 
                            // update en cours field 
                            bUpdate = true; 
                            setAccountCongeIndispoInformation(account,
                                							  ddCongeEnCours ,
                                                              dfCongeEnCours,
                                                              congeIndispo.Date_de_debut__c,
                                                              congeIndispo.Date_de_fin__c
                            								);
                    }  
                    //update a venir field
                    updateAcountAVenirField(recordTypeId,ddCongeAVenir,dfCongeAVenir); 
                   
                } else if(recordTypeId == dispoRTypeId) { 
                    bUpdate = true;
                    boolean wasAVenir  = compareDates(account.Tech_date_debut_disp_a_venir__c , 
                                                      account.Tech_date_fin_disp_a_venir__c,
                                                      congeIndispo.Date_de_debut__c ,
                                                      congeIndispo.Date_de_fin__c
                                                 	 );
                   updateAcountAVenirField(recordTypeId,ddDispAVenir,dfDispAVenir);  
                } else if(recordTypeId == indispoStandardRTypeId || recordTypeId == indispoConsigneRTypeId) {
                    
                    if(congeIndispo.Statut__c.equals(Label.Conge_Indispo_Passe) || congeIndispo.Statut__c.equals(Label.CongeIndispo_A_Venir)) {
                        boolean wasEnCours;
                        if(mapOldCongeIndispo != null) {
                            congeToCompare = mapOldCongeIndispo.get(congeIndispo.Id);
                        } else {
                            congeToCompare = congeIndispo;
                        }
                        
                        wasEnCours = compareDates(account.Tech_date_debut_indisp_en_cours__c , 
                                                  account.Tech_date_fin_indisp_en_cours__c,
                                                  congeToCompare.Date_de_debut__c ,
                                                  congeToCompare.Date_de_fin__c
                                                 );
                       
                        if(wasEnCours) {
                            account.Tech_date_debut_indisp_en_cours__c = null;
                            account.Tech_date_fin_indisp_en_cours__c = null;
                            bUpdate = true; 
                        }  
                         
                    } else if(congeIndispo.Statut__c.equalsIgnoreCase(Label.CongeIndispo_En_Cours)) {
                        bUpdate = true;
                        setAccountCongeIndispoInformation(account,
                                                          ddIndispEnCours,
                                                          dfIndispEnCours,
                                                          congeIndispo.Date_de_debut__c,
                                                          congeIndispo.Date_de_fin__c
                            							 );
                    } 
                }  
                if(bUpdate) {  
                    setAccountsToBeUpdated.add(account.Id); 
                } 
            
             } 
        if(setAccountsToBeUpdated.size() > 0) {  
            for(Id accountId : setAccountsToBeUpdated) {
                listAccountsToBeUpdated.add(mapAccounts.get(accountId));
            }
            Database.SaveResult[] srList = Database.update(listAccountsToBeUpdated,false);
            for(Database.SaveResult sr : srList) {
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()) { 
                        errorAccountIds = err.getStatusCode() + ' : ' + err.getMessage();
                    } 
                } 
            }
        } 
    } 
     
    private boolean compareDates(Date accountStartDate , Date accountEndDate , Date congeIndispStartDate , Date congeIndispEnDate) {
        boolean ret = false; 
        if(accountStartDate == congeIndispStartDate && accountEndDate == congeIndispEnDate) {
            ret = true;
        }
        return ret;
    }
    
    
    /*
     * Check the soonest start date to be filled in a venir fields (conge et disponibilite)
     */ 
    private void updateAcountAVenirField(Id recordTypeId,String fromFieldName , String toFieldName) {
        List<Conge_Indispo__c> listCongeIndispo = mapAccountCongesIndispo.get(account.Id);  
        Conge_Indispo__c congeIndispoAVenir = null;
        for(Conge_Indispo__c congeIndispo : listCongeIndispo ) {
            if(congeIndispo.RecordTypeId == recordTypeId && congeIndispo.Statut__c.equals(Label.CongeIndispo_A_Venir)) {
                if(congeIndispoAVenir == null) {
                	congeIndispoAVenir = congeIndispo;
                } else {
                    if(congeIndispo.Date_de_debut__c < congeIndispoAVenir.Date_de_debut__c) {
                        congeIndispoAVenir = congeIndispo;
                    }
                }
            } 
        } 
        if(congeIndispoAVenir != null) {  
            Date dFromDate  = (Date)account.get(fromFieldName);
            Date dEndDate   = (Date)account.get(toFieldName);
            boolean sameDates = false;
            if(dFromDate == congeIndispoAVenir.Date_de_debut__c && dEndDate == congeIndispoAVenir.Date_de_fin__c) {
                sameDates = true;
            }
            if(! sameDates) { 
                bUpdate = true;
                account.put(fromFieldName , congeIndispoAVenir.Date_de_debut__c );
                account.put(toFieldName ,   congeIndispoAVenir.Date_de_fin__c ); 
            }
        } else {
            bUpdate = true;
            account.put(fromFieldName,null);
            account.put(toFieldName,null);
        }
    }
     
    
    /*
     * concatenate the start date end endate for textfields in object account
     */
    private void setAccountCongeIndispoInformation(Account account , String fromFieldName ,String toFieldName ,  Date fromDate , Date toDate) {
        account.put(fromFieldName,fromDate);
        account.put(toFieldName,toDate);
    }
     
}