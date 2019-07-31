trigger CaseCommentBeforeDelete on CaseComment (before delete) {
    if(PAD.canTrigger('AP01_CaseComment')){
        AP01_CaseComment.deleteCaseCommemt(trigger.old);
    }
}