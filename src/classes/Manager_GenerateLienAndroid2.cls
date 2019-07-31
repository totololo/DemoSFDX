public class Manager_GenerateLienAndroid2 {
    public static String sendUserCreationMessage(String email,String identifiantAndroid) {
        if(!test.isRunningTest()){
            return WS_GenerateLienAndroid2.SendUserCreationMessage(email,identifiantAndroid); 
     }
       else{
            return null;
        }
    }
}