//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
//Methods Included: IsUpAndRunning, GetName, SynchronizeUsers, GetUsers, SendUserCreationMessage
// Primary Port Class Name: BasicHttpBinding_IUserManagement	
public class WS_GenerateLienAndroid {
    
    
    public class BasicHttpBinding_IUserManagement {
        
        private String getOrganisationId() {
            return UserInfo.getOrganizationId().length() == 18 ? UserInfo.getOrganizationId().substring(0, UserInfo.getOrganizationId().length() - 3) : UserInfo.getOrganizationId();
        }
        
        private String getEndpoint() {
            String strEndpoint;
            String orgId = getOrganisationId();
            if(orgId != null && orgId.length() > 0) {
            /****CB-RM3 Start 
            ***Simplification des étiquettes personnalisées: utilisation d'une seule étiquette pour toutes les orgs****
            ****/
                
               /* if(orgId == Label.ID_TEST) {
                    strEndpoint = Label.Lien_Android_Endpoint_Test;
                } else if (orgId == Label.ID_UAT) {
                    strEndpoint = Label.Lien_Android_Endpoint_UAT;
                } else if (orgId == Label.ID_PROD) {
                    strEndpoint = Label.Lien_Android_Endpoint_Prod;
                }*/
                if(orgId == Label.ID_ORG) {
                    strEndpoint = Label.Lien_Android_Endpoint;
                } 
             /**** End CB-RM3 ****/   
            }  
            return strEndpoint;
        }
        
        private Map<String, String> getAuthenticationKey() {
            Map<String, String> mapInputHeaders = new Map<String, String>();
            String orgId = getOrganisationId();
            String authKey;
            if(orgId != null && orgId.length() > 0) {
                
            /****CB-RM3 Start 
            ***Simplification des étiquettes personnalisées: utilisation d'une seule étiquette pour toutes les orgs****
            ****/
                /*if(orgId == Label.ID_TEST) {
                    authKey = Label.Lien_Android_Authentication_Key_Test;
                } else if (orgId == Label.ID_UAT) {
                    authKey = Label.Lien_Android_Authentication_Key_UAT;
                } else if (orgId == Label.ID_PROD) {
                    authKey = Label.Lien_Android_Authentication_Key_Prod;
                }*/
                
                if(orgId == Label.ID_ORG) {
                    authKey = Label.Lien_Android_Authentication_Key;
                }
           /**** End CB-RM3 ****/   
            }  
            if(authKey != null && authKey.length() > 0) {
                mapInputHeaders.put('X-App-Client-Key', authKey);
            } 
            return mapInputHeaders;
        }
        
        
        //public String endpoint_x = 'https://apis-tst.pickup-services.com/user/UserIntegrationService.svc/UserManagementService';
        public String endpoint_x = getEndpoint();
        public Map<String,String> inputHttpHeaders_x = getAuthenticationKey();
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/','schemasMicrosoftCom200310Serializat','http://schemas.microsoft.com/2003/10/Serialization/Arrays','schemasMicrosoftCom200310Serializat1','http://schemas.datacontract.org/2004/07/Pssa.Ww.User.Wcf.Contract','schemasDatacontractOrg200407PssaWwU','http://tempuri.org/','WS_GenerateLienAndroid'};
            
            
            
            
            public String SendUserCreationMessage(String Email,Boolean UpdateUserEmail,String UserName) {
                WS_GenerateLienAndroid.SendUserCreationMessageParameters_element request_x = new WS_GenerateLienAndroid.SendUserCreationMessageParameters_element();
                WS_GenerateLienAndroid.SendUserCreationMessageStatus_element response_x;
                request_x.Email = Email;
                request_x.UpdateUserEmail = UpdateUserEmail;
                request_x.UserName = UserName;
                Map<String, WS_GenerateLienAndroid.SendUserCreationMessageStatus_element> response_map_x = new Map<String, WS_GenerateLienAndroid.SendUserCreationMessageStatus_element>();
                response_map_x.put('response_x', response_x);
                WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                        'http://tempuri.org/IUserManagement/SendUserCreationMessage',
                        'http://tempuri.org/',
                        'SendUserCreationMessageParameters',
                        'http://tempuri.org/',
                        'SendUserCreationMessageStatus',
                        'WS_GenerateLienAndroid.SendUserCreationMessageStatus_element'}
                );
                response_x = response_map_x.get('response_x');
                return response_x.StatusValue;
            }
        
        
    }
    
    
    public class SendUserCreationMessageParameters_element {
        public String Email;
        public Boolean UpdateUserEmail;
        public String UserName;
        private String[] Email_type_info = new String[]{'Email','http://tempuri.org/','string','0','1','true'};
            private String[] UpdateUserEmail_type_info = new String[]{'UpdateUserEmail','http://tempuri.org/','boolean','0','1','false'};
                private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/','string','0','1','true'};
                    private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
                        private String[] field_order_type_info = new String[]{'Email','UpdateUserEmail','UserName'};
                            }
    public class SendUserCreationMessageStatus_element {
        public String StatusValue;
        private String[] StatusValue_type_info = new String[]{'StatusValue','http://tempuri.org/','SendUserCreationMessageStatusValue','0','1','false'};
            private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
                private String[] field_order_type_info = new String[]{'StatusValue'};
                    }
    
}