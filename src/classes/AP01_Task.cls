/* Author 		: Yorgo Nabhan
* Date 			: 2017-9-28
* Description 	: This Class is made to check if user has access to delete a task 
*/

public class AP01_Task {
    
    public static void CheckIfCanDelete(id UserId, list<Task> TriggerOld)
    {
        system.debug('CheckIfCanDelete Entered');
        List<profile> ListProfile =[SELECT Name 
                                    FROM profile 
                                    WHERE id = :UserId];
        String UserProfileName = ListProfile[0].Name;
        system.debug(UserProfileName);
        
        if(System.Label.Profile_Non_Delete_Access.contains(UserProfileName))
        {
            for(Task task : TriggerOld)
            {
                Task.addError(System.Label.Delete_Tache_Erreur); 
                
            }
        }
    }
    
}