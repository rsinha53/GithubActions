@isTest
public class ACETLGT_AuthorizationDetailCtrlTest {

    @isTest
    static void testGetAuthorizationsOutPatients() {
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseOutpatientFacility = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetOutpatientFacilityDetailResponseJSON() );
        OILResponseOutpatientFacility.TokenExpired = false;        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseOutpatientFacility);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ACETLGT_AuthorizationDetailController.DetailResultWrapper wr;
        String tempJSONString = 'a_b_c_null_11/11/1999_f_g_h_i_j_k_l_m';
        
        Test.startTest();
        wr = ACETLGT_AuthorizationDetailController.getAuthorizations('1234', '', 'Outpatient', tempJSONString);
        System.assert(wr != null);
        Test.stopTest();
    }
    
     @isTest
    static void testGetAuthorizationsInPatients() {
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseOutpatientFacility = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetOutpatientFacilityDetailResponseJSON() );
        OILResponseOutpatientFacility.TokenExpired = false;        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseOutpatientFacility);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ACETLGT_AuthorizationDetailController.DetailResultWrapper wr;
        String tempJSONString = 'a_b_c_d_e_f_g_h_i_j_k_l_m';
        
        Test.startTest();
        wr = ACETLGT_AuthorizationDetailController.getAuthorizations('1234', '', 'Inpatient', tempJSONString);
        System.assert(wr != null);
        Test.stopTest();
    }
    
     @isTest
    static void testGetAuthorizationsOutPatientFacility() {
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseOutpatientFacility = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetOutpatientFacilityDetailResponseJSON() );
        OILResponseOutpatientFacility.TokenExpired = false;        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseOutpatientFacility);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ACETLGT_AuthorizationDetailController.DetailResultWrapper wr;
        String tempJSONString = 'a_b_c_d_e_f_g_h_i_j_k_l_m';
        
        Test.startTest();
        wr = ACETLGT_AuthorizationDetailController.getAuthorizations('1234', '', 'Outpatient Facility', tempJSONString);
        System.assert(wr != null);
        Test.stopTest();
    }
    
    @isTest
    static void testGenerateICUEURL() {
        Test.startTest();
        
        List<ACETOrgInstanceURLToOrgNameMap__c> orgNames = new List<ACETOrgInstanceURLToOrgNameMap__c>();
        List<ACETOrgNameToSwivelEndpointMap__c> endPoints = new List<ACETOrgNameToSwivelEndpointMap__c>();
        List<ACETWrapEncryptionKey__c> keys = new List<ACETWrapEncryptionKey__c>();
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap1.Name = 'qaacet--acetqa.cs26';
        orgnamemap1.Org_Name__c = 'qa';
        orgNames.add(orgnamemap1);
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap.Name = 'devacet--acetdev.cs26';
        orgnamemap.Org_Name__c = 'dev';
        orgNames.add(orgnamemap);
            
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        orgNames.add(urlinstance3);
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        orgNames.add(urlinstance4);
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        orgNames.add(urlinstance5);
     
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap6 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap6.Name = 'emidscm';
        orgnamemap6.Org_Name__c = 'qa';
        orgNames.add(orgnamemap6);
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap7 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap7.Name = 'fullcopy';
        orgnamemap7.Org_Name__c = 'qa';
        orgNames.add(orgnamemap7);
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap8 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap8.Name = 'optum';
        orgnamemap8.Org_Name__c = 'prd';
        orgNames.add(orgnamemap8);
        
        insert orgNames;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_ICUECreateAuthorization';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        endPoints.add(SwivelEndpoint);
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        endPoints.add(SwivelEndpoint1);
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        endPoints.add(SwivelEndpoint2);
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_ICUECreateAuthorization';
        swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
        endPoints.add(swivel3);
        
        insert endPoints;
                
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='dev_ICUEEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(encryptKey);
                
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_ICUEEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(encryptKey1);
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_ICUEEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(dev1key);
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_ICUEEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(prdkey);
        
        insert keys;
        
        String url = ACETLGT_AuthorizationDetailController.GenerateICUEURL('0123456789');
        Test.stopTest();
        System.assert(String.isNotBlank(url));
    }
    
    @isTest
    static void testDetailResultWrapper() {
        ACETLGT_AuthorizationDetailResult wr = new ACETLGT_AuthorizationDetailResult();
        wr.Authorization_Number = '';
        wr.Actual_Admission_Date = '';
        wr.Actual_Discharge_Date = '';
        wr.Pre_Determination = '';
        wr.Discharge_Location = '';
        wr.Expiration_Date = '';
        wr.Service_End_Date = '';
        wr.Service_Start_Date = '';
        wr.Create_Dt = '';
        wr.Letter_Gen_ID = '';
        wr.Seq_No = '';
        wr.Authorization_Number_3 = '';
        wr.Primary_Phone = '';
        wr.Facility_Decision_Comment = '';
        wr.Facility_Decision_Reason = '';
        wr.Facility_Gap_Outcome = '';
        wr.Facility_Claim_Remark_Code = '';
        wr.Facility_Decision_Rendered_Date = '';
        wr.Facility_Decision_Sub_Type = '';
        wr.Facility_Decision_Outcome = '';
        wr.Facility_Provider_Status = '';
        wr.Service_Desc = '';
        wr.Service_Detail = '';
        wr.POS = '';
        wr.Facility_Authorization_Number = '';
        
        ACETLGT_AuthorizationDetailResult.authFacilityDetail wr1 = new ACETLGT_AuthorizationDetailResult.authFacilityDetail();
        wr1.Facility_Provider_Status = '';
        wr1.Facility_Decision_Outcome = '';
        wr1.Facility_Decision_Sub_Type = '';
        wr1.Facility_Decision_Rendered_Date = '';
        wr1.Facility_Claim_Remark_Code = '';
        wr1.Facility_Gap_Outcome = '';
        wr1.Facility_Decision_Reason = '';
        wr1.Facility_Decision_Comment = '';
        
        ACETLGT_AuthorizationDetailResult.BedDayDec wr2 = new ACETLGT_AuthorizationDetailResult.BedDayDec();
        wr2.bedDatesStart = '';
        wr2.bedDatesStop = '';
        wr2.bedTypeCode = '';
        wr2.bedTypeDescription = '';
        wr2.revenueCode = '';
        wr2.revenueDescription = '';
        wr2.decisionReasonCode = '';
        wr2.decisionReasonDescription = '';
        wr2.systemClaimRemarkCode = '';
        wr2.systemClaimRemarkDescription = '';
        wr2.systemClaimRemarkDescription = '';
        wr2.decisionOutcomeDescription = '';
        wr2.decisionUpdateDateTime = '';
        wr2.decisionOutcomeCode = '';
        
        wr.bedDayDecision = new List<ACETLGT_AuthorizationDetailResult.BedDayDec>{wr2};
            
        ACETLGT_AuthorizationDetailResult.authServiceDetail wr3 = new ACETLGT_AuthorizationDetailResult.authServiceDetail();
        wr3.Service_Decision_Outcome = '';
        wr3.Service_Decision_Sub_Type = '';
        wr3.Service_Decision_Rendered_Date = '';
        wr3.Service_Claim_Remark_Code = '';
        wr3.Service_Decision_Reason = '';
        
        wr.authServiceDetails = new List<ACETLGT_AuthorizationDetailResult.authServiceDetail>{wr3};
    }
    
    @isTest
    static void testSearchResultWrapper() {
        ACETLGT_AuthorizationSearchResult wr = new ACETLGT_AuthorizationSearchResult();
        wr.jsonString = '';
        wr.Case_Type_Code = '';
        wr.Case_Type_Desc = '';
        wr.Case_Reason_Code = '';
        wr.Case_Reason_Desc = '';
        wr.Admit_Date = '';
        wr.Dscharg_Date = '';
        wr.Expected_Start_Date = '';
        wr.Actual_End_Date = '';
        wr.Actual_Start_Date = '';
        wr.Expected_End_Date = '';
        wr.CountCode = '';
        wr.CountDesc = '';
        wr.AuthID = '';
        wr.selected = false;
    }
    
    @isTest
    static void testJSON2Apex() {
        ACETLGT_GetAuthorizationJSON2APEX.StatusReasonCode statusCode = new ACETLGT_GetAuthorizationJSON2APEX.StatusReasonCode();
        statusCode.code = '200';
        statusCode.description = 'OK';
        
        ACETLGT_GetAuthorizationJSON2APEX.EnrolleIdentifiers enroll = new ACETLGT_GetAuthorizationJSON2APEX.EnrolleIdentifiers();
        enroll.id = 'abcdefghijk';
        enroll.typeCode = 'abce';
        
        ACETLGT_GetAuthorizationJSON2APEX.RuleDecision rule = new ACETLGT_GetAuthorizationJSON2APEX.RuleDecision();
        
        ACETLGT_GetAuthorizationJSON2APEX.EffectiveDateRange effDateRange = new ACETLGT_GetAuthorizationJSON2APEX.EffectiveDateRange();
        effDateRange.stopDate = '12/12/2000';

		ACETLGT_GetAuthorizationJSON2APEX.Address address = new ACETLGT_GetAuthorizationJSON2APEX.Address();        
        address.addressLine1 = '';
        address.city = '';
        address.postalCode1 = '';
        address.state = statusCode;
        address.addressType = statusCode;
        address.countryCode = statusCode;
        address.effectiveDateRange = effDateRange;
        address.countyFIPS = '';
        address.countyName = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.ProcedureCode procedure = new ACETLGT_GetAuthorizationJSON2APEX.ProcedureCode();        
        procedure.typeCode = '';
        procedure.typeCodeDesc = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.ServiceDecisionSource serviceDec = new ACETLGT_GetAuthorizationJSON2APEX.ServiceDecisionSource();        
        serviceDec.sourceSeqNumber = '1212121';
        serviceDec.decisionSourceType = statusCode;

		ACETLGT_GetAuthorizationJSON2APEX.StatusReasonCodeNew reasonCode = new ACETLGT_GetAuthorizationJSON2APEX.StatusReasonCodeNew();
        reasonCode.code = '12344';
        reasonCode.description = 'sample description';

		ACETLGT_GetAuthorizationJSON2APEX.AvaliabilityeffectiveDateRange availEffDateRange = new ACETLGT_GetAuthorizationJSON2APEX.AvaliabilityeffectiveDateRange();        
        availEffDateRange.code = '';
        availEffDateRange.sourceSystem = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.ProviderContractOrgs providerContract = new ACETLGT_GetAuthorizationJSON2APEX.ProviderContractOrgs();        
        providerContract.contractOrg = '';
        providerContract.contractContext = '';
        providerContract.contractOrgPriority = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.Providers providers = new ACETLGT_GetAuthorizationJSON2APEX.Providers();
        providers.productType = '';
        providers.primaryPhone = '';
        providers.primaryTelephoneInternationalIndicator = '';
        providers.faxNumber = '';
        providers.faxInternationalIndicator = '';
        providers.providerContractOrgs = new List<ACETLGT_GetAuthorizationJSON2APEX.ProviderContractOrgs>{providerContract};
            
        ACETLGT_GetAuthorizationJSON2APEX.Notes notes = new ACETLGT_GetAuthorizationJSON2APEX.Notes();
        notes.createdByUserFirstName = '';
        notes.createdByUserLastName = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.SourceMemberId sourceMemberId = new ACETLGT_GetAuthorizationJSON2APEX.SourceMemberId();
        sourceMemberId.id = '';
        sourceMemberId.etype = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.Member member = new ACETLGT_GetAuthorizationJSON2APEX.Member();
        member.birthDate = '12/12/1990';
        member.firstName = 'abcd';
        member.lastName = 'defds';
        member.middleName = 'root';
        member.relationshipCode = '1234566';
        member.sourceMemberId = sourceMemberId;
        member.enrolleIdentifiers = new List<ACETLGT_GetAuthorizationJSON2APEX.EnrolleIdentifiers>{ enroll };
        member.gender = statusCode;
        member.address = new List<ACETLGT_GetAuthorizationJSON2APEX.Address>{ address };
        
        ACETLGT_GetAuthorizationJSON2APEX.Diagnosis diagnosis = new ACETLGT_GetAuthorizationJSON2APEX.Diagnosis();
        diagnosis.sequenceNumber = '123445';
        diagnosis.preferenceInd = '22222';
        diagnosis.admitInd = '2222';
        
        ACETLGT_GetAuthorizationJSON2APEX.BedDayDec bed = new ACETLGT_GetAuthorizationJSON2APEX.BedDayDec();
        bed.bedDates = new ACETLGT_GetAuthorizationJSON2APEX.ServiceEffDates();
        bed.bedTypeCode = statusCode;
        bed.revenueCode = statusCode;
        bed.decisionReasonCode = statusCode;
        bed.systemClaimRemarkCode = statusCode;
        bed.overrideClaimRemarkCode = reasonCode;
        bed.decisionOutcomeCode = statusCode;
        bed.decisionUpdateDateTime = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.ServiceNonFacility serviceNonFac = new ACETLGT_GetAuthorizationJSON2APEX.ServiceNonFacility();
        serviceNonFac.advanceNotificationTimestamp = '';
        serviceNonFac.placeOfServiceCode = statusCode;
        serviceNonFac.procedureFrequencyCode = statusCode;
        serviceNonFac.procedureUnitCount = '2';
        serviceNonFac.procedureUnitOfMeasureCode = statusCode;
        serviceNonFac.serviceDescUrgencyCode = statusCode;
        serviceNonFac.serviceDetailCategoryCode = statusCode;
        serviceNonFac.unitPerFrequencyCount = '2';
        serviceNonFac.dmeTotalCost = '21';
        serviceNonFac.dmeEnternalFeedingSSONutrInd = '12';
        
        ACETLGT_GetAuthorizationJSON2APEX.AuthDetailsResponse resp = new ACETLGT_GetAuthorizationJSON2APEX.AuthDetailsResponse();
		resp.authId = '12121212';
        resp.coverageSequenceNumber = '12121212';
        resp.createDateTime = '12/12/1999';
        resp.globalId = '12121212';
        resp.member = member;
        resp.ruleDecision = new List<ACETLGT_GetAuthorizationJSON2APEX.RuleDecision>{ rule };
        resp.letterTypes = new List<ACETLGT_GetAuthorizationJSON2APEX.RuleDecision>{ rule };
        
        ACETLGT_GetAuthorizationJSON2APEX.Services services = new ACETLGT_GetAuthorizationJSON2APEX.Services();
        services.sequenceNumber = '';
        services.procedureFullDescription = '';
        
        ACETLGT_GetAuthorizationJSON2APEX.FacilityDecision fDecision = new ACETLGT_GetAuthorizationJSON2APEX.FacilityDecision();
        fDecision.decisionSequenceNbr = '2223';
        fDecision.madeByUserid = '2223';
        fDecision.facilityDecisionSource = new List<ACETLGT_GetAuthorizationJSON2APEX.ServiceDecisionSource>{ serviceDec };
        
        ACETLGT_GetAuthorizationJSON2APEX.Facility facility = new ACETLGT_GetAuthorizationJSON2APEX.Facility();
        facility.notifyLateInd = '';
        facility.notifyRetrospectiveInd = '';
        facility.icmAvaliableInd = '';
        
        ACETLGT_GetAuthorizationJSON2APEX json2Apex = new ACETLGT_GetAuthorizationJSON2APEX();
        json2Apex.subTypeCode = statusCode;
        json2Apex.systemClaimRemarkCode = '232332';
        json2Apex.renderedDateTime = '12/12/2012';
    }
}