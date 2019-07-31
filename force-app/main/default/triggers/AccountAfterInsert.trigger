/* Author       : Sami Diab
* Date          : 2016-11-14
* Description   : This trigger is made to catch changes on 
*                 Account in order to check the Macroprofil changements 
*/
trigger AccountAfterInsert on Account (after insert) {  
    /* Update associations (Service/Transporteur) if Macroprofil changed */
    if(PAD.canTrigger('AP01_Account')){
        AP01_Account.UpdateAssociations(trigger.old, trigger.new);
    }
    
    //TMA Start 
        if(PAD.canTrigger('AP011_ProcessBuilders'))
        {
        AP011_ProcessBuilders.DoAllProcess(Trigger.New,Trigger.oldMap,false,true);
        }
    //TMA END    
   /* if(PAD.canTrigger('AP06_Account')){
       AP06_Account.createCaseUpdate(trigger.new); 
    }*/
   
    
}