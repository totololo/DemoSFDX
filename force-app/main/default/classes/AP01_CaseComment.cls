/*
* Class to block the modification or the deletion of the case comment
* @author: Christine Bayssary
* @date: 23/04/2017
* @Test: AP01_CaseComment_Test
*/
public class AP01_CaseComment {
    public static void deleteCaseCommemt(list<caseComment> listOldCaseComment){  
        Set<Id> caseIds = new Set<Id>();
        map<id, list<caseComment>> mapCaseComment = new map<id,list<caseComment>>();
        for(caseComment caseCmnt : listOldCaseComment){
            caseIds.add(caseCmnt.ParentId);
        }
        AP01_CaseComment.addErrorCaseCommemt(caseIds, listOldCaseComment);
    }
    
    
    public static void updateCaseCommemt(list<caseComment> listNewCaseComment, map<id,caseComment> oldMapCaseComment){
        Set<Id> caseIds = new Set<Id>();
        List<caseComment> caseCommentToUpdate = new List<caseComment>();
        for(caseComment caseCmnt : listNewCaseComment){
            if(caseCmnt.parentid != null && caseCmnt.commentbody  != oldMapCaseComment.get(caseCmnt.id).commentbody){
                caseIds.add(caseCmnt.parentid);
                caseCommentToUpdate.add(caseCmnt);
            }
        }
        AP01_CaseComment.addErrorCaseCommemt(caseIds, listNewCaseComment);        
    } 
    public static void addErrorCaseCommemt(Set<Id> caseIds, list<caseComment> caseCommentList){ 
        Map <Id, case> mapCases = new Map<Id, Case>( [select id, accountid,account.name,account.recordtypeid
                                                      from case
                                                      where id in : caseIds]);
        
        for(CaseComment caseCmnt: caseCommentList){
            String caseRecordTypeId = mapCases.get(caseCmnt.ParentId).account.recordtypeid;
            if(label.RT_INT_Compte.contains(caseRecordTypeId) || label.RT_INT_Compte2.contains(caseRecordTypeId)){
                caseCmnt.adderror(label.CaseComment_Blockage); 
            }   
        }        
    }
}