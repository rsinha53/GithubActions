public class ACETORSUpdateRequestJSON {
    
    public static string getORSUpdateRequestBody(String callerfirstname,String updateType,String updateTime,String updateDate,String contactmethodCode,String directionCode,String originatorTypeCode,String[] searchInputParams,String issueId,String[] commentSized){
        ACET_ORSRequest.Pcp providerInfo_sub = new ACET_ORSRequest.Pcp();
                providerInfo_sub.firstName = '';
                providerInfo_sub.lastName = '';
                providerInfo_sub.firstInitial = '';
                providerInfo_sub.mpin = '';
                providerInfo_sub.providerID = '';
                providerInfo_sub.state = '';
                providerInfo_sub.street1 = '';
                providerInfo_sub.street2 = '';
                providerInfo_sub.zip = '';
                providerInfo_sub.taxId = '';
                providerInfo_sub.taxPrefix = '';
                providerInfo_sub.taxSuffix = '';

                // Provider Details
                ACET_ORSRequest.Provider providerInfo = new ACET_ORSRequest.Provider();
                providerInfo.commonProviderID = '';
                providerInfo.contractNumber = '';
                providerInfo.degreeName = '';
                providerInfo.ipa = '';
                providerInfo.npis = new List<String>{''};
                providerInfo.tpsmIndicator = '';
                providerInfo.phoneNumber = '';
                providerInfo.provider = providerInfo_sub;
                providerInfo.pcp = new ACET_ORSRequest.Pcp();
                providerInfo.providerValidatedFlag = '';

                ACET_ORSRequest.DependentName callerName = new ACET_ORSRequest.DependentName();
                callerName.firstName = callerfirstname;
                callerName.lastName = '';

                ACET_ORSRequest.Originator originator = new ACET_ORSRequest.Originator();
                originator.providerId = '';
                originator.callerName = callerName;
                originator.originatorTin = '';
                originator.originatorTinSuffix = '';
                originator.callerAddress = new ACET_ORSRequest.CallerAddress();
                originator.autoId = '';

                ACET_ORSRequest.Other other = new ACET_ORSRequest.Other();
                other.agencyName = '';

                ACET_ORSRequest.EmployerInfo empInfp = new ACET_ORSRequest.EmployerInfo();
                empInfp.employerName = '';
                empInfp.employerNumber = '';
                empInfp.employerState = '';

                ACET_ORSRequest.Member member = new ACET_ORSRequest.Member();
                member.age = '';
                member.alternateId = '';
                member.benefitPackageCode = '';
                member.dateOfBirth = '';
                member.dateOfDeath = '';
                member.city = '';
                member.countryCode = '';
                member.neonIndicator = '';
                member.memberNumber = '';
                member.groupNumber = '';
                member.policy = '';
                member.alternateId = '';
                member.benefitPackageCode = '';
				
        
                // Issue main object
                ACET_ORSRequest.Issue issue = new ACET_ORSRequest.Issue();
                issue.updateType = updateType;
        		issue.updateTime =updateTime;
                issue.updateDate = updateDate;
                issue.provider = providerInfo;
                issue.contactMethodCode = contactmethodCode;
        		issue.directionCode = directionCode;
                issue.createdByApplicationIndicator = '';
        		issue.modifiedByApplicationIndicator = 'H';
                issue.originatorTypeCode = originatorTypeCode;
                issue.originator = originator;
                issue.issueId = issueId;
                issue.other = other;
                issue.comments = commentSized;
       			issue.contactElapseTime = '';
                issue.contactId = '';
                issue.followupDate = '';
                issue.employerInfo = empInfp;
                issue.member = member;
                issue.carbonCopies = new List<ACET_ORSRequest.CarbonCopies>{new ACET_ORSRequest.CarbonCopies()};
                issue.claim = new ACET_ORSRequest.Claim();
                issue.followUp = new ACET_ORSRequest.FollowUp();
                issue.logoLookups = new List<ACET_ORSRequest.LogoLookups>{new ACET_ORSRequest.LogoLookups()};
                issue.routedTo = new ACET_ORSRequest.Creator();
                issue.resolvedBy = new ACET_ORSRequest.Creator();
                issue.serviceRequest =  new ACET_ORSRequest.ServiceRequest();
                issue.priority = '';
                issue.status = '';
                issue.caseNumber = '';
				
                
        		
                ACET_ORSRequest.OrsSystemParameter sysPar = new ACET_ORSRequest.OrsSystemParameter();
                   sysPar.logonOffice = searchInputParams[0]; //'673';
                    sysPar.logonId = searchInputParams[1]; //'JR2';

			    ACET_ORSRequest.PostInput postInput = new ACET_ORSRequest.PostInput();
                postInput.issue = issue;
                postInput.orsSystemParameter = sysPar;

                ACET_ORSRequest acetORS = new ACET_ORSRequest();
                acetORS.postInput = postInput;

                String orsRequest = JSON.serialize(acetORS);
                //Overriding reserved keywords
                orsRequest = orsRequest.replace('\'','"').replace('null', '""').replace('number_Z', 'number').replace('--','');

        System.debug('orsRequest'+orsRequest);
		System.debug('RequestBody');
        return orsRequest;
    }

}