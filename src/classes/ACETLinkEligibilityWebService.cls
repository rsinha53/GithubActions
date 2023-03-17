/*
    Created By: Chandan Patro
    Created Date: 30th July 2019
    Description: This class is used to get all the data from Link Eligibility Api.
*/


public with sharing class ACETLinkEligibilityWebService {


    public map<String,String> setRelativeUrl(String searchOption,String firstName,String lastName,String payerID,String providerLastName,String providerNameID,String taxIdNumber,String dateOfBirth,String groupNumber,String memberId,String serviceStart,String serviceEnd){
        
        map<String,String> reqParaMap=new map<String,String>();
        reqParaMap.put('searchOption', searchOption);
        reqParaMap.put('firstName', firstName);
        reqParaMap.put('lastName', lastName);
        reqParaMap.put('payerID', payerID);
        reqParaMap.put('providerLastName', providerLastName);
        reqParaMap.put('providerNameID', providerNameID); //mod for provider details
        reqParaMap.put('taxIdNumber', taxIdNumber); //mod for provider details
        reqParaMap.put('dateOfBirth', dateOfBirth);
        reqParaMap.put('groupNumber', groupNumber);
        reqParaMap.put('memberId', memberId);
        reqParaMap.put('serviceStart', serviceStart);
        reqParaMap.put('serviceEnd', serviceEnd);
        //relativeUrl = addUrlParameters(reqParaMap);
        return reqParaMap;
    }
    /* Code Commented as its not required for ITE -Required for SAE
    public ACETWSCalloutResult getMemberWS(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID, String providerLastName, String providerFirstName, String npi){
      system.debug('memberId@@ ' + memberId + ' @@memberDOB@@ ' + memberDOB + ' @@@firstName ' + firstName + ' @@lastName@@ ' + lastName + ' @@groupNumber@@ ' + groupNumber + ' @@searchOption@@ ' + searchOption);
        String dateStr = ACETUtility.formatDateRequest(memberDOB);
        getEndpoint();
        setRelativeUrl(searchOption,firstName,lastName,'87726','LOTSOFF','DAVID','1205807328',dateStr,groupNumber,memberId,'','');
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETMemberSearchInteractionResult returnResponse = new ACETMemberSearchInteractionResult();
        try{
            HttpResponse response = Send(OAuthConfig,'LinkApi');
            System.debug('response='+response);
            String responseStr = '';
            StaticResource responseJSONSR = null;
            responseStr = response!=null?response.getBody():'';
            system.debug('ResponseBody** ' + responseStr);

            if(response!=null && response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    system.debug('responseJSONSR@@@ ' + responseJSONSR);
                    calloutResult.statusCode= response.getStatusCode();
                    AcetLinkEligibilityJSON2Apex json2Apex = AcetLinkEligibilityJSON2Apex.parse(responseStr);
                    List<AcetLinkEligibilityJSON2Apex.MemberPolicies> memberpolicies = new List<AcetLinkEligibilityJSON2Apex.MemberPolicies>();
                    List<ACETMemberSearchInteractionResult.memberProviderResult> wrapRespToreturn = new List<ACETMemberSearchInteractionResult.memberProviderResult>();
                    ACETMemberSearchInteractionResult.InteractionOverView interviewOverViewCard = new ACETMemberSearchInteractionResult.InteractionOverView();
                    ACETMemberSearchInteractionResult.InteractionSubjectCard subjectCard = new ACETMemberSearchInteractionResult.InteractionSubjectCard();
                    ACETMemberSearchInteractionResult.transactionIdResult transactionId = new ACETMemberSearchInteractionResult.transactionIdResult();
                    if(json2Apex != null){
                        if(json2Apex.memberPolicies != null){
                            memberpolicies = json2Apex.memberPolicies;
                            for(AcetLinkEligibilityJSON2Apex.MemberPolicies policies : memberpolicies){
                                if(policies.PolicyInfo != null){
                                    subjectCard.memberId = policies.PolicyInfo.memberId;
                                    wrapRespToreturn = returnResponseData(policies);
                                    break;
                                }

                            }
                            for(AcetLinkEligibilityJSON2Apex.MemberPolicies policies : memberpolicies){
                              if(policies.PolicyInfo != null){
                                    if(policies.PolicyInfo.policyStatus.contains('Active Policy') || policies.PolicyInfo.policyStatus.contains('active policy')){
                                        transactionId.memberId = policies.PolicyInfo.memberId;
                                        if(policies.transactionId != null){
                                        transactionId.transactionId = policies.transactionId;
                                        }
                                    }
                                }

                            }
                            returnResponse.transactionId = transactionId;
                            returnResponse.memberProviderResultlst = wrapRespToreturn;
                            system.debug('returnResponse.memberProviderResultlst@@@ ' + returnResponse.memberProviderResultlst);
                        }

                        if(json2Apex != null){
                            if(json2Apex.memberPolicies != null){
                                memberpolicies = json2Apex.memberPolicies;
                                for(AcetLinkEligibilityJSON2Apex.MemberPolicies policies : memberpolicies){
                                    if(policies.patientInfo != null){
                                        System.debug('policies.patientInfo@@@ ' + policies.patientInfo);
                                        for(AcetLinkEligibilityJSON2Apex.PatientInfo patientInfoObj : policies.patientInfo){
                                            if(patientInfoObj.searched == 'true'){
                                                if(string.isNotBlank(patientInfoObj.firstName) || string.isNotBlank(patientInfoObj.middleName) || string.isNotBlank(patientInfoObj.lastName) ){
                                                    subjectCard.subjectName = 'Subject'+' '+':'+' '+patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                                }
                                                if(string.isNotBlank(patientInfoObj.firstName) || string.isNotBlank(patientInfoObj.middleName) || string.isNotBlank(patientInfoObj.lastName) ){
                                                    subjectCard.memberName = patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                                }
                                                subjectCard.memberDOB = String.isNotBlank(patientInfoObj.dateOfBirth) ?  ACETUtility.formatDate(patientInfoObj.dateOfBirth) : '';
                                                subjectCard.gender = String.isNotBlank(patientInfoObj.gender) ? patientInfoObj.gender : '' ;
                                                subjectCard.relationship = String.isNotBlank(patientInfoObj.relationship) ? patientInfoObj.relationship : '' ;
                                                system.debug('gender**'+subjectCard.gender+'relation**'+subjectCard.relationship);
                                                subjectCard.age = Integer.valueOf(ACETUtility.getAgeFromBirthday(patientInfoObj.dateOfBirth));
                                                system.debug('subjectCard@@@ ' + subjectCard);
                                            }
                                        }
                                    }
                                    if(policies.insuranceInfo != null){
                                        subjectCard.groupNumber = String.isNotBlank(policies.insuranceInfo.groupNumber)?policies.insuranceInfo.groupNumber:'';
                                    }
                                }
                            }
                        }


                        //Code for requestingprovider
                        if(json2Apex.requestingProvider != null){
                            if(String.isNotBlank(json2Apex.requestingProvider.providerFirstName)){
                                interviewOverViewCard.name = json2Apex.requestingProvider.providerFirstName;
                                interviewOverViewCard.providerFN = json2Apex.requestingProvider.providerFirstName;
                            }
                            if(String.isNotBlank(json2Apex.requestingProvider.providerMiddleName)){
                                interviewOverViewCard.name = interviewOverViewCard.name + ' ' + json2Apex.requestingProvider.providerMiddleName;
                              interviewOverViewCard.providerMN = json2Apex.requestingProvider.providerMiddleName;
                            }

                            if(String.isNotBlank(json2Apex.requestingProvider.providerLastName)){
                                interviewOverViewCard.name = interviewOverViewCard.name + ' ' + json2Apex.requestingProvider.providerLastName;
                                interviewOverViewCard.providerLN = json2Apex.requestingProvider.providerLastName;
                            }
                            // interviewOverViewCard.name = json2Apex.requestingProvider.providerFirstName + ' ' + json2Apex.requestingProvider.providerMiddleName + ' ' + json2Apex.requestingProvider.providerLastName;
                            interviewOverViewCard.providerNameID = String.isNotBlank(json2Apex.requestingProvider.providerNameID)?json2Apex.requestingProvider.providerNameID:'';
                            interviewOverViewCard.taxidTIN = String.isNotBlank(json2Apex.requestingProvider.taxIdNumber)?json2Apex.requestingProvider.taxIdNumber:'';
                            interviewOverViewCard.npi = String.isNotBlank(json2Apex.requestingProvider.npi)?json2Apex.requestingProvider.npi:'';
                            interviewOverViewCard.healthCareSys = String.isNotBlank(json2Apex.requestingProvider.organizationName)?json2Apex.requestingProvider.organizationName:'';
                        }
                        //Code ends here
                        returnResponse.interactionView = interviewOverViewCard;
                        returnResponse.subjectCard = subjectCard;
                        System.debug('returnResponse@@@ ' + returnResponse.interactionView);
                        calloutResult.Success = true;
                        calloutResult.Message = 'GN400';
                        calloutResult.Response = returnResponse;
                    }
                }
            }
            else{
                system.debug('Error@@@ ' + response.getBody());
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false;
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                // US1813580 - Error Message Translation - Begin
                if(response.getStatusCode() == 400)
                {
                    System.debug('@@@ responseStr 400: ' + responseStr);
                    Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(responseStr);
                    String faultCode = (String) httpResponseJSON.get('faultCode');
                    System.debug('@@@ fault code 400: ' + faultCode);
                    if (faultCode != null && (faultCode.containsIgnoreCase('AAA:58') || faultCode.containsIgnoreCase('AAA:72')
                        || faultCode.containsIgnoreCase('AAA:73') || faultCode.containsIgnoreCase('AAA:76'))) { // == 'AAA:72'
                        calloutResult.Message = (String) httpResponseJSON.get('message');
                    } else {
                        calloutResult.Message = ACETLinkEligibilityWebService.getErrorMessage(SAEConstants.GN400);
                    }
                }
                else if(response.getStatusCode() == 500)
                {
                    calloutResult.Message = ACETLinkEligibilityWebService.getErrorMessage(SAEConstants.GN500A);
                }
                else if(response.getStatusCode() == 404)
                {
                    calloutResult.Message = ACETLinkEligibilityWebService.getErrorMessage(SAEConstants.GN404);
                }
                else
                {
                    calloutResult.Message = ACETLinkEligibilityWebService.getErrorMessage(SAEConstants.GN500A);
                    calloutResult.statusCode = 999;
                }
                // End
                calloutResult.Response = new ACETMemberSearchInteractionResult();
                system.debug(calloutResult);
            }
        }catch(Exception e){
                    system.debug(e.getStackTraceString());
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                    calloutResult.statusCode=999;
           }
        system.debug('calloutResult@@@ ' + calloutResult);
        return calloutResult;
    }

    private static List<ACETMemberSearchInteractionResult.memberProviderResult> returnResponseData(AcetLinkEligibilityJSON2Apex.MemberPolicies pat){
        ACETMemberSearchInteractionResult.memberProviderResult returnObj = new ACETMemberSearchInteractionResult.memberProviderResult();
        List<ACETMemberSearchInteractionResult.memberProviderResult> wrapperLst = new List<ACETMemberSearchInteractionResult.memberProviderResult>();
        List<AcetLinkEligibilityJSON2Apex.PatientInfo> patInfoLst = null;
        if(pat.patientInfo != null){
            patInfoLst = pat.patientInfo;
            if(patInfoLst != null && patInfoLst.size() > 0){
                for(AcetLinkEligibilityJSON2Apex.PatientInfo patObj : patInfoLst){
                    returnObj.firstName = patObj.firstName;
                    returnObj.middleName = patObj.middleName;
                    returnObj.lastName = patObj.lastName;
                    returnObj.name = patObj.firstName + ' ' + patObj.middleName + ' '  + patObj.lastName;
                    returnObj.dob = ACETUtility.formatDate(patObj.dateOfBirth);
                    returnObj.relationship = patObj.relationship;
                    wrapperLst.add(returnObj);
                }
            }
        }
        return wrapperLst;
    }

    */
    /*Below Code Added by Chandan to set active coverage */

    public ACETWSCalloutResult getMemberWS(String memberId, String memberDOB, String memberFN, String memberLN, String memberGrpN, String searchOption){
      system.debug('memberId@@ ' + memberId + ' @@memberDOB@@ ' + memberDOB + ' @@@firstName ' + memberFN + ' @@lastName@@ ' + memberLN + ' @@groupNumber@@ ' + memberGrpN + ' @@searchOption@@ ' + searchOption);
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        try {
            
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String org = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            String dateStr = ACETUtility.formatDateRequest(memberDOB);
            String serviceStart = ACETUtility.formatDateFutureDate(ACETUtility.format(System.today().addYears(-2)));
            String serviceEnd = ACETUtility.formatDateFutureDate(ACETUtility.format(System.today().addYears(1)));
            Map<String,String> requestParamsMap =setRelativeUrl(searchOption,memberFN,memberLN,'87726','ACET','9999999','9999999',dateStr,memberGrpN,memberId,serviceStart,serviceEnd);
            ACETLinkCoveragesResult returnResponse = new ACETLinkCoveragesResult();
            HttpResponse response =null;
            //*Below Code Added by Chandan to switch to static resourse any time-US2044089 */
            String responseStr=AcetUtility.getStaticResponseCheck(memberId,memberDOB,memberFN,memberLN,memberGrpN,searchOption,null,org);
            if(String.isNotBlank(responseStr)){
                if(responseStr=='Checked'){
                    response=new HttpResponse();
                    response.setBody('Checked');
                    response.setStatusCode(500);
                }
                else if(responseStr=='Duplicate'){
                    response=new HttpResponse();
                    response.setBody('duplicate record');
                    response.setStatusCode(400);
                }
                else if(responseStr=='Not found'){
                    response=new HttpResponse();
                    response.setBody('Not found');
                    response.setStatusCode(400);
                }
                else{
                    response=new HttpResponse();
                    response.setBody(responseStr);
                    response.setStatusCode(200);
                }
            }
            else{
                
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
                wsCallOutFW.requestParamsMap = requestParamsMap;
                wsCallOutFW.encodeURLParameters = true;        
                response = wsCallOutFW.getResponse();
                //response=Send(OAuthConfig,'LinkApi');
                System.debug('response='+response);
                responseStr = response!=null?response.getBody():'';

            }
            responseStr = response!=null?response.getBody():'';
            system.debug('responseStr** ' + responseStr);
            if(responseStr!=null && String.isNotBlank(responseStr) && response.getStatusCode()== 200){
                
                calloutResult.statusCode= response.getStatusCode();
                AcetLinkEligibilityJSON2Apex json2Apex = AcetLinkEligibilityJSON2Apex.parse(responseStr);
                List<AcetLinkEligibilityJSON2Apex.MemberPolicies> memberpolicies = new List<AcetLinkEligibilityJSON2Apex.MemberPolicies>();

                //Highlight logic related variables
                Date currentDate = null;
                Map<String, Date> activeMedicalPolicyMap = new Map<String, Date>();
                Map<String, Date> activeNonMedicalPolicyMap = new Map<String, Date>();
                Map<String, Date> inactiveMedicalPolicyMap = new Map<String, Date>();
                Map<String, Date> inactiveMedicalPolicyWithEnddateMap = new Map<String, Date>();
                Map<String, Date> inactiveNonMedicalPolicyMap = new Map<String, Date>();


                if(json2Apex != null){
                    system.debug('json2Apex.memberPolicies@@ ' + json2Apex.memberPolicies);

                    List<ACETLinkCoveragesResult.CoverageLine> policyLine = new List<ACETLinkCoveragesResult.CoverageLine>();
                    if(json2Apex.memberPolicies != null){

                        ACETLinkCoveragesResult.CoverageLine coverageline;
                        memberpolicies = json2Apex.memberPolicies;
                        String transactionId = null;

                        for(AcetLinkEligibilityJSON2Apex.MemberPolicies policies : memberpolicies){
                            coverageline = new ACETLinkCoveragesResult.CoverageLine();

                            // US1730904 - Financial Benefits
                            // Sanka Dharmasena - 20-06-2019
                            // Below Code commented by Chandan -as its not required for ITE -
                            // It required for SAE
                            /*ACETMemberSearchCoveragesResult.FinancialsWrapper fWrapper = ACETLinkEligibilityWebService.CreateFinancialWrappers(policies);
                            coverageline.financialWrapper = fWrapper;*/
                            // End

                            String plan = '';
                            String planInsType = '';
                            String startDate = '';
                            String endDate = '';
                            transactionId =  policies.transactionId;
                            coverageline.transactionId = policies.transactionId;

                            system.debug('transactionId:::'+transactionId);
                            system.debug('org::'+JSON.serialize(transactionId));
                            system.debug('Tran Length:::'+transactionId.length());

                            if(policies.policyInfo != null){
                                coverageline.nonMedicalPolicyBoolean = policies.policyInfo.nonMedicalPolicyBoolean;
                                if(policies.policyInfo.nonMedicalPolicyBoolean == true){
                                    plan = 'Non Medical';
                                }else{
                                    plan = 'Medical';
                                }
                                if(policies.policyInfo.planDates != null){

                                    startDate = String.isNotBlank(policies.policyInfo.planDates.startDate)?policies.policyInfo.planDates.startDate:'';
                                    endDate = String.isNotBlank(policies.policyInfo.planDates.endDate)?policies.policyInfo.planDates.endDate:'';
                                    //coverageline.eligibleDates = formatDate(startDate)+' - '+formatDate(endDate);
                                    coverageline.eligibleDates = ACETUtility.formatDate(startDate) + ' - ' + ACETUtility.formatDate(endDate);

                                    //Set eligible dates in financial benefits
                                    // US1861461 - Sanka Dharmasena
                                    /* Code Commented as its Not required for ITE- Uncomment it for SAE
                                    if(!coverageline.financialWrapper.yearType.equals('Calendar Year'))
                                    {
                                        coverageline.financialWrapper.displayYear = coverageline.eligibleDates;
                                    }*/
                                }

                                if(String.isNotBlank(policies.policyInfo.policyStatus)){
                                    //if(policies.policyInfo.policyStatus.contains('Active') || policies.policyInfo.policyStatus.contains('active')){
                                    if(policies.policyInfo.policyStatus.toLowerCase().subString(0,6) == 'future'){
                                        coverageline.planStatus = 'future';
                                    }else if(policies.policyInfo.policyStatus.toLowerCase().subString(0,6) == 'active'){
                                      coverageline.planStatus = 'true';
                                    }else
                                        coverageline.planStatus = 'false';
                                }

                                if(String.isNotBlank(policies.policyInfo.memberId)){
                                    returnResponse.MemberId = policies.policyInfo.memberId;
                                }

                            }
                            if(policies.referralInfo != null){
                                if(String.isNotBlank(policies.referralInfo.referralIndicator)){
                                    if(policies.referralInfo.referralIndicator == 'N'){
                                        coverageline.referral = 'No';
                                    }else if(policies.referralInfo.referralIndicator == 'Y'){
                                        coverageline.referral = 'Yes';
                                    }
                                }
                            }
                            if(policies.insuranceInfo != null){
                                planInsType = String.isNotBlank(policies.insuranceInfo.insuranceType)?policies.insuranceInfo.insuranceType:'';
                                coverageline.CoverageType = plan + ' - ' + planInsType;
                                coverageline.PolicyName = String.isNotBlank(policies.insuranceInfo.planDescription)?policies.insuranceInfo.planDescription:'';
                                coverageline.GroupNumber = String.isNotBlank(policies.insuranceInfo.groupNumber) ? policies.insuranceInfo.groupNumber : '';
                                //Prepare Address to be added on the Policy Details
                                List<String> addressList = new List<String>();

                                //Added by Vinay to get address Invidual values
                                if(policies.insuranceInfo.addressLine1 != null && policies.insuranceInfo.addressLine1 != '')
                                {
                                    coverageline.addressLine1 = policies.insuranceInfo.addressLine1;
                                }
                                if(policies.insuranceInfo.city != null && policies.insuranceInfo.city != '')
                                {
                                    coverageline.city = policies.insuranceInfo.city;
                                }
                                if(policies.insuranceInfo.state != null && policies.insuranceInfo.state != '')
                                {
                                    coverageline.state = policies.insuranceInfo.state;
                                }
                                if(policies.insuranceInfo.zip != null && policies.insuranceInfo.zip != '')
                                {
                                    //US1842940 Display the first 5 digits of the ZIP
                                    coverageline.zip = policies.insuranceInfo.zip.substring(0,5);
                                }

                                /*String concatAddress;

                                if(policies.insuranceInfo.addressLine1 != null && policies.insuranceInfo.addressLine1 != '')
                                {
                                    concatAddress = policies.insuranceInfo.addressLine1 + '\n';
                                }
                                if(policies.insuranceInfo.city != null && policies.insuranceInfo.city != '')
                                {
                                    concatAddress += policies.insuranceInfo.city + ', ';
                                }
                                if(policies.insuranceInfo.state != null && policies.insuranceInfo.state != '')
                                {
                                    concatAddress += policies.insuranceInfo.state + '\n';
                                }
                                if(policies.insuranceInfo.zip != null && policies.insuranceInfo.zip != '')
                                {
                                    //US1842940 Display the first 5 digits of the ZIP
                                    concatAddress += policies.insuranceInfo.zip.substring(0,5);
                                }

                                coverageline.concatAddress = concatAddress;*/

                            }


                            //Add the highlighted logic for current policies for given criteria. US1689046
                            if (coverageline.planStatus == 'true' && plan == 'Medical'){
                                activeMedicalPolicyMap.put(transactionId, date.valueOf(startDate));

                            }else if (coverageline.planStatus == 'false' &&  plan == 'Non Medical'){
                                inactiveNonMedicalPolicyMap.put(transactionId, date.valueOf(startDate));

                            }else if (coverageline.planStatus == 'true' &&  plan == 'Non Medical' ){
                                activeNonMedicalPolicyMap.put(transactionId, date.valueOf(startDate));

                            }else if ((coverageline.planStatus == 'false' || coverageline.planStatus == 'future') && plan == 'Medical'){
                                 inactiveMedicalPolicyMap.put(transactionId, date.valueOf(startDate));
                                if (endDate != '' && endDate != null)
                                   inactiveMedicalPolicyWithEnddateMap.put(transactionId, date.valueOf(endDate));
                            }

                            policyLine.add(coverageline);

                            if(policies.patientInfo != null){
                                for(AcetLinkEligibilityJSON2Apex.PatientInfo pat : policies.patientInfo){
                                    returnResponse.fullName = pat.firstName + ' ' + pat.middleName + ' ' + pat.lastName;
                                    returnResponse.dob = String.isNotBlank(pat.dateOfBirth)?ACETUtility.formatDate(pat.dateOfBirth):'';
                                    returnResponse.Age = String.isNotBlank(pat.dateOfBirth)?ACETUtility.getAgeFromBirthday(pat.dateOfBirth):'';
                                    returnResponse.gender = pat.gender;

                                    //Code for Address mappings
                                    List<ACETLinkCoveragesResult.Address> adrLst = new List<ACETLinkCoveragesResult.Address>();
                                    ACETLinkCoveragesResult.Address addrObj = new ACETLinkCoveragesResult.Address();
                                    addrObj.AddressLine1 = pat.addressLine1;
                                    addrObj.AddressLine2 = pat.addressLine2;
                                    addrObj.City = pat.city;
                                    addrObj.State = pat.state;
                                    //US1842940 - Restrict ZIP for first 5 digits
                                    addrObj.Zip = pat.zip.substring(0,5);
                                    adrLst.add(addrObj);
                                    returnResponse.Addresses = adrLst;
                                    //Address code ends here
                                }
                          }
                            /*Code Commented as not required for ITE-Uncomment ot for SAE
                             //Code for PCP mapping
                             system.debug('policies.primaryCarePhysicianInfo@@@ ' + policies.primaryCarePhysicianInfo);
                             if(policies.primaryCarePhysicianInfo != null){
                                ACETMemberSearchCoveragesResult.PCPAssignment pcp = new ACETMemberSearchCoveragesResult.PCPAssignment();
                                pcp.FirstName = String.isNotBlank(policies.primaryCarePhysicianInfo.firstName)?policies.primaryCarePhysicianInfo.firstName:'';
                                pcp.middleName = String.isNotBlank(policies.primaryCarePhysicianInfo.middleName)?policies.primaryCarePhysicianInfo.middleName:'';
                                pcp.LastName = String.isNotBlank(policies.primaryCarePhysicianInfo.lastName)?policies.primaryCarePhysicianInfo.lastName:'';
                                pcp.fullName = pcp.FirstName + ' ' + pcp.middleName + ' ' + pcp.LastName;
                                if(String.isBlank(pcp.FirstName) && String.isBlank(pcp.middleName) && String.isBlank(pcp.LastName)){
                                  pcp.NoPCPFlag = true;
                                }
                                returnResponse.PCPAssignments = pcp;

                            }
                            //PCP code ends here
              system.debug('returnResponse.PCPAssignments@@@ ' + returnResponse.PCPAssignments); */
                        }


                        //Run Highlight logic

                        //activeMedicalPolicyMap, activeNonMedicalPolicyMap, inactiveMedicalPolicyMap, inactiveNonMedicalPolicyMap
                        system.debug('activeMedicalPolicyMap:::'+activeMedicalPolicyMap.size());
                        system.debug('activeNonMedicalPolicyMap:::'+activeNonMedicalPolicyMap.size());
                        system.debug('inactiveMedicalPolicyMap:::'+inactiveMedicalPolicyMap.size());
                        system.debug('inactiveNonMedicalPolicyMap:::'+inactiveNonMedicalPolicyMap.size());
                        system.debug('inactiveMedicalPolicyWithEnddateMap:::'+inactiveMedicalPolicyWithEnddateMap.size());

                        Date mostRecentDate = null;
                       // String highlightedPolicyId = null; //Code Required for SAE
                        String ITEhighlightedPolicyId = null;//Code Added for ITE for active Medical policy-Chandan

            //Please check DD for the scenario mentioned below within '<>' characters
                        //<3> Active Medical Policy - Most recent one
                        Boolean isITEUser=ACETLinkMemberSearch.fetchUser();
                        system.debug('isITEUser..............'+isITEUser);
                        if(!isITEUser){
                          if (!activeMedicalPolicyMap.isEmpty()){
                            for (String s: activeMedicalPolicyMap.keySet()){
                                if (mostRecentDate == null && ITEhighlightedPolicyId == null){
                                    mostRecentDate = activeMedicalPolicyMap.get(s);
                                    ITEhighlightedPolicyId=s;

                                }else if (activeMedicalPolicyMap.get(s) > mostRecentDate){
                                    mostRecentDate = activeMedicalPolicyMap.get(s);
                                    ITEhighlightedPolicyId=s;
                                }
                            }
                          }
                          //Below code is for Where if active medical is not there,go for recent active medical.
                          if (activeMedicalPolicyMap.isEmpty() && ITEhighlightedPolicyId == null){
                            for (String s: inactiveMedicalPolicyWithEnddateMap.keySet()){
                                if (mostRecentDate == null && ITEhighlightedPolicyId == null){
                                    mostRecentDate = inactiveMedicalPolicyWithEnddateMap.get(s);
                                    ITEhighlightedPolicyId = s;

                                }else if (inactiveMedicalPolicyWithEnddateMap.get(s) > mostRecentDate){
                                    mostRecentDate = inactiveMedicalPolicyWithEnddateMap.get(s);
                                    ITEhighlightedPolicyId = s;
                                }
                            }
                          }
                          system.debug('ITEhighlightedPolicyId:::'+ITEhighlightedPolicyId);
                          for (ACETLinkCoveragesResult.CoverageLine p: policyLine){

                            if (ITEhighlightedPolicyId == p.transactionId){
                                p.ITEhighlightedPolicyId= true;
                                break;
                            }

                          }
                        }
                        //Code End for Ite
                        //Below code is for SAE
                       /*else{
                         if (!activeMedicalPolicyMap.isEmpty()){

                            for (String s: activeMedicalPolicyMap.keySet()){
                                if (mostRecentDate == null && highlightedPolicyId == null){
                                    mostRecentDate = activeMedicalPolicyMap.get(s);
                                    highlightedPolicyId = s;
                                }else if (activeMedicalPolicyMap.get(s) > mostRecentDate){
                                    mostRecentDate = activeMedicalPolicyMap.get(s);
                                    highlightedPolicyId = s;}
                            }
                        }


                       // 05/27 : We will only consider "Active Non-Modical" Policies
                       // <4> and <5> are almost the same
                       //<4> If there is no Active Medical Policy, then highlight the most recent Active Policy
                        if (activeMedicalPolicyMap.isEmpty() && highlightedPolicyId == null){


                            for (String s: activeNonMedicalPolicyMap.keySet()){
                                if (mostRecentDate == null && highlightedPolicyId == null){
                                    mostRecentDate = activeNonMedicalPolicyMap.get(s);
                                    highlightedPolicyId = s;

                                }else if (activeNonMedicalPolicyMap.get(s) > mostRecentDate){
                                    mostRecentDate = activeNonMedicalPolicyMap.get(s);
                                    highlightedPolicyId = s;
                                }
                            }

                        }

                        //<5> If there are more than one Active non Medical policies - chose first one


                        //<6> If there are no Active policies - highlight the most recent Past Medical Policy. Have to consider the EndDate

                        if (activeMedicalPolicyMap.isEmpty() && activeNonMedicalPolicyMap.isEmpty() && highlightedPolicyId == null){

                            for (String s: inactiveMedicalPolicyWithEnddateMap.keySet()){
                                if (mostRecentDate == null && highlightedPolicyId == null){
                                    mostRecentDate = inactiveMedicalPolicyWithEnddateMap.get(s);
                                    highlightedPolicyId = s;

                                }else if (inactiveMedicalPolicyWithEnddateMap.get(s) > mostRecentDate){
                                    mostRecentDate = inactiveMedicalPolicyWithEnddateMap.get(s);
                                    highlightedPolicyId = s;
                                }
                            }
                            //To Capture future scenarios
                            if (highlightedPolicyId == null){
                                for (String s: inactiveMedicalPolicyMap.keySet()){
                                    if (mostRecentDate == null && highlightedPolicyId == null){
                                        mostRecentDate = inactiveMedicalPolicyMap.get(s);
                                        highlightedPolicyId = s;

                                    }else if (inactiveMedicalPolicyMap.get(s) > mostRecentDate){
                                        mostRecentDate = inactiveMedicalPolicyMap.get(s);
                                        highlightedPolicyId = s;
                                    }
                                }

                            }

                        }

                        //<7> If no past Medical Policy Found, then chose any from the past, preferebly first one returns. This considers anything. Most of the time inactiveNoneMedicalPolicies

                        if (!inactiveNonMedicalPolicyMap.isEmpty() && highlightedPolicyId == null){

                            for (String s: inactiveNonMedicalPolicyMap.keySet()){
                                highlightedPolicyId = s;
                                break;
                            }
                        }

                        system.debug('mostRecentDate:::'+mostRecentDate);
                        system.debug('highlightedPolicyId:::'+highlightedPolicyId);
                        //Set the highlighted Policy matching the transaction Id
                        for (ACETMemberSearchCoveragesResult.CoverageLine p: policyLine){

                            if (highlightedPolicyId == p.transactionId){
                                p.highlightedPolicy = true;
                                break;
                            }

                        }
                       }*/
                        returnResponse.CoverageLines = policyLine;
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = returnResponse;
                        //system.debug('returnResponse.PCPAssignments@@@ ' + returnResponse.PCPAssignments);
                    }
                }
            }else{
               calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
               calloutResult.Success = false;
               calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
               // US1813580 - Error Message Translation - Begin
               //Sanka Dharmasena - 12/06/2019
               calloutResult.statusCode = response.getStatusCode();
                if(response.getStatusCode() == 400)
                {
                    if(response.getBody()!=null && response.getBody().contains('duplicate record')){
                        calloutResult.Message = ACETUtility.getErrorMessage('LD400');
                    }
                    else{
                        calloutResult.Message = ACETUtility.getErrorMessage('GN400');
                    }
                }
                else if(response.getStatusCode() == 500)
                {
                    calloutResult.Message = ACETUtility.getErrorMessage('GN500');
                }
                else if(response.getStatusCode() == 404)
                {
                    calloutResult.Message = ACETUtility.getErrorMessage('GN404');
                }
                else
                {
                    calloutResult.Message = ACETUtility.getErrorMessage('GN500');
                    calloutResult.statusCode = 999;
                }
                // End
               //calloutResult.statusCode=999;
             }
            }catch(Exception e){
			        System.debug('Exception happened:'+e);
                    system.debug(e.getStackTraceString());
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = ACETUtility.getErrorMessage('GN500');
                    calloutResult.statusCode=999;
           }

        return calloutResult;
    }

    // US1730904 - Financials PHS In-Network
    // Sanka Dharmasena - 21-06-2019
    /* Code Commented as not required for ITE - Uncomment this for Sni
    public static ACETMemberSearchCoveragesResult.FinancialsWrapper CreateFinancialWrappers(AcetLinkEligibilityJSON2Apex.MemberPolicies policy)
    {
        String yearType = '';
        String displayYear = '';

        ACETMemberSearchCoveragesResult.Financials tierOne = new ACETMemberSearchCoveragesResult.Financials();
        ACETMemberSearchCoveragesResult.Financials inNetwork = new ACETMemberSearchCoveragesResult.Financials();
        ACETMemberSearchCoveragesResult.Financials outNetwork = new ACETMemberSearchCoveragesResult.Financials();

        // INN/OON/Tier1 Deductibles
        if(policy.deductibleInfo.found)
        {
            //In network - Individual
            if(policy.deductibleInfo.individual.inNetwork.found)
            {
                inNetwork.dedFound = true;
                inNetwork.deductible = policy.deductibleInfo.individual.inNetwork.planAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.inNetwork.planAmount) : 0.0;
                inNetwork.dedSatisfied = policy.deductibleInfo.individual.inNetwork.metYtdAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.inNetwork.metYtdAmount) : 0.0;
                inNetwork.dedAmountRem = policy.deductibleInfo.individual.inNetwork.remainingAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.inNetwork.remainingAmount) : 0.0;
                inNetwork.dedPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.dedSatisfied, inNetwork.deductible);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.dedFound = false;
            }
            // In Network - Family
            if(policy.deductibleInfo.family.inNetwork.found)
            {
                inNetwork.dedFoundFam = true;
                inNetwork.deductibleFam = policy.deductibleInfo.family.inNetwork.planAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.inNetwork.planAmount) : 0.0;
                inNetwork.dedSatisfiedFam = policy.deductibleInfo.family.inNetwork.metYtdAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.inNetwork.metYtdAmount) : 0.0;
                inNetwork.dedAmountRemFam = policy.deductibleInfo.family.inNetwork.remainingAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.inNetwork.remainingAmount) : 0.0;
                inNetwork.dedFamPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.dedSatisfiedFam, inNetwork.deductibleFam);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.family.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.dedFoundFam = false;
            }
            //OON Individual
            if(policy.deductibleInfo.individual.outOfNetwork.found)
            {
                outNetwork.dedFound = true;
                outNetwork.deductible = policy.deductibleInfo.individual.outOfNetwork.planAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.outOfNetwork.planAmount) : 0.0;
                outNetwork.dedSatisfied = policy.deductibleInfo.individual.outOfNetwork.metYtdAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.dedAmountRem = policy.deductibleInfo.individual.outOfNetwork.remainingAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.dedPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.dedSatisfied, outNetwork.deductible);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.dedFound = false;
            }
            // OON - Family
            if(policy.deductibleInfo.family.outOfNetwork.found)
            {
                outNetwork.dedFoundFam = true;
                outNetwork.deductibleFam = policy.deductibleInfo.family.outOfNetwork.planAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.outOfNetwork.planAmount) : 0.0;
                outNetwork.dedSatisfiedFam = policy.deductibleInfo.family.outOfNetwork.metYtdAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.dedAmountRemFam = policy.deductibleInfo.family.outOfNetwork.remainingAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.dedFamPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.dedSatisfiedFam, outNetwork.deductibleFam);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.dedFoundFam = false;
            }
            // Tier_One - Individual
            if(policy.deductibleInfo.individual.inNetworkTier1.found)
            {
                tierOne.dedFound = true;
                tierOne.deductible = policy.deductibleInfo.individual.inNetworkTier1.planAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.inNetworkTier1.planAmount) : 0.0;
                tierOne.dedSatisfied = policy.deductibleInfo.individual.inNetworkTier1.metYtdAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.dedAmountRem = policy.deductibleInfo.individual.inNetworkTier1.remainingAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.individual.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.dedPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.dedSatisfied, tierOne.deductible);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.dedFound = false;
            }
            // Tier_One - Family
            if(policy.deductibleInfo.family.inNetworkTier1.found)
            {
                tierOne.dedFoundFam = true;
                tierOne.deductibleFam = policy.deductibleInfo.family.inNetworkTier1.planAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.inNetworkTier1.planAmount) : 0.0;
                tierOne.dedSatisfiedFam = policy.deductibleInfo.family.inNetworkTier1.metYtdAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.dedAmountRemFam = policy.deductibleInfo.family.inNetworkTier1.remainingAmount != '' ?
                                        Double.valueOf(policy.deductibleInfo.family.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.dedFamPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.dedSatisfiedFam, tierOne.deductibleFam);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.dedFoundFam = false;
            }
        }
        else
        {
            inNetwork.dedFound = false;
            inNetwork.dedFoundFam = false;
            outNetwork.dedFound = false;
            outNetwork.dedFoundFam = false;
            tierOne.dedFound = false;
            tierOne.dedFoundFam = false;
        }
        //INN/OON/Tier1 Out-of-Pocket
        if(policy.outOfPocketInfo.found)
        {
            // In-network - Individual
            if(policy.outOfPocketInfo.individual.inNetwork.found)
            {
                inNetwork.outOPFound = true;
                inNetwork.outOP = policy.outOfPocketInfo.individual.inNetwork.planAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.individual.inNetwork.planAmount) : 0.0;
                inNetwork.outOPRemAmount = policy.outOfPocketInfo.individual.inNetwork.remainingAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.individual.inNetwork.remainingAmount) : 0.0;
                inNetwork.outOPSatisfied = policy.outOfPocketInfo.individual.inNetwork.metYtdAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.individual.inNetwork.metYtdAmount) : 0.0;
                inNetwork.oopPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.outOPSatisfied, inNetwork.outOP);

                //Table Values
                //inNetwork.OOP_Limit_2 = inNetwork.outOP;
                //inNetwork.OOP_Limit_2_Satisfied = inNetwork.outOPSatisfied;

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.outOPFound = false;
            }
            // INN - Family
            if(policy.outOfPocketInfo.family.inNetwork.found)
            {
                inNetwork.outOPFoundFam = true;
                inNetwork.outOPFam = policy.outOfPocketInfo.family.inNetwork.planAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.family.inNetwork.planAmount) : 0.0;
                inNetwork.outOPRemAmountFam = policy.outOfPocketInfo.family.inNetwork.remainingAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.family.inNetwork.remainingAmount) : 0.0;
                inNetwork.outOPSatisfiedFam = policy.outOfPocketInfo.family.inNetwork.metYtdAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.family.inNetwork.metYtdAmount) : 0.0;
                inNetwork.oopFamPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.outOPSatisfiedFam, inNetwork.outOPFam);

                //Table Values
                //inNetwork.OOP_Limit_2_Family = inNetwork.outOPFam;
                //inNetwork.OOP_Limit_2_Satisfied_Family = inNetwork.outOPSatisfiedFam;

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.family.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.outOPFoundFam = false;
            }
            // OON - Individual
            if(policy.outOfPocketInfo.individual.outOfNetwork.found)
            {
                outNetwork.outOPFound = true;
                outNetwork.outOP = policy.outOfPocketInfo.individual.outOfNetwork.planAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.individual.outOfNetwork.planAmount) : 0.0;
                outNetwork.outOPRemAmount = policy.outOfPocketInfo.individual.outOfNetwork.remainingAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.individual.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.outOPSatisfied = policy.outOfPocketInfo.individual.outOfNetwork.metYtdAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.individual.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.oopPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.outOPSatisfied, outNetwork.outOP);

                //Table Values
                //outNetwork.OOP_Limit_2 = outNetwork.outOP;
                //outNetwork.OOP_Limit_2_Satisfied = outNetwork.outOPSatisfied;

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.outOPFound = false;
            }
            // OON - Family
            if(policy.outOfPocketInfo.family.outOfNetwork.found)
            {
                outNetwork.outOPFoundFam = true;
                outNetwork.outOPFam = policy.outOfPocketInfo.family.outOfNetwork.planAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.family.outOfNetwork.planAmount) : 0.0;
                outNetwork.outOPRemAmountFam = policy.outOfPocketInfo.family.outOfNetwork.remainingAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.family.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.outOPSatisfiedFam = policy.outOfPocketInfo.family.outOfNetwork.metYtdAmount != ''?
                                Double.valueOf(policy.outOfPocketInfo.family.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.oopFamPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.outOPSatisfiedFam, outNetwork.outOPFam);

                //Table Values
                //outNetwork.OOP_Limit_2_Family = outNetwork.outOPFam;
                //outNetwork.OOP_Limit_2_Satisfied_Family = outNetwork.outOPSatisfiedFam;

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.outOPFoundFam = false;
            }
            // Tier_One - Individual
            if(policy.outOfPocketInfo.individual.inNetworkTier1.found)
            {
                tierOne.outOPFound = true;
                tierOne.outOP = policy.outOfPocketInfo.individual.inNetworkTier1.planAmount != '' ?
                                        Double.valueOf(policy.outOfPocketInfo.individual.inNetworkTier1.planAmount) : 0.0;
                tierOne.outOPSatisfied = policy.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount != '' ?
                                        Double.valueOf(policy.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.outOPSatisfied = policy.outOfPocketInfo.individual.inNetworkTier1.remainingAmount != '' ?
                                        Double.valueOf(policy.outOfPocketInfo.individual.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.oopPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.outOPSatisfied, tierOne.outOP);

                //Table Values
                //tierOne.OOP_Limit_2 = tierOne.outOP;
                //tierOne.OOP_Limit_2_Satisfied = tierOne.outOPSatisfied;

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.outOPFound = false;
            }
            // Tier_One - Family
            if(policy.outOfPocketInfo.family.inNetworkTier1.found)
            {
                tierOne.outOPFoundFam = true;
                tierOne.outOPFam = policy.outOfPocketInfo.individual.inNetworkTier1.planAmount != '' ?
                                        Double.valueOf(policy.outOfPocketInfo.individual.inNetworkTier1.planAmount) : 0.0;
                tierOne.outOPSatisfiedFam = policy.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount != '' ?
                                        Double.valueOf(policy.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.outOPSatisfiedFam = policy.outOfPocketInfo.individual.inNetworkTier1.remainingAmount != '' ?
                                        Double.valueOf(policy.outOfPocketInfo.individual.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.oopFamPrecentage = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.outOPSatisfiedFam, tierOne.outOPFam);

                //Table Values
                //tierOne.OOP_Limit_2_Family = tierOne.outOPFam;
                //tierOne.OOP_Limit_2_Satisfied_Family = tierOne.outOPSatisfiedFam;

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.outOPFoundFam = false;
            }
        }
        else
        {
            inNetwork.outOPFound = false;
            inNetwork.outOPFoundFam = false;
            outNetwork.outOPFound = false;
            outNetwork.outOPFoundFam = false;
            tierOne.outOPFound = false;
            tierOne.outOPFoundFam = false;
        }
        //
        if(policy.outOfPocketMaxInfo.found)
        {
            //INN - Individual
            if(policy.outOfPocketMaxInfo.individual.inNetwork.found)
            {
                inNetwork.OOP_Limit_2_Found = true;
                inNetwork.OOP_Limit_2 = policy.outOfPocketMaxInfo.individual.inNetwork.planAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.inNetwork.planAmount) : 0.0;
                inNetwork.OOP_Limit_2_Satisfied = policy.outOfPocketMaxInfo.individual.inNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.inNetwork.metYtdAmount) : 0.0;
                inNetwork.OOP_Limit_2_Rem = policy.outOfPocketMaxInfo.individual.inNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.inNetwork.remainingAmount) : 0.0;
                inNetwork.OOP_Limit_2_Precentage = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.OOP_Limit_2_Satisfied, inNetwork.OOP_Limit_2);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.OOP_Limit_2_Found = false;
            }
            //INN - Family
            if(policy.outOfPocketMaxInfo.family.inNetwork.found)
            {
                inNetwork.OOP_Limit_2_Found_Family = true;
                inNetwork.OOP_Limit_2_Family = policy.outOfPocketMaxInfo.family.inNetwork.planAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.inNetwork.planAmount) : 0.0;
                inNetwork.OOP_Limit_2_Satisfied_Family = policy.outOfPocketMaxInfo.family.inNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.inNetwork.metYtdAmount) : 0.0;
                inNetwork.OOP_Limit_2_Rem_Family = policy.outOfPocketMaxInfo.family.inNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.inNetwork.remainingAmount) : 0.0;
                inNetwork.OOP_Limit_2_Precentage_Family = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.OOP_Limit_2_Satisfied_Family, inNetwork.OOP_Limit_2_Family);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.family.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.OOP_Limit_2_Found_Family = false;
            }
            // OON - Individual
            if(policy.outOfPocketMaxInfo.individual.outOfNetwork.found)
            {
                outNetwork.OOP_Limit_2_Found = true;
                outNetwork.OOP_Limit_2 = policy.outOfPocketMaxInfo.individual.outOfNetwork.planAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.outOfNetwork.planAmount) : 0.0;
                outNetwork.OOP_Limit_2_Satisfied = policy.outOfPocketMaxInfo.individual.outOfNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.OOP_Limit_2_Rem = policy.outOfPocketMaxInfo.individual.outOfNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.OOP_Limit_2_Precentage = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.OOP_Limit_2_Satisfied, outNetwork.OOP_Limit_2);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.OOP_Limit_2_Found = false;
            }
            // OON - Family
            if(policy.outOfPocketMaxInfo.family.outOfNetwork.found)
            {
                outNetwork.OOP_Limit_2_Found_Family = true;
                outNetwork.OOP_Limit_2_Family = policy.outOfPocketMaxInfo.family.outOfNetwork.planAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.outOfNetwork.planAmount) : 0.0;
                outNetwork.OOP_Limit_2_Satisfied_Family = policy.outOfPocketMaxInfo.family.outOfNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.OOP_Limit_2_Rem_Family = policy.outOfPocketMaxInfo.family.outOfNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.OOP_Limit_2_Precentage_Family = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.OOP_Limit_2_Satisfied_Family, outNetwork.OOP_Limit_2_Family);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.OOP_Limit_2_Found_Family = false;
            }
            // Tier1 - Individual
            if(policy.outOfPocketMaxInfo.individual.inNetworkTier1.found)
            {
                tierOne.OOP_Limit_2_Found = true;
                tierOne.OOP_Limit_2 = policy.outOfPocketMaxInfo.individual.inNetworkTier1.planAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.inNetworkTier1.planAmount) : 0.0;
                tierOne.OOP_Limit_2_Satisfied = policy.outOfPocketMaxInfo.individual.inNetworkTier1.metYtdAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.OOP_Limit_2_Rem = policy.outOfPocketMaxInfo.individual.inNetworkTier1.remainingAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.individual.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.OOP_Limit_2_Precentage = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.OOP_Limit_2_Satisfied, tierOne.OOP_Limit_2);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.OOP_Limit_2_Found = false;
            }
            // Tier1 - Family
            if(policy.outOfPocketMaxInfo.family.inNetworkTier1.found)
            {
                tierOne.OOP_Limit_2_Found_Family = true;
                tierOne.OOP_Limit_2_Family = policy.outOfPocketMaxInfo.family.inNetworkTier1.planAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.inNetworkTier1.planAmount) : 0.0;
                tierOne.OOP_Limit_2_Satisfied_Family = policy.outOfPocketMaxInfo.family.inNetworkTier1.metYtdAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.OOP_Limit_2_Rem_Family = policy.outOfPocketMaxInfo.family.inNetworkTier1.remainingAmount != '' ?
                                            Double.valueOf(policy.outOfPocketMaxInfo.family.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.OOP_Limit_2_Precentage_Family = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.OOP_Limit_2_Satisfied_Family, tierOne.OOP_Limit_2_Family);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.OOP_Limit_2_Found_Family = false;
            }
        }
        else
        {
            inNetwork.OOP_Limit_2_Found = false;
            inNetwork.OOP_Limit_2_Found_Family = false;
            outNetwork.OOP_Limit_2_Found = false;
            outNetwork.OOP_Limit_2_Found_Family = false;
            tierOne.OOP_Limit_2_Found = false;
            tierOne.OOP_Limit_2_Found_Family = false;
        }
        if(policy.copayMaxInfo.found)
        {
            //INN - INd
            if (policy.copayMaxInfo.individual.inNetwork.found)
            {
                inNetwork.CopayMax_Found = true;
                inNetwork.CopayMax = policy.copayMaxInfo.individual.inNetwork.planAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetwork.planAmount) : 0.0;
                inNetwork.CopayMax_Satisfied = policy.copayMaxInfo.individual.inNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetwork.metYtdAmount) : 0.0;
                inNetwork.CopayMax_Remaining =  policy.copayMaxInfo.individual.inNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetwork.remainingAmount) : 0.0;
                inNetwork.CopayMax_Precentage = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.CopayMax_Satisfied, inNetwork.CopayMax);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.CopayMax_Found = false;
            }
            // INN - Family
            if (policy.copayMaxInfo.family.inNetwork.found)
            {
                inNetwork.CopayMax_Found_Family = true;
                inNetwork.CopayMax_Family = policy.copayMaxInfo.individual.inNetwork.planAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetwork.planAmount) : 0.0;
                inNetwork.CopayMax_Satisfied_Family = policy.copayMaxInfo.individual.inNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetwork.metYtdAmount) : 0.0;
                inNetwork.CopayMax_Remaining_Family =  policy.copayMaxInfo.individual.inNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetwork.remainingAmount) : 0.0;
                inNetwork.CopayMax_Precentage_Family = ACETLinkEligibilityWebService.calculatePrecentage(inNetwork.CopayMax_Satisfied_Family, inNetwork.CopayMax_Family);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.CopayMax_Found_Family = false;
            }
            // OON - Ind
            if (policy.copayMaxInfo.individual.outOfNetwork.found)
            {
                outNetwork.CopayMax_Found = true;
                outNetwork.CopayMax = policy.copayMaxInfo.individual.outOfNetwork.planAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.outOfNetwork.planAmount) : 0.0;
                outNetwork.CopayMax_Satisfied = policy.copayMaxInfo.individual.outOfNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.CopayMax_Remaining =  policy.copayMaxInfo.individual.outOfNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.CopayMax_Precentage = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.CopayMax_Satisfied, outNetwork.CopayMax);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.CopayMax_Found = false;
            }
            //OON - Fam
            if (policy.copayMaxInfo.family.outOfNetwork.found)
            {
                outNetwork.CopayMax_Found_Family = true;
                outNetwork.CopayMax_Family = policy.copayMaxInfo.family.outOfNetwork.planAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.family.outOfNetwork.planAmount) : 0.0;
                outNetwork.CopayMax_Satisfied_Family = policy.copayMaxInfo.family.outOfNetwork.metYtdAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.family.outOfNetwork.metYtdAmount) : 0.0;
                outNetwork.CopayMax_Remaining_Family =  policy.copayMaxInfo.family.outOfNetwork.remainingAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.family.outOfNetwork.remainingAmount) : 0.0;
                outNetwork.CopayMax_Precentage_Family = ACETLinkEligibilityWebService.calculatePrecentage(outNetwork.CopayMax_Satisfied_Family, outNetwork.CopayMax_Family);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.CopayMax_Found_Family = false;
            }
            //Tier1 - Ind
            if (policy.copayMaxInfo.individual.inNetworkTier1.found)
            {
                tierOne.CopayMax_Found = true;
                tierOne.CopayMax = policy.copayMaxInfo.individual.inNetworkTier1.planAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetworkTier1.planAmount) : 0.0;
                tierOne.CopayMax_Satisfied = policy.copayMaxInfo.individual.inNetworkTier1.metYtdAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.CopayMax_Remaining =  policy.copayMaxInfo.individual.inNetworkTier1.remainingAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.individual.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.CopayMax_Precentage = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.CopayMax_Satisfied, tierOne.CopayMax);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.CopayMax_Found = false;
            }
            //Tier1 - Family
            if (policy.copayMaxInfo.family.inNetworkTier1.found)
            {
                tierOne.CopayMax_Found_Family = true;
                tierOne.CopayMax_Family = policy.copayMaxInfo.family.inNetworkTier1.planAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.family.inNetworkTier1.planAmount) : 0.0;
                tierOne.CopayMax_Satisfied_Family = policy.copayMaxInfo.family.inNetworkTier1.metYtdAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.family.inNetworkTier1.metYtdAmount) : 0.0;
                tierOne.CopayMax_Remaining_Family =  policy.copayMaxInfo.family.inNetworkTier1.remainingAmount != '' ?
                                            Double.valueOf(policy.copayMaxInfo.family.inNetworkTier1.remainingAmount) : 0.0;
                tierOne.CopayMax_Precentage_Family = ACETLinkEligibilityWebService.calculatePrecentage(tierOne.CopayMax_Satisfied_Family, tierOne.CopayMax_Family);

                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.CopayMax_Found_Family = false;
            }
        }
        else
        {
            inNetwork.CopayMax_Found = false;
            inNetwork.CopayMax_Found_Family = false;
            outNetwork.CopayMax_Found = false;
            outNetwork.CopayMax_Found_Family = false;
            tierOne.CopayMax_Found = false;
            tierOne.CopayMax_Found_Family = false;
        }

        if(String.isEmpty(yearType))
        {
            yearType = 'Calendar Year';
        }
        else
        {
            yearType = yearType.trim().replace('(', '').replace(')', '');
        }

        if(yearType.equals('Calendar Year'))
        {
            String defaultYear = '01/01/' + System.today().year() + ' - ' + '12/31/' + System.today().year();
            if(policy.policyInfo != null)
            {
                if(policy.policyInfo.planDates != null)
                {
                    String policyYear = '';
                    String startDate = '';
                    startDate = String.isNotBlank(policy.policyInfo.planDates.startDate) ? policy.policyInfo.planDates.startDate : '';
                    List<String> splitDates = startDate.split('-');
                    if(splitDates.size() > 0)
                    {
                        policyYear = splitDates.get(0);
                    }

                    displayYear = '01/01/' + policyYear + ' - ' + '12/31/' + policyYear;
                }
            }
            else
            {
                displayYear = defaultYear;
            }
        }

        ACETMemberSearchCoveragesResult.FinancialsWrapper returnResponse = new ACETMemberSearchCoveragesResult.FinancialsWrapper();
        returnResponse.inNetwork = inNetwork;
        returnResponse.onNetwork = outNetwork;
        returnResponse.tierOne = tierOne;
        returnResponse.yearType = yearType;
        returnResponse.displayYear = displayYear;

        //Hard Coded values for testing
        returnResponse.inNetwork.OOP_Limit_2_Found = true;
        returnResponse.inNetwork.OOP_Limit_2 = 1000.00;
        returnResponse.inNetwork.OOP_Limit_2_Satisfied = 300.00;
        returnResponse.inNetwork.OOP_Limit_2_Rem=700.00;
        returnResponse.inNetwork.OOP_Limit_2_Precentage= 30;

        returnResponse.inNetwork.OOP_Limit_2_Found_Family = true;
        returnResponse.inNetwork.OOP_Limit_2_Family = 1000.00;
        returnResponse.inNetwork.OOP_Limit_2_Satisfied_Family = 300.00;
        returnResponse.inNetwork.OOP_Limit_2_Rem_Family=700.00;
        returnResponse.inNetwork.OOP_Limit_2_Precentage_Family= 30;

        returnResponse.inNetwork.CopayMax_Found = true;
        returnResponse.inNetwork.CopayMax = 1000.00;
        returnResponse.inNetwork.CopayMax_Satisfied = 300.00;
        returnResponse.inNetwork.CopayMax_Remaining =700.00;
        returnResponse.inNetwork.CopayMax_Precentage = 30;

        returnResponse.inNetwork.CopayMax_Found_Family = true;
        returnResponse.inNetwork.CopayMax_Family = 1000.00;
        returnResponse.inNetwork.CopayMax_Satisfied_Family = 300.00;
        returnResponse.inNetwork.CopayMax_Remaining_Family =700.00;
        returnResponse.inNetwork.CopayMax_Precentage_Family = 30;


        return returnResponse;
    }

    // Sanka Dharmasena
    // Calculate Financial precentages
    public static Double calculatePrecentage(Double met, Double allAmt)
    {
        Double returnPrec = 0.0;
        if(allAmt == 0.0)
        {
            return returnPrec;
        }
        else
        {
            returnPrec = (met/allAmt)*100;
        }

        return returnPrec;
    }
    */
    //End By Chandan
    // US1813580 - Error Message Translation
    // Sanka Dharmasena - 18.07.2019
    // Get Error messages from metadata records
    public static String getErrorMessage(String errorCode)
    {
        String errorMessage = '';
        AcetErrorMessage__mdt[] ErrorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c
                                                    FROM AcetErrorMessage__mdt
                                                    WHERE DeveloperName = :errorCode];

        if(ErrorCodes.size() > 0)
        {
            errorMessage = ErrorCodes[0].Error_Message__c;
        }

        return errorMessage;
    }
    public Static String getStaticResponse(String StaticResourceName){
        System.debug('StaticResourceName in getStaticResponse='+StaticResourceName);
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = :StaticResourceName limit 1];
        //System.debug('StaticResource@@@@='+responseJSONSR);
        responseStr = responseJSONSR!=null?responseJSONSR.Body.toString():'';
        //System.debug('responseStr in getStaticResponse='+responseStr);
        return responseStr;
    }



}