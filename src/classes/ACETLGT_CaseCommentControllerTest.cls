@isTest
public class ACETLGT_CaseCommentControllerTest {
    
    @testsetup
    static void prepareData(){
        Case cas = TestDataFactory.createCases(1)[0];
        cas.ORS_Macess__c = 'testIssueId123';
        //cas.Type__c = 'Claims';  
        insert cas;
        
        SNI_Advocate_Detail__c sniAdv=new SNI_Advocate_Detail__c();
        sniAdv.Logon_ID__c='TST';
        sniAdv.Logon_Office__c='123';
        sniAdv.First_Name__c='TEST';
        sniAdv.Last_Name__c='USER';
        sniAdv.Status__c='active';
        insert sniAdv;
        
        List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>();
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v4/search';
        webConfigList.add(webConfig);
        
        ISL_Webservice_Config__c webORSConfig = new ISL_Webservice_Config__c();
        webORSConfig.Name = 'dev_ORSReadAPI';
        webORSConfig.ACET_Common_Name__c = 'ORSReadAPI';
        webORSConfig.Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read';
        webConfigList.add(webORSConfig);
        
        ISL_Webservice_Config__c newCustomSetting = new ISL_Webservice_Config__c();
        newCustomSetting.Name = 'SNIAPIAccessToken';
        newCustomSetting.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
        newCustomSetting.ACET_Common_Name__c = 'SNIApiEndpoint';
        webConfigList.add(newCustomSetting);
        
        
        ISL_Webservice_Config__c webORSUpdateConfig = new ISL_Webservice_Config__c();
        webORSUpdateConfig.Name = 'dev_ORSUpdateIssueMicroService';
        webORSUpdateConfig.ACET_Common_Name__c = 'ORSUpdateIssueMicroService';
        webORSUpdateConfig.Value__c = 'https://gateway-stage.optum.com/api/stage/ccs/ci/issues/v1';
        webConfigList.add(webORSUpdateConfig);
        
        ISL_Webservice_Config__c topsConfig1 = new ISL_Webservice_Config__c();
        topsConfig1.Name = 'dev_ORSEAIPToken';
        topsConfig1.ACET_Common_Name__c = 'ORSEAIPToken';
        topsConfig1.Value__c = 'https://gateway-stage.optum.com/api/alpha/cel/cnsr-sec/tokens/v1';
        webConfigList.add(topsConfig1);

        ISL_Webservice_Config__c topsConfig2 = new ISL_Webservice_Config__c();
        topsConfig2.Name = 'EAIPLoginFlowHttpHeaderContentType';
        topsConfig2.ACET_Common_Name__c = 'EAIPLoginFlowHttpHeaderContentType';
        topsConfig2.Value__c = 'application/json';
        webConfigList.add(topsConfig2);
        
        ISL_Webservice_Config__c topsConfig3 = new ISL_Webservice_Config__c();
        topsConfig3.Name = 'EAIPLoginFlowHttpHeaderActor';
        topsConfig3.ACET_Common_Name__c = 'EAIPLoginFlowHttpHeaderActor';
        topsConfig3.Value__c = 'ACET';
        webConfigList.add(topsConfig3);
        
        ISL_Webservice_Config__c topsConfig4 = new ISL_Webservice_Config__c();
        topsConfig4.Name = 'EAIPLoginFlowHeaderAccept';
        topsConfig4.ACET_Common_Name__c = 'EAIPLoginFlowHeaderAccept';
        topsConfig4.Value__c = 'application/json';
        webConfigList.add(topsConfig4);
        
        ISL_Webservice_Config__c topsConfig5 = new ISL_Webservice_Config__c();
        topsConfig5.Name = 'EAIPLoginFlowHttpMethod';
        topsConfig5.ACET_Common_Name__c = 'EAIPLoginFlowHttpMethod';
        topsConfig5.Value__c = 'POST';
        webConfigList.add(topsConfig5);
        
        insert webConfigList;       
        
    }
    @isTest static void ACETORSReadWSMethod1() 
    {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(200,'ORSReadAPI'));
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = ACETLGT_CaseCommentController.getORSDetails('testIssueId123','123456789','0012345','JACK','JONES');
        //System.assertEquals(200, returnWrapper.statusCode);
        Test.stopTest();
    }
    
    @isTest static void ACETORSReadWSMethod1_500() 
    {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(500,'ORSReadAPI'));
       ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = ACETLGT_CaseCommentController.getORSDetails('testIssueId123','123456789','0012345','JACK','LEE');
        ////System.assertEquals(500, returnWrapper.statusCode);
        Test.stopTest();
    }
    
    @isTest static void ACETORSReadWSMethod1_400() 
    {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(400,'ORSReadAPI'));
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = ACETLGT_CaseCommentController.getORSDetails('testIssueId123','123456789','0012345','JACK','LEE');
        ////System.assertEquals(400, returnWrapper.statusCode);
        Test.stopTest();
    }
    
    @isTest static void ACETORSReadWSMethod1_404() 
    {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(404,'ORSReadAPI'));
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = ACETLGT_CaseCommentController.getORSDetails('testIssueId123','123456789','0012345','JACK','LEE');
        ////System.assertEquals(404, returnWrapper.statusCode);
        Test.stopTest();
    }
    
    @isTest static void ACETORSReadWSMethod1_999() 
    {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(999,'ORSReadAPI'));
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = ACETLGT_CaseCommentController.getORSDetails('testIssueId123','123456789','0012345','JACK','LEE');
        ////System.assertEquals(999, returnWrapper.statusCode);
        Test.stopTest();
    }
    @isTest static void saveNewCommentTestMethod() 
    {
        
        Test.startTest();
        
       ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.comment = 'This is a test comment';
        Case cs = [SELECT Id from case where ORS_Macess__c ='testIssueId123'];
       ACETLGT_CaseCommentController.saveNewComment(returnWrapper,cs.Id,true);
        Case_Comment_Clone__c csComment = [select id from Case_Comment_Clone__c where ParentId__c =:cs.Id];
        System.assertNotEquals(null, csComment);
        Test.stopTest();
    }
    @isTest static void checkBoxEnablementTestMethod() 
    {
        
        Test.startTest();
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.statusCode = 200;
        Case cs = [SELECT Id from case where ORS_Macess__c ='testIssueId123'];
        boolean result = ACETLGT_CaseCommentController.checkBoxEnablement(cs.Id,returnWrapper);
        CaseComment casComm = new CaseComment(parentId = cs.id,CommentBody = 'text');
        insert casComm;
        ACETLGT_CaseCommentController.fetchCaseCommentsWrapper(cs.id,'testIssueId123');
        ////System.assertEquals(false, result);
        Test.stopTest();
    }
    @isTest static void sendCommentORSTestMethod_999() 
    {
        
        Test.startTest();
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.comment = 'This is a test comment';
        Case cs = [SELECT Id,ORS_Macess__c from case where ORS_Macess__c ='testIssueId123'];
        ACETORSReadResponseWrapper readWrapper = new ACETORSReadResponseWrapper();
        readWrapper.callerfirstname = 'Test';
        readWrapper.designeeId ='AS6';
        readWrapper.issueId = cs.ORS_Macess__c;
        readWrapper.ownerId = '673JR2';
        readWrapper.contactmethodCode ='W';
        readWrapper.originatorTypeCode = 'I';
        readWrapper.directionCode =  'O' ;
        readWrapper.status = 'C';
        List<ACETORSReadResponseWrapper> readWrapperList = new List<ACETORSReadResponseWrapper>();
        readWrapperList.add(readWrapper);
        returnWrapper.resultWrapper = readWrapperList ;
        //Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(999,'ORSUpdateMicroService'));
        ACETLGT_CaseCommentController.OrsResultWrapper resultWrapper = ACETLGT_CaseCommentController.sendCommentORS(returnWrapper);
        ////System.assertEquals(999, resultWrapper.statusCode);
        Test.stopTest();
    }
    @isTest static void sendCommentORSTestMethod_200() 
    {
        
        Test.startTest();
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.comment = 'This is a test comment';
        Case cs = [SELECT Id,ORS_Macess__c from case where ORS_Macess__c ='testIssueId123'];
        ACETORSReadResponseWrapper readWrapper = new ACETORSReadResponseWrapper();
        readWrapper.callerfirstname = 'Test';
        readWrapper.designeeId ='AS6';
        readWrapper.issueId = cs.ORS_Macess__c;
        readWrapper.ownerId = '673JR2';
        readWrapper.contactmethodCode ='W';
        readWrapper.originatorTypeCode = 'I';
        readWrapper.directionCode =  'O' ;
        readWrapper.status = 'C';
        List<ACETORSReadResponseWrapper> readWrapperList = new List<ACETORSReadResponseWrapper>();
        readWrapperList.add(readWrapper);
        returnWrapper.resultWrapper = readWrapperList ;
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(200,'ORSUpdateMicroService'));
        ACETLGT_CaseCommentController.OrsResultWrapper resultWrapper = ACETLGT_CaseCommentController.sendCommentORS(returnWrapper);
        ////System.assertEquals(200, resultWrapper.statusCode);
        Test.stopTest();
    }
    @isTest static void sendCommentORSTestMethod_400() 
    {
        
        Test.startTest();
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.comment = 'This is a test comment';
        ACETORSReadResponseWrapper readWrapper = new ACETORSReadResponseWrapper();
        readWrapper.callerfirstname = 'Test';
        readWrapper.designeeId ='AS6';
        readWrapper.issueId = '';
        readWrapper.ownerId = '673JR2';
        readWrapper.contactmethodCode ='W';
        readWrapper.originatorTypeCode = 'I';
        readWrapper.directionCode =  'O' ;
        readWrapper.status = 'C';
        List<ACETORSReadResponseWrapper> readWrapperList = new List<ACETORSReadResponseWrapper>();
        readWrapperList.add(readWrapper);
        returnWrapper.resultWrapper = readWrapperList ;
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(400,'ORSUpdateMicroService'));
       ACETLGT_CaseCommentController.OrsResultWrapper resultWrapper = ACETLGT_CaseCommentController.sendCommentORS(returnWrapper);
        ////System.assertEquals(400, resultWrapper.statusCode);
        Test.stopTest();
    }
    @isTest static void sendCommentORSTestMethod_404() 
    {
        
        Test.startTest();
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.comment = 'This is a test comment';
        Case cs = [SELECT Id,ORS_Macess__c from case where ORS_Macess__c ='testIssueId123'];
        ACETORSReadResponseWrapper readWrapper = new ACETORSReadResponseWrapper();
        readWrapper.callerfirstname = 'Test';
        readWrapper.designeeId ='AS6';
        readWrapper.issueId = '';
        readWrapper.ownerId = '673JR2';
        readWrapper.contactmethodCode ='W';
        readWrapper.originatorTypeCode = 'I';
        readWrapper.directionCode =  'O' ;
        readWrapper.status = 'C';
        List<ACETORSReadResponseWrapper> readWrapperList = new List<ACETORSReadResponseWrapper>();
        readWrapperList.add(readWrapper);
        returnWrapper.resultWrapper = readWrapperList ;
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(404,'ORSUpdateMicroService'));
        ACETLGT_CaseCommentController.OrsResultWrapper resultWrapper = ACETLGT_CaseCommentController.sendCommentORS(returnWrapper);
        //System.assertEquals(404, resultWrapper.statusCode);
        Test.stopTest();
    }
    @isTest static void sendCommentORSTestMethod_noStausCode() 
    {
        
        Test.startTest();
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.comment = 'This is a test comment';
        ACETORSReadResponseWrapper readWrapper = new ACETORSReadResponseWrapper();
        readWrapper.callerfirstname = 'Test';
        readWrapper.designeeId ='AS6';
        readWrapper.issueId = '';
        readWrapper.ownerId = '673JR2';
        readWrapper.contactmethodCode ='W';
        readWrapper.originatorTypeCode = 'I';
        readWrapper.directionCode =  'O' ;
        readWrapper.status = 'C';
        List<ACETORSReadResponseWrapper> readWrapperList = new List<ACETORSReadResponseWrapper>();
        readWrapperList.add(readWrapper);
        returnWrapper.resultWrapper = readWrapperList ;
        Test.setMock(HttpCalloutMock.class, new MockHttpORSResponseGenerator(0,'ORSUpdateMicroService'));
        ACETLGT_CaseCommentController.OrsResultWrapper resultWrapper = ACETLGT_CaseCommentController.sendCommentORS(returnWrapper);
        //System.assertEquals(999, resultWrapper.statusCode);
        Test.stopTest();
    }
    @isTest static void fetchCaseTestMethod() 
    {
        
        Test.startTest();
        ACETLGT_CaseCommentController.OrsResultWrapper returnWrapper = new ACETLGT_CaseCommentController.OrsResultWrapper();
        returnWrapper.statusCode = 200;
        Case cs = [SELECT Id from case where ORS_Macess__c ='testIssueId123'];
        
        //ACETLGT_CaseCommentController.fetchCaseCommentsWrapper(cs.Id,'test');
        ACETLGT_CaseCommentController.getErrorMessage('Error');
        Test.stopTest();
    }
}