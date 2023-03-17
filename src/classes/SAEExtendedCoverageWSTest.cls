@isTest
public class SAEExtendedCoverageWSTest {

    @testSetup static void setup() {
        ISL_Webservice_Config__c configObj = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_POLICYSEARCH_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_POLICYSEARCH_SERVICENAME,
            SAEConstants.SAE_POLICYSEARCH_VALUE
        );
        System.assertNotEquals(configObj, null);
        configObj = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_MEMBERPROVIDER_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            !SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_MEMBERPROVIDER_SERVICENAME,
            SAEConstants.SAE_MEMBERPROVIDER_VALUE
        );
        System.assertNotEquals(configObj, null);

        TestDataFactory.createInteraction();
		TestDataFactory.createContact();

        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkExtendedCoverage');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
    }

    static testMethod void test_getPolicyData() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        SAEPolicyDetailsController.SearchResultWrapper responseData = SAEPolicyDetailsController.getPolicyData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        //System.assertEquals(responseData.resultWrapper.policyRes.productType, SAEConstants.SAE_POLICYDETAILS_TYPE);
        //System.assertEquals(responseData.resultWrapper.policyRes.groupNumber, SAEConstants.SAE_POLICYDETAILS_GROUPNUMBER);
        Test.stopTest();
    }

    static testMethod void test_getCob() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        SAECOBController.CobSearchResultWrapper responseData = SAECOBController.getCob(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        /*System.assertEquals(responseData.resultWrapper.cob.cobLastUpdate, SAEConstants.SAE_COB_LASTUPDATED_DATE);
        System.assertEquals(responseData.resultWrapper.cob.cobUpdateMessage, SAEConstants.SAE_COB_COMMENTS);
        System.assertEquals(responseData.resultWrapper.cob.cobType, null);
        System.assertEquals(responseData.resultWrapper.cob.coverageStartDate, null);
        System.assertEquals(responseData.resultWrapper.cob.coverageEndDate, null);*/
        Test.stopTest();
    }

    static testMethod void test_pcpHistory() {
        
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_PCPHistory';
        endpointSetting.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0';
        Insert endpointSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEPCPHistoryWebServiceMock());
        SAE_PCPHistoryWebService.getPCPHistoryWS(SAEConstants.SAE_PCP_HISTORY_TRANSCATIONID);
        SAEPCPHistoryJSON2Apex json2apex = SAEPCPHistoryJSON2Apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q"}');
        //json2apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q');
        //System.assertNotEquals(resp, null);
        Test.stopTest();
    }
    
    static testMethod void test_pcpHistory400() {
        
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_PCPHistory';
        endpointSetting.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0';
        Insert endpointSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEPCPHistoryWebServiceMock400());
        SAE_PCPHistoryWebService.getPCPHistoryWS(SAEConstants.SAE_PCP_HISTORY_TRANSCATIONID);
        SAEPCPHistoryJSON2Apex json2apex = SAEPCPHistoryJSON2Apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q"}');
        //json2apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q');
       //  System.assertNotEquals(resp, null);
        Test.stopTest();
    }
    
    static testMethod void test_pcpHistory404() {
        
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_PCPHistory';
        endpointSetting.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0';
        Insert endpointSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEPCPHistoryWebServiceMock404());
        SAE_PCPHistoryWebService.getPCPHistoryWS(SAEConstants.SAE_PCP_HISTORY_TRANSCATIONID);
        SAEPCPHistoryJSON2Apex json2apex = SAEPCPHistoryJSON2Apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q"}');
        //json2apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q');
       //  System.assertNotEquals(resp, null);
        Test.stopTest();
    }
    
    static testMethod void test_pcpHistory500() {
        
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_PCPHistory';
        endpointSetting.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0';
        Insert endpointSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEPCPHistoryWebServiceMock500());
        SAE_PCPHistoryWebService.getPCPHistoryWS(SAEConstants.SAE_PCP_HISTORY_TRANSCATIONID);
        SAEPCPHistoryJSON2Apex json2apex = SAEPCPHistoryJSON2Apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q"}');
        //json2apex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01&q');
       //  System.assertNotEquals(resp, null);
        Test.stopTest();
    }
    
    static testMethod void test_getHouseHoldData() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());  
        SAEHouseHoldController.SearchResultWrapper responseData = SAEHouseHoldController.getHouseHoldMembers(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        System.assertEquals(responseData.resultWrapper.houseHoldList[0].firstName, SAEConstants.SAE_HOUSEHOLD_DETAIL_MAINMEMBER_FIRSTNAME);
        System.assertEquals(responseData.resultWrapper.houseHoldList[0].lastName, SAEConstants.SAE_HOUSEHOLD_DETAIL_MAINMEMBER_LASTNAME);
        Test.stopTest();
    }

    static testMethod void test_MemberProvider_getCobData() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());  
        SAECOBController.CobSearchResultWrapper responseData = SAEMemberProviderDetail.getCobData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        /*System.assertEquals(responseData.resultWrapper.cob.cobLastUpdate, SAEConstants.SAE_COB_LASTUPDATED_DATE);
        System.assertEquals(responseData.resultWrapper.cob.cobUpdateMessage, SAEConstants.SAE_COB_COMMENTS);
        System.assertEquals(responseData.resultWrapper.cob.cobType, null);
        System.assertEquals(responseData.resultWrapper.cob.coverageStartDate, null);
        System.assertEquals(responseData.resultWrapper.cob.coverageEndDate, null);*/
        Test.stopTest();
    }

    static testMethod void test_MemberProvider_getHouseHoldData() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());  
        SAEHouseHoldController.SearchResultWrapper responseData = SAEMemberProviderDetail.getHouseHoldData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        
        System.assertEquals(responseData.resultWrapper.houseHoldList[0].firstName, SAEConstants.SAE_HOUSEHOLD_DETAIL_MAINMEMBER_FIRSTNAME);
        System.assertEquals(responseData.resultWrapper.houseHoldList[0].lastName, SAEConstants.SAE_HOUSEHOLD_DETAIL_MAINMEMBER_LASTNAME);
        Test.stopTest();
    }
	


    // static testMethod void test_formatDate() {
    //     Test.startTest();
    //     String strDate = new SAEMemberProviderDetail().formatDate(SAEConstants.SAE_MEMBERPROVIDER_DOB);
    //     System.assertNotEquals(strDate, null);
    //     Test.stopTest();
    // }

    // This method stand for just to cover wrapper attributes purposefully since there is data mapping it is not covering with existing controller
    // This needs to be remove once exact controller written and mapped
    static testMethod void SAEPolicyDetailsResult_Wrapepr() {
        Test.startTest();
        SAEPolicyDetailsResult polDetailCls = new SAEPolicyDetailsResult();
        polDetailCls.policyRes = new SAEPolicyDetailsResult.policyResults();
        polDetailCls.policyRes.sourceCode = 'sourceCode';
        polDetailCls.policyRes.timelyFilling = 'timelyFilling';
        polDetailCls.policyRes.MaintenanceDate = 'MaintenanceDate';
        polDetailCls.policyRes.payerId = 'payerId';
        polDetailCls.policyRes.claimsMailingAddress = 'claimsMailingAddress';
        polDetailCls.policyRes.fundingArrangement = 'fundingArrangement';
        polDetailCls.policyRes.sharedSavings = 'sharedSavings';
        polDetailCls.policyRes.regionCode = 'regionCode';
        polDetailCls.policyRes.groupName = 'groupName';
		
		List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 1];
        Contact conRec = [SELECT Id FROM Contact LIMIT 1];
        String caseString = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"noMemberToSearch":false,"mnf":"","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+lstInteractions[0].Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        String caseString1 = '{"providerNotFound":true,"noProviderToSearch":false,"isOtherSearch":false,"noMemberToSearch":false,"mnf":"mnf","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+lstInteractions[0].Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        String caseString2 = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":true,"noMemberToSearch":false,"mnf":"mnf","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+lstInteractions[0].Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        String caseString3 = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"noMemberToSearch":true,"mnf":"mnf","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+lstInteractions[0].Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        
        SAEMemberProviderDetail.findMembers('956876492', '12/12/1989', 'Test First', 'Test Last', '098099', '', '', 'test Provider', 'test Provider Last', '45345345', '');
        SAEMemberProviderDetail.findMembers('956876492', '', '', '', '', '', '', 'test Provider', 'test Provider Last', '45345345', '');
        SAEMemberProviderDetail.getHasUHGAccess();
        SAEMemberProviderDetail.postCaseWrapper(caseString);
        SAEMemberProviderDetail.postCaseWrapper(caseString1);
        SAEMemberProviderDetail.postCaseWrapper(caseString2);
        SAEMemberProviderDetail.postCaseWrapper(caseString3);
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', lstInteractions[0].Id, '', false, false);
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', lstInteractions[0].Id, 'mnf', false, false);
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', lstInteractions[0].Id, 'mnf', true, false);
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', lstInteractions[0].Id, '', true, false);
        SAEMemberProviderDetail.getMemberRelatedCases('956876492', true);
        SAEMemberProviderDetail.getMemberRelatedCases('956876492', false);
        Test.stopTest();
    }
    
    static testMethod void SAEPolicyDetailsJsonToApex(){
        SAEPolicyDetailsJsonToApex Obj = SAEPolicyDetailsJsonToApex.parse('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageLevel":"4","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01","genderCode":"F","governmentProgramCode":"","groupNumber":"N/A","groupPanelNumber":"N/A","individualRelationshipCode":"EE","legacyPanelNumber":"","legalEntityCode":"20020","lineOfBusiness":"N/A","marketSite":"0013478","marketType":"50","mbi":"","medicareIndicator":null,"nhpIndicator":"","obligorID":"01","pcid":"00003","platform":"UNET","planFeatureCode":null,"planVariation":"0031","policyNumber":"0706577","productCode":"Q","productID":"","productType":"POS","postalAddress":{"city":"SCHERERVILLE","country":"US","state":"IN","street1":"1018 WILLOWBROOK DRIVE","street2":"","zip":"46375","zip4":""},"referralRequired":"NO","relationshipCode":"000","reportingCode":"0031","serviceBenefitDescription":null,"serviceBenefitNotes":null,"serviceBenefitDetails":[],"sharedArrangement":"00","sourceCode":"CS","sourceID":"07065770030384576502003","state":"IN","stateOfIssueCode":"IL","subscriberID":"00303845765","tciTableNumber":"017874","xrefId":"9782567","xrefIdPartitionNumber":"167","memberInfo":{"relationship":"Subscriber","firstName":"AMANDA","lastName":"ADAM","dob":"1977-06-08","memberID":"956876492","members":[{"relationship":"Spouse","firstName":"PETER","lastName":"ADAM","dob":"1976-01-30","memberID":"956876492"},{"relationship":"Child","firstName":"LUKE","lastName":"ADAM","dob":"2007-05-01","memberID":"956876492"},{"relationship":"Child","firstName":"LOGAN","lastName":"ADAM","dob":"2008-12-19","memberID":"956876492"},{"relationship":"Child","firstName":"LEIA","lastName":"ADAM","dob":"2013-11-12","memberID":"956876492"}],"dos":"2019-01-01"},"primaryCareProvider":{"pcpMessage":"No Primary Care Physician on file for this plan.","pcpFirstName":"N/A","pcpMiddleName":"N/A","pcpLastName":"N/A","providerAddress":{"addressLine1":"N/A","addressLine2":"N/A","city":"N/A","state":"N/A","zip":"N/A"},"pcpPhoneNumber":"N/A","providerNpi":"N/A","taxId":"N/A","pcpSpeciality":"N/A","pcpStartDate":"N/A","pcpEndDate":"N/A","acoNetworkDescription":"N/A","acoNetworkId":"N/A","affiliateHospitalName":"N/A","providerGroupName":"N/A","pcpFound":false},"additionalPlanDetails":{"cdhp":"N/A","cobUpdateInformation":{"cobUpdateMessage":"Member COB update overdue.","cobLastUpdate":"2018-03-14"},"fundingType":"Self-Funded","hsa":"N/A","insuranceTypeCode":null,"primaryPayer":"Primary","virtualVisits":"Virtual Visit benefits exist for this plan","umDelegationFlag":null},"payerInfo":null,"additionalCoverage":[{"phoneNumber":"","payerName":"","cobMemberId":"","cobPolicyNumber":"","policyEffectiveStartDate":"","policyEffectiveEndDate":"","notes":"N/A","description":"N/A","cobPolicyGroupNumber":"","coverageType":"","cobPolicyHolderName":"","street1":"","city":"","state":"","zip":"","primaryGroupIndicator":""}]}');
        Test.startTest();
        System.assertNotEquals(Obj, null);
        Test.stopTest();
    }
    
    static testMethod void SAEORSSlectIssueTest(){
        /* ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_ORSSelectIssue';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = '123';
        insert accessToken; */
        
        List<ISL_Webservice_Config__c> wsConfigs = new List<ISL_Webservice_Config__c>();
        wsConfigs.add(new ISL_Webservice_Config__c(Name='SNIAPIAccessToken', Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='dev_ORSSelectIssue', Value__c='https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-si/issues/v1/search'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken', Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHeaderAccept', Value__c='application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHttpHeaderActor', Value__c='ACET'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHttpHeaderContentType', Value__c='application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHttpMethod', Value__c='EAIPLoginFlowHttpMethod'));
        Insert wsConfigs;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSIssueMock());
        //SAEMemberProviderDetail.ORSSlectIssue('lastName', '1234567890', 'AL', 'callerFirstName', 'callerLastName', true, '111111111', true);
        Test.stopTest();
    }

     
    // Thanish - 8th October 2019
    @isTest
    static void testFormatDate() {
        SAEMemberProviderDetail mpd = new SAEMemberProviderDetail();
        String result = mpd.formatDate('2019-10-08');
        System.assertEquals('10-08-2019', result);
    }
    
    @isTest
    static void testGetOptumExlusions() {
        List<UHG_Restricted_Plans__mdt> mapOptumExlusions = [SELECT DeveloperName,MasterLabel FROM UHG_Restricted_Plans__mdt];
        System.assertEquals(mapOptumExlusions, SAEMemberProviderDetail.getOptumExlusions());
    }
   
    @isTest
    static void testPostCaseWrapper() { 
        Test.startTest();
        
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 1];
        String s = '{' +
            ' "Status" : "", ' +
            ' "Interaction" : "' + lstInteractions[0].Id + '", ' +
            ' "OriginatorName" : "", ' +
            ' "OriginatorRelationship" : "", ' +
            ' "OriginatorType" : "", ' +
            ' "OriginatorPhone" : "", ' +
            ' "OriginatorEmail" : "", ' +
            ' "OriginatorContactName" : "", ' +
            ' "SubjectName" : "", ' +
            ' "SubjectType" : "", ' +
            ' "SubjectDOB" : "", ' +
            ' "SubjectId" : "", ' +
            ' "SubjectGroupId" : "", ' +
            ' "MisdirectReason" : "", ' +
            ' "AddInfoTopic" : "", ' +
            ' "AddInfoOrginType" : "", ' +
            ' "AddInfoOrginSubType" : "", ' +
            ' "CommentPublic" : "", ' +
            ' "CommentDesc" : "", ' +
            ' "PolicyCount" : 1, ' +
            ' "CaseCreationFrom" : "" '
            + '}';
		//String result = SAEMemberProviderDetail.postCaseWrapper(s);
        //System.assertNotEquals(null, result);
        
        Test.stopTest();
    } 
    
    // @isTest static void TestGetCoverageLevel()
    // {
    //     Test.startTest();
    //     Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
    //     SAEExtendedCoverageWS.getCoverageLevel(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
    //     Test.stopTest();
    // }
    
    @isTest
    static void testfetchdata() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = true;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = false;
		SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', null, '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDLastNameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDFirstNameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'NameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDName', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '101987516','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDName', '');
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', null, '', providerDetails);
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDLastNameDateOfBirth', '', providerDetails);
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDFirstNameDateOfBirth', '', providerDetails);
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'NameDateOfBirth', '', providerDetails);
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDDateOfBirth', '', providerDetails);
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDName', '', providerDetails);
        SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '101987516','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDName', '', providerDetails);
        //System.assertNotEquals(null, result);
        
        Test.stopTest();
    } 
    
    @isTest
    static void testContinuationMethod() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        try
        {
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(SAETestDataFactory.getStaticResourceResponse('SAEEligibilityResponseMockData'));
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);

        }
        catch(exception e)
        {

        }

    }
    
    @isTest
    static void testContinuationMethod1() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        try
        {
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        //String strJson = SAETestDataFactory.getStaticResourceResponse('SAEEligibilityResponseMockData');
        //response.setBody('"faultCode":"AAA:58","message":"Error"');
        response.setBody('{"memberPolicies":[{"patientInfo":[{"addressLine1":"1018 WILLOWBROOK DRIVE","addressLine2":"","city":"SCHERERVILLE","dateOfBirth":"1977-06-08","firstName":"AMANDA","gender":"F","lastName":"ADAM","middleName":"K","relationship":"subscriber","searched":"true","state":"IN","zip":"46375","patientKey":"AgB7BZf%2FY0ry9KF2a8ajntSE9Fn9yuQhCT2ypKooRQIjzi8sF1nsBHa0fKruV6FfqLUW1lKNsc1N8VREATHkoZTwZglUokmhtLtakfUBdPYhHDYsVE1V5HOUZ3ianoioTvdjOqv%2FydOsN8bplQA34TzuFbTaA0jU28kYzuruFgz4bf2wy2Pst8h80M78l88st3Zq3dV4M5vyFrXMhi9gG4Pan%2B0wWZZbpWzpWuVhwY3wboTneR5pmWenp%2B5XTiCvQnvp0r6MY5z4%2FR1xSifNHmBuKKPcSJvVUYWDZtsW4yuvAjfvfBiXg8qQXeHAcsPYGwGJ0mO4Z4M7C9E8NqV2BGHE57YJdWXU8pV5pXvlBDsoU2p1P9XBnJ%2FblIajsqPnBhyhq5eKgiYwws28DdMl%2F3%2FIjH%2BNi1Hzqvh0EM1%2B3XanCJloOqKavTKCbEmIwOg8fcT1h1EfcAaU8Yov6pyYqqNi7feZNNBP%2BQ%2BQrYTmuAIMS1oQBEZdsNoEDTv1Nr4Dib9wPLRJAuLTsBbfZnd0Tl2we5%2FCX6sPZ%2BrA9QuhHNXDWXknXgmNok%2Fm6C41ktkEJAQcC1ppmuow7SU3WzaL16uA1a58xoyRar3FFpKaE%2Bpa6XKfGfAXNWmGX8MQfVEbQsLYjjGg9ctwEfgZFQMF0Bn0up093w8Mk9YtCi%2FcJm29f01m1cS6ynY%2B8x%2BCvPMM7FlSpSapxJ7ykCHkfpo01Ind6g8liQHQJJmNipid8WnUdvZFmtJA6xxVSWCYCzpo%2Fs6G0Rd%2B6EJXjngnVq%2BmXFISOF2q5F%2Fr7xp8u8wrWZ1ff54SowOLHYRKGp%2BmW5ftM5mnwxVPsLx1DEUWFNYWZUHM6zUNfJAY9Ou3e3bbxKveAQ%3D%3D","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"3500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"3500.0","metYtdAmount":"0.0"},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"6000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"6000.0","metYtdAmount":"0.0"},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"7000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"7000.0","metYtdAmount":"0.0"},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"14000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"14000.0","metYtdAmount":"0.0"},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"Y","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 30555","addressLine2":"","city":"SALT LAKE CITY","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"706577","insuranceType":"Commercial","insuranceTypeCode":"C1","paidThroughDate":null,"memberId":"956876492","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"UT","zip":"84130-0555","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"956876492","planDates":{"startDate":"2020-01-01","endDate":"2020-12-31"},"policyStatus":"Active Policy","searchedDates":{"searchStartDate":"2015-02-25","searchEndDate":"2020-12-31"},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":true,"id":"1","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"uk5gepl1-BGe-7Z7IJ7o0fj-TG89hft8j6d4dxa3s2KwIvOdIlpzIQdgluSG2kuaIcvN9r5lM3al3sJ_9rAGFSGZlo_LP1vL4tguJUuV6LHfTAzBloBGz9Wr4M38sDCtPfiE0Y9n0pGqH0pfzukX29tx3N5pEm4I0vF5n_G46X8710798"},{"patientInfo":[{"addressLine1":"1018 WILLOWBROOK DRIVE","addressLine2":"","city":"SCHERERVILLE","dateOfBirth":"1977-06-08","firstName":"AMANDA","gender":"F","lastName":"ADAM","middleName":"K","relationship":"subscriber","searched":"true","state":"IN","zip":"46375","patientKey":"AgB7BZf%2FY0ry9KF2a8ajntSE9Fn9yuQhCT2ypKooRQIjzi8sF1nsBHa0fKruV6FfqLUW1lKNsc1N8VREATHkoZTwZglUokmhtLtakfUBdPYhHDYsVE1V5HOUZ3ianoioTvdjOqv%2FydOsN8bplQA34TzuFbTaA0jU28kYzuruFgz4bf2wy2Pst8h80M78l88st3Zq3dV4M5vyFrXMhi9gG4Pan%2B0wWZZbpWzpWuVhwY3wboTneR5pmWenp%2B5XTiCvQnvp0r6MY5z4%2FR1xSifNHmBuKKPcSJvVUYWDZtsW4yuvAjfvfBiXg8qQXeHAcsPYGwGJ0mO4Z4M7C9E8NqV2BGHE57YJdWXU8pV5pXvlBDsoU2p1P9XBnJ%2FblIajsqPnBhyhq5eKgiYwws28DdMl%2F3%2FIjH%2BNi1Hzqvh0EM1%2B3XanCJloOqKavTKCbEmIwOg8fcT1h1EfcAaU8Yov6pyYqqNi7feZNNBP%2BQ%2BQrYTmuAIMS1oQBEZdsNoEDTv1Nr4Dib9wPLRJAuLTsBbfZnd0Tl2we5%2FCX6sPZ%2BrA9QuhHNXDWXknXgmNok%2Fm6C41ktkEJAQcC1ppmuow7SU3WzaL16uA1a58xoyRar3FFpKaE%2Bpa6XKfGfAXNWmGX8MQfVEbQsLYjjGg9ctwEfgZFQMF0Bn0up093w8Mk9YtCi%2FcJm29f01m1cS6ynY%2B8x%2BCvPMM7FlSpSapxJ7ykCHkfpo01Ind6g8liQHQJJmNipid8WnUdvZFmtJA6xxVSWCYCzpo%2Fs6G0Rd%2B6EJXjngnVq%2BmXFISOF2q5F%2Fr7xp8u8wrWZ1ff54SowOLHYRKGp%2BmW5ftM5mnwxVPsLx1DEUWFNYWZUHM6zUNfJAY9Ou3e3bbxKveAQ%3D%3D","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"600.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1800.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"3000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"3000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"6000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"6000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"12000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 30555","addressLine2":"","city":"SALT LAKE CITY","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"706577","insuranceType":"Commercial","insuranceTypeCode":"C1","paidThroughDate":null,"memberId":"956876492","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"UT","zip":"84130-0555","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"956876492","planDates":{"startDate":"2019-01-01","endDate":"2019-12-31"},"policyStatus":"Past Policy","searchedDates":{"searchStartDate":"2015-02-25","searchEndDate":"2020-12-31"},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":true,"id":"5","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"uk5gepl1-BGe-7Z7IJ7o0fj-TG89hft8j6d4dxa3s2K_KDOxWlipGU9XVqEj4vjer2FHSsyVJb5TEzhlO4mBDMBeiEA7YT5Fg9TRJbZBiTR8npgexwGvPw7OPTOJfdTL3qAXH-Q8pQRULLQewCHALE9vmqjF4HYWJGNR3OV4ngY345073"},{"patientInfo":[{"addressLine1":"1018 WILLOWBROOK DRIVE","addressLine2":"","city":"SCHERERVILLE","dateOfBirth":"1977-06-08","firstName":"AMANDA","gender":"F","lastName":"ADAM","middleName":"K","relationship":"subscriber","searched":"true","state":"IN","zip":"46375","patientKey":"AgB7BZf%2FY0ry9KF2a8ajntSE9Fn9yuQhCT2ypKooRQIjzi8sF1nsBHa0fKruV6FfqLUW1lKNsc1N8VREATHkoZTwZglUokmhtLtakfUBdPYhHDYsVE1V5HOUZ3ianoioTvdjOqv%2FydOsN8bplQA34TzuFbTaA0jU28kYzuruFgz4bf2wy2Pst8h80M78l88st3Zq3dV4M5vyFrXMhi9gG4Pan%2B0wWZZbpWzpWuVhwY3wboTneR5pmWenp%2B5XTiCvQnvp0r6MY5z4%2FR1xSifNHmBuKKPcSJvVUYWDZtsW4yuvAjfvfBiXg8qQXeHAcsPYGwGJ0mO4Z4M7C9E8NqV2BGHE57YJdWXU8pV5pXvlBDsoU2p1P9XBnJ%2FblIajsqPnBhyhq5eKgiYwws28DdMl%2F3%2FIjH%2BNi1Hzqvh0EM1%2B3XanCJloOqKavTKCbEmIwOg8fcT1h1EfcAaU8Yov6pyYqqNi7feZNNBP%2BQ%2BQrYTmuAIMS1oQBEZdsNoEDTv1Nr4Dib9wPLRJAuLTsBbfZnd0Tl2we5%2FCX6sPZ%2BrA9QuhHNXDWXknXgmNok%2Fm6C41ktkEJAQcC1ppmuow7SU3WzaL16uA1a58xoyRar3FFpKaE%2Bpa6XKfGfAXNWmGX8MQfVEbQsLYjjGg9ctwEfgZFQMF0Bn0up093w8Mk9YtCi%2FcJm29f01m1cS6ynY%2B8x%2BCvPMM7FlSpSapxJ7ykCHkfpo01Ind6g8liQHQJJmNipid8WnUdvZFmtJA6xxVSWCYCzpo%2Fs6G0Rd%2B6EJXjngnVq%2BmXFISOF2q5F%2Fr7xp8u8wrWZ1ff54SowOLHYRKGp%2BmW5ftM5mnwxVPsLx1DEUWFNYWZUHM6zUNfJAY9Ou3e3bbxKveAQ%3D%3D","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"3000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"3000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"6000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"6000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"12000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 30555","addressLine2":"","city":"SALT LAKE CITY","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"706577","insuranceType":"Commercial","insuranceTypeCode":"C1","paidThroughDate":null,"memberId":"956876492","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"UT","zip":"84130-0555","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"956876492","planDates":{"startDate":"2018-01-01","endDate":"2018-12-31"},"policyStatus":"","searchedDates":{"searchStartDate":"2015-02-25","searchEndDate":"2020-12-31"},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":true,"id":"4","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"uk5gepl1-BGe-7Z7IJ7o0fj-TG89hft8j6d4dxa3s2JRNTwSBx1v-Oa-pmq5PUhV5WHeMMV7O1wxe9ncZtvgtS25byWRL11GUPUJYvE0kss3GzYGHZxeRQD2aK_HGzykDNOGULGeSSn-Y3MPBz_f6ghEJmBbNwA2svnglbXqlVA961931"},{"patientInfo":[{"addressLine1":"1018 WILLOWBROOK DRIVE","addressLine2":"","city":"SCHERERVILLE","dateOfBirth":"1977-06-08","firstName":"AMANDA","gender":"F","lastName":"ADAM","middleName":"K","relationship":"subscriber","searched":"true","state":"IN","zip":"46375","patientKey":"AgB7BZf%2FY0ry9KF2a8ajntSE9Fn9yuQhCT2ypKooRQIjzi8sF1nsBHa0fKruV6FfqLUW1lKNsc1N8VREATHkoZTwZglUokmhtLtakfUBdPYhHDYsVE1V5HOUZ3ianoioTvdjOqv%2FydOsN8bplQA34TzuFbTaA0jU28kYzuruFgz4bf2wy2Pst8h80M78l88st3Zq3dV4M5vyFrXMhi9gG4Pan%2B0wWZZbpWzpWuVhwY3wboTneR5pmWenp%2B5XTiCvQnvp0r6MY5z4%2FR1xSifNHmBuKKPcSJvVUYWDZtsW4yuvAjfvfBiXg8qQXeHAcsPYGwGJ0mO4Z4M7C9E8NqV2BGHE57YJdWXU8pV5pXvlBDsoU2p1P9XBnJ%2FblIajsqPnBhyhq5eKgiYwws28DdMl%2F3%2FIjH%2BNi1Hzqvh0EM1%2B3XanCJloOqKavTKCbEmIwOg8fcT1h1EfcAaU8Yov6pyYqqNi7feZNNBP%2BQ%2BQrYTmuAIMS1oQBEZdsNoEDTv1Nr4Dib9wPLRJAuLTsBbfZnd0Tl2we5%2FCX6sPZ%2BrA9QuhHNXDWXknXgmNok%2Fm6C41ktkEJAQcC1ppmuow7SU3WzaL16uA1a58xoyRar3FFpKaE%2Bpa6XKfGfAXNWmGX8MQfVEbQsLYjjGg9ctwEfgZFQMF0Bn0up093w8Mk9YtCi%2FcJm29f01m1cS6ynY%2B8x%2BCvPMM7FlSpSapxJ7ykCHkfpo01Ind6g8liQHQJJmNipid8WnUdvZFmtJA6xxVSWCYCzpo%2Fs6G0Rd%2B6EJXjngnVq%2BmXFISOF2q5F%2Fr7xp8u8wrWZ1ff54SowOLHYRKGp%2BmW5ftM5mnwxVPsLx1DEUWFNYWZUHM6zUNfJAY9Ou3e3bbxKveAQ%3D%3D","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"450.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"900.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1350.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2700.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2750.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"11000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Member plan does not have a copay maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 30555","addressLine2":"","city":"SALT LAKE CITY","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"706577","insuranceType":"Commercial","insuranceTypeCode":"C1","paidThroughDate":null,"memberId":"956876492","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"UT","zip":"84130-0555","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"956876492","planDates":{"startDate":"2017-01-01","endDate":"2017-12-31"},"policyStatus":"Past Policy","searchedDates":{"searchStartDate":"2015-02-25","searchEndDate":"2020-12-31"},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":true,"id":"3","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"uk5gepl1-BGe-7Z7IJ7o0fj-TG89hft8j6d4dxa3s2Lc24Gc5cS_paXwPhib52W5Uy5nFW2eBG-MnwgsylCVNNVZim16Kpp8WbvFwKNOKMTTU8PxT1wyokqVlHvU0FqWI5Iseic_v8mFgfaboZElfoR6TnVEhFm5frGsg_Wv0U4131929"},{"patientInfo":[{"addressLine1":"1018 WILLOWBROOK DRIVE","addressLine2":"","city":"SCHERERVILLE","dateOfBirth":"1977-06-08","firstName":"AMANDA","gender":"F","lastName":"ADAM","middleName":"K","relationship":"subscriber","searched":"true","state":"IN","zip":"46375","patientKey":"AgB7BZf%2FY0ry9KF2a8ajntSE9Fn9yuQhCT2ypKooRQIjzi8sF1nsBHa0fKruV6FfqLUW1lKNsc1N8VREATHkoZTwZglUokmhtLtakfUBdPYhHDYsVE1V5HOUZ3ianoioTvdjOqv%2FydOsN8bplQA34TzuFbTaA0jU28kYzuruFgz4bf2wy2Pst8h80M78l88st3Zq3dV4M5vyFrXMhi9gG4Pan%2B0wWZZbpWzpWuVhwY3wboTneR5pmWenp%2B5XTiCvQnvp0r6MY5z4%2FR1xSifNHmBuKKPcSJvVUYWDZtsW4yuvAjfvfBiXg8qQXeHAcsPYGwGJ0mO4Z4M7C9E8NqV2BGHE57YJdWXU8pV5pXvlBDsoU2p1P9XBnJ%2FblIajsqPnBhyhq5eKgiYwws28DdMl%2F3%2FIjH%2BNi1Hzqvh0EM1%2B3XanCJloOqKavTKCbEmIwOg8fcT1h1EfcAaU8Yov6pyYqqNi7feZNNBP%2BQ%2BQrYTmuAIMS1oQBEZdsNoEDTv1Nr4Dib9wPLRJAuLTsBbfZnd0Tl2we5%2FCX6sPZ%2BrA9QuhHNXDWXknXgmNok%2Fm6C41ktkEJAQcC1ppmuow7SU3WzaL16uA1a58xoyRar3FFpKaE%2Bpa6XKfGfAXNWmGX8MQfVEbQsLYjjGg9ctwEfgZFQMF0Bn0up093w8Mk9YtCi%2FcJm29f01m1cS6ynY%2B8x%2BCvPMM7FlSpSapxJ7ykCHkfpo01Ind6g8liQHQJJmNipid8WnUdvZFmtJA6xxVSWCYCzpo%2Fs6G0Rd%2B6EJXjngnVq%2BmXFISOF2q5F%2Fr7xp8u8wrWZ1ff54SowOLHYRKGp%2BmW5ftM5mnwxVPsLx1DEUWFNYWZUHM6zUNfJAY9Ou3e3bbxKveAQ%3D%3D","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"450.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"900.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1350.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2700.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2750.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"11000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 30555","addressLine2":"","city":"SALT LAKE CITY","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"706577","insuranceType":"Commercial","insuranceTypeCode":"C1","paidThroughDate":null,"memberId":"956876492","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"UT","zip":"84130-0555","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"956876492","planDates":{"startDate":"2016-01-01","endDate":"2016-12-31"},"policyStatus":"Past Policy","searchedDates":{"searchStartDate":"2015-02-25","searchEndDate":"2020-12-31"},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":true,"id":"2","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"uk5gepl1-BGe-7Z7IJ7o0fj-TG89hft8j6d4dxa3s2Ja-0tipNgsXFputCzFYv2u50zuVi6-IrCf_QTzlSG3_IGqeqD02TK7jxWdqNNaaCIS3eR2p6IkJdSiA_JyhH5gLFLMjkwEIHZ_r97ETdqOTMQyWXcIcThsczB8jDQZgZI800949"},{"patientInfo":[{"addressLine1":"1018 WILLOWBROOK DRIVE","addressLine2":"","city":"SCHERERVILLE","dateOfBirth":"1977-06-08","firstName":"AMANDA","gender":"F","lastName":"ADAM","middleName":"K","relationship":"subscriber","searched":"true","state":"IN","zip":"46375","patientKey":"AgB7BZf%2FY0ry9KF2a8ajntSE9Fn9yuQhCT2ypKooRQIjzi8sF1nsBHa0fKruV6FfqLUW1lKNsc1N8VREATHkoZTwZglUokmhtLtakfUBdPYhHDYsVE1V5HOUZ3ianoioTvdjOqv%2FydOsN8bplQA34TzuFbTaA0jU28kYzuruFgz4bf2wy2Pst8h80M78l88st3Zq3dV4M5vyFrXMhi9gG4Pan%2B0wWZZbpWzpWuVhwY3wboTneR5pmWenp%2B5XTiCvQnvp0r6MY5z4%2FR1xSifNHmBuKKPcSJvVUYWDZtsW4yuvAjfvfBiXg8qQXeHAcsPYGwGJ0mO4Z4M7C9E8NqV2BGHE57YJdWXU8pV5pXvlBDsoU2p1P9XBnJ%2FblIajsqPnBhyhq5eKgiYwws28DdMl%2F3%2FIjH%2BNi1Hzqvh0EM1%2B3XanCJloOqKavTKCbEmIwOg8fcT1h1EfcAaU8Yov6pyYqqNi7feZNNBP%2BQ%2BQrYTmuAIMS1oQBEZdsNoEDTv1Nr4Dib9wPLRJAuLTsBbfZnd0Tl2we5%2FCX6sPZ%2BrA9QuhHNXDWXknXgmNok%2Fm6C41ktkEJAQcC1ppmuow7SU3WzaL16uA1a58xoyRar3FFpKaE%2Bpa6XKfGfAXNWmGX8MQfVEbQsLYjjGg9ctwEfgZFQMF0Bn0up093w8Mk9YtCi%2FcJm29f01m1cS6ynY%2B8x%2BCvPMM7FlSpSapxJ7ykCHkfpo01Ind6g8liQHQJJmNipid8WnUdvZFmtJA6xxVSWCYCzpo%2Fs6G0Rd%2B6EJXjngnVq%2BmXFISOF2q5F%2Fr7xp8u8wrWZ1ff54SowOLHYRKGp%2BmW5ftM5mnwxVPsLx1DEUWFNYWZUHM6zUNfJAY9Ou3e3bbxKveAQ%3D%3D","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"400.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"800.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1200.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2400.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2500.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"10000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 30555","addressLine2":"","city":"SALT LAKE CITY","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"706577","insuranceType":"Commercial","insuranceTypeCode":"C1","paidThroughDate":null,"memberId":"956876492","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"UT","zip":"84130-0555","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"956876492","planDates":{"startDate":"2015-01-01","endDate":""},"policyStatus":"Past Policy","searchedDates":{"searchStartDate":"2015-02-25","searchEndDate":"2020-12-31"},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":false,"id":"6","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"uk5gepl1-BGe-7Z7IJ7o0fj-TG89hft8j6d4dxa3s2KlF6jmbkZHkoLqhW7uz71V-x5D2IELL7pyDAmWd17zLhsjXq-nmjEenrfpmafKvFRc1b_1zVhZdvB-xeX-PWzj9u-xO28jbwDc_dJE6Uh0y9F6k8-5NnFpg4O3lP7Dcao864877"}],"requestingProvider":{"providerFirstName":null,"providerMiddleName":null,"providerLastName":"ACET","providerNameID":"9999999","taxIdNumber":"9999999","corporateTaxOwnerID":null,"corporateTaxOwnerName":null,"organizationName":null,"organizationID":null,"facilityName":null,"npi":null},"requestingProviderAddresses":[],"searchQuery":{"memberId":"0","lastName":"ADAM","firstName":"AMANDA","dateOfBirth":"19770608","payerID":"87726","payerName":"0","serviceStart":"20150225","serviceEnd":"20201231","middleName":"0","gender":"0","ssn":"0","city":"0","state":"0","zip":"0","groupNumber":"0","serviceTypeCode":"0","providerLastName":"ACET","providerFirstName":"0","providerNameID":"9999999","corporateTaxOwnerID":"0","corporateTaxOwnerName":"0","organizationName":"0","organizationID":"0","taxIdNumber":"9999999","searchOption":"NameDateOfBirth","payerLabel":"0","npi":"0"}}');
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);
        }catch(exception e)
        {
        }

    }
                         
    @isTest
    static void testContinuation400() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        try
        {
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(400);
        response.setBody('{"faultCode":"AAA:Fault Code","message":"Invalid Trans"}');
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);
        }catch(exception e)
        {

        }

    }
                         
    @isTest
    static void testContinuation404() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        try{
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404);
        response.setBody('{"faultCode":"AAA:Fault Code","message":"Invalid Trans"}');
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);

        }catch(exception e)
        {

        }

    }
    
    @isTest
    static void testContinuation406() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        try
        {
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(406);
        response.setBody('{"faultCode":"ED270IA","message":"Invalid Trans"}');
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);
        } catch(exception e)
        {

        }
    }
	
	@isTest
    static void testContinuation424() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        try
        {
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(424);
        response.setBody('{"faultCode":"AAA:42","message":"Invalid Trans"}');
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);
    }
        catch(exception e)
        {

        }

    }

	@isTest
    static void testContinuation500() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        try
        {
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        response.setBody('{"faultCode":"AAA:Fault Code","message":"Invalid Trans"}');
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);
    }
        catch(exception e)
        {

        }
    }

	@isTest
    static void testContinuation999() {
        try
        {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
		Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(999);
        response.setBody('{"faultCode":"AAA:Fault Code","message":"Invalid Trans"}');
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);

        }
         catch(exception e)
        {

        }

    }
                         
    // US2782863 - Thanish - 12th Aug 2020 - enabled exception testing
    @isTest static void TestGetCoverageLevel_Exception()
    {
        Test.startTest();
        ISL_Webservice_Config__c cs = ISL_Webservice_Config__c.getValues('SAE_PolicySearch');
        delete cs;
        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        SAEExtendedCoverageWS SEWs = new SAEExtendedCoverageWS();
        ACETWSCalloutResult res = SEWs.getPolicyWS(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }

    static testMethod void test_getPolicyData_CO() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock_LocalSC('CO'));  
        SAEPolicyDetailsController.SearchResultWrapper responseData = SAEPolicyDetailsController.getPolicyData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        //System.assertEquals(responseData.resultWrapper.policyRes.productType, SAEConstants.SAE_POLICYDETAILS_TYPE);
        //System.assertEquals(responseData.resultWrapper.policyRes.groupNumber, SAEConstants.SAE_POLICYDETAILS_GROUPNUMBER);
        Test.stopTest();
    }

    static testMethod void test_getPolicyData_PA() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock_LocalSC('PA'));  
        SAEPolicyDetailsController.SearchResultWrapper responseData = SAEPolicyDetailsController.getPolicyData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        //System.assertEquals(responseData.resultWrapper.policyRes.productType, SAEConstants.SAE_POLICYDETAILS_TYPE);
        //System.assertEquals(responseData.resultWrapper.policyRes.groupNumber, SAEConstants.SAE_POLICYDETAILS_GROUPNUMBER);
        Test.stopTest();
    }
    
    static testMethod void test_getPolicyData_AP() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock_LocalSC('AP'));  
        SAEPolicyDetailsController.SearchResultWrapper responseData = SAEPolicyDetailsController.getPolicyData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(responseData, null);
        //System.assertEquals(responseData.resultWrapper.policyRes.productType, SAEConstants.SAE_POLICYDETAILS_TYPE);
        //System.assertEquals(responseData.resultWrapper.policyRes.groupNumber, SAEConstants.SAE_POLICYDETAILS_GROUPNUMBER);
        Test.stopTest();
    }
    // End of Code - Thanish - 8th October 2019
    //Added by ETSBE Team 
    static testMethod void test_MemberProviderDetail() {
        Interaction__c intdata = new Interaction__c();
        intdata.Originator_Type__c='Internal UHG Employee';
        insert intdata;
        intdata = [select id,Originator_Type__c from Interaction__c where id=:  intdata.id ];
        case casedata= new Case();
        casedata.id__c ='001107';
        casedata.subject ='001107';
        
        insert casedata;
        casedata = [SELECT id, Originator_Type__c, CreatedDate,ID__c,ORS_Issue_ID__c,CaseNumber, Status,Relationship__c,Subject_Name__c,TaxID__c,Topic__c,Original_Subtype__c,Opportunity_Category__c,Reason,Surrogate_Key__c FROM CASE where id=: casedata.id];
        SAEMemberProviderDetail.getRelatedETSBECasesHistory('001107','1058476','956876492','AMnda',false,'Member');
        SAEMemberProviderDetail.getRelatedETSBECasesHistory('001107','1058476','956876492','AMnda',true,'Member');
        SAEMemberProviderDetail.getRelatedETSBECasesHistory('','1058476','','',false,'Group');
        SAEMemberProviderDetail.getRelatedETSBECasesHistory('001107','','','',false,'Producer');
        
        ETSBE_GetCases.getCases(new List<Case>{casedata});
        
    }

	// US2646403
    static testMethod void call_RCED_API() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAERCEDAPIWSMock200());
        SAEPolicyDetailsController.RCEDResponseWrap rced200=SAEPolicyDetailsController.call_RCED_API('0011223344', '123456', 'CS');
        System.assertNotEquals(rced200.statusCode, null);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAERCEDAPIWSMockError());
        SAEPolicyDetailsController.RCEDResponseWrap rcedError=SAEPolicyDetailsController.call_RCED_API('0011223344', '123456', 'CS');
        System.assertNotEquals(rcedError.statusCode, null);
        System.assertNotEquals(rcedError.statusCode, 200);
        System.assertNotEquals(rcedError.message, null);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAERCEDAPIWSMockError999());
        SAEPolicyDetailsController.RCEDResponseWrap rced1=SAEPolicyDetailsController.call_RCED_API('0011223344', '123456', 'CS');
        System.assertNotEquals(rced1.message, null);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAERCEDAPIWSMockExce());
        SAEPolicyDetailsController.RCEDResponseWrap rcedExcept=SAEPolicyDetailsController.call_RCED_API('0011223344', '123456', 'CS');
        //System.assertNotEquals(rcedExcept.message, null);
        Test.stopTest();
    }

}