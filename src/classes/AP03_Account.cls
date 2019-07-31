public class AP03_Account {
	// contrôler le nombre de choix sélectionner (au nombre de 2 max)
    public static void checkTypeDeDevice(List<Account> newAccounts, Map<Id, Account> oldAccounts){
        
        for(Account newAccount : newAccounts)
        {
            //if updating
            if(oldAccounts!= null && oldAccounts.ContainsKey(newAccount.Id))
            {
                if(oldAccounts.get(newAccount.Id).Type_de_device__c != newAccount.Type_de_device__c)
                {
                    splittingTypeDeDevice(newAccount);
                }
            }
            // if inserting
            else 
            {
                splittingTypeDeDevice(newAccount);
            }
        }
    }
    public static void splittingTypeDeDevice(Account acc){
        if(acc.Type_de_device__c != null)
        {
            List<String> typeDeDeviceList = acc.Type_de_device__c.split(';');
            if(typeDeDeviceList.size() > 2)
            {
                acc.Type_de_device__c.addError(Label.Type_de_device_Error);
            }
            else
            {
                acc.Type_de_device_Selected__c = typeDeDeviceList.size();
            }
        }
        else
        {
            acc.Type_de_device_Selected__c = 0;
        }
    }
}