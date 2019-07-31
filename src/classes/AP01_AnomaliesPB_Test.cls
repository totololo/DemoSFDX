@isTest
public class AP01_AnomaliesPB_Test {
    
    static testMethod void testService(){
        User currentUser = [SELECT Id, Name, BypassValidationRule__c
                            FROM User
                            WHERE Id = : UserInfo.getUserId()];
        currentUser.BypassValidationRule__c = true;
        currentUser.BypassWorkflow__c= true;
        currentUser.BypassProcessBuilder__c= true;
        currentUser.BypassApex__c = 'AP01_Account;AP05_Account;AP06_MacroprofilReseau;Utils_PUS;AP04_Account;AP03_Conge_Indispo;AP06_Conge_Indispo;AP07_Conge_Indispo;AP01_Conge_Indispo;AP02_Conge_Indispo';
        update currentUser;
        
        system.runAs(currentUser){
        //Create Contacts
        list<contact> listContact = new list<contact>();
        Contact c = Utils_TestMethods.CreateContact('c1');
        listContact.add(c);
            
        Contact c1 = Utils_TestMethods.CreateContact('c2');
        listContact.add(c1);
            
        Contact c2 = Utils_TestMethods.CreateContact('c3');
        listContact.add(c2);
            
        Insert listContact;
        
        //Create Macroprofil
        Macroprofil__c m1 = Utils_TestMethods.CreateMacroprofil('m1');
        Macroprofil__c m2 = Utils_TestMethods.CreateMacroprofil('m2');
        Macroprofil__c m3 = Utils_TestMethods.CreateMacroprofil('m3');
        insert new List<Macroprofil__c>{m1, m2, m3};
          
        //Create Account
        Map<String, Id> mapRecordTypeDevNameToId = new Map<String, Id>();
        for(RecordType rt : [SELECT Id, DeveloperName
                             FROM RecordType
                             WHERE DeveloperName='PUS_FR_Pickup_Contact' or  DeveloperName='PUS_FR_Point_non_Suivi_par_le_CO' OR DeveloperName = 'PUS_FR_Consigne' OR DeveloperName = 'PUS_FR_Point_non_Suivi_par_le_CO' 
                             OR DeveloperName = 'PUS_FR_PUDO_Suivi_CO' OR DeveloperName = 'DPD_Pays_Bas_PUDO_Suivi_CO'])
        {
            mapRecordTypeDevNameToId.put(rt.DeveloperName, rt.Id);
        }
        
        Id PUS_FR_Pickup_Contact = mapRecordTypeDevNameToId.get('PUS_FR_Pickup_Contact');
        Id PUS_FR_ConsigneId = mapRecordTypeDevNameToId.get('PUS_FR_Consigne');
        Id PUS_FR_Point_non_Suivi_par_le_CO = mapRecordTypeDevNameToId.get('PUS_FR_Point_non_Suivi_par_le_CO');
        Id PUS_FR_non_Suivi_COId = mapRecordTypeDevNameToId.get('PUS_FR_Point_non_Suivi_par_le_CO');
        Id PUS_FR_PUDO_Suivi_CO = mapRecordTypeDevNameToId.get('PUS_FR_PUDO_Suivi_CO');
        Id DPD_Pays_Bas_PUDO_Suivi_CO = mapRecordTypeDevNameToId.get('DPD_Pays_Bas_PUDO_Suivi_CO');                                                       
        Account account= Utils_TestMethods.CreateAccount(c,m1, 'a1');
        account.Lundi_ferme__c = false;
        account.Mardi_ferme__c = false;
        account.Industry='1';
        account.Activite_commerciale_principale__c='18';
        account.Mercredi_ferme__c = false;
        account.Jeudi_ferme__c = false;
        account.Vendredi_ferme__c = false;
        account.Samedi_ferme__c = false;
        account.Assujetti_la_TVA__c='Non';
        account.Dimanche_ferme__c = false;
        account.Lundi__c = true;
        account.Mardi__c = true;
        account.Mercredi__c = true;
        account.Jeudi__c = true;
        account.Vendredi__c = true;
        account.Samedi__c = true;
        account.Dimanche__c = true;
        account.Horaire_Ouverture_Reference__c = '11:30';
        account.Horaire_Fermeture_Reference__c = '23:00';
        account.Debut_pause_dejeuner__c = '12:00';
        account.Fin_pause_dejeuner__c = '12:00';
        account.ConversionTerminated__c =true;
        account.Etat__c ='2';
        account.RecordTypeId= PUS_FR_Pickup_Contact;        
        account.BillingStreet = 'Test';
        account.BillingPostalCode = '25142';
        account.BillingCountry = 'France';
        account.BillingCountryCode = 'FR';
        account.BillingCity = 'Paris';
        account.ShippingPostalCode = '25142';
        account.ShippingCountry = 'France';
        account.ShippingCountryCode = 'FR';
        account.ShippingCity = 'Paris';
        account.ShippingStreet = 'Test';
        account.N_de_rue_facturation__c = 'test';
                
        insert account; 
        
        c.AccountId = account.id;
        update c;
        
        Account newaccount = account.clone();
        newaccount.Contact_operationnel_1__c = c2.id;
        insert newaccount;
            
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c
                                                                             FROM Association_Record_Type_et_pays__mdt
                                                                             Where MasterLabel ='Belgium'
                                                                             Limit 1];
            
            //Create Account 1
            Account account1= Utils_TestMethods.CreateAccount(c1, null, 'Test Account 1'); 
            account1.RecordTypeId =associationRTPays[0].ID_PUDO_Non_Suivi__c;
            account1.Type = '20';
            account1.BillingCountry ='Belgium';
            account1.ShippingCountry ='Belgium';
            account1.BillingCountryCode = 'BE';
            account1.ShippingCountryCode ='BE';
            account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
            account1.Operateur_Global__c = 'DPD_BNL';
            account1.BillingPostalCode ='1234';
            account1.ShippingPostalCode = '1243';
            account1.Long_Lat_adresse_de_livraison__Latitude__s=62;
            account1.Long_Lat_adresse_de_livraison__Longitude__s=21;
            insert account1;
            
            c1.AccountId = account1.id;
            //update c1;
            
            c2.AccountId = newAccount.id;
            //update c2;
            
            update listContact;
        
        Test.startTest();
        
        List<Anomalie__c> ListAnomalie = new List<Anomalie__c> ();
        Anomalie__c a=new Anomalie__c();
        a.Name='test';
        a.PUDO__c=account.id;
        a.Statut__c='1';
        a.Type__c='SyncPudo';
        ListAnomalie.add(a);
        Anomalie__c b=new Anomalie__c();
        b=a.clone();
        b.Statut__c='1';
        b.Type__c= 'NoDevice';
        b.PUDO__c =newaccount.id;
        ListAnomalie.add(b);
        Anomalie__c a2=new Anomalie__c();
        a2.Name='test2';
        a2.PUDO__c=account1.id;
        a2.Statut__c='1';
        a2.Type__c='SyncPudo';
        ListAnomalie.add(a2);
        Anomalie__c a3=new Anomalie__c();
        a3.Name='test2';
        a3.PUDO__c=account1.id;
        a3.Statut__c='1';
        a3.Type__c='NoDevice';
        ListAnomalie.add(a3);
        insert ListAnomalie;
        a.Statut__c='0'; 
        update a;
        Test.stopTest();
        }}
}