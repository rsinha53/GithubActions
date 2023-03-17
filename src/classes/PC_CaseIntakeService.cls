/********************************************************************************
Class Name: PC_CaseIntakeService
Purpose: This class is responsible to capture case intake requests from third 
    party system for both CPM and RESCU.
Developer: Suman Kundu
Created On: 9/10/2018 
********************************************************************************/
@RestResource(urlMapping='/IntakeProcess/*')
global with sharing class PC_CaseIntakeService {
    
    @HttpPost 
    global static PC_Response doPost() {
        RestRequest reqContext = RestContext.request;
        PC_Response resp;
        try {
        	PC_IntakeServiceHandler serviceHandler = new PC_IntakeServiceHandler();
        	resp = serviceHandler.processRequest(reqContext);
        }catch(Exception e) {
        	 resp = (PC_Response)GenericExceptionHandler.handle(e);
        }
        system.debug('resp >> '+JSON.serialize(resp));
        return resp;
    }
}