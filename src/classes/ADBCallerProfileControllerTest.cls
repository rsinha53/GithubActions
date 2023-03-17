/**
* Author: Hasara Disanayaka
* Description : Test class for the unit test.
* Date Created: 12/04/2019
*/

@isTest
public class ADBCallerProfileControllerTest {
	final static String requiredReq = '{"first_nm":"TERRI","lst_nm":"ANDERSON","policy_nbr":"0136003","user_id":"skollur6","emailTypeCode":"P","emailTypeDesc":"Home","email":"asa@sdet.com","subscriber_id":"474706605","dob":"1955-08-23"}';
    @testSetup static void setup() {
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
				new WebserviceConfigurations__c(Name = 'ADBEpmpSaveEMailEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBEpmpSaveCommPrefEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBEpmpSavePhoneEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBEpmpGANUpdateEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBEpmpSelectionsEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBEpmpPreferencesEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBPHIContactEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'LinkEligibilityMemberSearch',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'LinkExtendedCoverage',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'LinkLanguagePrefEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
																														 
        };
        insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[2].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[3].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[4].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[5].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/cel/optumisl/epmp/v1.5/preferences'),
				new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[6].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://gateway-stage.optum.com/api/bravo/clin/icue/memberdetails/v2.0/getMemberContactsBySourceID'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[7].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[8].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com/elink-extended/api/coverageAttributes/v2.0'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[9].Id, Name = 'QA',recordtypeText__c = 'TokenAPI', EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com/elink-extended/api/languagePreference/v2.0')
																																																   
        };
        insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        
        // create test data for custom setting
        List<ISL_Webservice_Config__c> tokenUrl = new List<ISL_Webservice_Config__c>{
            new ISL_Webservice_Config__c(name='dev_EligibilityTokenService', value__c='https://api-gateway-stage.linkhealth.com/oauth/token'),
                new ISL_Webservice_Config__c(name='dev_EligibilityelinkService', value__c='	https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'),
                new ISL_Webservice_Config__c(name='dev_ADBLanguagePreferenceEndpoint',value__c='https://api-gateway-stage.linkhealth.com/elink-extended/api/languagePreference/v2.0'),
                new ISL_Webservice_Config__c(name='dev_LinkEligibilityAPI', value__c='https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'),
                new ISL_Webservice_Config__c(name='dev_LinkExtendedCoverageAPI', value__c='https://api-gateway-stage.linkhealth.com/elink-extended/api/coverageAttributes/v2.0'),
                new ISL_Webservice_Config__c(name='dev_ADBPHIContactEndpoint', value__c='https://gateway-stage.optum.com/api/bravo/clin/icue/memberdetails/v2.0/getMemberContactsBySourceID'),
                new ISL_Webservice_Config__c(name='dev_ADBEpmpSaveMailAddress', value__c='https://gateway-stage.optum.com/api/stage/cel/optumisl/epmp/v1.5/contactinfo/email'),
                new ISL_Webservice_Config__c(name='dev_ADBEpmpSaveCommPreference', value__c='https://gateway-stage.optum.com/api/stage/cel/optumisl/epmp/v1.5/preferences/paperless'),
                new ISL_Webservice_Config__c(name='dev_ADBEpmpSavePhone', value__c='https://gateway-stage.optum.com/api/stage/cel/optumisl/epmp/v1.5/contactinfo/phone'),
                new ISL_Webservice_Config__c(name='dev_ADBCommPrefEPMPUrlEndpoint', value__c='https://gateway-stage.optum.com/api/')
                }; 
                    
                    insert tokenUrl;
				List<ACETOrgNameToSwivelEndpointMap__c> orgNameMpping = new List<ACETOrgNameToSwivelEndpointMap__c>{
            new ACETOrgNameToSwivelEndpointMap__c(name='ADBcommunicationPreference', Swivel_Endpoint__c='https://epmpcui.optum.com/optumisl/epmp/users/v1.5/commonui?suppress=N#!/preferences'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBEmailContact', Swivel_Endpoint__c='https://epmpcui.optum.com/optumisl/epmp/users/v1.5/commonui?suppress=N#!/contact'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBPhoneContact', Swivel_Endpoint__c='https://epmpcui.optum.com/optumisl/epmp/users/v1.5/commonui?suppress=N#!/contact')
                };
                    insert orgNameMpping;																																												
        Test.stopTest();
    }
    
    
    // To test Eligibility Extended web service
    @isTest static void getMemberInfo (){
        String memberId = '036169100';//'048680047';
        String memberDob = '11/07/1954';//'1965-01-11';
        String transactionId = 'gwaziKFyQFLmCtOJeJtIMFi6idJyRcYzLLkUOcrCNP3YKeYO4yCS6KmZhMtsMb1oXPXbyG1aQeK_W3c5FKmVXDyjCYaUKeKlNZAhgoK8LOY5KwDN2YikMA35JDe2PvY-G78DOyffhPYC6pA1vpjGfJ9fXi4r18VE-tqMuF_r7X4821193';
        test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACETLinkExtendedResponseMock');
        mock.setStatusCode(200);
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ISL_Webservice_Config__c web = [SELECT id, name, value__c from ISL_Webservice_Config__c LIMIT 1];
        system.assertEquals(true, web.Value__c != null);
        ADBEligibilityExtendedRequestWrapper extendedService = ADBCallerProfileController.getMemberInfo(memberId, memberDob,transactionId);
        test.stopTest(); 
    }
    
    // To test Language Preference web service
    @isTest static void getlanguagePreference (){
        String memberId = '048680047';
        String memberDob = '1965-01-11';
        String transactionId = 'gwaziKFyQFLmCtOJeJtIMFi6idJyRcYzLLkUOcrCNP3YKeYO4yCS6KmZhMtsMb1oXPXbyG1aQeK_W3c5FKmVXDyjCYaUKeKlNZAhgoK8LOY5KwDN2YikMA35JDe2PvY-G78DOyffhPYC6pA1vpjGfJ9fXi4r18VE-tqMuF_r7X4821193';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACETLaguagePreference');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ISL_Webservice_Config__c web = [SELECT id, name, value__c from ISL_Webservice_Config__c LIMIT 1];
        system.assertEquals(true, web.Value__c != null);
        ADBEligibilityExtendedRequestWrapper extendedService = ADBCallerProfileController.getlanguagePreference(memberId, memberDob,transactionId);
        test.stopTest(); 
    }

    @isTest static void testEpmpPreferenceDetails(){
        String memberId = '555444333';
        String firstName = 'Sally';
        String lastName = 'Smith';
        String dob = '11-27-1923';
        String policyNumber = '0700639';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEpmpPreferenceTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.callEpmpPreferenceAPI(memberId, dob, firstName, lastName, policyNumber);
        test.stopTest();
    }
    
    @isTest static void testPHIContacts() {
        String userID = 'ABALLA';
        String cdxRefId = '33496774'; 
        test.startTest(); 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBPHIContactsTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.getPHIContacts(userID, cdxRefId);
        test.stopTest();
    }
    
    @isTest static void testPHISingleContact() {
        String userID = 'ABALLA';
        String cdxRefId = '33496774'; 
        test.startTest(); 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBPHIContactsSingleContact');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.getPHIContacts(userID, cdxRefId);
        test.stopTest();
    }
    
    @isTest static void testlaunchICUEHomeUrl(){
        test.startTest();
        String cdbXrefId='2352533',userId='svennam3';
        ADBCallerProfileController.getcoverageICUEHomeUrl(cdbXrefId,userId);
        test.stopTest();
    }

    @isTest static void testSaveEpmpMail(){
        String reqStr = requiredReq;
        
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEPMPMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.saveEpmpMail(reqStr);
        test.stopTest();
    } 
    
    @isTest static void testSaveEpmpCommunctnPreferencel(){
        String reqStr = requiredReq;
        
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEPMPMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.saveEpmpCommunctnPreference(reqStr);
        test.stopTest();
    }  
    
    @isTest static void testSaveEpmpPhoneNumber(){
        String memberId = '00555444333';
        String memFirstName = 'Sally';
        String memLastName = 'Smith';
        String memDob = '11-27-1923';
        String memberPolicy = '0700639';
        String userID = 'S1118';
        String telephoneNumber = '4567890000';
        
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEPMPMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.saveEpmpPhoneNumber(memberId, memDob, memFirstName, memLastName, memberPolicy, userID, telephoneNumber);
        test.stopTest();
    }
    
    @isTest static void testEPMPSSOUrl(){
        String memberId = '00555444333';
        String firstname = 'Sally';
        String lastname = 'Smith';
        String memberDob = '11/27/1923';
        String policy = '0700639';
        String userId = 'S1118';
        String selectedLinkEmail = 'Email';
        String selectedLinkMobilePhone = 'MobilePhone';
        String selectedLinkCommPref = 'CommPref';
        
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEPMPMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.getEPMPSSOUrl(memberId, userId, firstname, lastname, memberDob, policy, selectedLinkEmail);
        ADBCallerProfileController.getEPMPSSOUrl(memberId, userId, firstname, lastname, memberDob, policy, selectedLinkMobilePhone);
        ADBCallerProfileController.getEPMPSSOUrl(memberId, userId, firstname, lastname, memberDob, policy, selectedLinkCommPref);
        test.stopTest();
    }
    
    @isTest static void testGetPHIUrl(){
        String xrefId = 'hdisanay';
        String userId = '23903457';
        test.startTest();
        ADBCallerProfileController.getPHIUrl(xrefId, userId);
        test.stopTest();
    }
    
    @isTest static void testsaveEpmpPhoneNumberGAN(){
        String reqStr = requiredReq;
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEPMPMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.saveEpmpPhoneNumberGAN(reqStr);
        test.stopTest();
    }
    
    @isTest static void testupdateSelectionsAPI(){
        String reqStr = '{"first_nm":"TERRI","lst_nm":"ANDERSON","policy_nbr":"0136003","subscriber_id":"474706605","dob":"1955-08-23"}';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEPMPMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBCallerProfileController.updateSelectionsAPI(reqStr);
        test.stopTest();
    }
    
    @isTest static void  testADBEligibilityResponseWrapper(){
        test.startTest();
        String val = '{"memberPolicies":[{"patientInfo":[{"addressLine1":"165 WINDING STREAM TRAIL","addressLine2":"","city":"HAMPTON","dateOfBirth":"1970-12-23","firstName":"CRAIG","gender":"M","lastName":"BROGAN","middleName":"A","relationship":"subscriber","searched":"false","state":"GA","zip":"30228","patientKey":"AgBUi01I0pjbPfR4c2jw56P0CKEZF%2F%2Bdo%2BFL4Ji3rpAw0djjtrBJm7hHMetY9ktYvH%2BlmHI6IszaZUZvdnkm9LEAZYXhol2SqjmQvi%2BSy%2FMa9Q66QdCw25h%2ByU2bVDAeHmPkzuok1cHGlKGyp%2BFzTIQLuicwuwY%2Bg4%2FhB16lPpItitqVmtgi61WyGwBeNvTU0h5KCPElzzyaDgZw3KHSdD9Fon4OzVhsCU1vu%2BllWspa9cx59yCb1vBDqQ8UdFnyIx1S8YYUYVVZcEWF5z8YJ8jwrIp4C9ulA7jn0u1nDdiX73xEau%2BxTccpV5LtkHqwM%2B0Oztv1Lo%2FYXPPPhEHoF4fKDvS9C4%2BCYCyno85w3aOcqesRm4pjXdFK0nC65RGjAkl7BdEIoS98JiSjbXtZqsCuIGENgTBVmaeVoWKDgv4LwseTmjnYiLUodpKaqkJmuLUDMG2VhJ%2F%2Fh7ciF0%2B2gtR4JynaSp%2FYI8L4qwZB4iQ9Xd8rLqAAsbNdTtIeegC1pxGgcu5bQUTp1YDlFzUYSCQEgH9jjPwcBrOWL73NlP808btXIfZvasCJssWGVDm0MEsemhLie4s4794wTYI9pja0j7O4lxnbymD%2FOktQtw0yYMgusSf4muohXq%2BmzAh4sIerZ5FIwfFO%2BFbqAcmwky449znGBhVndLDq1DPAaknZ5DcC2dd0cp2obKGEX9pVCRaF5JpKQhlN5FMXYUtx2E9yzhfhns0jI1A6M6Aus3uDhHo7zXhEphuvgvRj2kEE7oVEbYU%2B7MhXoazt4oZXJvauAydyNQUUw5aOMTi8Y1Cm1DvsNpA2Jlfp81XYrTENzfW4espHxEdBsHmsqw1HF7Ig2s2CdHIZQDMApOjt4VNR1g%3D%3D","subscriberBoolean":true},{"addressLine1":"165 WINDING STREAM TRAIL","addressLine2":"","city":"HAMPTON","dateOfBirth":"1954-07-11","firstName":"PEGGY","gender":"F","lastName":"BROGAN","middleName":"P","relationship":"dependent","searched":"true","state":"GA","zip":"30228","patientKey":"AgBTdXluwq4SGm5TnrWGq8o9l2qIm0Fcw1MuzksiBVKqNbR06X3IxU0t9BJlRp8ko6pcZ7u3AGBP52THCT12XvC%2BRLGJQjVaDHyLWfj7IBuX%2BOGVj%2F43igTjmr%2F4lpSFDuEeSbpMNITOujNLaqx0FYdRWYsj5DfgcDjoYfcgiGbSYPH7IZTO6n0pG7JqOg3GEbEqFPReMUfAFuhjj4hk%2FVkeWCLUcNChHP6hRyGRumLUBjNAtIbBTmzVxGhRUHHvq41UUOBkiUPtKsGPAmCg2w42W%2F0GN2vDotni%2FLuhEp5sjNoSEXIUQJ%2FlrwjbvpxEGEnUcF7Io1Ld8hJUh8k0sYX8%2BD7nDYk6Qk%2FMPe2BBFTo67xIIh9labgtCWEJXfAV%2BdXkcn7UGD9F93qpN%2FhrS4XDccERsqq441rVMeAKQYa0uKEJCFzQA2fKXolyiTAIiBbmafywLhAPkorOUTcRHvThJfZFCacID5rtpKXM2%2BTuR6y5IqsIe17U61W1S2wr9xoLjBbvkv7HDjmmba5M3tsb1IEtHDmubrVJXftybVBbV7QN9xvph%2FgHInuOQl3LqDpbXRtFVIGLo90mNovqfITvEK0SF3YG03BF7eVyZ3O5IBqIeq%2Fj5FVOyP3%2B%2B00gIQ8y95TqRV6sYvBz9l%2BXkE9o5ElzZhyBtqY1FeewIqZIMT%2FdpHKJS0LagJKc3QGzBG4BqfGXcXTWwePdOzhCkagDVQYC94R3x6IxNwqEgnbDGFqVhZWqWE572jIzsKuwdLcQ0JNRT%2F5k343erQdDUMXUFaoURKC1%2BZScNgHhKApoaepkPK60KVaKlyjQfBDGuAE3CSWzh06PFaPJ76ga7f0W","subscriberBoolean":false}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"3100.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"2699.09","metYtdAmount":"400.91"},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"6200.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"6200.0","metYtdAmount":"0.0"},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"3100.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"2699.09","metYtdAmount":"400.91"}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"9300.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"8616.08","metYtdAmount":"683.92"},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"18600.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"18600.0","metYtdAmount":"0.0"},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"9300.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"8616.08","metYtdAmount":"683.92"}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"6400.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"5917.1","metYtdAmount":"482.9"},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"12800.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"12800.0","metYtdAmount":"0.0"},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"6400.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"5917.1","metYtdAmount":"482.9"}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"13100.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"12334.09","metYtdAmount":"765.91"},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"26200.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"26200.0","metYtdAmount":"0.0"},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"13100.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"12334.09","metYtdAmount":"765.91"}}},"copayMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Member-s plan does not have a copay maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Member-s plan does not have an out of pocket 2 maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 740800","addressLine2":"","city":"ATLANTA","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"226310","insuranceType":"Commercial","insuranceTypeCode":"C1","lineOfBusiness":"1","paidThroughDate":null,"memberId":"036169100","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"GA","zip":"30374-0800","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null,"administeredByUhc":false},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"036169100","planDates":{"startDate":"2020-01-01","endDate":"2019-12-31"},"policyStatus":"Active Policy","searchedDates":{"searchStartDate":"2020-05-13","searchEndDate":""},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasn-t been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":false,"id":"1","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"gwaziKFyQFLmCtOJeJtIMFi6idJyRcYzLLkUOcrCNP3YKeYO4yCS6KmZhMtsMb1oXPXbyG1aQeK_W3c5FKmVXDyjCYaUKeKlNZAhgoK8LOY5KwDN2YikMA35JDe2PvY-G78DOyffhPYC6pA1vpjGfJ9fXi4r18VE-tqMuF_r7X4821193"}],"requestingProvider":{"providerFirstName":null,"providerMiddleName":null,"providerLastName":"ACET","providerNameID":"9999999","taxIdNumber":"9999999","corporateTaxOwnerID":null,"corporateTaxOwnerName":null,"organizationName":null,"organizationID":null,"facilityName":null,"npi":null},"requestingProviderAddresses":[],"searchQuery":{"memberId":"036169100","lastName":"0","firstName":"0","dateOfBirth":"19540711","payerID":"87726","payerName":"0","serviceStart":"0","serviceEnd":"0","middleName":"0","gender":"0","ssn":"0","city":"0","state":"0","zip":"0","groupNumber":"0","serviceTypeCode":"0","providerLastName":"ACET","providerFirstName":"0","providerNameID":"9999999","corporateTaxOwnerID":"0","corporateTaxOwnerName":"0","organizationName":"0","organizationID":"0","taxIdNumber":"9999999","searchOption":"MemberIDDateOfBirth","payerLabel":"0","npi":"0"}} ';
        ADBEligibilityResponseWrapper.parse(val);
        test.stopTest();
    }
    
    @isTest static void  testADBEligibilityExtendedResponseWrapper(){
        test.startTest();
        String val = '{"alternateId":"036169100","benefitPlanId":"","benefitPackageLogNumber":"ACIS137","cesGroupNumber":"0226310","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2020-01-01","coverageLevel":"7","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01","genderCode":"F","governmentProgramCode":"","groupName":null,"groupNumber":"N-A","groupPanelNumber":"N-A","homeTelephoneNumber":"770-707-2951","individualRelationshipCode":"SP","legacyPanelNumber":"","legalEntityCode":"20020","lineOfBusiness":"N-A","marketSite":"0010460","marketType":"50","mbi":"","medicareIndicator":null,"medicareEntitlementReason":null,"nhpIndicator":"","nonEmbeddedFamilyStatusIndicator":"NONE","obligorID":"01","pcid":"00004","platform":"UNET","planFeatureCode":null,"planVariation":"6670","policyNumber":"0226310","productCode":"Q","productID":"","productType":"POS","postalAddress":{"city":"HAMPTON","country":"US","state":"GA","street1":"165 WINDING STREAM TRAIL","street2":"","zip":"30228","zip4":""},"referralRequired":"NO","relationshipCode":"001","reportingCode":"6670","serviceBenefitDescription":null,"serviceBenefitNotes":null,"serviceBenefitDetails":[],"sharedArrangement":"00","sourceCode":"CS","sourceID":"02263100003616910000001","state":"GA","stateOfIssueCode":"GA","subscriberID":"00036169100","tciTableNumber":"021143","xrefId":"84222735","xrefIdPartitionNumber":"135","memberInfo":{"relationship":"Spouse","firstName":"PEGGY","lastName":"BROGAN","dob":"1954-07-11","memberID":"036169100","genderCode":"F","members":[{"relationship":"Child","firstName":"JAKE","lastName":"BROGAN","dob":"1996-09-16","memberID":"036169100","genderCode":"M"},{"relationship":"Subscriber","firstName":"CRAIG","lastName":"BROGAN","dob":"1970-12-23","memberID":"036169100","genderCode":"M"}],"dos":"2020-01-01"},"primaryCareProvider":{"pcpMessage":"No Primary Care Physician on file for this plan.","pcpFirstName":"N-A","pcpMiddleName":"N-A","pcpLastName":"N-A","providerAddress":{"addressLine1":"N-A","addressLine2":"N-A","city":"N-A","state":"N-A","zip":"N-A"},"pcpPhoneNumber":"N-A","providerNpi":"N-A","taxId":"N-A","pcpSpeciality":"N-A","pcpStartDate":"N-A","pcpEndDate":"N-A","acoNetworkDescription":"N-A","acoNetworkId":"N-A","affiliateHospitalName":"N-A","providerGroupName":"N-A","entityType":null,"pcpFound":false},"additionalPlanDetails":{"cdhp":"YES","cobUpdateInformation":{"cobUpdateMessage":"Member COB update overdue.","cobLastUpdate":"2018-10-31"},"fundingType":"Self-Funded","hsa":"YES","insuranceTypeCode":null,"primaryPayer":"Primary","virtualVisits":"Virtual Visit benefits exist for this plan","umDelegationFlag":null},"payerInfo":null,"additionalCoverage":[{"phoneNumber":"","payerName":"","cobMemberId":"","cobPolicyNumber":"","policyEffectiveStartDate":"","policyEffectiveEndDate":"","notes":"N-A","description":"N-A","cobPolicyGroupNumber":"","coverageType":"","cobPolicyHolderName":"","street1":"","city":"","state":"","zip":"","primaryGroupIndicator":""}],"pcpHistoryList":[]} ';
        ADBEligibilityExtendedResponseWrapper.parse(val);
        test.stopTest();
    } 
    
    @isTest static void  testADBLanguagePreferenceResponseWrapper(){
        test.startTest();
        String val = '{"attributes":{"eligibleForLanguageAssistance":"NO","verbalLanguagePreference":"ENGLISH","writtenLanguagePreference":"ENGLISH"}}';
        ADBLanguagePreferenceResponseWrapper.parse(val);
        test.stopTest();
    }
   											 
    @isTest static void  testADBEpmpPreferenceResponseWrapper(){
        test.startTest();
        String val = '{"first_nm":"TERRI","lst_nm":"ANDERSON","policy_nbr":"0136003","user_id":"skollur6","emailTypeCode":"P","emailTypeDesc":"Home","email":"asa@sdet.com","subscriber_id":"474706605","dob":"1955-08-23"}';
        ADBEpmpPreferenceResponseWrapper.parse(val);
        test.stopTest();
    }
    @isTest static void  testADBPHIContactResponseWrapper(){
        test.startTest();
        String val = '{"memberContactsResponse":{"responseHeader":{"serviceCallStatusCode":"Success","serviceCallStatus":""},"sensitiveData":false,"memberContacts":[{"memberContactSeqNum":1,"contactType":6,"firstName":"Test","lastName":"DATA","relationship":8,"primaryContact":false,"contactPermissionIndicator":false,"phiAuthorizationIndicator":true,"country":"US","effectiveDate":"2020-07-10T00:00:00-05:00","endDate":"9999-12-31T00:00:00-06:00","legalRepresentativeIndicator":false,"livesWithMemberIndicator":false,"sensitiveDataAccess":false,"createDate":"2020-07-10T08:52:47.313-05:00","createdBy":"SMUDIMBI","updateDate":"2020-07-22T06:10:11.396-05:00","updatedBy":"SYSTEM"},{"memberContactSeqNum":2,"contactType":6,"firstName":"data","lastName":"one","relationship":8,"primaryContact":false,"contactPermissionIndicator":false,"phiAuthorizationIndicator":true,"country":"US","effectiveDate":"2020-07-10T00:00:00-05:00","endDate":"9999-12-31T00:00:00-06:00","legalRepresentativeIndicator":false,"livesWithMemberIndicator":false,"sensitiveDataAccess":false,"createDate":"2020-07-10T13:47:33.265-05:00","createdBy":"SMUDIMBI","updateDate":"2020-07-22T06:10:11.408-05:00","updatedBy":"SYSTEM"},{"memberContactSeqNum":3,"contactType":6,"firstName":"gdvs","lastName":"cs","relationship":36,"primaryContact":false,"contactPermissionIndicator":false,"phiAuthorizationIndicator":false,"country":"US","effectiveDate":"2020-07-10T00:00:00-05:00","endDate":"9999-12-31T00:00:00-06:00","legalRepresentativeIndicator":false,"livesWithMemberIndicator":false,"sensitiveDataAccess":false,"createDate":"2020-07-10T13:49:12.223-05:00","createdBy":"SMUDIMBI","updateDate":"2020-07-22T06:10:11.423-05:00","updatedBy":"SYSTEM"}]}}';
        ADBPHIContactResponseWrapper.parse(val);
        test.stopTest();
    }
  
    @isTest static void  testADBEpmpWrapper(){
        test.startTest();
        String val = '{"first_nm":"TERRI","lst_nm":"ANDERSON","policy_nbr":"0136003","subscriber_id":"474706605","dob":"1955-08-23"}';
        ADBEpmpSavePhoneNumberGAN.parse(val);
        ADBEpmpPhoneRequestWrapper.parse(val);
        ADBEpmpMailSaveRequestWrapper.parse(val);
        ADBEpmpCommPreferenceRequestWrapper.parse(val);
        ADBEpmpSelectionsReqWrapper.parse(val);
        test.stopTest();
    }

	@isTest static void testCurrentCall (){
        String currentCall = 'R3';
        String nullCurrentCall = '';
        String InvalCurrentCall = 'RP';
        test.startTest();
        ADBCallerProfileController.getCurrentCall(currentCall);
        ADBCallerProfileController.getCurrentCall(nullCurrentCall);
        ADBCallerProfileController.getCurrentCall(InvalCurrentCall);
        test.stopTest();
    }   
}