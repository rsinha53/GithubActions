public without sharing class ADBFollowUpsController {
    
    @AuraEnabled
    public static ADBCommitmentsUIWrapper fetchCommitmentsDetails(String xrefId){
        ADBCommitmentsUIWrapper responseWrapper = ADBCommitmentsService.callCommitmentsService(xrefId);
        system.debug('Commitments Response Wrapper:'+responseWrapper);
        return responseWrapper;
    }
    @AuraEnabled
    public static ADBORSCommitmentsUIWrapper getFollowUps(String memberId, String officeId, String logonId){
        ADBSelectIssuesResponseWrapper responseWrapper = new ADBSelectIssuesResponseWrapper();
        ADBSelectIssuesRequestWrapper requestWrapper = new ADBSelectIssuesRequestWrapper();
        List<ADBFollowUpHistoryResponseWrapper.FollowUpHistory> followupsList = new List<ADBFollowUpHistoryResponseWrapper.FollowUpHistory>();
        ADBORSCommitmentsUIWrapper wrapper = new ADBORSCommitmentsUIWrapper();
        wrapper.tweleveMonthDataAvailable = false;
        List<ADBORSCommitmentsWrapper> oppyList = new List<ADBORSCommitmentsWrapper>();
        List<ADBORSCommitmentsWrapper> overTwelveMonthData = new List<ADBORSCommitmentsWrapper>();
        try{
            // Creating request body to pass to the service
            requestWrapper.searchInput  = new ADBSelectIssuesRequestWrapper.SearchInput();
            requestWrapper.searchInput.searchType = 'SUBSCRIBER_ID';
            requestWrapper.searchInput.subscriberId = memberId;
            if(officeId != null){
                requestWrapper.searchInput.officeId = officeId;
                system.debug('ADBFollowUpsController OfficeId ::: '+ officeId);
            }
            if(logonId != null){
                requestWrapper.searchInput.agentId = logonId;
                system.debug('ADBFollowUpsControlle LogonId ::: '+ logonId);
            }
            
            String serializedBody = JSON.serialize(requestWrapper);
            system.debug('@@@Request'+serializedBody);
            // Actual service call to get the SelectIssue service response
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ORSSelectIssue',serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400) {
                System.debug('@@@Response'+response);
                if(response.getBody() != null){
                    System.debug('@@@Response 1'+response.getBody());
                    // Deserializing the response to response Wrapper
                    responseWrapper = (ADBSelectIssuesResponseWrapper) JSON.deserialize(response.getBody(), ADBSelectIssuesResponseWrapper.class);
                    System.debug('@@@Wrapper after deserialization : ' + responseWrapper);
                }
                if((responseWrapper!= null) && (responseWrapper.SearchResult != null) && (responseWrapper.SearchResult.SearchOutput != null) && (responseWrapper.SearchResult.SearchOutput.IssuesList != null)){
                    List<String> openIssues = new List<String>();
                    for(ADBSelectIssuesResponseWrapper.IssuesList issue:responseWrapper.SearchResult.SearchOutput.IssuesList){
                        if(issue.status.toLowerCase() == 'open' || issue.status.toLowerCase() == 'hold'){
                            openIssues.add(issue.issueId);
                        }
                    }
                    if(openIssues.size() >0){
                        for(String issueid:openIssues){
                            List<ADBFollowUpHistoryResponseWrapper.FollowUpHistory> tempFollowupsList = new List<ADBFollowUpHistoryResponseWrapper.FollowUpHistory>();
                            tempFollowupsList = getReadFollowupDetailsByIssueId(issueid, officeId, logonId);
                            system.debug('followups size for issue id'+issueid+'='+tempFollowupsList.size());
                            followupsList.addall(tempFollowupsList);
                        }
                        if(followupsList.size()>0){
                            for(ADBFollowUpHistoryResponseWrapper.FollowUpHistory followup:followupsList){
                                ADBORSCommitmentsWrapper.Commitment op = new ADBORSCommitmentsWrapper.Commitment();
                                op.commitment = followup.purposeDescription;
                                Date apStrtDt = Date.valueOf(followup.updateDate);
                                String apStrt = apStrtDt.format();
                                Date apDt = Date.parse(apStrt);
                                op.create_Date = apDt;
                                op.isOverdue = checkDueDateIsPast(followup.nextActionDueDate);
                                op.due_Date = followup.nextActionDueDate;
                                ADBORSCommitmentsWrapper ac = new ADBORSCommitmentsWrapper(op);
                                //	12 month period logic
                                if(apDt.daysBetween(Date.today()) <= 365) {
                                    oppyList.add(ac);
                                }else{
                                    overTwelveMonthData.add(ac);
                                }
                                oppyList.sort();
                            }
                            wrapper.commitments = oppyList;
                            
                            if(oppyList.size()>0){
                                for(integer i=0;i<oppyList.size();i++){
                                    if(i>4)
                                        oppyList.remove(i);
                                }
                            }else if(!overTwelveMonthData.isEmpty()) {
                                wrapper.tweleveMonthDataAvailable = true;
                            }
                        }
                        system.debug('size of final followups'+oppyList.size());
                    }
                }else if(responseWrapper.title == 'Validation Error' && responseWrapper.violations.size()>0){
                    system.debug('response validaion error'+responseWrapper.violations[0].reason);
					wrapper.systemErrorMsg = responseWrapper.violations[0].reason;
                }
            }
        }catch(Exception e){
            system.debug('CallerProfileController.getSelectIssue Exception ::' + e.getMessage());
        }
        return wrapper;
    }
    
    @AuraEnabled
    public static List<ADBFollowUpHistoryResponseWrapper.FollowUpHistory> getReadFollowupDetailsByIssueId(String issueId, String officeId, String logonId){
        ADBFollowUpHistoryResponseWrapper responseWrapper = new ADBFollowUpHistoryResponseWrapper();
        ADBFollowUpHistoryRequestWrapper readIssueRequest = new ADBFollowUpHistoryRequestWrapper();
        List<ADBFollowUpHistoryResponseWrapper.FollowUpHistory> followups = new List<ADBFollowUpHistoryResponseWrapper.FollowUpHistory>();
        try{
            // Creating request body to pass to the service
            readIssueRequest.ControlModifiers  = new ADBFollowUpHistoryRequestWrapper.controlModifiers();
            readIssueRequest.ControlModifiers.OrsSystemParameters = new ADBFollowUpHistoryRequestWrapper.orsSystemParameters();
            readIssueRequest.issueId =  issueId;
            if(officeId != null){
                readIssueRequest.controlModifiers.orsSystemParameters.logonOffice = officeId;
            }
            if(logonId != null){
                readIssueRequest.controlModifiers.orsSystemParameters.logonId = logonId;
            }
            String serializedBody = JSON.serialize(readIssueRequest);
            system.debug('serializedBody'+serializedBody);
            // Actual service call to get the ReadIssue service response
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBReadFollowupDetails',serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            if(response.getStatusCode() == 200){
                // Deserializing the response to response Wrapper
                responseWrapper = (ADBFollowUpHistoryResponseWrapper) JSON.deserialize(response.getBody(), ADBFollowUpHistoryResponseWrapper.class);
                if(responseWrapper.followUpHistory != null){
                    for(ADBFollowUpHistoryResponseWrapper.FollowUpHistory followup:responseWrapper.followUpHistory){
                        if('o'.equalsIgnoreCase(followup.statusCode))
                            followups.add(followup);
                    }
                }
                return followups;
            }else{
                system.debug('ADBFollowUpsController.getReadFollowupDetailsByIssueId Error ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('ADBFollowUpsController.getReadFollowupDetailsByIssueId Exception ::' + e.getMessage());
        }
        return followups;
    }
    
    @AuraEnabled
    public static Boolean checkDueDateIsPast(String dueDate){
        Boolean isOverdue = false;
        Date apStrtDt = Date.valueOf(dueDate);
        String apStrt = apStrtDt.format();
        system.debug('due Date'+apStrt);
        Date apDt = Date.parse(apStrt);
        Date todayDate = system.today();
        system.debug('today date'+todayDate+'::apDt'+apDt);
        if(apStrt!=null && todayDate>apDt){
            isOverdue = true;
        }
        return isOverdue;
    }
}