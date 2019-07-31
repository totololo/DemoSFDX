trigger AttachmentAfterInsert on Attachment (after insert) {
 	if(PAD.canTrigger('AP08_Attachment'))  {
        AP08_Attachement ap08_attachment = new AP08_Attachement();
        ap08_attachment.toggleAccountContractJoint(Trigger.NewMap ); 
    }
}