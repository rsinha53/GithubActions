@RestResource(urlMapping='/v1/ETSBECaseInfo/*')
   global with sharing class ETSBE_RMSIntgAPI{
     @HttpGet
      global static string fetchCase(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String caseno = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String cascoments='';  
        String result;  
        if(String.isNotBlank(caseno) && caseno!=null){
            List<Case> casinfo =new List<Case>();
            //US2693087:Change
            casinfo= [Select Id,Broker_ID__c,Broker_Name__c,CaseNumber,Platform__c,Assigned_Broker__c,Reward_Account_Number__c,Interaction__r.Name,Special_Instructions_Description__c,
                      Event_Received_Date_Time__c,Originator_name__c,OriginatorPhone__c,Funding_Type__c,Subject_Name__c,ID__c,RecordType.Name,Member_Relationship__c from case where CaseNumber=:caseno AND RecordType.Name IN('BEO','BEO_Closed') Limit 1];
            List<CaseComment> comentslst = new List<CaseComment>();
            if(casinfo!=null && casinfo.size()>0){
                comentslst = [select CreatedDate,CommentBody,ParentId,CreatedBy.Name from casecomment where ParentId=:casinfo[0].Id];
             }   
            if(comentslst!=null && comentslst.size()>0){
                for(CaseComment rec: comentslst){
                    cascoments = cascoments+ rec.CreatedBy.Name+'-'+rec.CreatedDate+'-'+rec.CommentBody+';';
                }
             }
            JSONGenerator gen = JSON.createGenerator(true);
            if(casinfo!=null && casinfo.size()>0){
            gen.writeStartObject();
            gen.writeStringField('FundType', casinfo[0].Funding_Type__c != null?casinfo[0].Funding_Type__c:'');
            gen.writeStringField('Platform', casinfo[0].Platform__c != null?casinfo[0].Platform__c:'');
            gen.writeStringField('AssignBroker', casinfo[0].Assigned_Broker__c != null?casinfo[0].Assigned_Broker__c:'');
            gen.writeStringField('RewardAccNo', casinfo[0].Reward_Account_Number__c != null?casinfo[0].Reward_Account_Number__c:'');
              gen.writeStringField('IntractID', casinfo[0].Interaction__r.Name!= null?casinfo[0].Interaction__r.Name:'');
              gen.writeStringField('EventRecdDateTime', String.valueOf(casinfo[0].Event_Received_Date_Time__c) != null?String.valueOf(casinfo[0].Event_Received_Date_Time__c):'');
              gen.writeStringField('OrigName', casinfo[0].Originator_name__c != null?casinfo[0].Originator_name__c:'');
              gen.writeStringField('OrigPhone', casinfo[0].OriginatorPhone__c != null?casinfo[0].OriginatorPhone__c:'');
              gen.writeStringField('SubjName', casinfo[0].Subject_Name__c != null?casinfo[0].Subject_Name__c:'');
              gen.writeStringField('SubjID', casinfo[0].ID__c!= null?casinfo[0].ID__c:'');
              gen.writeStringField('Membreltype', casinfo[0].Member_Relationship__c!= null?casinfo[0].Member_Relationship__c:'');
              gen.writeStringField('issuedesc', casinfo[0].Special_Instructions_Description__c != null?casinfo[0].Special_Instructions_Description__c:'');
              gen.writeStringField('cascomments',cascoments!= null?cascoments:'');
                /*change:US2693087*/
                gen.writeStringField('BrokerId', casinfo[0].Broker_ID__c != null?casinfo[0].Broker_ID__c:'');
                gen.writeStringField('BrokerName', casinfo[0].Broker_Name__c != null?casinfo[0].Broker_Name__c:'');
              gen.writeEndObject();
            }
            result=gen.getasString();           
        }
       return result;
      }
   }