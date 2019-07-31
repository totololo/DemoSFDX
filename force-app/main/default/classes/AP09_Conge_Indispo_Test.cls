/* Class that test the functionality of AP09_Conge_Indispo*/
@isTest
public class AP09_Conge_Indispo_Test { 
	static Id congeRTypeId = Label.CongeRT_15;
    static Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    static Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    static Id dispoRTypeId = Label.DispoRT_15;    
    
    static testmethod void testCreateCase() {
        
        List<Conge_Indispo__c> listCongeIndispoToBeAdded = new List<Conge_Indispo__c>(); 
        List<Conge_Indispo__c> listAccountToBeModified = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listAccountToBeDeleted = new List<Conge_Indispo__c>();
        List<Account> listAccountToBeAdded = new List<Account>();
        
        List<Conge_Indispo__c> listDispo = new List<Conge_Indispo__c>();
        List<Conge_Indispo__c> listIndispo = new List<Conge_Indispo__c>();
        
        
        //create marcroprofil and contact
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('M1');
        insert macroprofil;
        Contact contact1 = Utils_TestMethods.CreateContact('Contact1');
        Contact contact2 = Utils_TestMethods.CreateContact('Contact2');
        Contact contact3 = Utils_TestMethods.CreateContact('Contact3');
        Contact contact4 = Utils_TestMethods.CreateContact('Contact4');
        Contact contact5 = Utils_TestMethods.CreateContact('Contact5');
        insert new list<contact>{contact1,contact2,contact3,contact4,contact5};
        
        
        //create accounts
        Account account1 = Utils_TestMethods.CreateAccount(contact1, macroprofil, 'Account 1');
        account1.Operateur_Global__c = 'PUS_FR';
        Account account2 = Utils_TestMethods.CreateAccount(contact2, macroprofil, 'Account 2');
        account2.Operateur_Global__c = 'PUS_FR';
        Account account3 = Utils_TestMethods.CreateAccount(contact3, macroprofil, 'Account 3');
        account3.Operateur_Global__c = 'PUS_FR';
        Account account4 = Utils_TestMethods.CreateAccount(contact4, macroprofil, 'Account 4');
        account4.Operateur_Global__c = 'PUS_FR';
        Account account5 = Utils_TestMethods.CreateAccount(contact5, macroprofil, 'Account 5');
        account5.Operateur_Global__c = 'PUS_FR';
        listAccountToBeAdded.add(account1);
        listAccountToBeAdded.add(account2);
        listAccountToBeAdded.add(account3);
        listAccountToBeAdded.add(account4);
        listAccountToBeAdded.add(account5);
        insert listAccountToBeAdded;
        
        contact1.AccountId = account1.id;
        contact2.AccountId = account2.id;
        contact3.AccountId = account3.id;
        contact4.AccountId = account4.id;
        contact5.AccountId = account5.id;
        update new list<contact>{contact1,contact2,contact3,contact4,contact5};
                
        Conge_Indispo__c conge1 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, account1.Id , Date.today().addDays(11), Date.today().addDays(16));
        conge1.Type_d_indisponibilite__c = '1';
        conge1.Sous_type__c = 'Sinistre / Travaux / Santé';
        Conge_Indispo__c conge2 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, account2.Id , Date.today().addDays(5),Date.today().addDays(10));
        conge2.Type_d_indisponibilite__c = '2';
        conge2.Sous_type__c = 'Problème de synchronisation';
        Conge_Indispo__c conge3 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, account3.Id , Date.today().addDays(5),Date.today().addDays(10));
        conge3.Type_d_indisponibilite__c = '2';
        conge3.Sous_type__c = 'Panne PDA';
        Conge_Indispo__c conge4 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, account4.Id , Date.today().addDays(5),Date.today().addDays(10));
        conge4.Type_d_indisponibilite__c = '1';
        conge4.Sous_type__c = 'Qualité de service';
        conge4.Raison_d_appel__c = 'Indisponibilité qualité de service';
        Conge_Indispo__c conge5 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, account5.Id , Date.today().addDays(5),Date.today().addDays(10));
        conge5.Type_d_indisponibilite__c = '1';
        conge5.Sous_type__c = 'Injoignabilité';
        conge5.Raison_d_appel__c = 'Résiliation';
        listCongeIndispoToBeAdded.add(conge1);
        listCongeIndispoToBeAdded.add(conge2);
        listCongeIndispoToBeAdded.add(conge3);
        listCongeIndispoToBeAdded.add(conge4);
        listCongeIndispoToBeAdded.add(conge5);
        insert listCongeIndispoToBeAdded;    
    }	
}