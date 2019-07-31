/*
* Class used for common functionalities
* @author: Lea Zoghbi
* @date: 05/0/2017
* @Test: 
*/
public class Utils_PUS {
  public static boolean firstRun = true;
  public static boolean firstAllRun = false;
    public static void checksObjectNonModifiable(list<sObject> listAssocie, map<id, sObject> mapOldAssocie, string errormsg){
        if(firstRun){
            for(sObject sobj : listAssocie){
                if(mapOldAssocie.get((Id)sobj.get('Id')).get('tech_bypassNonModifiableCheck__c') == (sobj.get('tech_bypassNonModifiableCheck__c'))){                    
                    if(!(boolean)sobj.get('Modifiable__c')){// && mapOldAssocie.containskey((Id)sobj.get('Id')))) && mapOldAssocie.get((Id)sobj.get('Id')).get('Active__c') != (sobj.get('Active__c'))){                        
                        sobj.addError(errormsg);
                    }
                }
            }
            firstRun = false;
        }
    }
}