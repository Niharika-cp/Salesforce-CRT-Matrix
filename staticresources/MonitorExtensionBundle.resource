{
  "recordTypeMap": {},
  "RecordSetBundles": [
    {
      "Records": [
        {
          "attributes": {
            "type": "copado__Function__c",
            "url": "/services/data/v55.0/sobjects/copado__Function__c/a1A5e000000YsjPEAS"
          },
          "copado__API_Name__c": "setup_audit_trail",
          "copado__Callback_Type__c": "Flow",
          "copado__FlowHandler__c": "Monitor_Environments_Callback",
          "copado__Image_Name__c": "copado-function-core:v1",
          "copado__Options__c": "[ ]",
          "copado__Parameters__c": "[ {\n  \"required\" : false,\n  \"name\" : \"SessionID\",\n  \"defaultValue\" : \"{$RecordId.Credential.SessionId}\"\n}, {\n  \"required\" : false,\n  \"name\" : \"Endpoint\",\n  \"defaultValue\" : \"{$RecordId.Credential.Endpoint}\"\n}, {\n  \"required\" : true,\n  \"name\" : \"IntegrationUsername\",\n  \"defaultValue\" : \"mfranz@copado.com.demopersonal.dev1\"\n} ]",
          "copado__Script__c": "#!/usr/bin/env bash\n\n## Convert the SOAP endpoint parameter to the Data endpoint\nURLPath=$(dirname \"$Endpoint\")\nQUERYPATH=${URLPath/Soap\\/u\\//data/v}\n\n## Query SFDC for impersonations\ncurl \"$QUERYPATH/query/?q=SELECT+Name+from+User+WHERE+Username=%27$IntegrationUsername%27\" -H \"Authorization: Bearer $SessionID\" > userDetails.json\n\n## Query SFDC for impersonations\ncurl \"$QUERYPATH/query/?q=SELECT+ID,CreatedDate,+CreatedBy.Name,CreatedBy.Username,+Display+from+SetupAuditTrail+WHERE+createddate+>=+LAST_N_DAYS:3+AND+Action+=+%27suOrgAdminLogin%27\" -H \"Authorization: Bearer $SessionID\" > impersonations.json\n\n## Query SFDC for metadata changes NOT made by the integration user OR they were made by impersonation\ncurl \"$QUERYPATH/query/?q=SELECT+ID,CreatedDate,CreatedBy.Name,CreatedBy.Username,Action,Section,Display,DelegateUser+FROM+SetupAuditTrail+WHERE+createddate+>=+LAST_N_DAYS:3+AND+CreatedByID!=null+AND+CreatedBy.Name!=%27Automated+Process%27+AND+((CreatedBy.Username+!=+%27$IntegrationUsername%27)+OR+DelegateUser+!=+null)\" -H \"Authorization: Bearer $SessionID\" > metadatachanges.json\n\n## Save impersonation file back to Copado Salesforce Org so it can be processed\ncopado -u impersonations.json\ncopado -u metadatachanges.json\ncopado -u userDetails.json",
          "copado__Type__c": "Custom",
          "copado__Worker_Size__c": "S",
          "Id": "a1A5e000000YsjPEAS",
          "LastReferencedDate": "2022-10-04T09:42:58.000+0000",
          "LastViewedDate": "2022-10-04T09:42:58.000+0000",
          "Name": "Setup Audit Log Trail"
        }
      ],
      "ObjectType": "copado__Function__c"
    }
  ],
  "blobsByUID": {}
}