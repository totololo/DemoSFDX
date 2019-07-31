/**
*@Class: Batch_Account_DFA, Batch_Account_Reprise
*@Author: TMAEIL AHA
*@Date: 1/12/2017
*@Coverage: 100%
*@Description: Classe de test des batch Batch_Account_DFA et Batch_Account_Reprise
*/

@isTest
public class Batch_Account_Reprise_Test {
    
    testmethod static void testBatch() {
        
        
        User currentUser = [Select Id , BypassValidationRule__c,BypassApex__c
                            from User 
                            where Id=: UserInfo.getUserId()];
        currentUser.BypassValidationRule__c = true;
        currentUser.BypassApex__c = ('AP05_Account');
        update currentUser;
        
        system.runas(currentUser){
            
            Contact c = Utils_TestMethods.CreateContact('test');
            insert c;
            
            Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('MP');        
            Macroprofil__c macroprofil2 = Utils_TestMethods.CreateMacroprofil('MP2-Standard2');
           insert macroprofil;
            insert macroprofil2;
            
            Account acct = Utils_TestMethods.CreateAccount(c, macroprofil,'Account Test'); 
            acct.BillingStreet = 'Test';
            acct.BillingPostalCode = '25142';
            acct.BillingCountry = 'France';
            acct.BillingCountryCode = 'FR';
            acct.BillingCity = 'Paris';
            acct.ShippingPostalCode = '25142';
            acct.ShippingCountry = 'France';
            acct.ShippingCountryCode = 'FR';
            acct.ShippingCity = 'Paris';
            acct.ShippingStreet = 'Test';
            acct.Lundi_Ouverture__c = '01:00';
            acct.Lundi_Fermeture__c = '20:00';
            acct.lundi_debut_pause_dejeuner__c = '02:00';
            acct.lundi_fin_pause_dejeuner__c = '19:00';
            //acct.Mardi_ferme__c = true;
            acct.Mercredi_ferme__c = false;
            acct.Jeudi_ferme__c = false;
            acct.Vendredi_ferme__c = false;
            acct.Samedi_ferme__c = false;
            acct.Dimanche_ferme__c = false;
            acct.Horaire_Ouverture_Reference__c = '01:00';
            acct.Horaire_Fermeture_Reference__c = '20:00';
            acct.Type = 'Pickup store';
            acct.RecordTypeId = label.RT_Compte_Pickup_Contact;
            acct.Macroprofil_actuel__c = null;
            //acct.Macroprofil_de_reference__c = macroprofil2.id;
            acct.Responsable_facturation__c = c.id;
            acct.N_de_rue_facturation__c = 'test';
            acct.Date_de_fin_d_activite__c = system.today();
            acct.Contexte__c ='Exclusion';
            acct.Etat__c='2';
            acct.Mode__c=null;  
            insert acct;
            
            Test.startTest();
            Id batchJobId = Database.executeBatch(new Batch_Account_Reprise(), 200); 
            Id batchJobId2 = Database.executeBatch(new Batch_Account_Reprise(acct.id)); 
            Id batchJobId3 = Database.executeBatch(new Batch08_Account_DFA(), 200); 
            Id batchJobId4 = Database.executeBatch(new Batch08_Account_DFA(acct.id)); 
            Test.stopTest();
        }
    }    
}