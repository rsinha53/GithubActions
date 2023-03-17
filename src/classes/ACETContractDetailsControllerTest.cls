@isTest
public class ACETContractDetailsControllerTest {

    static testMethod void  ACETContractDetailsControllerTest1() {
        
        Account accountRec = ACETTestDataUtility.createAccount('test Account');
        insert accountRec;
        
        Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id, 'Test', 'Contact');
        insert contactRec;
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = contactRec.Id;
        insert interaction;
        
        Test.startTest();
        
        PageReference ContractDetailPage = Page.ACETContractDetails;
        ContractDetailPage.getParameters().put('interactionId', interaction.id);
        ContractDetailPage.getParameters().put('contactId', contactRec.id);
        ContractDetailPage.getParameters().put('sourceOriginator', 'Phone Call');
        ContractDetailPage.getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":null,"Relationship":null,"RatingMethod":null,"providerType":null,"ProductType":"","Product":"Gated INN only","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"Network":null,"MemberId":"36781823800","LastName":"Baker","isMember":" true","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1118476","GroupName":null,"GroupN":null,"Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2015","DOB":"11/7/1966","ConsumerAccountIndicator":null,"BenefitPlanId":null}');
        ContractDetailPage.getParameters().put('PID', '772445246508702091');
        ContractDetailPage.getParameters().put('TID', '128923264');
        ContractDetailPage.getParameters().put('PTINTC', 'SSN');
        ContractDetailPage.getParameters().put('AID', '138745240696327493');
        ContractDetailPage.getParameters().put('ATC', 'PRAC');
        ContractDetailPage.getParameters().put('CNTRDID', '1013791');
        ContractDetailPage.getParameters().put('CNTRHID', '894318');
        ContractDetailPage.getParameters().put('NID', '1008476');
        ContractDetailPage.getParameters().put('BPID', 'M000000036');
        ContractDetailPage.getParameters().put('NSID', 'FREEDOM_CHOICEPL');
        Test.setCurrentPageReference(ContractDetailPage);
        
        ACETContractDetailsController ACETContractDetailCtrl = new ACETContractDetailsController();
        Continuation conti = (Continuation)ACETContractDetailCtrl.CallWSOnPageLoad();
        
        HttpResponse response = new HttpResponse();
        response.setBody('{"getMedicalProviderAgreementResponse":{"medicalProviderAgreement":{"key":{"providerId":"207546199996894216","providerTINId":"810477845","providerTINTypeCode":"TIN","addressId":"691445240366278061","addressTypeCode":"PRAC","contractDetailId":"5151078","contractHeaderId":"4418904","networkId":"1008476"},"contractHeader":{"id":"4418904","providerId":"207546199996894216","statusCode":"A","cancelDate":"9999-12-31"},"contractDetail":{"id":"5151078","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","cancelReasonCode":"027","networkAssignmentStatusCode":"I","networkAssignmentEffectiveDate":"2016-10-01","networkAssignmentCancelDate":"2016-10-31","version":"1","discountNonCoveredIndicator":"N","providerAssignmentTypeCode":"PCP","claimProcessStartDate":"0001-01-01","externalContractId":"000000000000000000000000360477","claimTypeCode":"Medical","acceptingNewPatientsIndicator":"Y","acceptingExistingPatientsIndicator":"Y"},"network":{"id":"1008476","statusCode":"A","effectiveDate":"2014-01-01","cancelDate":"9999-12-31","name":"Choice Plus POS","typeCode":["Group"]},"lineOfBusiness":[{"name":"E&I","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","medicalNecessityIndicator":"N","medicalNecessity":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}]}],"pricingSet":{"id":"002560401543C","description":"002560401543C","version":"1","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31"},"pricingSchedule":[{"id":"002560401543C","description":"002560401543C","version":"1","assignmentStatusCode":"A","assignmentEffectiveDate":"2009-08-01","assignmentCancelDate":"9999-12-31"}],"recovery":{"overpaymentIndicator":"Y","waitPeriod":"30","waitPeriodTypeCode":"Days","deadlinePeriod":"365","deadlinePeriodTypeCode":"Days"},"filingLimit":[{"id":"5171166","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","period":"365","periodType":"Days","typeCode":"Billed","penaltyPercentage":"100"}]}}}');
        response.setStatusCode(200);
        response.setStatus('OK');
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);
        for (String RequestLabel :requests.keySet()) {
            Test.setContinuationResponse(RequestLabel, response);   
            Object result = Test.invokeContinuationMethod(ACETContractDetailCtrl, conti);
             ACETGetMedProvAgreementWebservice AGMPAWS = new ACETGetMedProvAgreementWebservice();
        AGMPAWS.GetProvider('A', 'A', 'A','A','A','A','A','A','A','A');
        

        }
                
        Test.stopTest();
    }
    static testMethod void  ACETContractDetailsControllerTest2() {
        
       /* Account accountRec = ACETTestDataUtility.createAccount('test Account');
        insert accountRec;
        
        Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id, 'Test', 'Contact');
        insert contactRec;*/
        
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountRec = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountRec.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = contactRec.Id;
        insert interaction;
        
        Test.startTest();
        
        PageReference ContractDetailPage = Page.ACETContractDetails;
        ContractDetailPage.getParameters().put('interactionId', interaction.id);
        ContractDetailPage.getParameters().put('contactId', contactRec.id);
        ContractDetailPage.getParameters().put('sourceOriginator', 'Phone Call');
        ContractDetailPage.getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":null,"Relationship":null,"RatingMethod":null,"providerType":null,"ProductType":"","Product":"Gated INN only","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"Network":null,"MemberId":"36781823800","LastName":"Baker","isMember":" true","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1118476","GroupName":null,"GroupN":null,"Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2015","DOB":"11/7/1966","ConsumerAccountIndicator":null,"BenefitPlanId":null}');
        ContractDetailPage.getParameters().put('PID', '772445246508702091');
        ContractDetailPage.getParameters().put('TID', '128923264');
        ContractDetailPage.getParameters().put('PTINTC', 'SSN');
        ContractDetailPage.getParameters().put('AID', '138745240696327493');
        ContractDetailPage.getParameters().put('ATC', 'PRAC');
        ContractDetailPage.getParameters().put('CNTRDID', '1013791');
        ContractDetailPage.getParameters().put('CNTRHID', '894318');
        ContractDetailPage.getParameters().put('NID', '1008476');
        ContractDetailPage.getParameters().put('BPID', 'M000000036');
        ContractDetailPage.getParameters().put('NSID', 'FREEDOM_CHOICEPL');
        Test.setCurrentPageReference(ContractDetailPage);
        
        ACETContractDetailsController ACETContractDetailCtrl = new ACETContractDetailsController();
        Continuation conti = (Continuation)ACETContractDetailCtrl.CallWSOnPageLoad();
        
        HttpResponse response = new HttpResponse();
        response.setBody('{"getMedicalProviderAgreementResponse":{"medicalProviderAgreement":{"key":{"providerId":"207546199996894216","providerTINId":"810477845","providerTINTypeCode":"TIN","addressId":"691445240366278061","addressTypeCode":"PRAC","contractDetailId":"5151078","contractHeaderId":"4418904","networkId":"1008476"},"contractHeader":{"id":"4418904","providerId":"207546199996894216","statusCode":"A","cancelDate":"9999-12-31"},"contractDetail":{"id":"5151078","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","cancelReasonCode":"027","networkAssignmentStatusCode":"I","networkAssignmentEffectiveDate":"2016-10-01","networkAssignmentCancelDate":"2016-10-31","version":"1","discountNonCoveredIndicator":"N","providerAssignmentTypeCode":"PCP","claimProcessStartDate":"0001-01-01","externalContractId":"000000000000000000000000360477","claimTypeCode":"Medical","acceptingNewPatientsIndicator":"Y","acceptingExistingPatientsIndicator":"Y"},"network":{"id":"1008476","statusCode":"A","effectiveDate":"2014-01-01","cancelDate":"9999-12-31","name":"Choice Plus POS","typeCode":["Group"]},"lineOfBusiness":[{"name":"E&I","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","medicalNecessityIndicator":"N","medicalNecessity":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}]}],"pricingSet":{"id":"002560401543C","description":"002560401543C","version":"1","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31"},"pricingSchedule":[{"id":"002560401543C","description":"002560401543C","version":"1","assignmentStatusCode":"A","assignmentEffectiveDate":"2009-08-01","assignmentCancelDate":"9999-12-31"}],"recovery":{"overpaymentIndicator":"Y","waitPeriod":"30","waitPeriodTypeCode":"Days","deadlinePeriod":"365","deadlinePeriodTypeCode":"Days"},"filingLimit":[{"id":"5171166","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","period":"365","periodType":"Days","typeCode":"Billed","penaltyPercentage":"100"}]}}}');
        response.setStatusCode(500);
        response.setStatus('OK');
        
        ACETGetMedProvAgreementWebservice AGMPAWS = new ACETGetMedProvAgreementWebservice();
        AGMPAWS.GetProvider('631945246538828621', 'PTINCODE', 'PtypeCode','addressId','addressTypeCode','contractHeaderId','contractDetailId','networkId','networkSchedule','benefitPlanId');
        
        ACETGetMedProvAgreementJSON2Apex getMedProv = new ACETGetMedProvAgreementJSON2Apex();
        
        ACETGetMedProvAgreementJSON2Apex.PricingSet getMedProvPricingSet = new ACETGetMedProvAgreementJSON2Apex.PricingSet();
        
        getMedProvPricingSet.id = '12345';
        getMedProvPricingSet.description = 'Test';
        getMedProvPricingSet.version = '1.0';
        getMedProvPricingSet.statusCode = 'Y';
        getMedProvPricingSet.effectiveDate = '06/01/2017';
        getMedProvPricingSet.cancelDate = '06/07/2018';
        
        list<ACETGetMedProvAgreementJSON2Apex.Tier> getMedProvTierList = new list<ACETGetMedProvAgreementJSON2Apex.Tier>();
        
        ACETGetMedProvAgreementJSON2Apex.Tier getMedProvTier = new ACETGetMedProvAgreementJSON2Apex.Tier();
        
        getMedProvTier.benefitPlanTierNumber = '12345';
        getMedProvTier.benefitPlanTierDescription = 'Test';
        getMedProvTier.benefitPlanTierParStatusCode = 'Y';
        getMedProvTier.benefitPlanTierServiceAreaTypeCode = 'NY';
        getMedProvTier.benefitPlanTierBenefitType = 'M';
        getMedProvTierList.add(getMedProvTier);
        
        
        ACETGetMedProvAgreementJSON2Apex.Recovery getMedProvRecovery = new ACETGetMedProvAgreementJSON2Apex.Recovery();
        
        getMedProvRecovery.overpaymentIndicator = '12345';
        getMedProvRecovery.waitPeriod = 'Test1';
        getMedProvRecovery.waitPeriodTypeCode = '001';
        getMedProvRecovery.deadlinePeriod = 'Test2';
        getMedProvRecovery.deadlinePeriodTypeCode = '002';
        
        list<ACETGetMedProvAgreementJSON2Apex.FinancialPenalty> getMedProvFinPenaltyList = new list<ACETGetMedProvAgreementJSON2Apex.FinancialPenalty>();
        
        ACETGetMedProvAgreementJSON2Apex.FinancialPenalty getMedProvFinPenalty = new ACETGetMedProvAgreementJSON2Apex.FinancialPenalty();
        
        getMedProvFinPenalty.id = '12345';
        getMedProvFinPenalty.tableNumber = 'Test';
        getMedProvFinPenalty.statusCode = 'ABC';
        getMedProvFinPenalty.effectiveDate = '06/07/2017';
        getMedProvFinPenalty.cancelDate = '06/27/2018';
        getMedProvFinPenaltyList.add(getMedProvFinPenalty);
        
        ACETGetMedProvAgreementJSON2Apex.Network getMedProvNet = new ACETGetMedProvAgreementJSON2Apex.Network();
        
        getMedProvNet.id = '12345';
        getMedProvNet.name = 'Test';
        getMedProvNet.statusCode = 'ABC';
        getMedProvNet.effectiveDate = '06/07/2017';
        //getMedProvNet.typeCode = '06/27/2018';
        
        ACETGetMedProvAgreementJSON2Apex.Key getMedProvKey = new ACETGetMedProvAgreementJSON2Apex.Key();
        
        getMedProvKey.benefitPlanId  = '12345';
        
        ACETGetMedProvAgreementJSON2Apex.ContractDetail getMedProvContDet = new ACETGetMedProvAgreementJSON2Apex.ContractDetail();
        
        getMedProvContDet.id = '12345';
        getMedProvContDet.statusCode = 'ABC';
        getMedProvContDet.effectiveDate = '06/07/2017';
        getMedProvContDet.cancelReasonCode = 'ABC';
        getMedProvContDet.description= 'ABC';
        getMedProvContDet.version = 'ABC';
        getMedProvContDet.providerAssignmentTypeCode = 'ABC';
        getMedProvContDet.fundingArrangement = 'ABC';
        getMedProvContDet.acceptingNewPatientsIndicator = 'ABC';
        getMedProvContDet.acceptingExistingPatientsIndicator = 'ABC';
        
        list<ACETGetMedProvAgreementJSON2Apex.FilingLimit> getMedProvFilLimitList = new list<ACETGetMedProvAgreementJSON2Apex.FilingLimit>();
        
        ACETGetMedProvAgreementJSON2Apex.FilingLimit getMedProvFilLimit = new ACETGetMedProvAgreementJSON2Apex.FilingLimit();
        
        getMedProvFilLimit.id = '12345';
        getMedProvFilLimit.statusCode = 'ABC';
        getMedProvFilLimit.effectiveDate = '06/07/2017';
        getMedProvFilLimit.period = 'ABC';
        getMedProvFilLimit.periodType = 'A';
        getMedProvFilLimit.typeCode = 'A';
        getMedProvFilLimit.penaltyPercentage = '10%';
        getMedProvFilLimit.penaltyAmount = '100';
        getMedProvFilLimitList.add(getMedProvFilLimit);
        
        
        list<ACETGetMedProvAgreementJSON2Apex.LineOfBusiness> getMedProvLOBList = new list<ACETGetMedProvAgreementJSON2Apex.LineOfBusiness>();
        ACETGetMedProvAgreementJSON2Apex.LineOfBusiness getMedProvLOB = new ACETGetMedProvAgreementJSON2Apex.LineOfBusiness();
        
        getMedProvLOB.name = '12345';
        getMedProvLOB.medicalNecessityIndicator = '1';
        getMedProvLOBList.add(getMedProvLOB);
         
        ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement getMedProvAgree = new ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement();
        
        getMedProvAgree.key = getMedProvKey;
        getMedProvAgree.contractDetail = getMedProvContDet;
        getMedProvAgree.network = getMedProvNet;
        getMedProvAgree.pricingSet = getMedProvPricingSet ;
        getMedProvAgree.recovery = getMedProvRecovery;
        getMedProvAgree.financialPenalty = getMedProvFinPenaltyList;
        getMedProvAgree.filingLimit = getMedProvFilLimitList; 
        getMedProvAgree.lineOfBusiness = getMedProvLOBList; 
        
        ACETContractDetailsController.FilingLimitDetailsWrapper AFLDWR=new ACETContractDetailsController.FilingLimitDetailsWrapper();
        AFLDWR.filingLimitPeriod='FLP';
        AFLDWR.filingLimitEffectiveDate='FLED';
        AFLDWR.filingLimitPenaltyAmount='FLPA';
        AFLDWR.filingLimitPeriodType='D';
        AFLDWR.filingLimitPeriodType='A';
        AFLDWR.filingLimitType='FLT';
        AFLDWR.filingLimitCancelDate='FLCD';
        AFLDWR.filingLimitPenaltyPercentage='FLPP';
        ACETContractDetailsController.TierDetailsWrapper ATDW = new ACETContractDetailsController.TierDetailsWrapper();
        ATDW.parStatus='PSTAtUS ';
        ATDW.tier='TESTTier';
        ATDW.tierDescription='TD';
        ATDW.benefitType='BT';
        ATDW.serviceAreaType='SA';
        ACETContractDetailsController.PricingSchedulesWrapper  ADPSW = new ACETContractDetailsController.PricingSchedulesWrapper();
        ADPSW.pricingScheduleStatus='PSS';
        ADPSW.pricingScheduleID='PSID';
        ADPSW.pricingScheduleDescription='PSD';
        ADPSW.pricingScheduleEffectiveDate='PSED';
        ADPSW.pricingScheduleCancelDate='PSC';
        ADPSW.facilityPaperTypeID='FPT';
        ADPSW.facilityPaperTypeDescription='FPTD';
        ACETContractDetailsController.LineOfBusinessWrapper ALOB = new ACETContractDetailsController.LineOfBusinessWrapper();
        ALOB.LOBName='LOB1';
        ALOB.MedicalNecessity='MN';
              
        Test.stopTest();
    }
    static testMethod void ACETGetMedProvAgreementWebserviceTestMethod1(){
           
        Account accountRec = ACETTestDataUtility.createAccount('test Account');
        insert accountRec;
        
        Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id, 'Test', 'Contact');
        insert contactRec;
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = contactRec.Id;
        insert interaction;
        
        Test.startTest();
        
        PageReference ContractDetailPage = Page.ACETContractDetails;
        ContractDetailPage.getParameters().put('interactionId', interaction.id);
        ContractDetailPage.getParameters().put('contactId', contactRec.id);
        ContractDetailPage.getParameters().put('sourceOriginator', 'Phone Call');
        ContractDetailPage.getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":null,"Relationship":null,"RatingMethod":null,"providerType":null,"ProductType":"","Product":"Gated INN only","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"Network":null,"MemberId":"36781823800","LastName":"Baker","isMember":" true","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1118476","GroupName":null,"GroupN":null,"Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2015","DOB":"11/7/1966","ConsumerAccountIndicator":null,"BenefitPlanId":null}');
        ContractDetailPage.getParameters().put('PID', '772445246508702091');
        ContractDetailPage.getParameters().put('TID', '128923264');
        ContractDetailPage.getParameters().put('PTINTC', 'SSN');
        ContractDetailPage.getParameters().put('AID', '138745240696327493');
        ContractDetailPage.getParameters().put('ATC', 'PRAC');
        ContractDetailPage.getParameters().put('CNTRDID', '1013791');
        ContractDetailPage.getParameters().put('CNTRHID', '894318');
        ContractDetailPage.getParameters().put('NID', '1008476');
        ContractDetailPage.getParameters().put('BPID', 'M000000036');
        ContractDetailPage.getParameters().put('NSID', 'FREEDOM_CHOICEPL');
        Test.setCurrentPageReference(ContractDetailPage);
        
        ACETContractDetailsController ACETContractDetailCtrl = new ACETContractDetailsController();
        Continuation conti = (Continuation)ACETContractDetailCtrl.CallWSOnPageLoad();
        
        HttpResponse response = new HttpResponse();
        response.setBody('{"getMedicalProviderAgreementResponse":{"medicalProviderAgreement":{"key":{"providerId":"207546199996894216","providerTINId":"810477845","providerTINTypeCode":"TIN","addressId":"691445240366278061","addressTypeCode":"PRAC","contractDetailId":"5151078","contractHeaderId":"4418904","networkId":"1008476"},"contractHeader":{"id":"4418904","providerId":"207546199996894216","statusCode":"I","cancelDate":"9999-12-31"},"contractDetail":{"id":"5151078","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","cancelReasonCode":"027","networkAssignmentStatusCode":"I","networkAssignmentEffectiveDate":"2016-10-01","networkAssignmentCancelDate":"2016-10-31","version":"1","discountNonCoveredIndicator":"N","providerAssignmentTypeCode":"PCP","claimProcessStartDate":"0001-01-01","externalContractId":"000000000000000000000000360477","claimTypeCode":"Medical","acceptingNewPatientsIndicator":"Y","acceptingExistingPatientsIndicator":"Y"},"network":{"id":"1008476","statusCode":"A","effectiveDate":"2014-01-01","cancelDate":"9999-12-31","name":"Choice Plus POS","typeCode":["Group"]},"lineOfBusiness":[{"name":"E&I","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31","medicalNecessityIndicator":"N","medicalNecessity":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}]}],"pricingSet":{"id":"002560401543C","description":"002560401543C","version":"1","statusCode":"I","effectiveDate":"2016-10-01","cancelDate":"2016-10-31"},"pricingSchedule":[{"id":"002560401543C","description":"002560401543C","version":"1","assignmentStatusCode":"A","assignmentEffectiveDate":"2009-08-01","assignmentCancelDate":"9999-12-31"}],"recovery":{"overpaymentIndicator":"Y","waitPeriod":"30","waitPeriodTypeCode":"Days","deadlinePeriod":"365","deadlinePeriodTypeCode":"Days"},"filingLimit":[{"id":"26475471","statusCode":"A","effectiveDate":"2017-12-01","cancelDate":"9999-12-31","assignmentLevel":"providerContract","period":"90","periodType":"Days","typeCode":"Billed","penaltyPercentage":"100"},{"id":"56204628","statusCode":"A","effectiveDate":"2017-12-01","cancelDate":"9999-12-31","assignmentLevel":"contract","period":"90","periodType":"Days","typeCode":"Billed","penaltyPercentage":"100"}]}}}');
        response.setStatusCode(200);
        response.setStatus('OK');
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);
        for (String RequestLabel :requests.keySet()) {
            Test.setContinuationResponse(RequestLabel, response);   
            Object result = Test.invokeContinuationMethod(ACETContractDetailCtrl, conti);
             ACETGetMedProvAgreementWebservice AGMPAWS = new ACETGetMedProvAgreementWebservice();
        AGMPAWS.GetProvider('A', 'A', 'A','A','A','A','A','A','A','A');
            
        Test.stopTest();
    }
        
   }
}