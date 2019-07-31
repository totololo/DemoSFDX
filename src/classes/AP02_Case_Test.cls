@isTest
public class AP02_Case_Test {
    static testmethod void updateCase() {
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('M1');
        insert macroprofil;
        Contact contact = Utils_TestMethods.CreateContact('Contact1');
        insert contact;
        
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_Conge__c,ID_CONGE__c
                                                                              FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
           associationRTPays.put(associationRT.MasterLabel, associationRT);  
        }
        Account account1= Utils_TestMethods.CreateAccount(contact, null, 'Test Account 1'); 
        account1.RecordTypeId =associationRTPays.get('Belgium').ID_PUDO_Non_Suivi__c;
        account1.Type = '20';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.BillingPostalCode ='1234';
        account1.ShippingPostalCode = '1243';
        account1.Amplitude_horaire_du_relais__c = 30;
        account1.Lundi_Ouverture__c = '10:30';
        account1.Lundi_Fermeture__c  = '17:45';        
        account1.lundi_debut_pause_dejeuner__c='14:30';
        account1.lundi_fin_pause_dejeuner__c ='16:30';	
        account1.Industry = '6';
        account1.Long_Lat_adresse_de_livraison__Latitude__s=62;
        account1.Long_Lat_adresse_de_livraison__Longitude__s=21;
        insert account1;
        List<Account> accountList = [SELECT Seuil_de_l_amplitude_horaire_respect__c, Heure_fermeture_minimale_respectee__c,
                                     Heure_ouverture_minimale_respect_e__c, Duree_pause_dejeuner_respectee__c,Industry
                                     FROM Account
                                     WHERE Id =:account1.id ];
        system.debug('accountList: ' + accountList);
        
        
        
        Integer thisYear = Date.today().year();
        Integer thisDay = Date.today().day();
        Integer thisMonth = Date.today().month();
        
        Conge_Indispo__c cong = Utils_TestMethods.CreateConge_Indispo(associationRTPays.get('Belgium').ID_CONGE__C, 
                                                                      account1.id, 
                                                                      Date.newInstance(thisYear, thisMonth,thisDay ), 
                                                                      Date.newInstance(thisYear, thisMonth,thisDay ));
        insert cong;
        
        Anomalie__c anomalie = new Anomalie__c();
        anomalie.PUDO__c = account1.id;
        anomalie.Numero_Anomalie__c = '1';
        anomalie.Statut__c = '1';
        insert anomalie;
        
        Case CaseAccount1 = new Case();
        CaseAccount1.Status = Label.ReQuette_En_attente_de_traitement;
        CaseAccount1.RecordTypeId = associationRTPays.get('Belgium').ID_Requete_Conge__c;
        CaseAccount1.AccountId  =  account1.id; 
        CaseAccount1.Anomalie__c = anomalie.id;
        insert CaseAccount1;
        
        caseAccount1.Status = Label.Requete_Terminee;
        update caseAccount1;
        List<Case> caseList = [select Status from Case where id =: caseAccount1.Id];
        for(Case currentCase: caseList)
        {
            System.assertEquals(currentCase.Status, Label.ReQuette_En_attente_de_traitement);
        }
    }
}