@RestResource(urlMapping='/alert/ReturnMsgPDA')
global with sharing class WsReturnMessagePDA {
    @HttpPost
    global static Boolean  updateAlertByMessagePDA(List<ResponseMessagePDA> listResponse){
        System.debug('listResponse'+listResponse);
        Set<ID>  gi = new Set<Id>();
        List<Alert__c> listAlertToRequest = new List<Alert__c>();
        List<Alert__c> listAlertToUpdate = new List<Alert__c>();
        String SOQL_IDs = '';
        Boolean ReturnStatus;
        Integer i =0;
        For(ResponseMessagePDA response: listResponse){
             i++;
            String id_in_quotes = '\''+response.IDMessagePDA+'\'';
            
            SOQL_IDs += id_in_quotes;
            if(response.IDMessagePDA!='' && i<listResponse.size()){
                SOQL_IDs+=',';
            }
           
        }
        String SOQL ='';
        if(SOQL_IDs!=''){
            SOQL = 'Select ID, MessagePDA_ID__c, alert_type__c from Alert__c  where MessagePDA_ID__c IN ('+SOQL_IDs+')';
            System.debug('SOQL'+SOQL);
            listAlertToRequest =database.query(SOQL);
        }
        For(ResponseMessagePDA response: listResponse){
            For(Alert__c alert: listAlertToRequest){
                if(response.IDMessagePDA==alert.MessagePDA_ID__c){
                    if(alert.alert_type__c =='2'){
                        alert.response_missguided_full_cause_closure__c = response.response_missguided_full_cause_closure;
                        alert.response_missguided_full_cause_refuse__c= response.response_missguided_full_cause_refuse;
                        alert.response_missguided_Part_cause_closure__c=response.response_missguided_Part_cause_closure;
                        alert.response_missguided_part_cause_refuse__c=response.response_missguided_part_cause_refuse;
                    }
                    if(alert.alert_type__c =='1'){
                        alert.response_overload_capacity_reach__c = response.response_overload_capacity_reach;
                        if(response.response_new_temporary_threshold!=null){
                            try {
                                alert.response_new_temporary_threshold__c = Decimal.valueOf(String.valueOf(response.response_new_temporary_threshold));
                            }catch (TypeException e) {
                                alert.response_new_temporary_threshold__c= null;
                            }
                        }
                        if(response.response_new_Contractual_threshold!=null){
                            try{
                                alert.response_new_Contractual_threshold__c = Decimal.valueOf(String.valueOf(response.response_new_Contractual_threshold));
                            }catch (TypeException e) {
                                alert.response_new_Contractual_threshold__c=null;
                            }
                        }
                        
                    }
                    listAlertToUpdate.add(alert);
                }
            }
        }
        try {
            update listAlertToUpdate;
            ReturnStatus=True;
        }
        catch(DmlException e) {
	        System.debug('The following exception has occurred:  ' + e.getMessage());
            ReturnStatus=False;
        }
        return ReturnStatus;
    }

    global class ResponseMessagePDA{
        public String IDMessagePDA {get;set;}
        public String response_overload_capacity_reach {get;set;}
        public String response_new_temporary_threshold {get;set;}
        public String response_new_Contractual_threshold {get;set;}
        public String response_missguided_full_cause_closure {get;set;}
        public String response_missguided_full_cause_refuse {get;set;}
        public String response_missguided_Part_cause_closure {get;set;}
        public String response_missguided_part_cause_refuse {get;set;}
    }
}