trigger AccountBeforeUpdate on Account (before update) {
    
    System.debug('#### CPU TIme Account Beforeupdate: ###### ' + Limits.getCpuTime());
    System.debug('AccountBeforeUpdate Tirgger.new.size(): ' + Trigger.new.size());
    
    //Si c'est le calcul de Récapitulatif de cumul
    if(trigger.new[0].Absence_de_device_existante__c!= trigger.oldMap.get(trigger.new[0].id).Absence_de_device_existante__c
       || trigger.new[0].Absence_de_device_ouverte__c!= trigger.oldMap.get(trigger.new[0].id).Absence_de_device_ouverte__c
       || trigger.new[0].Anomalie_de_synchro_ouverte__c!= trigger.oldMap.get(trigger.new[0].id).Anomalie_de_synchro_ouverte__c
       || trigger.new[0].Decommissionnement_de_device_ouvert__c!= trigger.oldMap.get(trigger.new[0].id).Decommissionnement_de_device_ouvert__c
      ){
          System.debug('#### calcul de Récapitulatif de cumul');
          return;
      }else{
          System.debug('#### no cumule');
      }
    
    if(PAD.canTrigger('AccountBeforeUpdate')){
        // Modifications by gho
        // Modification date : 25/04/2017
        // MP for Orange Accounts are assigned through PB : PUDO_PB11_MAJ_Infos_Societe_gerant
        // PB are tiggered after this class (after insert/update)
        // assign the values here statically
               
        //Copy Address from custom fileds to standard fields or Vice versa
        for(Account acct : Trigger.New ){
            //if(acct.Macroprofil_de_reference__c == null && acct.Macroprofil_actuel__c == null) { 
            if(acct.isOrangePartenaire__c) {
                acct.Macroprofil_de_reference__c = Label.Orange; acct.Macroprofil_actuel__c = Label.Orange;
            } 
            //ON LEAD UPDATE
            acct.shippingCountry = acct.shipping_Country__c;
            acct.shippingCountryCode = acct.Tech_CountryCode__c;
            acct.billingCountry = acct.shipping_Country__c;
            acct.billingCountryCode = acct.Tech_CountryCode__c;
            
            // Si la création du lead se déclenche par le flux en premier
            if(Trigger.oldMap.get(acct.id).ShippingStreet != acct.ShippingStreet 
               && Trigger.oldMap.get(acct.id).BillingStreet != acct.BillingStreet)
            {
                acct.Shipping_Street__c = acct.ShippingStreet;
                acct.Billing_Street__c = acct.BillingStreet;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingStreet = acct.Shipping_Street__c;
                acct.BillingStreet = acct.Billing_Street__c;
            }
            
            // Si la création du lead se déclenche par le flux en premier
            if(Trigger.oldMap.get(acct.id).ShippingPostalCode != acct.ShippingPostalCode
               && Trigger.oldMap.get(acct.id).BillingPostalCode != acct.BillingPostalCode)
            {
                acct.Shipping_Zip_Postal_Code__c = acct.ShippingPostalCode;
                acct.Billing_Zip_Postal_Code__c = acct.BillingPostalCode;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingPostalCode = acct.Shipping_Zip_Postal_Code__c;
                acct.BillingPostalCode = acct.Billing_Zip_Postal_Code__c;
            }
            
            // Si la création du lead se déclenche par le flux en premier
            if(Trigger.oldMap.get(acct.id).ShippingCity != acct.ShippingCity
               && Trigger.oldMap.get(acct.id).BillingCity != acct.BillingCity)
            {
                acct.Shipping_City__c = acct.ShippingCity;
                acct.Billing_City__c = acct.BillingCity;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingCity = acct.Shipping_City__c;
                acct.BillingCity = acct.Billing_City__c;
            }
            // Si la création du lead se déclenche par le flux en premier
            if(Trigger.oldMap.get(acct.id).ShippingState != acct.ShippingState && Trigger.oldMap.get(acct.id).BillingState != acct.BillingState)
            {
                acct.Shipping_State_Province__c = acct.ShippingState; acct.Billing_State_Province__c = acct.BillingState;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingState = acct.Shipping_State_Province__c;
                acct.BillingState = acct.Billing_State_Province__c;
            }
        }  
        //------------------------end of gho modifications-----------------------//
        
        // START TMA we have added a bypass batch 
        if(PAD.canTrigger('AP05_Account')){ 
            AP05_Account.setInternationalReferenceNumber(Trigger.new, Trigger.oldMap);  
        }
        // END TMA
        
        if(PAD.canTrigger('AP09_Account') && AP09_Account.firstRun && !System.isBatch()) { 
            AP09_Account.defineAccountDailyDisponibility(Trigger.newMap , Trigger.oldMap);  
        }
        
        
        //TMAEIL AHA
        if(PAD.canTrigger('AP11_Account')) {
            List<Account> LAccounts = new List<Account>();
            
            for(Account acc : trigger.new){
                if((trigger.oldmap.get(acc.id).Date_de_fin_d_activite__c != acc.Date_de_fin_d_activite__c
                    && acc.etat__c != '2' && acc.Date_de_fin_d_activite__c !=Date.today())
                   || trigger.oldmap.get(acc.id).Contexte__c != acc.Contexte__c){
                       LAccounts.add(acc);
                   }
            }
            
            if(LAccounts.size()>0 && LAccounts != null){
                AP11_Account.changerEtatModeSelonDFA(LAccounts);
            }
        }
        
        
        //added by John Boutros
        if(PAD.canTrigger('AP02_Account'))
        {
            System.debug('AccountBeforeUpdate PAD AP02_Account');
            AP02_Account.createConfigurationandCasierSite(Trigger.new , Trigger.oldMap); 
            AP02_Account.recordTypeEtatAssignment(Trigger.new, Trigger.oldMap);
            //AP02_Account.VRShippingCountryRT_Update(Trigger.new, Trigger.oldMap);
        }
        //added by John Boutros
        if(PAD.canTrigger('AP03_Account'))
        {
            System.debug('AccountBeforeUpdate PAD AP03_Account');
            AP03_Account.checkTypeDeDevice(Trigger.new, Trigger.oldMap);
        }
        //added by John Boutros
        if(PAD.canTrigger('AP11_AssociationPUDOMacroprofil'))
        {
            System.debug('AccountBeforeInsert PAD AP11_AssociationPUDOMacroprofil');
            AP11_AssociationPUDOMacroprofil.associationPUDOMacroprofil(Trigger.new, trigger.oldMap); 
        }
        //TMA: MJE Start 
        if(PAD.canTrigger('AP011_ProcessBuilders'))
        {
            AP011_ProcessBuilders.DoAllProcess(Trigger.New,Trigger.oldMap,true,false);
        }
        // TMA: MJE END
        System.debug('#### CPU TIme Account Beforeupdate: ###### End ##' + Limits.getCpuTime());
    }
}