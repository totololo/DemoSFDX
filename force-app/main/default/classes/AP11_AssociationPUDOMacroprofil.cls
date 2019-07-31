/*
* Author: John Boutros
* Modified By: -
* Date : 04/01/2018
* Description: Renseigner automatiquement le champs Macroprofil_actuel__c lors de la creation d'un compte (before insert)
* Test classe: AP11_AssociationPUDOMacroprofil_TEST
Coverage : 100%
*/
public class AP11_AssociationPUDOMacroprofil {
    public static void associationPUDOMacroprofil(List<Account> newAccountList, map<id, Account> oldAccountMap)
    {
        set<id> setAccountId = new set<id>();
        for(account acc: newAccountList){
            if(acc.id != null){
                setAccountid.add(acc.id);}
        }
        system.debug('AP11_AssociationPUDOMacroprofil setAccountId '+setAccountId);
        String test = '';
        list<lead> listLeadConverted = new list<lead>();
        if(!setAccountId.isEmpty())
        {
            system.debug('AP11_AssociationPUDOMacroprofil setAccountId before if '+setAccountId);
            listLeadConverted = [select id,ConvertedAccountId,IsConverted,Type_de_point__c 
                                 from lead 
                                 where IsConverted =true and ConvertedAccountId in :setAccountId];        
        }
        
        
        map<id,lead> mapLeadAccount = new map<id,lead>();
        system.debug('listLeadConverted '+listLeadConverted);
        for(lead lead : listLeadConverted){
            mapLeadAccount.put(lead.ConvertedAccountId, lead); 
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        system.debug('newAccountList '+newAccountList);
        for(Account accountTocheck: newAccountList){
            if(accountTocheck.Macroprofil_actuel__c == null){
                if(mapLeadAccount.containsKey(accountTocheck.Id)){
                    system.debug('mapLeadAccount.get(accountTocheck.id).Type_de_point__c '+mapLeadAccount.get(accountTocheck.id).Type_de_point__c);
                    if(mapLeadAccount.get(accountTocheck.id).Type_de_point__c != null){
                        accountTocheck.Type = mapLeadAccount.get(accountTocheck.id).Type_de_point__c;   
                    }
                }               
                accountsToUpdate.add(accountTocheck);   
            }
            else if (oldAccountMap!=null &&
                     (!(oldAccountMap.containsKey(accountTocheck.Id)) 
                      || accountTocheck.ShippingCountry != oldAccountMap.get(accountTocheck.Id).ShippingCountry 
                      || accountTocheck.Type != oldAccountMap.get(accountTocheck.Id).Type
                     )){
                         accountsToUpdate.add(accountTocheck);
                     }
        }
        system.debug('newAccountList '+newAccountList);
        //Liste des valeurs du custom setting AssociationPUDOMacroprofil__c
        List<Association_PUDO_Macroprofil__mdt> metadatasAssocPudoMacro = (List<Association_PUDO_Macroprofil__mdt>) new AssociationPUDOMacroprofil().getCustomMetadataRecords(
            'Select id, Pays__c, Partenaire__c, Type_de_point__c, Id_du_Macroprofil__c From Association_PUDO_Macroprofil__mdt'
        );
        Map<String, ID> metadataAssocPudoMacroMap = new Map<String, ID>();
        String key = '';
        String key1 = '';
        for(Association_PUDO_Macroprofil__mdt metadataAssocPudoMacro : metadatasAssocPudoMacro ){
            key = metadataAssocPudoMacro.Pays__c+'_'+ metadataAssocPudoMacro.Type_de_point__c;
            key1 = metadataAssocPudoMacro.Partenaire__c;
            if(key1 != null && !metadataAssocPudoMacroMap.containsKey(key1)){
                metadataAssocPudoMacroMap.put(key1, metadataAssocPudoMacro.Id_du_Macroprofil__c);
            }
            else if(!metadataAssocPudoMacroMap.containsKey(key)){
                metadataAssocPudoMacroMap.put(key, metadataAssocPudoMacro.Id_du_Macroprofil__c);
            }
        }
        for(Account newAccount : accountsToUpdate)
        {
            if(!LABEL.RT_France_Compte.contains(newAccount.recordTypeID) )
            {  
                key = newAccount.shippingCountry+'_'+newAccount.Type;
                system.debug('metadataAssocPudoMacroMap.get(newAccount.Partenaire__c) '+metadataAssocPudoMacroMap.get(newAccount.Partenaire__c));
                system.debug('metadataAssocPudoMacroMap.get(key) '+metadataAssocPudoMacroMap.get(key));
                if(metadataAssocPudoMacroMap.containsKey(newAccount.Partenaire__c))
                {
                    newAccount.Macroprofil_actuel__c = metadataAssocPudoMacroMap.get(newAccount.Partenaire__c);
                }
                else if(metadataAssocPudoMacroMap.containsKey(key))
                {
                    newAccount.Macroprofil_actuel__c = metadataAssocPudoMacroMap.get(key);
                }
            }
        }
    }
}