<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alerte_par_email_DOR</fullName>
        <description>Alerte par email DOR</description>
        <protected>false</protected>
        <recipients>
            <field>Utilisateur_DOR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Message_de_refus_approbation_prospect</template>
    </alerts>
    <alerts>
        <fullName>Alerte_par_email_Prop</fullName>
        <description>Alerte par email Propriétaire</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Message_de_refus_approbation_prospect</template>
    </alerts>
    <alerts>
        <fullName>Alerte_par_email_Propri_taire_et_Responsable</fullName>
        <description>Alerte par email Responsable</description>
        <protected>false</protected>
        <recipients>
            <field>Utilisateur_Responsable__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Message_de_refus_approbation_prospect</template>
    </alerts>
    <fieldUpdates>
        <fullName>AP_Recopie_Criteres_Validation</fullName>
        <description>Recopie les critères de validation au moment de la de demande d&apos;approbation.</description>
        <field>Criteres_lors_de_la_validation__c</field>
        <formula>&quot;Amplitude horaire : &quot;&amp; if(CONTAINS(Amplitude_horaire_40_h__c,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Ouvert jusqu&apos;à 19h : &quot;&amp; if(CONTAINS( Ouvert_jusqua_19h__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Ouvert avant 10h : &quot;&amp; if(CONTAINS( Ouvert_tous_les_matins_avant_10h__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Pause déjeuner &lt;= 2h : &quot;&amp; if(CONTAINS( Pause_dejeuner_inf_egal_2h__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Activité commerciale éligible : &quot;&amp; if(CONTAINS( Activite_commerciale_eligible__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Ouvert les matins : &quot;&amp; if(CONTAINS( Ouvert_les_matins_entre_mardi_et_samedi__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Seuil contractuel &gt;= 20 c/j : &quot;&amp; if(CONTAINS(Seuil_contractuel_sup_egal__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Dmax respectée : &quot;&amp; if(CONTAINS(	DMax_Respectee__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>AP_Recopie_Criteres_Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AP_Recopie_Criteres_Validation_INTER</fullName>
        <field>Criteres_lors_de_la_validation__c</field>
        <formula>$Label.AP_AmplitudeHoraire &amp; if(CONTAINS( Seuil_de_l_amplitude_horaire_respect__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)
&amp; BR() &amp; $Label.AP_Heure_fermetureMinimaleRespect_e &amp; if(CONTAINS( Heure_fermeture_minimale_respectee__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)
&amp; BR() &amp; $Label.AP_HeureOuvertureMinimaleRespect_e &amp; if(CONTAINS( Heure_ouverture_minimale_respect_e__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)
&amp; BR() &amp; $Label.AP_DureePauseDejeunerRespectee &amp; if(CONTAINS(  Duree_pause_dejeuner_respectee__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 
&amp; BR() &amp; $Label.AP_ActiviteCommercialeEligible &amp; if(CONTAINS( Activite_commerciale_eligible__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)
&amp; BR() &amp; $Label.AP_OuvertLesMatins &amp; if(CONTAINS( Ouvert_les_matins_entre_mardi_et_samedi__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)
&amp; BR() &amp; $Label.AP_SeuilRespecte  &amp; if(CONTAINS(Seuil_respecte__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)
&amp; BR() &amp; $Label.AP_DmaxRespectee &amp; if(CONTAINS(	DMax_Respectee__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>AP_Recopie_Criteres_Validation_INTER</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AP_Recopier_crit_res_validation_PContact</fullName>
        <field>Criteres_lors_de_la_validation_PC__c</field>
        <formula>&quot;; Dmax respectée : &quot;&amp; if(CONTAINS(  DMax_Respectee__c  ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) 

&amp; BR() &amp; &quot;; Activité commerciale éligible : &quot;&amp; if(CONTAINS( Activite_commerciale_eligible__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)

&amp; BR() &amp; &quot;; Ouvert avant 10h : &quot;&amp; if(CONTAINS(  Ouvert_tous_les_matins_avant_10h__c  ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>AP Recopier critères validation PContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Accord_DOR_Non_retenu</fullName>
        <field>Mode__c</field>
        <literalValue>Accord Pickup : Non retenu</literalValue>
        <name>Accord DOR Non retenu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Accord_GC_Non_retenu</fullName>
        <field>Mode__c</field>
        <literalValue>Accord Pickup : Non retenu</literalValue>
        <name>Accord GC Non retenu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Accord_Responsable_Non_Retenu</fullName>
        <description>Accord Responsable -  Non Retenu</description>
        <field>Mode__c</field>
        <literalValue>Accord Pickup : Non retenu</literalValue>
        <name>Accord Responsable Non Retenu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Adresse_livraison_fiabilisee</fullName>
        <field>Adresse_de_livraison_fiabilisee__c</field>
        <literalValue>0</literalValue>
        <name>Adresse_livraison_fiabilisée</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Amplitude_horaire_du_relais</fullName>
        <field>Amplitude_horaire_du_relais__c</field>
        <formula>Tech_Amplitude_Horaire_1__c+Tech_Amplitude_Horaire_2__c+Tech_Amplitude_Horaire_3__c + Tech_Amplitude_Horaire_4__c</formula>
        <name>Amplitude_horaire_du_relais</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CONS_WF02_Sauvegarde_Date_Activation</fullName>
        <description>Enregistre la date d&apos;activation (=date de passage en état 4) pour les consigne.</description>
        <field>Date_d_activation__c</field>
        <formula>Today()</formula>
        <name>CONS_WF02_Sauvegarde_Date_Activation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DateMAJ_SeuilCalcule</fullName>
        <description>Lorsque la hauteur, la largeur ou la profondeur est modifié, la Date de mise à jour de seuil calculé est renseignée avec la date du jour</description>
        <field>Date_de_mise_a_jour_seuil_calcule__c</field>
        <formula>TODAY()</formula>
        <name>DateMAJ_SeuilCalcule</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DateMAJ_SeuilContractuel</fullName>
        <description>Lorsque le seuil contractuel est modifié, la Date de mise à jour de seuil contractuel est renseignée avec la date du jour</description>
        <field>Date_de_mise_a_jour_Seuil_contractuel__c</field>
        <formula>TODAY()</formula>
        <name>DateMAJ_SeuilContractuel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DateRetractation</fullName>
        <description>Réactivation au cours de la période de préavis (Dans les 2 mois précédant la date de FDA). Date de rétractation se génère automatiquement (champ caché, utilisé uniquement pour le reporting) lors de la suppression de la date de FDA</description>
        <field>Date_de_retractation__c</field>
        <formula>TODAY()</formula>
        <name>DateRetractation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_de_formation_reelle</fullName>
        <field>Date_de_la_formation_reelle__c</field>
        <name>Date de formation réelle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>En_attente_ValidationGC</fullName>
        <field>Mode__c</field>
        <literalValue>65</literalValue>
        <name>En_attente_ValidationGC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>En_attente_Validation_GC</fullName>
        <field>Mode__c</field>
        <literalValue>65</literalValue>
        <name>En_attente_Validation_GC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Date_Today</fullName>
        <field>Date_de_passage_etat2__c</field>
        <formula>today()</formula>
        <name>MAJ_Date_Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Date_modif_MP</fullName>
        <field>Modifie_depuis_le__c</field>
        <formula>today()</formula>
        <name>MAJ Date modif MP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Dmax2</fullName>
        <field>Prospect_Dmax_respecte__c</field>
        <formula>if(CONTAINS(DMax_Respectee__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Dmax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_ETAT</fullName>
        <field>Etat__c</field>
        <literalValue>1</literalValue>
        <name>MAJ_ETAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Etat5</fullName>
        <field>Etat__c</field>
        <literalValue>5</literalValue>
        <name>MAJ_Etat5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_FormeJur_SA</fullName>
        <description>Mise à jour du champ &quot;Forme Juridique&quot; à SA.</description>
        <field>Ownership</field>
        <literalValue>SA</literalValue>
        <name>MAJ_FormeJur_SA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_FormeJur_SAS</fullName>
        <field>Ownership</field>
        <literalValue>SAS</literalValue>
        <name>MAJ_FormeJur_SAS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Mode_AttenteGC</fullName>
        <field>Mode__c</field>
        <literalValue>65</literalValue>
        <name>MAJ_Mode_AttenteGC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Mode_DemandeSortie</fullName>
        <field>Mode__c</field>
        <literalValue>2000</literalValue>
        <name>MAJ_Mode_DemandeSortie</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Activit_commerciale_ligib</fullName>
        <field>ProspectActivitcommercialeligible__c</field>
        <formula>if(CONTAINS(  Activite_commerciale_eligible__c  ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Activité commerciale éligib</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Amplitude_Horaire</fullName>
        <field>ProspectAmplitudeHoraire__c</field>
        <formula>if(CONTAINS( $Label.RT_France_Compte , RecordTypeId ), if(CONTAINS(Amplitude_horaire_40_h__c,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;),if(CONTAINS(Seuil_de_l_amplitude_horaire_respect__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;) )</formula>
        <name>MAJ Prospect Amplitude Horaire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Heure_fermeture_minim_resp</fullName>
        <field>Prospect_heure_fermeture_minim_respect_e__c</field>
        <formula>if(CONTAINS(  Heure_fermeture_minimale_respectee__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Heure fermeture minim resp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Heure_ouverture_minim_resp</fullName>
        <field>Prospect_heure_ouverture_minim_respect_e__c</field>
        <formula>if(CONTAINS( Heure_ouverture_minimale_respect_e__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Heure ouverture minim resp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Ouvert_avant_10h</fullName>
        <field>Prospectouvertavant10__c</field>
        <formula>if(CONTAINS( Ouvert_tous_les_matins_avant_10h__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Ouvert avant 10h</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Ouvert_jusqu_19h</fullName>
        <field>ProspectOuvertjusqua19__c</field>
        <formula>if(CONTAINS( Ouvert_jusqua_19h__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Ouvert jusqu&apos;à 19h</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Ouvert_les_matins</fullName>
        <field>Prospectouvertavant10__c</field>
        <formula>if(CONTAINS( Ouvert_les_matins_entre_mardi_et_samedi__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Ouvert les matins</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Ouvert_les_matins_Inter</fullName>
        <field>ProspectOuvertlesmatins__c</field>
        <formula>if(CONTAINS( Ouvert_les_matins_entre_mardi_et_samedi__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Ouvert les matins Inter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Pause_d_jeuner_2h</fullName>
        <description>if(CONTAINS( Pause_dejeuner_inf_egal_2h__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</description>
        <field>ProspectPausedejeuner12__c</field>
        <name>MAJ Prospect Pause déjeuner &lt;= 2h</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Pause_d_jeuner_respect_INT</fullName>
        <field>Prospect_Pause_d_jeuner_respecte_INT__c</field>
        <formula>if(CONTAINS(  Duree_pause_dejeuner_respectee__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Pause déjeuner respecté INT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Seuil_contractuel</fullName>
        <field>ProspectSeuilcontractuel20__c</field>
        <formula>if(CONTAINS(Seuil_contractuel_sup_egal__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Seuil contractuel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Prospect_Seuil_respect</fullName>
        <field>Prospect_Seuil_respect__c</field>
        <formula>if(CONTAINS( Seuil_respecte__c ,&quot;green&quot;),&quot;OK&quot;,&quot;KO&quot;)</formula>
        <name>MAJ Prospect Seuil respecté</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Type_Enregistrement_Valider</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PUS_FR_PUDO_Suivi_CO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>MAJ_Type_Enregistrement_Valider</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Type_d_enregistrement</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PUS_FR_Prospect_A_Valider</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>MAJ Type d&apos;enregistrement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Validation_responsable</fullName>
        <field>Mode__c</field>
        <literalValue>40</literalValue>
        <name>MAJ_Validation_responsable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_lecture_seule_2</fullName>
        <field>N_TVA__c</field>
        <name>MAJ lecture seule 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Maj_Mode</fullName>
        <field>Mode__c</field>
        <literalValue>300</literalValue>
        <name>Maj_Mode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Maj_RT_PickupContact</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PUS_FR_Pickup_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Maj_RT_PickupContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mode_Attente_validation_DOR</fullName>
        <field>Mode__c</field>
        <literalValue>En attente de validation DOR</literalValue>
        <name>Mode_Attente_validation_DOR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mode_Attente_validation_GC</fullName>
        <field>Mode__c</field>
        <literalValue>65</literalValue>
        <name>Mode_Attente_validation_GC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mode_Refus</fullName>
        <field>Mode__c</field>
        <literalValue>Accord Pickup : Non retenu</literalValue>
        <name>Mode_Non_retenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_Passage_en_etat_7</fullName>
        <description>S’il est impossible pour le point relais de synchroniser le moyen de scan, il faut faire passer manuellement le point en Etat 7 en saisissant la date de fin d’activité.</description>
        <field>Etat__c</field>
        <literalValue>7</literalValue>
        <name>PUDO Passage en état 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF07_Commentaires_Conges</fullName>
        <description>Dès que le commentaire congé est saisi, ce workflow remplit le champ Utilisateur_dernier_commentaire_conge__c avec le nom de l&apos;utilisateur.</description>
        <field>Utilisateur_dernier_commentaire_conge__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>PUDO_WF07_Commentaires_Congés</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF07_Date_Modification</fullName>
        <description>Dès que le commentaire congé est saisi, ce workflow remplit le champ Date_Modification_Conge__c avec la date de la modification</description>
        <field>Date_Modification_Conge__c</field>
        <formula>TODAY()</formula>
        <name>PUDO_WF07_Date_Modification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF08_Commentaires_ActifSansScan</fullName>
        <description>Dès que le commentaire congé est saisi, ce workflow remplit le champ Utilisateur_dernier_commentaire_conge__c avec le nom de l&apos;utilisateur.</description>
        <field>Utilisateur_dernier_ActifSansScan__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>PUDO_WF08_Commentaires_ActifSansScan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF08_Date_Modification</fullName>
        <description>Dès que le commentaire congé est saisi, ce workflow remplit le champ Date_Modification_ActifSansScan__c avec la date de la modification</description>
        <field>Date_Modification_ActifSansScan__c</field>
        <formula>TODAY ()</formula>
        <name>PUDO_WF08_Date_Modification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF09_Commentaires_Horaire</fullName>
        <description>Dès que le commentaire horaire est saisi, ce workflow remplit le champ Utilisateur_dernier_commentaire_horaire__c avec le nom de l&apos;utilisateur.</description>
        <field>Utilisateur_dernier_commentaire_horaire__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>PUDO_WF09_Commentaires_Horaire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF09_Date_Modification</fullName>
        <description>Dès que le commentaire congé est saisi, ce workflow remplit le champ Date_Modification_Horaire__c avec la date de la modification</description>
        <field>Date_Modification_Horaire__c</field>
        <formula>TODAY()</formula>
        <name>PUDO_WF09_Date_Modification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF10_Commentaires_InactifAvecScan</fullName>
        <description>Dès que le commentaire horaire est saisi, ce workflow remplit le champ Utilisateur_dernier_InactifAvecScan__c avec le nom de l&apos;utilisateur.</description>
        <field>Utilisateur_dernier_InactifAvecScan__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>PUDO_WF10_Commentaires_InactifAvecScan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF10_Date_Modification</fullName>
        <description>Dès que le commentaire congé est saisi, ce workflow remplit le champ Date_Modification_InactifAvecScan__c avec la date de la modification</description>
        <field>Date_Modification_InactifAvecScan__c</field>
        <formula>TODAY()</formula>
        <name>PUDO_WF10_Date_Modification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PUDO_WF11_Amplitude_Horaire</fullName>
        <description>Dès que Amplitude_horaire_du_relais__c est renseigné, le champ Date_de_modification_Amplitude_Horaire__c est rempli avec la date du jour.</description>
        <field>Date_de_modification_Amplitude_Horaire__c</field>
        <formula>TODAY()</formula>
        <name>PUDO_WF11_Amplitude_Horaire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Passage_du_mod_sur_aucun</fullName>
        <field>Mode__c</field>
        <name>Passage du mode sur aucun</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Passage_du_mode_sur_aucun</fullName>
        <field>Mode__c</field>
        <name>Passage du mode sur aucun</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Passage_en_etat_1</fullName>
        <field>Etat__c</field>
        <literalValue>1</literalValue>
        <name>Passage état 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Passage_en_etat_2</fullName>
        <field>Etat__c</field>
        <literalValue>2</literalValue>
        <name>Passage en état 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Passage_en_etat_7</fullName>
        <description>Passage assuré automatiquement par le système le jour de la date de désinstallation définitive.</description>
        <field>Etat__c</field>
        <literalValue>7</literalValue>
        <name>Passage en état 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Passage_en_etat_9</fullName>
        <field>Etat__c</field>
        <literalValue>9</literalValue>
        <name>Passage en état 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QuantiteColisFreebox</fullName>
        <description>A la création du point relais, le champ « Quantité maximale de colis Freebox » qui est caché à l’utilisateur doit être initialisé, par défaut, à 10.</description>
        <field>Quantite_maximale_de_colis_Freebox__c</field>
        <formula>10</formula>
        <name>QuantiteColisFreebox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_PC_A_Valider</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PUS_FR_Prospect_A_Valider_Pickup_contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Type_PC_A_Valider</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_d_enregistrement</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PUS_FR_Prospect_A_Valider</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Type d&apos;enregistrement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WF01_Change_RT_Validation_GestContr</fullName>
        <description>Lorsque la case validation contractuelle est cochée, modifier le type d&apos;enregistrement en compte PUDO standard.</description>
        <field>RecordTypeId</field>
        <lookupValue>PUS_FR_PUDO_Suivi_CO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WF01_Change_RT_Validation_GestContr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WF02_Update_Horaire</fullName>
        <field>Amplitude_horaire_du_relais__c</field>
        <formula>(IF(
    Lundi_ferme__c,0,
    (NOW()+((Value(Left(Text(Lundi_Fermeture__c),2))*60)+Value(right(Text(Lundi_Fermeture__c),2))))-(NOW()+((Value(Left(Text(Lundi_Ouverture__c),2))*60)+Value(right(Text(Lundi_Ouverture__c),2))))
-IF(ISPICKVAL(lundi_debut_pause_dejeuner__c,&quot;&quot;),0,
((NOW()+((Value(Left(Text(lundi_fin_pause_dejeuner__c),2))*60)+Value(right(Text(lundi_fin_pause_dejeuner__c),2))))-(NOW()+((Value(Left(Text(lundi_debut_pause_dejeuner__c),2))*60)+Value(right(Text(lundi_debut_pause_dejeuner__c),2)))))))

+IF(
    Mardi_ferme__c,0,
    (NOW()+((Value(Left(Text(Mardi_Fermeture__c),2))*60)+Value(right(Text(Mardi_Fermeture__c),2))))-(NOW()+((Value(Left(Text(Mardi_Ouverture__c),2))*60)+Value(right(Text(Mardi_Ouverture__c),2))))
-IF(ISPICKVAL(mardi_debut_pause_dejeuner__c,&quot;&quot;),0,
((NOW()+((Value(Left(Text(mardi_fin_pause_dejeuner__c),2))*60)+Value(right(Text(mardi_fin_pause_dejeuner__c),2))))-(NOW()+((Value(Left(Text(mardi_debut_pause_dejeuner__c),2))*60)+Value(right(Text(mardi_debut_pause_dejeuner__c),2)))))))

+IF(
    Mercredi_ferme__c,0,
    (NOW()+((Value(Left(Text(Mercredi_Fermeture__c),2))*60)+Value(right(Text(Mercredi_Fermeture__c),2))))-(NOW()+((Value(Left(Text(Mercredi_Ouverture__c),2))*60)+Value(right(Text(Mercredi_Ouverture__c),2))))
-IF(ISPICKVAL(mercredi_debut_pause_dejeuner__c,&quot;&quot;),0,
((NOW()+((Value(Left(Text(mercredi_fin_pause_dejeuner__c),2))*60)+Value(right(Text(mercredi_fin_pause_dejeuner__c),2))))-(NOW()+((Value(Left(Text(mercredi_debut_pause_dejeuner__c),2))*60)+Value(right(Text(mercredi_debut_pause_dejeuner__c),2)))))))

+IF(
    Jeudi_ferme__c,0,
    (NOW()+((Value(Left(Text(Jeudi_Fermeture__c),2))*60)+Value(right(Text(Jeudi_Fermeture__c),2))))-(NOW()+((Value(Left(Text(Jeudi_Ouverture__c),2))*60)+Value(right(Text(Jeudi_Ouverture__c),2))))
-IF(ISPICKVAL(jeudi_debut_pause_dejeuner__c,&quot;&quot;),0,
((NOW()+((Value(Left(Text(jeudi_fin_pause_dejeuner__c),2))*60)+Value(right(Text(jeudi_fin_pause_dejeuner__c),2))))-(NOW()+((Value(Left(Text(jeudi_debut_pause_dejeuner__c),2))*60)+Value(right(Text(jeudi_debut_pause_dejeuner__c),2)))))))

+IF(
    Vendredi_ferme__c,0,
    (NOW()+((Value(Left(Text(Vendredi_Fermeture__c),2))*60)+Value(right(Text(Vendredi_Fermeture__c),2))))-(NOW()+((Value(Left(Text(Vendredi_Ouverture__c),2))*60)+Value(right(Text(Vendredi_Ouverture__c),2))))
-IF(ISPICKVAL(vendredi_debut_pause_dejeuner__c,&quot;&quot;),0,
((NOW()+((Value(Left(Text(vendredi_fin_pause_dejeuner__c),2))*60)+Value(right(Text(vendredi_fin_pause_dejeuner__c),2))))-(NOW()+((Value(Left(Text(vendredi_debut_pause_dejeuner__c),2))*60)+Value(right(Text(vendredi_debut_pause_dejeuner__c),2)))))))

+IF(
Samedi_ferme__c,0,(NOW()+((Value(Left(Text(Samedi_Fermeture__c),2))*60)+Value(right(Text(Samedi_Fermeture__c),2))))-(NOW()+((Value(Left(Text(Samedi_Ouverture__c),2))*60)+Value(right(Text(Samedi_Ouverture__c),2))))
-IF(ISPICKVAL(samedi_debut_pause_dejeuner__c,&quot;&quot;),0,
((NOW()+((Value(Left(Text(samedi_fin_pause_dejeuner__c),2))*60)+Value(right(Text(samedi_fin_pause_dejeuner__c),2))))-(NOW()+((Value(Left(Text(samedi_debut_pause_dejeuner__c),2))*60)+Value(right(Text(samedi_debut_pause_dejeuner__c),2)))))))

+IF(Dimanche_ferme__c,0,(NOW()+((Value(Left(Text(Dimanche_Fermeture__c),2))*60)+Value(right(Text(Dimanche_Fermeture__c),2))))-(NOW()+((Value(Left(Text(Dimanche_Ouverture__c),2))*60)+Value(right(Text(Dimanche_Ouverture__c),2))))
-IF(ISPICKVAL(dimanche_debut_pause_dejeuner__c,&quot;&quot;),0,
((NOW()+((Value(Left(Text(dimanche_fin_pause_dejeuner__c),2))*60)+Value(right(Text(dimanche_fin_pause_dejeuner__c),2))))-(NOW()+((Value(Left(Text(dimanche_debut_pause_dejeuner__c),2))*60)+Value(right(Text(dimanche_debut_pause_dejeuner__c),2))))))))/60</formula>
        <name>WF02_Update_Horaire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CONS_WF02_Sauvegarde_Date_Activation</fullName>
        <actions>
            <name>CONS_WF02_Sauvegarde_Date_Activation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Enregistre la date d&apos;activation (=date de passage en état 4) pour les consigne.</description>
        <formula>AND(    NOT( $User.BypassWorkflow__c ),    ISPICKVAL(Etat__c, &apos;4&apos;),    ISPICKVAL(Type, &apos;20&apos;),    NOT(ISPICKVAL(PRIORVALUE(Etat__c), &apos;4&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PC_PNS_WF01_PassageEtat5</fullName>
        <actions>
            <name>MAJ_Etat5</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Maj_Mode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lorsque le champ &quot;Date de formation réelle&quot; est renseigné et après enregistrement, le champ &quot;Etat&quot; passe en &quot; Etat 5 – En Activité&quot; et &quot;Mode&quot; en &quot;300&quot;.</description>
        <formula>AND(  NOT( $User.BypassValidationRule__c ),   OR( AND(ISNEW(),  NOT(ISBLANK(Date_de_la_formation_reelle__c))) ,  AND( NOT(ISBLANK(Date_de_la_formation_reelle__c)) , ISCHANGED(Date_de_la_formation_reelle__c) ) ),     OR( CONTAINS($Label.RT_NonSuiviCo_Compte,  RecordType.Id ),  CONTAINS($Label.RT_PickupContact_Compte,   RecordType.Id ) ),  OR(NOT(ISPICKVAL(Etat__c, &apos;5&apos;)), NOT(ISPICKVAL(Mode__c, &apos;Activité normale&apos;))) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF12_MAJ Date passage état 2</fullName>
        <actions>
            <name>MAJ_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Pour enregistrer la date de passage du Pudo à l&apos;état 2.</description>
        <formula>and(not( $User.BypassWorkflow__c ),     ispickval( Etat__c ,&quot;2&quot;),  NOT(ISPICKVAL( PRIORVALUE( Etat__c) , &quot;2&quot; )) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF13_MAJ_Etat_Mode_validationGC</fullName>
        <actions>
            <name>Mode_Attente_validation_GC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ce WF est utilisé dans le cadre du Processus d&apos;approbation pour forcer le mode sur &quot;En attente de validation GC&quot; lorsqu&apos;il n&apos;y a pas de passage par la DOR.</description>
        <formula>AND(  NOT(ISPICKVAL(Mode__c, &apos;En attente de validation GC&apos;)),  NOT($User.BypassWorkflow__c), Dmax_Approbation__c =&quot;Oui&quot;, Zone_dimplantation__c &lt;&gt; &quot;H00-00000&quot;,  ISPICKVAL (Etat__c, &quot;1&quot;),  ISPICKVAL (Mode__c, &quot;En attente de validation DOR&quot;),  ISPICKVAL(Recrute_dans_la_mission__c, &quot;Oui&quot;) ,  ISPICKVAL( Macroprofil__c , &quot;Oui&quot;),  ISPICKVAL( Seuil_conforme__c , &quot;Oui&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF14_MAJ_Adresse_fiabilisée</fullName>
        <actions>
            <name>Adresse_livraison_fiabilisee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ce WF va décocher la case &quot;Adresse de livraison fiabilisée&quot; lorsque l&apos;un des champs de l&apos;adresse de livraison et de facturation est modifiée.</description>
        <formula>AND( 
NOT($User.BypassWorkflow__c),  Adresse_de_livraison_fiabilisee__c =true,

OR(
ISCHANGED(N_de_rue_livraison__c),
ISCHANGED(ShippingCity),
ISCHANGED(ShippingCountry),
ISCHANGED(ShippingStreet ),
ISCHANGED(ShippingPostalCode),

ISCHANGED(N_de_rue_facturation__c ),
ISCHANGED(BillingCity ),
ISCHANGED(BillingCountry ),
ISCHANGED(BillingStreet ),
ISCHANGED(BillingPostalCode)

)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_02_QuantiteColisFreebox</fullName>
        <actions>
            <name>QuantiteColisFreebox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Quantite_maximale_de_colis_Freebox__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWorkflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>A la création du point relais, le champ « Quantité maximale de colis Freebox » qui est caché à l’utilisateur doit être initialisé, par défaut, à 10.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_03_DateMAJ_SeuilCalcule</fullName>
        <actions>
            <name>DateMAJ_SeuilCalcule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lorsque la hauteur, la largeur ou la profondeur est modifié, la date de mise à jour de seuil calculé est renseignée avec la date du jour</description>
        <formula>AND (     !$User.BypassWorkflow__c,
          ! ISNEW(),
      OR ( ISCHANGED( Hauteur_cm__c ),
           ISCHANGED( Largeur_cm__c ),
           ISCHANGED( Profondeur_cm__c )
          )
     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_04_DateMAJ_SeuilContractuel</fullName>
        <actions>
            <name>DateMAJ_SeuilContractuel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lorsque le seuil contractuel est modifié, la date de mise à jour de seuil contractuel est renseignée avec la date du jour</description>
        <formula>AND ( !$User.BypassWorkflow__c, 
      !ISNEW(),
      ISCHANGED(Seuil_contractuel__c)
     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_05_DateRetractation</fullName>
        <actions>
            <name>DateRetractation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Réactivation au cours de la période de préavis (Dans les 2 mois précédant la date de FDA). Date de rétractation se génère automatiquement (champ caché, utilisé uniquement pour le reporting) lors de la suppression de la date de FDA</description>
        <formula>AND (  ! $User.BypassWorkflow__c ,
       ISCHANGED(Date_de_fin_d_activite__c),
       ISBLANK(Date_de_fin_d_activite__c) 
     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_06_DateModifMP_Auto</fullName>
        <actions>
            <name>MAJ_Date_modif_MP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Le champ &quot;Date de modification&quot; est rempli automatiquement (date d&apos;aujourd&apos;hui) au moment de modification du MP actuel ou MP de référence.</description>
        <formula>AND (
Not ($User.BypassWorkflow__c) ,
OR (
ischanged( Macroprofil_actuel__c ),
ischanged( Macroprofil_de_reference__c )
))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_07_Commentaires_Congés</fullName>
        <actions>
            <name>PUDO_WF07_Commentaires_Conges</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PUDO_WF07_Date_Modification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Dès que le commentaire congé est saisi, ce workflow remplit le champ Utilisateur_dernier_commentaire_conge__c avec le nom de l&apos;utilisateur et le champ Date_Modification_Conge__c avec la date du jour.</description>
        <formula>ISCHANGED( Commentaires_Conges__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_08_Commentaires_ActifSansScan</fullName>
        <actions>
            <name>PUDO_WF08_Commentaires_ActifSansScan</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PUDO_WF08_Date_Modification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Dès que le commentaire actif sans scan est saisi, ce workflow remplit le champ Utilisateur_dernier_ActifSansScan__c avec le nom de l&apos;utilisateur et le champ Date_Modification_ActifSansScan__c avec la date du jour.</description>
        <formula>AND ( 
NOT ( $User.BypassWorkflow__c) , ISCHANGED( Commentaires_Actif_sans_Scan__c )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_09_Commentaires_Horaire_Insuffisant</fullName>
        <actions>
            <name>PUDO_WF09_Commentaires_Horaire</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PUDO_WF09_Date_Modification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Dès que le commentaire Horaire est saisi, ce workflow remplit le champ Utilisateur_dernier_commentaire_horaire__c avec le nom de l&apos;utilisateur et le champ Date_Modification_Horaire__c avec la date du jour</description>
        <formula>AND ( 
NOT ( $User.BypassWorkflow__c) , ISCHANGED( Commentaires_Horaires__c )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_10_Commentaires_Inactif_Avec_Scan</fullName>
        <actions>
            <name>PUDO_WF10_Commentaires_InactifAvecScan</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PUDO_WF10_Date_Modification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Dès que le commentaire Horaire est saisi, ce workflow remplit le champ Utilisateur_dernier_InactifAvecScan__c avec le nom de l&apos;utilisateur et le champ Date_Modification_InactifAvecScan__c avec la date du jour</description>
        <formula>AND ( 
NOT ( $User.BypassWorkflow__c) , ISCHANGED( Commentaires_Inactif_avec_Scan__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_11_Modification_Amplitude_Horaire</fullName>
        <actions>
            <name>PUDO_WF11_Amplitude_Horaire</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Dès que Amplitude_horaire_du_relais__c est renseigné, ce workflow remplit le champ Date_de_modification_Amplitude_Horaire__c avec la date du jour.</description>
        <formula>AND ( 
NOT ( $User.BypassWorkflow__c) , ISCHANGED( Amplitude_horaire_du_relais__c )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PUDO_WF_15_Calcul_Amplitude</fullName>
        <actions>
            <name>Amplitude_horaire_du_relais</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT($User.BypassWorkflow__c), OR( ISNEW() ,  ISCHANGED(Tech_Amplitude_Horaire_1__c), ISCHANGED(Tech_Amplitude_Horaire_2__c), ISCHANGED(Tech_Amplitude_Horaire_3__c), ISCHANGED(Tech_Amplitude_Horaire_4__c) )   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
