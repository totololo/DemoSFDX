/*--------------------------------------------------------------------------------------------------------------------------
Author: Fadi Tannoury
Company: Ei-Technologies Lebanon
Description: Controller for C01_EmailTemplate
History
2018-06-05  Fadi Tannoury	  Creation
--------------------------------------------------------------------------------------------------------------------------*/

public class C01_EmailTemplate_CRR_Controller {
     
    public Compte_rendu_rempli__c CompteRenduRempli {get; set;}
    public List<Reponse_CR__c> listReponses;
    public String HeaderUrl {set;}
    public String FooterUrl {set;}
    public String OrgId {get;set;}
    
    public C01_EmailTemplate_CRR_Controller() {
       OrgId = [SELECT id, Name FROM Organization].Id;      
    }
    
    public string getHeaderUrl(){
        
        String HeaderUrl = '';
        String DevName = !Test.isRunningTest() ? 'Header_EmailTemplate' : 'HeaderTest';
        List<Document> Header = [SELECT Id, DeveloperName FROM Document WHERE DeveloperName = :DevName LIMIT 1]; 
        if(Header.size()>0){
            HeaderUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + Header[0].Id + '&oid=' + OrgId;
        }
        return HeaderUrl;
    }
    
    public string getFooterUrl(){
        
        String FooterUrl = '';
        String DevName = !Test.isRunningTest() ? 'Footer_EmailTemplate' : 'FooterTest';
        List<Document> Footer = [SELECT Id, DeveloperName FROM Document WHERE DeveloperName = :DevName LIMIT 1];
        if(Footer.size()>0){
            FooterUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + Footer[0].Id + '&oid=' + OrgId;
        }
        return FooterUrl;
    }

    public void setListReponses(List<Reponse_CR__c> lst){
        listReponses = lst;
    }
    
    public List<Reponse_CR__c> getListReponses(){
        
        system.debug('CompteRenduRempli: ' + CompteRenduRempli);

        List<Reponse_CR__c> lstRep = [SELECT Id, Name, Compte_rendu_rempli__c, Question__c, Reponse__c, Type_de_r_ponse__c, 
                                      Questions_CR__r.Tech_Question_Order__c, Questions_CR__r.Options_de_reponses__c
                                      FROM Reponse_CR__c
                                      WHERE Compte_rendu_rempli__c = :CompteRenduRempli.Id];
        system.debug('lstRep: '+lstRep);
            return lstRep;
        
    }

}