/*
* @author      TMAEITL JSA
* @CreatedDate    14/12/2017
* @description    Class handler containing the functions of the process builders
*/
public class AP011_ProcessBuilders {
    public static boolean firstRun = true;
    public static Map<String,Association_Record_Type_et_pays__mdt> mapassociationRTPays;
    public static void DoAllProcess(List<Account> lstNewacc,MAp<id,Account> mapOldAcc,Boolean isBefore,Boolean isInsert){
        List<Account> accountsWithNewMacroprofil = new List<Account>();
        Set <Id> macroprofilIds = new Set<Id>();
        User currentUser;
        Account OldAccount;
        if(isBefore){
            currentUser = [SELECT Id, Operateur__c,ManagerId  FROM User WHERE Id = :UserInfo.getUserId()];       
        }    
        if(isBefore){
            //added by John for ticket 130315
            List< Association_Record_Type_et_pays__mdt> associationRTPays = [Select Id,MasterLabel, ID_DemarrageActivite__c, ID_File_service_line__c
                                                                             FROM Association_Record_Type_et_pays__mdt];
            mapassociationRTPays =  new Map<String,Association_Record_Type_et_pays__mdt>();
            for(Association_Record_Type_et_pays__mdt mdtRecord: associationRTPays)
            {
                mapassociationRTPays.put(mdtRecord.MasterLabel, mdtRecord);
            }
            List<case> LNewCases = new   List<case>();
            system.debug('AP011_PB lstNewacc '+lstNewacc);
            for(Account acc : lstNewacc){
            system.debug('AP011_PB !isInsert '+!isInsert);
                if(!isInsert)
                {
                    system.debug('AP011_PB I m here');
                    OldAccount = mapOldAcc.get(acc.id);
                    // START PUDO_PB_17_MAJ_Responsable
                    if(acc.Mode__c  != OldAccount.Mode__c && acc.Mode__c =='40' && currentUser != null ){
                        acc.Utilisateur_Responsable__c = currentUser.ManagerId;
                    }
                    //END PUDO_PB_17_MAJ_Responsable
                    //
                    // START PB02 - Création automatique de requête type DA
                    if(Label.RT_France_Compte.contains(acc.RecordTypeId) && Label.RT_SuiviCo_Compte.contains(acc.RecordTypeId) && acc.Etat__c == '2' 
                       && acc.Date_de_la_formation_reelle__c != OldAccount.Date_de_la_formation_reelle__c
                       && acc.Date_de_la_formation_reelle__c != null)
                    {
                        LNewCases.add(new Case(AccountId = acc.Id,
                                               ContactId = acc.Contact_operationnel_1__c,
                                               Macroprofil_de_reference__c = acc.Macroprofil_de_reference__c,
                                               OwnerId = Label.DA_QueueARSId,//membersMap.get(currentUser.id),
                                               RecordTypeId = mapassociationRTPays.get(acc.Shipping_Country__c).ID_DemarrageActivite__c,
                                               Status = '0',
                                               Subject = Label.DA_ObjetDA,
                                               Object_de_la_requete__c = 'Démarrage d\'activité'
                                              ));
                        acc.Etat__c = '4';
                        acc.Mode__c = '200'; //en attente d'attribution
                    }
                    else if(( Label.RT_INT_Compte.contains(acc.RecordTypeId)||Label.RT_INT_Compte2.contains(acc.RecordTypeId)&& Label.RT_SuiviCo_Compte.contains(acc.RecordTypeId) ) 
                            && Label.RT_SuiviCo_Compte.contains(acc.RecordTypeId) && acc.Etat__c == '2' 
                            && acc.Date_de_la_formation_reelle__c != OldAccount.Date_de_la_formation_reelle__c
                            && acc.Date_de_la_formation_reelle__c != null)
                    {
                        LNewCases.add(new Case(AccountId = acc.Id,
                                               ContactId = acc.Contact_operationnel_1__c,
                                               Macroprofil_de_reference__c = acc.Macroprofil_de_reference__c,
                                               OwnerId = mapassociationRTPays.get(acc.Shipping_Country__c).ID_File_service_line__c,
                                               RecordTypeId = mapassociationRTPays.get(acc.Shipping_Country__c).ID_DemarrageActivite__c,
                                               Status = '0',
                                               Subject = Label.DA_ObjetDA,
                                               Object_de_la_requete__c = 'Démarrage d\'activité'
                                              ));
                        acc.Etat__c = '4';
                        acc.Mode__c = '200'; //en attente d'attribution
                    }
                    // END PB02 - Création automatique de requête type DA
                }
                // START PUDO_PB15_Calcul_Amplitude
                if(isInsert ||( OldAccount!= null && (acc.Tech_Amplitude_Horaire_1__c != OldAccount.Tech_Amplitude_Horaire_1__c
                                                      || acc.Tech_Amplitude_Horaire_2__c != OldAccount.Tech_Amplitude_Horaire_2__c
                                                      || acc.Tech_Amplitude_Horaire_3__c != OldAccount.Tech_Amplitude_Horaire_3__c
                                                      || acc.Tech_Amplitude_Horaire_4__c != OldAccount.Tech_Amplitude_Horaire_4__c))){
                                                          acc.Amplitude_horaire_du_relais__c=(acc.Tech_Amplitude_Horaire_1__c==null?0:acc.Tech_Amplitude_Horaire_1__c )+ (acc.Tech_Amplitude_Horaire_2__c==null?0:acc.Tech_Amplitude_Horaire_2__c)+ (acc.Tech_Amplitude_Horaire_3__c==null?0:acc.Tech_Amplitude_Horaire_3__c )+ (acc.Tech_Amplitude_Horaire_4__c==null?0:acc.Tech_Amplitude_Horaire_4__c);  
                                                      }
                // END PUDO_PB15_Calcul_Amplitude
                
                
                // START PUDO_PB02_Recopie_Operateur_Compte
                if(isInsert && String.isBlank(acc.Operateur_Global__c ) && currentUser!= null){
                    acc.Operateur_Global__c =currentUser.Operateur__c;
                }  
                // END PUDO_PB02_Recopie_Operateur_Compte 
                
                
                // STRAT PUDO_PB01_Recopie_Horaires_Reference
                if(
                    isInsert ||
                    ( OldAccount!= null && (OldAccount.Horaire_Ouverture_Reference__c != acc.Horaire_Ouverture_Reference__c || OldAccount.Horaire_Fermeture_Reference__c != acc.Horaire_Fermeture_Reference__c 
                                            || OldAccount.Debut_pause_dejeuner__c != acc.Debut_pause_dejeuner__c || OldAccount.Fin_pause_dejeuner__c != acc.Fin_pause_dejeuner__c 
                                            || OldAccount.Lundi__c != acc.Lundi__c || OldAccount.Mardi__c != acc.Mardi__c || OldAccount.Mercredi__c != acc.Mercredi__c 
                                            || OldAccount.Jeudi__c != acc.Jeudi__c || OldAccount.Vendredi__c != acc.Vendredi__c || OldAccount.Samedi__c != acc.Samedi__c 
                                            || OldAccount.Dimanche__c != acc.Dimanche__c 
                                            || OldAccount.Lundi_Ouverture__c != acc.Lundi_Ouverture__c || OldAccount.Mardi_Ouverture__c != acc.Mardi_Ouverture__c 
                                            || OldAccount.Mercredi_Ouverture__c != acc.Mercredi_Ouverture__c || OldAccount.Jeudi_Ouverture__c != acc.Jeudi_Ouverture__c
                                            || OldAccount.Vendredi_Ouverture__c != acc.Vendredi_Ouverture__c || OldAccount.Samedi_Ouverture__c != acc.Samedi_Ouverture__c 
                                            || OldAccount.Dimanche_Ouverture__c != acc.Dimanche_Ouverture__c 
                                            || OldAccount.Lundi_Fermeture__c != acc.Lundi_Fermeture__c || OldAccount.Mardi_Fermeture__c != acc.Mardi_Fermeture__c 
                                            || OldAccount.Mercredi_Fermeture__c != acc.Mercredi_Fermeture__c || OldAccount.Jeudi_Fermeture__c != acc.Jeudi_Fermeture__c 
                                            || OldAccount.Vendredi_Fermeture__c != acc.Vendredi_Fermeture__c || OldAccount.Samedi_Fermeture__c != acc.Samedi_Fermeture__c 
                                            || OldAccount.Dimanche_Fermeture__c != acc.Dimanche_Fermeture__c 
                                            || OldAccount.Lundi_fin_pause_dejeuner__c != acc.Lundi_fin_pause_dejeuner__c || OldAccount.Mardi_fin_pause_dejeuner__c != acc.Mardi_fin_pause_dejeuner__c 
                                            || OldAccount.Mercredi_fin_pause_dejeuner__c != acc.Mercredi_fin_pause_dejeuner__c || OldAccount.Jeudi_fin_pause_dejeuner__c != acc.Jeudi_fin_pause_dejeuner__c 
                                            || OldAccount.Vendredi_fin_pause_dejeuner__c != acc.Vendredi_fin_pause_dejeuner__c || OldAccount.Samedi_fin_pause_dejeuner__c != acc.Samedi_fin_pause_dejeuner__c 
                                            || OldAccount.Dimanche_fin_pause_dejeuner__c != acc.Dimanche_fin_pause_dejeuner__c
                                            || OldAccount.Lundi_debut_pause_dejeuner__c != acc.Lundi_debut_pause_dejeuner__c || OldAccount.Mardi_debut_pause_dejeuner__c != acc.Mardi_debut_pause_dejeuner__c 
                                            || OldAccount.Mercredi_debut_pause_dejeuner__c != acc.Mercredi_debut_pause_dejeuner__c || OldAccount.Jeudi_debut_pause_dejeuner__c != acc.Jeudi_debut_pause_dejeuner__c 
                                            || OldAccount.Vendredi_debut_pause_dejeuner__c != acc.Vendredi_debut_pause_dejeuner__c || OldAccount.Samedi_debut_pause_dejeuner__c != acc.Samedi_debut_pause_dejeuner__c 
                                            || OldAccount.Dimanche_debut_pause_dejeuner__c != acc.Dimanche_debut_pause_dejeuner__c ))
                )
                {
                    if(acc.Lundi__c == True)
                    {
                        acc.Lundi_Fermeture__c = acc.Horaire_Fermeture_Reference__c;
                        acc.Lundi_Ouverture__c = acc.Horaire_Ouverture_Reference__c;
                        acc.Lundi_debut_pause_dejeuner__c = acc.Debut_pause_dejeuner__c;
                        acc.Lundi_fin_pause_dejeuner__c = acc.Fin_pause_dejeuner__c;
                    }
                    if(acc.Mardi__c == True)
                    {
                        acc.Mardi_Fermeture__c = acc.Horaire_Fermeture_Reference__c;
                        acc.Mardi_Ouverture__c = acc.Horaire_Ouverture_Reference__c;
                        acc.Mardi_debut_pause_dejeuner__c = acc.Debut_pause_dejeuner__c;
                        acc.Mardi_fin_pause_dejeuner__c = acc.Fin_pause_dejeuner__c;
                    }
                    if(acc.Mercredi__c == True)
                    {
                        acc.Mercredi_Fermeture__c = acc.Horaire_Fermeture_Reference__c;
                        acc.Mercredi_Ouverture__c = acc.Horaire_Ouverture_Reference__c;
                        acc.Mercredi_debut_pause_dejeuner__c = acc.Debut_pause_dejeuner__c;
                        acc.Mercredi_fin_pause_dejeuner__c = acc.Fin_pause_dejeuner__c;
                    }
                    if(acc.Jeudi__c == True)
                    {
                        acc.Jeudi_Fermeture__c = acc.Horaire_Fermeture_Reference__c;
                        acc.Jeudi_Ouverture__c = acc.Horaire_Ouverture_Reference__c;
                        acc.Jeudi_debut_pause_dejeuner__c = acc.Debut_pause_dejeuner__c;
                        acc.Jeudi_fin_pause_dejeuner__c = acc.Fin_pause_dejeuner__c;
                    }
                    if(acc.Vendredi__c == True)
                    {
                        acc.Vendredi_Fermeture__c = acc.Horaire_Fermeture_Reference__c;
                        acc.Vendredi_Ouverture__c = acc.Horaire_Ouverture_Reference__c;
                        acc.Vendredi_debut_pause_dejeuner__c = acc.Debut_pause_dejeuner__c;
                        acc.Vendredi_fin_pause_dejeuner__c = acc.Fin_pause_dejeuner__c;
                    }
                    if(acc.Samedi__c == True)
                    {
                        acc.Samedi_Fermeture__c = acc.Horaire_Fermeture_Reference__c;
                        acc.Samedi_Ouverture__c = acc.Horaire_Ouverture_Reference__c;
                        acc.Samedi_debut_pause_dejeuner__c = acc.Debut_pause_dejeuner__c;
                        acc.Samedi_fin_pause_dejeuner__c = acc.Fin_pause_dejeuner__c;
                    }
                    if(acc.Dimanche__c == True)
                    {
                        acc.Dimanche_Fermeture__c = acc.Horaire_Fermeture_Reference__c;
                        acc.Dimanche_Ouverture__c = acc.Horaire_Ouverture_Reference__c;
                        acc.Dimanche_debut_pause_dejeuner__c = acc.Debut_pause_dejeuner__c;
                        acc.Dimanche_fin_pause_dejeuner__c = acc.Fin_pause_dejeuner__c;
                    }   
                }
                // END PUDO_PB01_Recopie_Horaires_Reference
                
                //Start TMA-MJE TFS-115797 replaced by WF: Pudo_WF_15_Calcul_Amplitude
                
                // START PUDO_PB15_Calcul_Amplitude
                //End TMA-MJE TFS-115797
                //Start PUDO_PB11_MAJ_Infos_Societe_gerant
                if(Label.RT_France_Compte.contains(acc.RecordTypeId)){
                    if(acc.isOrangePartenaire__c &&
                       (acc.Assujetti_la_TVA__c!='Oui' || acc.Capital_EUR__c != 50983913 || acc.N_SIREN__c!='437723844' || acc.N_TVA__c!='FR94437723844' || acc.Ownership!='160' 
                        || acc.Ville_RCS__c!='Bobigny' || acc.Activite_commerciale_principale__c!='91' || acc.Industry!='15' || !acc.Integre__c 
                        || !acc.Presence_camera_video__c || !acc.Presence_rideau_de_fer__c || acc.Type_acces_Internet__c!='5')
                      )
                    {
                        acc.Assujetti_la_TVA__c='OUI';
                        acc.Capital_EUR__c =50983913;
                        acc.N_SIREN__c='437723844';
                        acc.N_TVA__c='FR94437723844';
                        acc.Ownership='160';
                        acc.Ville_RCS__c='Bobigny';
                        
                        acc.Activite_commerciale_principale__c = '91';
                        acc.Industry = '15';
                        
                        acc.Integre__c = true;
                        
                        acc.Presence_camera_video__c = true;
                        acc.Presence_rideau_de_fer__c = true;
                        acc.Type_acces_Internet__c = '5';
                    }
                    else if(acc.Partenaire__c=='146' && acc.Type=='3' && 
                            (acc.Assujetti_la_TVA__c!='Oui' || acc.Capital_EUR__c != 283587.3 || acc.N_SIREN__c!='489895821' || acc.N_TVA__c!='FR26489895821'
                             || acc.Ownership!='162' || acc.Ville_RCS__c!='Grenoble' || acc.Activite_commerciale_principale__c !='59' || acc.Industry!='7' || !acc.Integre__c)
                           )
                    {
                        acc.Assujetti_la_TVA__c='OUI';
                        acc.Capital_EUR__c = 283587.3;
                        acc.N_SIREN__c='489895821';
                        acc.N_TVA__c='FR26489895821';
                        acc.Ownership='162';
                        acc.Ville_RCS__c='Grenoble';
                        
                        acc.Activite_commerciale_principale__c = '59';
                        acc.Industry = '7';
                        
                        acc.Integre__c = true;
                    }
                    else if(acc.Partenaire__c=='140' && acc.Type=='22' &&
                            (acc.Assujetti_la_TVA__c!='Oui' || acc.Capital_EUR__c != 3800000000.0 || acc.N_SIREN__c!='356000000' || acc.N_TVA__c!='FR39356000000'
                             || acc.Ownership!='160' || acc.Ville_RCS__c!='Paris' || acc.Activite_commerciale_principale__c !='33011' || acc.Industry!='3301' )
                           )
                    {
                        acc.Assujetti_la_TVA__c='OUI';
                        acc.Capital_EUR__c = 3800000000.0;
                        acc.N_SIREN__c='356000000';
                        acc.N_TVA__c='FR39356000000';
                        acc.Ownership='160';
                        acc.Ville_RCS__c='Paris';
                        
                        acc.Activite_commerciale_principale__c = '33011';
                        acc.Industry = '3301';
                    }
                    else if(acc.Partenaire__c=='-2' && acc.Type=='22' &&
                            (acc.Assujetti_la_TVA__c!='Oui' || acc.Capital_EUR__c != 32632000 || acc.N_SIREN__c!='383960135' || acc.N_TVA__c!='FR82383960135'
                             || acc.Ownership!='162' || acc.Ville_RCS__c!='Créteil' || acc.Activite_commerciale_principale__c !='33011' || acc.Industry!='3301' ))
                    {
                        acc.Assujetti_la_TVA__c='OUI';
                        acc.Capital_EUR__c =32632000;
                        acc.N_SIREN__c='383960135';
                        acc.N_TVA__c='FR82383960135';
                        acc.Ownership='162';
                        acc.Ville_RCS__c='Créteil';
                        
                        acc.Activite_commerciale_principale__c = '33011';
                        acc.Industry = '3301';
                    }
                }
                //End PUDO_PB11_MAJ_Infos_Societe_gerant               
                
                // START PUDO_PB10_MAJ_Macroprofils
                if(Label.RT_France_Compte.contains(acc.RecordTypeId)){
                    if((acc.Etat__c=='0' || acc.Etat__c=='1' || acc.Etat__c=='2') && acc.Macroprofil_de_reference__c != null && 
                       (isInsert || (mapOldAcc != null && acc.Macroprofil_de_reference__c  != mapOldAcc.get(acc.id).Macroprofil_de_reference__c))
                      ){
                          acc.Macroprofil_actuel__c = acc.Macroprofil_de_reference__c;
                          acc.Tech_MP_Assigned__c = !acc.Tech_MP_Assigned__c;
                      }else  if(!isInsert && (mapOldAcc.get(acc.id).Macroprofil_actuel__c !=acc.Macroprofil_actuel__c   )
                                &&  (acc.Etat__c=='4' || acc.Etat__c=='5' || acc.Etat__c == '6' || acc.Etat__c == '7') && acc.Statut_de_modification__c == 'Définitive')
                      {
                          acc.Date_de_fin_de_modification__c = null;
                          acc.Macroprofil_de_reference__c = acc.Macroprofil_actuel__c;
                          acc.Tech_MP_Assigned__c = !acc.Tech_MP_Assigned__c;
                      }
                }
                else if(Label.RT_INT_Compte.contains(acc.RecordTypeId)|| Label.RT_INT_Compte2.contains(acc.RecordTypeId)){
                    acc.Tech_MP_Assigned__c = !acc.Tech_MP_Assigned__c;
                }
                //END PUDO_PB10_MAJ_Macroprofils 
                
            }//End for Loop on Account
            system.debug('AP011_PB LNewCases '+LNewCases);
            if(LNewCases!= null && LNewCases.size()>0){
                insert LNewCases;
            } 
        }//End isBefore
        else
        {
            List<Historique_Etat_Mode__c> LHM = new List<Historique_Etat_Mode__c> ();
            List<Historique_Macroprofils__c> LMP = new List<Historique_Macroprofils__c> ();
            
 Map<Id, Account> mapNewAcc = new Map<Id, Account>([SELECT Id, Macroprofil_actuel__r.Name, Macroprofil_de_reference__r.Name FROM Account WHERE Id IN :lstNewAcc]);
            for(Account acc : lstNewacc){
                
                //Start HMMP_PB01_Historique_modifications_Macroprofil
                if(!isInsert && mapOldAcc!= null && acc.Tech_MP_Assigned__c != mapOldAcc.get(acc.id).Tech_MP_Assigned__c 
                   && ( String.isNotBlank(acc.Macroprofil_actuel__c))
                   && (mapOldAcc!= null && acc.Macroprofil_actuel__c != mapOldAcc.get(acc.id).Macroprofil_actuel__c || acc.Macroprofil_de_reference__c != mapOldAcc.get(acc.id).Macroprofil_de_reference__c)
                  ){
                      LMP.add(new Historique_Macroprofils__c(Compte__c = acc.Id,
                                                             Date_de_fin_du_statut__c = acc.Date_de_fin_de_modification__c,
                                                             Date_de_modification_MP__c = Date.today(),
                                                             Macroprofil_actuel__c = mapNewAcc.get(acc.Id).Macroprofil_actuel__r.Name,
                                                             Macroprofil_de_reference__c = mapNewAcc.get(acc.Id).Macroprofil_de_reference__r.Name,
                                                             Modifie_par__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName(),
                                                             Statut_de_modification__c = acc.Statut_de_modification__c
                                                            ));
                  }
                
                //End HMMP_PB01_Historique_modifications_Macroprofil
                system.debug('AP011_PB acc.Etat__c ' + acc.Etat__c);
                system.debug('AP011_PB acc.Mode__c ' + acc.Mode__c);
                system.debug('AP011_PB acc.RecordTypeId ' + acc.RecordTypeId);
                
                //Start PB06 - Générer l'historique des états / Mode
                if((!(acc.Etat__c == '2' && String.isBlank(acc.Type))
                   && ((/*acc.ConversionTerminated__c == true &&*/ acc.Etat__c == '0')
                       || acc.Etat__c == '1' || acc.Etat__c == '2' || acc.Etat__c == '3' || acc.Etat__c == '4' || acc.Etat__c == '5' 
                       || acc.Etat__c == '6' || acc.Etat__c == '7' || acc.Etat__c == '8' || acc.Etat__c == '9'
                       || label.RT_Consigne_Compte.contains(acc.RecordTypeId)||label.RT_NonSuiviCo_Compte.contains(acc.RecordTypeId))
                   && ( (mapOldAcc!=null && 
                         ( acc.Etat__c != mapOldAcc.get(acc.id).Etat__c || acc.Mode__c != mapOldAcc.get(acc.id).Mode__c)) 
                       || isInsert)
                  ) ){
                      system.debug('AP011_PB LHM 1 ' +firstRun);
                      system.debug('AP011_PB firstRun '+firstRun);
                      if(firstRun){
                          system.debug('AP011_PB test');
                          LHM.add(new Historique_Etat_Mode__c(Compte__c = acc.Id,
                                                              Creerpar__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName(),
                                                              Datedecreation__c = DateTime.now(),
                                                              Etat__c = acc.Etat__c,
                                                              Mode__c = acc.Mode__c
                                                             ));
                      }
                     
                  }
                //End PB06 - Générer l'historique des états / Mode
            }//End For Loop Account
            
          
            
            system.debug('AP011_PB LHM 2 ' + LHM);
            if(LHM != null && LHM.size() > 0){
                system.debug('AP011_PB LHM 3');
                 firstRun = false;
                insert LHM;
            }
            system.debug('AP011_PB LHM ');
            system.debug('AP011_PB LMP ');
            insert LMP;
        }
    }
    
}