@IsTest
public class ACETLGT_ProviderFeeScheduleTest{
    @IsTest
    Public static void providerFeeScheduleTest()
    { 
       Place_Of_Service_Values__mdt placeOfService = new Place_Of_Service_Values__mdt();
       placeOfService.label = 'Home';
       List<Place_Of_Service_Values__mdt> lstPlaceOfService = new List<Place_Of_Service_Values__mdt>();
       lstPlaceOfService.add(placeOfService);
       ACETLGT_ProviderFeeScheduleController.getPlaceOfServicecmdt();
       StaticResource feeScheduleSR= [SELECT Body FROM StaticResource WHERE Name = 'ACETProviderFeeScheduleResponseJSON'];
       String feeScheduleResponseJSON = feeScheduleSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', feeScheduleResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       String claimLinesInput = '[{"rowIndex":0,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":1,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00000","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":2,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"}]';
       ACETLGT_FeeScheduleWrapper diagCode = new ACETLGT_FeeScheduleWrapper();
       diagCode.diagnosisCode1 = '01';
       diagCode.diagnosisCode2 = '01';
       diagCode.diagnosisCode3 = '01';
       diagCode.diagnosisCode4 = '01';
       diagCode.diagnosisCode5 = '01';
       diagCode.diagnosisCode6 = '01';
       diagCode.diagnosisCode7 = '01';
       diagCode.diagnosisCode8 = '01';
       diagCode.diagnosisCode9 = '01';
       diagCode.diagnosisCode10 = '01';
       diagCode.diagnosisCode11 = '01';
       diagCode.diagnosisCode12 = '01';  
       List<ACETLGT_FeeScheduleWrapper> claimLinesTemp = new List<ACETLGT_FeeScheduleWrapper>(); 
       if(claimLinesInput != null && claimLinesInput != ''){
                claimLinesTemp = (List<ACETLGT_FeeScheduleWrapper>) JSON.deserialize(claimLinesInput, list<ACETLGT_FeeScheduleWrapper>.class); 
       } 
       ACETLGT_ProviderFeeScheduleController.getProviderFeeScheduleSearchResults('2018-8-2','2018-8-2','002560401543C',diagCode,claimLinesInput,'Facility-UB04','01','100','2018-08-02','2018-08-02','1234','INST','1234');
       ACETLGT_ProviderFeeScheduleWebService ACTPFeeShed = new ACETLGT_ProviderFeeScheduleWebService();
       ACTPFeeShed.init('2018-8-2','2018-8-2','','','','','','','','','002560401543C',diagCode,claimLinesTemp,'01','100','2018-08-02','2018-08-02','1234','INST','1234');
       ACETLGT_ProviderFeeScheduleJSON2APEX.claimHeaders claimHeaderObj= new ACETLGT_ProviderFeeScheduleJSON2APEX.claimHeaders();
       claimHeaderObj.claimClassID = 'PROF';
       claimHeaderObj.manualReviewIndicator = 'false';
       claimHeaderObj.pricingSetID = 'MSPSNEWNG92142';
       claimHeaderObj.pricingScheduleVersionID = '000330192142C';
       claimHeaderObj.pricingScheduleVersionID = '2839484';
       ACETLGT_ProviderFeeScheduleJSON2APEX.componentDetailTierList componentDetailTierListObj = new ACETLGT_ProviderFeeScheduleJSON2APEX.componentDetailTierList();
       componentDetailTierListObj.calculationType = 'FDPU';
       componentDetailTierListObj.pricingComponentDetailID = '244087442';
       componentDetailTierListObj.pricingComponentType = 'PFS';
       List<ACETLGT_ProviderFeeScheduleJSON2APEX.componentDetailTierList> componentDetailTierList = new List<ACETLGT_ProviderFeeScheduleJSON2APEX.componentDetailTierList>();
       componentDetailTierList.add(componentDetailTierListObj);
       ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines claimLines = new ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines();
       claimLines.claimClassIDParent = 'PROF';
       claimLines.manualReviewIndicatorParent = 'false';
       claimLines.pricingSetIDParent = 'MSPSNEWNG92142';
       claimLines.pricingScheduleIDParent = '000330192142C';
       claimLines.pricingScheduleVersionIDParent = '2839484';
       claimLines.billedAmount = '250';
       claimLines.claimLineNumber = '1';
       claimLines.dateOfServiceFrom = '2018-07-09';
       claimLines.dateOfServiceThru = '2018-07-09';
       claimLines.placeOfServiceCode = '11';
       claimLines.serviceUnits = '1';
       claimLines.aggregateAllowAmount = '0';
       claimLines.aggregateAllowIncrease = '0';
       claimLines.apcAmount = '0';
       claimLines.aapAmount = '0';
       claimLines.apAmount = '0';
       claimLines.basePrice = '108.12';
       claimLines.basepricePercent = '0';
       claimLines.billedAjustAmount = '0';
       claimLines.ccPercentReductionAmount = '0';
       claimLines.ccPricedAmount = '0';
       claimLines.componentType = 'PFS';
       claimLines.finalPricedAmount = '108.12';
       claimLines.gtbReductionAmount = '0';
       claimLines.netModifierReduction = '0';
       claimLines.notToExceedReduction = '0';
       claimLines.outlierGTBReduction = '0';
       claimLines.outlierPricedAmount = '108.12';
       claimLines.parentLineNumber = '0';
       claimLines.priced = '108.12';
       claimLines.pricedPercentReductionAmount = '0';
       claimLines.pricedPercent = '100';
       claimLines.pricingScheduleOrderID = '2869484';
       claimLines.procedureCodeType = '2';
       claimLines.procedureCode = '99214';
       claimLines.processedAmount = '108.12';
       claimLines.reviewIndicator = 'false';
       claimLines.transferPriceReductionAmount = '0';
       claimLines.componentDetailTierList = componentDetailTierList; 
       List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines> claimList = new List<ACETLGT_ProviderFeeScheduleJSON2APEX.claimLines>();
       claimList.add(claimLines);
       claimHeaderObj.claimLines = claimList;
       Test.stopTest();
    }   
    @IsTest
    Public static void providerFeeScheduleTestFailure()
    { 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', '{"ErrorID": "6e3c2ac7-8c52-4e0a-a04e-6640bc7de2d5","ErrorCode": "5.3","ErrorMessage": "Error","Advice": "If problem persists, please contact API team"}');
       OILTestResponse.TokenExpired = false;
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       String claimLinesInput = '[{"rowIndex":0,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":1,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00000","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":2,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"}]';
       ACETLGT_FeeScheduleWrapper diagCode = new ACETLGT_FeeScheduleWrapper();
       diagCode.diagnosisCode1 = '01';
       diagCode.diagnosisCode2 = '01';
       diagCode.diagnosisCode3 = '01';
       diagCode.diagnosisCode4 = '01';
       diagCode.diagnosisCode5 = '01';
       diagCode.diagnosisCode6 = '01';
       diagCode.diagnosisCode7 = '01';
       diagCode.diagnosisCode8 = '01';
       diagCode.diagnosisCode9 = '01';
       diagCode.diagnosisCode10 = '01';
       diagCode.diagnosisCode11 = '01';
       diagCode.diagnosisCode12 = '01';  
       List<ACETLGT_FeeScheduleWrapper> claimLinesTemp = new List<ACETLGT_FeeScheduleWrapper>(); 
       if(claimLinesInput != null && claimLinesInput != ''){
                claimLinesTemp = (List<ACETLGT_FeeScheduleWrapper>) JSON.deserialize(claimLinesInput, list<ACETLGT_FeeScheduleWrapper>.class); 
       } 
       ACETLGT_ProviderFeeScheduleController.getProviderFeeScheduleSearchResults('2018-8-2','2018-8-2','002560401543C',diagCode,claimLinesInput,'Facility-UB04','01','100','2018-08-02','2018-08-02','1234','INST','1234');
       ACETLGT_ProviderFeeScheduleWebService ACTPFeeShed = new ACETLGT_ProviderFeeScheduleWebService();
       ACTPFeeShed.init('2018-8-2','2018-8-2','','','','','','','','','002560401543C',diagCode,claimLinesTemp,'01','100','2018-08-02','2018-08-02','1234','INST','1234');
       ACTPFeeShed.queryPaginatedData(0, 5, 0);
       Test.stopTest();
    }   
    
}