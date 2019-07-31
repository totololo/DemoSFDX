<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UPDATE_Date_Fin_Injoignabilite</fullName>
        <description>La date de fin de l&apos;injoignabilité est égale à la date de fin de l&apos;indisponibilité correspondante.</description>
        <field>Date_de_fin1__c</field>
        <formula>Indisponibilite__r.Date_de_fin__c</formula>
        <name>UPDATE_Date_Fin_Injoignabilite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>HINJ_WF01_UpdateDateFinInjoignabilite</fullName>
        <actions>
            <name>UPDATE_Date_Fin_Injoignabilite</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Pour un historique d&apos;injoignabilité donné :
Si sa date de fin est nulle et la date de fin de l&apos;indisponibilité correspondante est passée,
alors sa date de fin est remise à la date de fin de l&apos;indisponibilité.</description>
        <formula>AND(!$User.BypassWorkflow__c ,ISNULL(Date_de_fin1__c),  Indisponibilite__r.Statut__c=&apos;Passé&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
