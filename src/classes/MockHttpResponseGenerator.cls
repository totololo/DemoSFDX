@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('callout:MessagePDA/Request/PostRequests', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"MessageResponses":[{"ContextIdentifier":"a0g1q000000PtqNAAS","Response":{"CreationSuccess":true,"RequestIdentifier":"372550","ErrorMessage":""}}]}');
        res.setStatusCode(200);
        return res;
    }
}