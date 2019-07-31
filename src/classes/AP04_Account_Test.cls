/*
* @author: Lea Zoghbi
* @date: 20/12/2016
*/
@isTest
private class AP04_Account_Test {
    static testMethod void runPositiveTestCases() {
        
        // Object Account contains a lot of validation rules 
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
		currentUser.BypassValidationRule__c = true;
        update currentUser;
        
        
        //Create Macroprofil
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('Macroprofil');
        Macroprofil__c mp2 = Utils_TestMethods.CreateMacroprofil('mp2');
        //TMA JSA 
        mp2.Name='MPFR_Consigne';
        insert new list<Macroprofil__c> {macroprofil, mp2};
            
        //Create Service
        Service__c service = Utils_TestMethods.CreateService('Service');
        insert service;
        
        //Create Transporteur
        Transporteur__c transporteur = Utils_TestMethods.CreateTransporteur('Transporteur');
        insert transporteur;
        
        //Create Reseau
        Reseau__c reseau = Utils_TestMethods.CreateReseau('Reseau');
        Reseau__c res_ft = Utils_TestMethods.CreateReseau('res_ft');
        insert new list<Reseau__c>{reseau, res_ft};
            
        //Create Macroprofil Service
        Macroprofil_Service__c macroService = Utils_TestMethods.CreateMacroprofilService(macroprofil, service);
        macroService.Active__c = true;
        macroService.Modifiable__c = true;
        Macroprofil_Service__c macroServiceMP2 = Utils_TestMethods.CreateMacroprofilService(mp2, service);
        macroServiceMP2.Active__c = true;
        macroServiceMP2.Modifiable__c = true;
        insert new list<Macroprofil_Service__c> {macroService, macroServiceMP2};
            
        //Create Macroprofil Transporteur
        Macroprofil_Transporteur__c macroTransporteur = Utils_TestMethods.CreateMacroprofilTransporteur(macroprofil, transporteur);
        macroTransporteur.Active__c = true;
        macroTransporteur.Modifiable__c = true;
        insert macroTransporteur;
        
        //Create Macroprofil Reseau
        Macroprofil_Reseau__c macroReseau = Utils_TestMethods.CreateMacroprofilReseau(macroprofil.Id, reseau.Id);
        Macroprofil_Reseau__c macroReseau_FT = Utils_TestMethods.CreateMacroprofilReseau(macroprofil.Id, res_ft.Id);
        insert new list<Macroprofil_Reseau__c> {macroReseau, macroReseau_FT};
            
        //create Reseau Service
        Reseau_Service__c reseauService = Utils_TestMethods.CreateReseauService(reseau.Id, service.Id);
        insert reseauService;
        
        //create Reseau Transporteur
        Reseau_Transporteur__c reseauTransporteur = Utils_TestMethods.CreateReseauTransporteur(reseau.Id, transporteur.Id);
        insert reseauTransporteur;
        
        //create account record
        Account pudo = Utils_TestMethods.CreateAccount(null, macroprofil, 'PUDO 1');
        pudo.Macroprofil_de_reference__c = macroprofil.Id;
        Account pudo_ft = Utils_TestMethods.CreateAccount(null, mp2, 'PUDO 1');
        pudo_ft.Macroprofil_de_reference__c = mp2.Id;
        
        insert new list<Account>{pudo, pudo_ft};
            
        list<Reseau_Associe__c> listRACreated = [ select id
                                                     from Reseau_Associe__c];
        
       // system.assertEquals(2, listRACreated.size());
        
        
        
        //reseau no longer valid
        // Commented By gho : 04/04/2017
        // this functionnality has been modified by Dany Rouss
        // Reseau-Associe is modified through batched and not trigger
        
        pudo.Industry = 'Auto, Moto';
        pudo.Type = '124';
        //pudo.Partenaire__c = 'Casino';
        pudo.Horaire_Ouverture_Reference__c = '07:30';
        pudo.Horaire_Fermeture_Reference__c = '17:00';
        pudo.Poids_maximal_accepte_par_colis__c = '30'; 
        //TMA JSA 
          pudo.Macroprofil_actuel__c=mp2.id;
          pudo.Type='20';
        
        update pudo;
        
        reseau.Domaine_d_activite__c = '4';
        reseau.Type_de_point__c = '22';
        reseau.Partenaire__c = '4';
        reseau.Horaire_d_ouverture_de_reference__c = '06:30';
        reseau.Horaire_de_fermeture_de_reference__c = '18:00';
        reseau.Poidsmaxacceptparcolis__c = '20';
        update reseau;
        
        list<Reseau_Associe__c> listRAUpdated = [ select id
                                                 from Reseau_Associe__c
                                                 where Active__c = true];
        test.startTest();
      //  system.assertEquals(2, listRAUpdated.size());
        Macroprofil_Service__c mps = [select id, Active__c
                                      from Macroprofil_Service__c
                                      where id = : macroService.Id];
        
        mps.Active__c = false;
        update mps;
        
        
        
        macroReseau.Active__c = true;
        update macroReseau;
        
        Macroprofil_Reseau__c macroReseauUpdated = [ select Id, Active__c
                                                    from Macroprofil_Reseau__c
                                                    where id = : macroReseau.Id];
        system.assertEquals(true, macroReseauUpdated.Active__c);
        
        macroService.Active__c = false;
        update macroService;
        
        macroTransporteur.Active__c = false;
        update macroTransporteur;
        integer  count= database.countQuery('select count() from account');
        
        system.debug('the count is '+ count);
        test.stopTest();
    }
}