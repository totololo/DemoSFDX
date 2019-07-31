/*
* The aim of this class is to close anomalie if the account state is changed
* @author: Christine Bayssary
* @date: 13/08/2018
* @Test: AP04_Anomalie_Test
*/
public class AP04_Anomalie {
    /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
     Company: EI-technologies
     Description: Close of the anomalie if the account state is changed
     Inputs: list of new accounts , map of old value
     Returns: -
    --------------------------------------------------------------------------------------------------------------------------*/
    
    public static void clotureAnomalie (list<account> listAccount, map<id, account> mapOldAccount){
        list<id> listAccountIds = new list<Id>();
        
        for(account acc: listAccount){
            if(acc.etat__c != mapOldAccount.get(acc.id).etat__c && mapOldAccount.get(acc.id).etat__c == '2'){
                listAccountIds.add(acc.id);                
            }            
        }
        system.debug('AP04_Anomalie listAccountIds ' + listAccountIds);
        list<Anomalie__c> listAnomalie = [select id,type__c,statut__c
                                          from anomalie__c 
                                          where pudo__c in :listAccountIds
                                          and statut__c ='1'
                                          and type__c ='Association à tort Etat 2'];
        system.debug('AP04_Anomalie Queried listAnomalie ' + listAnomalie);
        for(anomalie__c anom : listAnomalie){
            anom.statut__c ='0';
        }
        system.debug('AP04_Anomalie New listAnomalie ' + listAnomalie);
        update listAnomalie;
    }
}