public class AP05_Account { 
    
    public class BaseException extends Exception {}

    private static List<Account> listAccountsToBeUpdated = new List<Account>();
    
    
    // put all custom settings in a map 
    // update the whole map once
    private static Map<String ,String> mapCountrySequence = new Map<String ,String>();
        
    private static String incrementCountriesMapSequence(String sequence){
        String ret = sequence.substring(0,2);
        sequence = sequence.substring(2, sequence.length()); 
        // make sure that the sequence does not starts with 0
        // save the leadings zeros 
        Integer sequenceLength = sequence.length(); 
        Integer convertedSequence = Integer.valueOf(sequence); 
        convertedSequence ++;
        Integer convertedLength = (String.valueOf(convertedSequence)).length(); 
        if(convertedLength < sequenceLength) {
            for(Integer i = convertedLength ; i < sequenceLength ; i++ ) {
                ret += '0';
            }
        }
        ret += String.valueOf(convertedSequence); 
        return ret;
    }
    
    public static void setInternationalReferenceNumber(List<Account> listAccounts , Map<Id , Account> mapOldAccounts) { 
        CountriesSequence__c countryInstance = null;
        String strAccountShippingCountry = null;
        String sequenceNumber = null;
        String accountReference = null;
        for(Account account : listAccounts) { 
            // creation of nonsuivi or consigne with etat 2.
            // or converti (avoid modification of other fields).
            // if values are imported do not change them.        
            sequenceNumber = null;  
            if( (mapOldAccounts == null && account.Etat__c == '2' &&
                 (label.RT_NonSuiviCo_Compte.contains(account.RecordTypeId) || label.RT_Consigne_Compte.contains(account.RecordTypeId))
                ) ||
                (mapOldAccounts != null && (label.RT_ProspectConverti_Compte.contains(account.RecordTypeId) || label.RT_ProspectConvertiPickupContact_Compte.contains(account.RecordTypeId))&&
                 account.RecordTypeId != mapOldAccounts.get(account.Id).RecordTypeId)
              ){ 
              system.debug('entered here : setInternationalReferenceNumber');
                  accountReference = account.Reference_internationale__c;
                  if(accountReference == null || accountReference.length() == 0) {
                      strAccountShippingCountry = account.ShippingCountry;
                        if(strAccountShippingCountry != null && strAccountShippingCountry.length() > 0 && CountriesSequence__c.getInstance(strAccountShippingCountry) != null) {
                            if(!mapCountrySequence.containsKey(strAccountShippingCountry)) {
                                countryInstance = CountriesSequence__c.getInstance(strAccountShippingCountry);
                                if(countryInstance != null) {
                                    mapCountrySequence.put(strAccountShippingCountry,countryInstance.Sequence__c);
                                }
                            }
                           
                            sequenceNumber = mapCountrySequence.get(strAccountShippingCountry);  
                            account.Reference__c = sequenceNumber;
                            account.Reference_internationale__c = sequenceNumber; 
                                   
                           
                            // increment the sequence number of the map. To be updated once later
                            mapCountrySequence.put(strAccountShippingCountry, incrementCountriesMapSequence(sequenceNumber)); 
                        } else if(CountriesSequence__c.getInstance(strAccountShippingCountry) == null) {
                            if(label.RT_ProspectConverti_Compte.contains(account.RecordTypeId) || label.RT_ProspectConvertiPickupContact_Compte.contains(account.RecordTypeId) ) {
                                BaseException e = new BaseException();
                                e.setMessage(Label.Pays_Sequence);
                                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.Pays_Sequence));
                                throw e;
                            } else {
                                account.addError(Label.Pays_Sequence);                                 
                            }
                        }   
                  }               
            }  
        } 
        
        //update the custom settings
        if(mapCountrySequence.size() > 0) {
            List<CountriesSequence__c> listcountryInstances = new List<CountriesSequence__c>();
            countryInstance = null;
            for(String country:mapCountrySequence.keySet()){
                countryInstance = CountriesSequence__c.getInstance(country);
                if(countryInstance != null) {
                     countryInstance.Sequence__c = mapCountrySequence.get(country); 
                     listcountryInstances.add(countryInstance);
                } 
            }
            // DML statement 
            update listcountryInstances; 
        }
    }
}