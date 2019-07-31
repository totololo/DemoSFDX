Global class MessageResponse{
    public cls_MessageResponses[] MessageResponses;
    public class cls_MessageResponses {
        public String ContextIdentifier;    //TEST1
        public cls_Response Response;
    }
    public class cls_Response {
        public boolean CreationSuccess;
        public String RequestIdentifier;    //372346
        public String ErrorMessage; //
    }
    public static MessageResponse parse(String json){
        return (MessageResponse) System.JSON.deserialize(json, MessageResponse.class);
    }

}