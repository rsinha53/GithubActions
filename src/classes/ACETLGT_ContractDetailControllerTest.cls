@IsTest
public class ACETLGT_ContractDetailControllerTest {
      @IsTest
    Public static void contractDetailControllerTestmethod()
    {
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLGT_GetAgreementResponseJSON'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ContractDetailController.GetMedProvAgreementWebservice('959245382093360560','263520640','TIN','691445240366278061 ','PRAC','4418904','5151078','1008476','','');
       ACETLGT_GetMedProvAgreementWebservice getws = new ACETLGT_GetMedProvAgreementWebservice();
       getws.GetProvider('959245382093360560','263520640','TIN','691445240366278061 ','PRAC','4418904','5151078','1008476','','');
       ACETLGT_GetMedProvAgreementJSON2Apex.PricingSet AGMFP = new ACETLGT_GetMedProvAgreementJSON2Apex.PricingSet();
       AGMFP.description ='MSPS NEWNG 93052';
       AGMFP.version ='1';
       AGMFP.cancelDate = '9999-12-31';
       ACETLGT_GetMedProvAgreementJSON2Apex.Recovery AGMFR = new ACETLGT_GetMedProvAgreementJSON2Apex.Recovery();
       AGMFR.overpaymentIndicator ='Y';
       AGMFR.waitPeriod ='30';
       AGMFR.waitPeriodTypeCode = 'Days';
       AGMFR.deadlinePeriod = '365';
       AGMFR.deadlinePeriodTypeCode = 'Days';
       ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit AGMF = new ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit();
       AGMF.id ='23121601';
       AGMF.statusCode ='A';
       AGMF.period = '90';
       AGMF.periodType= 'Days';
       AGMF.penaltyPercentage= '100';
       ACETLGT_GetMedProvAgreementJSON2Apex.Network network = new ACETLGT_GetMedProvAgreementJSON2Apex.Network();
       network.id ='9';
       network.statusCode ='A';
       network.name = 'Liberty Network'; 
       ACETLGT_GetMedProvAgreementJSON2Apex.LineOfBusiness line = new ACETLGT_GetMedProvAgreementJSON2Apex.LineOfBusiness();
       line.name ='E&I';
       line.medicalNecessityIndicator ='N';
       ACETLGT_GetMedProvAgreementJSON2Apex.Key key = new ACETLGT_GetMedProvAgreementJSON2Apex.Key();
       key.contractDetailId ='23081601';
       ACETLGT_GetMedProvAgreementJSON2Apex.ContractDetail contract = new ACETLGT_GetMedProvAgreementJSON2Apex.ContractDetail();
       contract.id ='23081601';
       contract.version= '1';
       contract.providerAssignmentTypeCode= 'PCP';
       contract.acceptingNewPatientsIndicator= 'N';
       contract.acceptingExistingPatientsIndicator = 'Y';
       contract.processOrderNumber = '9';
       Test.stopTest();
    }
}