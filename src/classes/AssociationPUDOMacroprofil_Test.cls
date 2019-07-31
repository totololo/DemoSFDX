@isTest public class AssociationPUDOMacroprofil_Test {
    static testMethod void testGetMetadata() {
        List<SObject> AssociationPUDOMacroprofilRecords;
        Test.startTest();
        AssociationPUDOMacroprofilRecords = new AssociationPUDOMacroprofil().getCustomMetadataRecords( 'SELECT MasterLabel FROM Association_PUDO_Macroprofil__mdt' );
        Test.stopTest();
        System.assertEquals( [ SELECT MasterLabel FROM Association_PUDO_Macroprofil__mdt ].size(), AssociationPUDOMacroprofilRecords.size(), 'Size should match' );
    }
    
    public static void setMetadata( String query, List<SObject> records ) {
        AssociationPUDOMacroprofil.AssociationPUDOMacroprofilMap.put( query, records );
    }
}