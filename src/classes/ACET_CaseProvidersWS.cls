public with sharing class ACET_CaseProvidersWS {

    public static ACETWSCalloutResult getProvidersData(List<ACET_CaseProvidersReq.HscProvider> providerDetails , ACET_CaseProvidersReq.Member memberDetails)
    {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        String requestBody = requestFormatProcessing(providerDetails,memberDetails) ;
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        try{
            HttpResponse httpResponse = new HttpResponse();
            wsCallOutFW.serviceName = 'CaseProvidersSearch';
            wsCallOutFW.requestBody = requestBody;
            httpResponse = wsCallOutFW.getResponse(); 

            ACET_CaseProvidersResp result = new ACET_CaseProvidersResp();
            ACET_CreateAuthorizationRequest returnResponse = new ACET_CreateAuthorizationRequest();
            result = (ACET_CaseProvidersResp)System.JSON.deserialize(httpResponse.getBody(),ACET_CaseProvidersResp.class);

            // StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'ACET_CaseProvidersResponse' LIMIT 1];
            // String mockRes = response.Body.toString();
            // result = (ACET_CaseProvidersResp)System.JSON.deserialize(mockRes,ACET_CaseProvidersResp.class);
            if(result != null && result.responseCode == '200'){

                // Return objects - All retunn details will be the typeof ACET_CreateAuthorizationRequest object types.
                ACET_CreateAuthorizationRequest.CaseDetails returnCaseDetails = new ACET_CreateAuthorizationRequest.CaseDetails();
                List<ACET_CreateAuthorizationRequest.HscProvider> srnProviderList = new List<ACET_CreateAuthorizationRequest.HscProvider>();
                ACET_CreateAuthorizationRequest.HscProviders returnProviders = new ACET_CreateAuthorizationRequest.HscProviders();
                
                //ACET_CaseProvidersResp type objects for mapping.
                List<ACET_CaseProvidersResp.HscProvider> hscProviderList = new List<ACET_CaseProvidersResp.HscProvider>();

                // Provider details mapping.
                if(result.hscProviders != null && result.hscProviders.hscProvider != null){
                    hscProviderList = result.hscProviders.hscProvider;

                    for(ACET_CaseProvidersResp.HscProvider hscProviderObject : hscProviderList){

                        ACET_CreateAuthorizationRequest.HscProvider srnProviderDetailObject = new ACET_CreateAuthorizationRequest.HscProvider();
                        srnProviderDetailObject.qualityOutcomeType = hscProviderObject.qualityOutcomeType;
                        srnProviderDetailObject.efficiencyOutcomeType = hscProviderObject.efficiencyOutcomeType;
                        srnProviderDetailObject.firstName = hscProviderObject.firstName;
                        srnProviderDetailObject.lastName = hscProviderObject.lastName;
                        srnProviderDetailObject.middleName = hscProviderObject.middleName;
                        srnProviderDetailObject.businessName = hscProviderObject.businessName;
                        srnProviderDetailObject.providerCategory = hscProviderObject.providerCategory;
                        srnProviderDetailObject.address1 = hscProviderObject.address1;
                        srnProviderDetailObject.address2 = hscProviderObject.address2;
                        srnProviderDetailObject.city = hscProviderObject.city;
                        srnProviderDetailObject.state = hscProviderObject.state;
                        srnProviderDetailObject.zip = hscProviderObject.zip;
                        srnProviderDetailObject.zipSuffix = hscProviderObject.zipSuffix;
                        srnProviderDetailObject.countyName = hscProviderObject.countyName;
                        srnProviderDetailObject.primaryPhone = hscProviderObject.primaryPhone;
                        srnProviderDetailObject.tpsmType = hscProviderObject.tpsmType;
                        srnProviderDetailObject.acoID = hscProviderObject.acoID;
                        srnProviderDetailObject.acoName = hscProviderObject.acoName;
                        srnProviderDetailObject.uhpdTierDemotInd = hscProviderObject.uhpdTierDemotInd;
                        srnProviderDetailObject.specialtyType = hscProviderObject.specialtyType;
                        srnProviderDetailObject.specialtyTypeDesc = hscProviderObject.specialtyTypeDesc;
                        srnProviderDetailObject.networkStatusType = hscProviderObject.networkStatusType;
                        srnProviderDetailObject.networkStatusTypeDesc = hscProviderObject.networkStatusTypeDesc;
                        srnProviderDetailObject.providerSeqNum = hscProviderObject.providerSeqNum;
                        // New Mappings
                        srnProviderDetailObject.newProviderInd = hscProviderObject.newProviderInd;
                        srnProviderDetailObject.suffixName = hscProviderObject.suffixName;
                        srnProviderDetailObject.vanityCity = hscProviderObject.vanityCity;
                        srnProviderDetailObject.stateDesc = hscProviderObject.stateDesc;
                        srnProviderDetailObject.marketNumber = hscProviderObject.marketNumber;
                        srnProviderDetailObject.productType = hscProviderObject.productType;
                        srnProviderDetailObject.primaryPhoneInternationalInd = hscProviderObject.primaryPhoneInternationalInd;
                        srnProviderDetailObject.fax = hscProviderObject.fax;
                        srnProviderDetailObject.faxInternationalInd = hscProviderObject.faxInternationalInd;
                        srnProviderDetailObject.detailInd = hscProviderObject.detailInd;
                        srnProviderDetailObject.countryCode = hscProviderObject.countryCode;
                        srnProviderDetailObject.productMarketType = hscProviderObject.productMarketType;
                        srnProviderDetailObject.contractID = hscProviderObject.contractID;
                        srnProviderDetailObject.contractInd = hscProviderObject.contractInd;
                        srnProviderDetailObject.providerEffectiveDate = hscProviderObject.providerEffectiveDate;
                        srnProviderDetailObject.providerTerminationDate = hscProviderObject.providerTerminationDate;
                        srnProviderDetailObject.individualProvAssociationID = hscProviderObject.individualProvAssociationID;
                        srnProviderDetailObject.emergentWrapContractTypeID = hscProviderObject.emergentWrapContractTypeID;
                        srnProviderDetailObject.optOutLabVendorType = hscProviderObject.optOutLabVendorType;
                        srnProviderDetailObject.providerOrgType = hscProviderObject.providerOrgType;
                        srnProviderDetailObject.providerMedicaidLocationCode = hscProviderObject.providerMedicaidLocationCode;
                        srnProviderDetailObject.medicalRecordNumber = hscProviderObject.medicalRecordNumber;
                        srnProviderDetailObject.networkSteerageReasonType = hscProviderObject.networkSteerageReasonType;
                        srnProviderDetailObject.networkTier = hscProviderObject.networkTier;
                        srnProviderDetailObject.hscLetterOptOutCcInd = hscProviderObject.hscLetterOptOutCcInd;
                        srnProviderDetailObject.preferredNetworkInd = hscProviderObject.preferredNetworkInd;
                        srnProviderDetailObject.incentInd = hscProviderObject.incentInd;
                        srnProviderDetailObject.contractRoleCode = hscProviderObject.contractRoleCode;
                        srnProviderDetailObject.providerContract = hscProviderObject.providerContract;
                        srnProviderDetailObject.niceProviderType = hscProviderObject.niceProviderType;
                        srnProviderDetailObject.niceProviderOrganizationName = hscProviderObject.niceProviderOrganizationName;
                        srnProviderDetailObject.niceProviderContractArrangType = hscProviderObject.niceProviderContractArrangType;
                        srnProviderDetailObject.niceProviderOoaInd = hscProviderObject.niceProviderOoaInd;
                        srnProviderDetailObject.niceProviderContractTextInd = hscProviderObject.niceProviderContractTextInd;
                        srnProviderDetailObject.niceProviderClaimTextInd = hscProviderObject.niceProviderClaimTextInd;
                        srnProviderDetailObject.niceProviderMedicalRiskType = hscProviderObject.niceProviderMedicalRiskType;
                        srnProviderDetailObject.niceProviderHospitalRiskType = hscProviderObject.niceProviderHospitalRiskType;
                        srnProviderDetailObject.niceProviderPhsRiskType = hscProviderObject.niceProviderPhsRiskType;
                        srnProviderDetailObject.niceProviderUmType = hscProviderObject.niceProviderUmType;
                        srnProviderDetailObject.niceCompanyCodeType = hscProviderObject.niceCompanyCodeType;
                        srnProviderDetailObject.niceProviderNetworkInfoType = hscProviderObject.niceProviderNetworkInfoType;
                        srnProviderDetailObject.assocNiceProvGroupNum = hscProviderObject.assocNiceProvGroupNum;
                        srnProviderDetailObject.assocNiceProvGroupName = hscProviderObject.assocNiceProvGroupName;
                        srnProviderDetailObject.assocNiceProvServiceLocNum = hscProviderObject.assocNiceProvServiceLocNum;
                        srnProviderDetailObject.assocNiceProvServiceLocName = hscProviderObject.assocNiceProvServiceLocName;
                        srnProviderDetailObject.derivedNiceProviderRiskType = hscProviderObject.derivedNiceProviderRiskType;
                        srnProviderDetailObject.productCategoryType = hscProviderObject.productCategoryType;
                        srnProviderDetailObject.secondaryPhone = hscProviderObject.secondaryPhone;
                        srnProviderDetailObject.secondaryPhoneInternationalInd = hscProviderObject.secondaryPhoneInternationalInd;
                        srnProviderDetailObject.alternateFax = hscProviderObject.alternateFax;
                        srnProviderDetailObject.alternateFaxInternationalInd = hscProviderObject.alternateFaxInternationalInd;
                        srnProviderDetailObject.alternateFaxConfirmedInd = hscProviderObject.alternateFaxConfirmedInd;
                        srnProviderDetailObject.conditionFocusDescription = hscProviderObject.conditionFocusDescription;
                        srnProviderDetailObject.correspNdbAddressSeqNum = hscProviderObject.correspNdbAddressSeqNum;
                        srnProviderDetailObject.correspAddress1 = hscProviderObject.correspAddress1;
                        srnProviderDetailObject.correspAddress2 = hscProviderObject.correspAddress2;
                        srnProviderDetailObject.correspCountyName = hscProviderObject.correspCountyName;
                        srnProviderDetailObject.correspCity = hscProviderObject.correspCity;
                        srnProviderDetailObject.correspState = hscProviderObject.correspState;
                        srnProviderDetailObject.correspZip = hscProviderObject.correspZip;
                        srnProviderDetailObject.correspZipSuffix = hscProviderObject.correspZipSuffix;
                        srnProviderDetailObject.correspCountryCode = hscProviderObject.correspCountryCode;
                        srnProviderDetailObject.correspAttentionToName = hscProviderObject.correspAttentionToName;
                        srnProviderDetailObject.autoApprovalLetterInd = hscProviderObject.autoApprovalLetterInd;
                        srnProviderDetailObject.cirrusBenefitPlanID = hscProviderObject.cirrusBenefitPlanID;
                        srnProviderDetailObject.cirrusBenefitPlanName = hscProviderObject.cirrusBenefitPlanName;
                        srnProviderDetailObject.cirrusNetworkScheduleIDType = hscProviderObject.cirrusNetworkScheduleIDType;
                        srnProviderDetailObject.cirrusServiceAreaIDType = hscProviderObject.cirrusServiceAreaIDType;
                        srnProviderDetailObject.cirrusNetworkID = hscProviderObject.cirrusNetworkID;
                        srnProviderDetailObject.cirrusNetworkIDDesc = hscProviderObject.cirrusNetworkIDDesc;
                        srnProviderDetailObject.cirrusContractType = hscProviderObject.cirrusContractType;
                        srnProviderDetailObject.cirrusContractTypeDesc = hscProviderObject.cirrusContractTypeDesc;
                        srnProviderDetailObject.cirrusProviderAddressServiceAreas = hscProviderObject.cirrusProviderAddressServiceAreas;
                        srnProviderDetailObject.specialtyTypeCirrus = hscProviderObject.specialtyTypeCirrus;
                        srnProviderDetailObject.specialtyTypeCirrusDesc = hscProviderObject.specialtyTypeCirrusDesc;
                        // New Mappings Ends
                        // Provider Contract Orgs
                        List<ACET_CreateAuthorizationRequest.ProviderContractOrg> providerContractOrgsList = new List<ACET_CreateAuthorizationRequest.ProviderContractOrg> ();
                        ACET_CreateAuthorizationRequest.providerContractOrgs providerContractOrgs = new ACET_CreateAuthorizationRequest.providerContractOrgs();

                        for(ACET_CaseProvidersResp.ProviderContractOrg providerContractOrgObject : hscProviderObject.providerContractOrgs.providerContractOrg){
                            ACET_CreateAuthorizationRequest.ProviderContractOrg srnProviderContractOrg = new ACET_CreateAuthorizationRequest.ProviderContractOrg();
                            srnProviderContractOrg.providerContractOrg = providerContractOrgObject.providerContractOrg;
                            srnProviderContractOrg.providerContractContext = providerContractOrgObject.providerContractContext;
                            srnProviderContractOrg.providerContractOrgPriority = providerContractOrgObject.providerContractOrgPriority;
                            providerContractOrgsList.add(srnProviderContractOrg);
                        }
                        providerContractOrgs.providerContractOrg = providerContractOrgsList;
                        srnProviderDetailObject.providerContractOrgs = providerContractOrgs;

                        // Provider Identifiers
                        List<ACET_CreateAuthorizationRequest.ProviderIdentifier> providerIdentifierList = new List<ACET_CreateAuthorizationRequest.ProviderIdentifier> ();
                        ACET_CreateAuthorizationRequest.ProviderIdentifiers providerIdentifiers = new ACET_CreateAuthorizationRequest.ProviderIdentifiers();

                        for(ACET_CaseProvidersResp.ProviderIdentifier providerIdentifierObject : hscProviderObject.providerIdentifiers.providerIdentifier){
                            ACET_CreateAuthorizationRequest.ProviderIdentifier srnProviderIdentifier = new ACET_CreateAuthorizationRequest.ProviderIdentifier();
                            srnProviderIdentifier.providerIDType = providerIdentifierObject.providerIDType;
                            srnProviderIdentifier.providerIDText = providerIdentifierObject.providerIDText;
                            srnProviderIdentifier.providerIDDesc = providerIdentifierObject.providerIDDesc;
                            providerIdentifierList.add(srnProviderIdentifier);
                        }
                        providerIdentifiers.providerIdentifier = providerIdentifierList;
                        srnProviderDetailObject.providerIdentifiers = providerIdentifiers;

                        // Provider Roles
                        List<ACET_CreateAuthorizationRequest.ProviderRole> providerRoleList = new List<ACET_CreateAuthorizationRequest.ProviderRole> ();
                        ACET_CreateAuthorizationRequest.ProviderRoles providerRoles = new ACET_CreateAuthorizationRequest.ProviderRoles();

                        for(ACET_CaseProvidersResp.ProviderRole providerRoleObject : hscProviderObject.providerRoles.providerRole){
                            ACET_CreateAuthorizationRequest.ProviderRole srnProviderRole = new ACET_CreateAuthorizationRequest.ProviderRole();
                            srnProviderRole.providerRole = providerRoleObject.providerRole;
                            srnProviderRole.providerRoleDesc = providerRoleObject.providerRoleDesc;
                            providerRoleList.add(srnProviderRole);
                        }
                        providerRoles.providerRole = providerRoleList;
                        srnProviderDetailObject.providerRoles = providerRoles;

                        // Provider Contract Amendments 
                        List<ACET_CreateAuthorizationRequest.ProviderContractAmendment> providerContractAmendmentList = new List<ACET_CreateAuthorizationRequest.ProviderContractAmendment> ();
                        ACET_CreateAuthorizationRequest.ProviderContractAmendments providerContractAmendments = new ACET_CreateAuthorizationRequest.ProviderContractAmendments ();

                        for(ACET_CaseProvidersResp.ProviderContractAmendment providerContractAmendmentObject : hscProviderObject.providerContractAmendments.providerContractAmendment){
                            ACET_CreateAuthorizationRequest.ProviderContractAmendment srnProviderContractAmendment = new ACET_CreateAuthorizationRequest.ProviderContractAmendment();

                            srnProviderContractAmendment.contractDocumentID = providerContractAmendmentObject.contractDocumentID;
                            srnProviderContractAmendment.medicalNecessityTypeID = providerContractAmendmentObject.medicalNecessityTypeID;
                            srnProviderContractAmendment.providerContractAmendmentType = providerContractAmendmentObject.providerContractAmendmentType;
                            srnProviderContractAmendment.startDate = providerContractAmendmentObject.startDate;
                            srnProviderContractAmendment.endDate = providerContractAmendmentObject.endDate;

                            // Provider ContractAmendment Clauses
                            List<ACET_CreateAuthorizationRequest.ProviderContractAmendmentClause> providerClausesList = new List<ACET_CreateAuthorizationRequest.ProviderContractAmendmentClause> ();
                            ACET_CreateAuthorizationRequest.ProviderContractAmendmentClauses providerClauses = new ACET_CreateAuthorizationRequest.ProviderContractAmendmentClauses ();

                            for(ACET_CaseProvidersResp.ProviderContractAmendmentClause providerClausesObject : providerContractAmendmentObject.providerContractAmendmentClauses.providerContractAmendmentClause){
                                ACET_CreateAuthorizationRequest.ProviderContractAmendmentClause srnProviderClauses = new ACET_CreateAuthorizationRequest.ProviderContractAmendmentClause();

                                srnProviderClauses.providerContractClauseTypeID = providerClausesObject.providerContractClauseTypeID;
                                srnProviderClauses.clauseText = providerClausesObject.clauseText;
                                srnProviderClauses.providerContractProvisionType = providerClausesObject.providerContractProvisionType;
                                srnProviderClauses.clauseStatusTypeID = providerClausesObject.clauseStatusTypeID;
                                providerClausesList.add(srnProviderClauses);
                            }
                            providerClauses.providerContractAmendmentClause = providerClausesList;
                            srnProviderContractAmendment.providerContractAmendmentClauses = providerClauses;


                            providerContractAmendmentList.add(srnProviderContractAmendment);
                        }
                        providerContractAmendments.providerContractAmendment = providerContractAmendmentList;
                        srnProviderDetailObject.providerContractAmendments = providerContractAmendments;

                        srnProviderList.add(srnProviderDetailObject);
                            
                    }
                    returnProviders.hscProvider = srnProviderList;
                    returnCaseDetails.hscProviders = returnProviders;

                }
                // Provider Mappings End

                // Member Mapping
                if(result.member != null){

                    ACET_CreateAuthorizationRequest.Member returnMember = new ACET_CreateAuthorizationRequest.Member();
                    ACET_CaseProvidersResp.Member hscMember = new ACET_CaseProvidersResp.Member();

                    hscMember = result.member;
                    
                    returnMember.sourceMemberID = hscMember.sourceMemberID;
                    returnMember.sourceMemberIDType = hscMember.sourceMemberIDType;
                    returnMember.sourceMemberPartitionID = hscMember.sourceMemberPartitionID;
                    returnMember.firstName = hscMember.firstName;
                    returnMember.lastName = hscMember.lastName;
                    returnMember.middleName = hscMember.middleName;
                    returnMember.suffixName = hscMember.suffixName;
                    returnMember.birthDate = hscMember.birthDate;
                    returnMember.genderType = hscMember.genderType;
                    returnMember.relationshipCode = hscMember.relationshipCode;
                    returnMember.spokenLanguageText = hscMember.spokenLanguageText;
                    returnMember.writtenLanguageText = hscMember.writtenLanguageText;
                    returnMember.detailInd = hscMember.detailInd;
                    returnMember.settingOfCareText = hscMember.settingOfCareText;
                    returnMember.categoryEligibilityDesc = hscMember.categoryEligibilityDesc;
                    returnMember.race = hscMember.race;
                    returnMember.ethnicity = hscMember.ethnicity;
                    returnMember.calapPreferenceInd = hscMember.calapPreferenceInd;
                    returnMember.calapWrittenLangType = hscMember.calapWrittenLangType;
                    returnMember.calapSpokenLangType = hscMember.calapSpokenLangType;
                    returnMember.preferredSpokenLangType = hscMember.preferredSpokenLangType;
                    returnMember.preferredWrittenLangType = hscMember.preferredWrittenLangType;
                    returnMember.captureReasonType = hscMember.captureReasonType;
                    returnMember.recordSourceType = hscMember.recordSourceType;
                    returnMember.memberNoContactInd = hscMember.memberNoContactInd;
                    returnMember.subscriberEmploymentDate = hscMember.subscriberEmploymentDate;
                    returnMember.subscriberEmployeeStatusType = hscMember.subscriberEmployeeStatusType;
                    returnMember.bestDayToContact = hscMember.bestDayToContact;
                    returnMember.bestTimeToContact = hscMember.bestTimeToContact;
                    returnMember.alternateRelationshipCode = hscMember.alternateRelationshipCode;
                    returnMember.consumerID = hscMember.consumerID;
                    returnMember.totalMonetizedValueAmount = hscMember.totalMonetizedValueAmount;
                    returnMember.initialGestationalWeekCount = hscMember.initialGestationalWeekCount;
                    returnMember.envDisasterPlanInd = hscMember.envDisasterPlanInd;
                    returnMember.advanceDirectiveType = hscMember.advanceDirectiveType;
                    returnMember.goalOfCareType = hscMember.goalOfCareType;
                    returnMember.autoMedReferralAssignmentInd = hscMember.autoMedReferralAssignmentInd;
                    returnMember.geriatricMedChkInd = hscMember.geriatricMedChkInd;
                    returnMember.categoryEligibilityCode = hscMember.categoryEligibilityCode;
                    returnMember.lastRsaReceivedDateTime = hscMember.lastRsaReceivedDateTime;
                    returnMember.lastRsaRequestedDateTime = hscMember.lastRsaRequestedDateTime;
                    returnMember.dnrIndicator = hscMember.dnrIndicator;
                    returnMember.exchangeType = hscMember.exchangeType;
                    returnMember.noPhoneReasonType = hscMember.noPhoneReasonType;
                    returnMember.primaryMedMemberCoverageSeqNum = hscMember.primaryMedMemberCoverageSeqNum;
                    returnMember.sourceMemberLastUpdateDateTime = hscMember.sourceMemberLastUpdateDateTime;
                    returnMember.alternateEthncCode = hscMember.alternateEthncCode;
                    returnMember.alternateRaceCode = hscMember.alternateRaceCode;
                    returnMember.altPrefWriteLangTypId = hscMember.altPrefWriteLangTypId;
                    returnMember.altPrefSpokenLangTypId = hscMember.altPrefSpokenLangTypId;
                    returnMember.primaryISLIndividualGuid = hscMember.primaryISLIndividualGuid;
                    returnMember.customerID = hscMember.customerID;
                    returnMember.purchaserID = hscMember.purchaserID;
                    returnMember.hasLivingWillInd = hscMember.hasLivingWillInd;
                    returnMember.rsaPopulationType = hscMember.rsaPopulationType;
                    returnMember.nextRsaDueDate = hscMember.nextRsaDueDate;
                    returnMember.firstPocProblemDate = hscMember.firstPocProblemDate;
                    returnMember.confidentialInd = hscMember.confidentialInd;
                    returnMember.niceMemberMigrationStartDate = hscMember.niceMemberMigrationStartDate;
                    returnMember.medicareAStartDate = hscMember.medicareAStartDate;
                    returnMember.medicareBStartDate = hscMember.medicareBStartDate;
                    returnMember.medicareAEndDate = hscMember.medicareAEndDate;
                    returnMember.medicareBEndDate = hscMember.medicareBEndDate;
                    returnMember.cobInd = hscMember.cobInd;
                    returnMember.otherCoverageCarrierName = hscMember.otherCoverageCarrierName;
                    returnMember.otherCoveragePolicyNumber = hscMember.otherCoveragePolicyNumber;
                    returnMember.otherCoverageCardHolderId = hscMember.otherCoverageCardHolderId;
                    returnMember.otherCoverageCarrierTelNo = hscMember.otherCoverageCarrierTelNo;
                    returnMember.otherCovCarrierIntlInd = hscMember.otherCovCarrierIntlInd;
                    returnMember.otherCoveragePolicyHolderName = hscMember.otherCoveragePolicyHolderName;
                    returnMember.cobStartDate = hscMember.cobStartDate;
                    returnMember.cobEndDate = hscMember.cobEndDate;
                    returnMember.otherCoverageOrderType = hscMember.otherCoverageOrderType;
                    returnMember.otherCoverageReasonTypeID = hscMember.otherCoverageReasonTypeID;
                    returnMember.medicarePrimaryInd = hscMember.medicarePrimaryInd;
                    returnMember.cobVerifyDate = hscMember.cobVerifyDate;
                    returnMember.populationId = hscMember.populationId;
                    returnMember.origSystemMemberIDType = hscMember.origSystemMemberIDType;
                    returnMember.origSystemMemberID = hscMember.origSystemMemberID;
                    returnMember.eligibilitySystemTypeID = hscMember.eligibilitySystemTypeID;
                    returnMember.deathDate = hscMember.deathDate;
                    returnMember.icueMemberID = hscMember.icueMemberID;
                    returnMember.state = hscMember.state;
                    returnMember.policyNumber = hscMember.policyNumber;
                    returnMember.lineOfBusiness = hscMember.lineOfBusiness;
                    returnMember.memberIDType = hscMember.memberIDType;
                    returnMember.memberIDDesc = hscMember.memberIDDesc;
                    returnMember.memberIDText = hscMember.memberIDText;
                    returnMember.subscriberFirstName = hscMember.subscriberFirstName;
                    returnMember.subscriberLastName = hscMember.subscriberLastName;
                    
                    // Member => MemberCoverage
                    ACET_CreateAuthorizationRequest.MemberCoverage srnMemberCoverage = new ACET_CreateAuthorizationRequest.MemberCoverage();
                    ACET_CaseProvidersResp.MemberCoverage hscMemberCoverage = new ACET_CaseProvidersResp.MemberCoverage();

                    if(hscMember.memberCoverage != null){
                        hscMemberCoverage = hscMember.memberCoverage;

                        srnMemberCoverage.memberCoverageSeqNum = hscMemberCoverage.memberCoverageSeqNum;
                        srnMemberCoverage.policyNumber = hscMemberCoverage.policyNumber;
                        srnMemberCoverage.coverageType = hscMemberCoverage.coverageType;
                        srnMemberCoverage.coverageEffectiveDate = hscMemberCoverage.coverageEffectiveDate;
                        srnMemberCoverage.coverageEndDate = hscMemberCoverage.coverageEndDate;
                        srnMemberCoverage.marketNumber = hscMemberCoverage.marketNumber;
                        srnMemberCoverage.marketType = hscMemberCoverage.marketType;
                        srnMemberCoverage.divID = hscMemberCoverage.divID;
                        srnMemberCoverage.productType = hscMemberCoverage.productType;
                        srnMemberCoverage.productCategoryType = hscMemberCoverage.productCategoryType;
                        srnMemberCoverage.lineOfBusinessType = hscMemberCoverage.lineOfBusinessType;
                        srnMemberCoverage.groupNumber = hscMemberCoverage.groupNumber;
                        srnMemberCoverage.businessSegmentID = hscMemberCoverage.businessSegmentID;
                        srnMemberCoverage.legalEntityID = hscMemberCoverage.legalEntityID;
                        srnMemberCoverage.obligorID = hscMemberCoverage.obligorID;
                        srnMemberCoverage.sharedArrangementID = hscMemberCoverage.sharedArrangementID;
                        srnMemberCoverage.memberNetworkID = hscMemberCoverage.memberNetworkID;
                        srnMemberCoverage.panelID = hscMemberCoverage.panelID;
                        srnMemberCoverage.policyIssueState = hscMemberCoverage.policyIssueState;
                        srnMemberCoverage.coverageSetID = hscMemberCoverage.coverageSetID;
                        srnMemberCoverage.coverageSetMMECode = hscMemberCoverage.coverageSetMMECode;
                        srnMemberCoverage.coverageSetCMECode = hscMemberCoverage.coverageSetCMECode;
                        srnMemberCoverage.coverageSetMedicareCode = hscMemberCoverage.coverageSetMedicareCode;
                        srnMemberCoverage.fundingArrangementID = hscMemberCoverage.fundingArrangementID;
                        srnMemberCoverage.planVariationID = hscMemberCoverage.planVariationID;
                        srnMemberCoverage.reportCode = hscMemberCoverage.reportCode;
                        srnMemberCoverage.marketNetworkID = hscMemberCoverage.marketNetworkID;
                        srnMemberCoverage.marketNetworkInd = hscMemberCoverage.marketNetworkInd;
                        srnMemberCoverage.claimPlatformID = hscMemberCoverage.claimPlatformID;
                        srnMemberCoverage.cdhPlanType = hscMemberCoverage.cdhPlanType;
                        srnMemberCoverage.policyName = hscMemberCoverage.policyName;
                        srnMemberCoverage.marketSegmentCode = hscMemberCoverage.marketSegmentCode;
                        srnMemberCoverage.claimOfficeID = hscMemberCoverage.claimOfficeID;
                        srnMemberCoverage.claimOfficeName = hscMemberCoverage.claimOfficeName;
                        srnMemberCoverage.claimOfficeCustomerServicePhone = hscMemberCoverage.claimOfficeCustomerServicePhone;
                        srnMemberCoverage.claimOfficePhone = hscMemberCoverage.claimOfficePhone;
                        srnMemberCoverage.claimOfficeAddress1 = hscMemberCoverage.claimOfficeAddress1;
                        srnMemberCoverage.claimOfficeAddress2 = hscMemberCoverage.claimOfficeAddress2;
                        srnMemberCoverage.claimOfficeCity = hscMemberCoverage.claimOfficeCity;
                        srnMemberCoverage.claimOfficeState = hscMemberCoverage.claimOfficeState;
                        srnMemberCoverage.claimOfficeZip = hscMemberCoverage.claimOfficeZip;
                        srnMemberCoverage.claimOfficeZipSuffix = hscMemberCoverage.claimOfficeZipSuffix;
                        srnMemberCoverage.recordSourceType = hscMemberCoverage.recordSourceType;
                        srnMemberCoverage.productCode = hscMemberCoverage.productCode;
                        srnMemberCoverage.niceCoveragePlanCode = hscMemberCoverage.niceCoveragePlanCode;
                        srnMemberCoverage.niceCoveragePlanDescription = hscMemberCoverage.niceCoveragePlanDescription;
                        srnMemberCoverage.niceBenefitNetworkIndicator = hscMemberCoverage.niceBenefitNetworkIndicator;
                        srnMemberCoverage.erisaIndicator = hscMemberCoverage.erisaIndicator;
                        srnMemberCoverage.hcfaStatusType = hscMemberCoverage.hcfaStatusType;
                        srnMemberCoverage.hcfaPlanID = hscMemberCoverage.hcfaPlanID;
                        srnMemberCoverage.niceCompanyCodeType = hscMemberCoverage.niceCompanyCodeType;
                        srnMemberCoverage.niceCompanyRegionType = hscMemberCoverage.niceCompanyRegionType;
                        srnMemberCoverage.medNecessityApplInd = hscMemberCoverage.medNecessityApplInd;
                        srnMemberCoverage.productYearText = hscMemberCoverage.productYearText;
                        srnMemberCoverage.healthServiceProductLineCode = hscMemberCoverage.healthServiceProductLineCode;
                        srnMemberCoverage.healthServiceProductCode = hscMemberCoverage.healthServiceProductCode;
                        srnMemberCoverage.alternatePolicyNumber = hscMemberCoverage.alternatePolicyNumber;
                        srnMemberCoverage.productClassifierType = hscMemberCoverage.productClassifierType;
                        srnMemberCoverage.productBrandName = hscMemberCoverage.productBrandName;
                        srnMemberCoverage.masterGroupNumber = hscMemberCoverage.masterGroupNumber;
                        srnMemberCoverage.marketPackageNumber = hscMemberCoverage.marketPackageNumber;
                        srnMemberCoverage.marketPackageName = hscMemberCoverage.marketPackageName;
                        srnMemberCoverage.financialProductNumber = hscMemberCoverage.financialProductNumber;
                        srnMemberCoverage.financialProductDescription = hscMemberCoverage.financialProductDescription;
                        srnMemberCoverage.riskTypeCode = hscMemberCoverage.riskTypeCode;
                        srnMemberCoverage.subscriberPackageBenefitPlanID = hscMemberCoverage.subscriberPackageBenefitPlanID;
                        srnMemberCoverage.coreMedNecTypID = hscMemberCoverage.coreMedNecTypID;
                        srnMemberCoverage.policyEffectiveDate = hscMemberCoverage.policyEffectiveDate;
                        srnMemberCoverage.policyEndDate = hscMemberCoverage.policyEndDate;
                        srnMemberCoverage.indvContrInd = hscMemberCoverage.indvContrInd;
                        srnMemberCoverage.businessSegmentName = hscMemberCoverage.businessSegmentName;
                        srnMemberCoverage.cmsSnpInd = hscMemberCoverage.cmsSnpInd;
                        srnMemberCoverage.cmsSnpTypeName = hscMemberCoverage.cmsSnpTypeName;
                        srnMemberCoverage.cmsStateShortName = hscMemberCoverage.cmsStateShortName;
                        srnMemberCoverage.cmsProductTypeName = hscMemberCoverage.cmsProductTypeName;
                        srnMemberCoverage.radiologyMedNecType = hscMemberCoverage.radiologyMedNecType;
                        srnMemberCoverage.cardiologyMedNecType = hscMemberCoverage.cardiologyMedNecType;
                        srnMemberCoverage.contractLabVendorType = hscMemberCoverage.contractLabVendorType;
                        srnMemberCoverage.legacyBenefitPlanID = hscMemberCoverage.legacyBenefitPlanID;
                        srnMemberCoverage.gracePeriodThroughDate = hscMemberCoverage.gracePeriodThroughDate;
                        srnMemberCoverage.paidThroughDate = hscMemberCoverage.paidThroughDate;
                        srnMemberCoverage.emergentWrapBeneficiaryTypeID = hscMemberCoverage.emergentWrapBeneficiaryTypeID;
                        srnMemberCoverage.cosmosUmDelegationTypeID = hscMemberCoverage.cosmosUmDelegationTypeID;
                        srnMemberCoverage.oncologyMedNecType = hscMemberCoverage.oncologyMedNecType;
                        srnMemberCoverage.legacyBenPlanDesc = hscMemberCoverage.legacyBenPlanDesc;
                        srnMemberCoverage.delegatedEntityName = hscMemberCoverage.delegatedEntityName;
                        srnMemberCoverage.productTypeDescription = hscMemberCoverage.productTypeDescription;
                        srnMemberCoverage.providerNetworkDescription = hscMemberCoverage.providerNetworkDescription;
                        srnMemberCoverage.planVariationDesc = hscMemberCoverage.planVariationDesc;
                        srnMemberCoverage.reciprocityNumber = hscMemberCoverage.reciprocityNumber;
                        srnMemberCoverage.planFeatureCode = hscMemberCoverage.planFeatureCode;
                        srnMemberCoverage.planFeatureDescription = hscMemberCoverage.planFeatureDescription;
                        srnMemberCoverage.ltcInd = hscMemberCoverage.ltcInd;
                        srnMemberCoverage.mmpInd = hscMemberCoverage.mmpInd;
                        srnMemberCoverage.uhpdInd = hscMemberCoverage.uhpdInd;
                        srnMemberCoverage.topsTieredPlanSetup = hscMemberCoverage.topsTieredPlanSetup;
                        srnMemberCoverage.groupBenefitNumber = hscMemberCoverage.groupBenefitNumber;
                        srnMemberCoverage.genTstMedNecType = hscMemberCoverage.genTstMedNecType;
                        srnMemberCoverage.cirrusProductID = hscMemberCoverage.cirrusProductID;
                        srnMemberCoverage.cirrusProductName = hscMemberCoverage.cirrusProductName;
                        srnMemberCoverage.cirrusBenefitBundleID = hscMemberCoverage.cirrusBenefitBundleID;
                        srnMemberCoverage.cirrusBenefitBundleName = hscMemberCoverage.cirrusBenefitBundleName;
                        srnMemberCoverage.cirrusBenefitBundleOptionID = hscMemberCoverage.cirrusBenefitBundleOptionID;
                        srnMemberCoverage.cirrusBenefitBundleOptionName = hscMemberCoverage.cirrusBenefitBundleOptionName;
                        srnMemberCoverage.cirrusBenefitPlanID = hscMemberCoverage.cirrusBenefitPlanID;
                        srnMemberCoverage.cirrusBenefitPlanName = hscMemberCoverage.cirrusBenefitPlanName;
                        srnMemberCoverage.cirrusServiceAreaIDType = hscMemberCoverage.cirrusServiceAreaIDType;
                        srnMemberCoverage.radiationMedNecType = hscMemberCoverage.radiationMedNecType;
                        srnMemberCoverage.providerNetworkReciprocityType = hscMemberCoverage.providerNetworkReciprocityType;
                        srnMemberCoverage.cmsSegID = hscMemberCoverage.cmsSegID;
                    }
                    returnMember.memberCoverage = srnMemberCoverage;
                    // Member => MemberCoverage Ends

                    // Member => MemberCoverages
                    ACET_CreateAuthorizationRequest.MemberCoverages srnMemberCoverages = new ACET_CreateAuthorizationRequest.MemberCoverages();
                    List<ACET_CreateAuthorizationRequest.MemberCoverage> srnMemberCoverageList = new List<ACET_CreateAuthorizationRequest.MemberCoverage>();

                    if(hscMember.memberCoverages != null && hscMember.memberCoverages.memberCoverage != null){

                        for(ACET_CaseProvidersResp.MemberCoverage memberCoverageObj : hscMember.memberCoverages.memberCoverage){
                            ACET_CreateAuthorizationRequest.MemberCoverage srnMemberCoverageObj = new ACET_CreateAuthorizationRequest.MemberCoverage();

                            srnMemberCoverageObj.memberCoverageSeqNum = memberCoverageObj.memberCoverageSeqNum;
                            srnMemberCoverageObj.policyNumber = memberCoverageObj.policyNumber;
                            srnMemberCoverageObj.coverageType = memberCoverageObj.coverageType;
                            srnMemberCoverageObj.coverageEffectiveDate = memberCoverageObj.coverageEffectiveDate;
                            srnMemberCoverageObj.coverageEndDate = memberCoverageObj.coverageEndDate;
                            srnMemberCoverageObj.marketNumber = memberCoverageObj.marketNumber;
                            srnMemberCoverageObj.marketType = memberCoverageObj.marketType;
                            srnMemberCoverageObj.divID = memberCoverageObj.divID;
                            srnMemberCoverageObj.productType = memberCoverageObj.productType;
                            srnMemberCoverageObj.productCategoryType = memberCoverageObj.productCategoryType;
                            srnMemberCoverageObj.lineOfBusinessType = memberCoverageObj.lineOfBusinessType;
                            srnMemberCoverageObj.groupNumber = memberCoverageObj.groupNumber;
                            srnMemberCoverageObj.businessSegmentID = memberCoverageObj.businessSegmentID;
                            srnMemberCoverageObj.legalEntityID = memberCoverageObj.legalEntityID;
                            srnMemberCoverageObj.obligorID = memberCoverageObj.obligorID;
                            srnMemberCoverageObj.sharedArrangementID = memberCoverageObj.sharedArrangementID;
                            srnMemberCoverageObj.memberNetworkID = memberCoverageObj.memberNetworkID;
                            srnMemberCoverageObj.panelID = memberCoverageObj.panelID;
                            srnMemberCoverageObj.policyIssueState = memberCoverageObj.policyIssueState;
                            srnMemberCoverageObj.coverageSetID = memberCoverageObj.coverageSetID;
                            srnMemberCoverageObj.coverageSetMMECode = memberCoverageObj.coverageSetMMECode;
                            srnMemberCoverageObj.coverageSetCMECode = memberCoverageObj.coverageSetCMECode;
                            srnMemberCoverageObj.coverageSetMedicareCode = memberCoverageObj.coverageSetMedicareCode;
                            srnMemberCoverageObj.fundingArrangementID = memberCoverageObj.fundingArrangementID;
                            srnMemberCoverageObj.planVariationID = memberCoverageObj.planVariationID;
                            srnMemberCoverageObj.reportCode = memberCoverageObj.reportCode;
                            srnMemberCoverageObj.marketNetworkID = memberCoverageObj.marketNetworkID;
                            srnMemberCoverageObj.marketNetworkInd = memberCoverageObj.marketNetworkInd;
                            srnMemberCoverageObj.claimPlatformID = memberCoverageObj.claimPlatformID;
                            srnMemberCoverageObj.cdhPlanType = memberCoverageObj.cdhPlanType;
                            srnMemberCoverageObj.policyName = memberCoverageObj.policyName;
                            srnMemberCoverageObj.marketSegmentCode = memberCoverageObj.marketSegmentCode;
                            srnMemberCoverageObj.claimOfficeID = memberCoverageObj.claimOfficeID;
                            srnMemberCoverageObj.claimOfficeName = memberCoverageObj.claimOfficeName;
                            srnMemberCoverageObj.claimOfficeCustomerServicePhone = memberCoverageObj.claimOfficeCustomerServicePhone;
                            srnMemberCoverageObj.claimOfficePhone = memberCoverageObj.claimOfficePhone;
                            srnMemberCoverageObj.claimOfficeAddress1 = memberCoverageObj.claimOfficeAddress1;
                            srnMemberCoverageObj.claimOfficeAddress2 = memberCoverageObj.claimOfficeAddress2;
                            srnMemberCoverageObj.claimOfficeCity = memberCoverageObj.claimOfficeCity;
                            srnMemberCoverageObj.claimOfficeState = memberCoverageObj.claimOfficeState;
                            srnMemberCoverageObj.claimOfficeZip = memberCoverageObj.claimOfficeZip;
                            srnMemberCoverageObj.claimOfficeZipSuffix = memberCoverageObj.claimOfficeZipSuffix;
                            srnMemberCoverageObj.recordSourceType = memberCoverageObj.recordSourceType;
                            srnMemberCoverageObj.productCode = memberCoverageObj.productCode;
                            srnMemberCoverageObj.niceCoveragePlanCode = memberCoverageObj.niceCoveragePlanCode;
                            srnMemberCoverageObj.niceCoveragePlanDescription = memberCoverageObj.niceCoveragePlanDescription;
                            srnMemberCoverageObj.niceBenefitNetworkIndicator = memberCoverageObj.niceBenefitNetworkIndicator;
                            srnMemberCoverageObj.erisaIndicator = memberCoverageObj.erisaIndicator;
                            srnMemberCoverageObj.hcfaStatusType = memberCoverageObj.hcfaStatusType;
                            srnMemberCoverageObj.hcfaPlanID = memberCoverageObj.hcfaPlanID;
                            srnMemberCoverageObj.niceCompanyCodeType = memberCoverageObj.niceCompanyCodeType;
                            srnMemberCoverageObj.niceCompanyRegionType = memberCoverageObj.niceCompanyRegionType;
                            srnMemberCoverageObj.medNecessityApplInd = memberCoverageObj.medNecessityApplInd;
                            srnMemberCoverageObj.productYearText = memberCoverageObj.productYearText;
                            srnMemberCoverageObj.healthServiceProductLineCode = memberCoverageObj.healthServiceProductLineCode;
                            srnMemberCoverageObj.healthServiceProductCode = memberCoverageObj.healthServiceProductCode;
                            srnMemberCoverageObj.alternatePolicyNumber = memberCoverageObj.alternatePolicyNumber;
                            srnMemberCoverageObj.productClassifierType = memberCoverageObj.productClassifierType;
                            srnMemberCoverageObj.productBrandName = memberCoverageObj.productBrandName;
                            srnMemberCoverageObj.masterGroupNumber = memberCoverageObj.masterGroupNumber;
                            srnMemberCoverageObj.marketPackageNumber = memberCoverageObj.marketPackageNumber;
                            srnMemberCoverageObj.marketPackageName = memberCoverageObj.marketPackageName;
                            srnMemberCoverageObj.financialProductNumber = memberCoverageObj.financialProductNumber;
                            srnMemberCoverageObj.financialProductDescription = memberCoverageObj.financialProductDescription;
                            srnMemberCoverageObj.riskTypeCode = memberCoverageObj.riskTypeCode;
                            srnMemberCoverageObj.subscriberPackageBenefitPlanID = memberCoverageObj.subscriberPackageBenefitPlanID;
                            srnMemberCoverageObj.coreMedNecTypID = memberCoverageObj.coreMedNecTypID;
                            srnMemberCoverageObj.policyEffectiveDate = memberCoverageObj.policyEffectiveDate;
                            srnMemberCoverageObj.policyEndDate = memberCoverageObj.policyEndDate;
                            srnMemberCoverageObj.indvContrInd = memberCoverageObj.indvContrInd;
                            srnMemberCoverageObj.businessSegmentName = memberCoverageObj.businessSegmentName;
                            srnMemberCoverageObj.cmsSnpInd = memberCoverageObj.cmsSnpInd;
                            srnMemberCoverageObj.cmsSnpTypeName = memberCoverageObj.cmsSnpTypeName;
                            srnMemberCoverageObj.cmsStateShortName = memberCoverageObj.cmsStateShortName;
                            srnMemberCoverageObj.cmsProductTypeName = memberCoverageObj.cmsProductTypeName;
                            srnMemberCoverageObj.radiologyMedNecType = memberCoverageObj.radiologyMedNecType;
                            srnMemberCoverageObj.cardiologyMedNecType = memberCoverageObj.cardiologyMedNecType;
                            srnMemberCoverageObj.contractLabVendorType = memberCoverageObj.contractLabVendorType;
                            srnMemberCoverageObj.legacyBenefitPlanID = memberCoverageObj.legacyBenefitPlanID;
                            srnMemberCoverageObj.gracePeriodThroughDate = memberCoverageObj.gracePeriodThroughDate;
                            srnMemberCoverageObj.paidThroughDate = memberCoverageObj.paidThroughDate;
                            srnMemberCoverageObj.emergentWrapBeneficiaryTypeID = memberCoverageObj.emergentWrapBeneficiaryTypeID;
                            srnMemberCoverageObj.cosmosUmDelegationTypeID = memberCoverageObj.cosmosUmDelegationTypeID;
                            srnMemberCoverageObj.oncologyMedNecType = memberCoverageObj.oncologyMedNecType;
                            srnMemberCoverageObj.legacyBenPlanDesc = memberCoverageObj.legacyBenPlanDesc;
                            srnMemberCoverageObj.delegatedEntityName = memberCoverageObj.delegatedEntityName;
                            srnMemberCoverageObj.productTypeDescription = memberCoverageObj.productTypeDescription;
                            srnMemberCoverageObj.providerNetworkDescription = memberCoverageObj.providerNetworkDescription;
                            srnMemberCoverageObj.planVariationDesc = memberCoverageObj.planVariationDesc;
                            srnMemberCoverageObj.reciprocityNumber = memberCoverageObj.reciprocityNumber;
                            srnMemberCoverageObj.planFeatureCode = memberCoverageObj.planFeatureCode;
                            srnMemberCoverageObj.planFeatureDescription = memberCoverageObj.planFeatureDescription;
                            srnMemberCoverageObj.ltcInd = memberCoverageObj.ltcInd;
                            srnMemberCoverageObj.mmpInd = memberCoverageObj.mmpInd;
                            srnMemberCoverageObj.uhpdInd = memberCoverageObj.uhpdInd;
                            srnMemberCoverageObj.topsTieredPlanSetup = memberCoverageObj.topsTieredPlanSetup;
                            srnMemberCoverageObj.groupBenefitNumber = memberCoverageObj.groupBenefitNumber;
                            srnMemberCoverageObj.genTstMedNecType = memberCoverageObj.genTstMedNecType;
                            srnMemberCoverageObj.cirrusProductID = memberCoverageObj.cirrusProductID;
                            srnMemberCoverageObj.cirrusProductName = memberCoverageObj.cirrusProductName;
                            srnMemberCoverageObj.cirrusBenefitBundleID = memberCoverageObj.cirrusBenefitBundleID;
                            srnMemberCoverageObj.cirrusBenefitBundleName = memberCoverageObj.cirrusBenefitBundleName;
                            srnMemberCoverageObj.cirrusBenefitBundleOptionID = memberCoverageObj.cirrusBenefitBundleOptionID;
                            srnMemberCoverageObj.cirrusBenefitBundleOptionName = memberCoverageObj.cirrusBenefitBundleOptionName;
                            srnMemberCoverageObj.cirrusBenefitPlanID = memberCoverageObj.cirrusBenefitPlanID;
                            srnMemberCoverageObj.cirrusBenefitPlanName = memberCoverageObj.cirrusBenefitPlanName;
                            srnMemberCoverageObj.cirrusServiceAreaIDType = memberCoverageObj.cirrusServiceAreaIDType;
                            srnMemberCoverageObj.radiationMedNecType = memberCoverageObj.radiationMedNecType;
                            srnMemberCoverageObj.providerNetworkReciprocityType = memberCoverageObj.providerNetworkReciprocityType;
                            srnMemberCoverageObj.cmsSegID = memberCoverageObj.cmsSegID;

                            srnMemberCoverageList.add(srnMemberCoverageObj);
                        }
                    }
                    srnMemberCoverages.memberCoverage = srnMemberCoverageList;
                    returnMember.memberCoverages = srnMemberCoverages;
                    // Member => MemberCoverages Ends

                    // Member => MemberOtherCoverages
                    ACET_CreateAuthorizationRequest.MemberOtherCoverages srnOtherCoverages = new ACET_CreateAuthorizationRequest.MemberOtherCoverages();
                    List<ACET_CreateAuthorizationRequest.MemberOtherCoverage> srnOtherCoverageList = new List<ACET_CreateAuthorizationRequest.MemberOtherCoverage>();

                    if(hscMember.memberOtherCoverages != null && hscMember.memberOtherCoverages.memberOtherCoverage != null){

                        for(ACET_CaseProvidersResp.MemberOtherCoverage otherCoverageObj : hscMember.memberOtherCoverages.memberOtherCoverage){
                            ACET_CreateAuthorizationRequest.MemberOtherCoverage srnOtherCoverageObj = new ACET_CreateAuthorizationRequest.MemberOtherCoverage();

                            srnOtherCoverageObj.otherCoverageSequenceNumber = otherCoverageObj.otherCoverageSequenceNumber;
                            srnOtherCoverageObj.otherCoveragePolicyNumber = otherCoverageObj.otherCoveragePolicyNumber;
                            srnOtherCoverageObj.carrierName = otherCoverageObj.carrierName;
                            srnOtherCoverageObj.startDate = otherCoverageObj.startDate;
                            srnOtherCoverageObj.endDate = otherCoverageObj.endDate;
                            srnOtherCoverageObj.otherCoverageOrderType = otherCoverageObj.otherCoverageOrderType;
                            srnOtherCoverageObj.otherCoverageReasonTypeID = otherCoverageObj.otherCoverageReasonTypeID;
                            srnOtherCoverageList.add(srnOtherCoverageObj);
                        }
                    }
                    srnOtherCoverages.memberOtherCoverage = srnOtherCoverageList;
                    returnMember.memberOtherCoverages = srnOtherCoverages;
                    // Member => MemberOtherCoverages Ends

                    // Member => MemberShareCosts
                    ACET_CreateAuthorizationRequest.MemberShareCosts srnMemberShareCosts = new ACET_CreateAuthorizationRequest.MemberShareCosts();
                    List<ACET_CreateAuthorizationRequest.MemberShareCost> srnMemberShareCostList = new List<ACET_CreateAuthorizationRequest.MemberShareCost>();

                    if(hscMember.memberShareCosts != null && hscMember.memberShareCosts.memberShareCost != null){

                        for(ACET_CaseProvidersResp.MemberShareCost shareCostObj : hscMember.memberShareCosts.memberShareCost){
                            ACET_CreateAuthorizationRequest.MemberShareCost srnShareCostObj = new ACET_CreateAuthorizationRequest.MemberShareCost();

                            srnShareCostObj.shareAmount = shareCostObj.shareAmount;
                            srnShareCostObj.shareAmountStartDate = shareCostObj.shareAmountStartDate;
                            srnShareCostObj.shareAmountEndDate = shareCostObj.shareAmountEndDate;
                            srnMemberShareCostList.add(srnShareCostObj);
                        }
                    }
                    srnMemberShareCosts.memberShareCost = srnMemberShareCostList;
                    returnMember.memberShareCosts = srnMemberShareCosts;
                    // Member => MemberShareCosts Ends

                    // Member => MemberPopulations
                    ACET_CreateAuthorizationRequest.MemberPopulations srnMemberPopulations = new ACET_CreateAuthorizationRequest.MemberPopulations();
                    List<ACET_CreateAuthorizationRequest.MemberPopulation> srnMemberPopulationList = new List<ACET_CreateAuthorizationRequest.MemberPopulation>();

                    if(hscMember.memberPopulations != null && hscMember.memberPopulations.memberPopulation != null){

                        for(ACET_CaseProvidersResp.MemberPopulation memberPopulationObj : hscMember.memberPopulations.memberPopulation){
                            ACET_CreateAuthorizationRequest.MemberPopulation srnPopulationObj = new ACET_CreateAuthorizationRequest.MemberPopulation();

                            srnPopulationObj.populationId = memberPopulationObj.populationId;
                            srnPopulationObj.startDate = memberPopulationObj.startDate;
                            srnPopulationObj.endDate = memberPopulationObj.endDate;
                            srnPopulationObj.populationRuleName = memberPopulationObj.populationRuleName;
                            srnPopulationObj.memberPopAssociationDateTime = memberPopulationObj.memberPopAssociationDateTime;
                            srnMemberPopulationList.add(srnPopulationObj);
                        }
                    }
                    srnMemberPopulations.memberPopulation = srnMemberPopulationList;
                    returnMember.memberPopulations = srnMemberPopulations;
                    // Member => MemberPopulations Ends

                    // Member => MemberPcps
                    ACET_CreateAuthorizationRequest.MemberPcps srnMemberPcps = new ACET_CreateAuthorizationRequest.MemberPcps();
                    List<ACET_CreateAuthorizationRequest.MemberPcp> srnMemberPcpList = new List<ACET_CreateAuthorizationRequest.MemberPcp>();

                    if(hscMember.memberPcps != null && hscMember.memberPcps.memberPcp != null){

                        for(ACET_CaseProvidersResp.MemberPcp memberPcpObj : hscMember.memberPcps.memberPcp){
                            ACET_CreateAuthorizationRequest.MemberPcp srnPcpObj = new ACET_CreateAuthorizationRequest.MemberPcp();

                            srnPcpObj.ndbMpin = memberPcpObj.ndbMpin;
                            srnPcpObj.pcpSeqNbr = memberPcpObj.pcpSeqNbr;
                            srnPcpObj.effectiveDate = memberPcpObj.effectiveDate;
                            srnPcpObj.firstName = memberPcpObj.firstName;
                            srnPcpObj.lastName = memberPcpObj.lastName;
                            srnPcpObj.phoneInternationalInd = memberPcpObj.phoneInternationalInd;
                            srnPcpObj.phone = memberPcpObj.phone;
                            srnPcpObj.endDate = memberPcpObj.endDate;
                            srnPcpObj.individualProvAssociationID = memberPcpObj.individualProvAssociationID;
                            srnPcpObj.nicePcpProviderSrvcLocNbr = memberPcpObj.nicePcpProviderSrvcLocNbr;
                            srnPcpObj.nicePmgNetworkCode = memberPcpObj.nicePmgNetworkCode;
                            srnPcpObj.acoID = memberPcpObj.acoID;
                            srnPcpObj.acoName = memberPcpObj.acoName;
                            srnPcpObj.mdmProviderID = memberPcpObj.mdmProviderID;
                            srnPcpObj.federalTaxID = memberPcpObj.federalTaxID;
                            srnPcpObj.marketNumber = memberPcpObj.marketNumber;
                            srnPcpObj.marketType = memberPcpObj.marketType;
                            srnPcpObj.cirrusProviderLocationAffiliationID = memberPcpObj.cirrusProviderLocationAffiliationID;
                            srnMemberPcpList.add(srnPcpObj);
                        }
                    }
                    srnMemberPcps.memberPcp = srnMemberPcpList;
                    returnMember.memberPcps = srnMemberPcps;
                    // Member => MemberPcps Ends

                    // Member => MemberAdditionalPlanFeatures
                    ACET_CreateAuthorizationRequest.MemberAdditionalPlanFeatures srnaddPlanfeatures = new ACET_CreateAuthorizationRequest.MemberAdditionalPlanFeatures();
                    List<ACET_CreateAuthorizationRequest.MemberAdditionalPlanFeature> srnAddPlanfeatureList = new List<ACET_CreateAuthorizationRequest.MemberAdditionalPlanFeature>();

                    if(hscMember.memberAdditionalPlanFeatures != null && hscMember.memberAdditionalPlanFeatures.memberAdditionalPlanFeature != null){

                        for(ACET_CaseProvidersResp.MemberAdditionalPlanFeature addPlanfeatureObj : hscMember.memberAdditionalPlanFeatures.memberAdditionalPlanFeature){
                            ACET_CreateAuthorizationRequest.MemberAdditionalPlanFeature srnAddPlanfeatureObj = new ACET_CreateAuthorizationRequest.MemberAdditionalPlanFeature();

                            srnAddPlanfeatureObj.planFeatureCategoryType = addPlanfeatureObj.planFeatureCategoryType;
                            srnAddPlanfeatureObj.planFeatureType = addPlanfeatureObj.planFeatureType;
                            srnAddPlanfeatureList.add(srnAddPlanfeatureObj);
                        }
                    }
                    srnaddPlanfeatures.memberAdditionalPlanFeature = srnAddPlanfeatureList;
                    returnMember.memberAdditionalPlanFeatures = srnaddPlanfeatures;
                    // Member => MemberAdditionalPlanFeatures Ends

                    // Member => MemberIdentifiers
                    ACET_CreateAuthorizationRequest.MemberIdentifiers srnMemberIdentifiers = new ACET_CreateAuthorizationRequest.MemberIdentifiers();
                    List<ACET_CreateAuthorizationRequest.MemberIdentifier> srnMemberIdentifierList = new List<ACET_CreateAuthorizationRequest.MemberIdentifier>();

                    if(hscMember.memberIdentifiers != null && hscMember.memberIdentifiers.memberIdentifier != null){

                        for(ACET_CaseProvidersResp.MemberIdentifier memberIdentifierObj : hscMember.memberIdentifiers.memberIdentifier){
                            ACET_CreateAuthorizationRequest.MemberIdentifier srnIdentifierObj = new ACET_CreateAuthorizationRequest.MemberIdentifier();

                            srnIdentifierObj.memberIDType = memberIdentifierObj.memberIDType;
                            srnIdentifierObj.memberIDText = memberIdentifierObj.memberIDText;
                            srnIdentifierObj.memberIDDesc = memberIdentifierObj.memberIDDesc;
                            srnMemberIdentifierList.add(srnIdentifierObj);
                        }
                    }
                    srnMemberIdentifiers.memberIdentifier = srnMemberIdentifierList;
                    returnMember.memberIdentifiers = srnMemberIdentifiers;
                    // Member => MemberIdentifiers Ends

                    // Member => MemberPhones
                    ACET_CreateAuthorizationRequest.MemberPhones srnMemberPhones = new ACET_CreateAuthorizationRequest.MemberPhones();
                    List<ACET_CreateAuthorizationRequest.MemberPhone> srnMemberPhoneList = new List<ACET_CreateAuthorizationRequest.MemberPhone>();

                    if(hscMember.memberPhones != null && hscMember.memberPhones.memberPhone != null){

                        for(ACET_CaseProvidersResp.MemberPhone memberPhoneObj : hscMember.memberPhones.memberPhone){
                            ACET_CreateAuthorizationRequest.MemberPhone srnMemberPhoneObj = new ACET_CreateAuthorizationRequest.MemberPhone();

                            srnMemberPhoneObj.phoneType = memberPhoneObj.phoneType;
                            srnMemberPhoneObj.phone = memberPhoneObj.phone;
                            srnMemberPhoneObj.phoneInternationalInd = memberPhoneObj.phoneInternationalInd;
                            srnMemberPhoneObj.preferredInd = memberPhoneObj.preferredInd;
                            srnMemberPhoneList.add(srnMemberPhoneObj);
                        }
                    }
                    srnMemberPhones.memberPhone = srnMemberPhoneList;
                    returnMember.memberPhones = srnMemberPhones;
                    // Member => MemberPhones Ends

                     // Member => MemberAddresses
                    ACET_CreateAuthorizationRequest.MemberAddresses srnMemberAdds = new ACET_CreateAuthorizationRequest.MemberAddresses();
                    List<ACET_CreateAuthorizationRequest.MemberAddress> srnMemberAddList = new List<ACET_CreateAuthorizationRequest.MemberAddress>();

                    if(hscMember.memberAddresses != null && hscMember.memberAddresses.memberAddress != null){

                        for(ACET_CaseProvidersResp.MemberAddress memberAddObj : hscMember.memberAddresses.memberAddress){
                            ACET_CreateAuthorizationRequest.MemberAddress srnMemberAddObj = new ACET_CreateAuthorizationRequest.MemberAddress();

                            srnMemberAddObj.addressType = memberAddObj.addressType;
                            srnMemberAddObj.addressTypeDesc = memberAddObj.addressTypeDesc;
                            srnMemberAddObj.address1 = memberAddObj.address1;
                            srnMemberAddObj.address2 = memberAddObj.address2;
                            srnMemberAddObj.city = memberAddObj.city;
                            srnMemberAddObj.state = memberAddObj.state;
                            srnMemberAddObj.stateDesc = memberAddObj.stateDesc;
                            srnMemberAddObj.zip = memberAddObj.zip;
                            srnMemberAddObj.zipSuffix = memberAddObj.zipSuffix;
                            srnMemberAddObj.countryCode = memberAddObj.countryCode;
                            srnMemberAddObj.countryCodeDesc = memberAddObj.countryCodeDesc;
                            srnMemberAddObj.effectiveDate = memberAddObj.effectiveDate;
                            srnMemberAddObj.endDate = memberAddObj.endDate;
                            srnMemberAddObj.countyFIPS = memberAddObj.countyFIPS;
                            srnMemberAddObj.countyName = memberAddObj.countyName;
                            srnMemberAddList.add(srnMemberAddObj);
                        }
                    }
                    srnMemberAdds.memberAddress = srnMemberAddList;
                    returnMember.memberAddresses = srnMemberAdds;
                    // Member => MemberAddresses Ends

                    // Member => MemberCNSHealthStatuses
                    ACET_CreateAuthorizationRequest.MemberCNSHealthStatuses srnMemberhealthStatuses = new ACET_CreateAuthorizationRequest.MemberCNSHealthStatuses();
                    List<ACET_CreateAuthorizationRequest.MemberCNSHealthStatus> srnMemberhealthStatusList = new List<ACET_CreateAuthorizationRequest.MemberCNSHealthStatus>();

                    if(hscMember.memberCNSHealthStatuses != null && hscMember.memberCNSHealthStatuses.memberCNSHealthStatus != null){

                        for(ACET_CaseProvidersResp.MemberCNSHealthStatus memberHealthStatusObj : hscMember.memberCNSHealthStatuses.memberCNSHealthStatus){
                            ACET_CreateAuthorizationRequest.MemberCNSHealthStatus srnMemberHealthStatusObj = new ACET_CreateAuthorizationRequest.MemberCNSHealthStatus();

                            srnMemberHealthStatusObj.healthStatusSeqNum = memberHealthStatusObj.healthStatusSeqNum;
                            srnMemberHealthStatusObj.cnsHealthStatusCode = memberHealthStatusObj.cnsHealthStatusCode;
                            srnMemberHealthStatusObj.cnsHealthStatusDesc = memberHealthStatusObj.cnsHealthStatusDesc;
                            srnMemberHealthStatusObj.commentText = memberHealthStatusObj.commentText;
                            srnMemberHealthStatusObj.startDate = memberHealthStatusObj.startDate;
                            srnMemberHealthStatusObj.endDate = memberHealthStatusObj.endDate;
                            srnMemberhealthStatusList.add(srnMemberHealthStatusObj);
                        }
                    }
                    srnMemberhealthStatuses.memberCNSHealthStatus = srnMemberhealthStatusList;
                    returnMember.MemberCNSHealthStatuses = srnMemberhealthStatuses;
                    // Member => MemberCNSHealthStatuses Ends

                    // Member => MemberBenefitPlanTiers
                    ACET_CreateAuthorizationRequest.MemberBenefitPlanTiers srnMemberBenefitTiers = new ACET_CreateAuthorizationRequest.MemberBenefitPlanTiers();
                    List<ACET_CreateAuthorizationRequest.MemberBenefitPlanTier> srnMemberBenefitTierList = new List<ACET_CreateAuthorizationRequest.MemberBenefitPlanTier>();

                    if(hscMember.memberBenefitPlanTiers != null && hscMember.memberBenefitPlanTiers.memberBenefitPlanTier != null){

                        for(ACET_CaseProvidersResp.MemberBenefitPlanTier memberBenefitTierObj : hscMember.memberBenefitPlanTiers.memberBenefitPlanTier){
                            ACET_CreateAuthorizationRequest.MemberBenefitPlanTier srnMemberBenefitTierObj = new ACET_CreateAuthorizationRequest.MemberBenefitPlanTier();

                            srnMemberBenefitTierObj.cirrusBenefitPlanID = memberBenefitTierObj.cirrusBenefitPlanID;
                            srnMemberBenefitTierObj.cirrusBenefitPlanName = memberBenefitTierObj.cirrusBenefitPlanName;
                            srnMemberBenefitTierObj.cirrusBenefitPlanTierID = memberBenefitTierObj.cirrusBenefitPlanTierID;
                            srnMemberBenefitTierObj.cirrusBenefitPlanTierName = memberBenefitTierObj.cirrusBenefitPlanTierName;
                            srnMemberBenefitTierObj.cirrusBenefitPlanTierServiceAreaType = memberBenefitTierObj.cirrusBenefitPlanTierServiceAreaType;
                            srnMemberBenefitTierObj.cirrusBenefitPlanTierServiceAreaTypeDesc = memberBenefitTierObj.cirrusBenefitPlanTierServiceAreaTypeDesc;
                            srnMemberBenefitTierObj.cirrusNetworkTierID = memberBenefitTierObj.cirrusNetworkTierID;
                            srnMemberBenefitTierObj.cirrusNetworkTierName = memberBenefitTierObj.cirrusNetworkTierName;
                            srnMemberBenefitTierObj.cirrusNetworkIDType = memberBenefitTierObj.cirrusNetworkIDType;
                            srnMemberBenefitTierObj.cirrusNetworkName = memberBenefitTierObj.cirrusNetworkName;
                            srnMemberBenefitTierList.add(srnMemberBenefitTierObj);
                        }
                    }
                    srnMemberBenefitTiers.memberBenefitPlanTier = srnMemberBenefitTierList;
                    returnMember.memberBenefitPlanTiers = srnMemberBenefitTiers;
                    // Member => MemberBenefitPlanTiers Ends

                    // Member => MemberContacts
                    ACET_CreateAuthorizationRequest.MemberContacts srnMemberContacts = new ACET_CreateAuthorizationRequest.MemberContacts();
                    List<ACET_CreateAuthorizationRequest.MemberContact> srnMemberContactList = new List<ACET_CreateAuthorizationRequest.MemberContact>();

                    if(hscMember.memberContacts != null && hscMember.memberContacts.memberContact != null){

                        for(ACET_CaseProvidersResp.MemberContact memberContactObj : hscMember.memberContacts.memberContact){
                            ACET_CreateAuthorizationRequest.MemberContact srnMemberContactObj = new ACET_CreateAuthorizationRequest.MemberContact();

                            srnMemberContactObj.contactSequenceNumber = memberContactObj.contactSequenceNumber;
                            srnMemberContactObj.contactType = memberContactObj.contactType;
                            srnMemberContactObj.otherContactTypeDescription = memberContactObj.otherContactTypeDescription;
                            srnMemberContactObj.firstName = memberContactObj.firstName;
                            srnMemberContactObj.lastName = memberContactObj.lastName;
                            srnMemberContactObj.address1 = memberContactObj.address1;
                            srnMemberContactObj.address2 = memberContactObj.address2;
                            srnMemberContactObj.city = memberContactObj.city;
                            srnMemberContactObj.state = memberContactObj.state;
                            srnMemberContactObj.zip = memberContactObj.zip;
                            srnMemberContactObj.zipSuffix = memberContactObj.zipSuffix;
                            srnMemberContactObj.countryCode = memberContactObj.countryCode;
                            srnMemberContactObj.effectiveDate = memberContactObj.effectiveDate;
                            srnMemberContactObj.endDate = memberContactObj.endDate;
                            srnMemberContactObj.commentText = memberContactObj.commentText;
                            srnMemberContactObj.phiAuthorizedInd = memberContactObj.phiAuthorizedInd;
                            srnMemberContactObj.phiAuthorizedExpireEventDesc = memberContactObj.phiAuthorizedExpireEventDesc;
                            srnMemberContactObj.phiTypeOfInfoDesc = memberContactObj.phiTypeOfInfoDesc;
                            srnMemberContactObj.phiAuthorizedPurposeDesc = memberContactObj.phiAuthorizedPurposeDesc;
                            srnMemberContactObj.emailAddress = memberContactObj.emailAddress;
                            srnMemberContactObj.contactTypePrimaryInd = memberContactObj.contactTypePrimaryInd;
                            srnMemberContactObj.contactPermissionInd = memberContactObj.contactPermissionInd;
                            srnMemberContactObj.supportSystemIndicator = memberContactObj.supportSystemIndicator;
                            srnMemberContactObj.supportIndicatorType = memberContactObj.supportIndicatorType;
                            srnMemberContactObj.contactFrequency = memberContactObj.contactFrequency;
                            srnMemberContactObj.relationship = memberContactObj.relationship;
                            srnMemberContactObj.organizationName = memberContactObj.organizationName;
                            srnMemberContactObj.recordSourceDateTime = memberContactObj.recordSourceDateTime;
                            srnMemberContactObj.submittingProviderClinicalID = memberContactObj.submittingProviderClinicalID;
                            srnMemberContactObj.legalGuardianRelationshipType = memberContactObj.legalGuardianRelationshipType;
                            srnMemberContactObj.interdisciplinaryRoleType = memberContactObj.interdisciplinaryRoleType;
                            srnMemberContactObj.lastMemberISPAttended = memberContactObj.lastMemberISPAttended;
                            srnMemberContactObj.memberLegalRepresentationInd = memberContactObj.memberLegalRepresentationInd;
                            srnMemberContactObj.livesWithMemberInd = memberContactObj.livesWithMemberInd;
                            srnMemberContactObj.relationshipContactType = memberContactObj.relationshipContactType;

                            // Member Contact Identifiers
                            List<ACET_CreateAuthorizationRequest.MemberContactIdentifier> srnMemberContactIdentifierList = new List<ACET_CreateAuthorizationRequest.MemberContactIdentifier> ();
                            ACET_CreateAuthorizationRequest.MemberContactIdentifiers srnMemberContactIdentifiers = new ACET_CreateAuthorizationRequest.MemberContactIdentifiers ();
                            if(memberContactObj.memberContactIdentifiers != null && memberContactObj.memberContactIdentifiers.memberContactIdentifier != null){
                                for(ACET_CaseProvidersResp.MemberContactIdentifier memberContactIdentifierObject : memberContactObj.memberContactIdentifiers.memberContactIdentifier){
                                    ACET_CreateAuthorizationRequest.MemberContactIdentifier srnMemberContactIdentifierObj = new ACET_CreateAuthorizationRequest.MemberContactIdentifier();

                                    srnMemberContactIdentifierObj.memberContactIDType = memberContactIdentifierObject.memberContactIDType;
                                    srnMemberContactIdentifierObj.memberContactID = memberContactIdentifierObject.memberContactID;
                                    srnMemberContactIdentifierList.add(srnMemberContactIdentifierObj);
                                }
                            }
                            srnMemberContactIdentifiers.memberContactIdentifier = srnMemberContactIdentifierList;
                            srnMemberContactObj.memberContactIdentifiers = srnMemberContactIdentifiers;

                            // Member Contact Telephones
                            List<ACET_CreateAuthorizationRequest.MemberContactTelephone> srnMemberContactTelephoneList = new List<ACET_CreateAuthorizationRequest.MemberContactTelephone> ();
                            ACET_CreateAuthorizationRequest.MemberContactTelephones srnMemberContactTelephones = new ACET_CreateAuthorizationRequest.MemberContactTelephones ();
                            if(memberContactObj.memberContactTelephones != null && memberContactObj.memberContactTelephones.memberContactTelephone != null){
                                for(ACET_CaseProvidersResp.MemberContactTelephone memberContactPhoneObject : memberContactObj.memberContactTelephones.memberContactTelephone){
                                    ACET_CreateAuthorizationRequest.MemberContactTelephone srnMemberContactPhoneObj = new ACET_CreateAuthorizationRequest.MemberContactTelephone();

                                    srnMemberContactPhoneObj.phoneSeqNum = memberContactPhoneObject.phoneSeqNum;
                                    srnMemberContactPhoneObj.phone = memberContactPhoneObject.phone;
                                    srnMemberContactPhoneObj.phoneInternaltionalInd = memberContactPhoneObject.phoneInternaltionalInd;
                                    srnMemberContactPhoneObj.phoneType = memberContactPhoneObject.phoneType;
                                    srnMemberContactPhoneObj.preferredInd = memberContactPhoneObject.preferredInd;
                                    srnMemberContactTelephoneList.add(srnMemberContactPhoneObj);
                                }
                            }
                            srnMemberContactTelephones.memberContactTelephone = srnMemberContactTelephoneList;
                            srnMemberContactObj.memberContactTelephones = srnMemberContactTelephones;

                            srnMemberContactList.add(srnMemberContactObj);
                        }
                    }
                    srnMemberContacts.memberContact = srnMemberContactList;
                    returnMember.memberContacts = srnMemberContacts;
                    // Member => MemberContacts Ends

                    returnCaseDetails.member = returnMember;
                }

                
                returnResponse.caseDetails = returnCaseDetails;

                calloutResult.success = true; 
                calloutResult.statusCode = Integer.valueOf(result.responseCode); //statusCode;
                calloutResult.message = '';
                calloutResult.response = returnResponse;
            } else {
                calloutResult.success = true; 
                calloutResult.statusCode = Integer.valueOf(result.responseCode);
                calloutResult.message = '';
                calloutResult.response = returnResponse;
            }

        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug('@@@@Exception ## '+e.getLineNumber());
            calloutResult.success = true;
            calloutResult.message = '';
            calloutResult.statusCode=999;
        } 
        
        return calloutResult;
    }
    public static String requestFormatProcessing(List<ACET_CaseProvidersReq.HscProvider> providerDetails , ACET_CaseProvidersReq.Member memberDetails) {
       
        ACET_CaseProvidersReq caseProvidersReqObj = new ACET_CaseProvidersReq();
        caseProvidersReqObj.transactionId= '';

        // metadata -
        ACET_CaseProvidersReq.Metadata metadataObj= new ACET_CaseProvidersReq.Metadata();
        metadataObj.clientNPI = '';
        metadataObj.clientLocation = '';
        metadataObj.clientGroup = 'ACET';
        metadataObj.clientBusiness = 'ACET';
        metadataObj.caseSubmissionTransactionID = '';

        caseProvidersReqObj.metadata = metadataObj;

           // Passing Federation ID in userID
           String loggedInUsername = UserInfo.getName();
           User loggedInUser = [SELECT Name, Email, FederationIdentifier, Lastname, Firstname FROM User WHERE Name= :loggedInUsername];

        // invocationContext
        ACET_CaseProvidersReq.InvocationContext invocationContextObj = new ACET_CaseProvidersReq.InvocationContext();
        invocationContextObj.userIDType = 'USER_ID';
        invocationContextObj.userID = loggedInUser.FederationIdentifier;
        invocationContextObj.serviceCorrelationID ='';
        invocationContextObj.locationID = 'ACET';
        invocationContextObj.clientID = 'ACET';
        invocationContextObj.clientCorrelationID ='';

        caseProvidersReqObj.invocationContext = invocationContextObj;

        // member
        ACET_CaseProvidersReq.Member memberObj= new ACET_CaseProvidersReq.Member();
        memberObj = (ACET_CaseProvidersReq.Member) memberDetails;
       
        caseProvidersReqObj.member = memberObj;

        // hscProviders
        ACET_CaseProvidersReq.HscProviders hscProvidersObj = new ACET_CaseProvidersReq.HscProviders();
        List<ACET_CaseProvidersReq.HscProvider> hscProviderList= new List<ACET_CaseProvidersReq.HscProvider>();
        hscProviderList = (List<ACET_CaseProvidersReq.HscProvider>) providerDetails;
        
        hscProvidersObj.hscProvider = hscProviderList;

        caseProvidersReqObj.hscProviders = hscProvidersObj;

        String reqJSON = SYSTEM.JSON.serialize(caseProvidersReqObj);
        System.debug(LoggingLevel.INFO, 'reqJSON@@' + reqJSON);

        return reqJSON;
    }

    public static String convertDateFromLong (Long dateLong){
        String returnDate = null;
        if(dateLong != null){
            returnDate = DateTime.newInstance(dateLong).format('yyyy-MM-dd');
        }
        return returnDate;
    }
    public static String convertDateTimeFromLong (Long dateTimeLong){
        String returnDateTime = null;
        if(dateTimeLong != null){
            String datePart = DateTime.newInstance(dateTimeLong).format('yyyy-MM-dd');
            String timePart = DateTime.newInstance(dateTimeLong).format('HH:mm:ss.SSSZ');

            returnDateTime = datePart + 'T' + timePart;
        }
        return returnDateTime;
    }
}