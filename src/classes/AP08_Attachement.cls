/*
* Class to toggle the flag on the account with allows it to enter the approval PB
* @author: Georges Hobeika
* @date: 03/02/2017
* @Test: AP08_Attachment_Test
*/

public class AP08_Attachement { 
   
    Map<Id, List<Attachment>> mapAttachments = new Map<Id, List<Attachment>>();
    Map<Id, List<ContentDocumentLink>> mapContentDocuments = new Map<Id, List<ContentDocumentLink>>();
    Map<Id ,Account> mapAccounts = new Map<Id, Account>();
    Set<Id> setAccountsIds = new Set<Id>();
    List<Account> lstAccountsToBeUpdated = new List<Account>();
    
    
    private void fillAccounts() {
       for(Account acc : [SELECT Id,Reference_internationale__c , Contrat_Joint__c
                          FROM Account
                          where Id IN : setAccountsIds]) 
       {
           if(!mapAccounts.containsKey(acc.Id)) {
               mapAccounts.put(acc.Id, acc);
           }               
       }
        
    }
    
    private void fillContentDocumentLinks() {  
          for(ContentDocumentLink contentDoc : [SELECT Id , ContentDocument.title , LinkedEntityId
                                                FROM ContentDocumentLink
                                                where LinkedEntityId IN : setAccountsIds]) 
          {  
              if(!mapContentDocuments.containsKey(contentDoc.LinkedEntityId)) {
                  mapContentDocuments.put(contentDoc.LinkedEntityId, new List<ContentDocumentLink>());
              }
              mapContentDocuments.get(contentDoc.LinkedEntityId).add(contentDoc);
          }  
    }
    
    private void fillAttachments() {
        for(Attachment att : [SELECT Id , name , ParentId
                              FROM Attachment
                              WHERE parentID IN : setAccountsIds
                             ])
        {
            if(!mapAttachments.containsKey(att.ParentId)) {
                mapAttachments.put(att.ParentId, new List<Attachment>());
            }
            mapAttachments.get(att.ParentId).add(att); 
        }
    }
    
    private void fillMaps(Map<Id, SObject> mapDocuments) {
        Id accountId = null;
        Attachment attachment = null;
        ContentDocumentLink contentDoc = null;
        for(SObject obj : mapDocuments.values()) {  
            if(obj instanceof Attachment ) {
                attachment = (Attachment) obj;
                if(attachment.ParentId.getSObjectType() == Account.SObjectType) { 
                    setAccountsIds.add(attachment.ParentId);
                } 
            } else if(obj instanceof ContentDocumentLink) {
                contentDoc = (ContentDocumentLink) obj;
                if(contentDoc.LinkedEntityId.getSObjectType() == Account.SObjectType) { 
                    setAccountsIds.add(contentDoc.LinkedEntityId);
                } 
            }
        } 
        if(setAccountsIds.size() > 0) {
            fillAttachments();
            fillContentDocumentLinks();
            fillAccounts();
        }
    }
    
    /**
     * Check the name of the attachment if it matches the account international Reference
     */ 
    private boolean matchingNameFormat(String strInterReference , String strAttachName) {
        boolean bRet = false;
		String subName = '';
        if(strAttachName.contains('_')) {
           subName = strAttachName.substring(0,strAttachName.indexOf('_'));   
        } 
        if(subName.length() > 0 && subName.equalsIgnoreCase(strInterReference)) {
            bRet = true;
        } 
        return bRet;
    }
    
    
    /*
     * Attachements can be of types : Attachement or ContentDocumentLink
     * Attachment : Imported from Salesforce Classic
     * ContentDocuments : Imported from Lightning (Salesforce1 : Tablet)
     */ 
    
    public void toggleAccountContractJoint(Map<Id , SObject> mapDocuments) { 
    	boolean hasContract = false;
        String refInternational = '';
        
        fillMaps(mapDocuments); 
    	// iterate documents until finding one with name that matches the document reference international    
        for(Account acc : mapAccounts.values()) { 
            refInternational = acc.Reference_internationale__c; 
            
            if(mapAttachments.containsKey(acc.Id)) {
                for(Attachment attach : mapAttachments.get(acc.Id)) {
                    if( matchingNameFormat(refInternational,attach.Name)) {
                        hasContract = true;
                        break;
                    }
            	}
            }
            
            if(!hasContract && mapContentDocuments.containsKey(acc.Id)) {
                for(ContentDocumentLink contentDoc : mapContentDocuments.get(acc.Id)) { 
                    if(matchingNameFormat(refInternational,contentDoc.ContentDocument.title)) {
                        hasContract = true;
                        break;
                    }
           		} 
            }
            
            if(acc.Contrat_Joint__c != hasContract) {
                acc.Contrat_Joint__c = hasContract;
                lstAccountsToBeUpdated.add(acc); 
            } 
			
        }
        
        if(lstAccountsToBeUpdated.size() > 0) {
            update lstAccountsToBeUpdated;
        }
    }
}