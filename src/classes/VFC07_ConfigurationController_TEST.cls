@isTest
public class VFC07_ConfigurationController_TEST {
    static testMethod void testConfiguration() {
        {
            Macroprofil__c newMacroprofil= Utils_TestMethods.CreateMacroprofil('MPFR_Consigne');
            insert newMacroprofil;
            
            Configuration__c newConfig = Utils_TestMethods.createConfiguration('Configuration Name');
            insert newConfig;
            
            Type_de_casier__c newTypeCasier = Utils_TestMethods.createTypeCasierKEBA('Type casier');
            insert newTypeCasier;
            
            Configuration_Locker_Type__c newConfigLockType = Utils_TestMethods.createConfigurationLockerType(newConfig.id, newTypeCasier.id);
            insert newConfigLockType;
            
            //Create Custom Settings
            CountriesSequence__c cs = new CountriesSequence__c(Name='France' , Sequence__c = 'FR00001');
            insert cs;
            
            COntact cont1 = Utils_TestMethods.CreateContact('Test contact');
            insert cont1;
            
            Account acc2 = Utils_TestMethods.CreateAccount(cont1, newMacroprofil ,'Account name');
            insert acc2;
            
            acc2.Configuration__c = newConfig.id;
            update acc2;
          
            ApexPages.StandardController ctlr = new ApexPages.StandardController(acc2);
            VFC07_ConfigurationCOntroller controller = new VFC07_ConfigurationCOntroller(ctlr);
            controller.closePopup();
            try{
                
                controller.save();
            }
            catch (exception e){
                system.debug('exception');
            }
            controller.accountID = acc2.Id;
            controller.save();
            
            controller.accountID = '1234567891234';
            controller.save();
        }
    }
}