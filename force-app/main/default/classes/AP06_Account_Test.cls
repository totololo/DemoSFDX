/* Class that test the functionality of AP06_Account*/
    
    @isTest
    public class AP06_Account_Test {
        
        public testMethod static void TestcreateCase(){
            //Create Custom Settings country sequence
            CountriesSequence__c cs = new CountriesSequence__c(Name='Belgium' , Sequence__c = 'BE0001');
            insert cs;
            //Create Contact
            Contact testContact = Utils_TestMethods.CreateContact('Name');
            Contact testContact2 = Utils_TestMethods.CreateContact('Name2');
            Contact testContact3 = Utils_TestMethods.CreateContact('Name3');
            insert new list<contact>{testContact,testContact2,testContact3}; 
            list<Macroprofil__c> listMacroprofil = new list<Macroprofil__c>();
            Macroprofil__c testMacroprofil = Utils_TestMethods.CreateMacroprofil('test');
            listMacroprofil.add(testMacroprofil);
            Macroprofil__c testMacroprofil2 = Utils_TestMethods.CreateMacroprofil('test2');
            listMacroprofil.add(testMacroprofil2);
            insert listMacroprofil;
            
            String json1 = 
                '   [{'+
                '       \"Id_du_Macroprofil__c\": "'+testMacroprofil.id+'",'+
                '       \"MasterLabel\": \"MPBE1-Standard\",'+
                '       \"Pays__c\": \"Belgium\",'+
                '       \"Type_de_point__c\": \"20\"'+
                '   },{'+
                '       \"Id_du_Macroprofil__c\": "'+testMacroprofil2.id+'",'+
                '       \"MasterLabel\": \"MPBE1-Standard\",'+
                '       \"Type_de_point__c\": \"3\",'+
                '       \"Partenaire__c\": \"124\"'+
                '  }]';        
            AssociationPUDOMacroprofil_Test.setMetadata(
                'Select id, Pays__c, Partenaire__c, Type_de_point__c, Id_du_Macroprofil__c From Association_PUDO_Macroprofil__mdt',
                (List<Association_PUDO_Macroprofil__mdt>) JSON.deserialize( json1,  List<Association_PUDO_Macroprofil__mdt>.class )
            );
            
            List<Association_Record_Type_et_pays__mdt> associationRTPaysList = [Select Id, MasterLabel, ID_Prospect_A_Valider__c, ID_Prospect_Converti__c, ID_suivi_CO__c, ID_PUDO_Non_Suivi__c,ID_Requete_ContratNonRespecte__c
                                                                                  FROM Association_Record_Type_et_pays__mdt];
            
            
            map<string, Association_Record_Type_et_pays__mdt> associationRTPays = new map<string, Association_Record_Type_et_pays__mdt>();
            for(Association_Record_Type_et_pays__mdt associationRT : associationRTPaysList){
              associationRTPays.put(associationRT.MasterLabel, associationRT);  
            }
            
            list<account> listAccount = new list<account>();
            Account account1= Utils_TestMethods.CreateAccount(testContact, null, 'Test Account 1'); 
            account1.RecordTypeId =associationRTPays.get('Belgium').ID_PUDO_Non_Suivi__c;
            account1.Type = '20';
            account1.BillingCountry ='Belgium';
            account1.ShippingCountry ='Belgium';
            account1.BillingCountryCode = 'BE';
            account1.ShippingCountryCode ='BE';
            account1.Ville_de_l_adresse_de_livraison2__c = 'Belgium';
            account1.Operateur_Global__c = 'DPD_BNL';
            account1.BillingPostalCode ='1234';
            account1.ShippingPostalCode = '1243';
            account1.Long_Lat_adresse_de_livraison__Latitude__s=62;
            account1.Long_Lat_adresse_de_livraison__Longitude__s=21;
            listAccount.add(account1);
 
            //Create Account 2            
            Account account2= Utils_TestMethods.CreateAccount(testContact2, null, 'Test Account 2'); 
            account2.RecordTypeId =associationRTPays.get('Belgium').ID_PUDO_Non_Suivi__c;          
            account2.Mode__c = '';
            account2.Type = '20';
            account2.BillingCountry ='Belgium';
            account2.ShippingCountry ='Belgium';
            account2.BillingCountryCode = 'BE';
            account2.ShippingCountryCode ='BE';
            account2.Ville_de_l_adresse_de_livraison2__c ='Belgium';
            account2.Operateur_Global__c = 'DPD_BNL';
            account2.BillingPostalCode ='1234';
            account2.ShippingPostalCode = '1243';
            account2.Long_Lat_adresse_de_livraison__Latitude__s=62;
            account2.Long_Lat_adresse_de_livraison__Longitude__s=21;
            account2.Amplitude_horaire_du_relais__c = 90.22;
            account2.Lundi_Ouverture__c = '08:00';
            account2.Lundi_Fermeture__c  = '20:00'; 
            account2.Mardi_Ouverture__c = '08:00';
            account2.Mardi_Fermeture__c  = '20:00'; 
            account2.Mercredi_Ouverture__c = '08:00';
            account2.Mercredi_Fermeture__c  = '20:00';
            account2.Jeudi_ferme__c = false;
            account2.Jeudi_Ouverture__c = '08:00';
            account2.Jeudi_Fermeture__c  = '20:00';
            account2.Vendredi_ferme__c = false;
            account2.Vendredi_Ouverture__c = '08:00';
            account2.Vendredi_Fermeture__c  = '20:00';
            account2.Samedi_ferme__c = false;
            account2.Samedi_Ouverture__c = '08:00';
            account2.Samedi_Fermeture__c  = '20:00';
            account2.lundi_debut_pause_dejeuner__c='12:00';
            account2.lundi_fin_pause_dejeuner__c ='12:30';
            account2.mardi_debut_pause_dejeuner__c='12:00';
            account2.mardi_fin_pause_dejeuner__c ='12:30';
            account2.mercredi_debut_pause_dejeuner__c='12:00';
            account2.mercredi_fin_pause_dejeuner__c ='12:30';        
            account2.jeudi_debut_pause_dejeuner__c='12:00';
            account2.jeudi_fin_pause_dejeuner__c ='12:30';
            account2.vendredi_debut_pause_dejeuner__c='12:00';
            account2.vendredi_fin_pause_dejeuner__c ='12:30';
            account2.samedi_debut_pause_dejeuner__c='12:00';
            account2.samedi_fin_pause_dejeuner__c ='12:30';
            listAccount.add(account2);
            
            Account account3= Utils_TestMethods.CreateAccount(null, null, 'Test Account');
        	account3.RecordTypeId = associationRTPays.get('France').ID_PUDO_Non_Suivi__c;    
        	account3.ShippingCountry ='France';
        	account3.ShippingCountryCode='FR';
        	account3.Etat__c = '5';
        	account3.Operateur_Global__c = 'PUS_FR';
        	account3.ShippingPostalCode = '12345';
       		account3.Type ='2';
        	account3.N_TVA__c = 'Non';
            listAccount.add(account3);
            insert(listAccount);
            
            testContact.accountId = account1.id;
            testContact2.accountId = account2.id;
            update new list<contact>{testContact,testContact2};
                
            case requete = new case();
            requete.Subject=label.Requete_ObjetContratNonRespecte;
            requete.Status = label.Requette_En_attente_de_traitement;
            requete.RecordTypeId = associationRTPays.get('Belgium').ID_Requete_ContratNonRespecte__c;
            requete.AccountId = account1.id;
            insert requete;
            list<account> listAccountUpdate = new list<account>();
            account1.Date_de_la_formation_reelle__c = Date.newInstance(2018, 12, 9);
            account1.Amplitude_horaire_du_relais__c = 90.22;
            account1.Lundi_Ouverture__c = '08:00';
            account1.Lundi_Fermeture__c  = '20:00'; 
            account1.Mardi_Ouverture__c = '08:00';
            account1.Mardi_Fermeture__c  = '20:00'; 
            account1.Mercredi_Ouverture__c = '08:00';
            account1.Mercredi_Fermeture__c  = '20:00';
            account1.Jeudi_ferme__c = false;
            account1.Jeudi_Ouverture__c = '08:00';
            account1.Jeudi_Fermeture__c  = '20:00';
            account1.Vendredi_ferme__c = false;
            account1.Vendredi_Ouverture__c = '08:00';
            account1.Vendredi_Fermeture__c  = '20:00';
            account1.Samedi_ferme__c = false;
            account1.Samedi_Ouverture__c = '08:00';
            account1.Samedi_Fermeture__c  = '20:00';
            account1.lundi_debut_pause_dejeuner__c='12:00';
            account1.lundi_fin_pause_dejeuner__c ='12:30';
            account1.mardi_debut_pause_dejeuner__c='12:00';
            account1.mardi_fin_pause_dejeuner__c ='12:30';
            account1.mercredi_debut_pause_dejeuner__c='12:00';
            account1.mercredi_fin_pause_dejeuner__c ='12:30';        
            account1.jeudi_debut_pause_dejeuner__c='12:00';
            account1.jeudi_fin_pause_dejeuner__c ='12:30';
            account1.vendredi_debut_pause_dejeuner__c='12:00';
            account1.vendredi_fin_pause_dejeuner__c ='12:30';
            account1.samedi_debut_pause_dejeuner__c='12:00';
            account1.samedi_fin_pause_dejeuner__c ='12:30';
            listAccountUpdate.add(account1);
            
            account2.Amplitude_horaire_du_relais__c = 30;
            account2.Lundi_Ouverture__c = '10:30';
            account2.Lundi_Fermeture__c  = '17:45';        
            account2.lundi_debut_pause_dejeuner__c='14:30';
            account2.lundi_fin_pause_dejeuner__c ='16:30';	
            account2.Date_de_la_formation_reelle__c = Date.newInstance(2018, 12, 9);
            listAccountUpdate.add(account2);   
            
            account3.Amplitude_horaire_du_relais__c = 30;
            account3.Lundi_Ouverture__c = '10:30';
            account3.Lundi_Fermeture__c  = '17:45';        
            account3.lundi_debut_pause_dejeuner__c='14:30';
            account3.lundi_fin_pause_dejeuner__c ='17:30';	
            account3.Date_de_la_formation_reelle__c = Date.today();
            account3.Nom_Responsable_magasin__c = testcontact3.id;
            listAccountUpdate.add(account3);
            
            update listAccountUpdate;
        }
    }