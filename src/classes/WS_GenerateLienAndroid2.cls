public class WS_GenerateLienAndroid2 {
    
    
    public static string SendUserCreationMessage(String Email,String lienAndroid) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Login_Android' + '//api/User/SendCreationMessage');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setMethod('POST');
        request.setBody('Username='+lienAndroid+'&Email='+Email);
        request.setTimeout(100000);
        HttpResponse response = http.send(request);
        
        if(response == null) {
            return Label.Unreachable_WS;
        }
        else{
            Integer statusCode = response.getStatusCode();
            system.debug('statusCode'+ statusCode);
            if(statusCode ==200 ){
                return System.Label.Lien_Android_Email_Sent;
            }
            else if(response.getStatusCode() == 500) 
            {
                return System.Label.Lien_Android_User_Not_Found_Response;  
            }
            
            else{ 
                return Label.Unreachable_WS;
            }
        }
    }
    
    
}