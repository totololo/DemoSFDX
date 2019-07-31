<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MAJDateFINJ31</fullName>
        <field>Date_de_fin__c</field>
        <formula>Date_de_debut__c +31</formula>
        <name>MAJDateFINJ31</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PERI_DateFINJ%2B31</fullName>
        <actions>
            <name>MAJDateFINJ31</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>A la création de pérodes suivantes : activé au reroutage, seuil teporaire et Pudo exclus de la suggestion de reroutage, la date de fin sera à J+31 de la date de début au moment de l&apos;enregistrement, elle sera ensuite modifiable manuellement.</description>
        <formula>and( not( $User.BypassWorkflow__c ),
    isblank( Date_de_fin__c ),
or (ispickval( Type_de_periode__c ,&quot;41&quot;),
    ispickval(Type_de_periode__c ,&quot;43&quot;),
    ispickval(Type_de_periode__c ,&quot;48&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
