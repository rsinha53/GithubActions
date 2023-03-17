@isTest
public class ACETInteractHighlightsPanelControllTest {

    public static testMethod void testgetMemberAlert(){ 
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User memberAgent;
        System.runAs(thisUser){
         memberAgent = TestDataFactory.getUser('ACET Member');
        system.debug('UserName >>>> '+memberAgent);
             
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate = ACETTestDataUtility.createORGNameToSwivelData('dev_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate;
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate1 = ACETTestDataUtility.createORGNameToSwivelData('d1_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate1;
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate2 = ACETTestDataUtility.createORGNameToSwivelData('qa_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate2;
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate3 = ACETTestDataUtility.createORGNameToSwivelData('prd_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate3;
        ACETWrapEncryptionKey__c CirrusEncryptionKey= new ACETWrapEncryptionKey__c(Name='dev_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey;
        ACETWrapEncryptionKey__c CirrusEncryptionKey1= new ACETWrapEncryptionKey__c(Name='d1_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey1;
        ACETWrapEncryptionKey__c CirrusEncryptionKey2= new ACETWrapEncryptionKey__c(Name='qa_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey2;
        ACETWrapEncryptionKey__c CirrusEncryptionKey3= new ACETWrapEncryptionKey__c(Name='prd_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey3;
       
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
         }
        
        System.runAs(memberAgent){
            Test.startTest();
            
             ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
            ACETMemberDetail memberDetail = new ACETMemberDetail();
       
            ACETInteractionHighlightsPanelController temp = new ACETInteractionHighlightsPanelController();
            temp.Interaction = TestDataFactory.createInteraction();
            temp.Subject =  TestDataFactory.createContact();
            
            ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
            AdditionalInfo.DOB = '12/27/2009';
            AdditionalInfo.SitusState = '12/27/2009';
            AdditionalInfo.EffectiveDate = '12/27/2009';
            AdditionalInfo.EndDate = '12/27/2009';
            AdditionalInfo.groupName  = 'Test';
            AdditionalInfo.Network    = 'Test';
            AdditionalInfo.OriginatorRelationship  = 'Test';
            AdditionalInfo.PolicyNumber  = 'UHC1234';
            AdditionalInfo.Product  = 'Product Test';
            AdditionalInfo.productType  = 'Care Service';
            AdditionalInfo.Relationship  = 'Primary';  
            AdditionalInfo.MemberId='123456789';
            
            temp.AdditionalInfo = AdditionalInfo ;       
            temp.getMemberAlert();
            temp.btnHideWindowAlertWinodw();
            temp.clickMemberAlert();
            temp.getAllAlerts();
            temp.showHoldCodeHLP();
            temp.hideHoldCodeHLP();
            temp.callHoldRestrictions();
            temp.fetchCirrusSSOURL();
            temp.showHoldErrorMsgsHLP();
            Test.stopTest();
        }
        
    }
    public static testMethod void testgetProviderAlert(){ 
      
        User providerAgent = TestDataFactory.getUser('ACET Provider');
        system.debug('UserName >>>> '+providerAgent );
        
        System.runAs(providerAgent ){
            Test.startTest();
            ACETInteractionHighlightsPanelController temp = new ACETInteractionHighlightsPanelController();
            temp.Interaction = TestDataFactory.createInteraction();
            temp.Interaction.Originator_Type__c = 'Provider';
            temp.Subject =  TestDataFactory.createContactwithEID();
            
            ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
            AdditionalInfo.DOB = '12/27/2009';
            AdditionalInfo.SitusState = '12/27/2009';
            AdditionalInfo.EffectiveDate = '12/27/2009';
            AdditionalInfo.EndDate = '12/27/2009';
            AdditionalInfo.groupName  = 'Test';
            AdditionalInfo.Network    = 'Test';
            AdditionalInfo.OriginatorRelationship  = 'Test';
            AdditionalInfo.PolicyNumber  = 'UHC1234';
            AdditionalInfo.Product  = 'Product Test';
            AdditionalInfo.productType  = 'Care Service';
            AdditionalInfo.Relationship  = 'Primary'; 
            AdditionalInfo.MemberId='123456789';
            
            temp.AdditionalInfo=AdditionalInfo;
            temp.getProviderAlert();
            temp.btnHideWindowAlertWinodw();
            temp.clickProviderAlert();
            temp.getAllAlerts();
            Test.stopTest();
        }
        
    }
    
    public static testMethod void testgetProducerAlert(){       
            Test.startTest();
            ACETInteractionHighlightsPanelController temp = new ACETInteractionHighlightsPanelController();
            temp.Interaction = TestDataFactory.createInteraction();
            temp.Interaction.Originator_Type__c = 'Producer';
            temp.Subject =  TestDataFactory.createContact();
            temp.getProducerAlert();           
            temp.clickProducerAlert();
            temp.getAllAlerts();
            Test.stopTest();       
    }
    public static testMethod void testgetGroupAlert(){       
            Test.startTest();
            
            Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
            TestISLWSConfigs.put('dev_DynatraceJSURL', 'https://dtsaas-sgw.uhc.com:443/jstag/managed/ruxitagent_2fqr_10129170927131437.js');
            TestISLWSConfigs.put('dev_DynatraceConfig', 'app=56ED5C35A17F0669|cors=1|featureHash=2fqr|lastModification=0|dtVersion=10129170927131437');
            TestISLWSConfigs.put('dev_DynatraceReportURL', 'https://dtsaas-sgw.uhc.com:443/bf/236cb244-cefd-4e30-ab32-b01cfd5e50dc');
            List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
            insert lstISLWSConfigs;
        
            ACETInteractionHighlightsPanelController temp = new ACETInteractionHighlightsPanelController();
            temp.Interaction = TestDataFactory.createInteraction();
            temp.Interaction.Originator_Type__c = 'Group/Employer';
            temp.Subject =  TestDataFactory.createContact();
                        
            ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
            AdditionalInfo.DOB = '12/27/2009';
            AdditionalInfo.SitusState = '12/27/2009';
            AdditionalInfo.EffectiveDate = '12/27/2009';
            AdditionalInfo.EndDate = '12/27/2009';
            AdditionalInfo.groupName  = 'Test';
            AdditionalInfo.Network    = 'Test';
            AdditionalInfo.OriginatorRelationship  = 'Test';
            AdditionalInfo.PolicyNumber  = 'UHC1234';
            AdditionalInfo.Product  = 'Product Test';
            AdditionalInfo.productType  = 'Care Service';
            AdditionalInfo.Relationship  = 'Primary'; 
            AdditionalInfo.GroupN= '123456789-THWINGCOMPANY';  
            
            temp.AdditionalInfo = AdditionalInfo ;       
            temp.getGroupAlert();           
            temp.clickGroupAlert();
            temp.getAllAlerts();
            Test.stopTest();       
    }
   
   
}