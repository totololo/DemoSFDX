@isTest
public class AP02_Anomalie_Test {
    @testSetup
    static void testSetupm()
    {
        User currentUser = [SELECT Id, Name, BypassValidationRule__c
                            FROM User
                            WHERE Id = : UserInfo.getUserId()];
        currentUser.BypassValidationRule__c = true;
        currentUser.BypassProcessBuilder__c = true;
        currentUser.BypassWorkflow__c = true;
        update currentUser;
    }
    static testMethod void moyenScan() 
    {
        // retrieve ID of belgium
         List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_Conge__c,ID_CONGE__c
                                                                              FROM Association_Record_Type_et_pays__mdt];
            
            
        map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
           associationRTPays.put(associationRT.MasterLabel, associationRT);  
        }    
        Integer anomalieSurrattributionCount = 0;
        Integer decommissionnementDeviceCount = 0;
        Integer absenceDeviceCount = 0;
        Integer absenceDevice1Count = 0;
        Integer associationtortEtat2Count = 0;
        Integer pasDePDAAssocieStandard = 0;
        Integer pasDePDAAssociePartenaire = 0;
        
        Contact testContact = Utils_TestMethods.CreateContact('Name');       
        Contact testContact1 = Utils_TestMethods.CreateContact('Name1'); 
        Contact testContact2 = Utils_TestMethods.CreateContact('Name2'); 
        insert new List<Contact> {testContact, testContact1, testContact2};
        list<Account> listAccounts = new list<Account>();
        //Account type 2
        Account newAccount= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account');
        newAccount.RecordTypeId = associationRTPays.get('Belgium').ID_Prospect_A_Valider__c;
        newAccount.ShippingCountry ='Belgium';
        newAccount.ShippingCountryCode='BE';
        newAccount.Etat__c = '0';
        newAccount.Operateur_Global__c = 'DPD_BNL';
        newAccount.ShippingPostalCode = '1234';
        newAccount.Type ='2';
        listAccounts.add(newAccount);
        //Account type 3
        Account newAccount1= Utils_TestMethods.CreateAccount(testContact1, null, 'Test Account');
        newAccount1.RecordTypeId = associationRTPays.get('Belgium').ID_Prospect_A_Valider__c;
        newAccount1.ShippingCountry ='Belgium';
        newAccount1.ShippingCountryCode='BE';
        newAccount1.Etat__c = '0';
        newAccount1.Operateur_Global__c = 'DPD_BNL';
        newAccount1.ShippingPostalCode = '1234';
        newAccount1.Type ='3';
        listAccounts.add(newAccount1);
        Account newAccount2= Utils_TestMethods.CreateAccount(testContact2, null, 'Test Account');
        newAccount2.RecordTypeId = associationRTPays.get('France').ID_Prospect_Converti__c;
        newAccount2.ShippingCountry ='France';
        newAccount2.ShippingCountryCode='FR';
        newAccount2.Etat__c = '0';
        newAccount2.Operateur_Global__c = 'PUS_FR';
        newAccount2.ShippingPostalCode = '12345';
        newAccount2.Type ='2';
        listAccounts.add(newAccount2);
        insert listAccounts;
        testContact.AccountId = newAccount.id;
        testContact1.AccountId = newAccount1.id;
        testContact2.AccountId = newAccount2.id;
        update new List<Contact>{testContact, testContact1, testContact2};
        
        list<anomalie__c> listAnomaliesToInsert = new list<anomalie__c>();
        list<anomalie__c> listAnomaliesToUpdate = new list<anomalie__c>();
        
        //Anomalie Surattribution de device ouverte
        Anomalie__c testAnomalieSurrattribution = Utils_TestMethods.createAnomalie(newAccount);
        testAnomalieSurrattribution.Statut__c='1';
        testAnomalieSurrattribution.Type__c='TooManyDevices';
        listAnomaliesToInsert.add(testAnomalieSurrattribution);
    Anomalie__c testAnomalieSurrattribution1 = Utils_TestMethods.createAnomalie(newAccount);
        testAnomalieSurrattribution1.Statut__c='1';
        testAnomalieSurrattribution1.Type__c='TooManyDevices';
        listAnomaliesToInsert.add(testAnomalieSurrattribution1);      
        Anomalie__c testAnomalieSurrattribution2 = Utils_TestMethods.createAnomalie(newAccount);
        testAnomalieSurrattribution2.Statut__c='1';
        testAnomalieSurrattribution2.Type__c='TooManyDevices';
        listAnomaliesToInsert.add(testAnomalieSurrattribution2); 
        Anomalie__c testAnomalieSurrattribution3 = Utils_TestMethods.createAnomalie(newAccount2);
        testAnomalieSurrattribution3.Statut__c='1';
        testAnomalieSurrattribution3.Type__c='TooManyDevices';
        listAnomaliesToInsert.add(testAnomalieSurrattribution3);
        
        //Anomalie Décommissionnement de device ouverte
        Anomalie__c testDecommissionnementDevice = Utils_TestMethods.createAnomalie(newAccount);
        testDecommissionnementDevice.Statut__c='1';
        testDecommissionnementDevice.Type__c='NoDecommissioned';
        listAnomaliesToInsert.add(testDecommissionnementDevice);
        Anomalie__c testDecommissionnementDevice1 = Utils_TestMethods.createAnomalie(newAccount);
        testDecommissionnementDevice1.Statut__c='1';
        testDecommissionnementDevice1.Type__c='NoDecommissioned';
        listAnomaliesToInsert.add(testDecommissionnementDevice1);
        Anomalie__c testDecommissionnementDevice2 = Utils_TestMethods.createAnomalie(newAccount2);
        testDecommissionnementDevice2.Statut__c='1';
        testDecommissionnementDevice2.Type__c='NoDecommissioned';
        listAnomaliesToInsert.add(testDecommissionnementDevice2);
        
        //Anomalie Absence de device associé type 2
        Anomalie__c testAbsenceDevice = Utils_TestMethods.createAnomalie(newAccount2);
        testAbsenceDevice.Statut__c='1';
        testAbsenceDevice.Type__c='NoDevice';
        listAnomaliesToInsert.add(testAbsenceDevice);
        
        //Anomalie Absence de device associé type 3
        Anomalie__c testAbsenceDevice1 = Utils_TestMethods.createAnomalie(newAccount2);
        testAbsenceDevice1.Statut__c='1';
        testAbsenceDevice1.Type__c='NoDevice';
        listAnomaliesToInsert.add(testAbsenceDevice1);
        
        //Anomalie Absence de device associé Fr
        Anomalie__c testAbsenceDevice2 = Utils_TestMethods.createAnomalie(newAccount2);
        testAbsenceDevice2.Statut__c='1';
        testAbsenceDevice2.Type__c='NoDevice';
        listAnomaliesToInsert.add(testAbsenceDevice2);
        
        //Anomalie Association à tort Etat 2
        Anomalie__c testAssociationtortEtat2 = Utils_TestMethods.createAnomalie(newAccount);
        testAssociationtortEtat2.Statut__c='1';
        testAssociationtortEtat2.Type__c='Association à tort Etat 2';        
        listAnomaliesToInsert.add(testAssociationtortEtat2);
        
        Anomalie__c testAssociationtortEtat2_2 = Utils_TestMethods.createAnomalie(newAccount2);
        testAssociationtortEtat2_2.Statut__c='1';
        testAssociationtortEtat2_2.Type__c='Association à tort Etat 2';
        listAnomaliesToInsert.add(testAssociationtortEtat2_2);
        
        insert listAnomaliesToInsert;
        
        List<Case> anomCaseInserted = [SELECT id, Anomalie__c, Anomalie__r.Statut__c, Anomalie__r.type__c, Account.type
                                       FROM Case
                                       WHERE Anomalie__r.Statut__c ='1'];
        List<Anomalie__c> anomCongeInserted = [SELECT id,Type__c, PUDO__r.type,
                                               (SELECT id FROM Cong_s_disponibilit_s_indisponibilit_s__r WHERE Type_d_indisponibilite__c = '4')
                                               FROM Anomalie__c
                                               WHERE Statut__c = '1'];    
        system.debug('anomCaseInserted '+anomCaseInserted);
        system.debug('anomCongeInserted '+anomCongeInserted);
        for(Case anomCase : anomCaseInserted)
        {
            system.debug('anomCase.Anomalie__c '+anomCase.Anomalie__c);
            system.debug('testAnomalieSurrattribution.id '+testAnomalieSurrattribution.id);
            system.debug('anomCase.Anomalie__r.type__c '+anomCase.Anomalie__r.type__c);
            system.debug('anomCase.Account.type '+anomCase.Account.type);
            
            if(anomCase.Anomalie__c == testAnomalieSurrattribution.id)
            {
                anomalieSurrattributionCount++;
            }
            else if(anomCase.Anomalie__c == testDecommissionnementDevice.id)
            {
                decommissionnementDeviceCount++;
            }
            else if(anomCase.Anomalie__c == testAbsenceDevice1.id)
            {
                absenceDevice1Count++;
            }
            else if(anomCase.Anomalie__c == testAssociationtortEtat2.id)
            {
                associationtortEtat2Count++;
            }
        }
        //Anomalie Surattribution de device fermer
        testAnomalieSurrattribution.Statut__c = '0';
        listAnomaliesToUpdate.add(testAnomalieSurrattribution);
        //update testAnomalieSurrattribution;
        
        //Anomalie Décommissionnement de device fermer
        testDecommissionnementDevice.Statut__c = '0';
        //update testDecommissionnementDevice;
        listAnomaliesToUpdate.add(testDecommissionnementDevice);
        
        //Anomalie Absence de device fermer type 2
        testAbsenceDevice.Statut__c = '0';
        //update testAbsenceDevice;
        
        //Anomalie Absence de device fermer type 3
        testAbsenceDevice1.Statut__c = '0';
        //update testAbsenceDevice1;
        
        //Anomalie Association à tort Etat 2
        testAssociationtortEtat2.Statut__c = '0';
        listAnomaliesToUpdate.add(testAssociationtortEtat2);
        
        testAssociationtortEtat2_2.Statut__c = '0';
        listAnomaliesToUpdate.add(testAssociationtortEtat2_2);
        
        testAnomalieSurrattribution3.Statut__c = '0';
        listAnomaliesToUpdate.add(testAnomalieSurrattribution3);
        
        testDecommissionnementDevice2.Statut__c = '0';
        listAnomaliesToUpdate.add(testDecommissionnementDevice2);
        
        testAbsenceDevice2.Statut__c = '0';
        listAnomaliesToUpdate.add(testAbsenceDevice2);

        update listAnomaliesToUpdate;
        
        anomalieSurrattributionCount = 0;
        decommissionnementDeviceCount = 0;
        absenceDeviceCount = 0;
        absenceDevice1Count = 0;
        associationtortEtat2Count = 0;
        pasDePDAAssocieStandard = 0;
        pasDePDAAssociePartenaire = 0;
        
        List<Case> anomCaseUpdated = [SELECT id, status, Anomalie__c, Anomalie__r.Statut__c
                                      FROM Case
                                      WHERE Anomalie__r.Statut__c ='0'];
        List<Anomalie__c> anomCongeUpdated = [SELECT id, PUDO__r.type,
                                              (SELECT id FROM Cong_s_disponibilit_s_indisponibilit_s__r WHERE Type_d_indisponibilite__c = '4' AND Date_de_fin__c = :Date.today())
                                              FROM Anomalie__c
                                              WHERE Statut__c = '0'];   
        for(Case anomCase : anomCaseUpdated)
        {
            if(anomCase.Anomalie__c == testAnomalieSurrattribution.id && anomCase.status == 'Terminée')
            {
                anomalieSurrattributionCount++;
            }
            else if(anomCase.Anomalie__c == testDecommissionnementDevice.id && anomCase.status == 'Terminée')
            {
                decommissionnementDeviceCount++;
            }
            else if(anomCase.Anomalie__c == testAssociationtortEtat2.id && anomCase.status == 'Terminée')
            {
                associationtortEtat2Count++;
            }
        }
      }
}