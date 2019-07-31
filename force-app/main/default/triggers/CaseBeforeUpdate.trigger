/*--------------------------------------------------------------------------
 * Author: Chahid Khalil
 * Company : EI Technologies Liban
 * Description: triger before update Requete
 * Created Date: 4/05/2018
--------------------------------------------------------------------------*/
trigger CaseBeforeUpdate on Case (before update) {
	
     if(PAD.canTrigger('AP02_Case')){ 
            AP02_Case.ValidateCanCloseCase(Trigger.new, Trigger.oldMap);  
        }
}