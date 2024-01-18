<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_Developer_Alert</fullName>
        <description>Email to Developer Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>pavani.k@cloudfulcrum.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>copado__Developer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_to_Developer</template>
    </alerts>
</Workflow>
