global class Batch02_Reseau implements Database.Batchable<sObject> {
    global list<Reseau__c> listReseau = new list<Reseau__c>();
    global List<Macroprofil_Reseau__c> listMacroprofilReseau;
    private String  reseauIdsConcatenated;
    
    global Batch02_Reseau(list<Reseau__c> listReseauFromTrigger) {
        listReseau = listReseauFromTrigger;
        this.reseauIdsConcatenated = '';
        for(Reseau__c res: listReseau){
            this.reseauIdsConcatenated +=''+ res.Id + ',';
        }
        reseauIdsConcatenated = reseauIdsConcatenated.removeEnd(',');
        system.debug('reseauIdsConcatenated: ' + reseauIdsConcatenated);
        
    }
     
    global Batch02_Reseau(){
     	listReseau = [select id from Reseau__c where Techatraiter__c = true];   
        this.reseauIdsConcatenated = '';
        for(Reseau__c res: listReseau){
            this.reseauIdsConcatenated +=''+ res.Id + ',';
        }
        reseauIdsConcatenated = reseauIdsConcatenated.removeEnd(',');
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('listReseau: ' + listReseau);
        Set<Id> reseauIds = new Set<Id>();
        List<Id> reseauIdsList = new List<Id>();
        
        if(reseauIdsConcatenated != null && reseauIdsConcatenated != '')
        	reseauIdsList = this.reseauIdsConcatenated.split(',');
        
        Set<Id> resIds = new Set<Id>(reseauIdsList);        
        
        listMacroprofilReseau = [select id, Macroprofil__c
                                 from Macroprofil_Reseau__c
                                 where Reseau__c In:resIds];
        system.debug('listMacroprofilReseau: ' + listMacroprofilReseau);
        
        //get list of macroprofils Ids
        set<Id> setMacroprofilIds = new set<Id>();
        for(Macroprofil_Reseau__c mpr: listMacroprofilReseau){
            setMacroprofilIds.add(mpr.Macroprofil__c);
        }
        
        //get list of accounts concerned 
        String query =  'select Id, Macroprofil_de_reference__c,Macroprofil_actuel__c, Etat__c , Type, Industry, Partenaire__c, Horaire_Ouverture_Reference__c, Horaire_Fermeture_Reference__c, Poids_maximal_accepte_par_colis__c ' + 
                         'from Account where Macroprofil_actuel__c in : setMacroprofilIds';
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC , List<sObject> scope) {
        List<Id> reseauIdsList = this.reseauIdsConcatenated.split(',');
        Set<Id> resIds = new Set<Id>(reseauIdsList);
        listMacroprofilReseau = [select id, Macroprofil__c, Reseau__c, Active__c, Modifiable__c
                                 from Macroprofil_Reseau__c
                                 where Reseau__c In:resIds];
        AP04_Account ap04Acc = new AP04_Account();
        if(listMacroprofilReseau !=null && listMacroprofilReseau.size() > 0){
            ap04Acc.listMacroprofilReseau = listMacroprofilReseau;
            ap04Acc.fillMacroprofilReseau();
            if(scope.size() > 0)
                ap04Acc.manipulateMacroprofilReseau(scope, false);    
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        if(this.reseauIdsConcatenated != null && this.reseauIdsConcatenated != ''){
            List<Id> reseauIdsList = this.reseauIdsConcatenated.split(',');
            Set<Id> resIds = new Set<Id>(reseauIdsList);
            List<Reseau__c> reseauList = new List<Reseau__c>();
            for(Id resId : resIds){
                Reseau__c res = new Reseau__c(id = resId);
                res.Techatraiter__c = false;
                reseauList.add(res);
            }
            update reseauList;
        }        
    }
    
}