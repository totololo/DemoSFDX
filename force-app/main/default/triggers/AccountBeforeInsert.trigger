trigger AccountBeforeInsert on Account (before insert) {
    if(PAD.canTrigger('AccountBeforeInsert')){
        List<Account> LAccounts = new List<Account>();
        // Modifications by gho
        // Modification date : 25/04/2017
        // MP for Orange Accounts are assigned through PB : PUDO_PB11_MAJ_Infos_Societe_gerant
        // PB are tiggered after this class (after insert/update)
        // assign the values here statically

        //Copy Address from custom fileds to standard fields or Vice versa
        for(Account acct : Trigger.New ){        
            // if(acct.Macroprofil_de_reference__c == null && acct.Macroprofil_actuel__c == null) { 
            if(acct.isOrangePartenaire__c) {
                acct.Macroprofil_de_reference__c = Label.Orange;acct.Macroprofil_actuel__c = Label.Orange;
            }
            
            if(PAD.canTrigger('AP11_Account')) {
                if(acct.Date_de_fin_d_activite__c != null && acct.etat__c != '2' && acct.Date_de_fin_d_activite__c !=Date.today() && acct.Contexte__c != null){
                    LAccounts.add(acct);
                }
            }
            
            acct.shippingCountry = acct.shipping_Country__c;
            if(acct.shippingCountryCode == null)
            {
                acct.shippingCountryCode = acct.Tech_CountryCode__c;
            }
            acct.billingCountry = acct.shipping_Country__c;
            if(acct.billingCountryCode == null)
            {
                acct.billingCountryCode = acct.Tech_CountryCode__c;
            }

            // Si la création du lead se déclenche par le flux en premier
            if(acct.Shipping_Street__c == null && acct.Billing_Street__c == null)
            {
                acct.Shipping_Street__c = acct.ShippingStreet;
                acct.Billing_Street__c = acct.BillingStreet;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingStreet = acct.Shipping_Street__c;acct.BillingStreet = acct.Billing_Street__c;
            }
            
            // Si la création du lead se déclenche par le flux en premier
            if(acct.Shipping_Zip_Postal_Code__c == null && acct.Billing_Zip_Postal_Code__c == null)
            {
                acct.Shipping_Zip_Postal_Code__c = acct.ShippingPostalCode;
                acct.Billing_Zip_Postal_Code__c = acct.BillingPostalCode;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingPostalCode = acct.Shipping_Zip_Postal_Code__c;acct.BillingPostalCode = acct.Billing_Zip_Postal_Code__c;
            }
            
            // Si la création du lead se déclenche par le flux en premier
            if(acct.Shipping_City__c == null && acct.Billing_City__c == null)
            {
                acct.Shipping_City__c = acct.ShippingCity;
                acct.Billing_City__c = acct.BillingCity;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingCity = acct.Shipping_City__c;acct.BillingCity = acct.Billing_City__c;
            }
            
            // Si la création du lead se déclenche par le flux en premier
            if(acct.Shipping_State_Province__c == null && acct.Billing_State_Province__c == null)
            {
                acct.Shipping_State_Province__c = acct.ShippingState;
                acct.Billing_State_Province__c = acct.BillingState;
            }
            // Si la création du lead se déclenche par la sauvgarde sur la présentation de page
            else
            {
                acct.ShippingState = acct.Shipping_State_Province__c;acct.BillingState = acct.Billing_State_Province__c;
            }
            
        } 
        
        //TMAEIL AHA
        if(PAD.canTrigger('AP11_Account')) {
            if(LAccounts.size()>0 && LAccounts != null){AP11_Account.changerEtatModeSelonDFA(LAccounts);
            }
        }
        //END
        
        
        List<Account> listAccountsToBeAdded = new List<Account>();
        

        if(PAD.canTrigger('AP05_Account')){ 
            AP05_Account.setInternationalReferenceNumber(Trigger.new , null);   
        }
        
        if(PAD.canTrigger('AP09_Account')) {
            AP09_Account.defineAccountDailyDisponibility(Trigger.new,false);  
        }
        
        //added by John Boutros
        if(PAD.canTrigger('AP02_Account'))
        {
            System.debug('AccountBeforeInsert PAD VFC07_Configuration');
            AP02_Account.createConfigurationandCasierSite(Trigger.new, null);
            //AP02_Account.VRShippingCountryRT_Insert(Trigger.new, null);
        }
        //added by John Boutros
        if(PAD.canTrigger('AP03_Account'))
        {
            System.debug('AccountBeforeInsert PAD AP03_Account');
            AP03_Account.checkTypeDeDevice(Trigger.new, null);
        }
        //added by John Boutros
        if(PAD.canTrigger('AP11_AssociationPUDOMacroprofil'))
        {
            System.debug('AccountBeforeInsert PAD AP11_AssociationPUDOMacroprofil');
            AP11_AssociationPUDOMacroprofil.associationPUDOMacroprofil(Trigger.new, Null); 
        }
        
        //TMA: MJE Start 
        if(PAD.canTrigger('AP011_ProcessBuilders'))
        {
            AP011_ProcessBuilders.DoAllProcess(Trigger.New,null,true,true);
        }
        // TMA: MJE END
    }
}