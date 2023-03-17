/*
**********************************************************************************
Class Name:  NPSSurvey
Description :
Author: Balakrishnan,
Created Date : 03-11-2021
Modification History :
**********************************************************************************
*/
@RestResource(urlMapping='/SNI/NPSSurvey/*')
global class SNI_FL_NPSSurveyService {
@HTTPGet
    global static responseWrapper getAgentMemberName() {
        
      RestRequest req = RestContext.request;
      RestResponse res = Restcontext.response;
     
      
      try{
            
            string npsId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            NPS_Data__c accrec = [select id,name,Member_Name__c,Agent_Name__c from NPS_Data__c where id=:npsId];
            responseWrapper wResponse = new responseWrapper();
            wResponse.memberName =accrec.Member_Name__c;
            wResponse.agentName =accrec.Agent_Name__c;
          
          return wResponse;
            
         }
        Catch(Exception ex){
            system.debug('Error:'+ex);
            responseWrapper wResponse = new responseWrapper();
            wResponse.errorMessage ='Error:'+ex;
            return wResponse;
        }
      

    }
    
    global class responseWrapper{
       global string agentName;
       global string memberName;
       global string errorMessage;
      }
    
}