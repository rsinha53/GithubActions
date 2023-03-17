/**
* Author: Sai Kolluru
* Description : Used by ADB_MyFollowUpsComponent
* AuraEnabled : 
* Date Created: 10/01/2021
*/ 
public without sharing class ADBMyFollowUpsController {
   
    @AuraEnabled
    public static Map<String,Object> getMyFollowupsWorkloadList(String logonId, String officeId){
        
        ADBFollowupsWorkloadListReqWrapper req = new ADBFollowupsWorkloadListReqWrapper();
        ADBFollowupsWorkloadListResWpr res = new ADBFollowupsWorkloadListResWpr();
        List<String> codeLst = new List<String>();
        Map<String,Object> resMap = new Map<String,Object>();
        Map<String,String> commitmentMap = new Map<String,String>();
        try{
            req.controlModifiersType = new ADBFollowupsWorkloadListReqWrapper.ControlModifiersType();
            req.controlModifiersType.orsSystemParameter = new ADBFollowupsWorkloadListReqWrapper.OrsSystemParameter();
            req.controlModifiersType.orsSystemParameter.logonId = logonId;
       		req.controlModifiersType.orsSystemParameter.logonOffice = officeId;
            ADBFollowupsWorkloadListReqWrapper.WorkLoadSelection ws = new ADBFollowupsWorkloadListReqWrapper.WorkLoadSelection();
            req.requestHeader = new ADBFollowupsWorkloadListReqWrapper.RequestHeader();
            req.requestHeader.applicationName = 'ACET';
     		req.requestHeader.applicationInstanceName = 'ACET';
     		req.requestHeader.logLevel = 'INFO';
            ws.associateId = logonId;
       		ws.officeId = officeId;
       		ws.departmentCode = 'SYS';
            req.workLoadSelection = new List<ADBFollowupsWorkloadListReqWrapper.workLoadSelection>();
            req.workLoadSelection.add(ws);
            req.businessIndicator = 'U';
   			req.requestIndicator = 'A';
   			req.sortOrder = 'D';
            req.requestHeader.serviceOption = new List<ADBFollowupsWorkloadListReqWrapper.ServiceOption>();
            ADBFollowupsWorkloadListReqWrapper.ServiceOption so= new ADBFollowupsWorkloadListReqWrapper.ServiceOption();
           	so.key = 'MAX_CALL_COUNT';
         	so.value = '1';
            req.requestHeader.serviceOption.add(so);
            String serializedBody = JSON.serialize(req);
             ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ORSMyFollowupsSelectWorkloadList', serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            system.debug('response for myFollowups'+response);
            if(response!= null && response.getStatusCode() == 200 || response.getStatusCode() == 400 || response.getStatusCode() == 500){
                
                system.debug('response for MyFollowups '+response.getBody());
                res = (ADBFollowupsWorkloadListResWpr) JSON.deserialize(response.getBody(), ADBFollowupsWorkloadListResWpr.class);
                resMap.put('followupsMap',res);
                if(res.workList!= null && res.workList.size()>0){
                    system.debug('response worklists available');
                    for(ADBFollowupsWorkloadListResWpr.WorkList wl:res.workList){
                        if(wl.followUpOwner.statusDescription == 'OPEN'){
                            codeLst.add(wl.followUpOwner.purposeCode);
                        }
                    }
                
                    List<ADBCommitmentCode__mdt> commitmentCodeList =  new List<ADBCommitmentCode__mdt>([SELECT key__c, value__c FROM ADBCommitmentCode__mdt where key__c=: codeLst]);
                    if(null != commitmentCodeList){
                        for(ADBCommitmentCode__mdt mp:commitmentCodeList){
                            commitmentMap.put(mp.key__c,mp.value__c);
                        }	
                    }
                    resMap.put('commitmentCodeMap',commitmentMap);
            	}
                else if(res.title == 'Validation Error' && res.violations.size()>0){
                    system.debug('response validaion error'+res.violations[0].reason);
					resMap.put('serviceError',res.violations[0].reason);
                }
            }
        }catch(Exception e){
            system.debug('My Followups getMyFollowupsWorkloadList Exception ::' + e.getMessage());
        }
        return resMap;
    }
}