<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AutoFlagInjoignable</fullName>
        <description>&quot;Indisponibilité problème opérationnel - Anomalie Colis&quot; automatiquement attachée au FLAG INJOIGNABLE</description>
        <field>Injoignable__c</field>
        <literalValue>1</literalValue>
        <name>AutoFlagInjoignable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Coche_Injoignabl_en_cours_TECH_Compte</fullName>
        <description>Lorsque &quot;Injoignabilité&quot; est sélectionnée comme Sous-Type d&apos;Indisponibilité = coche la case &quot;Injoignabilité en cours TECH&quot; sur Compte</description>
        <field>Injoignabilite_en_cours_TECH__c</field>
        <literalValue>1</literalValue>
        <name>Coche Injoignabl en cours TECH Compte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Nom_du_compte__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DPD_BNL_decoche_case_Injoignabilite_TECH</fullName>
        <description>Pour une indisponibilité de sous-type &quot;Injoignable&quot; en cours et que la date de fin est dépassé alors la case &quot;Injoignable en cours TECH&quot; de l&apos;objet Compte est décochée.</description>
        <field>Injoignabilite_en_cours_TECH__c</field>
        <literalValue>0</literalValue>
        <name>DPD_BNL_decoche_case_Injoignabilite_TECH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Nom_du_compte__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Decoche_Injoignabl_en_cours_TECH_Compte</fullName>
        <description>Lorsque &quot;Injoignabilité&quot; est passée decoche la case &quot;Injoignabilité en cours TECH&quot; sur Compte</description>
        <field>Injoignabilite_en_cours_TECH__c</field>
        <literalValue>0</literalValue>
        <name>Decoche Injoignabl en cours TECH Compte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Nom_du_compte__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Decoche_case_injoignabiliteencours_TECH</fullName>
        <description>Décoche la case Champ &quot;Injoignabilité en cours TECH&quot;</description>
        <field>Injoignabilite_en_cours_TECH__c</field>
        <literalValue>0</literalValue>
        <name>Decoche_case_injoignabiliteencours_TECH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Nom_du_compte__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Decoche_le_champ_Injoignable</fullName>
        <description>Décoche le champ Injoignable lorsque l&apos;indisponibilité a un statut autre que &quot;En cours&quot;.</description>
        <field>Injoignable__c</field>
        <literalValue>0</literalValue>
        <name>Décoche le champ Injoignable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_Date_Today</fullName>
        <field>Injoignable_depuis_le__c</field>
        <formula>Today()</formula>
        <name>MAJ_Date_Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MAJ_INDISPO_date_de_debut_injoignabilite</fullName>
        <description>Pour une indisponibilité donnée, si la case &quot;Injoignable&quot; est décochée, alors le champs &quot;Injoignable depuis le&quot; est remis à zéro (sans date).</description>
        <field>Injoignable_depuis_le__c</field>
        <name>MAJ INDISPO date de debut injoignabilite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mise_jour_du_champ_Injoignable</fullName>
        <field>Injoignable__c</field>
        <literalValue>1</literalValue>
        <name>Mise à jour du champ Injoignable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CONG_WF01_UpdateDateDebutInjoignabilite</fullName>
        <actions>
            <name>MAJ_INDISPO_date_de_debut_injoignabilite</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Conge_Indispo__c.Injoignable__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWorkflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Pour une indisponibilité donnée, si la case &quot;Injoignable&quot; est décochée, alors le champs &quot;Injoignable depuis le&quot; est remis à zéro (sans date).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CONG_WF02_UpdateDateDebutInjoignabilite</fullName>
        <actions>
            <name>MAJ_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Conge_Indispo__c.Injoignable__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWorkflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Pour une indisponibilité donnée, si la case &quot;Injoignable&quot; est cochée, alors le champs &quot;Injoignable depuis le&quot; est la date d&apos;aujourd&apos;hui.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CONG_WF03_UpdateInjoignabilite</fullName>
        <actions>
            <name>Mise_jour_du_champ_Injoignable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ce workflow va cocher la case &quot;Injoignable&quot; lorsque l&apos;indisponibilité est de sous type &quot;Injoignabilité&quot; pour la France et que le statut est égal à &quot;En cours&quot;.</description>
        <formula>AND(  ISPICKVAL( Sous_type__c , &quot;Injoignabilité&quot;),  Statut__c = &quot;En cours&quot;, CONTAINS( RecordTypeId , $Label.CongInd_RT_IndispoFR) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CONG_WF04_Uncheck_Injoignable</fullName>
        <actions>
            <name>Decoche_le_champ_Injoignable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ce workflow est utilisé pour décocher la case Injoignable lorsque l&apos;injoignabilité est fermée.</description>
        <formula>AND( ISPICKVAL( Sous_type__c , &quot;Injoignabilité&quot;),  Statut__c = &quot;Passé&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPD_BNL_coche_case_Injoignabiliteencours_objet_compte_TECH</fullName>
        <actions>
            <name>Coche_Injoignabl_en_cours_TECH_Compte</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Conge_Indispo__c.Sous_type__c</field>
            <operation>equals</operation>
            <value>Injoignabilité</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWorkflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Conge_Indispo__c.Statut__c</field>
            <operation>contains</operation>
            <value>progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Conge_Indispo__c.Statut__c</field>
            <operation>contains</operation>
            <value>cours</value>
        </criteriaItems>
        <description>Pour une indisponibilité de sous-type &quot;Injoignable&quot; donnée, alors la case &quot;Injoignable en cours TECH&quot; de l&apos;objet Compte est cochée.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Conge_Indispo__c.Date_de_fin__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DPD_BNL_decoche_case_Injoignabiliteencours_objet_compte_TECH</fullName>
        <actions>
            <name>DPD_BNL_decoche_case_Injoignabilite_TECH</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>A la date de fin d&apos;indisponibilité de sous-type &quot;Injoignable&quot; donnée, alors la case &quot;Injoignable en cours TECH&quot; de l&apos;objet Compte est décochée lorsque que cette date est atteint</description>
        <formula>AND(  ISPICKVAL( Sous_type__c , &quot;Injoignabilité&quot;) , NOT($User.BypassWorkflow__c ),  Statut__c = $Label.Conge_Indispo_Passe  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
