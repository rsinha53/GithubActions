/**
 * @description       : US3511613
 * @author            : Raviteja
 * @group             : Team Blinkers
 * @last modified on  : 05-26-2021
 * @last modified by  : Raviteja
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   05-20-2021   Raviteja       Initial Version
**/
public with sharing class ACET_ExternalIdSearchController {
   
    /**
    * @description US3511613
    * @author Raviteja | 05-20-2021 
    * @param searchtype 
    * @param searchvalue 
    * @param fromdate 
    * @param todate 
    * @param officeId 
    * @param associateId 
    * @return list<externalIdResults> 
    **/
    @AuraEnabled
    public static list<externalIdResults> fetchexternalIdData(String searchtype, String searchvalue, date fromdate, date todate, String officeId, String associateId){
        list<externalIdResults> externalIdResultsList = new list<externalIdResults>();
        try{
            Map<String, Object> reqPramsMap = new Map<String, Object>();
            String topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');//673/JR2
            List<String> searchInputParams = new List<String>();
            String requestBody;
            String responseBody;
            Integer statusCode;
            if(!String.isBlank(topsUserId)) {
                searchInputParams = topsUserId.split('/');
            }else {
                ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                loginflow.validateTopsCredentials();
                topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');
                if(!String.isBlank(topsUserId)) {
                    searchInputParams = topsUserId.split('/');
                }
            }

            if(!searchInputParams.isempty()) {
                reqPramsMap.put('officeId',searchInputParams[0]);
                reqPramsMap.put('agentId',searchInputParams[1]);
            }
            reqPramsMap.put('searchType',searchtype);
            if(searchtype=='ALTERNATE_ID'){
                reqPramsMap.put('alternateId',searchvalue);
            }else if(searchtype=='PROVIDER_TAX_ID'){
                reqPramsMap.put('providerTaxId',searchvalue);
            } else if (searchtype == 'CLAIM_ID') {
                if(searchvalue.length() > 10){
                    searchvalue = searchvalue.left(10);
                }
                Map < String, String > claimmap = new Map < String, String > ();
                claimmap.put('claimId', searchvalue);
                list < object > objlist = new list < object > ();
                objlist.add(claimmap);
                reqPramsMap.put('claims', objlist);
            }
            // US3520457: External ID search (Provider Snapshot) - Search by Advocate - Krish - 22th June 2021
            else if (searchtype == 'ASSOCIATE_ID') {
                String associateIdTemp = !String.isEmpty(associateId.split(' ')[0]) ? associateId.split(' ')[0] : '';
                String associateOfficeidTemp = !String.isEmpty(officeId.split(' ')[0]) ? officeId.split(' ')[0] : '';
                reqPramsMap.put('associateId', associateIdTemp); 
                reqPramsMap.put('associateOfficeId', associateOfficeidTemp);
            }

            if(fromdate!=NULL){
                String fromdatestring = String.valueof(fromdate.year()) + '-' + String.valueof(fromdate.month()) + '-' + String.valueof(fromdate.day());
                reqPramsMap.put('fromDateOfService',fromdatestring);
            }
            if(todate!=NULL){
                String todatestring = String.valueof(todate.year()) + '-' + String.valueof(todate.month()) + '-' + String.valueof(todate.day());
                reqPramsMap.put('toDateOfService',todatestring);
            }
            requestBody = JSON.serialize(reqPramsMap);
            requestBody = requestBody.replaceall('\\\\','');
            requestBody = '{"searchInput":' + requestBody + '}';
            System.debug('@@@ ACET_ExternalIdSearchController: fetchexternalIdData(): requestBody: '+requestBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'ORSSelectIssue';
            wsCallOutFW.requestBody = requestBody;
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            statusCode = httpResponse.getStatusCode();
            responseBody = httpResponse.getBody();
            if(statusCode == 200){
                if(string.isNotBlank(responseBody)){
                    Map<String, Object> orsMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
                    Map<String, Object> orsRespMap = (Map<String, Object>)orsMainMap.get('searchResult');    
                    Map<String,Object> orsSearchOutput = (Map<String, Object>)orsRespMap.get('searchOutput');
                    List<Object> orsIssuesList = (List<Object>)orsSearchOutput.get('issuesList');

                    for(Object obj : orsIssuesList){
                        Map<String, Object> mapobj = (Map<String, Object>)obj;
                        externalIdResults ss = new externalIdResults();
                        ss.ID = (String)mapobj.get('issueId');
                        String originType = (String)mapobj.get('originatorTypeDescription');
                        originType = originType.toLowerCase();
                        ss.OriginatorType = originType.capitalize();
                        string orgDate = (String)mapobj.get('originatedDate');
                        String orgTime = (String)mapobj.get('originatedTime');
                        List<String> orgTimeList = orgTime.split(':');
                        Date orgDt = date.valueOf(orgDate);
                        DateTime myDateTime = DateTime.newInstance(orgDt.year(),
                                                                   orgDt.month(),
                                                                   orgDt.day(),
                                                                   integer.valueOf(orgTimeList[0]),
                                                                   integer.valueOf(orgTimeList[1]),
                                                                   integer.valueOf(orgTimeList[2]));
                        String convertedOrgDateTime = myDateTime.format('MM/dd/yyyy hh:mm a');
                        
                        ss.CreatedDate = convertedOrgDateTime;
                        if(String.isNotBlank(ss.ID)){
                            if(0 == ss.ID.indexOf('D')){
                                ss.IDType = 'ORS';
                            }else{
                                ss.IDType = '';
                            }
                        }
                        ss.TopicReason = (String)mapobj.get('contactReasonDescription'); 
                        Map<String, Object> memberInfo = ( Map<String, Object>)mapobj.get('memberInfo');
                        Map<String, Object> dependetName = ( Map<String, Object>)memberInfo.get('dependentName');
    
                        String mem_fistName = (String) dependetName.get('firstName');
                        String mem_lastName = (String) dependetName.get('lastName');

                        if(String.isNotBlank(mem_fistName) || (String.isNotBlank(mem_lastName))){
                           String SubjectName = String.isNotBlank(mem_fistName) ? mem_fistName +' '+ (String.isNotBlank(mem_lastName) ? mem_lastName : '') : '--';     
                           ss.Subject = SubjectName;               
                        }
                        String mem_id = (String) memberInfo.get('memberNumber');
                        ss.memberId = mem_id;
                        Map<String, Object> originatorInfo = ( Map<String, Object>)mapobj.get('originatorInfo');
                        String taxId = (String) originatorInfo.get('originatorTIN');
                        ss.taxId = taxId;
                        ss.error = false;
                        externalIdResultsList.add(ss);
                    }
                }
                return externalIdResultsList;
            }else{
                externalIdResults results = new externalIdResults();
                results.error = true;
                if(httpResponse.getStatus()=='404'){
                    results.errormsg='Update your search criteria and try your search again.';
                    results.errortype='info';
                }else{
                   results.errormsg = 'Unexpected Error Occurred on the External ID Results. Please try again. If problem persists please contact the help desk.';
                   results.errortype='error';
                }
                externalIdResultsList.add(results);
                return externalIdResultsList;
            }
        }catch(Exception e){
            externalIdResults results = new externalIdResults();
            results.error = true;
            results.errormsg = 'Unexpected Error Occurred on the External ID Results. Please try again. If problem persists please contact the help desk.';
            results.errortype='error';
            externalIdResultsList.add(results);
            return externalIdResultsList;
        }
    }

    /**
    * @description US3511613
    * @author Raviteja | 05-20-2021 
    * @param searchtype 
    * @param searchvalue 
    * @return list<externalIdResults> 
    **/
    @AuraEnabled
    public static list<externalIdResults> fetchexternalIdDatabyORS(String searchtype, String searchvalue){
        list<externalIdResults> externalIdResultsList = new list<externalIdResults>();
        try{    
            String topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');//673/JR2
            List<String> searchInputParams = new List<String>();
            String requestBody;
            String responseBody;
            Integer statusCode;
            if(!String.isBlank(topsUserId)) {
                searchInputParams = topsUserId.split('/');
            }else {
                ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                loginflow.validateTopsCredentials();
                topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');
                if(!String.isBlank(topsUserId)) {
                    searchInputParams = topsUserId.split('/');
                }
            }

            if(!searchInputParams.isempty()) {
                requestBody = ACET_ServiceRequestDetailCtrl.getRequestBody(searchInputParams[1], searchInputParams[0], searchvalue);
            }
                    
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'ORSReadIssueMicroService';
            wsCallOutFW.requestBody = requestBody;
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            statusCode = httpResponse.getStatusCode();
            responseBody = httpResponse.getBody();
            if(statusCode == 200){
                if(string.isNotBlank(responseBody)){  
                    ACET_ORSReadIssueWrapper issueDetails = ACET_ORSReadIssueWrapper.parse(responseBody);
                    externalIdResults results = new externalIdResults();
                    results.OriginatorType = issueDetails.issue.originatorTypeDescription;
                    results.ID = issueDetails.issue.issueId;
                    results.TopicReason = issueDetails.issue.contactReasonDescription;
                    if(issueDetails.issue.originatedDate != null && string.isNotBlank(issueDetails.issue.originatedDate)){
                        results.CreatedDate = issueDetails.issue.originatedDate.split('-')[1] + '/' +issueDetails.issue.originatedDate.split('-')[2] + '/' + issueDetails.issue.originatedDate.split('-')[0];
                    }
                    if(String.isNotBlank(results.ID)){
                        if(0 == results.ID.indexOf('D')){
                            results.IDType = 'ORS';
                        }else{
                            results.IDType = '';
                        }
                    }

                    if(String.isNotBlank(issueDetails.issue.member.DependentName.firstName) || (String.isNotBlank(issueDetails.issue.member.DependentName.lastName))){
                        String SubjectName = String.isNotBlank(issueDetails.issue.member.DependentName.firstName) ? issueDetails.issue.member.DependentName.firstName +' '+ (String.isNotBlank(issueDetails.issue.member.DependentName.lastName) ? issueDetails.issue.member.DependentName.lastName : '') : '--';
                        results.Subject = SubjectName;
                    }              
                    results.memberId = issueDetails.issue.member.memberNumber;
                    results.taxId = issueDetails.issue.originator.originatorTin;
                    results.error = false;
                    externalIdResultsList.add(results);
                    return externalIdResultsList;
                }
            }else{
                externalIdResults results = new externalIdResults();
                results.error = true;
                if(httpResponse.getStatus()=='404'){
                    results.errormsg='Update your search criteria and try your search again.';
                    results.errortype='info';
                }else{
                   results.errormsg = 'Unexpected Error Occurred on the External ID Results. Please try again. If problem persists please contact the help desk.';
                   results.errortype='error';
                }
                externalIdResultsList.add(results);
                return externalIdResultsList;
            }
        }catch(Exception e){
            externalIdResults results = new externalIdResults();
            results.error = true;
            results.errormsg = 'Unexpected Error Occurred on the External ID Results. Please try again. If problem persists please contact the help desk.';
            results.errortype='error';
            externalIdResultsList.add(results);
            return externalIdResultsList;
        }
        return null;
    }

    @AuraEnabled
    public static list<String> getOfficeOptions(){
        List<ACET_External__mdt> officeRecords = [SELECT Id, MasterLabel, Office__c from ACET_External__mdt ];
        List<String> officeOptions = new List<String>();
        for(ACET_External__mdt row : officeRecords){
            if(!officeOptions.contains(row.Office__c )){
                officeOptions.add(row.Office__c);
            }
        }
        return officeOptions;
    }
    @AuraEnabled
    public static list<String> getDepartmentOptions(String office){
        List<ACET_External__mdt> officeRecords = [SELECT Id, MasterLabel, Office__c, Department__c, Team__c from ACET_External__mdt where Office__c =:office];
        List<String> departmentOptions = new List<String>();
        for(ACET_External__mdt row : officeRecords){
            if(!departmentOptions.contains(row.Department__c )){
                departmentOptions.add(row.Department__c);
            }
        }
        return departmentOptions;
    }

    @AuraEnabled
    public static list<String> getTeamOptions(String office, String department){
        List<ACET_External__mdt> officeRecords = [SELECT Id, MasterLabel, Office__c, Department__c, Team__c from ACET_External__mdt where Office__c =:office AND Department__c =: department];
        List<String> teamOptions = new List<String>();
        for(ACET_External__mdt row : officeRecords){
            if(!teamOptions.contains(row.Team__c )){
                teamOptions.add(row.Team__c);
            }
        }
        return teamOptions;
    }
    @AuraEnabled
    public static List<ACET_SelectAssociateWS.SelectAssociateOutput> getAssociateOptions(String office, String department, String team){
        System.debug('@@@ ACET_ExternalIdSearchController.getAssociateOptions(): office: '+office+' department: '+department+ ' team: '+team);
        ACET_SelectAssociateWS selectAssociate = new ACET_SelectAssociateWS();
        ACET_SelectAssociateWS.SelectAssociateInput input = new ACET_SelectAssociateWS.SelectAssociateInput();
        input.officeId = !String.isEmpty(office) && !String.isEmpty(office.split(' ')[0]) ? office.split(' ')[0] : '' ;
        input.departmentCode = !String.isEmpty(department) && !String.isEmpty(department.split(' ')[0]) ? department.split(' ')[0] : '';
        input.teamCode = !String.isEmpty(team) && !String.isEmpty(team.split(' ')[0]) ? team.split(' ')[0] : '';
        List<ACET_SelectAssociateWS.SelectAssociateOutput> teamOptions = ACET_SelectAssociateWS.callSelectAssociate(input);
        System.debug('@@@ ACET_ExternalIdSearchController.getAssociateOptions(): teamOptions.length: '+teamOptions.size());
        return teamOptions;
    }
    

    public class externalIdResults{
        @AuraEnabled public string OriginatorType {get;set;}
        @AuraEnabled public string CreatedDate{get;set;}
        @AuraEnabled public string Subject{get;set;}
        @AuraEnabled public string ID{get;set;}
        @AuraEnabled public string IDType{get;set;}
        @AuraEnabled public string TopicReason{get;set;}
        @AuraEnabled public string taxId{get;set;}
        @AuraEnabled public string memberId{get;set;}
        @AuraEnabled public boolean error{get;set;}
        @AuraEnabled public String errormsg{get;set;}
        @AuraEnabled public String errortype{get;set;}
    }

}