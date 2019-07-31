@isTest
public class AP08_Conge_Indispo_Test {
    
    static testmethod void insertUpdateConge_Indispo() {
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('M1');
        insert macroprofil;
        Contact contact = Utils_TestMethods.CreateContact('Contact1');
        insert contact;
        
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel,  
                                                                         ID_suivi_CO__c,ID_PUDO_Non_Suivi__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        List<Account> accountList = new List<Account>();
        Account account1 = Utils_TestMethods.CreateAccount(contact, macroprofil, 'Account 1');      
        account1.RecordTypeId = associationRTPays[0].ID_PUDO_Non_Suivi__c;
        account1.Type = '20';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.BillingPostalCode ='1234';
        account1.ShippingPostalCode = '1243';
        account1.Industry = '1';
        account1.Long_Lat_adresse_de_livraison__Latitude__s=62;
        account1.Long_Lat_adresse_de_livraison__Longitude__s=21;
        account1.Amplitude_horaire_du_relais__c = 90.22;
        account1.Lundi_Ouverture__c = '08:00';
        account1.Lundi_Fermeture__c  = '20:00'; 
        account1.Mardi_Ouverture__c = '08:00';
        account1.Mardi_Fermeture__c  = '20:00'; 
        account1.Mercredi_Ouverture__c = '08:00';
        account1.Mercredi_Fermeture__c  = '20:00';
        account1.Jeudi_ferme__c = false;
        account1.Jeudi_Ouverture__c = '08:00';
        account1.Jeudi_Fermeture__c  = '20:00';
        account1.Vendredi_ferme__c = false;
        account1.Vendredi_Ouverture__c = '08:00';
        account1.Vendredi_Fermeture__c  = '20:00';
        account1.Samedi_ferme__c = false;
        account1.Samedi_Ouverture__c = '08:00';
        account1.Samedi_Fermeture__c  = '20:00';
        account1.lundi_debut_pause_dejeuner__c='12:00';
        account1.lundi_fin_pause_dejeuner__c ='12:30';
        account1.mardi_debut_pause_dejeuner__c='12:00';
        account1.mardi_fin_pause_dejeuner__c ='12:30';
        account1.mercredi_debut_pause_dejeuner__c='12:00';
        account1.mercredi_fin_pause_dejeuner__c ='12:30';        
        account1.jeudi_debut_pause_dejeuner__c='12:00';
        account1.jeudi_fin_pause_dejeuner__c ='12:30';
        account1.vendredi_debut_pause_dejeuner__c='12:00';
        account1.vendredi_fin_pause_dejeuner__c ='12:30';
        account1.samedi_debut_pause_dejeuner__c='12:00';
        account1.samedi_fin_pause_dejeuner__c ='12:30';     
        accountList.add(account1);
        
        Account account2 = Utils_TestMethods.CreateAccount(contact, macroprofil, 'Account 2');
        account2.RecordTypeId = associationRTPays[0].ID_PUDO_Non_Suivi__c;
        account2.Type = '20';
        account2.BillingCountry ='Belgium';
        account2.ShippingCountry ='Belgium';
        account2.BillingCountryCode = 'BE';
        account2.ShippingCountryCode ='BE';
        account2.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account2.Operateur_Global__c = 'DPD_BNL';
        account2.BillingPostalCode ='1234';
        account2.ShippingPostalCode = '1243';
        account2.Industry = '1';
        account2.Long_Lat_adresse_de_livraison__Latitude__s=62;
        account2.Long_Lat_adresse_de_livraison__Longitude__s=21;
        account2.Amplitude_horaire_du_relais__c = 90.22;
        account2.Lundi_Ouverture__c = '08:00';
        account2.Lundi_Fermeture__c  = '20:00'; 
        account2.Mardi_Ouverture__c = '08:00';
        account2.Mardi_Fermeture__c  = '20:00'; 
        account2.Mercredi_Ouverture__c = '08:00';
        account2.Mercredi_Fermeture__c  = '20:00';
        account2.Jeudi_ferme__c = false;
        account2.Jeudi_Ouverture__c = '08:00';
        account2.Jeudi_Fermeture__c  = '20:00';
        account2.Vendredi_ferme__c = false;
        account2.Vendredi_Ouverture__c = '08:00';
        account2.Vendredi_Fermeture__c  = '20:00';
        account2.Samedi_ferme__c = false;
        account2.Samedi_Ouverture__c = '08:00';
        account2.Samedi_Fermeture__c  = '20:00';
        account2.lundi_debut_pause_dejeuner__c='12:00';
        account2.lundi_fin_pause_dejeuner__c ='12:30';
        account2.mardi_debut_pause_dejeuner__c='12:00';
        account2.mardi_fin_pause_dejeuner__c ='12:30';
        account2.mercredi_debut_pause_dejeuner__c='12:00';
        account2.mercredi_fin_pause_dejeuner__c ='12:30';        
        account2.jeudi_debut_pause_dejeuner__c='12:00';
        account2.jeudi_fin_pause_dejeuner__c ='12:30';
        account2.vendredi_debut_pause_dejeuner__c='12:00';
        account2.vendredi_fin_pause_dejeuner__c ='12:30';
        account2.samedi_debut_pause_dejeuner__c='12:00';
        account2.samedi_fin_pause_dejeuner__c ='12:30';       
        accountList.add(account2);
        insert accountList;
        
        
        List<Case> CaseList = new List<Case>();
        Case CaseAccount1 = new Case();
        CaseAccount1.Status = Label.ReQuette_En_attente_de_traitement;
        CaseAccount1.RecordTypeId = Label.RT_DPD_BNL_Conges_Requette;
        CaseAccount1.AccountId  =  account1.id; 
        CaseList.add(CaseAccount1);
        
        Case CaseAccount2 = new Case();
        CaseAccount2.Status = Label.ReQuette_En_attente_de_traitement;
        CaseAccount2.RecordTypeId = Label.RT_DPD_BNL_Conges_Requette;
        CaseAccount2.AccountId  =  account2.id; 
        CaseList.add(CaseAccount2);
        insert CaseList; 
        
        Integer thisYear = Date.today().year();
        Integer thisDay = Date.today().day();
        Integer thisMonth = Date.today().month();
        
        List<Conge_Indispo__c> cong_indispoList = new List<Conge_Indispo__c>();
        Conge_Indispo__c cong = Utils_TestMethods.CreateConge_Indispo(Label.RT_Conge_Indispo_Conge, 
                                                                      account1.id, 
                                                                      Date.newInstance(thisYear, thisMonth,thisDay ), 
                                                                      Date.newInstance(thisYear, thisMonth,thisDay ));
        cong_indispoList.add(cong);
        Conge_Indispo__c cong1 = Utils_TestMethods.CreateConge_Indispo(Label.RT_Conge_Indispo_Conge, 
                                                                       account2.id, 
                                                                       Date.newInstance(thisYear, thisMonth+1,thisDay ), 
                                                                       Date.newInstance(thisYear, thisMonth+1,thisDay ));
        
        cong_indispoList.add(cong1);
        insert cong_indispoList;
        
        cong1.Date_de_debut__c =Date.newInstance(thisYear, thisMonth,thisDay );
        cong1.Date_de_fin__c = Date.newInstance(thisYear, thisMonth,thisDay );
        update cong1;                
        
    }
}