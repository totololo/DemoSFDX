@isTest
public class AP11_AssociationPUDOMacroprofil_TEST {
    static testMethod void myTest() {
        
        //Create Contact
        Contact contactTest = Utils_TestMethods.CreateContact('c1');
        insert contactTest;
        //Create Custom Settings country sequence
        CountriesSequence__c cs = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE0001');
        insert cs;
        //Create Contact
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        insert testContact;       
        
        Macroprofil__c testMacroprofil = Utils_TestMethods.CreateMacroprofil('test');
        insert testMacroprofil;
        Macroprofil__c testMacroprofil2 = Utils_TestMethods.CreateMacroprofil('test2');
        insert testMacroprofil2;
        Macroprofil__c testMacroprofil3 = Utils_TestMethods.CreateMacroprofil('test3');
        insert testMacroprofil3;
        
        String json1 = 
            '   [{'+
            '       \"Id_du_Macroprofil__c\": "'+testMacroprofil.id+'",'+
            '       \"MasterLabel\": \"MPBE1-Standard\",'+
            '       \"Pays__c\": \"Belgium\",'+
            '       \"Type_de_point__c\": \"20\"'+
            '   },{'+
            '       \"Id_du_Macroprofil__c\": "'+testMacroprofil2.id+'",'+
            '       \"MasterLabel\": \"MPBE1-Standard\",'+
            '       \"Type_de_point__c\": \"3\",'+
            '       \"Partenaire__c\": \"124\"'+
            '   },{'+
            '       \"Id_du_Macroprofil__c\": "'+testMacroprofil3.id+'",'+
            '       \"MasterLabel\": \"MPNL1-Standard\",'+
            '       \"Type_de_point__c\": \"20\",'+
            '       \"Pays__c\": \"Netherlands\"'+
            '	}]';        
        AssociationPUDOMacroprofil_Test.setMetadata(
            'Select id, Pays__c, Partenaire__c, Type_de_point__c, Id_du_Macroprofil__c From Association_PUDO_Macroprofil__mdt',
            (List<Association_PUDO_Macroprofil__mdt>) JSON.deserialize( json1,  List<Association_PUDO_Macroprofil__mdt>.class )
        );
        
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         or MasterLabel ='Netherlands'
                                                                         order by MasterLabel ];
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account'); 
        account1.RecordTypeId =associationRTPays[0].ID_PUDO_Non_Suivi__c;
        account1.Type = '20';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.BillingPostalCode ='1234';
        account1.ShippingPostalCode = '1243';
        insert account1;
        Account accountAssert = [Select Id, Macroprofil_actuel__c, BillingCountry, Type
                                 From Account 
                                 Where Id =: account1.Id];

        system.assertEquals(testMacroprofil.id, accountAssert.Macroprofil_actuel__c);
        //Create Account
        Account account2= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account');
        account2.RecordTypeId =associationRTPays[0].ID_PUDO_Non_Suivi__c;
        account2.Type = '3';
        account2.Partenaire__c = '124';
        account2.BillingCountry ='Belgium';
        account2.ShippingCountry ='Belgium';
        account2.BillingCountryCode = 'BE';
        account2.ShippingCountryCode ='BE';
        account2.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account2.ShippingPostalCode = '1243';
        account2.BillingPostalCode ='1234';
        account2.Operateur_Global__c = 'DPD_BNL';
        insert account2;
        Account accountAssert2 = [Select Id, Macroprofil_actuel__c, BillingCountry, Type
                                  From Account 
                                  Where Id =: account2.Id];

        system.assertEquals(testMacroprofil2.id, accountAssert2.Macroprofil_actuel__c);
        account1.RecordTypeId =associationRTPays[1].ID_PUDO_Non_Suivi__c;
        account1.Type = '20';
        account1.ShippingCountry ='Netherlands';
        account1.ShippingCountryCode ='NL';
        account1.ShippingPostalCode = '1234 AB';
        update account1;

    }
}