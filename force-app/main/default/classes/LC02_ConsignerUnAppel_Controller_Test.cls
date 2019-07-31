@isTest
public class LC02_ConsignerUnAppel_Controller_Test {
    static testMethod void DemarrageActiviteAppelRelaisRepond() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = associationRTPays[0].ID_suivi_CO__c;
        account1.Etat__c = '0';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        insert account1;
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        Case demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel1Statut1, macroProf.id);
        demarrageCase.RecordTypeId = Label.RT_BNL_Requete_Injoignabilite;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        LC02_ConsignerUnAppel_Controller.getCaseStatus(demarrageCase.id);
        
        //le relais repond
        LC02_ConsignerUnAppel_Controller.consignerUnappelController(Label.DA_OuiRelaisRepond, demarrageCase.id);
    }
    static testMethod void DemarrageActiviteAppelRelaisRepondPas() {
  List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = associationRTPays[0].ID_suivi_CO__c;
        account1.Etat__c = '0';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        insert account1;
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        Case demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel1Statut1, macroProf.id);
        demarrageCase.RecordTypeId = Label.RT_BNL_Requete_Injoignabilite;
        demarrageCase.AccountId =account1.id;
        //demarrageCase.Object_de_la_requete__c ='currentRequest.Object_de_la_requete__c';
        insert demarrageCase;
        LC02_ConsignerUnAppel_Controller.consignerUnappelController(Label.DA_NonRelaisRepond, demarrageCase.id);
    }
    static testMethod void DemarrageActiviteAppelRelaisNull() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = associationRTPays[0].ID_suivi_CO__c;
        account1.Etat__c = '0';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        insert account1;
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        Case demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel1Statut1, macroProf.id);
        demarrageCase.RecordTypeId = Label.RT_BNL_Requete_Injoignabilite;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        LC02_ConsignerUnAppel_Controller.consignerUnappelController(null, demarrageCase.id);
    }
    static testMethod void TraitementInterrompuDateRappel() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = associationRTPays[0].ID_suivi_CO__c;
        account1.Etat__c = '0';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        insert account1;
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        Case demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel1Statut1, macroProf.id);
        demarrageCase.RecordTypeId = Label.RT_BNL_Requete_Injoignabilite;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        LC02_ConsignerUnAppel_Controller.consignerUnappelController(Label.DA_InterrompuLbl, demarrageCase.id);
    }
    
}