@isTest
public class ACETGroupPolicyContractControllerTest {
    public static testMethod void GroupPolicyContractControllerTest1() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read'); 
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;

        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',01);
        mapOnshoreVerbgs.put('Claim Transactions',02);
        mapOnshoreVerbgs.put('Other Claim Transactions Services',03);
        mapOnshoreVerbgs.put('Member Touchpoints',04);
        mapOnshoreVerbgs.put('Customer Touchpoints',05);
        mapOnshoreVerbgs.put('Member and Provider Touchpoints',06);
        mapOnshoreVerbgs.put('All Services Onshore except IT',07);
        mapOnshoreVerbgs.put('All Services Onshore',08);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        PageReference ACETGroupPolicyContract = Page.ACETGroupPolicyContract;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        Test.setCurrentPage(ACETGroupPolicyContract);
        apexpages.currentpage().getparameters().put('groupId', '12345678'); //167106
        apexpages.currentpage().getparameters().put('contractId', '32423');
        apexpages.currentpage().getparameters().put('interactionId',InteractionId.Id);
        apexpages.currentpage().getparameters().put('callTopic', 'Policy Contract(s)');
        
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        
        Test.startTest();
        ACETGroupPolicyContractController policyContractContr = new ACETGroupPolicyContractController();
        policyContractContr.IsShowActiveCoveragesOnly = true;
        policyContractContr.subject = cont;
        policyContractContr.notResearchUser= false;
        policyContractContr.showPolicyContract();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        //acetCallTopicDW.saveCase();
        Test.stopTest();
    }
    //uncomment above after controller integration
    
    


    public static testMethod void ACETCallTopicsDataWrapper1() {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName", "additionalInfo":"Testing"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefit;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Group';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETGroupPlan.getParameters().put('InteractionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('groupId', '1234567');
        ACETGroupPlan.getParameters().put('onshoreCode', '06');
        Test.setCurrentPage(ACETGroupPlan);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        
        Test.startTest();
        ACETGroupPlanBenefitController groupPlanContr = new ACETGroupPlanBenefitController();
        groupPlanContr.IsShowActiveCoveragesOnly = true;
        groupPlanContr.groupDetails = groupDetail;
        groupPlanContr.toggleShowPlanBenefits();
        groupPlanContr.Subject = cont;
        boolean b = true;
        groupPlanContr.notResearchUser = b;
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
        Test.stopTest();
    }
        public static testMethod void ACETCallTopicsDataWrapper2() {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName", "additionalInfo":"Testing"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefit;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Group';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETGroupPlan.getParameters().put('InteractionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('groupId', '1234567');
        ACETGroupPlan.getParameters().put('onshoreCode', '04');
        Test.setCurrentPage(ACETGroupPlan);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        
        ACETGroupDetail.PolicyContract pol = new ACETGroupDetail.PolicyContract();

        
       
        
        
        Test.startTest();
        ACETGroupPlanBenefitController groupPlanContr = new ACETGroupPlanBenefitController();
        groupPlanContr.IsShowActiveCoveragesOnly = true;
        groupPlanContr.groupDetails = groupDetail;
        groupPlanContr.toggleShowPlanBenefits();
        groupPlanContr.Subject = cont;
        boolean b = true;
        groupPlanContr.notResearchUser = b;
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
        Test.stopTest();
    }
    
    public static testMethod void ACETGroupPlanWebServiceMethod() {
        ACETGroupPlanBenefitController groupPlanContr = new ACETGroupPlanBenefitController();   
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        Test.startTest();
            groupPlanContr.init();
            groupPlanContr.IsShowActiveCoveragesOnly = true;
            groupPlanContr.groupDetails = groupDetail;
            groupPlanContr.toggleShowPlanBenefits();
            groupPlanContr.Subject = cont;
            acetCallTopicDW.saveCase();
        Test.stopTest();
        system.AssertNotEquals(acetCallTopicDW.caseObj.id, null);
    }
}