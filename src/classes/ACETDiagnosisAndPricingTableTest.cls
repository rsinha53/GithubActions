@isTest(SeeAllData=false)
private class ACETDiagnosisAndPricingTableTest {
  static testMethod void  feeScheduleTest() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('d1_FeeSchedule', '/api/alpha/eisl/providers/feeschedules/v1.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        StaticResource feeScheduleSR= [SELECT Body FROM StaticResource WHERE Name = 'ACETProviderFeeScheduleResponseJSON'];
        String feeScheduleResponseJSON = feeScheduleSR.Body.toString(); 
        
        
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        */
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
            
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        ACETDiagnosisAndPricingTable feeScheduleController = new ACETDiagnosisAndPricingTable();
       feeScheduleController.jsonStr = '[{"rowIndex":0,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":1,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00000","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":2,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"}]';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', feeScheduleResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        PageReference ACETPD = Page.ACETProviderFeeSchedule;
        ACETPD.getParameters().put('interactionId', oInteraction.Id);
        Test.setCurrentPageReference(ACETPD);
        feeScheduleController.DOSFromToday = '2018-08-02';
        feeScheduleController.DOSThruToday= '2018-08-02';
        feeScheduleController.POS = '11';
        feeScheduleController.pricingSetParam = '002560401543C';
        feeScheduleController.pricingsetId = '002560401543C';
        Interaction__c admissionDate = new Interaction__c ();
        admissionDate.tst_Date_Field__c = Date.newInstance(2015, 2, 14);
        Interaction__c disChargeDate = new Interaction__c ();
        disChargeDate.tst_Date_Field__c = Date.newInstance(2016, 11, 14);
        feeScheduleController.admissionDate = admissionDate;
        feeScheduleController.disChargeDate = disChargeDate;
        ACETFeeScheduleWrapper diagCode = new ACETFeeScheduleWrapper();
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
        diagCode.rowIndex = 1;
        diagCode.DOSFromToday = '2018-08-02';
        diagCode.DOSThruToday = '2018-08-02';
        diagCode.CPT = '1234';
        diagCode.MOdifiers= '01';
        diagCode.drugCode = '01';
        diagCode.editCodeText = 'PR070-Procedure Type Code could not be derived';
        diagCode.billedAmount = '500';
        diagCode.pricingScheduleId = '002560401543C';
        diagCode.diagCodes = '01';
        diagCode.POS = '11';
        diagCode.daysOfUNits = '10000';
        diagCode.dollarCharges = '100000';
        diagCode.pricedAmount = '100000';
        diagCode.pricingsetId = '002560401543C';
        diagCode.poscode = '11';
        feeScheduleController.diagnosisCode = diagCode;
        feeScheduleController.diagCodes = '01';
        feeScheduleController.drugCode = '01';
        feeScheduleController.editCodeText = 'PR070-Procedure Type Code could not be derived';
        feeScheduleController.billedAmount = '500';
        feeScheduleController.pricingScheduleId = '002560401543C';
        feeScheduleController.searchResults();
        feeScheduleController.setTableSize();
        ACETProviderFeeScheduleWebService feeScheduleWebService = new ACETProviderFeeScheduleWebService();
        feeScheduleWebService.queryPaginatedData(0, 5, 0);
        feeScheduleController.showData();
        feeScheduleController.cliamTypeChange();
        ACETDiagnosisAndPricingTable adpt = new ACETDiagnosisAndPricingTable();
      	adpt.rowEntry = '75';
        adpt.returnDateFormat('text-text-text');
        adpt.addRowsFromEntry();
        feeScheduleController.addRowsFromEntry();
        feeScheduleController.getclaimTypeOptions();
        feeScheduleController.surrogateKey = '1234568';
        ACETProviderFeeScheduleJSON2APEX providerFeeScheduleJSON2Apex = new ACETProviderFeeScheduleJSON2APEX();
        ACETProviderFeeScheduleJSON2APEX.claimHeaders claimHeaderObj= new ACETProviderFeeScheduleJSON2APEX.claimHeaders();
        claimHeaderObj.claimClassID = 'PROF';
        claimHeaderObj.manualReviewIndicator = 'false';
        claimHeaderObj.pricingSetID = 'MSPSNEWNG92142';
        claimHeaderObj.pricingScheduleVersionID = '000330192142C';
        claimHeaderObj.pricingScheduleVersionID = '2839484';
        ACETProviderFeeScheduleJSON2APEX.componentDetailTierList componentDetailTierListObj = new ACETProviderFeeScheduleJSON2APEX.componentDetailTierList();
        componentDetailTierListObj.calculationType = 'FDPU';
        componentDetailTierListObj.pricingComponentDetailID = '244087442';
        componentDetailTierListObj.pricingComponentType = 'PFS';
        List<ACETProviderFeeScheduleJSON2APEX.componentDetailTierList> componentDetailTierList = new List<ACETProviderFeeScheduleJSON2APEX.componentDetailTierList>();
        componentDetailTierList.add(componentDetailTierListObj);
        ACETProviderFeeScheduleJSON2APEX.claimLines claimLines = new ACETProviderFeeScheduleJSON2APEX.claimLines();
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
        List<ACETProviderFeeScheduleJSON2APEX.claimLines> claimList = new List<ACETProviderFeeScheduleJSON2APEX.claimLines>();
        claimList.add(claimLines);
        claimHeaderObj.claimLines = claimList;
        Test.stopTest();
    }
    static testMethod void  feeScheduleTestFailure() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('d1_FeeSchedule', '/api/alpha/eisl/providers/feeschedules/v1.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        StaticResource feeScheduleSR= [SELECT Body FROM StaticResource WHERE Name = 'ACETProviderFeeScheduleResponseJSON'];
        String feeScheduleResponseJSON = feeScheduleSR.Body.toString(); 
        
        
        
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        ACETDiagnosisAndPricingTable feeScheduleController = new ACETDiagnosisAndPricingTable();
        feeScheduleController.jsonStr = '[{"rowIndex":0,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":1,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00000","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"},{"rowIndex":2,"dateOfServiceFrom":"2018-8-2","dateOfServiceThru":"2018-8-2","procedureCode":"00914","modifierCode1":"01","modifierCode2":"01","modifierCode3":"01","modifierCode4":"01","placeOfServiceCode":"11","rxNationalDrugCode":"","serviceUnits":"1","billedAmount":"500"}]';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', '{"ErrorID": "6e3c2ac7-8c52-4e0a-a04e-6640bc7de2d5","ErrorCode": "5.3","ErrorMessage": "Error","Advice": "If problem persists, please contact API team"}');
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        PageReference ACETPD = Page.ACETProviderFeeSchedule;
        ACETPD.getParameters().put('interactionId', oInteraction.Id);
        Test.setCurrentPageReference(ACETPD);
        feeScheduleController.DOSFromToday = '2018-08-02';
        feeScheduleController.DOSThruToday= '2018-08-02';
        feeScheduleController.POS = '11';
        feeScheduleController.pricingsetId = '002560401543C';
        feeScheduleController.diagCodes = '01';
        feeScheduleController.drugCode = '01';
        feeScheduleController.editCodeText = 'PR070-Procedure Type Code could not be derived';
        feeScheduleController.billedAmount = '500';
        feeScheduleController.pricingScheduleId = '002560401543C';
        feeScheduleController.searchResults();
        ACETProviderFeeScheduleWebService feeScheduleWebService = new ACETProviderFeeScheduleWebService();
        feeScheduleWebService.queryPaginatedData(0, 5, 0);
        feeScheduleController.showData();
        feeScheduleController.surrogateKey = '1234568';
        Test.stopTest();
    }
       
}