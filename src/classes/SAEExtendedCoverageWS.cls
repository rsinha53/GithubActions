public with sharing class SAEExtendedCoverageWS {

    public ACETWSCalloutResult getPolicyWS(String transactionId) {

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        Map < String, String > requestParamsMap = new Map < String, String > ();

        //SAEProviderMemberSearchInteractionResult returnResponse = new SAEProviderMemberSearchInteractionResult();

        try {
            Boolean isStaticResponseChecked = false;
            HttpResponse response;
            String responseStr = '';

            /*** US3076045 - Avish **/
            requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkExtendedCoverage';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;
            response = wsCallOutFW.getResponse();
            //US3076045 - Ends

            calloutResult.statusCode = response.getStatusCode();
            responseStr = response.getBody();


            if (response.getStatusCode() == 200) {
                if (responseStr != null && String.isNotBlank(responseStr)) {

                    //calloutResult.statusCode= response.getStatusCode();

                    Map < String, Object > policyMainMap = (Map < String, Object > ) JSON.deserializeUntyped(responseStr);
                    //Attributes will no longer be used
                    //Map<String, Object> policyAttrMap = (Map<String, Object>)policyMainMap.get('attributes');
                    Map < String, Object > policyAddPlanDetMap = (Map < String, Object > ) policyMainMap.get('additionalPlanDetails');

                    //Removed due to inconsistency of data
                    //SAEPolicyDetailsJsonToApex json2Apex = SAEPolicyDetailsJsonToApex.parse(responseStr);
                    SAEPolicyDetailsJsonToApex json2Apex;
                    SAEPolicyDetailsResult.policyResults respToReturn = null;

                    //US - After Extended Service changed - Lahiru
                    if (!policyMainMap.isEmpty()) {

                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = (SAEPolicyDetailsResult) getPolicyResult(responseStr);

                    } else {
                        calloutResult.Success = true;
                        calloutResult.Response = new SAEPolicyDetailsResult.policyResults();
                    }

                }
            } else {
                calloutResult.Success = true;
                calloutResult.Response = new SAEPolicyDetailsResult.policyResults();
            }

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode = 999;
        }

        return calloutResult;
    }

    //this method parsing the response string into SAEPolicyDetailsResult by vishnu kasu
    Public SAEPolicyDetailsResult getPolicyResult(String responseStr) {
        SAEPolicyDetailsResult pResponse = new SAEPolicyDetailsResult();
        try {
            Map < String, Object > policyMainMap = (Map < String, Object > ) JSON.deserializeUntyped(responseStr);
            //Attributes will no longer be used
            //Map<String, Object> policyAttrMap = (Map<String, Object>)policyMainMap.get('attributes');
            Map < String, Object > policyAddPlanDetMap = (Map < String, Object > ) policyMainMap.get('additionalPlanDetails');

            //Removed due to inconsistency of data
            //SAEPolicyDetailsJsonToApex json2Apex = SAEPolicyDetailsJsonToApex.parse(responseStr);
            SAEPolicyDetailsJsonToApex json2Apex;
            SAEPolicyDetailsResult.policyResults respToReturn = null;
            respToReturn = new SAEPolicyDetailsResult.policyResults();
            //US1944144 - 03/19/2020 Avish
            respToReturn.nonEmbeddedFamilyStatusIndicator = String.isNotBlank((String) policyMainMap.get('nonEmbeddedFamilyStatusIndicator')) ? (String) policyMainMap.get('nonEmbeddedFamilyStatusIndicator') : '';
            String localSourceCode = String.isNotBlanK((String) policyMainMap.get('sourceCode')) ? (String) policyMainMap.get('sourceCode') : '';
            respToReturn.sourceCode = localSourceCode;
            ACET_SourceCodeValues__mdt sourceCodeRecord = [SELECT value__c FROM ACET_SourceCodeValues__mdt WHERE DeveloperName =: localSourceCode LIMIT 1];
            if (sourceCodeRecord != null) {
                respToReturn.sourceCodeDetail = sourceCodeRecord.value__c;
            } else {
                respToReturn.sourceCodeDetail = '--';
            }
            respToReturn.relationshipCode = String.isNotBlanK((String) policyMainMap.get('individualRelationshipCode')) ? (String) policyMainMap.get('individualRelationshipCode') : '';

            //US1827051 - Show only core fields - Sanka - 06/06/2019
            respToReturn.showAllFields = true;
            //US2253388 - Member Subject Card/Member Snapshot - Integrate EEID-Durga - START
            respToReturn.EEID = string.isNotBlank(string.Valueof(policyMainMap.get('subscriberID'))) ? string.Valueof(policyMainMap.get('subscriberID')) : ''; //Durga
            if(respToReturn.EEID != null && respToReturn.EEID.length() > 9) {
                respToReturn.EEID = respToReturn.EEID.right(9);
            }
            //US2253388 - Member Subject Card/Member Snapshot - Integrate EEID-Durga - End

            if (localSourceCode == 'CO') {
                respToReturn.isMedicarePlan = true;
                respToReturn.isPHSPlan = false;
                respToReturn.isComPlan = false;
                respToReturn.isMedicaidPlan = false;

                //US1827051 - Show only core fields - Sanka - 06/06/2019
                respToReturn.showAllFields = true;
            } else if (localSourceCode == 'PA') {
                respToReturn.isPHSPlan = true;
                respToReturn.isMedicarePlan = false;
                respToReturn.isComPlan = false;
                respToReturn.isMedicaidPlan = false;

                //US1827051 - Show only core fields - Sanka - 06/06/2019
                respToReturn.showAllFields = true;
            } else if (localSourceCode == 'CS') {
                respToReturn.isComPlan = true;
                respToReturn.isMedicarePlan = false;
                respToReturn.isMedicaidPlan = false;
                respToReturn.isPHSPlan = false;

                //US1827051 - Show only core fields - Sanka - 06/06/2019
                respToReturn.showAllFields = true;
            } else if (localSourceCode == 'AP') {
                respToReturn.isMedicaidPlan = true;
                respToReturn.isMedicarePlan = false;
                respToReturn.isPHSPlan = false;
                respToReturn.isComPlan = false;

                //US1827051 - Show only core fields - Sanka - 06/06/2019
                respToReturn.showAllFields = true;
            } else if (localSourceCode == '' || localSourceCode == null) {
                //US1827051 - Show only core fields - Sanka - 06/06/2019
                respToReturn.showAllFields = false;
            }


            respToReturn.productType = String.isNotBlanK((String) policyMainMap.get('productType')) ? (String) policyMainMap.get('productType') : '';
            //mapping change for fundingType with schema change
            respToReturn.fundingType = String.isNotBlanK((String) policyAddPlanDetMap.get('fundingType')) ? (String) policyAddPlanDetMap.get('fundingType') : '';
            respToReturn.groupNumber = String.isNotBlanK((String) policyMainMap.get('groupNumber')) ? (String) policyMainMap.get('groupNumber') : '';
            respToReturn.groupName = String.isNotBlanK((String) policyMainMap.get('groupName')) ? (String) policyMainMap.get('groupName') : ''; //US2574803 _vishnu
            respToReturn.policyNumber = policyMainMap.containsKey('policyNumber') ? (String) policyMainMap.get('policyNumber') : '';
            if (String.isBlank(respToReturn.groupName) || respToReturn.groupName.contains('N/A')) {
                respToReturn.groupName = '--';
            }
            /* Changed by vinya for this DE304979 */
            if (String.isBlank(respToReturn.groupNumber) || respToReturn.groupNumber.contains('N/A')) {
                respToReturn.groupNumber = respToReturn.policyNumber;
            }
            //USS2221006 - END

		respToReturn.mbi = String.isNotBlanK((String) policyMainMap.get('mbi')) ? (String) policyMainMap.get('mbi') : ''; // US3209228 - sravani changes 
            respToReturn.marketSite = String.isNotBlanK((String) policyMainMap.get('marketSite')) ? (String) policyMainMap.get('marketSite') : ''; // US2623985 - Thanish - 10th Jun 2020 - For contract summary filtering
            respToReturn.marketType = string.isNotBlank((String) policyMainMap.get('marketType')) ? (String) policyMainMap.get('marketType') : '';
            respToReturn.stateOfIssueCode = string.isNotBlank((String) policyMainMap.get('stateOfIssueCode')) ? (String) policyMainMap.get('stateOfIssueCode') : ''; //Health Plan
            respToReturn.productId = string.isNotBlank((String) policyMainMap.get('productID')) ? (String) policyMainMap.get('productID') : ''; //Network Type
            respToReturn.cosmosDivision = string.isNotBlank((String) policyMainMap.get('cosmosDivision')) ? (String) policyMainMap.get('cosmosDivision') : ''; //DIV
            respToReturn.providerDiv = string.isNotBlank((String) policyMainMap.get('providerDiv')) ? (String) policyMainMap.get('providerDiv') : ''; //US3574032
            respToReturn.coverageStartDate = string.isNotBlank((String) policyMainMap.get('coverageStartDate')) ? (String) policyMainMap.get('coverageStartDate') : '';
            // US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 01/03/2021
            respToReturn.coverageEndDate = policyMainMap.containsKey('coverageEndDate') ? (String) policyMainMap.get('coverageEndDate') : '';
            respToReturn.insuranceTypeCode = String.isNotBlanK((String) policyAddPlanDetMap.get('insuranceTypeCode')) ? (String) policyAddPlanDetMap.get('insuranceTypeCode') : '';

            //Added by Vinay for Tier 1 Integration
            respToReturn.entityType = string.isNotBlank((String) policyMainMap.get('entityType')) ? (String) policyMainMap.get('entityType') : '';
            respToReturn.sharedArrangement = string.isNotBlank((String) policyMainMap.get('sharedArrangement')) ? (String) policyMainMap.get('sharedArrangement') : '';
            respToReturn.obligorID = string.isNotBlank((String) policyMainMap.get('obligorID')) ? (String) policyMainMap.get('obligorID') : '';
            respToReturn.productCode = string.isNotBlank((String) policyMainMap.get('productCode')) ? (String) policyMainMap.get('productCode') : '';
            respToReturn.claimSourceSystemCode = string.isNotBlank((String) policyMainMap.get('claimSourceSystemCode')) ? (String) policyMainMap.get('claimSourceSystemCode') : '';
            respToReturn.eligibilitySourceSystemCode = string.isNotBlank((String) policyMainMap.get('eligibilitySourceSystemCode')) ? (String) policyMainMap.get('eligibilitySourceSystemCode') : '';
            //Jitendra
            respToReturn.benefitPlanId = String.isNotBlanK((String) policyMainMap.get('benefitPlanId')) ? (String) policyMainMap.get('benefitPlanId') : '';

            String coverageLevel = string.isNotBlank((String) policyMainMap.get('coverageLevel')) ? (String) policyMainMap.get('coverageLevel') : '';

            if (SAEConstants.COVERAGELEVEL.get(coverageLevel) != null) {
                respToReturn.coverageLevel = SAEConstants.COVERAGELEVEL.get(coverageLevel);
            } else {
                respToReturn.coverageLevel = coverageLevel;
            }

            //  US2696849 - Thanish - 22nd Jul 2020
            respToReturn.subscriberID = string.isNotBlank((String) policyMainMap.get('subscriberID')) ? (String) policyMainMap.get('subscriberID') : '';
            respToReturn.coverageLevelNum = coverageLevel;

            respToReturn.tciTableNumber = string.isNotBlank((String) policyMainMap.get('tciTableNumber')) ? (String) policyMainMap.get('tciTableNumber') : '';
            respToReturn.lineOfBusiness = string.isNotBlank((String) policyMainMap.get('lineOfBusiness')) ? (String) policyMainMap.get('lineOfBusiness') : '';
            respToReturn.groupPanelNumber = string.isNotBlank((String) policyMainMap.get('groupPanelNumber')) ? (String) policyMainMap.get('groupPanelNumber') : '';
            respToReturn.xrefId = policyMainMap.containsKey('xrefId') ? (String) policyMainMap.get('xrefId') : ''; //US2154799
            respToReturn.xrefIdPartitionNumber = policyMainMap.containsKey('xrefIdPartitionNumber') ? (String) policyMainMap.get('xrefIdPartitionNumber') : ''; //Avish - createAuth
            // US1814440 Wrap to IBAAG/PASS for E&I Sarma - 13/02/2020
            respToReturn.benefitPackageLogNumber = policyMainMap.containsKey('benefitPackageLogNumber') ? (String) policyMainMap.get('benefitPackageLogNumber') : '';
            respToReturn.platform = policyMainMap.containsKey('platform') ? (String) policyMainMap.get('platform') : '';

            //US2098648 - Sanka - ORS Case Integration
            respToReturn.alternateId = policyMainMap.containsKey('alternateId') ? (String) policyMainMap.get('alternateId') : '';
            //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            respToReturn.dependentSequenceNumber = policyMainMap.containsKey('dependentSequenceNumber') ? (String) policyMainMap.get('dependentSequenceNumber') : '';
            //US3314325 - Sanka - COB Mapping Changes
            respToReturn.medicareEntitlementReason = policyMainMap.containsKey('medicareEntitlementReason') && policyMainMap.get('medicareEntitlementReason') != null ? (String) policyMainMap.get('medicareEntitlementReason') : '--';
            respToReturn.medicareIndicator = policyMainMap.containsKey('medicareIndicator') && policyMainMap.get('medicareIndicator') != null ? (String) policyMainMap.get('medicareIndicator') : '--';

            //US2563008 - Member Snapshot - Phone Number Integration - Sravan -28/04/2020
            respToReturn.homeTelephoneNumber = policyMainMap.containsKey('homeTelephoneNumber') ? (String) policyMainMap.get('homeTelephoneNumber') : '';

            //US1901028    - Member CDHP Integration - Sarma - 29/08/2019 : Start
            if (String.isNotBlank((String) policyAddPlanDetMap.get('cdhp'))) {
                if ((String) policyAddPlanDetMap.get('cdhp') == 'YES') {
                    respToReturn.isCdhp = true;
                    if ((String) policyAddPlanDetMap.get('hsa') != null) {
                        if ((String) policyAddPlanDetMap.get('hsa') == 'YES') {
                            respToReturn.isHsa = true;
                        } else {
                            respToReturn.isHsa = false;
                        }
                    } else {
                        respToReturn.isHsa = false;
                    }

                } else {
                    respToReturn.isCdhp = false;
                    respToReturn.isHsa = false;
                }
            } else {
                respToReturn.isCdhp = false;
                respToReturn.isHsa = false;
            }
            //US1901028    - Member CDHP Integration : End

            try {
                respToReturn.HealthPlanSite = [SELECT Link__c FROM Healthplan_Site__mdt WHERE Label =: respToReturn.stateOfIssueCode LIMIT 1].Link__c;

                if (respToReturn.HealthPlanSite == null) {
                    respToReturn.HealthPlanSite = '';
                }
            } catch (Exception e) {
                respToReturn.HealthPlanSite = '';

            }
            // US2678249 TECH - Offshore Restriction: Validate data from Proper Use API - Sarma
            // Off shore Restriction Logic : Starts
            if (respToReturn.sourceCode != null && String.isNotBlank(respToReturn.sourceCode)) {
                String param = '';
                String sourceCode = '';

                if (respToReturn.sourceCode == 'CO') {
                    sourceCode = 'MR';
                    if (respToReturn.cosmosDivision != null && String.isNotBlank(respToReturn.cosmosDivision) && respToReturn.groupNumber != null && respToReturn.groupNumber != '--') {
                        param = respToReturn.groupNumber + '_' + respToReturn.cosmosDivision;

                        respToReturn.policyRestrictionLevelList = ACETUtility.getPolicyRestrictionLevel(sourceCode, param);

                    }

                } else if (respToReturn.sourceCode == 'CS') {
                    sourceCode = 'EI';
                    if (respToReturn.policyNumber != null && String.isNotBlank(respToReturn.policyNumber) && respToReturn.groupNumber != null && respToReturn.groupNumber != '--') {
                        String policyNum = respToReturn.policyNumber;
                        String groupNum = respToReturn.groupNumber;
                        if (policyNum.startsWith('0')) {
                            policyNum = policyNum.substring(1, policyNum.length());
                        }
                        if (groupNum.startsWith('0')) {
                            groupNum = groupNum.substring(1, groupNum.length());
                        }
                        param = policyNum + '_' + groupNum;
                        respToReturn.policyRestrictionLevelList = ACETUtility.getPolicyRestrictionLevel(sourceCode, param);

                    }
                    if ((respToReturn.policyRestrictionLevelList == null || respToReturn.policyRestrictionLevelList.size() == 0) && (respToReturn.policyNumber != null && String.isNotBlank(respToReturn.policyNumber))) {
                        String policyNum = respToReturn.policyNumber;
                        if (policyNum.startsWith('0')) {
                            param = policyNum.substring(1, policyNum.length());
                        } else {
                            param = policyNum;
                        }

                        respToReturn.policyRestrictionLevelList = ACETUtility.getPolicyRestrictionLevel(sourceCode, param);

                    }

                }

            }

            respToReturn.isOffShoreUser = ACETUtility.isOffShoreUser();
            // Off shore Restriction Logic : Ends
            // US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
            Map < String, Object > pcpInfo = (Map < String, Object > ) policyMainMap.get('primaryCareProvider');
            if (pcpInfo != null && !pcpInfo.isEmpty()) {
                respToReturn.pcptaxId = pcpInfo.containsKey('taxId') ? (String) pcpInfo.get('taxId') : '';
                // US2917371 - Thanish - 7th Dec 2020
                SAEPolicyDetailsResult.PrimaryCareProvider primaryCareProvider = new SAEPolicyDetailsResult.PrimaryCareProvider();
                primaryCareProvider.taxId = respToReturn.pcptaxId;
                primaryCareProvider.providerNpi = pcpInfo.containsKey('providerNpi') ? (String) pcpInfo.get('providerNpi') : '';
                primaryCareProvider.pcpFirstName = pcpInfo.containsKey('pcpFirstName') ? (String) pcpInfo.get('pcpFirstName') : '';
                primaryCareProvider.pcpMiddleName = pcpInfo.containsKey('pcpMiddleName') ? (String) pcpInfo.get('pcpMiddleName') : '';
                primaryCareProvider.pcpLastName = pcpInfo.containsKey('pcpLastName') ? (String) pcpInfo.get('pcpLastName') : '';
                //US3086530
                primaryCareProvider.pcpPhoneNumber = pcpInfo.containsKey('pcpPhoneNumber') ? (String) pcpInfo.get('pcpPhoneNumber') : '';
                primaryCareProvider.pcpSpeciality = pcpInfo.containsKey('pcpSpeciality') ? (String) pcpInfo.get('pcpSpeciality') : '';
                primaryCareProvider.pcpEndDate = pcpInfo.containsKey('pcpEndDate') ? (String) pcpInfo.get('pcpEndDate') : '';//add by vishnu
                primaryCareProvider.pcpStartDate = pcpInfo.containsKey('pcpStartDate') ? (String) pcpInfo.get('pcpStartDate') : '';//add by vishnu
                primaryCareProvider.acoNetworkDescription = pcpInfo.containsKey('acoNetworkDescription') ? (String) pcpInfo.get('acoNetworkDescription') : '';//add by vishnu
                primaryCareProvider.acoNetworkId = pcpInfo.containsKey('acoNetworkId') ? (String) pcpInfo.get('acoNetworkId') : '';//add by vishnu
                Map < String, Object > pcpAdressInfo = (Map < String, Object > ) pcpInfo.get('providerAddress');

                if (pcpAdressInfo != null && !pcpAdressInfo.isEmpty()) {

                    primaryCareProvider.pcpProvideraddressLine1 = pcpAdressInfo.containsKey('addressLine1') ? (String) pcpAdressInfo.get('addressLine1') : '';
                    primaryCareProvider.pcpProvideraddressLine2 = pcpAdressInfo.containsKey('addressLine2') ? (String) pcpAdressInfo.get('addressLine2') : '';
                    primaryCareProvider.pcpProvidercity = pcpAdressInfo.containsKey('city') ? (String) pcpAdressInfo.get('city') : '';
                    primaryCareProvider.pcpProviderstate = pcpAdressInfo.containsKey('state') ? (String) pcpAdressInfo.get('state') : '';
                    primaryCareProvider.pcpProviderzip = pcpAdressInfo.containsKey('zip') ? (String) pcpAdressInfo.get('zip') : '';

                }
                respToReturn.primaryCareProvider = primaryCareProvider;
            }
            // US2356250 - PCP History Integration
            // Sanka Dharmasena - 14/08/2020
            List < Object > pcpHistory = (List < Object > ) policyMainMap.get('pcpHistoryList');
            List < SAEPolicyDetailsResult.PCPHistroy > historyList = new List < SAEPolicyDetailsResult.PCPHistroy > ();
            if (pcpHistory != null) {
                for (Object obj: pcpHistory) {
                    SAEPolicyDetailsResult.PCPHistroy pcph = new SAEPolicyDetailsResult.PCPHistroy();
                    Map < String, Object > hisRecord = (Map < String, Object > ) obj;
                    String startDate = (String) hisRecord.get('pcpStartDate');
                    pcph.StartDate = !String.isBlank(startDate) ? SAEUtils.formatDate(startDate) : '--';
                    String endtDate = (String) hisRecord.get('pcpEndDate');
                    pcph.EndDate = !String.isBlank(endtDate) ? SAEUtils.formatDate(endtDate) : '--';
                    //DE369470 Fix
                    String PCPFName = hisRecord.get('pcpFirstName') != null ? (String) hisRecord.get('pcpFirstName') : '';
                    String PCPMName = hisRecord.get('pcpMiddleName') != null ? (String) hisRecord.get('pcpMiddleName') : '';
                    String PCPLName = hisRecord.get('pcpLastName') != null ? (String) hisRecord.get('pcpLastName') : '';
                    pcph.PCPName = PCPFName + ' ' + PCPMName + ' ' + PCPLName;
                    //End
                    pcph.PCPNameShort = pcph.PCPName.length() > 20 ? pcph.PCPName.substring(0, 19) + '...' : pcph.PCPName;
                    // Gap
                    pcph.PCPNumber = '--';
                    pcph.ProviderGroupName = (String) hisRecord.get('providerGroupName');
                    if (String.isNotBlank(pcph.ProviderGroupName)) {
                        pcph.ProviderGroupNameShort = pcph.ProviderGroupName.length() > 20 ? pcph.ProviderGroupName.substring(0, 19) + '...' : pcph.ProviderGroupName;
                    }

                    // Gap
                    pcph.ProviderGroupNumber = '--';
                    pcph.TaxId = hisRecord.get('taxId') != null ? (String) hisRecord.get('taxId') : '--';
                    historyList.add(pcph);
                }
                respToReturn.pcpHistoryList = historyList;
            }

            //US3587915 - Create Auth : Call new API for Case Provider Search Provider  Mappings - Sarma- 03rd June 2021
            Map < String, Object > memberInf = (Map < String, Object > ) policyMainMap.get('memberInfo');
            SAEPolicyDetailsResult.MemberInfo memberInfo = new SAEPolicyDetailsResult.MemberInfo();
            if (memberInf != null) {
                memberInfo.firstName = memberInf.containsKey('firstName') ? (String) memberInf.get('firstName') : '';
                memberInfo.lastName = memberInf.containsKey('lastName') ? (String) memberInf.get('lastName') : '';
                memberInfo.middleName = memberInf.containsKey('middleName') ? (String) memberInf.get('middleName') : '';
                memberInfo.dob = memberInf.containsKey('dob') ? (String) memberInf.get('dob') : '';
                memberInfo.memberID = memberInf.containsKey('memberID') ? (String) memberInf.get('memberID') : '';
                memberInfo.genderCode = memberInf.containsKey('genderCode') ? (String) memberInf.get('genderCode') : '';
            }
            respToReturn.memberInfo = memberInfo;
            respToReturn.reportingCode = policyMainMap.containsKey('reportingCode') ? (String) policyMainMap.get('reportingCode') : '';
            //US3587915 Ends

            pResponse.policyRes = respToReturn;
        } catch (Exception e) {
            System.debug('Extended WS' + e.getLineNumber() + ' ' + e.getMessage());
        }
        return pResponse;

    }

}