@isTest

private class ACETLGT_CommunicationSearchTest{
   static String memberresponse ='{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"2015-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"MAIL","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}';
static String notFoundVal = 'Resource Not Found';

    static testMethod void testFindDocService(){
        ACETLGT_FindDocWebservice service = new ACETLGT_FindDocWebservice();        
        ACETLGT_FindDocWebservice.documentKey key = new ACETLGT_FindDocWebservice.documentKey();
        key.value = '11-12-1977';
        key.name = 'u_mbr_id';
        key.dataTypeIndicator = 'Datetime';
        key.operator = '= ANY';
        service.getDocKeyRequest('DocKeyTemplate', key.name, key.value, key.dataTypeIndicator, key.operator);
        List<ACETLGT_FindDocWebservice.documentKey> findDocKeys = new List<ACETLGT_FindDocWebservice.documentKey>();
        findDocKeys.add(key);
        service.init('u_clinical_docs', findDocKeys);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindDocWebserviceResponse());
        oILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, oILResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);           
        service.queryPaginatedData(1,1,1);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, notFoundVal, ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
        oILResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, oILResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2); 
        service.queryPaginatedData(1,1,1);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, notFoundVal, ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
        oILResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, oILResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3); 
        service.queryPaginatedData(1,1,1);
        
        ISL_Webservice_Config__c  isl = new ISL_Webservice_Config__c();
        isl.Name ='OILHttpHeaderScope';
        isl.Is_Available__c=true;
        isl.Value__c='read';
        insert isl;
        
        List<ACETLGT_FindDocWebservice.documentKey> ad1=new List<ACETLGT_FindDocWebservice.documentKey>();
        ACETLGT_FindDocWebservice.documentKey ad=new ACETLGT_FindDocWebservice.documentKey();
        ad.name = 'Test';
        ad.value = 'Test123';
        ad.dataTypeIndicator = 'Testdata';
        ad.operator = 'UHG';
        ad1.add(ad);
        
        ACETLGT_FindDocWebservice ac=new ACETLGT_FindDocWebservice();
        
        //Calling the void method's
        ac.GetEndpoint();
        ac.GetMethod();
        ac.GetHeaders(isl);
        ac.init('test123',ad1);
        ac.GetRequestBody(1,1,1); 
        ac.GetRequestBodyIdCards();
        
        ACETMemberDetail md = new ACETMemberDetail();
        md.FirstName = 'test';
        md.LastName = 'here';
        md.DOB = '1/1/1990';
        md.CoverageLines = null;
        md.Surrogatekey='10';
        
        ACETMemberDetail.Address cl = new ACETMemberDetail.Address();
        cl.City = 'tewt';
        cl.Zip = 'test';
        cl.countryCode = 'test';
        
        MultiStaticResourceCalloutMock multiMockResponse = new MultiStaticResourceCalloutMock();
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetIndividualService', 'GetIndividualFamilyMembersJSON');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetMemberShipService', 'GetMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/FindMemberShipService', 'FindMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetFamilyMemberService', 'GetFamilyMemberService');
        multiMockResponse.setStatusCode(200);
        multiMockResponse.setHeader('Content-Type', 'application/json');        
        
        Test.setMock(HttpCalloutMock.class, multiMockResponse);
        
        String dynamicParams='["te,st1","te,st2","te,st3"]';
        String dynamicParams1= '["89024672500,u_id_crd_srl_nbr,String,","1198480,u_grp_id,String,"]';
        List<String> docIds=   new List<String>();
        docIds.add('1234');
        docIds.add('2222');
        
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETRedeliverResponseJSON'];
        String responseJSON = responseJSONSR.Body.toString(); 
        MockHttpCalloutResponseGenerator.MockHttpResponse oILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', responseJSON);
        oILTestResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator mockHttpResponse = new MockHttpCalloutResponseGenerator(null, oILTestResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
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
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', memberresponse);        
        oILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oILResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
        
        String prwrap ='{"personwrapper" :{ "personFirstName":"testfname", "personLastName":"testfname", "personMiddleName":"testfname", "personSuffix":"testfname", "personAddOne":"testfname", "personAddTwo":"testfname", "personCity":"testfname", "personState":"testfname", "personZipCode":"testfname","personOrganization":"testfname", "personFirstNameAA":"testfname","personMiddleNameAA":"testfname", "personLastNameAA":"testfname", "personSuffixAA":"testfname",  "personAddOneAA":"testfname","personAddTwoAA":"testfname", "personCityAA":"testfname", "personStateAA":"testfname","personZipCodeAA":"testfname", "personOrganizationAA":"testfname", "recipientId":"testfname", "personCityAA":"testfname", "idQualifier":"testfname","recipientType":"testfname"}}'; 
        ACETLGT_CommunicationSearchController  objCont = new ACETLGT_CommunicationSearchController();
        ACETLGT_CommunicationSearchController.getDocTypes('Member ACET Letter',true, 'self');
        ACETLGT_CommunicationSearchController.getDocTypes('Member ACET Letter',true, '');
        ACETLGT_CommunicationSearchController.changeSearchFilter('ACET Letter');
        ACETLGT_CommunicationSearchController.getSearchResultFields('Provider RA');
        ACETLGT_CommunicationSearchController.getSearchResultFields('Oxford Group Handbook');
        ACETLGT_CommunicationSearchController.getSearchResultFields('Oxford Member Handbook');
        ACETLGT_CommunicationSearchController.findMemberInfo('testmemberid','testsrk','ACET Letter');
        ACETLGT_CommunicationSearchController.findMemberInfo('39045843900','','ACET Letter');
        ACETLGT_CommunicationSearchController.getCommunicationSearchResults('ACET Letter',dynamicParams);
        ACETLGT_CommunicationSearchController.getCommunicationSearchResults('Oxford Group Handbook',dynamicParams);
        ACETLGT_CommunicationSearchController.getCommunicationSearchResults('Oxford Member Handbook',dynamicParams);
        ACETLGT_CommunicationSearchController.getCommunicationSearchResults('Provider RA',dynamicParams);
        ACETLGT_CommunicationSearchController.getCommunicationSearchResults('Provider RA',dynamicParams1);
        ACETLGT_CommunicationSearchController.resendSelectedDocs(docIds,responseJSON,'addOnFile','','');        
        ACETLGT_CommunicationSearchController.resendSelectedDocs(docIds,responseJSON,'altAdd','','');
        try{
            ACETLGT_CommunicationSearchController.resendSelectedDocs(docIds,responseJSON,'','','');
        }catch(Exception e){        
        }
        ACETLGT_CommunicationSearchController.personWrapper pWrap=new ACETLGT_CommunicationSearchController.personWrapper();
        pWrap.personFirstName='testfname';
        pWrap.personLastName='testlname'; 
        pWrap.personMiddleName='test';        
        pWrap.personSuffix='test';
        pWrap.personAddOne='test';
        pWrap.personAddTwo='test';
        pWrap.personCity='test';
        pWrap.personState='test';
        pWrap.personZipCode='test';
        pWrap.personOrganization='test';         
        
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
    static testmethod void finddoctest1()
    {
        ACETLGT_FindDocWebservice.DocumentKey dockey = new ACETLGT_FindDocWebservice.DocumentKey();
        List<ACETLGT_FindDocWebservice.DocumentKey > dockeylist = new List<ACETLGT_FindDocWebservice.DocumentKey>();
        dockey.dataTypeIndicator = 'Datetime';
        dockey.operator = '=';
        dockey.Value = '123';
        dockey.name = 'test';
        dockeylist.add(dockey);
        
        ACETLGT_FindDocWebservice.documentKey ad1=new ACETLGT_FindDocWebservice.documentKey();
        ad1.name = 'Test';
        ad1.value = 'T';
        ad1.dataTypeIndicator = 'Testdata';
        ad1.operator = 'UHG';
        dockeylist.add(ad1);    
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findDocumentsResponse":{"findDocumentsResponseType":{"documentList":{"document":[{"repositoryId":"PSEUDO1","repositoryName":"EDMS","documentId":"0902b1fe80425e2e","documentClass":"u_oxf_pra","documentKeys":{"documentKey":[{"name":"a_controlling_app","value":"","dataTypeIndicator":"string"},{"name":"a_is_hidden","value":"false","dataTypeIndicator":"boolean"},{"name":"a_archive","value":"false","dataTypeIndicator":"boolean"},{"name":"keywords","value":"","dataTypeIndicator":"string"},{"name":"subject","value":"","dataTypeIndicator":"string"},{"name":"cmis:createdBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"a_full_text","value":"false","dataTypeIndicator":"boolean"},{"name":"a_compound_architecture","value":"","dataTypeIndicator":"string"},{"name":"language_code","value":"","dataTypeIndicator":"string"},{"name":"cmis:isMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:contentStreamFileName","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101.pdf","dataTypeIndicator":"string"},{"name":"r_has_events","value":"false","dataTypeIndicator":"boolean"},{"name":"r_lock_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_current_state","value":"0","dataTypeIndicator":"integer"},{"name":"u_legal_hold","value":"Inactive","dataTypeIndicator":"string"},{"name":"group_permit","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:contentStreamLength","value":"1","dataTypeIndicator":"integer"},{"name":"r_link_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"a_status","value":"","dataTypeIndicator":"string"},{"name":"r_policy_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_lock_machine","value":"","dataTypeIndicator":"string"},{"name":"a_effective_label","value":"","dataTypeIndicator":"string"},{"name":"owner_name","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"group_name","value":"","dataTypeIndicator":"string"},{"name":"a_link_resolved","value":"false","dataTypeIndicator":"boolean"},{"name":"a_category","value":"","dataTypeIndicator":"string"},{"name":"u_primary_nbr","value":"","dataTypeIndicator":"string"},{"name":"cmis:contentStreamMimeType","value":"application/pdf","dataTypeIndicator":"string"},{"name":"a_special_app","value":"","dataTypeIndicator":"string"},{"name":"cmis:baseTypeId","value":"cmis:document","dataTypeIndicator":"id"},{"name":"r_frzn_assembly_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"r_component_label","value":"","dataTypeIndicator":"string"},{"name":"resolution_label","value":"","dataTypeIndicator":"string"},{"name":"a_effective_flag","value":"","dataTypeIndicator":"string"},{"name":"acl_domain","value":"EDMDCM08","dataTypeIndicator":"string"},{"name":"acl_name","value":"u_oxf_pra_acl","dataTypeIndicator":"string"},{"name":"a_is_signed","value":"false","dataTypeIndicator":"boolean"},{"name":"u_ingestion_dt","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_application_type","value":"","dataTypeIndicator":"string"},{"name":"a_storage_type","value":"PRO_Archiver","dataTypeIndicator":"string"},{"name":"cmis:isLatestMajorVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutId","value":"","dataTypeIndicator":"id"},{"name":"r_page_cnt","value":"1","dataTypeIndicator":"integer"},{"name":"authors","value":"","dataTypeIndicator":"string"},{"name":"r_alias_set_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_composite_id","value":"","dataTypeIndicator":"id"},{"name":"r_assembled_from_id","value":"0000000000000000","dataTypeIndicator":"id"},{"name":"r_content_size","value":"1","dataTypeIndicator":"integer"},{"name":"cmis:isImmutable","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionLabel","value":"1.0","dataTypeIndicator":"string"},{"name":"cmis:checkinComment","value":"","dataTypeIndicator":"string"},{"name":"title","value":"","dataTypeIndicator":"string"},{"name":"cmis:creationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"a_expiration_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_order_no","value":"","dataTypeIndicator":"integer"},{"name":"a_extended_properties","value":"","dataTypeIndicator":"string"},{"name":"cmis:name","value":"T618848_OXOPP_ProvPRA_sprs_OXFORD_UHGOXF_20171025-062124_MS33931101","dataTypeIndicator":"string"},{"name":"r_is_virtual_doc","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isLatestVersion","value":"true","dataTypeIndicator":"boolean"},{"name":"r_frozen_flag","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:lastModificationDate","value":"2017-10-25T21:13:56.000Z","dataTypeIndicator":"datetime"},{"name":"owner_permit","value":"7","dataTypeIndicator":"integer"},{"name":"a_last_review_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_aspect_name","value":"","dataTypeIndicator":"string"},{"name":"u_primary_dt","value":"","dataTypeIndicator":"datetime"},{"name":"cmis:lastModifiedBy","value":"edm_npd_rw_pxy","dataTypeIndicator":"string"},{"name":"r_access_date","value":"2017-10-27T19:52:29.000Z","dataTypeIndicator":"datetime"},{"name":"cmis:contentStreamId","value":"0602b1fe80463d88","dataTypeIndicator":"id"},{"name":"a_effective_date","value":"","dataTypeIndicator":"datetime"},{"name":"a_is_template","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:changeToken","value":"2","dataTypeIndicator":"string"},{"name":"r_is_public","value":"false","dataTypeIndicator":"boolean"},{"name":"r_composite_label","value":"","dataTypeIndicator":"string"},{"name":"r_link_high_cnt","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:isVersionSeriesCheckedOut","value":"false","dataTypeIndicator":"boolean"},{"name":"cmis:versionSeriesCheckedOutBy","value":"","dataTypeIndicator":"string"},{"name":"world_permit","value":"1","dataTypeIndicator":"integer"},{"name":"a_retention_date","value":"","dataTypeIndicator":"datetime"},{"name":"r_has_frzn_assembly","value":"false","dataTypeIndicator":"boolean"},{"name":"u_document_id","value":"0902b1fe80425e2e","dataTypeIndicator":"string"},{"name":"a_publish_formats","value":"","dataTypeIndicator":"string"},{"name":"r_resume_state","value":"0","dataTypeIndicator":"integer"},{"name":"cmis:versionSeriesId","value":"0902b1fe80425e2e","dataTypeIndicator":"id"},{"name":"u_check_folder","value":"true","dataTypeIndicator":"boolean"},{"name":"u_mbr_id","value":"39488083500|80718377300|84374968100|81456178900","dataTypeIndicator":"string"},{"name":"u_pay_nbr","value":"254341","dataTypeIndicator":"string"},{"name":"u_clm_nbr","value":"MW18822224|MS33932015|MH90978355|MH43799886|MS33931101","dataTypeIndicator":"string"},{"name":"u_prov_tin","value":"720881569","dataTypeIndicator":"string"},{"name":"u_srs_desg_cd","value":"WB","dataTypeIndicator":"string"},{"name":"u_dt_srvc","value":"2017-09-24T05:00:00.000Z|2017-09-23T05:00:00.000Z|2017-09-22T05:00:00.000Z|2017-09-13T05:00:00.000Z|2017-09-12T05:00:00.000Z|2017-09-11T05:00:00.000Z|2017-04-24T05:00:00.000Z|2017-04-23T05:00:00.000Z|2017-04-21T05:00:00.000Z|2017-04-22T05:00:00.000Z|2017-09-21T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_pay_cyc_dt","value":"2017-10-12T05:00:00.000Z","dataTypeIndicator":"datetime"},{"name":"u_mbr_lst_nm","value":"TAYLOR|MILLER|ANDERSON|WILSON","dataTypeIndicator":"string"},{"name":"u_mbr_fst_nm","value":"ALEC|ALBERTO|ALEJANDRO|ALDEN","dataTypeIndicator":"string"},{"name":"u_pra_doc_typ_cd","value":"RA","dataTypeIndicator":"string"},{"name":"u_flfl_req_head_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_id","value":"NA","dataTypeIndicator":"string"},{"name":"u_tmplt_nm","value":"NA","dataTypeIndicator":"string"}]}}]},"pagination":{"maxRecords":"250","pageNumber":"1","pageSize":"25","recordCount":"1","moreRecords":"false"}}}}');
        oILResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, oILResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);    
        ACETLGT_FindDocWebservice ac1=new ACETLGT_FindDocWebservice();
        ac1.documenttype = 'IDCARDS';
        ac1.documentKeys = dockeylist;
        
        //Calling the void method's
        ac1.GetEndpoint();
        ac1.GetMethod();
        ac1.GetRequestBodyIdCards();
        ac1.queryPaginatedData(1,1,1);
        ACETWSCalloutResult res =ac1.querypaginateddata(1,50,1);
        res.Success = true;
        res.Message = 'status';
        
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
    static testmethod void communicationsearchresulttest(){
        ISL_Webservice_Config__c  isl = new ISL_Webservice_Config__c();
        isl.Name ='OILHttpHeaderAccept';
        isl.Is_Available__c=true;
        isl.Value__c='read';
        insert isl;
        
        ISL_Webservice_Config__c  isl1 = new ISL_Webservice_Config__c();
        isl1.Name ='OILHttpHeaderScope';
        isl1.Is_Available__c=true;
        isl1.Value__c='read';
        insert isl1;
        
        ISL_Webservice_Config__c  isl2 = new ISL_Webservice_Config__c();
        isl2.Name ='OILHttpHeaderActor';
        isl2.Is_Available__c=true;
        isl2.Value__c='read';
        insert isl2;
        
        MultiStaticResourceCalloutMock multiMockResponse = new MultiStaticResourceCalloutMock();
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetIndividualService', 'GetIndividualFamilyMembersJSON');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetMemberShipService', 'GetMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/FindMemberShipService', 'FindMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetFamilyMemberService', 'GetFamilyMemberService');
        multiMockResponse.setStatusCode(200);
        multiMockResponse.setHeader('Content-Type', 'application/json');   
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'error', '{"ErrorID":"500","ErrorCode":"System.CalloutException","ErrorMessage":"You have uncommitted work pending. Please commit or rollback before calling out","Advice":"Unexpected error occurred. Please try again. If problem persists, please contact the help desk."}');
        oILResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, oILResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2); 
        ACETFinfFulfillmentHistoryWebservice fulfillment1=new ACETFinfFulfillmentHistoryWebservice();
        fulfillment1.FindFulfillmentHistoryWS('0902b1fb8062b942');
        
        try{
            MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findFulfillmentHistoryResult": {"findFulfillmentHistoryResponse": {"searchParameter":    {"searchSourceID": "FISERV","documentID": "0902b1fb8062b942"},"searchResultSet": [   {"responseRequestHeader":       { "requestID": "test_demo_22_1","sourceIDName": "","destinationIDName": "FISERV ID Card Supplier","requestDate": "2017-01-31","businessSegmentName": "","marketSegmentName": "Oxford","fulfillmentTypeBusName": "Claim Pend Letters","requestCategory": "TransactionalInlinePrintReadySingleItem","dataFormat": "pdf","requestorRefNo": "req123","supplierRefNo": "sup01","requestTrailer": {"requestItemCount": 1} },"responseCurrentEventLog":       {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived", "receivedDate": "2017-05-12"dispatchedDate": "2017-05-12","statusCode": "Accepted"},"responseRequestDetail": {"responseTransactionalRequestDetail":       {"responseRecipient": [         {"recipientId": "Raja9","identifierQualifierCodeDescr": "Member ID Type","deliveryMethod1": "Fax", "constituentTypeDescr": "Member Type","person":             {"prefix": "Mr","firstName": "Firstname","middleName": "Middlename","lastName": "Lastname","suffix": "Dr" }"MailToAddress":             {"Address1": "Nilgiri3Appt","Address2": "Sector34","Address3": "CityCenter",  "City": "Noida","State": "UP", "Zip": "201301" }, 3:50 PM "ReturnToAddress":             "Address1": "RosewoodCity", "Address2": "SohnaRoad","Address3": "Street34", "City": "Noida","State": "Noida", "Zip": "201301" }, "faxNumber": "123-990-6734", "emailAddress": "abc@xyz.com"}] "responseTemplate":          {"templateID": "childRequest_1","templateName": "tempname"} }},"responseRequestHistory":       [ {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0","documentID": "Raja_Fax", "documentType": "Raja","repositoryName": "Raja" },  {"processorName": "Fulfillment Hub","eventTypeBusName": "Inbound Request","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0"}]}]}}}');
            OILTestResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpResponse);
            ACETFinfFulfillmentHistoryWebservice fulfillment=new ACETFinfFulfillmentHistoryWebservice();
            ACETWSCalloutResult res=new ACETWSCalloutResult();        
            fulfillment.GetHeaders(isl);    
            fulfillment.FindFulfillmentHistoryWS('0902b1fb8062b942');
        }catch(Exception e){}
        
        ACETFinfFulfillmentHistoryWebservice fulfillment11=new ACETFinfFulfillmentHistoryWebservice();       
        fulfillment11.GetHeaders(isl1); 
        
        ACETFinfFulfillmentHistoryWebservice fulfillment2=new ACETFinfFulfillmentHistoryWebservice();       
        fulfillment2.GetHeaders(isl2); 
        
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
    static testMethod void testFindFulfillmentHistoryJSON2Apex() 
    {
        ISL_Webservice_Config__c  isl = new ISL_Webservice_Config__c();
        isl.Name ='OILHttpHeaderAccept';
        isl.Is_Available__c=true;
        isl.Value__c='read';
        insert isl;
        
        try{
            MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findFulfillmentHistoryResult": {"findFulfillmentHistoryResponse": {"searchParameter":    {"searchSourceID": "FISERV","documentID": "0902b1fb8062b942"},"searchResultSet": [   {"responseRequestHeader":       { "requestID": "test_demo_22_1","sourceIDName": "","destinationIDName": "FISERV ID Card Supplier","requestDate": "2017-01-31","businessSegmentName": "","marketSegmentName": "Oxford","fulfillmentTypeBusName": "Claim Pend Letters","requestCategory": "TransactionalInlinePrintReadySingleItem","dataFormat": "pdf","requestorRefNo": "req123","supplierRefNo": "sup01","requestTrailer": {"requestItemCount": 1} },"responseCurrentEventLog":       {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived", "receivedDate": "2017-05-12"dispatchedDate": "2017-05-12","statusCode": "Accepted"},"responseRequestDetail": {"responseTransactionalRequestDetail":       {"responseRecipient": [         {"recipientId": "Raja9","identifierQualifierCodeDescr": "Member ID Type","deliveryMethod1": "Fax", "constituentTypeDescr": "Member Type","person":             {"prefix": "Mr","firstName": "Firstname","middleName": "Middlename","lastName": "Lastname","suffix": "Dr" }"MailToAddress":             {"Address1": "Nilgiri3Appt","Address2": "Sector34","Address3": "CityCenter",  "City": "Noida","State": "UP", "Zip": "201301" }, 3:50 PM "ReturnToAddress":             "Address1": "RosewoodCity", "Address2": "SohnaRoad","Address3": "Street34", "City": "Noida","State": "Noida", "Zip": "201301" }, "faxNumber": "123-990-6734", "emailAddress": "abc@xyz.com"}] "responseTemplate":          {"templateID": "childRequest_1","templateName": "tempname"} }},"responseRequestHistory":       [ {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0","documentID": "Raja_Fax", "documentType": "Raja","repositoryName": "Raja" },  {"processorName": "Fulfillment Hub","eventTypeBusName": "Inbound Request","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0"}]}]}}}');
            OILTestResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpResponse);
            ACETFinfFulfillmentHistoryWebservice fulfillment=new ACETFinfFulfillmentHistoryWebservice();
            ACETWSCalloutResult res=new ACETWSCalloutResult();        
            fulfillment.GetHeaders(isl);    
            fulfillment.FindFulfillmentHistoryWS('0902b1fb8062b942');
        }catch(Exception e){}
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.SearchParameter AFFJ2A4 = new ACETLGT_FindFulfillmentHistoryJSON2Apex.SearchParameter();
        AFFJ2A4.searchSourceID='test';
        AFFJ2A4.documentID='test';
        
        List<ACETLGT_FindFulfillmentHistoryJSON2Apex.SearchResultSet> SRS1= new List<ACETLGT_FindFulfillmentHistoryJSON2Apex.SearchResultSet>();
        ACETLGT_FindFulfillmentHistoryJSON2Apex.SearchResultSet SRS= new ACETLGT_FindFulfillmentHistoryJSON2Apex.SearchResultSet();
        ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestHeader RRH= new ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestHeader();
        
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
        ACETLGT_FindFulfillmentHistoryJSON2Apex.RequestTrailer RQT = new ACETLGT_FindFulfillmentHistoryJSON2Apex.RequestTrailer();
        RQT.requestItemCount=10;
        RRH.requestTrailer=RQT;
        SRS.responseRequestHeader=RRH;
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseCurrentEventLog RCEL= new ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseCurrentEventLog();
        RCEL.processorName='test';
        RCEL.eventTypeBusName='test';
        RCEL.receivedDate='test';
        RCEL.dispatchedDate='test';
        RCEL.statusCode='test';
        SRS.responseCurrentEventLog=RCEL;
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestDetail RRD= new ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestDetail();
        ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseTransactionalRequestDetail  RTRD = new ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseTransactionalRequestDetail();
        List<ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRecipient> RR1 =new List<ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRecipient>();
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRecipient RR =new ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRecipient();
        RR.recipientId='test';
        RR.identifierQualifierCodeDescr='test';
        RR.deliveryMethod1='test';
        RR.constituentTypeDescr='test';
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.Person PER = new ACETLGT_FindFulfillmentHistoryJSON2Apex.Person();
        PER.prefix='test';
        PER.firstName='test';
        PER.middleName='test';
        PER.lastName='test';
        PER.suffix='test';
        RR.person=PER;
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.MailToAddress MA =new ACETLGT_FindFulfillmentHistoryJSON2Apex.MailToAddress();
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
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseTemplate RT = new ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseTemplate();
        RT.templateID='test';
        RT.templateName='test';
        RR1.add(RR);
        RTRD.responseRecipient =RR1;
        RTRD.responseTemplate=RT; 
        RRD.responseTransactionalRequestDetail=RTRD;
        SRS.responseRequestDetail=RRD;
        
        List<ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestHistory> RRHT1= new List<ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestHistory>();
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestHistory RRHT= new ACETLGT_FindFulfillmentHistoryJSON2Apex.ResponseRequestHistory();
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
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResponse AFFJ2A3 = new ACETLGT_FindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResponse();
        AFFJ2A3.searchParameter=AFFJ2A4;
        AFFJ2A3.searchResultSet=SRS1;
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult AFFJ2A2 = new ACETLGT_FindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult();
        AFFJ2A2.findFulfillmentHistoryResponse=AFFJ2A3;  
        
        ACETLGT_FindFulfillmentHistoryJSON2Apex acetJson = new ACETLGT_FindFulfillmentHistoryJSON2Apex();        
        ACETLGT_FindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult findhis= new ACETLGT_FindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult();        
        acetJson.findFulfillmentHistoryResult= findhis;     
    }
    static testMethod void testMemInfo2(){
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', memberresponse);       
        oILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oILResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
        try{
            ACETLGT_CommunicationSearchController.findMemberInfo('testmemberid','testsrk','ACET Letter');
        }catch(Exception ex){}
    }
    static testMethod void testMemInfo4(){
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', memberresponse);       
        oILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oILResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
        try{
            ACETLGT_CommunicationSearchController.findMemberInfo('testmemberid','testsrk','IRS 1095 Form');
        }catch(Exception ex){}
    }
    static testMethod void testMemInfo3(){
        MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', memberresponse);
        oILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oILResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
        ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
        addinfo.MemberId = '123456';
        String addinfojson = JSON.serialize(addinfo);
        try{
            ACETLGT_CommunicationSearchController.findMemberInfo('testmemberid','testsrk','ACET Letter');
        }catch(Exception ex){}
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
    static testMethod void testfindfulfilmentmtd() {
        
        Test.startTest();
        StaticResource responseJSONFinF = [SELECT Body FROM StaticResource WHERE Name = 'AcetFindFulfillmentHistoryResultJSON'];
        String responseJSONFin = responseJSONFinF.Body.toString();
        MockHttpCalloutResponseGenerator.MockHttpResponse oILTestResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', responseJSONFin);
        oILTestResponse3.TokenExpired = false;
        MockHttpCalloutResponseGenerator mockHttpResponse3 = new MockHttpCalloutResponseGenerator(null,oILTestResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse3); 
        //Calling method-"FindFulfillmentHistoryWS" directly  to increase coverage
        //This service is not called from the ACETLGT_CommunicationSearchController
        ACETFinfFulfillmentHistoryWebservice fs = new ACETFinfFulfillmentHistoryWebservice();       
        fs.FindFulfillmentHistoryWS('55454333434');    
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oilTestResponse3Exception = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{}');
        oilTestResponse3Exception .TokenExpired = false;
        MockHttpCalloutResponseGenerator mockHttpResponse3Exception = new MockHttpCalloutResponseGenerator(null,oilTestResponse3Exception);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse3Exception );
        //Calling method-"FindFulfillmentHistoryWS" directly  to increase coverage
        //This service is not called from the ACETLGT_CommunicationSearchController
        ACETFinfFulfillmentHistoryWebservice fs1 = new ACETFinfFulfillmentHistoryWebservice();      
        fs1.FindFulfillmentHistoryWS('55454333434');    
        Test.Stoptest();
    }
    static testMethod void testFindDocService12(){
         ACETLGT_FindDocWebservice service = new ACETLGT_FindDocWebservice();
         ACETLGT_FindDocWebservice.documentKey key = new ACETLGT_FindDocWebservice.documentKey();
         key.value = '112077';
         key.name = 'u_mbr_id';
         key.dataTypeIndicator = 'string';
         key.operator = '=';
         List<ACETLGT_FindDocWebservice.documentKey> findDocKeys = new List<ACETLGT_FindDocWebservice.documentKey>();
         findDocKeys.add(key);
         service.init('u_clinical_docs', findDocKeys);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindDocWebserviceResponse());
         oILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, oILResponse1);
         Test.setMock(HttpCalloutMock.class, mockHttpRes1);           
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, notFoundVal, ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
         oILResponse2.TokenExpired = false;        
         MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, oILResponse2);
         Test.setMock(HttpCalloutMock.class, mockHttpRes2); 
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse oILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, notFoundVal, ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
         oILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, oILResponse3);
         Test.setMock(HttpCalloutMock.class, mockHttpRes3); 
         service.queryPaginatedData(1,1,1);
        String error = '{"errors":{"errors":[{"title":"Not Found","status":404,"description":"u_enrl_lt docclass is invalid"}]}}';
        HttpResponse resp = new HttpResponse();
        resp.setBody(error);
    }
}