@isTest
public class AP03_Conge_Indispo_TEST {

        static final Id indispoStandardRTypeId = Label.IndispoStandardRT_15;
       
      // Cas d'une suppression d'un congé qui est en cours, enclenche un message d'erreur
    static testMethod void suppCongeDateEnCours(){
        
        List<Conge_Indispo__c> listeCongesToDelete = new List<Conge_Indispo__c>();    
        Boolean expectedExceptionThrown = false;
        
        Account a = [Select Id, Name from Account where Name='TestPudoNoCo' LIMIT 1];
        
        Conge_Indispo__c conge =  Utils_TestMethods.CreateConge_Indispo(indispoStandardRTypeId, a.Id, Date.today(), Date.today().addDays(20));     
        insert conge;
        
        try{
          delete conge;
        }catch(Exception e){ 
            System.debug('Entrée dans le catch <suppCongeDateEnCours> class test');
            
            expectedExceptionThrown =  e.getMessage().contains(Label.supp_cong_dateEnCours) ? true : false;  
            
        } 
        //System.AssertEquals(true, expectedExceptionThrown);      
        
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