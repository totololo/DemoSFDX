/**
*@Class: AP11_Account
*@Author: TMAEIL AHA
*@Date: 1/12/2017
*@Coverage: 77%
*@Description: Classe de test de la classe AP11_Account
*/

@isTest
public class AP11_Account_Test {
    
    static testMethod void testMAJ (){
        
        List<Account> listAccs = new List<Account>();
        
        // Object Account contains a lot of validation rules 
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
        currentUser.BypassValidationRule__c = true;
        update currentUser;
        
        
        //Create Macroprofil
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('MP2-Standard');        
        Macroprofil__c macroprofil2 = Utils_TestMethods.CreateMacroprofil('MPFR_Consigne');
        insert new list<Macroprofil__c> {macroprofil,macroprofil2};
                        
        //create account record
        Account acc1 = Utils_TestMethods.CreateAccount(null, macroprofil, 'acc1');
        acc1.Macroprofil_de_reference__c = macroprofil.Id;
        insert acc1;
        
        acc1.Date_de_fin_d_activite__c = system.today().addDays(18);
        acc1.Contexte__c = 'Exclusion' ;
        acc1.Etat__c = Label.Account_Etat_6;
        acc1.Mode__c = Label.Account_Mode_ResiliationSuggere;
        update acc1;
        
        acc1.Contexte__c = 'Résiliation';
        update acc1;
        
        acc1.Date_de_fin_d_activite__c = System.today().addDays(60);
        update acc1;
        
        acc1.Date_de_fin_d_activite__c = System.today().addDays(50);
        update acc1;
        
        acc1.Contexte__c = 'Exclusion';
        update acc1;
        
        acc1.Date_de_fin_d_activite__c = System.today();
        update acc1;
        
        acc1.Contexte__c = 'Résiliation';
        update acc1;
        listAccs.add(acc1);
        
        Account acc3 = Utils_TestMethods.CreateAccount(null, macroprofil, 'acc3');
        acc3.Macroprofil_de_reference__c = macroprofil.Id;
        acc3.Date_de_fin_d_activite__c = system.today().addDays(26);
        acc3.Contexte__c = 'Exclusion' ;
        listAccs.add(acc3);
        
        Account acc4 = Utils_TestMethods.CreateAccount(null, macroprofil, 'acc4');
        acc4.Macroprofil_de_reference__c = macroprofil.Id;
        acc4.Date_de_fin_d_activite__c = system.today();
        acc4.Contexte__c = 'Exclusion' ;
        listAccs.add(acc4);
        
        Account acc2 = Utils_TestMethods.CreateAccount(null, macroprofil2, 'acc2');
        acc2.Macroprofil_de_reference__c = macroprofil2.Id;
        acc2.RecordTypeId = '012580000005YcI';
        acc2.Date_de_fin_d_activite__c = system.today().addDays(25);
        acc2.Contexte__c = 'Résiliation' ;
        listAccs.add(acc2);
        
        Account acc5 = Utils_TestMethods.CreateAccount(null, macroprofil2, 'acc5');
        acc5.Macroprofil_de_reference__c = macroprofil2.Id;
        acc5.RecordTypeId = '012580000005YcI';
        acc5.Date_de_fin_d_activite__c = system.today().addDays(26);
        acc5.Contexte__c = 'Exclusion' ;
        listAccs.add(acc5);
        
        Account acc6 = Utils_TestMethods.CreateAccount(null, macroprofil2, 'acc6');
        acc6.Macroprofil_de_reference__c = macroprofil2.Id;
        acc6.RecordTypeId = '012580000005YcI';
        acc6.Date_de_fin_d_activite__c = system.today();
        acc6.Contexte__c = 'Résiliation' ;
        listAccs.add(acc6);
        
        Account acc7 = Utils_TestMethods.CreateAccount(null, macroprofil, 'acc7');
        acc7.Macroprofil_de_reference__c = macroprofil.Id;
        acc7.Date_de_fin_d_activite__c = null;
        acc7.Contexte__c = 'Résiliation' ;
        acc7.Etat__c='7';
        listAccs.add(acc7);
        
        AP11_Account.changerEtatModeSelonDFA(listAccs);
    } 
}