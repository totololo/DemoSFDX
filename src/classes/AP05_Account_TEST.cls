@isTest
public class AP05_Account_TEST {
    
    private static Id PUS_FR_Prospect_Converti = Label.PUS_RT_ProspectConverti;     
    private static Id PUS_FR_Point_non_Suivi_par_le_CO = Label.PUS_RT_NonSuiviParCO;
    private static Id PUS_FR_Consigne = Label.PUS_RT_Consigne;
    
    static testmethod void testAccountInternationReferenceNumber() {
        //Create Contact
        Contact c = Utils_TestMethods.CreateContact('c1');
        insert c;
        
        //Create Macroprofil
        Macroprofil__c m1 = Utils_TestMethods.CreateMacroprofil('m1');
        insert m1;
        
        //Create Custom Settings
        CountriesSequence__c cs = new CountriesSequence__c(Name='France' , Sequence__c = 'FR00001');
        insert cs;
        
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_ContratNonRespecte__c
                                                                              FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
           associationRTPays.put(associationRT.MasterLabel, associationRT);  
        }
        
        //Create List of Accounts
        // 2  Non Suivi par le CO and 1 Consigne
        List<Account>listAccountsToBeInserted = new List<Account>();
        Account account1 = Utils_TestMethods.CreateAccount(c,m1, 'a1');
        account1.Etat__c = '2';
        account1.RecordTypeId = associationRTPays.get('France').ID_PUDO_Non_Suivi__c;
 		
        Account account2 = Utils_TestMethods.CreateAccount(c,m1, 'a2');
        account2.Etat__c = '2';
        account2.RecordTypeId = associationRTPays.get('France').ID_PUDO_Non_Suivi__c;
        
        Account account3 = Utils_TestMethods.CreateAccount(c,m1, 'a3');
        account3.Etat__c = '2';
        account3.RecordTypeId = PUS_FR_Consigne;
        
        listAccountsToBeInserted.add(account1);
        listAccountsToBeInserted.add(account2);
        listAccountsToBeInserted.add(account3);
        
        //Create an account and modify it to TR : PUS_FR_Prospect_Converti
        Account account4 = Utils_TestMethods.CreateAccount(c,m1, 'a4');
        insert account4; 
        account4.RecordTypeId = associationRTPays.get('France').ID_Prospect_Converti__c;
        
        User user = [SELECT Id 
                     FROM User
                     Where Id =: UserInfo.getUserId()
                    ];
        user.BypassValidationRule__c = true;
        update user;
        System.runAs(user) {
            Test.startTest();
            insert listAccountsToBeInserted; 
            update account4;
            CountriesSequence__c countryInstance = CountriesSequence__c.getInstance('France');
           // System.assertEquals('FR00005', countryInstance.Sequence__c);
            Test.stopTest();
        } 
    }
}