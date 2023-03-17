@IsTest
public class ACETFamilyMembershipJson2ApexTest {
	
    ACETFamilyMembershipJson2Apex obj = new ACETFamilyMembershipJson2Apex();
    static testMethod void testFamilyMemberTest(){
        ACETFamilyMembershipJson2Apex.cls_individual clsInd = new ACETFamilyMembershipJson2Apex.cls_individual();
        clsInd.birthDate='';
        clsInd.genderCode='';
        clsInd.genderDescription='';
        clsInd.individualIdentifier ='';
        clsInd.privacyIndicator='';
        clsInd.relationshipCode='';
        clsInd.relationshipDescription='';
        clsInd.socialSecurityNumber='';
        
        ACETFamilyMembershipJson2Apex.cls_name clsNam= new ACETFamilyMembershipJson2Apex.cls_name();
        clsInd.name=clsNam;
        clsNam.firstName='';
        clsNam.lastName='';
        clsNam.middleName='';
        clsNam.nameSuffix='';
        
        ACETFamilyMembershipJson2Apex.cls_address clsAd = new ACETFamilyMembershipJson2Apex.cls_address();
        clsAd.addressLine1='';
        clsAd.addressLine2='';
        clsAd.city='';
        clsAd.countryCode='';
        clsAd.countryDescription='';
        clsAd.postalCode='';
        clsAd.stateCode='';
        clsAd.typeCode='';
        clsInd.address = new ACETFamilyMembershipJson2Apex.cls_address[]{clsAd};
        
        ACETFamilyMembershipJson2Apex.cls_identifiers clsIdn = new ACETFamilyMembershipJson2Apex.cls_identifiers();
        clsIdn.id='';
        clsIdn.type='';
        clsInd.identifiers = new ACETFamilyMembershipJson2Apex.cls_identifiers[]{clsIdn};
        
        ACETFamilyMembershipJson2Apex.cls_membership clsMem = new ACETFamilyMembershipJson2Apex.cls_membership();
        //
    //	clsMem.clinicalProgram;
      //  clsMem.cob;
        //clsMem.coverages;
        //clsMem.providers;
        //clsMem.identifiers;
        clsMem.sourceSysCode='';
        //clsMem.utilizationPlan;
        clsInd.membership = new ACETFamilyMembershipJson2Apex.cls_membership[]{clsMem};
        
        ACETFamilyMembershipJson2Apex.cls_coverages clsC = new ACETFamilyMembershipJson2Apex.cls_coverages();
      //  clsC.bundleOptions;
        clsC.claimSystemTypeCode='';
        clsC.eligibilitySystemTypeCode='';
        clsC.groupName='';
        clsC.groupNumber='';
        clsC.memberStatus='';
        
        ACETFamilyMembershipJson2Apex.cls_coverageLevelList clsCList = new ACETFamilyMembershipJson2Apex.cls_coverageLevelList();
        clsCList.covLevelCode='';
        clsCList.covLevelDesc='';
        clsCList.covLevelEffDate='';
        clsCList.covLevelExpDate='';
        
        ACETFamilyMembershipJson2Apex.cls_benefits clsBen = new ACETFamilyMembershipJson2Apex.cls_benefits();
        clsBen.benefitBundleId='';
        clsBen.benefitBundleName='';
        clsBen.benefitBundleOptionDescription='';
        clsBen.benefitBundleOptionId='';
        clsBen.benefitEffectiveDate='';
        clsBen.benefitExpirationDate='';
        clsBen.benefitPlanId='';
        clsBen.benefitPlanName='';
        clsBen.benefitType='';
        clsBen.benefitTypeDescription='';
        clsBen.cancelReasonTypeCode='';
        clsBen.coverageLastUpdateDate='';
        clsBen.coverageLevelCode='';
        //clsBen.coverageLevelList.add(clsCList);
        clsBen.eligibilityStatusCode='';
        clsBen.fundingArrangementCode='';
        clsBen.fundingArrangementDescription='';
        clsBen.individualGroupTypeCode='';
        clsBen.marketSegment='';
        clsBen.memberIdCardSerialNumber='';
        clsBen.networkScheduleID='';
        clsBen.planType='';
        clsBen.relationshipCode='';
        clsBen.relationshipDescription='';
        clsBen.serviceArea='';
        clsBen.stateOfIssueCode='';
        clsBen.subscriberIdCardSerialNumber='';
       
        ACETFamilyMembershipJson2Apex.cls_product clsPro = new ACETFamilyMembershipJson2Apex.cls_product();
        clsPro.productIdentifier='';
        clsPro.productName='';
        clsPro.productType='';
        clsBen.product=clsPro;
        
        ACETFamilyMembershipJson2Apex.cls_indicators clsIn = new ACETFamilyMembershipJson2Apex.cls_indicators();
        clsIn.hsaIndicator='';
        clsIn.erisaIndicator='';
        clsIn.qmscoIndicator='';
        clsIn.onshoreRestrictionIndicator='';
        clsIn.dvcnIndicator='';
        clsIn.proofOfHealthCoverageIndicator='';
        clsIn.pcpRequiredIndicator='';
        clsIn.clickToCall='';
        clsIn.clickToChat='';
        clsIn.activationMessaging='';
        clsIn.secureMessaging='';
        clsBen.indicators=clsIn;
        
        ACETFamilyMembershipJson2Apex.cls_utilizationPlan clsU = new ACETFamilyMembershipJson2Apex.cls_utilizationPlan();
        clsU.entityId='';
        clsU.externalPlanId='';
        clsU.planId='';
        
        ACETFamilyMembershipJson2Apex.cls_cob cc=new ACETFamilyMembershipJson2Apex.cls_cob();
        cc.cobEffectiveEndDate='';
        cc.cobEffectiveStartDate='';
        cc.cobRelatedEntityContactTelephoneNumber='';
        cc.cobTypeCode='';
        cc.cobTypeCodeDescription='';
        cc.coverageType='';
        cc.custodyCode='';
        cc.medicareEntitlementReasonCode='';
        cc.medicareEntitlementType='';
        cc.otherInsuranceCardholderId='';
        cc.otherInsuranceCarrierName='';
        cc.otherInsurancePolicyNumber='';
		cc.otherInsurancePrimacyIndicator='';
		cc.otherInsuranceVerifyDate='';
        
        ACETFamilyMembershipJson2Apex.cls_providers clp=new ACETFamilyMembershipJson2Apex.cls_providers();
        clp.assignmentType='';
        clp.effectiveDate='';
        clp.expirationDate='';
        clp.firstName='';
        clp.lastName='';
		clp.locationAffiliationID='';
        clp.networkId='';
        clp.networkScheduleDescription='';
        clp.networkScheduleId='';
        clp.organizationLocationId='';
        
        ACETFamilyMembershipJson2Apex.cls_providerIdentifiers cpi = new ACETFamilyMembershipJson2Apex.cls_providerIdentifiers();
        cpi.id='';
        cpi.type='';
        clp.providerIdentifiers= new ACETFamilyMembershipJson2Apex.cls_providerIdentifiers[]{cpi};
        
        ACETFamilyMembershipJson2Apex.cls_clinicalProgram clc = new ACETFamilyMembershipJson2Apex.cls_clinicalProgram();
        clc.clinicalProgramVendor='';
        clc.serviceCategory='';
        clc.umDetermination='';
        
        ACETFamilyMembershipJson2Apex.cls_carrierType clca = new ACETFamilyMembershipJson2Apex.cls_carrierType();
        clca.carrierExternalId='';
        clca.carrierId='';
        clca.carrierName='';
        clsMem.carrierType=clca;

        ACETFamilyMembershipJson2Apex.cls_lob clslob= new ACETFamilyMembershipJson2Apex.cls_lob();
        clslob.lineOfBusinessDescription='';
        clslob.lineOfBusinessId='';
        clslob.lineOfBusinessName='';
        clca.lob= new ACETFamilyMembershipJson2Apex.cls_lob[]{clslob};
    }
        static testMethod void ACETFamilyMembershipTest1(){
            ACETFamilyMembershipJson2Apex.parse(JSON.serialize(new ACETFamilyMembershipJson2Apex()));
        }
 
}