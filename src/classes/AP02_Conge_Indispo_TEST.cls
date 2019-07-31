@isTest
public class AP02_Conge_Indispo_TEST {
    
    static final Id congeRTypeId = Label.CongeRT_15;
    static final Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    static final Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    static final Id dispoRTypeId = Label.DispoRT_15;
    
    // Cas de modification de congés avec dates qui ne se chevauchent pas
    static testMethod void chevauchementDatesCorrectUpdate(){
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();    
        List<Conge_Indispo__c> listeCongesToUpdate = new List<Conge_Indispo__c>();    
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c conge1 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, a.Id, Date.today().addDays(15), Date.today().addDays(20));      
        listeCongesToInsert.add(conge1);
        Conge_Indispo__c indispo1 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today().addDays(30), Date.today().addDays(35));    
        listeCongesToInsert.add(indispo1);
        Conge_Indispo__c conge2 = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, a.Id, Date.today().addDays(60), Date.today().addDays(90));          
        listeCongesToInsert.add(conge2);
        
        insert listeCongesToInsert;      
        
        conge2.Date_de_debut__c = conge2.Date_de_debut__c.addDays(2);
        listeCongesToUpdate.add(conge2);
        
        indispo1.Date_de_debut__c =  indispo1.Date_de_debut__c.addDays(2);
        listeCongesToUpdate.add(indispo1);
        test.starttest();
        update listeCongesToUpdate;
        
        Conge_Indispo__c conge2bis = [Select Id, Name, Date_de_debut__c, Date_de_fin__c, RecordTypeId  from Conge_Indispo__c where Id=:conge2.Id];  
        system.debug('conge 2 ' + conge2bis);
        
        //System.assertEquals(Date.today().addDays(62), conge2bis.Date_de_debut__c, 'La date du congé n\'a pas été correctement modifiée ');
        
        // Cas du chevauchement incorrecte entre deux congés après modification
        
        try{   
            conge2bis.Date_de_debut__c =  Date.today().addDays(17);
            conge2bis.Date_de_fin__c = Date.today().addDays(25);
            update conge2bis;
            
        }catch(Exception e){ 
            //System.debug('Entrée dans le catch <chevauchementDatesIncorrecteUpdateConges> class test');
            
            boolean expectedExceptionThrown =  e.getMessage().contains(Label.conge_dates_existantes) ? true : false;  
            //System.AssertEquals(true, expectedExceptionThrown);
        } 
        test.stoptest();

    }
    
    
    // Cas du chevauchement entre deux indisponibilités après modification
    static testMethod void chevauchementDatesIncorrecteIndispo(){
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        Boolean expectedExceptionThrown = false;
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today().addDays(15), Date.today().addDays(20));     
        listeCongesToInsert.add(indispo1);
        Conge_Indispo__c indispo2 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today().addDays(25), Date.today().addDays(30));     
        listeCongesToInsert.add(indispo2); 
        
        insert listeCongesToInsert;
        
        try{
           indispo2.Date_de_debut__c= Date.today().addDays(19);
           update indispo2;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <chevauchementDatesIncorrecteIndispo> class test');
            
            expectedExceptionThrown =  e.getMessage().contains(Label.indispo_dates_existantes) ? true : false;  
            
        } 
       // System.AssertEquals(true, expectedExceptionThrown);      
        
    }
    
    // Cas du chevauchement entre un nouveau congé et une dispo existante avec dans ce cas suppression de la dispo après modification
    static testMethod void chevauchementIncorrectDispoSupp(){
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();    
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c dispo1 =  Utils_TestMethods.CreateConge_Indispo(dispoRTypeId, a.Id, Date.today().addDays(15), Date.today().addDays(20));
        insert dispo1;
        
        Conge_Indispo__c conge1 =  Utils_TestMethods.CreateConge_Indispo(congeRTypeId, a.Id, Date.today().addDays(22), Date.today().addDays(26));    
        insert conge1;
        
        conge1.Date_de_debut__c = Date.today().addDays(19);
        update conge1;
        
        Account a1 = [Select Id, Name, (Select Id from Conges__r) from Account where Id=:a.Id];  
        system.debug('compte a1 ' + a1 + ' conges__r du compte ' + a1.conges__r);
        
        //System.assertEquals(1, a1.conges__r.size(), 'La disponibilité existante au mêmes dates que le congé nouvellement modifié n\'a pas été supprimée !');
        
    }
    
    // Cas du chevauchement des dates après modification de la date de fin d'une indisponibilité existante à nulle 
    static testMethod void chevauchementIncorrectIndispoDateDeFin(){
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();    
        Boolean expectedExceptionThrown = false;
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today().addDays(15), Date.today().addDays(20));     
        insert indispo1;
        
        Conge_Indispo__c indispo2 = Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today().addDays(25), Date.today().addDays(25));     
        insert indispo2; 
        
        
        try{
          indispo1.Date_de_fin__c = null;
          update indispo1;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <chevauchementIncorrectIndispoDateDeFin> class test');
            
            expectedExceptionThrown =  e.getMessage().contains(Label.indispo_sans_dateDeFin) ? true : false;  
            
        } 
       // System.AssertEquals(true, expectedExceptionThrown);      
        
    }
    
      // Cas d'une modification d'une indisponibilité qui est en cours, enclenche un message d'erreur
    static testMethod void indispoDateEnCours(){
        
        List<Conge_Indispo__c> listeIndispoToUpdate = new List<Conge_Indispo__c>();    
        Boolean expectedExceptionThrown = false;
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
       Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today(), Date.today().addDays(20));   
        insert indispo1;
        
        try{
          indispo1.Commentaires__c='Test';
          update indispo1;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <indispoDateEnCours> class test');
            
            expectedExceptionThrown =  e.getMessage().contains(Label.indispo_update_dateEnCours) ? true : false;  
            
        } 
        //stem.AssertEquals(true, expectedExceptionThrown);      
        
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