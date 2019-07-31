trigger ReseauBeforeUpdate on Reseau__c (before update) {
		
    for(Reseau__c reseau :trigger.new){
        if(trigger.oldMap != null && trigger.oldMap.get(reseau.Id) !=null){
            Reseau__c oldReseau = trigger.oldMap.get(reseau.Id);
            if(reseau.Type_de_point__c != oldReseau.Type_de_point__c || reseau.Domaine_d_activite__c != oldReseau.Domaine_d_activite__c ||
               reseau.Partenaire__c != oldReseau.Partenaire__c  || reseau.Horaire_d_ouverture_de_reference__c != oldReseau.Horaire_d_ouverture_de_reference__c || 
               reseau.Horaire_de_fermeture_de_reference__c != oldReseau.Horaire_de_fermeture_de_reference__c || reseau.Poidsmaxacceptparcolis__c != oldReseau.Poidsmaxacceptparcolis__c)
                reseau.Techatraiter__c = true;
            //ticket 131288
            reseau.Tech_Operateur__c = reseau.Operateur__c;
        }
	}
}