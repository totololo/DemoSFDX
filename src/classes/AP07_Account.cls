/*--------------------------------------------------------------------------
*Author: Chahid Khalil
*Company : EI Technologies Liban
*Description: class used in Batch09_AccountRequette
*Test Class: Batch09_AccountRequette_Test
*Created Date: 27/04/2018
--------------------------------------------------------------------------*/
public class AP07_Account {
    
    public static void CreateCase(List<Account> newAccounts){
        List<Batch_Log__c> LBatchLogs = new List<Batch_Log__c>();
        Set<ID> congesRecordTypeIDs = new Set<Id>();
        List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id, MasterLabel, ID_Requete_Conge__c
                                                                            FROM Association_Record_Type_et_pays__mdt];
        Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPays =  new Map<String,Association_Record_Type_et_pays__mdt>();
        for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPays)
        {
            mapassociationRTPays.put(mdtRecord.MasterLabel, mdtRecord);
            if (mdtRecord.ID_Requete_Conge__c != null)
            {                
                congesRecordTypeIDs.add(mdtRecord.ID_Requete_Conge__c);
            }
        }
        
        List<Case> NewCaseList = new List<Case>();
        Set<Id> AccountIds = New Set<Id>();
        List<Account> account_MetCondition =  new List<Account>();
        for(Account acc : newAccounts)
        {
            if (//(Label.RT_INT_Compte.contains(acc.RecordTypeId) || Label.RT_INT_Compte2.contains(acc.RecordTypeId)) &&
                !Label.RT_Consigne_Compte.contains(acc.RecordTypeId)) 
            {
                AccountIds.add(acc.Id); 
                account_MetCondition.add(acc); 
            }
        }
        if (AccountIds.size()>0)
        {
            Integer thisYear = Date.today().year();
            List<AggregateResult> AccountCase_List = [SELECT AccountId CaseAccountId ,count(Id) CaseCount 
                                                      FROM Case
                                                      WHERE AccountId in :AccountIds and
                                                      ((CALENDAR_YEAR(CreatedDate) =: thisYear 
                                                        and account.shippingcountry !='France')
                                                      or account.shippingcountry ='France')
                                                      and RecordTypeId IN : congesRecordTypeIDs         
                                                      GROUP BY AccountId];// case should be open
            Map<Id,Integer> MapAccount_Case  = new Map<Id,Integer>();
            for (AggregateResult result : AccountCase_List)
            {            
                MapAccount_Case.put((id)result.get('CaseAccountId'), (Integer)result.get('CaseCount'));
            }   
            
            List<Conge_Indispo__c> Conge_IndispoList =[SELECT Nom_du_compte__c 
                                                         FROM Conge_Indispo__c 
                                                        WHERE Nom_du_compte__c in :AccountIds and
                                                              TECH_Conges_Dispo_Juillet_Aout__c = true];
            //Map containing Account with conge List
            Map<Id,List<Conge_Indispo__c>> MapAccount_Conge = new Map<Id,List<Conge_Indispo__c>>();
            for (Conge_Indispo__c ci : Conge_IndispoList)
            {
                if(!MapAccount_Conge.containsKey(ci.Nom_du_compte__c))
                {
                    MapAccount_Conge.put(ci.Nom_du_compte__c, new List<Conge_Indispo__c>());
                }              
                MapAccount_Conge.get(ci.Nom_du_compte__c).add(ci);
            }   
            
            for(Account currentacc : account_MetCondition){ 
                if (!MapAccount_Conge.containsKey(currentacc.id) && !MapAccount_Case.containsKey(currentacc.id))               
                {
                    if (currentacc.ShippingCountry !='' && currentacc.ShippingCountry != null){
                        //France
                       if(currentacc.ShippingCountry == 'France'){
                        Case newCase = new Case();
                        newCase.Status = Label.ReQuette_En_attente_de_traitement;// no translation needed
                        Association_Record_Type_et_pays__mdt temp_Association_R = mapassociationRTPays.get(currentacc.ShippingCountry);
                        newCase.RecordTypeId = temp_Association_R.ID_Requete_Conge__c ;
                        newCase.ContactId = currentacc.Contact_operationnel_1__c;
                        newCase.AccountId = currentacc.id;
                        newCase.ownerId = label.FileWebHelp_ID_FR;
                        newCase.Object_de_la_requete__c='Les Congés du relais';
                        NewCaseList.add(newCase);
                        }
                     //BNL + Hongrie
                     else{
                        Case newCase = new Case();
                        newCase.Status = Label.ReQuette_En_attente_de_traitement;// no translation needed
                        Association_Record_Type_et_pays__mdt temp_Association_R = mapassociationRTPays.get(currentacc.ShippingCountry);
                        newCase.RecordTypeId = temp_Association_R.ID_Requete_Conge__c ;
                        newCase.ContactId = currentacc.Contact_operationnel_1__c;
                        newCase.AccountId = currentacc.id;
                        newCase.Object_de_la_requete__c='Les Congés du relais';
                        NewCaseList.add(newCase);  
                        }
                    }
                    else{
                         LBatchLogs.add(new Batch_log__c(Status_Code__c = 'AP07_Account', Message__c = Label.Message_No_Shipping_Country, Fields__c = Label.Shipping_Country, ID__c = currentacc.id
                            ));
                    }
                }
            }            
            Database.SaveResult[] srList = Database.insert(NewCaseList,false);
            if(Label.is_Batch_Logs_Active == 'true'){
                //List<Batch_Log__c> LBatchLogs = new List<Batch_Log__c>();
                for (Integer i = 0; i < NewCaseList.size(); i++) {
                    Database.SaveResult sr = srList[i];
                    Case origRecord = NewCaseList[i];
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            LBatchLogs.add(new Batch_log__c(Status_Code__c = '' + err.getStatusCode(), Message__c = err.getMessage(), Fields__c = '' + err.getFields(), ID__c = sr.Id ));
                        }
                    }
                }
                if(LBatchLogs.size() > 0){
                    insert LBatchLogs;
                }
            }
        }
    }      
}