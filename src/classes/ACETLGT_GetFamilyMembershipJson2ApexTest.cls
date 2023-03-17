@Istest
public class ACETLGT_GetFamilyMembershipJson2ApexTest {
    public static testmethod void test(){
        ACETLGT_GetFamilyMembershipJson2Apex gfma = new ACETLGT_GetFamilyMembershipJson2Apex();
        gfma.getFamilyMembershipResponse = new ACETLGT_GetFamilyMembershipJson2Apex.cls_getFamilyMembershipResponse();
        gfma.getFamilyMembershipResponse.individual 
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_individual>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_individual()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].individualIdentifier);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].name);
        gfma.getFamilyMembershipResponse.individual[0].name = new ACETLGT_GetFamilyMembershipJson2Apex.cls_name();
        System.debug(gfma.getFamilyMembershipResponse.individual[0].name.firstName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].name.lastName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].name.middleName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].name.nameSuffix);
        
        System.debug(gfma.getFamilyMembershipResponse.individual[0].birthDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].genderCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].genderDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].socialSecurityNumber);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].privacyIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].relationshipCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].relationshipDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address);
        gfma.getFamilyMembershipResponse.individual[0].address = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_address>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_address()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].typeCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].addressLine1);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].addressLine2);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].city);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].countryDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].countrycode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].postalcode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].address[0].stateCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].identifiers);
        gfma.getFamilyMembershipResponse.individual[0].identifiers 
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_identifiers>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_identifiers()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].identifiers[0].id);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].identifiers[0].type);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership);
        gfma.getFamilyMembershipResponse.individual[0].membership 
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_membership>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_membership()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].sourceSysCode);     
        gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_coverages>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_coverages()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].groupNumber);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].groupName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].eligibilitySystemTypeCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].claimSystemTypeCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].memberStatus);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_bundleOptions>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_bundleOptions()};
        gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits
                = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_benefits>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_benefits()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitBundleId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitBundleName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitBundleOptionId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitBundleOptionDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitEffectiveDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitExpirationDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitPlanId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitPlanName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitType);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].benefitTypeDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLevelCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].product);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].product
            = new ACETLGT_GetFamilyMembershipJson2Apex.cls_product();
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].product.productIdentifier);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].product.productName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].product.productType);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].relationshipCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].relationshipDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].memberIdCardSerialNumber);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].subscriberIdCardSerialNumber);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].eligibilityStatusCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].serviceArea);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].cancelReasonTypeCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].planType);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].networkScheduleID);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].marketSegment);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].stateOfIssueCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].fundingArrangementCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].fundingArrangementDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLastUpdateDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].individualGroupTypeCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLevelList);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLevelList
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_coverageLevelList>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_coverageLevelList()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLevelList[0].covLevelCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLevelList[0].covLevelDesc);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLevelList[0].covLevelEffDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].coverageLevelList[0].covLevelExpDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].holdList);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators);
		gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators
		= new ACETLGT_GetFamilyMembershipJson2Apex.cls_indicators();
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.erisaIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.qmscoIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.onshoreRestrictionIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.proofOfHealthCoverageIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.dvcnIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.pcpRequiredIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.clickToCall);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.clickToChat);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.activationMessaging);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.secureMessaging);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].coverages[0].bundleOptions[0].benefits[0].indicators.hsaIndicator);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].utilizationPlan
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_utilizationPlan>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_utilizationPlan()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].utilizationPlan[0].planId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].utilizationPlan[0].entityId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].utilizationPlan[0].externalPlanId);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].cob
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_cob>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_cob()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].cobTypeCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].cobTypeCodeDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].custodyCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].otherInsurancePrimacyIndicator);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].coverageType);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].medicareEntitlementType);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].medicareEntitlementReasonCode);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].cobEffectiveStartDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].cobEffectiveEndDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].otherInsuranceVerifyDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].otherInsurancePolicyNumber);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].otherInsuranceCardholderId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].otherInsuranceCarrierName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].cob[0].cobRelatedEntityContactTelephoneNumber);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].providers
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_providers>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_providers()};
        gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].providerIdentifiers
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_providerIdentifiers>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_providerIdentifiers()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].providerIdentifiers[0].id_z);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].providerIdentifiers[0].type_z);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].assignmentType);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].effectiveDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].expirationDate);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].firstName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].lastName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].networkId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].networkScheduleId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].networkScheduleDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].organizationLocationId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].providers[0].locationAffiliationID);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].clinicalProgram
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_clinicalProgram>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_clinicalProgram()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].clinicalProgram[0].clinicalProgramVendor);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].clinicalProgram[0].serviceCategory);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].clinicalProgram[0].umDetermination);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType
            = new ACETLGT_GetFamilyMembershipJson2Apex.cls_carrierType();
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType.carrierId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType.carrierName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType.carrierExternalId);
        gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType.lob
            = new List<ACETLGT_GetFamilyMembershipJson2Apex.cls_lob>{new ACETLGT_GetFamilyMembershipJson2Apex.cls_lob()};
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType.lob[0].lineOfBusinessId);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType.lob[0].lineOfBusinessName);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].carrierType.lob[0].lineOfBusinessDescription);
        System.debug(gfma.getFamilyMembershipResponse.individual[0].membership[0].identifiers);
        ACETLGT_GetFamilyMembershipJson2Apex.parse('{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"577305900","name":{"firstName":"KYLEE","lastName":"CINTRON","middleName":"R","nameSuffix":""},"birthDate":"2014-06-17","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"728522247","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"8 PLEASANT VILLAGE DRIVE","addressLine2":"","city":"SUCCASUNNA","postalCode":"07876","stateCode":"NJ","countryCode":"US"}],"dependentDisabilityList":[{}],"identifiers":[],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1280453","groupName":"VAC-U-MAX","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000662","benefitPlanName":"Ox-NJLG-EPO-HSA-2015-002","benefitType":"MD","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"33889271903","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"01","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000183","benefitPlanName":"$25/$50/$75","benefitType":"RX","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"33889271903","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"MD","cobTypeCodeDescription":"Medical","otherInsurancePrimacyIndicator":"P","coverageType":"1","cobEffectiveStartDate":"2019-01-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-11-20","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"W248410563","otherInsuranceCarrierName":"AETNA","cobRelatedEntityContactTelephoneNumber":""},{"cobTypeCode":"RX","cobTypeCodeDescription":"RX","otherInsurancePrimacyIndicator":"P","coverageType":"1","cobEffectiveStartDate":"2019-01-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-11-20","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"W248410563","otherInsuranceCarrierName":"AETNA","cobRelatedEntityContactTelephoneNumber":""}],"providers":[{}],"clinicalProgram":[],"identifiers":[{"id":"577305900","type":"enrolleeEID"},{"id":"27913892","type":"subscriberSystemId"},{"id":"27903735","type":"enrolleeSystemID"},{"id":"1260404558","type":"subscriberSurrogateKey"},{"id":"1260404541","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"194232085","name":{"firstName":"LOUIS","lastName":"CINTRON","middleName":"","nameSuffix":""},"birthDate":"1969-09-03","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"147749073","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"8 PLEASANT VILLAGE DRIVE","addressLine2":"","city":"SUCCASUNNA","postalCode":"07876","stateCode":"NJ","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1280453","groupName":"VAC-U-MAX","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000662","benefitPlanName":"Ox-NJLG-EPO-HSA-2015-002","benefitType":"MD","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"33889271900","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"01","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000183","benefitPlanName":"$25/$50/$75","benefitType":"RX","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"33889271900","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"194232085","type":"enrolleeEID"},{"id":"27913892","type":"subscriberSystemId"},{"id":"27913892","type":"enrolleeSystemID"},{"id":"1260404558","type":"subscriberSurrogateKey"},{"id":"1260404558","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"221873153","name":{"firstName":"MADISON","lastName":"CINTRON","middleName":"S","nameSuffix":""},"birthDate":"2001-08-14","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"143191393","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"8 PLEASANT VILLAGE DRIVE","addressLine2":"","city":"SUCCASUNNA","postalCode":"07876","stateCode":"NJ","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1280453","groupName":"VAC-U-MAX","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000662","benefitPlanName":"Ox-NJLG-EPO-HSA-2015-002","benefitType":"MD","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"33889271902","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"01","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000183","benefitPlanName":"$25/$50/$75","benefitType":"RX","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"33889271902","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"RX","cobTypeCodeDescription":"RX","otherInsurancePrimacyIndicator":"P","coverageType":"1","cobEffectiveStartDate":"2019-01-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-11-20","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"W248410563","otherInsuranceCarrierName":"AETNA","cobRelatedEntityContactTelephoneNumber":""},{"cobTypeCode":"MD","cobTypeCodeDescription":"Medical","otherInsurancePrimacyIndicator":"P","coverageType":"1","cobEffectiveStartDate":"2019-01-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-11-20","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"W248410563","otherInsuranceCarrierName":"AETNA","cobRelatedEntityContactTelephoneNumber":""}],"providers":[{}],"identifiers":[{"id":"221873153","type":"enrolleeEID"},{"id":"27913892","type":"subscriberSystemId"},{"id":"27903734","type":"enrolleeSystemID"},{"id":"1260404558","type":"subscriberSurrogateKey"},{"id":"1260404551","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"188681895","name":{"firstName":"RAQUEL","lastName":"CINTRON","middleName":"T","nameSuffix":""},"birthDate":"2001-02-01","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"144087606","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"8 PLEASANT VILLAGE DRIVE","addressLine2":"","city":"SUCCASUNNA","postalCode":"07876","stateCode":"NJ","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1280453","groupName":"VAC-U-MAX","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000662","benefitPlanName":"Ox-NJLG-EPO-HSA-2015-002","benefitType":"MD","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"33889271901","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"01","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"2759805","benefitBundleOptionDescription":"LIBERTY EPO HSA OPTION","benefitEffectiveDate":"2020-03-08","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000183","benefitPlanName":"$25/$50/$75","benefitType":"RX","coverageLevelCode":"ECH","product":{"productIdentifier":"PM00000025"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"33889271901","subscriberIdCardSerialNumber":"33889271900","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","networkScheduleID":"LIBERTY_NYNJ_CP","coverageLevelList":[{"covLevelCode":"ECH","covLevelDesc":"Employee and Children","covLevelEffDate":"2020-03-08","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"188681895","type":"enrolleeEID"},{"id":"27913892","type":"subscriberSystemId"},{"id":"28015421","type":"enrolleeSystemID"},{"id":"1260404558","type":"subscriberSurrogateKey"},{"id":"1260404597","type":"enrolleeSurrogateKey"}]}]}]}}');
    }
}