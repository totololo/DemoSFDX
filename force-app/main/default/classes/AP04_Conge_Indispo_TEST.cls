@isTest
public class AP04_Conge_Indispo_TEST {

    static final Id congeRTypeId = Label.CongeRT_15;
    static final Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    static final Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    static final Id dispoRTypeId = Label.DispoRT_15;
    
    
     // Cas d'une création d'une injoignabilité sans date de début renseignée après modification de l'indisponibilité correspondante
    static testMethod void insertInjoignabiliteSansDateDeDebut(){
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today(), Date.today().addDays(10));     
        insert indispo1;

        indispo1.Injoignable__c = true;
        update indispo1;

        Historique_Injoignabilites__c hi = [Select Id, Name, Date_de_debut1__c, Indisponibilite__c from Historique_Injoignabilites__c where Indisponibilite__c=: indispo1.Id LIMIT 1];
        }
      // Cas d'une création d'une injoignabilité avec date de début renseignée après modification de l'indisponibilité correspondante
    static testMethod void insertInjoignabiliteAvecDateDeDebutEtFin(){
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoConsigneRTypeId, a.Id, Date.today(), Date.today().addDays(10));     
        insert indispo1;

        indispo1.Injoignable__c = true;
        indispo1.Injoignable_depuis_le__c = Date.today().addDays(-2);
        update indispo1;
        
        indispo1.Injoignable__c = false;
        update indispo1;

        Historique_Injoignabilites__c hi = [Select Id, Name, Date_de_debut1__c, Date_de_fin1__c, Indisponibilite__c from Historique_Injoignabilites__c where Indisponibilite__c=: indispo1.Id LIMIT 1];
        }
    
     // Cas de l'update de la date de début de l'injoignabilité
        static testMethod void injoignabiliteUpdateDateDeDebut(){
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today(), Date.today().addDays(10));     
        insert indispo1;

        indispo1.Injoignable__c = true; 
        update indispo1;
		
        indispo1.Injoignable_depuis_le__c = Date.today().addDays(-2);
        update indispo1;
          
        Historique_Injoignabilites__c hi = [Select Id, Name, Date_de_debut1__c, Indisponibilite__c from Historique_Injoignabilites__c where Indisponibilite__c=: indispo1.Id LIMIT 1];
        }
    
  
    @testSetup
    static void allTheDataForThisTestClass() {
        
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('mp1');
        insert mp;  
        Contact c = Utils_TestMethods.CreateContact('TestContact');
        Account a = Utils_TestMethods.CreateAccount(c, mp, 'TestPudoNoCo');    
        insert a;    
    }
    
}