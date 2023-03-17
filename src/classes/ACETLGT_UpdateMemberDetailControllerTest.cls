@isTest
public class ACETLGT_UpdateMemberDetailControllerTest{
  @IsTest
    Public static void LightningupdateMemMethod()
    {
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User memberAgent;
         System.runAs(thisUser){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c = true;
        update starTokenAPIOrgSpecificConfigs;
        
        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('updateIndividualMembershipService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c = true;
        update orsorgSpecificConfigs;
        
        WebserviceConfigurations__c orswsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('getIndividualMembershipService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig2.Id);
        
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
             mapISLWSConfigs.put('dev_updateIndividual', '/api/alpha/eisl/individuals/membership/v2.0/update');           
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"UpdateIndividualMembershipResponse":{"response":{"responseCode":"200","responseDesc":" STS0003-Member: Member ID: 100001553415: Record(s) updated.-"}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
         }
         System.runAs(memberAgent){
            Test.startTest();
               ACETLGT_UpdateMemberDetailController updmem= new ACETLGT_UpdateMemberDetailController(); 
       
            List<ACETLGT_MemberSearchCoveragesResult.Phone> PhoneList = new List<ACETLGT_MemberSearchCoveragesResult.Phone>();
        ACETLGT_MemberSearchCoveragesResult.Phone phoneitem = new ACETLGT_MemberSearchCoveragesResult.Phone();
        phoneitem.PhoneNumberType = 'W'; 
        phoneitem.primaryIndicator ='Yes';
        phonelist.add(phoneitem );
        
            ACETLGT_UpdateMemberDetailController.updateMemberDetail('12345678900','12345678900','1234567','lName','fName','mName','','123456789','M','01/01/1990','18', 'Primary', 'abc@gmail.com', PhoneList);
        Test.stopTest();
            
        }
        
    }

@IsTest
    Public static void LightningupdateMemberMethod()
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
            mapISLWSConfigs.put('dev_updateIndividual', '/api/alpha/eisl/individuals/membership/v2.0/update');           
             mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c = true;
        update starTokenAPIOrgSpecificConfigs;
        
        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('updateIndividualMembershipService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c = true;
        update orsorgSpecificConfigs;
        
        WebserviceConfigurations__c orswsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('getIndividualMembershipService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig2.Id);
        
          MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"562368928","name":{"firstName":"GeorgeMom","lastName":"Delgado","middleName":"","nameSuffix":"Jr"},"birthDate":"1973-08-09","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"040765431","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","holdEligInd":"false","address":[{"typeCode":"HOM","addressLine1":"9303 Lyon Drive","addressLine2":"Lyon Estates","city":"ARLETA","postalCode":"91331","stateCode":"CA","countryCode":"US"},{"typeCode":"WRK","addressLine1":"Test Street3","addressLine2":"Test Street4","city":"CALIFORNIA","postalCode":"20619","stateCode":"MD","countryCode":"US"},{"typeCode":"MAIL","addressLine1":"Test Street","addressLine2":"Test Street2","city":"CALLAWAY","postalCode":"20620","stateCode":"MD","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"788-978-4051","phoneExt":"99899111","internationalIndicator":"N","primaryIndicator":"N"},{"phoneType":"F","phoneNumber":"979-797-9797","phoneExt":"123","internationalIndicator":"N","primaryIndicator":"Y"},{"phoneType":"M","phoneNumber":"530-555-4242","phoneExt":"","internationalIndicator":"N","primaryIndicator":"N"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"test_user1@email.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2020-01-01","retirementDate":"9999-12-31"}],"language":[{"languageCode":"AFA","languageUsedTypeCode":"5","languageUsedTypeDescription":"Language_Reading"},{"languageCode":"APA","languageUsedTypeCode":"7","languageUsedTypeDescription":"Language_Speaking"}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"722101868","type":"SRK"}]}}}');
         OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
         }
        
        System.runAs(memberAgent){
            Test.startTest();
            ACETLGT_UpdateMemberDetailController.getSearchResults('test');
                ACETLGT_UpdateMemberDetailController  groupmem= new ACETLGT_UpdateMemberDetailController (); 
        List<ACETLGT_MemberSearchCoveragesResult.Phone> PhoneList = new List<ACETLGT_MemberSearchCoveragesResult.Phone>();
        /*ACETLGT_MemberSearchCoveragesResult.Phone phoneitem = new ACETLGT_MemberSearchCoveragesResult.Phone();
        phoneitem.PhoneNumberType = 'W'; 
        phoneitem.primaryIndicator ='Yes';
        phonelist.add(phoneitem );*/
        
        ACETLGT_UpdateMemberDetailController.updateMemberDetail('12345678900','12345678900','1234567','lName','fName','mName','','123456789','M','01/01/1990','18', 'Primary', 'abc@gmail.com', PhoneList);
        Test.stopTest();
            
        }
        
    }
     @IsTest
    Public static void LightningupdateMemMethodErr()
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
             mapISLWSConfigs.put('dev_updateIndividual', '/api/alpha/eisl/individuals/membership/v2.0/update');           
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'OK', '{"UpdateIndividualMembershipResponse":{"response":{"responseCode":404","responseDesc":" Error"}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        List<ACETLGT_MemberSearchCoveragesResult.Phone> PhoneList = new List<ACETLGT_MemberSearchCoveragesResult.Phone>();
        ACETLGT_MemberSearchCoveragesResult.Phone phoneitem = new ACETLGT_MemberSearchCoveragesResult.Phone();
        phoneitem.PhoneNumberType = 'W'; 
        phoneitem.primaryIndicator ='Yes';
        phonelist.add(phoneitem );
        
        System.runAs(memberAgent){
            Test.startTest();
               // ACETLGT_UpdateMemberDetailController updmem= new ACETLGT_UpdateMemberDetailController(); 
       		ACETLGT_UpdateMemberDetailController.updateMemberDetail('12345678900','12345678900','1234567','lName','fName','mName','','123456789','M','01/01/1990','18', 'Email', '', null);
            ACETLGT_UpdateMemberDetailController.getSearchResults(null);
            Test.stopTest();
            
        }
        
    }
         @IsTest
    Public static void LightningupdateMemMethodpcp()
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
             mapISLWSConfigs.put('dev_updateIndividual', '/api/alpha/eisl/individuals/membership/v2.0/update');           
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"UpdateIndividualMembershipResponse":{"response":{"responseCode":404","responseDesc":" Error"}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        List<ACETLGT_MemberSearchCoveragesResult.Phone> PhoneList = new List<ACETLGT_MemberSearchCoveragesResult.Phone>();
        ACETLGT_MemberSearchCoveragesResult.Phone phoneitem = new ACETLGT_MemberSearchCoveragesResult.Phone();
        phoneitem.PhoneNumberType = 'W'; 
        phoneitem.primaryIndicator ='Yes';
        phonelist.add(phoneitem );
        
        System.runAs(memberAgent){
            Test.startTest();
                ACETLGT_UpdateMemberDetailController updmem= new ACETLGT_UpdateMemberDetailController(); 
       		ACETLGT_UpdateMemberDetailController.updateMemberDetail('12345678900','12345678900','1234567','lName','fName','mName','','123456789','M','01/01/1990','18', 'Email', '', PhoneList);
            Test.stopTest();
            
        }
        
    }
     @IsTest
    Public static void LightningupdateMemIndMethod()
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
             mapISLWSConfigs.put('dev_GetIndividualEndpoint', '/api/alpha/eisl/individuals/v2.0/read');           
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"493142896","name":{"firstName":"Maynard","lastName":"Moss","middleName":"","nameSuffix":""},"birthDate":"1960-09-14","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"767626350","maritalStatusCode":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"123 Annie Road","addressLine2":"","city":"HOLTSVILLE","postalCode":"00501","stateCode":"NY","countryCode":"US"}],"phone":[{"phoneType":"W","phoneNumber":"732-656-6591","phoneExt":"1234","internationalIndicator":"N","primaryIndicator":"Y"},{"phoneType":"H","phoneNumber":"732-656-6591","phoneExt":"","internationalIndicator":"N","primaryIndicator":"N"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"maynard@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2019-01-01","retirementDate":"9999-12-31"}],"language":[{"languageCode":"ENG","languageUsedTypeCode":"5","languageUsedTypeDescription":"Language_Reading"}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"660492642","type":"SRK"}]}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        System.runAs(memberAgent){
            Test.startTest();
                
            //Setting relationship codes        
        list<ACETRelationshipCodes__c> rCodes = new list<ACETRelationshipCodes__c> ();
        rCodes.add(new ACETRelationshipCodes__c (Name = '18',Description__c = 'Self'));
        rCodes.add(new ACETRelationshipCodes__c (Name = '01',Description__c = 'Spouse'));
        rCodes.add(new ACETRelationshipCodes__c (Name = '19',Description__c = 'Child'));
        insert rCodes;      
       
            ACETLGT_UpdateMemberDetailController updmem= new ACETLGT_UpdateMemberDetailController(); 
       		
            ACETLGT_UpdateMemberDetailController.getSearchResults('654651892');
            ACETLGT_UpdateMemberDetailController.getSearchResults('1');
            Test.stopTest();
            
        }
        
    }
    
    static testMethod void updateMembersProcessButton()
    {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c = true;
        update starTokenAPIOrgSpecificConfigs;
        
        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('updateIndividualMembershipService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c = true;
        update orsorgSpecificConfigs;
        
        
        Test.startTest();
        
        String json = '{"UpdateIndividualMembershipResponse":{"response":{"responseCode":"200","responseDesc":" STS0001-Member Investigation: Member Investigation ID: 28019336: Record(s) added.- STS0003-Member: Member ID: 100000477226: Record(s) updated.- WRN12007-Member: Member ID: 100000477226: SSN Status: WARNING: Record received cannot update record on system when SSN type is satisfied.-"}}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', json);
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        String reqbody = '{"cobData":true,"groupNumber":1260145,"subscriberIDCardSerialNumber":"96432336200","memberIDCardSerialNumber":96432336201,"lastName":"Delgado","firstName":"GeorgeChild","middleName":"","nameSuffix":"","socialSecurityNumber":"040770771","gender":"M","birthDate":"2002-04-25","relationShipCode":"19","otherInsuranceIndicator":"N","otherInsuranceCoverageType":"2","otherInsuranceEffectiveStartDate":"2021-05-05","otherInsuranceEndDate":"2022-12-31","otherInsuranceVerificationDate":"","custodyCode":"","otherInsurancePolicyNumber":"12345","otherInsuranceType":"MD","primacyIndicator":"T","otherInsuranceCardholderFirstName":"","otherInsuranceCardholderLastName":"","medicareIndicator":"Y","entitlementType":"MedicareA","entitlementTypeReason":"0"}';
        String addressBody = '[{"addressTypeCode":"Home","addressLine1":"9303 Lyon Drive","addressLine2":"Lyon Estates","city":"ARLETA","stateCode":"CA","postalCode":"91331"},{"addressTypeCode":"Work","addressLine1":"Test Street3","addressLine2":"Test Street4","city":"CALIFORNIA","stateCode":"MD","postalCode":"20619"},{"addressTypeCode":"Mailing","addressLine1":"Test Street","addressLine2":"Test Street2","city":"CALLAWAY","stateCode":"MD","postalCode":"20620"}]';
        ACETLGT_UpdateMemberDetailController.updateMemberDemographics(reqbody, addressBody);
   		ACETLGT_UpdateMemberDetailController.getStateValues();
        Test.stopTest();
    }
    
    static testMethod void updateMembersProcessButton1()
    {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c = true;
        update starTokenAPIOrgSpecificConfigs;
        
        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('updateIndividualMembershipService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c = true;
        update orsorgSpecificConfigs;
        
        
        Test.startTest();
        ACETLGT_WSCalloutResult updateResult = new ACETLGT_WSCalloutResult();
        String json = '{"UpdateIndividualMembershipResponse":{"response":{"responseCode":"400","responseDesc":" STS0001-Member Investigation: Member Investigation ID: 28019336: Record(s) added.- STS0003-Member: Member ID: 100000477226: Record(s) updated.- WRN12007-Member: Member ID: 100000477226: SSN Status: WARNING: Record received cannot update record on system when SSN type is satisfied.-"}}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', json);
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        String reqbody = '{"pcpId":"123456","cobData":false,"groupNumber":1260145,"subscriberIDCardSerialNumber":"96432336200","memberIDCardSerialNumber":96432336201,"lastName":"Delgado","firstName":"GeorgeChild","middleName":"","nameSuffix":"","socialSecurityNumber":"040770771","gender":"M","birthDate":"2002-04-25","relationShipCode":"19","otherInsuranceIndicator":"N","otherInsuranceCoverageType":"2","otherInsuranceEffectiveStartDate":"2021-05-05","otherInsuranceEndDate":"2022-12-31","otherInsuranceVerificationDate":"","custodyCode":"","otherInsurancePolicyNumber":"12345","otherInsuranceType":"MD","primacyIndicator":"T","otherInsuranceCardholderFirstName":"","otherInsuranceCardholderLastName":"","medicareIndicator":"Y","entitlementType":"MedicareA","entitlementTypeReason":"0"}';
        String addressBody = '[{"addressTypeCode":"Home","addressLine1":"9303 Lyon Drive","addressLine2":"Lyon Estates","city":"ARLETA","stateCode":"CA","postalCode":"91331"},{"addressTypeCode":"Work","addressLine1":"Test Street3","addressLine2":"Test Street4","city":"CALIFORNIA","stateCode":"MD","postalCode":"20619"},{"addressTypeCode":"Mailing","addressLine1":"Test Street","addressLine2":"Test Street2","city":"CALLAWAY","stateCode":"MD","postalCode":"20620"}]';
        
        ACETLGT_UpdateCOBDetails.UpdateCOBWrapper uCob = new ACETLGT_UpdateCOBDetails.UpdateCOBWrapper();
        ACETLGT_UpdateCOBDetails.updateMembers(reqbody,addressBody);
        updateResult.Message = 'Update Failed.';
        updateResult.Success = false;   
        updateResult.statusCode=208;
       Test.stopTest();
    }
    
}