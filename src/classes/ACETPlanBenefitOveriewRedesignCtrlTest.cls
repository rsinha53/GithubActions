@isTest(SeeAllData=false)
private class ACETPlanBenefitOveriewRedesignCtrlTest{

    @testSetup static void setup() {
          Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
         mapISLWSConfigs.put('dev_GetBenefitAccEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
           RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
    }
     static testMethod void planBenefitOveriewTestMethod() {
      

        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
          
        Test.startTest();
        
        String ResponseJSON = '{"ACETGetSubscriptionRedesignRequest":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        String resp1 = '{ "getBenefitAccumulatorResponse" : { "benefitAccumulator":{ "benefitPlan" : []	}}}}';
       
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccumRedesignResponse');
        mock.setStatusCode(200);
       Test.setMock(HttpCalloutMock.class, mock);
      list<string> existsOnRiderPlantest = new list<string>();
         existsOnRiderPlantest.add('M000000006-5');
        ACETPlanBenefitOveriewRedesignController.getAccumRedesign('12345','2018/01/01','12345888','M000000006','','','','2018/02/02','','','','','M000000006','','M000000006-5,M000000006-2,M000000006-4,M000000006-6,M000000006-1,M000000006-3','Calendar year','01-INN,02-INN,03-INN,04-INN,5-INN,06-INN,07-INN,8-00N,09-OON',existsOnRiderPlantest);
         try {
             ACETPlanBenefitOveriewRedesignController.getBenefitLanguage('12345','2018/01/01','1234567689','','','','2018/01/01','2018/01/01','','','2018/01/01','','',true);
         } catch (Exception ex) {
         }
       
        ACETLanguageCTIndicator__c languageIndicator = new ACETLanguageCTIndicator__c();
        languageIndicator.Name = 'Ambulatory Surgery Center Revenue Code';
        languageIndicator.Benefit_Code__c = 'AMBULATORY_SURGERY_CENTER_REV';
        insert languageIndicator;
        Specialty_Crosswalk__c specialtyIndicator = new Specialty_Crosswalk__c();
        specialtyIndicator.Benefit_Code__c = 'AMBULATORY_SURGERY_CENTER_REV';
        insert specialtyIndicator;
        ACETPlanBenefitOveriewRedesignController  OvrReCtrl = new ACETPlanBenefitOveriewRedesignController();
        OvrReCtrl.dateRange = '01/31/2017 - 01/31/2018';
        OvrReCtrl.MemberId ='72015543500';
        OvrReCtrl.IsPlanBenefit=true;
        OvrReCtrl.BenefitBundleOptionId ='M00000007';
         OvrReCtrl.accumAsOf='02/04/2017';
        OvrReCtrl.failureMessage ='ERROR';
        OvrReCtrl.isVal =true;
        OvrReCtrl.dateRange ='04/04/2018';
        OvrReCtrl.hippaBenefitCodeJSON ='Hippa';
        OvrReCtrl.ccc ='Test';
        OvrReCtrl.bundleOptionId ='M00007';                
        OvrReCtrl.CoverageType ='INN';
        OvrReCtrl.EffectiveDate ='10/11/2018';
        OvrReCtrl.EndDate = '10/12/2018';
        Date effectiveDate = Date.parse(OvrReCtrl.EffectiveDate);
        Date endDate = Date.parse(OvrReCtrl.EndDate);
        OvrReCtrl.populateDate();
        OvrReCtrl.SRKID ='SRKTEST';
        OvrReCtrl.benefitDateSearch ='14/12/2017';
        OvrReCtrl.currentDate ='04/13/2017';    
        OvrReCtrl.currentDateBenefits ='phy';
        OvrReCtrl.benefitKeys ='TST';
        List<String> bKeyslst = new List<String>();
        bKeyslst.add('TST');
       // OvrReCtrl.benefitKeysList= bKeyslst;
        OvrReCtrl.groupId='412239026';
        OvrReCtrl.renewalDate='04/13/2019';
        OvrReCtrl.groupEffectiveDate='04/10/2018';
        OvrReCtrl.orgSitusState = 'CT';
        OvrReCtrl.primarySpeciality = 'General';
        ACETGroupPlanBenefitWrapper groupPlanWrap = new ACETGroupPlanBenefitWrapper();
        groupPlanWrap.benefitRedesignWrapperList = new Map<String,Map<String,List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>>();
        ACETGroupPlanBenefitWrapper.BenefitSubSection BenefitSection1 = new ACETGroupPlanBenefitWrapper.BenefitSubSection();
        BenefitSection1.benefitLevel ='TEst';
        BenefitSection1.benefitLevelDescription ='Desc';
        BenefitSection1.benefitCodeGeneralLanguage ='ENG';
        BenefitSection1.benefitCodeLanguage ='EN'; 
        BenefitSection1.benefitVersion ='v2'; 
        BenefitSection1.ageFrom ='25'; 
        BenefitSection1.ageFromDuration ='11/11/2007';   
        BenefitSection1.ageThrough ='04/04/2018';    
        BenefitSection1.ageThroughDuration ='04/04/2018';   
        BenefitSection1.networkId  ='typw';  
        BenefitSection1.relationshipCode  ='REL';  
        BenefitSection1.coverageIndicator  ='CI';
        List<ACETGroupPlanBenefitWrapper.BenefitSubSection> benefitSectionList = new List<ACETGroupPlanBenefitWrapper.BenefitSubSection>();
        benefitSectionList.add(BenefitSection1);
        Map<String,List<ACETGroupPlanBenefitWrapper.BenefitSubSection>> benefitSectionMap = new Map<String,List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>();
        benefitSectionMap.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',benefitSectionList);
        groupPlanWrap.benefitRedesignWrapperList.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',benefitSectionMap);
        Map<String,String> benefitCodeMap = OvrReCtrl.benefitCodeMap;
        List<String> allbenefitCodes = OvrReCtrl.allbenefitCodes;
         ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
         AdditionalInfo.DOB = '12/27/2009';
         AdditionalInfo.SitusState = '12/27/2009';
         AdditionalInfo.EffectiveDate = '12/27/2009';
         AdditionalInfo.EndDate = '12/27/2009';
         AdditionalInfo.groupName  = 'Test';
         AdditionalInfo.Network    = 'Test';
         AdditionalInfo.OriginatorRelationship  = 'Test';
         AdditionalInfo.PolicyNumber  = 'UHC1234';
         AdditionalInfo.Product  = 'Product Test';
         AdditionalInfo.productType  = 'Care Service';
         AdditionalInfo.Relationship  = 'Primary';
         OvrReCtrl.AdditionalInfo = AdditionalInfo;
        Test.stopTest();
    }
    static testMethod void planBenefitOveriewTestMethod1() {
           Test.startTest();
           Specialty_Crosswalk__c specialtyIndicator = new Specialty_Crosswalk__c();
           specialtyIndicator.Classification__c = 'General Practice';
           insert specialtyIndicator;
           ACETPlanBenefitOveriewRedesignController  OvrReCtrl = new ACETPlanBenefitOveriewRedesignController();
           OvrReCtrl.EffectiveDate ='10/11/2018';
           OvrReCtrl.EndDate = '12/12/2019';
           Date effectiveDate = Date.parse(OvrReCtrl.EffectiveDate);
           Date endDate = Date.parse(OvrReCtrl.EndDate);
           OvrReCtrl.populateDate();
		   Test.stopTest();
    }
    
      static testMethod void planBenefitOveriewTestMethod2() {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
          
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccumulatorErrorResponse');
        mock.setStatusCode(400);
       Test.setMock(HttpCalloutMock.class, mock);
      list<string> existsOnRiderPlantest = new list<string>();
         existsOnRiderPlantest.add('M000000006-5');
        ACETPlanBenefitOveriewRedesignController.getAccumRedesign('12345','2018/01/01','12345888','M000000006','','','','2018/02/02','','','','','M000000006','','M000000006-5,M000000006-2,M000000006-4,M000000006-6,M000000006-1,M000000006-3','Calendar year','01-INN,02-INN,03-INN,04-INN,05-INN,06-INN,07-INN,08-00N,09-OON',existsOnRiderPlantest);
       // ACETPlanBenefitOveriewRedesignController.getBenefitLanguage('12345','2018/01/01','1234567689','','','','2018/01/01','2018/01/01','','','2018/01/01','','',true);
       
      
        Test.stopTest();
    }
    
        static testMethod void planBenefitOveriewTestMethod3() {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
          
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccumRedesignResponse');
        mock.setStatusCode(404);
       Test.setMock(HttpCalloutMock.class, mock);
      list<string> existsOnRiderPlantest = new list<string>();
         existsOnRiderPlantest.add('M000000006-5');
        ACETPlanBenefitOveriewRedesignController.getAccumRedesign('12345','2018/01/01','12345888','M000000006','','','','2018/02/02','','','','','M000000006','','M000000006-5,M000000006-2,M000000006-4,M000000006-6,M000000006-1,M000000006-3','Calendar year','01-INN,02-INN,03-INN,04-INN,05-INN,06-INN,07-INN,08-00N,09-OON',existsOnRiderPlantest);
       // ACETPlanBenefitOveriewRedesignController.getBenefitLanguage('12345','2018/01/01','1234567689','','','','2018/01/01','2018/01/01','','','2018/01/01','','',true);
       
      
        Test.stopTest();
    }
    @isTest static void test_additionalCoverage() {
        Test.startTest(); 
        ACETPlanBenefitOveriewRedesignController pbo = new ACETPlanBenefitOveriewRedesignController();
        String situsState = pbo.getSitusState();
        String specialtyCrosswalkString = pbo.getspecialtyCrosswalkString();
		pbo.SubSRKID = 'Test';      
        pbo.specialtyCrosswalkString = 'test';
        pbo.SitusState = 'test';
        pbo.selectedBenefit = 'test';
        Test.stopTest();
    }
}