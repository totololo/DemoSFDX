<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MAJ_DemandeSortie</fullName>
        <field>Statut_de_demande_de_sortie_de_DA__c</field>
        <literalValue>1</literalValue>
        <name>MAJ_DemandeSortie</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_StatutRequeteDemandeSortie</fullName>
        <field>Status</field>
        <literalValue>En attente demande de sortie</literalValue>
        <name>MAJ_StatutRequeteDemandeSortie</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Requete__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Statut_si_accepte</fullName>
        <field>Statut_de_demande_de_sortie_de_DA__c</field>
        <literalValue>2</literalValue>
        <name>MAJ Statut si accepté</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Staut_Requ_te_Sortie_Refuse</fullName>
        <field>Status</field>
        <literalValue>1</literalValue>
        <name>MAJ Staut Requête Sortie Refuse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Requete__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Staut_Requete_Sortie_Valide</fullName>
        <field>Status</field>
        <literalValue>Terminée</literalValue>
        <name>MAJ Staut Requête Sortie Valide</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Requete__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Staut_si_refusee</fullName>
        <field>Statut_de_demande_de_sortie_de_DA__c</field>
        <literalValue>3</literalValue>
        <name>MAJ Staut si refusée</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAj_SortieEnCours</fullName>
        <field>Status</field>
        <literalValue>En attente demande de sortie</literalValue>
        <name>MAj_SortieEnCours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Requete__c</targetObject>
    </fieldUpdates>
</Workflow>
