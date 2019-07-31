/*
* Class to propagate creation or modification of any reseau transporteur on a MP to all accounts having this MP
* @author: Lea Zoghbi
* @date: 19/12/2016
* @Test: AP06_MacroprofilReseau_TEST
*/
public class AP06_MacroprofilReseau {
    public static void InsertUpdateReseauAssocie(list<Macroprofil_Reseau__c> listMacroprofilReseau){
        
        if(PAD.canTrigger('AP04_Account')) {
            System.debug('###gho 1');
			if(!Utils_PUS.firstAllRun){
                System.debug('###gho 2');
				AP04_Account ap04Acc = new AP04_Account();
				ap04Acc.listMacroprofilReseau = listMacroprofilReseau;
				ap04Acc.fillMacroprofilReseau(); 
				System.debug('###gho 3');
			
				//get list of macroprofils Ids
				set<Id> setMacroprofilIds = new set<Id>();
				for(Macroprofil_Reseau__c mpr: listMacroprofilReseau){
                    System.debug('###gho 4');
					setMacroprofilIds.add(mpr.Macroprofil__c);
				}
				
				//get list of accounts concerned 
				list<Account> listAccounts = [ select Id, Macroprofil_de_reference__c, Type, Industry, Partenaire__c, 
											  Horaire_Ouverture_Reference__c, Horaire_Fermeture_Reference__c, Poids_maximal_accepte_par_colis__c
											  from Account 
											  where Macroprofil_de_reference__c in : setMacroprofilIds]; 
				if(listAccounts.size() > 0) {
                    System.debug('###gho 5');
					ap04Acc.manipulateMacroprofilReseau(listAccounts, false);
				}
			}            
        }
    }
}