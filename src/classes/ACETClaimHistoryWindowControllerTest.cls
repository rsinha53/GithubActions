@isTest
public class ACETClaimHistoryWindowControllerTest {
    
    Static testmethod void testWindowController()
    {
        /*Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        insert cont;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Member';        
        insert interaction;
        
        
        PageReference pageRef = Page.ACETClaimHistoryWindow;
        Test.setCurrentPage(pageRef);
        
        System.currentPageReference().getParameters().put('SRK', 'SRK_Key');
        System.currentPageReference().getParameters().put('contactId', cont.Id);
        System.currentPageReference().getParameters().put('id', cont.Id);
        System.currentPageReference().getParameters().put('interactionId', interaction.Id);
        System.currentPageReference().getParameters().put('additionalInfo', '{"SitusState":"IA","Relationship":"Subscriber/Recipient","ProductType":"HMO","Product":"HMO","PolicyNumber":"0909003","OriginatorRelationship":"Subscriber/Recipient","Network":"788909","GroupName":null,"EndDate":"1/1/8888","EffectiveDate":"8/8/2012","DOB":"2/1/1963","ConsumerAccountIndicator":null}');
        
        ACETClaimHistoryWindowController Controller  = new ACETClaimHistoryWindowController();
        //Controller.noresult=True;
        //Controller.Subject = cont;
        //Controller.IsProviderFlow=True;
        //Controller.isCancelCaseCreation=True;
        //Controller.renderCancelCaseSection();
        //Controller.init();
        //Controller.wrapper=null;
        //Controller.MemberDetail=null;  
        //Controller.initInteractionAndSubject();     
        //Controller.createInteraction();
        
        
    }
    
    Static testmethod void testInstitutionalClaimHistory2()
    {
//        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"InstitutionalClaimHistoryResponse":{"InstitutionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"encounterIndicator":"N","timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
//        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"InstitutionalClaimHistoryResponse":{"InstitutionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"encounterIndicator":"N","surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
//        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"InstitutionalClaimHistoryResponse":{"InstitutionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"InstitutionalClaimHistoryResponse":{"InstitutionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","otherPayer":[{"otherInsuranceSubscriberID":{"id":"6482910","type":"id"},"otherInsuranceSubscriberName":{"firstName":"John","middleName":"M","lastName":"Gartner","suffix":"M"},"payerResponsibilitySequenceCode":{"code":"H636","description":"payerResponsibilitySequenceCodeDescription 128"},"otherInsurancePayerID":"A12","otherInsurancePayerName":"Medico Plus","insuranceTypeCode":{"code":"S232","description":"otherInsuranceTypeCodeDescription 126"},"claimTotalOtherPayerPaidAmount":"122.23","claimTotalOtherPayerPatientResponsibilityAmount":"187.23","claimTotalOtherPayerNotCoveredAmount":"268.23"}],"claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        
        
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);      
        ACETClaimHistoryWindowController.queryGetInstitutionalClaimHistory('03','UH90761111', '');
        
        ACETInstitutionalClaimHistoryJson2Apex j2a = new ACETInstitutionalClaimHistoryJson2Apex();
        ACETInstitutionalClaimHistoryJson2Apex.ServiceLineUHCAmounts_Z serviceLineZ = new ACETInstitutionalClaimHistoryJson2Apex.ServiceLineUHCAmounts_Z();
        serviceLineZ.serviceBilledChargeAmount = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Address add = new ACETInstitutionalClaimHistoryJson2Apex.Address();
        add.addressline1 = 'test';
        add.addressLine2 = 'test';
        add.city = 'test';
        add.state = 'test';
        add.postalCode = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ClaimAccumulator claimAccum = new ACETInstitutionalClaimHistoryJson2Apex.ClaimAccumulator();
        claimAccum.tierTypeCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        claimAccum.tierTypeCode.code = 'test';
        claimAccum.tierTypeCode.description = 'test';
        claimAccum.costShareType = 'test';
        claimAccum.claimAccumAppliedAmount = 'test';
        claimAccum.accumSnapShotAppliedAmount = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ClaimSubmissionType cst = new ACETInstitutionalClaimHistoryJson2Apex.ClaimSubmissionType();
        cst.code = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ClaimDocument cd = new ACETInstitutionalClaimHistoryJson2Apex.ClaimDocument();
        cd.documentId = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Adjustments adjusts = new ACETInstitutionalClaimHistoryJson2Apex.Adjustments();
        adjusts.code = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        adjusts.remarkGroupCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        adjusts.amount = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ClaimNotes cn = new ACETInstitutionalClaimHistoryJson2Apex.ClaimNotes();
        cn.noteTypeCode = 'test';
        cn.noteTypeText = 'test';
        cn.notesCreatedBy = 'test';
        cn.notesCreatedDate = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.CesMnemonic cm = new ACETInstitutionalClaimHistoryJson2Apex.CesMnemonic();
        cm.cesMnemonicCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        cm.cesRemarkText = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Subscriber sub = new ACETInstitutionalClaimHistoryJson2Apex.Subscriber();
        sub.memberGroupName = 'test';
        sub.identifiers = new list<ACETInstitutionalClaimHistoryJson2Apex.Identifiers>();
        sub.name = new ACETInstitutionalClaimHistoryJson2Apex.Name();
        sub.birthDate = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.OtherPayer op = new ACETInstitutionalClaimHistoryJson2Apex.OtherPayer();
        op.otherInsuranceSubscriberID = new ACETInstitutionalClaimHistoryJson2Apex.OtherInsuranceSubscriberID();
        op.otherInsuranceSubscriberName = new ACETInstitutionalClaimHistoryJson2Apex.OtherInsuranceSubscriberName();
        op.otherInsurancePayerID = 'test';
        op.otherInsurancePayerName = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ServiceLine sl = new ACETInstitutionalClaimHistoryJson2Apex.ServiceLine();
        sl.healthCoverageType = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        sl.unitOfMeasure = 'test';
        sl.ambulatoryPaymentClassificationCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        sl.ambulatoryPaymentStatusCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        sl.overrideIndicator = 'test';
        sl.semiPrivateRoomRate = 'test';
        sl.provider = new list<ACETInstitutionalClaimHistoryJson2Apex.Provider_Z>();
        sl.claimLineAdjudicationDate = 'test';
        sl.serviceNotes = new list<ACETInstitutionalClaimHistoryJson2Apex.ClaimNotes>();
        ACETInstitutionalClaimHistoryJson2Apex.BenefitClaimAccumulator bca = new ACETInstitutionalClaimHistoryJson2Apex.BenefitClaimAccumulator();
        bca.benefitBundleOptionId = 'test';
        bca.claimAccumulator = new ACETInstitutionalClaimHistoryJson2Apex.ClaimAccumulator();
        ACETInstitutionalClaimHistoryJson2Apex.BenefitPlan bp = new ACETInstitutionalClaimHistoryJson2Apex.BenefitPlan();
        bp.benefitBundleOptionID = 'test';
        bp.planCoinsurancePercent = 'test';
        bp.memberCoinsurancePercent = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Provider_Z pz = new ACETInstitutionalClaimHistoryJson2Apex.Provider_Z();
        pz.providerType = 'test';
        pz.name = new ACETInstitutionalClaimHistoryJson2Apex.Name_Y();
        pz.organizationName = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Y bcay = new ACETInstitutionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Y();
        bcay.benefitBundleOptionId = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Name_Z nz = new ACETInstitutionalClaimHistoryJson2Apex.Name_Z();
        nz.firstName = 'test';
        nz.middleName = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Z bcaz = new ACETInstitutionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Z();
        bcaz.benefitPlanId = 'test';
        bcaz.benefitBundleOptionId = 'test';
        bcaz.benefitCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        bcaz.claimAccumulator = new ACETInstitutionalClaimHistoryJson2Apex.ClaimAccumulator_Z();
        ACETInstitutionalClaimHistoryJson2Apex.CarcAdjustments ca = new ACETInstitutionalClaimHistoryJson2Apex.CarcAdjustments();
        ca.adjustments = new list<ACETInstitutionalClaimHistoryJson2Apex.Adjustments>();
        ACETInstitutionalClaimHistoryJson2Apex.Name_Y ny = new ACETInstitutionalClaimHistoryJson2Apex.Name_Y();
        ny.firstName = 'test';
        ny.middleName = 'test';
        ny.lastName = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ServiceLineUHCAmounts sla = new ACETInstitutionalClaimHistoryJson2Apex.ServiceLineUHCAmounts();
        sla.servicePatientResponsibilityAmount = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.BenefitPlan_Y bpy = new ACETInstitutionalClaimHistoryJson2Apex.BenefitPlan_Y();
        bpy.benefitBundleOptionID = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.DiagnosisCode dc = new ACETInstitutionalClaimHistoryJson2Apex.DiagnosisCode();
        dc.levelType = 'test';
        dc.admittingDiagnosisIndicator = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Patient pat = new ACETInstitutionalClaimHistoryJson2Apex.Patient();
        pat.identifiers = new list<ACETInstitutionalClaimHistoryJson2Apex.Identifiers>();
        ACETInstitutionalClaimHistoryJson2Apex.BenefitPlan_Z bpz = new ACETInstitutionalClaimHistoryJson2Apex.BenefitPlan_Z();
        bpz.benefitPlanID = 'test';
        bpz.benefitBundleOptionID = 'test';
        bpz.memberCoinsurancePercent = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.OtherInsuranceSubscriberName oisn = new ACETInstitutionalClaimHistoryJson2Apex.OtherInsuranceSubscriberName();
        oisn.firstName = 'test';
        oisn.middleName = 'test';
        oisn.lastName = 'test';
        oisn.suffix = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ClaimAccumulator_Z caz = new ACETInstitutionalClaimHistoryJson2Apex.ClaimAccumulator_Z();
        caz.tierTypeCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        caz.coverageLevel = 'test';
        caz.costShareType = 'test';
        caz.claimAccumAppliedAmount = 'test';
        caz.accumSnapShotAppliedAmount = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Provider pro = new ACETInstitutionalClaimHistoryJson2Apex.Provider();
        pro.providerType = 'test';
        pro.providerID = 'test';
        pro.providerTIN = 'test';
        pro.providerTINTypeCode = 'test';
        pro.providerNPI = 'test';
        pro.organizationName = 'test';
        pro.address = new ACETInstitutionalClaimHistoryJson2Apex.Address();
        pro.name = new ACETInstitutionalClaimHistoryJson2Apex.Name();
        ACETInstitutionalClaimHistoryJson2Apex.Identifiers_Z iz = new ACETInstitutionalClaimHistoryJson2Apex.Identifiers_Z();
        iz.type_Z = 'test';
        iz.id = 'test';
        iz.sourceSystemCode = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.ClaimRemarks cr = new ACETInstitutionalClaimHistoryJson2Apex.ClaimRemarks();
        cr.remarkCode = new ACETInstitutionalClaimHistoryJson2Apex.SurgicalProcedure();
        cr.rarcCode = new ACETInstitutionalClaimHistoryJson2Apex.ClaimType();
        ACETInstitutionalClaimHistoryJson2Apex.Adjustments_Z az = new ACETInstitutionalClaimHistoryJson2Apex.Adjustments_Z();
        az.amount = 'test';
        az.quantity = 'test';
        ACETInstitutionalClaimHistoryJson2Apex.Identifiers ide = new ACETInstitutionalClaimHistoryJson2Apex.Identifiers();
        ide.type = 'test';
        ide.id = 'test';
        ide.sourceSystemCode = 'test';
        
        
    }
    
    Static testmethod void testProfessionalClaimHistory()
    {
//        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"professionalClaimHistoryResponse":{"professionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"encounterIndicator":"N","timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
//        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"professionalClaimHistoryResponse":{"professionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"encounterIndicator":"N","surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
//        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"professionalClaimHistoryResponse":{"professionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"professionalClaimHistoryResponse":{"professionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","otherPayer":[{"otherInsuranceSubscriberID":{"id":"6482910","type":"id"},"otherInsuranceSubscriberName":{"firstName":"John","middleName":"M","lastName":"Gartner","suffix":"M"},"payerResponsibilitySequenceCode":{"code":"H636","description":"payerResponsibilitySequenceCodeDescription 128"},"otherInsurancePayerID":"A12","otherInsurancePayerName":"Medico Plus","insuranceTypeCode":{"code":"S232","description":"otherInsuranceTypeCodeDescription 126"},"claimTotalOtherPayerPaidAmount":"122.23","claimTotalOtherPayerPatientResponsibilityAmount":"187.23","claimTotalOtherPayerNotCoveredAmount":"268.23"}],"claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        
        
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);      
        ACETClaimHistoryWindowController.queryGetProfessionalClaimHistory('03','UH90761111', '');
        
        ACETProfessionalClaimHistoryJson2Apex j2a = new ACETProfessionalClaimHistoryJson2Apex();
        ACETProfessionalClaimHistoryJson2Apex.ServiceLineUHCAmounts_Z serviceLineZ = new ACETProfessionalClaimHistoryJson2Apex.ServiceLineUHCAmounts_Z();
        serviceLineZ.serviceBilledChargeAmount = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Address add = new ACETProfessionalClaimHistoryJson2Apex.Address();
        add.addressline1 = 'test';
        add.addressLine2 = 'test';
        add.city = 'test';
        add.state = 'test';
        add.postalCode = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ClaimAccumulator claimAccum = new ACETProfessionalClaimHistoryJson2Apex.ClaimAccumulator();
        claimAccum.tierTypeCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        claimAccum.tierTypeCode.code = 'test';
        claimAccum.tierTypeCode.description = 'test';
        claimAccum.costShareType = 'test';
        claimAccum.claimAccumAppliedAmount = 'test';
        claimAccum.accumSnapShotAppliedAmount = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ClaimSubmissionType cst = new ACETProfessionalClaimHistoryJson2Apex.ClaimSubmissionType();
        cst.code = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ClaimDocument cd = new ACETProfessionalClaimHistoryJson2Apex.ClaimDocument();
        cd.documentId = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Adjustments adjusts = new ACETProfessionalClaimHistoryJson2Apex.Adjustments();
        adjusts.code = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        adjusts.remarkGroupCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        adjusts.amount = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ClaimNotes cn = new ACETProfessionalClaimHistoryJson2Apex.ClaimNotes();
        cn.noteTypeCode = 'test';
        cn.noteTypeText = 'test';
        cn.notesCreatedBy = 'test';
        cn.notesCreatedDate = 'test';
        ACETProfessionalClaimHistoryJson2Apex.CesMnemonic cm = new ACETProfessionalClaimHistoryJson2Apex.CesMnemonic();
        cm.cesMnemonicCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        cm.cesRemarkText = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Subscriber sub = new ACETProfessionalClaimHistoryJson2Apex.Subscriber();
        sub.memberGroupName = 'test';
        sub.identifiers = new list<ACETProfessionalClaimHistoryJson2Apex.Identifiers>();
        sub.name = new ACETProfessionalClaimHistoryJson2Apex.Name();
        sub.birthDate = 'test';
        ACETProfessionalClaimHistoryJson2Apex.OtherPayer op = new ACETProfessionalClaimHistoryJson2Apex.OtherPayer();
        op.otherInsuranceSubscriberID = new ACETProfessionalClaimHistoryJson2Apex.OtherInsuranceSubscriberID();
        op.otherInsuranceSubscriberName = new ACETProfessionalClaimHistoryJson2Apex.OtherInsuranceSubscriberName();
        op.otherInsurancePayerID = 'test';
        op.otherInsurancePayerName = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ServiceLine sl = new ACETProfessionalClaimHistoryJson2Apex.ServiceLine();
        sl.healthCoverageType = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        sl.unitOfMeasure = 'test';
        sl.ambulatoryPaymentClassificationCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        sl.ambulatoryPaymentStatusCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        sl.overrideIndicator = 'test';
        sl.semiPrivateRoomRate = 'test';
        sl.provider = new list<ACETProfessionalClaimHistoryJson2Apex.Provider_Z>();
        sl.claimLineAdjudicationDate = 'test';
        sl.serviceNotes = new list<ACETProfessionalClaimHistoryJson2Apex.ClaimNotes>();
        ACETProfessionalClaimHistoryJson2Apex.BenefitClaimAccumulator bca = new ACETProfessionalClaimHistoryJson2Apex.BenefitClaimAccumulator();
        bca.benefitBundleOptionId = 'test';
        bca.claimAccumulator = new ACETProfessionalClaimHistoryJson2Apex.ClaimAccumulator();
        ACETProfessionalClaimHistoryJson2Apex.BenefitPlan bp = new ACETProfessionalClaimHistoryJson2Apex.BenefitPlan();
        bp.benefitBundleOptionID = 'test';
        bp.planCoinsurancePercent = 'test';
        bp.memberCoinsurancePercent = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Provider_Z pz = new ACETProfessionalClaimHistoryJson2Apex.Provider_Z();
        pz.providerType = 'test';
        pz.name = new ACETProfessionalClaimHistoryJson2Apex.Name_Y();
        pz.organizationName = 'test';
        ACETProfessionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Y bcay = new ACETProfessionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Y();
        bcay.benefitBundleOptionId = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Name_Z nz = new ACETProfessionalClaimHistoryJson2Apex.Name_Z();
        nz.firstName = 'test';
        nz.middleName = 'test';
        ACETProfessionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Z bcaz = new ACETProfessionalClaimHistoryJson2Apex.BenefitClaimAccumulator_Z();
        bcaz.benefitPlanId = 'test';
        bcaz.benefitBundleOptionId = 'test';
        bcaz.benefitCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        bcaz.claimAccumulator = new ACETProfessionalClaimHistoryJson2Apex.ClaimAccumulator_Z();
        ACETProfessionalClaimHistoryJson2Apex.CarcAdjustments ca = new ACETProfessionalClaimHistoryJson2Apex.CarcAdjustments();
        ca.adjustments = new list<ACETProfessionalClaimHistoryJson2Apex.Adjustments>();
        ACETProfessionalClaimHistoryJson2Apex.Name_Y ny = new ACETProfessionalClaimHistoryJson2Apex.Name_Y();
        ny.firstName = 'test';
        ny.middleName = 'test';
        ny.lastName = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ServiceLineUHCAmounts sla = new ACETProfessionalClaimHistoryJson2Apex.ServiceLineUHCAmounts();
        sla.servicePatientResponsibilityAmount = 'test';
        ACETProfessionalClaimHistoryJson2Apex.BenefitPlan_Y bpy = new ACETProfessionalClaimHistoryJson2Apex.BenefitPlan_Y();
        bpy.benefitBundleOptionID = 'test';
        ACETProfessionalClaimHistoryJson2Apex.DiagnosisCode dc = new ACETProfessionalClaimHistoryJson2Apex.DiagnosisCode();
        dc.levelType = 'test';
        dc.admittingDiagnosisIndicator = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Patient pat = new ACETProfessionalClaimHistoryJson2Apex.Patient();
        pat.identifiers = new list<ACETProfessionalClaimHistoryJson2Apex.Identifiers>();
        ACETProfessionalClaimHistoryJson2Apex.BenefitPlan_Z bpz = new ACETProfessionalClaimHistoryJson2Apex.BenefitPlan_Z();
        bpz.benefitPlanID = 'test';
        bpz.benefitBundleOptionID = 'test';
        bpz.memberCoinsurancePercent = 'test';
        ACETProfessionalClaimHistoryJson2Apex.OtherInsuranceSubscriberName oisn = new ACETProfessionalClaimHistoryJson2Apex.OtherInsuranceSubscriberName();
        oisn.firstName = 'test';
        oisn.middleName = 'test';
        oisn.lastName = 'test';
        oisn.suffix = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ClaimAccumulator_Z caz = new ACETProfessionalClaimHistoryJson2Apex.ClaimAccumulator_Z();
        caz.tierTypeCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        caz.coverageLevel = 'test';
        caz.costShareType = 'test';
        caz.claimAccumAppliedAmount = 'test';
        caz.accumSnapShotAppliedAmount = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Provider pro = new ACETProfessionalClaimHistoryJson2Apex.Provider();
        pro.providerType = 'test';
        pro.providerID = 'test';
        pro.providerTIN = 'test';
        pro.providerTINTypeCode = 'test';
        pro.providerNPI = 'test';
        pro.organizationName = 'test';
        pro.address = new ACETProfessionalClaimHistoryJson2Apex.Address();
        pro.name = new ACETProfessionalClaimHistoryJson2Apex.Name();
        ACETProfessionalClaimHistoryJson2Apex.Identifiers_Z iz = new ACETProfessionalClaimHistoryJson2Apex.Identifiers_Z();
        iz.type_Z = 'test';
        iz.id = 'test';
        iz.sourceSystemCode = 'test';
        ACETProfessionalClaimHistoryJson2Apex.ClaimRemarks cr = new ACETProfessionalClaimHistoryJson2Apex.ClaimRemarks();
        cr.remarkCode = new ACETProfessionalClaimHistoryJson2Apex.SurgicalProcedure();
        cr.rarcCode = new ACETProfessionalClaimHistoryJson2Apex.ClaimType();
        ACETProfessionalClaimHistoryJson2Apex.Adjustments_Z az = new ACETProfessionalClaimHistoryJson2Apex.Adjustments_Z();
        az.amount = 'test';
        az.quantity = 'test';
        ACETProfessionalClaimHistoryJson2Apex.Identifiers ide = new ACETProfessionalClaimHistoryJson2Apex.Identifiers();
        ide.type = 'test';
        ide.id = 'test';
        ide.sourceSystemCode = 'test';
        
        
    }
    
    Static testmethod void testInstitutionalClaimHistory()
    {
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"institutionalClaimHistoryResponse":{"institutionalClaim":[{"claimType":{"code":"02"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-04-19","claimLastDateofService":"2018-04-19","sourceClaimId":"4558483","claimId":"2244184128","claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"05","description":"In Process"},"pendReasonCode":[{}],"encounterIndicator":"N","surgeryDate":"2018-04-19","dischargeDate":"2018-04-19","dischargeTimeHour":"1600","admitDate":"2018-04-19T08:00:00Z","admitTimeHour":"0800","claimReceiptDate":"2018-06-22","claimEvent":{"claimEventAdjudicationDateTime":"2018-06-22T18:22:20Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4588487","claimEventStatus":"05","claimEventStatusDescription":"In Process","claimEventStatusDate":"2018-06-22T18:22:20Z"},"diagnosisCode":[{"code":{"code":"Z000"},"levelType":"100","sequenceNumber":"100","admittingDiagnosisIndicator":"Y"}],"drgNumber":{},"patient":{"name":{"firstName":"Subscriber","lastName":"AABASE_MNS5"},"birthDate":"1965-03-03"},"patientAccountNumber":"T4072","provider":[{"providerType":"Billing","providerID":"299046689482247876","providerTIN":"066068853","providerTINTypeCode":"EI","providerNPI":"1427041581","name":{},"organizationName":"NORWALK HOSPITAL","address":{"addressLine1":"24 STEVENS ST","city":"NORWALK","state":"CT","postalCode":"068503852"}},{"providerType":"Rendering","providerNPI":"1427041581","name":{"lastName":"NORWALK HOSPITAL"},"address":{}}],"subscriber":{"name":{"firstName":"Subscriber","lastName":"AABASE_MNS5"},"birthDate":"1965-03-03"},"claimUHCTotals":{"claimTotalBilledChargeAmount":"100.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-04-19","serviceLastDateofService":"2018-04-19","serviceUnitCount":"1","unitOfMeasure":"DA","revenueCode":{"code":"0918","description":"Behavioral Health Treatments/Services-Extension of 090X-Testing"},"ambulatoryPaymentClassificationCode":{},"ambulatoryPaymentStatusCode":{},"benefitClaimAccumulator":[{"claimAccumulator":{}}],"benefitPlan":{"benefitCode":{}},"cobMethod":{},"procedureCode":{"code":{"code":"96372"},"type":{"code":"4","description":"HCPCS"}},"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"100"},"serviceNotes":[{}],"cancelReason":{}}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"institutionalClaimHistoryResponse":{"institutionalClaim":[{"claimType":{"code":"03"},"claimSubmissionType":{"code":"02","description":"Electronic"},"claimFirstDateofService":"2018-07-09","claimLastDateofService":"2018-07-09","sourceClaimId":"4898480","claimId":"UH90761111","adjudicatedCOBLevel":{"code":"1","description":"Primary"},"claimSourceSystemCode":"CR","claimSplitIndicator":"N","claimStatusCode":{"code":"01","description":"Claim Finalized - Paid or Denied"},"claimCauseCode":{"code":"K91.840","description":"K91.840 benefitLevelCauseDescription"},"encounterIndicator":"N","occurrenceCode":[{"code":{"code":"46730","description":"text58 occurrenceCodeDescription"},"fromDate":"2016-06-10"}],"occurenceSpanCode":[{"code":{"code":"46729","description":"text58 occurrencespanCodeDescription"},"fromDate":"2016-06-08","throughDate":"2016-06-09"}],"surgicalProcedure":[{"code":"G00-G99","description":"Episodic and paroxysmal disorders"},{"code":"A00-B99","description":"Intestinal infectious diseases"}],"timelyFilingLimitDays":"90","claimReceiptDate":"2018-07-16","claimEvent":{"claimEventAdjudicationDateTime":"2018-07-16T20:55:01Z","claimEventType":{"code":"01","description":"Original"},"claimEventSeqNum":"1","claimEventId":"4928480","claimEventStatus":"01","claimEventStatusDescription":"Claim Finalized - Paid or Denied","claimEventStatusDate":"2018-07-16","adjudicatedClaimPaymentRequest":[{}]},"cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"diagnosisCode":[{"sequenceNumber":"1","code":{"code":"F0150"},"levelType":"1"}],"patient":{"name":{"firstName":"Alphonse","lastName":"Hull"},"identifiers":[{"type":"MCH","id":"35824330500"},{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"birthDate":"1965-01-01"},"patientAccountNumber":"001-SUSSEW0000","provider":[{"providerType":"Billing","providerID":"979246196218143332","providerTIN":"061321508","providerTINTypeCode":"EI","providerNPI":"1134105414","name":{"firstName":"BURTON","lastName":"RUBIN"},"address":{"addressLine1":"8 W END AVE","city":"OLD GREENWICH","state":"CT","postalCode":"068701642"}}],"subscriber":{"identifiers":[{"type":"EID","id":"468604207"},{"type":"SRK","id":"632138944"},{"sourceSystemCode":"CR"}],"name":{"firstName":"Alphonse","lastName":"Hull"},"birthDate":"1965-01-01"},"payerType":"","otherPayer":[{"otherInsuranceSubscriberID":{"id":"6482910","type":"id"},"otherInsuranceSubscriberName":{"firstName":"John","middleName":"M","lastName":"Gartner","suffix":"M"},"payerResponsibilitySequenceCode":{"code":"H636","description":"payerResponsibilitySequenceCodeDescription 128"},"otherInsurancePayerID":"A12","otherInsurancePayerName":"Medico Plus","insuranceTypeCode":{"code":"S232","description":"otherInsuranceTypeCodeDescription 126"},"claimTotalOtherPayerPaidAmount":"122.23","claimTotalOtherPayerPatientResponsibilityAmount":"187.23","claimTotalOtherPayerNotCoveredAmount":"268.23"}],"claimUHCTotals":{"claimTotalBilledChargeAmount":"500.00","claimTotalDeductibleAmount":"0.00","claimTotalInterestAmount":"0.00","claimTotalPaidAmount":"0.00","totalCopayAmount":"0.00","totalNotCoveredAmount":"0.00","totalPatientResponsibilityAmount":"500.00","claimTotalUHCProvWriteOffAmount":"0.00","claimTotalReimbursementReductionAmount":"500.00","claimTotalPenaltyAmount":"0.00","claimTotalAllowedAmount":"0.00","claimTotalCoinsuranceAmount":"0.00"},"serviceLine":[{"claimServiceLineID":"1","serviceFirstDateofService":"2018-07-09","serviceLastDateofService":"2018-07-09","serviceLineStatusCode":{"code":"D","description":"Denied"},"unitOfMeasure":"UN","serviceUnitCount":"1.000","placeofServiceCode":"11","claimLineAdjudicationDate":"2018-07-16T20:54:59Z","cesMnemonic":[{"cesMnemonicCode":{"code":"A548","description":"A548 cesMnemonicCodeDescription"},"cesRemarkCode":"10378","cesRemarkText":"Active"}],"carcAdjustments":{"adjustments":[{"carcCode":{"code":"27","description":"Expenses incurred af"},"remarkGroupCode":{"code":"PR","description":"Patient Responsibility"},"amount":"500.00","quantity":"1.000"}],"adjustmentTotal":"500.00"},"benefitClaimAccumulator":[{"benefitBundleOptionId":"1038484"}],"benefitPlan":{"benefitPlanID":"M000000081","benefitBundleOptionID":"1038484"},"procedureCode":{"code":{"code":"99214","description":"OFFICE/OUTPATIENT VISIT EST"},"type":{"code":"4","description":"HCPCS"}},"diagnosisCodePointer":["1","0","0","0"],"serviceLineUHCAmounts":{"serviceBilledChargeAmount":"500.00","serviceDeductibleAmount":"0.00","servicePaidAmount":"0.00","serviceCopayAmount":"0.00","serviceNotCoveredAmount":"0.00","servicePatientResponsibilityAmount":"500.00","serviceReimbursementReductionAmount":"500.00","serviceAllowedAmount":"0.00","serviceCoinsuranceAmount":"0.00","serviceUHCProvWriteOffAmount":"0.00","servicePenaltyAmount":"0.00"},"serviceRemarks":[{"remarkCode":{"code":"CAD150"},"remarkCodeRecipientType":"3","remarkCodeMemberProviderDesc":"These charges are for services provided after this patient coverage was canceled, therefore, they are not covered."}]}]}],"pagination":{"pageNumber":"1","pageSize":"5","totalCount":"1","totalPages":"1","recordCount":"1"}}}');
        
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);      
        ACETClaimHistoryWindowController.queryGetInstitutionalClaimHistory('02','2244184128', '');
    }
    
    static testMethod void getEncoderProDescriptionSuccessTest(){
    
            setUpEncoderProData();
            ACETClaimDetailController Controller  = new ACETClaimDetailController();
            
            
            Map<String,List<String>> codesMap = new Map<String,List<String>>();
            codesMap.put('testsection',new List<String>());
            codesMap.get('testsection').add('testcode');
            
            String data = JSON.serialize(codesMap);
            
         
            MockHttpCalloutResponseGenerator.MockHttpResponse epResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"batch-responses": {"response": [{"#text": "{\"desc-full\":"Office or other outpatient visit for the evaluation and management of an established patient, which requires at least 2 of these 3 key components: An expanded problem focused history; An expanded problem focused examination; Medical decision making of low complexity. Counseling and coordination of care with other physicians, other qualified health care professionals, or agencies are provided consistent with the nature of the problem(s) and the patient and/or family needs. Usually, the presenting problem(s) are of low to moderate severity. Typically, 15 minutes are spent face-to-face with the patient and/or family."}","status-code": 200,"request-id": "cpt_99213"}]}}');
            epResponse.tokenexpired = false;
            MockHttpCalloutResponseGenerator epr = new MockHttpCalloutResponseGenerator(null, epResponse);            

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, epr);
            
             ACETClaimHistoryWindowController.getEncoderProDescription(data);
            Test.stopTest();
    
    }
    static testMethod void getEncoderProDescriptionFailure500Test(){
    
            setUpEncoderProData();
            ACETClaimDetailController Controller  = new ACETClaimDetailController();
            
            
            Map<String,List<String>> codesMap = new Map<String,List<String>>();
            codesMap.put('testsection',new List<String>());
            codesMap.get('testsection').add('testcode');
            
            String data = JSON.serialize(codesMap);
            
         
            MockHttpCalloutResponseGenerator.MockHttpResponse epResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', '{"batch-responses": {"response": [{"#text": "{\"desc-full\":"Office or other outpatient visit for the evaluation and management of an established patient, which requires at least 2 of these 3 key components: An expanded problem focused history; An expanded problem focused examination; Medical decision making of low complexity. Counseling and coordination of care with other physicians, other qualified health care professionals, or agencies are provided consistent with the nature of the problem(s) and the patient and/or family needs. Usually, the presenting problem(s) are of low to moderate severity. Typically, 15 minutes are spent face-to-face with the patient and/or family."}","status-code": 200,"request-id": "cpt_99213"}]}}');
            epResponse.tokenexpired = false;
            MockHttpCalloutResponseGenerator epr = new MockHttpCalloutResponseGenerator(null, epResponse);            

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, epr);
            
             ACETClaimHistoryWindowController.getEncoderProDescription(data);
            Test.stopTest();
    
    }
    static testMethod void getEncoderProDescriptionFailureExceptionTest(){
    
            setUpEncoderProData();
            ACETClaimDetailController Controller  = new ACETClaimDetailController();
            
            
            Map<String,List<String>> codesMap = new Map<String,List<String>>();
            codesMap.put('testsection',new List<String>());
            codesMap.get('testsection').add('testcode');
            
            String data = JSON.serialize(codesMap);
            
         
            MockHttpCalloutResponseGenerator.MockHttpResponse epResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '"batch-responses": {"response": [{"#text": "{\"desc-full\":"Office or other outpatient visit for the evaluation and management of an established patient, which requires at least 2 of these 3 key components: An expanded problem focused history; An expanded problem focused examination; Medical decision making of low complexity. Counseling and coordination of care with other physicians, other qualified health care professionals, or agencies are provided consistent with the nature of the problem(s) and the patient and/or family needs. Usually, the presenting problem(s) are of low to moderate severity. Typically, 15 minutes are spent face-to-face with the patient and/or family."}","status-code": 200,"request-id": "cpt_99213"}]}}');
            epResponse.tokenexpired = false;
            MockHttpCalloutResponseGenerator epr = new MockHttpCalloutResponseGenerator(null, epResponse);            

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, epr);
            
             ACETClaimHistoryWindowController.getEncoderProDescription(data);
            Test.stopTest();
    
    }       
    static void setUpEncoderProData(){
        List<ACETEncoderProConfig__c> configs = new List<ACETEncoderProConfig__c>();
         ACETEncoderProConfig__c config;
         config = new ACETEncoderProConfig__c();
         config.name = 'CPT_REGEX';
         config.type__c = 'CODETYPE';
         config.value__c = '\\b\\d\\d\\d\\d[0-9TtFfMm]\\b';
        configs.add(config);
        
        config = new ACETEncoderProConfig__c();
        config.name = 'DESCTYPE';
        config.type__c = 'DESCTYPE';
        config.value__c = 'desc-full';
        configs.add(config);
        
        config = new ACETEncoderProConfig__c();
        config.name = 'PASSWORD';
        config.type__c = 'PASSWORD';
        config.value__c = 'pwd';
        configs.add(config);
        
        config = new ACETEncoderProConfig__c();
        config.name = 'USERNAME';
        config.type__c = 'USERNAME';
        config.value__c = 'test';
        configs.add(config);    
            insert configs;     
    }
}