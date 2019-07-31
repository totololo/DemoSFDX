/*
* The aim of this class is to modify the field ServiceNameTranslation in the related service
* @author: Christine Bayssary
* @date: 30/08/2018
* @Test: AP01_ServiceAssocie_Test
*/
public class AP01_ServiceAssocie {
    
    public static boolean isRunning = true;
    
    public static void fillNomService(list<Service_Associe__c> listServiceAssocie){
        
        list<id> listServiceIds = new list<id>();
        for(Service_Associe__c s : listServiceAssocie){
            listServiceIds.add(s.Service__c);}
        
        map<id,service__c> mpServices  = new map<id, service__c>([select id, name, Nom_du_service_translated__c 
                                                                  from service__c 
                                                                  where id in:listServiceIds]);
        for(Service_Associe__c s : listServiceAssocie){
            if(mpServices.containskey(s.Service__c)){
                s.Nom_du_service_traduit__c = mpServices.get(s.Service__c).Nom_du_service_translated__c;}}        
    } 
    
    public static void fillNomService2(list<Service_Associe__c> listServiceAssocie, map<id,Service_Associe__c> oldMapServiceAssociee){
        list<id> listServiceIds = new list<id>();
        list<Service_Associe__c> listServicesAssocieeUpdated  = new list<Service_Associe__c>();
        for(Service_Associe__c s : listServiceAssocie){
            if(s.Service__c != oldMapServiceAssociee.get(s.id).Service__c){
                listServiceIds.add(s.Service__c);
            }}
        
        map<id,Service__c> mapServices = new map<id,Service__c>([select id,Nom_du_service_translated__c 
                                                                 from service__c 
                                                                 where id in :listServiceIds]);
        
        for(Service_Associe__c s :listServiceAssocie){
            if(mapServices.containsKey(s.Service__c)){
                s.Nom_du_service_traduit__c =  mapServices.get(s.Service__c).Nom_du_service_translated__c;
            }
            
        }
        
    }
    
    public static void updateNomService(list<Service__c> listServices, map<id,Service__c> oldMapService){
        
        list<id> listServiceIds = new list<id>();
        map<id,service__c> mpServices  = new map<id, service__c>();
        for(Service__c s : listServices){
            if(s.Nom_du_service_translated__c != oldMapService.get(s.id).Nom_du_service_translated__c){
                listServiceIds.add(s.id);
                mpServices.put(s.id,s);}}
        
        list<Service_Associe__c> listServiceAssocie  = [select id, name, Nom_du_service_traduit__c,Service__c 
                                                        from Service_Associe__c 
                                                        where service__c in:listServiceIds
                                                        and Modifiable__c = true];
        for(Service_Associe__c s : listServiceAssocie){
            if(mpServices.containskey(s.Service__c)){
                s.Nom_du_service_traduit__c = mpServices.get(s.Service__c).Nom_du_service_translated__c;}}  
        isRunning =  false;
        update listServiceAssocie;
    } 
}