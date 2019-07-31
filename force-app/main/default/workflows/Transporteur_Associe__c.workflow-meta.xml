<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MAJ_Date_modif_trans_assoc</fullName>
        <field>Date_de_modification__c</field>
        <formula>today()</formula>
        <name>MAJ Date modif trans assoc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAA_DateFinVide</fullName>
        <description>Le champ &quot;Date de fin de statut&quot; est vidée automatiquement quand 
statut est Définitif.</description>
        <field>Date_de_fin_du_statut__c</field>
        <name>TRAA_DateFinVide</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TRAA_WF01_DateModif_auto</fullName>
        <actions>
            <name>MAJ_Date_modif_trans_assoc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Le champ &quot;Date de modification&quot; est rempli automatiquement au moment de modification de la case à cocher &quot;Activé&quot;</description>
        <formula>AND (
NOT ( $User.BypassWorkflow__c ),
ischanged( Active__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAA_WF02_DateFinVide</fullName>
        <actions>
            <name>TRAA_DateFinVide</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Le champ &quot;Date de fin de statut&quot; est vidée automatiquement quand 
statut est Définitif.</description>
        <formula>AND (
NOT ( $User.BypassWorkflow__c ),
ispickval (Etat_du_statut__c, &quot;Définitif&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
