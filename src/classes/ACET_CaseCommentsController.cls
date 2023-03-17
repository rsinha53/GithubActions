public with sharing class ACET_CaseCommentsController 
{
    //QA
    // public static final List<String> ALLOWED_PROFILES = new List<String>{'Provider Service'};
    // Dev
    public static final List<String> ALLOWED_PROFILES = new List<String>{'Provider Service','System Administrator'};
    public static final List<String> SAE_RECORD_TYPES = new List<String>{'SAE Provider','SAE Provider Closed'};

    public ACET_CaseCommentsController() {

    }

    @AuraEnabled
    public static ACET_CaseCommentsController.feedback insertCaseComments(String caseId, String caseComment, Boolean isPublic)
    {
        ACET_CaseCommentsController.feedback created = new ACET_CaseCommentsController.feedback();

        Id profileId = userinfo.getProfileId();
        String profileName =[SELECT Id,Name FROM Profile WHERE Id=:profileId].Name;

        List<Case> paretCase = [Select Id, RecordType.Name from case where Id = :caseId ];

        if(!ALLOWED_PROFILES.contains(profileName) && SAE_RECORD_TYPES.contains(paretCase.get(0).RecordType.Name))
        {
            String errorMessage = 'Case comments on SAE cases are not allowed to be added by non SAE users.';
            created.message = errorMessage;
            created.success = false;
        }else{
            try {
                CaseComment cm = new CaseComment();
                cm.ParentId =caseId;
                cm.CommentBody = caseComment;
                cm.IsPublished = isPublic;
                insert cm;
                
                created.message = cm.Id;
                created.success = true;

            } catch (Exception e) {
                created.message = e.getMessage();
                created.success = false;
            }
        }       

        return created;
    }

    // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
    @AuraEnabled
    public static List<UpdateCaseCommentsWrapper> updateORSCaseComments(String caseId, String comment){
        List<UpdateCaseCommentsWrapper> returnList = new List<UpdateCaseCommentsWrapper>();
        List<UpdateCaseCommentsWrapper> errorList = new List<UpdateCaseCommentsWrapper>();

        try{
        List<Case> caseRecord = [SELECT id, Caller__c, CaseNumber, Status, ORS_Issue_ID__c, Originator_Type__c FROM Case WHERE id = :caseId];
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

        String logonoffice = '';
        String agentId = '';

        if(!searchInputParams.isempty()) {
            logonoffice = searchInputParams[0];
            agentId = searchInputParams[1];
        }

        String requestBody =  '{"searchInput": {"searchType": "CASE_NBR","officeId": "'+ logonoffice +'", "agentId": "'+ agentId +'","caseNumber":"'+ caseRecord.get(0).CaseNumber +'"}}';

            // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
            HttpResponse selectIssuesResponse = (HttpResponse)ACET_ORSWebservice.selectIssuesCommon(requestBody);

            if(selectIssuesResponse.getStatusCode() == 200) {
                ACET_ORSSelectIssuesWrapper selectIssues = ACET_ORSSelectIssuesWrapper.parse(selectIssuesResponse.getBody());

        for(ACET_ORSSelectIssuesWrapper.IssuesList issue : selectIssues.searchResult.searchOutput.issuesList){

            //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
            ACET_ORSRequestWrapper.OrsSourceSystemParameters sysPara = new ACET_ORSRequestWrapper.OrsSourceSystemParameters();
            sysPara.logonId = agentId;
            sysPara.logonOffice = logonoffice;
    


             ACET_ORSRequestWrapper.controlModifiers controlModifiers = new ACET_ORSRequestWrapper.controlModifiers();
             controlModifiers.orsSourceSystemParameters = sysPara;

             ACET_ORSRequestWrapper.Meta metaInfo = new ACET_ORSRequestWrapper.Meta();
             metaInfo.controlModifiers = controlModifiers;
             //US2887985: Tech: Create ORS Change to Microservice - Sravan - End

                    ACET_ORSRequestWrapper.CallerName callerName = new ACET_ORSRequestWrapper.CallerName();
            List<String> callerNames = new List<String>();
            if(caseRecord.get(0).Caller__c != null) {
                callerNames = caseRecord.get(0).Caller__c.split(' ');
                if(callerNames != null && !callerNames.isEmpty()){
                    callerName.firstName = callerNames.get(0);
                    callerName.lastName = callerNames.size() > 1 ? callerNames.get(1) : ' ';  
                }
            }else{
                callerName.firstName = ' ';
                callerName.lastName = ' '; 
            }
    

            //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
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
                    //US2887985: Tech: Create ORS Change to Microservice - Sravan - End
    

            ACET_ORSRequestWrapper.Issue orsIssue = new ACET_ORSRequestWrapper.Issue();
            /*orsIssue.issueId = issue.issueId;
            orsIssue.updateType = 'X';
            orsIssue.modifiedByApplicationIndicator = 'H';*/
            orsIssue.comments = comments;
            orsIssue.originator = originator;
            orsIssue.directionCode = 'I';
            orsIssue.contactMethodCode = issue.contactMethodCode;
            originator.originatorTypeCode = issue.originatorTypeCode;
            orsIssue.employer = new ACET_ORSRequestWrapper.employer();
            orsIssue.logoLookups = new List<ACET_ORSRequestWrapper.LogoLookups>{new ACET_ORSRequestWrapper.LogoLookups()};
            //US2887985: Tech: Create ORS Change to Microservice - Sravan - Start
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

                //US2887985: Tech: Create ORS Change to Microservice - Sravan - End
    
                String stringRequest = JSON.serialize((Object)requestMap);

                //Overriding reserved keywords
                stringRequest = stringRequest.replace('null', '""').replace('number_Z', 'number').replace('--','');

                 system.debug('Latest Wrap'+ stringRequest);

                    // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
                    HttpResponse responseStr = (HttpResponse)ACET_ORSWebservice.updateORSIssue(stringRequest,issue.issueId);
                    if(responseStr.getStatusCode() != 200 && responseStr.getStatusCode() != 201) { //DE391654 - Sravan
                        UpdateCaseCommentsWrapper error = new UpdateCaseCommentsWrapper();
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
        }
            } else {
                UpdateCaseCommentsWrapper error = new UpdateCaseCommentsWrapper();
                error.responseStatus = selectIssuesResponse.getStatusCode();

                if(selectIssuesResponse.getStatusCode() == 400) {
                    error.responseStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                } else if(selectIssuesResponse.getStatusCode() == 404) {
                    error.responseStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                } else if(selectIssuesResponse.getStatusCode() == 500) {
                    error.responseStatusMessage = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                } else {
                    error.responseStatusMessage = 'Unexpected error occured. Error Code: ' + String.valueOf(selectIssuesResponse.getStatusCode());
                }
                errorList.add(error);
            }

            if(errorList.size() > 0) {
                returnList = errorList;
            } else {
                returnList.add(new UpdateCaseCommentsWrapper());
            }

            return returnList;
        }
        catch (Exception ex) {
            UpdateCaseCommentsWrapper error = new UpdateCaseCommentsWrapper();
            error.responseStatus = 999;
            error.responseStatusMessage = 'Unexpected error occured.';
            List<UpdateCaseCommentsWrapper> exceptionList = new List<UpdateCaseCommentsWrapper>();
            exceptionList.add(error);
            return exceptionList;
        }
    }

    @AuraEnabled
    public static List<CaseCommentWrapper> getCaseComments(String caseId)
    {
        List<CaseCommentWrapper> returnList = new List<CaseCommentWrapper>();
        List<CaseComment> comments = [SELECT Id, ParentId, CommentBody, CreatedById,CreatedBy.Name, CreatedDate,IsPublished 
                                        FROM CaseComment 
                                        WHERE ParentId= :caseId ORDER BY CreatedDate DESC];

        for (CaseComment cc : comments) {
            CaseCommentWrapper cw = new CaseCommentWrapper();
            cw.CaseId = cc.ParentId;
            cw.Com_UserId = cc.CreatedById;
            cw.Com_UserName = cc.CreatedBy.Name;
            cw.Com_CreatedDate = cc.CreatedDate.format('MM/dd/YYYY hh:mm aaa');
            cw.IsPublic = cc.IsPublished;
            cw.CommentBody = cc.CommentBody;

            returnList.add(cw);
        }

        return returnList;
    }

    // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
    public class UpdateCaseCommentsWrapper{
        @AuraEnabled public Integer responseStatus;
        @AuraEnabled public String responseStatusMessage;

        public UpdateCaseCommentsWrapper(){
            this.responseStatus = 200; this.responseStatusMessage = 'Success';
        }
    }

    public class CaseCommentWrapper
    {
        @AuraEnabled public String CaseId{get;set;}
        @AuraEnabled public String Com_UserId{get;set;}
        @AuraEnabled public String Com_UserName{get;set;}
        @AuraEnabled public String Com_CreatedDate{get;set;}
        @AuraEnabled public boolean IsPublic{get;set;}
        @AuraEnabled public String CommentBody{get;set;}
    }

    public class feedback
    {
        @AuraEnabled public boolean success{get;set;}
        @AuraEnabled public String message{get;set;}
    }
}