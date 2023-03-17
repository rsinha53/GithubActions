@isTest
public class SAEClaimSearchControllerTest {

    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'slayerdev';
        Upsert orgProps;
        List<WebserviceConfigurations__c> webConRelatedDocumentsList = new List<WebserviceConfigurations__c>();
        WebserviceConfigurations__c  webConRelatedDocuments = new WebserviceConfigurations__c ();
        webConRelatedDocuments.GrantType__c  = 'client_credentials';
        webConRelatedDocuments.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments.Method__c  = 'GET';
        webConRelatedDocuments.Name  = 'LinkClaimSearch';
        webConRelatedDocuments.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConRelatedDocuments.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        webConRelatedDocuments.RecordTypeText__c  = 'Service_API';
        webConRelatedDocumentsList.add(webConRelatedDocuments);
        
        WebserviceConfigurations__c  webConRelatedDocuments1 = new WebserviceConfigurations__c ();
        webConRelatedDocuments1.GrantType__c  = 'client_credentials';
        webConRelatedDocuments1.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments1.Method__c  = 'GET';
        webConRelatedDocuments1.Name  = 'LinkClaimSearchByMember';
        webConRelatedDocuments1.Timeout__c = 10000;
        webConRelatedDocuments1.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        webConRelatedDocumentsList.add(webConRelatedDocuments1);
        webConRelatedDocuments.RecordTypeText__c  = 'Service_API';
        insert webConRelatedDocumentsList;
        
        List<Mock_Response_Details__c> mockResponseRecList = new List<Mock_Response_Details__c>();
        Mock_Response_Details__c mockResponseRec=new Mock_Response_Details__c();
        mockResponseRec.Status_Code__c='999';
        mockResponseRec.FileName__c='ClaimSummary_7867773888';
        mockResponseRec.SearchParameter__c='ClaimSummary_7867773888';
        mockResponseRec.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec);
        
        Mock_Response_Details__c mockResponseRec1=new Mock_Response_Details__c();
        mockResponseRec1.Status_Code__c='200';
        mockResponseRec1.FileName__c='ClaimSummary_18A902707070';
        mockResponseRec1.SearchParameter__c='ClaimSummary_18A902707070';
        mockResponseRec1.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec1);
        
        Mock_Response_Details__c mockResponseRec2=new Mock_Response_Details__c();
        mockResponseRec2.Status_Code__c='200';
        mockResponseRec2.FileName__c='ClaimSummaryByTin_741777515';
        mockResponseRec2.SearchParameter__c='ClaimSummaryByTin_741777515';
        mockResponseRec2.WebserviceConfigurations__c = webConRelatedDocuments1.id;
        mockResponseRecList.add(mockResponseRec2);
        
        Mock_Response_Details__c mockResponseRec3=new Mock_Response_Details__c();
        mockResponseRec3.Status_Code__c='200';
        mockResponseRec3.FileName__c='ClaimSummaryByTin_942854057';
        mockResponseRec3.SearchParameter__c='ClaimSummaryByTin_942854057';
        mockResponseRec3.WebserviceConfigurations__c = webConRelatedDocuments1.id;
        mockResponseRecList.add(mockResponseRec3);
        
        Mock_Response_Details__c mockResponseRec4=new Mock_Response_Details__c();
        mockResponseRec4.Status_Code__c='400';
        mockResponseRec4.FileName__c='ClaimSummary_7867775465';
        mockResponseRec4.SearchParameter__c='ClaimSummary_7867775465';
        mockResponseRec4.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec4);
        
        Mock_Response_Details__c mockResponseRec5=new Mock_Response_Details__c();
        mockResponseRec5.Status_Code__c='200';
        mockResponseRec5.FileName__c='ClaimSummaryByTin_942854234';
        mockResponseRec5.SearchParameter__c='ClaimSummaryByTin_942854234';
        mockResponseRec5.WebserviceConfigurations__c = webConRelatedDocuments1.id;
        mockResponseRecList.add(mockResponseRec5);
        
        Mock_Response_Details__c mockResponseRec6=new Mock_Response_Details__c();
        mockResponseRec6.Status_Code__c='200';
        mockResponseRec6.FileName__c='ClaimSummary_AA10219463';
        mockResponseRec6.SearchParameter__c='ClaimSummary_AA10219463';
        mockResponseRec6.WebserviceConfigurations__c = webConRelatedDocuments1.id;
        mockResponseRecList.add(mockResponseRec6);
        
        Mock_Response_Details__c mockResponseRec7=new Mock_Response_Details__c();
        mockResponseRec7.Status_Code__c='200';
        mockResponseRec7.FileName__c='ClaimSummary_7867773888';
        mockResponseRec7.SearchParameter__c='ClaimSummary_7867773888';
        mockResponseRec7.WebserviceConfigurations__c = webConRelatedDocuments1.id;
        mockResponseRecList.add(mockResponseRec7);
        
        Mock_Response_Details__c mockResponseRec8=new Mock_Response_Details__c();
        mockResponseRec8.Status_Code__c='200';
        mockResponseRec8.FileName__c='ClaimSummaryByTin_061330992';
        mockResponseRec8.SearchParameter__c='ClaimSummaryByTin_061330992';
        mockResponseRec8.WebserviceConfigurations__c = webConRelatedDocuments1.id;
        mockResponseRecList.add(mockResponseRec8);

        insert mockResponseRecList;
        
        List<OrgSpecificConfigurations__c> orgConfigList = new List<OrgSpecificConfigurations__c>();
        OrgSpecificConfigurations__c orgConfig = new OrgSpecificConfigurations__c();
        orgConfig.Name = 'slayerdev';
        orgConfig.WebserviceConfigurations__c = webConRelatedDocuments.id;
        orgConfig.EnableMock__c = true;
        orgConfig.EndpointDomain__c='https://api-gateway-stage.linkhealth.com/clink-api/api/claim/summary/v1.0';
        orgConfig.RecordTypeText__c='TokenAPI';
        orgConfigList.add(orgConfig);
        
        OrgSpecificConfigurations__c orgConfig3 = new OrgSpecificConfigurations__c();
        orgConfig3.Name = 'slayerdev';
        orgConfig3.WebserviceConfigurations__c = webConRelatedDocuments1.id;
        orgConfig3.EnableMock__c = true;
        orgConfig3.EndpointDomain__c='https://api-gateway-stage.linkhealth.com/clink-api/api/claim/summary/v1.0';
        orgConfig3.RecordTypeText__c='TokenAPI';
        orgConfigList.add(orgConfig3);
        
        insert orgConfigList;
    }
    static testMethod void test_SAEClaimSummaryJSON2Apex(){
        Test.startTest();
        SAEClaimSummaryJSON2Apex wrapper = new SAEClaimSummaryJSON2Apex();
        SAEClaimSummaryJSON2Apex.cls_claims claim = new  SAEClaimSummaryJSON2Apex.cls_claims();
        claim.claimNumber = '11234124';
        claim.claimStatus = 'DENIED';
        List<SAEClaimSummaryJSON2Apex.cls_claims> claimSearchResultList = new List<SAEClaimSummaryJSON2Apex.cls_claims>();
        wrapper.claims = claimSearchResultList;
        SAEClaimSummaryJSON2Apex.parse('{}');
        Test.stopTest();
    }
    static testMethod void test_claimWrapperTest(){
        Test.startTest();
        SAEEligibilityClaimDetailsJSON2Apex wrapper = new SAEEligibilityClaimDetailsJSON2Apex();
        wrapper.transactionId = '1234567890qwert';
        
        SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes codes = new SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes();
        codes.code = 'CS';
        codes.type = 'claim';
        codes.description = 'desc';
        
        SAEEligibilityClaimDetailsJSON2Apex.CobInfo cob = new SAEEligibilityClaimDetailsJSON2Apex.CobInfo();
        cob.claimOIPaidAmt = '123';
        cob.otherInsuredNm = '1234567';
        cob.primaryImpact = 'test';
        
        SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes dCode= new SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes();
        dCode.diagnosisCode = 'ds';
        
        SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo cDetails = new  SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo();
        cDetails.claimNumber = 'cl890';
        cDetails.cobInfo = cob;
        cDetails.diagnosisCodes = new List<SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes> {dCode};
            cDetails.lines = new List<SAEEligibilityClaimDetailsJSON2Apex.Lines> {new SAEEligibilityClaimDetailsJSON2Apex.Lines()};
                
                SAEEligibilityClaimDetailsJSON2Apex.Lines line = new SAEEligibilityClaimDetailsJSON2Apex.Lines();
        line.lineNbr = 'ln123';
        line.processedDt = '13-09-2019';
        line.firstSrvcDt = '13-09-2019';
        line.lastSrvcDt = '13-09-2019';
        line.srvcCode = 'cod123';
        //line.revenueCode = 'rv123';
        line.paidAmt = '890';
        line.allowdAmt = '890';
        line.provWrtOffAmt = '890';
        line.notCovAmt = '890';
        line.totalMemResp = '890';
        line.copay = '890';
        line.deductible = '890';
        line.coinsurance = '890';
        line.claimCodes = new List<SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes> {codes};
            
            
            Test.stopTest();
    }
    static testMethod void test_getClaimsAutodocTest(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.claimNumber = '18A902707070';
        claimInputs.taxId = '420982971';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'P';
        claimInputs.FromDate = '1/14/2020';
        claimInputs.ToDate = '5/14/2020';
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,true);
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    static testMethod void test_getClaimsAutodocTest1(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.claimNumber = '18A902707070';
        claimInputs.taxId = '420982971';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'ALL';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,false);
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    static testMethod void test_getClaimsAutodocTest2(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.claimNumber = '7867773888';
        claimInputs.taxId = '420982971';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'ALL';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,false);
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    static testMethod void test_getClaimsAutodocTest3(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.memberId = '3333333333';
        claimInputs.memberDOB = '10/14/2020';
        claimInputs.taxId = '741777515';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'H';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';
        claimInputs.AuthId = '1111111';
        claimInputs.selectedop = '';
        claimInputs.initailClaims = true;
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,false);
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    
    static testMethod void test_getClaimsAutodocTest4(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.claimNumber = '7867775465';
        claimInputs.payerId = '87726';
        claimInputs.ClaimType = 'P';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,false);
        Test.stopTest();
    }
    
    static testMethod void test_getClaimsAutodocTest5(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.memberId = '3333333333';
        claimInputs.memberDOB = '10/14/2020';
        claimInputs.taxId = '942854057';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'H';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';
        
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,true,1,false);
        Test.stopTest();
    }
    
    static testMethod void test_getClaimsAutodocTest6(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.memberId = '3333333333';
        claimInputs.memberDOB = '10/14/2020';
        claimInputs.taxId = '942854234';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'H';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';
        claimInputs.AuthId = '1111111';
        claimInputs.selectedop = '';
        claimInputs.initailClaims = true;
        Date dt = date.newinstance(2020, 2, 2);
        SAEClaimSearchController.getformatDate(dt);
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,true,1,false);
        Test.stopTest();
    }
    
    static testMethod void test_getClaimsAutodocTest7(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.claimNumber = 'AA10219463';
        claimInputs.payerId = '87726';
        claimInputs.ClaimType = 'P';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';      
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,true);
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    
    static testMethod void test_getClaimsAutodocTest8(){
        Test.startTest(); 
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.claimNumber = '7867773888';
        claimInputs.payerId = '87726';
        claimInputs.ClaimType = 'P';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';      
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,true);        
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    static testMethod void test_getClaimsAutodocTest9(){
         Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.memberId = '3333333333';
        claimInputs.memberDOB = '10/14/2020';
        claimInputs.taxId = '061330992';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'H';
        claimInputs.FromDate = '10/14/2020';
        claimInputs.ToDate = '10/14/2020';
        claimInputs.AuthId = '1111111';
        claimInputs.selectedop = '';
        claimInputs.initailClaims = true;
        SAEClaimSearchController.SearchResultWrapper result = SAEClaimSearchController.getClaimsAutodoc(claimInputs,true,false,1,false);
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    static testMethod void test_ACET_ProviderLookupController(){
        ACET_ProviderLookupController.PolicyDetails policy = new ACET_ProviderLookupController.PolicyDetails();
        String taxid='000006798';
        String pid='000006798';
        String pid1='977411242';
        String pnum='90125';
        String pcode='CO';

        ACET_ProviderLookupController.CoverageDateWrapper c =new ACET_ProviderLookupController.CoverageDateWrapper();
        c.coverageStartDate = '06-19-2019';
        c.coverageEndDate = '06-19-2019';
        ACET_ProviderLookupController.getMAndRProviderStatus(taxid,pid,'',policy,'');
        ACET_ProviderLookupController.getNetworkKeyStatus(pid1,pnum,pcode,'','',false);
        ACET_ProviderLookupController.getEAndIProviderStatusNew(taxid,pid,'',policy,'','');
        ACET_ProviderLookupController.getLookupData(taxid,pid,pid1,'','','','','','','','','','','','','','','','',1,3,true,
                                                   '','','','','','','');
        ACET_ProviderLookupController.getProviderLookupResults('', '', '', '', '', '',
        '', '', '', '', '', '', '',
        '', 'NTL', '', '', '', '',
        1, 5, true, '', '', '', '',
        '', '', '', false, pcode, c);
        ACET_ProviderLookupController.getProviderDetaiils(taxid,pid,'');

    }

    static testMethod void getfieldValueTest(){
        SAEClaimSearchResult.ClaimSearchResult clm = new SAEClaimSearchResult.ClaimSearchResult();
        string fieldValue = SAEClaimSearchController.getfieldValue(clm.providerID);
        SAEClaimSearchResult csr = new SAEClaimSearchResult();
        SAEClaimSearchResult.ClaimSearchResult res = new SAEClaimSearchResult.ClaimSearchResult();
        res.claimNumber='str';
        res.taxID='str';
        res.providerID='str';
        res.providerName='str';
        res.DOSStart='str';
        res.DOSEnd='str';
        res.charged='str';
        res.status='str';
        res.paperlessInd='str';
        res.receivedDate='str';
        res.initialDueDate='str';
        res.processDate='str';
        res.totalDeductibleAmt='str';// Bharath Added:10/5/2020
        res.totalCoinsuranceAmt='str';// Bharath Added:10/5/2020
		res.claimtype='str';// Tilak Added:10/12/2020
		res.billTyp='str'; // Raviteja Added:10/05/2021 Team Blinkers
        res.drgNbr='str';
        res.billMpin='str';
        res.billServicepin='str';
        //res.processedDt='str';
        //res.claimStatus='str';
        res.networkStatus='str';
        res.totalChargedAmt='str';
        //total denied amount on claim status
        res.totalDeniedAmount='str';
        res.totalAllowdAmt='str';
        res.deductibleAmt='str';
        res.totalCopayAmt='str';
        res.totalCoinsAmt='str';
        res.totalPaidAmt='str';
        res.provNotCovAmt='str';
        res.provWriteOffAmt='str';
        res.totalPtntRespAmt='str';
        res.claimBenefitlevel='str';
        res.chkInfo='str'; // Added by Mani 11/24/2020 US1866504
        res.ptntLn='str';
        res.ptntFn='str';
        res.platform='str';
        res.referralId='str';
        res.ptntDob='str';
        res.sbmtMembrId='str'; 	//ketki -3/28 getting member id in focus
        res.policyNbr='str'; //ketki -3/28 getting policy number from claim response
        res.adjTaxID='str';
        res.adjservicingMpin='str';
        res.adjProviderID='str';
        res.adjProviderName='str';
        res.TopsAdditionalInfo='str';
        res.contractId='str';
        res.caeClmNbr='str'; //US3457078
        res.resubmCaeClmNbr='str'; //US3457078
        res.chwyIcn='str'; //US3457078
		res.ptntAcctNbr='str'; //US3477116
        res.tin='str'; //US3477116
        res.tinPrfx='str'; //US3477116
        res.tinSufx='str'; //US3477116
        SAEClaimSearchResult.cls_claimCodes res1 = new SAEClaimSearchResult.cls_claimCodes();
        res1.type ='str';
		res1.code='str';
		res1.description='str';
		ACET_ViewPaymentsCheckSearchWrapper.ProviderId proId= new ACET_ViewPaymentsCheckSearchWrapper.ProviderId();
		proId.providerTin='str';
		proId.providerPrefix='str';
		proId.providerSuffix='str';
		ACET_ViewPaymentsCheckSearchWrapper.PostalAddress postAdd= new ACET_ViewPaymentsCheckSearchWrapper.PostalAddress();
		postAdd.addressLine1='str';
		postAdd.addressLine2='str';
		postAdd.city='str';
		postAdd.state='str';
		postAdd.zip='str';
		ACET_ViewPaymentsCheckSearchWrapper.DraftItem Dft= new ACET_ViewPaymentsCheckSearchWrapper.DraftItem();
		Dft.draftNumber='str';
		Dft.draftSequenceNumber='str';
		Dft.bankCode='str';
		Dft.topsEngineCode='str';
		Dft.transactionType='str';
		Dft.paidAmount='str';
		Dft.payLocation='str';
		Dft.draftStatusCode='str';
		ACET_ViewPaymentsCheckSearchWrapper.Check chk= new ACET_ViewPaymentsCheckSearchWrapper.Check();
		chk.checkIssueDate='str';
		chk.checkAmount='str';
		chk.componentCount='str';
		chk.adjustmentStatus='str';
		chk.adjustmentTypeCode='str';
		chk.sourceCode='str';
		chk.bulkRecoveryIndicator='str';
		chk.bulkRecoveryAmount='str';
		ACET_ViewPaymentsCheckSearchWrapper.DraftDetail dd= new ACET_ViewPaymentsCheckSearchWrapper.DraftDetail();
		dd.policyNumber='str';
		dd.subscriberId='str';
		dd.dependentNumnber='str';
		dd.firstName='str';
		dd.lastName='str';
		dd.relationshipCode='str';
		dd.icn='str';
		dd.icnSuffix='str';
		dd.processedDate='str';
		dd.processedTime='str';
		dd.icnDraftSequenceNumber='str';
		dd.filmOffice='str';
		dd.flnJulianDate='str';
		dd.flnSRLNumber='str';
		ACET_ViewPaymentsCheckSearchWrapper.Payee cs= new ACET_ViewPaymentsCheckSearchWrapper.Payee();
		cs.payeeType='str';
		cs.payeeTypeDescription='str';
		cs.payeeFirstName='str';
		cs.payeelastName='str';
		ACET_ViewPaymentsCheckSearchWrapper.PagingState ps= new ACET_ViewPaymentsCheckSearchWrapper.PagingState();
		ps.moreData='str';
		ps.nextKey='str';    
    }
    
}