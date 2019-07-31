/*
* @author: Lea Zoghbi
* @date: 05/01/2017
*/
@isTest
private class AP06_MacroprofilReseau_Test {
    static testMethod void InsertUpdateReseauAssocieTest() {
        
        //Create Macroprofil
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('Macroprofil');
        Macroprofil__c mp2 = Utils_TestMethods.CreateMacroprofil('mp2');
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
        
        insert macroReseau;
        
        //create Reseau Service
        Reseau_Service__c reseauService = Utils_TestMethods.CreateReseauService(reseau.Id, service.Id);
        insert reseauService;
         
        //create Reseau Transporteur
        Reseau_Transporteur__c reseauTransporteur = Utils_TestMethods.CreateReseauTransporteur(reseau.Id, transporteur.Id);
        insert reseauTransporteur;
        
        //create account record
        Account pudo = Utils_TestMethods.CreateAccount(null, macroprofil, 'PUDO 1');
        pudo.Macroprofil_de_reference__c = macroprofil.Id;
        insert pudo;
         
        test.startTest();
        Macroprofil_Reseau__c macroReseau_FT = Utils_TestMethods.CreateMacroprofilReseau(macroprofil.Id, res_ft.Id);
        insert macroReseau_FT;
        List<Macroprofil_Reseau__c> listMacroprofilReseau = new List<Macroprofil_Reseau__c>{macroReseau_FT}; 
        Utils_PUS.firstAllRun = false;
        AP06_MacroprofilReseau.InsertUpdateReseauAssocie(listMacroprofilReseau);
        
        
        macroReseau_FT.Active__c = false;
        update macroReseau_FT;
        
        test.stopTest();
    }
}