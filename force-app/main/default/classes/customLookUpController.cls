public class customLookUpController {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String AccountID) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        ObjectName = 'Contact';
        List < sObject > returnList = new List < sObject > ();
       	//modified by John
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 4   
        String sQuery = 'select id, Name ' 
						+ 'from Contact '
						+ 'where Name LIKE: searchKey '
            			+ 'AND AccountId =: AccountID '
						+ 'order by name '
            			+ 'LIMIT 4';
        //String sQuery =  'select id, Name, Contact_operationnel__c from ' +ObjectName + ' where Name LIKE: searchKey And Contact_operationnel__c order by name DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
       	system.debug('JMB customLookUpController lstOfRecords ' + lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    //added by John to retrieve contact Name
    @AuraEnabled
    public static String getContactNameApex(String ContactID)
    {
        List<Contact> retrieveContact = [Select id, Name
                                         From Contact
                                         Where id =: ContactID];
        String contactName = '';
        for(Contact contactRecord : retrieveContact)
        {
            contactName = contactRecord.Name;
        }
        return contactName;
    }
}