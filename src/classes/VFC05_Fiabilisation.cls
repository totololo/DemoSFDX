/*
* Class validate address through AMABIAS web service
* @author: Georges Hobeika
* @date: 16/02/2017
* @Test: VFC05_Fiabilisation_Test
*/

public class VFC05_Fiabilisation {
     
    // extension to standard controller : account
    private Id accountId = null; 
    public Account account{get;set;}  
	private Account accountToBeUpdated = null;    
    // used for Keep original address button
    public boolean passageFiabilisation{get;set;}
    
    // the status message returned from AMABIAS web service
    public String status{get;set;} 
    
    // Street is divided into 3 parts
    public String shippingStreet1{get;set;}
    public String shippingStreet2{get;set;}
    public String shippingStreet3{get;set;}
  
    // wrapper to fill a grid with the list of suggested addresses (by AMABIAS) along with 2 checkboxes
    // user can choose  which address(shipping or billing) he wants to replace by any of the suggested addresses
    public class Address { 
        public String id{get;set;}
        public String city{get;set;} 
        public String postalCode{get;set;}
        public String streetNumber{get;set;}
        public String countryCode{get;set;}
        public String street{get;set;} 
    }
    
    // 2 checkboxes 
    public boolean applyForDelivery{get;set;}
    public boolean applyForBilling{get;set;}
    
    //list of the wrapper
    public List<Address> listAddresses{get;set;}
    
    // extension constructor
    // retreive the needed fields  
    public VFC05_Fiabilisation(ApexPages.StandardController stdController) { 
        this.passageFiabilisation = false;
        this.applyForDelivery = true;
        this.applyForBilling  = true;
        listAddresses = new List<Address>(); 
        this.accountId = stdController.getId();
        this.account = [SELECT ID , ShippingPostalCode , ShippingCity ,  ShippingStreet , ShippingCountryCode , shippingCountry , Account.N_de_rue_livraison__c,
                        BillingPostalCode , BillingCity , BillingStreet , BillingCountryCode , Account.N_de_rue_facturation__c,
                        Adresse_de_livraison_fiabilisee__c , Passage_par_fiabilisation_effectuee__c
                        FROM Account
                        Where Id = : this.accountId
                       ];  
        if(this.account.ShippingStreet != null && this.account.ShippingStreet.length() > 0) {
            String [] arrStreets = this.account.ShippingStreet.split('\\r?\\n');
            if(arrStreets.size() > 0) {
                this.shippingStreet1 = arrStreets[0].trim();
            }
            if(arrStreets.size() > 1) {
                this.shippingStreet2 = arrStreets[1].trim();
            }
            if(arrStreets.size() > 2) {
                this.shippingStreet3 = arrStreets[2].trim();
            }
        } 
    }
     
    
    // close current screen and get back to the account page
    public PageReference closeScreen() {
        PageReference  acctPage =  new PageReference('/' + accountId);
        return acctPage;  
    }
    
    // custom settings contains a meaning phrase for each status
    private String getResponseStatus(String status) { 
        String ret =  '';  
        Amabis__c amabisCS = Amabis__c.getInstance( status.replaceAll('\\s+$', '')); 
        if(amabisCS != null ) {
            ret = amabisCS.Statut__c;
        } 
        return ret;
    }
    
    
    public PageReference keepOriginalAddress() {
        // update checkboxes before
        if(! account.Passage_par_fiabilisation_effectuee__c && !Test.isRunningTest()) { 
             account.Passage_par_fiabilisation_effectuee__c = true;
             update account;
        }
        PageReference  acctPage =  new PageReference('/' + accountId);
        return acctPage;  
    }
    
    private boolean isEmptyForm() {
        // remove leading and trailing spaces
        String streetNumber = account.N_de_rue_livraison__c == null ? '' : account.N_de_rue_livraison__c.trim();
        String shippingPostalCode = account.ShippingPostalCode == null ? '' : account.ShippingPostalCode.trim();
        String shippingCity = account.ShippingCity == null ? '' : account.ShippingCity.trim();
        boolean ret = false;
        if(streetNumber.length() == 0 && shippingPostalCode.length() == 0 && shippingCity.length() == 0
            && shippingStreet1.trim().length() == 0 && shippingStreet2.trim().length() == 0 && shippingStreet3.trim().length() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.FIAB_Required));
                ret = true;
        }
		         
        return ret;
    }
    
    // call AMABIAS web service, retreive and display addresses suggestions if any
    public PageReference suggestAddresses() {
        if(isEmptyForm()) {
            this.status = '';
            return null;
        }
       
        //used for keep original address button
        this.passageFiabilisation = true;
        
        // create instance of the WS response
        rnvpiWebserviceRnvpiAmabisComXsd.rnvpiResponse amabisValidationResponse = null;
        
        // re-initiate the list of suggestions
        if(listAddresses.size() > 0) {
            listAddresses.clear();
        }
         
        try {  
            // invoke Amabis web service
            // parameters : account fields that can be changed by the user.
            String street = this.shippingStreet1 + ' ' +  this.shippingStreet2 + ' ' + this.shippingStreet3;
            amabisValidationResponse = Manager_Amabis.validateAddress(account.N_de_rue_livraison__c,street,account.ShippingPostalCode,account.ShippingCity,account.ShippingCountryCode); 
            if(amabisValidationResponse != null) {
                // XML response provied by AMABIAS
                // Response sent without root which cannot be parsed
                // Adding manually a root to the XML document
                String strResponse = amabisValidationResponse.objdesc;
                String strStatusCode = amabisValidationResponse.statut;
                strResponse = '<RESPONSE>' + strResponse + '</RESPONSE>';  
                System.debug('###gho strReponse : ' + strResponse);
                // Convert the string response to XML document and parse it
                Dom.Document doc = new Dom.Document();
                doc.load(strResponse);  
                Dom.XmlNode responseNode = doc.getRootElement();
                // Status provided by AMABIAS
                this.status = getResponseStatus(responseNode.getChildElement(Label.FIAB_StatusNode, null).getText());  
                Address address = null;
                String strSugAddresses = null; 
                system.debug('strStatusCode '+strStatusCode);
                if(! strStatusCode.startsWith('OK')) { 
                    // Suggested addresses are found in the tag LADR seperated by '|' character
                    // each address contains the fields seperated by '/' character      
                    // list of suggestions with dynamic id used in client side validation 
                    try {
                        strSugAddresses = responseNode.getChildElement(Label.FIAB_LadrNode, null).getText();
                    }catch(Exception e){}
                    system.debug('strSugAddresses '+strSugAddresses);
                    if(strSugAddresses != null) {
                        String [] arrAddresses = strSugAddresses.split('\\|');  
                        system.debug('arrAddresses '+arrAddresses);
                        for(integer i = 0 ; i < arrAddresses.size() ; i++) {  
                            String [] arrAdressFields = arrAddresses[i].split('/'); 
                            system.debug('arrAdressFields '+arrAdressFields);
                            if(arrAdressFields.size() == 4)
                            {
                                if(arrAdressFields[1].indexOf('=') ==  -1) {
                                    address = new Address();
                                    address.id = '' + i;
                                    // street number + street
                                    // ex : 1 Avenue de Villiers
                                    String streetNumber = '';  
                                    address.street = arrAdressFields[1];
                                    system.debug('address.street '+address.street);
                                    if(arrAdressFields[1].contains(' ')){
                                        streetNumber = arrAdressFields[1].substring(0,arrAdressFields[1].indexOf(' '));}
                                    if(streetNumber != null && streetNumber.length() > 0 && streetNumber.isNumeric()) {
                                        address.streetNumber = streetNumber;
                                        address.street 		 = arrAdressFields[1].subString(arrAdressFields[1].indexOf(' ') + 1 , arrAdressFields[1].length() );
                                    } else {
                                        address.street = arrAdressFields[1]; 
                                    }
                                    system.debug('arrAdressFields[2]'+ arrAdressFields[2]);
                                    system.debug('arrAdressFields[2].indexOf()'+ arrAdressFields[2].indexOf(' '));
                                    // postal code 
                                    if(arrAdressFields[2].contains(' ')){
                                    address.postalcode = arrAdressFields[2].substring(0,arrAdressFields[2].indexOf(' '));
                                    
                                    
                                    // city 
                                    // ex: 75017 PARIS
                                    address.city = arrAdressFields[2].replace(address.postalcode,'');}
                                    listAddresses.add(address);
                                    
                                    // country code
                                    Address.countrycode = this.account.ShippingCountryCode;
                                }
                            }
                            else if (arrAdressFields.size() == 3)
                            {
                                if(arrAdressFields[0].indexOf('=') ==  -1) {
                                    address = new Address();
                                    address.id = '' + i;
                                    // street number + street
                                    // ex : 1 Avenue de Villiers
                                    String streetNumber = '';  
                                    address.street = arrAdressFields[0];
                                    system.debug('address.street '+address.street);
                                    streetNumber = arrAdressFields[0].substring(0,arrAdressFields[0].indexOf(' '));
                                    if(streetNumber != null && streetNumber.length() > 0 && streetNumber.isNumeric()) {
                                        address.streetNumber = streetNumber;
                                        address.street 		 = arrAdressFields[0].subString(arrAdressFields[0].indexOf(' ') + 1 , arrAdressFields[0].length() );
                                    } else {
                                        address.street = arrAdressFields[0]; 
                                    }
                                    system.debug('arrAdressFields[1]'+ arrAdressFields[1]);
                                    system.debug('arrAdressFields[1].indexOf()'+ arrAdressFields[1].indexOf(' '));
                                    // postal code 
                                    address.postalcode = arrAdressFields[1].substring(0,arrAdressFields[1].indexOf(' '));
                                    
                                    // city 
                                    // ex: 75017 PARIS
                                    address.city = arrAdressFields[1].replace(address.postalcode,'');
                                    listAddresses.add(address);
                                    
                                    // country code
                                    Address.countrycode = this.account.ShippingCountryCode;
                                }
                            }
                        }
                    }
                     
                } else if(strStatusCode.startsWith('OK')){  
                    // address correct but some modifications are availabe
                    // 1 record
                    // ex : rue : Villiers --> avenue de Villiers
                     
                    address = new Address();
                    address.id = '0';   
                    if(responseNode.getChildElement(Label.FIAB_StreetOnlyNode,null).getText() != null) {
                        address.street = responseNode.getChildElement(Label.FIAB_StreetOnlyNode,null).getText();
                    }
                    
                    if(responseNode.getChildElement(Label.FIAB_Num1,null).getText() != null) {
                        address.streetNumber = responseNode.getChildElement(Label.FIAB_Num1,null).getText();
                    }
                    
                    if(responseNode.getChildElement(Label.FIAB_PostalCodeNode,null).getText() != null) {
                        address.postalcode   = responseNode.getChildElement(Label.FIAB_PostalCodeNode,null).getText();
                    }
                    
                    if(responseNode.getChildElement(Label.FIAB_CityNode,null).getText() != null) {
                        address.city = responseNode.getChildElement(Label.FIAB_CityNode,null).getText(); 
                    } 
                    
                    // country code
                    Address.countrycode = this.account.ShippingCountryCode;
                    
                    listAddresses.add(address);
                    
                }   
            } 
        }catch(Exception e) { 
            account.addError(Label.FIAB_AddressIncrorrect);                                 
            System.debug('###gho exception : ' + e.getMessage());
		}  
        return null;
    }
    
    public PageReference submitAddresses() { 
        // User can change one address
        // Can replace Shipping/Billing Addresses
        String addressId = ApexPages.currentPage().getParameters().get('addressId');        
        Address selectedAddress = null;
        // get the selected address
        if(addressId != null && addressId.length() > 0) {
            for(Address add : listAddresses) {
                if((add.id).equals(addressId)) {
                    selectedAddress = add;
                    break;
                }
            } 
            boolean isApplyForBillingChecked  = this.applyForBilling;
            boolean isApplyForDeliveryChecked = this.applyForDelivery; 
            accountToBeUpdated = [select Id , Adresse_de_livraison_fiabilisee__c
                                  FROM Account
                                  where Id =: this.account.Id
                                 ];
            if(isApplyForBillingChecked) { 
                updateBillingFields(selectedAddress);
            }
            if(isApplyForDeliveryChecked) {
                updateDeliveryFields(selectedAddress);
            }  
            
            if(! accountToBeUpdated.Adresse_de_livraison_fiabilisee__c) {
                 accountToBeUpdated.Adresse_de_livraison_fiabilisee__c = true;
            }
            
            if(! accountToBeUpdated.Passage_par_fiabilisation_effectuee__c && !Test.isRunningTest()) { 
                 accountToBeUpdated.Passage_par_fiabilisation_effectuee__c = true;
         	}
            
            //update the second field also
            update accountToBeUpdated;
             
        }
        
        PageReference  acctPage =  new PageReference('/' + accountId);
        return acctPage; 
		 
    }
    
    private String getCountry(String code) {
        String ret = '';
        Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        for(Schema.PicklistEntry f : ple){
            if(code.equalsIgnoreCase(f.getValue())) { 
                ret = f.getLabel();
            }  
        }
        return ret;
    }
    
    private void updateBillingFields(Address add) { 
        accountToBeUpdated.N_de_rue_facturation__c = add.streetNumber;
        accountToBeUpdated.BillingStreet = add.street;
        accountToBeUpdated.BillingPostalCode = add.postalcode;
        accountToBeUpdated.BillingCity  = add.city;  
        accountToBeUpdated.BillingCountryCode = add.countrycode;
        accountToBeUpdated.BillingCountry = getCountry(add.countrycode);
    }
    
    private void updateDeliveryFields(Address add) { 
        accountToBeUpdated.N_de_rue_livraison__c = add.streetNumber;
        accountToBeUpdated.ShippingStreet = add.street;
        accountToBeUpdated.ShippingPostalCode = add.postalCode;
        accountToBeUpdated.ShippingCity  = add.city;  
        accountToBeUpdated.ShippingCountryCode = add.countrycode;
        accountToBeUpdated.ShippingCountry = getCountry(add.countrycode);
    }
}