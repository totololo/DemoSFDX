/*
* Author: John Boutros
* Modified By: -
* Date : 19/01/2018
* Modifier le Propriétaire de la requête
* Test classe: VFC12_GetOwnership_TEST
Coverage : 100%
*/
public class VFC12_GetOwnership {
    public VFC12_GetOwnership(ApexPages.StandardController controller) {}
    public static PageReference getOwnership() {
        system.debug('ApexPages.currentPage().getParameters().get() '+ApexPages.currentPage().getParameters().get('id'));
        Case caseToBeUpdate = [Select OwnerId
                               From Case
                               Where id = :ApexPages.currentPage().getParameters().get('id')];
        caseToBeUpdate.OwnerId = UserInfo.getUserId();
        update caseToBeUpdate;
        system.debug('caseToBeUpdate '+caseToBeUpdate);
        PageReference pageRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return pageRef;
    }
}