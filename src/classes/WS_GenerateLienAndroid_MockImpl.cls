global class WS_GenerateLienAndroid_MockImpl implements WebServiceMock {

    public static boolean correctAnswer = null;
    
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) { 
            WS_GenerateLienAndroid.SendUserCreationMessageStatus_element reponseElement = new WS_GenerateLienAndroid.SendUserCreationMessageStatus_element() ;
            if(correctAnswer){
                reponseElement.StatusValue = Label.Lien_Android_OK;
            } else {
                reponseElement.StatusValue = Label.Lien_Android_User_Not_Found	;
            }
            response.put('response_x' , reponseElement);
        }
}