trigger CaseCommentBeforeUpdate on CaseComment (before update) {
    if(PAD.canTrigger('AP01_CaseComment')){
        AP01_CaseComment.updateCaseCommemt(trigger.new,trigger.oldMap); 
    }
}