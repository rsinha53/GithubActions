/**
 @Desc: Test Coverages for Authorization logic
 @Date: 08 JAN 2020
 @Dev: Malinda
 */
@isTest
private class ACET_AuthorizationControllerTest {
    
    @testSetup static void setup() {
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User userObj;
         System.runAs(thisUser){

       Profile profAdmin = SAETestDataFactory.loadProfile(SAEConstants.SAE_PROFILE_SYSADMIN_NAME); 

        userObj = new User();
       userObj.Alias = SAEConstants.SAE_USER_SYSADMIN_ALIAS;
       userObj.Email = SAEConstants.SAE_USER_SYSADMIN_EMAIL;
       userObj.EmailEncodingKey = SAEConstants.SAE_USER_EMAILENCODINGKEY;
       userObj.LastName = SAEConstants.SAE_USER_SYSADMIN_LASTNAME;
       userObj.LanguageLocaleKey = SAEConstants.SAE_USER_LANGLOCALEKEY;
       userObj.LocaleSidKey = SAEConstants.SAE_USER_LOCALESIDKEY;
       userObj.ProfileId = profAdmin.Id;
       userObj.TimeZoneSidKey = SAEConstants.SAE_USER_TIMEZONESIDKEY;
       userObj.UserName = SAEConstants.SAE_USER_ADMIN_USERNAME;
       userObj.FederationIdentifier = 'xxxx121xxxx';
       INSERT userObj;
         }
       
       INSERT new ACETOrgInstanceURLToOrgNameMap__c(Name = 'qa',Org_Name__c = 'qa');        
      
       INSERT new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUECreateAuthorization', Swivel_Endpoint__c = 'https://basics.uhc.com/basicscompmgmt');
        
       INSERT new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey', Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c = 'AES256');

        // US3636832: Migration of authSummary and authDetail APIs to new framework- Swapnil
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        WebserviceConfigurations__c tokenAPIWSConfigGetAuth = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('GetAuthorization');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigsGetAuth = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfigGetAuth.Id);

        WebserviceConfigurations__c tokenAPIWSConfigFindAuth = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('FindAuthorization');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigsFindAuth = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfigFindAuth.Id);

    }

    static testMethod void findAuthorizations() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETAuthorizationFindAuthWebServiceMock());
        ACET_FindAuthorizationWebservice.FindAuthRequest requestObj = new ACET_FindAuthorizationWebservice.FindAuthRequest();
        requestObj.SourceMemberId = '625871210';
        requestObj.SourceMemberFirstName = 'PATRICK';
        requestObj.SourceMemberLasttName = 'ALFORD';
        requestObj.SourceMemberDOB = '1960-10-27';
        requestObj.StartDate = '1960-10-27';
        requestObj.PolicyIndex = 'test';
        requestObj.GetAllAuth = 'test';
        requestObj.SRNNumber = 'test';
        ACET_AuthorizationController.SearchResultWrapper response = ACET_AuthorizationController.findAuthorizations(requestObj);
        System.assertNotEquals(null, response);
        Test.stopTest();
    }

    static testMethod void findAuthorizationsWrapper() {
        Test.startTest();       
        String strJSONResponseBody = SAETestDataFactory.getStaticResourceResponse(SAEConstants.FIND_AUTH_RESP);
        System.assertNotEquals(null, ACET_FindAuthorizationJSON2Apex.parse(strJSONResponseBody));
        Test.stopTest();
    }

    static testMethod void getAuthorizations() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETAuthorizationGetAuthWebServiceMock());
        ACET_GetAuthorizationStatusDetails.AuthDetailsRequest requestObj = new ACET_GetAuthorizationStatusDetails.AuthDetailsRequest();
        requestObj.AUTH_ID = '156627064';
        requestObj.XREF_ID = '625871210';
        ACET_AuthorizationController.SearchResultWrapperAuthStatus response = ACET_AuthorizationController.getAuthorizationStatus(requestObj);

        ACET_AuthorizationStatusResponse.Services ServicesCls = new ACET_AuthorizationStatusResponse.Services(); 
        ServicesCls.sequenceNumber = 'sequenceNumber';
        ServicesCls.serviceReferenceNumber = 'serviceReferenceNumber';
        ServicesCls.procedureFullDescription = 'procedureFullDescription';
        ServicesCls.providerSeqNumber = 'providerSeqNumber';

        ACET_AuthorizationStatusResponse.ProcedureCode ProcedureCodeCls = new ACET_AuthorizationStatusResponse.ProcedureCode();
        ProcedureCodeCls.code = 'code';
        ProcedureCodeCls.codeDesc = 'codeDesc';
        ProcedureCodeCls.typeCode = 'typeCode';
        ProcedureCodeCls.typeCodeDesc = 'typeCodeDesc';
        ServicesCls.procedureCode = ProcedureCodeCls;

        ACET_AuthorizationStatusResponse.serviceNonFacility serviceNonFacilityCls = new ACET_AuthorizationStatusResponse.serviceNonFacility();
        serviceNonFacilityCls.advanceNotificationTimestamp = 'advanceNotificationTimestamp';

        ACET_AuthorizationStatusResponse.StatusReasonCode StatusReasonCodeCls = new ACET_AuthorizationStatusResponse.StatusReasonCode();
        StatusReasonCodeCls.code = 'code';
        StatusReasonCodeCls.description = 'description';

        serviceNonFacilityCls.placeOfServiceCode = StatusReasonCodeCls;
        serviceNonFacilityCls.procedureFrequencyCode = StatusReasonCodeCls;
        serviceNonFacilityCls.procedureUnitOfMeasureCode = StatusReasonCodeCls;
        serviceNonFacilityCls.serviceDescUrgencyCode = StatusReasonCodeCls;
        serviceNonFacilityCls.serviceDetailCategoryCode = StatusReasonCodeCls;

        ACET_AuthorizationStatusResponse.ServiceEffDates ServiceEffDatesCls = new ACET_AuthorizationStatusResponse.ServiceEffDates();
        ServiceEffDatesCls.startDate = 'startDate';
        ServiceEffDatesCls.stopDate = 'stopDate';
        serviceNonFacilityCls.serviceEffDates = ServiceEffDatesCls;

        serviceNonFacilityCls.procedureUnitCount = 'procedureUnitCount';
        serviceNonFacilityCls.unitPerFrequencyCount = 'unitPerFrequencyCount';
        serviceNonFacilityCls.dmeTotalCost = 'dmeTotalCost';
        serviceNonFacilityCls.dmeProcurementType = 'dmeProcurementType';
        serviceNonFacilityCls.dmeEnternalFeedingSSONutrInd = 'dmeEnternalFeedingSSONutrInd';
        ServicesCls.serviceNonFacility = serviceNonFacilityCls;

        ACET_AuthorizationStatusResponse.ServiceDecision ServiceDecisionCls = new ACET_AuthorizationStatusResponse.ServiceDecision();
        ServiceDecisionCls.decisionSequenceNbr = 'decisionSequenceNbr';
        ServiceDecisionCls.decisionSubTypeCode = StatusReasonCodeCls;
        ServiceDecisionCls.decisionReasonCode = StatusReasonCodeCls;
        ServiceDecisionCls.decisionOutcomeCode = StatusReasonCodeCls;
        ServiceDecisionCls.decisionMadeByUserId = 'decisionMadeByUserId';
        ServiceDecisionCls.derivedClaimRemarkCode = StatusReasonCodeCls;
        ServiceDecisionCls.decisionRenderedDatetime = 'decisionRenderedDatetime';
        ServicesCls.serviceDecision = ServiceDecisionCls;
      
        System.assertNotEquals(null, response);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETAuthorizationGetAuthWebServiceMock401());
        response =  ACET_AuthorizationController.getAuthorizationStatus(requestObj);
        System.assertNotEquals(null, response);


        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETAuthorizationGetAuthWebServiceMock400());
        response =  ACET_AuthorizationController.getAuthorizationStatus(requestObj);
        System.assertNotEquals(null, response);

        Test.stopTest();
    }

    static testMethod void getAuthorizationsNegativeTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETAuthorizationGetAuthWebServiceMock());
        ACET_GetAuthorizationStatusDetails.AuthDetailsRequest requestObj = new ACET_GetAuthorizationStatusDetails.AuthDetailsRequest();
        requestObj.AUTH_ID = '156627064';
        requestObj.XREF_ID = '625871210';
        requestObj = null;
        ACET_AuthorizationController.SearchResultWrapperAuthStatus response = ACET_AuthorizationController.getAuthorizationStatus(requestObj);
        System.assertNotEquals(null, response);
        Test.stopTest();
    }

    static testMethod void getAuthorizationsWrapper() {
        Test.startTest();        
        String strJSONResponseBody = SAETestDataFactory.getStaticResourceResponse(SAEConstants.GET_AUTH_RESP);
                
        ACET_AuthorizationStatusResponse.AuthDetailsResponse objAuthDetailsResponse = new ACET_AuthorizationStatusResponse.AuthDetailsResponse();
        objAuthDetailsResponse.authId = '0101010101';
        objAuthDetailsResponse.coverageSequenceNumber = '0101010101';
        objAuthDetailsResponse.createDateTime = '2020-01-01';
        objAuthDetailsResponse.statusReasonCode = null;
        objAuthDetailsResponse.statusCode = null;
        objAuthDetailsResponse.serviceSettingTypeCode = null;
        objAuthDetailsResponse.globalId = '0101010101';
        objAuthDetailsResponse.reviewPriority = null;
        objAuthDetailsResponse.serviceCategoryTypeCode = null;
        objAuthDetailsResponse.member = null;
        objAuthDetailsResponse.authFollowUpContact = null;
        objAuthDetailsResponse.providers = null;
        objAuthDetailsResponse.notes = null;
        objAuthDetailsResponse.facility = null;
        objAuthDetailsResponse.ruleDecision = null;
        objAuthDetailsResponse.services = null;
        objAuthDetailsResponse.diagnosis = null;
        objAuthDetailsResponse.letterTypes = null;
        objAuthDetailsResponse.copiedToDetail = null;
        objAuthDetailsResponse.memberBenefitPlanTier = null;

        ACET_AuthorizationStatusResponse.Address objAddress = new ACET_AuthorizationStatusResponse.Address();
        objAddress.addressLine1 = 'adrs';
        objAddress.city = 'city';
        objAddress.state = null;
        objAddress.postalCode1 = '0101010101';
        objAddress.addressType = null;
        objAddress.countryCode = null;
        objAddress.effectiveDateRange = null;
        objAddress.countyFIPS = '0101010101';
        objAddress.countyName = 'US';

        ACET_AuthorizationStatusResponse.FacilityDecision objFacilityDecision = new ACET_AuthorizationStatusResponse.FacilityDecision();
        objFacilityDecision.decisionSequenceNbr  = '0101010101';
        objFacilityDecision.madeByUserId  = '0101010101';
        objFacilityDecision.renderedDateTime  = '2020-01-01';
        objFacilityDecision.subTypeCode = null;
        objFacilityDecision.decisionReasonCode = null;
        objFacilityDecision.decisionOutcomeCode = null;
        objFacilityDecision.derviedClaimRemarkCode = null;
        objFacilityDecision.facilityDecisonSource = null;

        ACET_AuthorizationStatusResponse.AuthFollowUpContact objAuthFollowUpContact = new ACET_AuthorizationStatusResponse.AuthFollowUpContact();
        objAuthFollowUpContact.contactFullName = 'Xya';
        objAuthFollowUpContact.communicationContactRoleCode = null;
        objAuthFollowUpContact.phoneNumber = null;

        ACET_AuthorizationStatusResponse.DiagnosisCode objDiagnosisCode = new ACET_AuthorizationStatusResponse.DiagnosisCode();
        objDiagnosisCode.code = '0101010101';
        objDiagnosisCode.codeDesc = 'test';
        objDiagnosisCode.typeCode = '0101010101';
        objDiagnosisCode.typeCodeDesc = 'test';

        ACET_AuthorizationStatusResponse.StatusReasonCode objStatusReasonCode = new ACET_AuthorizationStatusResponse.StatusReasonCode();
        objStatusReasonCode.code = '0101010101';
        objStatusReasonCode.description = 'test';

        ACET_AuthorizationStatusResponse.NetworkId objNetworkId = new ACET_AuthorizationStatusResponse.NetworkId();
        objNetworkId.description = 'test';

        ACET_AuthorizationStatusResponse.Providers objProviders = new ACET_AuthorizationStatusResponse.Providers();
        objProviders.seqNum = '0101010101';
        objProviders.categoryCode = '0101010101';
        objProviders.organizationName = 'test';
        objProviders.address = null;
        objProviders.specialtyType = null;
        objProviders.primaryPhone = '0101010101';
        objProviders.primaryTelephoneInternationalIndicator = '0101010101';
        objProviders.faxInternationalIndicator = '0101010101';
        objProviders.networkId = null;
        objProviders.networkStatusType = null;
        objProviders.providerIdentifiers = null;
        objProviders.role = null;
        //objProviders.providerContractOrgs = null;
        objProviders.firstName = 'test';
        objProviders.middleName = 'test';
        objProviders.lastName = 'test';
        objProviders.faxNumber = '0101010101';

        ACET_AuthorizationStatusResponse.EnrolleIdentifiers objEnrolleIdentifiers = new ACET_AuthorizationStatusResponse.EnrolleIdentifiers();
        objEnrolleIdentifiers.id = '0101010101';
        objEnrolleIdentifiers.typeCode = '0101010101';
        objEnrolleIdentifiers.typeCodeDesc = 'test';

        ACET_AuthorizationStatusResponse.SpecialtyType objSpecialtyType = new ACET_AuthorizationStatusResponse.SpecialtyType();
        objSpecialtyType.code = '0101010101';
        objSpecialtyType.desc_x = 'test';

        ACET_AuthorizationStatusResponse.SpecialtyType_Z objSpecialtyType_Z = new ACET_AuthorizationStatusResponse.SpecialtyType_Z();
        objSpecialtyType_Z.code = '0101010101';
        objSpecialtyType_Z.desc_Z = 'test';

        ACET_AuthorizationStatusResponse.IcueMemberID objIcueMemberID = new ACET_AuthorizationStatusResponse.IcueMemberID();
        objIcueMemberID.id = '0101010101';

        //CET_AuthorizationStatusResponse.FacilityDecisonSource objFacilityDecisonSource = new ACET_AuthorizationStatusResponse.FacilityDecisonSource();
        //objFacilityDecisonSource.sourceSeqNumber = '0101010101';
        //objFacilityDecisonSource.decisionSourceType = null;

        ACET_AuthorizationStatusResponse.EffectiveDateRange objEffectiveDateRange = new ACET_AuthorizationStatusResponse.EffectiveDateRange();
        objEffectiveDateRange.stopDate = '2020-01-01';

        ACET_AuthorizationStatusResponse.PhoneNumber objPhoneNumber = new ACET_AuthorizationStatusResponse.PhoneNumber();
        objPhoneNumber.telephoneNumber = '11111111111';
        objPhoneNumber.phoneTypeCode = '11111111111';
        objPhoneNumber.primaryIndicator = '11111111111';
        objPhoneNumber.phoneInterntionalIndicator = '11111111111';

        ACET_AuthorizationStatusResponse.SourceMemberId objSourceMemberId = new ACET_AuthorizationStatusResponse.SourceMemberId();
        objSourceMemberId.id = '0101010101';
        objSourceMemberId.type_Z  = '0101010101';

        ACET_AuthorizationStatusResponse.Facility objFacility = new ACET_AuthorizationStatusResponse.Facility();
        objFacility.notifyLateInd = '0101010101';
        objFacility.notifyRetrospectiveInd = '0101010101';
        objFacility.placeOfServiceCode = null;
        objFacility.serviceDetailCategoryCode = null;
        objFacility.serviceDescUrgencyCode = null;
        objFacility.expectedAdmissionDate = '2020-01-01';
        objFacility.expectedDischargeDate = '2020-01-01';
        objFacility.actualAdmissionDateTime = '2020-01-01';
        objFacility.actualDischargeDateTime = '2020-01-01';
        objFacility.dischargeDispositionType = null;
        objFacility.icmAvaliableInd = '0101010101';
        objFacility.serviceReferenceNumber = '0101010101';
        objFacility.admissionNotifyDateTime = '2020-01-01';
        objFacility.dischargeNotifyDateTime = '2020-01-01';
        objFacility.facilityDecision = null;

        ACET_AuthorizationStatusResponse.Diagnosis objDiagnosis = new ACET_AuthorizationStatusResponse.Diagnosis();
        objDiagnosis.diagnosisSeqNum = '0101010101';
        objDiagnosis.diagnosisCode = null;
        objDiagnosis.primaryInd = '0101010101';
        objDiagnosis.admitInd = '0101010101';
        objDiagnosis.diagnosisOtherText = 'test';

        ACET_AuthorizationStatusResponse.Member objMember = new ACET_AuthorizationStatusResponse.Member();
        objMember.sourceMemberId = null;
        objMember.enrolleIdentifiers = null;
        objMember.firstName = 'test';
        objMember.lastName = 'test';
        objMember.middleName = 'test';
        objMember.birthDate = '2020-01-01';
        objMember.gender = null;
        objMember.relationshipCode = '0101010101';
        objMember.address = null;
        objMember.spokenLanguageText = 'test';
        objMember.writtenLanguageText = 'test';
        objMember.icueMemberID = null;

        ACET_AuthorizationStatusResponse.Address_Z objAddress_Z = new ACET_AuthorizationStatusResponse.Address_Z();
        objAddress_Z.addressLine1 = 'test';
        objAddress_Z.city = 'test';
        objAddress_Z.state = null;
        objAddress_Z.postalCode1 = '0101010101';
        objAddress_Z.postalCode2 = '0101010101';

        ACET_AuthorizationStatusResponse.Notes objNotes = new ACET_AuthorizationStatusResponse.Notes();
        objNotes.categoryCode = null;
        objNotes.text = 'test';
        objNotes.createdByUserId = '0101010101';
        objNotes.createdByUserFirstName = 'test';
        objNotes.createdByUserLastName = 'test';
        objNotes.createDateTime = '2020-01-01';

        Test.stopTest();
    }
	

   static testMethod void generateICUEURL() {
        Test.startTest();        
        System.runAs(SAETestDataFactory.loadUser(SAEConstants.SAE_USER_ADMIN_USERNAME)) {
        
            
            String strURL = ACET_AuthorizationController.GenerateICUEURL('625871210', 'PATRICK', 'ALFORD', 'PAT', 'Member' , '001');
            System.assertNotEquals(null, strURL);
        }
        Test.stopTest();
    }    
    
    static testMethod void editICUEURL() {
        Test.startTest();        
        System.runAs(SAETestDataFactory.loadUser(SAEConstants.SAE_USER_ADMIN_USERNAME)) {
          
            String strURL = ACET_AuthorizationController.editICUEURL('A002044006', 'Member');
            System.assertNotEquals(null, strURL);
        }
        Test.stopTest();
    }

    @isTest static void getAuthorizationsExceptionTest()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETAuthorizationGetAuthWebServiceMock());
        ACET_GetAuthorizationStatusDetails.AuthDetailsRequest requestObj = new ACET_GetAuthorizationStatusDetails.AuthDetailsRequest();
        ACET_AuthorizationController.SearchResultWrapperAuthStatus response = ACET_AuthorizationController.getAuthorizationStatus(requestObj);
        Test.stopTest();
    }

    @isTest static void findAuthorizationsExceptionTest()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETAuthorizationFindAuthWebServiceMock());
        ACET_FindAuthorizationWebservice.FindAuthRequest requestObj = new ACET_FindAuthorizationWebservice.FindAuthRequest();
        ACET_AuthorizationController.SearchResultWrapper response = ACET_AuthorizationController.findAuthorizations(requestObj);
        Test.stopTest();
    }
}