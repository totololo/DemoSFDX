public class Manager_GenerateLienAndroid {

    public static String sendUserCreationMessage(String email,String username) {
        WS_GenerateLienAndroid.BasicHttpBinding_IUserManagement wsInstance = new WS_GenerateLienAndroid.BasicHttpBinding_IUserManagement();
        return wsInstance.SendUserCreationMessage(email,true,username);
    } 
}