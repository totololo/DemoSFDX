/* Author       : Georges Hobeika
* Date          : 2017-03-21
* Description   : This class is created to set the field : tech_Locale_side_key on the user which is used to define the format of a date.
*/

public class AP01_User {
    
    public static void updateUserTechLocaleSidKey(List<User> lstNewUsers , Map<Id, User> mapOldUsers) {
        User oldUser = null;
        for(User user : lstNewUsers) {
            
            if(mapOldUsers != null) {
                oldUser = mapOldUsers.get(user.Id);
            }
            
            if(mapOldUsers == null || (user.LocaleSidKey != oldUser.LocaleSidKey)) {
                user.Tech_Locale_Sid_Key__c = user.LocaleSidKey;
            }
               
        }        
    }
}