/*
* Class to display the number of anomalies for each account
* @author: Georges Hobeika
* @date: 30/03/2017
* @Test: VFC06_PudoAnomalies_Test
*/

public class VFC06_PudoAnomalies {

    private Account account;
    
    public String anomalie{get;set;}
    public boolean showAnomalie{get;set;}
    public String link{get;set;}
    
    public VFC06_PudoAnomalies(ApexPages.StandardController stdController) {
        account = [Select Id , Reference_internationale__c
                   FROM Account
                   where Id = : stdController.getId()
                  ]; 
        showAnomalie = false;  
        
    }
    
    public PageReference getPudoAnomalies() { 
        showAnomalie = true;
		Manager_PudoAnomalies anomalieManager = new Manager_PudoAnomalies();
        String strResponseBody = anomalieManager.getPudoAnomaliesCount(account.Reference_internationale__c);
        link = '';
        if(strResponseBody != Label.Anomalie_KO) { 
            anomalie = strResponseBody;
            String orgId = UserInfo.getOrganizationId().substring(0,15); 
            if(account.Reference_internationale__c != null) { 
               /* if(orgId == Label.ID_UAT) { 
                   link =  Label.Colis_UAT + '/';
                } else if(orgId == Label.ID_PROD) {
                   link =  Label.Colis_PROD + '/';
                }else if(orgId == Label.ID_PREPROD) {
                    link = Label.Colis_PreProd + '/';
                }*/
                
                //if(orgId == Label.ID_ORG) { 
                   link =  Label.Colis_Org + '/';
                //}
                if(link.length() > 0) {
                    link += 'gestionanomalies.aspx?InternationalSiteId=' + account.Reference_internationale__c; 
                } 
            }
        } else {
            anomalie = Label.Anomalie_PasDeConnection; 
        }  
        return null;
    }
}