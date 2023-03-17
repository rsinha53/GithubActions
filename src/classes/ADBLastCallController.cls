public without sharing class ADBLastCallController {

    @AuraEnabled
    public static List<String> getSelectIssues(String memberId, String officeId, String logonId){
        ADBSelectIssuesResponseWrapper responseWrapper = new ADBSelectIssuesResponseWrapper();
        ADBSelectIssuesRequestWrapper requestWrapper = new ADBSelectIssuesRequestWrapper();
        List<String> responseList= new List<String>();
        try{
            // Creating request body to pass to the service
            requestWrapper.searchInput  = new ADBSelectIssuesRequestWrapper.SearchInput();
            requestWrapper.searchInput.searchType = 'SUBSCRIBER_ID';
            requestWrapper.searchInput.subscriberId = memberId;
            if(officeId != null){
                requestWrapper.searchInput.officeId = officeId;
                system.debug('ADBCallerProfileController OfficeId ::: '+ officeId);
            }
            if(logonId != null){
                requestWrapper.searchInput.agentId = logonId;
                system.debug('ADBCallerProfileController LogonId ::: '+ logonId);
            }
            String serializedBody = JSON.serialize(requestWrapper);
            system.debug('@@@Request'+serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ORSSelectIssue',serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            // Checking the status code is success
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    System.debug('@@@Response 1'+response.getBody());
                    // Deserializing the response to response Wrapper
                    responseWrapper = (ADBSelectIssuesResponseWrapper) JSON.deserialize(response.getBody(), ADBSelectIssuesResponseWrapper.class);
                    System.debug('@@@Wrapper after deserialization : ' + responseWrapper);
                }
                if((responseWrapper!= null) && (responseWrapper.SearchResult != null) && (responseWrapper.SearchResult.SearchOutput != null) && (responseWrapper.SearchResult.SearchOutput.IssuesList != null)){
                    if(responseWrapper.SearchResult.SearchOutput.IssuesList[0].originatedDate != null){
                        String ExtractedDate = responseWrapper.SearchResult.SearchOutput.IssuesList[0].originatedDate;
                        if(String.isNotBlank(ExtractedDate)){
                            list<String> lstSplitDate = ExtractedDate.split('-');
                            String lastCallDate = lstSplitDate[1]+'/'+lstSplitDate[2]+'/'+lstSplitDate[0];
                            responseList.add(lastCallDate);
                            system.debug('@@@Date'+responseList);
                        }else{
                            responseList.add('');
                        }
                        system.debug('ADBCallerProfileController LastCall Date ::: '+ responseWrapper.SearchResult.SearchOutput.IssuesList[0].originatedDate);
                    }else{
                        responseList.add('');
                    }
                    if(responseWrapper.SearchResult.SearchOutput.IssuesList[0].contactReasonDescription != null){
                        responseList.add(responseWrapper.SearchResult.SearchOutput.IssuesList[0].contactReasonDescription);
                    }else{
                        responseList.add('');
                    }
                    if(responseWrapper.SearchResult.SearchOutput.IssuesList[0].issueId != null){
                        responseList.add(responseWrapper.SearchResult.SearchOutput.IssuesList[0].issueId);
                    }
                    system.debug('@@@All attr'+responseList);
                }
            }else{
                system.debug('CallerProfileController.getSelectIssue Error ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('CallerProfileController.getSelectIssue Exception ::' + e.getMessage());
        }
        return responseList;
    }
    
    @AuraEnabled
    public static String getReadIssueDetails(String memberId, String issueId, String officeId, String logonId){
        ADBReadIssueDetailsResponseWrapper responseWrapper = new ADBReadIssueDetailsResponseWrapper();
        ADBReadIssueDetailsRequestWrapper readIssueRequest = new ADBReadIssueDetailsRequestWrapper();
        String lstCallCategrory;
        try{
            // Creating request body to pass to the service
            readIssueRequest.ControlModifiers  = new ADBReadIssueDetailsRequestWrapper.controlModifiers();
            readIssueRequest.ControlModifiers.OrsSystemParameters = new ADBReadIssueDetailsRequestWrapper.orsSystemParameters();
            readIssueRequest.issueId =  issueId;
            if(officeId != null){
                readIssueRequest.controlModifiers.orsSystemParameters.logonOffice = officeId;
            }
            if(logonId != null){
                readIssueRequest.controlModifiers.orsSystemParameters.logonId = logonId;
            }
            String serializedBody = JSON.serialize(readIssueRequest);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ORSReadIssueMicroService',serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            //Checking the status code is success
            if(response.getStatusCode() == 200){
                // Deserializing the response to response Wrapper
                responseWrapper = (ADBReadIssueDetailsResponseWrapper) JSON.deserialize(response.getBody(), ADBReadIssueDetailsResponseWrapper.class);
                if(responseWrapper.issue.reasonCategory != null){
                    lstCallCategrory = responseWrapper.issue.reasonCategory;
                }
            }else{
                system.debug('CallerProfileController.getReadIssueDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('CallerProfileController.getReadIssueDetails Exception ::' + e.getMessage());
        }
        if(!Test.isRunningTest()){
            ADBField_Mapping__mdt callCategrory = [SELECT Value__c FROM ADBField_Mapping__mdt WHERE key__c =: lstCallCategrory];
            String reasonCategory = callCategrory.value__c;
            if(reasonCategory != null){
                return reasonCategory;
            }else{
                return lstCallCategrory;
            }
        }else{
            return lstCallCategrory;
        }
    }
    

}