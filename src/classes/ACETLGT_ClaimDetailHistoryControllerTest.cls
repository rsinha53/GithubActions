@isTest
    private class ACETLGT_ClaimDetailHistoryControllerTest{
       
        static testMethod void ACETLGT_ClaimDetailHistoryTest(){
           
        //StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'professionalClaimHistoryRequest'];
      //  String ResponseJSON = ResponseJSONSR.Body.toString(); 
         MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse1= new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"professionalClaimHistoryResponse":{"professionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","otherPayer":[{"otherInsuranceSubscriberID":{"id":"6482910","type":"id"},"otherInsuranceSubscriberName":{"firstName":"John","middleName":"M","lastName":"Gartner","suffix":"M"},"payerResponsibilitySequenceCode":{"code":"H636","description":"payerResponsibilitySequenceCodeDescription 128"},"otherInsurancePayerID":"A12","otherInsurancePayerName":"Medico Plus","insuranceTypeCode":{"code":"S232","description":"otherInsuranceTypeCodeDescription 126"},"claimTotalOtherPayerPaidAmount":"122.23","claimTotalOtherPayerPatientResponsibilityAmount":"187.23","claimTotalOtherPayerNotCoveredAmount":"268.23"}],"claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        OILTestResponse1.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse1 = new MockHttpCalloutResponseGenerator(null, OILTestResponse1);
       Test.setMock(HttpCalloutMock.class, MockHttpResponse1);
        ACETLGT_ClaimDetailHistoryController.getProfClaimDetail('','','');
             
        } 
        static testMethod void ACETLGT_ClaimDetailHistoryTest1(){
           
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'institutionalClaimHistoryRequest'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse1.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse1 = new MockHttpCalloutResponseGenerator(null, OILTestResponse1);
       Test.setMock(HttpCalloutMock.class, MockHttpResponse1);
        ACETLGT_ClaimDetailHistoryController.getInstClaimDetail('','','');
        ACETLGT_ClaimDetailHistoryController.getStdErrMsg('',400);
             
        }
        
    @isTest
    static void errorhandleTest()
    {  
        
       ACETErrorHandler.createAppErrorLog('', '','','','' );       
       ACETErrorHandler test = new ACETErrorHandler();
     
       test.setErrorMsgInDataTable('',null); 
       test.setErrorMsg('',null);
       
        test.setErrorMsg('GN404',null);
       test.setErrorMsgInDataTable('GN404',null);    
       
       
       test.setErrorMsg('GN200',null);
       test.setErrorMsgInDataTable('GN200',null);
       
       test.setErrorMsg('GN400',null);
       test.setErrorMsgInDataTable('GN400',null);
      
       test.setErrorMsg('GN999',null);
       test.setErrorMsgInDataTable('GN999',null);
       
       test.setErrorMsg('GN500',null);
       test.setErrorMsgInDataTable('GN500',null);

    }
        
        static testMethod void lightningInstClmHistTest(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"InstitutionalClaimHistoryResponse":{"InstitutionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","otherPayer":[{"otherInsuranceSubscriberID":{"id":"6482910","type":"id"},"otherInsuranceSubscriberName":{"firstName":"John","middleName":"M","lastName":"Gartner","suffix":"M"},"payerResponsibilitySequenceCode":{"code":"H636","description":"payerResponsibilitySequenceCodeDescription 128"},"otherInsurancePayerID":"A12","otherInsurancePayerName":"Medico Plus","insuranceTypeCode":{"code":"S232","description":"otherInsuranceTypeCodeDescription 126"},"claimTotalOtherPayerPaidAmount":"122.23","claimTotalOtherPayerPatientResponsibilityAmount":"187.23","claimTotalOtherPayerNotCoveredAmount":"268.23"}],"claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1); 
        ACETLGT_InstiClmHistoryWebservice ICHWS = new ACETLGT_InstiClmHistoryWebservice();
		ICHWS.InstitutionalClaimHistoryWS('02','123456','123456789');         
    }
    
    static testMethod void lightningProfClmHistTest(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"professionalClaimHistoryResponse":{"professionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","otherPayer":[{"otherInsuranceSubscriberID":{"id":"6482910","type":"id"},"otherInsuranceSubscriberName":{"firstName":"John","middleName":"M","lastName":"Gartner","suffix":"M"},"payerResponsibilitySequenceCode":{"code":"H636","description":"payerResponsibilitySequenceCodeDescription 128"},"otherInsurancePayerID":"A12","otherInsurancePayerName":"Medico Plus","insuranceTypeCode":{"code":"S232","description":"otherInsuranceTypeCodeDescription 126"},"claimTotalOtherPayerPaidAmount":"122.23","claimTotalOtherPayerPatientResponsibilityAmount":"187.23","claimTotalOtherPayerNotCoveredAmount":"268.23"}],"claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);  
        ACETLGT_ProfessionalClmHistoryWebservice PCHWS = new ACETLGT_ProfessionalClmHistoryWebservice();
		PCHWS.ProfessionalClaimHistoryWS('02','123456','123456789');   
         string data = '{"claimItem":["E04.1","R31.9","R31.9","E04.1","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","R35.0","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","M23.304","R35.0","R31.9","M23.304","M23.304","E04.1","E04.1","D18.01","E04.1","L02.32","D18.01","E04.1","D18.01","E04.1","E04.1","N94.89","E04.1","E04.1","S00.93XA","Z74.3","R55","E04.1"]}';
        ACETLGT_ClaimDetailHistoryController.getEncoderProDescription(data);
    }
 }