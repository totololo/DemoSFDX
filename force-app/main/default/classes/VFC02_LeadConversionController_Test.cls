@isTest
public class VFC02_LeadConversionController_Test {
    public static  testmethod void  convertLeads()
    {  
		// retrieve ID of belgium
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel,ID_Piste__c, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];        
        //Create Custom Settings
        CountriesSequence__c cs = new CountriesSequence__c(Name='France' , Sequence__c = 'FR00001');
        insert cs;
        CountriesSequence__c cs1 = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE00001');
        insert cs1;
        
        Lead lead1 = Utils_TestMethods.createLead('Georges','Hobeika','EI-Technologies','Qualifie');
        lead1.Postal_Code__c = '77777';
        lead1.RecordTypeId = Label.RT_Prospect_France;
        //lead1.Activite_commerciale_principale__c=null;
        insert lead1;
        ApexPages.StandardController sc = new ApexPages.StandardController(lead1); 
        VFC02_LeadConversionController leadController = new VFC02_LeadConversionController(sc);  
        Lead lead2 = Utils_TestMethods.createLead('John','Boutros','EI-Technologies','Qualifie');
        lead2.Postal_Code__c = '77777';
        lead2.RecordTypeId = associationRTPays[0].ID_Piste__c;
        lead2.Activite_commerciale_principale__c='2168';
        lead2.Status    =  null; 
        lead2.Country__c   = 'Belgium'; 
        lead2.Industry = '226';
        lead2.Postal_Code__c = '1234';
        insert lead2;
        ApexPages.StandardController sc1 = new ApexPages.StandardController(lead2); 
        VFC02_LeadConversionController leadController1 = new VFC02_LeadConversionController(sc);  
        
        // convert the lead
        leadController.convertLeadAndRedirectToAccount();
        System.debug('###gho leadController.showLink ' +  leadController.showLink); 
        
        // convert the lead for the second time
        leadController.convertLeadAndRedirectToAccount();
        // System.assertEquals(true, leadController.showLink);
        
        Lead lead3 = Utils_TestMethods.createLead('John','Boutros','EI-Technologies','Qualifie');
        lead3.RecordTypeId = associationRTPays[0].ID_Piste__c;
        lead3.Country__c   = 'Belgium'; 
        lead3.Street__c    =  'lead street';
        lead3.Activite_commerciale_principale__c = null;
        lead3.Postal_Code__c ='1235';
        insert lead3;
        //lead3.Postal_Code__c ='1234';
        //update lead3;
        test.startTest(); 
        ApexPages.StandardController sc3 = new ApexPages.StandardController(lead3); 
        VFC02_LeadConversionController leadController3 = new VFC02_LeadConversionController(sc3); 
        leadController3.convertLeadAndRedirectToAccount();
        
        
        
        // redirect to the lead page 
        PageReference pageref = leadController.redirectToLead();
        // system.assertEquals('/' + lead1.Id, pageref.getUrl());
        //test.stopTest();
    }
    
}