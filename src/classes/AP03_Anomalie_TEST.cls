/* 
 * Author        : RFO
 * Date          : 2018-06-05
 * Description   : Test AP03_Anomalie 
 */
@isTest
public class AP03_Anomalie_TEST {
    
    static testMethod void testExtractDataFromAnomalyDescription(){
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
           
        //Create Services
        Service__c s1 = Utils_TestMethods.CreateService('s1');
            
        //Create Transporteurs
        Transporteur__c t1 = Utils_TestMethods.CreateTransporteur('t1');
            
        //Create Macroprofil Service
        Macroprofil_Service__c ms1 = Utils_TestMethods.CreateMacroprofilService(m1,s1);
            
        //Create Macroprofil Tranporteur
        Macroprofil_Transporteur__c mt1 = Utils_TestMethods.CreateMacroprofilTransporteur(m1,t1);
        
        //Create Account
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
       // account.RecordTypeId= [SELECT Id FROM RecordType WHERE DeveloperName = 'PUS_FR_PUDO_Suivi_CO'].get(0).Id;
        
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

        list<Anomalie__c> listAnomalie = new list<Anomalie__c>();
       

        //Create multiple PDA anomaly
        Anomalie__c ano2 = Utils_TestMethods.createAnomalie(account);
        ano2.Name ='Multiple Devices';
        ano2.Statut__c = '0';
        ano2.Description__c ='2//[PDA_WINDOWS/M3/////GA5GNCNJD3995639]/[PDA_WINDOWS/M3/////GA5GNCNJD3432545]';
        listAnomalie.add(ano2);
        
        //Create single PDA anomaly
         Anomalie__c ano = Utils_TestMethods.createAnomalie(account);
        ano.Name ='Single Device';
        ano.Statut__c = '0';
        ano.Description__c ='PDA_WINDOWS/M3/////GA5GNCNJD3995639';
        listAnomalie.add(ano);

        //Create unexpected description anomaly
        Anomalie__c ano3 = Utils_TestMethods.createAnomalie(account);
        ano3.Name ='Unexpected desc';
        ano3.Statut__c = '0';
        ano3.Description__c ='qlkdfqkldfqdfqkqsdhfqf';
        listAnomalie.add(ano3);

        //Create empty description anomaly
        Anomalie__c ano4 = Utils_TestMethods.createAnomalie(account);
        ano4.Name ='Empty desc';
        ano4.Statut__c = '0';
        ano4.Description__c ='';
        listAnomalie.add(ano4);
        insert listAnomalie;
        Test.startTest();
  
        list<Anomalie__c> listAnomalieInserted = [Select PDA_type__c, PDA_Ids__c From Anomalie__c where id in (:ano.id)];
        
        for(Anomalie__c anomalie : listAnomalieInserted){
            
            if(anomalie.id == ano.id){
                System.assertEquals('PDA_WINDOWS',anomalie.PDA_type__c);
                System.assertEquals('GA5GNCNJD3995639',anomalie.PDA_Ids__c);

            }
            else if(anomalie.id == ano2.id){
              System.assertEquals('PDA_WINDOWS|PDA_WINDOWS',anomalie.PDA_type__c);
              System.assertEquals('GA5GNCNJD3995639|GA5GNCNJD3432545',anomalie.PDA_Ids__c);    
            }
            else if(anomalie.id == ano4.id){
              System.assertEquals(null,anomalie.PDA_type__c);
              System.assertEquals(null,anomalie.PDA_Ids__c); 
            }
             else if(anomalie.id == ano3.id){
              System.assertEquals(null,anomalie.PDA_type__c);
              System.assertEquals(null,anomalie.PDA_Ids__c); 
            }
            
        }
        
        Test.stopTest();
         
    }
    
}