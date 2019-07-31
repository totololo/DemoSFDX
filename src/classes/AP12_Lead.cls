/*
* Author: John Boutros
* Modified By: John Boutros
* Date : 07/02/2018
* Description:
* Test classe: AP12_Lead_TEST
Coverage : 100%
*/
public class AP12_Lead {
    public static void VRShippingCountryRT(List<Lead> newLeads, Map<Id, Lead> oldLeads)
    {
        system.debug('VRShippingCountryRT entered');
        User currentUser = [Select id , name , BypassProcessBuilder__c, BypassValidationRule__c, BypassWorkflow__c
                            from User
                            where id =: UserInfo.getUserId()];
        if(currentUser.BypassValidationRule__c  == false)
        {
            system.debug('BypassValidationRule__c entered');
            // Liste de type d'enregistrement et de pays
            List<Association_Record_Type_et_pays__mdt> metadataRTPays = [SELECT ID_Piste__c, MasterLabel
                                                                         FROM Association_Record_Type_et_pays__mdt];
            Set<String> AssocPaysRT = new Set<String>();
            // ajouter les pays et les types d'enregistrement correspondants dans un set
            for(Association_Record_Type_et_pays__mdt metadataAssocPaysRT : metadataRTPays)
            {
                AssocPaysRT.add(metadataAssocPaysRT.MasterLabel+'_'+ metadataAssocPaysRT.ID_Piste__c);
            }
            String paysRTID ='';
            system.debug('newLeads '+newLeads);
            for(Lead leadRecord: newLeads)
            {
                if(!Label.RT_Consigne_Compte.Contains(leadRecord.RecordTypeId) )
                {
                    if(leadRecord.Country !=null)
                    {
                        //if updating
                        if(oldLeads!= null && oldLeads.ContainsKey(leadRecord.Id))
                        {
                            if(oldLeads.get(leadRecord.Id).Country != leadRecord.Country)
                            {
                                // valider le choix du pays
                                if(!AssocPaysRT.contains(leadRecord.Country+'_'+leadRecord.RecordTypeId))
                                {
                                    leadRecord.Country.addError(Label.Pays_TypeEnregistrment);
                                }
                            }
                        }
                        //if inserting
                        else{    
                            paysRTID = leadRecord.Country+'_'+leadRecord.RecordTypeId;
                            // valider le choix du pays
                            system.debug('paysRTID '+paysRTID);
                            system.debug('AssocPaysRT '+AssocPaysRT);
                            if(!AssocPaysRT.contains(paysRTID))
                            {
                                system.debug('leadRecord 4 '+leadRecord);
                                leadRecord.Country.addError(Label.Pays_TypeEnregistrment);
                            }
                        }
                    }
                }
            }
        }
    }
}