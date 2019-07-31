/*
* Interface between the webservice and the controller that syncs the last status of an account devices
* @author: Georges Hobeika
* @date: 13/02/2017
* @Test: Manager_PudoDevicesSynchro_Test
*/

public class Manager_PudoDevicesSynchro {
    
    public static HttpResponse syncDevices(String internationalSiteId , integer numberOfLinesPerDevice ) { 
        String url = 'callout:PUS/SynchroHybride/synchronizations/search?internationalSiteId=' + internationalSiteId  + '&numberOfLinesPerDevice=' + numberOfLinesPerDevice ;
        HttpRequest  req = new HttpRequest();
        HTTPResponse res = null;  
        req.setEndpoint(url);
        req.setMethod('GET'); 
        Http http = new Http(); 
        if(req != null) {
            try {
                res = http.send(req);  
            }catch(Exception e){ 
            } 
        }   
        return res;
    }
}