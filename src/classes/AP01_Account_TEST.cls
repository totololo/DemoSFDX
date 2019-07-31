/* Author     : Sami Diab
* Date       : 2016-11-15
* Description   : Test AP01_Account 
*/
@isTest
public class AP01_Account_TEST {
    
    static testMethod void testService()
    {
        User currentUser = [SELECT Id, Name, BypassValidationRule__c
                            FROM User
                            WHERE Id = : UserInfo.getUserId()];
        currentUser.BypassValidationRule__c = true;
        currentUser.BypassWorkflow__c= true;
        currentUser.BypassProcessBuilder__c= true;
        currentUser.BypassApex__c = 'AP01_Account;AP05_Account;AP06_MacroprofilReseau;Utils_PUS;AP04_Account;AP03_Conge_Indispo;AP06_Conge_Indispo;AP07_Conge_Indispo;AP01_Conge_Indispo;AP02_Conge_Indispo';
        update currentUser;
        
        //Create Contact
        Contact c = Utils_TestMethods.CreateContact('c1');
        Insert c;
        
        //Create Macroprofil
        Macroprofil__c m1 = Utils_TestMethods.CreateMacroprofil('m1');
        Macroprofil__c m2 = Utils_TestMethods.CreateMacroprofil('m2');
        Macroprofil__c m3 = Utils_TestMethods.CreateMacroprofil('m3');
        insert new List<Macroprofil__c>{m1, m2, m3};
            
            
            //Create Services
            Service__c s1 = Utils_TestMethods.CreateService('s1');
        Service__c s2 = Utils_TestMethods.CreateService('s2');
        Service__c s3 = Utils_TestMethods.CreateService('s3');
        insert new List<Service__c>{s1, s2, s3};
            
            //Create Transporteurs
            Transporteur__c t1 = Utils_TestMethods.CreateTransporteur('t1');
        Transporteur__c t2 = Utils_TestMethods.CreateTransporteur('t2');
        Transporteur__c t3 = Utils_TestMethods.CreateTransporteur('t3');
        Insert new List<Transporteur__c>{t1, t2, t3};
            
            //Create Macroprofil Service
            Macroprofil_Service__c ms1 = Utils_TestMethods.CreateMacroprofilService(m1,s1);
        Macroprofil_Service__c ms2 = Utils_TestMethods.CreateMacroprofilService(m2,s2);
        Macroprofil_Service__c ms3 = Utils_TestMethods.CreateMacroprofilService(m2,s3);
        Insert new List<Macroprofil_Service__c>{ms1,ms2,ms3};     
            
            //Create Macroprofil Tranporteur
            Macroprofil_Transporteur__c mt1 = Utils_TestMethods.CreateMacroprofilTransporteur(m1,t1);
        Macroprofil_Transporteur__c mt2 = Utils_TestMethods.CreateMacroprofilTransporteur(m2,t2);
        Macroprofil_Transporteur__c mt3 = Utils_TestMethods.CreateMacroprofilTransporteur(m2,t3);
        Insert new List<Macroprofil_Transporteur__c>{mt1, mt2, mt3}; 
            
          
        
        //Create Account
         Map<String, Id> mapRecordTypeDevNameToId = new Map<String, Id>();
    for(RecordType rt : [SELECT Id, DeveloperName
                         FROM RecordType
                         WHERE DeveloperName='PUS_FR_Pickup_Contact' or  DeveloperName='PUS_FR_Point_non_Suivi_par_le_CO' OR DeveloperName = 'PUS_FR_Consigne' OR DeveloperName = 'PUS_FR_Point_non_Suivi_par_le_CO' OR DeveloperName = 'PUS_FR_PUDO_Suivi_CO'])
    {
        mapRecordTypeDevNameToId.put(rt.DeveloperName, rt.Id);
    }
        
        Id PUS_FR_Pickup_Contact = mapRecordTypeDevNameToId.get('PUS_FR_Pickup_Contact');
    Id PUS_FR_ConsigneId = mapRecordTypeDevNameToId.get('PUS_FR_Consigne');
    Id PUS_FR_Point_non_Suivi_par_le_CO = mapRecordTypeDevNameToId.get('PUS_FR_Point_non_Suivi_par_le_CO');
    Id PUS_FR_non_Suivi_COId = mapRecordTypeDevNameToId.get('PUS_FR_Point_non_Suivi_par_le_CO');
    Id PUS_FR_PUDO_Suivi_CO = mapRecordTypeDevNameToId.get('PUS_FR_PUDO_Suivi_CO');
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
          Test.startTest();
        
        AP01_Account.firstRun = true;
        
        account.Macroprofil_de_reference__c = m2.Id;
        account.Lundi__c=false;
        update account;
        account.Lundi__c=true;
        account.RecordTypeId = PUS_FR_PUDO_Suivi_CO ;
        account.Date_de_la_formation_reelle__c=system.today();
        c.AccountId = account.Id;
        update c;
        account.Contact_operationnel_1__c = c.Id;
        update account;
        account.RecordTypeId =PUS_FR_Point_non_Suivi_par_le_CO;
        AP01_Account.firstRun = true;
        account.Etat__c='7';
        account.Type ='3';
        account.Mode__c='900';
        account.Partenaire__c='237';
        account.Macroprofil_de_reference__c = m1.Id;
        //update account;     
        account.Partenaire__c='-2';
        account.Type='22';
        update account;
        
        List<Account> ListAccountToInsert = new List<Account> ();
        Account acc = new account();
        acc = account.clone();
        acc.Partenaire__c='-2' ;
        acc.Type='22';
        ListAccountToInsert.add(acc); 
        
        Account acc1 = new account();
        acc1 = account.clone();
        acc1.Partenaire__c='4' ;
        acc1.Type='3';
        ListAccountToInsert.add(acc1);  
        
        Account acc2 = new account();
        acc2 = account.clone();
        acc2.Partenaire__c='-2' ;
        acc2.Type='22';
        ListAccountToInsert.add(acc2); 
        insert ListAccountToInsert; 
        
        Test.stopTest();
         
    }
    
}