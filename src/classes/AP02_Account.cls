/*
* Author: Amal CHREITEH
* Modified By: John Boutros
* Date : 12/01/2018
* Description:
* Test classe: AP02_Account_TEST
Coverage : 98%
*/
public class AP02_Account {
    // créer configuration locke type à partir de la configuratioin existante
    // créer une configuration casier site à partir de Type de casier existant
    public static void createConfigurationandCasierSite(List<Account> newAccounts ,Map<Id, Account> oldAccounts) {
        Set<Id> configurationIds = new Set<Id>();
        List<Configuration_Site__c> ConfigurationSiteToDelete = new List<Configuration_Site__c>();
        List<Account> AccountsTobeUpdated = new List<Account>();
        Map<Id, Configuration_Site__c> accountConfigSite = new Map <Id, Configuration_Site__c>();
        for(Account newAccount : newAccounts){
            if(Label.RT_Consigne_Compte.contains(newAccount.recordTypeID))
            {
                if(newAccount.Recopie_Configuration__c == true){
                    configurationIds.add(newAccount.Configuration__c);
                    AccountsTobeUpdated.add(newAccount);
                    if(newAccount.Configuration_Site__c != null){
                        ConfigurationSiteToDelete.add(new Configuration_site__c(id = oldAccounts.get(newAccount.Id).Configuration_Site__c ));
                    }
                }
                else if(newAccount.Configuration_Site__c == null){
                    if(oldAccounts!= null && oldAccounts.ContainsKey(newAccount.Id)){
                        if(oldAccounts.get(newAccount.Id).Configuration_Site__c != null)
                        {
                            ConfigurationSiteToDelete.add(new Configuration_site__c(id = oldAccounts.get(newAccount.Id).Configuration_Site__c ));
                        }
                    }
                    newAccount.Configuration__c =null;
                }
                
            }
        }
        Set<Id> configurationIdsWithoutNull = new Set<Id>();
        if(configurationIds.size()>0){
            Map<Id, Configuration__c> newConfigurations = new Map<Id, Configuration__c>([select id, Modele__c,name,Description__c
                                                                                         From Configuration__c
                                                                                         Where id in : configurationIds ]);
            List<Configuration_Locker_Type__c> lockerTypeOfRetrievedConfigurationList = [Select id, Configuration__c, Type_de_casier__c, Name, Type_de_casier__r.name,Type_de_casier__r.Modele__c,
                                                                                         Type_de_casier__r.Minimum__c,Type_de_casier__r.Moyenne__c,Type_de_casier__r.Maximum__c,Type_de_casier__r.Coef_Ajustement__c,
                                                                                         Nombre__c
                                                                                         From Configuration_Locker_Type__c
                                                                                         Where Configuration__c in : configurationIds];
            if(newConfigurations.size()>0){
                Map<Id, List<Configuration_Locker_Type__c>> lockerTypeMap = new Map<Id, List<Configuration_Locker_Type__c>>();
                List<Casier_Site__c> newCasierSiteList = new List<Casier_Site__c>();
                for(Configuration_Locker_Type__c lockerType : lockerTypeOfRetrievedConfigurationList ){
                    if(!lockerTypeMap.containsKey(lockerType.Configuration__c)){
                        lockerTypeMap.put(lockerType.Configuration__c, new List<Configuration_Locker_Type__c>());
                    }
                    lockerTypeMap.get(lockerType.Configuration__c).add(lockerType);
                }
                List<Configuration_Site__c> newConfigSite = new List<Configuration_Site__c>();
                Map<Casier_Site__c, Configuration_site__c> configSiteCasierSite = new Map <Casier_Site__c, Configuration_site__c>();
                for(Account newAccount: AccountsTobeUpdated){
                    Configuration__c accountConfig = newConfigurations.get(newAccount.Configuration__c); 
                    Configuration_Site__c newConfigurationSite = new Configuration_Site__c();
                    newConfigurationSite.Tech_Compte__c = newAccount.Id;
                    newConfigurationSite.name = accountConfig.name;
                    newConfigurationSite.Description__c= accountConfig.Description__c;
                    newConfigurationSite.Nom_Configuration__c = accountConfig.name;
                    newConfigurationSite.Modele__c = accountConfig.Modele__c;
                    newConfigSite.add(newConfigurationSite);
                    accountConfigSite.put(newAccount.Id, newConfigurationSite );
                    if(lockerTypeMap.size() > 0)
                    {
                        for(Configuration_Locker_Type__c lockerTypeOfRetrievedConfiguration : lockerTypeMap.get(accountConfig.Id))
                        {
                            Casier_Site__c newCasierSite = new Casier_Site__c();
                            newCasierSite.Name = lockerTypeOfRetrievedConfiguration.Type_de_casier__r.name;//lockerTypeOfRetrievedConfiguration.name;
                            //newCasierSite.Nombre__c = lockerTypeOfRetrievedConfiguration.Nombre__c;
                            //newCasierSite.Nom_de_Type_de_casier__c  = lockerTypeOfRetrievedConfiguration.Type_de_casier__r.name;
                            newCasierSite.Modele__c = lockerTypeOfRetrievedConfiguration.Type_de_casier__r.Modele__c;
                            newCasierSite.Minimum__c = lockerTypeOfRetrievedConfiguration.Type_de_casier__r.Minimum__c;
                            newCasierSite.Moyenne__c = lockerTypeOfRetrievedConfiguration.Type_de_casier__r.Moyenne__c;
                            newCasierSite.Maximum__c = lockerTypeOfRetrievedConfiguration.Type_de_casier__r.Maximum__c;
                            newCasierSite.Coef_Ajustement__c = lockerTypeOfRetrievedConfiguration.Type_de_casier__r.Coef_Ajustement__c;
                            newCasierSite.Seuil_contractuel__c = lockerTypeOfRetrievedConfiguration.Nombre__c;
                            newCasierSite.Seuil_calcule__c = lockerTypeOfRetrievedConfiguration.Nombre__c;//1;
                            configSiteCasierSite.put(newCasierSite, newConfigurationSite);
                        }
                    }
                }
                try{
                    insert newConfigSite;
                    system.debug('newConfigSite'+ newConfigSite);
                    for(Casier_Site__c casierSite : configSiteCasierSite.keyset())
                    {
                        casierSite.Configuration_Site__c = configSiteCasierSite.get(casierSite).id;
                        newCasierSiteList.add(casierSite);
                    }
                    insert newCasierSiteList;
                    for(Account acc : AccountsTobeUpdated){
                        if(accountConfigSite.containsKey(acc.Id)){
                            acc.Configuration_Site__c = accountConfigSite.get(acc.Id).Id;
                        }
                        acc.Recopie_Configuration__c = false;
                    }
                    
                }
                catch(exception e){
                    AccountsTobeUpdated[0].Configuration__c.addError(e.getMessage());
                }
            }
            
        }
        if(ConfigurationSiteToDelete.size()>0){
            List<Casier_Site__c> casierSiteTodelete = [Select Id 
                                                       from Casier_Site__c
                                                       where Configuration_Site__c in :ConfigurationSiteToDelete];
            if(casierSiteTodelete.size()>0){
                Delete casierSiteTodelete;
            }
            Delete ConfigurationSiteToDelete;            
        }
    }
   
        // modifier le type d'enregistrement selon la valeur de l'état (En utilisant les ID stocké dans la métadonné personnalisé)
    public static void recordTypeEtatAssignment(List<Account> newAccountList, map<id, Account> oldAccountMap){
        Map<String, ID> associationRTPaysValiderMap  = new Map<String, ID>();
        Map<String, ID> associationRTPaysSuiviCOMap  = new Map<String, ID>();
        String key = '';
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel,
                                                                         ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt]; 
        
        for(Association_Record_Type_et_pays__mdt assRTPays  : associationRTPays){
            key = assRTPays.MasterLabel;
            if(!associationRTPaysValiderMap.containsKey(key)){
                associationRTPaysValiderMap.put(key, assRTPays.ID_Prospect_A_Valider__c);
            }
            if(!associationRTPaysSuiviCOMap.containsKey(key))
            {
                associationRTPaysSuiviCOMap.put(key, assRTPays.ID_suivi_CO__c);
            }
        }
        
        for(Account newAccount : newAccountList)
        {
            //if etat changed and new etat = 1 and international
            if(oldAccountMap.get(newAccount.Id).Etat__c != newAccount.Etat__c && newAccount.Etat__c == '1'  
               && ( LABEL.RT_INT_Compte.contains(newAccount.recordTypeID) || LABEL.RT_INT_Compte2.contains(newAccount.recordTypeID))
               && LABEL.RT_ProspectConverti_Compte.contains(newAccount.recordTypeID))
            {    
                //Prospect Converti
                key = newAccount.BillingCountry;
                if(associationRTPaysValiderMap.containsKey(key))
                {
                    newAccount.RecordTypeId = associationRTPaysValiderMap.get(key);
                }
            }
            //if etat changed and new etat = 2 and international
            else if(oldAccountMap.get(newAccount.Id).Etat__c != newAccount.Etat__c && newAccount.Etat__c == '2'  
                    && ( LABEL.RT_INT_Compte.contains(newAccount.recordTypeID) || LABEL.RT_INT_Compte2.contains(newAccount.recordTypeID) )
                    && LABEL.RT_ProspectAValider_Compte.contains(newAccount.recordTypeID))
            {                    
                key = newAccount.BillingCountry;
                if(associationRTPaysSuiviCOMap.containsKey(key))
                {
                    newAccount.RecordTypeId = associationRTPaysSuiviCOMap.get(key);
                }
            }
        }
    }
}