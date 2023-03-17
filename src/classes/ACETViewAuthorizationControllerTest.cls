@isTest(SeeAllData=false)
private class ACETViewAuthorizationControllerTest{
    
    //Default Search
    static testMethod void ACETViewAuthorizationControllerTest1() 
    {   
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist Customer Support Team - Agent; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        createCustomSetting();
        
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';      
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', '');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional);        
        
        test.setCurrentPage(ACETVAPage);
                
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        
        ACETVACtrl.strAuthorizationNumber = '';
        ACETVACtrl.AuthorizationType = '----None----';
        ACETVACtrl.strStatus = '----None----';
      
        Interaction__c StartDateTest = new Interaction__c();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 1, 1);
        Interaction__c EndDateTest = new Interaction__c();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2015, 2, 2);
        ACETVACtrl.SourceOriginator = 'test';
        ACETVACtrl.StartDate = StartDateTest;
        ACETVACtrl.EndDate = EndDateTest;

        ACETVACtrl.routeCase();
        ACETVACtrl.Save();
        ACETVACtrl.SaveAndClose();
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();        
        
    
        Test.stopTest();   
    }  
    
    static testMethod void ACETViewAuthorizationControllerTest2() 
    {        
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails);    
        createCustomSetting();
        
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';      
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', 'A0123456789');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional);        
        
        test.setCurrentPage(ACETVAPage);
                
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
             
        ACETVACtrl.strAuthorizationNumber = 'A0123456789';
        ACETVACtrl.AuthorizationType = 'Inpatient';        
        ACETVACtrl.strStatus = 'closed';        


       
        Interaction__c StartDateTest = new Interaction__c();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 2, 14);
        ACETVACtrl.StartDate = StartDateTest;
        
        ACETVACtrl.CallFindAuthorizationWS();  
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();  
               
        Test.stopTest();   
    }  
    
    static testMethod void ACETViewAuthorizationControllerTest3() 
    {   
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        createCustomSetting();
        
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';    
        
        Test.startTest();         
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', 'A0123456789');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional); 
        test.setCurrentPage(ACETVAPage);              
        
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        ACETVACtrl.strAuthorizationNumber = 'A0123456789';
        ACETVACtrl.AuthorizationType = 'Outpatient';
        ACETVACtrl.strStatus = 'closed';
    
        Interaction__c StartDateTest = new Interaction__c();
        StartDateTest.tst_Date_Field__c = null;

        Interaction__c EndDateTest = new Interaction__c();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2015, 4, 14);
        ACETVACtrl.StartDate = StartDateTest;
        ACETVACtrl.EndDate = EndDateTest;
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();        
        Test.stopTest();   
    }
    
    static testMethod void ACETViewAuthorizationControllerTest4() 
    {   
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        createCustomSetting();
        
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';        
        Test.startTest();     

        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', 'A0123456789');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional);        
        
        test.setCurrentPage(ACETVAPage);
                    
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        
        ACETVACtrl.AuthorizationType = 'Outpatient Facility';
        ACETVACtrl.strStatus = 'closed';
        Case StartDateTest = new Case();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 2, 14);
        Case EndDateTest = new Case();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2016, 11, 14);
       
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();        
        Test.stopTest();   
    }
    
    /*static testMethod void ACETViewAuthorizationControllerTest5() 
    { 
        Test.startTest();        
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        
        ACETVACtrl.strAuthorizationNumber = 'A0123456789';
        ACETVACtrl.AuthorizationType = '----None----';
        ACETVACtrl.strStatus = '----None----';
        Case StartDateTest = new Case();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 8, 14);
        system.debug('*****StartDate****'+StartDateTest.tst_Date_Field__c);
        Case EndDateTest = new Case();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2016, 8, 14);
        system.debug('*****EndDate****'+EndDateTest.tst_Date_Field__c);
      
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();
        
        Test.stopTest();   
    } 
    
    static testMethod void ACETViewAuthorizationControllerTest6() 
    { 
        Test.startTest();        
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.renderCancelCaseSection();
        ACETVACtrl.renderMisdirectCaseSection();        
        ACETVACtrl.CallFindAuthorizationWS();
        
       

        ACETVACtrl.AuthorizationType = 'Inpatient';
        ACETVACtrl.strStatus = '----None----';
        
        Case StartDateTest = new Case();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 8, 14);
      
        
        Case EndDateTest = new Case();
        EndDateTest.tst_Date_Field__c = null;
    
        ACETVACtrl.routeCase();
        ACETVACtrl.Save();
        ACETVACtrl.SaveAndClose();

        
        ACETViewAuthorizationController.returnDateFormat('2/2/2016');        
        
        Test.stopTest();   
    }*/
    
static testMethod void ACETViewAuthorizationControllerTest7() 
    { 
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        createCustomSetting();    
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');    
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';         
        
        Test.startTest();      
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', 'A0123456789');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional);        
        
        test.setCurrentPage(ACETVAPage);        
      
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        
        ACETVACtrl.strAuthorizationNumber = '';
        ACETVACtrl.AuthorizationType = '----None----';
        ACETVACtrl.strStatus = '----None----';
        Case StartDateTest = new Case();
        StartDateTest.tst_Date_Field__c = null;
        Case EndDateTest = new Case();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2015, 8, 14);
      //  ACETVACtrl.StartDate = StartDateTest;
      //  ACETVACtrl.EndDate = EndDateTest;
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();
        
        Test.stopTest();   
    }

    static testMethod void ACETViewAuthorizationControllerTest8() 
    {         
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails);   
        createCustomSetting();
        
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';      
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', '');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional);        
        
        test.setCurrentPage(ACETVAPage);
                
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
             
        ACETVACtrl.strAuthorizationNumber = '';
        ACETVACtrl.AuthorizationType = 'Inpatient';        
        ACETVACtrl.strStatus = 'closed';        


        Case StartDateTest = new Case();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 2, 14);
        Case EndDateTest = new Case();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2016, 11, 14);
    
        ACETVACtrl.CallFindAuthorizationWS();  
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();  
               
        Test.stopTest();   
    }      
 static testMethod void ACETViewAuthorizationControllerTest9() 
 
    {
        list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
        callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
        insert callTopicAccess;
        
          Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
              
        createCustomSetting();
        
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';      
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', '');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional);        
        
        test.setCurrentPage(ACETVAPage);
                
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETAuthorizationSearchResult asr = new ACETAuthorizationSearchResult();
        asr.Case_status = 'closed';
        asr.Authorization_Number = ''; 
             
        ACETVACtrl.strAuthorizationNumber = 'A0123456789';
        ACETVACtrl.AuthorizationType = 'Outpatient Facility';        

        Case StartDateTest = new Case();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 2, 2);
        Case EndDateTest = new Case();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2016, 11, 2);
        ACETVACtrl.CallFindAuthorizationWS();  
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();  
        ACETVACtrl.strStatus = 'closed';  
               
        Test.stopTest();   
    }  
    static testMethod void ACETViewAuthorizationControllerTest10() 
    {          
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails);  
        createCustomSetting();
        
        Interaction__c ViewAuthTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        Contact ViewAuthSubject = [select Name,EID__c,firstname,lastname from Contact limit 1];
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/26/2009';
        AdditionalInfo.EndDate = '12/27/2009';      
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETVAPage = Page.ACETViewAuthorization;
        ACETVAPage.getParameters().put('interactionId', ViewAuthTestInteraction.Id);
        ACETVAPage.getParameters().put('contactId', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('sourceOriginator', 'GRegory Grimm');
        ACETVAPage.getParameters().put('relationship', ViewAuthSubject.Id);
        ACETVAPage.getParameters().put('DOB', AdditionalInfo.DOB);
        ACETVAPage.getParameters().put('SitusState', AdditionalInfo.SitusState);
        ACETVAPage.getParameters().put('EffectiveDate', AdditionalInfo.EffectiveDate);
        ACETVAPage.getParameters().put('AuthNumber', '');
        String additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"2/2/2012","EndDate":"2/2/2015","EffectiveDate":"2/2/2012","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';        
        ACETVAPage.getParameters().put('additionalInfo', additional);        
        
        test.setCurrentPage(ACETVAPage);
                
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
             
        ACETVACtrl.strAuthorizationNumber = '';
        ACETVACtrl.AuthorizationType = 'Outpatient Facility';        
        ACETVACtrl.strStatus = 'closed';        


        Case StartDateTest = new Case();
        StartDateTest.tst_Date_Field__c = Date.newInstance(2015, 2, 14);
        Case EndDateTest = new Case();
        EndDateTest.tst_Date_Field__c = Date.newInstance(2016, 11, 14);
        ACETVACtrl.CallFindAuthorizationWS();  
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();  
               
        Test.stopTest();   
    }         
    static void createCustomSetting(){
    
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
        mapISLWSConfigs.put('dev_SearchMedicalProvidersEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/search');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/alpha/eisl/clinical/medicalhealthservicecaseauthorizations/v2.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
         
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;  
        ACETAuthorizationSearchResult  ACETASR= new ACETAuthorizationSearchResult();
        ACETASR.Case_Reason_Code='test';
        ACETASR.Case_Reason_Desc='Test';
        ACETASR.Admit_Date='06-09-2017';
        ACETASR.Dscharg_Date='06-10-2017';
        ACETASR.selected=true;
  } 
    
    //Success records with authorization records
    static testMethod void ACETViewAuthorizationControllerTest11() {
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/alpha/eisl/clinical/medicalhealthservicecaseauthorizations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN1', 'Test Contact FN1', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON());
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
               
        PageReference ACETVA = Page.ACETViewAuthorization;
        ACETVA.getParameters().put('interactionId', oInteraction.Id);
        ACETVA.getParameters().put('contactId', oContact.Id);
        ACETVA.getParameters().put('sourceOriginator', 'Phone Call');
        ACETVA.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETVA.getParameters().put('memberId', '36781823800');
        ACETVA.getParameters().put('SRK', '');
        ACETVA.getParameters().put('DOB', '11/7/1966');
        ACETVA.getParameters().put('SitusState', '');
        ACETVA.getParameters().put('vccdParams', '');
        ACETVA.getParameters().put('AuthNumber', 'A000599546');
        Test.setCurrentPageReference(ACETVA);
        
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        ACETVACtrl.StartDate.tst_Date_Field__c = Date.newinstance(2017, 1, 1);
        ACETVACtrl.EndDate.tst_Date_Field__c = Date.newinstance(2017, 12, 1);
        ACETVACtrl.AuthorizationType = 'Outpatient Facility';
        ACETVACtrl.strStatus = 'Open';
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();
        ACETVACtrl.AuthorizationType = 'Inpatient';
        ACETVACtrl.strStatus = 'Open';
        ACETVACtrl.strAuthorizationNumber = 'A000599539';
        ACETVACtrl.StartDate.tst_Date_Field__c = Date.newinstance(2017, 1, 1);
        ACETVACtrl.EndDate.tst_Date_Field__c = null;
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();
        ACETVACtrl.AuthorizationType = 'Outpatient';
        ACETVACtrl.strStatus = 'Anticipated Admission';
        ACETVACtrl.strAuthorizationNumber = 'A000600130';
        ACETVACtrl.StartDate.tst_Date_Field__c = null;
        ACETVACtrl.EndDate.tst_Date_Field__c = Date.newinstance(2017, 12, 1);
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.clearFilter();
        ACETVACtrl.AuthorizationType = '----None----';
        ACETVACtrl.strStatus = 'Open';
        ACETVACtrl.ApplyFilter();
        ACETVACtrl.renderCancelCaseSection();
        ACETVACtrl.renderMisdirectCaseSection();
        ACETVACtrl.routeCase();
        
        Test.stopTest();
    }
    
    //Success response, no authorization records
    static testMethod void ACETViewAuthorizationControllerTest12() {
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/alpha/eisl/clinical/medicalhealthservicecaseauthorizations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN1', 'Test Contact FN1', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        String ResponseJSON = '{"findMedicalHealthServiceCaseAuthorizationsResult":{"findAuthorizationsResponseBaseType":{"responseHeader":{"applicationName":"ACET","serviceCallStatus":"SUCCESS","serviceName":"hscSummaryService","serviceVersion":{"number":"v3"},"logID":{"id":"132001"}},"findAuthorizationsByMemberResponse":{"authorization":[]},"pagination":{"pageSize":"4","totalCount":"0","moreRecords":"false","startRecord":"1"}}}}'; 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
               
        PageReference ACETVA = Page.ACETViewAuthorization;
        ACETVA.getParameters().put('interactionId', oInteraction.Id);
        ACETVA.getParameters().put('contactId', oContact.Id);
        ACETVA.getParameters().put('sourceOriginator', 'Phone Call');
        ACETVA.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETVA.getParameters().put('memberId', '36781823800');
        ACETVA.getParameters().put('SRK', '');
        ACETVA.getParameters().put('DOB', '11/7/1966');
        ACETVA.getParameters().put('SitusState', '');
        ACETVA.getParameters().put('vccdParams', '');
        Test.setCurrentPageReference(ACETVA);
        
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        ACETVACtrl.Save();
        ACETVACtrl.SaveAndClose();
        Test.stopTest();
    }
    
    //Error response
    static testMethod void ACETViewAuthorizationControllerTest13() {
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        
        TestISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/alpha/eisl/clinical/medicalhealthservicecaseauthorizations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN1', 'Test Contact FN1', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        String ResponseJSON = '{"findMedicalHealthServiceCaseAuthorizationsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
               
        PageReference ACETVA = Page.ACETViewAuthorization;
        ACETVA.getParameters().put('interactionId', oInteraction.Id);
        ACETVA.getParameters().put('contactId', oContact.Id);
        ACETVA.getParameters().put('sourceOriginator', 'Phone Call');
        ACETVA.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETVA.getParameters().put('memberId', '36781823800');
        ACETVA.getParameters().put('SRK', '');
        ACETVA.getParameters().put('DOB', '11/7/1966');
        ACETVA.getParameters().put('SitusState', '');
        ACETVA.getParameters().put('vccdParams', '');
        Test.setCurrentPageReference(ACETVA);
        
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        
        Test.stopTest();
    }
    
    //Invalid JSON
    static testMethod void ACETViewAuthorizationControllerTest14() {
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
      insert callTopicAccess;
      
      Interaction__c inte = TestDataFactory.createInteraction();
            account accountObj = new account();
            accountObj.Name = 'Test account';
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'Test';
            contactObj.LastName = 'Contact';
            insert contactObj;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUECreateAuthorization';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/alpha/eisl/clinical/medicalhealthservicecaseauthorizations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN1', 'Test Contact FN1', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        //insert oInteraction;
        
        String ResponseJSON = '{"findMedicalHealthServiceCaseAuthorizationsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."';
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
               
        PageReference ACETVA = Page.ACETViewAuthorization;
        ACETVA.getParameters().put('interactionId', oInteraction.Id);
        ACETVA.getParameters().put('contactId', oContact.Id);
        ACETVA.getParameters().put('sourceOriginator', 'Phone Call');
        ACETVA.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETVA.getParameters().put('memberId', '36781823800');
        ACETVA.getParameters().put('SRK', '');
        ACETVA.getParameters().put('DOB', '11/7/1966');
        ACETVA.getParameters().put('SitusState', '');
        ACETVA.getParameters().put('vccdParams', '');
        Test.setCurrentPageReference(ACETVA);
        
        ACETViewAuthorizationController ACETVACtrl = new ACETViewAuthorizationController();
        ACETVACtrl.CallFindAuthorizationWS();
        
        Test.stopTest();
    }   
}