public class ACET_ReadConsumerEligibilityService 
{
    public ACET_ReadConsumerEligibilityService(){}
    
    // US3308070 - Thanish - 2nd Mar 2021 - modified the method to pass as of date and integrted new webservice framework
    public static ReadConsumerWrapper call_RCED_API(String subscriberId, String policyNumber, String sourceCode, String coverageLevel, String coverageStartDate)// US3308070 - Thanish - 2nd Mar 2021
    {
        ReadConsumerWrapper returnWrapper = new ReadConsumerWrapper();
        returnWrapper.networkKey = null;
        try {
            ADBLoyaltyRequestWrapper loyaltyRequest = getLoyaltyRequest();
            loyaltyRequest.readInput.searchId = subscriberId;
            loyaltyRequest.readInput.policyNumber = policyNumber;
            loyaltyRequest.readInput.sourceCode = sourceCode;
            // Based on Coverage level
            loyaltyRequest.readInput.requestFamilyOrIndividual = coverageLevel.equals('1') ? 'Individual' : 'Family';
            // Passing date
            loyaltyRequest.readInput.asOfDate = coverageStartDate;
            loyaltyRequest.readInput.requestCoverageTimeline = 'CURRENT';
            loyaltyRequest.readInput.requestDemographic = 'NONE';
            loyaltyRequest.readInput.requestHealthCoverage = 'MEDICAL';
            
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'ADBLoyaltyEndpoint';
            wsCallOutFW.requestBody = JSON.serialize(loyaltyRequest);
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            String modResp = httpResponse.getBody();
            // String modResp = httpResponse.getBody().replace('"end"', '"end_x"');
            if(httpResponse.getStatusCode() == 200){
                ADBLoyaltyResponseWrapper loyaltyResponseWrapper = (ADBLoyaltyResponseWrapper) JSON.deserialize(modResp, ADBLoyaltyResponseWrapper.class);
            if(loyaltyResponseWrapper!= null && loyaltyResponseWrapper.readResult != null && loyaltyResponseWrapper.readResult.readOutput != null){
                ADBLoyaltyResponseWrapper.ReadResult rs= loyaltyResponseWrapper.readResult;
                if(!rs.readOutput.eligibilities.isEmpty() && rs.readOutput.eligibilities[0].subscriberDetail != null
                   && rs.readOutput.eligibilities[0].subscriberDetail.eligibility != null){
                    returnWrapper.networkKey = rs.readOutput.eligibilities[0].subscriberDetail.eligibility.networkKey;
                   }
            }
            }

            System.debug('networkKey ' + returnWrapper.networkKey);
            
        } catch (Exception e) {
            returnWrapper.networkKey = null;
            System.debug('Error :: ' + e.getMessage());
        }
        
        return returnWrapper;
    }

	// New COB Implementation
    public static ACET_SAECalloutResult getCOBData(RCEDRequest reqParams){
        System.debug('getCOBData'+reqParams);
        ACET_SAECalloutResult retResponse = new ACET_SAECalloutResult();
        ReadConsumerWrapper returnWrapper = new ReadConsumerWrapper();
        ADBLoyaltyRequestWrapper loyaltyRequest = getLoyaltyRequest();
        loyaltyRequest.readInput.searchId = reqParams.subscriberId;
        loyaltyRequest.readInput.policyNumber = reqParams.policyNumber;
        loyaltyRequest.readInput.sourceCode = reqParams.sourceCode;
        loyaltyRequest.readInput.requestFamilyOrIndividual = 'Family';
        loyaltyRequest.readInput.requestCoverageTimeline = 'TWO_YR_PRIOR';
        loyaltyRequest.readInput.asOfDate = System.now().format('YYYY-MM-dd');
        loyaltyRequest.readInput.requestHealthCoverage = 'ALL';
        loyaltyRequest.readInput.requestCobAndMedicare = 'ALL';
        loyaltyRequest.readInput.requestHealthServices = 'ALL';
        loyaltyRequest.readInput.requestCobAndMedicarePrimarySecondary = 'Y';
        loyaltyRequest.readInput.requestMedicareAndCobDemographic = 'Y';
        try {
			RCEDDetailsForCreateAuth rCEDDetailsForCreateAuth = new RCEDDetailsForCreateAuth();
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'ADBLoyaltyEndpoint';
            wsCallOutFW.requestBody = JSON.serialize(loyaltyRequest);
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            String modResp = httpResponse.getBody().replace('"end"', '"end_x"');
            if(httpResponse.getStatusCode() == 200){
                ACET_RCEDResponse loyaltyResponseWrapper = (ACET_RCEDResponse) JSON.deserialize(modResp, ACET_RCEDResponse.class);
                if(loyaltyResponseWrapper!= null && loyaltyResponseWrapper.readResult != null && loyaltyResponseWrapper.readResult.readOutput != null){
                    if(loyaltyResponseWrapper.readResult.readOutput.eligibilities != null && loyaltyResponseWrapper.readResult.readOutput.eligibilities.size() > 0){
                        ACET_RCEDResponse.eligibility el;
                        if(reqParams.isSubscriber){
                            el = loyaltyResponseWrapper.readResult.readOutput.eligibilities.get(0).subscriberDetail.eligibility;
                        }else{
                            if(loyaltyResponseWrapper.readResult.readOutput.eligibilities.get(0).dependents != null){
                                for(ACET_RCEDResponse.subscriberDetail sub : loyaltyResponseWrapper.readResult.readOutput.eligibilities.get(0).dependents){
								rCEDDetailsForCreateAuth.cesCustomerName=sub.eligibility.demographics.cesCustomerName;//vishnu
                                    if(sub.eligibility.demographics.topsName == reqParams.firstName && sub.eligibility.demographics.dateOfBirth == reqParams.dateOfBirth){
                                        el = sub.eligibility;
                                        break;
                                    }
                                }
                            }
                        }
																											returnWrapper.claimEngineCode=loyaltyResponseWrapper.readResult.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics.claimEngineCode;
                        if(loyaltyResponseWrapper.readResult.readOutput.eligibilities[0].offices != null)
                        returnWrapper.officeNumber=loyaltyResponseWrapper.readResult.readOutput.eligibilities[0].offices[0].officeNumber;																																																																																																						   
                        if(el != null){
                            returnWrapper.dependentNo = reqParams.sourceCode == 'CO' ? el.demographics.dependentNumber : el.demographics.topsSequenceNumber;
                            returnWrapper.regionCode = loyaltyResponseWrapper.readResult.readOutput.eligibilities.get(0).regionCode;
                            //Card Data
                            Map<String,String> resonMap_tc = new Map<String,String>{'A' => 'Part A Only', 
                                    'B' => 'Part B Only', 
                                    'C' => 'Both Parts A and B',
                                    'E' => 'Parts A and D only',
                                    'F' => 'Parts B and D only',
                                    'G' => 'A,B,D'};
                            Map<String,String> resonMap_en = new Map<String,String>{'A' => 'Age',
                                    'B' => 'ESRD',
                                    'D' => 'Disability - Active Working',
                                    'G' => 'Disability - Not Actively Working',
                                    'U' => 'Unknown'};
                            ACET_RCEDResponse.medicares med = el.medicares != null && el.medicares.size() > 0 ? el.medicares.get(0) : null;
                            String medInd = med != null ? med.medicareExistsIndicator : '';
                            if(el.cobs != null && el.cobs.size() > 0){
                                //Gaps
                                returnWrapper.updateSts = '--';
                                returnWrapper.payeeName = '--';
                                // End
                                ACET_RCEDResponse.cobs cob = el.cobs.get(0);
                                String insInd = cob.otherInsuranceIndicator;

                                if(insInd == 'Y'){
                                    returnWrapper.otherIns = 'Yes';
                                    if(cob.cobPrimacies != null && cob.cobPrimacies.size() > 0){
                                        Map<String,String> typeMap = new Map<String,String>{'I' => 'Internal', 'A' => 'Auto', 'C' => 'Commercial'};
                                        returnWrapper.c_type = typeMap.get(cob.cobPrimacies.get(0).otherInsuranceType);
                                        returnWrapper.otherInsPrimary = cob.cobPrimacies.get(0).otherInsurancePrimacy == 'P' ? 'Yes' : 'No';
                                        returnWrapper.primaryEffectiveDates = SAEUtils.formatDate(cob.cobPrimacies.get(0).effectiveDates.start) + '-'+ SAEUtils.formatDate(cob.cobPrimacies.get(0).effectiveDates.end_x);
                                    }else{
                                        returnWrapper.c_type = '--';
                                    }
                                    returnWrapper.eligibleDates = SAEUtils.formatDate(cob.otherInsuranceDates.start) +'-'+ SAEUtils.formatDate(cob.otherInsuranceDates.end_x);
                                }else if(insInd == 'N' && medInd == 'Y'){
                                    returnWrapper.otherIns = 'Yes';
                                    returnWrapper.c_type = 'Medicare';
                                    returnWrapper.eligibleDates = med.medicareEntitlements!=null && med.medicareEntitlements.size() > 0 ? SAEUtils.formatDate(med.medicareEntitlements.get(0).medicareEntitlementEffectiveDates.start) +'-'+ SAEUtils.formatDate(med.medicareEntitlements.get(0).medicareEntitlementEffectiveDates.end_x) : '--';
                                    if(med.medicareEligibilities != null && med.medicareEligibilities.size() > 0 
                                    &&  med.medicareEligibilities.get(0).medicarePrimacies != null 
                                    && med.medicareEligibilities.get(0).medicarePrimacies.size() > 0){
                                        returnWrapper.otherInsPrimary =  med.medicareEligibilities.get(0).medicarePrimacies.get(0).medicarePrimacy == 'P' ? 'Yes' : 'No';
                                        returnWrapper.primaryEffectiveDates =   SAEUtils.formatDate(med.medicareEligibilities.get(0).medicarePrimacies.get(0).medicarePrimacyEffectiveDates.start) +'-'+
                                                                             SAEUtils.formatDate(med.medicareEligibilities.get(0).medicarePrimacies.get(0).medicarePrimacyEffectiveDates.end_x);
                                    }
                                }else if(insInd == 'N' && medInd == 'N'){
                                    returnWrapper.otherIns = 'No';
                                    returnWrapper.c_type = '--';
                                }else{
                                    returnWrapper.otherIns = '--';
                                    returnWrapper.c_type = '--';
                                    returnWrapper.eligibleDates = '--';
                                }
                                if(med != null){
                                    String medEnt = med.medicareEntitlements != null && med.medicareEntitlements.size() > 0 ? med.medicareEntitlements.get(0).entitlementTypeCode : '--';
                                    returnWrapper.medicareInfo = resonMap_en.get(medEnt) + ' / ' + resonMap_tc.get(med.medicareTypeCode);                                            
                                }
                                returnWrapper.lastUpdate = SAEUtils.formatDate(cob.otherInsuranceVerifyDate);
                            }else if(med != null && medInd == 'Y'){
                                // US3441246
                                returnWrapper.otherIns = 'Yes';
                                returnWrapper.c_type = 'Medicare';
                                returnWrapper.eligibleDates = med.medicareEntitlements!=null && med.medicareEntitlements.size() > 0 ? SAEUtils.formatDate(med.medicareEntitlements.get(0).medicareEntitlementEffectiveDates.start) +' - '+ SAEUtils.formatDate(med.medicareEntitlements.get(0).medicareEntitlementEffectiveDates.end_x) : '--';
                                if(med.medicareEligibilities != null && med.medicareEligibilities.size() > 0
                                &&  med.medicareEligibilities.get(0).medicarePrimacies != null
                                && med.medicareEligibilities.get(0).medicarePrimacies.size() > 0){
                                    returnWrapper.otherInsPrimary =  med.medicareEligibilities.get(0).medicarePrimacies.get(0).medicarePrimacy == 'P' ? 'Yes' : 'No';
                                    returnWrapper.primaryEffectiveDates =   SAEUtils.formatDate(med.medicareEligibilities.get(0).medicarePrimacies.get(0).medicarePrimacyEffectiveDates.start) +' - '+
                                                                            SAEUtils.formatDate(med.medicareEligibilities.get(0).medicarePrimacies.get(0).medicarePrimacyEffectiveDates.end_x);
                                }
                                String medEnt = med.medicareEntitlements != null && med.medicareEntitlements.size() > 0 ? med.medicareEntitlements.get(0).entitlementTypeCode : '--';
                                returnWrapper.medicareInfo = resonMap_en.get(medEnt) + ' / ' + resonMap_tc.get(med.medicareTypeCode);
                                returnWrapper.lastUpdate = '--';
                            }

                            //COB History
                            ACET_RCEDResponse.previousCobPrimarySecondary his = el.previousCobPrimarySecondary;
                            ACET_RCEDResponse.previousMedicarePrimarySecondary medHis = el.previousMedicarePrimarySecondary;
                            if(his != null && his.effectiveDates.start == '0001-01-01' && his.effectiveDates.end_x == '9999-12-31' && his.typeCode == '' && his.verifyDate == ''){                               
                                if(medHis != null && (his.effectiveDates.start != '0001-01-01' || medHis.effectiveDates.end_x != '9999-12-31')){
                                    ACET_ReadMemberCobHistory.COBHistoyWrapper cwrap = new ACET_ReadMemberCobHistory.COBHistoyWrapper();
                                    cwrap.updated = '--';
                                    cwrap.oiPrimary = '--'; //Gap
                                    cwrap.oiType = '--'; //Gap
                                    cwrap.payerName = '--'; //Gap
                                    cwrap.eligDates = SAEUtils.formatDate(medHis.effectiveDates.start) + '-' + SAEUtils.formatDate(medHis.effectiveDates.end_x);
                                    cwrap.medicareType = resonMap_tc.get(medHis.typeCode);//Gap
                                    cwrap.medicareEntReason = '--';//Gap
                                    returnWrapper.cobHistory = new List<ACET_ReadMemberCobHistory.COBHistoyWrapper>{cwrap};
                                }
                            }else if(his != null){
                                ACET_ReadMemberCobHistory.COBHistoyWrapper cwrap = new ACET_ReadMemberCobHistory.COBHistoyWrapper();
                                cwrap.updated = his.verifyDate;
                                cwrap.oiPrimary = '--'; //Gap
                                cwrap.oiType = his.typeCode;
                                cwrap.payerName = '--'; //Gap
                                cwrap.eligDates = SAEUtils.formatDate(his.effectiveDates.start) + '-' + SAEUtils.formatDate(his.effectiveDates.end_x);
                                cwrap.medicareType = medHis!=null ? resonMap_tc.get(medHis.typeCode) : '--';
                                cwrap.medicareEntReason = '--';//Gap
                                returnWrapper.cobHistory = new List<ACET_ReadMemberCobHistory.COBHistoyWrapper>{cwrap};
                            }

                            // Details for createAuth
                            // US3507486 - Create Auth  Update Funding Arrangement Value : Sarma - 10th May 2021
                            if(el.healthCoverages != null && el.healthCoverages.size() > 0){
                                List<ACET_RCEDResponse.healthCoverages> healthCoveragesList = new List<ACET_RCEDResponse.healthCoverages>();
                                healthCoveragesList = el.healthCoverages;

                                for(ACET_RCEDResponse.healthCoverages healthCoverageObj : healthCoveragesList) {

                                    if(healthCoverageObj.policyNumber.equals(reqParams.policyNumber) && healthCoverageObj.coverageType.equals('M')){
                                        rCEDDetailsForCreateAuth.fundingArrangement = healthCoverageObj.fundingArrangement;
                                        // US3507488: Create Auth Med Nec Indicator - Swapnil 13 May 2021
                                        rCEDDetailsForCreateAuth.obligorID = healthCoverageObj.obligorId;
                                        rCEDDetailsForCreateAuth.sharedArrangementID = healthCoverageObj.sharedArrangementCode;
                                        rCEDDetailsForCreateAuth.productClassifierType = healthCoverageObj.productClassifier;
                                        rCEDDetailsForCreateAuth.productCode = healthCoverageObj.productCode;
										rCEDDetailsForCreateAuth.siteOfCareCoreMed = healthCoverageObj.siteOfCareCoreMed;//added by vishnu start
                                        if(healthCoverageObj.topsCoverageSet!=null)
                                        {
                                            rCEDDetailsForCreateAuth.baseMme=healthCoverageObj.topsCoverageSet.baseMme;
                                            rCEDDetailsForCreateAuth.medicare=healthCoverageObj.topsCoverageSet.medicare;
                                            rCEDDetailsForCreateAuth.topsCoverageSetId=healthCoverageObj.topsCoverageSet.topsCoverageSetId;
                                            rCEDDetailsForCreateAuth.cme=healthCoverageObj.topsCoverageSet.cme;
                                        }//added by vishnu end
                                        break;
                                    }
                                }
                                returnWrapper.rCEDDetailsForCreateAuth = rCEDDetailsForCreateAuth;
                            }
                            // US3507486 - Ends
                        }
                    }
                }
                System.debug(JSON.serialize(returnWrapper));
                retResponse.response = returnWrapper;
                retResponse.isSuccess = true;
                retResponse.statusCode = 200;
            }else{
                retResponse.isSuccess = false;
                retResponse.message = httpResponse.getStatus();
                retResponse.statusCode = httpResponse.getStatusCode();
            }
        } catch (Exception e) {
            retResponse.isSuccess = false;
            retResponse.message = e.getMessage();
            retResponse.statusCode = 999;
            System.debug('Exception RCED::' + e.getMessage());
            System.debug('Exception RCED::' + e.getStackTraceString());
        }
        return retResponse;
    }

    public static ADBLoyaltyRequestWrapper getLoyaltyRequest(){
        ADBLoyaltyRequestWrapper loyaltyRequest = new ADBLoyaltyRequestWrapper();
        loyaltyRequest.readInput  = new ADBLoyaltyRequestWrapper.readInput();
        loyaltyRequest.readInput.controlModifiers = new ADBLoyaltyRequestWrapper.ControlModifiers();
        loyaltyRequest.readInput.controlModifiers.cdbSystemParameters = new ADBLoyaltyRequestWrapper.CdbSystemParameters();
        loyaltyRequest.readInput.controlModifiers.ndbSystemParameters = new ADBLoyaltyRequestWrapper.NdbSystemParameters();
        loyaltyRequest.readInput.controlModifiers.cdbSystemParameters.applicationId = 'ACT';
        loyaltyRequest.readInput.controlModifiers.cdbSystemParameters.roleId = 'ACT';
        loyaltyRequest.readInput.controlModifiers.ndbSystemParameters.platformId = '';
        loyaltyRequest.readInput.controlModifiers.ndbSystemParameters.projectId = '';
        loyaltyRequest.readInput.controlModifiers.requestCodeDescriptionLookup = 'false';
        loyaltyRequest.readInput.controlModifiers.requestProviderDemographic = 'false';
        loyaltyRequest.readInput.controlModifiers.requestTopsEligibilityInformation = 'true';
        loyaltyRequest.readInput.controlModifiers.requestWrittenLanguagePreference = 'false';
        loyaltyRequest.readInput.searchId = '';
        loyaltyRequest.readInput.policyNumber = '';
        loyaltyRequest.readInput.sourceCode = '';
        loyaltyRequest.readInput.requestFamilyOrIndividual = '';
        loyaltyRequest.readInput.asOfDate = '';
        loyaltyRequest.readInput.requestCoverageTimeline = 'CURRENT';
        loyaltyRequest.readInput.requestDemographic = 'NONE';
        loyaltyRequest.readInput.requestHealthCoverage = 'MEDICAL';
        loyaltyRequest.readInput.requestCobAndMedicare = 'NONE';
        loyaltyRequest.readInput.requestHealthServices = 'NONE';
        loyaltyRequest.readInput.requestLifeAndDisability = 'NONE';
        loyaltyRequest.readInput.requestFinancial = 'NONE';
        loyaltyRequest.readInput.requestPreExist = 'NONE';
        loyaltyRequest.readInput.requestComments = 'NONE';
        loyaltyRequest.readInput.requestTopsCancelDate = 'NONE';
        loyaltyRequest.readInput.requestFamilyLastUpdateDate = 'N';
        loyaltyRequest.readInput.requestVendorAndCalendar = 'N';
        loyaltyRequest.readInput.requestCobAndMedicarePrimarySecondary = 'N';
        loyaltyRequest.readInput.requestPolicyAmounts = 'N';
        loyaltyRequest.readInput.blsEligibilityInd = 'Y';
        loyaltyRequest.readInput.requestCamsDemographic = 'N';
        loyaltyRequest.readInput.requestMedicareAndCobDemographic = 'N';
        loyaltyRequest.readInput.requestAuthorizedRepresentative = 'N';
        loyaltyRequest.readInput.requestExpandedCoverageTimelines = 'false';
        loyaltyRequest.readInput.requestPrimeLifeAndDisability = 'false';
        loyaltyRequest.readInput.requestCptin = 'N';
        loyaltyRequest.readInput.requestDocumentLetterSuppression = 'N';
        loyaltyRequest.readInput.requestMemberLoyalty = 'N';
        loyaltyRequest.readInput.requestMemberPopulation = 'N';
        loyaltyRequest.readInput.requestEmail = '';
        return loyaltyRequest;
    }

    // Future proofing - Add attribute and return if needed
    public class ReadConsumerWrapper
    {
        public String networkKey;
        // RCED For COB
        @AuraEnabled public String otherIns{get;set;}
        @AuraEnabled public String otherInsPrimary{get;set;}
        @AuraEnabled public String c_type{get;set;}
        @AuraEnabled public String eligibleDates{get;set;}
		@AuraEnabled public String claimEngineCode{get;set;}
        @AuraEnabled public String officeNumber{get;set;}																						   
        @AuraEnabled public String primaryEffectiveDates{get;set;}
        @AuraEnabled public String payeeName{get;set;}//Gap
        @AuraEnabled public String medicareInfo{get;set;}//Gap
        @AuraEnabled public String updateSts{get;set;}//Gap
        @AuraEnabled public String lastUpdate{get;set;}
        //Required for other services
        @AuraEnabled public String dependentNo{get;set;}
        @AuraEnabled public String regionCode{get;set;}
        // COB History
        @AuraEnabled public List<ACET_ReadMemberCobHistory.COBHistoyWrapper> cobHistory{get;set;}
        //Create Auth related details
        // US3507486 - Create Auth  Update Funding Arrangement Value : Sarma - 10th May 2021
        @AuraEnabled public RCEDDetailsForCreateAuth rCEDDetailsForCreateAuth{get;set;}
    }
    // New COB integration
    public class RCEDRequest
    {
        // US3340930 - Thanish - 6th Mar 2021
        @AuraEnabled public String subscriberId{get;set;}
        @AuraEnabled public String policyNumber{get;set;}
        @AuraEnabled public String sourceCode{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String dateOfBirth{get;set;}
        @AuraEnabled public Boolean isSubscriber{get;set;}
    }

    // US3507486 - Create Auth  Update Funding Arrangement Value : Sarma - 10th May 2021
    public class RCEDDetailsForCreateAuth {
        @AuraEnabled public String fundingArrangement{get;set;}

        // US3507488: Create Auth Med Nec Indicator - Swapnil 13 May 2021
        @AuraEnabled public String obligorID{get;set;}
        @AuraEnabled public String sharedArrangementID{get;set;}
        @AuraEnabled public String productClassifierType{get;set;}
        @AuraEnabled public String productCode{get;set;}
		//added by vishnu
        @AuraEnabled public String cesCustomerName{get;set;}        
        @AuraEnabled public String siteOfCareCoreMed{get;set;}
        @AuraEnabled public String baseMme{get;set;}
        @AuraEnabled public String medicare{get;set;}
        @AuraEnabled public String topsCoverageSetId{get;set;}
        @AuraEnabled public String cme{get;set;}

    }

    //Log Creation
    @future
    public static void createAppErrorLog_ORS(string AppName, string servName, string endPoint, string respStatus, Integer respStatuscode, string reqBody,string resBody,String urlParameters){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog(AppName, servName, endPoint, respStatus, respStatuscode);
        AppErrorLog.UrlParamaters__c=urlParameters;
        List<Attachment> AppErrorLogAtts = new List<Attachment>();
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'RCES_Request', reqBody));
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'RCES_Rsponse', resBody));
        system.debug(LoggingLevel.INFO, 'AppErrorLog: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
        Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
        if (ErrorLogSR.isSuccess()) {
            Id ErrorLogId = ErrorLogSR.getId();
            for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                AppErrorLogAtt.ParentId = ErrorLogId;
            }
            Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
        }
    }
}