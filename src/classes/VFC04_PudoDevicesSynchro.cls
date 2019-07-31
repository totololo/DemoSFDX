/*
* Class to Sync the last Status of the Pudo Devices
* @author: Georges Hobeika
* @date: 13/02/2017
* @Test: VFC04_PudoDevicesSynchro_Test
*/

public class VFC04_PudoDevicesSynchro { 
    
    // public HttpResponse response {get;set;}
    public boolean hasDevices    {get;set;}
    public boolean showLoading   {get;set;}
    public String loadingMessage {get;set;}
    
    public Integer offset { get; set; }
    
    
    public String associerPDALink{get;set;}
    
    public class Device { 
        public String internationalSiteId{get;set;}
        public String deviceNumber{get;set;}
        public String connectedAt{get;set;}
        public String applicationVersion{get;set;}
        public String userAgent{get;set;}
        public String browser{get;set;}
        public String contentVersion{get;set;}
        public String deviceBrand{get;set;}
        public String deviceType{get;set;}
        public String os{get;set;}
        public String osVersion{get;set;}
        public String deviceEnvironment{get;set;} 
        public Boolean IsFleetAssociation {get;set;}
        
        // links : PDA Number , Associer un PDA , Dissocier un PDA
        // Depends on the organization ID
        public String dissocierPDALink{get;set;}
        public String WhitelistPDALink{get;set;}
        public String PDALink{get;set;}
    }
    
    public List<Device> listDevices{get;set;} 
    public List<Device> listdevicesSort{get;set;} 
    public List<Device> listDevices30{get;set;}
    public Boolean hasPrevious {get;set;}
    public Boolean hasNext {get;set;}
    
    private final Id acctId;
    private Account acct;
    private List<Anomalie__c> anomListAss;
    private List<Anomalie__c> anomListNoDec;
    static Set<ID> setRelatedAnomAcc;
    static List<Anomalie__c> listAnomalieInactScanToInsert;
    
    static boolean firstRun = false;
    public VFC04_PudoDevicesSynchro(ApexPages.StandardController stdController) {
        this.acctId = stdController.getId();
        this.showLoading = true;
        this.loadingMessage = Label.Loading_Devices + '...';
        this.offset = 0;
    }
    
    public PageReference syncDevices() {           
        acct = [SELECT Id ,Reference_internationale__c, Tech_Has_Device__c, Etat__c,Date_de_la_formation_reelle__c, recordTypeID
                FROM Account
                WHERE Id = : acctId];
        
        anomListNoDec = [SELECT id
                         FROM anomalie__C
                         where PUDO__r.id = : acctId
                         And Statut__c = : '1'
                         And type__c = 'NoDecommissioned'];
        
        anomListAss = [SELECT id
                       FROM anomalie__C
                       where PUDO__r.id = : acctId
                       And Statut__c = : '1'
                       And type__c ='Association à tort Etat 2'];
        
        List<account> accountToUpdate = new List<account>();
        String internationalSiteId = acct.Reference_internationale__c;  
        if(internationalSiteId != null && internationalSiteId.length() > 0 ) {
            HttpResponse response = Manager_PudoDevicesSynchro.syncDevices(internationalSiteId, 1);
            if(response == null) {
                loadingMessage = Label.Unreachable_WS;
            } else {
                Integer statusCode = response.getStatusCode();
                if(StatusCode == 404 || StatusCode == 500) {
                    loadingMessage = Label.Unreachable_WS;
                } else {
                    String strJsonResponse =  response.getBody();  
                    // create the links (PDA , associer , dissocier based on the org ID)
                    //constructLinks(internationalSiteId);
                    //TFS-124985
                    constructAssociePdaLink(internationalSiteId);
                    // END TFS-124985
                    
                    if(strJsonResponse != null && strJsonResponse.length() > 2){
                        // not empty response : []
                        showLoading = false;
                        hasDevices  = true; 
                        
                        
                        // Convert the response object(json string) to Device instance(List)
                        listDevices = (List<Device>)System.JSON.deserialize(strJsonResponse, List<Device>.class);
                        // create the links (PDA , associer , dissocier based on the org ID)
                        constructLinks(internationalSiteId);
                        sortDevices(listDevices);                        
                        hasPrevious = getDisabledPrevious();
                        hasNext = getDisabledNext();
                        if(listdevicesSort.size() > 0)
                        {
                            system.debug('acct '+acct);
                            createAnomalieNoDecommissionedOrAssociationEtat2(acct.Etat__c, acct.ID, acct.Date_de_la_formation_reelle__c,anomListNoDec,anomListAss,acct.recordTypeID);
                            system.debug('acct '+acct);
                        }
                    } else {
                        loadingMessage = Label.No_Devices;
                    } 
                }  
            }
            
        } else {
            loadingMessage =  Label.No_Devices;
        }  
        return null;
    } 
    
    private void constructAssociePdaLink(String refId){
        String orgId = UserInfo.getOrganizationId();
        associerPDALink  = Label.PDA_Associer + refId + '&language=fr-FR';  
        
    }
    
    private void constructLinks(String refId) {
        String orgId = UserInfo.getOrganizationId();
        if(listDevices != null && listDevices.size() > 0){
            for(Device dev : listDevices) {
                
                dev.WhitelistPDALink = Label.cyclope_Link + refId;
                dev.dissocierPDALink  = Label.PDA_Dissocier  + refId + '&product=' + dev.deviceNumber + '&language=fr-FR'; 
                dev.PDALink = Label.PDA_Link + Label.DeviceNum_Link + dev.deviceNumber; 
            }    
        }
        
        associerPDALink  = Label.PDA_Associer + refId + '&language=fr-FR'; 
        
        /**** End CB-RM3 ****/
                
    }
    
    public void nextPage() {
        offset = Math.min(offset + 6, listdevicesSort.size() - 6);
    }
    public void previousPage() {
        offset = Math.max(0, offset - 6);
    }
    public void lastPage() {
        offset = listdevicesSort.size() - 6;
    }
    public void firstPage() {
        offset = 0;
    }
    
    public Boolean getDisabledPrevious() { 
        if(offset>0){
            return false;
        }
        else {
            return true;
        }
        
    }
    public Boolean getDisabledNext() {
        if (offset<listdevicesSort.size() - 6) 
        {
            return false;   
        }
        else {
            return true;   
        }
    }
    
    private void sortDevices(list<Device> listDevices){
        integer targetsize = listDevices.size();
        listdevicesSort = new list<Device>();
        listDevices30  = new list<Device>();
        
        for (integer i = 0; i< targetsize ; i ++){
            Date dt1 = Date.valueOf(listDevices[i].connectedAt);
            Integer noOfDays = dt1.daysBetween(system.today());
            if(noOfDays <= 30 || test.isRunningTest()){
                device device = listDevices[i];
                listDevices30.add(device); 
            }
        }
        integer device30Size = listDevices30.size();
        while(listdevicesSort.size() != device30Size){
            findMinDateValue(listDevices30);
        }
    }
    
    
    private void findMinDateValue(list<Device> listDevices){
        date dt = Date.newInstance(1900, 12, 31);        
        integer mini = 0;
        for (integer i = 0; i< listDevices.size() ; i ++){
            if(listDevices[i].connectedAt > String.valueOf(dt)){                
                dt = Date.valueOf(listDevices[i].connectedAt);                
                mini = i;                
            }
        }   
        listdevicesSort.add(listDevices[mini]);       
        listDevices.remove(mini); 
    }
    
    /*
* The aim of this method is to check if the account's state is 7, 8 or 9 and has one or more associated device
*  to create an anomalie of type NoDecommissioned and a case "Relais inactif avec moyens de scan associés"
*  And to check if account's stat is 2 and date de formation réelle empty
then create an anomalie AssociationEtat2 and case "Relais sans formation avec moyen de scan associé"
*/
    public static void createAnomalieNoDecommissionedOrAssociationEtat2(String accEtat, ID accountId, Date dateFormationReelle, list<anomalie__c> anomListNoDec,list<anomalie__c> anomListAss,ID recordtypeID)
    {   
        set<id> setRelatedAnomAccDec = new Set<ID>();
        set<id> setRelatedAnomAccAss = new Set<ID>();
        listAnomalieInactScanToInsert = new List<Anomalie__c>();
        system.debug('accEtat '+accEtat);
        if(Label.RT_INT_Compte.contains(recordtypeID) || Label.RT_INT_Compte2.contains(recordtypeID) || Label.RT_France_Compte.contains(recordtypeID)){
            
            if((accEtat == '7' || accEtat == '8'|| accEtat == '9') && anomListNoDec.size() == 0)
            {
                setRelatedAnomAccDec.add(accountId);
            }
            else if(accEtat == '2' && dateFormationReelle == null && anomListAss.size() == 0){
                setRelatedAnomAccAss.add(accountId);
            }
            for(ID accID : setRelatedAnomAccDec)
            {
                listAnomalieInactScanToInsert.add(createAnomalieNoDecommissioned(accID));
            }
            for(ID accID : setRelatedAnomAccAss)
            {
                listAnomalieInactScanToInsert.add(createAnomalieAssociationEtat2(accID));
            }
        }
        insert listAnomalieInactScanToInsert;        
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: John Boutros
Company: EI-technologies
Description: create an anomalie of type NoDecommissioned
Inputs: set of accountID's that met the conditions
Returns: Anomalie to insert
--------------------------------------------------------------------------------------------------------------------------*/
    public static Anomalie__c createAnomalieNoDecommissioned(ID accountID)
    {
        Anomalie__c newAnomalie= new Anomalie__c();
        newAnomalie.Name='Anomalie NoDecommissioned';
        newAnomalie.PUDO__c=accountID;
        newAnomalie.Statut__c='1';
        newAnomalie.Type__c='NoDecommissioned';
        return newAnomalie;
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-technologies
Description: create an anomalie of type Association à tort Etat 2
Inputs: set of accountID's that met the conditions
Returns: Anomalie to insert
--------------------------------------------------------------------------------------------------------------------------*/
    public static Anomalie__c createAnomalieAssociationEtat2(ID accountID)
    {
        Anomalie__c newAnomalie= new Anomalie__c(Name='Anomalie Association à tort Etat 2',PUDO__c=accountID,Statut__c='1',Type__c='Association à tort Etat 2');
        return newAnomalie;
    }
}