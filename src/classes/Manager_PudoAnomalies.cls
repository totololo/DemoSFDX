/*
* Interface between Salesforce and the external webservice PUS_Anomalie
* @author: Georges Hobeika
* @date: 31/03/2017
* @Test: Manager_PudoAnomalies_Test
*/

public class Manager_PudoAnomalies {
	
    private HttpRequest req;
    private Http http;
    private HttpResponse res;
        
    
    public String getPudoAnomaliesCount(String strReferenceInternational) {
        String strResponse;
        http = new Http();
        req = new HttpRequest();
        if(strReferenceInternational != null && strReferenceInternational.length() > 0) {
            String strPath = '/anomalies/pudo/' + strReferenceInternational; 
            
            req.setEndpoint('callout:PUS_Anomalie' + strPath); 
            req.setTimeout(30000);
            req.setMethod('GET');  
            try {
                res = http.send(req);    
                if (res.getStatusCode() == 200) {  
                    strResponse = res.getBody(); 
                    strResponse = strResponse.substring(strResponse.indexOf(':') + 1 , strResponse.length() - 1); 
                    
                } else {
                    if(res.getBody().contains('Pudo not found')) {
                        strResponse = Label.Colis_Not_Found;
                    } else {
                        strResponse = Label.Anomalie_KO;
                    }
                   
                }
            }catch(Exception e) { 
                strResponse = Label.Anomalie_KO;
            }
           
        } 
        return strResponse;
    }
     
}