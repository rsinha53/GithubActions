@isTest
public class ADBAncillaryControllerTest {
    
    @testSetup
    static void setupTestData() {
        // create test data for custom setting
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBAncillaryDataEndpoint',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000)
                };                
                    insert configs;
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,Name = 'QA',recordtypeText__c = 'TokenAPI',EndpointDomain__c = 'https://gateway-stage.optum.com/api/test/usr/riptide/eligibility/v1')
                };
                    insert orgConfigs;
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
    }
    
    
    @isTest static void testGetAncillaryDetails(){
        String memberId = '595156952';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBAncillaryTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBAncillaryController.getAncillaryDetails(memberId);
        
        test.stopTest();
    }
    

    @isTest static void testprepareECPAncillaryData(){
        test.startTest();
        String val = '{"data":{"mbrshp":[{"src_mbr_id":"A2146359246","orig_sys_mbr_id":"595156952","orig_sys_cd":"FEDX_WTWN","mbr_covs":[{"cov_typ_ref_id":19944,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2020-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"NoSurcharge"}]},{"cov_typ_ref_id":19924,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"WAIVEHI","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19923,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"WAIVECI","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19922,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"WAIVEACC","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19943,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"WAIVELEGAL","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19942,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"WAIVEID","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19941,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"PRUDENTIALADDOPTCHILD","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19940,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"PRUDENTIALADDOPTSPOUSE","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19939,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2020-05-22","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19938,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2020-05-22","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"NotEligible"}]},{"cov_typ_ref_id":19937,"cov_typ_ref_cd":null,"carr_nm":"CignaBehavioralHealth","cov_eff_dt":"2011-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"Eligible"}]},{"cov_typ_ref_id":19936,"cov_typ_ref_cd":null,"carr_nm":"AIG","cov_eff_dt":"2011-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"PRUDENTIALADDBASIC","pln_nm":"1.5xBaseSalary"}]},{"cov_typ_ref_id":19935,"cov_typ_ref_cd":null,"carr_nm":"CatamaranExport","cov_eff_dt":"2016-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"OPTUMRX","pln_nm":"OptumRx"}]},{"cov_typ_ref_id":171,"cov_typ_ref_cd":{"ref_dspl":"EAP","ref_desc":"EmployeeAssistanceProgram"},"carr_nm":"CignaBehavioralHealth","cov_eff_dt":"2011-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"EAP-CBH"}]},{"cov_typ_ref_id":19933,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2020-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"WAIVEDCFSA","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":0,"cov_typ_ref_cd":null,"carr_nm":"ConnectYourCareEnrollmentExp","cov_eff_dt":"2020-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"CYCFSA","pln_nm":"Enrolled"}]},{"cov_typ_ref_id":19931,"cov_typ_ref_cd":null,"carr_nm":"AetnaDisabilityExport","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"Premier-70%ofMonthlyPay"}]},{"cov_typ_ref_id":19930,"cov_typ_ref_cd":null,"carr_nm":"AetnaDisabilityExport","cov_eff_dt":"2011-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"CorePlan"}]},{"cov_typ_ref_id":19929,"cov_typ_ref_cd":null,"carr_nm":"Waive","cov_eff_dt":"2019-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"WAIVELIFE","pln_nm":"NotEnrolled"}]},{"cov_typ_ref_id":19928,"cov_typ_ref_cd":null,"carr_nm":"PrudentialLife","cov_eff_dt":"2018-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"PRUDENTIALLIFEOPTCHILD","pln_nm":"10000"}]},{"cov_typ_ref_id":19927,"cov_typ_ref_cd":null,"carr_nm":"PrudentialLife","cov_eff_dt":"2020-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"PRUDENTIALLIFEOPTSPOUSE","pln_nm":"80000"}]},{"cov_typ_ref_id":19926,"cov_typ_ref_cd":null,"carr_nm":"PrudentialLife","cov_eff_dt":"2020-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"PRUDENTIALLIFEOPT","pln_nm":"2xBaseAnnualSalary"}]},{"cov_typ_ref_id":19925,"cov_typ_ref_cd":null,"carr_nm":"PrudentialLife","cov_eff_dt":"2011-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"PRUDENTIALLIFEBASIC","pln_nm":"1.5xBaseAnnualSalary"}]},{"cov_typ_ref_id":196,"cov_typ_ref_cd":{"ref_dspl":"Vision","ref_desc":"Vision"},"carr_nm":"DavisVision","cov_eff_dt":"2020-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"DAVISVISIONBUYUP","pln_nm":"VisionBuyUp"}]},{"cov_typ_ref_id":160,"cov_typ_ref_cd":{"ref_dspl":"Dental","ref_desc":"Dental"},"carr_nm":"CIGNAMedical/Dental","cov_eff_dt":"2015-09-22","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"CIGNADENTALPPO","pln_nm":"PPODentalPlan"}]},{"cov_typ_ref_id":182,"cov_typ_ref_cd":{"ref_dspl":"Medical","ref_desc":"Medical"},"carr_nm":"Anthem5010Export","cov_eff_dt":"2016-01-01","cov_end_dt":null,"mbr_cov_phmds":[{"pln_cd":"TBD","pln_nm":"80Narrow-AnthemWI"}]}]}]}}';
        ADBAncillaryWrapper.parse(val);
        test.stopTest();
    }
}