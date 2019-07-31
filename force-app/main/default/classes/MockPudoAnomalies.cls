global class MockPudoAnomalies implements HttpCalloutMock {
	 global HTTPResponse respond(HTTPRequest req) {
		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Count":1}');
        res.setStatusCode(200);
        return res;
     }
}