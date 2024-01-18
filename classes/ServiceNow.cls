global class ServiceNow {

    @AuraEnabled
    webservice static void createCR(id crid){
        Change_Request__c cr = [SELECT Id,Name,Impact__c,Category__c,Description__c,justification__c,Risk__c,
                                        Priority__c,Risk_Impact_Analysis__c,Short_Description__c,Type__c,Implementation_Plan__c,Release_LookUp__c,
                                        Backout_Plan__c,Test_Plan__c,Planned_End_Date__c,Planned_Start_Date__c,Actual_Start_Date__c,Actual_End_Date__c,System_ID__c,Assignment_Group__c,Assigned_to__c
                                        FROM Change_Request__c  Where id =:crid];

        system.debug('decriptions ======'+cr.Description__c);
        string str = cr.Description__c;
        system.debug('STR ===='+str.Replace('<br>','\\r\\n'));
        Datetime planstartdate,planenddate,accstartdate,accenddate;
        
        //Convert Data/Time into SQL Format
        if(cr.Planned_Start_Date__c != null){
        planstartdate = (cr.Planned_Start_Date__c).addhours(12).addMinutes(30);}
        if (cr.Planned_End_Date__c !=null){
        planenddate = (cr.Planned_End_Date__c).addhours(12).addMinutes(30);}
        if (cr.Actual_Start_Date__c !=null){
        accstartdate = (cr.Actual_Start_Date__c).addhours(12).addMinutes(30);}
        if (cr.Actual_End_Date__c !=null){
        accenddate = (cr.Actual_End_Date__c).addhours(12).addMinutes(30);}

        //system.debug('Impact__c '+ cr.Impact__c);
        string bodyJSON = '{ "short_description": "'+cr.Short_Description__c+'", "description": "'+str.Replace('<br>','\\r\\n')+'", "type": "'+cr.Type__c+'", "priority": "'+cr.Priority__c+'", "risk": "'+cr.Risk__c+'", "impact": "'+cr.Impact__c+'", "justification": "'+cr.justification__c+'", "risk_impact_analysis": "'+cr.Risk_Impact_Analysis__c+'", "category": "'+cr.Category__c+'", "test_plan": "'+cr.Test_Plan__c+'", "implementation_plan": "'+cr.Implementation_Plan__c+'", "backout_plan": "'+cr.Backout_Plan__c+'", "start_date": "'+planstartdate+'", "end_date": "'+planenddate+'", "work_start": "'+accstartdate+'", "work_end": "'+accenddate+'", "assignment_group": "'+cr.Assignment_Group__c+'" }';
		system.debug('body JSON =====  '+bodyJSON);
        
        if(cr.System_ID__c == null){
            // Instantiate a new http object
            Http h = new Http();
            
            // This will instantiate a new HTTP request, specify the method as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:ServiceNow'+'/'+cr.Type__c);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setBody(bodyJSON);
            // This will send the request, and return a response
            HttpResponse res = h.send(req);
            System.debug('response code ====' + res.getStatusCode());
            System.debug('request response: ===== ' + res.getBody());    
            
            if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                // Get the response body
                String responseBody = res.getBody();

                // Deserialize the JSON response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                System.debug('jsonResponse=====    '+jsonResponse);
                // Access specific fields in the JSON response
                Map<String, Object> jsonResponse1 = (Map<String, Object>) jsonResponse.get('result');
                System.debug('jsonResponse1=====   '  +jsonResponse1);
                //Access the SysID field in the result response 
                Map<String, Object> jsonResponse2 = (Map<String, Object>) jsonResponse1.get('sys_id');
                System.debug('jsonResponse1=====   '  +jsonResponse2);
                //Access the Change Number field in the result response 
                Map<String, Object> jsonResponse3 = (Map<String, Object>) jsonResponse1.get('number');
                System.debug('jsonResponse1=====   '  +jsonResponse3);
                String sysid =jsonResponse2.get('value').toString();
                String crno =jsonResponse3.get('value').toString();
                system.debug('System ID :'+sysid+' & CRNO - '+crno);
                Change_Request__c mycr = new Change_Request__c();
                mycr = [select id,name from Change_Request__c where id =:crid];
                mycr.System_ID__c = sysid;
                mycr.CR_Number__c = crno;
                mycr.error_Response__C = null;
                //system.debug('System ID - '+mycr.System_ID__c);
                update mycr;
            } else{
                String responseBody = res.getBody();

                // Deserialize the JSON response
                Map<String, Object> errorResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                System.debug('errorResponse=====    '+errorResponse);/*
                // Access specific fields in the JSON response
                Map<String, Object> jsonResponse1 = (Map<String, Object>) errorResponse.get('error');
                System.debug('messageResponse1=====   '  +jsonResponse1);*/
                Change_Request__c mycr = new Change_Request__c();
                mycr = [select id,name,error_Response__C from Change_Request__c where id =:crid];
                string errp = errorResponse.get('error').toString();
                System.debug('errp ==='+errp);
                mycr.error_Response__C = errp;
                update mycr;
            }
        }
        else{

                Change_Request__c mycr = new Change_Request__c();
                mycr = [select id,name,error_Response__C from Change_Request__c where id =:crid];
                mycr.error_Response__C = 'CR already exists';
                update mycr;

        }
    }

    @AuraEnabled
    Public static void updateCR(id crid){
        Change_Request__c cr = [SELECT Id,Name,Impact__c,Category__c,Description__c,justification__c,Risk__c,
                                        Priority__c,Risk_Impact_Analysis__c,Short_Description__c,Type__c,Implementation_Plan__c,Release_LookUp__c,
                                        Backout_Plan__c,Test_Plan__c,System_ID__c,Planned_End_Date__c,Planned_Start_Date__c,Actual_Start_Date__c,Actual_End_Date__c,Assignment_Group__c,Assigned_to__c FROM 
                                        Change_Request__c  Where id =:crid];

        string str = cr.Description__c;
        system.debug('STR ===='+str.Replace('<br>','\\r\\n'));

        Datetime planstartdate,planenddate,accstartdate,accenddate;
        
        //Convert Data/Time into SQL Format
        if(cr.Planned_Start_Date__c != null){
        planstartdate = (cr.Planned_Start_Date__c).addhours(12).addMinutes(30);}
        if (cr.Planned_End_Date__c !=null){
        planenddate = (cr.Planned_End_Date__c).addhours(12).addMinutes(30);}
        if (cr.Actual_Start_Date__c !=null){
        accstartdate = (cr.Actual_Start_Date__c).addhours(12).addMinutes(30);}
        if (cr.Actual_End_Date__c !=null){
        accenddate = (cr.Actual_End_Date__c).addhours(12).addMinutes(30);}

       // system.debug('planstartdate >>> '+ planstartdate + '  planenddate >>>> '+planenddate);
        
        //Request Body to be sent
        string bodyJSON = '{ "short_description": "'+cr.Short_Description__c+'", "description": "'+str.Replace('<br>','\\r\\n')+'", "type": "'+cr.Type__c+'", "priority": "'+cr.Priority__c+'", "risk": "'+cr.Risk__c+'", "impact": "'+cr.Impact__c+'", "justification": "'+cr.justification__c+'", "risk_impact_analysis": "'+cr.Risk_Impact_Analysis__c+'", "category": "'+cr.Category__c+'", "test_plan": "'+cr.Test_Plan__c+'", "implementation_plan": "'+cr.Implementation_Plan__c+'", "backout_plan": "'+cr.Backout_Plan__c+'", "start_date": "'+planstartdate+'", "end_date": "'+planenddate+'", "work_start": "'+accstartdate+'", "work_end": "'+accenddate+'", "assigned_to": "'+cr.Assigned_to__c+'", "assignment_group": "'+cr.Assignment_Group__c+'"}';
		system.debug('body JSON ===='+bodyJSON);
        // Instantiate a new http object
        Http h = new Http();
        // This will instantiate a new HTTP request, specify the method as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ServiceNow'+'/'+cr.System_ID__c);
        //String endUrl =req.setEndpoint;
        //system.debug('Endpoint =====', endUrl)
        req.setMethod('PATCH');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(bodyJSON);
        // This will send the request, and return a response
        HttpResponse res = h.send(req);
        system.debug('Response Code ====='+res.getStatusCode());
        System.debug('request response: ' + res.getBody() );
    }
	@AuraEnabled
    Public static void getCR(id crid){
        Change_Request__c cr = [SELECT Id,Name,Impact__c,Category__c,Description__c,justification__c,Risk__c,
                                        Priority__c,Risk_Impact_Analysis__c,Short_Description__c,Type__c,Implementation_Plan__c,
                                        Backout_Plan__c,Test_Plan__c,System_ID__c,Planned_End_Date__c,Planned_Start_Date__c,Actual_Start_Date__c,Actual_End_Date__c FROM 
                                        Change_Request__c  Where id =:crid];

        // Instantiate a new http object
        Http h = new Http();
        // This will instantiate a new HTTP request, specify the method as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ServiceNow'+'/'+cr.System_ID__c);
        //String endUrl =req.setEndpoint;
        //system.debug('Endpoint =====', endUrl)
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // This will send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug('request response: ' + res.getBody() );
        
   
        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) 
        {

            list<string> param = new list<string>();
            // Get the response body
            String responseBody = res.getBody();

            // Deserialize the JSON response
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            System.debug('jsonResponse====='+jsonResponse);
            // Access specific fields in the JSON response
            Map<String, Object> jsonResponse1 = (Map<String, Object>) jsonResponse.get('result');
            System.debug('jsonResponse1  ====='+jsonResponse1);
            
            //Access the SysID field in the result response 
            Map<String, Object> sysid_response = (Map<String, Object>) jsonResponse1.get('sys_id');
            System.debug('sysid_response =====   '  +sysid_response);
            String sysid =sysid_response.get('value').toString();
            System.debug('Sysid Value=====   '  +sysid);
            param.add(sysid);

            //Access the short_description field in the result response 
            Map<String, Object> short_description_response = (Map<String, Object>) jsonResponse1.get('short_description');
            System.debug('short_description_response =====   '  +short_description_response);
            String short_description =short_description_response.get('value').toString();
            System.debug('short_description Value=====   '  +short_description);
            param.add(short_description);

            //Access the description field in the result response 
            Map<String, Object> description_response = (Map<String, Object>) jsonResponse1.get('description');
            System.debug('description =====   '  +description_response);
            String description =description_response.get('value').toString();
            System.debug('description Value=====   '  +description);
            List<String> userStoryDescriptions = new List<String>();
            userStoryDescriptions.add(description);
            system.debug('userStoryDescriptions ======'+userStoryDescriptions);

            param.add(description);

            //Access the priority field in the result response 
            Map<String, Object> priority_response = (Map<String, Object>) jsonResponse1.get('priority');
            System.debug('priority_response =====   '  +priority_response);
            Decimal priority =(Decimal)priority_response.get('value');
            String priorityvalueAsString = String.valueOf(priority);
            System.debug('priority Value=====   '  +priorityvalueAsString);
            param.add(priorityvalueAsString);

            //Access the risk field in the result response 

            Map<String, Object> impact_response = (Map<String, Object>) jsonResponse1.get('impact');
            System.debug('impact_response =====   '  +impact_response);
            // Extract the "value" from the JSON map
            Decimal impact = (Decimal)impact_response.get('value');
            String impactpriorityvalueAsString = String.valueOf(impact);
            System.debug('impact Value=====   '  +impactpriorityvalueAsString);
            param.add(impactpriorityvalueAsString);
            

            //Access the justification field in the result response 
            Map<String, Object> justification_response = (Map<String, Object>) jsonResponse1.get('justification');
            System.debug('justification_response =====   '  +justification_response);
            String justification =justification_response.get('value').toString();
            System.debug('justification Value=====   '  +justification);
            param.add(justification);

            //Access the risk_impact_analysis field in the result response 
            Map<String, Object> risk_impact_analysis_response = (Map<String, Object>) jsonResponse1.get('risk_impact_analysis');
            System.debug('risk_impact_analysis_response =====   '  +risk_impact_analysis_response);
            String risk_impact_analysis =risk_impact_analysis_response.get('value').toString();
            System.debug('risk_impact_analysis Value=====   '  +risk_impact_analysis);
            param.add(risk_impact_analysis);

            //Access the category field in the result response 
            Map<String, Object> category_response = (Map<String, Object>) jsonResponse1.get('category');
            System.debug('category_response =====   '  +category_response);
            String category =category_response.get('value').toString();
            System.debug('category Value=====   '  +category);
            param.add(category);

            //Access the test_plan field in the result response 
            Map<String, Object> test_plan_response = (Map<String, Object>) jsonResponse1.get('test_plan');
            System.debug('test_plan_response =====   '  +test_plan_response);
            String test_plan =test_plan_response.get('value').toString();
            System.debug('test_plan Value=====   '  +test_plan);
            param.add(test_plan);

            //Access the implementation_plan field in the result response 
            Map<String, Object> implementation_plan_response = (Map<String, Object>) jsonResponse1.get('implementation_plan');
            System.debug('implementation_plan_response =====   '  +implementation_plan_response);
            String implementation_plan =implementation_plan_response.get('value').toString();
            System.debug('implementation_plan Value=====   '  +implementation_plan);
            param.add(implementation_plan);

            //Access the backout_plan field in the result response 
            Map<String, Object> backout_plan_response = (Map<String, Object>) jsonResponse1.get('backout_plan');
            System.debug('backout_plan_response =====   '  +backout_plan_response);
            String backout_plan =backout_plan_response.get('value').toString();
            System.debug('backout_plan Value=====   '  +backout_plan);
            param.add(backout_plan);

           /* //Access the State field in the result response 
            Map<String, Object> state_response = (Map<String, Object>) jsonResponse1.get('state');
            System.debug('state_response =====   '  +state_response);
            String state =state_response.get('value').toString();
            System.debug('state Value=====   '  +state_response);
            param.add(state);*/


            Map<String, Object> state_response = (Map<String, Object>) jsonResponse1.get('state');
            System.debug('state_response =====   '  +state_response);
            // Extract the "value" from the JSON map
            Decimal state = (Decimal)state_response.get('value');
            String state_responsevalueAsString = String.valueOf(state);
            System.debug('state_responsevalueAsString Value=====   '  +state_responsevalueAsString);
            param.add(state_responsevalueAsString);
            /*
            //Access the start_date field in the result response 
            Map<String, Object> start_date_response = (Map<String, Object>) jsonResponse1.get('start_date');
            System.debug('start_date_response =====   '  +start_date_response);
            String start_date =start_date_response.get('value').toString();
            System.debug('start_date Value=====   '  +start_date);
            if(start_date != null){
                DateTime start_dateTimeValue = DateTime.valueOf(start_date);
                DateTime start_newDateTimeValue = start_dateTimeValue.addHours(-7);
            param.add(start_date);}

            //Access the end_date field in the result response 
            Map<String, Object> end_date_response = (Map<String, Object>) jsonResponse1.get('end_date');
            System.debug('end_date_response =====   '  +end_date_response);
            String end_date =end_date_response.get('value').toString();
            System.debug('end_date Value=====   '  +end_date);
            param.add(end_date);

            //Access the work_start field in the result response 
            Map<String, Object> work_start_response = (Map<String, Object>) jsonResponse1.get('work_start');
            System.debug('work_start_response =====   '  +work_start_response);
            String work_start =work_start_response.get('value').toString();
            System.debug('work_start Value=====   '  +work_start);
            param.add(work_start);

            //Access the work_end field in the result response 
            Map<String, Object> work_end_response = (Map<String, Object>) jsonResponse1.get('work_end');
            System.debug('work_end_response =====   '  +work_end_response);
            String work_end =work_end_response.get('value').toString();
            System.debug('work_end Value=====   '  +work_end);
            param.add(work_end);*/

            system.debug('List of Param ====='+ param);

            Change_Request__c mycr = new Change_Request__c();
            mycr = [select id,Name,Impact__c,Category__c,Description__c,justification__c,Risk__c,Status__c,
                                        Priority__c,Risk_Impact_Analysis__c,Short_Description__c,Type__c,Implementation_Plan__c,
                                        Backout_Plan__c,Test_Plan__c,System_ID__c,Planned_End_Date__c,Planned_Start_Date__c,Actual_Start_Date__c,Actual_End_Date__c FROM 
                                        Change_Request__c where id =:crid];
                       
            //mycr.description__C=null; 
            system.debug('mycr descriptioon ======'+mycr.description__C);                         
            for(String ud : userStoryDescriptions){
                //mycr.Description__c = mycr.Description__c!=null? mycr.Description__c+'\\n'+ud:ud;
                system.debug('cr.description__C===='+cr.description__C);
            }
            //mycr.Description__c = description;
            mycr.Risk_Impact_Analysis__c = risk_impact_analysis;
            mycr.Status__c = state_responsevalueAsString;
            //mycr.Status__c = 
            //mycr.Planned_Start_Date__c = start_newDateTimeValue;
            //system.debug('start_dateTimeValue ======'+start_newDateTimeValue);
            //system.debug('System ID - '+mycr.System_ID__c);
            //system.debug('Description__c - '+mycr.Description__c);
            system.debug('mycr.Status__c - '+mycr.Status__c);
            update mycr; 
        }
    }
	@AuraEnabled
    Public static void getCTask (id crid){

        Change_Request__c cr = [SELECT Id,Name,Impact__c,Category__c,Description__c,justification__c,Risk__c,
                                        Priority__c,Risk_Impact_Analysis__c,Short_Description__c,Type__c,Implementation_Plan__c,
                                        Backout_Plan__c,Test_Plan__c,System_ID__c,Planned_End_Date__c,Planned_Start_Date__c,Actual_Start_Date__c,Actual_End_Date__c
                                        FROM Change_Request__c  Where id =:crid];  

        // Instantiate a new http object
        Http h = new Http();
        
        // This will instantiate a new HTTP request, specify the method as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ServiceNow'+'/'+cr.System_ID__c+'/task');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //req.setBody(bodyJSON);
        // This will send the request, and return a response
        HttpResponse res = h.send(req);
        //System.debug('request response: ===== ' + res.getBody() );

        String jsonResponse = res.getBody(); // Replace with your JSON response

        // Parse the JSON string
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        //System.debug('jsonMap request response: ===== ' + jsonMap );

        List<Object> jsonResponseList = (List<Object>) jsonMap.get('result');
        System.debug('jsonResponseList ===== ' + jsonResponseList);

        // Check if the parsed JSON list contains multiple results & JSON map is empty or has data
        if (jsonResponseList.isEmpty()) {
            System.debug('JSON response is empty.');
        }
         else {
            System.debug('JSON response has multiple results.');
            // Iterate through the results and store in objects
            List<Change_Task__c> ctToUpdate = new List<Change_Task__c>();
            List<Change_Task__c> ctToInsert = new List<Change_Task__c>();
            for (Object result : jsonResponseList) {
            Map<String, Object> resultData = (Map<String, Object>) result;
            //Access the system ID field in the result response 
            Map<String, Object> systemid_response = (Map<String, Object>) resultData.get('sys_id');
            //System.debug('systemid_response =====   '  +systemid_response);
            String systemid =systemid_response.get('value').toString();
            System.debug('systemid Value=====   '  +systemid);

            //Access the ctnumber_ID field in the result response
            Map<String, Object> ctnumber_response = (Map<String, Object>) resultData.get('number');
            System.debug('ctnumber_response =====   '  +ctnumber_response);
            String ctnumber =ctnumber_response.get('value').toString();
            System.debug('ctnumber Value=====   '  +ctnumber);

            //Access the short_description field in the result response
            Map<String, Object> short_description_response = (Map<String, Object>) resultData.get('short_description');
            //System.debug('short_description_response =====   '  +short_description_response);
            String short_description =short_description_response.get('value').toString();
            System.debug('short_description Value=====   '  +short_description);

            //Access the description field in the result response
            Map<String, Object> description_response = (Map<String, Object>) resultData.get('description');
            //System.debug('description_response =====   '  +description_response);
            String description =description_response.get('value').toString();
            System.debug('description Value=====   '  +description);

            //Access the change_request field in the result response
            Map<String, Object> change_request_response = (Map<String, Object>) resultData.get('change_request');
            //System.debug('change_request_response =====   '  +description_response);
            String change_request =change_request_response.get('display_value').toString();
            System.debug('change_request display Value=====   '  +change_request);

            //Access the change_request_value field in the result response
            Map<String, Object> change_request_value_response = (Map<String, Object>) resultData.get('change_request');
            //System.debug('change_request_value_response =====   '  +description_response);
            String change_request_value =change_request_value_response.get('value').toString();
            System.debug('change_request_ ID=====   '  +change_request_value);

            //Query for existing record
            List<Change_Task__c> existingRecords = [SELECT Id, System_ID__c,Short_description__c,Description__c,Change_Task_Number__c FROM Change_Task__c WHERE System_ID__c = :systemid];
            system.debug('existing records ===='+existingRecords);
            if (!existingRecords.isEmpty()) {
            // Update existing record
                for (Change_Task__c existingRecord : existingRecords) {
                    system.debug('Change task exists added to update list');
                    existingRecord.Short_description__c = short_description;
                    existingRecord.Description__c = description;
                    existingRecord.Change_Task_Number__c = ctnumber;
                    system.debug('existingRecord short desc ===='+existingRecord.Short_description__c);
                    ctToUpdate.add(existingRecord);
                }
            } else {
                List<Change_Request__c> crexistingRecords = [SELECT Id, CR_Number__c,System_ID__c,Short_description__c,Description__c FROM Change_Request__c WHERE System_ID__c = :change_request_value];
                system.debug('Change request Found '+crexistingRecords);
                // Create new record
                for (Change_Request__c crex : crexistingRecords){
                system.debug('Change task doesnt exists added to insert list');
                Change_Task__c Changetasknew = new Change_Task__c();
                Changetasknew.System_ID__c = systemid;
                Changetasknew.Short_description__c = short_description;
                Changetasknew.Description__c = description;
                Changetasknew.Change_Task_Number__c = ctnumber;
                Changetasknew.Change_Request__c = crex.ID;
                //Changetasknew.Change_Task_Number__c = changenumber;;
                System.debug('Change Task new Details ===='+Changetasknew);
                ctToInsert.add(Changetasknew);
                }
            }
        }
        if (!ctToUpdate.isEmpty()) {
        update ctToUpdate; // Update existing records
        system.debug('updated the record');
        }
        if (!ctToInsert.isEmpty()) {
            insert ctToInsert; // Insert new records
            system.debug('inserted the record');
        }
    }
}
    @AuraEnabled    
    Public static void closeCTask (id ctid){
      Change_Task__c ct =  [select id,name,Change_Request__c, Change_Task_Number__c, System_ID__c from Change_Task__c where id =:ctid];
      String changeRequestValue = ct.Change_Request__c;
      Change_Request__c cr = [select id,name,System_ID__c from Change_Request__c WHERE id = :changeRequestValue];
      string crid =cr.id;
      system.debug('sting CRID ====='+crid);
       string bodyJSON = '{"state": "3"}';
        // Instantiate a new http object
        Http h = new Http();
        // This will instantiate a new HTTP request, specify the method as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ServiceNow'+'/'+cr.System_ID__c+'/task/'+ct.System_ID__c);
        req.setMethod('PATCH');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(bodyJSON);
        // This will send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug('response code ====' + res.getStatusCode());
        System.debug('request response: ===== ' + res.getBody());
}
}