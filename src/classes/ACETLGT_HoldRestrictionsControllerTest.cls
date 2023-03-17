@isTest
public class ACETLGT_HoldRestrictionsControllerTest {
	@IsTest
    Public static void LightningMemberHoldRestrictionsMethod()
    {
        //String result=LightningForgotPasswordController.forgotPassword('test@test.test', 'http://www.checkemailfake');
        User memberAgent = TestDataFactory.getUser('ACET Member'); 
         Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
            mapISLWSConfigs.put('StargateConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
            mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
            mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
            mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
            mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
            mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
            mapISLWSConfigs.put('dev_StargateOAuthClientId', 'ISLStageConClientId');
            mapISLWSConfigs.put('dev_StargateOAuthClientSecret', 'ISLStageConClientSecret');
            mapISLWSConfigs.put('dev_StargateOAuthEndpoint', 'https://gateway-stage.optum.com');
             mapISLWSConfigs.put('dev_HoldRestrictions', '/api/alpha/cel/eligibility/selectholdrestrictions/v1/search');           
            mapISLWSConfigs.put('StargateTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"selectHoldRestrictionsResponse":{"selectHoldRestrictions":{"holdList":[{"holdCode":"EDIACD","holdDescription":"Prevent Elig update","effectiveDate":"2019-03-04","expirationDate":"2019-03-14","holdNote":"This is testing the length of the notes box. This is testing the length of the notes box. This is testing the length of the notes box. This is testing the length of the notes box. This is testing the length of the notes box. This is testing the length of the notes","holdRestriction":["Hold Eligibility","Hold Claim Adjudication"],"holdLevel":"Member"},{"holdCode":"MGCO","holdDescription":"Member Group Contract Option is on hold","effectiveDate":"2019-01-09","expirationDate":"9999-12-31","holdNote":"","holdRestriction":["Hold Claim Adjudication"],"holdLevel":"Contract Option"},{"holdCode":"MGCPO","holdDescription":"Member Group Contract Plan Option is on hold","effectiveDate":"2019-01-09","expirationDate":"2019-07-31","holdNote":"","holdRestriction":["Hold Claim Adjudication"],"holdLevel":"Plan Option"},{"holdCode":"EDIACD","holdDescription":"Prevent Elig update","effectiveDate":"2019-01-09","expirationDate":"2019-07-31","holdNote":"","holdRestriction":["Hold Eligibility","Hold Claim Adjudication"],"holdLevel":"Plan Option"},{"holdCode":"FULFIL","holdDescription":"Hold Fulfillment","effectiveDate":"2019-01-09","expirationDate":"2019-07-31","holdNote":"","holdRestriction":["Hold Fulfillment"],"holdLevel":"Plan Option"},{"holdCode":"EDIACD","holdDescription":"Prevent Elig update","effectiveDate":"2019-01-09","expirationDate":"2019-07-31","holdNote":"","holdRestriction":["Hold Eligibility","Hold Claim Adjudication"],"holdLevel":"Plan Option"},{"holdCode":"CONTRB","holdDescription":"Prevent Contributions","effectiveDate":"2019-01-09","expirationDate":"2019-07-31","holdNote":"","holdRestriction":["Hold Claim Adjudication"],"holdLevel":"Plan Option"},{"holdCode":"IDCARD","holdDescription":"Hold ID Card","effectiveDate":"2019-02-19","expirationDate":"9999-12-31","holdNote":"","holdRestriction":["Hold ID Card"],"holdLevel":"Group"},{"holdCode":"FULFIL","holdDescription":"Hold Fulfillment","effectiveDate":"2019-02-19","expirationDate":"9999-12-31","holdNote":"","holdRestriction":["Hold Fulfillment"],"holdLevel":"Group"}]}}},"pagination":{"pageNumber":"1","pageSize":"5","recordCount":"1","totalCount":"1","totalPages":"1"}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        System.runAs(memberAgent){
            Test.startTest();
                ACETLGT_HoldRestrictionsController memSearch= new ACETLGT_HoldRestrictionsController(); 
            
            ACETLGT_HoldRestrictionsController.getHoldRestrictions('12345677890','1234567');
            Test.stopTest();
            
        }
        
    }
    
}