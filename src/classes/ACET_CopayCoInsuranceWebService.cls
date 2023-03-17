/*
 * @Desc: US1741780 - Base Class for CopayAdditionalCoInsurance web service
 * @Date: 18-03-2020
 * @Dev: Sarma
 */

public class ACET_CopayCoInsuranceWebService{

    static final Integer RESPONSE_SUCCESS_CODE = 200;
    static final String BENEFIT_RESOURCE = 'CopayCoInsuranceEndpoint';
    static final String COPAY_SERVICE_SUCCESS_MSG = 'Success';
    static final String COPAY_SERVICE_COMMON_ERROR_MSG = 'Web Service or External System is temporarily unavailable.';
    static final Integer COPAY_SERVICE_ERROR_CODE = 999;
    String endPoint = '';

    public ACETWSCalloutResult getBenefit(CopayCoInsuranceRequest requestObj) {

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_CopayCoInsuranceResponceJSON2Apex responseObj;
        ACET_CopayCoInsuranceResult resultWrapper;
        ACET_CopayCoInsuranceResult.CopayCoInsurance copayCoInsurance;
        Map <String, String> requestParamsMap = new Map <String, String>();

        try {
            HttpResponse response;
            //String resultQuery = '?patientKey=' + requestObj.patientKey + '&policyId=' + requestObj.policyId + '&serviceTypeDescriptions=' + requestObj.serviceTypeDescription_API;

            requestParamsMap.put('patientKey', String.isNotBlank(requestObj.patientKey) ? requestObj.patientKey : '');
            requestParamsMap.put('policyId', String.isNotBlank(requestObj.policyId) ? requestObj.policyId : '');
            requestParamsMap.put('serviceTypeDescriptions', String.isNotBlank(requestObj.serviceTypeDescription_API) ? requestObj.serviceTypeDescription_API : '');
            
            // calling webservice using webservice framework
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkCopayCoInsurance';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;
            response = wsCallOutFW.getResponse();
            //US3008502 - Ends

            // Mock data setup - End
            Integer statusCode = response.getStatusCode();

            if (statusCode == RESPONSE_SUCCESS_CODE) {
                calloutResult.statusCode = response.getStatusCode();
                responseObj = (ACET_CopayCoInsuranceResponceJSON2Apex) JSON.deserialize(response.getBody(), ACET_CopayCoInsuranceResponceJSON2Apex.class);
                if (responseObj != null) {
                    resultWrapper = new ACET_CopayCoInsuranceResult();
                    copayCoInsurance = new ACET_CopayCoInsuranceResult.CopayCoInsurance();
                    ACET_CopayCoInsuranceResult.Individual individual = new ACET_CopayCoInsuranceResult.Individual();
                    // Wrapper logic
                    if (responseObj.CopayCoInsuranceDetails != NULL) {
                        if (responseObj.CopayCoInsuranceDetails.individual.found) {
                            individual.found = true;
                            boolean isMskAvailable = false;
                            // US2779783
                            boolean isDollarAmountAvailable = false;
                            copayCoInsurance = new ACET_CopayCoInsuranceResult.CopayCoInsurance();
                            // inNetwork starts
                            ACET_CopayCoInsuranceResult.InNetwork inNetwork = new ACET_CopayCoInsuranceResult.InNetwork();
                            if (responseObj.CopayCoInsuranceDetails.individual.inNetwork.found) {
                                List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                                services = responseObj.CopayCoInsuranceDetails.individual.inNetwork.services;

                                for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                    List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsAllowedList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
                                    List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsRemainingList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
                                    String benefitAllowedFinalString = '';
                                    String benefitRemainingFinalString = '';
                                    // US2779783
                                    String dollarAmountFinalString = '';
                                    benefitsAllowedList = ser.benefitsAllowedFrequency;
                                    benefitsRemainingList = ser.benefitsRemainingFrequency;
                                    // US2575447 - Plan Benefits Details - for Remaining & Remaining MSK Benefit Types
                                    String mskRemainingFinalString = '';
                                    //Copay Value population
                                    String copayValue = '';
                                    for (String copayVal: ser.messages.coPay.message) {
                                        copayValue = String.isNotBlank(copayValue) ? ',' + copayVal : copayVal;
                                    }
                                    if(String.isBlank(copayValue)) {
                                        copayValue = '$' + ser.coPayAmount;
                                    }
                                    //CoInsurance Value Population
                                    String coInsuranceValue = '';
                                    for (String coInsVal: ser.messages.coInsurance.message) {
                                        coInsuranceValue = String.isNotBlank(coInsuranceValue) ? ',' + coInsVal : coInsVal;
                                    }
                                    if(String.isBlank(coInsuranceValue)) {
                                        coInsuranceValue = ser.coInsurancePercent + '%';
                                    }

                                    for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstAllowed: benefitsAllowedList) {
                                        String benefitAllowedString = String.isNotBlank(lstAllowed.frequency) ? lstAllowed.frequency : '';
                                        // US2779783
                                        String dollarAmountString = '';
                                        if (String.isNotBlank(benefitAllowedString)) {
                                            if (benefitAllowedString.equalsIgnoreCase('0 visits')) {
                                                benefitAllowedString = '';
                                                isDollarAmountAvailable = true;
                                                ACET_CopayCoInsuranceResponceJSON2Apex.Messages messagesObject = new ACET_CopayCoInsuranceResponceJSON2Apex.Messages();
                                                messagesObject = ser.messages;
                                                system.debug('##### messagesObject' + messagesObject);
                                                dollarAmountFinalString = getDollarAmount(messagesObject);
                                            }
                                        }

                                        if (String.isNotBlank(benefitAllowedFinalString) && String.isNotBlank(benefitAllowedString)) {
                                            benefitAllowedString = ' , ' + benefitAllowedString;
                                        }
                                        benefitAllowedFinalString = benefitAllowedFinalString + benefitAllowedString;
                                    }

                                    // US2798700	Plan Benefit Details - Remianing MSK Benefit type limit - Sarma - 10/9/2020
                                    for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstRemaining: benefitsRemainingList) {
                                        String benefitRemainingString = String.isNotBlank(lstRemaining.frequency) ? lstRemaining.frequency : '';
                                        if (benefitRemainingString.containsIgnoreCase('MUSCULOSKELETAL')) {
                                            isMskAvailable = true;
                                            if (String.isNotBlank(mskRemainingFinalString) && String.isNotBlank(benefitRemainingString)) {
                                                benefitRemainingString = ' , ' + benefitRemainingString;
                                            }
                                            mskRemainingFinalString = mskRemainingFinalString + benefitRemainingString;
                                        } else {
                                            if (String.isNotBlank(benefitRemainingFinalString) && String.isNotBlank(benefitRemainingString)) {
                                                benefitRemainingString = ' , ' + benefitRemainingString;
                                            }
                                            benefitRemainingFinalString = benefitRemainingFinalString + benefitRemainingString;
                                        }
                                    }
                                    inNetwork.benefitsAllowed = String.isNotBlank(benefitAllowedFinalString) ? benefitAllowedFinalString : '--';
                                    inNetwork.benefitsRemaining = String.isNotBlank(benefitRemainingFinalString) ? benefitRemainingFinalString : '--';
                                    // US2575447
                                    inNetwork.mskRemaining = String.isNotBlank(mskRemainingFinalString) ? mskRemainingFinalString : '--';
                                    // US2779783
                                    inNetwork.dollarAmount = String.isNotBlank(dollarAmountFinalString) ? dollarAmountFinalString : '--';
                                    inNetwork.copay = String.isNotBlank(copayValue) ? copayValue : '--';
                                    inNetwork.coInsurance = String.isNotBlank(coInsuranceValue) ? coInsuranceValue : '--';
                                }
                                individual.inNetwork = inNetwork;
                            } else {
                                inNetwork.benefitsAllowed = '--';
                                inNetwork.benefitsRemaining = '--';
                                // US2575447
                                inNetwork.mskRemaining = '--';
                                // US2779783
                                inNetwork.dollarAmount = '--';
                                inNetwork.copay = '--';
                                inNetwork.coInsurance = '--';
                                individual.inNetwork = inNetwork;
                            }
                            // inNetwork ends
                            // outNetwork starts
                            ACET_CopayCoInsuranceResult.InNetwork outNetwork = new ACET_CopayCoInsuranceResult.InNetwork();
                            if (responseObj.CopayCoInsuranceDetails.individual.outOfNetwork.found) {
                                List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                                services = responseObj.CopayCoInsuranceDetails.individual.outOfNetwork.services;

                                for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                    List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsAllowedList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
                                    List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsRemainingList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
                                    String benefitAllowedFinalString = '';
                                    String benefitRemainingFinalString = '';
                                    // US2575447 - Plan Benefits Details - for Remaining & Remaining MSK Benefit Types
                                    String mskRemainingFinalString = '';
                                    // US2779783
                                    String dollarAmountFinalString = '';
                                    benefitsAllowedList = ser.benefitsAllowedFrequency;
                                    benefitsRemainingList = ser.benefitsRemainingFrequency;
                                    
                                    //Copay Value population
                                    String copayValue = '';
                                    for (String copayVal: ser.messages.coPay.message) {
                                        copayValue = String.isNotBlank(copayValue) ? ',' + copayVal : copayVal;
                                    }
                                    if(String.isBlank(copayValue)) {
                                        copayValue = '$' + ser.coPayAmount;
                                    }
                                    //CoInsurance Value Population
                                    String coInsuranceValue = '';
                                    for (String coInsVal: ser.messages.coInsurance.message) {
                                        coInsuranceValue = String.isNotBlank(coInsuranceValue) ? ',' + coInsVal : coInsVal;
                                    }
                                    if(String.isBlank(coInsuranceValue)) {
                                        coInsuranceValue = ser.coInsurancePercent + '%';
                                    }

                                    for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstAllowed: benefitsAllowedList) {
                                        String benefitAllowedString = String.isNotBlank(lstAllowed.frequency) ? lstAllowed.frequency : '';
                                        // US2779783
                                        String dollarAmountString = '';
                                        if (String.isNotBlank(benefitAllowedString)) {
                                            if (benefitAllowedString.equalsIgnoreCase('0 visits')) {
                                                benefitAllowedString = '';
                                                isDollarAmountAvailable = true;
                                                ACET_CopayCoInsuranceResponceJSON2Apex.Messages messagesObject = new ACET_CopayCoInsuranceResponceJSON2Apex.Messages();
                                                messagesObject = ser.messages;
                                                system.debug('##### messagesObject' + messagesObject);
                                                dollarAmountFinalString = getDollarAmount(messagesObject);
                                            }
                                        }

                                        if (String.isNotBlank(benefitAllowedFinalString) && String.isNotBlank(benefitAllowedString)) {
                                            benefitAllowedString = ' , ' + benefitAllowedString;
                                        }
                                        benefitAllowedFinalString = benefitAllowedFinalString = +benefitAllowedString;
                                    }

                                    // US2798700	Plan Benefit Details - Remianing MSK Benefit type limit - Sarma - 10/9/2020
                                    for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstRemaining: benefitsRemainingList) {
                                        String benefitRemainingString = String.isNotBlank(lstRemaining.frequency) ? lstRemaining.frequency : '';
                                        if (benefitRemainingString.containsIgnoreCase('MUSCULOSKELETAL')) {
                                            isMskAvailable = true;
                                            if (String.isNotBlank(mskRemainingFinalString) && String.isNotBlank(benefitRemainingString)) {
                                                benefitRemainingString = ' , ' + benefitRemainingString;
                                            }
                                            mskRemainingFinalString = mskRemainingFinalString + benefitRemainingString;
                                        } else {
                                            if (String.isNotBlank(benefitRemainingFinalString) && String.isNotBlank(benefitRemainingString)) {
                                                benefitRemainingString = ' , ' + benefitRemainingString;
                                            }
                                            benefitRemainingFinalString = benefitRemainingFinalString + benefitRemainingString;
                                        }
                                    }
                                    outNetwork.benefitsAllowed = String.isNotBlank(benefitAllowedFinalString) ? benefitAllowedFinalString : '--';
                                    outNetwork.benefitsRemaining = String.isNotBlank(benefitRemainingFinalString) ? benefitRemainingFinalString : '--';
                                    // US2575447
                                    outNetwork.mskRemaining = String.isNotBlank(mskRemainingFinalString) ? mskRemainingFinalString : '--';
                                    // US2779783
                                    outNetwork.dollarAmount = String.isNotBlank(dollarAmountFinalString) ? dollarAmountFinalString : '--';
                                    outNetwork.copay = String.isNotBlank(copayValue) ? copayValue : '--';
                                    outNetwork.coInsurance = String.isNotBlank(coInsuranceValue) ? coInsuranceValue : '--';
                                }
                                individual.outNetwork = outNetwork;

                            } else {
                                outNetwork.benefitsAllowed = '--';
                                outNetwork.benefitsRemaining = '--';
                                // US2575447
                                outNetwork.mskRemaining = '--';
                                // US2779783
                                outNetwork.dollarAmount = '--';
                                outNetwork.copay = '--';
                                outNetwork.coInsurance = '--';
                                individual.outNetwork = outNetwork;
                            }
                            // outNetwork ends
                            // tier1 starts
                            ACET_CopayCoInsuranceResult.InNetwork tier1 = new ACET_CopayCoInsuranceResult.InNetwork();
                            if (responseObj.CopayCoInsuranceDetails.individual.inNetworkTier1.found) {
                                List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                                services = responseObj.CopayCoInsuranceDetails.individual.inNetworkTier1.services;

                                for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                    List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsAllowedList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
                                    List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsRemainingList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
                                    String benefitAllowedFinalString = '';
                                    String benefitRemainingFinalString = '';
                                    // US2575447 - Plan Benefits Details - for Remaining & Remaining MSK Benefit Types
                                    String mskRemainingFinalString = '';
                                    // US2779783
                                    String dollarAmountFinalString = '';
                                    benefitsAllowedList = ser.benefitsAllowedFrequency;
                                    benefitsRemainingList = ser.benefitsRemainingFrequency;
                                    
                                    //Copay Value population
                                    String copayValue = '';
                                    for (String copayVal: ser.messages.coPay.message) {
                                        copayValue = String.isNotBlank(copayValue) ? ',' + copayVal : copayVal;
                                    }
                                    if(String.isBlank(copayValue)) {
                                        copayValue = '$' + ser.coPayAmount;
                                    }
                                    //CoInsurance Value Population
                                    String coInsuranceValue = '';
                                    for (String coInsVal: ser.messages.coInsurance.message) {
                                        coInsuranceValue = String.isNotBlank(coInsuranceValue) ? ',' + coInsVal : coInsVal;
                                    }
                                    if(String.isBlank(coInsuranceValue)) {
                                        coInsuranceValue = ser.coInsurancePercent + '%';
                                    }

                                    for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstAllowed: benefitsAllowedList) {
                                        String benefitAllowedString = String.isNotBlank(lstAllowed.frequency) ? lstAllowed.frequency : '';
                                        // US2779783
                                        String dollarAmountString = '';
                                        if (String.isNotBlank(benefitAllowedString)) {
                                            if (benefitAllowedString.equalsIgnoreCase('0 visits')) {
                                                benefitAllowedString = '';
                                                isDollarAmountAvailable = true;
                                                ACET_CopayCoInsuranceResponceJSON2Apex.Messages messagesObject = new ACET_CopayCoInsuranceResponceJSON2Apex.Messages();
                                                messagesObject = ser.messages;
                                                system.debug('##### messagesObject' + messagesObject);
                                                dollarAmountFinalString = getDollarAmount(messagesObject);
                                            }
                                        }
                                        if (String.isNotBlank(benefitAllowedFinalString) && String.isNotBlank(benefitAllowedString)) {
                                            benefitAllowedString = ' , ' + benefitAllowedString;
                                        }
                                        benefitAllowedFinalString = benefitAllowedFinalString + benefitAllowedString;
                                    }

                                    // US2798700	Plan Benefit Details - Remianing MSK Benefit type limit - Sarma - 10/9/2020
                                    for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstRemaining: benefitsRemainingList) {
                                        String benefitRemainingString = String.isNotBlank(lstRemaining.frequency) ? lstRemaining.frequency : '';
                                        if (benefitRemainingString.containsIgnoreCase('MUSCULOSKELETAL')) {
                                            isMskAvailable = true;
                                            if (String.isNotBlank(mskRemainingFinalString) && String.isNotBlank(benefitRemainingString)) {
                                                benefitRemainingString = ' , ' + benefitRemainingString;
                                            }
                                            mskRemainingFinalString = mskRemainingFinalString + benefitRemainingString;
                                        } else {
                                            if (String.isNotBlank(benefitRemainingFinalString) && String.isNotBlank(benefitRemainingString)) {
                                                benefitRemainingString = ' , ' + benefitRemainingString;
                                            }
                                            benefitRemainingFinalString = benefitRemainingFinalString + benefitRemainingString;
                                        }
                                    }
                                    tier1.benefitsAllowed = String.isNotBlank(benefitAllowedFinalString) ? benefitAllowedFinalString : '--';
                                    tier1.benefitsRemaining = String.isNotBlank(benefitRemainingFinalString) ? benefitRemainingFinalString : '--';
                                    // US2575447
                                    tier1.mskRemaining = String.isNotBlank(mskRemainingFinalString) ? mskRemainingFinalString : '--';
                                    // US2779783
                                    tier1.dollarAmount = String.isNotBlank(dollarAmountFinalString) ? dollarAmountFinalString : '--';
                                    tier1.copay = String.isNotBlank(copayValue) ? copayValue : '--';
                                    tier1.coInsurance = String.isNotBlank(coInsuranceValue) ? coInsuranceValue : '--';
                                }
                                individual.tier1 = tier1;
                            } else {
                                tier1.benefitsAllowed = '--';
                                tier1.benefitsRemaining = '--';
                                // US2575447
                                tier1.mskRemaining = '--';
                                // US2779783
                                tier1.dollarAmount = '--';
                                tier1.copay = '--';
                                tier1.coInsurance = '--';
                                individual.tier1 = tier1;
                            }
                            // tier1 ends
                            individual.isMskAvailable = isMskAvailable;
                            // US2779783
                            individual.isDollarAmountAvailable = isDollarAmountAvailable;
                        } else {
                            individual.found = false;
                        }
                        copayCoInsurance.individual = individual;
                        resultWrapper.copayCoInsurance = copayCoInsurance;
                    }
                }
                calloutResult.Success = true;
                calloutResult.Message = COPAY_SERVICE_SUCCESS_MSG;
                calloutResult.statusCode = RESPONSE_SUCCESS_CODE;
                calloutResult.Response = resultWrapper;
            } //US2101444 Assigning custom error message based on response status code _by vishnu  11/05/2020
            else if (SAEConstants.viewAuthStatusCodeErrorMSG.containsKey(response.getStatusCode())) {
                calloutResult.Message = SAEConstants.viewAuthStatusCodeErrorMSG.get(response.getStatusCode());
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Response = responseObj;
            } else {
                calloutResult.Message = COPAY_SERVICE_COMMON_ERROR_MSG;
                calloutResult.statusCode = response.getStatusCode();
                calloutResult.Response = responseObj;
            }
        } catch (Exception e) {
            system.debug('##Exception:: ' + e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = COPAY_SERVICE_COMMON_ERROR_MSG;
            calloutResult.statusCode = COPAY_SERVICE_ERROR_CODE;
        }
        return calloutResult;
    }

    public class CopayCoInsuranceRequest {
        @AuraEnabled public String patientKey {
            get;
            set;
        }
        @AuraEnabled public String policyId {
            get;
            set;
        }
        @AuraEnabled public String serviceTypeDescription_API {
            get;
            set;
        }
    }

    public String getDollarAmount(ACET_CopayCoInsuranceResponceJSON2Apex.Messages messagesObject) {
        String dolAmountString = '';
        String dolAmountFinalString = '';
        if (messagesObject.found) {
            ACET_CopayCoInsuranceResponceJSON2Apex.CoPay benefitsAllowedObject = new ACET_CopayCoInsuranceResponceJSON2Apex.CoPay();
            benefitsAllowedObject = messagesObject.benefitsAllowed;
            if (benefitsAllowedObject.found) {
                List < String > messageList = benefitsAllowedObject.message;
                for (String message: messageList) {
                    dolAmountString = message;
                    if (String.isNotBlank(dolAmountFinalString) && String.isNotBlank(dolAmountString)) {
                        dolAmountString = '\r\n' + dolAmountString;
                    }
                    dolAmountFinalString = dolAmountFinalString + dolAmountString;
                }
            }
        }
        return dolAmountFinalString;
    }
}