@isTest
public class VFC09_DemarrageActiviteAppel_TEST {
    
    static testMethod void DemarrageActiviteAppelRelaisRepond() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        } 
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        //account1.recordTypeID = associationRTPays[0].ID_suivi_CO__c;
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
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
        Case demarrageCase = Utils_TestMethods.createRequete('1', macroProf.id);//label.DA_EnAttenteAppel1Statut1
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
                VFC09_DemarrageActiviteAppel.getCaseStatus(demarrageCase.id);

      //le relais repond
        VFC09_DemarrageActiviteAppel.goToNextPage2(Label.DA_OuiRelaisRepond, demarrageCase.Status, demarrageCase.id);
    }
    static testMethod void DemarrageActiviteAppelRelaisRepondPas() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
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
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        VFC09_DemarrageActiviteAppel.goToNextPage2(Label.DA_NonRelaisRepond, demarrageCase.Status, demarrageCase.id);
    }
    static testMethod void DemarrageActiviteAppelRelaisNull() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
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
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        VFC09_DemarrageActiviteAppel.goToNextPage2(null, demarrageCase.Status, demarrageCase.id);
    }
    static testMethod void DemarrageActiviteAppelRelais() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
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
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        VFC09_DemarrageActiviteAppel.goToNextPage2(null, demarrageCase.Status, null);
    }
    static testMethod void TraitementInterrompuDateRappel() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        testContact1.Contact_operationnel__c = true;
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
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
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        Date dateRap = date.newinstance(system.now().year(),system.now().month(),system.now().day());
        String resultatappel = '3';
        Historique_des_Comptes_Rendus__c createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel,demarrageCase, dateRap, true);
        insert createHistorRecord;

        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id,testContact1.id, 'Success');
    }
    static testMethod void TraitementInterrompuDateRappelVide() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
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
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        String resultatappel = '3';
        Historique_des_Comptes_Rendus__c createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel,demarrageCase, null, true);
        insert createHistorRecord;
        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id, testContact1.id, 'Success');
    }
    static testMethod void TraitementNonInterrompuAppelN() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(null, null, 'Test Account');
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
        account1.Etat__c = '4';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        account1.Partenaire__c = '120';
        insert account1;
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        //En attent appel 1
        Case demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel1Statut1, macroProf.id);
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        String resultatappel = '3';
        Historique_des_Comptes_Rendus__c createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel, demarrageCase, null, false);
        insert createHistorRecord;
        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id, testContact1.id, 'Success');
        //En attent appel 2
        demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel2Statut2, macroProf.id);
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel,demarrageCase, null, false);
        insert createHistorRecord;
        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id, testContact1.id, 'Success');
        //En attent appel 3
        demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel3Statut3, macroProf.id);
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel,demarrageCase, null, false);
        insert createHistorRecord;
        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id, testContact1.id, 'Success');
        //VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '4', demarrageCase.Status, demarrageCase.id);
    }
    static testMethod void TraitementNonInterrompuAppelNSelectedRadioBoxValue4() {
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt];
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPays)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        //Create Contact
        Contact testContact1 = Utils_TestMethods.CreateContact('c2');
        Insert testContact1;
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(null, null, 'Test Account');
        account1.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
        account1.Etat__c = '4';
        account1.BillingCountry ='Belgium';
        account1.ShippingCountry ='Belgium';
        account1.ShippingPostalCode ='1234';
        account1.BillingPostalCode ='1234';
        account1.BillingCountryCode = 'BE';
        account1.ShippingCountryCode ='BE';
        account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
        account1.Operateur_Global__c = 'DPD_BNL';
        account1.type = '3';
        account1.Partenaire__c = '120';
        insert account1;
        Macroprofil__c macroProf = Utils_TestMethods.CreateMacroprofil('test');
        insert macroProf;
        //En attent appel 1
        Case demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel1Statut1, macroProf.id);
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        String resultatappel = '3';
        Historique_des_Comptes_Rendus__c createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel, demarrageCase, null, false);
        insert createHistorRecord;
        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id, testContact1.id, 'Success');
        //En attent appel 2
        demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel2Statut2, macroProf.id);
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel,demarrageCase, null, false);
        insert createHistorRecord;
        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id, testContact1.id, 'Success');
        //En attent appel 3
        demarrageCase = Utils_TestMethods.createRequete(label.DA_EnAttenteAppel3Statut3, macroProf.id);
        demarrageCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
        demarrageCase.AccountId =account1.id;
        insert demarrageCase;
        createHistorRecord = Utils_TestMethods.historiquePassageAppelSuivant(resultatappel,demarrageCase, null, false);
        insert createHistorRecord;
        //VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '3', demarrageCase.Status, demarrageCase.id);
        VFC09_DemarrageActiviteAppel.insertCompteRendu(createHistorRecord, '4', demarrageCase.Status, demarrageCase.id, testContact1.id, 'Success');
    }
    
    
}