/* Author       : Sami Diab
* Date          : 2016-11-14
* Description   : This trigger is made to catch changes on 
*                 Account in order to check the Macroprofil changements 
*/
trigger AccountAfterUpdate on Account (after update) {
    
    System.debug('#### CPU TIme Account AFTERupdate: ###### ' + Limits.getCpuTime());
    System.debug('AccountAfterUpdate Tirgger.new.size(): ' + Trigger.new.size());
    
    //Si c'est le calcul de Récapitulatif de cumul
    if(trigger.new[0].Absence_de_device_existante__c!= trigger.oldMap.get(trigger.new[0].id).Absence_de_device_existante__c
       || trigger.new[0].Absence_de_device_ouverte__c!= trigger.oldMap.get(trigger.new[0].id).Absence_de_device_ouverte__c
       || trigger.new[0].Anomalie_de_synchro_ouverte__c!= trigger.oldMap.get(trigger.new[0].id).Anomalie_de_synchro_ouverte__c
       || trigger.new[0].Decommissionnement_de_device_ouvert__c!= trigger.oldMap.get(trigger.new[0].id).Decommissionnement_de_device_ouvert__c
      ){
          System.debug('#### calcul de Récapitulatif de cumul');
          return;
      }else{
          System.debug('#### no cumul');
      }
    
    if(trigger.isAfter && trigger.isUpdate) {
        /* Update associations (Service/Transporteur) if Macroprofil changed */
        if(PAD.canTrigger('AP01_Account')){
            AP01_Account.UpdateAssociations(trigger.old, trigger.new);
        }
    }
    System.debug('#### CPU TIme Account AFTERupdate: ###### END ###' + Limits.getCpuTime());
    
    //TMA Start 
    if(PAD.canTrigger('AP011_ProcessBuilders'))
    {
        AP011_ProcessBuilders.DoAllProcess(Trigger.New,Trigger.oldMap,false,false);
    }
    // TMA END
    if(PAD.canTrigger('AP06_Account')){
       AP06_Account.createCaseUpdate(trigger.new,trigger.oldMap); 
    }
    if(PAD.canTrigger('AP04_Anomalie')){
        AP04_Anomalie.clotureAnomalie(trigger.new,trigger.oldMap);}
}