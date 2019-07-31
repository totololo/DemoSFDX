@isTest
public class Manager_PudoDevicesSynchro_Test {
    
    static testMethod void test_syncDevices() {
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPudoDevicesGenerator());
        HttpResponse res =  Manager_PudoDevicesSynchro.syncDevices('FR43033', 1);
        System.assertEquals(200, res.getStatusCode());
        test.stopTest();
    }
}