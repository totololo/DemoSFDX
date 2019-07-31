Global Class WSCallMessagePDA{
    @Future(callout=true)
    public static void MsgPDACallout(set<ID> listAlertId){
        System.debug('Test listAlertId'+listAlertId);
        Map<Id,MessageResponse.cls_Response> mapAlertIDContextReqId = new Map<Id,MessageResponse.cls_Response>();
        List<Survey.Requests> listRequestsToSend = new List<Survey.Requests>();
        listRequestsToSend = Survey.toListRequestID(listAlertId);
        Survey asurvey = new Survey(listRequestsToSend );
        System.debug('listRequestsToSend'+listRequestsToSend);
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('http://messagepudo-publicapi-dev.pickup-services.com/Request/PostRequests');
        req.setEndpoint('callout:MessagePDA' + '/Request/PostRequests');
        //req.setHeader('X-Username', '{!$MessagePDA.UserName}');
    	//req.setHeader('X-Password', '{!$MessagePDA.Password}');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json; charset=utf-8');
        req.setTimeout(120000);
        String JSONStringToSend =JSON.serialize(asurvey);
        System.debug('asurvey '+asurvey);
        System.debug('JSONStringToSend '+JSONStringToSend);
        req.setbody(JSONStringToSend);
        Http http = new Http();
        System.debug('Test reponse'+req);
        HTTPResponse res = http.send(req);
        System.debug('Test reponse'+res.getBody());
        JSONParser parserRetour = JSON.createParser(res.getBody());
        MessageResponse msgResponse= (MessageResponse)JSON.deserialize(res.getBody(), MessageResponse.class);
        System.debug('msgResponse '+msgResponse );
        IF(msgResponse!=NULL){
            For(MessageResponse.cls_MessageResponses clsMsg: msgResponse.MessageResponses){
                System.debug('clsMsg'+clsMsg);
                MessageResponse.cls_Response clsresponse = clsMsg.Response;
                System.debug('clsresponse.RequestIdentifier'+clsresponse.RequestIdentifier );
                mapAlertIDContextReqId.put(clsMsg.ContextIdentifier,clsresponse);
            }
            List<Alert__c> listAlertRequest = [Select ID from Alert__c where ID in: mapAlertIDContextReqId.KeySet()] ;
            List<Alert__c> listAlertToUpdate= new List<Alert__c>();
            For(Alert__c alert:listAlertRequest ){
                
                if(mapAlertIDContextReqId.containsKey(alert.Id)){
                    alert.MessagePDA_ID__c=(mapAlertIDContextReqId.get(alert.Id)).RequestIdentifier;
                    alert.MsgPDA_Erreur_Message__c=(mapAlertIDContextReqId.get(alert.Id)).ErrorMessage;
                    listAlertToUpdate.add(alert);   
                }
            }
            update listAlertToUpdate; 
        }
        
         //return res;    
    }
   }