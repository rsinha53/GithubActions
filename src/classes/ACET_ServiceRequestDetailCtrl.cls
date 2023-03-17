// US2041480 - Thanish - 26th Mar 2020
public class ACET_ServiceRequestDetailCtrl {
    
    public static Map < String, String > addedByMap = new Map < String, String > ();
    
    public class ServiceRequestsWrapper {
        public ACET_WebserviceCalloutFramework claimWsCallOutFW{get;set;}
        public ACET_WebserviceCalloutFramework claimActCallOutFW{get;set;}
        public List < selectIssueWrapper > infoWrapperList{get;set;}
        public String issueId{get;set;}
        public String taxId{get;set;}
    }

    //Nikhil - US1954760 - ORS/Link- Populate Related External ID Table Integration
    @AuraEnabled(continuation = true cacheable=true)
    public static Object getClaimIssues(String claimNumber, String taxId, String issueId) {
        // Create continuation with a timeout
        Continuation con = new Continuation(60);
        // Set callback method
        con.continuationMethod = 'processInitialResponse';

        try {
            //get selectIssues Requestbody
            String orsRequestBody = getSelectIssueBody(claimNumber);

            // Create first callout request
            ACET_WebserviceCalloutFramework orsWsCallOutFW = new ACET_WebserviceCalloutFramework();
            orsWsCallOutFW.serviceName = 'ORSSelectIssue';
            orsWsCallOutFW.requestBody = orsRequestBody;
            orsWsCallOutFW.encodeURLParameters = true;

            // Add initial callout request to continuation
            con.addHttpRequest(orsWsCallOutFW.getHttpRequest());

            // Create Second callout request
            Map < String, String > claimReqPramsMap = new Map < String, String > ();
            claimReqPramsMap.put('tin', taxId);
            claimReqPramsMap.put('payerId', '87726');
            claimReqPramsMap.put('claimNumber', claimNumber);

            ACET_WebserviceCalloutFramework claimWsCallOutFW = new ACET_WebserviceCalloutFramework();
            claimWsCallOutFW.serviceName = 'LinkClaimDetail';
            claimWsCallOutFW.requestParamsMap = claimReqPramsMap;
            claimWsCallOutFW.encodeURLParameters = true;
            // Add second callout request to continuation
            con.addHttpRequest(claimWsCallOutFW.getHttpRequest());
            
            ServiceRequestsWrapper reqWrapper = new ServiceRequestsWrapper();
            reqWrapper.issueId = issueId;
            reqWrapper.taxId = taxId;
            reqWrapper.claimWsCallOutFW = claimWsCallOutFW;
            // Set state
            con.state = reqWrapper;
        } catch (exception ex) {
            System.debug('Exception::' + ex.getStackTraceString());
        }
        return con;
    }

    // Callback method for initial request
    @AuraEnabled(continuation = true cacheable = true)
    public static Object processInitialResponse(List < String > labels, Object state) {
        ServiceRequestsWrapper reqWrapper = (ServiceRequestsWrapper) state;
        // Get the response by using the unique label
        HttpResponse orsResponse = Continuation.getResponse(labels[0]);
        if (orsResponse.getStatusCode() == 200) {
            reqWrapper.infoWrapperList = getORSRecords(orsResponse, reqWrapper.issueId);
        }
        HttpResponse claimDetailResponse = Continuation.getResponse(labels[1]);
        if(claimDetailResponse.getStatusCode() != 200) {
            claimDetailResponse = reqWrapper.claimWsCallOutFW.getResponse();
        }
        Continuation chainedContinuation = null;
        try {
            // Chain continuation if some condition is met
            if (claimDetailResponse.getStatusCode() == 200) {
                String claimDetailResponseBody = claimDetailResponse.getBody();
                System.debug('claimDetailResponseBody::' + claimDetailResponseBody);
                SAEEligibilityClaimDetailsJSON2Apex claimDetailResultWrapper = SAEEligibilityClaimDetailsJSON2Apex.parse(claimDetailResponseBody);

                // Create a second continuation 
                chainedContinuation = new Continuation(60);
                // Set callback method
                chainedContinuation.continuationMethod = 'processChainedResponse';

                // Create callout request
                Map < String, String > claimActPramsMap = new Map < String, String > ();
                claimActPramsMap.put('claimNumber', claimDetailResultWrapper.claimsDetailInfo[0].claimNumber);
                claimActPramsMap.put('payerId', claimDetailResultWrapper.claimsDetailInfo[0].electronicPayerID);
                claimActPramsMap.put('tin', reqWrapper.taxId);
                //claimActPramsMap.put('tin', claimDetailResultWrapper.claimsDetailInfo[0].providerTin);
                claimActPramsMap.put('transactionId', claimDetailResultWrapper.transactionId);

                ACET_WebserviceCalloutFramework claimActCallOutFW = new ACET_WebserviceCalloutFramework();
                claimActCallOutFW.serviceName = 'LinkClaimAction';
                claimActCallOutFW.requestParamsMap = claimActPramsMap;
                claimActCallOutFW.encodeURLParameters = true;

                // Add callout request to continuation
                chainedContinuation.addHttpRequest(claimActCallOutFW.getHttpRequest());
                reqWrapper.claimActCallOutFW = claimActCallOutFW;
                // Set state
                chainedContinuation.state = reqWrapper;
            } else {
                return reqWrapper.infoWrapperList;
            }
        } catch (Exception ex) {
            System.debug('Exception::' + ex.getStackTraceString());
        }
        // Start another continuation 
        return chainedContinuation;
    }

    // Callback method for chained request
    @AuraEnabled(continuation = true cacheable = true)
    public static Object processChainedResponse(List < String > labels, Object state) {
        ServiceRequestsWrapper reqWrapper = (ServiceRequestsWrapper) state;
        List < selectIssueWrapper > claimActList = reqWrapper.infoWrapperList;
        try {
            // Get the ClaimActionResponse for the chained request
            HttpResponse claimActionResponse = Continuation.getResponse(labels[0]);
            if(claimActionResponse.getStatusCode() != 200) {
                claimActionResponse = reqWrapper.claimActCallOutFW.getResponse();
            }

            if (claimActionResponse.getStatusCode() == 200) {
                String claimActResponseBody = claimActionResponse.getBody();
                System.debug('claimActResponseBody::' + claimActResponseBody);
                ACET_ClaimActionResultWrapper claimWrapper = ACET_ClaimActionResultWrapper.parse(claimActResponseBody);
                if (claimWrapper.actions != null) {
                    for (ACET_ClaimActionResultWrapper.Actions actionInfo: claimWrapper.actions) {
                        if (actionInfo.ticketInfo != null) {
                            for (ACET_ClaimActionResultWrapper.TicketInfo tcktInfo: actionInfo.ticketInfo) {
                                selectIssueWrapper info = new selectIssueWrapper();
                                info.DateCreated = tcktInfo.submissionDate;
                                info.isLink = false;
                                if (actionInfo.ticketType.equalsIgnoreCase('appeal') || actionInfo.ticketType.equalsIgnoreCase('pend')) {
                                    info.IdType = 'LINK-' + actionInfo.ticketType;
                                } else if (actionInfo.ticketType.equalsIgnoreCase('recon')) {
                                    info.IdType = 'LINK-Reconsideration';
                                    info.isLink = true;
                                } else {
                                    info.IdType = actionInfo.ticketType;
                                }
                                info.ExternalId = tcktInfo.ticketNumber;
                                claimActList.add(info);
                            }
                        }
                    }
                }
            } else {
                return reqWrapper.infoWrapperList;
            }
        } catch (Exception ex) {
            System.debug('exception::' + ex.getStackTraceString());
        }
        return claimActList;
    }

    /**
     * @description To populate ORS records for claim number
     * @author Nikhil Kanth | 04-26-2021 
     * @param orsResponse 
     * @param orsId 
     * @return List<selectIssueWrapper> 
     **/
    public static List < selectIssueWrapper > getORSRecords(HttpResponse orsResponse, String orsId) {
        List < selectIssueWrapper > orsList = new List < selectIssueWrapper > ();
        if (orsResponse.getStatusCode() == 200) {
            ACET_ORSSelectIssues infoWrapper = ACET_ORSSelectIssues.parse(orsResponse.getBody());
            System.debug('infoWrapper::' + infoWrapper);
            if((infoWrapper!=null) && (infoWrapper.SearchResult!=null) && (infoWrapper.SearchResult.searchOutput!=null)){
                for (ACET_ORSSelectIssues.IssuesList issueInfo: infoWrapper.SearchResult.searchOutput.issuesList) {
                    selectIssueWrapper info = new selectIssueWrapper();
                    info.DateCreated = SAEUtils.formatDate(issueInfo.originatedDate);
                    info.IdType = 'ORS';
                    info.ExternalId = issueInfo.issueId;
                        if (orsId!=null && orsId.equalsIgnoreCase(issueInfo.issueId)) {
                        info.isLink = false;
                    } else {
                        info.isLink = true;
                    }
                    orsList.add(info);
                }
            }
        }
        return orsList;
    }

    /**
     * @description forming request body for Select service
     * @author Nikhil Kanth | 04-26-2021 
     * @param claimNumber 
     * @return String 
     **/
    private static String getSelectIssueBody(String claimNumber) {
        //Fetching TOPS
        String topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId'); //673/NNK
        List < String > searchInputParams = new List < String > ();
        if (String.isNotBlank(topsUserId)) {
            searchInputParams = topsUserId.split('/');
        }

        //Forming Request Body
        String requestBody = '';
        SearchInput searchInput = new SearchInput();
        searchInput.searchType = 'CLAIM_ID';
        if (!searchInputParams.isempty()) {
            searchInput.officeId = searchInputParams[0];
            searchInput.agentId = searchInputParams[1];
        }
        Claims claim = new Claims();
        // US34244763 - Thanish - 11th May 2021
        if(claimNumber.length() > 10){
            claim.claimId = claimNumber.left(10);
        } else{
            claim.claimId = claimNumber;
        }
        List < Claims > claimsList = new List < Claims > ();
        claimsList.add(claim);
        searchInput.claims = claimsList;
        requestBody = JSON.serialize(searchInput);
        requestBody = '{"searchInput":' + requestBody + '}';
        return requestBody;
    }

    //Return response
    public class selectIssueWrapper {
        @AuraEnabled public String DateCreated;
        @AuraEnabled public String IdType;
        @AuraEnabled public String ExternalId;
        @AuraEnabled public Boolean isLink;
        @AuraEnabled public Integer reponseStatus;
        @AuraEnabled public String reponseStatusMessage;
        // US3177995 - Thanish - 22nd Jun 2021
        @AuraEnabled public String purgedORSID;
        @AuraEnabled public Boolean isEmptyPurgedORS;

        public selectIssueWrapper() {
            this.DateCreated = '--';
            this.IdType = '--';
            this.ExternalId = '--';
            this.isLink = false;
            this.reponseStatus = 200;
            this.reponseStatusMessage = 'Success';
        }
    }

    //Request body
    public class Claims {
        public String claimId;
    }

    public SearchInput searchInput;

    public class SearchInput {
        public String searchType;
        public String officeId;
        public List < Claims > claims;
        public String agentId;
    }

    @AuraEnabled
    public static ACET_ServiceRequestDetailWrapper getORSIssueDetails(String issueId, String strIdType, String caseId) {
        // US2667560 - ORS ReadIssue Error Handling - Sanka
        ACET_ServiceRequestDetailWrapper detailWrapper = new ACET_ServiceRequestDetailWrapper();
        try{
            String topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId'); //673/JR2
            List < String > searchInputParams = new List < String > ();
            //Paramters used for owner and userId filtering - Sravan - Start
            String ownerName = '';
            String userId = '';
            String ownerId = '';
            Map < String, ACET_ORSReadIssueWrapper.owners > ownerMap = new Map < String, ACET_ORSReadIssueWrapper.owners > ();
            Map < String, String > commentMap = new Map < String, String > ();
            Map < String, ACET_ORSReadIssueWrapper.detailComments > commentUserIdMap = new Map < String, ACET_ORSReadIssueWrapper.detailComments > ();
            //Paramters used for owner and userId filtering - Sravan - End
            
            if(string.isNotBlank(strIdType) && strIdType == 'FACETS'){
                return getFacetsDetails(issueId,caseId);
            }

            if (!String.isBlank(topsUserId)) {
                searchInputParams = topsUserId.split('/');
            } else {
                ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                loginflow.validateTopsCredentials();
                topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId');
                if (!String.isBlank(topsUserId)) {
                    searchInputParams = topsUserId.split('/');
                }
            }
            // searchInputParams size will be 0 for test classes
            String requestBody = '';
            if (searchInputParams.size() > 0) {
                //requestBody = '{"searchInput":{"controlModifiers":{"orsSystemParameters":{"logonId":"' + searchInputParams[1] + '","logonOffice":"' + searchInputParams[0] + '"}},"issueId":"' + issueId + '"}}';
                //US2887998
                 //requestBody = '{"controlModifiers":{"orsSystemParameters":{"logonId":"' + searchInputParams[1] + '","logonOffice":"' + searchInputParams[0] + '"}},"issueId":"' + issueId + '"}';
                  requestBody = getRequestBody(searchInputParams[1],searchInputParams[0],issueId);
            }
            
            ACET_ORSWebservice orsWebService = new ACET_ORSWebservice();
            HttpResponse response = (HttpResponse)orsWebService.readIssueDetails(requestBody);
            
            Integer stat_code = response.getStatusCode();
            //stat_code = 500;
            // US2667560 - ORS ReadIssue Error Handling - Sanka
            if(stat_code != 200){
                detailWrapper.success = false;
                if(stat_code == 500){
                    detailWrapper.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }else if(stat_code == 400){
                    // Have the same message
                    detailWrapper.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }else if(stat_code == 404){
                    detailWrapper.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                }else{
                    detailWrapper.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }
                return detailWrapper;
            }
            
            // US2667560 - ORS ReadIssue Error Handling - Sanka
            // String stringResponse = response.toString();
            String stringResponse = response.getBody();
            //stringResponse = stringResponse.replace('"date"', '"date_z"');//US2887998
            //stringResponse = stringResponse.replace('"time"', '"time_z"');//US2887998
            
            //ACET_ORSReadIssueWrapper issueDetails = (ACET_ORSReadIssueWrapper) JSON.deserialize(stringResponse, ACET_ORSReadIssueWrapper.class);
            ACET_ORSReadIssueWrapper issueDetails = ACET_ORSReadIssueWrapper.parse(stringResponse);//US2887998
            //system.debug('issueDetailsInApex: '+issueDetails.issue.claim.claimNumber);
            string claimNumber = issueDetails.issue.claim.claimNumber;
            detailWrapper.success = true;
            detailWrapper.userTimeZone = String.valueof(UserInfo.getTimeZone());
            detailWrapper.extORSFacetsTimeZone = Label.ACET_ORS_TimeZone;

            detailWrapper.externalIdDetails.status = issueDetails.issue.statusDescription;
            detailWrapper.externalIdDetails.method = issueDetails.issue.contactMethodDescription;
            detailWrapper.externalIdDetails.origType =  issueDetails.issue.originatorTypeDescription;
            detailWrapper.externalIdDetails.claimNumber =  issueDetails.issue.claim.claimNumber;
            detailWrapper.externalIdDetails.claimServiceDate =  issueDetails.issue.claim.serviceDate;
            detailWrapper.externalIdDetails.origMPIN = issueDetails.issue.originator.originatorMpin;
            detailWrapper.externalIdDetails.origTaxId =  issueDetails.issue.originator.originatorTin;
            detailWrapper.externalIdDetails.origName = issueDetails.issue.originator.callerName.firstName + ' ' +  issueDetails.issue.originator.callerName.lastName;
            detailWrapper.externalIdDetails.reason =  issueDetails.issue.reasonDescription;
            detailWrapper.externalIdDetails.surveyCode = issueDetails.issue.surveyCode;
            //US3145625 - Sravan - Start
            if(issueDetails.issue.originatedDate != null && string.isNotBlank(issueDetails.issue.originatedDate)){
                detailWrapper.strDate = issueDetails.issue.originatedDate.split('-')[1] + '/' +issueDetails.issue.originatedDate.split('-')[2] + '/' + issueDetails.issue.originatedDate.split('-')[0];
            }
            //US3145625 - Sravan - End
            Map<string,Object> additionalInfoMap = new Map<string,Object>();
            if(string.isNotBlank(issueDetails.issue.contactMethodCode)){
                additionalInfoMap.put('contactMethodCode',issueDetails.issue.contactMethodCode);
            }
            if(string.isNotBlank(issueDetails.issue.originatorTypeCode)){
                additionalInfoMap.put('originatorTypeCode',issueDetails.issue.originatorTypeCode);
            }
             detailWrapper.externalIdDetails.additionalInfo =  additionalInfoMap;
            //Logic to filter comments based on owner - Sravan
            for (ACET_ORSReadIssueWrapper.owners owner: issueDetails.issue.owners) {
                ownerMap.put(owner.headerNumber, owner);
            }
            //Logic to filter commnets based on userId - Sravan
            for (ACET_ORSReadIssueWrapper.detailComments comment: issueDetails.issue.detailComments) {
                commentMap.put(comment.commentTime + comment.userId, comment.commentText);
                //Integer commentNumber = Integer.valueOf(comment.commentNumber);
                commentUserIdMap.put(comment.commentNumber + comment.headerNumber, comment);
            }
            
            Integer commentSize = issueDetails.issue.detailComments.size();
            ACET_ServiceRequestDetailWrapper.History historyManualCmnts = new ACET_ServiceRequestDetailWrapper.History();
            ACET_ServiceRequestDetailWrapper.History historyUpdateCmnts = new ACET_ServiceRequestDetailWrapper.History();
            Integer iterationCount = 0;
            for (ACET_ORSReadIssueWrapper.detailComments commentItem: issueDetails.issue.detailComments) {
                iterationCount++;
                Boolean isLastIteration = iterationCount == commentSize ? true :false;
                ACET_ServiceRequestDetailWrapper.History history = new ACET_ServiceRequestDetailWrapper.History();
                String addedBy = '';
                if (ownerMap != null) {
                    if (ownerMap.containsKey(commentItem.headerNumber) && ownerMap.get(commentItem.headerNumber) != null && ownerMap.get(commentItem.headerNumber).associateName != null) {
                        ownerName = ownerMap.get(commentItem.headerNumber).associateName.firstName + ' ' + ownerMap.get(commentItem.headerNumber).associateName.lastName;
                        ownerId = ownerMap.get(commentItem.headerNumber).officeId + ownerMap.get(commentItem.headerNumber).associateId;
                        if (ownerMap.get(commentItem.headerNumber).associateName.firstName == '' && ownerMap.get(commentItem.headerNumber).associateName.lastName == '') {
                           ownerName =  ownerMap.get(commentItem.headerNumber).officeId + ' ' + ownerMap.get(commentItem.headerNumber).departmentCode + ' ' + ownerMap.get(commentItem.headerNumber).teamCode;
                        }
                    }
                }
                userId = getUserId(commentItem, ownerId, commentUserIdMap);
                if (String.isNotBlank(userId)) {
                    addedBy = getAddedBy(userId, commentMap,commentItem.commentTime);
                } else {
                    addedBy = 'SYSTEM';
                }
                
                //Update Case Comments
                if(commentItem.commentType == 'NC' && commentItem.userId == '??????') {
                    if(historyUpdateCmnts.comments != '--' && historyUpdateCmnts.dateAndTime != commentItem.commentDate + '/' + commentItem.commentTime && historyUpdateCmnts.addedBy != addedBy) {
                        detailWrapper.historyList.add(historyUpdateCmnts);
                        historyUpdateCmnts = new ACET_ServiceRequestDetailWrapper.History();
                    }
                    if(historyUpdateCmnts.comments != '--') {
                        historyUpdateCmnts.comments =  historyUpdateCmnts.comments + commentItem.commentText +'\n';
                    } else {
                        historyUpdateCmnts.comments = commentItem.commentText +'\n';
                    }
                    historyUpdateCmnts.dateAndTime = commentItem.commentDate + '/' + commentItem.commentTime;
                    historyUpdateCmnts.addedBy = addedBy;
                    historyUpdateCmnts.owner = ownerName;
                } else if(commentItem.commentType == 'EN' && commentItem.userId == '') { //For all Manual Comments
                    if(historyManualCmnts.comments != '--' && historyManualCmnts.dateAndTime != commentItem.commentDate + '/' + commentItem.commentTime && historyManualCmnts.addedBy != addedBy) {
                        detailWrapper.historyList.add(historyManualCmnts);
                        historyManualCmnts = new ACET_ServiceRequestDetailWrapper.History();
                    }
                    if(historyManualCmnts.comments != '--') {
                        if(claimNumber!=''){
                           string tempstrng = commentItem.commentText;
                           system.debug('Incoming tempstrng: '+tempstrng);

                           /*tempstrng =tempstrng.replace('(LINK, PHONE, ETC.)', '(LINK| PHONE| ETC.)' );
                           tempstrng =tempstrng.replace('SUBSCRIBER, SPOUSE AND ONE CHILD', 'SUBSCRIBER| SPOUSE AND ONE CHILD' );
						   tempstrng =tempstrng.replace('CORRECTLY, PRE-APPEAL', 'CORRECTLY| PRE-APPEAL' );
						   tempstrng =tempstrng.replace('RECOVERY, OVERPAYMENT', 'RECOVERY| OVERPAYMENT' );	   
                           tempstrng =tempstrng.replace(', ', '\n');
						   tempstrng =tempstrng.replace(' , ', '\n');
							tempstrng =tempstrng.replace(' ,', '\n');										 
                           tempstrng =tempstrng.replace('|', ',');*/
                           historyManualCmnts.comments =  historyManualCmnts.comments + tempstrng;
                        }else{
                          historyManualCmnts.comments =  historyManualCmnts.comments + commentItem.commentText +'\n';
                        }
                    } else {
                        historyManualCmnts.comments = commentItem.commentText +'\n';
                    }
                    historyManualCmnts.dateAndTime = commentItem.commentDate + '/' + commentItem.commentTime;
                    historyManualCmnts.addedBy = addedBy;
                    historyManualCmnts.owner = ownerName;
                } else { //For all System Generated Comments
                    if(history.comments != '--' && history.dateAndTime != commentItem.commentDate + '/' + commentItem.commentTime && history.addedBy != addedBy) {
                        detailWrapper.historyList.add(history);
                        history = new ACET_ServiceRequestDetailWrapper.History();
                    }
                    if(history.comments != '--') {
                        history.comments =  history.comments + commentItem.commentText +'\n';
                    } else {
                        history.comments = commentItem.commentText +'\n';
                    }
                    history.dateAndTime = commentItem.commentDate.contains('-') ? commentItem.commentDate + '/' + commentItem.commentTime : commentItem.commentDate.substring(0,4) + '-' + commentItem.commentDate.substring(4,6) + '-' + commentItem.commentDate.substring(6,8) + '/' + commentItem.commentTime;
                    history.addedBy = addedBy;
                    history.owner = ownerName;
                }
                
                if(history.comments != '--' || isLastIteration) {
                    //Adding Manual Comments to History
                    if(isLastIteration) {
                        detailWrapper.historyList.add(historyManualCmnts);
                        historyManualCmnts = new ACET_ServiceRequestDetailWrapper.History();
                    }
                    //Adding Updated Comments to History
                    if(historyUpdateCmnts.comments != '--') {
                        detailWrapper.historyList.add(historyUpdateCmnts);
                        historyUpdateCmnts = new ACET_ServiceRequestDetailWrapper.History();
                    }
                    //Adding System Comments to History
                    if(history.comments != '--') {
                        detailWrapper.historyList.add(history);   
                    }
                }
            }
        }catch(Exception e){
            detailWrapper.success = false;
            detailWrapper.errorMessage = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
        }
        return detailWrapper;
    }
    
    
    //To get the userId - Sravan
    public static String getUserId(ACET_ORSReadIssueWrapper.detailComments comment, String ownerId, Map < String, ACET_ORSReadIssueWrapper.detailComments > commentUserIdMap) {
        String userId = '';
        Integer commentNumber = 0;
        Integer count = 1;
        Integer priorNode = 1;
        Integer numOfComments = 0;
        if (comment != null) {
            if (String.isNotBlank(comment.userId) && comment.userId == '??????' && comment.commentType == 'NC') { //update comments
                userId = comment.userId;
            } else if (String.isNotBlank(comment.userId) && (comment.commentType == 'EN' || comment.commentType == 'NC' || comment.commentType == 'NO')) { //Manually entered comments
                userId = comment.userId.replaceAll('[^a-zA-Z0-9]*', '');
            } else if (String.isNotBlank(comment.userId) && comment.commentType != 'EN' && comment.commentType != 'NC' && comment.commentType != 'NO') { //System comments
                userId = '';
            } else if (String.isBlank(comment.userId) && comment.commentType == 'EN') { //Manually entered comments
                userId = ownerId;
            } else if (String.isBlank(comment.userId) && comment.commentType != 'EN' && comment.commentType != 'NC' && comment.commentType != 'NO') { //System comments
                userId = '';
            } else if (String.isBlank(comment.userId) && (comment.commentType == 'NC' || comment.commentType == 'NO')) { //Manually entered comments
                if (commentUserIdMap != null) {
                    commentNumber = Integer.valueOf(comment.commentNumber);
                    //Logic to fetch the userId from prior node
                    numOfComments = commentUserIdMap.Size();
                    while (count < numOfComments) {
                        Integer priorNodeCommentNum = commentNumber - priorNode;
                        String key = String.valueOf(priorNodeCommentNum) + comment.headerNumber;
                        if (commentUserIdMap.containsKey(key) && commentUserIdMap.get(key) != null && String.isNotBlank(commentUserIdMap.get(key).userId)) {
                            userId = commentUserIdMap.get(key).userId;
                            count = numOfComments;
                        } else {
                            //Logic to fetch userid from comment text
                            if (commentUserIdMap.containsKey(key) && commentUserIdMap.get(key) != null && String.isNotBlank(commentUserIdMap.get(key).commentText)) {
                                String commentText = commentUserIdMap.get(key).commentText;
                                String filteredText = commentText.replaceFirst('[^0-9]*', '');
                                List < String > textList = new List < String > ();
                                textList = filteredText.split(' ');
                                if (textList != null && !textList.isEmpty()) {
                                    if (textList.Size() > 1) {
                                        userId = textList[0] + textList[1];
                                        count = numOfComments;
                                    } else if (textList.Size() == 1) {
                                        userId = textList[0];
                                        count = numOfComments;
                                    }
                                } else {
                                    //Move to next node
                                    count = count + 1;
                                    priorNode = priorNode + 1;
                                }
                            } else {
                                //Move to next node
                                count = count + 1;
                                priorNode = priorNode + 1;
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        return userId;
    }
    
    //To get addedBy - Sravan
    public static String getAddedBy(String userId, Map < String, String > commentMap, String commentTime) {
        String commentText = '';
        String trimmedText = '';
        String addedBy = '';
        if(userId == '??????') {
            if (String.isNotBlank(commentTime)) {
                if (!addedByMap.containsKey(commentTime)) {
                    if (commentMap != null) {
                        if (commentMap.containsKey(commentTime) && commentMap.get(commentTime) != null && String.isNotBlank(commentMap.get(commentTime))) {
                            commentText = commentMap.get(commentTime).replaceAll('[^a-zA-Z\\s]', '');
                            trimmedText = commentText;
                            if (String.isNotBlank(trimmedText)) {
                                List < String > charList = new List < String > ();
                                charList = trimmedText.split(' ');
                                if (charList != null && !charList.isEmpty()) {
                                    Integer charSize = charList.Size();
                                    if (charSize > 1) {
                                        addedBy = charList[charSize - 2] + ' ' + charList[charSize - 1];
                                        addedByMap.put(commentTime, addedBy);
                                    } else if (charSize == 1) {
                                        addedBy = charList[charSize - 1];
                                        addedByMap.put(commentTime, addedBy);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    addedBy = addedByMap.get(commentTime);
                    
                }
            }
        } else {
            if (!addedByMap.containsKey(commenttime + userId)) {
                if (commentMap != null) {
                    if (commentMap.containsKey(commenttime + userId) && commentMap.get(commenttime + userId) != null && String.isNotBlank(commentMap.get(commenttime + userId))) {
                        commentText = commentMap.get(commenttime + userId).replaceAll('[^a-zA-Z\\s]', '');
                        trimmedText = commentText;
                        if (String.isNotBlank(trimmedText)) {
                            List < String > charList = new List < String > ();
                            charList = trimmedText.split(' ');
                            if (charList != null && !charList.isEmpty()) {
                                Integer charSize = charList.Size();
                                if (charSize > 1) {
                                    addedBy = charList[charSize - 2] + ' ' + charList[charSize - 1];
                                    addedByMap.put(commenttime + userId, addedBy);
                                } else if (charSize == 1) {
                                    addedBy = charList[charSize - 1];
                                    addedByMap.put(commenttime + userId, addedBy);
                                }
                            }
                        }
                    }
                }
            } else {
                addedBy = addedByMap.get(commenttime + userId);
            }
        }
        return addedBy;
    }

    //Durga
    public static string getRequestBody(String logonId,String logonOffice, String issueId){
        ACET_ORSReadIssueRequestWrapper ar =new ACET_ORSReadIssueRequestWrapper();
        ACET_ORSReadIssueRequestWrapper.ControlModifiers cm= new ACET_ORSReadIssueRequestWrapper.ControlModifiers();
        ACET_ORSReadIssueRequestWrapper.OrsSystemParameters ors= new ACET_ORSReadIssueRequestWrapper.OrsSystemParameters();
        ors.logonId = logonId;
        ors.logonOffice = logonOffice;
        cm.orsSystemParameters=ors;
        ar.issueId = issueId;
        ar.controlModifiers = cm;
        string requestBody = JSON.serialize(ar);
        return requestBody;
    }


    //Get FacetsRequestDetails - ACET_FACETSServiceRequest_Test
    public static ACET_ServiceRequestDetailWrapper getFacetsDetails (String issueId, String caseId) {
        ACET_ServiceRequestDetailWrapper info = new ACET_ServiceRequestDetailWrapper();
        try {
            ACET_FacetsWebservice.getFacetsResponse responseStr = (ACET_FacetsWebservice.getFacetsResponse)ACET_FacetsWebservice.fetchFacetsCases('','',issueId,1);
            Integer statusCode = responseStr.responseStatus;

            if(statusCode != 200){
                info.success = false;
                if(statusCode == 500){
                    info.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }else if(statusCode == 400){
                    info.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }else if(statusCode == 404){
                    info.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                }else{
                    info.errorMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }
                return info;
            }
            else if(statusCode == 200){
                ACET_FacetsGetCasesResponse casesFacetsResponse = responseStr.casesFacetsResponse;
                if(casesFacetsResponse.data != null){
                    Map<string,string> userNameMap = new Map<string,string>();
                    string strPrimaryUserIdfromService = '', strIssueStatus = '--',strUserName = '--', strDate = '--', strStatus = '--', strMethod = '--', strOrgType = '--', strMPIN = '--', strOrgName = '--', strSummaryText='--', strTaxId = '--', strDateTime='--',strNoteText = '',strLastTime = '',strLastUpdatedUser = '';
                    for(ACET_FacetsGetCasesResponse.Data dr : casesFacetsResponse.data){
                        if(dr.attributes != null && dr.attributes.tasks != null){
                            for(ACET_FacetsGetCasesResponse.Tasks tr: dr.attributes.tasks){
                                //strPrimaryUserIdfromService = string.isNotBlank(tr.primaryUserId) ? tr.primaryUserId : '';
                                if(string.isNotBlank(tr.primaryUserId)){
                                    strPrimaryUserIdfromService = tr.primaryUserId.trim();
                                    userNameMap.put(tr.primaryUserId.trim(),tr.primaryUserId.trim());
                                }
                                if(string.isNotBlank(tr.lastUpdateUserId)){
                                    strLastUpdatedUser = tr.lastUpdateUserId.trim();
                                    userNameMap.put(tr.lastUpdateUserId.trim(),tr.lastUpdateUserId.trim());
                                }
                                if(String.isNotBlank(tr.statusCode.code)) {
                                    strStatus = tr.statusCode.code == 'CL' ? 'CLOSED' : 'OPEN';//US3145625 - Sravan
                                }
                                if(String.isNotBlank(tr.statusCode.desc_Z)) {
                                    strStatus = strStatus + ' - ' + tr.statusCode.desc_Z;
                                }
                                if(String.isNotBlank(tr.statusReasonCode.desc_Z)) {
                                    strIssueStatus = tr.statusReasonCode.desc_Z;
                                }

                                if(String.isNotBlank(tr.inputDate)) {
                                    strDate =  (String.isNotBlank(tr.inputDate) ? (tr.inputDate.split('T')[0].split('-')[1] + '/' +tr.inputDate.split('T')[0].split('-')[2] + '/' + tr.inputDate.split('T')[0].split('-')[0]) :  '');
                                }

                                if(String.isNotBlank(tr.inputDate)) {
                                    strDateTime =  (String.isNotBlank(tr.inputDate) ? tr.inputDate.split('T')[0] +'/'+tr.inputDate.split('T')[1]:'');
                                }

                                if(String.isNotBlank(tr.providerId)) {
                                    strMPIN =  tr.providerId;
                                }

                                if(String.isNotBlank(tr.summaryText)) {
                                    strSummaryText =  tr.summaryText;
                                }

                                if(string.isNotBlank(tr.noteText) && tr.noteType != null && string.isNotBlank(tr.noteType.desc_Z) && tr.noteType.desc_Z == 'Notes Text'){
                                    strNoteText = tr.noteText;
                                }

                                 if(string.isNotBlank(tr.lastUpdatedDate)){
                                    strLastTime =  (String.isNotBlank(tr.lastUpdatedDate) ? tr.lastUpdatedDate.split('T')[0] +'/'+tr.lastUpdatedDate.split('T')[1]:'');
                                }
                            }

                            if(String.isNotBlank(dr.attributes.inquiryMethod.desc_Z)) {
                                strMethod = dr.attributes.inquiryMethod.desc_Z;
                            }

                            if(String.isNotBlank(dr.attributes.callerType.desc_Z)) {
                                strOrgType = dr.attributes.callerType.desc_Z;
                            }

                            /*if(String.isNotBlank(dr.attributes.callerName.firstName)) {
                                strOrgName = dr.attributes.callerName.firstName;
                            }
                            if(String.isNotBlank(dr.attributes.callerName.lastName)) {
                                strOrgName = strOrgName + ' - ' + dr.attributes.callerName.lastName;
                            }*/

                            //US3145625 - Sravan - Start
                            if(String.isNotBlank(caseId)){
                                List<Case> caseList = new List<Case>();
                                system.debug('The issue id'+ caseId);
                                caseList = [Select Id, Caller__c, TaxID__c from case where id=: caseId];
                                if(caseList != null && !caseList.isEmpty()){
                                    strOrgName = caseList[0].Caller__c;
                                    strTaxId = caseList[0].TaxID__c;
                            }

                            }
                            //US3145625 - Sravan - End


                        }
                    }
                    //Fill Wrapper
                    info.externalIdDetails = new ACET_ServiceRequestDetailWrapper.ExternalIdDetails();
                    info.externalIdDetails.status = strStatus;
                    info.externalIdDetails.method = strMethod;
                    info.externalIdDetails.origType = strOrgType;
                    info.externalIdDetails.claimNumber = '0000000000';
                    info.externalIdDetails.claimServiceDate = '--';
                    info.externalIdDetails.origMPIN = strMPIN;
                    info.externalIdDetails.origTaxId = strTaxId;//US3145625 - Sravan
                    info.externalIdDetails.origName = strOrgName.toUpperCase();
                    info.externalIdDetails.reason = strIssueStatus;
                    info.externalIdDetails.IDType = 'FACETS';
                    info.strDate = strDate;
                    info.isFacets = true;

                    if(!userNameMap.isEmpty()){
                        List<User> lstUsers = new List<User>();
                        lstUsers = [Select id,FederationIdentifier,FirstName,LastName from User Where FederationIdentifier=:userNameMap.keyset()];
                        if(!lstUsers.isEmpty()){
                            //strUserName = (lstUsers[0].FirstName != null ? lstUsers[0].FirstName : '') + ' ' +(lstUsers[0].LastName != null ? lstUsers[0].LastName : '');
                            for(user u:lstUsers){
                                if(userNameMap.get(u.FederationIdentifier) != NULL){
                                    string userName = (u.FirstName != null ? u.FirstName : '') + ' ' +(u.LastName != null ? u.LastName : '');
                                    userNameMap.put(u.FederationIdentifier,userName);
                                }
                        }
                    }
                    }
                   List<ACET_ServiceRequestDetailWrapper.History> objHistoryList = new List<ACET_ServiceRequestDetailWrapper.History>();
                    ACET_ServiceRequestDetailWrapper.History objHistory = new ACET_ServiceRequestDetailWrapper.History();
                    objHistory.addedBy = userNameMap.get(strPrimaryUserIdfromService);
                    objHistory.owner =  userNameMap.get(strPrimaryUserIdfromService); //strUserName;
                    objHistory.comments = strSummaryText;
                    objHistory.dateAndTime = strDateTime;//strDate;
                    objHistoryList.add(objHistory);

                    if(string.isNotBlank(strNoteText) && string.isNotBlank(strLastUpdatedUser)){
                        ACET_ServiceRequestDetailWrapper.History objHistory2 = new ACET_ServiceRequestDetailWrapper.History();
                        objHistory2.addedBy = userNameMap.get(strLastUpdatedUser);
                        objHistory2.owner = userNameMap.get(strLastUpdatedUser);
                        objHistory2.comments = processFacetsNotesText(strNoteText);//strNoteText;
                        objHistory2.dateAndTime = strLastTime;
                        objHistoryList.add(objHistory2);
                    }

                    //info.historyList = new List<ACET_ServiceRequestDetailWrapper.History>{objHistory};
                    info.historyList = objHistoryList;
                    info.success = true;
                    info.userTimeZone = String.valueof(UserInfo.getTimeZone());
                    info.extORSFacetsTimeZone = Label.ACET_Facets_TimeZone;
                    info.errorMessage = '';
                }
            }
        } catch(exception ex) {
            info.success = false;
            system.debug('@ex@'+ex.getMessage());
            info.errorMessage = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
        }
        return info;
    }

    public static string processFacetsNotesText(string commenttext){
        system.debug('@commenttext@'+commenttext);
        List<string> lstOfcomments = commenttext.split('\n');
        lstOfcomments.remove(0);
        List<string> finalList= new List<string>();
        integer l = 90;
        for(string comment: lstOfcomments){
            Integer length = comment.length();
            if(length > l) {
                List<string> tlist = new List<string>();
                Integer noOfIterations = (Integer) length/l;
                for(Integer i=0; i<=noOfIterations ; i++) {
                    if(length > (i*l)+l) {
                        tlist.add(comment.subString(i*l, (i*l)+l));
                    } else {
                        tlist.add(comment.subString(i*l, length));
                    }
                }
                string ts = string.join(tlist,'\n');
                ts = '* '+ts;
                finalList.add(ts);
            }
            else{
                comment = '* '+comment;
                finalList.add(comment);
            }
        }
        string fs = string.join(finalList, '\n');
        system.debug('@fs@'+fs);
        return fs;
    }

    // ACET_FACETSServiceRequest_Test
    @AuraEnabled
    public static ACET_SAECalloutResult insertFacetsComments(string comment,string facetId){
        ACET_SAECalloutResult returnResp = new ACET_SAECalloutResult();
        List<User> lstUsers = new List<User>();
        lstUsers = [Select id,FederationIdentifier from User Where Id=:Userinfo.getUserId()];
        returnResp = ACET_FacetsWebservice.updateFaceCase(facetId,comment, !lstUsers.isEmpty() ? lstUsers[0].FederationIdentifier : '');
        Integer statusCode = returnResp.statusCode;
        if(statusCode == 400) {
            returnResp.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
        } else if(statusCode == 404) {
            returnResp.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
        } else if(statusCode == 500) {
            returnResp.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
        } else {
            returnResp.Message = 'Unexpected error occured. Error Code: ' + String.valueOf(statusCode);
        }
        system.debug('=returnResp='+returnResp);
        return returnResp;
    }

    @AuraEnabled
        public static ACET_CaseCommentsController.feedback insertCaseComments(String caseId, String caseComment, Boolean isPublic)
        {
            return ACET_CaseCommentsController.insertCaseComments(caseId,caseComment,isPublic);
        }

        @AuraEnabled
        public static List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> updateORSCaseComments(String caseId, String comment){
            return ACET_CaseCommentsController.updateORSCaseComments(caseId,comment);
        }

        @AuraEnabled
        public static List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> updateOnlyORSCaseComments(string ORSCaseId, string comment, string contactMethod,string originatoryTypeCode,
                                                                                                           string originatorName){
            List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> resList = new List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper>();
            List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> errorList = new List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper>();
            try{
                List<String> comments = new List<String>();
                if(comment != null && comment != '') {
                    Integer length = comment.length();
                    if(length > 71) {
                        Integer noOfIterations = (Integer) length/71;
                        for(Integer i=0; i<=noOfIterations ; i++) {
                            if(length > (i*71)+71) {
                                comments.add(comment.subString(i*71, (i*71)+71));
                            } else {
                                comments.add(comment.subString(i*71, length));
                            }
                        }
                    } else {
                        comments.add(comment);
                    }
                } else {
                    comments.add('');
                }


                String topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');
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

                String logonoffice = '';
                String agentId = '';

                if(!searchInputParams.isempty()) {
                    logonoffice = searchInputParams[0];
                    agentId = searchInputParams[1];
                }

                string stringRequest = processCommentSpecificUpdateRequest(ORSCaseId,comments,contactMethod,logonoffice,agentId,originatoryTypeCode,originatorName);

                system.debug('finalWrap'+ stringRequest);
                HttpResponse responseStr = (HttpResponse)ACET_ORSWebservice.updateORSIssue(stringRequest,ORSCaseId);
                 return proceeUpdateResponseCallout(responseStr);
            }
            catch(Exception e){
                 ACET_CaseCommentsController.UpdateCaseCommentsWrapper error = new ACET_CaseCommentsController.UpdateCaseCommentsWrapper();
                error.responseStatus = 999;
                error.responseStatusMessage = 'Unexpected error occured.';
                List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> exceptionList = new List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper>();
                exceptionList.add(error);
                return exceptionList;
            }

        }

        @AuraEnabled
        public static string processCommentSpecificUpdateRequest(string ORSCaseId, List<string> comments, string contactMethod,string logonoffice, string agentId,string originatoryTypeCode, string originatorName){
            string finalRequst= '';
            ACET_ORSRequestWrapper.OrsSourceSystemParameters sysPara = new ACET_ORSRequestWrapper.OrsSourceSystemParameters();
                sysPara.logonId = agentId;
                sysPara.logonOffice = logonoffice;
                ACET_ORSRequestWrapper.controlModifiers controlModifiers = new ACET_ORSRequestWrapper.controlModifiers();
                controlModifiers.orsSourceSystemParameters = sysPara;

            ACET_ORSRequestWrapper.Meta metaInfo = new ACET_ORSRequestWrapper.Meta();
            metaInfo.controlModifiers = controlModifiers;
            ACET_ORSRequestWrapper.CallerName callerName = new ACET_ORSRequestWrapper.CallerName();
            List<String> callerNames = new List<String>();
            if(string.isNotBlank(originatorName)){
                callerNames = originatorName.split(' ');
                if(callerNames != null && !callerNames.isEmpty()){
                    callerName.firstName = callerNames.get(0);
                    callerName.lastName = callerNames.size() > 1 ? callerNames.get(1) : ' ';
                }

            }
            else{
                callerName.firstName = '';
                callerName.lastName = '';
            }
            ACET_ORSRequestWrapper.Originator originator = new ACET_ORSRequestWrapper.Originator();
            originator.callerName = callerName;
            ACET_ORSRequestWrapper.Cti cti  = new ACET_ORSRequestWrapper.Cti();
            ACET_ORSRequestWrapper.DayPhone dayPhone  = new ACET_ORSRequestWrapper.DayPhone();
            ACET_ORSRequestWrapper.EveningPhone eveningPhone= new ACET_ORSRequestWrapper.EveningPhone();

            originator.cti  = cti;
            originator.dayPhone = dayPhone;
            originator.eveningPhone = eveningPhone;
            originator.callerAddress = new ACET_ORSRequestWrapper.CallerAddress();

            ACET_ORSRequestWrapper.ProviderInfo providerInfo = new ACET_ORSRequestWrapper.ProviderInfo();
            List<String> stringList = new List<String>();
            stringList.add('');
            providerInfo.npis = stringList;
            ACET_ORSRequestWrapper.Pcp pcp = new ACET_ORSRequestWrapper.Pcp();
            ACET_ORSRequestWrapper.Address pcpAddress = new ACET_ORSRequestWrapper.Address();
            ACET_ORSRequestWrapper.Phone pcpPhone = new ACET_ORSRequestWrapper.Phone();
            ACET_ORSRequestWrapper.ProviderName pcpProviderName =  new ACET_ORSRequestWrapper.ProviderName();
            pcp.providerName = pcpProviderName;
            pcp.phone = pcpPhone;
            pcp.address = pcpAddress;
            providerInfo.pcp = pcp;
            ACET_ORSRequestWrapper.Provider provider = new ACET_ORSRequestWrapper.Provider();
            ACET_ORSRequestWrapper.ProviderName providerName =  new ACET_ORSRequestWrapper.ProviderName();
            ACET_ORSRequestWrapper.Address address = new ACET_ORSRequestWrapper.Address();
            ACET_ORSRequestWrapper.Phone phone = new ACET_ORSRequestWrapper.Phone();
            provider.providerName = providerName;
            provider.address = address;
            provider.phone = phone;

            providerInfo.provider = provider;


            ACET_ORSRequestWrapper.Issue orsIssue = new ACET_ORSRequestWrapper.Issue();
            /*orsIssue.issueId = issue.issueId;
            orsIssue.updateType = 'X';
            orsIssue.modifiedByApplicationIndicator = 'H';*/
            orsIssue.comments = comments;
            orsIssue.originator = originator;
            orsIssue.directionCode = 'I';
            orsIssue.contactMethodCode = contactMethod;
            originator.originatorTypeCode = originatoryTypeCode;
            orsIssue.employer = new ACET_ORSRequestWrapper.employer();
            orsIssue.logoLookups = new List<ACET_ORSRequestWrapper.LogoLookups>{new ACET_ORSRequestWrapper.LogoLookups()};
                ACET_ORSRequestWrapper.Member member = new ACET_ORSRequestWrapper.Member();
            ACET_ORSRequestWrapper.ServicesQuoted servicesQuoted = new ACET_ORSRequestWrapper.ServicesQuoted();
            ACET_ORSRequestWrapper.Address memberAddress = new ACET_ORSRequestWrapper.Address();
            ACET_ORSRequestWrapper.DependentName dependentName = new ACET_ORSRequestWrapper.DependentName();
            ACET_ORSRequestWrapper.FaxNumber faxNumber = new ACET_ORSRequestWrapper.FaxNumber();
            ACET_ORSRequestWrapper.MemberName memberName = new ACET_ORSRequestWrapper.MemberName();
            ACET_ORSRequestWrapper.Phone memberPhone = new ACET_ORSRequestWrapper.Phone();
            member.phone = memberPhone;
            member.memberName = memberName;
            member.faxNumber = faxNumber;
            member.servicesQuoted = servicesQuoted;
            member.riderCodes = new List<String>{''};
                member.address = memberAddress;
            member.age = 0;
            member.totalNonCoverageCount = 0;
            member.dependentName = dependentName;
            orsIssue.member = member;

            orsIssue.otherInfo = new ACET_ORSRequestWrapper.OtherInfo();
            orsIssue.providerInfo = providerInfo;
            orsIssue.serviceRequest = new ACET_ORSRequestWrapper.ServiceRequest();
            ACET_ORSRequestWrapper.CarbonCopies carbonCopies  = new ACET_ORSRequestWrapper.CarbonCopies();
            ACET_ORSRequestWrapper.RoutedTo routedTo = new ACET_ORSRequestWrapper.RoutedTo();
            ACET_ORSRequestWrapper.ResolvedBy resolvedBy = new ACET_ORSRequestWrapper.ResolvedBy();
            ACET_ORSRequestWrapper.IssueHandling issueHandling = new ACET_ORSRequestWrapper.IssueHandling();
            issueHandling.carbonCopies = new List<ACET_ORSRequestWrapper.CarbonCopies>{carbonCopies};
                issueHandling.routedTo = routedTo;
            issueHandling.resolvedBy = resolvedBy;
            orsIssue.issueHandling = issueHandling;
            ACET_ORSRequestWrapper.Grievance grievance = new  ACET_ORSRequestWrapper.Grievance();
            orsIssue.grievance = grievance;
            orsIssue.issueElapseTime = 0;
            orsIssue.contactElapseTime = 0;

            ACET_ORSRequestWrapper.Claim claim = new ACET_ORSRequestWrapper.Claim();
            ACET_ORSRequestWrapper.Drafts drafts = new ACET_ORSRequestWrapper.Drafts();
            ACET_ORSRequestWrapper.Atg atg= new ACET_ORSRequestWrapper.Atg();
            atg.drafts = new List<ACET_ORSRequestWrapper.Drafts>{drafts};
                claim.atg = atg;
            orsIssue.claim = claim;

            ACET_ORSRequestWrapper.CellPhone cellPhone = new  ACET_ORSRequestWrapper.CellPhone();
            ACET_ORSRequestWrapper.Creator creator = new  ACET_ORSRequestWrapper.Creator();
            ACET_ORSRequestWrapper.Fax fax = new  ACET_ORSRequestWrapper.Fax();
            ACET_ORSRequestWrapper.HomePhone homePhone = new  ACET_ORSRequestWrapper.HomePhone();
            ACET_ORSRequestWrapper.OtherPhone otherPhone = new  ACET_ORSRequestWrapper.OtherPhone();
            ACET_ORSRequestWrapper.WorkPhone workPhone = new ACET_ORSRequestWrapper.WorkPhone();

            ACET_ORSRequestWrapper.FollowUp  followUp = new ACET_ORSRequestWrapper.FollowUp();
            followUp.cellPhone = cellPhone;
            followUp.creator =creator;
            followUp.fax   = fax;
            followUp.homePhone  = homePhone;
            followUp.otherPhone = otherPhone;
            followUp.workPhone  = workPhone;

            orsIssue.followUp = followUp;

            ACET_ORSRequestWrapper.Data dataObj = new ACET_ORSRequestWrapper.Data();
            dataObj.issue = orsIssue;

            ACET_ORSRequestWrapper acetORS = new ACET_ORSRequestWrapper();
            acetORS.meta = metaInfo;
            acetORS.data = dataObj;

            String orsReq =  JSON.serialize(acetORS);
            Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(orsReq);
            String orsdata =  JSON.serialize(requestMap.get('data'));
            Map<String, Object> orsMap= (Map<String, Object>)JSON.deserializeUntyped(orsdata);
            orsMap.put('modifiedByApplicationIndicator','H');
            orsMap.put('updateType','X');
            Object dataObject = (Object)orsMap;
            requestMap.put('data',dataObject);

            finalRequst= JSON.serialize((Object)requestMap);

            //Overriding reserved keywords
            finalRequst = finalRequst.replace('null', '""').replace('number_Z', 'number').replace('--','');

            return finalRequst;
        }

        public static List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> proceeUpdateResponseCallout (HttpResponse responseStr) {
             List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> retunrList = new List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper>();
            List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper> errorList = new List<ACET_CaseCommentsController.UpdateCaseCommentsWrapper>();
        if(responseStr.getStatusCode() != 200  && responseStr.getStatusCode() != 201) {
                    ACET_CaseCommentsController.UpdateCaseCommentsWrapper error = new ACET_CaseCommentsController.UpdateCaseCommentsWrapper();
                    error.responseStatus = responseStr.getStatusCode();

                    if(responseStr.getStatusCode() == 400) {
                        error.responseStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                    } else if(responseStr.getStatusCode() == 404) {
                        error.responseStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                    } else if(responseStr.getStatusCode() == 500) {
                        error.responseStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                    } else {
                        error.responseStatusMessage = 'Unexpected error occured. Error Code: ' + String.valueOf(responseStr.getStatusCode());
                    }
                    errorList.add(error);
                }
                 if(errorList.size() > 0) {
                    retunrList = errorList;
                } else {
                    retunrList.add(new ACET_CaseCommentsController.UpdateCaseCommentsWrapper());
                }
            return retunrList;
        }

    // US3177995 - Thanish - 22nd Jun 2021
    @AuraEnabled
    public static ACET_SAECalloutResult getPurgedORSRecords(String searchId){
        List<selectIssueWrapper> retList = new List<selectIssueWrapper>();
        ACET_SAECalloutResult result = ACET_DocThreeSixtyService.searchDocuments(searchId, true);
        List<ACET_DocThreeSixtyService.PurgedORS> purgedRecords = (List<ACET_DocThreeSixtyService.PurgedORS>) result.response;

        if(result.isSuccess && (purgedRecords.size() > 0)){
            for(ACET_DocThreeSixtyService.PurgedORS purgedRecord : purgedRecords){
                selectIssueWrapper record = new selectIssueWrapper();
                record.DateCreated = purgedRecord.dateTimeVal;
                record.ExternalId = purgedRecord.externalId;
                record.purgedORSID = purgedRecord.objectId;
                record.IdType = purgedRecord.idType;
                record.isEmptyPurgedORS = false;
                record.isLink = true;
                retList.add(record);
            }
            result.response = retList;
        } else{
            selectIssueWrapper emptyRec = new selectIssueWrapper();
            emptyRec.isEmptyPurgedORS = true; emptyRec.ExternalId = 'No Additional Results Found'; emptyRec.IdType = 'Purged ORS'; emptyRec.isLink = false;
            retList.add(emptyRec);
            result.response = retList;
        }
        return result;
    }
}