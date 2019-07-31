trigger UserBeforeUpdate on User (before update) {
	if(PAD.canTrigger('AP01_User')) {
        AP01_User.updateUserTechLocaleSidKey(Trigger.New, Trigger.OldMap); 
    }
}