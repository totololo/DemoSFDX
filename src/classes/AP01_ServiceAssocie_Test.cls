/* Class that test the functionality of AP01_ServiceAssocie*/

@isTest
public class AP01_ServiceAssocie_Test {
    
    public static testmethod void UpdateNomServiceTest (){
        
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c
                                                                            FROM Association_Record_Type_et_pays__mdt];
        
        
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
            associationRTPays.put(associationRT.MasterLabel, associationRT);}
        
        service__c testService1 = Utils_TestMethods.CreateService('test service 1');
        testService1.Nom_du_service_translated__c= 'Chronofresh';
        
        service__c testService2 = Utils_TestMethods.CreateService('test service 2');
        testService2.Nom_du_service_translated__c= 'Contre remboursement_CASH';
        insert new list<service__c> {testService1,testService2};
            
        Contact testContact = Utils_TestMethods.CreateContact('test contact');
        insert testContact;
        
        Macroprofil__c testMacrorofil = Utils_TestMethods.CreateMacroprofil('test Macrorofil');
        insert testMacrorofil;
        
        account testAccount = Utils_TestMethods.CreateAccount(testContact,testMacrorofil,'test account');
        testAccount.RecordTypeId = associationRTPays.get('Belgium').ID_PUDO_Non_Suivi__c;
        testAccount.N_TVA__c = '123';
        testAccount.Type = '20';
        testAccount.BillingCountry ='Belgium';
        testAccount.ShippingCountry ='Belgium';
        testAccount.BillingCountryCode = 'BE';
        testAccount.ShippingCountryCode ='BE';
        testAccount.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        testAccount.Operateur_Global__c = 'DPD_BNL';
        testAccount.BillingPostalCode ='1234';
        testAccount.ShippingPostalCode = '1234';
        testAccount.Long_Lat_adresse_de_livraison__Latitude__s=62;
        insert testAccount;
        
        service_associe__c testServiceAssociee = new service_associe__c();
        testServiceAssociee.Service__c = testService1.id;
        testServiceAssociee.Compte__c = testAccount.id;
        testServiceAssociee.Modifiable__c = true;
        insert testServiceAssociee;
        
        testService1.Nom_du_service_translated__c= 'Contre remboursement';
        update testService1;
        
        testServiceAssociee.Service__c  = testService2.id;
        update testServiceAssociee;
    }
}