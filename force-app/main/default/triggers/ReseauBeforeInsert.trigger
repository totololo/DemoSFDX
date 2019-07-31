trigger ReseauBeforeInsert on Reseau__c (before insert) {
    for(Reseau__c reseau :trigger.new){
        reseau.Techatraiter__c = true;
        //ticket 131288
        reseau.Tech_Operateur__c = reseau.Operateur__c;
    }
}