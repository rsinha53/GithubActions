public with sharing class SAEClaimSearchWS{ 

    public ACETWSCalloutResult getClaimWS(SAEClaimSearchController.ClaimInputs claimInputs){
        System.debug('The claim input coming is: '+ claimInputs);
        String responseStr = '';
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        SAEClaimSearchResult returnData = new SAEClaimSearchResult();
        List<SAEClaimSearchResult> result = new List<SAEClaimSearchResult>();
        List<SAEClaimSearchResult.ClaimSearchResult> returnresponse = new List<SAEClaimSearchResult.ClaimSearchResult>();

        List<SAEClaimSummaryJSON2Apex.cls_claims> claimsResponseArray = new List<SAEClaimSummaryJSON2Apex.cls_claims>();
        try{
            Map<String, String> reqPramsMap = new Map<String, String>();
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();

            if(String.isNotBlank(claimInputs.claimNumber)){
                 reqPramsMap.put('claimNumber', claimInputs.claimNumber);
                 wsCallOut.serviceName = 'LinkClaimSearch';
            }
            else{
                  reqPramsMap.put('memberId', claimInputs.memberId);
                  reqPramsMap.put('patientDob', claimInputs.memberDOB);
                  reqPramsMap.put('isMemberOnly', 'true');
                  wsCallOut.serviceName = 'LinkClaimSearchByMember';
            }
			claimInputs.taxId = String.isNotBlank(claimInputs.taxId)?claimInputs.taxId:'999999999';

            reqPramsMap.put('tin', claimInputs.taxId );
            reqPramsMap.put('payerId', claimInputs.payerId);
            String invalidDate='Invalid Date';
            if(!invalidDate.equals(claimInputs.FromDate)){
                reqPramsMap.put('firstSrvcDt', claimInputs.FromDate);
            }
            if(!invalidDate.equals(claimInputs.ToDate)){
                reqPramsMap.put('lastSrvcDt', claimInputs.ToDate);
            }
            if(String.isNotBlank(claimInputs.taxId)){
                if(claimInputs.taxId =='999999999'){
                    reqPramsMap.put('isMemberOnly', 'true');
                }
            }


            wsCallOut.requestParamsMap = reqPramsMap;
            HttpResponse response = wscallout.getResponse();


            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            if(response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    calloutResult.statusCode= response.getStatusCode();
                    SAEClaimSummaryJSON2Apex json2Apex = SAEClaimSummaryJSON2Apex.parse(responseStr);
                    if(json2Apex != null){
                        if(json2Apex.claims != null){
                            claimsResponseArray = json2Apex.claims;
                            for(SAEClaimSummaryJSON2Apex.cls_claims claims : claimsResponseArray){
                                SAEClaimSearchResult.ClaimSearchResult res = new SAEClaimSearchResult.ClaimSearchResult();
                                res.claimNumber = String.isNotBlank(claims.claimNumber)?claims.claimNumber:'--';
                                res.status = String.isNotBlank(claims.claimStatus)?claims.claimStatus:'--';
                                if(claims.provInfo != null){
                                    SAEClaimSummaryJSON2Apex.cls_provInfo provInfo = new SAEClaimSummaryJSON2Apex.cls_provInfo();
                                    provInfo = claims.provInfo;
                                    if(provInfo.submitted != null){
                                        SAEClaimSummaryJSON2Apex.cls_submitted submitted = new SAEClaimSummaryJSON2Apex.cls_submitted();
                                        submitted = provInfo.submitted;
                                        res.taxID = getValueoff(submitted.tin);
                                        res.providerName = getValueoff(submitted.billProvNm);
                                        res.providerID =  getValueoff(submitted.billingMpin); 
                                    }
                                    if(provInfo.adjudicated != null){
                                        SAEClaimSummaryJSON2Apex.cls_adjudicated adjudicated = new SAEClaimSummaryJSON2Apex.cls_adjudicated();
                                        adjudicated = provInfo.adjudicated;
                                        res.adjTaxID = getValueoff(adjudicated.tin);
                                        res.adjProviderName = getValueoff(adjudicated.billProvNm);
                                        res.adjProviderID =  getValueoff(adjudicated.billingMpin);
										res.tinPrfx = getValueoff(adjudicated.tinPrfx);
                                        res.tinSufx = getValueoff(adjudicated.tinSufx);
                                        res.tin = getValueoff(adjudicated.tin);
                                        res.adjservicingMpin=getValueoff(adjudicated.servicingMpin);
                                    }
                                }

                                if(claims.claimSummary != null){
                                     SAEClaimSummaryJSON2Apex.cls_claimSummary summaryInfo = new SAEClaimSummaryJSON2Apex.cls_claimSummary();
                                    summaryInfo = claims.claimSummary;
                                    res.claimtype = summaryInfo.claimType;
                                    res.paperlessInd = summaryInfo.paperlessInd;
                                    res.DOSStart = getValueoff(summaryInfo.firstSrvcDt);
                                    res.DOSEnd = getValueoff(summaryInfo.lastSrvcDt);
                                    res.charged =getValueoff(summaryInfo.totalChargedAmt);
                                    res.receivedDate = getValueoff(summaryInfo.receivedDt);
                                    res.processDate =  getValueoff(summaryInfo.processedDt);
									res.totalDeductibleAmt = getValueoff(summaryInfo.deductibleAmt);
                                    res.totalCoinsuranceAmt =  getValueoff(summaryInfo.totalCoinsAmt);
                                    res.provWriteOffAmt = getValueoff(summaryInfo.provWriteOffAmt);
                                    res.totalPtntRespAmt = getValueoff(summaryInfo.totalPtntRespAmt);
                                    res.networkStatus = getValueoff(summaryInfo.networkStatus);
									res.billTyp = getValueoff(summaryInfo.billTyp); //Raviteja May 10 2021 Team Blinkers
                                    res.drgNbr = getValueoff(summaryInfo.drgNbr);
                                    res.totalChargedAmt = getValueoff(summaryInfo.totalChargedAmt);
                                    res.totalAllowdAmt = getValueoff(summaryInfo.totalAllowdAmt);
                                    res.platform = getValueoff(summaryInfo.platform);
                                    res.caeClmNbr = getValueoff(summaryInfo.caeClmNbr);  //US3457078 keyed claim
                                    res.paperlessInd = getValueoff(summaryInfo.paperlessInd); // Type
                                    res.resubmCaeClmNbr = getValueoff(summaryInfo.resubmCaeClmNbr);  //US3457078 original claim
                                    res.chwyIcn = getValueoff(summaryInfo.chwyIcn);  //US3457078
                                    List<SAEClaimSearchResult.cls_claimCodes> claimCodesList = new List<SAEClaimSearchResult.cls_claimCodes>();
                                                                        for(SAEClaimSummaryJSON2Apex.cls_claimCodes codesRec: summaryInfo.claimCodes){
                                                                            SAEClaimSearchResult.cls_claimCodes claimCodeRec = new SAEClaimSearchResult.cls_claimCodes();
                                                                            claimCodeRec.code = codesRec.code;
                                                                            claimCodeRec.description = codesRec.description;
                                                                            claimCodeRec.type = codesRec.type;
                                                                            claimCodesList.add(claimCodeRec);
                                                                        }
                                                                        res.claimCodes = claimCodesList;
                                    if(summaryInfo.chkInfo!=null && !summaryInfo.chkInfo.isEmpty()) {
                                        system.debug('chkInfo@@@'+summaryInfo.chkInfo);
                                        SAEClaimSummaryJSON2Apex.cls_chkInfo checkInfo=new SAEClaimSummaryJSON2Apex.cls_chkInfo();
                                        Integer i=1;
                                        date paymentIssueDt;
                                        for(SAEClaimSummaryJSON2Apex.cls_chkInfo s : summaryInfo.chkInfo){
                                            if(s.paymentIssueDt !=null && s.paymentIssueDt !=''){
                                                if(i == 1){
                                                    checkInfo = s;
                                                    paymentIssueDt = date.parse(s.paymentIssueDt);
                                                    i++;
                                                }else if(paymentIssueDt < date.parse(s.paymentIssueDt)){
                                                    checkInfo = s;
                                                    paymentIssueDt = date.parse(s.paymentIssueDt);
                                                }

                                            }
                                            res.chkInfo=checkInfo.chkSrsDesg+checkInfo.chkNbr;
                                        }
                                    }
                                    String TopsAdditionalInfo = '--';
                                    String contractId = '--';
                                    if(summaryInfo.topsAdditionalInfo!=null && !summaryInfo.topsAdditionalInfo.isEmpty()){
                                        for(SAEClaimSummaryJSON2Apex.TopsAdditionalInfo s : summaryInfo.topsAdditionalInfo){
                                            TopsAdditionalInfo=s.filmOfficeNumber+s.filmLocatorNumber;
                                            contractId=getValueoff(s.contractId);
                                        }
                                    }else{
                                        if(summaryInfo.caeClmNbr !=null && String.isNotBlank(summaryInfo.caeClmNbr)){
                                            String caeClmNbr = summaryInfo.caeClmNbr;
                                            string a1 = caeClmNbr.removeEnd('00');
                                            string a2 = caeClmNbr.left(3);
                                            string a3 = a1.removeStart(caeClmNbr.left(3));
                                            string a4 = a3+a2;
                                            TopsAdditionalInfo = a4;

                                        }
                                    }
                                     if(summaryInfo.cosmosAdditionalInfo!=null && !summaryInfo.cosmosAdditionalInfo.isEmpty()){
                                        for(SAEClaimSummaryJSON2Apex.cosmosAdditionalInfo s : summaryInfo.cosmosAdditionalInfo){
                                            res.referralId = getValueoff(s.referralId);
                                        }
                                    }
                                    res.TopsAdditionalInfo = TopsAdditionalInfo;
                                    res.contractId = contractId;
                                    res.totalCopayAmt =  getValueoff(summaryInfo.totalCopayAmt);
                                    res.totalCoinsAmt = getValueoff(summaryInfo.totalCoinsAmt);
                                    res.totalPaidAmt = getValueoff(summaryInfo.totalPaidAmt);
                                    res.sbmtMembrId = getValueoff(summaryInfo.sbmtMembrId);
                                    res.provNotCovAmt =  getValueoff(summaryInfo.provNotCovAmt);
                                    //res.referralId = getValueoff(summaryInfo.referralId);
									res.ptntAcctNbr = summaryInfo.ptntAcctNbr;
                                    if( String.isNotBlank(summaryInfo.totalChargedAmt) && String.isNotBlank(summaryInfo.totalAllowdAmt)){
                                        Decimal deniedAmt = Decimal.valueOf(summaryInfo.totalChargedAmt) - Decimal.valueOf(summaryInfo.totalAllowdAmt);
                                        res.totalDeniedAmount =  String.valueOf(deniedAmt);
                                    }
                                    else{
                                        res.totalDeniedAmount = '0.00';
                                    }
                                    if(String.isNotBlank(summaryInfo.networkStatus)){
                                        if(summaryInfo.networkStatus == 'I'){
                                            res.claimBenefitlevel = 'INN';
                                        }else if(summaryInfo.networkStatus == 'O'){
                                            res.claimBenefitlevel = 'OON';
                                        }
                                    }else{
                                        res.claimBenefitlevel =  '--';
                                    }
                                }
                                if(claims.memberInfo != null){
                                    SAEClaimSummaryJSON2Apex.cls_memberInfo memberInfo = new SAEClaimSummaryJSON2Apex.cls_memberInfo();
                                    memberInfo = claims.memberInfo;
                                    system.debug('memberInfo'+memberInfo);
                                    res.ptntFn = memberInfo.ptntFn;
                                    res.ptntLn = memberInfo.ptntLn;
                                    res.ptntDob = memberInfo.ptntDob;
                                    res.policyNbr=memberInfo.policyNbr;
                                }

                                returnresponse.add(res);


                            }
                            returnData.claimResultLst = returnresponse;

                        }
                }
                calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = returnData;
                }
            }else{
                system.debug('Error@@@ ' + response.getBody());
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false;
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();

                if(response.getStatusCode() == 400)
                {
                    system.debug('responseStr>>> ' + responseStr);
                    Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(responseStr);
                    Map<String, Object> errorHandlingMap = (Map<String, Object>)httpResponseJSON.get('error');
                    List<Object> listErrorMap = (List<Object>)errorHandlingMap.get('errors');
                    map<String,Object> errorMsgObj = (map<String,Object>) listErrorMap[0];
					Integer index = ((String)errorMsgObj.get('message')).indexOf(':');
                    calloutResult.Message = ((String)errorMsgObj.get('message')).substring(index + 1);
                }
               	calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false;
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Message = response.getBody();
                calloutResult.Response = getErrorResponse(response.getStatusCode(),response.getBody());
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


    public static ACETWSCalloutResult getErrorResponse(Integer statusCode, String responseBody) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        calloutResult.Success = false;
        calloutResult.message = '';
        calloutResult.statusCode = statusCode;
        Map < String, Object > httpResponseJSON = (Map < String, Object > ) JSON.deserializeUntyped(responseBody);
        String faultCode = (String) httpResponseJSON.get('faultCode');

        Map<String, Object> errorHandlingMap = (Map<String, Object>)httpResponseJSON.get('error');
        List<Object> listErrorMap = (List<Object>)errorHandlingMap.get('errors');
        map<String,Object> errorMsgObj = (map<String,Object>) listErrorMap[0];
        system.debug('@@code>>> ' + errorMsgObj.get('code'));
        String errorCode=(String) errorMsgObj.get('code');

        if (statusCode == 400) {
            if (faultCode != null && (faultCode.containsIgnoreCase('LCLM_S_102') )) {
                calloutResult.message = getErrorMessage(faultCode) ;
            } else if (faultCode != null && (faultCode.containsIgnoreCase('LCLM_S_103'))) {
                calloutResult.message = getErrorMessage(faultCode);
            } else if (faultCode != null && (faultCode.containsIgnoreCase('LCLM_S_301'))) {
                calloutResult.message = getErrorMessage(faultCode) ;
            }
            if (errorCode != null && ((errorCode.containsIgnoreCase('LCLM_M_401')) ||(errorCode.containsIgnoreCase('LCLM_M_108')))||(errorCode.containsIgnoreCase('LCLM_S_301')) ) {
                calloutResult.showToastMessage=false;
            }
            else{
                calloutResult.showToastMessage=true;
            }
        } else if (statusCode == 401) {
            calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        } else if (statusCode == 404) {
            calloutResult.message = 'No Results Found';
        } else if (statusCode == 500) {
            if (faultCode.containsIgnoreCase('LCLM_S_302')) {
                calloutResult.message = getErrorMessage(faultCode);
            }
        } else if (statusCode == 503) {
                calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
        }
        else {
            calloutResult.message = getErrorMessage(SAEConstants.GN500A);
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }
    // Get Error messages from metadata records
    public static String getErrorMessage(String errorCode) {
        String errorMessage = '';
        AcetErrorMessage__mdt[] errorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c FROM AcetErrorMessage__mdt WHERE DeveloperName =: errorCode];
        if (errorCodes.size() > 0) {
            errorMessage = errorCodes[0].Error_Message__c;
        }
        return errorMessage;
    }
    
    private String getValueoff(String value){
        return String.isNotBlank(value)?value:'--';
    }
}