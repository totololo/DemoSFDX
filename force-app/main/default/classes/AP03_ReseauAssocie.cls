/*
* Class to fill the number of PUDO associated to a reseau(relation us lookup instead of Master-Detail)
* @author: Georges Hobeika
* @date: 12/05/2017
* @Test: VFC03_DemarrageActiviteAppel_Test
*/

public class AP03_ReseauAssocie {
 
    
    private static Map<Id,Reseau__c> mapReseau;
    private static Set<Id> setReseauIds = new Set<Id>();
    
    
    public static void calculateReseauSeuil(Map<Id,Reseau_Associe__c> mapRA, Map<Id, Reseau_Associe__c> mapOldRA) {
        
        // get the distinct reseaux ids from the reseau associe map
        for(Reseau_Associe__c ra : mapRa.values()) {
            setReseauIds.add(ra.reseau__c);
        }
        
 		mapReseau = new Map<Id, Reseau__c>([SELECT Id , NombredePUDOAssocies__c
                                            FROM Reseau__c
                                            where Id IN : setReseauIds
                                           ]);
         
        // old data contains null as value for the field NombredePUDOAssocies__c
        // this field has to be numeric so we can apply icremental or decremental action later
        for(Reseau__c res : mapReseau.values()) {
            if(res.NombredePUDOAssocies__c == null) { 
                res.NombredePUDOAssocies__c = 0;
            }
        }
        
        Reseau_Associe__c oldRA;
        for(Reseau_Associe__c ra : mapRa.values()) {
            oldRA = null;
            if(mapOldRA != null) {
                oldRA = mapOldRA.get(ra.Id);
            }
            // applicable for new reseau or activated/desactivated reseaux
            if(oldRA == null || ra.Active__c != oldRA.Active__c) {
                if(ra.Active__c) {
                    mapReseau.get(ra.reseau__c).NombredePUDOAssocies__c ++;
                } else {
                    if(mapReseau.get(ra.reseau__c).NombredePUDOAssocies__c > 0) {
                        mapReseau.get(ra.reseau__c).NombredePUDOAssocies__c --;
                    }
                }
            }
        }
        
       update mapReseau.values();
    }
}