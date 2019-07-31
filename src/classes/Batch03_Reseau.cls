global class Batch03_Reseau implements Database.Batchable<sObject> {
    private String  accountIdsConcatenated;
	private Set<Id> setAccountIds = new Set<Id>();
	
    global Batch03_Reseau(Set<Id> accountIds) {
        this.accountIdsConcatenated = '';
        for(Id id: accountIds){
            this.accountIdsConcatenated +=''+ id + ',';
        }
        accountIdsConcatenated = accountIdsConcatenated.removeEnd(',');
    }
    global Batch03_Reseau(){ 
	
	
        Set<Id> setMacroprofils = new Set<Id>();		
		Set<Id> setServices = new Set<Id>();	   
		Set<Id> setTransporteurs = new Set<Id>();
		Set<Id> setReseaux = new Set<Id>();
		
		
        this.accountIdsConcatenated = '';
		
		
		// get the accounts from service associated that should be recalculated
      	for( Macroprofil_Service__c mpService :  [select Macroprofil__c, Service__c 
												  from Macroprofil_Service__c 
												  where Techatraiter__c = true]) {
			setMacroprofils.add(mpService.Macroprofil__c);
			setServices.add(mpService.Service__c);				
		}
        
		for(Service_Associe__c servAss :  [Select Compte__c, Compte__r.Macroprofil_actuel__c
                         				   from Service_Associe__c 
                                           where Service__c =: setServices]) {
			if(servAss.Compte__c != null && setMacroprofils.contains(servAss.Compte__r.Macroprofil_actuel__c))
        		setAccountIds.add(servAss.Compte__c);
		}										
		
        
		
        // get the accounts from transporteur associated that should be recalculated
	    setMacroprofils.clear();
		for(Macroprofil_Transporteur__c trans : [select Macroprofil__c, Transporteur__c 
                                                     from Macroprofil_Transporteur__c 
                                                     where Techatraiter__c = true]){
			setMacroprofils.add(trans.Macroprofil__c);
            setTransporteurs.add(trans.Transporteur__c);
		}
				         
        for( Transporteur_Associe__c transAss : [Select Compte__c, Compte__r.Macroprofil_actuel__c
                         							  from Transporteur_Associe__c 
                                                      where Transporteur__c in: setTransporteurs]){
        	if(transAss.Compte__c != null && setMacroprofils.contains(transAss.Compte__r.Macroprofil_actuel__c))
        		setAccountIds.add(transAss.Compte__c);
        }
		
		
		
        
        // get the accounts from reseaux associated that should be recalculated
		setMacroprofils.clear();
		for (Macroprofil_Reseau__c  mpRes : [select Macroprofil__c, Reseau__c 
                                             from Macroprofil_Reseau__c 
                                             where Techatraiter__c = true]) { 
			setMacroprofils.add(mpRes.Macroprofil__c);
            setReseaux.add(mpRes.Reseau__c);
		}
					 
        for(Reseau_Associe__c resAss : [Select Compte__c, Compte__r.Macroprofil_actuel__c
                         			    from Reseau_Associe__c 
                                        where Reseau__c in: setReseaux]){
        	if(resAss.Compte__c != null && setMacroprofils.contains(resAss.Compte__r.Macroprofil_actuel__c))
        		setAccountIds.add(resAss.Compte__c);
        }
		
		setMacroprofils.clear();
		setReseaux.clear();
		setTransporteurs.clear();
		setServices.clear(); 
        
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC) {  
        //get list of accounts concerned 
        String query =  'select Id, Macroprofil_de_reference__c,Etat__c, Macroprofil_actuel__c, Type, Industry, Partenaire__c, Horaire_Ouverture_Reference__c, Horaire_Fermeture_Reference__c, Poids_maximal_accepte_par_colis__c ' +
                        'from Account where Id in : setAccountIds' ;
        return Database.getQueryLocator(query);    
    }
	
    
    global void execute(Database.BatchableContext BC , List<Account> scope) {
        set<Id> setMacroprofilIds = new set<Id>();
        for(Account acc : scope){
            setMacroprofilIds.add(acc.macroprofil_de_reference__c);
        }
        AP04_Account ap04Acc = new AP04_Account();
        ap04Acc.UpdateReseauAssociations(scope, setMacroprofilIds);
    }
    
    global void finish(Database.BatchableContext BC){
 		List<Macroprofil_Service__c> newlist = [select Techatraiter__c
												from Macroprofil_Service__c 
												where Techatraiter__c = true];
        List<Macroprofil_Transporteur__c> newlistTrans = [select Techatraiter__c
                                                     from Macroprofil_Transporteur__c 
                                                     where Techatraiter__c = true];
        List<Macroprofil_Reseau__c> newlistRes = [select Techatraiter__c
                                                 from Macroprofil_Reseau__c
                                                 where Techatraiter__c = true];
        
        for(Macroprofil_Service__c mps: newlist)
            mps.techatraiter__c = false;
        for(Macroprofil_Transporteur__c mpt: newlistTrans)
            mpt.techatraiter__c = false;
         for(Macroprofil_Reseau__c mpr: newlistRes)
            mpr.techatraiter__c = false;
        
        
        update newlist;
        update newlistTrans;
		update newlistRes;
    }

    
}