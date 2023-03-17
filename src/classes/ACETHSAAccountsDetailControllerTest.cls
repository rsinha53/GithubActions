@isTest
private class ACETHSAAccountsDetailControllerTest {
   static testMethod void hsaSummaryContrMethod(){
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('d1_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('d1_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('d1_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('d1_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '8000');
        mapISLWSConfigs.put('d1_HSATransaction','/api/alpha/eisl/member/healthsavings/accounts/v1.0/read');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        System.debug('lstISLWSConfigs::'+lstISLWSConfigs);
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaTransactionResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
         System.debug('OILResponse::'+OILResponse);    
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        System.debug('MockHttpRes::'+MockHttpRes); 
        PageReference ACETHSA= Page.ACETHSAAccountsDetail;
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
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Member';
        insert Interaction ;
        Test.startTest();
        ACETHSA.getParameters().put('InteractionId', Interaction.Id);
        ACETHSA.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETHSA.getParameters().put('contactId', cont.Id);
        ACETHSA.getParameters().put('memberId', '123456789');    
        ACETHSA.getParameters().put('callTopic', 'HSA Account');
        ACETHSA.getParameters().put('SRK', '123456789'); 
        ACETHSA.getParameters().put('unmaskedSSN', '123456789'); 
        ACETHSA.getParameters().put('HSAKey', 'NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA=='); 
        Test.setCurrentPage(ACETHSA);
       
        ACETHSAAccountsDetailController hsaAcc= new ACETHSAAccountsDetailController();
        hsaAcc.Subject = cont;
        hsaAcc.memberId = '12345678901';
        hsaAcc.statusSelected = 'All';
        hsaAcc.getstatusList();
        hsaAcc.getviewList();
        hsaAcc.callTransaction();
        hsaAcc.CallWSOnPageLoad();
        hsaAcc.CallWSTransactionOnPageLoad();
        
        ACETHSATransactionWebservice transWS = new ACETHSATransactionWebservice();
        transWS.init('NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','Recent');
        
        HttpResponse response = new HttpResponse();
        response.setBody(ResponseJSON);
        response.setStatusCode(200);
        transWS.queryPaginatedData(1,50,1);
        
        transWS.init('testkey','Scheduled');
        response.setBody(ResponseJSON);
        response.setStatusCode(200);
        transWS.queryPaginatedData(1,50,1);
        
        ACETHSATransactionResult transRes = new ACETHSATransactionResult();
        transRes.transactionDate = '01/01/2018';
        transRes.status = 'Processed';
        transRes.description= 'test';
        transRes.amount= '123';
        
        Test.stopTest();
   } 
   
   static testMethod void hsaSummaryContrMethod2(){
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('d1_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('d1_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('d1_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('d1_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '8000');
        mapISLWSConfigs.put('d1_HsaTransaction','/api/alpha/eisl/member/healthsavings/accounts/v1.0/read');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaTransactionResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        
        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETHSA= Page.ACETHSAAccountsDetail;
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
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Member';
        insert Interaction ;
        Test.startTest();
        ACETHSA.getParameters().put('InteractionId', Interaction.Id);
        ACETHSA.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETHSA.getParameters().put('contactId', cont.Id);
        ACETHSA.getParameters().put('memberId', '123456789');    
        ACETHSA.getParameters().put('callTopic', 'HSA Account');
        ACETHSA.getParameters().put('SRK', '123456789'); 
        ACETHSA.getParameters().put('unmaskedSSN', '123456789'); 
        ACETHSA.getParameters().put('HSAKey', 'NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA=='); 
        Test.setCurrentPage(ACETHSA);
       
        ACETHSAAccountsDetailController hsaAcc= new ACETHSAAccountsDetailController();
        hsaAcc.Subject = cont;
        hsaAcc.statusSelected = 'Recent';
        hsaAcc.getstatusList();
        hsaAcc.getviewList();
        hsaAcc.callTransaction();
        hsaAcc.CallWSOnPageLoad();
        hsaAcc.CallWSTransactionOnPageLoad();
        
        ACETHSATransactionWebservice transWS = new ACETHSATransactionWebservice();
        transWS.init('NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','Recent');
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(ResponseJSON);
        transWS.queryPaginatedData(1,50,1);
        
        ACETHSATransactionJSON2Apex.Transactions j2aTr = new ACETHSATransactionJSON2Apex.Transactions();
        j2aTr.id= '1234';
        j2aTr.accountDescription= 'USA';
        j2aTr.status= '1234';
        j2aTr.transactionDate= '2018-01-01';
        j2aTr.amount= '1234';
        j2aTr.transactionCode= 'A';
        
        list<ACETHSATransactionJSON2Apex.Transactions> j2aTrList = new list<ACETHSATransactionJSON2Apex.Transactions>();
        j2aTrList.add(j2aTr);
        
        ACETHSATransactionJSON2Apex.Pagination j2aPa = new ACETHSATransactionJSON2Apex.Pagination();
        j2aPa.pageNumber= '1';
        j2aPa.pageSize= '50';
        j2aPa.totalCount= '114';
        
        ACETHSATransactionJSON2Apex j2a = new ACETHSATransactionJSON2Apex();
        j2a.transactions= j2aTrList;
        j2a.pagination = j2aPa ;
        
        Test.stopTest();
   }
   
   static testMethod void hsaSummaryContrMethodBadResponse(){
       //Setup records in custom setting
       Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
       mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
       mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
       mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
       mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
       mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
       mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
       mapISLWSConfigs.put('d1_CISLOAuthClientId', 'ISLStageConClientId');
       mapISLWSConfigs.put('d1_CISLOAuthClientSecret', 'ISLStageConClientSecret');
       mapISLWSConfigs.put('d1_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
       mapISLWSConfigs.put('d1_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
       mapISLWSConfigs.put('OILTimeout', '8000');
       mapISLWSConfigs.put('d1_HsaTransaction','/api/alpha/eisl/member/healthsavings/accounts/v1.0/read');
       
       List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       insert lstISLWSConfigs;
       
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaTransactionResponseJSON'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
       
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ResponseJSON );
       OILResponse.TokenExpired = false;
       
       
       
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);
       
       PageReference ACETHSA= Page.ACETHSAAccountsDetail;
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
       Interaction__c Interaction = new Interaction__c();
       Interaction.Contact_Name__c = 'Test contname';
       Interaction.Originator__c = cont.id;
       Interaction.Originator_Type__c = 'Member';
       insert Interaction ;
       Test.startTest();
       ACETHSA.getParameters().put('InteractionId', Interaction.Id);
       ACETHSA.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
       ACETHSA.getParameters().put('contactId', cont.Id);
       ACETHSA.getParameters().put('memberId', '123456789');    
       ACETHSA.getParameters().put('callTopic', 'HSA Account');
       ACETHSA.getParameters().put('SRK', '123456789'); 
       ACETHSA.getParameters().put('unmaskedSSN', '123456789'); 
       ACETHSA.getParameters().put('HSAKey', 'NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA=='); 
       Test.setCurrentPage(ACETHSA);
      
       ACETHSAAccountsDetailController hsaAcc= new ACETHSAAccountsDetailController();
       hsaAcc.Subject = cont;
       hsaAcc.statusSelected = 'Recent';
       hsaAcc.getstatusList();
       hsaAcc.getviewList();
       hsaAcc.callTransaction();
       hsaAcc.CallWSOnPageLoad();
       hsaAcc.CallWSTransactionOnPageLoad();
       
       ACETHSATransactionWebservice transWS = new ACETHSATransactionWebservice();
       transWS.init('NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','Recent');
       HttpResponse response = new HttpResponse();
       response.setStatusCode(401);
       response.setBody(ResponseJSON);
       transWS.queryPaginatedData(1,50,1);
       
       ACETHSATransactionJSON2Apex.Transactions j2aTr = new ACETHSATransactionJSON2Apex.Transactions();
       j2aTr.id= '1234';
       j2aTr.accountDescription= 'USA';
       j2aTr.status= '1234';
       j2aTr.transactionDate= '2018-01-01';
       j2aTr.amount= '1234';
       j2aTr.transactionCode= 'A';
       
       list<ACETHSATransactionJSON2Apex.Transactions> j2aTrList = new list<ACETHSATransactionJSON2Apex.Transactions>();
       j2aTrList.add(j2aTr);
       
       ACETHSATransactionJSON2Apex.Pagination j2aPa = new ACETHSATransactionJSON2Apex.Pagination();
       j2aPa.pageNumber= '1';
       j2aPa.pageSize= '50';
       j2aPa.totalCount= '114';
       
       ACETHSATransactionJSON2Apex j2a = new ACETHSATransactionJSON2Apex();
       j2a.transactions= j2aTrList;
       j2a.pagination = j2aPa ;
       
       Test.stopTest();
  }
    
    //added by suresh
    static testMethod void hsaSummaryWebService(){
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaTransactionResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug('Response JSON: '+ ResponseJSON);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        System.debug('OILResponse::'+OILResponse);    
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        System.debug('MockHttpRes::'+MockHttpRes); 
        ACETHSATransactionWebService hsa = new ACETHSATransactionWebService();
        hsa.init('NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','Recent');
        hsa.queryPaginatedData(1,1,1);
    }
}