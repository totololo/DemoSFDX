trigger ServiceAssocieAfterUpdate on Service_Associe__c (after update) {
   if(PAD.canTrigger('AP04_Account')){
        Set<Id> setAccountIds = new Set<Id>();
        for(Service_Associe__c ta : trigger.new){
            setAccountIds.add(ta.Compte__c);
        }
        System.debug('###gho setAccountIds : ' + setAccountIds);
      if(PAD.canTrigger('AP02_ReseauAssocie')){
         AP02_ReseauAssocie.checkAssociations(setAccountIds);
      }       
    } 

}