@IsTest
public class ACETLGT_IdCardRequestControllerTest {
    @testsetup
    static void prepareData(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c jwtTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StargateJWTTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(jwtTokenWSConfig.Id);
		System.debug(tokenAPIOrgSpecificConfigs);
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('SubmitFulfillmentRequestService', jwtTokenWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        System.debug(orgSpecificConfigs);
    }

    @IsTest
    Public static void cleanDate_InValid(){

        String dateValInvalid = ACETLGT_IdCardRequestController.cleanDate('0/0/0000');

        System.assertEquals(dateValInvalid , '00/00/0000');
    }

    @IsTest
    Public static void cleanDate_Valid(){

        String dateValValid = ACETLGT_IdCardRequestController.cleanDate('01/02/2019');

        System.assertEquals(dateValValid , '01/02/2019');
    }

    @IsTest
    Public static void testMethodCallout(){
        String ordHistStartdate = '2019-01-22';
        String ordHistEnddate = '2020-01-21';
        String selectedFamilyId = '97161070000';

        ACETLGT_FormsHistoryWebService formsHistoryWebService = new ACETLGT_FormsHistoryWebService();
                
        formsHistoryWebService.init('ACET',Integer.ValueOf(label.ACETIDCardDocumentType),ordHistStartdate,ordHistEnddate,String.valueOf(selectedFamilyId),'MemberID');
                
        ACETWSCalloutResult searchResult =  formsHistoryWebService.queryPaginatedData(1,1,1);
    }

    @IsTest
    Public static void formatDate_Valid(){

        ACETLGT_FormsHistoryWebService acetFrmsHisWebServ=new ACETLGT_FormsHistoryWebService();
        acetFrmsHisWebServ.init();
        acetFrmsHisWebServ.init('testSrcID',1,'testStDate','testEndDate','testRecID','testQualiID');
        acetFrmsHisWebServ.formatDatetime('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatDatetime('2017-07-08');
        acetFrmsHisWebServ.FormatRecpt('testrecep');
        acetFrmsHisWebServ.formatStartDate('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatStartDate('2017-07T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07/08T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07T12:00:00Z');
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        acetFrmsHisWebServ.init();
        ACETFormsHistoryResult objACETFormsHistoryResult = new ACETFormsHistoryResult();

    }

    @IsTest
    Public static void LightningcallfamMemMethod()
    {
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User memberAgent;
         System.runAs(thisUser){
        list<ACETRelationshipCodes__c> rCodes = new list<ACETRelationshipCodes__c> ();
            rCodes.add(new ACETRelationshipCodes__c (Name = '18',Description__c = 'Self'));
            rCodes.add(new ACETRelationshipCodes__c (Name = '01',Description__c = 'Spouse'));
            rCodes.add(new ACETRelationshipCodes__c (Name = '19',Description__c = 'Child'));
            insert rCodes;
        
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
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        //List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       	
        //	Error flow : without mock
        ACETLGT_IdCardRequestController.getFamilyMembershipResults('654651892','1168520','10/01/2018','97161070000');
        
        //	success flow
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"492265628","name":{"firstName":"MACKENZIE","lastName":"ONORATI","middleName":"","nameSuffix":""},"birthDate":"2012-04-12","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"802876040","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"4083 56TH AVE NE","addressLine2":"","city":"STAMFORD","postalCode":"06922","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1168520","groupName":"GRAHAM CAPITAL MANAGEMENT LP","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"MNS0000003","benefitPlanName":"Graham Cap Mgt - KACTOHP61R - NON-63055","benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"97161070003","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000037","benefitPlanName":"LG $5/$25/$40","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"97161070003","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"492265628","type":"enrolleeEID"},{"id":"100000031216","type":"subscriberSystemId"},{"id":"100000031242","type":"enrolleeSystemID"},{"id":"654651892","type":"subscriberSurrogateKey"},{"id":"654651883","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"492293043","name":{"firstName":"TRANG","lastName":"ONORATI","middleName":"","nameSuffix":""},"birthDate":"2013-10-15","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"314975443","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"4083 56TH AVE NE","addressLine2":"","city":"STAMFORD","postalCode":"06922","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1168520","groupName":"GRAHAM CAPITAL MANAGEMENT LP","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"MNS0000003","benefitPlanName":"Graham Cap Mgt - KACTOHP61R - NON-63055","benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"97161070004","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000037","benefitPlanName":"LG $5/$25/$40","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"97161070004","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"492293043","type":"enrolleeEID"},{"id":"100000031216","type":"subscriberSystemId"},{"id":"100000031245","type":"enrolleeSystemID"},{"id":"654651892","type":"subscriberSurrogateKey"},{"id":"654679255","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"492280979","name":{"firstName":"TAMA","lastName":"ONORATI","middleName":"","nameSuffix":""},"birthDate":"1977-02-24","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"4083 56TH AVE NE","addressLine2":"","city":"STAMFORD","postalCode":"06922","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1168520","groupName":"GRAHAM CAPITAL MANAGEMENT LP","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"MNS0000003","benefitPlanName":"Graham Cap Mgt - KACTOHP61R - NON-63055","benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"97161070001","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000037","benefitPlanName":"LG $5/$25/$40","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"97161070001","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"492280979","type":"enrolleeEID"},{"id":"100000031216","type":"subscriberSystemId"},{"id":"100000031231","type":"enrolleeSystemID"},{"id":"654651892","type":"subscriberSurrogateKey"},{"id":"654667179","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"492265644","name":{"firstName":"SOILA","lastName":"ONORATI","middleName":"","nameSuffix":""},"birthDate":"2011-02-01","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"047171607","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"4083 56TH AVE NE","addressLine2":"","city":"STAMFORD","postalCode":"06922","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1168520","groupName":"GRAHAM CAPITAL MANAGEMENT LP","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"MNS0000003","benefitPlanName":"Graham Cap Mgt - KACTOHP61R - NON-63055","benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"97161070002","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000037","benefitPlanName":"LG $5/$25/$40","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"97161070002","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"492265644","type":"enrolleeEID"},{"id":"100000031216","type":"subscriberSystemId"},{"id":"100000031236","type":"enrolleeSystemID"},{"id":"654651892","type":"subscriberSurrogateKey"},{"id":"654651860","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"492265646","name":{"firstName":"LORINA","lastName":"ONORATI","middleName":"","nameSuffix":""},"birthDate":"1979-08-27","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"056628382","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"4083 56TH AVE NE","addressLine2":"","city":"STAMFORD","postalCode":"06922","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1168520","groupName":"GRAHAM CAPITAL MANAGEMENT LP","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"MNS0000003","benefitPlanName":"Graham Cap Mgt - KACTOHP61R - NON-63055","benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"97161070000","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1738484","benefitBundleOptionDescription":"","benefitEffectiveDate":"2018-10-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000037","benefitPlanName":"LG $5/$25/$40","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000006"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"97161070000","subscriberIdCardSerialNumber":"97161070000","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2018-10-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{"providerIdentifiers":[{"id":"P4152441","type":"PUL"},{"id":"D400002428","type":"1C"},{"id":"D400054474","type":"1C"},{"id":"832901320","type":"SSN"},{"id":"1441688","type":"MPI"},{"id":"P4416275","type":"PUL"},{"id":"1669542999","type":"NPI"},{"id":"831446190354151913","type":"LTK"}],"assignmentType":"OBGYN","effectiveDate":"2018-10-01","expirationDate":"9999-12-31","firstName":"CAROL","lastName":"FUCIGNA","networkId":"7","organizationLocationId":"0","locationAffiliationId":"39421107","address1":"1351 WASHINGTON BLVD","address2":"","address3":"","address4":"","address5":"","city":"STAMFORD","state":"CT","postalCode":"06902-2419","country":"US"},{"providerIdentifiers":[{"id":"603408","type":"1C"},{"id":"494146193657144226","type":"LTK"},{"id":"1457350522","type":"NPI"},{"id":"1260481","type":"MPI"},{"id":"P5517882","type":"PUL"},{"id":"750922259","type":"SSN"}],"assignmentType":"PCP","effectiveDate":"2019-09-06","expirationDate":"9999-12-31","firstName":"TODD","lastName":"AARON","networkId":"7","organizationLocationId":"0","locationAffiliationId":"37312757","address1":"850 PAPER MILL RD","address2":"","address3":"","address4":"","address5":"","city":"GLENSIDE","state":"PA","postalCode":"19038-7833","country":"US"}],"identifiers":[{"id":"492265646","type":"enrolleeEID"},{"id":"100000031216","type":"subscriberSystemId"},{"id":"100000031216","type":"enrolleeSystemID"},{"id":"654651892","type":"subscriberSurrogateKey"},{"id":"654651892","type":"enrolleeSurrogateKey"}]}]}]}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
                }                                                                                                           
         System.runAs(memberAgent){
            Test.startTest();
            ACETLGT_IdCardRequestController updmem= new ACETLGT_IdCardRequestController(); 
            ACETLGT_IdCardRequestController.getFamilyMembershipResults('654651892','1168520','10/01/2018','97161070000');
        	Test.stopTest();
            
        }
        
    }
                                                                                                                              
    


    @IsTest
    Public static void LightningcallfamMemHistoryMethod()
    {
        User memberAgent = TestDataFactory.getUser('ACET Member'); 
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
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findFulfillmentHistoryResult":{"findFulfillmentHistoryResponse":{"searchParameter":{"searchSourceID":"ACET","fulfillmentType":"10600","rangeStartEventReceivedDate":"01/22/2019","rangeEndEventReceivedDate":"01/22/2020","recipientID":"97161070000","idQualifier":"MemberID"},"searchResultSet":[{"responseRequestHeader":{"requestID":"CIRRUS43afb57a-b843-4a3b-9956-4e0440aa5651","sourceIDName":"CIRRUS","requestDate":"2019-09-06T13:21:00.583-05:00","businessSegmentName":"EI","marketSegmentName":"OXF","fulfillmentTypeBusName":"10600","requestCategory":"TransactionalInlineDataOnly","dataFormat":"JSON","requestorRefNo":"43afb57a-b843-4a3b-9956-4e0440aa5651","requestTrailer":{"requestItemCount":1}},"responseCurrentEventLog":{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-09-07T00:31:10.743-05:00","statusCode":"Rejected"},"responseRequestDetail":{"responseTransactionalRequestDetail":{"responseRecipient":[{"recipientId":"97161070000","identifierQualifierCodeDescr":"MemberID","deliveryMethod1":"Mailed","person":{"firstName":"LORINA","lastName":"ONORATI"},"MailToAddress":{"Address1":"4083 56TH AVE NE","City":"STAMFORD","State":"CT","Zip":"06922"},"ReturnToAddress":{"Address1":"11000 Optum Circle","City":"Eden Prairie","State":"MN","Zip":"55344"},"carbonCopyInd":false}],"responseTemplate":{"templateID":"IDC_818181","templateName":"ID CARD"}}},"responseRequestHistory":[{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-09-07T00:31:10.743-05:00","recipientId":"97161070000","deliveryMethodCd":"Mailed","statusCode":"Accepted","successCount":"1","exceptionCount":"0"}]},{"responseRequestHeader":{"requestID":"CIRRUS34aa2b8f-b5fa-42e3-8056-99a7bd943aee","sourceIDName":"CIRRUS","requestDate":"2019-08-26T10:25:00.484-05:00","businessSegmentName":"EI","marketSegmentName":"OXF","fulfillmentTypeBusName":"10600","requestCategory":"TransactionalInlineDataOnly","dataFormat":"JSON","requestorRefNo":"34aa2b8f-b5fa-42e3-8056-99a7bd943aee","requestTrailer":{"requestItemCount":1}},"responseCurrentEventLog":{"processorName":"MC","eventTypeBusName":"Document Fulfilled","receivedDate":"2019-08-27T00:30:03.871-05:00","statusCode":"Accepted"},"responseRequestDetail":{"responseTransactionalRequestDetail":{"responseRecipient":[{"recipientId":"97161070000","identifierQualifierCodeDescr":"MemberID","deliveryMethod1":"Mailed","person":{"firstName":"LORINA","lastName":"ONORATI"},"MailToAddress":{"Address1":"4083 56TH AVE NE","City":"STAMFORD","State":"CT","Zip":"06922"},"ReturnToAddress":{"Address1":"11000 Optum Circle","City":"Eden Prairie","State":"MN","Zip":"55344"},"carbonCopyInd":false}],"responseTemplate":{"templateID":"IDC_818181","templateName":"ID CARD"}}},"responseRequestHistory":[{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-08-27T00:30:03.871-05:00","recipientId":"97161070000","deliveryMethodCd":"Mailed","statusCode":"Accepted","successCount":"1","exceptionCount":"0"}]},{"responseRequestHeader":{"requestID":"CIRRUS22566f8c-3d14-41ff-85fc-810899c799fb","sourceIDName":"CIRRUS","requestDate":"2019-08-23T17:08:00.686-05:00","businessSegmentName":"EI","marketSegmentName":"OXF","fulfillmentTypeBusName":"10600","requestCategory":"TransactionalInlineDataOnly","dataFormat":"JSON","requestorRefNo":"22566f8c-3d14-41ff-85fc-810899c799fb","requestTrailer":{"requestItemCount":1}},"responseCurrentEventLog":{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-08-24T00:30:24.447-05:00","statusCode":"Accepted"},"responseRequestDetail":{"responseTransactionalRequestDetail":{"responseRecipient":[{"recipientId":"97161070000","identifierQualifierCodeDescr":"MemberID","deliveryMethod1":"Mailed","person":{"firstName":"LORINA","lastName":"ONORATI"},"MailToAddress":{"Address1":"4083 56TH AVE NE","City":"STAMFORD","State":"CT","Zip":"06922"},"ReturnToAddress":{"Address1":"11000 Optum Circle","City":"Eden Prairie","State":"MN","Zip":"55344"},"carbonCopyInd":false}],"responseTemplate":{"templateID":"IDC_818181","templateName":"ID CARD"}}},"responseRequestHistory":[{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-08-24T00:30:24.447-05:00","recipientId":"97161070000","deliveryMethodCd":"Mailed","statusCode":"Accepted","successCount":"1","exceptionCount":"0"}]}]}}}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        System.runAs(memberAgent){
            Test.startTest();
            ACETLGT_IdCardRequestController updmem= new ACETLGT_IdCardRequestController(); 
            ACETLGT_IdCardRequestController.getFamilyMemberHistory('2019-01-22','2020-01-20','97161070000');
        	Test.stopTest();
            
        }
        
    }
   
@IsTest
    Public static void LightningcallfamMemHistoryMethod2()
    {
        User memberAgent = TestDataFactory.getUser('ACET Member'); 
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
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findFulfillmentHistoryResult":{"findFulfillmentHistoryResponse":{"searchParameter":{"searchSourceID":"ACET","fulfillmentType":"10600","rangeStartEventReceivedDate":"01/22/2019","rangeEndEventReceivedDate":"01/22/2020","recipientID":"97161070000","idQualifier":"MemberID"},"searchResultSet":[{"responseRequestHeader":{"requestID":"CIRRUS43afb57a-b843-4a3b-9956-4e0440aa5651","sourceIDName":"CIRRUS","requestDate":"2019-09-06T13:21:00.583-05:00","businessSegmentName":"EI","marketSegmentName":"OXF","fulfillmentTypeBusName":"10600","requestCategory":"TransactionalInlinePrintReadySingleItem","dataFormat":"JSON","requestorRefNo":"43afb57a-b843-4a3b-9956-4e0440aa5651","requestTrailer":{"requestItemCount":1}},"responseCurrentEventLog":{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-09-07T00:31:10.743-05:00","statusCode":"Rejected"},"responseRequestDetail":{"responseTransactionalRequestDetail":{"responseRecipient":[{"recipientId":"97161070000","identifierQualifierCodeDescr":"MemberID","deliveryMethod1":"Mailed","person":{"firstName":"LORINA","lastName":"ONORATI"},"MailToAddress":{"Address1":"4083 56TH AVE NE","City":"STAMFORD","State":"CT","Zip":"06922"},"ReturnToAddress":{"Address1":"11000 Optum Circle","City":"Eden Prairie","State":"MN","Zip":"55344"},"carbonCopyInd":false}],"responseTemplate":{"templateID":"IDC_818181","templateName":"ID CARD"}}},"responseRequestHistory":[{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-09-07T00:31:10.743-05:00","recipientId":"97161070000","deliveryMethodCd":"Mailed","statusCode":"Accepted","successCount":"1","exceptionCount":"0"}]},{"responseRequestHeader":{"requestID":"CIRRUS34aa2b8f-b5fa-42e3-8056-99a7bd943aee","sourceIDName":"CIRRUS","requestDate":"2019-08-26T10:25:00.484-05:00","businessSegmentName":"EI","marketSegmentName":"OXF","fulfillmentTypeBusName":"10600","requestCategory":"TransactionalInlineDataOnly","dataFormat":"JSON","requestorRefNo":"34aa2b8f-b5fa-42e3-8056-99a7bd943aee","requestTrailer":{"requestItemCount":1}},"responseCurrentEventLog":{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-08-27T00:30:03.871-05:00","statusCode":"Accepted"},"responseRequestDetail":{"responseTransactionalRequestDetail":{"responseRecipient":[{"recipientId":"97161070000","identifierQualifierCodeDescr":"MemberID","deliveryMethod1":"Mailed","person":{"firstName":"LORINA","lastName":"ONORATI"},"MailToAddress":{"Address1":"4083 56TH AVE NE","City":"STAMFORD","State":"CT","Zip":"06922"},"ReturnToAddress":{"Address1":"11000 Optum Circle","City":"Eden Prairie","State":"MN","Zip":"55344"},"carbonCopyInd":false}],"responseTemplate":{"templateID":"IDC_818181","templateName":"ID CARD"}}},"responseRequestHistory":[{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-08-27T00:30:03.871-05:00","recipientId":"97161070000","deliveryMethodCd":"Mailed","statusCode":"Accepted","successCount":"1","exceptionCount":"0"}]},{"responseRequestHeader":{"requestID":"CIRRUS22566f8c-3d14-41ff-85fc-810899c799fb","sourceIDName":"CIRRUS","requestDate":"2019-08-23T17:08:00.686-05:00","businessSegmentName":"EI","marketSegmentName":"OXF","fulfillmentTypeBusName":"10600","requestCategory":"TransactionalInlineDataOnly","dataFormat":"JSON","requestorRefNo":"22566f8c-3d14-41ff-85fc-810899c799fb","requestTrailer":{"requestItemCount":1}},"responseCurrentEventLog":{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-08-24T00:30:24.447-05:00","statusCode":"Accepted"},"responseRequestDetail":{"responseTransactionalRequestDetail":{"responseRecipient":[{"recipientId":"97161070000","identifierQualifierCodeDescr":"MemberID","deliveryMethod1":"Mailed","person":{"firstName":"LORINA","lastName":"ONORATI"},"MailToAddress":{"Address1":"4083 56TH AVE NE","City":"STAMFORD","State":"CT","Zip":"06922"},"ReturnToAddress":{"Address1":"11000 Optum Circle","City":"Eden Prairie","State":"MN","Zip":"55344"},"carbonCopyInd":false}],"responseTemplate":{"templateID":"IDC_818181","templateName":"ID CARD"}}},"responseRequestHistory":[{"processorName":"MC","eventTypeBusName":"ReceivedPending","receivedDate":"2019-08-24T00:30:24.447-05:00","recipientId":"97161070000","deliveryMethodCd":"Mailed","statusCode":"Accepted","successCount":"1","exceptionCount":"0"}]}]}}}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        System.runAs(memberAgent){
            Test.startTest();
            ACETLGT_IdCardRequestController hist= new ACETLGT_IdCardRequestController(); 
            ACETLGT_IdCardRequestController.getFamilyMemberHistory('2019-01-22','2020-01-20','97161070000');
        	Test.stopTest();
            
        }
        
    }
   
    @isTest static void testSubmitOrder() {
        Test.startTest();
        ACETLGT_IdCardRequestController.SubmitOrderResponse resp = ACETLGT_IdCardRequestController.submitOrder('937723200', '034234332', '13243545');
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(201, 'OK', '{"externalCorrelationID":"12234444444"}}');        
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
		resp = ACETLGT_IdCardRequestController.submitOrder('937723200', '034234332', '13243545');
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '{"externalCorrelationID":"12234444444"}}');        
        OILResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes2);
		resp = ACETLGT_IdCardRequestController.submitOrder('937723200', '034234332', '13243545');
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(429, 'OK', '{"externalCorrelationID":"12234444444"}}');        
        OILResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
        Test.setMock(HttpCalloutMock.class, MockHttpRes3);
		resp = ACETLGT_IdCardRequestController.submitOrder('937723200', '034234332', '13243545');
        Test.stopTest();
	}
                                                                                                                              
	@isTest static void testFindDocument() {
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindDocWebserviceResponse());
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);
        Test.startTest();
        	ACETLGT_IdCardRequestController.findDocWrapper wrapper = ACETLGT_IdCardRequestController.findDocument('["sdf,sfd", "sds,hhh", "ff,dsf","sfsdf,ferd"]');
        Test.stopTest();
    }
                                                                                                                              
    @isTest static void testUtils() {
    	ACETLGT_IdCardRequestController.findDocWrapper docWrap = new ACETLGT_IdCardRequestController.findDocWrapper();
        docWrap.documentId = '098766544332';
        ACETLGT_IdCardRequestController.FormHistoryResultMapWrapper formWrap = new ACETLGT_IdCardRequestController.FormHistoryResultMapWrapper();
        formWrap.formHistoryResultMap = new Map<String, List<ACETLGT_FormsHistoryResult>>();
    }

}