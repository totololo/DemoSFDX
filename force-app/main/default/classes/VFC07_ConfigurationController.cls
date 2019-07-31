/*
* Author: John Boutros
* Modified By: -
* Date : 06/12/2017
* Description: Ouvrir une page VP et remplir le champ Configuration, puis copier l'ancien objet Configuration (si il y en a un)
* dans Configuration Site et copier l'object Configuration Locker Type Casier Site.
* Test classe: VFC07_Configuration_TEST
Coverage : 100%
*/
public class VFC07_ConfigurationController {
    public boolean displayPopup {get; set;}     
    public String accountID{get; set;}
    public Account thisAccount {get; set;}
    public PageReference pageRef;
    public string error {get;set;}
    
    public VFC07_ConfigurationController(ApexPages.StandardController controller) {
        accountID = ApexPages.currentPage().getParameters().get('id'); 
        thisAccount = (Account)controller.getRecord();
        displayPopup = true;    
    }
    //Method created to update the configuation__c on the Account Object and return to the account's record
    public PageReference save() {
        displayPopup = true;   
        pageRef = new PageReference('/'+accountID);
        if(accountID != null)
        {
            try {
                thisaccount.Recopie_Configuration__c = true;
                update thisaccount;
                return pageRef;
            } catch(exception e) {
                error = e.getMessage();
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
        return null;
    }
    //Method created to close the popup and return to the account's record
    public PageReference closePopup() {     
        pageRef = new PageReference('/'+thisAccount.Id);
        displayPopup = false;   
        return pageRef;
    }       
    //Method created to copy Configuration__c to Configuration_Site__c
    //and Configuration_Locker_Type__c &  Type_de_casier__c to Casier_Site__c
    
}