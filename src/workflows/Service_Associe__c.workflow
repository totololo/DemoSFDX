<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MAJ_Date_modif_serv_assoc</fullName>
        <field>Date_de_modification__c</field>
        <formula>today()</formula>
        <name>MAJ Date modif serv assoc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SERAVIderDateFin</fullName>
        <description>Le champ &quot;Date de fin de statut&quot; est rempli vidée automatiquement quand 
statut est Définitif.</description>
        <field>Date_de_fin_du_statut__c</field>
        <name>SERAVIderDateFin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SERA_WF01_DateModif_Auto</fullName>
        <actions>
            <name>MAJ_Date_modif_serv_assoc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Le champ &quot;Date de modification&quot; est rempli automatiquement (date d&apos;aujourd&apos;hui) au moment de modification de la case à cocher &quot;Activé&quot;.</description>
        <formula>AND (
NOT ( $User.BypassWorkflow__c) ,
ischanged(Active__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SERA_WF02_DateFinVide</fullName>
        <actions>
            <name>SERAVIderDateFin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Le champ &quot;Date de fin de statut&quot; est rempli vidée automatiquement quand 
statut est Définitif.</description>
        <formula>AND (
NOT ( $User.BypassWorkflow__c) ,
ispickval (Etat_du_statut__c, &quot;Définitif&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
