public with sharing class ACETGetMembershipWebService extends ACETWebService{
    private Map<String,String> EligibilityCodeVsStatusMap;
    public Map<String, String> PlanTypeCodeMap {get; set;}
    
    public ACETGetMembershipWebService(){
        super('Stargate');
        EligibilityCodeVsStatusMap = new Map<String,String>();
        EligibilityCodeVsStatusMap.put('A','ACTIVE');
        EligibilityCodeVsStatusMap.put('C','COBRA');
        EligibilityCodeVsStatusMap.put('S','SURVIVING INSURED');
        EligibilityCodeVsStatusMap.put('T','TEFRA');
        EligibilityCodeVsStatusMap.put('','');
        
        PlanTypeCodeMap = new Map<String,String>();
        PlanTypeCodeMap.put('01','EPO');
        PlanTypeCodeMap.put('02','HMO');
        PlanTypeCodeMap.put('03','Indemnity');
        PlanTypeCodeMap.put('05','POS');
        PlanTypeCodeMap.put('06','PPO');
    }
    public override void getEndpoint(){
        GetEndpointDetail('GetMembershipEndpoint');
    }
    public void getRequestBody(String identifier, String groupNumber){
        RequestBody = '{"getMembershipRequest" : {"identifier" : "'+identifier+'","identifierType" : "SRK","groupNumber" : "'+groupNumber+'"}}';              
    } 
 
    public ACETWSCalloutResult getMembership(String memberId, String customerAccountId, ACETMemberDetail memberDetail){               
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }            
        getEndpoint();
        getRequestBody(MemberDetail.SurrogateKey,customerAccountId);
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{

            HttpResponse response;
            if(!Test.isRunningTest()){
            response = Send(OAuthConfig); 
            }
            else{
                response=new HttpResponse();
                response.setStatuscode(200);
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1260145","groupName":"HR NUCLEUS","parentGroupNumber":"","parentGroupName":"","inheritParentMemGroupConfigInd":"","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000833","benefitPlanName":"CT_LG_DIRECT HSA_18HSA01","benefitType":"MD","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006","productName":"OHI Oxford Direct"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"96432336200","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{"holdCode":"MBBG","holdDescription":"Member Bill Group Invoice","holdEligibilityIndicator":"false","holdLevel":"MEMBER"}],"memberDirectBillingInd":false,"linkedSubscriberId":"","indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000018","benefitPlanName":"LG $5/$30/$60 Traditional","benefitType":"RX","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006","productName":"OHI Oxford Direct"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"96432336200","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"03","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{"holdCode":"MBBG","holdDescription":"Member Bill Group Invoice","holdEligibilityIndicator":"false","holdLevel":"MEMBER"}],"memberDirectBillingInd":false,"linkedSubscriberId":"","indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{"providerIdentifiers":[{"id":"901655773","type":"SSN"},{"id":"5109937","type":"MPI"},{"id":"H505770","type":"1C"},{"id":"1609197888","type":"NPI"},{"id":"125746197655054630","type":"LTK"},{"id":"P5062197","type":"PUL"}],"assignmentType":"OBGYN","effectiveDate":"2021-04-05","expirationDate":"9999-12-31","firstName":"KATIE","lastName":"PROPST","networkId":"0","organizationLocationId":"0","locationAffiliationId":"58071364","address1":"111 PARK ST","address2":"","address3":"","address4":"","address5":"","city":"HARTFORD","state":"CT","postalCode":"06106-2520","country":"US"},{"providerIdentifiers":[{"id":"5289425","type":"MPI"},{"id":"D400236068","type":"1C"},{"id":"PENDING","type":"1C"},{"id":"598848577055736089","type":"LTK"},{"id":"P5138634","type":"PUL"},{"id":"1821232034","type":"NPI"},{"id":"722067031","type":"SSN"}],"assignmentType":"PCP","effectiveDate":"2021-05-05","expirationDate":"9999-12-31","firstName":"THOMAS","lastName":"ABBENANTE","networkId":"0","organizationLocationId":"0","locationAffiliationId":"60462012","address1":"279 CHASE AVE","address2":"","address3":"","address4":"","address5":"","city":"WATERBURY","state":"CT","postalCode":"06704-2236","country":"US"}],"identifiers":[{}]}}}');
            }
            //response.setStatusCode(400);
            if(response!=null){
            calloutResult.statusCode=response.getStatusCode();

            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                         String responseBody = response.getBody().contains('\"type\":')?response.getBody().replace('\"type\":', '\"type_z\":'):response.getBody();
                         responseBody = responseBody.replace('\"id\":', '\"id_z\":');    
                         ACETGetMembershipJSON2ApexADP jSON2Apex = (ACETGetMembershipJSON2ApexADP)JSON.deserialize(responseBody, ACETGetMembershipJSON2ApexADP.class);
                         system.debug('JSON2Apex : ' + jSON2Apex);
                         ACETGetMembershipJSON2ApexADP.cls_membership Membership = jSON2Apex.getMembershipResponse != null ? jSON2Apex.getMembershipResponse.membership : null;
                         if(Membership != null){
                             for(ACETGetMembershipJSON2ApexADP.cls_coverages coverage : Membership.coverages ){
                                 if(coverage.bundleOptions != null && !(coverage.bundleOptions).isEmpty()){
                                     List<ACETGetMembershipJSON2ApexADP.cls_bundleOptions> bundleOptions = coverage.bundleOptions;
                                     for(ACETGetMembershipJSON2ApexADP.cls_bundleOptions bundleoption : bundleOptions){
                                         if(bundleoption.benefits != null && !bundleoption.benefits.isEmpty()){
                                             for(ACETGetMembershipJSON2ApexADP.cls_benefits benefit : bundleoption.benefits){
                                                 system.debug('>> '+benefit.indicators);
                                                String benefitEffDate = String.isNotBlank(benefit.benefitEffectiveDate)?String.valueof(ACETUtility.format(Date.valueof(benefit.benefitEffectiveDate))):'';
                                                String benefitEndDate = String.isNotBlank(benefit.benefitExpirationDate)?String.valueof(ACETUtility.format(Date.valueof(benefit.benefitExpirationDate))):'';
                                                Date newEffectiveDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[1]));
                                                Date newEndDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[1]));
                                                    
                                                system.debug('Effective'+newEffectiveDate+'//'+benefitEffDate+'//Ben End'+benefitEndDate+benefit.benefitEffectiveDate+benefit.benefitExpirationDate);
                                                
                                                if(memberDetail.PreferredCoverage.benefitPlanId == benefit.benefitPlanId &&
                                                   memberDetail.PreferredCoverage.coverageMemberId == benefit.memberIdCardSerialNumber &&
                                                   ((Date.ValueOf(newEffectiveDate) >= Date.valueof(benefit.benefitEffectiveDate) &&
                                                     benefitEffDate !='' && String.isNotBlank(benefit.benefitEffectiveDate) &&
                                                     benefitEndDate == '12/31/9999')||
                                                             (benefitEndDate != '' && String.isNotBlank(benefit.benefitExpirationDate) && benefitEndDate != '12/31/9999' && Date.valueof(benefit.benefitEffectiveDate) <= Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEffectiveDate) <= Date.valueof(benefit.benefitExpirationDate) ))){
                                                    //memberDetail.OriginatorRelationShip = ACETRelationshipCodes__c.getValues('18').Description__c;
                                                     system.debug('got match');
                                                     memberDetail.RelationShip = String.isNotBlank(benefit.relationshipCode)?ACETRelationshipCodes__c.getValues(benefit.relationshipCode).Description__c:'';
                                                      memberDetail.RelationShipCode = String.isNotBlank(benefit.relationshipCode)?benefit.relationshipCode:'';
                                                     memberDetail.BenefitPlanId = benefit.benefitPlanId;
                                                     if(String.isBlank(memberDetail.benefitPlanId) ){
                                                        calloutResult.statusCode=212;//212-->Note that all information may not have loaded on the page. Continue to service the call following your normal protocols
                                                     }
                                                     memberDetail.QMSCOIndicator = benefit.indicators != null && benefit.indicators.qmscoindicator != null ? (benefit.indicators.qmscoIndicator.equals('Y') ? 'Yes' : 'No') : 'No';
                                                     memberDetail.Network = (benefit.networkScheduleID != null)?benefit.networkScheduleID:'';
                                                     //Field mapping added by Avish for getSubscription webservice User Stroy US652217 field mapping on 06072017
                                                     memberDetail.BundleOptionID = benefit.benefitBundleOptionId;
                                                     memberDetail.hsaAvailable = (benefit.indicators != null && benefit.indicators.hsaIndicator != null)?(benefit.indicators.hsaIndicator.equals('Y') ? 'Yes' : 'No'):'No';
                                                     //Rama:Added to get the coverage level from getMembeship   
                                                     memberDetail.CoverageLevelCode = (benefit.coverageLevelCode!= Null) && String.isNotBlank(benefit.coverageLevelCode)?benefit.coverageLevelCode:'';                                                      
                                                     system.debug('CoverageLevelCode***'+memberDetail.CoverageLevelCode);
                                                     memberDetail.MemberStatus = coverage.memberStatus;
                                                     memberDetail.TerminationReason = String.isNotBlank(benefit.cancelReasonTypeCode)?benefit.cancelReasonTypeCode:'';
                                                     //Added by Avish on 11/15/2017 as a part of US809970
                                                     memberDetail.EligibilityStatus = (benefit.eligibilityStatusCode != Null) && String.isNotBlank(benefit.eligibilityStatusCode)?((EligibilityCodeVsStatusMap.get(benefit.eligibilityStatusCode) == 'COBRA' || EligibilityCodeVsStatusMap.get(benefit.eligibilityStatusCode) == 'SURVIVING INSURED')?EligibilityCodeVsStatusMap.get(benefit.eligibilityStatusCode):''):'';
                                                     memberDetail.PlanType = (benefit.planType != Null) && String.isNotBlank(benefit.planType)?PlanTypeCodeMap.get(benefit.planType):'';
                                                     memberDetail.FundingArragement = String.isNotBlank(benefit.fundingArrangementDescription)?benefit.fundingArrangementDescription:'';
                                                     if(benefit.coverageLevelList!=null && !benefit.coverageLevelList.isEmpty()){
                                                     memberDetail.lstCoverageLineHistory = new List<ACETMemberDetail.CoverageLineHistory>();
                                                         for(ACETGetMembershipJSON2ApexADP.cls_coverageLevelList coverageList : benefit.coverageLevelList){
                                                             ACETMemberDetail.CoverageLineHistory clh = new ACETMemberDetail.CoverageLineHistory();   
                                                             clh.covLevelCode = String.isNotBlank(coverageList.covLevelCode)?coverageList.covLevelCode:'';
                                                             clh.covLevelDesc = String.isNotBlank(coverageList.covLevelDesc)?coverageList.covLevelDesc:'';
                                                             string effd = String.isNotBlank(coverageList.covLevelEffDate)?coverageList.covLevelEffDate:'';
                                                             string exd = String.isNotBlank(coverageList.covLevelExpDate)?coverageList.covLevelExpDate:'';
                                                             if(String.isNotBlank(effd))
                                                                 clh.covLevelEffDate = Date.newInstance(Integer.valueOf(effd.split('-')[0]), Integer.valueOf(effd.split('-')[1]), Integer.valueOf(effd.split('-')[2]));
                                                             if(String.isNotBlank(exd))
                                                             clh.covLevelExpDate= Date.newInstance(Integer.valueOf(exd.split('-')[0]), Integer.valueOf(exd.split('-')[1]), Integer.valueOf(exd.split('-')[2]));
                                                             memberDetail.lstCoverageLineHistory.add(clh);  
                                                         }
                                                     }
                                                     break;
                                                 }
                                             }
                                         }
                                     }
                                 }                          

                             system.debug('----------Membership.providers---------->'+Membership.providers);
                             memberDetail.PCPAssignments = new List<ACETMemberDetail.PCPAssignment>();
                             for(ACETGetMembershipJSON2ApexADP.cls_providers provider : Membership.providers ){
                                 system.debug('----------ACETMemberDetail---------->'+provider);
                                 ACETMemberDetail.PCPAssignment pcp = new ACETMemberDetail.PCPAssignment();
                                 pcp.FirstName = String.isNotBlank(provider.firstName)?provider.firstName:'';  
                                 pcp.LastName = String.isNotBlank(provider.lastName)?provider.lastName:'';
                                 pcp.locationAffiliationID = String.isNotBlank(provider.locationAffiliationID)?provider.locationAffiliationID:'27109358';

                                 //if(provider.providerIdentifiers != null){
                                     for(ACETGetMembershipJSON2ApexADP.cls_providerIdentifiers ppi : provider.providerIdentifiers){                              
                                         if(ppi.type_z == 'NPI'){
                                             pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:'';  
                                         }
                                         if(ppi.type_z == 'LTK' && (pcp.id == null || pcp.id == '')){
                                             pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:'';  
                                         }                                   
                                     } 
                                 //}
                                                            

                                 pcp.pcpAssignmentType = String.isNotBlank(provider.assignmentType)?provider.assignmentType:'';
                                 system.debug('----Dates---->'+provider.effectiveDate+'-----Today----->'+Date.Today());
                                 if(provider.expirationDate != null && provider.expirationDate != ''){
                                     pcp.endDate = formatdate(provider.expirationDate); 
                                     pcp.isActive = isActive(provider.expirationDate);         
                                 }                         
                                 //memberDetail.Network = OIL Gap
                                 if(provider.effectiveDate != null && provider.effectiveDate != '')
                                     pcp.effectiveDate = formatdate(provider.effectiveDate);
                                 // pcp.effectiveDate = date.parse('2016-01-01 00:00:00');
                                 system.debug('----Dates---->'+pcp.effectiveDate+'-----Today----->'+Date.Today()); 
                                 memberDetail.PCPAssignments.add(pcp);
                             } 
                         }
                         calloutResult.Success = true;
                         calloutResult.Message = '';
                         calloutResult.Response = memberDetail;
                     }
            }else if(response.getStatusCode() == 500){                
                //currently servce returns 500 if no records found
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = true;                
                calloutResult.Response = new ACETMemberDetail();
                system.debug(calloutResult);                
             }
            }
           }
            
         else{//When Response is null
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
         }
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;

        }

        return calloutResult;    
    } 

    //to remove to global util class
    public String formatDate(String dateString){
      try{
        if(String.isBlank(dateString)) return null;

        List<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];

            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 

            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
      }catch(Exception e){
          System.debug('Exception Happened='+e); 
          return null;
      }
        
    }

    public String getAgeFromBirthday(String birthDate){
      try{
        if(String.isBlank(birthDate)) return null;
        Date d = Date.valueOf(birthDate);
        return String.valueOf(d.daysBetween(Date.today())/365);
        }catch(Exception e){
          System.debug('Exception Happened='+e); 
          return null;
      }
    }

    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';

        return 'xxx-xx-' + ssn.substring(ssn.length() - 4);
    }
    public Continuation StartRequest(String memberId, String customerAccountId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {   
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }                
        getEndpoint();
        getRequestBody(MemberDetail.SurrogateKey,customerAccountId);
        
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        system.debug('CallbackMethodName'+ CallbackMethodName + oContinuation);
        return oContinuation;         
    } 
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){              
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }   
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            system.debug('MemberDetail before exception '+Memberdetail);
            HttpResponse response;
            if(!Test.isRunningTest()){
            response = Send(OAuthConfig); 
            }
            else{
                response=new HttpResponse();
                response.setStatuscode(200);
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1260145","groupName":"HR NUCLEUS","parentGroupNumber":"","parentGroupName":"","inheritParentMemGroupConfigInd":"","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000833","benefitPlanName":"CT_LG_DIRECT HSA_18HSA01","benefitType":"MD","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006","productName":"OHI Oxford Direct"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"96432336200","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{"holdCode":"MBBG","holdDescription":"Member Bill Group Invoice","holdEligibilityIndicator":"false","holdLevel":"MEMBER"}],"memberDirectBillingInd":false,"linkedSubscriberId":"","indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000018","benefitPlanName":"LG $5/$30/$60 Traditional","benefitType":"RX","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006","productName":"OHI Oxford Direct"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"96432336200","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"03","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{"holdCode":"MBBG","holdDescription":"Member Bill Group Invoice","holdEligibilityIndicator":"false","holdLevel":"MEMBER"}],"memberDirectBillingInd":false,"linkedSubscriberId":"","indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{"providerIdentifiers":[{"id":"901655773","type":"SSN"},{"id":"5109937","type":"MPI"},{"id":"H505770","type":"1C"},{"id":"1609197888","type":"NPI"},{"id":"125746197655054630","type":"LTK"},{"id":"P5062197","type":"PUL"}],"assignmentType":"OBGYN","effectiveDate":"2021-04-05","expirationDate":"9999-12-31","firstName":"KATIE","lastName":"PROPST","networkId":"0","organizationLocationId":"0","locationAffiliationId":"58071364","address1":"111 PARK ST","address2":"","address3":"","address4":"","address5":"","city":"HARTFORD","state":"CT","postalCode":"06106-2520","country":"US"},{"providerIdentifiers":[{"id":"5289425","type":"MPI"},{"id":"D400236068","type":"1C"},{"id":"PENDING","type":"1C"},{"id":"598848577055736089","type":"LTK"},{"id":"P5138634","type":"PUL"},{"id":"1821232034","type":"NPI"},{"id":"722067031","type":"SSN"}],"assignmentType":"PCP","effectiveDate":"2021-05-05","expirationDate":"9999-12-31","firstName":"THOMAS","lastName":"ABBENANTE","networkId":"0","organizationLocationId":"0","locationAffiliationId":"60462012","address1":"279 CHASE AVE","address2":"","address3":"","address4":"","address5":"","city":"WATERBURY","state":"CT","postalCode":"06704-2236","country":"US"}],"identifiers":[{}]}}}');
            }
            system.debug('call out done');
           if(response!=null){
            //response.setStatusCode(500);
            calloutResult.statusCode=response.getStatusCode();
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                         String responseBody = response.getBody().contains('\"type\":')?response.getBody().replace('\"type\":', '\"type_z\":'):response.getBody();
                         responseBody = response.getBody().contains('\"id\":')?responseBody.replace('\"id\":', '\"id_z\":'):response.getBody();   
                         ACETGetMembershipJSON2ApexADP jSON2Apex = (ACETGetMembershipJSON2ApexADP)JSON.deserialize(responseBody, ACETGetMembershipJSON2ApexADP.class);
                         system.debug('JSON2Apex : ' + jSON2Apex);
                         ACETGetMembershipJSON2ApexADP.cls_membership Membership = jSON2Apex.getMembershipResponse != null ? jSON2Apex.getMembershipResponse.membership : null;
                         if(Membership != null){
                             for(ACETGetMembershipJSON2ApexADP.cls_coverages coverage : Membership.coverages ){
                                 if(coverage.bundleOptions != null && !(coverage.bundleOptions).isEmpty()){
                                     List<ACETGetMembershipJSON2ApexADP.cls_bundleOptions> bundleOptions = coverage.bundleOptions;
                                     for(ACETGetMembershipJSON2ApexADP.cls_bundleOptions bundleoption : bundleOptions){
                                         if(bundleoption.benefits != null && !bundleoption.benefits.isEmpty()){
                                             for(ACETGetMembershipJSON2ApexADP.cls_benefits benefit : bundleoption.benefits){
                                                 system.debug('memberDetail.PreferredCoverage.benefitPlanId >>> '+memberDetail.PreferredCoverage.benefitPlanId);
                                                 system.debug('benefit.benefitPlanId >>> '+benefit.benefitPlanId);
                                                 system.debug('benefit.benefitBundleOptionId >>> '+benefit.benefitBundleOptionId);
                                                 String benefitEffDate = String.isNotBlank(benefit.benefitEffectiveDate)?String.valueof(ACETUtility.format(Date.valueof(benefit.benefitEffectiveDate))):'';
                                                String benefitEndDate = String.isNotBlank(benefit.benefitExpirationDate)?String.valueof(ACETUtility.format(Date.valueof(benefit.benefitExpirationDate))):'';
                                                Date newEffectiveDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[1]));
                                                Date newEndDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[1]));
                                                    
                                                system.debug('Effective'+newEffectiveDate+'//'+benefitEffDate+'//Ben End'+benefitEndDate+benefit.benefitEffectiveDate+benefit.benefitExpirationDate);
                                                
                                                if(memberDetail.PreferredCoverage.benefitPlanId == benefit.benefitPlanId && memberDetail.PreferredCoverage.coverageMemberId == benefit.memberIdCardSerialNumber && ((Date.ValueOf(newEffectiveDate) >= Date.valueof(benefit.benefitEffectiveDate) && benefitEffDate !='' && String.isNotBlank(benefit.benefitEffectiveDate) && benefitEndDate == '12/31/9999')||
                                                             (benefitEndDate != '' && String.isNotBlank(benefit.benefitExpirationDate)&& benefitEndDate != '12/31/9999' && Date.valueof(benefit.benefitEffectiveDate) <= Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEffectiveDate) <= Date.valueof(benefit.benefitExpirationDate) ))){
                                                    //memberDetail.OriginatorRelationShip = ACETRelationshipCodes__c.getValues('18').Description__c;
                                                     system.debug('got match');
                                                     memberDetail.MemberId = String.isNotBlank(benefit.memberIdCardSerialNumber)?benefit.memberIdCardSerialNumber:'' ;
                                                     if(String.isBlank(memberDetail.MemberId) ){
                                                         calloutResult.statusCode=212;//212-->Note that all information may not have loaded on the page. Continue to service the call following your normal protocols
                                                     }
                                                     memberDetail.RelationShip = String.isNotBlank(benefit.relationshipCode)?ACETRelationshipCodes__c.getValues(benefit.relationshipCode).Description__c:'';
                                                     memberDetail.RelationShipCode = String.isNotBlank(benefit.relationshipCode)?benefit.relationshipCode:'';
                                                     memberDetail.BenefitPlanId = String.isNotBlank(benefit.benefitPlanId)?benefit.benefitPlanId:'';
                                                     if(String.isBlank(memberDetail.benefitPlanId) ){
                                                        calloutResult.statusCode=212;//212-->Note that all information may not have loaded on the page. Continue to service the call following your normal protocols
                                                     }
                                                     memberDetail.QMSCOIndicator = benefit.indicators != null && benefit.indicators.qmscoindicator != null ? (benefit.indicators.qmscoIndicator.equals('Y') ? 'Yes' : 'No') : 'No';
                                                     //Field mapping added by Avish for getSubscription webservice User Stroy US652217 field mapping on 06072017
                                                     memberDetail.BundleOptionID = String.isNotBlank(benefit.benefitBundleOptionId)?benefit.benefitBundleOptionId:'';     
                                                     memberDetail.hsaAvailable = (benefit.indicators != null && benefit.indicators.hsaIndicator != null)?(benefit.indicators.hsaIndicator.equals('Y') ? 'Yes' : 'No'):'No';
                                                        //Rama:Added to get the coverage level from getMembeship   
                                                     memberDetail.CoverageLevelCode = (benefit.coverageLevelCode!= Null) && String.isNotBlank(benefit.coverageLevelCode)?benefit.coverageLevelCode:'';                                                          
                                                     system.debug('CoverageLevelCode***'+memberDetail.CoverageLevelCode);
                                                     memberDetail.Network = (benefit.networkScheduleID != null)?benefit.networkScheduleID:'';
                                                     memberDetail.MemberStatus = String.isNotBlank(coverage.memberStatus)?coverage.memberStatus:'';
                                                     memberDetail.TerminationReason = String.isNotBlank(benefit.cancelReasonTypeCode)?benefit.cancelReasonTypeCode:'';
                                                     //Added by Avish on 11/15/2017 as a part of US809970
                                                     memberDetail.EligibilityStatus = (benefit.eligibilityStatusCode != Null) && String.isNotBlank(benefit.eligibilityStatusCode)?((EligibilityCodeVsStatusMap.get(benefit.eligibilityStatusCode) == 'COBRA' || EligibilityCodeVsStatusMap.get(benefit.eligibilityStatusCode) == 'SURVIVING INSURED')?EligibilityCodeVsStatusMap.get(benefit.eligibilityStatusCode):''):'';
                                                     memberDetail.PlanType = (benefit.planType != Null) && String.isNotBlank(benefit.planType)?PlanTypeCodeMap.get(benefit.planType):'';
                                                     memberDetail.FundingArragement = String.isNotBlank(benefit.fundingArrangementDescription)?benefit.fundingArrangementDescription:'';
                                                     if(benefit.coverageLevelList!=null && !benefit.coverageLevelList.isEmpty()){
                                                     memberDetail.lstCoverageLineHistory = new List<ACETMemberDetail.CoverageLineHistory>();
                                                         for(ACETGetMembershipJSON2ApexADP.cls_coverageLevelList coverageList : benefit.coverageLevelList){
                                                             ACETMemberDetail.CoverageLineHistory clh = new ACETMemberDetail.CoverageLineHistory();   
                                                             clh.covLevelCode = String.isNotBlank(coverageList.covLevelCode)?coverageList.covLevelCode:'';
                                                             clh.covLevelDesc = String.isNotBlank(coverageList.covLevelDesc)?coverageList.covLevelDesc:'';
                                                             string effd = coverageList.covLevelEffDate;
                                                             string exd = coverageList.covLevelExpDate;
                                                             if(String.isNotBlank(effd))
                                                                 clh.covLevelEffDate = Date.newInstance(Integer.valueOf(effd.split('-')[0]), Integer.valueOf(effd.split('-')[1]), Integer.valueOf(effd.split('-')[2]));
                                                             if(String.isNotBlank(exd))
                                                                 clh.covLevelExpDate= Date.newInstance(Integer.valueOf(exd.split('-')[0]), Integer.valueOf(exd.split('-')[1]), Integer.valueOf(exd.split('-')[2]));
                                                             memberDetail.lstCoverageLineHistory.add(clh); 
                                                             //memberDetail.GatedPlan = 'sjain';//coverageList.GatedPlan;
                                                         }
                                                     }
                                                     break;
                                                 }
                                             }
                                         }
                                     }
                                 }
                         
                             } 




                             system.debug('----------Membership.providers---------->'+Membership.providers);
                             memberDetail.PCPAssignments = new List<ACETMemberDetail.PCPAssignment>();
                             for(ACETGetMembershipJSON2ApexADP.cls_providers provider : Membership.providers ){
                                 ACETMemberDetail.PCPAssignment pcp = new ACETMemberDetail.PCPAssignment();


                                 pcp.FirstName = String.isNotBlank(provider.firstName)?provider.firstName:'';  
                                 pcp.LastName = String.isNotBlank(provider.lastName)?provider.lastName:'';
                                 pcp.pcpAssignmentType = String.isNotBlank(provider.assignmentType)?provider.assignmentType:'';
                                 pcp.locationAffiliationID = String.isNotBlank(provider.locationAffiliationID)?provider.locationAffiliationID:''; //27109358 - Added by Avish 09/10/2018
                                 if(provider.providerIdentifiers != null){


                                     for(ACETGetMembershipJSON2ApexADP.cls_providerIdentifiers ppi : provider.providerIdentifiers){                              
                                         if(ppi.type_z == 'NPI'){
                                             pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:'';  
                                         }
                                         if(ppi.type_z == 'LTK' && (pcp.id == null || pcp.id == '')){
                                             pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:''; 
                                         }                                   
                                     }
                                 }
                                 /*    if(provider.expirationDate != '' && provider.expirationDate != null){
                                pcp.endDate = null;//date.parse(provider.expirationDate);
                            } */

                                 //memberDetail.Network = OIL Gap
                                 system.debug('----Dates---->'+provider.effectiveDate+'-----Today----->'+Date.Today());
                                 if(provider.expirationDate != null && provider.expirationDate != ''){
                                     pcp.endDate = formatdate(provider.expirationDate); 
                                     pcp.isActive = isActive(provider.expirationDate);         
                                 }               
                                 //memberDetail.Network = OIL Gap
                                 if(provider.effectiveDate != null && provider.effectiveDate != '')
                                     pcp.effectiveDate = formatdate(provider.effectiveDate);
                                 //  pcp.effectiveDate = date.parse('05/05/2017');
                                 system.debug('----Dates---->'+pcp.effectiveDate+'-----Today----->'+Date.Today());
                                 if(!String.IsEmpty(provider.firstName) && !String.IsEmpty(provider.lastName) && !String.IsEmpty(provider.assignmentType) && !String.IsEmpty(provider.effectiveDate) && !String.IsEmpty(provider.expirationDate)){
                                     memberDetail.PCPAssignments.add(pcp);   
                                 }

                             }
                             system.debug('----------memberDetail.PCPAssignments---------->'+memberDetail.PCPAssignments); 
                         }
                         calloutResult.Success = true;
                         calloutResult.Message = '';
                         calloutResult.Response = memberDetail; 
                }

            }else {
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;                
                calloutResult.Response = memberDetail;
                calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
            }
           }
           else{//response is null
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999; 
           }
        }catch(Exception e){
            system.debug('MemberDetail afer exception '+Memberdetail);
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;

        }

        return calloutResult;    
    } 
    public boolean isActive(String expdate){
        if(!String.IsEmpty(expdate)){
            system.debug('expdate' + expdate);
            Date d = Date.valueOf(expdate);
            return d > date.today();
        }
        else
        {
            return false;

        }       
    }     
}