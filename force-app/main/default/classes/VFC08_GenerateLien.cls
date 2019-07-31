public class VFC08_GenerateLien {
    
    public Account acct{get;set;}
    
    public String  message{get;set;}
    public boolean success{get;set;}
    public boolean isSF1{get;set;}
    
    public VFC08_GenerateLien(ApexPages.StandardController stdController) { 
        this.acct = (Account) stdController.getRecord(); 
        isSF1 = isSalesforce1();
    }
    
    public PageReference sendEmailRM() {  
        String email = this.acct.Nom_Responsable_magasin__r.Email; 
        if(email == null || email.length() == 0 ) {
            this.success = false;
            this.message = System.Label.Lien_Android_No_Email;
        } else {
            sendMail2(email); 
        }
        
        return null;
    }
    
    public PageReference sendEmailCU() {
        String email = UserInfo.getUserEmail(); 
        sendMail2(email);
        return null;
    }
    //method sendMail2
    private void sendMail2(String email) { 
        String identifiantAndroid = this.acct.Identifiant_android_du_Pudo__c;
        if(identifiantAndroid == null || identifiantAndroid.length() == 0) {
            this.success = false;
            this.message = System.Label.Lien_Android_Fill_Identifiant_android_du_Pudo;
        } else {
            String result2 = Manager_GenerateLienAndroid2.sendUserCreationMessage(email,identifiantAndroid);
            system.debug(result2);
            this.success = true;
            this.message = result2;
        } 
    }
    public void sendEmailTest(){
        String email = this.acct.Nom_Responsable_magasin__r.Email; 
        sendMail(email);
    }
    private void sendMail(String email) { 
        String reference = this.acct.Reference_internationale__c;
        if(reference == null || reference.length() == 0) {
            this.success = false;
            this.message = System.Label.Lien_Android_Fill_Reference_Internationale;
            
        } else {
            String result = Manager_GenerateLienAndroid.sendUserCreationMessage(email,reference);
            system.debug(result);
            
            if(result.equals(System.Label.Lien_Android_User_Not_Found)) {
                this.success = false;
                this.message = System.Label.Lien_Android_User_Not_Found_Response;
            } else if(result.equals(System.Label.Lien_Android_OK)) {
                this.success = true;
                this.message = System.Label.Lien_Android_Email_Sent;
            }
        } 
    }
    //Added by Amal Chreiteh on 22/09/2017
    public static Boolean isSalesforce1(){
       if (String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost'))||
                        String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin'))||
                        ApexPages.currentPage().getParameters().get('isdtp')== 'p1'||
                        (ApexPages.currentPage().getParameters().get('retURL')!= null &&
                        ApexPages.currentPage().getParameters().get('retURL').contains('projectone')))
                    {
            return true;
        }else{
            return false;
        }
    }
    public PageReference GoToAccountPage(){
       if (acct != null)
           {
            return new PageReference ('/'+ acct.Id);
        }else{
            return null;
        }
    }
    
}