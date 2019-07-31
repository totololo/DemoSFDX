public with sharing class MassUpdateExtension{

    ApexPages.StandardSetController setCon;
    public Case caseTogetOwner {get;set;}
    public String ownerId {get;set;}
    public PageReference originalUrl { get; set; }

    public MassUpdateExtension(ApexPages.StandardSetController controller) {
        caseTogetOwner  = new case();
        setCon = controller;
        
        }

    public PageReference updateRecords(){
        List <Case> casesToUpdate = (List<Case>) setCon.getSelected() ;
        ownerId = caseTogetOwner.OWNERID;
        for (Case c :casesToUpdate  ){
            c.OwnerId= ownerId;
        }
        update casesToUpdate;
        originalUrl = setCon.cancel();
        return originalUrl;
    }


}