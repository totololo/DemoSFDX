public class VFC01_PageRedirect {
    
    public boolean isValidReferenceNumber {get;set;}
    public String strErrorMessage {get;set;}
    public String vfReferenceInt {get;set;} 
    
    public PageReference redirect() { 
        String referenceNumber = '';
        isValidReferenceNumber = true;
        PageReference pr = null; 
        
        if(vfReferenceInt != null && vfReferenceInt.length() > 0) {
            referenceNumber = vfReferenceInt;
        } else {
            referenceNumber = ApexPages.currentPage().getParameters().get('ref');
        }
        
        if(referenceNumber == null || referenceNumber.length() == 0) {
            strErrorMessage = Label.Empty_Reference_Number;
            isValidReferenceNumber = false;
        }
        
        // check the availability of the account if any ref is sent
        if(isValidReferenceNumber) {
            List<Account> accountList = [SELECT Id,operateur_global__c FROM Account WHERE Reference_internationale__c =: referenceNumber OR Reference__c =: referenceNumber];
            if(accountList.size() >0)   {
                String accountId = accountList[0].Id;
                String accountOperateur = accountList[0].operateur_global__c;
                /*if(accountOperateur == 'PUS_FR'){   
                    pr = new PageReference('/console#%2F'+accountId);
                }
                else{*/
                    pr = new PageReference('/lightning/r/Account/'+accountId+'/view');
                //}
                
            } else {
                strErrorMessage = System.Label.Invalid_International_Reference + ' : ' + referenceNumber;
            }    
        } 
        return pr;
    }  
}