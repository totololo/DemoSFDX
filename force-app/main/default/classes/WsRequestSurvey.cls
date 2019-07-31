global class WsRequestSurvey {
    //@InvocableVariable(label='ListAlert' required=true)
    //global List<Alert__c> listAlert;
    @InvocableMethod
    public static void  MessagePDACallout(List<Alert__c> listAlert){
        Set<ID> setAlertID= new Set<ID>();
        For(Alert__c alert:listAlert){
            setAlertID.add(alert.ID);
        }
        WSCallMessagePDA.MsgPDACallout(setAlertID);
    }
}