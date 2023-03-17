@IsTest
public class ACETLGT_ProviderLookupDetailTest {
    @IsTest
    Public static void providerLookupDetailPhysician()
    { 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getHCPAdapterJSONHrsOper()); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;         
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderDetail('959245382093360560','263520640','TIN','1452407764893','PRAC ','provider Lookup');
       ACETLGT_GetHCPWebservice hcpws = new ACETLGT_GetHCPWebservice();
       hcpws.init('959245382093360560','263520640','TIN','1452407764893', 'PRAC', 'provider Lookup');
       ACETGetHCPAdapterJSON2Apex.tpsm AFHPC = new ACETGetHCPAdapterJSON2Apex.tpsm();
       AFHPC.statusEffectiveDate = '0001-01-01';
       AFHPC.statusCancelDate = '0001-01-01';
       AFHPC.code = '99Z';
       Test.stopTest();
    }   
    @IsTest
    Public static void providerLookupDetailFacility()
    { 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getHCOCallableJSON()); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderDetailFacility('959245382093360560','263520640','TIN','1452407764893','PRAC ','provider Lookup');
       ACETLGT_GetHCOWebservice hcows = new ACETLGT_GetHCOWebservice();
       hcows.init('959245382093360560','263520640','TIN','1452407764893', 'PRAC', 'provider Lookup');
       ACETGetHCOJSON2Apex.tpsm acgt = new ACETGetHCOJSON2Apex.tpsm();
       acgt.statusCode= 'A';
       acgt.statusEffectiveDate= '0001-01-01';
       acgt.statusCancelDate='0001-01-01';
       Test.stopTest();
    } 
     @IsTest
    Public static void providerLookupDetailAgreement()
    { 
       StaticResource GetAgrmntSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetAgrmntResponseJSON1'];
       String GetAgrmntResponseJSON = GetAgrmntSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetAgrmntResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderContractResults('959245382093360560','263520640','TIN','1452407764893','PRAC');
       ACETLGT_FindAgreementsWebservice agreementws = new ACETLGT_FindAgreementsWebservice();
       agreementws.init('959245382093360560','263520640','TIN','1452407764893', 'PRAC');
       agreementws.queryPaginatedData(0,5,0);
       Test.stopTest();
    } 
    @IsTest
    Public static void providerLookupDetailTestmethodForPhysician()
    {
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderLookupResults('959245382093360560','1316273071','263520640','AGGARWAL','MAYANK ','M','Podiatrist','40444721','06708','1',' WATERBURY','CT','','9','OXFORD_TRI_STATE','In/Out of Srvc Area','Medical','Y','US','Physician','','true','','','');
       Test.stopTest();
    }
     @IsTest
    Public static void providerLookupDetailTestmethodForFacility()
    {
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderLookupResults('959245382093360560','1316273071','263520640','AGGARWAL','MAYANK ','M','Podiatrist','40444721','06708','1',' WATERBURY','CT','','9','OXFORD_TRI_STATE','In/Out of Srvc Area','Medical','Y','US','Facility','','true','','','');
       Test.stopTest();
    }
     @IsTest
    Public static void providerLookupDetailAffliationsPhysician()
    { 
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindHCPAffResponseJSON1'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderAffiliationResults('959245382093360560','Physician');
       ACETLGT_FindHCPAffiliationsWebservice hcpws = new ACETLGT_FindHCPAffiliationsWebservice();
       hcpws.init('959245382093360560');
       hcpws.queryPaginatedData(0,5,0);
       Test.stopTest();
    }   
     @IsTest
    Public static void providerLookupDetailAffliationsPhysicianFailure()
    { 
      String ResponseJSON = '{"findMedicalHealthcareProfessionalAffiliationsResult":{"errors":"code":"W008","name":"No records returned","severity":"low",';
      ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderAffiliationResults('959245382093360560','Physician');
       ACETLGT_FindHCPAffiliationsWebservice hcpws = new ACETLGT_FindHCPAffiliationsWebservice();
       hcpws.init('959245382093360560');
       hcpws.queryPaginatedData(0,5,0);
       Test.stopTest();
    }
     @IsTest
    Public static void providerLookupDetailAffliationsFacility()
    { 
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindHCOAffResponseJSON1'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderAffiliationResults('959245382093360560','Facility');
       ACETLGT_FindHCOAffiliationsWebservice hcows = new ACETLGT_FindHCOAffiliationsWebservice();
       hcows.init('959245382093360560');
       hcows.queryPaginatedData(0,5,0);
       Test.stopTest();
    }
     @IsTest
    Public static void providerLookupDetailAffliationsFacilityFailure()
    { 
       String ResponseJSON = '{"findMedicalHealthcareOrganizationAffiliationsResult":{"errors":"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getProviderAffiliationResults('959245382093360560','Facility');
       ACETLGT_FindHCOAffiliationsWebservice hcows = new ACETLGT_FindHCOAffiliationsWebservice();
       hcows.init('959245382093360560');
       hcows.queryPaginatedData(0,5,0);
       Test.stopTest();
    }
    @IsTest
    Public static void familyMembsResultWrapperTestMethod()
    {  
       Test.startTest();
       ACETLGT_ProviderLookupDetailController.getpcp('959245382093360560','Facility','test','test');
       ACETLGT_ProviderLookupDetailController.UpdatePCPOBGYN('pcpObgnID', 'memberId', 'currentpcpAssignmentType', '', '111111', '222222', 'lastName', 'firstName', 'middleName', 'nameSuffix', 'ssn', 'M', '01/01/1990', 'relationshipcode', 'npiType', 'npiVal', 'existpatientindicator');
       ACETLGT_FindHCOAffiliationsWebservice hcows = new ACETLGT_FindHCOAffiliationsWebservice();
        ACETLGT_ProviderLookupDetailController.CurrentPhysician cPhysician = new ACETLGT_ProviderLookupDetailController.CurrentPhysician();
        cPhysician.effDate='';
        cPhysician.EndDate=Date.today();
        cPhysician.firstName='';
        cPhysician.isChecked=true;
        cPhysician.lastName='';
        cPhysician.pcpAssignmentType='';
        cPhysician.pcpid='';
        cPhysician.pcptype='';
       hcows.init('959245382093360560');
       hcows.queryPaginatedData(0,5,0);
       Test.stopTest();
    }
    
}