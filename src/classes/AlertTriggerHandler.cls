/* Author       : Gildas ADOUKONOU
* Date          : 2018-11-27
* Description   : This class is the handler of Trigger on Alert__c Object. This class prevent the insert of an existing  current alert  or a current case on the PUDO, call the right flow according to the type of alerting
* 
*/
public with sharing class AlertTriggerHandler {
    public static void handleBeforeInsert(List<Alert__c> listNewAlert){
        For(Alert__c alert :listNewAlert){
            alert.Status__c='1';
        }
        
    }
    public static void handleAfterInsert(List<Alert__c> listNewAlert){
        List<Alert__c> listAlertOverload = new list<Alert__c>();
        List<Alert__c> listAlertMissRoutedFull = new list<Alert__c>();
        List<Alert__c> listAlertMissRoutedPartial = new list<Alert__c>();
        For(Alert__c alert: listNewAlert){
            //Alert Dévoyé full 
            If(alert.alert_type__c=='2' && alert.Missguided_Type__c=='1'){ 
                listAlertMissRoutedFull.add(alert);
            }
            //Alert Dévoyé partiel
            If(alert.alert_type__c=='2' && alert.Missguided_Type__c=='2' ){
                listAlertMissRoutedPartial.add(alert);
            }
            //Alert surcharge
            If(alert.alert_type__c=='1' ){
                listAlertOverload.add(alert);
            }
        }
        Map<String, List<Object>> paramsOverload = new Map<String, List<Object>>();
        Map<String, List<Object>> paramsMissroutedFull = new Map<String, List<Object>>();
        Map<String, List<Object>> paramsMissroutedPartial = new Map<String, List<Object>>();
        if(listAlertOverload.size()>0){
            paramsOverload.put('ListAlertInput',listAlertOverload);
            Flow.Interview.Traitement_alerte_Surcharge TraitementFlowBIOverload = new Flow.Interview.Traitement_alerte_Surcharge(paramsOverload);
            TraitementFlowBIOverload.start();
            System.debug((List<Alert__c>)(TraitementFlowBIOverload.getVariableValue('ListAlertInput')));
            System.debug('traitement surcharge');    
        }
        if(listAlertMissRoutedFull.size()>0){
            paramsMissroutedFull.put('ListAlertInput',listAlertMissRoutedFull);
            Flow.Interview.Traitement_devoye_Full TraitementFlowBIMissroutedFull = new Flow.Interview.Traitement_devoye_Full(paramsMissroutedFull);
            TraitementFlowBIMissroutedFull.start();
            System.debug((List<Alert__c>)(TraitementFlowBIMissroutedFull.getVariableValue('ListAlertInput')));
            System.debug('traitement devoyé complet');         }
        if(listAlertMissRoutedPartial.size()>0){
            paramsMissroutedPartial.put('ListAlertInput',listAlertMissRoutedPartial);
            Flow.Interview.Traitement_devoyer_partiel TraitementFlowBIMissroutedPartial = new Flow.Interview.Traitement_devoyer_partiel(paramsMissroutedPartial);
            TraitementFlowBIMissroutedPartial.start();
            System.debug((List<Alert__c>)(TraitementFlowBIMissroutedPartial.getVariableValue('ListAlertInput')));
            System.debug('traitement devoyé partiel start');
                
        }

    }
    public static void handleAfterUpdate(List<Alert__c> listNewAlert){
        List<Alert__c> listAlertReponseSurcharge = new list<Alert__c>();
        List<Alert__c> listAlertReponseDevoye = new list<Alert__c>();
        For(Alert__c alert: listNewAlert){
            
            If(alert.Retour_Msg_PDA_Trait__c==False && alert.alert_type__c=='1'){
                    listAlertReponseSurcharge.add(alert);
            }
            If(alert.Retour_Msg_PDA_Trait__c==False && alert.alert_type__c=='2'){
                    listAlertReponseDevoye.add(alert);
            }
        }
        If(listAlertReponseSurcharge.size()>0){
            Map<String, List<Object>> params = new Map<String, List<Object>>();
            params.put('ListAlertInput',listAlertReponseSurcharge);
            Flow.Interview.Traitement_retour_Message_PDA_Surcharge retourTraitementFlowSurcharge = new Flow.Interview.Traitement_retour_Message_PDA_Surcharge(params);
            retourTraitementFlowSurcharge.start();
            System.debug((List<Alert__c>)(retourTraitementFlowSurcharge.getVariableValue('ListAlertInput')));
            System.debug('retourPDA start');
        }
        If(listAlertReponseDevoye.size()>0){
            Map<String, List<Object>> params = new Map<String, List<Object>>();
            params.put('ListAlertInput',listAlertReponseDevoye);
            Flow.Interview.Traitement_retour_Message_PDA_Devoye retourTraitementFlowDevoye = new Flow.Interview.Traitement_retour_Message_PDA_Devoye(params);
            retourTraitementFlowDevoye.start();
            System.debug((List<Alert__c>)(retourTraitementFlowDevoye.getVariableValue('ListAlertInput')));
            System.debug('retourPDA start');
        }
      
    }
}