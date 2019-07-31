@isTest
public class customLookUpController_Test {
    static testMethod void testCustomLookupField() 
    {
        Contact newTestContact = Utils_TestMethods.CreateContact('John Bo');
        newTestContact.FirstName = 'John Bo';
        newTestContact.LastName = 'Bo';
        newTestContact.Contact_operationnel__c = true;
        insert newTestContact;
        
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('M1');
        insert macroprofil;
        
        List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_Conge__c,ID_CONGE__c
                                                                              FROM Association_Record_Type_et_pays__mdt];
            
        
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
            associationRTPays.put(associationRT.MasterLabel, associationRT);  
        }
        Account account1= Utils_TestMethods.CreateAccount(newTestContact, null, 'Test Account 1'); 
        account1.RecordTypeId =associationRTPays.get('Belgium').ID_PUDO_Non_Suivi__c;
        account1.Type = '20';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.BillingPostalCode ='1234';
        account1.ShippingPostalCode = '1243';
        account1.Amplitude_horaire_du_relais__c = 30;
        account1.Lundi_Ouverture__c = '10:30';
        account1.Lundi_Fermeture__c  = '17:45';        
        account1.lundi_debut_pause_dejeuner__c='14:30';
        account1.lundi_fin_pause_dejeuner__c ='16:30';  
        account1.Industry = '6';
        account1.Long_Lat_adresse_de_livraison__Latitude__s=62;
        account1.Long_Lat_adresse_de_livraison__Longitude__s=21;
        insert account1;
        newTestContact.AccountId = account1.id;
        update newTestContact;
        customLookUpController.fetchLookUpValues('John Bo', 'Contact', account1.id);
        customLookUpController.getContactNameApex(newTestContact.id);
    }
}