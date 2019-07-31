@isTest
public class AP03_Account_TEST {
	static testMethod void testCheckTypeDeDevice() {
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
        //Create Account
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account');
        account1.Type_de_device__c = 'PDA Android;PDA Windows';
        try{
            insert account1;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        account1.Type_de_device__c = 'BYOD';
        try{
            update account1;
        } catch(DmlException e) {
            system.debug('DmlException e '+ e);
        }
        account1.Type_de_device__c = 'PDA Android;PDA Windows;BYOD';
        try{
            update account1;
        }
        catch(exception e){
            system.assert(e.getmessage().contains(Label.Type_de_device_Error));
        }
        account1.Type_de_device__c =null;
        try{
            update account1;
        }
        catch(exception e){
            system.assert(e.getmessage().contains(Label.Type_de_device_Error));
        }
    }
    
}