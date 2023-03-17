@istest
private class ACETCobControllerTest{
    private static void setTestData(String flow){
    
        List<ISL_Webservice_Config__c> ISLWebserviceCSList = new List<ISL_Webservice_Config__c>();
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderAccept', 'application/json;charset=UTF-8'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderActor', 'ACET'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderScope', 'read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthContentType', 'application/x-www-form-urlencoded'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthGrantType', 'client_credentials'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientId', 'ISLStageConClientId'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMemberEndpoint', '/GetIndividualService'));
        //ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMembershipEndpoint', '/api/alpha/eisl/individuals/membership/v3.0/read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_SearchMembershipEndpoint', '/FindMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetFamilyMembersEndpoint', '/api/alpha/eisl/individuals/familymembership/v2.0/read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetEmployerGroupEndpoint', '/api/alpha/eisl/organizations/employergroups/v3.0/read'));
        
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetIndividualEndpoint', '/api/alpha/eisl/individuals/v2.0/read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_FindMembershipEndpoint', '/api/alpha/eisl/individuals/membership/v2.0/search'));
        
        
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILTimeout', '3000'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('SRKCounter', '1'));   
        insert ISLWebserviceCSList;
        
        List<ACETOtherInsuranceType__c> oInsTypeLst = new List<ACETOtherInsuranceType__c>();
        ACETOtherInsuranceType__c aInsType = new ACETOtherInsuranceType__c();
        aInsType.Name = 'Commercial';
        aInsType.OtherInsuranceType__c = 'Commercial';
        oInsTypeLst.add(aInsType);
        
        ACETOtherInsuranceType__c aInsType1 = new ACETOtherInsuranceType__c();
        aInsType1.Name = 'Motor Vehicle Accident';
        aInsType1.OtherInsuranceType__c = 'Motor Vehicle Accident';
        oInsTypeLst.add(aInsType1);
        
        ACETOtherInsuranceType__c aInsType2 = new ACETOtherInsuranceType__c();
        aInsType2.Name = 'Workers Compensation';
        aInsType2.OtherInsuranceType__c = 'Workers Compensation';
        oInsTypeLst.add(aInsType2);
        
        insert oInsTypeLst;
        
        List<ACETCoveragesTypes__c> covTypeLst = new List<ACETCoveragesTypes__c>();
        ACETCoveragesTypes__c aCovType = new ACETCoveragesTypes__c();
        aCovType.Name = 'Dental Care';
        aCovType.CoverageType__c = 'Dental Care';
        covTypeLst.add(aCovType);
        
        ACETCoveragesTypes__c aCovType1 = new ACETCoveragesTypes__c();
        aCovType1.Name = 'Free Standing Prescription Drug';
        aCovType1.CoverageType__c = 'Free Standing Prescription Drug';
        covTypeLst.add(aCovType1);
        
        ACETCoveragesTypes__c aCovType2 = new ACETCoveragesTypes__c();
        aCovType2.Name = 'Hospital - Inpatient';
        aCovType2.CoverageType__c = 'Hospital - Inpatient';
        covTypeLst.add(aCovType2);
        
        insert covTypeLst;
        
        List<ACETGovCoveragesTypes__c> govCovTypeLst = new List<ACETGovCoveragesTypes__c>();
        ACETGovCoveragesTypes__c aGovCovType = new ACETGovCoveragesTypes__c();
        aGovCovType.Name = 'BLACKLUNG';
        aGovCovType.CoveragesTypes__c = 'BLACKLUNG';
        govCovTypeLst.add(aGovCovType);
        
        ACETGovCoveragesTypes__c aGovCovType1 = new ACETGovCoveragesTypes__c();
        aGovCovType1.Name = 'Medicaid';
        aGovCovType1.CoveragesTypes__c = 'Medicaid';
        govCovTypeLst.add(aGovCovType1);
        
        ACETGovCoveragesTypes__c aGovCovType2 = new ACETGovCoveragesTypes__c();
        aGovCovType2.Name = 'MedicareA';
        aGovCovType2.CoveragesTypes__c = 'MedicareA';
        govCovTypeLst.add(aGovCovType2);
        
        insert govCovTypeLst;
        
        List<ACETEntitlementReason__c> EntitleLst = new List<ACETEntitlementReason__c>();
        ACETEntitlementReason__c entitleReason = new ACETEntitlementReason__c();
        entitleReason.Name = 'Age';
        entitleReason.Reason__c = 'Age';
        EntitleLst.add(entitleReason);
        
        ACETEntitlementReason__c entitleReason1 = new ACETEntitlementReason__c();
        entitleReason1.Name = 'Disabled';
        entitleReason1.Reason__c = 'Disabled';
        EntitleLst.add(entitleReason1);
        
        ACETEntitlementReason__c entitleReason2 = new ACETEntitlementReason__c();
        entitleReason2.Name = 'Disabled at Work';
        entitleReason2.Reason__c = 'Disabled at Work';
        EntitleLst.add(entitleReason2);
        
        insert EntitleLst;
        
        List<ACETRelationshipCodes__c> relationshipLst = new List<ACETRelationshipCodes__c>();
        ACETRelationshipCodes__c rel = new ACETRelationshipCodes__c();
        rel.Name = '19';
        rel.Description__c = 'Child';
        relationshipLst.add(rel);
        
        ACETRelationshipCodes__c rel1 = new ACETRelationshipCodes__c();
        rel1.Name = '01';
        rel1.Description__c = 'Spouse';
        relationshipLst.add(rel1);
        
        ACETRelationshipCodes__c rel2 = new ACETRelationshipCodes__c();
        rel2.Name = '18';
        rel2.Description__c = 'Self';
        relationshipLst.add(rel2);
        
        insert relationshipLst;
        
        
        
    }
    static testMethod void testACETCobController(){
        PageReference pageRef = Page.ACETCordinationOfBenefits;
        Test.setCurrentPage(pageRef);       
        ACETCobControllerTest.setTestData('');
        ACETCobController Controller  = new ACETCobController();
        controller.medicare = new List<ACETCobController.wrapperMedicare>();
        ACETCobController.wrapperMedicare wm = new ACETCobController.wrapperMedicare();
        wm.Name = 'aaaa';
        wm.Relationship = 'Individual';
        wm.MedicareType = 'aa';
        wm.Dob = '01/01/1990';
        wm.Age = '26';
        wm.MedicarePrimary = 'No';
        wm.CrossoverIndicator = 'Y';
        wm.EntitleReason = 'NA';
        wm.EstimationApplies = 'Y';
        wm.EffectiveStartA = '';
        wm.EffectiveEndA = '';
        wm.EffectiveStartB = '';
        wm.EffectiveEndB = '';
        wm.EffectiveStartD = '';
        wm.EffectiveEndD = '';
        wm.LastUpdate = '';
        wm.Source = '';
        wm.Comments = '';
        controller.medicare.add(wm);
        ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
     //   Controller.response = JSON.serialize(md);
     
        Controller.isClaim=True;
        Controller.isCancelCaseCreation=True;
        Controller.isCommercialActive=True;
        Controller.selectCommericial='Test';
        Controller.custodialSelect='Test';    
       // Contact con = TestDataFactory.createContact();
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
        ApexPages.currentPage().getParameters().put('SRK','surrogateKey');
        ApexPages.currentPage().getParameters().put('Id','73452645');
        ApexPages.currentPage().getParameters().put('firstName','Connie');
        ApexPages.currentPage().getParameters().put('lastName','Reed');
        ApexPages.currentPage().getParameters().put('sourceOriginator','FAX');    
    //    ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
        ApexPages.currentPage().getParameters().put('additionalInfo', json.serialize(md));
        Controller.getOtherInsuranceTypes();
        Controller.getCoverageTypes();
        Controller.getGovCoverageTypes();
        Controller.getEntitlementreason();
        Continuation conti = (Continuation)Controller.CallWSonPageLoad11();
        system.debug('conti1--->'+conti);
        Map<String, HttpRequest> requests = conti.getRequests();
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug('2323request'+ request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
                system.debug('2323inside GetFamilyMemberService');
                response.setBody('{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"478761592","name":{"firstName":"Ricky","lastName" '+ 
                ':"Ackerman","middleName":"","nameSuffix":""},"birthDate":"2018-06-11","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"024820238",'+
                '"privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"","city":"AVON","postalCode":"06001",'+
                '"stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1198476",'+
                '"groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE",'+
                '"bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660403","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01",'+
                '"covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484",'+
                '"benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004",'+
                '"benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},'+
                '"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660403","subscriberIdCardSerialNumber":"64155660400",'+
                '"eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family",'+
                '"covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},'+
                '{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31",'+
                '"benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN","coverageLevelCode":"FAM",'+
                '"product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660403",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660403","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"478761592",'+
                '"type":"enrolleeEID"},{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081582","type":"enrolleeSystemID"},{"id":"642288661",'+
                '"type":"subscriberSurrogateKey"},{"id":"642288666","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"478761535",'+
                '"name":{"firstName":"Anna","lastName":"Ackerman","middleName":"","nameSuffix":""},"birthDate":"2015-02-11","genderCode":"F","genderDescription":"Female",'+
                '"socialSecurityNumber":"024820966","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"",'+
                '"city":"AVON","postalCode":"06001","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR",'+
                '"coverages":[{"groupNumber":"1198476","groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR",'+
                '"memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C",'+
                '"benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660402","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01",'+
                '"covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484",'+
                '"benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004",'+
                '"benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},'+
                '"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660402","subscriberIdCardSerialNumber":"64155660400",'+
                '"eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family",'+
                '"covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},'+
                '{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31",'+
                '"benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN","coverageLevelCode":"FAM",'+
                '"product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660402",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660402","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"478761535","type":'+
                '"enrolleeEID"},{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081581","type":"enrolleeSystemID"},{"id":"642288661","type":"subscriberSurrogateKey"},'+
                '{"id":"642288672","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"478761549","name":{"firstName":"Alfonso","lastName":"Ackerman",'+
                '"middleName":"","nameSuffix":""},"birthDate":"1979-02-11","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"024820948",'+
                '"privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"","city":"AVON","postalCode":"06001",'+
                '"stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1198476",'+
                '"groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE",'+
                '"bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"01","relationshipDescription":"Spouse",'+
                '"memberIdCardSerialNumber":"64155660401","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01",'+
                '"covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484",'+
                '"benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004",'+
                '"benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},'+
                '"relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"64155660401","subscriberIdCardSerialNumber":"64155660400",'+
                '"eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family",'+
                '"covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},'+
                '{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31",'+
                '"benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN","coverageLevelCode":"FAM",'+
                '"product":{"productIdentifier":"PM00000012"},"relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"64155660401",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"01","relationshipDescription":"Spouse",'+
                '"memberIdCardSerialNumber":"64155660401","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"478761549","type":"enrolleeEID"},'+
                '{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081580","type":"enrolleeSystemID"},{"id":"642288661","type":"subscriberSurrogateKey"},'+
                '{"id":"642288682","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"478761534","name":{"firstName":"Gianna","lastName":"Ackerman",'+
                '"middleName":"","nameSuffix":""},"birthDate":"1982-01-11","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"028947923",'+
                '"privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"","city":"AVON","postalCode":"06001",'+
                '"stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1198476",'+
                '"groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE",'+
                '"bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"64155660400",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004","benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750",'+
                '"benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self",'+
                '"memberIdCardSerialNumber":"64155660400","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self",'+
                '"memberIdCardSerialNumber":"64155660400","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self",'+
                '"memberIdCardSerialNumber":"64155660400","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{"providerIdentifiers":[{"id":"P5172574","type":"PUL"},'+
                '{"id":"3267460","type":"MPI"},{"id":"1336329465","type":"NPI"},{"id":"P4873589","type":"PUL"},{"id":"126646189022899559","type":"LTK"}],'+
                '"assignmentType":"PCP","effectiveDate":"2019-01-01","expirationDate":"2019-10-31","firstName":"SOWMYA","lastName":"KURTAKOTI","networkId":"7",'+
                '"organizationLocationId":"19541915","locationAffiliationId":"28282368","address1":"256 S MAIN ST","address2":"","address3":"","address4":"",'+
                '"address5":"","city":"MANCHESTER","state":"CT","postalCode":"06040","country":"US"}],"identifiers":[{"id":"478761534","type":"enrolleeEID"},'+
                '{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081579","type":"enrolleeSystemID"},{"id":"642288661","type":"subscriberSurrogateKey"},'+
                '{"id":"642288661","type":"enrolleeSurrogateKey"}]}]}]}}');
                system.debug('1response'+response);
            }      
            
             
            system.debug('2323response'+response.getBody());
            system.debug('RequestLabel >>> '+RequestLabel);
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(Controller, conti);
     
     
        //Controller.childconsolefunction();
        Controller.renderCancelCaseSection();
        Controller.rerenderPB();
        Controller.Save();
        Controller.SaveAndClose();
        ACETCobController aa=new ACETCobController();
        aa.updateCommercial();
        ACETCobController.wrapperCommercial awc=new ACETCobController.wrapperCommercial();
        awc.comName='Data';
        awc.comRelationship='test';
        awc.comDob='test';
        awc.comAge='22';
        awc.comLastDate='2/2/22';
        awc.comRelationship='Spouse';
        awc.comMemberOtherInsurance='';
        awc.comInsuranceType='';
        awc.comPrimary='Yes';
        awc.comComemricalEffectiveEnd='';
        awc.comCustodialParent='Former Spouse';
        awc.comSource='Test';
        awc.comComments='Test';
        awc.comComemricalEffectivestart='Test';
        
        
        ACETMemberDetail amd = new ACETMemberDetail();
        amd.lstCOB = new List<ACETMemberDetail.COB>();
        ACETMemberDetail.COB c = new ACETMemberDetail.COB();
        c.CoverageTypeCode = '1';
        c.MemberId = '123';
        amd.lstCOB.add(c);
        ACETMemberDetail.COB c1 = new ACETMemberDetail.COB();
        c1.CoverageTypeCode = '2';
        c1.MemberId = '1234';
        amd.lstCOB.add(c1);
        amd.FamilyMembers = new List<ACETMemberDetail.FamilyMember>();
        ACETMemberDetail.FamilyMember af = new ACETMemberDetail.FamilyMember();
        af.EID = '123';
         amd.FamilyMembers.add(af);
        ACETMemberDetail.FamilyMember af1 = new ACETMemberDetail.FamilyMember();
        af1.EID = '1234';
         amd.FamilyMembers.add(af1);
        aa.childconsolefunction(amd);
        
    }
    
  /**  static testMethod void testACETCobControllerException(){
        PageReference pageRef = Page.ACETCordinationOfBenefits;
        Test.setCurrentPage(pageRef);       
       // ACETCobControllerTest.setTestData('');
       
       List<ISL_Webservice_Config__c> ISLWebserviceCSList = new List<ISL_Webservice_Config__c>();
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('StargateConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderAccept', 'application/json;charset=UTF-8'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderActor', 'ACET'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderScope', 'read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthContentType', 'application/x-www-form-urlencoded'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthGrantType', 'client_credentials'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_StargateOAuthClientId', 'ISLStageConClientId'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_StargateOAuthClientSecret', 'ISLStageConClientSecret'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_StargateOAuthEndpoint', 'https://gateway-stage.optum.com'));
        
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_StargateOAuthTokenEndpoint', '/auth/oauth/v2/token'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('StargateTimeout', '3000'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('SRKCounter', '1'));   
        insert ISLWebserviceCSList;
        ACETCobController Controller  = new ACETCobController();
        controller.medicare = new List<ACETCobController.wrapperMedicare>();
        ACETCobController.wrapperMedicare wm = new ACETCobController.wrapperMedicare();
        wm.Name = 'aaaa';
        wm.Relationship = 'Individual';
        wm.MedicareType = 'aa';
        wm.Dob = '01/01/1990';
        wm.Age = '26';
        wm.MedicarePrimary = 'No';
        wm.CrossoverIndicator = 'Y';
        wm.EntitleReason = 'NA';
        wm.EstimationApplies = 'Y';
        wm.EffectiveStartA = '';
        wm.EffectiveEndA = '';
        wm.EffectiveStartB = '';
        wm.EffectiveEndB = '';
        wm.EffectiveStartD = '';
        wm.EffectiveEndD = '';
        wm.LastUpdate = '';
        wm.Source = '';
        wm.Comments = '';
        controller.medicare.add(wm);
        ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
     //   Controller.response = JSON.serialize(md);
     
        Controller.isClaim=True;
        Controller.isCancelCaseCreation=True;
        Controller.isCommercialActive=True;
        Controller.selectCommericial='Test';
        Controller.custodialSelect='Test';    
        Contact con = TestDataFactory.createContact();
        Interaction__c inte = TestDataFactory.createInteraction();
        ApexPages.currentPage().getParameters().put('interactionId',inte.id);
        ApexPages.currentPage().getParameters().put('contactId',con.id);
        ApexPages.currentPage().getParameters().put('SRK','surrogateKey');
        ApexPages.currentPage().getParameters().put('Id','73452645');
        ApexPages.currentPage().getParameters().put('firstName','Connie');
        ApexPages.currentPage().getParameters().put('lastName','Reed');
        ApexPages.currentPage().getParameters().put('sourceOriginator','FAX');    
    //    ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'Prakash';
        md.LastName = 'Swain';
        md.DOB = '1/1/1991';
        md.CoverageLines = null;
        //ApexPages.currentPage().getParameters().put('additionalInfo', json.serialize(md));
        Controller.getOtherInsuranceTypes();
        Controller.getCoverageTypes();
        Controller.getGovCoverageTypes();
        Controller.getEntitlementreason();
       // Continuation conti = (Continuation)Controller.CallWSonPageLoad11();
       Continuation conti = new Continuation(10);
        conti.continuationMethod ='GetMembershipCallback11';
     //  Map<String, HttpRequest> requests = conti.getRequests();
    Map<String, HttpRequest> requests = new  Map<String, HttpRequest>();
          HttpRequest req = new HttpRequest();
     req.setEndpoint('https://api-stg.optum.com:8443');
     req.setMethod('POST');
    //   HttpRequest re = System.HttpRequest[Endpoint=https://api-stg.optum.com:8443, Method=POST];
        requests.put('Continuation-2',req);
        system.debug('requests--->'+requests);
        HttpResponse response;
        HttpRequest request;
        if(requests.keyset() != null){
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug('2323request'+ request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v5.0/read')) {
                system.debug('2323inside GetFamilyMemberService');
                response.setBody('{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"478761592","name":{"firstName":"Ricky","lastName" '+ 
                ':"Ackerman","middleName":"","nameSuffix":""},"birthDate":"2018-06-11","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"024820238",'+
                '"privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"","city":"AVON","postalCode":"06001",'+
                '"stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1198476",'+
                '"groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE",'+
                '"bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660403","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01",'+
                '"covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484",'+
                '"benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004",'+
                '"benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},'+
                '"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660403","subscriberIdCardSerialNumber":"64155660400",'+
                '"eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family",'+
                '"covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},'+
                '{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31",'+
                '"benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN","coverageLevelCode":"FAM",'+
                '"product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660403",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660403","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"478761592",'+
                '"type":"enrolleeEID"},{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081582","type":"enrolleeSystemID"},{"id":"642288661",'+
                '"type":"subscriberSurrogateKey"},{"id":"642288666","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"478761535",'+
                '"name":{"firstName":"Anna","lastName":"Ackerman","middleName":"","nameSuffix":""},"birthDate":"2015-02-11","genderCode":"F","genderDescription":"Female",'+
                '"socialSecurityNumber":"024820966","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"",'+
                '"city":"AVON","postalCode":"06001","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR",'+
                '"coverages":[{"groupNumber":"1198476","groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR",'+
                '"memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C",'+
                '"benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660402","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01",'+
                '"covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484",'+
                '"benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004",'+
                '"benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},'+
                '"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660402","subscriberIdCardSerialNumber":"64155660400",'+
                '"eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family",'+
                '"covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},'+
                '{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31",'+
                '"benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN","coverageLevelCode":"FAM",'+
                '"product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"64155660402",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"19","relationshipDescription":"Child",'+
                '"memberIdCardSerialNumber":"64155660402","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"478761535","type":'+
                '"enrolleeEID"},{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081581","type":"enrolleeSystemID"},{"id":"642288661","type":"subscriberSurrogateKey"},'+
                '{"id":"642288672","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"478761549","name":{"firstName":"Alfonso","lastName":"Ackerman",'+
                '"middleName":"","nameSuffix":""},"birthDate":"1979-02-11","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"024820948",'+
                '"privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"","city":"AVON","postalCode":"06001",'+
                '"stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1198476",'+
                '"groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE",'+
                '"bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"01","relationshipDescription":"Spouse",'+
                '"memberIdCardSerialNumber":"64155660401","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01",'+
                '"covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484",'+
                '"benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004",'+
                '"benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750","benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},'+
                '"relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"64155660401","subscriberIdCardSerialNumber":"64155660400",'+
                '"eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family",'+
                '"covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},'+
                '{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31",'+
                '"benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN","coverageLevelCode":"FAM",'+
                '"product":{"productIdentifier":"PM00000012"},"relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"64155660401",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"01","relationshipDescription":"Spouse",'+
                '"memberIdCardSerialNumber":"64155660401","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"478761549","type":"enrolleeEID"},'+
                '{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081580","type":"enrolleeSystemID"},{"id":"642288661","type":"subscriberSurrogateKey"},'+
                '{"id":"642288682","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"478761534","name":{"firstName":"Gianna","lastName":"Ackerman",'+
                '"middleName":"","nameSuffix":""},"birthDate":"1982-01-11","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"028947923",'+
                '"privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"100 PASEO DE COLON STE 1","addressLine2":"","city":"AVON","postalCode":"06001",'+
                '"stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1198476",'+
                '"groupName":"ALEXANDRA COHEN","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE",'+
                '"bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"M000000783","benefitPlanName":"CTSM FREEDOM DIRECT$40/50 ER/IP D&C","benefitType":"MD",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"64155660400",'+
                '"subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"RX00000004","benefitPlanName":"SG $250D T3/T4 5/50/30% to 500/50% to750",'+
                '"benefitType":"RX","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self",'+
                '"memberIdCardSerialNumber":"64155660400","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08","planType":"03",'+
                '"coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],"holdList":[{}],'+
                '"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1","benefitEffectiveDate":"2019-01-01",'+
                '"benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDD000021","benefitPlanName":"PEDIATRIC DENTAL CTSM FREEDOM DIRECT 07","benefitType":"DN",'+
                '"coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self",'+
                '"memberIdCardSerialNumber":"64155660400","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1528484","benefitBundleOptionDescription":"OPTION 1",'+
                '"benefitEffectiveDate":"2019-01-01","benefitExpirationDate":"2019-10-31","benefitPlanId":"PEDV000021","benefitPlanName":"PEDIATRIC VISION CTSM FREEDOM DIRECT 07",'+
                '"benefitType":"VS","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000012"},"relationshipCode":"18","relationshipDescription":"Self",'+
                '"memberIdCardSerialNumber":"64155660400","subscriberIdCardSerialNumber":"64155660400","eligibilityStatusCode":"A","cancelReasonTypeCode":"08",'+
                '"planType":"","coverageLevelList":[{"covLevelCode":"FAM","covLevelDesc":"Family","covLevelEffDate":"2019-01-01","covLevelExpDate":"2019-10-31"}],'+
                '"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{"providerIdentifiers":[{"id":"P5172574","type":"PUL"},'+
                '{"id":"3267460","type":"MPI"},{"id":"1336329465","type":"NPI"},{"id":"P4873589","type":"PUL"},{"id":"126646189022899559","type":"LTK"}],'+
                '"assignmentType":"PCP","effectiveDate":"2019-01-01","expirationDate":"2019-10-31","firstName":"SOWMYA","lastName":"KURTAKOTI","networkId":"7",'+
                '"organizationLocationId":"19541915","locationAffiliationId":"28282368","address1":"256 S MAIN ST","address2":"","address3":"","address4":"",'+
                '"address5":"","city":"MANCHESTER","state":"CT","postalCode":"06040","country":"US"}],"identifiers":[{"id":"478761534","type":"enrolleeEID"},'+
                '{"id":"100000081579","type":"subscriberSystemId"},{"id":"100000081579","type":"enrolleeSystemID"},{"id":"642288661","type":"subscriberSurrogateKey"},'+
                '{"id":"642288661","type":"enrolleeSurrogateKey"}]}]}]}}');
                system.debug('1response'+response);
            }      
            
             system.debug('conti-->'+conti);
            system.debug('2323response'+response.getBody());
            system.debug('RequestLabel >>> '+RequestLabel);
            Test.setContinuationResponse(RequestLabel, response); 
        }}
        Object result = Test.invokeContinuationMethod(Controller, conti);
     
     
        //Controller.childconsolefunction();
        Controller.renderCancelCaseSection();
        Controller.rerenderPB();
        Controller.Save();
        Controller.SaveAndClose();
      
        
    } **/
}