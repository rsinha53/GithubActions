@istest
private class ACETLGT_ClaimSearchControllerTest{
    private static final String code = 'dkgljgdgjf_1324';
    private static final String code1 = 'suresh';
    private static Map<String, String> mapISLWSConfigs;
    private static final Integer statusCode200 = 200;
    private static final String status200 = 'OK';
    private static final Integer statusCode500 = 500;
    private static final String status500 = 'Internal Server Error';
    static void prepareData(){
        mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_CreateLetter', '/api/alpha/eisl/fulfillment/createletter/v1.0');
        mapISLWSConfigs.put('dev_EncoderPro', '/api/alpha/eisl/fulfillment/createletter/v1.0');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
    }
    static testMethod void testClaimSearcWebservice(){
        prepareData();
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        ACETFindClaimJSON2Apex.Pagination js2apexpage = new ACETFindClaimJSON2Apex.Pagination();
        js2apexpage.pageNumber = '1';
        js2apexpage.pageSize = '50';
        js2apexpage.recordCount = '200';
        js2apexpage.totalCount = '400';
        ACETFindClaimJSON2Apex.Name name = new ACETFindClaimJSON2Apex.Name();
        name.firstName = 'test';
        name.lastName = 'test';
        name.middleName = 'test';
        ACETFindClaimJSON2Apex.Identifiers iden = new ACETFindClaimJSON2Apex.Identifiers();
        iden.id = 'test';
        iden.type_Z = 'test';
        List<ACETFindClaimJSON2Apex.Identifiers> listiden = new List<ACETFindClaimJSON2Apex.Identifiers>();
        listiden.add(iden);
        ACETFindClaimJSON2Apex.Provider prov = new ACETFindClaimJSON2Apex.Provider();
        prov.providerID = 'test';
        prov.providerNPI = 'test';
        ACETFindClaimJSON2Apex.Patient pat = new ACETFindClaimJSON2Apex.Patient();
        pat.birthDate = 'test';
        pat.identifiers = listiden;
        pat.name = name;
        ACETFindClaimJSON2Apex.DiagnosisCode code = new ACETFindClaimJSON2Apex.DiagnosisCode();
        code.levelType = 'test';
        ACETFindClaimJSON2Apex.Subscriber sub = new ACETFindClaimJSON2Apex.Subscriber();
        sub.identifiers = listiden;
        sub.name = name;
        ACETFindClaimJSON2Apex.Claims clms = new ACETFindClaimJSON2Apex.Claims();
        clms.claimSourceSystemCode = 'test1';
        clms.claimReceivedDate = 'test';
        clms.totalCopayAmount = 'test';
        clms.totalNotCoveredAmount = 'test';
        clms.claimTotalAllowedAmount = 'test';
        clms.patientAccountNumber = 'test';
        clms.patient = pat;
        clms.subscriber = sub;
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
        res.ServiceEnd = 'test';
        res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'PHIRestriction';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
        
        Date startDate = Date.parse('12/15/15');
        Date endDate = Date.parse('12/16/15');
        
         ACETLGT_FindClaimWebservice  service = new ACETLGT_FindClaimWebservice();         
         service.init('a','a','a','a','a','a12345','a','a','a','a','a','a');
         service.init('1234TaxId','strNetworkStatus','startDate','EndDate','strDeductibleOnly','strClaimId','strAuthorizationNumber','trReferrelNumber','strProviderType','strMCHId','strEID','strencouters');
         service.formattedDate('09/04/2018');
          
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
         Test.setMock(HttpCalloutMock.class, MockHttpRes1);           
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', '');
         OILResponse2.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
         Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Server Error', '');
         OILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes3); 
         service.queryPaginatedData(1,1,1); 
         
          MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'Matching Record Not found', '');
         OILResponse4.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes4 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes4); 
         service.queryPaginatedData(1,1,1);
         string data = '{"claimItem":["E04.1","R31.9","R31.9","E04.1","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","R35.0","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","R35.0","R31.9","M23.304","M23.304","E04.1","E04.1","D18.01","E04.1","L02.32","D18.01","E04.1","D18.01","E04.1","E04.1","N94.89","E04.1","E04.1","S00.93XA","Z74.3","R55","E04.1"]}';
        ACETLGT_ClaimsSearchController.getClaimsSearchResults('taxid','inNetwork',startDate,endDate,'strdeductible','claimnumber','AuthorizationNumber','ReferralNumber','providers','MemberId','EID','encouter');
        ACETLGT_ClaimsSearchController.getEncoderProDescription(data);
    } 
    
    static testMethod void testClaimSearcWebservice_2(){
        prepareData();
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        ACETFindClaimJSON2Apex.Pagination js2apexpage = new ACETFindClaimJSON2Apex.Pagination();
        js2apexpage.pageNumber = '1';
        js2apexpage.pageSize = '50';
        js2apexpage.recordCount = '200';
        js2apexpage.totalCount = '400';
      
        ACETFindClaimJSON2Apex.Name name = new ACETFindClaimJSON2Apex.Name();
        name.firstName = 'test';
        name.lastName = 'test';
        name.middleName = 'test';
       
        ACETFindClaimJSON2Apex.Identifiers iden = new ACETFindClaimJSON2Apex.Identifiers();
        iden.id = 'test';
        iden.type_Z = 'test';
        List<ACETFindClaimJSON2Apex.Identifiers> listiden = new List<ACETFindClaimJSON2Apex.Identifiers>();
        listiden.add(iden);
        ACETFindClaimJSON2Apex.Provider prov = new ACETFindClaimJSON2Apex.Provider();
        prov.name = name;
        prov.providerID = 'test';
        prov.providerNPI = 'test';
        ACETFindClaimJSON2Apex.Patient pat = new ACETFindClaimJSON2Apex.Patient();
        pat.birthDate = 'test';
        pat.identifiers = listiden;
        pat.name = name;
        ACETFindClaimJSON2Apex.DiagnosisCode code = new ACETFindClaimJSON2Apex.DiagnosisCode();
        code.levelType = 'test';
        ACETFindClaimJSON2Apex.Subscriber sub = new ACETFindClaimJSON2Apex.Subscriber();
        sub.identifiers = listiden;
        sub.name = name;
        ACETFindClaimJSON2Apex.Claims clms = new ACETFindClaimJSON2Apex.Claims();
        clms.claimSourceSystemCode = 'test';
        clms.claimReceivedDate = 'test';
        clms.totalCopayAmount = 'test';
        clms.totalNotCoveredAmount = 'test';
        clms.claimTotalAllowedAmount = 'test';
        clms.patientAccountNumber = 'test';
        clms.patient = pat;
        clms.subscriber = sub;
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'PHIRestriction';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
        
        
         ACETLGT_FindClaimWebservice  service = new ACETLGT_FindClaimWebservice();         
         service.init(null,'a',null,null,null,null,null,null,null,null,null,null);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
         Test.setMock(HttpCalloutMock.class, MockHttpRes1);           
         service.queryPaginatedData(1,1,1);
         
         service.init(null,null,null,null,null,null,'a','a',null,'false',null,null);        
          MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse4.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes4 = new MockHttpCalloutResponseGenerator(null, OILResponse4);
         Test.setMock(HttpCalloutMock.class, MockHttpRes4);           
         service.queryPaginatedData(1,1,1);
         
          service.init('a',null,null,'a',null,null,'a','a',null,'false',null,null);
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse5.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes5= new MockHttpCalloutResponseGenerator(null, OILResponse5);
         Test.setMock(HttpCalloutMock.class, MockHttpRes5);           
         service.queryPaginatedData(1,1,1);
         
         service.init('a',null,null,'a',null,null,'a','a','a','false',null,null);
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse6.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes6= new MockHttpCalloutResponseGenerator(null, OILResponse6);
         Test.setMock(HttpCalloutMock.class, MockHttpRes6);           
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', '');
         OILResponse2.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
         Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Server Error', '');
         OILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes3); 
         service.queryPaginatedData(1,1,1);
         
          MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse7 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'Matching Records Not Found', '');
         OILResponse7.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes7 = new MockHttpCalloutResponseGenerator(null, OILResponse7);
         Test.setMock(HttpCalloutMock.class, MockHttpRes7); 
         service.queryPaginatedData(1,1,1);
        // ACETLGT_ClaimsSearchController.getClaimsSearchResults('taxid','inNetwork',d1,d2,'strdeductible','claimnumber','AuthorizationNumber','ReferralNumber','providers','MemberId','EID');
    }
        
    /*global class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(ACETTestDataUtility.FindClaimsJSON());
            res.setStatusCode(200);
            return res;
        }
    }*/
    
    static testmethod void getcompareresult()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
        res.ServiceEnd = 'test';
        res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'ClaimID';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult1()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Provider';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult2()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'TaxID';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult3()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Network';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult4()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'PHIRestriction';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult5()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Provider';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult6()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'TaxID';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult7()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Network';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
       }
    static testmethod void getcompareresult9()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Status';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    static testmethod void getcompareresult8()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'BenefitLevel';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    static testMethod void endCoderTestMethod(){
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, '{"batchResponses":{"response":[{"text":{"description":"suresh"},"statusCode":200,"requestId":"wwwqweer_12334"}]}}');
        OILResponse6.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes6= new MockHttpCalloutResponseGenerator(null, oilResponse6);
        Test.setMock(HttpCalloutMock.class, mockHttpRes6);           
        ACETLGT_EncoderProWebservice encode = new ACETLGT_EncoderProWebservice();
        List<String> codeList = new List<String>();
        codeList.add(code);
        encode.getCodeDescriptions(codeList);
    }
    static testMethod void endCoderTestMethod_1(){
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, '{"batchResponses":{"response":[{"text":{"description":""},"statusCode":200,"requestId":"wwwqweer_12334"}]}}');
        OILResponse6.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes6= new MockHttpCalloutResponseGenerator(null, oilResponse6);
        Test.setMock(HttpCalloutMock.class, mockHttpRes6);           
        ACETLGT_EncoderProWebservice encode = new ACETLGT_EncoderProWebservice();
        List<String> codeList = new List<String>();
        codeList.add(code);
        encode.getCodeDescriptions(codeList);
    }
    static testMethod void endCoderTestMethod_2(){
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, '{"batchResponses":{"response":[{"text":{"description":""},"statusCode":200,"requestId":"wwwqweer_12334"}]}}');
        OILResponse6.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes6= new MockHttpCalloutResponseGenerator(null, oilResponse6);
        Test.setMock(HttpCalloutMock.class, mockHttpRes6);           
        ACETLGT_EncoderProWebservice encode = new ACETLGT_EncoderProWebservice();
        List<String> codeList = new List<String>();
        codeList.add(code);
        Map<String,List<String>> codeVsCodeTypesMap = new Map<String,List<String>>();
        codeVsCodeTypesMap.put(code1,codeList);
        encode.getCodeDescriptions(codeList);
        encode.getBatchRequestBody(codeVsCodeTypesMap, code1);
    }
    static testMethod void endCoderTestMethodCatch(){
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, '{"batchResponses":{"response":[{"text":{"description":""},"statusCode":200}]}}');
        OILResponse6.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes6= new MockHttpCalloutResponseGenerator(null, oilResponse6);
        Test.setMock(HttpCalloutMock.class, mockHttpRes6);           
        ACETLGT_EncoderProWebservice encode = new ACETLGT_EncoderProWebservice();
        List<String> codeList = new List<String>();
        codeList.add(code);
        encode.getCodeDescriptions(codeList);
    }
    static testMethod void endCoderTestMethod_3(){
   
        prepareData();
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        System.debug('lstISLWSConfigs::'+lstISLWSConfigs);
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, '{"batchResponses":{"response":[{"text":{"description":"suresh"},"statusCode":200,"requestId":"wwwqweer_12334"}]}}');
        OILResponse6.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes6= new MockHttpCalloutResponseGenerator(null, oilResponse6);
        Test.setMock(HttpCalloutMock.class, mockHttpRes6);           
        ACETLGT_EncoderProWebservice encode = new ACETLGT_EncoderProWebservice();
        List<String> codeList = new List<String>();
        codeList.add(code);
        encode.getCodeDescriptions(codeList);
    }
}