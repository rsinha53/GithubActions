@istest
private class ACETClaimPaymentControllerTest{
    static testMethod void testACETClaimPaymentController(){
        
        PageReference pageRef = Page.ACETClaimPayment;
        Test.setCurrentPage(pageRef);
        Test.startTest();      
        ACETClaimPaymentController claimpayment= new ACETClaimPaymentController();      
        ACETGetClaimCheckStatusResult checks = new ACETGetClaimCheckStatusResult();
        checks.CashedDate = Date.today();
        checks.VoidStopDate = Date.today();
        checks.ReturnedDate = 'test';
        checks.RemailedDate = 'test';
        checks.checkStatus = 'test';
        checks.issuedDate = 'test'; 
        String testGetChecks = claimpayment.getChecks();
        Test.stopTest();
        
    }
    static testMethod void ACETClaimPaymentControllerTest1() 
    {
        ACETClaimPaymentResult.Claims clm = new ACETClaimPaymentResult.Claims();
        clm.ClaimNumber = 'test';
        clm.MemberID = 'test';
        clm.PolicyNumber = 'test';
        clm.PatientAccountNumber = 'test';
        clm.FirstName = 'test';
        clm.LastName = 'test';
        clm.Relationship = 'test';
        clm.PaidAmount = 'test';
        clm.StartDate = 'test';
        clm.EndDate = 'test';
        ACETClaimPaymentResult res = new ACETClaimPaymentResult();
        res.PayeeAddressCity = 'test';
        res.PayeeAddressState = 'test';
        res.PayeeAddressZip = 'test';
        res.CheckStatus='test';
        res.IssuedDate=system.today();
        ACETClaimPaymentController.WrapperPayeeInformation wrpayeeinfo = new ACETClaimPaymentController.WrapperPayeeInformation();
        wrpayeeinfo.PayeeType = 'test';
        wrpayeeinfo.PayeeID = 'test';
        wrpayeeinfo.PayeeName = 'test';
        wrpayeeinfo.PayeeAddressLine1 = 'test';
        wrpayeeinfo.PayeeAddressLine2 = 'test';
        wrpayeeinfo.City = 'test';
        wrpayeeinfo.State = 'test';
        wrpayeeinfo.Zip = 'test';
        ACETClaimPaymentController.WrapperPaidClaims wrclaims = new ACETClaimPaymentController.WrapperPaidClaims();
        wrclaims.ClaimNumber = 'test';
        wrclaims.MemberID = 'test';
        wrclaims.PolicyNumber = 'test';
        wrclaims.PatientAccountNumber = 'test';
        wrclaims.FirstName = 'test';
        wrclaims.LastName = 'test';
        wrclaims.Relationship = 'test';
        wrclaims.PaidAmount = 'test';
        wrclaims.StartDate = 'test';
        wrclaims.EndDate = 'test';
        // Claim Payment summary mock webservice
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        
        insert lstISLWSConfigs;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"9","description":"prov TIN"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"RFV9999998","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"Y","checkOrEFTAmount":"100.31","overPaymentWithheldAmt":"72.20"}]},{"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]},{"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"9","description":"prov TIN"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"BKD9517535","paymentIssueDate":"2017-01-21","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"Y","checkOrEFTAmount":"56.31","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"25"}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        // Get Check status mock service  
        //Setup records in custom setting
        
        
        // Set mock callout class
        PageReference ACETCPPage = Page.ACETClaimPayment;        
        test.setCurrentPage(ACETCPPage);
        ACETClaimPaymentControllerTest.setTestData('');    
        Test.startTest(); 
        
        
        ACETClaimPaymentController controller = new ACETClaimPaymentController();
        controller.ProviderId = '';
        controller.TaxId = '';
        controller.NPI = '';
        controller.CallCode = '';
        controller.CheckNumber = '';
        controller.SeriesDesignator = '';
        controller.TotalPayment = '';
        controller.LastName = '';
        controller.FirstName = '';
        controller.MemberId = '';
        controller.PolicyNumber = '';
        //controller.SelectedPaymentGUID = controller.Payments[0].GUID;  
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetCheckStatusJSON());
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);  
        controller.search();
        controller.searchutil();
        controller.showDetailsSection();     
        controller.clear();
        Test.stopTest();
    }
    static testMethod void ACETClaimPaymentControllerTest2() 
    {
        
        ACETClaimPaymentController.WrapperPayeeInformation wrpayeeinfo = new ACETClaimPaymentController.WrapperPayeeInformation();
        wrpayeeinfo.PayeeType = 'test';
        wrpayeeinfo.PayeeID = 'test';
        wrpayeeinfo.PayeeName = 'test';
        wrpayeeinfo.PayeeAddressLine1 = 'test';
        wrpayeeinfo.PayeeAddressLine2 = 'test';
        wrpayeeinfo.City = 'test';
        wrpayeeinfo.State = 'test';
        wrpayeeinfo.Zip = 'test';
        ACETClaimPaymentController.WrapperPaidClaims wrclaims = new ACETClaimPaymentController.WrapperPaidClaims();
        wrclaims.ClaimNumber = 'test';
        wrclaims.MemberID = 'test';
        wrclaims.PolicyNumber = 'test';
        wrclaims.PatientAccountNumber = 'test';
        wrclaims.FirstName = 'test';
        wrclaims.LastName = 'test';
        wrclaims.Relationship = 'test';
        wrclaims.PaidAmount = 'test';
        wrclaims.StartDate = 'test';
        wrclaims.EndDate = 'test';
        // Claim Payment summary mock webservice
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        
        insert lstISLWSConfigs;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"1","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"25","recordCount":"1","totalCount":"1"}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        // Get Check status mock service  
        //Setup records in custom setting
        
        ApexPages.currentPage().getParameters().put('SRK','690242');
        // Set mock callout class
        PageReference ACETCPPage = Page.ACETClaimPayment;        
        test.setCurrentPage(ACETCPPage);
        //ACETClaimPaymentControllerTest.setTestData(''); 
        Interaction__c inte= new Interaction__c();
        
        inte.Originator_Type__c = 'Provider';
        insert inte;
       // Contact con = TestDataFactory.createContactwithEID();  
                  RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        //Interaction__c inte = TestDataFactory.createInteraction();
        ApexPages.currentPage().getParameters().put('interactionId',inte.id);    
        ApexPages.currentPage().getParameters().put('contactId',con.id);
        ApexPages.currentPage().getParameters().put('Id','73452645');
        ApexPages.currentPage().getParameters().put('firstName','Connie');
        ApexPages.currentPage().getParameters().put('lastName','Reed');
        ApexPages.currentPage().getParameters().put('sourceOriginator','FAX');  
        ApexPages.currentPage().getParameters().put('CheckNumber','183847');
        ApexPages.currentPage().getParameters().put('SeriesDesignator','PH');  
        ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
        ACETHighlightsPanelAdditionalInfo info = new ACETHighlightsPanelAdditionalInfo();
        info.isMember = 'false';
        info.FirstName = 'test';
        info.LastName = 'test';
        info.DOB = '1/1/1111';
        
        
        ApexPages.currentPage().getParameters().put('additionalInfo', json.serialize(info));  
        Test.startTest(); 
        
        ACETClaimPaymentController controller = new ACETClaimPaymentController();
        
        controller.ProviderId = '';
        controller.TaxId = '';
        controller.NPI = '';
        controller.CallCode = '';
        controller.CheckNumber = '30000043';
        controller.SeriesDesignator = '';
        controller.TotalPayment = '';
        controller.LastName = '';
        controller.FirstName = '';
        controller.MemberId = '';
        controller.PolicyNumber = '';
        //controller.SelectedPaymentGUID = controller.Payments[0].GUID;  
        /*MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetCheckStatusJSON());
OILResponse1.TokenExpired = false;        
MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
Test.setMock(HttpCalloutMock.class, MockHttpRes1);   */
        controller.search();
        controller.searchutil();
        controller.showDetailsSection();     
        controller.clear();
        controller.getDummyProvider();
        
        
        Test.stopTest();
    }
    
    static testMethod void ACETClaimPaymentControllerTest3() 
    {
        ACETFindClaimPaymentJSON2Apex.cls_name clsname = new ACETFindClaimPaymentJSON2Apex.cls_name();
        clsname.firstName = 'test';
        clsname.lastName = 'test';
        
        ACETFindClaimPaymentJSON2Apex.cls_identifiers iden = new ACETFindClaimPaymentJSON2Apex.cls_identifiers();
        iden.id = 'test';
        iden.sourceSysCode = 'test';
        iden.type = 'test';
        List<ACETFindClaimPaymentJSON2Apex.cls_identifiers> listiden = new List<ACETFindClaimPaymentJSON2Apex.cls_identifiers>();
        listiden.add(iden);
        
        ACETFindClaimPaymentJSON2Apex.cls_billingProvider billprov = new ACETFindClaimPaymentJSON2Apex.cls_billingProvider();
        billprov.providerFirstName = 'test';
        billprov.providerID = 'test';
        billprov.providerLastName = 'test';
        billprov.providerNPI = 'test';
        billprov.providerOrganizationName = 'test';
        billprov.providerTIN = 'test';
        
        ACETFindClaimPaymentJSON2Apex.cls_renderingProvider rendering = new ACETFindClaimPaymentJSON2Apex.cls_renderingProvider();
        rendering.providerFirstName = 'test';
        rendering.providerID = 'test';
        rendering.providerLastName = 'test';
        List<ACETFindClaimPaymentJSON2Apex.cls_renderingProvider> listredering= new List<ACETFindClaimPaymentJSON2Apex.cls_renderingProvider>();
        listredering.add(rendering);
        
        ACETFindClaimPaymentJSON2Apex.cls_Pagination pagin = new ACETFindClaimPaymentJSON2Apex.cls_Pagination();
        pagin.pageNumber = '1';
        pagin.pageSize = '50';
        pagin.recordCount = '100';
        pagin.totalCount = '200';
        
        ACETFindClaimPaymentJSON2Apex.cls_payeeTypeCode typecode = new ACETFindClaimPaymentJSON2Apex.cls_payeeTypeCode();
        typecode.code = '1';
        typecode.description = 'test';
        
        ACETFindClaimPaymentJSON2Apex.cls_payeeAddress payeeaddress = new ACETFindClaimPaymentJSON2Apex.cls_payeeAddress();
        payeeaddress.addressLine1 = 'test';
        payeeaddress.addressLine2 = 'test';
        payeeaddress.city = 'test';
        payeeaddress.postalCode = '75039';
        payeeaddress.state = 'TX';
        
        ACETFindClaimPaymentJSON2Apex.cls_paymentStatus paystatus = new ACETFindClaimPaymentJSON2Apex.cls_paymentStatus();
        paystatus.code = '1';
        
        ACETFindClaimPaymentJSON2Apex.cls_payment payment = new ACETFindClaimPaymentJSON2Apex.cls_payment();
        payment.bulkPaymentIndicator = 'test';
        payment.checkOrEFTAmount = 'test';
        payment.checkSeriesDesignatorNumber = 'test';
        payment.overPaymentWithheldAmt = 'test';
        payment.payeeAddress = payeeaddress;
        payment.payeeName = 'test';
        payment.payeeTypeCode = typecode;
        payment.paymentIssueDate = 'test';
        payment.paymentMethodTypeCode = 'test';
        payment.paymentStatus = paystatus;
        
        ACETFindClaimPaymentJSON2Apex.cls_patient patient = new ACETFindClaimPaymentJSON2Apex.cls_patient();
        patient.cardSerialNumber = 'test';
        patient.memberGroupNumber = 'test';
        patient.relationshipCode = '1';
        patient.name = clsname;
        patient.identifiers = listiden;
        
        ACETFindClaimPaymentJSON2Apex.cls_claim clsclm = new ACETFindClaimPaymentJSON2Apex.cls_claim();
        clsclm.claimID= 'test';
        clsclm.claimFirstDateofService = 'test';
        clsclm.claimLastDateofService = 'test';
        clsclm.claimEventAdjudicationDateTime = 'test';
        clsclm.patientAccountNumber = 'test';
        clsclm.claimTotalPaidAmount = 'test';
        clsclm.patient = patient;
        clsclm.billingProvider = billprov;
        clsclm.renderingProvider = listredering;
        
        ACETFindClaimPaymentJSON2Apex newparse = ACETFindClaimPaymentJSON2Apex.parse('{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"1","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"25","recordCount":"1","totalCount":"1"}}}');
        
        
        ACETClaimPaymentController.WrapperPayeeInformation wrpayeeinfo = new ACETClaimPaymentController.WrapperPayeeInformation();
        wrpayeeinfo.PayeeType = 'test';
        wrpayeeinfo.PayeeID = 'test';
        wrpayeeinfo.PayeeName = 'test';
        wrpayeeinfo.PayeeAddressLine1 = 'test';
        wrpayeeinfo.PayeeAddressLine2 = 'test';
        wrpayeeinfo.City = 'test';
        wrpayeeinfo.State = 'test';
        wrpayeeinfo.Zip = 'test';
        ACETClaimPaymentController.WrapperPaidClaims wrclaims = new ACETClaimPaymentController.WrapperPaidClaims();
        wrclaims.ClaimNumber = 'test';
        wrclaims.MemberID = 'test';
        wrclaims.PolicyNumber = 'test';
        wrclaims.PatientAccountNumber = 'test';
        wrclaims.FirstName = 'test';
        wrclaims.LastName = 'test';
        wrclaims.Relationship = 'test';
        wrclaims.PaidAmount = 'test';
        wrclaims.StartDate = 'test';
        wrclaims.EndDate = 'test';
        // Claim Payment summary mock webservice
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        
        insert lstISLWSConfigs;
        
        // Get Check status mock service  
        //Setup records in custom setting
        
        ApexPages.currentPage().getParameters().put('SRK','690242');
        // Set mock callout class
        PageReference ACETCPPage = Page.ACETClaimPayment;        
        test.setCurrentPage(ACETCPPage);
        ACETClaimPaymentControllerTest.setTestData('');    
        Test.startTest(); 
        ACETClaimPaymentController controller = new ACETClaimPaymentController();
        
        controller.ProviderId = '';
        controller.TaxId = '';
        controller.NPI = '';
        controller.CallCode = '';
        controller.CheckNumber = '';
        controller.SeriesDesignator = '';
        controller.TotalPayment = '';
        controller.LastName = '';
        controller.FirstName = '';
        controller.MemberId = '';
        controller.PolicyNumber = '';
        //controller.SelectedPaymentGUID = controller.Payments[0].GUID;  
        
        
        
        
        Test.stopTest();
    }
    
    private static void setTestData(String flow){        
       // Contact con = TestDataFactory.createContactwithEID();  
       RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
              
        Interaction__c inte = TestDataFactory.createInteraction();
        ApexPages.currentPage().getParameters().put('interactionId',inte.id);    
        ApexPages.currentPage().getParameters().put('contactId',con.id);
        ApexPages.currentPage().getParameters().put('Id','73452645');
        ApexPages.currentPage().getParameters().put('firstName','Connie');
        ApexPages.currentPage().getParameters().put('lastName','Reed');
        ApexPages.currentPage().getParameters().put('sourceOriginator','FAX');  
        ApexPages.currentPage().getParameters().put('CheckNumber','183847');
        ApexPages.currentPage().getParameters().put('SeriesDesignator','PH');  
        ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
        ApexPages.currentPage().getParameters().put('additionalInfo', json.serialize(md));        
    }
    
    static testMethod void ACETClaimPaymentControllerTest5() 
    {
        
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        
        insert lstISLWSConfigs;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"9","description":"prov TIN"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"RFV9999998","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"Y","checkOrEFTAmount":"100.31","overPaymentWithheldAmt":"72.20"}]},{"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]},{"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"9","description":"prov TIN"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"BKD9517535","paymentIssueDate":"2017-01-21","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"Y","checkOrEFTAmount":"56.31","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"25"}}}');
        OILResponse.TokenExpired = false; 
        
        ACETFindClaimPaymentWebService ws = new ACETFindClaimPaymentWebService();
        ACETWSCalloutResult acetres = new ACETWSCalloutResult();
        
        // Set mock callout class
        PageReference ACETCPPage = Page.ACETClaimPayment;        
        test.setCurrentPage(ACETCPPage);
        ACETClaimPaymentControllerTest.setTestData('');    
        Test.startTest(); 
        
        
        ACETClaimPaymentController controller = new ACETClaimPaymentController();
        controller.ProviderId = '';
        controller.TaxId = '';
        controller.NPI = '';
        controller.CallCode = '';
        controller.CheckNumber = '';
        controller.SeriesDesignator = '';
        controller.TotalPayment = '';
        controller.LastName = '';
        controller.FirstName = '';
        controller.MemberId = '';
        controller.PolicyNumber = '';
        //controller.SelectedPaymentGUID = controller.Payments[0].GUID;  
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetCheckStatusJSON());
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);   
        controller.searchutil();
        controller.showDetailsSection();     
        controller.clear();
        Test.stopTest();
        controller.PaymentType = 'test';
        controller.RemailedDate = 'test';
        controller.ReturnedDate = 'test';
        controller.issuedDate = 'test';
        controller.checks = new ACETGetClaimCheckStatusResult();
        controller.VoidStopDate = date.parse('12/27/2009');
        controller.CashedDate = date.parse('12/27/2009');
        controller.CheckImageUrl = 'test';

        
    }
    
    static testMethod void ACETClaimPaymentControllerTest6() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"MS27810004","claimFirstDateofService":"2017-07-01","claimLastDateofService":"2017-07-10","patient":{"name":{"firstName":"JESSICA","lastName":"WERHANE"},"identifiers":[{"id":"620710139","type":"1058480","sourceSysCode":"CR"}],"relationshipCode":"18","cardSerialNumber":"51754772900"},"billingProvider":{"providerLastName":"BOUTIN, RYAN","providerNPI":"1699094201","providerID":"367545680040174627","providerTIN":"060646818"},"renderingProvider":[{}],"claimTotalPaidAmount":"500"}],"payment":[{"payeeName":"MIDDLESEX HOSPITAL PHYSICIANS SERVICES","payeeTypeCode":{"code":"03","description":"Provider"},"payeeAddress":{"addressLine1":"28 CRESCENT ST","city":"MIDDLETOWN","postalCode":"06457-3654","state":"CT"},"paymentTrackingNumber":"1208476","checkSeriesDesignatorNumber":"510","paymentIssueDate":"2017-08-17","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"N","checkOrEFTAmount":"500","paymentStatus":{"code":"O"}}]}]}}');
        OILResponse.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        ACETFindClaimPaymentWebService ws = new ACETFindClaimPaymentWebService();
        
        ACETWSCalloutResult acetres = ws.getClaimPayments('MS0001234');
    }
    
    static testMethod void ACETClaimPaymentControllerTest7() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"1","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest11() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"MS27810004","claimFirstDateofService":"2017-07-01","claimLastDateofService":"2017-07-10","patient":{"name":{"firstName":"JESSICA","lastName":"WERHANE"},"identifiers":[{"id":"620710139","type":"1058480","sourceSysCode":"CR"}],"relationshipCode":"18","cardSerialNumber":"51754772900"},"billingProvider":{"providerLastName":"BOUTIN, RYAN","providerNPI":"1699094201","providerID":"367545680040174627","providerTIN":"060646818"},"renderingProvider":[{}],"claimTotalPaidAmount":"500"}],"payment":[{"payeeName":"MIDDLESEX HOSPITAL PHYSICIANS SERVICES","payeeTypeCode":{"code":"03","description":"Provider"},"payeeAddress":{"addressLine1":"28 CRESCENT ST","city":"MIDDLETOWN","postalCode":"06457-3654","state":"CT"},"paymentTrackingNumber":"1208476","checkSeriesDesignatorNumber":"510","paymentIssueDate":"2017-08-17","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"N","checkOrEFTAmount":"500","paymentStatus":{"code":"O"}}]}]}}');
        OILResponse.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        ACETFindClaimPaymentWebService ws = new ACETFindClaimPaymentWebService();
        
        ACETWSCalloutResult acetres = ws.getClaimPayments('MS0001234');
    }
    
    static testMethod void ACETClaimPaymentControllerTest8() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"3","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    
    static testMethod void ACETClaimPaymentControllerTest9() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"MS27810004","claimFirstDateofService":"2017-07-01","claimLastDateofService":"2017-07-10","patient":{"name":{"firstName":"JESSICA","lastName":"WERHANE"},"identifiers":[{"id":"620710139","type":"1058480","sourceSysCode":"CR"}],"relationshipCode":"4","cardSerialNumber":"51754772900"},"billingProvider":{"providerLastName":"BOUTIN, RYAN","providerNPI":"1699094201","providerID":"367545680040174627","providerTIN":"060646818"},"renderingProvider":[{}],"claimTotalPaidAmount":"500"}],"payment":[{"payeeName":"MIDDLESEX HOSPITAL PHYSICIANS SERVICES","payeeTypeCode":{"code":"03","description":"Provider"},"payeeAddress":{"addressLine1":"28 CRESCENT ST","city":"MIDDLETOWN","postalCode":"06457-3654","state":"CT"},"paymentTrackingNumber":"1208476","checkSeriesDesignatorNumber":"510","paymentIssueDate":"2017-08-17","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"N","checkOrEFTAmount":"500","paymentStatus":{"code":"O"}}]}]}}');
        OILResponse.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        ACETFindClaimPaymentWebService ws = new ACETFindClaimPaymentWebService();
        
        ACETWSCalloutResult acetres = ws.getClaimPayments('MS0001234');
        
        
        
        
        OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', '');
        OILResponse.TokenExpired = false; 
        MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        
        acetres = ws.getClaimPayments('MS0001234');
        

        
        OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', '');
        OILResponse.TokenExpired = false; 
        MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        
        acetres = ws.getClaimPayments('MS0001234');
        
        OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'Resource Not Found', '');
        OILResponse.TokenExpired = false; 
        MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        
        acetres = ws.getClaimPayments('MS0001234');
        
        
        
        
        ws.init('test');
        
        
        OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"EXCEPTIONfindClaimPaymentResponse":{"claimpayment":[{"claim":[{"claimID":"MS27810004","claimFirstDateofService":"2017-07-01","claimLastDateofService":"2017-07-10","patient":{"name":{"firstName":"JESSICA","lastName":"WERHANE"},"identifiers":[{"id":"620710139","type":"1058480","sourceSysCode":"CR"}],"relationshipCode":"4","cardSerialNumber":"51754772900"},"billingProvider":{"providerLastName":"BOUTIN, RYAN","providerNPI":"1699094201","providerID":"367545680040174627","providerTIN":"060646818"},"renderingProvider":[{}],"claimTotalPaidAmount":"500"}],"payment":[{"payeeName":"MIDDLESEX HOSPITAL PHYSICIANS SERVICES","payeeTypeCode":{"code":"03","description":"Provider"},"payeeAddress":{"addressLine1":"28 CRESCENT ST","city":"MIDDLETOWN","postalCode":"06457-3654","state":"CT"},"paymentTrackingNumber":"1208476","checkSeriesDesignatorNumber":"510","paymentIssueDate":"2017-08-17","paymentMethodTypeCode":"CHK","bulkPaymentIndicator":"N","checkOrEFTAmount":"500","paymentStatus":{"code":"O"}}]}]}}');
        OILResponse.TokenExpired = false; 
        MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        acetres = ws.getClaimPayments('MS0001234');
        

    }
    
    static testMethod void ACETClaimPaymentControllerTest10() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"5","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    
    static testMethod void ACETClaimPaymentControllerTest12() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"6","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest13() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"7","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest14() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"8","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest15() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"9","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    
    static testMethod void ACETClaimPaymentControllerTest16() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"10","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest17() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"11","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest18() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"12","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest19() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"13","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest20() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"14","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest21() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"15","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest22() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"17","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest23() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"18","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest24() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"19","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest25() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"23","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest26() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"24","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest27() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"25","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    static testMethod void ACETClaimPaymentControllerTest28() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findClaimPaymentsResponse":{"claimpayment":[{"claim":[{"claimID":"9999732874","claimFirstDateofService":"2017-02-16","claimLastDateofService":"2017-02-16","claimEventAdjudicationDateTime":"2017-03-02T07:07:34Z","patient":{"name":{"firstName":"John","lastName":"Hill"},"identifiers":[{"type":"AE99991074598","sourceSysCode":"CR"}],"relationshipCode":"26","cardSerialNumber":"AE99996F6F6F","memberGroupNumber":"446686468"},"patientAccountNumber":"0987654321","billingProvider":{"providerFirstName":"Joe","providerLastName":"Metzinski","providerNPI":"1245612456","providerID":"2382388321","providerTIN":"145689022"},"renderingProvider":[{"providerOrganizationName":"RallyforHealth","providerID":"8968966981"}],"claimTotalPaidAmount":"500.55","paymentStatus":{"code":"P","description":"Paid"}}],"payment":[{"payeeName":"Humana","payeeTypeCode":{"code":"7","description":"member"},"payeeAddress":{"addressLine1":"12751","addressLine2":"North Wood Street","city":"Southfield","postalCode":"48034","state":"MI"},"paymentTrackingNumber":"6666666612345678","checkSeriesDesignatorNumber":"JYN6520820","paymentIssueDate":"2017-02-21","paymentMethodTypeCode":"FWT","bulkPaymentIndicator":"Y","checkOrEFTAmount":"150.71","overPaymentWithheldAmt":"72.20"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1"}}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETFindClaimPaymentWebService aws = new ACETFindClaimPaymentWebService();
        aws.queryPaginatedData(1, 50, 1);
    }
    
    static testMethod void ACETClaimPaymentControllerTest29() 
    {
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getCheckStatusResponse": {"voidDate":"2012-12-12","ReturnedDate":"12-12-2012","RemailedDate":"12-12-2012","issuedDate":"12-12-2012","checkStatus":"Matched; Outstanding","CashedDate":"2012-12-12"}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETGetClaimCheckStatusWebService service = new ACETGetClaimCheckStatusWebService();
        ACETWSCalloutResult ares1 = service.getCheckstatus('123', '123');
        ACETGetCheckStatusWebService aws = new ACETGetCheckStatusWebService();
        ACETWSCalloutResult ares =  aws.getCheckStatus('123','234');
    }
    static testMethod void ACETClaimPaymentControllerTest30() 
    {
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getCheckStatusResponse": {"voidDate":"2012-12-12","ReturnedDate":"12-12-2012","RemailedDate":"12-12-2012","issuedDate":"12-12-2012","checkStatus":"status","CashedDate":"2012-12-12"}}');
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETGetClaimCheckStatusWebService service = new ACETGetClaimCheckStatusWebService();
        ACETWSCalloutResult ares1 = service.getCheckstatus('123', '123');
        ACETGetCheckStatusWebService aws = new ACETGetCheckStatusWebService();
        ACETWSCalloutResult ares =  aws.getCheckStatus('123','234');
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '{"getCheckStatusResponse": {"voidDate":"2012-12-12","ReturnedDate":"12-12-2012","RemailedDate":"12-12-2012","issuedDate":"12-12-2012","checkStatus":"status","CashedDate":"2012-12-12"}}');
        OILResponse3.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1); 
        ACETGetClaimCheckStatusWebService service1 = new ACETGetClaimCheckStatusWebService();
        ACETWSCalloutResult ares2 = service1.getCheckstatus('123', '123');
        ACETGetCheckStatusWebService aws1 = new ACETGetCheckStatusWebService();
        ACETWSCalloutResult ares3 =  aws1.getCheckStatus('123','234');
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getCheckStatusResponse": {}');
        OILResponse4.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse4);
        Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
        ACETGetClaimCheckStatusWebService service2 = new ACETGetClaimCheckStatusWebService();
        ACETWSCalloutResult ares4 = service2.getCheckstatus('123', '123');
        ACETGetCheckStatusWebService aws2 = new ACETGetCheckStatusWebService();
        ACETWSCalloutResult ares5 =  aws2.getCheckStatus('123','234');
    }
    
    static testmethod void ACETClaimPaymentControllertest31()
    {
        Test.startTest();
        ACETClaimPaymentController controller = new ACETClaimPaymentController();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Not Found', 'Not Found');
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);  
        controller.search();
        controller.searchutil();
        controller.showDetailsSection();     
        controller.clear();
        Test.stopTest();
    }
}