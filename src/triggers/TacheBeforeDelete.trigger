/* Author       : Yorgo Nabhan
* Date          : 2017-9-28
* Description   : This trigger is made to check if user has access to delete a task   
*/
trigger TacheBeforeDelete on Task (before delete) {

    system.debug('Trigger TacheBeforeDelete Entered');
    if(PAD.canTrigger('AP01_Task')){
        id UserId = userinfo.getProfileId();
        AP01_Task.CheckIfCanDelete(UserId, trigger.old);
    }

    
}