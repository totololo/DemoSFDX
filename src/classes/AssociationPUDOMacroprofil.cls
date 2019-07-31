public class AssociationPUDOMacroprofil {
    
    @testVisible static private Map<String, List<SObject>> AssociationPUDOMacroprofilMap = new Map<String, List<SObject>>();
     
    public List<SObject> getCustomMetadataRecords(String query) {
        if ( !AssociationPUDOMacroprofilMap.containsKey( query ) ) {
            AssociationPUDOMacroprofilMap.put( query, Database.query( query ) );
        }
        return AssociationPUDOMacroprofilMap.get( query );
    }

}