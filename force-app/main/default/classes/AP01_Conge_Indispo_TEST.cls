@isTest
public class AP01_Conge_Indispo_TEST {
    
    static final Id congeRTypeId = Label.CongeRT_15;
    static final Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
    //static final Id indispoConsigneRTypeId = Label.IndispoConsigneRT_15;
    static final Id dispoRTypeId = Label.DispoRT_15;
    static Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPays;
    
    static List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel, ID_Conge__c, ID_Indisponibilite_standard__c,
                                                                            ID_Disponibilite__c
                                                                            FROM Association_Record_Type_et_pays__mdt];
    static testMethod void fillCustomMetadata()
    {
        mapassociationRTPays =  new Map<String,Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPays)
        {
            mapassociationRTPays.put(mdtRecord.MasterLabel, mdtRecord);
        }
    }
    static testMethod void chevauchementDatesCorrect(){
		fillCustomMetadata();
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
		currentUser.BypassValidationRule__c = true;
        currentUser.BypassWorkflow__c =true;
        update currentUser;
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();    
        
        Account a = [Select Id, Name, ShippingCountry from Account where Name='TestPudoNoCo' LIMIT 1];
        Conge_Indispo__c conge1 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Conge__c, a.Id, Date.today().addDays(10), Date.today().addDays(15));      
        listeCongesToInsert.add(conge1);
        Conge_Indispo__c dispo1 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Disponibilite__c, a.Id,Date.today().addDays(20), Date.today().addDays(25));    
        listeCongesToInsert.add(dispo1);
        Conge_Indispo__c indispo1 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Indisponibilite_standard__c, a.Id, Date.today().addDays(30), Date.today().addDays(32));    
        listeCongesToInsert.add(indispo1);
        Conge_Indispo__c conge2 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Conge__c, a.Id, Date.today().addDays(60), Date.today().addDays(63));          
        listeCongesToInsert.add(conge2);
        
        insert listeCongesToInsert;      
        
        Account a1 = [Select Id, Name, ShippingCountry, (Select Id from Conges__r) from Account where Id=:a.Id];  
        system.debug('compte a1 ' + a1 + ' conges__r du compte ' + a1.conges__r);
        
        //System.assertEquals(4, a1.conges__r.size(), 'Les 4 congés n\'ont pas été correctement insérés au compte');
        Test.startTest();
        // Cas du chevauchement entre deux congés 
        Conge_Indispo__c conge3 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Conge__c, a.Id, Date.today().addDays(5), Date.today().addDays(12));        
        
        try{   
            insert conge3;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <chevauchementDatesIncorrecteConges> class test');
          
            boolean expectedExceptionThrown =  e.getMessage().contains(Label.conge_dates_existantes) ? true : false;  
            System.AssertEquals(true, expectedExceptionThrown);
        } 
           
        a1 = [Select Id, Name, ShippingCountry, (Select Id from Conges__r) from Account where Id=:a.Id];  
        system.debug('compte a1 ' + a1 + ' conges__r du compte ' + a1.conges__r);
        Test.stopTest();
    }
    
     // Cas du chevauchement entre deux disponibilités 
    static testMethod void chevauchementDatesIncorrecteDispo(){
		fillCustomMetadata();
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
		currentUser.BypassValidationRule__c = true;
        update currentUser;
        
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        Boolean expectedExceptionThrown = false;
        
        Account a = [Select Id, Name, ShippingCountry from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c dispo1 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Disponibilite__c, a.Id, Date.today().addDays(17), Date.today().addDays(20));    
        listeCongesToInsert.add(dispo1);
        Conge_Indispo__c dispo2 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Disponibilite__c, a.Id, Date.today().addDays(3), Date.today().addDays(25));       
        listeCongesToInsert.add(dispo2); 
        
        try{
            insert listeCongesToInsert;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <chevauchementDatesIncorrecteDispo> class test');
            
            expectedExceptionThrown =  e.getMessage().contains(Label.dispo_dates_existantes) ? true : false;  
            
        } 
        //System.AssertEquals(true, expectedExceptionThrown);      
    }
    
      // Cas du chevauchement entre deux indisponibilités
    static testMethod void chevauchementDatesIncorrecteIndispo(){
		fillCustomMetadata();
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
		currentUser.BypassValidationRule__c = true;
        update currentUser;
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();  
        Boolean expectedExceptionThrown = false;
        
        Account a = [Select Id, Name, ShippingCountry from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Indisponibilite_standard__c, a.Id, Date.today().addDays(15), Date.today().addDays(18));     
        listeCongesToInsert.add(indispo1);
        Conge_Indispo__c indispo2 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Indisponibilite_standard__c, a.Id, Date.today().addDays(10), Date.today().addDays(20));     
        listeCongesToInsert.add(indispo2); 
        
        try{
            insert listeCongesToInsert;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <chevauchementDatesIncorrecteIndispo> class test');
            
            expectedExceptionThrown =  e.getMessage().contains(Label.indispo_dates_existantes) ? true : false;  
            
        } 
        //System.AssertEquals(true, expectedExceptionThrown);      
        
    }
    
      // Cas du chevauchement entre un nouveau congé et une dispo existante avec dans ce cas suppression de la dispo
    static testMethod void chevauchementIncorrectDispoSupp(){
		fillCustomMetadata();
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
		currentUser.BypassValidationRule__c = true;
        update currentUser;
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();    
        
        Account a = [Select Id, Name, ShippingCountry from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c dispo1 =  Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Disponibilite__c, a.Id, Date.Today().addDays(1), Date.Today().addDays(7));
        insert dispo1;
        
        Conge_Indispo__c conge1 =  Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Conge__c, a.Id, Date.Today(), Date.today().addDays(2));    
        insert conge1;
        
        Account a1 = [Select Id, Name, ShippingCountry, (Select Id from Conges__r) from Account where Id=:a.Id];  
        system.debug('compte a1 ' + a1 + ' conges__r du compte ' + a1.conges__r);
        
        //System.assertEquals(1, a1.conges__r.size(), 'La disponibilité existante au mêmes dates que le congé nouvellement inséré n\'a pas été supprimée !');
     
    }
    
    // Cas du chevauchement entre une indispo et une autre indispo dont la date de fin n'est pas indiquée
    static testMethod void chevauchementIncorrectIndispoDateDeFin(){
        
		fillCustomMetadata();
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
		currentUser.BypassValidationRule__c = true;
        update currentUser;
        
        List<Conge_Indispo__c> listeCongesToInsert = new List<Conge_Indispo__c>();    
        Boolean expectedExceptionThrown = false;
        
        Account a = [Select Id, Name, ShippingCountry from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c indispo1 =  Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Indisponibilite_standard__c, a.Id, Date.today().addDays(15),Date.today().addDays(17));     
       	insert indispo1;
        
        Conge_Indispo__c indispo2 = Utils_TestMethods.CreateConge_Indispo(mapassociationRTPays.get(a.ShippingCountry).ID_Indisponibilite_standard__c, a.Id, Date.today().addDays(5), null);     
     
        try{
         insert indispo2;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <chevauchementIncorrectIndispoDateDeFin> class test');
            
            expectedExceptionThrown =  e.getMessage().contains(Label.indispo_sans_dateDeFin) ? true : false;  
            
        } 
        //System.AssertEquals(true, expectedExceptionThrown);      
        
    }
    
    
    @testSetup
    static void allTheDataForThisTestClass() {
		fillCustomMetadata();
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('mp1');
        insert mp;  
        Contact c = Utils_TestMethods.CreateContact('TestContact');
        Account a = Utils_TestMethods.CreateAccount(c, mp, 'TestPudoNoCo');    
        insert a;    
    }
    
    
    
}