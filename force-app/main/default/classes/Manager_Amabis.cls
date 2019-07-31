/*
* Intermediate Class between the visual force page's extension and AMABIAS web service
* @author: Georges Hobeika
* @date: 16/02/2017
* @Test: Manager_Amabis_Test
*/

public class Manager_Amabis {
	
    // authentication key stored as label provided by AMABIAS
    private static String authenticationKey = Label.Amabis_Authentication_Key;
    
    public static rnvpiWebserviceRnvpiAmabisComXsd.rnvpiResponse validateAddress(String streetNumber , String street , String postalCode , String city , String codePays) {
        System.debug('###gho street : ' + street);
        rnvpiWebserviceRnvpiAmabisComXsd.rnvpiResponse resp = null;
        webserviceRnvpiAmabisCom.MainHttpsSoap11Endpoint amabisWebServiceInstance = new webserviceRnvpiAmabisCom.MainHttpsSoap11Endpoint();
        String address = streetNumber + '//' + street + '//' + postalCode + '//' + city;  
        String separ = '//'; 
        String pays = codePays; 
        String options = 'type=A,format=X,objets=ADR2/ADR3/ADR4/ADR5/ADR6/ADR7/LOCCP/LOCLIBDEST2/NUM1/BTQC1/LIBVOIE/ERRSTR/LADR/STATUT';
        String optionsGlobales = 'clef=' + authenticationKey; 
        try {
            system.debug('### in manager');
           resp = amabisWebServiceInstance.rnvpi(address, separ, pays, options, optionsGlobales); 
        }catch(Exception e) { 
            system.debug('### in catch manager ' + e.getMessage());
        }
        
        return resp;
    }
    
}