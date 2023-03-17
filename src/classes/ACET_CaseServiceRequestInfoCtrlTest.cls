@isTest(seealldata=false)
private class ACET_CaseServiceRequestInfoCtrlTest {
    
    @istest
    static void getORSIssueRecordsTest(){
        
        Case caseRec =  new Case(status='Closed');
        Case caseRecWithFacetId =  new Case(status='Closed',Facets_Issue_ID__c='82783,2323,232,32,23287', MACESSPIQ__c = 'test,test--test,test--test');
        // Thanish - 17th Jun 2020 - Code Coverage
        Case openCaseRec =  new Case(status='Open');
        Insert caseRec; Insert openCaseRec; Insert caseRecWithFacetId;
        
        List<ISL_Webservice_Config__c> wsConfigs = new List<ISL_Webservice_Config__c>();
        wsConfigs.add(new ISL_Webservice_Config__c(Name='SNIAPIAccessToken', Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='dev_ORSSelectIssue', Value__c='https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-si/issues/v1/search'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken', Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHeaderAccept', Value__c='application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHttpHeaderActor', Value__c='ACET'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHttpHeaderContentType', Value__c='application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name='EAIPLoginFlowHttpMethod', Value__c='EAIPLoginFlowHttpMethod'));
        Insert wsConfigs;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSIssueMock());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(caseRec.Id);
        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSIssueMock400());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(caseRec.Id);
        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSIssueMock500());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(caseRec.Id);
        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSIssueMock999());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(caseRec.Id);
        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSIssueMock404());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(caseRec.Id);

        // Thanish - 17th Jun 2020 - Code Coverage
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSOneIssueMock());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(caseRec.Id);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSOneIssueMock());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(openCaseRec.Id);
        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETORSOneIssueMock());
        ACET_CaseServiceRequestInfoCtrl.getORSIssueRecords(caseRecWithFacetId.Id);
        Test.stopTest();
    }

}