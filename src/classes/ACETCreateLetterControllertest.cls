@istest
public with sharing class ACETCreateLetterControllertest {
    //'--None--'
    static testmethod void test2()
    {
        ACETProcessLetterWebservice apl =   new ACETProcessLetterWebservice();
        ACETWSCalloutResult RES=new ACETWSCalloutResult();
        RES.Success=false;
        RES.Message='Test';
        apl.ProcessLetterWS('39898','PUBLISH');
        apl.ProcessLetterWS(Null,Null);
        
        /*try {
apl.processLetterWS('','');
} 
catch (NullPointerException e) {
System.debug ('all ok');
return;
} */
        
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpagereference(vfpage);
        Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
        contactobj.Birthdate = system.today();
        insert contactobj;
        system.debug('contactobj is '+contactobj);
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        system.debug('TestCase is '+TestCase);
        
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
        urlinstance6.Name = 'emidscm';
        urlinstance6.Org_Name__c = 'qa';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'fullcopy';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance10 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance10.Name = 'optum';
        urlinstance10.Org_Name__c = 'prd';
        insert urlinstance10;
        
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
        ACETWrapEncryptionKey__c prdkey1 = new ACETWrapEncryptionKey__c();
        prdkey1.Name = 'prd_Engageonekey';
        prdkey1.Algorithm_Name__c = 'AES256';
        prdkey1.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert prdkey1;
        
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
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        //fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Pending Submission';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
        ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        OILResponse1.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null,OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1); 
        
        apexpages.currentpage().getparameters().put('letterid',fulfillment.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.selectedTemplate = '--None--';
        ACLC.selectedtemplatename = '--None--';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'Email';
        ACLC.SelectedType='Test';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.faxNumber = '123';
        ACLC.recipientfacilityName = 'test';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.recipientsuffix = 'mr';
        ACLC.RequestBodyFormat = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
        ACLC.getDeliveryOptions();
        ACLC.onchangetemplate();
        ACLC.onchangerecipienttype();
        Apexpages.currentpage().getparameters().put('myparam','Test');
        ACLC.DisplayMessage();
        
        List<SelectOption> types = ACLC.getTypes();
        ACLC.getDeliveryOptions();
        ACLC.onchangetemplate();
        ACLC.CreateLetter();
        ACLC.SubmitLetter();
        
        ACLC.LaunchActiveX();
        try{
            ACLC.CancelLetter();
        }
        catch(exception ex)
        {
            
        }
        
        
        
        //ACLC.DisplayMessage();
        
    }
    static testmethod void testtwo()
    {
        ACETProcessLetterWebservice apl =   new ACETProcessLetterWebservice();
        ACETWSCalloutResult RES=new ACETWSCalloutResult();
        RES.Success=false;
        RES.Message='Test';
        apl.ProcessLetterWS('39898','PUBLISH');
        apl.ProcessLetterWS(Null,Null);
        
        /*try {
apl.processLetterWS('','');
} 
catch (NullPointerException e) {
System.debug ('all ok');
return;
} */
        
        case cc = new case();
        cc.Caller__c='cc';
        cc.Surrogate_Key__c='12345';
        insert cc;
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpagereference(vfpage);
        Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
        contactobj.Birthdate = system.today();
        insert contactobj;
        system.debug('contactobj is '+contactobj);
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        system.debug('TestCase is '+TestCase);
        
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
        urlinstance6.Name = 'emidscm';
        urlinstance6.Org_Name__c = 'qa';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'fullcopy';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance10 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance10.Name = 'optum';
        urlinstance10.Org_Name__c = 'prd';
        insert urlinstance10;
        
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
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        //fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Canceled';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
        ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        OILResponse1.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null,OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1); 
        
        apexpages.currentpage().getparameters().put('letterid',fulfillment.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.selectedTemplate = '--None84849--';
        ACLC.selectedtemplatename = '--None--';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'Email';
        ACLC.SelectedType='Test';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.faxNumber = '123';
        ACLC.recipientfacilityName = 'test';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.recipientsuffix = 'mr';
        ACLC.receipentVal='Member';
        ACLC.RequestBodyFormat = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
        ACLC.getDeliveryOptions();
        ACLC.onchangetemplate();
        ACLC.onchangerecipienttype();
        Apexpages.currentpage().getparameters().put('myparam','Test');
        ACLC.DisplayMessage();
        
        List<SelectOption> types = ACLC.getTypes();
        ACLC.getDeliveryOptions();
        ACLC.onchangetemplate();
        ACLC.CreateLetter();
        ACLC.SubmitLetter();
        ACLC.LaunchActiveX();
        try{
            ACLC.CancelLetter();
        }
        catch(exception ex)
        {
            
        }
        
        
        
        //ACLC.DisplayMessage();
        
    }
    
    static testmethod void test3()
    {
        ACETProcessLetterWebservice apl =   new ACETProcessLetterWebservice();
        ACETWSCalloutResult RES=new ACETWSCalloutResult();
        RES.Success=false;
        RES.Message='Test';
        apl.ProcessLetterWS('39898','PUBLISH');
        apl.ProcessLetterWS(Null,Null);
        
        /*try {
apl.processLetterWS('','');
} 
catch (NullPointerException e) {
System.debug ('all ok');
return;
} */
        
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpagereference(vfpage);
        Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
        contactobj.Birthdate = system.today();
        insert contactobj;
        system.debug('contactobj is '+contactobj);
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        system.debug('TestCase is '+TestCase);
        
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
        urlinstance6.Name = 'emidscm';
        urlinstance6.Org_Name__c = 'qa';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'fullcopy';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance10 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance10.Name = 'optum';
        urlinstance10.Org_Name__c = 'prd';
        insert urlinstance10;
        
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
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        //fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Submitted';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
        ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        OILResponse1.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null,OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1); 
        
        apexpages.currentpage().getparameters().put('letterid',fulfillment.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.selectedTemplate = '--None--';
        ACLC.selectedtemplatename = '--None--';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'Email';
        ACLC.SelectedType='Test';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.faxNumber = '123';
        ACLC.recipientfacilityName = 'test';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.recipientsuffix = 'mr';
        ACLC.RequestBodyFormat = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
        ACLC.getDeliveryOptions();
        ACLC.onchangetemplate();
        ACLC.onchangerecipienttype();
        Apexpages.currentpage().getparameters().put('myparam','Test');
        ACLC.DisplayMessage();
        
        List<SelectOption> types = ACLC.getTypes();
        ACLC.getDeliveryOptions();
        ACLC.onchangetemplate();
        ACLC.CreateLetter();
        ACLC.SubmitLetter();
        
        ACLC.LaunchActiveX();
        try{
            ACLC.CancelLetter();
        }
        catch(exception ex)
        {
            
        }
        
        
        
        //ACLC.DisplayMessage();
        
    }
    
    static testmethod void test1()
    {
        ACETCreateLetterJSON2Apex.CreateLetterResult res = new ACETCreateLetterJSON2Apex.CreateLetterResult();
        res.letterId = 11111;
        ACETCreateLetterJSON2Apex json = new ACETCreateLetterJSON2Apex();
        json.createLetterResult = res;
        
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageGetClaimCheckStatus', '/api/alpha/eisl/claims/checkstatus/v1/read');          
        mapISLWSConfigs.put('ISLStageClaimPaymentEndpoint', '/api/bravo/eisl/claims/claimpayments/v1.0/summary/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        
        insert lstISLWSConfigs;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"createLetterResult":{"letterId":46416}}');
        OILResponse.TokenExpired = false;  
        
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpagereference(vfpage);
        /* Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
insert accountObj;
Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
contactobj.Birthdate = system.today();
insert contactobj;*/
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account accountObj  = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactobj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
        system.debug('contactobj is '+contactobj);
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', contactobj.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        system.debug('TestCase is '+TestCase);
        
        Create_Letter__c let=new Create_Letter__c();
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'devacet--acetdev.cs26';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance2 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance2.Name = 'qaacet--acetqa--c.cs26';
        urlinstance2.Org_Name__c = 'qa';
        insert urlinstance2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'devacet101--acetdev101.cs26';
        urlinstance4.Org_Name__c = 'dev101';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'qaacet101--acetqa101.cs26';
        urlinstance5.Org_Name__c = 'qa101';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'acet-uhg';
        urlinstance6.Org_Name__c = 'prd';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'cs17';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        ACETOrgInstanceURLToOrgNameMap__c urlinstance8 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance8.Name = 'emidscm';
        urlinstance8.Org_Name__c = 'qa';
        insert urlinstance8;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance9 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance9.Name = 'fullcopy';
        urlinstance9.Org_Name__c = 'qa';
        insert urlinstance9;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance10 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance10.Name = 'optum';
        urlinstance10.Org_Name__c = 'prd';
        insert urlinstance10;
        
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
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_Engageonekey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert dev1key;
        
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
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Review_on_ActiveX__c = true;
        insert fulfillment;
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        OILResponse1.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null,OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1); 
        
        apexpages.currentpage().getparameters().put('letterid',fulfillment.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        ACETCreateLetterController ACLC = new ACETCreateLetterController(sc);
        ACLC.selectedTemplate = 'Balance_Bill_Letter';
        ACLC.selectedtemplatename = 'Balance_Bill_Letter';
        ACLC.selectedDeliveryOption = 'Email';
        ACLC.selectedDeliveryOption2 = 'Email';
        ACLC.SelectedType='Test';
        ACLC.emailAddress = 'abc@ac.com';
        ACLC.selectedRecipientType = 'Provider';
        ACLC.selectedRecipientSubType = 'Facility';
        ACLC.faxNumber = '123';
        ACLC.recipientfacilityName = 'test';
        ACLC.recipientFirstName = 'test';
        ACLC.recipientLastName = 'test';
        ACLC.recipientsuffix = 'mr';
        ACLC.RequestBodyFormat = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
        ACLC.getDeliveryOptions();
        ACLC.onchangetemplate();
        ACLC.onchangerecipienttype();
        
        ACLC.getTypes();
        ACLC.CreateLetter();
        ACLC.SubmitLetter();
        
        ACLC.LaunchActiveX();
        try{
            ACLC.CancelLetter();
        }
        catch(exception ex)
        {
            
        }
        
        
    }
    
    static testmethod void test4(){
        /*
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
ACETCreateLetterController ACLC = new ACETCreateLetterController(sc); */
        
        ACETProcessLetterWebservice apl =   new ACETProcessLetterWebservice();
        ACETWSCalloutResult RES=new ACETWSCalloutResult();
        
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
        //acl.last4Bytes = 'test==';
        //acl.headerEncoded = 'qswrR1w34d=';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        OILResponse6.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes6 = new MockHttpCalloutResponseGenerator(null,OILResponse6);
        Test.setMock(HttpCalloutMock.class, MockHttpRes6);
        
        acl.CreateLetterWS('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>','Balance_Bill_Letter');
        
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
        
        StaticResource RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLetterAttachmentXML'];
        //interaction and highlight panel       
        //Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group');
        
        /* Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
insert accountObj;
Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
contactobj.PersonBirthdate = system.today();
insert contactobj;*/
        
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
        
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpage(vfpage);
        
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
    }
    
    static testMethod void ACETCreateLetterWebservice1(){
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
        
        StaticResource RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLetterAttachmentXML'];
        //interaction and highlight panel       
        //Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group');
        
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
        
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpage(vfpage);
        
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
    }
    
    static testMethod void ACETProcessLetterWebservice(){
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
        mapISLWSConfigs.put('dev_CreateLetter', '/api/alpha/eisl/fulfillment/processletter/v1.0');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        //interaction and highlight panel       
        //Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group');
        
        /* Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
insert accountObj;
Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
contactobj.Birthdate = system.today();
insert contactobj;*/
        
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
        
        Case c=new Case();
        
        
        apexpages.currentpage().getparameters().put('letterid',fulfillment.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"processLetterResult": {}}');
        OILResponse.TokenExpired = false; 
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpage(vfpage);
        
        
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
        
        /* MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '');
OILResponse2.TokenExpired = false; 
MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
Test.setMock(HttpCalloutMock.class, MockHttpRes2);
ACLC.SubmitLetter(); */
        
        test.stopTest();
    }
    
    static testMethod void test5(){
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
        mapISLWSConfigs.put('dev_CreateLetter', '/api/alpha/eisl/fulfillment/processletter/v1.0');
        mapISLWSConfigs.put('dev_ProcessLetter', '/api/alpha/eisl/fulfillment/process-letters/v1.0');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        //interaction and highlight panel       
        //Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group');
        
        /* Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
insert accountObj;
Contact contactobj = ACETTestDataUtility.CreateContact(accountObj.id,'test','test','1234567',accountObj.EID__c, '1234');
contactobj.Birthdate = system.today();
insert contactobj;*/
        
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
        
        Case c=new Case();
        
        
        apexpages.currentpage().getparameters().put('letterid',fulfillment.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(TestCase);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '{"description": "testing 400"}');
        OILResponse.TokenExpired = false; 
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        pagereference vfpage = page.ACETCreateLetter;
        test.setcurrentpage(vfpage);
        
        
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
        //Added to add coverage to ACETProcessLetterWebservice
        Test.setMock(HttpCalloutMock.class, new ACETLGT_CreateLetterControllerMock(500, 'pass'));
        
        ACLC.SubmitLetter();
        Test.setMock(HttpCalloutMock.class, new ACETLGT_CreateLetterControllerMock(400, 'pass'));
        ACLC.SubmitLetter();
        
        /* MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '');
OILResponse2.TokenExpired = false; 
MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
Test.setMock(HttpCalloutMock.class, MockHttpRes2);
ACLC.SubmitLetter(); */
        
        test.stopTest();
    }
    
}