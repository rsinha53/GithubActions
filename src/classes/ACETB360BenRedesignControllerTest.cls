/* Class Name: ACETB360BenRedesignControllerTest
* Author: Manish
* Created Date: 08/04/2021
* Description: Test Class for ACETB360BenefitOveriewRedesignController
*/
@isTest
public class ACETB360BenRedesignControllerTest {
    public static final String groupId = '1008812';
    public static final String benefitBundleOptionId = '11958488';
    public static final String benefitDateSearch = '2021-01-01';
    public static final Boolean isBenefitAvailable = true;
    public static final Integer statusCode200 = 200;
    public static final String status200 = 'OK';
    public static final Integer statusCode400 = 400;
    public static final String status400 = 'Bad Request';
    public static final Integer statusCode404 = 404;
	public static final String status404 = 'Not Found';
    public static final Integer statusCode500 = 500;
    public static final String status500 = 'Internal Server Error';
    public static final Integer statusCode504 = 504;
    public static final String status504 = 'Time Out';
    
    public static final String benAvailableRes1 = '{"result":{"isAvailable": true}}';
    public static final String benAvailableRes2 = '{"result":{"isAvailable": false}}';
    public static final String b360BadResponse = '{"applicationErrors":[{"applicationErrorCode":4000,"applicationErrorMessage":"Missing mandatory parameters : benefitPlanID"}]}';
    public static final String benCatResponse = '{"result":[{"categoryName":"Preventive Care ","children":[{"categoryName":"Annual Physical","benefitId":"6f9fb9a0-caa7-11eb-a3a4-93b47cfc5118#1008812_11958488#20210604T120500001#usp@dbd#2"}]}]}';
    public static final String b360BenefitCategoryStr1 = '{"benefitCategoryList":["Preventive Care"],"benefitCategoryChildrenMap":{"Preventive Care":[{"categoryName":"Annual Physical","benefitId":"6f9fb9a0-caa7-11eb-a3a4-93b47cfc5118#1008812_11958488#20210604T120500001#usp@dbd#2"}]}}';
    public static final String selectedCategory1 = 'Preventive Care';
    public static final String b360BenefitCategoryStr2 = '{"benefitCategoryList":["Preventive Care"]}';
    public static final String selectedCategory2 = 'Manish';
    public static final String searchedKeyword = 'Surgery';
    public static final String benSearchResponse1 = '{"result":{"matchingPhrases":[],"benefit":[{"benefitId":"742345f0-caa7-11eb-a3a4-93b47cfc5118#1008812_11958488#20210604T120500001#USP@dbd#3@101@f076e77e-8881-4e7e-bcd4-0f1a06be76ff","benefitName":"Surgery – Outpatient","benefitSummaryText":""}]}}';
    public static final String benSearchResponse2 = '{"result":{"matchingPhrases":[],"benefit":[]}}';
    public static final String benefitId = '74c6b1e0-caa7-11eb-a3a4-93b47cfc5118#9Z5466_3531451#20210604T120500001#USP@dbd#3@101@fdbe57c5-5545-4f04-8c10-0b52f01884f2';
    public static final String benSecResponse1 = '{"result":{"benefit":[{"benefitSectionName":"Lab, X-ray and Diagnostic Testing","benefitType":"Benefit","benefitName":"Minor Lab, X-Ray and Diagnostic - Outpatient","benefitLanguageDescription":" <b>What are diagnostic tests?</b>","benefitNetworkSection":[{"networkLanguageDescription":"<b>Lab Testing - Outpatient</b>","networkTypeDescription":["Your cost if you use Network benefits"]}],"benefitLimitAndException":[{"description":"General","details":"Limited to 18 Presumptive Drug Tests per year."}]},{"benefitSectionName":"Lab, X-ray and Diagnostic Testing","benefitType":"BenefitCSR","benefitName":"Authorization by Provider ","benefitNetworkSection":[{"networkLanguageDescription":" Member notification is not required","networkTypeDescription":["Plan Information"]}]}]}}';
    public static final String benSecResponse2 = '{"result":{"benefit":[]}}';
    
    @testsetup
    static void prepareData(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
		System.debug(tokenAPIOrgSpecificConfigs);
        // Service API data
        WebserviceConfigurations__c wsConfig1 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360AreBenefitsAvailableService', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs1 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig1.Id);
        System.debug(orgSpecificConfigs1);
        // Service API data
        WebserviceConfigurations__c wsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360GetBenefitCategoryService', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig2.Id);
        System.debug(orgSpecificConfigs2);
        // Service API data
        WebserviceConfigurations__c wsConfig3 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360SearchBenefitsAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs3 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig3.Id);
        System.debug(orgSpecificConfigs3);
        // Service API data
        WebserviceConfigurations__c wsConfig4 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360GetBenefitsSectionAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs4 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig4.Id);
        System.debug(orgSpecificConfigs4);
    }
    @isTest
    static void textInitVariables(){
        ACETB360BenefitOveriewRedesignController b360Controller = new ACETB360BenefitOveriewRedesignController();
        b360Controller.isBenefitAvailable = false;
        b360Controller.b360BenefitCategory = null;
        b360Controller.b360BenefitCategoryStr = null;
        b360Controller.benefitDateSearch = null;
        b360Controller.currentDate = null;
        b360Controller.currentDateBenefits = null;
        b360Controller.failureMessage = null;
        b360Controller.errorSeverity = null;
        b360Controller.effectiveDate = null;
        b360Controller.endDate = null; 
        b360Controller.groupEffectiveDate = null;
        b360Controller.groupRenewalDate = null; 
        b360Controller.groupId= null;
        b360Controller.benefitBundleOptionId = null;     
        b360Controller.searchedKeyword = null;
        b360Controller.selectedCategory = null;
        b360Controller.benefitId = null;
        b360Controller.benefitSectionsStr = null;
        b360Controller.selectedChildCategory = null;
    }
    @isTest 
    static void testGetBenefitAvailable() {
        
        ACETB360BenefitOveriewRedesignController b360Controller = new ACETB360BenefitOveriewRedesignController();
        b360Controller.groupId = groupId;
        b360Controller.benefitBundleOptionId = benefitBundleOptionId;
        b360Controller.benefitDateSearch = benefitDateSearch;
        
        test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benAvailableRes1);        
        mockResponse5.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
        b360Controller.getBenefitAvailable();
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benAvailableRes2);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		b360Controller.getBenefitAvailable();
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, b360BadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		b360Controller.getBenefitAvailable();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, b360BadResponse);
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		b360Controller.getBenefitAvailable();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, b360BadResponse);
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		b360Controller.getBenefitAvailable();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, b360BadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		b360Controller.getBenefitAvailable();
        
        test.stopTest();
	}
    
    @isTest 
    static void testGetB360BenefitCategoryList() {
        
        ACETB360BenefitOveriewRedesignController b360Controller = new ACETB360BenefitOveriewRedesignController();
        b360Controller.groupId = groupId;
        b360Controller.benefitBundleOptionId = benefitBundleOptionId;
        b360Controller.benefitDateSearch = benefitDateSearch;
        b360Controller.isBenefitAvailable = isBenefitAvailable;
        
        test.startTest();
        b360Controller.getB360BenefitCategoryList();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benCatResponse);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		b360Controller.getB360BenefitCategoryList();
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, b360BadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		b360Controller.getB360BenefitCategoryList();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, b360BadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		b360Controller.getB360BenefitCategoryList();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, b360BadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		b360Controller.getB360BenefitCategoryList();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, b360BadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		b360Controller.getB360BenefitCategoryList();
        
        test.stopTest();
	}
    
    @isTest
    static void testGetChildCategory(){
        ACETB360BenefitOveriewRedesignController b360Controller = new ACETB360BenefitOveriewRedesignController();
        
        b360Controller.b360BenefitCategoryStr = b360BenefitCategoryStr1;
        b360Controller.selectedCategory = selectedCategory1;
        test.startTest();
        b360Controller.getChildCategory();
        
        b360Controller.b360BenefitCategoryStr = b360BenefitCategoryStr2;
        b360Controller.selectedCategory = selectedCategory2;
        b360Controller.getChildCategory();
        test.stopTest(); 
    }
    
    @isTest 
    static void testBenefitKeywordSearch() {
        
        ACETB360BenefitOveriewRedesignController b360Controller = new ACETB360BenefitOveriewRedesignController();
        b360Controller.groupId = groupId;
        b360Controller.benefitBundleOptionId = benefitBundleOptionId;
        b360Controller.benefitDateSearch = benefitDateSearch;
        b360Controller.searchedKeyword = searchedKeyword;
        
        test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200,benSearchResponse1);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		b360Controller.benefitKeywordSearch();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200,benSearchResponse2);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		b360Controller.benefitKeywordSearch();
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400,b360BadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		b360Controller.benefitKeywordSearch();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500,b360BadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		b360Controller.benefitKeywordSearch();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404,b360BadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		b360Controller.benefitKeywordSearch();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504,b360BadResponse);        
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		b360Controller.benefitKeywordSearch();
        
        test.stopTest();
	}
    
    @isTest 
    static void testGetBenefitSection() {
        
        ACETB360BenefitOveriewRedesignController b360Controller = new ACETB360BenefitOveriewRedesignController();
        b360Controller.groupId = groupId;
        b360Controller.benefitBundleOptionId = benefitBundleOptionId;
        b360Controller.benefitDateSearch = benefitDateSearch;
        b360Controller.benefitId = benefitId;
        
        test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benSecResponse1);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		b360Controller.getBenefitSection();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benSecResponse2);
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		b360Controller.getBenefitSection();
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, b360BadResponse); 
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		b360Controller.getBenefitSection();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, b360BadResponse); 
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		b360Controller.getBenefitSection();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, b360BadResponse); 
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		b360Controller.getBenefitSection();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, b360BadResponse); 
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		b360Controller.getBenefitSection();
        
        test.stopTest();
	}
}