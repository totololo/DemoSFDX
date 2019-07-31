@isTest
public class Batch02_Account_Test {
    
    private static Map<Integer, String> mapOpeningHoursFields  = new Map<Integer, String>();
    private static Map<Integer, String> mapClosingHoursFields = new Map<Integer, String>();
    private static Map<Integer, String> mapStartLunchBreakFields = new Map<Integer, String>();
    private static Map<Integer, String> mapEndLunchBreakFields = new Map<Integer, String>();
    private static Map<Integer, String> mapOpeningDays = new Map<Integer ,String>();
    
    private static Integer getDayOfTheWeek() { 
        Integer ret = -1;
        Datetime dt = System.now();
        String currentDay  = dt.format('EEEE');
        if(currentDay.equals('Sunday')) {
            ret = 0;
        }
        else if(currentDay.equals('Monday')) {
            ret = 1;
        }
         else if(currentDay.equals('Tuesday')) {
            ret = 2;
        }
         else if(currentDay.equals('Wednesday')) {
            ret = 3;
        }
         else if(currentDay.equals('Thursday')) {
            ret = 4;
        }
         else if(currentDay.equals('Friday')) {
            ret = 5;
        }
         else if(currentDay.equals('Saturday')) {
            ret = 6 ;
        }
       
        return ret;
   }
    
    private static void fillMaps() {
         
        mapOpeningHoursFields.put(0, 'Dimanche_Ouverture__c');
        mapOpeningHoursFields.put(1, 'Lundi_Ouverture__c');
        mapOpeningHoursFields.put(2, 'Mardi_Ouverture__c');
        mapOpeningHoursFields.put(3, 'Mercredi_Ouverture__c');
        mapOpeningHoursFields.put(4, 'Jeudi_Ouverture__c');
        mapOpeningHoursFields.put(5, 'Vendredi_Ouverture__c'); 
        mapOpeningHoursFields.put(6, 'Samedi_Ouverture__c'); 
        
        mapClosingHoursFields.put(0, 'Dimanche_Fermeture__c');
        mapClosingHoursFields.put(1, 'Lundi_Fermeture__c');
        mapClosingHoursFields.put(2, 'Mardi_Fermeture__c');
        mapClosingHoursFields.put(3, 'Mercredi_Fermeture__c');
        mapClosingHoursFields.put(4, 'Jeudi_Fermeture__c');
        mapClosingHoursFields.put(5, 'Vendredi_Fermeture__c'); 
         mapClosingHoursFields.put(6, 'Samedi_Fermeture__c');
        
        mapStartLunchBreakFields.put(0, 'dimanche_debut_pause_dejeuner__c');
        mapStartLunchBreakFields.put(1, 'lundi_debut_pause_dejeuner__c');
        mapStartLunchBreakFields.put(2, 'mardi_debut_pause_dejeuner__c');
        mapStartLunchBreakFields.put(3, 'mercredi_debut_pause_dejeuner__c');
        mapStartLunchBreakFields.put(4, 'jeudi_debut_pause_dejeuner__c');
        mapStartLunchBreakFields.put(5, 'vendredi_debut_pause_dejeuner__c');
        mapStartLunchBreakFields.put(6, 'samedi_debut_pause_dejeuner__c');
         
        mapEndLunchBreakFields.put(0, 'dimanche_fin_pause_dejeuner__c');
        mapEndLunchBreakFields.put(1, 'lundi_fin_pause_dejeuner__c');
        mapEndLunchBreakFields.put(2, 'mardi_fin_pause_dejeuner__c');
        mapEndLunchBreakFields.put(3, 'mercredi_fin_pause_dejeuner__c');
        mapEndLunchBreakFields.put(4, 'jeudi_fin_pause_dejeuner__c');
        mapEndLunchBreakFields.put(5, 'vendredi_fin_pause_dejeuner__c');
        mapEndLunchBreakFields.put(6, 'samedi_fin_pause_dejeuner__c');
         
         
        mapOpeningDays.put(0, 'Dimanche_ferme__c'); 
        mapOpeningDays.put(1, 'Lundi_ferme__c');
        mapOpeningDays.put(2, 'Mardi_ferme__c');
        mapOpeningDays.put(3, 'Mercredi_ferme__c');
        mapOpeningDays.put(4, 'Jeudi_ferme__c');
        mapOpeningDays.put(5, 'Vendredi_ferme__c');
        mapOpeningDays.put(6, 'Samedi_ferme__c');
    }


     testmethod static void testBatch() {
         User currentUser = [Select id , name , BypassProcessBuilder__c, BypassWorkflow__c, BypassApex__c, BypassValidationRule__c
                           from User
                           where id =: UserInfo.getUserId()];
        currentUser.BypassProcessBuilder__c = true;
        currentUser.BypassWorkflow__c = true;
        currentUser.BypassValidationRule__c = true;
        update currentUser;
         
        fillMaps();
        // create contact
        Contact c = Utils_TestMethods.CreateContact('Georges Hobeika');
        insert c;
        
        // create Macroprofil
        Macroprofil__c mp = Utils_TestMethods.CreateMacroprofil('MP Test');
        insert mp;
        
        Account acct = Utils_TestMethods.CreateAccount(c, mp,'Account Test');
        
        Integer dayOfTheWeek = getDayOfTheWeek(); 
        
        acct.put(mapOpeningHoursFields.get(dayOfTheWeek),'08:00');
        acct.put(mapClosingHoursFields.get(dayOfTheWeek),'18:00'); 
         
          //TMA JSA  
        acct.put(mapStartLunchBreakFields.get(dayOfTheWeek),'10:30');
        acct.put(mapEndLunchBreakFields.get(dayOfTheWeek),'11:00');
        acct.put(mapOpeningDays.get(dayOfTheWeek),false);
        
        insert acct;
         Account insertedAccount = [SELECT Id ,DisponibiliteFormule__c 
                        		   FROM Account 
                                   WHERE id = : acct.Id
                                   ];
         
        Test.startTest();
        Id batchJobId = Database.executeBatch(new Batch02_Account(), 200);
        
        Test.stopTest();
    }    
    
}