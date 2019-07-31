// Tests for MassDeleteExtension
@isTest
private class MassUpdateExtensionTest {
    static testMethod void testUpdateRecords() {
		User Owner = Utils_TestMethods.createUser('test','y','test.test@pickup.dev','test@test.com');
        insert Owner;
        Contact testContact = Utils_TestMethods.CreateContact('Name');
        insert testContact; 
        Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account');
        insert account1;
        List<Case> cases = new List<Case>();
        Case case1 = Utils_TestMethods.createRequete('en attente d\'attribution',null);
        case1.AccountId =account1.id; 
        cases.add(case1);
        Case case2 = Utils_TestMethods.createRequete('en attente d\'attribution', null);
        case2.AccountId =account1.id; 
        cases.add(case2);
        insert cases;
        Case case3 = Utils_TestMethods.createRequete('en attente d\'attribution', null);
        case3.AccountId =account1.id; 
        case3.OwnerId = owner.Id;
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(cases );
        MassUpdateExtension extension = new MassUpdateExtension (sc);
        extension.caseTogetOwner = case3;
		sc.setSelected(cases);
        System.assertNotEquals(null, extension.updateRecords());
    }

}