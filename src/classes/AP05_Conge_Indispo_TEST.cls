@isTest
public class AP05_Conge_Indispo_TEST {
    
    static final Id congeRTypeId = Label.CongeRT_15;
    static final Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    static final Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    static final Id dispoRTypeId = Label.DispoRT_15;
    
    //Cas où suite à la création d'une indisponibilité, il y a création de l'injoignabilité correspondante sans date de début renseignée
    static testMethod void insertInjoignabiliteSansDateDeDebut(){
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today().addDays(1), Date.today().addDays(5));     
        indispo1.Injoignable__c = true;
        //TMA JSA 
        indispo1.Date_de_debut__c=system.today();
        insert indispo1;
        
        Historique_Injoignabilites__c hi = [Select Id, Name, Date_de_debut1__c, Indisponibilite__c from Historique_Injoignabilites__c where Indisponibilite__c=: indispo1.Id LIMIT 1];
        
        System.assert(hi != null); 
        //System.assert(hi.Date_de_debut1__c == indispo1.Date_de_debut__c);
        
    }
    
    // Cas où suite à la création d'une indisponibilité, il y a création de l'injoignabilité correspondante avec date de début renseignée
    static testMethod void insertInjoignabiliteAvecDateDeDebut(){
        
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today().addDays(1), Date.today().addDays(5));     
        indispo1.Injoignable__c = true;
        //TMA JSA
        indispo1.Date_de_debut__c=system.today();
        indispo1.Injoignable_depuis_le__c = Date.today().addDays(-1);
        insert indispo1;
        
        Historique_Injoignabilites__c hi = [Select Id, Name, Date_de_debut1__c, Indisponibilite__c from Historique_Injoignabilites__c where Indisponibilite__c=: indispo1.Id LIMIT 1];
        
        System.assert(hi != null); 
        //System.assert(hi.Date_de_debut1__c == indispo1.Injoignable_depuis_le__c );
        
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