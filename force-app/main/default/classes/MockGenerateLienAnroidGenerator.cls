@isTest
global class MockGenerateLienAnroidGenerator implements HttpCalloutMock{ 
    
    public String type;
    
    global MockGenerateLienAnroidGenerator(final String type){
        this.type = type;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        If(Type == 'Success'){
            res.setBody(   
                
                '   {'+
                '       \"IsSuccess\": true,'+
                '       \"Data\": \"Un email pour le changement de mot de passe a été envoyé\",'+ 
                '       \"Errors\": []'+
                '   }');
            
            res.setStatusCode(200); 
        }
        else if(Type == 'NotFound'){
            res.setBody(   
                
                '   {'+
                '       \"IsSuccess\": false,'+
                '       \"Data\": null,'+ 
                '       \"Errors\": [\"user FR43033@pudo.dev.pickup not found\"]'+
                '   }');
            res.setStatusCode(500); 
        }
        else if(Type == '404'){
            res.setStatusCode(404); 
        }
      
        return res;
    }
}