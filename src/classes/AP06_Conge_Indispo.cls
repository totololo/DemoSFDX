public class AP06_Conge_Indispo {
    
    private Map<Id, String> mapIdRecordTypes = new Map<Id ,String>(); 
    
    // Closed Conge/Indispo (Passé) cannot be modified
    // Only Type and SousType Can be modified for consigne indisponibilités
    public void checkCongeIndispoStatus(List<Conge_Indispo__c> listCongeIndispo , Map<Id, Conge_Indispo__c> mapOldCongeIndispo) {
        fillRecordTypesMap();
        String strErrorMessage;
        String congeIndispoRT;
        String congeIndispoAccountRT;
        boolean bError;
        Conge_Indispo__c oldCongeIndispo;
        for(Conge_Indispo__c congeIndispo : listCongeIndispo) {
            oldCongeIndispo = mapOldCongeIndispo.get(congeIndispo.Id);
            bError = false;
            congeIndispoRT = congeIndispo.RecordTypeId;
            congeIndispoAccountRT = congeIndispo.Compte_RecordType__c;
            strErrorMessage = Label.Update_Right + ' ';
            if(mapOldCongeIndispo.get(congeIndispo.Id).Statut__c.equals(System.Label.ClosedCongeIndispo)) { 
                if(congeIndispoRT.contains(Label.IndispoConsigneRT_15) && congeIndispoAccountRT.contains(Label.AccountConsigneRT_15)) {
                    if(oldCongeIndispo.Date_de_debut__c != congeIndispo.Date_de_debut__c || oldCongeIndispo.Date_de_fin__c != congeIndispo.Date_de_fin__c) {
                        bError = true;
                        strErrorMessage += Label.Consigne_Date + ' ';
                    }
                } else {
                    bError = true;
                }
                
            }
            if(bError) {
                if(mapIdRecordTypes.containsKey(congeIndispo.RecordTypeId)){
                    strErrorMessage += mapIdRecordTypes.get(congeIndispo.RecordTypeId) + ' ';
                    strErrorMessage += Label.Old_Status;
                    congeIndispo.addError(strErrorMessage);
                } 
            } 
        } 
    }
    
    private void fillRecordTypesMap() { 
         Id congeRTypeId = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByName().get(Label.CongeRT).getRecordTypeId();
    	 Id dispoRTypeId = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByName().get(Label.DisponibiliteRT).getRecordTypeId();
         Id indispoStandardRTypeId = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByName().get(Label.IndisponibiliteStandardRT).getRecordTypeId();
         Id indispoConsigneRTypeId = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByName().get(Label.IndisponibiliteConsigneRT).getRecordTypeId();
         mapIdRecordTypes.put(congeRTypeId, System.Label.CongeRT);
         mapIdRecordTypes.put(dispoRTypeId, System.Label.CongeRT);
         mapIdRecordTypes.put(indispoStandardRTypeId, System.Label.Indisponibilite);
         mapIdRecordTypes.put(indispoConsigneRTypeId, System.Label.Indisponibilite);
    }
}