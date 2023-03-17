public class ACET_CaseServiceRequestInfoCtrl {
    
    public class SearchInput {
        public String searchType;
        public String officeId;
        public String agentId;
        public String caseNumber;
    }
    
    @AuraEnabled
    public static List<ServiceRequestInfoWrapper> getORSIssueRecords(String caseRecordId) {
        List<ServiceRequestInfoWrapper> infoList = new List<ServiceRequestInfoWrapper>();
        String requestBody = null;
        String responseBody = null;
        Case caseRecord = [SELECT Id,CaseNumber,CreatedById,Status,ORS_Issue_ID__c,Facets_Issue_ID__c,MACESSPIQ__c FROM Case WHERE Id = :caseRecordId];
        if(string.isNotBlank(caseRecord.Facets_Issue_ID__c)){
            system.debug('==Facets_Issue_ID__c='+caseRecord.Facets_Issue_ID__c);
            //US3068299 - Sravan - Start
            infoList = getFacetsRecords(caseRecord.Facets_Issue_ID__c);
            infoList.addAll(getMacess(caseRecord.MACESSPIQ__c,caseRecord.Id,caseRecord.CreatedById));
            if(string.isBlank(caseRecord.ORS_Issue_ID__c)){
                return infoList;
            }
            //US3068299 - Sravan - End
        }
        String issueId = caseRecord.CaseNumber;
        String topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');//673/JR2
        List<String> searchInputParams = new List<String>();
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
        if(String.isNotBlank(issueId)) {
            SearchInput searchInput = new SearchInput();
            searchInput.searchType = 'CASE_NBR';
            if(!searchInputParams.isempty()) {
                searchInput.officeId = searchInputParams[0];
                searchInput.agentId = searchInputParams[1];
            }
            searchInput.caseNumber = issueId;//'1456'
            requestBody = JSON.serialize(searchInput);
            requestBody = '{"searchInput":' + requestBody + '}';

            // US2101464 - Thanish - 19th Jun 2020 - Error code handling ...
            HttpResponse response = (HttpResponse)ACET_ORSWebservice.getORSSearchServiceResponse(requestBody);
            Integer statusCode = response.getStatusCode();
            responseBody = response.getBody();

            if(statusCode == 200) {
            ServiceRequestInfoWrapper info = new ServiceRequestInfoWrapper();
            ACET_ORSSelectIssues infoWrapper = ACET_ORSSelectIssues.parse(responseBody);
            //Boolean staset = false;
            for(ACET_ORSSelectIssues.IssuesList issueInfo : infoWrapper.SearchResult.searchOutput.issuesList) {
                info = new ServiceRequestInfoWrapper();
                info.infoId = issueInfo.issueId;
                info.idType = 'ORS';
                info.routeTo = issueInfo.ownerOfficeId + ' ' + issueInfo.OwnerDepartmentCode ;
                info.issueStatus = issueInfo.statusCode;
                
                //info.issueStatus = '';
                /*if(infoWrapper.SearchResult.searchOutput.issuesList.size()>1){
                    if(!staset)
                      info.issueStatus = 'C';
                    else
                      info.issueStatus = 'O';
                    staset = true;
                }
                else if(caseRecord.Status == 'Closed'){
                    info.issueStatus = 'C';
                } else if(caseRecord.Status == 'Open'){
                    info.issueStatus = 'O';
                }else{
                    info.issueStatus = issueInfo.status;
                }*/
                info.createdBy = issueInfo.associateName.firstName+' '+issueInfo.associateName.lastName;
                infoList.add(info);
            }
            } else {
                ServiceRequestInfoWrapper info = new ServiceRequestInfoWrapper();
                info.reponseStatus = statusCode;
                if(statusCode == 400) {
                    info.reponseStatusMessage = 'Unexpected error occured. Please try again. If problem persists, contact help desk.';
                } else if(statusCode == 404) {
                    info.reponseStatusMessage = 'No Results Found';
                } else if(statusCode == 500) {
                    info.reponseStatusMessage = 'Unexpected error occured. Please try again. If problem persists, contact help desk.';
                } else {
                    info.reponseStatusMessage = 'Unexpected error occured. Please try again. If problem persists, contact help desk.';
                }
                infoList.add(info);
            }
        }
        return infoList;
    }

    // Frontend Wrapper here
    public class ServiceRequestInfoWrapper {
      @AuraEnabled public String infoId;
      @AuraEnabled public String idType;
      @AuraEnabled public String routeTo;
      @AuraEnabled public String issueStatus;
      @AuraEnabled public String createdBy;
      @AuraEnabled public Integer reponseStatus; // US2101464 - Thanish - 19th Jun 2020 - Error code handling ...
      @AuraEnabled public String reponseStatusMessage; // US2101464 - Thanish - 19th Jun 2020 - Error code handling ...
      @AuraEnabled public String facetResponse;
      @AuraEnabled public String strCaseId;

      public ServiceRequestInfoWrapper() {
        // US2101464 - Thanish - 19th Jun 2020 - Error code handling ...
        this.routeTo = '--'; this.issueStatus = '--'; this.reponseStatus = 200;
        this.infoId = '--'; this.idType = '--'; this.createdBy = '--'; this.reponseStatusMessage = 'Success'; this.facetResponse= ''; this.strCaseId = '';
      }
    }

    public static List<ServiceRequestInfoWrapper> getFacetsRecords(String facetInquiryId){
        List<ServiceRequestInfoWrapper> infoList = new List<ServiceRequestInfoWrapper>();

        if(String.isNotBlank(facetInquiryId)){
            List<String>  InquiryList = new List<String>();
            InquiryList = facetInquiryId.split(',');
            if(InquiryList != null && !InquiryList.isEmpty()){
                for(String inquiryId : InquiryList){
        ACET_FacetsWebservice.getFacetsResponse responseStr = (ACET_FacetsWebservice.getFacetsResponse)ACET_FacetsWebservice.fetchFacetsCases('','',inquiryId,1);
        system.debug('=== response tr is '+responseStr);
        Integer statusCode = responseStr.responseStatus;
        system.debug('==responseStr.responseStatus='+responseStr.responseStatus);
        if(statusCode== 200){
            ServiceRequestInfoWrapper info = new ServiceRequestInfoWrapper();
            ACET_FacetsGetCasesResponse casesFacetsResponse = responseStr.casesFacetsResponse;
            system.debug('=casesFacetsResponse='+casesFacetsResponse);
            if(casesFacetsResponse.data != null){
                string strPrimaryUserIdfromService = '';
                string strIssueStatus = '';
                string strUserName = '--';
                for(ACET_FacetsGetCasesResponse.Data dr : casesFacetsResponse.data){
                    if(dr.attributes != null && dr.attributes.tasks != null){
                        for(ACET_FacetsGetCasesResponse.Tasks tr: dr.attributes.tasks){
                            strPrimaryUserIdfromService = string.isNotBlank(tr.primaryUserId) ? tr.primaryUserId : '';
                            strIssueStatus = string.isNotBlank(string.valueof(tr.statusReasonCode)) && string.isNotBlank(tr.statusReasonCode.desc_Z) ? tr.statusReasonCode.desc_Z : '--';
                        }
                    }
                }
                if(string.isNotBlank(strPrimaryUserIdfromService)){
                    List<User> lstUsers = new List<User>();
                    lstUsers = [Select id,FederationIdentifier,FirstName,LastName from User Where FederationIdentifier=:strPrimaryUserIdfromService.trim()];
                    if(!lstUsers.isEmpty()){
                        strUserName = (lstUsers[0].FirstName != null ? lstUsers[0].FirstName : '') + ' ' +(lstUsers[0].LastName != null ? lstUsers[0].LastName : '--');
                    }

                }
                for(ACET_FacetsGetCasesResponse.Data dr : casesFacetsResponse.data){
                    info.infoId = dr.id;
                    info.idType = 'FACETS';
                    info.routeTo = '--' ;
                    if(strIssueStatus == 'Completed Route'){
                        info.issueStatus = 'Closed';
                    }
                    else{
                    info.issueStatus = strIssueStatus;
                    }
                    info.createdBy = strUserName;
                    info.facetResponse = JSON.serialize(casesFacetsResponse); //casesFacetsResponse;
                    infoList.add(info);
      }
    }

        }
        else{
            ServiceRequestInfoWrapper info = new ServiceRequestInfoWrapper();
            info.reponseStatus = statusCode;

            info.reponseStatusMessage =responseStr.responseStatusMessage;
            infoList.add(info);
        }
                }
            }
        }
        return infoList;
}

//US3182873 - Sravan
public static List<ServiceRequestInfoWrapper> getMacess(String maccesPiq,String caseId,Id createdById){
    List<ServiceRequestInfoWrapper> ServiceRequestInfoWrapperList = new List<ServiceRequestInfoWrapper>();
    String userName = '';
    String federationIdentifier = '';
    if(maccesPiq != null && String.isNotBlank(maccesPiq)){
        List<String> piqAndMacessList = new List<String>();
        piqAndMacessList = maccesPiq.split(',');
        if(piqAndMacessList != null && !piqAndMacessList.isEmpty()){
            if(createdById != null){
                List<User> lstUsers = new List<User>();
                    lstUsers = [Select id,FederationIdentifier,FirstName,LastName from User Where Id=:createdById];
                	system.debug('lstUsers--'+lstUsers);
                    if(lstUsers != null && !lstUsers.isEmpty()){
                        federationIdentifier  = lstUsers[0].FederationIdentifier;
                        if(String.isNotBlank(federationIdentifier)){
                            List<User> finalUsers = new List<User>();
                            finalUsers = [Select id,FederationIdentifier,FirstName,LastName from User Where FederationIdentifier =: federationIdentifier];
                            if(finalUsers != null && !finalUsers.isEmpty()){
                                userName = (finalUsers[0].FirstName != null ? finalUsers[0].FirstName : '') + ' ' +(finalUsers[0].LastName != null ? finalUsers[0].LastName : '--');
                            }
                        }
                    }
            }
            for(String piqAndMacess : piqAndMacessList){
                String piqNum = piqAndMacess.substringBefore('--');
                String maccessNum = piqAndMacess.substringAfter('--');
                if(piqNum != null && String.isNotBlank(piqNum)){
                    ServiceRequestInfoWrapper infoWrapper = new ServiceRequestInfoWrapper();
                    if(maccessNum == null || String.isBlank(maccessNum)){
                        Map<String,String> requestParamMap = new Map<String,String>();
                        requestParamMap.put('searchType','T');
                        requestParamMap.put('searchValue',piqNum);
                        //Call the macces get api
                        ACET_SAECalloutResult result = ACET_MACESSWebService.searchMACESSCase(requestParamMap,caseId);
                        system.debug('Get Macess Api Response'+ result);
                        if(result != null){

                            if(result.statusCode == 200){
                                String maccesId = JSON.serialize(result.Response);
                                infoWrapper.infoId = maccesId.remove('"');
                                infoWrapper.idType = 'MACESS';
                                infoWrapper.routeTo = 'MACESS' ;
                                infoWrapper.issueStatus = 'Open';
                                infoWrapper.createdBy = userName;
                                ServiceRequestInfoWrapperList.add(infoWrapper);

                            }
                            else{
                                infoWrapper.infoId =piqNum;
                                infoWrapper.idType = 'MACESS';
                                infoWrapper.routeTo = 'MACESS' ;
                                infoWrapper.issueStatus = 'Open';
                                infoWrapper.createdBy = userName;
                                ServiceRequestInfoWrapperList.add(infoWrapper);
                            }

                        }
                    }
                    else{
                        infoWrapper.infoId = maccessNum;
                        infoWrapper.idType = 'MACESS';
                        infoWrapper.routeTo = 'MACESS' ;
                        infoWrapper.issueStatus = 'Open';
                        infoWrapper.createdBy = userName;
                        ServiceRequestInfoWrapperList.add(infoWrapper);
                    }

                }

            }
        }
    }
    return ServiceRequestInfoWrapperList;


}

}