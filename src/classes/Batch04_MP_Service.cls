global class Batch04_MP_Service implements Database.Batchable<sObject> {

    global Batch04_MP_Service() {}     
	
    global Database.QueryLocator start(Database.BatchableContext BC) {
		//Get the involved records
		List<Macroprofil_Service__c> newlist = [select Macroprofil__c, Service__c 
												from Macroprofil_Service__c 
												where Techatraiter__c = true];
		
	   //Set of Macroprofils
		Set<Id> setMacroprofils = new Set<Id>();
		//Set of Services
		Set<Id> setServices = new Set<Id>();
	   
		for(Macroprofil_Service__c neww : newlist)
		{
			setMacroprofils.add(neww.Macroprofil__c);
			setServices.add(neww.Service__c);
		}
		
        //get list of accounts concerned 
        String query =  'Select Id, Compte__c,Compte__r.Etat__c, Compte__r.Macroprofil_actuel__c ,Service__c, Active__c, Modifiable__c, tech_bypassNonModifiableCheck__c  ' +
                         'from Service_Associe__c where Compte__r.Macroprofil_actuel__c =: setMacroprofils And Service__c =: setServices' ;
                         
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC , List<Service_Associe__c> scope) {
       
		List<Macroprofil_Service__c> newlist = [select Macroprofil__c, Service__c, Active__c, Modifiable__c, Interdit__c, Exclu__c
												from Macroprofil_Service__c 
												where Techatraiter__c = true];
		//Set of Macroprofils
		Set<Id> setMacroprofils = new Set<Id>();
		//Set of Services
		Set<Id> setServices = new Set<Id>();
		//Indexing
		map<String,Macroprofil_Service__c> mapIdMTMT = new map<String,Macroprofil_Service__c>();
		
		for(Macroprofil_Service__c neww : newlist)
		{
			setMacroprofils.add(neww.Macroprofil__c);
			setServices.add(neww.Service__c);
			mapIdMTMT.put(''+ neww.Macroprofil__c + neww.Service__c,neww);
		}
		
		
 	    Set<Id> accountIds = new Set<Id>();
		for(Service_Associe__c ta : scope)
		{			
			accountIds.add(ta.Compte__c);
			Macroprofil_Service__c mt = mapIdMTMT.get(''+ta.Compte__r.Macroprofil_actuel__c + ta.Service__c);
			if(mt!= null){
				ta.Active__c = mt.Active__c; 
				ta.Modifiable__c = mt.Modifiable__c;
				ta.Interdit__c = mt.Interdit__c;
				ta.Exclu__c = mt.Exclu__c;
				ta.tech_bypassNonModifiableCheck__c = !ta.tech_bypassNonModifiableCheck__c;
			}
		}
		
		update scope;
    }
    
    global void finish(Database.BatchableContext BC){
		system.debug('Batch04_MP_Service finish: ');
		Batch05_MP_Transporteur batch = new Batch05_MP_Transporteur();
        Database.executeBatch(batch, 200); 
    }

    
}