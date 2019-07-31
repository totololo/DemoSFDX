@isTest
public class AP07_Conge_Indispo_Test { 
	static Id congeRTypeId = Label.CongeRT_15;
    static Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    static Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    static Id dispoRTypeId = Label.DispoRT_15;    
    
    private static Date getDateDebutFromTextField(Account account , String fieldName) {
        Date retDate = null;
		String fieldValue = (String) account.get(fieldName);
        if(fieldValue != null && fieldValue.length() > 0) {
            String strDate = fieldValue.substring(0,fieldValue.indexOf('|'));  
            retDate =  Date.valueOf(strDate);
        }        
        return retDate;
    }
    
    static testmethod void testUpdateCongeIndispo() {
        
        List<Conge_Indispo__c> listCongeIndispoToBeAdded = new List<Conge_Indispo__c>(); 
        List<Conge_Indispo__c> listAccountToBeModified = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listAccountToBeDeleted = new List<Conge_Indispo__c>();
        List<Account> listAccountToBeAdded = new List<Account>();
        
        List<Conge_Indispo__c> listDispo = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listIndispo = new List<Conge_Indispo__c>();
        
        
        // create marcroprofil and contact
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('M1');
        insert macroprofil;
        Contact contact = Utils_TestMethods.CreateContact('Contact1');
        insert contact;
        
        
        // create accounts
        Account account1 = Utils_TestMethods.CreateAccount(contact, macroprofil,'Account 1');
        Account account2 = Utils_TestMethods.CreateAccount(contact, macroprofil, 'account 2');
        Account account3 = Utils_TestMethods.CreateAccount(contact, macroprofil, 'account 3');
        listAccountToBeAdded.add(account1);
        listAccountToBeAdded.add(account2);
        listAccountToBeAdded.add(account3);
        insert listAccountToBeAdded;
        
         // create account with 2 conges : en cours et a venir
        Conge_Indispo__c conge1 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, account1.Id , Date.today().addDays(11), Date.today().addDays(16));
        Conge_Indispo__c conge2 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, account1.Id , Date.today().addDays(5),Date.today().addDays(10));
        listCongeIndispoToBeAdded.add(conge1);
        listCongeIndispoToBeAdded.add(conge2);
        
        // start test
        Test.startTest();
        
        
        //insert the conge list and check the account conge en cours field
        insert listCongeIndispoToBeAdded;
        Account insertedAccount = [SELECT Id, Tech_date_debut_conge_en_cours__c
                                   FROM Account
                                   WHERE Id =: account1.Id
                                  ];
         
       // System.assertEquals(insertedAccount.Tech_date_debut_conge_en_cours__c, Date.today());
         
        // modify the conge en cours sur account1 (conge2)
        conge2.Date_de_debut__c = Date.today().addDays(3);
        conge2.Date_de_fin__c   = Date.today().addDays(3);  
        listAccountToBeModified.add(conge2);
        update listAccountToBeModified;
        Account modifiedAccount = [SELECT Id, Tech_date_debut_conge_en_cours__c ,Tech_date_fin_conge_en_cours__c
                                   FROM Account
                                   WHERE Id =: account1.Id
                                  ];
         
        //System.assertEquals( modifiedAccount.Tech_date_debut_conge_en_cours__c  , null );
        //System.assertEquals( modifiedAccount.Tech_date_fin_conge_en_cours__c  , null );
        
        // delete the conges conge1 et conge2 on account1
        listAccountToBeDeleted.add(conge1);
        
        delete listAccountToBeDeleted;
        
        Integer congeCount = [SELECT COUNT() 
                              FROM Conge_Indispo__c
                              WHERE Nom_du_compte__c = : account1.Id
                             ];
        //System.assertEquals(congeCount , 1);
        delete conge2;
          
        //create Account with dispo  
        Conge_Indispo__c disp1 = Utils_TestMethods.CreateConge_Indispo(dispoRTypeId, account2.Id, Date.today().addDays(3), Date.today().addDays(3));
        Conge_Indispo__c disp2 = Utils_TestMethods.CreateConge_Indispo(dispoRTypeId, account2.Id, Date.today().addDays(5), Date.today().addDays(10));
        listDispo.add(disp2);
        listDispo.add(disp1);
        
        insert listDispo;
        delete disp1;
        
        modifiedAccount = [SELECT Id, Tech_date_debut_disp_a_venir__c
                                   FROM Account
                                   WHERE Id =: account2.Id
                          ]; 
        //System.assertEquals(modifiedAccount.Tech_date_debut_disp_a_venir__c,Date.today().addDays(5));
        
        delete disp2;
        modifiedAccount = [SELECT Id, Tech_date_debut_disp_a_venir__c , Tech_date_fin_disp_a_venir__c
                           FROM Account
                           WHERE Id =: account2.Id
                          ]; 
        //System.assertEquals(modifiedAccount.Tech_date_debut_disp_a_venir__c,null);
       // System.assertEquals(modifiedAccount.Tech_date_fin_disp_a_venir__c,null);
        
        // account with indip en cours
        Conge_Indispo__c indispo1 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, account3.Id, Date.today(), Date.today().addDays(5));
        listIndispo.add(indispo1); 
        insert listIndispo;
        modifiedAccount = [SELECT Id, Tech_date_debut_indisp_en_cours__c
                           FROM Account
                           WHERE Id =: account3.Id
                          ]; 
       // System.assertEquals(modifiedAccount.Tech_date_debut_indisp_en_cours__c,Date.today());
        
        Test.stopTest();
        
    }	
}