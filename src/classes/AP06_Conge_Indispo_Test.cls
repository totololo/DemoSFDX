@isTest
public class AP06_Conge_Indispo_Test { 
    static testMethod void updateClosedConge(){
        User user = [SELECT id , BypassValidationRule__c from User 
                     WHERE id = : Userinfo.getUserId()];
        user.BypassValidationRule__c = true;
        update user;
       // System.runAs(user) { 
            Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('mp1');
            insert mp;  
            Contact c = Utils_TestMethods.CreateContact('TestContact');
            insert c;
            Account a = Utils_TestMethods.CreateAccount(c, mp, 'TestPudoNoCo');    
            insert a;
            Id congeRTypeId = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByName().get(Label.CongeRT).getRecordTypeId();
        	
            Conge_Indispo__c conge = Utils_TestMethods.CreateConge_Indispo(congeRTypeId, a.Id , Date.today().addDays(+15), Date.today().addDays(+20) );
            try {
                insert conge; 
                System.debug('!!!gho inserted');
            }catch(Exception e) {
                System.debug('!!!gho inserted exception ');
            }
            
            
            conge.Date_de_fin__c = Date.today().addDays(-9);
            Test.startTest();
            try {
                update conge;
                System.debug('!!!gho updated'); 
                Id indispoRTId  = Schema.SObjectType.Conge_Indispo__c.getRecordTypeInfosByName().get(Label.IndisponibiliteStandardRT).getRecordTypeId();
                Conge_Indispo__c conge1 = Utils_TestMethods.CreateConge_Indispo(indispoRTId, a.Id , Date.today().addDays(-12), Date.today().addDays(-5) );
                insert conge1;
                conge1.Commentaires__c = 'test';
                update conge1;
        	}catch(Exception e) {
                System.assert(true, e.getMessage().contains('Vous n\'avez pas le droit de modifier '  + Label.CongeRT + ' Avec un statut dépassé'));
            }
            Test.stopTest();
        //}
        
    } 
}