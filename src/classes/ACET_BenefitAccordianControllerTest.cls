@isTest
public class ACET_BenefitAccordianControllerTest {
    
    @testsetup
    static void testsetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkServiceTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkCopayCoInsurance', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
    }

    static testMethod void getBenefitDetails() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETCopayCoInsuranceWebServiceMock());
        ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest requestObj = new ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest();
        requestObj.patientKey = 'AgCCvrTCjH71cXqqEVT0CS%2BE4uOzFcyetU1Bh6fEQObWoHi3N7FOZ09WsLNvnwMuX6w6wqjqBsqSNA7rnFtYWfVBH1IqBRxs7DLyunndThds32emQ2rukanQBCF3l7viFq7ekxPCiZOywe%2B2rxvjdlsmP5pwF8WlFUwoV9prWEeuFA8S2hckVkkG6lcHbSHm9jDjSgBvl6FFo%2F3d4yQw%2FR65m5vssY1aJKp1pFqrz%2BoOZ8cvVWLsOIRZQP8myqBSGCoVN%2B6M1nJu3MGyHCIVgpqMYuvtVt0%2FmdfcrTIPz7g%2FpOwOUJGs5r89RnUBfOPfVfQ4x25cXH%2FQFFo9R1q0G54mraJC5CdZFrut0EqMYABUHVw0kq1bfPMZ5FMeBANF618WzrvFj%2BCoGVDwleMIRCctPEWZmGALpDUIH3ForQHe3hxihg4QJOGFfbrxcGV4oMpr7fqYmeYZWhgiq%2FD6Psusn8tizyjjwebnDK2KR1UvOQdpmO3Q1tg5lZtw679MgdTlIZuw0ZAdlKt8Gq5HNlank9%2F99MN3uWmZ8XsKgNK8CiDsszwsUytkaUatGlGjoTYz88SEi9nfYrt8Gqg3sjIRwxx3y6aUXetD%2BlLROdh4juRG%2B4xYUKj2O7MmF4mpXfGkPrEp%2BHJigfjsreSJL6%2F1sazJR0n6jaqlosqKDAxFt70G1V4UxsQ%2FFTfGihyc8lH7HExT%2BJFurjOR5ubiZYXOWhBbR5B6SOfrNor3LlHzFSFc%2Fk%2Fm3p8sBMz9r%2FIoSkaEII4wD9Shmk32Lh5is5WIR8w8hx%2FhmkvLMJRXcLYNaO486E8cEfXhG0SmlfX5kq0b9hyCOOeABlAPKraiGQIIjqB1iGOFOjZ6SBZs81jXaw%3D%3D';
        requestObj.policyId = '2';
        requestObj.serviceTypeDescription_API = 'cardiacRehabilitation';
        ACET_BenefitAccordianController.BenefitResponseWrapper benefitWrapper = ACET_BenefitAccordianController.getBenefitDetails(requestObj, 'Acupunture', 1, 0);
        Test.stopTest();
    }
    
    static testMethod void getBenefitDetails400() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockFor400());
        ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest requestObj = new ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest();
        requestObj.patientKey = 'AgCCvrTCjH71cXqqEVT0CS%2BE4uOzFcyetU1Bh6fEQObWoHi3N7FOZ09WsLNvnwMuX6w6wqjqBsqSNA7rnFtYWfVBH1IqBRxs7DLyunndThds32emQ2rukanQBCF3l7viFq7ekxPCiZOywe%2B2rxvjdlsmP5pwF8WlFUwoV9prWEeuFA8S2hckVkkG6lcHbSHm9jDjSgBvl6FFo%2F3d4yQw%2FR65m5vssY1aJKp1pFqrz%2BoOZ8cvVWLsOIRZQP8myqBSGCoVN%2B6M1nJu3MGyHCIVgpqMYuvtVt0%2FmdfcrTIPz7g%2FpOwOUJGs5r89RnUBfOPfVfQ4x25cXH%2FQFFo9R1q0G54mraJC5CdZFrut0EqMYABUHVw0kq1bfPMZ5FMeBANF618WzrvFj%2BCoGVDwleMIRCctPEWZmGALpDUIH3ForQHe3hxihg4QJOGFfbrxcGV4oMpr7fqYmeYZWhgiq%2FD6Psusn8tizyjjwebnDK2KR1UvOQdpmO3Q1tg5lZtw679MgdTlIZuw0ZAdlKt8Gq5HNlank9%2F99MN3uWmZ8XsKgNK8CiDsszwsUytkaUatGlGjoTYz88SEi9nfYrt8Gqg3sjIRwxx3y6aUXetD%2BlLROdh4juRG%2B4xYUKj2O7MmF4mpXfGkPrEp%2BHJigfjsreSJL6%2F1sazJR0n6jaqlosqKDAxFt70G1V4UxsQ%2FFTfGihyc8lH7HExT%2BJFurjOR5ubiZYXOWhBbR5B6SOfrNor3LlHzFSFc%2Fk%2Fm3p8sBMz9r%2FIoSkaEII4wD9Shmk32Lh5is5WIR8w8hx%2FhmkvLMJRXcLYNaO486E8cEfXhG0SmlfX5kq0b9hyCOOeABlAPKraiGQIIjqB1iGOFOjZ6SBZs81jXaw%3D%3D';
        requestObj.policyId = '2';
        requestObj.serviceTypeDescription_API = 'cardiacRehabilitation';
        ACET_BenefitAccordianController.BenefitResponseWrapper benefitWrapper = ACET_BenefitAccordianController.getBenefitDetails(requestObj, 'Acupunture', 1, 0);
        //System.assertNotEquals(null, benefitWrapper.benefitTable);
        Test.stopTest();
    }
    
    static testMethod void getBenefitDetails_DollarAmount() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETCopayCoInsuranceWebServiceMockDollarAmount());
        ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest requestObj = new ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest();
        requestObj.patientKey = 'AgAINCgZjuttt%2BE4uOzFcyetU1Bh6fEQObWoHi3N7FOZ09WsLNvnwMuX6w6wqjqBsqSNA7rnFtYWfVBH1IqBRxs7DLyunndThds32emQ2rukanQBCF3l7viFq7ekxPCiZOywe%2B2rxvjdlsmP5pwF8WlFUwoV9prWEeuFA8S2hckVkkG6lcHbSHm9jDjSgBvl6FFo%2F3d4yQw%2FR65m5vssY1aJKp1pFqrz%2BoOZ8cvVWLsOIRZQP8myqBSGCoVN%2B6M1nJu3MGyHCIVgpqMYuvtVt0%2FmdfcrTIPz7g%2FpOwOUJGs5r89RnUBfOPfVfQ4x25cXH%2FQFFo9R1q0G54mraJC5CdZFrut0EqMYABUHVw0kq1bfPMZ5FMeBANF618WzrvFj%2BCoGVDwleMIRCctPEWZmGALpDUIH3ForQHe3hxihg4QJOGFfbrxcGV4oMpr7fqYmeYZWhgiq%2FD6Psusn8tizyjjwebnDK2KR1UvOQdpmO3Q1tg5lZtw679MgdTlIZuw0ZAdlKt8Gq5HNlank9%2F99MN3uWmZ8XsKgNK8CiDsszwsUytkaUatGlGjoTYz88SEi9nfYrt8Gqg3sjIRwxx3y6aUXetD%2BlLROdh4juRG%2B4xYUKj2O7MmF4mpXfGkPrEp%2BHJigfjsreSJL6%2F1sazJR0n6jaqlosqKDAxFt70G1V4UxsQ%2FFTfGihyc8lH7HExT%2BJFurjOR5ubiZYXOWhBbR5B6SOfrNor3LlHzFSFc%2Fk%2Fm3p8sBMz9r%2FIoSkaEII4wD9Shmk32Lh5is5WIR8w8hx%2FhmkvLMJRXcLYNaO486E8cEfXhG0SmlfX5kq0b9hyCOOeABlAPKraiGQIIjqB1iGOFOjZ6SBZs81jXaw%3D%3D';
        requestObj.policyId = '2';
        requestObj.serviceTypeDescription_API = 'acupuncture';
        System.debug(Logginglevel.INFO, 'COPAY-REQUEST-OBJECT:' + requestObj);
        ACET_BenefitAccordianController.BenefitResponseWrapper benefitWrapper = ACET_BenefitAccordianController.getBenefitDetails(requestObj, 'Acupunture', 1, 0);
        //System.assertNotEquals(null, benefitWrapper.benefitTable);
        Test.stopTest();
    }

    static testMethod void CopayCoInsurancesWrapper() {
        Test.startTest();
        String strJSONResponseBody = SAETestDataFactory.getStaticResourceResponse(SAEConstants.COPAY_COINSURANCE_RESP);
        System.assertNotEquals(null, ACET_CopayCoInsuranceResponceJSON2Apex.parse(strJSONResponseBody));
        Test.stopTest();
    }

    static testMethod void getBenefitDetailsNegativeTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETCopayCoInsuranceWebServiceMock());
        ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest requestObj = new ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest();
        requestObj.patientKey = 'AgCCvrTCjH71cXqqEVT0CS%2BE4uOzFcyetU1Bh6fEQObWoHi3N7FOZ09WsLNvnwMuX6w6wqjqBsqSNA7rnFtYWfVBH1IqBRxs7DLyunndThds32emQ2rukanQBCF3l7viFq7ekxPCiZOywe%2B2rxvjdlsmP5pwF8WlFUwoV9prWEeuFA8S2hckVkkG6lcHbSHm9jDjSgBvl6FFo%2F3d4yQw%2FR65m5vssY1aJKp1pFqrz%2BoOZ8cvVWLsOIRZQP8myqBSGCoVN%2B6M1nJu3MGyHCIVgpqMYuvtVt0%2FmdfcrTIPz7g%2FpOwOUJGs5r89RnUBfOPfVfQ4x25cXH%2FQFFo9R1q0G54mraJC5CdZFrut0EqMYABUHVw0kq1bfPMZ5FMeBANF618WzrvFj%2BCoGVDwleMIRCctPEWZmGALpDUIH3ForQHe3hxihg4QJOGFfbrxcGV4oMpr7fqYmeYZWhgiq%2FD6Psusn8tizyjjwebnDK2KR1UvOQdpmO3Q1tg5lZtw679MgdTlIZuw0ZAdlKt8Gq5HNlank9%2F99MN3uWmZ8XsKgNK8CiDsszwsUytkaUatGlGjoTYz88SEi9nfYrt8Gqg3sjIRwxx3y6aUXetD%2BlLROdh4juRG%2B4xYUKj2O7MmF4mpXfGkPrEp%2BHJigfjsreSJL6%2F1sazJR0n6jaqlosqKDAxFt70G1V4UxsQ%2FFTfGihyc8lH7HExT%2BJFurjOR5ubiZYXOWhBbR5B6SOfrNor3LlHzFSFc%2Fk%2Fm3p8sBMz9r%2FIoSkaEII4wD9Shmk32Lh5is5WIR8w8hx%2FhmkvLMJRXcLYNaO486E8cEfXhG0SmlfX5kq0b9hyCOOeABlAPKraiGQIIjqB1iGOFOjZ6SBZs81jXaw%3D%3D';
        requestObj.policyId = '2';
        requestObj.serviceTypeDescription_API = 'cardiacRehabilitation';
        requestObj = null;
        ACET_BenefitAccordianController.BenefitResponseWrapper benefitWrapper = ACET_BenefitAccordianController.getBenefitDetails(requestObj, 'Acupunture', 1, 0);
        System.assertNotEquals(null, benefitWrapper.benefitTable);
        Test.stopTest();
    }
}