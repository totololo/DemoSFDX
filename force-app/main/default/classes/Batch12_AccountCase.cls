global class Batch12_AccountCase Implements Database.batchable<sobject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {        
        UpdateUser(true, Label.BatchBypass);
        return Database.getQueryLocator([SELECT id,RecordTypeId,ShippingCountry,Etat__c,Type , Contact_operationnel_1__c
                                         FROM Account 
                                         WHERE((Etat__c = '4' or Etat__c = '5') and shippingCountry = 'France')]);       
    }
    
    global  void execute(Database.BatchableContext BC,List<Account> scope)
    {     
        AP07_Account.CreateCase(scope);
    }
    
    global void finish(Database.BatchableContext BC)
    {   
        UpdateUser(false, '');
    }
    
    private void UpdateUser(Boolean BypassworkflowProcessVR,String BypassTrigger){
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassWorkflow__c, BypassApex__c, BypassValidationRule__c
                            from User
                            where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = BypassworkflowProcessVR;
        currentUser.BypassWorkflow__c = BypassworkflowProcessVR;
        currentUser.BypassValidationRule__c = BypassworkflowProcessVR;
        currentUser.BypassApex__c = BypassTrigger;
        update currentUser;
    }
}