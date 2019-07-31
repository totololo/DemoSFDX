@isTest
public class AP01_User_Test {
 
    static testmethod void updateUserTechLocaleSidKey_Test() {
        User newUser = Utils_TestMethods.createUser('Georges', 'Hobeika', 'georges.hobeika@ei-technologies.com', 'georges.hobeika@ei-technologies.com');
        newUser.FirstName = 'Georges';
        newUser.LastName  = 'Hobeika';
        newUser.LocaleSidKey = 'fr_FR';
        newUser.Username = 'georges.hobeika@ei-technologie.com';
        newUser.Email = 'georges.hobeika@ei-technologie.com';
        newUser.Alias = 'gho';
        newUser.CommunityNickname = 'hobeika.georges';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.ProfileId = label.Profile_SystemAdmin;
        newUser.LanguageLocaleKey = 'fr';
        newUser.Operateur__c = 'PUS_FR';
        newUser.TimeZoneSidKey = 'Europe/Paris';
        insert newUser;
        
        User insertedUser = [Select id , tech_locale_sid_key__c
                             from User 
                             where id =: newUser.Id];
        System.assertEquals('fr_FR',insertedUser.Tech_Locale_Sid_Key__c);
        
        insertedUser.LocaleSidKey = 'en_CA';
        update insertedUser;
        
        User updatedUser = [Select id , tech_locale_sid_key__c
                            from User 
                            where id =: newUser.Id];
        System.assertEquals('en_CA',updatedUser.Tech_Locale_Sid_Key__c);
        
    }
}