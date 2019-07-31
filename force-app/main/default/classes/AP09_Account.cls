/*
* Class to show the disponibilte of an account
* @author: Georges Hobeika
* @date: 02/03/2017
* @Test: AP09_Account_Test
*/
public class AP09_Account {
    
    public static boolean firstRun = true;
    
    private static Map<Integer, String> mapOpeningHoursFields  = new Map<Integer, String>();
    private static Map<Integer, String> mapClosingHoursFields = new Map<Integer, String>();
    private static Map<Integer, String> mapStartLunchBreakFields = new Map<Integer, String>();
    private static Map<Integer, String> mapEndLunchBreakFields = new Map<Integer, String>();
    private static Map<Integer, String> mapOpeningDays = new Map<Integer ,String>();
    private static Map<Integer, String> mapDays = new Map<Integer, String>();
    private static String horaireOuvertureReference = 'Horaire_Ouverture_Reference__c';
    private static String horaireFermetureReference = 'Horaire_Fermeture_Reference__c';
    private static String debutPauseDejeuner = 'Debut_pause_dejeuner__c';
    private static String finPauseDejeuner = 'Fin_pause_dejeuner__c';
    
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
         
        mapDays.put(0, 'Dimanche__c');
        mapDays.put(1, 'Lundi__c');
        mapDays.put(2, 'Mardi__c');
        mapDays.put(3, 'Mercredi__c');
        mapDays.put(4, 'Jeudi__c');
        mapDays.put(5, 'Vendredi__c');
        mapDays.put(6, 'Samedi__c');
         
        
    }
   
     
    public static void defineAccountDailyDisponibility(Map<Id,Account> mapNewAccounts ,Map<Id,Account> mapOldAccounts) {
        
        if(firstRun) {
            firstRun = false;        
        }
        
        Integer dayOfTheWeek = getDayOfTheWeek();
        //get the list of accounts with schedule of the current day modified or schedule of the lunch break;
        List<Account> lstAccountsToBeTreated = new List<Account>();
        
        Account oldAccount = null; 
        String strOpeningHourField;
        String strClosingHourField;
        String strStartLunchBreakField;
        String strEndLunchBreakField;
        String strReferenceDay;
        boolean bToBeTreated; 
        
        fillMaps();
		       	
        for(Account acct : mapNewAccounts.values()){ 
            bToBeTreated = false;
            oldAccount = mapOldAccounts.get(acct.Id);
            strOpeningHourField = mapOpeningHoursFields.get(dayOfTheWeek); 
            strClosingHourField = mapClosingHoursFields.get(dayOfTheWeek); 
            strStartLunchBreakField  = mapStartLunchBreakFields.get(dayOfTheWeek); 
            strEndLunchBreakField = mapEndLunchBreakFields.get(dayOfTheWeek); 
            strReferenceDay = mapDays.get(dayOfTheWeek);
            
            
            if(  acct.get(mapOpeningDays.get(dayOfTheWeek)) != oldAccount.get(mapOpeningDays.get(dayOfTheWeek)) ||
                 acct.get(strOpeningHourField) != oldAccount.get(strOpeningHourField) ||
                ( acct.get(strClosingHourField) != oldAccount.get(strClosingHourField))|| 
                (acct.get(strStartLunchBreakField) != oldAccount.get(strStartLunchBreakField)) ||
                (acct.get(strEndLunchBreakField) != oldAccount.get(strEndLunchBreakField)) ||
                (acct.Debut_pause_dejeuner__c != null && acct.Debut_pause_dejeuner__c != oldAccount.Debut_pause_dejeuner__c ) ||
                (acct.Fin_pause_dejeuner__c != null && acct.Fin_pause_dejeuner__c != oldAccount.Fin_pause_dejeuner__c  ) ||
               	acct.get(horaireOuvertureReference) != oldAccount.get(horaireOuvertureReference) ||
                acct.get(horaireFermetureReference) != oldAccount.get(horaireFermetureReference) ||
                acct.get(strReferenceDay) != OldAccount.get(strReferenceDay)
              ) {
                    lstAccountsToBeTreated.add(acct);
            }
        } 
        if(lstAccountsToBeTreated.size() > 0) {  
            defineAccountDailyDisponibility(lstAccountsToBeTreated,false);
        } 
    }
	
    public static void defineAccountDailyDisponibility(List<Account> lstAccounts , boolean fromBatch) {
	
        if(mapOpeningHoursFields.size() == 0){
            fillMaps();
        }
        
        Integer dayOfTheWeek = getDayOfTheWeek();
        System.debug('!!!gho dayOfTheWeek : ' + dayOfTheWeek);
        Integer intOpeningHour = -1;
        Integer intClosingHour = -1;
        Integer intStartLunchBreakHour = -1 ;
        Integer intEndLunchBreakHour = -1;
        Boolean bHoraireReference = false;
        for(Account acct : lstAccounts) {    
            
            bHoraireReference = Boolean.valueOf(acct.get(mapDays.get(dayOfTheWeek)));
             
            if(bHoraireReference){ 
                intOpeningHour = convertTimeToNumber((String)acct.get(horaireOuvertureReference)) ; 
            }else {
                if(acct.get(mapOpeningHoursFields.get(dayOfTheWeek)) != null) {
                    intOpeningHour = convertTimeToNumber((String) acct.get(mapOpeningHoursFields.get(dayOfTheWeek))); 
                }  
            }
                            
            if(bHoraireReference){
                intClosingHour = convertTimeToNumber((String)acct.get(horaireFermetureReference)) ; 
            }else {
                if(acct.get(mapClosingHoursFields.get(dayOfTheWeek)) != null) {
                    intClosingHour = convertTimeToNumber((String) acct.get(mapClosingHoursFields.get(dayOfTheWeek)));
                }
            }
           
            if(bHoraireReference) {
                intStartLunchBreakHour = convertTimeToNumber((String) acct.Debut_pause_dejeuner__c);
            }else {
                if(acct.get(mapStartLunchBreakFields.get(dayOfTheWeek)) != null) {
                    intStartLunchBreakHour = convertTimeToNumber((String) acct.get(mapStartLunchBreakFields.get(dayOfTheWeek)));//modified by TMAEITL FEK | convertTimeToNumber((String) acct.Debut_pause_dejeuner__c);
                }
            }
             
            
            if(bHoraireReference) {
                intEndLunchBreakHour = convertTimeToNumber((String) acct.Fin_pause_dejeuner__c);
            }else {
                if(acct.get(mapEndLunchBreakFields.get(dayOfTheWeek)) != null) {
                    intEndLunchBreakHour = convertTimeToNumber((String) acct.get(mapEndLunchBreakFields.get(dayOfTheWeek)));
                }
            }
          
              
            if(acct.get(mapOpeningDays.get(dayOfTheWeek)) == true) {
                acct.Tech_Number_Opening_Hour__c = -1;
                acct.Tech_Number_Closing_Hour__c = -1;
                acct.Tech_Number_Start_Lunch_Hour__c = -1;
                acct.Tech_Number_End_Lunch_Hour__c = -1;
            }else {
               
                acct.Tech_Number_Opening_Hour__c = intOpeningHour;
                acct.Tech_Number_Closing_Hour__c = intClosingHour; 
                acct.Tech_Number_Start_Lunch_Hour__c = intStartLunchBreakHour;
                acct.Tech_Number_End_Lunch_Hour__c = intEndLunchBreakHour;
            }
           
             
        }  
        
        if(fromBatch) {
            System.debug('AP09_Account updating account');
            Database.SaveResult[] srList = Database.update(lstAccounts,false);
            if(Label.is_Batch_Logs_Active == 'true'){
                List<Batch_Log__c> LBatchLogs = new List<Batch_Log__c>();
                //for (Database.SaveResult sr : srList) {
                for (Integer i = 0; i < lstAccounts.size(); i++) {
                    Database.SaveResult sr = srList[i];
                    Account origRecord = lstAccounts[i];
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            LBatchLogs.add(new Batch_log__c(Status_Code__c = '' + err.getStatusCode(),
                                                            Message__c = err.getMessage(),
                                                            Fields__c = '' + err.getFields(),
                                                            ID__c = origRecord.Id
                                                           ));
                        }
                    }
                }
                if(LBatchLogs.size() > 0){
                    insert LBatchLogs;
                }
            }
        }
    }
    
    private static Integer convertTimeToNumber(String strTime) {
        // Convert time to number ex --> 08:30 = (08*60) + 30
        // To be Comparable
        Integer ret = -1;
		Integer intHour;
        Integer intMinutes; 
        
        if(strTime != null && strTime.indexOf(':') > -1) {
            intHour    = Integer.valueOf(strTime.substring(0,strTime.indexOf(':')));
            intMinutes = Integer.valueOf(strTime.substring(strTime.indexOf(':') + 1 ,strTime.length()));
        	ret = intHour * 60 + intMinutes;
        }                 
        return ret;
    }
    
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
    
}