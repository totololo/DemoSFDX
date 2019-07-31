@isTest
public class Batch12_AccountCase_Test {
    
    static testmethod void testBatch() {
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('M1');
        insert macroprofil;
        
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_ContratNonRespecte__c,ID_Requete_Conge__c
                                                                                  FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
          associationRTPays.put(associationRT.MasterLabel, associationRT);}
        
        //Account qui verifie les condition
        List<Account> Accounts = new List<Account>();
        Account account1 = Utils_TestMethods.CreateAccount(null, macroprofil, 'Account 1');
        account1.Etat__c = '4';
        account1.Type  = '2';
        account1.RecordTypeId = associationRTPays.get('Belgium').ID_suivi_CO__c;
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.BillingPostalCode ='1234';
        account1.ShippingPostalCode = '1243';        
        Accounts.add(account1);
        
        //Account avec conge
        Account account2= Utils_TestMethods.CreateAccount(null, null, 'Test Account');
        account2.RecordTypeId = associationRTPays.get('France').ID_PUDO_Non_Suivi__c;
        account2.ShippingCountry ='France';
        account2.ShippingCountryCode='FR';
        account2.Etat__c = '5';
        account2.Operateur_Global__c = 'PUS_FR';
        account2.ShippingPostalCode = '12345';
        account2.Type ='2';
        account2.N_TVA__c = 'Non';
        Accounts.add(account2);          
       
        //Account avec requete deja creer
        Account account4 = Utils_TestMethods.CreateAccount(null, macroprofil, 'Account 4');
        account4.Etat__c = '4';
        account4.Type  = '2';
        account4.RecordTypeId = associationRTPays.get('Belgium').ID_suivi_CO__c;
        account4.BillingCountry ='Belgium';
        account4.ShippingCountry ='Belgium';
        account4.BillingCountryCode = 'BE';
        account4.ShippingCountryCode ='BE';
        account4.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account4.Operateur_Global__c = 'DPD_BNL';
        account4.BillingPostalCode ='1234';
        account4.ShippingPostalCode = '1243';   
        Accounts.add(account4);
        insert Accounts;
        Integer thisYear = Date.today().year();
        Integer thisDay = Date.today().day();
        Integer thisMonth = Date.today().month();

        Conge_Indispo__c cong = Utils_TestMethods.CreateConge_Indispo(Label.RT_Conge_Indispo_Conge, 
                                                                      account2.id, 
                                                                      Date.newInstance(thisYear, thisMonth ,thisDay ), 
                                                                      Date.newInstance(thisYear, thisMonth ,thisDay ));
        insert cong;
        
        Case CaseAccount4 = new Case();
        CaseAccount4.Status = Label.ReQuette_En_attente_de_traitement;
        CaseAccount4.RecordTypeId = associationRTPays.get('Belgium').ID_Requete_Conge__c;
        CaseAccount4.AccountId  =  account4.id; 
        insert CaseAccount4; 
        
        Test.startTest();
        Batch12_AccountCase batchAccountRequette = new Batch12_AccountCase();
        Database.executeBatch(batchAccountRequette);
        Test.stopTest();
        
        
        /*List<Case> cases = [SELECT id, RecordTypeId
                            FROM Case 
                           where AccountId =: account1.Id and RecordTypeId =:associationRTPays.get('Belgium').ID_Requete_Conge__c
                           ];
        System.assertEquals( 1 , cases.size());
        System.assertEquals( associationRTPays.get('Belgium').ID_Requete_Conge__c , cases[0].RecordTypeId );*/
        
        List<account> listAccount = [select id,name,etat__c from account where id=:account2.Id];
        List<Case> cases1 = [SELECT id, RecordTypeId
                              FROM Case 
                             Where AccountId =: account2.Id and RecordTypeId =:associationRTPays.get('France').ID_Requete_Conge__c
                           ];      
        System.assertEquals( 1 , cases1.size() );
        /*List<Case> cases2 = [SELECT id, RecordTypeId
                              FROM Case 
                             Where AccountId =: account4.Id and RecordTypeId =:associationRTPays.get('Belgium').ID_Requete_Conge__c
                           ];   
        System.assertEquals( 1 , cases2.size() );*/
    }
}