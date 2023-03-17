@isTest
public class ACETLGT_CovidVaccineAPIServiceTest {

    @testSetup
    static void setpTestData(){
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'Covid19_ImmunizationEndpoint', Method__c = 'POST', Timeout__c = 10000,RecordTypeText__c  = 'Token_API')
        };
        insert configs;

        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id, RecordTypeText__c  = 'TokenAPI',Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/test/usr/riptide/immunization/v1')
        };
        insert orgConfigs;

        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        Test.stopTest();
    }

    @isTest static void testgetCovidVaccineIndicatorDetails(){
        String fn = 'Sai';
        String ln = 'Kolluru';
        String dob = '12/07/1979';
        test.startTest();
        
        //	exception flow
        List<String> popups = ACETLGT_CovidVaccineAPIService.getCovidVaccineIndicatorDetails(fn,ln,dob);
        System.assert(popups.isEmpty());

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Covid19_ImmunizationAPI_MockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        // Call the method that performs the callout - success flow
        popups = ACETLGT_CovidVaccineAPIService.getCovidVaccineIndicatorDetails(fn,ln,dob);
        System.assert(!popups.isEmpty());
        test.stopTest();
    }

    @isTest static void testNoVaccineInfoFlow(){
        String fn = 'Sai';
        String ln = 'Kolluru';
        String dob = '1979-12-07';
        test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Covid19_ImmunizationAPI_MockResponse');
        mock.setStatusCode(400);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        //	No Vaccine information flow
        List<String> popups = ACETLGT_CovidVaccineAPIService.getCovidVaccineIndicatorDetails(fn,ln,dob);
        System.assert(popups.isEmpty());
    }

    @isTest static void testWrapperAttr(){
        ACETLGT_CovidVaccineIndicatorWrapper.Immunization_indv wr = new ACETLGT_CovidVaccineIndicatorWrapper.Immunization_indv();
        wr.indv_id = 123;
        wr.fst_nm = 'Joe';
        wr.lst_nm = 'Root';
        wr.bth_dt = '1990-04-05';
        wr.gdr_ref_id = 123;

        ACETLGT_CovidVaccineIndicatorWrapper.Immunizations wr2 = new ACETLGT_CovidVaccineIndicatorWrapper.Immunizations();
        wr2.cvx_code= '207';
        wr2.cpt_code= '0011A';
        wr2.ndc= '207';
        wr2.npi= '207';
        wr2.provider_first_name= 'Joe';
        wr2.provider_last_name= 'Root';
        wr2.provider_org_name= 'abcd';
        wr2.dose_quanity= '2';
        wr2.dose_route= 'abcd';
        wr2.dose_site = 'abcd';
        wr2.expiration_dt = '2030-04-05';
    }
}