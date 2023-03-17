@istest
public class ACETLGT_COBControllerTest {

    @IsTest
    Public static void getFamilyMembershipResultsTest()
    {
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User memberAgent;
         System.runAs(thisUser){

        memberAgent = TestDataFactory.getUser('ACET Member'); 
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetFamilyMembersEndpoint', '/api/alpha/eisl/individuals/familymembership/v2.0/read');           
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/alpha/eisl/organizations/employergroups/v4.0/read');           
        mapISLWSConfigs.put('OILTimeout', '3000'); 

        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"492285893","name":{"firstName":"MARGART","lastName":"SEELBACH","middleName":"","nameSuffix":""},"birthDate":"1965-10-09","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"042669567","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"472 LEWELLEN DR NW","addressLine2":"","city":"BRIDGEPORT","postalCode":"06604","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"identifiers":[],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1270391","groupName":"ALL AMERICAN SEWER & DRAIN SERVICE","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"CT S FRDM NG 40/50/4500/80 PPO 19","benefitEffectiveDate":"2019-06-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD","coverageLevelCode":"EMP","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"60377532400","subscriberIdCardSerialNumber":"60377532400","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2019-06-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"MD","cobTypeCodeDescription":"Medical","otherInsurancePrimacyIndicator":"P","coverageType":"2","medicareEntitlementType":"Medicaid","medicareEntitlementReasonCode":"","cobEffectiveStartDate":"2018-06-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-02-12","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"A898987636","otherInsuranceCarrierName":"","cobRelatedEntityContactTelephoneNumber":""},{"cobTypeCode":"MD","cobTypeCodeDescription":"Medical","otherInsurancePrimacyIndicator":"S","coverageType":"1","cobEffectiveStartDate":"2018-06-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-02-12","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"BT78093098","otherInsuranceCarrierName":"BLUE CROSS & BLUE SHIELD","cobRelatedEntityContactTelephoneNumber":""}],"providers":[{"providerIdentifiers":[{"id":"863846187403264466","type":"LTK"},{"id":"1992725238","type":"NPI"},{"id":"744065084","type":"SSN"},{"id":"2079058","type":"MPI"}],"assignmentType":"PCP","effectiveDate":"2019-06-01","expirationDate":"9999-12-31","firstName":"JASON","lastName":"CITARELLA","networkId":"1008476","organizationLocationId":"0","locationAffiliationId":"39607675","address1":"2475 NORTH AVE","address2":"","address3":"","address4":"","address5":"","city":"BRIDGEPORT","state":"CT","postalCode":"06604-2362","country":"US"}],"clinicalProgram":[],"identifiers":[{"id":"492285893","type":"enrolleeEID"},{"id":"100000000003","type":"subscriberSystemId"},{"id":"100000000003","type":"enrolleeSystemID"},{"id":"654672105","type":"subscriberSurrogateKey"},{"id":"654672105","type":"enrolleeSurrogateKey"}]}]}]}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
         }

    	System.runAs(memberAgent){
			list<ACETRelationshipCodes__c> rCodes = new list<ACETRelationshipCodes__c> ();
            rCodes.add(new ACETRelationshipCodes__c (Name = '18',Description__c = 'Self'));
            rCodes.add(new ACETRelationshipCodes__c (Name = '01',Description__c = 'Spouse'));
            rCodes.add(new ACETRelationshipCodes__c (Name = '19',Description__c = 'Child'));
            insert rCodes; 
            Test.startTest();
            
            ACETLGT_COBController Controller  = new ACETLGT_COBController();
            ACETLGT_COBController.getFamilyMembershipResults('654672105', '1270391', '6/1/2019', '60377532400');
            
            Test.stopTest();

        }    
    }
 @IsTest
    Public static void getFamilyMembershipResultsTestone()
    {
         User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User memberAgent;
         System.runAs(thisUser){

        memberAgent = TestDataFactory.getUser('ACET Member'); 
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetFamilyMembersEndpoint', '/api/alpha/eisl/individuals/familymembership/v2.0/read');           
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/alpha/eisl/organizations/employergroups/v4.0/read');           
        mapISLWSConfigs.put('OILTimeout', '3000'); 

        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"492285893","name":{"firstName":"MARGART","lastName":"SEELBACH","middleName":"","nameSuffix":""},"birthDate":"1965-10-09","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"042669567","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"472 LEWELLEN DR NW","addressLine2":"","city":"BRIDGEPORT","postalCode":"06604","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"identifiers":[],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1270391","groupName":"ALL AMERICAN SEWER & DRAIN SERVICE","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"CT S FRDM NG 40/50/4500/80 PPO 19","benefitEffectiveDate":"2019-06-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD","coverageLevelCode":"EMP","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"60377532400","subscriberIdCardSerialNumber":"60377532400","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2019-06-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"MD","cobTypeCodeDescription":"Medical","otherInsurancePrimacyIndicator":"P","coverageType":"2","medicareEntitlementType":"Medicaid","medicareEntitlementReasonCode":"","cobEffectiveStartDate":"2018-06-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-02-12","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"A898987636","otherInsuranceCarrierName":"","cobRelatedEntityContactTelephoneNumber":""},{"cobTypeCode":"MD","cobTypeCodeDescription":"Medical","otherInsurancePrimacyIndicator":"S","coverageType":"1","cobEffectiveStartDate":"2018-06-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2020-02-12","otherInsurancePolicyNumber":"","otherInsuranceCardholderId":"BT78093098","otherInsuranceCarrierName":"BLUE CROSS & BLUE SHIELD","cobRelatedEntityContactTelephoneNumber":""}],"providers":[{"providerIdentifiers":[{"id":"863846187403264466","type":"LTK"},{"id":"1992725238","type":"NPI"},{"id":"744065084","type":"SSN"},{"id":"2079058","type":"MPI"}],"assignmentType":"PCP","effectiveDate":"2019-06-01","expirationDate":"9999-12-31","firstName":"JASON","lastName":"CITARELLA","networkId":"1008476","organizationLocationId":"0","locationAffiliationId":"39607675","address1":"2475 NORTH AVE","address2":"","address3":"","address4":"","address5":"","city":"BRIDGEPORT","state":"CT","postalCode":"06604-2362","country":"US"}],"clinicalProgram":[],"identifiers":[{"id":"492285893","type":"enrolleeEID"},{"id":"100000000003","type":"subscriberSystemId"},{"id":"100000000003","type":"enrolleeSystemID"},{"id":"654672105","type":"subscriberSurrogateKey"},{"id":"654672105","type":"enrolleeSurrogateKey"}]}]}]}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
         }

    	System.runAs(memberAgent){
			list<ACETRelationshipCodes__c> rCodes = new list<ACETRelationshipCodes__c> ();
            rCodes.add(new ACETRelationshipCodes__c (Name = '18',Description__c = 'Self'));
            rCodes.add(new ACETRelationshipCodes__c (Name = '01',Description__c = 'Spouse'));
            rCodes.add(new ACETRelationshipCodes__c (Name = '19',Description__c = 'Child'));
            insert rCodes; 
            Test.startTest();
            
            ACETLGT_COBController Controller  = new ACETLGT_COBController();
            ACETLGT_COBController.getFamilyMembershipResults('654672105', '1270391', '6/1/2019', '60377532400');
            
            Test.stopTest();
            set<string> stringlisttest = new set<string>(); 
            list<string> testlist = new list<string>();
            stringlisttest.add('testsetsstring');
            ACETLGT_MemberDetail memdetail = new ACETLGT_MemberDetail();
            memdetail.CoverageTypeValue ='covtype';
            memdetail.groupNameValue ='kkdert';
            memdetail.CoverageTypeSet = stringlisttest;
            memdetail.groupNameSet=stringlisttest;
            memdetail.effectiveDateValue = system.today();
            memdetail.endDateValue =system.today();
            memdetail.groupNumberValue = '1234';
            memdetail.groupNumberSet =stringlisttest;
            Memdetail.sourceCodeValue ='1jdud';
            Memdetail.sourceCodeSet =stringlisttest;
            Memdetail.searchOnLoad = true;
            Memdetail.isAdvanceSearched =true;
            Memdetail.EID ='eidstring';
            Memdetail.QMSCOIndicator ='ert';
            Memdetail.isServiceError =true;
            Memdetail.FirstName ='fnamestr';
            Memdetail.LastName='lnamestr';
            Memdetail.MemberId ='124rtg';
            Memdetail.SCRId ='1err';
            Memdetail.DOB ='dobstr';
            Memdetail.RelationShip ='RelationShipstr';
            Memdetail.RelationShipCode ='str';
            Memdetail.OriginatorRelationship ='OriginatorRelationship';
            Memdetail.MiddleInitial='ffr';
            Memdetail.Gender ='male';
            MemDetail.age ='23';
            MemDetail.SSN='ssd';
            MemDetail.CPTIN='CPTINstr';
            MemDetail.FullSSN='FullSSNstr';
            MemDetail.SpokenLanguage='SpokenLanguagestr';
            MemDetail.WrittenLanguage='WrittenLanguage';
            MemDetail.Email='Email';
            MemDetail.AsianInitiativeIndicator='AsianInitiativeIndicator';
            MemDetail.MigrationDate='MigrationDate';
            MemDetail.OriginalEffectiveDate='OriginalEffectiveDate';
            MemDetail.DeceasedDate ='DeceasedDate';
            MemDetail.PCPRequired='PCPRequired';
            MemDetail.PCPAssignment='PCPAssignment';
            MemDetail.SitusState='SitusState';
            MemDetail.PolicyNumber='PolicyNumber';
            MemDetail.FundingArragement='FundingArragement';
            MemDetail.MemberStatus='MemberStatus';
            MemDetail.TerminationReason='TerminationReason';
            MemDetail.HoldReason='HoldReason';
            MemDetail.Network='Network';
            MemDetail.gatedPlanIndicator='gatedPlanIndicator';
            MemDetail.EffectiveDate='EffectiveDate';
            MemDetail.EndDate='EndDate';
            MemDetail.Product='Product';
            MemDetail.ProductType='ProductType';
            MemDetail.Suffix='Suffix';
            MemDetail.BundleOptionID='BundleOptionID';
            MemDetail.hsaAvailable='hsaAvailable';
            MemDetail.CoverageLevelCode='CoverageLevelCode';
            MemDetail.benefitAdmin='benefitAdmin';
            MemDetail.benefitAdminPhone='benefitAdminPhone';
            MemDetail.disability='disability';
             MemDetail.GroupSize ='GroupSize';
             MemDetail.responsibilityType='responsibilityType';
             MemDetail.continuationType='continuationType';
             MemDetail.enrollmentMethod='enrollmentMethod';
             MemDetail.coverageGroupContractOptionId='coverageGroupContractOptionId';
             MemDetail.coverageGroupContractOptionEffDate='coverageGroupContractOptionEffDate';
             MemDetail.coverageGroupContractOptionStatus='coverageGroupContractOptionStatus';
             MemDetail.coverageGroupContractOptionFilterStatus='coverageGroupContractOptionFilterStatus';
             MemDetail.hasPopulation=true;
             MemDetail.cobraAdministrativeIndicator='cobraAdministrativeIndicator';
             MemDetail.onshoreRestriction='onshoreRestriction';
             MemDetail.SurrogateKey ='SurrogateKey';
             MemDetail.SurrogateKeys.add('SurrogateKeys');
             MemDetail.EnrolleeSurrogateKey='EnrolleeSurrogateKey';
             MemDetail.onshore='onshore';
             MemDetail.MiddleName='MiddleName';
             MemDetail.EligibilityStatus='EligibilityStatus';
             MemDetail.TerminationDate=System.today();
             MemDetail.DateOfEmployment=System.today();
             MemDetail.EmploymentStatus ='EmploymentStatus';
             MemDetail.CoverageLevel='CoverageLevel';
             MemDetail.GroupName='GroupName';
             MemDetail.EmploymentStartDate='EmploymentStartDate';
             MemDetail.ClaimAddressline1='ClaimAddressline1';
             MemDetail.ClaimAddressline2='ClaimAddressline2';
             MemDetail.ClaimAddresscity='ClaimAddresscity';
             MemDetail.ClaimAddressstate='ClaimAddressstate';
             MemDetail.ClaimAddresspostalCode='ClaimAddresspostalCode';
             MemDetail.ClaimAddresscountyCode='ClaimAddresscountyCode';
            
            
            
            
            
            
            
        }
        
    }
}