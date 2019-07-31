public class Utils_TestMethods {
    
    public static Macroprofil_Transporteur__c createMacroprofilTransporteur(Macroprofil__c m, Transporteur__c t){
        Macroprofil_Transporteur__c mt = new Macroprofil_Transporteur__c();
        mt.Macroprofil__c = m.Id;
        mt.Transporteur__c = t.Id;
        mt.Active__c = true;
        return mt;
    }
    
    public static Macroprofil_Service__c createMacroprofilService(Macroprofil__c m, Service__c s){
        Macroprofil_Service__c mt = new Macroprofil_Service__c();
        mt.Macroprofil__c = m.Id;
        mt.Service__c = s.Id;
        mt.Active__c = true;
        return mt;
    }
    
    public static Transporteur__c CreateTransporteur(string Name)
    {
        Transporteur__c t = new Transporteur__c();
        t.Name = Name; 
        
        return t;
    }
    
    public static Service__c CreateService(string Name)
    {
        Service__c s = new Service__c();
        s.Name =Name;
        
        return s;
    }
    
    public static Contact CreateContact(string Name)
    {
        Contact c = new Contact();
        c.FirstName = 'PUS Contact';
        c.LastName = Name;
        c.Phone = '0123443';
        c.Email = 'test@gmail.com';
        c.MobilePhone='74185285';
        return c;
    }
    
    public static Conge_Indispo__c CreateConge_Indispo(Id recordTypeId, Id nomCompte )
    {
        Conge_Indispo__c cong = new Conge_Indispo__c();
        cong.RecordTypeId= recordTypeId;
        cong.Nom_du_compte__c = nomCompte;
        cong.Date_de_debut__c = Date.today();
        cong.Date_de_fin__c = Date.today().adddays(30);       
        return cong;
    }
    
        public static Conge_Indispo__c CreateConge_Indispo(Id recordTypeId, Id nomCompte, Date dateDebut, Date dateFin )
    {
        Conge_Indispo__c cong = new Conge_Indispo__c();
        cong.RecordTypeId= recordTypeId;
        cong.Nom_du_compte__c = nomCompte;
        cong.Date_de_debut__c = dateDebut;
        cong.Date_de_fin__c = dateFin;       
        return cong;
    }
    
    public static Macroprofil__c createMacroprofil(string Name)
    {
        Macroprofil__c m = new Macroprofil__c();
        m.name='MPFR_Consigne';
        m.ReferenceExterne__c = Name;
        m.Operateur__c='PUS_FR';
        //insert m;
        return m;
    }
    
    public static Account CreateAccount(Contact contact, Macroprofil__c macroprofil, string Name)
    {
        Account account = new Account();
        //account.RecordTypeId = 
        account.Name = Name;
        if(contact != null){
            account.Contact_operationnel_1__c = contact.Id;
            account.Responsable_facturation__c = contact.Id;
        }
        account.Refus_Email__c = true;
        if(macroprofil !=null)
        {
            account.Macroprofil_actuel__c = macroprofil.Id;
        }
        account.Industry = 'Photographe';
        account.Hauteur_cm__c = 20;
        account.Largeur_cm__c = 100;
        account.Profondeur_cm__c = 200;
        account.Seuil_contractuel__c = 2;
        account.employes_formes__c = 20;
        account.Ownership = 'Autre';
        account.Titulaire_du_compte__c = 'Test';
        account.Code_BIC__c ='12345678';
        account.IBAN__c = 'FR7630066107000002026480159'; 
        account.BillingCountry = 'France';
        account.BillingCity = 'Paris';
        account.BillingStreet = 'Paris';
        account.BillingCountryCode = 'FR';
        account.BillingPostalCode = '12345';
        //Add
        account.ShippingPostalCode='12345';
        account.BillingStreet='abc';
        account.BillingCity='France'; 
        account.Etat__c='8';
        account.Lundi_Ouverture__c='00:15';
        account.Lundi_Fermeture__c='04:00';
        account.lundi_debut_pause_dejeuner__c='01:00';
        account.lundi_fin_pause_dejeuner__c='01:15';
        account.Mardi_Ouverture__c='00:15';
        account.Mardi_Fermeture__c='04:00';
        account.Mardi_debut_pause_dejeuner__c='01:00';
        account.Mardi_fin_pause_dejeuner__c='01:15';
        account.Mercredi_Ouverture__c='00:15';
        account.Mercredi_Fermeture__c='04:00';
        account.Mercredi_debut_pause_dejeuner__c='01:00';
        account.Mercredi_fin_pause_dejeuner__c='01:15';
        account.Mercredi_Ouverture__c='00:15';
        account.Mercredi_Fermeture__c='04:00';
        account.Mercredi_debut_pause_dejeuner__c='01:00';
        account.Mercredi_fin_pause_dejeuner__c='01:15';
        account.Jeudi_ferme__c=true;
        account.Vendredi_ferme__c=true;
        account.Samedi_ferme__c=true;
        account.Dimanche_ferme__c=true;
        // TMA JSA
        account.Type='20';
        account.ShippingCity='France';
        account.ShippingCountry='France';
        account.ShippingCountryCode='FR';
        account.ShippingStreet='abc'; 
        account.Long_Lat_adresse_de_livraison__Latitude__s = 21;
        account.Long_Lat_adresse_de_livraison__Longitude__s = 21;
        return account;
    }   
    
    public static Account createAccountBNLnonSuiviCO(Macroprofil__c macroprofil, string Name)
    {
        Account newAccount = new Account();
        newAccount.Name = Name;
        newAccount.Date_d_installation__c = date.ValueOf('2017-12-13');
        //newAccount.Macroprofil_de_reference__c = macroprofil.id;
        newAccount.N_de_rue_livraison__c = 'rue Cast';
        //newAccount.Rue_de_l_adresse_de_livraison__c = 'rue Castex';
        newAccount.Code_postal__c = '75004';
        //newAccount.Ville_de_l_adresse_de_livraison2__c = 'France';
        newAccount.ShippingStreet ='Test Street';
        newAccount.ShippingCity = 'Test City';
        newAccount.ShippingPostalCode = '12345';
        newAccount.ShippingLatitude = 1;
        newAccount.ShippingLongitude = 1;
        newAccount.Long_Lat_adresse_de_livraison__Latitude__s = 21;
        newAccount.Long_Lat_adresse_de_livraison__Longitude__s = 21;
        newAccount.RecordTypeId = Label.AccountConsigneRT_15;
        
        
        newAccount.Long_Lat_adresse_de_livraison__Latitude__s = 21;
        newAccount.Long_Lat_adresse_de_livraison__Longitude__s = 21;
        return newAccount;
    }
    //Added by john to create Configuration PUS_BNL_Consigne
    public static Configuration__c createConfiguration(String name)
    {
        Configuration__c newConfiguration = new Configuration__c();
        newConfiguration.Name = name;
        newConfiguration.Modele__c = 'KEBA';
        newConfiguration.Description__c ='Test Description';
        return newConfiguration;
    }
    public static Configuration_Site__c createConfigurationSite()
    {
        Configuration_Site__c newConfigurationSite = new Configuration_Site__c();
        newConfigurationSite.Name = 'Test Config';
        newConfigurationSite.Nom_Configuration__c= 'Testing Config';
        newConfigurationSite.Modele__c ='KEBA';
        newConfigurationSite.Description__c = 'test Description';
        return newConfigurationSite;
    }
    //Added by john to create TypeCasierKEBA PUS_BNL_Consigne
    public static Type_de_casier__c createTypeCasierKEBA(String name)
    {
        Type_de_casier__c newTypeCasier = new Type_de_casier__c();
        newTypeCasier.Name = name;
        newTypeCasier.Coef_ajustement__c = 1;
        newTypeCasier.Maximum__c = 10;
        newTypeCasier.Minimum__c = 2;
        newTypeCasier.Modele__c = 'KEBA';
        newTypeCasier.Moyenne__c = 6;
        newTypeCasier.Poids_max__c =12;
        return newTypeCasier;
    }
    //Added by john to create ConfigurationLockerType PUS_BNL_Consigne
    public static Configuration_Locker_Type__c createConfigurationLockerType(ID newConfigID,ID newTypeCasierID)
    {
        Configuration_Locker_Type__c newConfigLockType = new Configuration_Locker_Type__c();
        newConfigLockType.Configuration__c = newConfigID;
        newConfigLockType.Type_de_casier__c = newTypeCasierID;
        newConfigLockType.Nombre__c = 1.0;
        return newConfigLockType;
    }
    public static Lead createLead(String firstName , String lastName , String company , String status)
    {
        Lead lead = new Lead();
        lead.FirstName =  firstName;
        lead.LastName  =  lastName;
        lead.Company   =  company;
        lead.Status    =  status; 
        lead.Country   = 'France'; 
        lead.CountryCode = 'FR';
        lead.Street    =  'lead street';
        lead.Activite_commerciale_principale__c = '18';
        lead.Industry = '1';
        lead.N_de_la_rue__c = '100';
        lead.City  = 'Paris';
        lead.PostalCode = '0000';
        lead.Long_Lat_adresse_de_livraison__Latitude__s = 21;
        lead.Long_Lat_adresse_de_livraison__Longitude__s = 21;
        return lead;
    }
    
    //method to create reseau
    public static Reseau__c CreateReseau(string Name){
        Reseau__c retVal = new Reseau__c();
        retVal.Name =Name;
        return retVal;
    }
    
    //method to create MacroProfil Reseau
    public static Macroprofil_Reseau__c createMacroprofilReseau(string macroprofilId, string reseauId)
    {
        Macroprofil_Reseau__c retVal = new Macroprofil_Reseau__c();
        retVal.Macroprofil__c =macroprofilId;
        retVal.Reseau__c = reseauId;
        retVal.Active__c = true;
        return retVal;
    }
    
    //method to create Reseau Service
    public static Reseau_Service__c CreateReseauService(string reseauId, string serviceId){
        Reseau_Service__c retVal = new Reseau_Service__c();
        retVal.Reseau__c = reseauId;
        retVal.Service__c = serviceId;
        return retVal;
    }
    
    //method to create Reseau Transporteur
    public static Reseau_Transporteur__c CreateReseauTransporteur(string reseauId, string transporteurId){
        Reseau_Transporteur__c retVal = new Reseau_Transporteur__c();
        retVal.Reseau__c = reseauId;
        retVal.Transporteur__c = transporteurId;
        return retVal;
    }
    
     //method to create Requete
    public static Case createRequete(string statut, string macroprofilId){
        Case retVal = new Case();
        retVal.Status = statut;
        retVal.Macroprofil_de_reference__c = macroprofilId;
        return retVal;
    }
    //method to create Requete handleAfterUpdate
    public static Case createRequete_REQ_PB06StatusTermine(Id accountID, ID indispoID){
        Case retVal = new Case();
        retVal.Status ='Terminée';
        retVal.Subject=Label.IND_PannePDA;
        retVal.AccountId=accountID;
        retVal.Indisponibilite__c=indispoID;
        
        return retVal;
    }
    //method to create Requete En attente de traitement
    public static Case createRequete_REQ_PB06StatusEnAttente(Id accountID, ID indispoID){
        Case retVal = new Case();
        retVal.Status ='En attente de traitement';
        retVal.Subject=Label.IND_PannePDA;
        retVal.AccountId=accountID;
        retVal.Indisponibilite__c=indispoID;
        
        return retVal;
    }
    //method to create Requete handleAfterUpdate
    public static Case createRequete_PUSFRDemarrage_Activite(Id accountID){
        Recordtype recDemarActivite= [Select ID, SobjectType, Name, DeveloperName From RecordType  where SobjectType='Case' and DeveloperName='PUS_FR_Demarrage_d_activite' ];
        
        Case retVal = new Case();
        retVal.Status ='En attente de traitement';
        retVal.AccountId=accountID;
        retVal.RecordTypeID=recDemarActivite.Id;
        
        return retVal;
    }
    //method to create Requete handleAfterUpdate
    public static Case createRequete_PUS_FR_Anomalie_Synchro(Id accountID){
        Id RecordTypeIdCaseAnomalie = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PUS_FR_Anomalie_Synchro').getRecordTypeId();
        Case retVal = new Case();
        retVal.recordtypeid=RecordTypeIdCaseAnomalie;
        retVal.AccountId=accountID;
        return retVal;
    }
    
    //method to create Requete Demarrage Activité Sans rappel
    public static Case createRequete_PUS_FR_DemarrageActiviteNoRappel(Id accountID){
        Id RecordTypeIdCaseAnomalie = [Select ID, SobjectType, Name, DeveloperName From RecordType  where SobjectType='Case' and DeveloperName='PUS_FR_Anomalie_Synchro' LIMIT 1 ].ID;
        Case retVal = new Case();
        retVal.recordtypeid=RecordTypeIdCaseAnomalie;
        retVal.AccountId=accountID;
        retVal.Traitement_interrompu__c=TRUE;
        retVal.Planifier_un_rappel__c=FALSE;
        return retVal;
    }
    //method to create Requete Demarrage Activité avec Rappel
    public static Case createRequete_PUS_FR_DemarrageActiviteRappel(Id accountID){
        Id RecordTypeIdCaseAnomalie = [Select ID, SobjectType, Name, DeveloperName From RecordType  where SobjectType='Case' and DeveloperName='PUS_FR_Anomalie_Synchro' LIMIT 1 ].ID;
        Case retVal = new Case();
        retVal.recordtypeid=RecordTypeIdCaseAnomalie;
        retVal.AccountId=accountID;
        retVal.Traitement_interrompu__c=TRUE;
        retVal.Planifier_un_rappel__c=TRUE;
        retVal.Date_de_rappel_planifiee__c=date.Today()+100;
        return retVal;
    }
    
    //method to create Questionnaire
    public static Questionnaire__c createQuestionnaire(string macroprofilId, string statut){
        Questionnaire__c retVal = new Questionnaire__c();
        retVal.Statut_de_la_requete__c = statut;
        retVal.Macroprofil__c = macroprofilId;
        return retVal;
    }
    //method to create Question
    public static Questions__c createQuestion(string questionnaireId, string question, string reponseSuggere, string typeQuestion){
        Questions__c retVal = new Questions__c();
        retVal.Nom_du_Questionnaire__c = questionnaireId;
        retVal.Question__c = question;
        retVal.Reponses_suggerees__c = reponseSuggere;
        retVal.Type_de_question__c = typeQuestion;
        return retVal;
    }
    //method to create Attachment
    public static Attachment createAttachment(Id accountId , String body , String name) {
        Attachment attachment = new Attachment();
        attachment.ParentId   = accountId;
        attachment.Body       = Blob.valueOf(body);
        attachment.Name       = name;
        return attachment;
    }
    
    //method to create User
    public static User createUser(String firstName,String lastName,String username,String email){
        User retUser = new User();
        retUser.FirstName = firstName;
        retUser.LastName  = lastName; 
        retUser.Username = username;
        retUser.Email = email;
        retUser.Alias = firstName + '.' + lastName;
        retUser.CommunityNickname = lastname + '.' + firstname;
        /*Change for ODASEVA request avoid HardCoding*/
        //Request a profile ID 
        Profile userProfile= [Select Id from Profile where name='System Administrator' OR name='Administrateur système' LIMIT 1];
        //retUser.ProfileId = '00e580000012ZsGAAU';
        retUser.ProfileId = userProfile.id;
        retUser.LocaleSidKey = 'fr_FR';
        retUser.EmailEncodingKey = 'ISO-8859-1'; 
        retUser.LanguageLocaleKey = 'fr';
        retUser.Operateur__c = 'PUS_FR';
        retUser.TimeZoneSidKey = 'Europe/Paris';
        return retUser;
    }
    
    public static Reseau_Associe__c createReseauAssocie(Id ReseauId , Id CompteId , boolean isActive , boolean isModifiable){
        Reseau_Associe__c ra = new Reseau_Associe__c();
        ra.Reseau__c = ReseauId;
        ra.Compte__c = CompteId;
        ra.Modifiable__c = isModifiable;
        ra.Active__c = isActive;
        return ra;
    }
    //Methode creation Anomalie
    public static Anomalie__c createAnomalie(Id compteId){
        Anomalie__c anomalie = new Anomalie__c();
        anomalie.Numero_Anomalie__c='121212';
        anomalie.Datededetection__c= date.Today();
        anomalie.Statut__c='1';
        anomalie.Type__c='SyncPudo';
        anomalie.PUDO__c=compteId;
        return anomalie;
        
    }

    public static Historique_des_Comptes_Rendus__c historiquePassageAppelSuivant(String resultatappel, Case demarrageCase,Date dateRap, Boolean traitInter)
    {
        Historique_des_Comptes_Rendus__c histCompteRendu = new Historique_des_Comptes_Rendus__c();
        histCompteRendu.Cases__c = demarrageCase.id;
        histCompteRendu.Compte_rendu__c ='Test Compte Rendu';
        histCompteRendu.Traitement_interrompu__c = traitInter;
        histCompteRendu.Date_Du_Rappel__c =dateRap;
        histCompteRendu.Resultat_d_appel__c = '3';
        histCompteRendu.Status__c =demarrageCase.Status;
        return histCompteRendu;
    }
    
    public static Task createTask(Case caseTask, Contact contactTask)
    {
        Task newTask = new Task();
        newTask.WhatId = caseTask.id;
        newTask.WhoId = contactTask.id;
        return newTask;
    }
    
    public static Anomalie__c createAnomalie(Account account)
    {
        Anomalie__c newAnomalie= new Anomalie__c();
        newAnomalie.Name='test anomalie';
        newAnomalie.PUDO__c=account.id;
        return newAnomalie;
    }
    
    public static Compte_rendu__c createCompteRendu(String Name, Id RecordTypeId)
    {
        Compte_rendu__c CompteRendu= new Compte_rendu__c();
        CompteRendu.Name = Name;
        CompteRendu.RecordTypeId = RecordTypeId;
        return CompteRendu;
    }
    
    public static Compte_rendu_rempli__c createCompteRenduRempli(Id Compte, String Statut)
    {
        Compte_rendu_rempli__c CompteRenduRempli= new Compte_rendu_rempli__c();
        CompteRenduRempli.Compte__c = Compte;
        CompteRenduRempli.Statut__c = Statut;
        return CompteRenduRempli;
    }
    
    public static Questions_CR__c createQuestionsCR(Id CompteRenduId, String Options_de_reponses, String Questions, String Type_de_reponse)
    {
        Questions_CR__c question = new Questions_CR__c();
        question.Compte_rendu__c = CompteRenduId;
        question.Options_de_reponses__c = Options_de_reponses;
        question.Questions__c = Questions;
        question.Type_de_reponse__c = Type_de_reponse;
        return question;
    }
    
    public static Reponse_CR__c createReponseCR(Id CompteRenduRempliId, String QuestionsCRId, String Questions, String Reponses)
    {
        Reponse_CR__c Reponse = new Reponse_CR__c();
        Reponse.Compte_rendu_rempli__c = CompteRenduRempliId;
        Reponse.Questions_CR__c = QuestionsCRId;
        Reponse.Question__c = Questions;
        Reponse.Reponse__c = Reponses;
        return Reponse;
    }
    
    public static Document createDocument(String Name, String DeveloperName, Id FolderId)
    {
        Document document = new Document();
        document.Name = Name;
        document.DeveloperName = DeveloperName;
        document.FolderId = FolderId;
        return document;
    }
    
    public static Task createEmailTask(Id CRRId, String TaskType)
    {
        Task newTask = new Task();
        newTask.WhatId = CRRId;
        newTask.TaskSubtype = TaskType;
        return newTask;
    }
    public static Secteur__c createSectorFR(String Namsecteur){
        Secteur__c testSecteur= new Secteur__c ();
        testSecteur.Name=Namsecteur;
        testSecteur.Operateur__c='PUS_FR';
        testSecteur.Pays__c='Fr';
        testSecteur.Type_de_secteur__c='Cluster';
        testSecteur.Selectionnable__c=true;
        return testSecteur;
        
    }
    public static Account CreateAccountPUS_FR_SuiviCo(Contact contact, Macroprofil__c macroprofil, string Name, Secteur__c secteur)
    {
        Id objectRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' and developerName='PUS_FR_PUDO_Suivi_CO'].Id;
        
        Account account = new Account();
        //account.RecordTypeId = 
        account.recordtypeId=objectRecordTypeId;
        account.Name = Name;
        if(contact != null){
            account.Contact_operationnel_1__c = contact.Id;
            account.Responsable_facturation__c = contact.Id;
        }
        account.Refus_Email__c = true;
        if(macroprofil !=null)
        {
            account.Macroprofil_actuel__c = macroprofil.Id;
        }
        account.Industry = 'Photographe';
        account.Hauteur_cm__c = 20;
        account.Largeur_cm__c = 100;
        account.Profondeur_cm__c = 200;
        account.Seuil_contractuel__c = 2;
        account.employes_formes__c = 20;
        account.Ownership = 'Autre';
        account.Titulaire_du_compte__c = 'Test';
        account.Code_BIC__c ='12345678';
        account.IBAN__c = 'FR7630066107000002026480159'; 
        account.BillingCountry = 'France';
        account.BillingCity = 'Paris';
        account.BillingStreet = 'Paris';
        account.BillingCountryCode = 'FR';
        account.BillingPostalCode = '12345';
        //Add
        account.ShippingPostalCode='12345';
        account.BillingStreet='abc';
        account.BillingCity='France'; 
        account.Etat__c='4';
        account.Lundi_Ouverture__c='00:15';
        account.Lundi_Fermeture__c='04:00';
        account.lundi_debut_pause_dejeuner__c='01:00';
        account.lundi_fin_pause_dejeuner__c='01:15';
        account.Mardi_Ouverture__c='00:15';
        account.Mardi_Fermeture__c='04:00';
        account.Mardi_debut_pause_dejeuner__c='01:00';
        account.Mardi_fin_pause_dejeuner__c='01:15';
        account.Mercredi_Ouverture__c='00:15';
        account.Mercredi_Fermeture__c='04:00';
        account.Mercredi_debut_pause_dejeuner__c='01:00';
        account.Mercredi_fin_pause_dejeuner__c='01:15';
        account.Mercredi_Ouverture__c='00:15';
        account.Mercredi_Fermeture__c='04:00';
        account.Mercredi_debut_pause_dejeuner__c='01:00';
        account.Mercredi_fin_pause_dejeuner__c='01:15';
        account.Jeudi_ferme__c=true;
        account.Vendredi_ferme__c=true;
        account.Samedi_ferme__c=true;
        account.Dimanche_ferme__c=true;
        // TMA JSA
        account.Type='3';
        account.Partenaire__c='134';
        account.ShippingCity='France';
        account.ShippingCountry='France';
        account.ShippingCountryCode='FR';
        account.ShippingStreet='abc'; 
        account.Long_Lat_adresse_de_livraison__Latitude__s = 21;
        account.Long_Lat_adresse_de_livraison__Longitude__s = 21;
        account.OPERATEUR_GLOBAL__C='PUS_FR';
        account.TYPE_DE_DEVICE__C='PDA Android';
        account.TYPE_ACCES_INTERNET__C='3';
        account.TYPE_DE_PARKING__C='3';
        account.CAPITAL_EUR__C=123000;
        account.INDUSTRY='10';
        account.PHONE='00000111';
        
        return account;
    }   
	//added by John for Bulk creation of Contacts, Accounts, Cases DA for INT Countries (Here we took just Belgium Case)
    public static List<Contact> createMultipleContacts(Integer numberOfContacts){
        List<Contact> contactListToInsert = new List<Contact>();
        Contact testContact = new Contact();
        for(Integer i = 0; i < numberOfContacts; i++)
        {
            testContact = Utils_TestMethods.CreateContact('Contact Test');
            contactListToInsert.add(testContact);
        }
        return contactListToInsert;
    }
    public static List<Account> createMultipleDAIntAccounts(Integer numberOfAccounts, List<Contact> contactsListInserted){
        Map<String, Association_Record_Type_et_pays__mdt> mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        //Query associationRTPaysList
        List< Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id , MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                             FROM Association_Record_Type_et_pays__mdt];
        mapOfInfoRTCongeIndispo = new Map<String, Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord : associationRTPaysList)
        {
            mapOfInfoRTCongeIndispo.put(mdtRecord.MasterLabel, mdtRecord);
        }
        List<Account> accountListToUpdate = new List<Account>();
        Account testAccount = new Account();
        Map<Integer, Contact> mapOfContacts = new Map<Integer, Contact>();
        Integer count = 0;
        for(Contact contactToAssign : contactsListInserted)
        {
            mapOfContacts.put(count, contactToAssign);
            count ++;
        }
        for(Integer i = 0; i < numberOfAccounts; i++)
        {
            testAccount= Utils_TestMethods.CreateAccount(mapOfContacts.get(i), null, 'Test Account');
            testAccount.recordTypeID = mapOfInfoRTCongeIndispo.get('Belgium').ID_suivi_CO__c;
            testAccount.Etat__c = '0';
            testAccount.BillingCountry ='Belgium';
            testAccount.ShippingCountry ='Belgium';
            testAccount.ShippingPostalCode ='1234';
            testAccount.BillingPostalCode ='1234';
            testAccount.BillingCountryCode = 'BE';
            testAccount.ShippingCountryCode ='BE';
            testAccount.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
            testAccount.Operateur_Global__c = 'DPD_BNL';
            testAccount.type = '3';
            accountListToUpdate.add(testAccount);
        }
        return accountListToUpdate;
    }
    public static List<Case> createMultipleDAIntCases(Integer numberOfCases, Macroprofil__c macroprofilInserted, List<Account> accountsListInserted){
        List<Case> caseListToInsert = new List<Case>();
        Case testCase = new Case();
        Map<Integer, ID> mapOfAccounts = new Map<Integer, ID>();
        Integer count = 0;
        for(Account accountToAssign : accountsListInserted)
        {
            mapOfAccounts.put(count, accountToAssign.id);
            count ++;
        }
        for(Integer i = 0; i < numberOfCases; i++)
        {
            testCase = Utils_TestMethods.createRequete('1', macroprofilInserted.id);
            testCase.RecordTypeId = Label.DA_RequeteRecrodTypeDAId_BNL;
            testCase.AccountId = mapOfAccounts.get(i);
            testCase.Traitement_interrompu__c= false;
            testCase.Planifier_un_rappel__c= false;
            testCase.Date_de_rappel_planifiee__c = null;
            caseListToInsert.add(testCase);
        }
        return caseListToInsert;
    }
        
}