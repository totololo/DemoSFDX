@isTest
public class AP03_ReseauAssocie_Test {
    
    static testMethod void calculateReseauSeuil_test() {
        
        // Create Contact
        Contact contact = Utils_TestMethods.CreateContact('contact');
        insert contact;
        
        // Create Macroprofil__c
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('mp');
        insert mp;
        
        // Create Reseau__c
        Reseau__c res = Utils_TestMethods.CreateReseau('res');
        insert res;
        
        // Assign the Reseau__c to the Macroprofil__c(reseau par défaut : Macroprofil_Reseau__c)
        Macroprofil_Reseau__c mpr = Utils_TestMethods.CreateMacroprofilReseau(mp.Id, res.Id);
        mpr.Active__c = true;
        mpr.Modifiable__c = true;
        insert mpr;
        
        // Create Account
        // Account.Macroprofil_de_reference = mp --> res associé avec acct
        Account acct = Utils_TestMethods.CreateAccount(contact, mp, 'account');
        acct.Macroprofil_de_reference__c = mp.Id;
        acct.Macroprofil_actuel__c = mp.Id;
        Test.startTest();
        insert acct;
        
        
        // The inserted reseau should be associated only to one account : acct
        List<Reseau_Associe__c> lstRA = [SELECT Id
                                         FROM Reseau_Associe__c
                                         where Reseau__c =: res.Id
                                       ];
        //System.assertEquals(1,lstRa.size());
        
        
        // Check the number of accounts associated to the reseau inserted
        Reseau__c insertedReseau = [SELECT id , NombredePUDOAssocies__c
                                    FROM Reseau__c 
                                    Where Id =: res.Id
                                   ];  
        //System.assertEquals(1,insertedReseau.NombredePUDOAssocies__c);
        
        
        // Remove the reseau associe
        // The number of accounts associated to the reseau should become 0 
        
        lstRA = [SELECT Id
                 FROM Reseau_Associe__c
                 where Reseau__c =: res.Id
                 and Active__c = true
                ];
        if(lstRA.size() > 0) {
            Reseau_Associe__c ra = lstRA.get(0);
            ra.Active__c = false;
            ra.Modifiable__c = true;
            update ra; 
        }
        
        //System.assertEquals(0,lstRa.size());
       
        
        
        Test.stopTest();
    }
}