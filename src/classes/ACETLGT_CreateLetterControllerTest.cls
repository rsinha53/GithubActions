@istest
private class ACETLGT_CreateLetterControllerTest{
  
     static testmethod void test4(){
        
        ACETProcessLetterWebservice apl =   new ACETProcessLetterWebservice();

        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', 'processletterresult:{}');
        OILResponse1.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null,OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1); 
        apl.ProcessLetterWS('','');
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '{}');
        OILResponse5.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes5 = new MockHttpCalloutResponseGenerator(null,OILResponse5);
        Test.setMock(HttpCalloutMock.class, MockHttpRes5); 
        apl.ProcessLetterWS('','');     
        
        ACETCreateLetterWebservice acl = new ACETCreateLetterWebservice();
        ACETLGT_CreateLetterWebservice acl1 = new ACETLGT_CreateLetterWebservice();
     
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        OILResponse6.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes6 = new MockHttpCalloutResponseGenerator(null,OILResponse6);
        Test.setMock(HttpCalloutMock.class, MockHttpRes6);
        
        acl.CreateLetterWS('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>','Balance_Bill_Letter');
        acl1.CreateLetterWS('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>','Balance_Bill_Letter');
        
        ACETFindLetterResult findres = new ACETFindLetterResult();
        findres.Status = 'OK';
        ACETFindLetterJSON2Apex.comment comment = new ACETFindLetterJSON2Apex.comment();
        comment.text = 'test';
        comment.dates = 'test';
        List<ACETFindLetterJSON2Apex.comment> comlist = new List<ACETFindLetterJSON2Apex.comment>();
        comlist.add(comment);
        ACETFindLetterJSON2Apex.Comments Comments = new ACETFindLetterJSON2Apex.Comments();
        Comments.comment = comlist;
        String test1 = 'test';
        List<String> lststring = new List<String>();
        lststring.add(test1);
        ACETFindLetterJSON2Apex.Headers Headers = new ACETFindLetterJSON2Apex.Headers();
        Headers.ContentID = lststring;
        Headers.ContentType = lststring;
        
        ACETFindLetterJSON2Apex.Parameters params = new ACETFindLetterJSON2Apex.Parameters();
        List<ACETFindLetterJSON2Apex.Parameters> lstparams = new List<ACETFindLetterJSON2Apex.Parameters>();
        ACETFindLetterJSON2Apex.ContentType contype = new ACETFindLetterJSON2Apex.ContentType();
        contype.parameters = params;
        contype.subtype = 'test';
        contype.type = 'test';
        contype.wildcardSubtype = true;
        contype.wildcardType = true;
        ACETFindLetterJSON2Apex.LetterWorkItem item = new ACETFindLetterJSON2Apex.LetterWorkItem();
        item.comments = Comments;
        item.createdBy = 'test';
        item.externalId = 'test';
        item.lastModifiedDate = 'test';
        item.letterId = 123;
        item.ownedBy = 'test';
        item.status = 'test';
        List<ACETFindLetterJSON2Apex.LetterWorkItem> lstitem = new List<ACETFindLetterJSON2Apex.LetterWorkItem>();
        lstitem.add(item);
        
        ACETFindLetterJSON2Apex.WorkItems witem = new ACETFindLetterJSON2Apex.WorkItems();
        witem.letterWorkItem = lstitem;
        witem.workItem = lstitem;
        
        ACETFindLetterJSON2Apex.Object_Z obj = new ACETFindLetterJSON2Apex.Object_Z();
        obj.workItems = witem;
        
        ACETFindLetterJSON2Apex.AllAttachments allattach = new ACETFindLetterJSON2Apex.AllAttachments();
        allattach.contentId = 'test';
        allattach.contentType = contype;
        allattach.headers = Headers;
        allattach.object_Z = obj;
        List<ACETFindLetterJSON2Apex.AllAttachments> lstattach = new List<ACETFindLetterJSON2Apex.AllAttachments>();
        lstattach.add(allattach);
        
        ACETFindLetterJSON2Apex.MultipartBody mbody = new ACETFindLetterJSON2Apex.MultipartBody();
        mbody.allAttachments = lstattach;
        mbody.childAttachments = lstparams;
        mbody.rootAttachment = allattach;
        mbody.type = contype;
        
        ACETFindLetterJSON2Apex j2a = new ACETFindLetterJSON2Apex();
        j2a.MultipartBody = mbody;
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
        letterInfo.resultLetterId ='1234';
         ACETCreateLetterJSON2Apex.CreateLetterResult res = new ACETCreateLetterJSON2Apex.CreateLetterResult();
                    res.letterId = 11111;
                    ACETCreateLetterJSON2Apex json = new ACETCreateLetterJSON2Apex();
                    json.createLetterResult = res;
                     oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = letterInfo;
                    
        StaticResource RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLetterAttachmentXML'];
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.PersonBirthdate = system.today();
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
            
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
         Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
         TestCase.Surrogate_Key__c ='123';
        insert TestCase;
         ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        //fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Pending Submission';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        String fulfil = String.ValueOf(fulfillment.id);
        
        ACETLGT_CreateLetterController.submitLetter(fulfil);
    }
    
     static testMethod void ACETCreateLetterWebservice(){
          Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_CreateLetter', '/api/alpha/eisl/fulfillment/createletter/v1.0');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
            letterInfo.resultLetterId ='1234';
         ACETCreateLetterJSON2Apex.CreateLetterResult res = new ACETCreateLetterJSON2Apex.CreateLetterResult();
                    res.letterId = 11111;
                    ACETCreateLetterJSON2Apex json = new ACETCreateLetterJSON2Apex();
                    json.createLetterResult = res;
                     oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = letterInfo;
        
        StaticResource RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLetterAttachmentXML'];
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.PersonBirthdate = system.today();
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
            
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
         Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
         ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"createLetterResult":{"letterId":39710}}');
        OILResponse.TokenExpired = false; 
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
         Create_Letter__c let=new Create_Letter__c();        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'devacet--acetdev--c.cs26';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance1 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance1.Name = 'devacet--acetdev.cs26';
        urlinstance1.Org_Name__c = 'dev';
        insert urlinstance1;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance2 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance2.Name = 'qaacet--acetqa--c.cs26';
        urlinstance2.Org_Name__c = 'qa';
        insert urlinstance2;
        
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
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'oxfdlight';
        urlinstance6.Org_Name__c = 'qa';
        insert urlinstance6;
         
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'fullcopy';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
         
        ACETOrgInstanceURLToOrgNameMap__c urlinstance8 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance8.Name = 'optum';
        urlinstance8.Org_Name__c = 'prd';
        insert urlinstance8;
        
        ACETOrgNameToSwivelEndpointMap__c swivel = new ACETOrgNameToSwivelEndpointMap__c();
        swivel.Name = 'dev_EngageOne';
        swivel.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel;
        
        ACETOrgNameToSwivelEndpointMap__c swivel1 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel1.Name = 'qa_EngageOne';
        swivel1.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel1;
        
        ACETOrgNameToSwivelEndpointMap__c swivel2 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel2.Name = 'd1_EngageOne';
        swivel2.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_EngageOne';
        swivel3.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel3;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_Engageonekey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert dev1key;
        
        ACETWrapEncryptionKey__c devkey = new ACETWrapEncryptionKey__c();
        devkey.Name = 'dev_Engageonekey';
        devkey.Algorithm_Name__c = 'AES256';
        devkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert devkey;
        
        ACETWrapEncryptionKey__c qakey = new ACETWrapEncryptionKey__c();
        qakey.Name = 'qa_Engageonekey';
        qakey.Algorithm_Name__c = 'AES256';
        qakey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert qakey;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_Engageonekey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert prdkey;
        
        ACETLetterVisiblebyCalltopicandProfile__c calltopic = new ACETLetterVisiblebyCalltopicandProfile__c();
        calltopic.Name = 'View Claims';
        calltopic.Employee_Broker_Profiles__c = 'ACET EB Agent';
        calltopic.Member_Profiles__c = 'ACET Member,System Administrator';
        calltopic.Member_Letters_Visible__c = 'MNRP Letter,System Administrator';
        calltopic.Employee_Broker_Letters_Visible__c = 'MNRP Letter';
        insert calltopic;
        
        Test.startTest();//
  
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.templateTest='Test';
        ACLC.deliveryType='Mail';
        ACLC.selectedTemplate = 'Balance_Bill_Letter';
        ACLC.selectedtemplatename = 'Balance_Bill_Letter';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'fax';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.deliverystatus1='Sent';
        ACLC.deliverystatus2='Sent';
        ACLC.CCstatus='Sent';
        ACLC.letterNumber='323232';
        ACLC.submittedBy=System.now();
        ACLC.submittedDt=System.now();
        ACLC.modifiedBy=System.now();
        ACLC.createdBy=System.now();
        ACLC.createdByUserRole='Test';
        ACLC.engageoneworkitemid='Id';
        ACLC.func='Test';
        ACLC.RequestBodyFormat = RequestJSONSR.Body.toString(); 
        ACLC.getTypes();
        ACLC.CreateLetter();
        ACLC.workitemid='workid123';
        test.stopTest();
        
         Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        //fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Pending Submission';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
         Create_Letter__c fulfillment1 = new Create_Letter__c();
        fulfillment1.Letter_Name__c = 'Balance Bill Letter';
        fulfillment1.Case__c = TestCase.Id;
        //fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment1.Review_on_ActiveX__c = true;
        fulfillment1.Letter_Status__c = 'Submitted';
        fulfillment1.Submitted_By__c = userinfo.getName();
        fulfillment1.Letter_Name__c='Balance Bill Letter';
        insert fulfillment1;
         String fulfil = String.ValueOf(fulfillment.id);
        String fulfil1 = String.ValueOf(fulfillment1.id);
        
        //ACETLGT_CreateLetterController ACC = new ACETLGT_CreateLetterController();
        ACETLGT_CreateLetterController.getCaseFromId(TestCase.id);
        ACETLGT_CreateLetterController.createLetter(TestCase.id, 'Balance_Bill_Letter', 'Email', 'fax', 'test', 'test','test', 'test');
        ACETLGT_CreateLetterController.getEngageOneUrl(fulfil);
        ACETLGT_CreateLetterController.getEngageOneUrl(fulfil1);
        ACETLGT_CreateLetterController.submitLetter(fulfil);
        ACETLGT_CreateLetterController.cancelLetter(fulfil);
        ACETLGT_CreateLetterController.getFulfillmentInfo(fulfil);
        }
        
       static testMethod void ACETCreateLetterWebservice1(){
        StaticResource RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLetterAttachmentXML'];
       ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
       ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
        letterInfo.resultLetterId ='1234';
        Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
        contactobj.Birthdate = system.today();
        insert contactobj;
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
         Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
         ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"createLetterResult":{"letterId":39710}}');
        OILResponse.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ACETCreateLetterWebservice acl = new ACETCreateLetterWebservice();
        ACETLGT_CreateLetterWebservice acl1 = new ACETLGT_CreateLetterWebservice();
        
        acl.CreateLetterWS('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>','Balance_Bill_Letter');
        acl1.CreateLetterWS('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>','Balance_Bill_Letter');
        
         ACETCreateLetterJSON2Apex.CreateLetterResult res = new ACETCreateLetterJSON2Apex.CreateLetterResult();
                    res.letterId = 11111;
                    ACETCreateLetterJSON2Apex json = new ACETCreateLetterJSON2Apex();
                    json.createLetterResult = res;
                     oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = letterInfo;
        
        Test.startTest();//
  
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.templateTest='Test';
        ACLC.deliveryType='Mail';
        ACLC.selectedTemplate = 'Balance_Bill_Letter';
        ACLC.selectedtemplatename = 'Balance_Bill_Letter';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'fax';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.deliverystatus1='Sent';
        ACLC.deliverystatus2='Sent';
        ACLC.CCstatus='Sent';
        ACLC.letterNumber='323232';
        ACLC.submittedBy=System.now();
        ACLC.submittedDt=System.now();
        ACLC.modifiedBy=System.now();
        ACLC.createdBy=System.now();
        ACLC.createdByUserRole='Test';
        ACLC.engageoneworkitemid='Id';
        ACLC.func='Test';
        ACLC.RequestBodyFormat = RequestJSONSR.Body.toString(); 
        ACLC.getTypes();
        ACLC.CreateLetter();
        test.stopTest();
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        //fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Submitted';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        
        
        String fulfil = String.ValueOf(fulfillment.id);
        //ACETLGT_CreateLetterController ACC = new ACETLGT_CreateLetterController();
        ACETLGT_CreateLetterController.getCaseFromId(TestCase.id);
        ACETLGT_CreateLetterController.createLetter(TestCase.id, 'Foreign_Travel', 'Email', 'fax', 'test', 'test','test', 'test');
        //ACETLGT_CreateLetterController.getEngageOneUrl(fulfil);
        ACETLGT_CreateLetterController.submitLetter(fulfil);
        ACETLGT_CreateLetterController.cancelLetter(fulfil);
        ACETLGT_CreateLetterController.getFulfillmentInfo(fulfil);
        }
    
      static testMethod void ACETProcessLetterWebservice(){
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.PersonBirthdate = system.today();
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
            letterInfo.resultLetterId ='1234';
        Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
            
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
         
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c='Pending Submission';
        insert fulfillment;
        
        Case c=new Case();
          ACETCreateLetterJSON2Apex.CreateLetterResult res = new ACETCreateLetterJSON2Apex.CreateLetterResult();
                    res.letterId = 11111;
                    ACETCreateLetterJSON2Apex json = new ACETCreateLetterJSON2Apex();
                    json.createLetterResult = res;
                     oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = letterInfo;
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"processLetterResult": {}}');
        OILResponse.TokenExpired = false; 
        Test.startTest();
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.selectedTemplate = 'Balance_Bill_Letter';
        ACLC.selectedtemplatename = 'Balance_Bill_Letter';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'fax';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.RequestBodyFormat = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><data><datum name="CaseID">00011122C</datum></data>';
       
       List<ACETWSCalloutResult> findLetterCalloutResultList = new List<ACETWSCalloutResult>();
        ACETWSCalloutResult findLetterCalloutResult = new ACETWSCalloutResult();
        findLetterCalloutResult.Message = 'ACTIVE_COMPLETE';
        
        ACLC.SubmitLetter();
        
         String fulfil = String.ValueOf(fulfillment.id);
        //ACETLGT_CreateLetterController ACC = new ACETLGT_CreateLetterController();
        ACETLGT_CreateLetterController.getCaseFromId(TestCase.id);
        ACETLGT_CreateLetterController.createLetter(TestCase.id, 'Balance_Bill_Letter', 'Email', 'fax', 'test', 'test','test', 'test');
        //ACETLGT_CreateLetterController.getEngageOneUrl(fulfil);
        ACETLGT_CreateLetterController.submitLetter(fulfil);
        ACETLGT_CreateLetterController.cancelLetter(fulfil);
        ACETLGT_CreateLetterController.getFulfillmentInfo(fulfil);

      
        
        test.stopTest();
    }
    
    static testMethod void test5(){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
            letterInfo.resultLetterId ='1234';
       RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        ACETCreateLetterJSON2Apex.CreateLetterResult res = new ACETCreateLetterJSON2Apex.CreateLetterResult();
                    res.letterId = 11111;
                    ACETCreateLetterJSON2Apex json = new ACETCreateLetterJSON2Apex();
                    json.createLetterResult = res;
                     oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = letterInfo;
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.PersonBirthdate = system.today();
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
            
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
         
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c='Pending Submission';
        insert fulfillment;
        
        Case c=new Case();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '{"description": "testing 400"}');
        OILResponse.TokenExpired = false; 
        
        Test.startTest();
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.selectedTemplate = 'Balance_Bill_Letter';
        ACLC.selectedtemplatename = 'Balance_Bill_Letter';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'fax';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.RequestBodyFormat = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><data><datum name="CaseID">00011122C</datum></data>';
        
         String fulfil = String.ValueOf(fulfillment.id);
        //ACETLGT_CreateLetterController ACC = new ACETLGT_CreateLetterController();
        ACETLGT_CreateLetterController.getCaseFromId(TestCase.id);
        ACETLGT_CreateLetterController.createLetter(TestCase.id, 'Balance_Bill_Letter', 'Email', 'fax', 'test', 'test','test', 'test');
        //ACETLGT_CreateLetterController.getEngageOneUrl(fulfil);
        ACETLGT_CreateLetterController.submitLetter(fulfil);
        ACETLGT_CreateLetterController.cancelLetter(fulfil);
        ACETLGT_CreateLetterController.getFulfillmentInfo(fulfil);
        
        List<ACETWSCalloutResult> findLetterCalloutResultList = new List<ACETWSCalloutResult>();
        ACETWSCalloutResult findLetterCalloutResult = new ACETWSCalloutResult();
        findLetterCalloutResult.Message = 'ACTIVE_COMPLETE';

        
        ACLC.SubmitLetter();
        
        test.stopTest();
    }
    static testMethod void test6(){
        /*
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'acet-uhg--behdev';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;

        ACETOrgNameToSwivelEndpointMap__c swivel = new ACETOrgNameToSwivelEndpointMap__c();
        swivel.Name = 'dev_EngageOne';
        swivel.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel;

        ACETWrapEncryptionKey__c devkey = new ACETWrapEncryptionKey__c();
        devkey.Name = 'dev_Engageonekey';
        devkey.Algorithm_Name__c = 'AES256';
        devkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert devkey;
        */
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.PersonBirthdate = system.today();
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
            
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');

        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c='Pending Submission';
        insert fulfillment;

        String fulfil = String.ValueOf(fulfillment.id);
        
        String mockResponse = '{"MultipartBody":{"rootAttachment":{"object":{"workItems":{"LetterWorkItem":[{"status":"ACTIVE_COMPLETE"}]}}}}}';
        Test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse response2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', mockResponse);
        response2.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, response2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes2);
        ACETLGT_CreateLetterController.submitLetter(fulfil);

        ACETLGT_CreateLetterController.getStdErrMsg('test',400);
        //ACETLGT_CreateLetterController.getEngageOneUrl(fulfil);
        Test.stopTest();

    }

    static testMethod void test7(){
        /*
        Used to cover some error sections in submitLetter method is ACETLGT_CreateLetterController

        */
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.PersonBirthdate = system.today();
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
            
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');

        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c='Pending Submission';
        insert fulfillment;

        String fulfil = String.ValueOf(fulfillment.id);
        
        String mockResponse = '{"MultipartBody":{"rootAttachment":{"object":{"workItems":{"LetterWorkItem":[{"status":"Unexpected error occurred. Please try again. If problem persists, please contact the help desk."}]}}}}}';
        Test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse response2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', mockResponse);
        response2.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, response2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes2);
        ACETLGT_CreateLetterController.submitLetter(fulfil);

        mockResponse = '{"MultipartBody":{"rootAttachment":{"object":{"workItems":{"LetterWorkItem":[{"status":"error","description":"Error 1"}]}}}}}';
        response2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', mockResponse);
        response2.TokenExpired = false; 
        MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, response2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes2);
        ACETLGT_CreateLetterController.submitLetter(fulfil);

        /*
            Could not find a way to test responseBody code of 404, because the ACETLGT_FindLetterWebservice lines 62-64 do not reset the responseBody to the status code.
            If modifications to the ACETLGT_FindLetterWebservice are made, then testing could be continued for those scenarios
        */

        Test.stopTest();

    }

    static testMethod void test8(){
        /*
        Used to cover some error sections in submitLetter method is ACETLGT_CreateLetterController, processLetterCalloutResult items

        */
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_ProcessLetter', '/api/ALPHA/ccs/eisl-fulfillment/process-letters/v1');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;


        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.PersonBirthdate = system.today();
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
            
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');

        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c='Pending Submission';
        insert fulfillment;

        String fulfil = String.ValueOf(fulfillment.id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ACETLGT_CreateLetterControllerMock(500, 'pass'));
        ACETLGT_CreateLetterController.submitLetter(fulfil);
        ACETLGT_CreateLetterController.cancelLetter(fulfil);
        Test.setMock(HttpCalloutMock.class, new ACETLGT_CreateLetterControllerMock(400, 'pass'));
        ACETLGT_CreateLetterController.submitLetter(fulfil);
        ACETLGT_CreateLetterController.cancelLetter(fulfil);
        Test.setMock(HttpCalloutMock.class, new ACETLGT_CreateLetterControllerMock(200, 'pass'));
        ACETLGT_CreateLetterController.cancelLetter(fulfil);
        Test.stopTest();

    }
 }