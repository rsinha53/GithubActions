@isTest
global class CDB_ACETWebserviceTest {
    
        
    private static final String GRANTTYPE = 'testGrantType';      
    private static final String CLIENTSECRET = 'testClientSecret';      
    private static final String CLIENTID = 'testClientID';
    
    global static Map<String, WebserviceConfigurations__c> webServices = new Map<String, WebserviceConfigurations__c>();

    global class tokenAccessMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type','application/x-www-form-urlencoded');
            response.setBody('{"token_type":"Bearer","expires_in":3599,"ext_expires_in":3599,"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiI3NjZmZDBmZC1jYzM5LTQwZGYtODgyZi00ZDI5NDU5ZWY4MmMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vYzc1OTE1MWMtZGIyZC00YzdkLTkyMmYtNTgzMDg1OTFkMTk3L3YyLjAiLCJpYXQiOjE2NTI4NjM2MDUsIm5iZiI6MTY1Mjg2MzYwNSwiZXhwIjoxNjUyODY3NTA1LCJhaW8iOiJFMlpnWUZqRTlJbzF2OU1sdnNG"}');       
            response.setStatusCode(200);
            return response; 
        }
    }
    global class memberInfoMock implements HttpCalloutMock {

        global HTTPResponse respond(HTTPRequest req) {          
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('consumername', 'CHN');
            res.setHeader('roles', 'CHN');
            res.setHeader('x-upstream-env','stage');
            res.setHeader('x-uhg-user-identifier','eyJlaWQiOiI0MTQ2Mjk3OSIsImZpZHMiOlt7ImlkIjoiMzU1Nzk1NDIzIiwic291cmNlQ0QiOiJDREJfQ1MifSx7ImlkIjoiNDQwMTQyNDUiLCJzb3VyY2VDRCI6IkNEQl9DUyJ9XSwiY3JpZHMiOltdLCJoaHNJZCI6bnVsbH0=');
            res.setHeader('Authorization', 'Bearer ' + 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiI3NjZmZDBmZC1jYzM5LTQwZGYtODgyZi00ZDI5NDU5ZWY4MmMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vYzc1OTE1MWMtZGIyZC00YzdkLTkyMmYtNTgzMDg1OTFkMTk3L3YyLjAiLCJpYXQiOjE2NTI4NjM2MDUsIm5iZiI6MTY1Mjg2MzYwNSwiZXhwIjoxNjUyODY3NTA1LCJhaW8iOiJFMlpnWUZqRTlJbzF2OU1sdnNG');
            res.setBody('{"eligibilities":[{"sourceIndividual":{"active":true,"alternateIdentifiers":{"alternateIds":[{"identifier":"913868524"}],"alternateSubscriberId":"913868524","employerAssignedIds":[{"identifier":"900130"}],"enterpriseIndividualIdentifier":"705986728","familyId":233820262,"legacyMemberIds":null,"medicaidRecipientNumbers":null,"memberAlternateIds":null,"memberFamilyLinkIds":null,"memberId":"","memberReplacementIds":null,"priorMemberIds":null,"sourceSystemIds":[{"identifier":"07033520059067543501001"}],"subscriberIds":[{"identifier":"00590675435"}],"survivingSpouseIds":null,"mbiNumber":null,"hicNumber":null,"medicaidRecipientNumber":null,"survivingSpouseId":null},"birthSequenceNumber":"001","demographicInfo":{"birthDate":"1990-08-24","ethnicity":null,"genderType":{"code":"F"}},"eligibilityAttributes":{"enrolleeMemberFacingIdentifier":"","relationshipType":{"description":"Spouse"},"subscriberMemberFacingIdentifier":"00590675435"},"enrolleeSourceCode":"CS","enrolleeSourceId":"07033520059067543501001","individualIdentifier":"cdb:7:308730507:CS:07033520059067543501001","legacyAttributes":{"customerNumber":"0703352","relationshipCode":"SP"},"organizationType":{"code":""},"personName":{"firstName":"AJLA","lastName":"ISBELL","middleName":"","suffix":""},"postalAddresses":[{"addressType":{"code":"M"},"beginDate":"2020-05-15","endDate":null,"isoCountry":{"code":"US"},"line1Text":"10700 CAPRI DRIVE","line2Text":"","postalCode":"75072","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":false,"stateProvinceCode":"TX","townName":"MC KINNEY"},{"addressType":{"code":"P"},"beginDate":"2020-05-15","endDate":null,"isoCountry":{"code":"US"},"line1Text":"10700 CAPRI DRIVE","line2Text":"","postalCode":"75072","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":true,"stateProvinceCode":"TX","townName":"MC KINNEY"}],"primeDependentCode":"","researchAuthorizationIndicator":false,"socialSecurityNumber":"633545465","sourceSystemAttributes":{"cdb":{"consumerId":308730507,"customerAccountIdentifier":"0703352","familyPartitionNumber":262,"migratedMemberships":null,"partitionNumber":7,"referenceData":{"subscriberRelationshipTypeCode":"001"},"spclProcHndlCd":"0","xrefId":665137059}},"sourceSystemCode":"CDB"},"memberships":[{"active":true,"cancelReasonType":null,"claimSystemType":{"code":"01"},"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"A","description":"ASO"},"customerAccountIdentifier":"0703352","obligor":{"code":"01"},"purchasePlanIdentifier":"cdb:CS:0703352:A:ACIS052","sharedArrangement":{"code":"00"}},"customerAccountIdentifier":"0703352","divisionCode":"","effectiveDate":"2019-01-01","eligibilityGracePeriodThruDate":"9999-12-31","eligibilitySystemType":{"code":"01"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":{"code":""},"stateIssueCode":"MN"},"marketSegment":null,"marketType":{"code":"50"},"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":"0042577","organization":{"planVariationCode":"0169","reportingCode":"0169"},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":{"code":""},"healthCoverageType":{"description":"PHYSICAL HEALTH"},"serviceType":{"code":"A"}},"recordType":"HEALTH_COVERAGE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"0703352","legacyProductCode":"","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"3","coverageTypeCode":"A"}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:14:150792174:CS:07033520059067543500001","terminationDate":"9999-12-31"}]},{"sourceIndividual":{"active":true,"alternateIdentifiers":{"alternateIds":[{"identifier":"913868524"}],"alternateSubscriberId":"913868524","employerAssignedIds":[{"identifier":"900130"}],"enterpriseIndividualIdentifier":"1072715605","familyId":233820262,"legacyMemberIds":null,"medicaidRecipientNumbers":null,"memberAlternateIds":null,"memberFamilyLinkIds":null,"memberId":"","memberReplacementIds":null,"priorMemberIds":null,"sourceSystemIds":[{"identifier":"07033520059067543502001"}],"subscriberIds":[{"identifier":"00590675435"}],"survivingSpouseIds":null,"mbiNumber":null,"hicNumber":null,"medicaidRecipientNumber":null,"survivingSpouseId":null},"birthSequenceNumber":"001","demographicInfo":{"birthDate":"2019-12-24","ethnicity":null,"genderType":{"code":"F"}},"eligibilityAttributes":{"enrolleeMemberFacingIdentifier":"","relationshipType":{"description":"Child"},"subscriberMemberFacingIdentifier":"00590675435"},"enrolleeSourceCode":"CS","enrolleeSourceId":"07033520059067543502001","individualIdentifier":"cdb:9:327297029:CS:07033520059067543502001","legacyAttributes":{"customerNumber":"0703352","relationshipCode":"CH"},"organizationType":{"code":""},"personName":{"firstName":"LEIA","lastName":"ISBELL","middleName":"K","suffix":""},"postalAddresses":[{"addressType":{"code":"M"},"beginDate":"2020-05-18","endDate":null,"isoCountry":{"code":"US"},"line1Text":"10700 CAPRI DRIVE","line2Text":"","postalCode":"75072","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":false,"stateProvinceCode":"TX","townName":"MC KINNEY"},{"addressType":{"code":"P"},"beginDate":"2020-05-18","endDate":null,"isoCountry":{"code":"US"},"line1Text":"10700 CAPRI DRIVE","line2Text":"","postalCode":"75072","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":true,"stateProvinceCode":"TX","townName":"MC KINNEY"}],"primeDependentCode":"","researchAuthorizationIndicator":false,"socialSecurityNumber":"000000000","sourceSystemAttributes":{"cdb":{"consumerId":327297029,"customerAccountIdentifier":"0703352","familyPartitionNumber":262,"migratedMemberships":null,"partitionNumber":9,"referenceData":{"subscriberRelationshipTypeCode":"002"},"spclProcHndlCd":"0","xrefId":714892986}},"sourceSystemCode":"CDB"},"memberships":[{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"A","description":"ASO"},"customerAccountIdentifier":"0703352","obligor":{"code":"01"},"purchasePlanIdentifier":null,"sharedArrangement":{"code":"00"}},"customerAccountIdentifier":"0703352","divisionCode":"","effectiveDate":"2019-12-24","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"01"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":"MN"},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"0169","reportingCode":"0169"},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"0703352","legacyProductCode":"IW","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"7","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:14:150792174:CS:07033520059067543500001","terminationDate":"9999-12-31"}]}],"eligibilityMetaData":{"totalResults":2}}');
            res.setStatusCode(200);
            return res;
        } 
    }
    @testSetup
    global static void dataSetup () {
        List<WebserviceConfigurations__c> webServ = new List<WebserviceConfigurations__c>();
        WebserviceConfigurations__c wc = new WebserviceConfigurations__c();
        wc.Name = 'CDB Authorization';
        wc.EndpointPath__c = 'https://api-stg.uhg.com/oauth2/token';
        wc.Headers__c = '[{"key": "Content-Type","value":"application/x-www-form-urlencoded"},{"key":"client_id","value":' +CLIENTID+'},{"key":"client_secret","value":' +CLIENTSECRET+ '}]';
        wc.Method__c = 'POST';
        wc.Active__c  = true;
        wc.JSONBodyWithMergeFields__c = 'grant_type=' +GRANTTYPE+'&client_id='+CLIENTID+'&client_secret='+CLIENTSECRET+'&scope=https://api.uhg.com/.default';
        webServ.add(wc);
        
        WebserviceConfigurations__c wc1 = new WebserviceConfigurations__c();
        wc1.Name = 'CDB User Service EID';
        wc1.EndpointPath__c = 'https://api-stg.uhg.com/api/identity/user/individuals/v1/read';
        wc1.Headers__c = '[{"key": "Content-Type","value":"application/json"},{"key":"consumername","value": "CHN"},{"key":"roles","value":"CHN"},{"key":"consumername","value": "CHN"},{"x-uhg-user-identifier":"roles","value":"eyJlaWQiOiIyMjY4NzE0MjAiLCJmaWRzIjpbXX0="}]';
        wc1.Method__c = 'POST';
        wc1.Active__c  = true;
        wc1.JSONBodyWithMergeFields__c = 'grant_type=' +GRANTTYPE+'&client_id='+CLIENTID+'&client_secret='+CLIENTSECRET+'&scope=https://api.uhg.com/.default';
        webServ.add(wc1);
        
        WebserviceConfigurations__c wc2 = new WebserviceConfigurations__c();
        wc2.Name = 'CDB User Service API With DOB';
        wc2.EndpointPath__c = 'https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        wc2.Headers__c = '[{"key": "Content-Type","value":"application/json"},{"key":"consumername","value": "CHN"},{"key":"roles","value":"CHN"},{"key":"consumername","value": "CHN"},{"x-uhg-user-identifier":"roles","value":"eyJlaWQiOiIyMjY4NzE0MjAiLCJmaWRzIjpbXX0="}]';
        wc2.Method__c = 'POST';
        wc2.Active__c  = true;
        wc2.JSONBodyWithMergeFields__c = '{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        webServ.add(wc2);
        
        WebserviceConfigurations__c wc3 = new WebserviceConfigurations__c();
        wc3.Name = 'CDB Member Search API';
        wc3.EndpointPath__c = 'https://api-stg.uhg.com/api/payer/member-eligibility/eligibilities/v4/search';
        wc3.Headers__c = '[{"key": "Content-Type","value":"application/json"},{"key":"consumername","value": "CHN"},{"key":"roles","value":"CHN"},{"key":"consumername","value": "CHN"},{"x-uhg-user-identifier":"roles","value":"eyJlaWQiOiIyMjY4NzE0MjAiLCJmaWRzIjpbXX0="}]';
        wc3.Method__c = 'POST';
        wc3.Active__c  = true;
        wc3.JSONBodyWithMergeFields__c = '{\n\"includeFamily\": true,\n\"includeInactive\": true\n}';
        webServ.add(wc3);
        insert webServ;
        
        for(WebserviceConfigurations__c webSrv:webServ){
            webServices.put(webSrv.name,webSrv);
        }
        CHN_Qualified_Data__c chnq = new CHN_Qualified_Data__c();
        chnq.CHN_Referral_Identifier__c = 'test';
        insert chnq;
        
        CHN_Members__c chnm = new CHN_Members__c();
        chnm.Optum_Segment_Id__c = '1234';
        insert chnm;
    }
    @isTest
    global static void getCDBDataTest(){
        /*CHN_Qualified_Data__c chnq = new CHN_Qualified_Data__c();
        chnq.CHN_Referral_Identifier__c = 'test';
        chnq.Subscriber_Member_ID__c = '23232323';
        chnq.First_Name__c = 'test';
        chnq.Last_Name__c = 'test';
        chnq.Date_of_Birth__c = system.today();
        insert chnq;*/
        
        CHN_Members__c chnm = new CHN_Members__c();
        chnm.Optum_Segment_Id__c = '1234';
        chnm.Pop_ID__c = 'POP45156';
        chnm.Member_ID__c  = '23232323';
        chnm.First_Name__c   = 'test';
        chnm.Last_Name__c   = 'test';
        chnm.Date_of_Birth__c   = system.today();
        insert chnm;
        set<string> str= new  set<string>();
        str.add('444454523232');
        test.startTest();
        
            
        try{
            ACETSNILinkMemberSearch.SearchResultWrapper result = new ACETSNILinkMemberSearch.SearchResultWrapper();
            Test.setMock(HttpCalloutMock.class, new tokenAccessMock());  
            result = CDB_ACETWebservice.getCDBData('23232323','1961-06-29', 'Test', 'Test', '1232', 'test', '2323232243');
            
            Date dt = system.today();
            String dob = String.valueof(dt);
            CDB_ACETWebservice.MemberQulificationCheck(str);
            CDB_ACETWebservice.MemberEligibilityCheck('23232323');
            String accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiI3NjZmZDBmZC1jYzM5LTQwZGYtODgyZi00ZDI5NDU5ZWY4MmMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vYzc1OTE1MWMtZGIyZC00YzdkLTkyMmYtNTgzMDg1OTFkMTk3L3YyLjAiLCJpYXQiOjE2NTI4NjM2MDUsIm5iZiI6MTY1Mjg2MzYwNSwiZXhwIjoxNjUyODY3NTA1LCJhaW8iOiJFMlpnWUZqRTlJbzF2OU1sdnNG';
            for(WebserviceConfigurations__c webSrv:[SELECT Id,Name,EndpointPath__c,Headers__c,Method__c,Active__c,JSONBodyWithMergeFields__c FROM WebserviceConfigurations__c]){
                webServices.put(webSrv.name,webSrv);
            }
            CDB_ACETWebservice.getUserInfo(true,webServices,accessToken,'23232323');
        }catch(exception ex){
            system.debug('exception in test class:' + ex.getMessage());
        }
        test.stopTest();
    }
    @isTest
    global static void getCDBDataTest1(){
        try{
            Test.setMock(HttpCalloutMock.class, new tokenAccessMock());  
            String accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiI3NjZmZDBmZC1jYzM5LTQwZGYtODgyZi00ZDI5NDU5ZWY4MmMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vYzc1OTE1MWMtZGIyZC00YzdkLTkyMmYtNTgzMDg1OTFkMTk3L3YyLjAiLCJpYXQiOjE2NTI4NjM2MDUsIm5iZiI6MTY1Mjg2MzYwNSwiZXhwIjoxNjUyODY3NTA1LCJhaW8iOiJFMlpnWUZqRTlJbzF2OU1sdnNG';
            for(WebserviceConfigurations__c webSrv:[SELECT Id,Name,EndpointPath__c,Headers__c,Method__c,Active__c,JSONBodyWithMergeFields__c FROM WebserviceConfigurations__c where Active__c=true]){
                webServices.put(webSrv.name,webSrv);
            }
            CDB_ACETWebservice.getUserInfoWithDOB(true,webServices,accessToken,'23232323','1961-06-29','test','test');
             CDB_ACETWebservice.getUserInfo(true,webServices,accessToken,'23232323');
        }catch(exception ex){
            system.debug('exception in test class:' + ex.getMessage());
        }

    }
    @isTest
    global static void getCDBDataTest2(){
        try{
            Test.setMock(HttpCalloutMock.class, new tokenAccessMock());  
            String accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiI3NjZmZDBmZC1jYzM5LTQwZGYtODgyZi00ZDI5NDU5ZWY4MmMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vYzc1OTE1MWMtZGIyZC00YzdkLTkyMmYtNTgzMDg1OTFkMTk3L3YyLjAiLCJpYXQiOjE2NTI4NjM2MDUsIm5iZiI6MTY1Mjg2MzYwNSwiZXhwIjoxNjUyODY3NTA1LCJhaW8iOiJFMlpnWUZqRTlJbzF2OU1sdnNG';
            for(WebserviceConfigurations__c webSrv:[SELECT Id,Name,EndpointPath__c,Headers__c,Method__c,Active__c,JSONBodyWithMergeFields__c FROM WebserviceConfigurations__c]){
                webServices.put(webSrv.name,webSrv);
            }
            CDB_ACETWebservice.getMemberInfo(true,webServices,'apiIdentifier',accessToken,1);
            CDB_ACETWebservice.createCDBStatusLog('test','test','test','test','200');
        }catch(exception ex){
            system.debug('exception in test class:' + ex.getMessage());
        }
    }
    @isTest
    global static void getCDBDataTest3(){
        test.startTest();
        try{
            String apiIdentifier = 'eyJlaWQiOiI0MTQ2Mjk3OSIsImZpZHMiOlt7ImlkIjoiMzU1Nzk1NDIzIiwic291cmNlQ0QiOiJDREJfQ1MifSx7ImlkIjoiNDQwMTQyNDUiLCJzb3VyY2VDRCI6IkNEQl9DUyJ9XSwiY3JpZHMiOltdLCJoaHNJZCI6bnVsbH0=';
            String accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiI3NjZmZDBmZC1jYzM5LTQwZGYtODgyZi00ZDI5NDU5ZWY4MmMiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vYzc1OTE1MWMtZGIyZC00YzdkLTkyMmYtNTgzMDg1OTFkMTk3L3YyLjAiLCJpYXQiOjE2NTI4NjM2MDUsIm5iZiI6MTY1Mjg2MzYwNSwiZXhwIjoxNjUyODY3NTA1LCJhaW8iOiJFMlpnWUZqRTlJbzF2OU1sdnNG';
            Test.setMock(HttpCalloutMock.class, new memberInfoMock());  
            for(WebserviceConfigurations__c webSrv:[SELECT Id,Name,EndpointPath__c,Headers__c,Method__c,Active__c,JSONBodyWithMergeFields__c FROM WebserviceConfigurations__c]){
                webServices.put(webSrv.name,webSrv);
            }
            CDB_ACETWebservice.createAppErrorLog('test','test','test','test',200);
            CDB_ACETWebservice.setWrapperData(apiIdentifier,true,webServices,accessToken,'','996858301');
        }catch(exception ex){
            system.debug('exception in test class:' + ex.getMessage());
        }
        test.stopTest();
    }
                        
                     
}