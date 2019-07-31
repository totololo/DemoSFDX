/* Class that test the functionality of AP04_Anomalie*/
@isTest
public class AP04_Anomalie_Test {
    
    static testMethod void testClotureAnomalie(){
        User us =  Utils_TestMethods.createUser('usr','a','aUsr@usr.com','aUsr@mail.com');
        us.BypassValidationRule__c = true;
        insert us;

        system.runAs(us){
        //Create Contact
        Contact c = Utils_TestMethods.CreateContact('c1');
        Insert c;
        
        //Create Macroprofil
        Macroprofil__c m1 = Utils_TestMethods.CreateMacroprofil('m1');
        insert new List<Macroprofil__c>{m1};
            
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
        c.AccountId = account.id;
        update c;
        Test.startTest();
        
        List<Anomalie__c> ListAnomalie = new List<Anomalie__c> ();
        Anomalie__c a=new Anomalie__c();
        a.Name='test';
        a.PUDO__c=account.id;
        a.Statut__c='1';
        a.Type__c='Association à tort Etat 2';
        ListAnomalie.add(a);
        insert ListAnomalie;
        account.Etat__c = '5';
        update account;
      Test.stopTest();}
    }
}