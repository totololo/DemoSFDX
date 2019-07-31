@isTest
public class AP12_Lead_TEST {
    static testmethod void test()
    {
        /*// retrieve ID of belgium
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id , MasterLabel,ID_Piste__c, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c
                                                                         FROM Association_Record_Type_et_pays__mdt
                                                                         Where MasterLabel ='Belgium'
                                                                         Limit 1];
        //Create Custom Settings country sequence
        CountriesSequence__c cs = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE0001');
        try{
            insert cs;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        try{
            insert testContact;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        //Create lead France
        Lead lead1= Utils_TestMethods.createLead('firstName', 'lastName', 'company', 'Non');
        lead1.RecordTypeId = Label.RT_Prospect_France;
        lead1.Country__c ='France';
        lead1.CountryCode = 'FR';
        lead1.Postal_Code__c = '12345';
        insert lead1;
        lead1.Country__c ='Belgium';
        lead1.CountryCode='BE';
        // update lead and enter error
        //try{
        //    update lead1;
        //} catch(DmlException e) {
         //   system.assert(e.getMessage().contains(Label.Pays_TypeEnregistrment) );
        //}
        //Create lead BNL
        Lead lead2= Utils_TestMethods.createLead('firstName1', 'lastName1', 'company1', 'Non');
        lead2.RecordTypeId = associationRTPays[0].ID_Piste__c;
        lead2.Country__c ='Belgium';
        lead2.CountryCode='BE';
        lead2.Industry ='227';
        lead2.Activite_commerciale_principale__c = '2175';
        insert lead2;
        // update lead and enter error
        try{
            lead2.Country__c='France';
            lead2.CountryCode ='FR';
            update lead2;
        } catch(DmlException e) {
            system.assert(e.getMessage().contains(Label.Pays_TypeEnregistrment) );
        }
        //Create lead France and enter error
        Lead lead3= Utils_TestMethods.createLead('firstName2', 'lastName2', 'company2', 'Non');
        lead3.RecordTypeId = Label.RT_Prospect_France;
        lead3.Country__c ='Belgium';
        lead3.CountryCode='BE';
        try{
            insert lead3;
        } catch(DmlException e) {
            system.assert(e.getMessage().contains(Label.Pays_TypeEnregistrment) );
        }
        //Create lead BNL
        Lead lead4= Utils_TestMethods.createLead('firstName3', 'lastName3', 'company3', 'Non');
        lead4.RecordTypeId = associationRTPays[0].ID_Piste__c;
        lead4.Activite_commerciale_principale__c =null;
        lead4.Country__c ='France';
        lead4.CountryCode ='FR';
        try{
            insert lead4;
        } catch(DmlException e) {
            system.debug('e.getMessage() '+e.getMessage());
            system.assert(e.getMessage().contains(Label.Pays_TypeEnregistrment) );
        }*/
    }
}