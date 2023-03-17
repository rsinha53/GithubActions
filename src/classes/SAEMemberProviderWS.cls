public class SAEMemberProviderWS {
    
    public ACETWSCalloutResult getMemberDetails(SAEMemberProviderDetail.MemberDetails memberDetails, ACET_ProviderSearchCtrl.ProviderDetails providerDetails) {
        Map < String, String > requestParamsMap = new Map < String, String > ();
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        memberDetails.memberDOB = SAEUtils.formatDateRequest(memberDetails.memberDOB);
        if(providerDetails.isProviderNotFound || providerDetails.isNoProviderToSearch || providerDetails.isOther) {
            
            requestParamsMap.put('providerLastName', System.Label.SAEProviderLastName);
            requestParamsMap.put('providerFirstName', '');
            requestParamsMap.put('providerNameID', System.Label.SAEProviderNameID);
            requestParamsMap.put('taxIdNumber', System.Label.SAEProviderTaxIdNumber);
            
        } else {
            
            requestParamsMap.put('providerLastName', String.isNotBlank(providerDetails.lastName) ? providerDetails.lastName : '');
            requestParamsMap.put('providerFirstName', String.isNotBlank(providerDetails.firstName) ? providerDetails.firstName : '');
            requestParamsMap.put('providerNameID', String.isNotBlank(providerDetails.providerId) ? providerDetails.providerId : '');
            requestParamsMap.put('taxIdNumber', String.isNotBlank(providerDetails.taxId) ? providerDetails.taxId : '');
        }               
        requestParamsMap.put('memberId', String.isNotBlank(memberDetails.memberId) ? memberDetails.memberId : '');
        requestParamsMap.put('searchOption', String.isNotBlank(memberDetails.searchOption) ? memberDetails.searchOption : '');
        requestParamsMap.put('firstName', String.isNotBlank(memberDetails.firstName) ? memberDetails.firstName : '');
        requestParamsMap.put('lastName', String.isNotBlank(memberDetails.lastName) ? memberDetails.lastName : '');
        requestParamsMap.put('dateOfBirth', String.isNotBlank(memberDetails.memberDOB) ? memberDetails.memberDOB : '');
        requestParamsMap.put('groupNumber', String.isNotBlank(memberDetails.groupNumber) ? memberDetails.groupNumber : '');
        requestParamsMap.put('payerID', String.isNotBlank(memberDetails.payerId) ? memberDetails.payerId : '');    
   
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;        
        HttpResponse response = wsCallOutFW.getResponse();
        calloutResult = SAEMemberProviderWS.processResponse(response);
        
        return calloutResult;
    }

	public ACETWSCalloutResult getMemberDetails(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID, String providerLastName, String providerFirstName, String npi, String providerFlow, String taxId, String providerId){
        system.debug('memberId@@ ' + memberId + ' @@memberDOB@@ ' + memberDOB + ' @@@firstName ' + firstName + ' @@lastName@@ ' + lastName + ' @@groupNumber@@ ' + groupNumber + ' @@searchOption@@ ' + searchOption + ' @@providerFlow@@ ' + providerFlow);
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        String dateStr = SAEUtils.formatDateRequest(memberDOB);
        SAEProviderMemberSearchInteractionResult returnResponse = new SAEProviderMemberSearchInteractionResult();
        try{
            Boolean isStaticResponseChecked = false;
            String responseStr = '';
            HttpResponse response;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            System.debug('@@ SAEMemberProviderWS: getMemberWS: isStaticResponseChecked: '+isStaticResponseChecked);
            
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                String searchparameter='';
                switch on searchOption {
                    when 'MemberIDNameGroupNumberDateOfBirth' {
                        searchparameter=  memberId+'_'+firstName+'_'+lastName+'_'+groupNumber+'_'+memberDOB; 
                        
                    }
                    when 'MemberIDNameDateOfBirth' {
                        searchparameter=  memberId+'_'+firstName+'_'+lastName+'_'+memberDOB; 
                        
                    }
                    when 'MemberIDName'{
                        searchparameter=  memberId+'_'+firstName+'_'+lastName; 
                    }
                    when 'MemberIDLastNameDateOfBirth' {
                        searchparameter=  memberId+'_'+lastName+'_'+memberDOB; 
                    }
                    when 'MemberIDFirstNameDateOfBirth'{
                        searchparameter=  memberId+'_'+firstName+'_'+memberDOB; 
                    }
                    when 'NameDateOfBirth' {
                        searchparameter=  firstName+'_'+lastName+'_'+memberDOB; 
                    }
                    when 'MemberIDDateOfBirth'{
                        searchparameter=  memberId+'_'+memberDOB; 
                    }
                    when else {
                        System.debug('default');
                    }
                }
                system.debug(LoggingLevel.INFO,'@@searchparameter@@ ' + searchparameter);
                if(String.isNotBlank(searchparameter)) {
                    response = SAEUtils.getResponse(searchparameter);
                }
            } else {
                String reqMethod='GET';
                String endPoint = ISL_Webservice_Config__c.getInstance('SAE_ProviderSearch').Value__c;
                //US2034277 : TECH - Eligibility V2 Request Changes :START
                List<String> reqParaLst;
                String resultQuery = '';
                String strTaxIdNumber = '';
                String strProviderNameID = '';
                if(providerFlow == 'Provider Not Found' || providerFlow == 'No Provider To Search' || providerFlow == 'Other') {
                    providerLastName = 'ACET'; 
                    strTaxIdNumber = '9999999';
                    strProviderNameID = '9999999';
                    reqParaLst = new List<String>{searchOption,EncodingUtil.urlEncode(firstName,'UTF-8'),EncodingUtil.urlEncode(lastName, 'UTF-8'),payerID,providerLastName,'',dateStr,groupNumber,memberId,'','',strTaxIdNumber,strProviderNameID};
                        resultQuery = SAEWebservice.formQueryString(reqParaLst);
                } else {
                    npi = String.isNotBlank(npi) ? npi.trim() : '';
                    //reqParaLst = new List<String>{searchOption,firstName,lastName,payerID,strProviderLastName,'',dateStr,groupNumber,memberId,'','',strTaxIdNumber,strProviderNameID};
                    resultQuery += '?searchOption=' + searchOption + '&firstName='+ EncodingUtil.urlEncode(firstName, 'UTF-8') + '&lastName='+ EncodingUtil.urlEncode(lastName, 'UTF-8') + '&payerID=' + payerID + '&providerLastName=' + EncodingUtil.urlEncode(String.isNotBlank(providerLastName)?providerLastName:'', 'UTF-8') + '&providerFirstName=' + EncodingUtil.urlEncode(String.isNotBlank(providerFirstName)?providerFirstName:'', 'UTF-8') + '&dateOfBirth=' + memberDOB + '&groupNumber=' + groupNumber + '&memberId='+ memberId + '&serviceStart=&serviceEnd=&npi=' + npi + '&taxIdNumber=' + taxId + '&providerNameID=' + providerId;
                }
                
                //List<String> reqParaLst = new List<String>{searchOption,firstName,lastName,'87726','LOTSOFF','DAVID','1205807328',dateStr,groupNumber,memberId,'',''};
                //US2034277 : TECH - Eligibility V2 Request Changes
                //List<String> reqParaLst = new List<String>{searchOption,firstName,lastName,payerID,strProviderLastName,'',dateStr,groupNumber,memberId,'','',strTaxIdNumber,strProviderNameID};
                //US2034277 : TECH - Eligibility V2 Request Changes :END    
                
                system.debug('resultQuery@@@ ' + resultQuery);
                
                ////Only To test future policies
                if (memberId == '85969010' && memberDOB == '1962-11-05'){
                    //resultQuery = '?searchOption=MemberIDDateOfBirth&payerID=87726&providerLastName=ACET&providerFirstName=DAVID&npi=1205807328&dateOfBirth=1962-11-05&memberId=859690190&serviceStart=2020-01-01';
                    //US2034277 : TECH - Eligibility V2 Request Changes
                    resultQuery = '?searchOption=MemberIDDateOfBirth&payerID=87726&providerLastName=ACET&dateOfBirth=1962-11-05&memberId=859690190&serviceStart=2020-01-01&taxIdNumber=9999999&providerNameID=9999999';
                }
                system.debug('resultQuery@@@222 ' + resultQuery);
                
                StaticResource responseJSONSR = null;
                String responseBody;
                
                response = SAEWebservice.makeCallout(resultQuery,endPoint,reqMethod);
            }
			responseStr = response.getBody();   
            system.debug('ResponseBody** ' + responseStr);
            
            if(response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    calloutResult.statusCode= response.getStatusCode();
                    SAEEligibilityResponseJSON2Apex json2Apex = SAEEligibilityResponseJSON2Apex.parse(responseStr);
                    List<SAEEligibilityResponseJSON2Apex.MemberPolicies> memberpolicies = new List<SAEEligibilityResponseJSON2Apex.MemberPolicies>();
                    List<SAEProviderMemberSearchInteractionResult.memberProviderResult> wrapRespToreturn = new List<SAEProviderMemberSearchInteractionResult.memberProviderResult>();
                    SAEProviderMemberSearchInteractionResult.InteractionOverView interviewOverViewCard = new SAEProviderMemberSearchInteractionResult.InteractionOverView();
                    SAEProviderMemberSearchInteractionResult.InteractionSubjectCard subjectCard = new SAEProviderMemberSearchInteractionResult.InteractionSubjectCard();
                    // DE275005 incorrect GroupNumber mapping - 01/11/2019 - Sarma : adding 2 new var
                    List<SAEEligibilityResponseJSON2Apex.MemberPolicies> selectedPolicies = new List<SAEEligibilityResponseJSON2Apex.MemberPolicies>();
                    SAEEligibilityResponseJSON2Apex.MemberPolicies selectedPolicy;
                    
                    if(json2Apex != null){
                        if(json2Apex.memberPolicies != null){
                            memberpolicies = json2Apex.memberPolicies;
                            for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){
                                
                                if(policies.PolicyInfo != null){
                                    subjectCard.memberId = policies.PolicyInfo.memberId;
                                    wrapRespToreturn = returnResponseData(policies);  
                                    break;
                                }   
                                
                            }
                            returnResponse.memberProviderResultlst = wrapRespToreturn;
                            system.debug('returnResponse.memberProviderResultlst@@@ ' + returnResponse.memberProviderResultlst);
                            //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                            Map<string,string> polciygroupToPayerIdMap = new Map<string,string>();
                            // DE275005 	incorrect GroupNumber mapping - 01/11/2019 - Sarma : Start
                            for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){
                                string isThisPoilcyActive = 'F';//US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                if(policies.PolicyInfo != null){
                                    if(policies.PolicyInfo.policyStatus.contains('Active') || policies.PolicyInfo.policyStatus.contains('active')){ 
                                        selectedPolicies.add(policies);    
                                        isThisPoilcyActive = 'T';//US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                    }
                                    }
                                //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga - Start
                                if(string.isNotBlank(policies.insuranceInfo.payerId) && string.isNotBlank(policies.transactionId) ){
                                    polciygroupToPayerIdMap.put(policies.transactionId,policies.insuranceInfo.payerId+';;'+isThisPoilcyActive);
                                }
                            }
                            System.debug('===@@polciygroupToPayerIdMap132'+polciygroupToPayerIdMap);
                            if(!polciygroupToPayerIdMap.isEmpty()){
                                subjectCard.policyandPayerMap = polciygroupToPayerIdMap;
                            }
                            //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga - End
                            System.debug('POLICY WEBSERVICE:::: selected policy list size : '+selectedPolicies.size());
                            System.debug('POLICY WEBSERVICE:::: selected policy list : '+selectedPolicies);
                            if(selectedPolicies.size()>0){
                                selectedPolicy = selectedPolicies[0];
                            } else{
                                
                                selectedPolicy = memberpolicies[0];
                            }
                            // DE275005 : End
                        }
                        //Durga
                        if(json2Apex != null){
                            if(json2Apex.searchQuery != null){
                                subjectCard.searchQueryPayerId = String.isNotBlank(json2Apex.searchQuery.payerID)?json2Apex.searchQuery.payerID:'';
                            }
                        }
                        if(json2Apex != null){
                            // DE275005 incorrect GroupNumber mapping - 01/11/2019 - Sarma 
                            // Changing variable to single object from list of objects & removing for loop.
                            if(selectedPolicies != null){ 
                                SAEEligibilityResponseJSON2Apex.MemberPolicies policies = selectedPolicy; 
                                // for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){ 
                                if(policies.patientInfo != null){
                                    System.debug('policies.patientInfo@@@ ' + policies.patientInfo);
                                    for(SAEEligibilityResponseJSON2Apex.PatientInfo patientInfoObj : policies.patientInfo){
                                        if(patientInfoObj.searched == 'true'){
                                            if(String.isNotBlank(patientInfoObj.firstName) || String.isNotBlank(patientInfoObj.middleName) || String.isNotBlank(patientInfoObj.lastName) ){
                                                subjectCard.subjectName = 'Subject'+' '+':'+' '+patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                            }
                                            if(String.isNotBlank(patientInfoObj.firstName) || String.isNotBlank(patientInfoObj.middleName) || String.isNotBlank(patientInfoObj.lastName) ){
                                                subjectCard.memberName = patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                                subjectCard.firstName = patientInfoObj.firstName;
                                                subjectCard.middleName = patientInfoObj.middleName;
                                                subjectCard.lastName = patientInfoObj.lastName; 
                                            }
                                            subjectCard.memberDOB = String.isNotBlank(patientInfoObj.dateOfBirth) ?  SAEUtils.formatDate(patientInfoObj.dateOfBirth) : '';
                                            subjectCard.gender = String.isNotBlank(patientInfoObj.gender) ? patientInfoObj.gender : '' ;
                                            subjectCard.SSN = String.isNotBlank(patientInfoObj.SSN) ? patientInfoObj.SSN : '' ;
                                            subjectCard.EEID = String.isNotBlank(patientInfoObj.EEID) ? patientInfoObj.EEID : '' ;
                                            subjectCard.relationship = String.isNotBlank(patientInfoObj.relationship) ? patientInfoObj.relationship : '' ;    
                                            system.debug('gender**'+subjectCard.gender+'relation**'+subjectCard.relationship);
                                            subjectCard.age = Integer.valueOf(SAEUtils.getAgeFromBirthday(patientInfoObj.dateOfBirth));
                                            system.debug('subjectCard@@@ ' + subjectCard);
                                        }
                                    }
                                }
                                if(policies.insuranceInfo != null){
                                    subjectCard.groupNumber = String.isNotBlank(policies.insuranceInfo.groupNumber)?policies.insuranceInfo.groupNumber:'';
                                }
                                //}
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
                        
                        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
                        ACETWSCalloutResult findInvidualCalloutResult = null;
                        findInvidualCalloutResult = findIndividualWS.findIndividual(memberId);
                        SAEProviderMemberSearchInteractionResult findInvidualresultwrap = new SAEProviderMemberSearchInteractionResult();                 
                        SAEProviderMemberSearchInteractionResult.InteractionSubjectCard subjectCardRec = subjectCard;
                        
                        if (findInvidualCalloutResult.Success != null && findInvidualCalloutResult.Success){
                            findInvidualresultwrap = (SAEProviderMemberSearchInteractionResult)findInvidualCalloutResult.Response;
                            for(SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch memberList:findInvidualresultwrap.lstSAEMemberStandaloneSearch){
                                if(subjectCardRec.firstName == memberList.firstName && subjectCardRec.lastName == memberList.lastName && subjectCardRec.memberDOB == memberList.birthDate){
                                    subjectCardRec.SSN = memberList.SSN;
                                    
                                }
                            }
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
            }else{
                system.debug('Error@@@ ' + response.getBody());
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false; 
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                // US1813580 - Error Message Translation - Begin
                Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(responseStr);
                String faultCode = (String) httpResponseJSON.get('faultCode');
                System.debug('@@@ fault code 400:: ' + faultCode);
                Boolean flag=faultCode != null?true:false;
                Integer statusCode=response.getStatusCode();
                if(statusCode == 400)
                {                    
                    if (flag && (faultCode.containsIgnoreCase('AAA:58') || faultCode.containsIgnoreCase('AAA:72')
                                              || faultCode.containsIgnoreCase('AAA:73') || faultCode.containsIgnoreCase('AAA:76') || 
                                              faultCode.containsIgnoreCase('AAA:79'))) { // == 'AAA:72'
                                                  //calloutResult.Message = SAEMemberProviderWS.getErrorMessage('AAA:72');
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
                                              }else if (flag && (faultCode.containsIgnoreCase('ED270UG'))){ /** US1964362  Added by Avish 11/25/2019**/
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';                       
                                              }else if (flag && (faultCode.containsIgnoreCase('AAA:Fault Code'))){
                                                  String[] faultCodeMsg = faultCode.split(':');
                                                  String[] faultCodeMsg2 = faultCodeMsg[1].split(' ');
                                                  String faultCodeOrignal = faultCodeMsg[0]+faultCodeMsg2[0]+faultCodeMsg2[1];
                                                  System.debug('@@@ fault code 400: ' + faultCode);
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCodeOrignal) + '(' + faultCode + ')';   
                                                  System.debug('@@@ fault code Message: ' + SAEMemberProviderWS.getErrorMessage(faultCodeOrignal));
                                              }else if (flag && (faultCode.containsIgnoreCase('ED270IP'))){
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                              }else if (flag && (faultCode.containsIgnoreCase('ED270BP'))){
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')'; //SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                              }else if (flag && (faultCode.containsIgnoreCase('ED270BR'))){
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                              }                    
                    else {
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400) + '(' + faultCode + ')';
                    }
                }else if(statusCode == 404)
                {
                    if (flag && (faultCode.containsIgnoreCase('AEFNND'))){
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }else{
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404) + '(' + faultCode + ')';
                    }
                    
                }else if(statusCode == 406){
                    if (flag && (faultCode.containsIgnoreCase('ED270IA'))){
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }
                }
                else if(statusCode == 424){
                    if (flag && (faultCode.containsIgnoreCase('ED270UR'))){
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }else if (flag && (faultCode.containsIgnoreCase('AAA:42'))){
                        String[] faultCodeMsg = faultCode.split(':');
                        String temp = faultCodeMsg[0]+faultCodeMsg[1];
                        system.debug('temp>>> ' + temp);
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(temp) + '(' + faultCode + ')';
                    }
                }
                else if(statusCode == 500)
                {
                    if (flag && (faultCode.containsIgnoreCase('ED270SE') ||
                                              faultCode.containsIgnoreCase('ED270UE') || faultCode.containsIgnoreCase('AEFNEE'))){ 
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';                       
                                              }else{
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                                                  calloutResult.statusCode = 999;
                                              }
                    
                } 
                else
                {
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                    calloutResult.statusCode = 999;
                }  
                // End
                calloutResult.Response = new SAEProviderMemberSearchInteractionResult();
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
    
    public static ACETWSCalloutResult processResponse(HttpResponse response) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        SAEProviderMemberSearchInteractionResult returnResponse = new SAEProviderMemberSearchInteractionResult();
        String responseStr = response.getBody();  
        system.debug('response.getStatusCode()### ' + response.getStatusCode());
        try{
            if(response.getStatusCode() == 200){
                system.debug('responseStr### ' + responseStr);
                if(responseStr != null && String.isNotBlank(responseStr)){
                    system.debug('responseStr### ' + responseStr);
                    calloutResult.statusCode= response.getStatusCode();
                    SAEEligibilityResponseJSON2Apex json2Apex = SAEEligibilityResponseJSON2Apex.parse(responseStr);
                    List<SAEEligibilityResponseJSON2Apex.MemberPolicies> memberpolicies = new List<SAEEligibilityResponseJSON2Apex.MemberPolicies>();
                    List<SAEProviderMemberSearchInteractionResult.memberProviderResult> wrapRespToreturn = new List<SAEProviderMemberSearchInteractionResult.memberProviderResult>();
                    SAEProviderMemberSearchInteractionResult.InteractionOverView interviewOverViewCard = new SAEProviderMemberSearchInteractionResult.InteractionOverView();
                    SAEProviderMemberSearchInteractionResult.InteractionSubjectCard subjectCard = new SAEProviderMemberSearchInteractionResult.InteractionSubjectCard();
                    // DE275005 incorrect GroupNumber mapping - 01/11/2019 - Sarma : adding 2 new var
                    List<SAEEligibilityResponseJSON2Apex.MemberPolicies> selectedPolicies = new List<SAEEligibilityResponseJSON2Apex.MemberPolicies>();
                    SAEEligibilityResponseJSON2Apex.MemberPolicies selectedPolicy;
                    
                    if(json2Apex != null){
                        if(json2Apex.memberPolicies != null){
                            memberpolicies = json2Apex.memberPolicies;
                            for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){
                                
                                if(policies.PolicyInfo != null){
                                    subjectCard.memberId = policies.PolicyInfo.memberId;
                                    wrapRespToreturn = returnResponseData(policies);  
                                    break;
                                }   
                                
                            }
                            returnResponse.memberProviderResultlst = wrapRespToreturn;
                            system.debug('returnResponse.memberProviderResultlst@@@ ' + returnResponse.memberProviderResultlst);
                            //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                            Map<string,string> polciygroupToPayerIdMap = new Map<string,string>();
                            // DE275005 	incorrect GroupNumber mapping - 01/11/2019 - Sarma : Start
                            for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){
                                string isThisPoilcyActive = 'F';//US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                if(policies.PolicyInfo != null){
                                    if(policies.PolicyInfo.policyStatus.contains('Active') || policies.PolicyInfo.policyStatus.contains('active')){ 
                                        selectedPolicies.add(policies);    
                                        isThisPoilcyActive = 'T';//US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                    }
                                }
                                //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga - Start
                                if(string.isNotBlank(policies.insuranceInfo.payerId) && string.isNotBlank(policies.transactionId) ){
                                    polciygroupToPayerIdMap.put(policies.transactionId,policies.insuranceInfo.payerId+';;'+isThisPoilcyActive);
                                }
                            }
                            System.debug('===@@polciygroupToPayerIdMap132'+polciygroupToPayerIdMap);
                            if(!polciygroupToPayerIdMap.isEmpty()){
                                subjectCard.policyandPayerMap = polciygroupToPayerIdMap;
                            }
                            //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga - End
                            System.debug('POLICY WEBSERVICE:::: selected policy list size : '+selectedPolicies.size());
                            System.debug('POLICY WEBSERVICE:::: selected policy list : '+selectedPolicies);
                            if(selectedPolicies.size()>0){
                                selectedPolicy = selectedPolicies[0];
                            } else{
                                
                                selectedPolicy = memberpolicies[0];
                            }
                            // DE275005 : End
                        }
                        //Durga
                        if(json2Apex != null){
                            if(json2Apex.searchQuery != null){
                                subjectCard.searchQueryPayerId = String.isNotBlank(json2Apex.searchQuery.payerID)?json2Apex.searchQuery.payerID:'';
                            }
                        }
                        if(json2Apex != null){
                            // DE275005 incorrect GroupNumber mapping - 01/11/2019 - Sarma 
                            // Changing variable to single object from list of objects & removing for loop.
                            if(selectedPolicies != null){ 
                                SAEEligibilityResponseJSON2Apex.MemberPolicies policies = selectedPolicy; 
                                // for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){ 
                                if(policies.patientInfo != null){
                                    System.debug('policies.patientInfo@@@ ' + policies.patientInfo);
                                    for(SAEEligibilityResponseJSON2Apex.PatientInfo patientInfoObj : policies.patientInfo){
                                        if(patientInfoObj.searched == 'true'){
                                            if(String.isNotBlank(patientInfoObj.firstName) || String.isNotBlank(patientInfoObj.middleName) || String.isNotBlank(patientInfoObj.lastName) ){
                                                subjectCard.subjectName = 'Subject'+' '+':'+' '+patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                            }
                                            if(String.isNotBlank(patientInfoObj.firstName) || String.isNotBlank(patientInfoObj.middleName) || String.isNotBlank(patientInfoObj.lastName) ){
                                                subjectCard.memberName = patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                                subjectCard.firstName = patientInfoObj.firstName;
                                                subjectCard.middleName = patientInfoObj.middleName;
                                                subjectCard.lastName = patientInfoObj.lastName; 
                                            }
                                            subjectCard.memberDOB = String.isNotBlank(patientInfoObj.dateOfBirth) ?  SAEUtils.formatDate(patientInfoObj.dateOfBirth) : '';
                                            subjectCard.gender = String.isNotBlank(patientInfoObj.gender) ? patientInfoObj.gender : '' ;
                                            subjectCard.SSN = String.isNotBlank(patientInfoObj.SSN) ? patientInfoObj.SSN : '' ;
                                            subjectCard.EEID = String.isNotBlank(patientInfoObj.EEID) ? patientInfoObj.EEID : '' ;
                                            subjectCard.relationship = String.isNotBlank(patientInfoObj.relationship) ? patientInfoObj.relationship : '' ;    
                                            system.debug('gender**'+subjectCard.gender+'relation**'+subjectCard.relationship);
                                            subjectCard.age = Integer.valueOf(SAEUtils.getAgeFromBirthday(patientInfoObj.dateOfBirth));
                                            system.debug('subjectCard@@@ ' + subjectCard);
                                        }
                                    }
                                }
                                if(policies.insuranceInfo != null){
                                    subjectCard.groupNumber = String.isNotBlank(policies.insuranceInfo.groupNumber)?policies.insuranceInfo.groupNumber:'';
                                }
                                //}
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
                        
                        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
                        ACETWSCalloutResult findInvidualCalloutResult = null;
                        findInvidualCalloutResult = findIndividualWS.findIndividual(subjectCard.memberId);
                        SAEProviderMemberSearchInteractionResult findInvidualresultwrap = new SAEProviderMemberSearchInteractionResult();                 
                        SAEProviderMemberSearchInteractionResult.InteractionSubjectCard subjectCardRec = subjectCard;
                        
                        if (findInvidualCalloutResult.Success != null && findInvidualCalloutResult.Success){
                            findInvidualresultwrap = (SAEProviderMemberSearchInteractionResult)findInvidualCalloutResult.Response;
                            for(SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch memberList:findInvidualresultwrap.lstSAEMemberStandaloneSearch){
                                if(subjectCardRec.firstName == memberList.firstName && subjectCardRec.lastName == memberList.lastName && subjectCardRec.memberDOB == memberList.birthDate){
                                    subjectCardRec.SSN = memberList.SSN;
                                    
                                }
                            }
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
            }else{
                system.debug('Error@@@ ' + response.getBody());
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false; 
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                // US1813580 - Error Message Translation - Begin
                Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(responseStr);
                String faultCode = (String) httpResponseJSON.get('faultCode');
                System.debug('@@@ fault code 400:: ' + faultCode);
                Boolean flag=faultCode != null?true:false;
                Integer statusCode=response.getStatusCode();
                if(statusCode == 400)
                {                    
                    if (flag && (faultCode.containsIgnoreCase('AAA:58') || faultCode.containsIgnoreCase('AAA:72')
                                 || faultCode.containsIgnoreCase('AAA:73') || faultCode.containsIgnoreCase('AAA:76') || 
                                 faultCode.containsIgnoreCase('AAA:79'))) { // == 'AAA:72'
                                     //calloutResult.Message = SAEMemberProviderWS.getErrorMessage('AAA:72');
                                     calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
                                 }else if (flag && (faultCode.containsIgnoreCase('ED270UG'))){ /** US1964362  Added by Avish 11/25/2019**/
                                     calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';                       
                                 }else if (flag && (faultCode.containsIgnoreCase('AAA:Fault Code'))){
                                     String[] faultCodeMsg = faultCode.split(':');
                                     String[] faultCodeMsg2 = faultCodeMsg[1].split(' ');
                                     String faultCodeOrignal = faultCodeMsg[0]+faultCodeMsg2[0]+faultCodeMsg2[1];
                                     System.debug('@@@ fault code 400: ' + faultCode);
                                     calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCodeOrignal) + '(' + faultCode + ')';   
                                     System.debug('@@@ fault code Message: ' + SAEMemberProviderWS.getErrorMessage(faultCodeOrignal));
                                 }else if (flag && (faultCode.containsIgnoreCase('ED270IP'))){
                                     calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                 }else if (flag && (faultCode.containsIgnoreCase('ED270BP'))){
                                     calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')'; //SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                 }else if (flag && (faultCode.containsIgnoreCase('ED270BR'))){
                                     calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                 }                    
                    else {
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400) + '(' + faultCode + ')';
                    }
                }else if(statusCode == 404)
                {
                    if (flag && (faultCode.containsIgnoreCase('AEFNND'))){
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }else{
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404) + '(' + faultCode + ')';
                    }
                    
                }else if(statusCode == 406){
                    if (flag && (faultCode.containsIgnoreCase('ED270IA'))){
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }
                }
                else if(statusCode == 424){
                    if (flag && (faultCode.containsIgnoreCase('ED270UR'))){
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }else if (flag && (faultCode.containsIgnoreCase('AAA:42'))){
                        String[] faultCodeMsg = faultCode.split(':');
                        String temp = faultCodeMsg[0]+faultCodeMsg[1];
                        system.debug('temp>>> ' + temp);
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(temp) + '(' + faultCode + ')';
                    }
                }
                else if(statusCode == 500)
                {
                    if (flag && (faultCode.containsIgnoreCase('ED270SE') ||
                                 faultCode.containsIgnoreCase('ED270UE') || faultCode.containsIgnoreCase('AEFNEE'))){ 
                                     calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';                       
                                 }else{
                                     calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                                     calloutResult.statusCode = 999;
                                 }
                    
                } 
                else
                {
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                    calloutResult.statusCode = 999;
                }  
                // End
                calloutResult.Response = new SAEProviderMemberSearchInteractionResult();
                system.debug(calloutResult);  
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
    public ACETWSCalloutResult getMemberWS(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID, String providerLastName, String providerFirstName, String npi, String providerFlow){
        system.debug('memberId@@ ' + memberId + ' @@memberDOB@@ ' + memberDOB + ' @@@firstName ' + firstName + ' @@lastName@@ ' + lastName + ' @@groupNumber@@ ' + groupNumber + ' @@searchOption@@ ' + searchOption + ' @@providerFlow@@ ' + providerFlow);
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        String dateStr = SAEUtils.formatDateRequest(memberDOB);
        SAEProviderMemberSearchInteractionResult returnResponse = new SAEProviderMemberSearchInteractionResult();
        try{
            Boolean isStaticResponseChecked = false;
            String responseStr = '';
            HttpResponse response;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            System.debug('@@ SAEMemberProviderWS: getMemberWS: isStaticResponseChecked: '+isStaticResponseChecked);
            
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                String searchparameter='';
                switch on searchOption {
                    when 'MemberIDNameGroupNumberDateOfBirth' {
                        searchparameter=  memberId+'_'+firstName+'_'+lastName+'_'+groupNumber+'_'+memberDOB; 
                        
                    }
                    when 'MemberIDNameDateOfBirth' {
                        searchparameter=  memberId+'_'+firstName+'_'+lastName+'_'+memberDOB; 
                        
                    }
                    when 'MemberIDName'{
                        searchparameter=  memberId+'_'+firstName+'_'+lastName; 
                    }
                    when 'MemberIDLastNameDateOfBirth' {
                        searchparameter=  memberId+'_'+lastName+'_'+memberDOB; 
                    }
                    when 'MemberIDFirstNameDateOfBirth'{
                        searchparameter=  memberId+'_'+firstName+'_'+memberDOB; 
                    }
                    when 'NameDateOfBirth' {
                        searchparameter=  firstName+'_'+lastName+'_'+memberDOB; 
                    }
                    when 'MemberIDDateOfBirth'{
                        searchparameter=  memberId+'_'+memberDOB; 
                    }
                    when else {
                        System.debug('default');
                    }
                }
                if(String.isNotBlank(searchparameter)) {
                    response = SAEUtils.getResponse(searchparameter);
                }
            } else {
                String reqMethod='GET';
                String endPoint = ISL_Webservice_Config__c.getInstance('SAE_ProviderSearch').Value__c;
                //US2034277 : TECH - Eligibility V2 Request Changes :START
                List<String> reqParaLst;
                String resultQuery = '';
                String strTaxIdNumber = '';
                String strProviderNameID = '';
                if(providerFlow == 'Provider Not Found' || providerFlow == 'No Provider To Search' || providerFlow == 'Other') {
                    providerLastName = 'ACET'; 
                    strTaxIdNumber = '9999999';
                    strProviderNameID = '9999999';
                    reqParaLst = new List<String>{searchOption,EncodingUtil.urlEncode(firstName,'UTF-8'),EncodingUtil.urlEncode(lastName, 'UTF-8'),payerID,providerLastName,'',dateStr,groupNumber,memberId,'','',strTaxIdNumber,strProviderNameID};
                        resultQuery = SAEWebservice.formQueryString(reqParaLst);
                } else {
                    //reqParaLst = new List<String>{searchOption,firstName,lastName,payerID,strProviderLastName,'',dateStr,groupNumber,memberId,'','',strTaxIdNumber,strProviderNameID};
                    resultQuery += '?searchOption=' + searchOption + '&firstName='+ EncodingUtil.urlEncode(firstName, 'UTF-8') + '&lastName='+ EncodingUtil.urlEncode(lastName, 'UTF-8') + '&payerID=' + payerID + '&providerLastName=' + EncodingUtil.urlEncode(String.isNotBlank(providerLastName)?providerLastName:'', 'UTF-8') + '&providerFirstName=' + EncodingUtil.urlEncode(String.isNotBlank(providerFirstName)?providerFirstName:'', 'UTF-8') + '&dateOfBirth=' + memberDOB + '&groupNumber=' + groupNumber + '&memberId='+ memberId + '&serviceStart=&serviceEnd=&npi=' + npi;
                }
                
                //List<String> reqParaLst = new List<String>{searchOption,firstName,lastName,'87726','LOTSOFF','DAVID','1205807328',dateStr,groupNumber,memberId,'',''};
                //US2034277 : TECH - Eligibility V2 Request Changes
                //List<String> reqParaLst = new List<String>{searchOption,firstName,lastName,payerID,strProviderLastName,'',dateStr,groupNumber,memberId,'','',strTaxIdNumber,strProviderNameID};
                //US2034277 : TECH - Eligibility V2 Request Changes :END    
                
                system.debug('resultQuery@@@ ' + resultQuery);
                
                ////Only To test future policies
                if (memberId == '85969010' && memberDOB == '1962-11-05'){
                    //resultQuery = '?searchOption=MemberIDDateOfBirth&payerID=87726&providerLastName=ACET&providerFirstName=DAVID&npi=1205807328&dateOfBirth=1962-11-05&memberId=859690190&serviceStart=2020-01-01';
                    //US2034277 : TECH - Eligibility V2 Request Changes
                    resultQuery = '?searchOption=MemberIDDateOfBirth&payerID=87726&providerLastName=ACET&dateOfBirth=1962-11-05&memberId=859690190&serviceStart=2020-01-01&taxIdNumber=9999999&providerNameID=9999999';
                }
                system.debug('resultQuery@@@222 ' + resultQuery);
                
                StaticResource responseJSONSR = null;
                String responseBody;
                
                response = SAEWebservice.makeCallout(resultQuery,endPoint,reqMethod);
            }
			responseStr = response.getBody();   
            system.debug('ResponseBody** ' + responseStr);
            
            if(response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    calloutResult.statusCode= response.getStatusCode();
                    SAEEligibilityResponseJSON2Apex json2Apex = SAEEligibilityResponseJSON2Apex.parse(responseStr);
                    List<SAEEligibilityResponseJSON2Apex.MemberPolicies> memberpolicies = new List<SAEEligibilityResponseJSON2Apex.MemberPolicies>();
                    List<SAEProviderMemberSearchInteractionResult.memberProviderResult> wrapRespToreturn = new List<SAEProviderMemberSearchInteractionResult.memberProviderResult>();
                    SAEProviderMemberSearchInteractionResult.InteractionOverView interviewOverViewCard = new SAEProviderMemberSearchInteractionResult.InteractionOverView();
                    SAEProviderMemberSearchInteractionResult.InteractionSubjectCard subjectCard = new SAEProviderMemberSearchInteractionResult.InteractionSubjectCard();
                    // DE275005 incorrect GroupNumber mapping - 01/11/2019 - Sarma : adding 2 new var
                    List<SAEEligibilityResponseJSON2Apex.MemberPolicies> selectedPolicies = new List<SAEEligibilityResponseJSON2Apex.MemberPolicies>();
                    SAEEligibilityResponseJSON2Apex.MemberPolicies selectedPolicy;
                    
                    if(json2Apex != null){
                        if(json2Apex.memberPolicies != null){
                            memberpolicies = json2Apex.memberPolicies;
                            for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){
                                
                                if(policies.PolicyInfo != null){
                                    subjectCard.memberId = policies.PolicyInfo.memberId;
                                    wrapRespToreturn = returnResponseData(policies);  
                                    break;
                                }   
                                
                            }
                            returnResponse.memberProviderResultlst = wrapRespToreturn;
                            system.debug('returnResponse.memberProviderResultlst@@@ ' + returnResponse.memberProviderResultlst);
                            //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                            Map<string,string> polciygroupToPayerIdMap = new Map<string,string>();
                            // DE275005 	incorrect GroupNumber mapping - 01/11/2019 - Sarma : Start
                            for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){
                                string isThisPoilcyActive = 'F';//US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                if(policies.PolicyInfo != null){
                                    if(policies.PolicyInfo.policyStatus.contains('Active') || policies.PolicyInfo.policyStatus.contains('active')){ 
                                        selectedPolicies.add(policies);    
                                        isThisPoilcyActive = 'T';//US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                    }
                                    }
                                //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga - Start
                                if(string.isNotBlank(policies.insuranceInfo.payerId) && string.isNotBlank(policies.transactionId) ){
                                    polciygroupToPayerIdMap.put(policies.transactionId,policies.insuranceInfo.payerId+';;'+isThisPoilcyActive);
                                }
                            }
                            System.debug('===@@polciygroupToPayerIdMap132'+polciygroupToPayerIdMap);
                            if(!polciygroupToPayerIdMap.isEmpty()){
                                subjectCard.policyandPayerMap = polciygroupToPayerIdMap;
                            }
                            //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga - End
                            System.debug('POLICY WEBSERVICE:::: selected policy list size : '+selectedPolicies.size());
                            System.debug('POLICY WEBSERVICE:::: selected policy list : '+selectedPolicies);
                            if(selectedPolicies.size()>0){
                                selectedPolicy = selectedPolicies[0];
                            } else{
                                
                                selectedPolicy = memberpolicies[0];
                            }
                            // DE275005 : End
                        }
                        //Durga
                        if(json2Apex != null){
                            if(json2Apex.searchQuery != null){
                                subjectCard.searchQueryPayerId = String.isNotBlank(json2Apex.searchQuery.payerID)?json2Apex.searchQuery.payerID:'';
                            }
                        }
                        if(json2Apex != null){
                            // DE275005 incorrect GroupNumber mapping - 01/11/2019 - Sarma 
                            // Changing variable to single object from list of objects & removing for loop.
                            if(selectedPolicies != null){ 
                                SAEEligibilityResponseJSON2Apex.MemberPolicies policies = selectedPolicy; 
                                // for(SAEEligibilityResponseJSON2Apex.MemberPolicies policies : memberpolicies){ 
                                if(policies.patientInfo != null){
                                    System.debug('policies.patientInfo@@@ ' + policies.patientInfo);
                                    for(SAEEligibilityResponseJSON2Apex.PatientInfo patientInfoObj : policies.patientInfo){
                                        if(patientInfoObj.searched == 'true'){
                                            if(String.isNotBlank(patientInfoObj.firstName) || String.isNotBlank(patientInfoObj.middleName) || String.isNotBlank(patientInfoObj.lastName) ){
                                                subjectCard.subjectName = 'Subject'+' '+':'+' '+patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                            }
                                            if(String.isNotBlank(patientInfoObj.firstName) || String.isNotBlank(patientInfoObj.middleName) || String.isNotBlank(patientInfoObj.lastName) ){
                                                subjectCard.memberName = patientInfoObj.firstName + ' ' + patientInfoObj.middleName + ' ' + patientInfoObj.lastName ;
                                                subjectCard.firstName = patientInfoObj.firstName;
                                                subjectCard.middleName = patientInfoObj.middleName;
                                                subjectCard.lastName = patientInfoObj.lastName; 
                                            }
                                            subjectCard.memberDOB = String.isNotBlank(patientInfoObj.dateOfBirth) ?  SAEUtils.formatDate(patientInfoObj.dateOfBirth) : '';
                                            subjectCard.gender = String.isNotBlank(patientInfoObj.gender) ? patientInfoObj.gender : '' ;
                                            subjectCard.SSN = String.isNotBlank(patientInfoObj.SSN) ? patientInfoObj.SSN : '' ;
                                            subjectCard.EEID = String.isNotBlank(patientInfoObj.EEID) ? patientInfoObj.EEID : '' ;
                                            subjectCard.relationship = String.isNotBlank(patientInfoObj.relationship) ? patientInfoObj.relationship : '' ;    
                                            system.debug('gender**'+subjectCard.gender+'relation**'+subjectCard.relationship);
                                            subjectCard.age = Integer.valueOf(SAEUtils.getAgeFromBirthday(patientInfoObj.dateOfBirth));
                                            system.debug('subjectCard@@@ ' + subjectCard);
                                        }
                                    }
                                }
                                if(policies.insuranceInfo != null){
                                    subjectCard.groupNumber = String.isNotBlank(policies.insuranceInfo.groupNumber)?policies.insuranceInfo.groupNumber:'';
                                }
                                //}
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
                        
                        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
                        ACETWSCalloutResult findInvidualCalloutResult = null;
                        findInvidualCalloutResult = findIndividualWS.findIndividual(memberId);
                        SAEProviderMemberSearchInteractionResult findInvidualresultwrap = new SAEProviderMemberSearchInteractionResult();                 
                        SAEProviderMemberSearchInteractionResult.InteractionSubjectCard subjectCardRec = subjectCard;
                        
                        if (findInvidualCalloutResult.Success != null && findInvidualCalloutResult.Success){
                            findInvidualresultwrap = (SAEProviderMemberSearchInteractionResult)findInvidualCalloutResult.Response;
                            for(SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch memberList:findInvidualresultwrap.lstSAEMemberStandaloneSearch){
                                if(subjectCardRec.firstName == memberList.firstName && subjectCardRec.lastName == memberList.lastName && subjectCardRec.memberDOB == memberList.birthDate){
                                    subjectCardRec.SSN = memberList.SSN;
                                    
                                }
                            }
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
            }else{
                system.debug('Error@@@ ' + response.getBody());
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false; 
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                // US1813580 - Error Message Translation - Begin
                Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(responseStr);
                String faultCode = (String) httpResponseJSON.get('faultCode');
                System.debug('@@@ fault code 400:: ' + faultCode);
                if(response.getStatusCode() == 400)
                {                    
                    if (faultCode != null && (faultCode.containsIgnoreCase('AAA:58') || faultCode.containsIgnoreCase('AAA:72') 
                                              || faultCode.containsIgnoreCase('AAA:73') || faultCode.containsIgnoreCase('AAA:76') || 
                                              faultCode.containsIgnoreCase('AAA:79'))) { // == 'AAA:72'
                                                  //calloutResult.Message = SAEMemberProviderWS.getErrorMessage('AAA:72');
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
                                              }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270UG'))){ /** US1964362  Added by Avish 11/25/2019**/
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';                       
                                              }else if (faultCode != null && (faultCode.containsIgnoreCase('AAA:Fault Code'))){
                                                  String[] faultCodeMsg = faultCode.split(':');
                                                  String[] faultCodeMsg2 = faultCodeMsg[1].split(' ');
                                                  String faultCodeOrignal = faultCodeMsg[0]+faultCodeMsg2[0]+faultCodeMsg2[1];
                                                  System.debug('@@@ fault code 400: ' + faultCode);
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCodeOrignal) + '(' + faultCode + ')';   
                                                  System.debug('@@@ fault code Message: ' + SAEMemberProviderWS.getErrorMessage(faultCodeOrignal));
                                              }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270IP'))){
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                              }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270BP'))){
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')'; //SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                              }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270BR'))){
                                                  calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                              }                    
                    else {
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400) + '(' + faultCode + ')';
                    }
                }else if(response.getStatusCode() == 404)
                {
                    if (faultCode != null && (faultCode.containsIgnoreCase('AEFNND'))){ 
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }else{
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404) + '(' + faultCode + ')';
                    }
                    
                }else if(response.getStatusCode() == 406){
                    if (faultCode != null && (faultCode.containsIgnoreCase('ED270IA'))){ 
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }
                }
                else if(response.getStatusCode() == 424){
                    if (faultCode != null && (faultCode.containsIgnoreCase('ED270UR'))){
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                    }else if (faultCode != null && (faultCode.containsIgnoreCase('AAA:42'))){
                        String[] faultCodeMsg = faultCode.split(':');
                        String temp = faultCodeMsg[0]+faultCodeMsg[1];
                        system.debug('temp>>> ' + temp);
                        calloutResult.Message = SAEMemberProviderWS.getErrorMessage(temp) + '(' + faultCode + ')';
                    }
                }
                else if(response.getStatusCode() == 500)
                {
                    if (faultCode != null && (faultCode.containsIgnoreCase('ED270SE') || 
                                              faultCode.containsIgnoreCase('ED270UE') || faultCode.containsIgnoreCase('AEFNEE'))){ 
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';                       
                                              }else{
                                                  calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                                                  calloutResult.statusCode = 999;
                                              }
                    
                } 
                else
                {
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                    calloutResult.statusCode = 999;
                }  
                // End
                calloutResult.Response = new SAEProviderMemberSearchInteractionResult();
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
    
    private static List<SAEProviderMemberSearchInteractionResult.memberProviderResult> returnResponseData(SAEEligibilityResponseJSON2Apex.MemberPolicies pat){
        SAEProviderMemberSearchInteractionResult.memberProviderResult returnObj = new SAEProviderMemberSearchInteractionResult.memberProviderResult();
        List<SAEProviderMemberSearchInteractionResult.memberProviderResult> wrapperLst = new List<SAEProviderMemberSearchInteractionResult.memberProviderResult>();
        List<SAEEligibilityResponseJSON2Apex.PatientInfo> patInfoLst = null;
        if(pat.patientInfo != null){
            patInfoLst = pat.patientInfo;
            if(patInfoLst != null && patInfoLst.size() > 0){
                for(SAEEligibilityResponseJSON2Apex.PatientInfo patObj : patInfoLst){
					returnObj = new SAEProviderMemberSearchInteractionResult.memberProviderResult();
                    returnObj.firstName = patObj.firstName;
                    returnObj.middleName = patObj.middleName;
                    returnObj.lastName = patObj.lastName;
                    returnObj.name = patObj.firstName + ' ' + patObj.middleName + ' '  + patObj.lastName;
                    returnObj.dob = SAEUtils.formatDate(patObj.dateOfBirth);
                    returnObj.relationship = patObj.relationship;
                    wrapperLst.add(returnObj);
                }
            }                        
        }
        return wrapperLst;
    }
    
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
    
    
}