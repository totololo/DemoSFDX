public class AP11_Account {
    //TODO: Change everything to labels
    //TODO: Tidy up
    static Boolean isDFA56 = false;
    public static void changerEtatModeSelonDFA(List<Account> LAccounts){
        
        System.debug('AP11_Account.changerEtatModeSelonDFA start');
        List<Account> LAccRetourEtat = new List<Account>();     //Cette liste sera utilisée pour faire un rollback des etat et mode de ses comptes 
        List<Account> LAccSansRetourEtat = new List<Account>(); //Cette liste sera utilisée pour les autres comptes
        system.debug('JMB LAccounts '+LAccounts);
        for(Account acc:LAccounts){
            //si on a changé les dates fin [PUDO_PB14_Retour_EtatMode]
            //Cette partie sera considérée seulement par les triggers car on fait une requête avec condition 'Date_de_fin_d_activite__c <> null' dans le batch 
            if(acc.Date_de_fin_d_activite__c == null && (acc.Etat__c == Label.Account_Etat_6 || acc.Etat__c == Label.Account_Etat_7)){
                system.debug('christine LAccRetourEtat 1 '+LAccRetourEtat);
                acc.Contexte__c = null;
                acc.Motif__c = null;
                LAccRetourEtat.add(acc);
                continue;                   //continuer le for, rien à faire avec les autres conditions
            }
            //Pour prendre en considération les pays INT
            else if(acc.RecordTypeId != null && (! Label.RT_Consigne_Compte.contains(acc.RecordTypeId) && acc.Date_de_fin_d_activite__c != null && acc.Date_de_fin_d_activite__c > Date.today().addDays(56) && (acc.Etat__c == '6' || acc.Etat__c == '7')) ){
                //else if(acc.RecordTypeId != Label.AccountConsigneRT_15 && acc.Date_de_fin_d_activite__c != null && acc.Date_de_fin_d_activite__c > Date.today().addDays(56) && (acc.Etat__c == '6' || acc.Etat__c == '7')){
                system.debug('christine LAccRetourEtat 2 '+LAccRetourEtat);
                system.debug('Date >= 56');
                acc.Etat__c = '5';
                acc.Mode__c = '300';
                isDFA56 = true;
                LAccRetourEtat.add(acc);
                continue;                   //continuer le for, rien à faire avec les autres conditions
            }
            else if(acc.Date_de_fin_d_activite__c == null && (acc.Etat__c == '2' || acc.Etat__c == '4' || acc.Etat__c == '5')){acc.Contexte__c = null;acc.Motif__c = null;
                                                                                                                              }
            //fin de partie
            
            system.debug('AP11_Account acc.RecordTypeId ' + acc.RecordTypeId);
            
            //Si recordType n'est pas PUS_FR_Consigne [PB07 - Changement Etat/Mode 6-7]
            if(acc.RecordTypeId != null && (!Label.RT_Consigne_Compte.contains(acc.RecordTypeId) )) { //Pour prendre en considération les pays INT
                //if(acc.RecordTypeId != Label.AccountConsigneRT_15){
                //quelque soit le contexte, si DFA > today + 56 : pas de changements
                system.debug('AP11_Account acc.Date_de_fin_d_activite__c ' + acc.Date_de_fin_d_activite__c);
                if(acc.Date_de_fin_d_activite__c != null && acc.Date_de_fin_d_activite__c <= Date.today().addDays(56)){
                    system.debug('Date <= 56');
                    //si today + 21 < DFA <= today + 56
                    //- contexte 'Résiliation'  : Passage à état 6, mode 740 (suggéré)
                    //- contexte 'Exclusion'    : Passage à état 6, mode 730
                    if(acc.Date_de_fin_d_activite__c > Date.today().addDays(21) ){
                        system.debug('21 < Date <= 56');
                        if(acc.Contexte__c == Label.Account_Contexte_Resiliation && acc.Mode__c != Label.Account_Mode_ResiliationSuggere){acc.Etat__c = Label.Account_Etat_6; acc.Mode__c = Label.Account_Mode_ResiliationSuggere;
                                                                                                                                         }
                        else if(acc.Contexte__c == Label.Account_Contexte_Exclusion && acc.Mode__c != Label.Account_Mode_ExclusionSuggere){
                            acc.Etat__c = Label.Account_Etat_6;
                            acc.Mode__c = Label.Account_Mode_ExclusionSuggere;
                        }
                    }else
                        //si today < DFA <= today + 21 et RecordType = PUDO Suivit OU non suivi OU Contact (pour le contact, si le contexte est vide, rien ne se passe)
                        //- contexte 'Résiliation'  : Passage à état 6, mode 745 (non suggéré)
                        //- contexte 'Exclusion'    : Passage à état 6, mode 735
                        if(acc.RecordTypeId != null && (acc.Date_de_fin_d_activite__c > Date.today() 
                                                        //Pour prendre en considération les pays INT
                                                        && (Label.RT_NonSuiviCo_Compte.contains(acc.RecordTypeId) || Label.RT_PickupContact_Compte.contains(acc.RecordTypeId)
                                                            ||Label.RT_SuiviCo_Compte.contains(acc.RecordTypeId))) ) {
                                                                /* if(acc.Date_de_fin_d_activite__c > Date.today()  
&& (acc.RecordTypeId == Label.AccountNonSuiviCoRT 
||acc.RecordTypeId == Label.AccountPickupContactRT || acc.RecordTypeId == Label.AccountPudoSuiviCoRT)){*/
                                                                system.debug('Today < Date <= 21');
                                                                if(acc.Contexte__c == Label.Account_Contexte_Resiliation && acc.Mode__c != Label.Account_Mode_ResiliationNonSuggere){
                                                                    acc.Etat__c = Label.Account_Etat_6;
                                                                    acc.Mode__c = Label.Account_Mode_ResiliationNonSuggere;
                                                                }
                                                                else if(acc.Contexte__c == Label.Account_Contexte_Exclusion && acc.Mode__c != Label.Account_Mode_ExclusionNonSuggere){
                                                                    acc.Etat__c = Label.Account_Etat_6;
                                                                    acc.Mode__c = Label.Account_Mode_ExclusionNonSuggere;
                                                                }
                                                            }
                    //Passage Etat 7, Mode 900 (Inactif)
                    //Pour prendre en considération les pays INT
                    else if(acc.RecordTypeId != null && (acc.Date_de_fin_d_activite__c != null &&  acc.Date_de_fin_d_activite__c <= Date.today()  
                                                         && (acc.Etat__c != Label.Account_Etat_7 || acc.Mode__c != Label.Account_Mode_Inactif || acc.En_attente_de_courrier__c != null)
                                                         && (Label.RT_SuiviCo_Compte.contains(acc.RecordTypeId) || Label.RT_PickupContact_Compte.contains(acc.RecordTypeId) ||  Label.RT_NonSuiviCo_Compte.contains(acc.RecordTypeId) || Label.RT_Consigne_Compte.contains(acc.RecordTypeId))) ){
                                                             /*else if(acc.Date_de_fin_d_activite__c != null &&  acc.Date_de_fin_d_activite__c <= Date.today()  
&& (acc.Etat__c != Label.Account_Etat_7 || acc.Mode__c != Label.Account_Mode_Inactif || acc.En_attente_de_courrier__c != null)
&& (acc.RecordTypeId == Label.AccountPudoSuiviCoRT 
|| acc.RecordTypeId == Label.AccountPickupContactRT || acc.RecordTypeId == Label.AccountNonSuiviCoRT || acc.RecordTypeId == Label.AccountConsigneRT_15)){*/
                                                             
                                                             acc.Etat__c = Label.Account_Etat_7;
                                                             acc.Mode__c = Label.Account_Mode_Inactif;
                                                             acc.En_attente_de_courrier__c = null;
                                                         }
                }
            }
            //Si recordtype est PUS_FR_Consigne  [CONS_PB01_Date_FDA_renseignee]
            else{
                System.debug('PUDO Consigne');
                //pas de condition sur TODAY + 56, si DFA > TODAY + 21, passage à Etat 6 et Mode selon le contexte
                if(acc.Date_de_fin_d_activite__c != null && acc.Date_de_fin_d_activite__c >= Date.today().addDays(22) ){
                    System.debug('Consigne DFA >= TODAY + 22');
                    if(acc.Contexte__c == Label.Account_Contexte_Exclusion && acc.Mode__c != Label.Account_Mode_ExclusionSuggere){
                        acc.Etat__c = Label.Account_Etat_6;
                        acc.Mode__c = Label.Account_Mode_ExclusionSuggere;
                    }
                    else if(acc.Contexte__c == Label.Account_Contexte_Resiliation && acc.Mode__c != Label.Account_Mode_ResiliationSuggere){
                        acc.Etat__c = Label.Account_Etat_6;
                        acc.Mode__c = Label.Account_Mode_ResiliationSuggere;
                    }
                }
                else if(acc.Date_de_fin_d_activite__c != null && acc.Date_de_fin_d_activite__c <= Date.today().addDays(21) && acc.Date_de_fin_d_activite__c > Date.today()){
                    if(acc.Contexte__c == Label.Account_Contexte_Exclusion && acc.Mode__c != Label.Account_Mode_ExclusionNonSuggere){
                        acc.Etat__c = Label.Account_Etat_6;
                        acc.Mode__c = Label.Account_Mode_ExclusionNonSuggere;
                    }
                    else if(acc.Contexte__c == Label.Account_Contexte_Resiliation && acc.Mode__c != Label.Account_Mode_ResiliationNonSuggere){
                        acc.Etat__c = Label.Account_Etat_6;
                        acc.Mode__c = Label.Account_Mode_ResiliationNonSuggere;
                    }
                }
                else if(acc.Date_de_fin_d_activite__c != null && acc.Date_de_fin_d_activite__c <= Date.today() 
                        && (acc.Etat__c != Label.Account_Etat_7 || acc.Mode__c != Label.Account_Mode_Inactif || acc.En_attente_de_courrier__c != null)){
                            System.debug('I am here');
                            acc.Etat__c = Label.Account_Etat_7;
                            acc.Mode__c = Label.Account_Mode_Inactif;
                            acc.En_attente_de_courrier__c = null;
                        }
            }
            LAccSansRetourEtat.add(acc);
        }
        //si dans un batch, faire un update (car le trigger c'est before update, alors les valeurs durant l'update seront les nouvelles valeurs)
        if(system.isBatch()){
            if(LAccSansRetourEtat.size() > 0){
                Database.SaveResult[] srList = Database.update(LAccSansRetourEtat, false);
                if(Label.is_Batch_Logs_Active == 'true'){
                    List<Batch_Log__c> LBatchLogs = new List<Batch_Log__c>();
                    //for (Database.SaveResult sr : srList) {
                    for (Integer i = 0; i < LAccSansRetourEtat.size(); i++) {
                        Database.SaveResult sr = srList[i];
                        Account origRecord = LAccSansRetourEtat[i];
                        if (!sr.isSuccess()) {
                            for(Database.Error err : sr.getErrors()) {
                                LBatchLogs.add(new Batch_log__c(Status_Code__c = 'AP11_Account ' + err.getStatusCode(),
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
        if(LAccRetourEtat.size() > 0){
            system.debug('christine LAccRetourEtat final '+LAccRetourEtat);
            Update_Etat(LAccRetourEtat);
        }
        System.debug('AP11_Account.changerEtatModeSelonDFA end');
    }
    
    //Function to replace the flow Update_Etat
    private static void Update_Etat(List<Account> LAccounts){
        System.debug('Update_Etat Start');
        List<Account> LAccountsToUpdate = new List<Account>(); //utilisée seulement par un batch
        
        List<Historique_Etat_Mode__c> LHEMexistant = [SELECT Compte__c, Tech_Age_Mode__c, Creerpar__c, Datedecreation__c, Etat__c, Mode__c 
                                                      FROM Historique_Etat_Mode__c 
                                                      WHERE Compte__c IN :LAccounts AND Etat__c <> :Label.Account_Etat_6 
                                                      ORDER By Datedecreation__c DESC];
        system.debug('christine LHEMexistant '+LHEMexistant);
        //Map pour mapper les comptes avec leur historique d'etat
        Map<Id, List<Historique_Etat_Mode__c>> MapCompteLHEM = new Map<Id, List<Historique_Etat_Mode__c>>();
        for(Historique_Etat_Mode__c HEM: LHEMexistant){
            if(MapCompteLHEM.get(HEM.Compte__c) == null){
                MapCompteLHEM.put(HEM.Compte__c, new List<Historique_Etat_Mode__c>());
            }
            MapCompteLHEM.get(HEM.Compte__c).add(HEM);
        }
        
        List<Historique_Etat_Mode__c> LHEM = new List<Historique_Etat_Mode__c>(); //cette liste est utilisée pour créer de nouvau ligne d'historique
        system.debug('christine LHEM '+LHEM);
        system.debug('AP11_Account isDFA56 ' + isDFA56);
        for(Account acc: LAccounts){
            if(MapCompteLHEM.get(acc.Id) != null && isDFA56 == false){
                for(Historique_Etat_Mode__c HEM: MapCompteLHEM.get(acc.Id)){
                    if(HEM.Etat__c != acc.Etat__c && HEM.Mode__c != acc.Mode__c){
                        system.debug('christine creation of a new record');
                        LHEM.add(new Historique_Etat_Mode__c(Compte__c = acc.Id,
                                                             Creerpar__c = User.FirstName + ' ' + User.LastName,
                                                             Datedecreation__c = DateTime.now(),
                                                             Etat__c = acc.Etat__c,
                                                             Mode__c = acc.Mode__c
                                                            ));
                        acc.Etat__c = HEM.Etat__c;
                        acc.Mode__c = HEM.Mode__c;
                        LAccountsToUpdate.add(acc);
                        system.debug('christine LAccountsToUpdate '+LAccountsToUpdate);
                        system.debug('christine LHEM '+LHEM);
                        break;
                    }
                }
            }
        }
        System.debug('LAccountsToUpdate: ' + LAccountsToUpdate);
        if(System.isBatch()){
            Database.SaveResult[] srList = Database.update(LAccountsToUpdate, false);
            
        }
        System.debug('LHEM: ' + LHEM);
        if(LHEM.size() > 0){	
            system.debug('christine LHEM insertion '+LHEM);
            insert LHEM;
        }
        System.debug('Update_Etat End');
    }
    
}