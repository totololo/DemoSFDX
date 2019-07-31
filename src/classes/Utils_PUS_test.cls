/*
* @author: Lea Zoghbi
* @date: 20/12/2017
*/
@isTest
private class Utils_PUS_test {
    static testMethod void checksObjectNonModifiableTest() {
        //Create Macroprofil
        Macroprofil__c macroprofil = Utils_TestMethods.CreateMacroprofil('Macroprofil');
        insert macroprofil;
        
        //Create Service
        Service__c service = Utils_TestMethods.CreateService('Service');
        insert service;
        
        //Create Transporteur
        Transporteur__c transporteur = Utils_TestMethods.CreateTransporteur('Transporteur');
        insert transporteur;
        
        //Create Reseau
        Reseau__c reseau = Utils_TestMethods.CreateReseau('Reseau');
        insert reseau;
        
        //Create Macroprofil Service
        Macroprofil_Service__c macroService = Utils_TestMethods.CreateMacroprofilService(macroprofil, service);
        macroService.Active__c = true;
        macroService.Modifiable__c = false;
        insert macroService;
        
        //Create Macroprofil Transporteur
        Macroprofil_Transporteur__c macroTransporteur = Utils_TestMethods.CreateMacroprofilTransporteur(macroprofil, transporteur);
        macroTransporteur.Active__c = true;
        macroTransporteur.Modifiable__c = false;
        insert macroTransporteur;
        
        //Create Macroprofil Reseau
        Macroprofil_Reseau__c macroReseau = Utils_TestMethods.CreateMacroprofilReseau(macroprofil.Id, reseau.Id);
        macroReseau.Active__c = true;
        macroReseau.Modifiable__c = false;
        insert macroReseau;
        //create account record
        Account pudo = Utils_TestMethods.CreateAccount(null, macroprofil, 'PUDO 1');
        pudo.Macroprofil_de_reference__c = macroprofil.Id;
        insert pudo;
        
        test.startTest();
        Service_Associe__c sa = [select id, Active__C , Modifiable__c 
                                from Service_Associe__c limit 1];
        
        sa.Modifiable__c = false;
        sa.Active__c = false;
        try{
            update sa;
        }catch(Exception ex){
            system.assert(true, ex.getMessage().contains(Label.SERA_ErrorNonModifiable));
        }
        
        Transporteur_Associe__c ta = [select id, Active__C , Modifiable__c 
                                from Transporteur_Associe__c limit 1];
        
        ta.Modifiable__c = false;
        ta.Active__c = false;
        try{
            update ta;
        }catch(Exception ex){
            system.assert(true, ex.getMessage().contains(Label.TRAA_ErrorNonModifiable));
        }
        
        Reseau_Associe__c ra = [select id, Active__C , Modifiable__c 
                                from Reseau_Associe__c limit 1];
        
        ra.Modifiable__c = false;
        ra.Active__c = false;
        try{
            update ra;
        }catch(Exception ex){
            system.assert(true, ex.getMessage().contains(Label.RESA_ErrorNonModifiable));
        }
        
        test.stopTest();
    }
}