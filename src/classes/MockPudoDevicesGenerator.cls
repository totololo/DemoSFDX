@isTest
global class MockPudoDevicesGenerator implements HttpCalloutMock{
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[' 
                    + '{"InternationalSiteId":"FR43033",'
                    + '"DeviceNumber":"1234",'
                    + '"ConnectedAt":"2017-02-08T15:22:22.277",'
                    + '"ApplicationVersion":"1.0",'
                    + '"UserAgent":"Mozilla/5.0 (Linux; Android 4.4.4; CT50 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Crosswalk/21.51.546.7 Mobile Safari/537.36",'
                    + '"Browser":"chrome","Imei":"990006210146832",'
                    + '"ContentVersion":"3.0.0.63707.0",'
                    + '"DeviceBrand":"CT50",'
                    + '"DeviceType":"MobileApp",'
                    + '"Os":"Android",'
                    + '"OsVersion":"4.4.4",'
                    + '"DeviceEnvironment":"test"}]');
        res.setStatusCode(200);
        return res;
    }
}