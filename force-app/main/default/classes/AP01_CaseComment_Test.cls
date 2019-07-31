/* Class that test the functionality of AP01_CaseComment*/

@isTest
public class AP01_CaseComment_Test {
    
    public testMethod static void TestTriggers(){
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
            '  }]';        
        AssociationPUDOMacroprofil_Test.setMetadata(
            'Select id, Pays__c, Partenaire__c, Type_de_point__c, Id_du_Macroprofil__c From Association_PUDO_Macroprofil__mdt',
            (List<Association_PUDO_Macroprofil__mdt>) JSON.deserialize( json1,  List<Association_PUDO_Macroprofil__mdt>.class )
        );
        
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
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
        
        Case cas = Utils_TestMethods.createRequete('1', testMacroprofil.id);
        cas.AccountId = account1.Id;
        cas.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('DPD_BNL_Indisponibilité').getRecordTypeId();
        insert cas;
        
        caseComment caseCmnt = new caseComment();
        caseCmnt.CommentBody = 'test';
        caseCmnt.ParentId = cas.id;
        insert caseCmnt;
        
        caseCmnt.CommentBody = 'test 2';
        try{
            update caseCmnt;
        }
        catch(exception e){
            system.assert(e.getMessage().contains(label.CaseComment_Blockage));
        }
        try{ 
            delete caseCmnt;   
        }
        catch(exception e){
            system.assert(e.getMessage().contains(label.CaseComment_Blockage));
        }
        
    }
}