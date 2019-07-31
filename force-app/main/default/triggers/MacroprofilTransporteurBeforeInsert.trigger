trigger MacroprofilTransporteurBeforeInsert on Macroprofil_Transporteur__c (before insert) {
	for(Macroprofil_Transporteur__c neww : trigger.new){         
        neww.Techatraiter__c = true;
    }
}