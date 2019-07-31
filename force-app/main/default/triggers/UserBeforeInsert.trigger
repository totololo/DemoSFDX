trigger UserBeforeInsert on User (before insert) {
    if(PAD.canTrigger('AP01_User')) {
        AP01_User.updateUserTechLocaleSidKey(Trigger.New,null); 
    }
}