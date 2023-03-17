@isTest
public class ACETLGT_UpdateCOBDetailsTest {
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
        ACETLGT_UpdateCOBDetails.updateMembers(reqbody, addressBody);
        
        String reqbody1 = '{"commCode":"45673","emailId":"abc@optum.com","cobData":true,"groupNumber":1260145,"subscriberIDCardSerialNumber":"96432336200","memberIDCardSerialNumber":96432336201,"lastName":"Delgado","firstName":"GeorgeChild","middleName":"","nameSuffix":"","socialSecurityNumber":"040770771","gender":"M","birthDate":"2002-04-25","relationShipCode":"19","otherInsuranceIndicator":"N","otherInsuranceCoverageType":"2","otherInsuranceEffectiveStartDate":"2021-05-05","otherInsuranceEndDate":"2022-12-31","otherInsuranceVerificationDate":"","custodyCode":"","otherInsurancePolicyNumber":"12345","otherInsuranceType":"MD","primacyIndicator":"T","otherInsuranceCardholderFirstName":"","otherInsuranceCardholderLastName":"","medicareIndicator":"Y","entitlementType":"MedicareA","entitlementTypeReason":"0"}';
       
        ACETLGT_UpdateCOBDetails.updateMembers(reqbody1, addressBody);
        ACETLGT_UpdateCOBDetails.updateMembers(null, null);
        
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
        ACETLGT_UpdateCOBDetails.getAddressTypeCode('Mailing');
        ACETLGT_UpdateCOBDetails.getAddressTypeCode('Work');
        ACETLGT_UpdateCOBDetails.getAddressTypeCode('Home');
        ACETLGT_UpdateCOBDetails.getAddressTypeCode('');
       Test.stopTest();
    }
    
}