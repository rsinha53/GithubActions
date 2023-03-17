@isTest
public class ACETDocRedeliveryTest {
    public static string docid = '76bdcd92-8e2b-43af-a13c-8ee9f20e5d0b|u_tbs_2036';
    public static string add1 = '247 Sesame Street';
    public static string city = 'NEW HAVEN';
    @testSetup static void setup() {
        Test.startTest();  
        Account ac = new Account();
        ac.name = 'test';
        insert ac;
        
        Case cs = new Case();
        cs.AccountId = ac.id;
        cs.Subject_Name__c = 'test';
        insert cs;
        Contact cont = new Contact();
        cont.LastName = 'testcon';
        insert cont;
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Member';        
        insert interaction;
        
        List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>();
        ISL_Webservice_Config__c topsConfig2 = new ISL_Webservice_Config__c();
        topsConfig2.Name = 'qa_StargateOAuthEndpoint';
        topsConfig2.ACET_Common_Name__c = 'StargateOAuthEndpoint';
        topsConfig2.Value__c = '/auth/oauth/v2/token';
        webConfigList.add(topsConfig2);
       
        ISL_Webservice_Config__c topsConfig3 = new ISL_Webservice_Config__c();
        topsConfig3.Name = 'StargateTimeout';
        topsConfig3.Value__c = '3000';
        webConfigList.add(topsConfig3);
        insert webConfigList;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c = true;
        update starTokenAPIOrgSpecificConfigs;
        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Doc360DocumentReprint', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c = true;
        update orsorgSpecificConfigs;
        WebserviceConfigurations__c orswsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('DOC360GLobalURL', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig2.Id);
        orsorgSpecificConfigs2.Static_Data__c='{"appId":"5949e3ae-1198-4b02-bc83-d63c7e4baa2c"}';
        update orsorgSpecificConfigs2;
        WebserviceConfigurations__c orswsConfig3 = ACET_WebserviceCalloutFramework_Test.createWSConfig('Doc360MultipleDocumentReprint', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs3 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs3.EnableErrorLog__c = true;
        update orsorgSpecificConfigs3;
        
        test.stopTest();
    }
    
    @isTest static void docRedeliveryWSTest(){ 
        test.startTest();
        ACETDocRedeliveryWebservice printWeb = new ACETDocRedeliveryWebservice();
        ACETDocRedeliveryRequest docRedeliveryReq = new ACETDocRedeliveryRequest();
        docRedeliveryReq.redeliveryID = 'ACET-215144994152479';
        docRedeliveryReq.recepientId  = 'recipientId';
        docRedeliveryReq.idQualifier  = 'MemberID';
        docRedeliveryReq.recepientType= 'Member';
        docRedeliveryReq.docClass     = 'u_clm_ltr';
		docRedeliveryReq.docId        = docid;
		docRedeliveryReq.bookOfBusinessTypeCode = 'DocumentReprintRequestForOX';
        docRedeliveryReq.mName   = 'H';
        docRedeliveryReq.suffix  = '';
        docRedeliveryReq.perAdd1 = add1;
        docRedeliveryReq.perAdd2 = '';
        docRedeliveryReq.perCity = city;
        docRedeliveryReq.perState= 'AK';
        docRedeliveryReq.perZip  = '06511';
        docRedeliveryReq.fName = 'Paul';
        docRedeliveryReq.lName = 'Hsu';
        printWeb.docRedeliveryWS(docRedeliveryReq);
        test.stopTest();
    }
    
    static testmethod void docTest()
    {
        String samplebody= '{"type": "/doc360/document-prints/v1","status": 500,"detail": "JSON parse error: Unexpected character","errorCode": 5000}';
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(samplebody, 500));
        
        ApexPages.currentPage().getParameters().put('docId','7f183de6');
        ApexPages.currentPage().getParameters().put('docType','ACET Letter');
        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');
        ACETDocumentController doc = new ACETDocumentController();
        doc.documentId = 'test';
        doc.documentType = 'test';
        doc.getDoc360URL();
        
        test.startTest();
        doc.resendSelectedDocs();
        Test.stopTest();
    }
    
    static testmethod void docTest2()
    {
        String samplebody= '{"reprintId":null,"clientReprintId":"Paul-ACET-1624455939386","documentClassName":null,"documentId":null,"sourceId":null,"receivedDate":null,"status":"Failed","error":{"type":"/doc360/document-prints/v1","status": 400,"detail": "Suffix should be Jr. or junior or Sr. or senior","errorCode": 2002 }}';
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(samplebody, 201));
        
        ApexPages.currentPage().getParameters().put('docId','7f183de6');
        ApexPages.currentPage().getParameters().put('docType','ACET Letter');
        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');
       
        ACETDocumentController doc = new ACETDocumentController();
        doc.documentId = 'test1';
        doc.documentType = 'test1';
        
        doc.getDoc360URL();
        test.startTest();
        doc.resendSelectedDocs();
    }
    
    static testmethod void multipleDocTest(){
        test.startTest();
        ACETDocRedeliveryWebservice printWeb = new ACETDocRedeliveryWebservice();
        List<ACETDocRedeliveryRequest> multiDocRedeliveryReq = new List<ACETDocRedeliveryRequest>();
        ACETDocRedeliveryRequest docRedeliveryReq1 = new ACETDocRedeliveryRequest();
        ACETDocRedeliveryRequest docRedeliveryReq2 = new ACETDocRedeliveryRequest();
        
        docRedeliveryReq1.redeliveryID = 'ACET-215144994152480';
        docRedeliveryReq1.recepientId  = 'recipientId';
        docRedeliveryReq1.idQualifier  = 'MemberID';
        docRedeliveryReq1.recepientType= 'Member';
        docRedeliveryReq1.docClass     = 'u_clm_ltr';
		docRedeliveryReq1.docId        = docid;
		docRedeliveryReq1.bookOfBusinessTypeCode = 'DocumentReprintRequestForOX';
        docRedeliveryReq1.mName   = 'H';
        docRedeliveryReq1.suffix  = '';
        docRedeliveryReq1.perAdd1 = add1;
        docRedeliveryReq1.perAdd2 = '';
        docRedeliveryReq1.perCity = city;
        docRedeliveryReq1.perState= 'AK';
        docRedeliveryReq1.perZip  = '06511';
        docRedeliveryReq1.fName = 'Paul';
        docRedeliveryReq1.lName = 'Hsu';
        multiDocRedeliveryReq.add(docRedeliveryReq1);
        
        docRedeliveryReq2.redeliveryID = 'ACET-215144994152481';
        docRedeliveryReq2.recepientId  = 'recipientId';
        docRedeliveryReq2.idQualifier  = 'MemberID';
        docRedeliveryReq2.recepientType= 'Member';
        docRedeliveryReq2.docClass     = 'u_clm_ltr';
		docRedeliveryReq2.docId        = docid;
		docRedeliveryReq2.bookOfBusinessTypeCode = 'DocumentReprintRequestForOX';
        docRedeliveryReq2.mName   = 'H';
        docRedeliveryReq2.suffix  = '';
        docRedeliveryReq2.perAdd1 = add1;
        docRedeliveryReq2.perAdd2 = '';
        docRedeliveryReq2.perCity = city;
        docRedeliveryReq2.perState= 'AK';
        docRedeliveryReq2.perZip  = '06511';
        docRedeliveryReq2.fName = 'Paul';
        docRedeliveryReq2.lName = 'Hsu';
        multiDocRedeliveryReq.add(docRedeliveryReq2);

        printWeb.docRedeliveryMultipleWS(multiDocRedeliveryReq);
        test.stopTest();
    }
    
    @isTest static void  testACETReprintJSON2Apex(){
        test.startTest();
        String val = '{"reprintId":null,"clientReprintId":"ACET-1624455939386","documentClassName":null,"documentId":null,"sourceId":null,"receivedDate":null,"status":"Failed","error":{"type":"/doc360/document-prints/v1","status": 400,"detail": "Suffix should be Jr. or junior or Sr. or senior","errorCode": 2002 }}';
        ACETReprintJSON2Apex.parse(val);
        test.stopTest();
    }
}