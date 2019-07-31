global class Batch07_UpdateTypeDevice implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        User currentUser = [Select Id , BypassValidationRule__c
                            from User 
                            where Id=: UserInfo.getUserId()];
        currentUser.BypassValidationRule__c = true;
        update currentUser;
        String querySTMT ='SELECT id, Type_de_device__c, Type_de_device_Selected__c FROM Account ';
        querySTMT += 'WHERE Type_de_device_Selected__c = null AND Type_de_device__c != null ';
        return Database.getQueryLocator(querySTMT);
    }
    global void execute(Database.BatchableContext info, List<Account> scope){
        List <Account> accountToUpdate = new List<Account>();
        List<String> typeDeDeviceList = new List<String>();
        for(Account accountObject: scope){
            typeDeDeviceList= accountObject.Type_de_device__c.split(';');
            accountObject.Type_de_device_Selected__c = typeDeDeviceList.size();
            accountToUpdate.add(accountObject);
        }
        update accountToUpdate;
    }
    global void finish(Database.BatchableContext info){
        
    }
}