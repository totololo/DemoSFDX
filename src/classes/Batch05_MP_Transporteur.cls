global class Batch05_MP_Transporteur implements Database.Batchable<sObject> {
	    
	global Batch05_MP_Transporteur() {		
	}
       
	
    global Database.QueryLocator start(Database.BatchableContext BC) {
		//Get the involved records
		List<Macroprofil_Transporteur__c> newlist = [select Macroprofil__c, Transporteur__c 
                                                     from Macroprofil_Transporteur__c 
                                                     where Techatraiter__c = true];
		System.debug('$$$gho newlist size : ' + newlist.size());
        System.debug('$$$gho newlist : ' + newlist);
	    //Set of Macroprofils
		Set<Id> setMacroprofils = new Set<Id>();
		//Set of Transporteurs
		Set<Id> setTransporteurs = new Set<Id>();
	   
		for(Macroprofil_Transporteur__c neww : newlist)
		{
			
			setMacroprofils.add(neww.Macroprofil__c);
            setTransporteurs.add(neww.Transporteur__c);
		}
					
                       
        //get list of accounts concerned 
        String query =  'Select Id, Compte__c,Compte__r.Etat__c,Compte__r.Macroprofil_actuel__c, Transporteur__c, Active__c, Modifiable__c, tech_bypassNonModifiableCheck__c  ' +
                         'from Transporteur_Associe__c where Compte__r.Macroprofil_actuel__c =: setMacroprofils And Transporteur__c =: setTransporteurs' ;
        System.debug('$$$gho query : ' + query);
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC , List<Transporteur_Associe__c> scope) {
		List<Macroprofil_Transporteur__c> newlist = [select Macroprofil__c, Transporteur__c, Active__c, Modifiable__c, Interdit__c, Exclut__c
                                                     from Macroprofil_Transporteur__c 
                                                     where Techatraiter__c = true];
		//Set of Macroprofils
		Set<Id> setMacroprofils = new Set<Id>();
		//Set of Transporteurs
		Set<Id> setTransporteurs = new Set<Id>();
		//Indexing
        map<String,Macroprofil_Transporteur__c> mapIdMTMT = new map<String,Macroprofil_Transporteur__c>();
		
		for(Macroprofil_Transporteur__c neww : newlist)
		{
			setMacroprofils.add(neww.Macroprofil__c);
			setTransporteurs.add(neww.Transporteur__c);
			mapIdMTMT.put(''+ neww.Macroprofil__c + neww.Transporteur__c,neww);
		}
		
		
 	    Set<Id> accountIds = new Set<Id>();
		for(Transporteur_Associe__c ta : scope)
		{
			accountIds.add(ta.Compte__c);
			Macroprofil_Transporteur__c mt = mapIdMTMT.get(''+ta.Compte__r.Macroprofil_actuel__c + ta.Transporteur__c);
			//TODO: link all values
			ta.Active__c = mt.Active__c;
			ta.Exclu__c = mt.Exclut__c;
			ta.Interdit__c = mt.Interdit__c;
			ta.Modifiable__c = mt.Modifiable__c;
			ta.tech_bypassNonModifiableCheck__c = !ta.tech_bypassNonModifiableCheck__c;
		}
		
		update scope;
		
    }
    
    global void finish(Database.BatchableContext BC){
		system.debug('Batch05_MP_Transporteur finish: ');		
        Batch03_Reseau batch = new Batch03_Reseau();
        Database.executeBatch(batch, 75); 
    }

    
}