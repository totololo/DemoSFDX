@isTest
public class WS_GenerateLienAndroid2_Test {
    
     static testMethod void test_GenerateLienAndroid2() {
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockGenerateLienAnroidGenerator('Success'));
        String resSuccess =  WS_GenerateLienAndroid2.SendUserCreationMessage('test@test.com', 'FR43033@pickup.com');
        system.assert(resSuccess.contains(System.Label.Lien_Android_Email_Sent));
        Test.setMock(HttpCalloutMock.class, new MockGenerateLienAnroidGenerator('NotFound'));
        String resNotFound =  WS_GenerateLienAndroid2.SendUserCreationMessage('test@test.com', 'FR43033@pudo.dev.pickup'); 
        system.assert(resNotFound.contains(System.Label.Lien_Android_User_Not_Found_Response));
        Test.setMock(HttpCalloutMock.class, new MockGenerateLienAnroidGenerator('404'));
        String resError =  WS_GenerateLienAndroid2.SendUserCreationMessage('test@test.com', 'FR43033@pickup.com'); 
        system.assert(resError.contains(Label.Unreachable_WS));
        test.stopTest();
         
    }

}