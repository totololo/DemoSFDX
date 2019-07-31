trigger Conge_Indispo_BeforeDelete on Conge_Indispo__c (before delete) {  
    AP03_Conge_Indispo congeIndispo = new AP03_Conge_Indispo();  
    if(PAD.canTrigger('AP03_Conge_Indispo')){
       congeIndispo.datesEnCours(Trigger.old);         
    }
}