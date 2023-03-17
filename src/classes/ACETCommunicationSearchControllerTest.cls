@isTest(seeAllData = false)
public class ACETCommunicationSearchControllerTest{
      
        static testMethod void GetDocTest(){
        ACETFindDocJson2Apex ap=new ACETFindDocJson2Apex();                
               
            ACETDocument acetdoc = new ACETDocument();
            ACETDocument.DocumentKey dockey = new ACETDocument.DocumentKey('n', 'v', 'd');
            List<ACETDocument.DocumentKey> dockeylist = new List<ACETDocument.DocumentKey>();
            dockey.DataType = 'string';
            
            dockey.Value = '123';
            dockey.WSName = 'test';
            dockeylist.add(dockey);
            acetdoc.ContentType = 'string';
            acetdoc.DocumentId = 'id';
            acetdoc.DocumentKeys = dockeylist;
            acetdoc.DocumentLength = 5;
            
                   
            
        ISL_Webservice_Config__c isl3 = new ISL_Webservice_Config__c();
        isl3.Name = 'OILHttpHeaderAccept  '; 
        isl3.Error_Log_Enabled__c = False;
        isl3.Is_Available__c = True;
        isl3.Page_Size__c = 1;
        isl3.Service_Name__c = '';
        isl3.Value__c = 'application/json;charset=UTF-8'; 
        insert isl3;

                
        ISL_Webservice_Config__c  isl = new ISL_Webservice_Config__c();
        isl.Name ='OILHttpHeaderScope';
        isl.Is_Available__c=true;
        isl.Value__c='read';
        insert isl;
        
        ISL_Webservice_Config__c isl2 = new ISL_Webservice_Config__c();
        isl2.Name = 'OILHttpHeaderActor'; 
        isl2.Error_Log_Enabled__c = False;
        isl2.Is_Available__c = True;
        isl2.Page_Size__c = 3;
        isl2.Service_Name__c = '';
        isl2.Value__c = 'ACET'; 
        insert isl2;  
        
        ACETGetDocWebservice web=new ACETGetDocWebservice();
        ACETWSCalloutResult ress=new ACETWSCalloutResult();
        web.GetRequestBody();
        web.GetMethod();
        web.GetEndpoint();
        web.GetRequestBody('test','test');
        web.GetRequestBody('Data','Data');
        web.fetchDocument('test','test');

        ApexPages.currentPage().getParameters().put('isl',isl3.Id);
        ApexPages.currentPage().getParameters().put('isl1',isl.Id);
        ApexPages.currentPage().getParameters().put('isl2',isl2.Id);
    

        
        List<ACETFindDocWebservice.documentKey> ad1=new List<ACETFindDocWebservice.documentKey>();
        ACETFindDocWebservice.documentKey ad=new ACETFindDocWebservice.documentKey();
        ad.name = 'Test';
        ad.value = 'Test123';
        ad.dataTypeIndicator = 'Testdata';
        ad.operator = 'UHG';
        ad1.add(ad);
         ACETFindDocWebservice.DocumentKey dockey2 = new ACETFindDocWebservice.DocumentKey();
        dockey2.dataTypeIndicator = 'Datetime';
        dockey2.operator = '=';
        dockey2.Value = '2020-01-01';
        dockey2.name = 'testdate';
        ad1.add(dockey2);
        

         ACETFindDocWebservice ac=new ACETFindDocWebservice();
            //Calling the void method's
         ac.GetEndpoint();
         ac.GetMethod();
         ac.GetHeaders(isl);
         ac.init('test123',ad1);
         ac.GetRequestBody(1,1,1); 
                                           
    ApexPages.currentPage().getParameters().put('isl',isl3.Id);
    ApexPages.currentPage().getParameters().put('isl1',isl.Id);
    ApexPages.currentPage().getParameters().put('isl2',isl2.Id);
     ACETWSCalloutResult oACETWSCallout = new ACETWSCalloutResult();
     oACETWSCallout = ac.queryPaginatedData(1,2,3);
     oACETWSCallout.Success = true;
     oACETWSCallout.Message = 'status';
     
     
          
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
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        web.fetchDocument('test','test');
        Test.stopTest();        
             
      ACETFindDocJson2Apex ap1=new ACETFindDocJson2Apex();
      ACETFindDocJson2Apex.FindDocumentsResponseType type=new ACETFindDocJson2Apex.FindDocumentsResponseType();
      ACETFindDocJson2Apex.FindDocumentsResponse find=new ACETFindDocJson2Apex.FindDocumentsResponse();
      find = ap1.findDocumentsResponse;
      ACETFindDocJson2Apex.DocumentList doc=new ACETFindDocJson2Apex.DocumentList();
      ACETFindDocJson2Apex.Pagination pg=new ACETFindDocJson2Apex.Pagination();
      ACETFindDocJson2Apex.DocumentKey keys=new ACETFindDocJson2Apex.DocumentKey();
      ACETFindDocJson2Apex.DocumentKeys doc1=new ACETFindDocJson2Apex.DocumentKeys(); 
      ACETFindDocJson2Apex.Document doc2=new  ACETFindDocJson2Apex.Document();
      
      
       }       
       static testmethod void communicationTest2(){
      ACETFinfFulfillmentHistoryWebservice fulfillment=new ACETFinfFulfillmentHistoryWebservice();
      fulfillment.GetEndpoint();
      
      ACETWSCalloutResult res=new ACETWSCalloutResult();
      ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet SR= new ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet();
      ACETFindFulfillmentHistoryJSON2Apex.MailToAddress AD =new ACETFindFulfillmentHistoryJSON2Apex.MailToAddress();
        AD.Address1='test';
        AD.Address2='test';
        AD.Address3='test';
        AD.City='test';
        AD.State='test';
        
    
        ISL_Webservice_Config__c OAuthConfig =new ISL_Webservice_Config__c();

                 
      // SFDC will respond to the callout with mock response
        //system.assert(...);  // verify leads are built as expected, errors handled



                     
    //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    
    ACETFindFulfillmentHistoryJSON2Apex.SearchParameter AFFJ2A4 = new ACETFindFulfillmentHistoryJSON2Apex.SearchParameter();
        AFFJ2A4.searchSourceID ='test';
        AFFJ2A4.documentID='test';
    List<ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet> SRS1= new List<ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet>();
    ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet SRS= new ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet();
    ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHeader RRH= new ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHeader();
    //ResponseRequestHeader 
        RRH.requestID='test';
        RRH.sourceIDName='test';
        RRH.destinationIDName='test';
        RRH.requestDate='test';
        RRH.businessSegmentName='test';
        RRH.marketSegmentName='test';
        RRH.fulfillmentTypeBusName='test';
        RRH.requestCategory='test';
        RRH.dataFormat='test';
        RRH.requestorRefNo='test';
        RRH.supplierRefNo='test';
    ACETFindFulfillmentHistoryJSON2Apex.RequestTrailer RQT = new ACETFindFulfillmentHistoryJSON2Apex.RequestTrailer();
        RQT.requestItemCount=10;
        RRH.requestTrailer=RQT;
        SRS.responseRequestHeader=RRH;
    ACETFindFulfillmentHistoryJSON2Apex.ResponseCurrentEventLog RCEL= new ACETFindFulfillmentHistoryJSON2Apex.ResponseCurrentEventLog();
        RCEL.processorName='test';
        RCEL.eventTypeBusName='test';
        RCEL.receivedDate='test';
        RCEL.dispatchedDate='test';
        RCEL.statusCode='test';
        SRS.responseCurrentEventLog=RCEL;
    ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestDetail RRD= new ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestDetail();
    ACETFindFulfillmentHistoryJSON2Apex.ResponseTransactionalRequestDetail  RTRD = new ACETFindFulfillmentHistoryJSON2Apex.ResponseTransactionalRequestDetail();
    List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient> RR1 =new List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient>();
    ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient RR =new ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient();

        RR.recipientId='test';
        RR.identifierQualifierCodeDescr='test';
        RR.deliveryMethod1='test';
        RR.constituentTypeDescr='test';
    ACETFindFulfillmentHistoryJSON2Apex.Person PER = new ACETFindFulfillmentHistoryJSON2Apex.Person();
        PER.prefix='test';
        PER.firstName='test';
        PER.middleName='test';
        PER.lastName='test';
        PER.suffix='test';
        RR.person=PER;
    ACETFindFulfillmentHistoryJSON2Apex.MailToAddress MA =new ACETFindFulfillmentHistoryJSON2Apex.MailToAddress();
        MA.Address1='test';
        MA.Address2='test';
        MA.Address3='test';
        MA.City='test';
        MA.State='test';
        MA.Zip='test';
        RR.MailToAddress=MA;
        RR.ReturnToAddress=MA;
        RR.faxNumber='test';
        RR.emailAddress='test';
    ACETFindFulfillmentHistoryJSON2Apex.ResponseTemplate RT = new ACETFindFulfillmentHistoryJSON2Apex.ResponseTemplate();
        RT.templateID='test';
        RT.templateName='test';
        RR1.add(RR);
        RTRD.responseRecipient =RR1;
        RTRD.responseTemplate=RT; 
        RRD.responseTransactionalRequestDetail=RTRD;
        SRS.responseRequestDetail=RRD;
    List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory> RRHT1= new List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory>();
    ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory RRHT= new ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory();

        RRHT.processorName='test';
        RRHT.eventTypeBusName='test';
        RRHT.receivedDate='test';
        RRHT.dispatchedDate='test';
        RRHT.recipientId='test';
        RRHT.deliveryMethodCd='test';
        RRHT.statusCode='test';
        RRHT.successCount='test';
        RRHT.exceptionCount='test';
        RRHT.documentID='test';
        RRHT.documentType='test';
        RRHT.repositoryName='test';
        RRHT1.add(RRHT);
        SRS.responseRequestHistory=RRHT1; 
        SRS1.ADD(SRS);
    ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResponse AFFJ2A3 = new ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResponse();
        AFFJ2A3.searchParameter=AFFJ2A4;
        AFFJ2A3.searchResultSet=SRS1;
    ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult AFFJ2A2 = new ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult();
        AFFJ2A2.findFulfillmentHistoryResponse=AFFJ2A3;

    
        PageReference pgRef = Page.ACETFormsHistory;
        System.currentPageReference().getParameters().put('docId',JSON.serialize(new List<String>{'test123'}));
        ACETHighlightsPanelAdditionalInfo objACETHighlightsPanelAdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        objACETHighlightsPanelAdditionalInfo.surrogatekey = 'test';
        System.currentPageReference().getParameters().put('additionalInfo',JSON.serialize(objACETHighlightsPanelAdditionalInfo));
        setMockResponse();
                                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        ACETCommunicationSearchController objCont = new ACETCommunicationSearchController();
        List<Document_Type_Search_Result_Field__mdt  > listSearchResults =new List<Document_Type_Search_Result_Field__mdt  >();
        objCont.selectedResWrapper = new list<ACETCommunicationSearchResult>();
        objCont.IsGroupFocus = True;
        objcont.showSubmitBtnAOF=true;
        objcont.DynamicParams='Test';
        
        objCont.Commhistorytitle='Test';
        objCont.documentType = 'Member EOB';
        objCont.init();
        objCont.documentType = 'Provider PRA';
        objCont.init();
        objCont.documentType = 'SBC';
        objCont.init();
        objCont.documentType = 'TEST';
        objCont.init();
        objCont.resend();
        objCont.btnCancel();
        System.currentPageReference().getParameters().put('SRK','');
        System.currentPageReference().getParameters().put('groupID','1388476');
        try {objCont.findGroupInfo();     }catch(exception ex){}           
        System.currentPageReference().getParameters().put('producerId','167106');         
        System.currentPageReference().getParameters().put('ProvTypeCode','HCO');
        System.currentPageReference().getParameters().put('ProvTypeCode','HCP');
        System.currentPageReference().getParameters().put('bulkCheck','false');
        System.currentPageReference().getParameters().put('bulkCheck','true');
           objCont.GetCommuicationHistoryResults();
        
        ISL_Webservice_Config__c  isl = new ISL_Webservice_Config__c();
        isl.Name ='OILHttpHeaderScope';
        isl.Is_Available__c=true;
        isl.Value__c='read';
        insert isl;

     List<ACETFindDocWebservice.documentKey> ad2=new List<ACETFindDocWebservice.documentKey>();
        ACETFindDocWebservice.documentKey ad1=new ACETFindDocWebservice.documentKey();
        ad1.name = 'Test';
        ad1.value = 'Test123';
        ad1.dataTypeIndicator = 'Testdata';
        ad1.operator = 'UHG';
        ad2.add(ad1);

        
        ACETFindDocWebservice ac=new ACETFindDocWebservice();
            //Calling the void method's
         ac.GetEndpoint();
         ac.GetMethod();
         ac.GetHeaders(isl);
         ac.init('test123',ad2);
         ac.GetRequestBody(1,1,1); 
        ACETDatatableWrapper wrap=new ACETDatatableWrapper('AcetFindDocWebservice',ac);
        
                
        ACETCommunicationSearchResult result = new ACETCommunicationSearchResult();
        result.Document_ID = 'test123';
        result.organization = 'Oxford';
        result.Funding_Type = 'ASO';
        result.Document_Class = 'Test';
        result.Member_Id = '123456789';
        result.EOB_Date = string.valueof(system.today());
        result.policy_Number  = '987654321';
        result.Member_Name = 'Steve Gill';
        result.DocumentContentType = 'test';
        result.Resend_Status = 'test status';
        result.Check_EFT_Number = '123243';
        result.Payee_Name = 'test name';
        result.selectRecord = true;
        result.IsDocSizeMoreThanOneMB = false;
        result.Series_Designator = 'test name';
        result.redStatus = 'test name';
        result.Tax_ID = 'test name';
        result.redDateTime = 'test name';
        result.Employer_Group_Name_SBC = 'test';
        result.Organization_SBC = 'test';
        result.Funding_Type_SBC = 'test';
        result.Policy_End_Date_SBC = 'test';
        result.Policy_Number_SBC = 'test';
        result.Policy_Start_Date_SBC = 'test';
        result.Employee_ID_Test = 'test';
        result.Member_ID_Test = 'test';
        result.Payee_Name_Test = 'test';
        result.Policy_Number_Test = 'test';
        result.Tax_ID_Test = 'test';
        result.Organization_Test = 'test';
        result.Funding_Type_Test = 'test';
        result.Document_ID_Test = 'test';
       result.Funding_Type_PRA = null;
        result.Member_ID_PRA = 'test';
        result.Organization_PRA = 'test';
        result.Resend_Date_Time = 'test';
        result.Document_ID_PRA = '12324';
        result.Document_ID_SBC = '53423';
        result.PRA_Date = 'test';
        result.Document_Class_PRA  = null;
        result.Document_Class_SBC = null;
    }
    
    AcetCommunicationSearchController cont =new AcetCommunicationSearchController();
    
    ACETGetProducerAdapterWebservice servicecall = new ACETGetProducerAdapterWebservice();
    
    static testMethod void testProvInfo(){

    System.currentPageReference().getParameters().put('producerId','167106');

    ACETGetProducerAdapterWebservice servicecall = new ACETGetProducerAdapterWebservice();

    servicecall.GetProducer('16712');

    Document_Type_Flow__mdt docTypeFlow1=[select Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c from Document_Type_Flow__mdt where Flow__c ='Producer' Limit 1];  
                        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        ACETCommunicationSearchController acetComSerContr=new ACETCommunicationSearchController();

    try{

    acetComSerContr.findProducerInfo(docTypeFlow1);

    }catch(Exception e){}

}
static testMethod void testSer(){

                         ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');


    ACETCommunicationSearchController acetComSerContr=new ACETCommunicationSearchController();

    acetComSerContr.DynamicParams='["te,st1","te,st2","te,st3"]';


    try{

      acetComSerContr.search();

    }catch(Exception e){}

}
static testMethod void testSelectedDocs(){

    System.currentPageReference().getParameters().put('docIds','te,st1');
                     ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETCommunicationSearchController acetComSerContr=new ACETCommunicationSearchController();

    acetComSerContr.selectAddress='AddressOnFile';

    try{

      acetComSerContr.resendSelectedDocs();
acetComSerContr.selectAddress='AlternateAddress';
    }catch(Exception e){}
acetComSerContr.selectAddress='test';
                         ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

ACETCommunicationSearchController.personWrapper pWrap=new ACETCommunicationSearchController.personWrapper();

    pWrap.personFirstName='testfname';

    pWrap.personLastName='testlname'; 

}

    static testMethod void ACETRedeliveryJSON2ApexTest() {
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETRedeliverResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        ACETDocRedeliveryWebservice ADRW = new ACETDocRedeliveryWebservice();
        ACETDocRedeliveryRequest docRedeliveryReq = new ACETDocRedeliveryRequest();
        docRedeliveryReq.redeliveryID = '';
        docRedeliveryReq.recepientId  = '';
        docRedeliveryReq.idQualifier  = '';
        docRedeliveryReq.recepientType= '';
        docRedeliveryReq.docClass     = '';
		docRedeliveryReq.docId        = '';
		docRedeliveryReq.bookOfBusinessTypeCode = '';
        docRedeliveryReq.mName   = '';
        docRedeliveryReq.suffix  = '';
        docRedeliveryReq.perAdd1 = '';
        docRedeliveryReq.perAdd2 = '';
        docRedeliveryReq.perCity = '';
        docRedeliveryReq.perState= '';
        docRedeliveryReq.perZip  = '';
        docRedeliveryReq.fName = '';
        docRedeliveryReq.lName = '';
        ADRW.docRedeliveryWS(docRedeliveryReq);
        
    }
    static testMethod void testSuffixMessage() {
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        ACETCommunicationSearchController objCont = new ACETCommunicationSearchController();
        objCont.suffixMessage();
        
    }
    


    static testMethod void ACETCommunicationSearchControllerTest1() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/documents/v2.0/search/redelivery');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETRedeliverResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        String ResponseJSON1 = ResponseJSONSR.Body.toString();
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode', 'ox');

                    ACETHighlightsPanelAdditionalInfo info = new ACETHighlightsPanelAdditionalInfo();
        info.isMember = 'false';
        info.FirstName = 'test';
        info.LastName = 'test';
        info.DOB = '1/1/1111';
        info.GroupNumber = 'test';
        info.PolicyNumber = 'TestPolicyNumber';
        info.bookOfBusinessTypeCode ='ox';
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        
        
        PageReference pgRef = Page.ACETCommunicationSearchPage;
        Test.setCurrentPageReference(pgRef);
        
        PageReference pgRef2 = Page.ACETProducerDetail; 
        Test.setCurrentPageReference(pgRef2);
        
        PageReference pgRef3 = Page.ACETViewEmployerGroup; 
        Test.setCurrentPageReference(pgRef3);

        ACETCommunicationSearchResult result = new ACETCommunicationSearchResult();
        result.Document_ID = 'test123';
        result.organization = 'Oxford';
        result.Funding_Type = 'ASO';
        result.Document_Class = 'Test';
        result.Member_Id = '123456789';
        result.EOB_Date = string.valueof(system.today());
        result.policy_Number  = '987654321';
        result.Member_Name = 'Steve Gill';
         result.DocumentContentType = 'test';
         result.Resend_Status = 'test status';
        result.Check_EFT_Number = '123243';
        result.Payee_Name = 'test name';
       result.selectRecord = true;
        result.IsDocSizeMoreThanOneMB = false;
        result.Series_Designator = 'test name';
        result.redStatus = 'test name';
        result.Tax_ID = 'test name';
        result.redDateTime = 'test name';
        result.Employer_Group_Name_SBC = 'test';
        result.Organization_SBC = 'test';
        result.Funding_Type_SBC = 'test';
        result.Policy_End_Date_SBC = 'test';
        result.Policy_Number_SBC = 'test';
        result.Policy_Start_Date_SBC = 'test';
        result.Employee_ID_Test = 'test';
        result.Member_ID_Test = 'test';
        result.Payee_Name_Test = 'test';
        result.Policy_Number_Test = 'test';
        result.Tax_ID_Test = 'test';
        result.Organization_Test = 'test';
        result.Funding_Type_Test = 'test';
        result.Document_ID_Test = 'test';
        result.Funding_Type_PRA = null;
        result.Member_ID_PRA = 'test';
        result.Organization_PRA = 'test';
        result.Resend_Date_Time = 'test';
        result.Document_ID_PRA = '12324';
        result.Document_ID_SBC = '53423';
        result.PRA_Date = 'test';
        result.Document_Class_PRA  = null;
        result.Document_Class_SBC = null;
        //result.EOB_Date = null;
        // result.policy_Number  = null;
                ApexPages.currentPage().getParameters().put('docIds',JSON.serialize(new List<String>{'test123','test1234'}));
                setMockResponse();
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

                ACETCommunicationSearchController objCont = new ACETCommunicationSearchController();
        objcont.DTWrapper=null;
        objcont.listSearchResults=null;
        objcont.findDocKeys=null;
        objcont.Selecteddocname='Test';
        objCont.documentType = 'Member EOB';
        objCont.selectAddress = 'AlternateAddress';
        objCont.init();
        objCont.resWrapper = new list<ACETCommunicationSearchResult>();
        objCont.resWrapper.add(result);

        
        objCont.resendSelectedDocs();
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse1 = new MockHttpCalloutResponseGenerator(null, OILTestResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse1);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse2 = new MockHttpCalloutResponseGenerator(null, OILTestResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse2);  
        objCont.selectAddress = 'AddressOnFile';
        objCont.AdditionalInfoData = info;
        try{ objCont.findGroupInfo();}catch(exception ex){}
        StaticResource ResponseJSONFinF = [SELECT Body FROM StaticResource WHERE Name = 'AcetFindFulfillmentHistoryResultJSON'];
        String ResponseJSONFin = ResponseJSONFinF.Body.toString();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSONFin);
        OILTestResponse3.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse3 = new MockHttpCalloutResponseGenerator(null,OILTestResponse3);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse3);
        
        objCont.GetCommuicationHistoryResults();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse3_Exception = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        OILTestResponse3_Exception .TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse3_Exception = new MockHttpCalloutResponseGenerator(null,OILTestResponse3_Exception );
        Test.setMock(HttpCalloutMock.class, MockHttpResponse3_Exception );
        objCont.GetCommuicationHistoryResults();
        
        Test.Stoptest();
        
    }
     
    private static void setMockResponse(){
        
        MultiStaticResourceCalloutMock multiMockResponse = new MultiStaticResourceCalloutMock();
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetIndividualService', 'GetIndividualFamilyMembersJSON');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetMemberShipService', 'GetMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/FindMemberShipService', 'FindMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetFamilyMemberService', 'GetFamilyMemberService');
        multiMockResponse.setStatusCode(200);
        multiMockResponse.setHeader('Content-Type', 'application/json');        
        
        Test.setMock(HttpCalloutMock.class, multiMockResponse);
        
    }
    static testMethod void flowname1(){
                     ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController ac1= new ACETCommunicationSearchController();
     try {
     ac1.getFlowName();
     }
     catch(exception ex){}           
    
    
     Interaction__c oInteraction1 = new Interaction__c();
     oInteraction1.Originator_Type__c = 'Member';
     insert oInteraction1;
     ApexPages.currentPage().getParameters().put('InteractionId',oInteraction1 .Id);
                        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     //calling methods
     ACETCommunicationSearchController acc1= new ACETCommunicationSearchController();
     acc1.getFlowName();
     ACETMemberDetail memberDetail = new ACETMemberDetail();
     System.currentPageReference().getParameters().put('SRK','dummy619836885');     
      
    }
    
    static testMethod void flowname2(){
                     ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController ac2= new ACETCommunicationSearchController();
     try {
     ac2.getFlowName();
    }
    catch(exception ex){}           
    
          
     Interaction__c oInteraction2 = new Interaction__c();
     oInteraction2.Originator_Type__c = 'Broker';
     insert oInteraction2;
     ApexPages.currentPage().getParameters().put('InteractionId',oInteraction2.Id);
                        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     //calling methods
     ACETCommunicationSearchController ac21= new ACETCommunicationSearchController();
     ac21.getFlowName(); 
                     ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController acc2= new ACETCommunicationSearchController();
     acc2.getFlowName();
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController acs2= new ACETCommunicationSearchController();
     acs2.documentType='SBC';
     acs2.getFlowName();
     System.currentPageReference().getParameters().put('ProvTypeCode','HCO'); 
         
    }

static testMethod void flowname3(){
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController ac3= new ACETCommunicationSearchController();
     try {
     ac3.getFlowName();
     }
     catch(exception ex){}           
    
    Interaction__c oInteractiona3 = new Interaction__c();
     oInteractiona3.Originator_Type__c = 'Group';
     insert oInteractiona3;
     ApexPages.currentPage().getParameters().put('InteractionId',oInteractiona3.Id);

          
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController acc3= new ACETCommunicationSearchController();
     acc3.getFlowName(); 
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController acs3= new ACETCommunicationSearchController();
     acs3.getFlowName();
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

          ACETCommunicationSearchController acsc3= new ACETCommunicationSearchController();
     acsc3.documentType='SBC';
     acsc3.getFlowName();
     System.currentPageReference().getParameters().put('ProvTypeCode','HCO'); 
         
    }

static testMethod void flowname4(){
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController a4= new ACETCommunicationSearchController();
     try {
     a4.getFlowName();
    }
    catch(exception ex){}           
    Interaction__c oInteractiona4 = new Interaction__c();
     oInteractiona4.Originator_Type__c = 'Producer';
     insert oInteractiona4;
     ApexPages.currentPage().getParameters().put('InteractionId',oInteractiona4.Id);

     
      
    
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"response": { "serviceAttributes":{"applicationIdentifier": "IVR","requestIdentifier": "2d537d12-b1fd-4d7a-b990-40dfb1c23426","responseCode": "200","responseDescription": "Success:Trace of all the success calls","totalNumberOfRecords": "9","pageNumber": "","recordsPerPage": ""},"getProducerResponse":{"producerID": "167106","memberGroupDetails":[{"groupNumber": "2100105","groupName": "10404 - Scenario 5 "},{"groupNumber": "9786013","groupName": "SB UHG Scenario 4"},{"groupNumber": "1110176","groupName": "UHG SHOP Test contract 26"},{"groupNumber": "5110301","groupName": "Test UHG contract 31"},{"groupNumber": "1110111","groupName": "UHG SHOP Test contract 15"},{"groupNumber": "9966214","groupName": "Test contract 2"},{"groupNumber": "9966231","groupName": "Test contract 2"},{"groupNumber": "7676005","groupName": "SB UHG Scenario 1"},{"groupNumber": "8110400","groupName": "Test UHG PR contract 1"}],"producerCompanyName": "","producerName":{"firstName": "SAMUEL","middleInitial": "J","lastName": "GRUBBS"},"producerTIN": "","producerSSN": "987167106","producerType": "I ","type": "BR","producerContact": " ","producerEffectiveStartDate": "08/23/2007","producerEffectiveEndDate": "12/31/2016","producerAddress":{"addressTypeCode": "M","addressLine1": "647 LUVERNE AVE","addressLine2": "","city": "PANAMA CITY","state": "FL","zipCode": "32401","country": "","phoneNumber": "8507695215"},"producerStatus": "InActive","legacyBrokerCode": ""}}}');        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.producerId = '123456';
        String addinfojson = JSON.serialize(addinfo);
            ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
                     ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETCommunicationSearchController ac4= new ACETCommunicationSearchController();
     ac4.getFlowName();
    
     ApexPages.currentPage().getParameters().put('groupID','123456');
     ac4.IsMemberFocus = false;
     ac4.getFlowName();
     ac4.DocumentType = 'Group Letter';
    ac4.init();
    ac4.documentTypeName = 'Group Letter';
    ac4.updateSearchField();
    
    
                         ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     
     ACETCommunicationSearchController acs4= new ACETCommunicationSearchController();
     ac4.getFlowName();
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController aca4= new ACETCommunicationSearchController();
     aca4.documentType='SBC';
     aca4.getFlowName();
     System.currentPageReference().getParameters().put('ProvTypeCode','HCO'); 

         
    }


static testMethod void flowname5(){
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController ac5= new ACETCommunicationSearchController();
     try {
     ac5.getFlowName();
     }
    catch(exception ex){}               
    Interaction__c oInteractiona5 = new Interaction__c();
     oInteractiona5.Originator_Type__c = 'Provider';
     insert oInteractiona5;
     ApexPages.currentPage().getParameters().put('InteractionId',oInteractiona5.Id);

          
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController aca5= new ACETCommunicationSearchController();
     aca5.getFlowName(); 
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

     ACETCommunicationSearchController acc5= new ACETCommunicationSearchController();
     acc5.getFlowName();
                          ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

          ACETCommunicationSearchController acs5= new ACETCommunicationSearchController();
     acs5.documentType='SBC';
     acs5.getFlowName();
     System.currentPageReference().getParameters().put('ProvTypeCode','HCO'); 
   }
   
   static testMethod void testUpdateSearchField(){
     
     Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c = true;
        update starTokenAPIOrgSpecificConfigs;

        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkRelatedDocuments', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c = true;
        update orsorgSpecificConfigs;
     ApexPages.currentPage().getParameters().put('ProvTypeCode','HCO');    
     ApexPages.currentPage().getParameters().put('memberId','HCO'); 
     ApexPages.currentPage().getParameters().put('groupID','1388476');
     ApexPages.currentPage().getParameters().put('producerId','167106');
     ApexPages.currentPage().getParameters().put('SRK','SRK');
            ACETHighlightsPanelAdditionalInfo info = new ACETHighlightsPanelAdditionalInfo();
        info.isMember = 'false';
        info.FirstName = 'test';
        info.LastName = 'test';
        info.DOB = '1/1/1111';
        info.GroupNumber = 'test';
        
        
        ApexPages.currentPage().getParameters().put('additionalInfo', json.serialize(info));
        Test.startTest();
         
         ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

             ACETCommunicationSearchController acetComSerCntr= new ACETCommunicationSearchController();
        acetComSerCntr.DynamicParams = '["1234567890,u_id_crd_srl_nbr,String,","12334343,u_grp_id,String,"]';
       ACETFindDoc360SearchResults res = new ACETFindDoc360SearchResults();
       res.moreRecordsLeft=false;
       res.startRow=1;
       res.scrollId='';
       ACETFindDoc360SearchResults.RecordsList rec = new ACETFindDoc360SearchResults.RecordsList();
       rec.objectName ='test';
       rec.mimeType='pdf';
       rec.contentType ='PDF';
       rec.contentSize=1415;
       rec.contentFileExtension='.pdf';
       rec.totalPages=1;
       rec.contentStream='test';
       ACETFindDoc360SearchResults.Attributes att = new ACETFindDoc360SearchResults.Attributes();
       att.classId=0;
       att.id=0;
       att.alias1='test';
       att.alias2='test';
       att.conversionFormat='test';
       att.federateSearchAlias='test';
       att.legacyLabelName='test';
       att.physicalName='test';
       att.priority='test';
       att.sortNumericInd='test';
       att.wildCardIndicator='test';
       att.wildCardMinLengthRequired='10';
       ACETFindDoc360SearchRequest.Range rg =new ACETFindDoc360SearchRequest.Range();
       rg.gte='12';
       rg.lte='12';
       rg.gt='12';
       rg.lt='12';
       ACETFindDoc360SearchRequest.Filters ft = new ACETFindDoc360SearchRequest.Filters();
       ft.range=rg;
     List<SelectOption> docTypeOptions=new List<SelectOption>();
     docTypeOptions.add(new SelectOption('ACET Letter','ACET Letter'));
     acetComSerCntr.documentTypeOptions=docTypeOptions;
     acetComSerCntr.DocumentType='ACET Letter';
     try{
     acetComSerCntr.Flow='Provider';
     acetComSerCntr.updateSearchField();
     }catch(Exception e){}
     try{
         String samplebody= '{"moreRecordsLeft":false,"startRow":0,"totalRecords":1,"scrollId":"","recordsList":[{"objectId":"51bd3285-6f83-45f7-a6f7-4e58aae30c47|u_enrl_ltr_2021-04","objectName":"","mimeType":null,"contentType":"PDF","contentSize":1079046,"contentFileExtension":null,"totalPages":152,"contentStream":null,"attributes":[{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"r_content_size","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"r_content_size","physicalName":"r_content_size","priority":null,"sortNumericInd":null,"value":"1079046"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_flfl_req_head_id","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_flfl_req_head_id","physicalName":"u_flfl_req_head_id","priority":null,"sortNumericInd":null,"value":"111"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"a_content_type","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"a_content_type","physicalName":"a_content_type","priority":null,"sortNumericInd":null,"value":"PDF"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_id_crd_srl_nbr","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_id_crd_srl_nbr","physicalName":"u_id_crd_srl_nbr","priority":null,"sortNumericInd":null,"value":"1234567890"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_tmplt_nm","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_tmplt_nm","physicalName":"u_tmplt_nm","priority":null,"sortNumericInd":null,"value":"COBRA TERM MEDICARE OTHER COV"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_title","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_title","physicalName":"u_title","priority":null,"sortNumericInd":null,"value":"MEMBER HANDBOOK.PDF"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_grp_id","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_grp_id","physicalName":"u_grp_id","priority":null,"sortNumericInd":null,"value":"12334343"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_ltr_create_dt","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_ltr_create_dt","physicalName":"u_ltr_create_dt","priority":null,"sortNumericInd":null,"value":"2021-04-08T00:00:00.000Z"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_mbr_lst_nm","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_mbr_lst_nm","physicalName":"u_mbr_lst_nm","priority":null,"sortNumericInd":null,"value":"PAUL"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_author","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_author","physicalName":"u_author","priority":null,"sortNumericInd":null,"value":"HHSU2"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_sbscr_id","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_sbscr_id","physicalName":"u_sbscr_id","priority":null,"sortNumericInd":null,"value":"12222"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_mbr_id","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_mbr_id","physicalName":"u_mbr_id","priority":null,"sortNumericInd":null,"value":"111"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_policy_nbr","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_policy_nbr","physicalName":"u_policy_nbr","priority":null,"sortNumericInd":null,"value":""},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_mbr_fst_nm","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_mbr_fst_nm","physicalName":"u_mbr_fst_nm","priority":null,"sortNumericInd":null,"value":"TEST"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_gbl_doc_id","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_gbl_doc_id","physicalName":"u_gbl_doc_id","priority":null,"sortNumericInd":null,"value":"51bd3285-6f83-45f7-a6f7-4e58aae30c47|u_enrl_ltr_2021-04"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_legal_hold","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_legal_hold","physicalName":"u_legal_hold","priority":null,"sortNumericInd":null,"value":"false"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_pulse_mbr_id","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_pulse_mbr_id","physicalName":"u_pulse_mbr_id","priority":null,"sortNumericInd":null,"value":"1111"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_ssn","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_ssn","physicalName":"u_ssn","priority":null,"sortNumericInd":null,"value":"1112223333"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"u_orig_creation_date","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"u_orig_creation_date","physicalName":"u_orig_creation_date","priority":null,"sortNumericInd":null,"value":"2021-04-15T18:08:11.000Z"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"r_page_cnt","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"r_page_cnt","physicalName":"r_page_cnt","priority":null,"sortNumericInd":null,"value":"152"},{"classId":0,"id":0,"alias1":null,"alias2":null,"conversionFormat":null,"federateSearchAlias":null,"labelName":"r_object_id","wildCardIndicator":null,"wildCardMinLengthRequired":null,"legacyLabelName":"r_object_id","physicalName":"r_object_id","priority":null,"sortNumericInd":null,"value":"51bd3285-6f83-45f7-a6f7-4e58aae30c47|u_enrl_ltr_2021-04"}]}]}';
         Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(samplebody, 200));
        acetComSerCntr.Flow='Member';
        acetComSerCntr.updateSearchField();
     }catch(Exception e){}
     
     try{
        acetComSerCntr.Flow='Producer';
        acetComSerCntr.updateSearchField();
     }catch(Exception e){}
     
     try{
        acetComSerCntr.Flow='Group';
        acetComSerCntr.updateSearchField();
     }catch(Exception e){}
     
     list<ACETCommunicationSearchResult> acetComSerRes = new list<ACETCommunicationSearchResult>();
     acetComSerCntr.Flow='Provider';
     acetComSerCntr.resWrapper=acetComSerRes;
     acetComSerCntr.clear();
     
     try{
        acetComSerCntr.DocumentType='Provider RA';
        acetComSerCntr.Flow='Member';
        acetComSerCntr.updateSearchField(); 
        acetComSerCntr.DynamicParams='test';
        acetComSerCntr.DynamicParams = '["89024672500,u_id_crd_srl_nbr,String,","1198480,u_grp_id,String,"]';
        acetComSerCntr.search();
     }catch(Exception e){}
     try{
        acetComSerCntr.UpdateAddressFields();
     }catch(Exception e){}  
       
     
   try{  acetComSerCntr.findGroupInfo();}catch(exception ex){}
     Document_Type_Flow__mdt docTypeFlow=[select Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,Subscriber_Only__c from Document_Type_Flow__mdt where Flow__c ='Member' and Is_Member_Focus__c = true Limit 1];
     acetComSerCntr.findMemberInfo(docTypeFlow);
     Document_Type_Flow__mdt docTypeFlow1=[select Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,Subscriber_Only__c from Document_Type_Flow__mdt where Flow__c ='Producer'and Is_Member_Focus__c = true and WS_Primary_Address_Type__c!=null Limit 1];
     try{
     acetComSerCntr.findProducerInfo(docTypeFlow);
     }catch(exception ex){}
     acetComSerCntr.getProfileName();
     Test.stopTest();
   }
    static testMethod void testMemInfo(){
    
    Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '123456789';
        insert cont;
    
    Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';       
        insert interaction;
        
        ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetIndividuakHttpCalloutMock());
ApexPages.currentPage().getParameters().put('SRK','testsrk');
ApexPages.currentPage().getParameters().put('memberId','testmemberId');
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Backup_Address_Type__c, WS_Primary_Address_Type__c from Document_Type_Flow__mdt where WS_Primary_Address_Type__c!=null Limit 1];

try{

  acetFrmsHisCntr.findMemberInfo(docTypeFlow3);

}catch(Exception ex){}
    Test.stopTest();
}
    static testMethod void testMemInfo1point5(){
    
    Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '123456789';
        insert cont;
    
    Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';       
        insert interaction;
        
        ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
        Test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"2015-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"MAIL","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
ApexPages.currentPage().getParameters().put('SRK','testsrk');
ApexPages.currentPage().getParameters().put('memberId','testmemberId');
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Backup_Address_Type__c, WS_Primary_Address_Type__c, Subscriber_Only__c from Document_Type_Flow__mdt where Subscriber_Only__c=true Limit 1];

try{

  acetFrmsHisCntr.findMemberInfo(docTypeFlow3);

}catch(Exception ex){}
    Test.stopTest();
}
    
    static testMethod void testMemInfo2(){
MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"2015-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"MAIL","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ApexPages.currentPage().getParameters().put('SRK','testsrk');
ApexPages.currentPage().getParameters().put('memberId','testmemberId');
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Backup_Address_Type__c, WS_Primary_Address_Type__c from Document_Type_Flow__mdt where WS_Primary_Address_Type__c!=null Limit 1];

try{

  acetFrmsHisCntr.findMemberInfo(docTypeFlow3);

}catch(Exception ex){}

}
    static testMethod void testMemInfo3(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"1980-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.MemberId = '123456';
        String addinfojson = JSON.serialize(addinfo);
        
        ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
        ApexPages.currentPage().getParameters().put('SRK','testsrk');
ApexPages.currentPage().getParameters().put('memberId','testmemberId');
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Backup_Address_Type__c, WS_Primary_Address_Type__c from Document_Type_Flow__mdt where WS_Primary_Address_Type__c!=null Limit 1];

try{

  acetFrmsHisCntr.findMemberInfo(docTypeFlow3);

}catch(Exception ex){}

}
static testMethod void testGroupInfo(){
    Test.setMock(HttpCalloutMock.class, new FindGroupInfoHttpCalloutMock());
    ApexPages.currentPage().getParameters().put('groupID','');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.groupn = '123456789123456789';
        String addinfojson = JSON.serialize(addinfo);
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
    try{
      acetFrmsHisCntr.findGroupInfo();
     }catch(Exception ex){}
}

    static testMethod void testGroupInfo2(){
    Test.setMock(HttpCalloutMock.class, new FindGroupInfoMockCorpAdd());
        ApexPages.currentPage().getParameters().put('groupID','');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.groupn = '123456789123456789';
        String addinfojson = JSON.serialize(addinfo);
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
    try{
      acetFrmsHisCntr.findGroupInfo();
     }catch(Exception ex){}
}

static testMethod void testProducerInfo(){  
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"response": { "serviceAttributes":{"applicationIdentifier": "IVR","requestIdentifier": "2d537d12-b1fd-4d7a-b990-40dfb1c23426","responseCode": "200","responseDescription": "Success:Trace of all the success calls","totalNumberOfRecords": "9","pageNumber": "","recordsPerPage": ""},"getProducerResponse":{"producerID": "167106","memberGroupDetails":[{"groupNumber": "2100105","groupName": "10404 - Scenario 5 "},{"groupNumber": "9786013","groupName": "SB UHG Scenario 4"},{"groupNumber": "1110176","groupName": "UHG SHOP Test contract 26"},{"groupNumber": "5110301","groupName": "Test UHG contract 31"},{"groupNumber": "1110111","groupName": "UHG SHOP Test contract 15"},{"groupNumber": "9966214","groupName": "Test contract 2"},{"groupNumber": "9966231","groupName": "Test contract 2"},{"groupNumber": "7676005","groupName": "SB UHG Scenario 1"},{"groupNumber": "8110400","groupName": "Test UHG PR contract 1"}],"producerCompanyName": "","producerName":{"firstName": "SAMUEL","middleInitial": "J","lastName": "GRUBBS"},"producerTIN": "","producerSSN": "987167106","producerType": "I ","type": "BR","producerContact": " ","producerEffectiveStartDate": "08/23/2007","producerEffectiveEndDate": "12/31/2016","producerAddress":{"addressTypeCode": "Corporate","addressLine1": "647 LUVERNE AVE","addressLine2": "","city": "PANAMA CITY","state": "FL","zipCode": "32401","country": "","phoneNumber": "8507695215"},"producerStatus": "InActive","legacyBrokerCode": ""}}}');        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
    ApexPages.currentPage().getParameters().put('producerId','testprodid');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.producerId = '123456789123456789';
        String addinfojson = JSON.serialize(addinfo);
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
    
    Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Primary_Address_Type__c,WS_Backup_Address_Type__c from Document_Type_Flow__mdt where WS_Backup_Address_Type__c='Corporate' limit 1];
    try{
    
      acetFrmsHisCntr.findProducerInfo(docTypeFlow3);
     }catch(Exception ex){}
}
   static testMethod void testProducerInfo2(){  
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"response": { "serviceAttributes":{"applicationIdentifier": "IVR","requestIdentifier": "2d537d12-b1fd-4d7a-b990-40dfb1c23426","responseCode": "200","responseDescription": "Success:Trace of all the success calls","totalNumberOfRecords": "9","pageNumber": "","recordsPerPage": ""},"getProducerResponse":{"producerID": "167106","memberGroupDetails":[{"groupNumber": "2100105","groupName": "10404 - Scenario 5 "},{"groupNumber": "9786013","groupName": "SB UHG Scenario 4"},{"groupNumber": "1110176","groupName": "UHG SHOP Test contract 26"},{"groupNumber": "5110301","groupName": "Test UHG contract 31"},{"groupNumber": "1110111","groupName": "UHG SHOP Test contract 15"},{"groupNumber": "9966214","groupName": "Test contract 2"},{"groupNumber": "9966231","groupName": "Test contract 2"},{"groupNumber": "7676005","groupName": "SB UHG Scenario 1"},{"groupNumber": "8110400","groupName": "Test UHG PR contract 1"}],"producerCompanyName": "","producerName":{"firstName": "SAMUEL","middleInitial": "J","lastName": "GRUBBS"},"producerTIN": "","producerSSN": "987167106","producerType": "I ","type": "BR","producerContact": " ","producerEffectiveStartDate": "08/23/2007","producerEffectiveEndDate": "12/31/2016","producerAddress":{"addressTypeCode": "Physical","addressLine1": "647 LUVERNE AVE","addressLine2": "","city": "PANAMA CITY","state": "FL","zipCode": "32401","country": "","phoneNumber": "8507695215"},"producerStatus": "InActive","legacyBrokerCode": ""}}}');        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
    ApexPages.currentPage().getParameters().put('producerId','testprodid');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.producerId = '123456789123456789';
        String addinfojson = JSON.serialize(addinfo);                     ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        
        ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
    
    Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Primary_Address_Type__c,WS_Backup_Address_Type__c from Document_Type_Flow__mdt where WS_Primary_Address_Type__c='Physical' limit 1];
    try{
    
      acetFrmsHisCntr.findProducerInfo(docTypeFlow3);
     }catch(Exception ex){}
} 

static testMethod void testProviderInfo(){
    Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '123456789';
        insert cont;
    
    Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';       
        insert interaction;
        
        ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
        ApexPages.currentPage().getParameters().put('DocId','7f183de6');
        ApexPages.currentPage().getParameters().put('docType','ACET Letter');
        ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
        ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
        ApexPages.currentPage().getParameters().put('idCard','7f183de6');
        ApexPages.currentPage().getParameters().put('SRK','');
    
    Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Primary_Address_Type__c,WS_Backup_Address_Type__c from Document_Type_Flow__mdt where WS_Backup_Address_Type__c='PRAC'  Limit 1];
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findMedicalHealthcareProfessionalsResponse":{"medicalHealthcareProfessionals":[{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1452423907049","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"790 CENTRAL AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06607","postalSuffixCode":"1705","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.178137","longitude":"-73.165412","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1452423907049","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3324567"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568971","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1452423907051","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"82 GEORGE ST","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06604","postalSuffixCode":"3315","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.18707","longitude":"-73.195653","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1452423907051","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"5763881"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568959","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1452423907052","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"727 HONEYSPOT RD","city":"STRATFORD","stateCode":"CT","postalPrefixCode":"06615","postalSuffixCode":"7172","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.175551","longitude":"-73.147027","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1452423907052","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3757242"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568940","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1456783007990","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"805 ATLANTIC ST","city":"STAMFORD","stateCode":"CT","postalPrefixCode":"06902","postalSuffixCode":"6805","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.04305","longitude":"-73.541632","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1456783007990","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3275111"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568955","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1456787702845","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"64 BLACK ROCK AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06605","postalSuffixCode":"1200","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.17127","longitude":"-73.197185","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1456787702845","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"5795000"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568949","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"681845240406789881","addressTypeCode":"BIL"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"471 BARNUM AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"2409","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187248","longitude":"-73.180255","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"BIL","addressId":"681845240406789881","primaryIndicator":"N","handicapAccessibleIndicator":"N"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3333030"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568969","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"681845240406789881","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"471 BARNUM AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"2409","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187248","longitude":"-73.180255","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"681845240406789881","primaryIndicator":"Y","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"FAX","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6963261"},{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3333030"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568969","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"682845240406790439","addressTypeCode":"BIL"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"982 E MAIN ST","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"1913","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187938","longitude":"-73.18058","statusCode":"A","effectiveDate":"2014-01-01","cancelDate":"9999-12-31","typeCode":"BIL","addressId":"682845240406790439","primaryIndicator":"N","handicapAccessibleIndicator":"N"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6963260"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568965","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"682845240406790439","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"982 E MAIN ST","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"1913","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187938","longitude":"-73.18058","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"682845240406790439","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6963260"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568965","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"744145240281030923","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"1351 WASHINGTON BLVD","city":"STAMFORD","stateCode":"CT","postalPrefixCode":"06902","postalSuffixCode":"2419","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.058096","longitude":"-73.543132","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"744145240281030923","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6213700"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568953","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]}],"pagination":{"pageNumber":"0","pageSize":"50","recordCount":"10","totalCount":"10","totalPages":"1"}}}');
    OILResponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
   Test.startTest();
    Test.setMock(HttpCalloutMock.class, MockHttpRes);
    ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');
                                                                                                                   
    ApexPages.currentPage().getParameters().put('ProvTypeCode','testprovtcode');
    ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
      try{
      acetFrmsHisCntr.findProviderInfo(docTypeFlow3);
     }catch(Exception ex){}
    Test.stopTest();                                                                                                      
}
                                                                                                                          
static testMethod void testProviderInfoBIL(){
    Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '123456789';
        insert cont;
    
    Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';      
        insert interaction;
        
        ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
        ApexPages.currentPage().getParameters().put('DocId','7f183de6');
        ApexPages.currentPage().getParameters().put('docType','ACET Letter');
        ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
        ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
        ApexPages.currentPage().getParameters().put('idCard','7f183de6');
        ApexPages.currentPage().getParameters().put('SRK','');
    
    Document_Type_Flow__mdt docTypeFlow3=[select id,WS_Primary_Address_Type__c,WS_Backup_Address_Type__c from Document_Type_Flow__mdt where WS_Primary_Address_Type__c='BIL'  Limit 1];
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findMedicalHealthcareProfessionalsResponse":{"medicalHealthcareProfessionals":[{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1452423907049","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"790 CENTRAL AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06607","postalSuffixCode":"1705","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.178137","longitude":"-73.165412","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1452423907049","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3324567"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568971","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1452423907051","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"82 GEORGE ST","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06604","postalSuffixCode":"3315","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.18707","longitude":"-73.195653","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1452423907051","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"5763881"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568959","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1452423907052","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"727 HONEYSPOT RD","city":"STRATFORD","stateCode":"CT","postalPrefixCode":"06615","postalSuffixCode":"7172","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.175551","longitude":"-73.147027","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1452423907052","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3757242"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568940","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1456783007990","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"805 ATLANTIC ST","city":"STAMFORD","stateCode":"CT","postalPrefixCode":"06902","postalSuffixCode":"6805","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.04305","longitude":"-73.541632","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1456783007990","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3275111"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568955","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"1456787702845","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"64 BLACK ROCK AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06605","postalSuffixCode":"1200","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.17127","longitude":"-73.197185","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"1456787702845","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"5795000"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568949","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"681845240406789881","addressTypeCode":"BIL"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"471 BARNUM AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"2409","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187248","longitude":"-73.180255","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"BIL","addressId":"681845240406789881","primaryIndicator":"N","handicapAccessibleIndicator":"N"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3333030"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568969","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"681845240406789881","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"471 BARNUM AVE","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"2409","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187248","longitude":"-73.180255","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"681845240406789881","primaryIndicator":"Y","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"FAX","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6963261"},{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"3333030"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568969","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"682845240406790439","addressTypeCode":"BIL"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"982 E MAIN ST","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"1913","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187938","longitude":"-73.18058","statusCode":"A","effectiveDate":"2014-01-01","cancelDate":"9999-12-31","typeCode":"BIL","addressId":"682845240406790439","primaryIndicator":"N","handicapAccessibleIndicator":"N"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6963260"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568965","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"682845240406790439","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"982 E MAIN ST","city":"BRIDGEPORT","stateCode":"CT","postalPrefixCode":"06608","postalSuffixCode":"1913","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.187938","longitude":"-73.18058","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"682845240406790439","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6963260"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568965","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]},{"key":{"providerId":"816348545285632239","providerTINId":"060972266","providerTINTypeCode":"TIN","addressId":"744145240281030923","addressTypeCode":"PRAC"},"hcp":{"providerStatusCode":"A","providerStatusEffectiveDate":"2007-01-01","providerStatusCancelDate":"9999-12-31","providerId":"816348545285632239","providerLastName":"ADIMANDO","providerFirstName":"ANDREA","providerBirthDate":"1978-01-28","providerGenderCode":"F"},"role":[{"statusCode":"A","effectiveDate":"2016-10-01","cancelDate":"9999-12-31"}],"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"060972266","typeCode":"TIN","owner":"OPTIMUS HEALTH CARE"},"tpsm":[{"statusCode":"A","statusEffectiveDate":"2016-04-22","statusCancelDate":"9999-12-31","code":"99Z"}],"npi":[{"statusCode":"A","effectiveDate":"2008-03-28","cancelDate":"9999-12-31","id":"1801936448","validationDate":"0001-01-01"}],"contract":[{"businessSegmentCode":"E&I","contractStatusCode":"A","networkIds":["1018476"],"contractClaimTypes":["Behavioral"]}],"specialty":[{"statusCode":"I","effectiveDate":"1985-10-01","cancelDate":"2017-09-12","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YP2500X","typeDescription":"Counselor~Professional"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YS0200X","typeDescription":"Counselor~School"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101YM0800X","typeDescription":"Counselor~Mental Health"},{"statusCode":"A","effectiveDate":"2009-02-11","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"101Y00000X","typeDescription":"Counselor~"},{"statusCode":"A","effectiveDate":"2008-08-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"363LP0808X","typeDescription":"Nurse Practitioner~Psych/Mental Health"},{"statusCode":"A","effectiveDate":"1985-10-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"163WP0808X","typeDescription":"Registered Nurse~Psych/Mental Health"}],"address":{"addressLine1":"1351 WASHINGTON BLVD","city":"STAMFORD","stateCode":"CT","postalPrefixCode":"06902","postalSuffixCode":"2419","countyCode":"001","countyDescription":"Fairfield County","countryCode":"US","benefitServiceAreas":["OXFORD_TRI_STATE","OXFORD_CT"],"latitude":"41.058096","longitude":"-73.543132","statusCode":"A","effectiveDate":"2012-12-28","cancelDate":"9999-12-31","typeCode":"PRAC","addressId":"744145240281030923","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"203","phoneNumber":"6213700"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}],"premiumDesignation":[{"effectiveDate":"0001-01-01","cancelDate":"0001-01-01"}],"degree":[{"statusCode":"ACTV","primaryIndicator":"N","code":"NP","schoolName":"No School Code","completionDate":"0001-01-01"},{"statusCode":"ACTV","primaryIndicator":"Y","code":"MS","schoolName":"No School Code","completionDate":"0001-01-01"}],"providerLocationAffiliations":[{"id":"27568953","healthcareOrganizationID":"518645238423773367","effectiveDate":"2015-08-30","cancelDate":"9999-12-31","statusCode":"A"}]}],"pagination":{"pageNumber":"0","pageSize":"50","recordCount":"10","totalCount":"10","totalPages":"1"}}}');
    OILResponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, MockHttpRes);
    ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');
                                                                                                              
    ApexPages.currentPage().getParameters().put('ProvTypeCode','testprovtcode');
    ACETCommunicationSearchController acetFrmsHisCntr=new ACETCommunicationSearchController();
      try{
      acetFrmsHisCntr.findProviderInfo(docTypeFlow3);
     }catch(Exception ex){}
    Test.stopTest();                                                                                                      
}
    static testMethod void testFindDocService(){
         ACETFindDocWebservice service = new ACETFindDocWebservice();
         ACETFindDocWebservice.documentKey key = new ACETFindDocWebservice.documentKey();
         key.value = '112077';
         key.name = 'u_mbr_id';
         key.dataTypeIndicator = 'string';
         key.operator = '=';
         List<ACETFindDocWebservice.documentKey> findDocKeys = new List<ACETFindDocWebservice.documentKey>();
         findDocKeys.add(key);
         service.init('u_clinical_docs', findDocKeys);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindDocWebserviceResponse());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
         Test.setMock(HttpCalloutMock.class, MockHttpRes1);           
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'Resource Not Found', ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
         OILResponse2.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
         Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
         OILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes3); 
         service.queryPaginatedData(1,1,1);
        String error = '{"errors":{"errors":[{"title":"Not Found","status":404,"description":"u_enrl_lt docclass is invalid"}]}}';
        HttpResponse resp = new HttpResponse();
        resp.setBody(error);
        ACETFindDocWebservice.parseFailureData(resp);
 
    }
    
    static testmethod void finddoctest()
    {
        
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
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findDocumentsResponse":{"findDocumentsResponseType":{"documentList":{"document":[{"repositoryId":"PSEUDO1","repositoryName":"EDMS","documentId":"0902b1fe80425e2e","documentClass":"u_oxf_pra","documentKeys":{"documentKey":[{"name":"a_controlling_app","value":"","dataTypeIndicator":"string"},{"name":"a_is_hidden","value":"false","dataTypeIndicator":"boolean"},{"name":"a_archive","value":"false","dataTypeIndicator":"boolean"},{"name":"keywords","value":"","dataTypeIndicator":"string"},{"name":"subject","value":"","dataTypeIndicator":"string"},{"name":"cmis:createdBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"a_full_text","value":"false","dataTypeIndicator":"boolean"},{"name":"a_compound_architecture","value":"","dataTypeIndicator":"string"},{"name":"language_code","value":"","dataTypeIndicator":"string"},{"name":"cmis:isMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:contentStreamFileName","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101.pdf","dataTypeIndicator":"string"},{"name":"r_has_events","value":"false","dataTypeIndicator":"boolean"},{"name":"r_lock_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_current_state","value":"0","dataTypeIndicator":"integer"},{"name":"u_legal_hold","value":"Inactive","dataTypeIndicator":"string"},{"name":"group_permit","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:contentStreamLength","value":"1","dataTypeIndicator":"integer"},{"name":"r_link_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"a_status","value":"","dataTypeIndicator":"string"},{"name":"r_policy_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_lock_machine","value":"","dataTypeIndicator":"string"},{"name":"a_effective_label","value":"","dataTypeIndicator":"string"},{"name":"owner_name","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"group_name","value":"","dataTypeIndicator":"string"},{"name":"a_link_resolved","value":"false","dataTypeIndicator":"boolean"},{"name":"a_category","value":"","dataTypeIndicator":"string"},{"name":"u_primary_nbr","value":"","dataTypeIndicator":"string"},{"name":"cmis:contentStreamMimeType","value":"application/pdf","dataTypeIndicator":"string"},{"name":"a_special_app","value":"","dataTypeIndicator":"string"},{"name":"cmis:baseTypeId","value":"cmis:document","dataTypeIndicator":"id"},{"name":"r_frzn_assembly_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"r_component_label","value":"","dataTypeIndicator":"string"},{"name":"resolution_label","value":"","dataTypeIndicator":"string"},{"name":"a_effective_flag","value":"","dataTypeIndicator":"string"},{"name":"acl_domain","value":"EDMDCM08","dataTypeIndicator":"string"},{"name":"acl_name","value":"u_oxf_pra_acl","dataTypeIndicator":"string"},{"name":"a_is_signed","value":"false","dataTypeIndicator":"boolean"},{"name":"u_ingestion_dt","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_application_type","value":"","dataTypeIndicator":"string"},{"name":"a_storage_type","value":"PRO_Archiver","dataTypeIndicator":"string"},{"name":"cmis:isLatestMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutId","value":"","dataTypeIndicator":"id"},{"name":"r_page_cnt","value":"1","dataTypeIndicator":"integer"},{"name":"authors","value":"","dataTypeIndicator":"string"},{"name":"r_alias_set_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_composite_id","value":"","dataTypeIndicator":"id"},{"name":"r_assembled_from_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_content_size","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:isImmutable","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionLabel","value":"1.0","dataTypeIndicator":"string"},{"name":"cmis:checkinComment","value":"","dataTypeIndicator":"string"},{"name":"title","value":"","dataTypeIndicator":"string"},{"name":"cmis:creationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_expiration_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_order_no","value":"","dataTypeIndicator":"integer"},{"name":"a_extended_properties","value":"","dataTypeIndicator":"string"},{"name":"cmis:name","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101","dataTypeIndicator":"string"},{"name":"r_is_virtual_doc","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isLatestVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"r_frozen_flag","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:lastModificationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"owner_permit","value":"7","dataTypeIndicator":"integer"},{"name":"a_last_review_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_aspect_name","value":"","dataTypeIndicator":"string"},{"name":"u_primary_dt","value":"","dataTypeIndicator":"datetime"},{"name":"cmis:lastModifiedBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"r_access_date","value":"2017-10-27T19:52:29.000Z","dataTypeIndicator":"datetime"},{"name":"cmis:contentStreamId","value":"0602b1fe80463d88","dataTypeIndicator":"id"},{"name":"a_effective_date","value":"","dataTypeIndicator":"datetime"},{"name":"a_is_template","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:changeToken","value":"2","dataTypeIndicator":"string"},{"name":"r_is_public","value":"false","dataTypeIndicator":"boolean"},{"name":"r_composite_label","value":"","dataTypeIndicator":"string"},{"name":"r_link_high_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isVersionSeriesCheckedOut","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutBy","value":"","dataTypeIndicator":"string"},{"name":"world_permit","value":"1","dataTypeIndicator":"integer"},{"name":"a_retention_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_has_frzn_assembly","value":"false","dataTypeIndicator":"boolean"},{"name":"u_document_id","value":"0902b1fe80425e2e","dataTypeIndicator":"string"},{"name":"a_publish_formats","value":"","dataTypeIndicator":"string"},{"name":"r_resume_state","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:versionSeriesId","value":"0902b1fe80425e2e","dataTypeIndicator":"id"},{"name":"u_check_folder","value":"true","dataTypeIndicator":"boolean"},{"name":"u_mbr_id","value":"39488083500|80718377300|84374968100|81456178900","dataTypeIndicator":"string"},{"name":"u_pay_nbr","value":"254341","dataTypeIndicator":"string"},{"name":"u_clm_nbr","value":"MW18822224|MS33932015|MH90978355|MH43799886|MS33931101","dataTypeIndicator":"string"},{"name":"u_prov_tin","value":"720881569","dataTypeIndicator":"string"},{"name":"u_srs_desg_cd","value":"WB","dataTypeIndicator":"string"},{"name":"u_dt_srvc","value":"2017-09-24T05:00:00.000Z|2017-09-23T05:00:00.000Z|2017-09-22T05:00:00.000Z|2017-09-13T05:00:00.000Z|2017-09-12T05:00:00.000Z|2017-09-11T05:00:00.000Z|2017-04-24T05:00:00.000Z|2017-04-23T05:00:00.000Z|2017-04-21T05:00:00.000Z|2017-04-22T05:00:00.000Z|2017-09-21T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_pay_cyc_dt","value":"2017-10-12T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_mbr_lst_nm","value":"TAYLOR|MILLER|ANDERSON|WILSON","dataTypeIndicator":"string"},{"name":"u_mbr_fst_nm","value":"ALEC|ALBERTO|ALEJANDRO|ALDEN","dataTypeIndicator":"string"},{"name":"u_pra_doc_typ_cd","value":"RA","dataTypeIndicator":"string"},{"name":"u_flfl_req_head_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_nm","value":"NA","dataTypeIndicator":"string"}]}}]},"pagination":{"maxRecords":"250","pageNumber":"1","pageSize":"25","recordCount":"1","moreRecords":"false"}}}}');
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);    
        ACETFindDocWebservice ac1=new ACETFindDocWebservice();
        //Calling the void method's
        ac1.GetEndpoint();
        ac1.GetMethod();
        
        ACETWSCalloutResult res =ac1.querypaginateddata(1,50,1);
    }
    
    static testmethod void finddoctest1()
    {
        
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
        mapISLWSConfigs.put('dev_FindDocument', '/api/alpha/ccs/eisl/documents/v4.0/search'); 
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        ACETFindDocWebservice.DocumentKey dockey = new ACETFindDocWebservice.DocumentKey();
        List<ACETFindDocWebservice.DocumentKey> dockeylist = new List<ACETFindDocWebservice.DocumentKey>();
        dockey.dataTypeIndicator = 'string';
        dockey.operator = '=';
        dockey.Value = '123';
        dockey.name = 'test';
        dockeylist.add(dockey);
       
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findDocumentsResponse":{"findDocumentsResponseType":{"documentList":{"document":[{"repositoryId":"PSEUDO1","repositoryName":"EDMS","documentId":"0902b1fe80425e2e","documentClass":"u_oxf_pra","documentKeys":{"documentKey":[{"name":"a_controlling_app","value":"","dataTypeIndicator":"string"},{"name":"a_is_hidden","value":"false","dataTypeIndicator":"boolean"},{"name":"a_archive","value":"false","dataTypeIndicator":"boolean"},{"name":"keywords","value":"","dataTypeIndicator":"string"},{"name":"subject","value":"","dataTypeIndicator":"string"},{"name":"cmis:createdBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"a_full_text","value":"false","dataTypeIndicator":"boolean"},{"name":"a_compound_architecture","value":"","dataTypeIndicator":"string"},{"name":"language_code","value":"","dataTypeIndicator":"string"},{"name":"cmis:isMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:contentStreamFileName","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101.pdf","dataTypeIndicator":"string"},{"name":"r_has_events","value":"false","dataTypeIndicator":"boolean"},{"name":"r_lock_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_current_state","value":"0","dataTypeIndicator":"integer"},{"name":"u_legal_hold","value":"Inactive","dataTypeIndicator":"string"},{"name":"group_permit","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:contentStreamLength","value":"1","dataTypeIndicator":"integer"},{"name":"r_link_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"a_status","value":"","dataTypeIndicator":"string"},{"name":"r_policy_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_lock_machine","value":"","dataTypeIndicator":"string"},{"name":"a_effective_label","value":"","dataTypeIndicator":"string"},{"name":"owner_name","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"group_name","value":"","dataTypeIndicator":"string"},{"name":"a_link_resolved","value":"false","dataTypeIndicator":"boolean"},{"name":"a_category","value":"","dataTypeIndicator":"string"},{"name":"u_primary_nbr","value":"","dataTypeIndicator":"string"},{"name":"cmis:contentStreamMimeType","value":"application/pdf","dataTypeIndicator":"string"},{"name":"a_special_app","value":"","dataTypeIndicator":"string"},{"name":"cmis:baseTypeId","value":"cmis:document","dataTypeIndicator":"id"},{"name":"r_frzn_assembly_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"r_component_label","value":"","dataTypeIndicator":"string"},{"name":"resolution_label","value":"","dataTypeIndicator":"string"},{"name":"a_effective_flag","value":"","dataTypeIndicator":"string"},{"name":"acl_domain","value":"EDMDCM08","dataTypeIndicator":"string"},{"name":"acl_name","value":"u_oxf_pra_acl","dataTypeIndicator":"string"},{"name":"a_is_signed","value":"false","dataTypeIndicator":"boolean"},{"name":"u_ingestion_dt","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_application_type","value":"","dataTypeIndicator":"string"},{"name":"a_storage_type","value":"PRO_Archiver","dataTypeIndicator":"string"},{"name":"cmis:isLatestMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutId","value":"","dataTypeIndicator":"id"},{"name":"r_page_cnt","value":"1","dataTypeIndicator":"integer"},{"name":"authors","value":"","dataTypeIndicator":"string"},{"name":"r_alias_set_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_composite_id","value":"","dataTypeIndicator":"id"},{"name":"r_assembled_from_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_content_size","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:isImmutable","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionLabel","value":"1.0","dataTypeIndicator":"string"},{"name":"cmis:checkinComment","value":"","dataTypeIndicator":"string"},{"name":"title","value":"","dataTypeIndicator":"string"},{"name":"cmis:creationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_expiration_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_order_no","value":"","dataTypeIndicator":"integer"},{"name":"a_extended_properties","value":"","dataTypeIndicator":"string"},{"name":"cmis:name","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101","dataTypeIndicator":"string"},{"name":"r_is_virtual_doc","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isLatestVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"r_frozen_flag","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:lastModificationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"owner_permit","value":"7","dataTypeIndicator":"integer"},{"name":"a_last_review_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_aspect_name","value":"","dataTypeIndicator":"string"},{"name":"u_primary_dt","value":"","dataTypeIndicator":"datetime"},{"name":"cmis:lastModifiedBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"r_access_date","value":"2017-10-27T19:52:29.000Z","dataTypeIndicator":"datetime"},{"name":"cmis:contentStreamId","value":"0602b1fe80463d88","dataTypeIndicator":"id"},{"name":"a_effective_date","value":"","dataTypeIndicator":"datetime"},{"name":"a_is_template","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:changeToken","value":"2","dataTypeIndicator":"string"},{"name":"r_is_public","value":"false","dataTypeIndicator":"boolean"},{"name":"r_composite_label","value":"","dataTypeIndicator":"string"},{"name":"r_link_high_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isVersionSeriesCheckedOut","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutBy","value":"","dataTypeIndicator":"string"},{"name":"world_permit","value":"1","dataTypeIndicator":"integer"},{"name":"a_retention_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_has_frzn_assembly","value":"false","dataTypeIndicator":"boolean"},{"name":"u_document_id","value":"0902b1fe80425e2e","dataTypeIndicator":"string"},{"name":"a_publish_formats","value":"","dataTypeIndicator":"string"},{"name":"r_resume_state","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:versionSeriesId","value":"0902b1fe80425e2e","dataTypeIndicator":"id"},{"name":"u_check_folder","value":"true","dataTypeIndicator":"boolean"},{"name":"u_mbr_id","value":"39488083500|80718377300|84374968100|81456178900","dataTypeIndicator":"string"},{"name":"u_pay_nbr","value":"254341","dataTypeIndicator":"string"},{"name":"u_clm_nbr","value":"MW18822224|MS33932015|MH90978355|MH43799886|MS33931101","dataTypeIndicator":"string"},{"name":"u_prov_tin","value":"720881569","dataTypeIndicator":"string"},{"name":"u_srs_desg_cd","value":"WB","dataTypeIndicator":"string"},{"name":"u_dt_srvc","value":"2017-09-24T05:00:00.000Z|2017-09-23T05:00:00.000Z|2017-09-22T05:00:00.000Z|2017-09-13T05:00:00.000Z|2017-09-12T05:00:00.000Z|2017-09-11T05:00:00.000Z|2017-04-24T05:00:00.000Z|2017-04-23T05:00:00.000Z|2017-04-21T05:00:00.000Z|2017-04-22T05:00:00.000Z|2017-09-21T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_pay_cyc_dt","value":"2017-10-12T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_mbr_lst_nm","value":"TAYLOR|MILLER|ANDERSON|WILSON","dataTypeIndicator":"string"},{"name":"u_mbr_fst_nm","value":"ALEC|ALBERTO|ALEJANDRO|ALDEN","dataTypeIndicator":"string"},{"name":"u_pra_doc_typ_cd","value":"RA","dataTypeIndicator":"string"},{"name":"u_flfl_req_head_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_nm","value":"NA","dataTypeIndicator":"string"}]}}]},"pagination":{"maxRecords":"250","pageNumber":"1","pageSize":"25","recordCount":"1","moreRecords":"false"}}}}');
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);    
        ACETFindDocWebservice ac1=new ACETFindDocWebservice();
        ac1.documenttype = 'IDCARDS';
        
        ac1.DocumentKeys = dockeylist;
        //Calling the void method's
        ac1.GetEndpoint();
        ac1.GetMethod();
        
        test.startTest();
        ACETWSCalloutResult res =ac1.querypaginateddata(1,50,1);
        test.stopTest();
    }
    
    static testmethod void finddoctest2()
    {
        
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
        
        ACETFindDocWebservice.DocumentKey dockey = new ACETFindDocWebservice.DocumentKey();
        List<ACETFindDocWebservice.DocumentKey> dockeylist = new List<ACETFindDocWebservice.DocumentKey>();
        dockey.dataTypeIndicator = 'Datetime';
        dockey.operator = '=';
        dockey.Value = '123';
        dockey.name = 'test';
        dockeylist.add(dockey);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findDocumentsResponse":{"findDocumentsResponseType":{"documentList":{"document":[{"repositoryId":"PSEUDO1","repositoryName":"EDMS","documentId":"0902b1fe80425e2e","documentClass":"u_oxf_pra","documentKeys":{"documentKey":[{"name":"a_controlling_app","value":"","dataTypeIndicator":"string"},{"name":"a_is_hidden","value":"false","dataTypeIndicator":"boolean"},{"name":"a_archive","value":"false","dataTypeIndicator":"boolean"},{"name":"keywords","value":"","dataTypeIndicator":"string"},{"name":"subject","value":"","dataTypeIndicator":"string"},{"name":"cmis:createdBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"a_full_text","value":"false","dataTypeIndicator":"boolean"},{"name":"a_compound_architecture","value":"","dataTypeIndicator":"string"},{"name":"language_code","value":"","dataTypeIndicator":"string"},{"name":"cmis:isMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:contentStreamFileName","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101.pdf","dataTypeIndicator":"string"},{"name":"r_has_events","value":"false","dataTypeIndicator":"boolean"},{"name":"r_lock_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_current_state","value":"0","dataTypeIndicator":"integer"},{"name":"u_legal_hold","value":"Inactive","dataTypeIndicator":"string"},{"name":"group_permit","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:contentStreamLength","value":"1","dataTypeIndicator":"integer"},{"name":"r_link_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"a_status","value":"","dataTypeIndicator":"string"},{"name":"r_policy_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_lock_machine","value":"","dataTypeIndicator":"string"},{"name":"a_effective_label","value":"","dataTypeIndicator":"string"},{"name":"owner_name","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"group_name","value":"","dataTypeIndicator":"string"},{"name":"a_link_resolved","value":"false","dataTypeIndicator":"boolean"},{"name":"a_category","value":"","dataTypeIndicator":"string"},{"name":"u_primary_nbr","value":"","dataTypeIndicator":"string"},{"name":"cmis:contentStreamMimeType","value":"application/pdf","dataTypeIndicator":"string"},{"name":"a_special_app","value":"","dataTypeIndicator":"string"},{"name":"cmis:baseTypeId","value":"cmis:document","dataTypeIndicator":"id"},{"name":"r_frzn_assembly_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"r_component_label","value":"","dataTypeIndicator":"string"},{"name":"resolution_label","value":"","dataTypeIndicator":"string"},{"name":"a_effective_flag","value":"","dataTypeIndicator":"string"},{"name":"acl_domain","value":"EDMDCM08","dataTypeIndicator":"string"},{"name":"acl_name","value":"u_oxf_pra_acl","dataTypeIndicator":"string"},{"name":"a_is_signed","value":"false","dataTypeIndicator":"boolean"},{"name":"u_ingestion_dt","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_application_type","value":"","dataTypeIndicator":"string"},{"name":"a_storage_type","value":"PRO_Archiver","dataTypeIndicator":"string"},{"name":"cmis:isLatestMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutId","value":"","dataTypeIndicator":"id"},{"name":"r_page_cnt","value":"1","dataTypeIndicator":"integer"},{"name":"authors","value":"","dataTypeIndicator":"string"},{"name":"r_alias_set_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_composite_id","value":"","dataTypeIndicator":"id"},{"name":"r_assembled_from_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_content_size","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:isImmutable","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionLabel","value":"1.0","dataTypeIndicator":"string"},{"name":"cmis:checkinComment","value":"","dataTypeIndicator":"string"},{"name":"title","value":"","dataTypeIndicator":"string"},{"name":"cmis:creationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_expiration_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_order_no","value":"","dataTypeIndicator":"integer"},{"name":"a_extended_properties","value":"","dataTypeIndicator":"string"},{"name":"cmis:name","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101","dataTypeIndicator":"string"},{"name":"r_is_virtual_doc","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isLatestVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"r_frozen_flag","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:lastModificationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"owner_permit","value":"7","dataTypeIndicator":"integer"},{"name":"a_last_review_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_aspect_name","value":"","dataTypeIndicator":"string"},{"name":"u_primary_dt","value":"","dataTypeIndicator":"datetime"},{"name":"cmis:lastModifiedBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"r_access_date","value":"2017-10-27T19:52:29.000Z","dataTypeIndicator":"datetime"},{"name":"cmis:contentStreamId","value":"0602b1fe80463d88","dataTypeIndicator":"id"},{"name":"a_effective_date","value":"","dataTypeIndicator":"datetime"},{"name":"a_is_template","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:changeToken","value":"2","dataTypeIndicator":"string"},{"name":"r_is_public","value":"false","dataTypeIndicator":"boolean"},{"name":"r_composite_label","value":"","dataTypeIndicator":"string"},{"name":"r_link_high_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isVersionSeriesCheckedOut","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutBy","value":"","dataTypeIndicator":"string"},{"name":"world_permit","value":"1","dataTypeIndicator":"integer"},{"name":"a_retention_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_has_frzn_assembly","value":"false","dataTypeIndicator":"boolean"},{"name":"u_document_id","value":"0902b1fe80425e2e","dataTypeIndicator":"string"},{"name":"a_publish_formats","value":"","dataTypeIndicator":"string"},{"name":"r_resume_state","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:versionSeriesId","value":"0902b1fe80425e2e","dataTypeIndicator":"id"},{"name":"u_check_folder","value":"true","dataTypeIndicator":"boolean"},{"name":"u_mbr_id","value":"39488083500|80718377300|84374968100|81456178900","dataTypeIndicator":"string"},{"name":"u_pay_nbr","value":"254341","dataTypeIndicator":"string"},{"name":"u_clm_nbr","value":"MW18822224|MS33932015|MH90978355|MH43799886|MS33931101","dataTypeIndicator":"string"},{"name":"u_prov_tin","value":"720881569","dataTypeIndicator":"string"},{"name":"u_srs_desg_cd","value":"WB","dataTypeIndicator":"string"},{"name":"u_dt_srvc","value":"2017-09-24T05:00:00.000Z|2017-09-23T05:00:00.000Z|2017-09-22T05:00:00.000Z|2017-09-13T05:00:00.000Z|2017-09-12T05:00:00.000Z|2017-09-11T05:00:00.000Z|2017-04-24T05:00:00.000Z|2017-04-23T05:00:00.000Z|2017-04-21T05:00:00.000Z|2017-04-22T05:00:00.000Z|2017-09-21T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_pay_cyc_dt","value":"2017-10-12T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_mbr_lst_nm","value":"TAYLOR|MILLER|ANDERSON|WILSON","dataTypeIndicator":"string"},{"name":"u_mbr_fst_nm","value":"ALEC|ALBERTO|ALEJANDRO|ALDEN","dataTypeIndicator":"string"},{"name":"u_pra_doc_typ_cd","value":"RA","dataTypeIndicator":"string"},{"name":"u_flfl_req_head_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_nm","value":"NA","dataTypeIndicator":"string"}]}}]},"pagination":{"maxRecords":"250","pageNumber":"1","pageSize":"25","recordCount":"1","moreRecords":"false"}}}}');
        OILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);    
        ACETFindDocWebservice ac1=new ACETFindDocWebservice();
        
        ac1.DocumentKeys = dockeylist;
        //Calling the void method's
        ac1.GetEndpoint();
        ac1.GetMethod();
        
        ACETWSCalloutResult res =ac1.querypaginateddata(1,50,1);
    }
    static testMethod void testProviderFlow2(){
        Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '123456789';
        insert cont;
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';        
        insert interaction;
        
        ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
        ApexPages.currentPage().getParameters().put('DocId','7f183de6');
        ApexPages.currentPage().getParameters().put('docType','ACET Letter');
        ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
        ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
        ApexPages.currentPage().getParameters().put('idCard','7f183de6');
        ApexPages.currentPage().getParameters().put('SRK','');
        ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.providerType = 'HCO';
        String addinfojson = JSON.serialize(addinfo);
        
        ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
                             ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        Test.setMock(HttpCalloutMock.class, new FindProviderInfoCalloutMock1());
        ACETCommunicationSearchController stub = new ACETCommunicationSearchController();
        Document_Type_Flow__mdt docTypeFlow=[select Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,Subscriber_Only__c from Document_Type_Flow__mdt where Flow__c ='Provider' and Is_Member_Focus__c = false Limit 1];

        stub.findproviderinfo(docTypeFlow);
        ACETDocRedeliveryWebservice acdrW = new ACETDocRedeliveryWebservice();
        acdrW.getrequestBodyMap();
        acdrW.getrequestBodyRedelivery('LF');
        acdrW.getrequestBodyRedelivery('OL');
        
        
    }
}