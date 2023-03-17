@istest
public class ACETFormsHistoryControllertest {
    static testmethod void test1()
    {
        
        ACETProcessFulFillmentJSON2Apex process = new ACETProcessFulFillmentJSON2Apex();
        ACETProcessFulFillmentJSON2Apex.Transaction_Z trans = new ACETProcessFulFillmentJSON2Apex.Transaction_Z();
        trans.transaction_ZStatus = 'new';
        
        List<ACETProcessFulFillmentJSON2Apex.Transaction_Z> translist = new List<ACETProcessFulFillmentJSON2Apex.Transaction_Z>();
        translist.add(trans);
        ACETProcessFulFillmentJSON2Apex.Transaction_zLevelAck translev = new ACETProcessFulFillmentJSON2Apex.Transaction_zLevelAck();
        translev.transaction_Z = translist;
        
        ACETProcessFulFillmentJSON2Apex.ValidationResults validate = new ACETProcessFulFillmentJSON2Apex.ValidationResults();
        validate.transaction_zLevelAck = translev;
        ACETProcessFulFillmentJSON2Apex.Acknowledge ack = new ACETProcessFulFillmentJSON2Apex.Acknowledge();
        ack.validationResults = validate;
        ACETProcessFulFillmentJSON2Apex.AcknowledgeMsg ackmsg = new ACETProcessFulFillmentJSON2Apex.AcknowledgeMsg();
        ackmsg.acknowledge = ack;
        ACETProcessFulFillmentJSON2Apex.ProcessFulfillmentRequestResult result = new ACETProcessFulFillmentJSON2Apex.ProcessFulfillmentRequestResult();
        result.acknowledgeMsg = ackmsg;
    String jsonText = '{"status":"REQUEST_SUCCEEDED","responseTime":42,"message":[],"Results":{ "series": [{"seriesID":"LAUCN040010000000006","data":[{"year":"2014","period":"M08","periodName":"August","value":"20410","footnotes":[{"code":"P","text":"Preliminary."}]},{"year":"2014","period":"M07","periodName":"July","value":"20750","footnotes":[{}]},{"year":"2014","period":"M06","periodName":"June","value":"20863","footnotes":[{}]},{"year":"2014","period":"M05","periodName":"May","value":"20321","footnotes":[{}]},{"year":"2014","period":"M04","periodName":"April","value":"19919","footnotes":[{}]},{"year":"2014","period":"M03","periodName":"March","value":"20309","footnotes":[{}]},{"year":"2014","period":"M02","periodName":"February","value":"20055","footnotes":[{}]},{"year":"2014","period":"M01","periodName":"January","value":"20499","footnotes":[{}]},{"year":"2013","period":"M13","periodName":"Annual","value":"21130","footnotes":[{}]},{"year":"2013","period":"M12","periodName":"December","value":"20358","footnotes":[{}]},{"year":"2013","period":"M11","periodName":"November","value":"20190","footnotes":[{}]},{"year":"2013","period":"M10","periodName":"October","value":"20614","footnotes":[{}]},{"year":"2013","period":"M09","periodName":"September","value":"20963","footnotes":[{}]},{"year":"2013","period":"M08","periodName":"August","value":"21457","footnotes":[{}]},{"year":"2013","period":"M07","periodName":"July","value":"21611","footnotes":[{}]},{"year":"2013","period":"M06","periodName":"June","value":"21684","footnotes":[{}]},{"year":"2013","period":"M05","periodName":"May","value":"21408","footnotes":[{}]},{"year":"2013","period":"M04","periodName":"April","value":"21177","footnotes":[{}]},{"year":"2013","period":"M03","periodName":"March","value":"21059","footnotes":[{}]},{"year":"2013","period":"M02","periodName":"February","value":"21324","footnotes":[{}]},{"year":"2013","period":"M01","periodName":"January","value":"21715","footnotes":[{}]},{"year":"2012","period":"M13","periodName":"Annual","value":"22061","footnotes":[{}]},{"year":"2012","period":"M12","periodName":"December","value":"21695","footnotes":[{}]},{"year":"2012","period":"M11","periodName":"November","value":"21459","footnotes":[{}]},{"year":"2012","period":"M10","periodName":"October","value":"22063","footnotes":[{}]},{"year":"2012","period":"M09","periodName":"September","value":"22312","footnotes":[{}]},{"year":"2012","period":"M08","periodName":"August","value":"22640","footnotes":[{}]},{"year":"2012","period":"M07","periodName":"July","value":"22924","footnotes":[{}]},{"year":"2012","period":"M06","periodName":"June","value":"22479","footnotes":[{}]},{"year":"2012","period":"M05","periodName":"May","value":"21935","footnotes":[{}]},{"year":"2012","period":"M04","periodName":"April","value":"21624","footnotes":[{}]},{"year":"2012","period":"M03","periodName":"March","value":"21778","footnotes":[{}]},{"year":"2012","period":"M02","periodName":"February","value":"21813","footnotes":[{}]},{"year":"2012","period":"M01","periodName":"January","value":"22014","footnotes":[{}]}]}] }}';

        ACETGetProducerRequestDetail.Parse(jsonText);
        
        
      /*  Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        insert cont;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Member'; 
        interaction.tst_Date_Field__c = system.today();      
        insert interaction;
        
        Case c = new Case();
        //date d = c.tst_Date_Field__c+30;
        //system.debug(d);
        DateTime dt = datetime.newInstance(1991/06/26);
        system.debug(dt);  
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseInpatient = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetInpatientDetailResponseJSONTest() );
        OILResponseInpatient.TokenExpired = false;        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseInpatient);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        pageRef.getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"Test"}');
        pageRef.getParameters().put('groupID', 'test');
        pageRef.getParameters().put('SRK', 'test');
        
        ACETFormsHistoryController controller = new ACETFormsHistoryController();
        ACETFormsHistoryController.MaterialForms contwrapr = new ACETFormsHistoryController.MaterialForms(mform);
        ACETFormsHistoryController.personWrapper contprsnwrapr = new ACETFormsHistoryController.personWrapper();
        contprsnwrapr.personOrganization1='TestFirstname';
        contprsnwrapr.personOrganization2='TestFirstname';
        contprsnwrapr.personFirstName='Test';
        contprsnwrapr.personMiddleName='Data';
        contprsnwrapr.personLastName='LastName';
        contprsnwrapr.personSuffix='Suffix';
        contprsnwrapr.personAddOne='Test';
        contprsnwrapr.personAddTwo='Test';
        contprsnwrapr.personCity='City';
        contprsnwrapr.personState='State';
        contprsnwrapr.personZipCode='Test';
        controller.successmessage= false;
        //controller.btnSubmit();
        controller.getdocumentTypeValues();
        controller.getBusinessUnitValues();
        
        ACETHighlightsPanelAdditionalInfo addpanel = new ACETHighlightsPanelAdditionalInfo();
        //controller.AdditionalInfo =addpanel;
       Contact cont1 = new Contact();
        cont1.FirstName='Test';
        cont1.LastName='Test';
        cont1.Tax_ID__c = '123456789';
        insert cont1;
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();
        //datawrpr.init(interactionId = interaction.Id);
        
        controller.wrapper  =datawrpr;
        controller.subject =cont;
        
        controller.BusinessUnit ='Test';
        controller.source='Test';
        controller.doctype='Test';
        controller.neworder='Test';
        controller.orderhistory='Data';
        controller.order='Test';
        controller.enddate='2/2/17';
        controller.chooseAddress=true;
        controller.personOrganizationAA1='Test';
        controller.personOrganizationAA2='Test';
        controller.personFirstNameAA='Test';
        controller.personMiddleNameAA='Test';
        controller.personLastNameAA='Test';
        controller.personSuffixAA='Test';
        controller.personAddOneAA='Test';
        controller.personAddTwoAA='Test';
        controller.personCityAA='Test';
        controller.personStateAA='Test';
        controller.personZipCodeAA='Test';
        controller.selectAddress='Test';
        controller.hpAdditionInfoStr='Test'; 
        controller.recepientId='Test';
        controller.idQualifier='Test';
        controller.recipientType='Test';
        
        controller.startdate = interaction;
        controller.Interaction = interaction;
        /*controller.findGroupInfo(); 
controller.MaterialForms();
controller.checkValidQuantity();
controller.findProducerInfo();*/
        controller.search();
        controller.calculateEnddate();
        controller.changeOrderDate();
        controller.init();
        controller.search();
        controller.clearsearch();
        controller.getBusinessUnitValues();
        controller.getdocumentTypeValues();
        controller.MaterialForms();
        controller.findMemberInfo();
        controller.findProducerInfo();
        controller.findProviderInfo();
        controller.btnSubmit();
        
        //string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';            
        
    }        
    static testmethod void test2()
    {
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Group/Employer';        
        insert interaction;
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        pageRef.getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","isMember":false,"Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"Test"}');
        pageRef.getParameters().put('groupID', 'test');
        pageRef.getParameters().put('SRK', 'test');
        
        ACETFormsHistoryController controller = new ACETFormsHistoryController();
        ACETFormsHistoryController.MaterialForms contwrapr = new ACETFormsHistoryController.MaterialForms(mform);
        ACETFormsHistoryController.personWrapper contprsnwrapr = new ACETFormsHistoryController.personWrapper();
        
        controller.getdocumentTypeValues();
        controller.getBusinessUnitValues();
        
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();        
        controller.wrapper  =datawrpr;
        controller.subject =cont;
        
        controller.BusinessUnit ='Test';
        controller.source='Test';
        controller.doctype='Test';
        controller.neworder='Test';
        controller.orderhistory='Data';
        controller.order='Test';
        controller.enddate='2/2/17';
        controller.chooseAddress=true;
        controller.personOrganizationAA1='Test';
        controller.personOrganizationAA2='Test';
        controller.personFirstNameAA='Test';
        controller.personMiddleNameAA='Test';
        controller.personLastNameAA='Test';
        controller.personSuffixAA='Test';
        controller.personAddOneAA='Test';
        controller.personAddTwoAA='Test';
        controller.personCityAA='Test';
        controller.personStateAA='Test';
        controller.personZipCodeAA='Test';
        controller.selectAddress='Test';
        controller.hpAdditionInfoStr='Test'; 
        controller.recepientId='Test';
        controller.idQualifier='Test';
        controller.recipientType='Test';
        
        controller.startdate = interaction;
        controller.Interaction = interaction;
        controller.MaterialForms();
        controller.checkValidQuantity();
        controller.findProducerInfo();
        controller.search();
        controller.calculateEnddate();
        controller.changeOrderDate();
        controller.init();
        controller.clearsearch();
        //controller.findMemberInfo();
        //controller.findProviderInfo();
        controller.btnSubmit();
        controller.checkValidQuantity();
        
    }
    static testmethod void test6()
    {
        
       /* Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        insert cont;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Group/Employer';        
        insert interaction;
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        pageRef.getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","isMember":null,"Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"Test"}');
        pageRef.getParameters().put('groupID', 'test');
        pageRef.getParameters().put('SRK', 'test');
        
        ACETFormsHistoryController controller = new ACETFormsHistoryController();
        ACETFormsHistoryController.MaterialForms contwrapr = new ACETFormsHistoryController.MaterialForms(mform);
        ACETFormsHistoryController.personWrapper contprsnwrapr = new ACETFormsHistoryController.personWrapper();
        
        controller.getdocumentTypeValues();
        controller.getBusinessUnitValues();
        
        //ACETHighlightsPanelAdditionalInfo addpanel = new ACETHighlightsPanelAdditionalInfo();
       // controller.AdditionalInfo =addpanel;
        
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();
        //datawrpr.init(interactionId = interaction.Id);
        
        controller.wrapper  =datawrpr;
        controller.subject =cont;
        
        controller.BusinessUnit ='Producer';
        controller.source='Test';
        controller.doctype='Test';
        controller.neworder='Test';
        controller.orderhistory='Data';
        controller.order='Test';
        controller.enddate='2/2/17';
        controller.chooseAddress=true;
        controller.personOrganizationAA1='Test';
        controller.personOrganizationAA2='Test';
        controller.personFirstNameAA='Test';
        controller.personMiddleNameAA='Test';
        controller.personLastNameAA='Test';
        controller.personSuffixAA='Test';
        controller.personAddOneAA='Test';
        controller.personAddTwoAA='Test';
        controller.personCityAA='Test';
        controller.personStateAA='Test';
        controller.personZipCodeAA='Test';
        controller.selectAddress='Test';
        controller.hpAdditionInfoStr='Test'; 
        controller.recepientId='Test';
        controller.idQualifier='Test';
        controller.recipientType='Test';
        
        controller.startdate = interaction;
        controller.Interaction = interaction;
        //controller.findGroupInfo(); 
        controller.MaterialForms();
        controller.checkValidQuantity();
        controller.findProducerInfo();
        controller.search();
        controller.calculateEnddate();
        controller.changeOrderDate();
        controller.init();
        controller.clearsearch();
        //controller.findMemberInfo();
        //controller.findProviderInfo();
        controller.btnSubmit();
        controller.checkValidQuantity();
        
        //string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';     
    }
    static testMethod void testSearch(){
        
        
        
        
       /* Contact cont = new Contact();
        
        cont.FirstName='Test';
        
        cont.LastName='Test';
        
        cont.Tax_ID__c = '123456789';
        
        insert cont;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        
        
        
        Interaction__c interaction = new Interaction__c();
        
        interaction.Originator__c = cont.Id; 
        
        interaction.Interaction_Type__c = 'Phone Call';
        
        interaction.Originator_Type__c = 'Member'; 
        
        insert interaction;
        
        
        
        
        
        
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open',tst_Date_Field__c=system.today());
        
        insert TestC;

        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        
        acetFrmsHisCntr.order='Order History';
        
        acetFrmsHisCntr.startdate=interaction;
        
        try{
            
            acetFrmsHisCntr.search();
            
        }catch(Exception e){}
        
        acetFrmsHisCntr.calculateEnddate();
        
    }
    static testmethod void test3(){
        
       /* Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        insert cont;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Producer';        
        insert interaction;
        
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        pageRef.getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"Test"}');
        pageRef.getParameters().put('groupID', 'test');
        pageRef.getParameters().put('SRK', 'test');
        
        ACETFormsHistoryController controller = new ACETFormsHistoryController();
        ACETFormsHistoryController.MaterialForms contwrapr = new ACETFormsHistoryController.MaterialForms(mform);
        ACETFormsHistoryController.personWrapper contprsnwrapr = new ACETFormsHistoryController.personWrapper();
        
        controller.getdocumentTypeValues();
        controller.getBusinessUnitValues();
        
        ACETHighlightsPanelAdditionalInfo addpanel = new ACETHighlightsPanelAdditionalInfo();
        //controller.AdditionalInfo =addpanel;
        Contact cont2 = new Contact();
        cont2.FirstName='Test';
        cont2.LastName='Test';
        cont2.Tax_ID__c = '123456789';
        insert cont2;
        controller.hpAdditionInfoStr='Test'; 
        //String str={"findFulfillmentHistoryResult": {"findFulfillmentHistoryResponse": {"searchParameter":    {"searchSourceID": "FISERV","documentID": "Raja_Fax"},"searchResultSet": [   {"responseRequestHeader":       { "requestID": "test_demo_22_1","sourceIDName": "","destinationIDName": "FISERV ID Card Supplier","requestDate": "2017-01-31","businessSegmentName": "","marketSegmentName": "Oxford","fulfillmentTypeBusName": "Claim Pend Letters","requestCategory": "TransactionalInlinePrintReadySingleItem","dataFormat": "pdf","requestorRefNo": "req123","supplierRefNo": "sup01","requestTrailer": {"requestItemCount": 1} },"responseCurrentEventLog":       {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived", "receivedDate": "2017-05-12"dispatchedDate": "2017-05-12","statusCode": "Accepted"},"responseRequestDetail": {"responseTransactionalRequestDetail":       {"responseRecipient": [         {"recipientId": "Raja9","identifierQualifierCodeDescr": "Member ID Type","deliveryMethod1": "Fax", "constituentTypeDescr": "Member Type","person":             {"prefix": "Mr","firstName": "Firstname","middleName": "Middlename","lastName": "Lastname","suffix": "Dr" }"MailToAddress":             {"Address1": "Nilgiri3Appt","Address2": "Sector34","Address3": "CityCenter",  "City": "Noida","State": "UP", "Zip": "201301" }, 3:50 PM "ReturnToAddress":             "Address1": "RosewoodCity", "Address2": "SohnaRoad","Address3": "Street34", "City": "Noida","State": "Noida", "Zip": "201301" }, "faxNumber": "123-990-6734", "emailAddress": "abc@xyz.com"}] "responseTemplate":          {"templateID": "childRequest_1","templateName": "tempname"} }},"responseRequestHistory":       [ {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0","documentID": "Raja_Fax", "documentType": "Raja","repositoryName": "Raja" },  {"processorName": "Fulfillment Hub","eventTypeBusName": "Inbound Request","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0"}]}]}}});
        //string str= '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';            
        ACETHighlightsPanelAdditionalInfo objACETHighlightsPanelAdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        objACETHighlightsPanelAdditionalInfo.surrogatekey = 'test';
        System.currentPageReference().getParameters().put('additionalInfo',JSON.serialize(objACETHighlightsPanelAdditionalInfo));
        
        
        
        
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();
        //datawrpr.init(interactionId = interaction.Id);
        
        controller.wrapper  =datawrpr;
        controller.subject =cont;
        
        controller.BusinessUnit ='Test';
        controller.source='Test';
        controller.doctype='Test';
        controller.neworder='Test';
        controller.orderhistory='Data';
        controller.order='Test';
        controller.enddate='2/2/17';
        controller.chooseAddress=true;
        controller.personOrganizationAA1='Test';
        controller.personOrganizationAA2='Test';
        controller.personFirstNameAA='Test';
        controller.personMiddleNameAA='Test';
        controller.personLastNameAA='Test';
        controller.personSuffixAA='Test';
        controller.personAddOneAA='Test';
        controller.personAddTwoAA='Test';
        controller.personCityAA='Test';
        controller.personStateAA='Test';
        controller.personZipCodeAA='Test';
        controller.selectAddress='Test';
        controller.hpAdditionInfoStr='Test'; 
        controller.recepientId='Test';
        controller.idQualifier='Test';
        controller.recipientType='Test';
        
        controller.startdate = interaction;
        controller.Interaction = interaction;
        /*controller.findGroupInfo(); 
controller.MaterialForms();
controller.checkValidQuantity();
controller.findProducerInfo();*/
        controller.search();
        controller.calculateEnddate();
        controller.changeOrderDate();
        controller.init();
        controller.search();
        controller.clearsearch();
        controller.getBusinessUnitValues();
        controller.getdocumentTypeValues();
        controller.MaterialForms();
        controller.findMemberInfo();
        controller.findProducerInfo();
        controller.findProviderInfo();
        controller.btnSubmit();
        
        //string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';            
        
    }
    static testmethod void testfindProviderInfo1()
    {       
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('ProvTypeCode', 'HCO');
        
       /* Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '';
        insert cont;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Provider';        
        insert interaction;
                
        Test.setMock(HttpCalloutMock.class, new FindProviderInfoCalloutMock1());
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        //try{
          //  acetFrmsHisCntr.findProviderInfo();
        //}catch(Exception ex){}
        
    }
    /*static testmethod void findProviderInfo2(){
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef);
        pageRef.getParameters().put('ProvTypeCode', 'HCP');
        
        Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '';
        insert cont;        
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Provider';        
        insert interaction;

        Test.setMock(HttpCalloutMock.class, new FindProviderInfoCalloutMock1());
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        try{
            acetFrmsHisCntr.findProviderInfo();
        }catch(Exception ex){}
        
    }*/
    
    static testmethod void test4()
    {
        
       /* Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        insert cont;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Provider';        
        insert interaction;
        
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        pageRef.getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}');
        pageRef.getParameters().put('groupID', '37E9769C');
        pageRef.getParameters().put('SRK', 'test');
        pageRef.getParameters().put('ProvTypeCode', 'test');
        pageRef.getParameters().put('producerId', 'test');
        pageRef.getParameters().put('ProvTypeCode', 'HCO');
        
        
        ACETFormsHistoryController controller = new ACETFormsHistoryController();
        ACETFormsHistoryController.MaterialForms contwrapr = new ACETFormsHistoryController.MaterialForms(mform);
        ACETFormsHistoryController.personWrapper contprsnwrapr = new ACETFormsHistoryController.personWrapper();
        
        controller.getdocumentTypeValues();
        controller.getBusinessUnitValues();
        
        ACETHighlightsPanelAdditionalInfo addpanel = new ACETHighlightsPanelAdditionalInfo();
        controller.AdditionalInfo =addpanel;
        
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();
        //datawrpr.init(interactionId = interaction.Id);
        
        controller.wrapper  =datawrpr;
        controller.subject =cont;
        
        controller.BusinessUnit ='Test';
        controller.source='Test';
        controller.doctype='Test';
        controller.neworder='Test';
        controller.orderhistory='Data';
        controller.order='Test';
        controller.enddate='2/2/17';
        controller.chooseAddress=true;
        controller.personOrganizationAA1='Test';
        controller.personOrganizationAA2='Test';
        controller.personFirstNameAA='Test';
        controller.personMiddleNameAA='Test';
        controller.personLastNameAA='Test';
        controller.personSuffixAA='Test';
        controller.personAddOneAA='Test';
        controller.personAddTwoAA='Test';
        controller.personCityAA='Test';
        controller.personStateAA='Test';
        controller.personZipCodeAA='Test';
        controller.selectAddress='Test';
        controller.hpAdditionInfoStr='Test'; 
        controller.recepientId='Test';
        controller.idQualifier='Test';
        controller.recipientType='Test';
        
        controller.startdate = interaction;
        controller.Interaction = interaction;
        /*controller.findGroupInfo(); 
controller.MaterialForms();
controller.checkValidQuantity();
controller.findProducerInfo();*/
        controller.search();
        controller.calculateEnddate();
        controller.changeOrderDate();
        controller.init();
        controller.search();
        controller.clearsearch();
        controller.getBusinessUnitValues();
        controller.getdocumentTypeValues();
        controller.MaterialForms();
        controller.findMemberInfo();
        controller.findProducerInfo();
        controller.findProviderInfo();
        controller.btnSubmit();
        
        //string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';    
        /*Test.startTest();

PageReference pgRef = Page.ACETFormsHistory; //ACETCommunicationsSearchPage;
Test.setCurrentPageReference(pgRef);

ACETFormsHistoryController objCont = new ACETFormsHistoryController();
objCont.selectAddress = 'AlternateAddress';
objCont.BusinessUnit = 'Member';
objCont.getMaterialForms();
objCont.btnSubmit();

Test.stopTest();

String str={"findFulfillmentHistoryResult": {"findFulfillmentHistoryResponse": {"searchParameter":    {"searchSourceID": "FISERV","documentID": "Raja_Fax"},"searchResultSet": [   {"responseRequestHeader":       { "requestID": "test_demo_22_1","sourceIDName": "","destinationIDName": "FISERV ID Card Supplier","requestDate": "2017-01-31","businessSegmentName": "","marketSegmentName": "Oxford","fulfillmentTypeBusName": "Claim Pend Letters","requestCategory": "TransactionalInlinePrintReadySingleItem","dataFormat": "pdf","requestorRefNo": "req123","supplierRefNo": "sup01","requestTrailer": {"requestItemCount": 1} },"responseCurrentEventLog":       {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived", "receivedDate": "2017-05-12"dispatchedDate": "2017-05-12","statusCode": "Accepted"},"responseRequestDetail": {"responseTransactionalRequestDetail":       {"responseRecipient": [         {"recipientId": "Raja9","identifierQualifierCodeDescr": "Member ID Type","deliveryMethod1": "Fax", "constituentTypeDescr": "Member Type","person":             {"prefix": "Mr","firstName": "Firstname","middleName": "Middlename","lastName": "Lastname","suffix": "Dr" }"MailToAddress":             {"Address1": "Nilgiri3Appt","Address2": "Sector34","Address3": "CityCenter",  "City": "Noida","State": "UP", "Zip": "201301" }, 3:50 PM "ReturnToAddress":             "Address1": "RosewoodCity", "Address2": "SohnaRoad","Address3": "Street34", "City": "Noida","State": "Noida", "Zip": "201301" }, "faxNumber": "123-990-6734", "emailAddress": "abc@xyz.com"}] "responseTemplate":          {"templateID": "childRequest_1","templateName": "tempname"} }},"responseRequestHistory":       [ {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0","documentID": "Raja_Fax", "documentType": "Raja","repositoryName": "Raja" },  {"processorName": "Fulfillment Hub","eventTypeBusName": "Inbound Request","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0"}]}]}}});
HttpResponse res = new HttpResponse();
res.setHeader('Content-Type', 'application/json');
res.setBody(str);
res.setStatusCode(200);
//return res;

}*/
    }          
    static testmethod void testACETFrmsHistWebServ(){
        ACETFormsHistoryWebServiceFF acetFrmsHisWebServ=new ACETFormsHistoryWebServiceFF();
        acetFrmsHisWebServ.init();
        acetFrmsHisWebServ.init('testSrcID',1,'testStDate','testEndDate','testRecID','testQualiID');
        acetFrmsHisWebServ.formatDatetime('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatDatetime('2017-07-08');
        acetFrmsHisWebServ.FormatRecpt('testrecep');
        acetFrmsHisWebServ.formatStartDate('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatStartDate('2017-07T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07/08T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07T12:00:00Z');
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        acetFrmsHisWebServ.init();
        ACETFormsHistoryResult objACETFormsHistoryResult = new ACETFormsHistoryResult();
    }
    
    static testmethod void testACETFrmsHistWebServMock(){
        ACETFormsHistoryWebServiceFF acetFrmsHisWebServ=new ACETFormsHistoryWebServiceFF();
        acetFrmsHisWebServ.init();
        acetFrmsHisWebServ.init('testSrcID',1,'testStDate','testEndDate','testRecID','testQualiID');
        acetFrmsHisWebServ.formatDatetime('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatDatetime('2017-07-08');
        acetFrmsHisWebServ.FormatRecpt('testrecep');
        acetFrmsHisWebServ.formatStartDate('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatStartDate('2017-07T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07/08T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07T12:00:00Z');
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ACETMockHttpResponseGenerator ());
        
        acetFrmsHisWebServ.init();
        ACETFormsHistoryResult objACETFormsHistoryResult = new ACETFormsHistoryResult();
    }
 
    static testmethod void testACETFrmsHistWebServMock2(){
        ACETFormsHistoryWebServiceFF acetFrmsHisWebServ=new ACETFormsHistoryWebServiceFF();
        acetFrmsHisWebServ.init();
        acetFrmsHisWebServ.init('testSrcID',1,'testStDate','testEndDate','testRecID','testQualiID');
        acetFrmsHisWebServ.formatDatetime('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatDatetime('2017-07-08');
        acetFrmsHisWebServ.FormatRecpt('testrecep');
        acetFrmsHisWebServ.formatStartDate('2017-07-08T12:00:00Z');
        acetFrmsHisWebServ.formatStartDate('2017-07T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07/08T12:00:00Z');
        acetFrmsHisWebServ.formatEndDate('2017/07T12:00:00Z');
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FindFulfillmentHistHttpCalloutMock());
        acetFrmsHisWebServ.init();
        ACETFormsHistoryResult objACETFormsHistoryResult = new ACETFormsHistoryResult();
    }
        
    static testmethod void testACETProcessFulfillmentWS(){
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
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETProcessFulFillmentWebservice'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
                RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
            
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse1.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpResponse1 = new MockHttpCalloutResponseGenerator(null, OILTestResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse1);
        
        Material_Forms__c matformtest = new Material_Forms__c();
        //matformtest.Name = 'test';
        matformtest.Document_Title__c =  'test';
        matformtest.Document_URL__c = 'test';
        matformtest.Category__c = 'test';
        matformtest.Business_Unit__c ='Member';
        matformtest.Quantity__c = '10';
        insert matformtest;
    }
    
    
    /*Test.startTest();

PageReference pgRef = Page.ACETFormsHistory; //ACETCommunicationsSearchPage;
Test.setCurrentPageReference(pgRef);
Test.stopTest();
ACETFormsHistoryController objCont = new ACETFormsHistoryController();
objCont.personOrganizationAA='UHG';
objCont.selectAddress = 'AlternateAddress';
objCont.BusinessUnit = 'Member';
objCont.getMaterialForms();
objCont.btnSubmit();



String str={"findFulfillmentHistoryResult": {"findFulfillmentHistoryResponse": {"searchParameter":    {"searchSourceID": "FISERV","documentID": "Raja_Fax"},"searchResultSet": [   {"responseRequestHeader":       { "requestID": "test_demo_22_1","sourceIDName": "","destinationIDName": "FISERV ID Card Supplier","requestDate": "2017-01-31","businessSegmentName": "","marketSegmentName": "Oxford","fulfillmentTypeBusName": "Claim Pend Letters","requestCategory": "TransactionalInlinePrintReadySingleItem","dataFormat": "pdf","requestorRefNo": "req123","supplierRefNo": "sup01","requestTrailer": {"requestItemCount": 1} },"responseCurrentEventLog":       {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived", "receivedDate": "2017-05-12"dispatchedDate": "2017-05-12","statusCode": "Accepted"},"responseRequestDetail": {"responseTransactionalRequestDetail":       {"responseRecipient": [         {"recipientId": "Raja9","identifierQualifierCodeDescr": "Member ID Type","deliveryMethod1": "Fax", "constituentTypeDescr": "Member Type","person":             {"prefix": "Mr","firstName": "Firstname","middleName": "Middlename","lastName": "Lastname","suffix": "Dr" }"MailToAddress":             {"Address1": "Nilgiri3Appt","Address2": "Sector34","Address3": "CityCenter",  "City": "Noida","State": "UP", "Zip": "201301" }, 3:50 PM "ReturnToAddress":             "Address1": "RosewoodCity", "Address2": "SohnaRoad","Address3": "Street34", "City": "Noida","State": "Noida", "Zip": "201301" }, "faxNumber": "123-990-6734", "emailAddress": "abc@xyz.com"}] "responseTemplate":          {"templateID": "childRequest_1","templateName": "tempname"} }},"responseRequestHistory":       [ {"processorName": "Fulfillment Hub","eventTypeBusName": "Document Archived","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0","documentID": "Raja_Fax", "documentType": "Raja","repositoryName": "Raja" },  {"processorName": "Fulfillment Hub","eventTypeBusName": "Inbound Request","receivedDate": "2017-05-12","dispatchedDate": "2017-05-12","recipientId": "Raja9","deliveryMethodCd": "Fax","statusCode": "Accepted","successCount": "1","exceptionCount": "0"}]}]}}});
HttpResponse res = new HttpResponse();
res.setHeader('Content-Type', 'application/json');
res.setBody(str);
res.setStatusCode(200);*/
    //return res;
    
    
    static testMethod void  ACETProcessFulfillmentWebserviceTest1() 
    {        
        ISL_Webservice_Config__c  isl = new ISL_Webservice_Config__c();
        isl.Name ='OILHttpHeaderScope';
        isl.Is_Available__c=true;
        isl.Value__c='read';
        insert isl;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        ACETProcessFulfillmentWebservice acc = new ACETProcessFulfillmentWebservice();
        acc.GetEndpoint();
        acc.GetHeaders(isl);
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit'); // personOrganisation
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','','memLName','','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        
        ACETWSCalloutResult acet = new ACETWSCalloutResult();
        acet.Success = true;
        acet.Message = 'status';
    }
    
    static testMethod void  ACETProcessFulfillmentWebserviceTest2() 
    {
        //Inserting the Custom Setting values
        
        ISL_Webservice_Config__c  isl1 = new ISL_Webservice_Config__c();
        isl1.Name ='OILHttpHeaderActor';
        isl1.Is_Available__c=true;
        isl1.Value__c='ACET';
        insert isl1;
        
        ISL_Webservice_Config__c  isl2 = new ISL_Webservice_Config__c();
        isl2.Name ='OILHttpHeaderScope';
        isl2.Is_Available__c=true;
        isl2.Value__c='read';
        insert isl2;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        //insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        /*//Calling the methods'
ACETProcessFulfillmentWebservice acc = new ACETProcessFulfillmentWebservice();

ACETProcessFulfillmentWebservice mock = new ACETProcessFulfillmentWebservice(); 
// mock.setStaticResource(ACETTestResources);
//mock.setStatusCode(200); // Or other appropriate HTTP status code
//mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
Test.setMock(HttpCalloutMock.class, mock);

acc.GetEndpoint();
acc.GetHeaders(isl); 
string strREs = '{"success":true,"data":[{"id":69,"code":"38272aae-02bd-4163-8892-7e270789d915","campaign":"JP Sony Playstation April 2016","createdAt":"2016-04-06T15:56:14.648+01:00","updatedAt":"2016-05-04T10:29:38.647+01:00","availableQuantity":999999999999,"effectiveFrom":"2016-04-06T00:00:00.000+01:00","effectiveTo":"2017-04-07T00:00:00.000+01:00","initialQuantity":999999999999,"discount":{"type":"percent","ratePlan":{"id":"2c92c0f953cfa2da0153ec1d544869d2","name":"Livesport Rateplan - Promotion - 3m","status":"Active","description":"Discount applied to give users a service credit. 3 months free trial","OfferType__c":"Discount","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f953cfa2da0153ec1d545b69d4","uom":null,"name":"Discount (Promotion)","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":3,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"subscription","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Billing_Periods","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}},"customFields":{"hey ":{"type":"string","value":"q ","required":false,"validateRequirement":false},"deviceid":{"type":"string","value":"ps","required":false,"validateRequirement":false},"newusers":{"type":"string","value":"0","required":false,"validateRequirement":false},"stringid":{"type":"string","value":"psjp3m","required":false,"validateRequirement":false},"countryid":{"type":"string","value":"jp","required":false,"validateRequirement":false},"frozenuser":{"type":"string","value":"0","required":false,"validateRequirement":false},"expireduser":{"type":"string","value":"0","required":false,"validateRequirement":false},"partialuser":{"type":"string","value":"1","required":false,"validateRequirement":false},"activepaiduser":{"type":"string","value":"0","required":false,"validateRequirement":false},"adctivegraceuser":{"type":"string","value":"0","required":false,"validateRequirement":false},"freesubscription":{"type":"string","value":"0","required":false,"validateRequirement":false}},"ratePlanGroups":[[{"id":"2c92c0f950a292790150af61f31e5f35","name":"Livesport Rateplan - with Free Trial","status":"Active","description":"","OfferType__c":"FreeTrial","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f950d656c10150d8833dc72b9d","uom":null,"name":"Livesport Free Trial ","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"rateplan","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Months","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false},{"id":"2c92c0f950a292790150af61f49a5f38","uom":null,"name":"Livesport Monthly Charge","type":"Recurring","model":"FlatFee","pricing":[{"price":9.99,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":1500.0,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.0,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.99,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null}],"taxCode":"VAT2","taxMode":"TaxInclusive","taxable":true,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":null,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":null,"listPriceBase":"Per_Billing_Period","pricingSummary":["EUR9.99","JPY1500","GBP10","CHF10.99"],"smoothingModel":null,"applyDiscountTo":null,"defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":null,"endDateCondition":"Subscription_End","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}]]},{"id":70,"code":"d4e4bada-4ac7-465b-a3e4-e3ad9f7effc3","campaign":"Test in the Past Promo","createdAt":"2016-04-06T16:02:44.213+01:00","updatedAt":"2016-05-04T07:46:46.016+01:00","availableQuantity":999999999999,"effectiveFrom":"2015-04-06T16:00:00.000+01:00","effectiveTo":"2016-01-01T16:00:00.000+00:00","initialQuantity":999999999999,"discount":{"type":"percent","ratePlan":{"id":"2c92c0f95282215b01528485a5b52a76","name":"Livesport Rateplan - Discount","status":"Active","description":"Discount applied to give users a service credit","OfferType__c":"Discount","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f95282214e015284888fd617ca","uom":null,"name":"Discount (Service Credit)","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"subscription","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Billing_Periods","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}},"customFields":{"country":{"value":"jp","validateRequirement":false}},"ratePlanGroups":[[{"id":"2c92c0f950a292790150af61f31e5f35","name":"Livesport Rateplan - with Free Trial","status":"Active","description":"","OfferType__c":"FreeTrial","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f950d656c10150d8833dc72b9d","uom":null,"name":"Livesport Free Trial ","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"rateplan","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Months","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false},{"id":"2c92c0f950a292790150af61f49a5f38","uom":null,"name":"Livesport Monthly Charge","type":"Recurring","model":"FlatFee","pricing":[{"price":9.99,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":1500.0,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.0,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.99,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null}],"taxCode":"VAT2","taxMode":"TaxInclusive","taxable":true,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":null,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":null,"listPriceBase":"Per_Billing_Period","pricingSummary":["EUR9.99","JPY1500","GBP10","CHF10.99"],"smoothingModel":null,"applyDiscountTo":null,"defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":null,"endDateCondition":"Subscription_End","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}]]},{"id":73,"code":"38272aae-02bd-4163-8892-7e270789d915","campaign":"Test in the Future","createdAt":"2016-04-06T16:04:07.983+01:00","updatedAt":"2016-05-04T07:46:46.182+01:00","availableQuantity":999999999999,"effectiveFrom":"2017-04-06T16:00:00.000+01:00","effectiveTo":"2018-04-07T16:00:00.000+01:00","initialQuantity":999999999999,"discount":{"type":"percent","ratePlan":{"id":"2c92c0f95282215b01528485a5b52a76","name":"Livesport Rateplan - Discount","status":"Active","description":"Discount applied to give users a service credit","OfferType__c":"Discount","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f95282214e015284888fd617ca","uom":null,"name":"Discount (Service Credit)","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"subscription","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Billing_Periods","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}},"customFields":{"country":{"value":"jp","validateRequirement":false}},"ratePlanGroups":[[{"id":"2c92c0f950a292790150af61f31e5f35","name":"Livesport Rateplan - with Free Trial","status":"Active","description":"","OfferType__c":"FreeTrial","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f950d656c10150d8833dc72b9d","uom":null,"name":"Livesport Free Trial ","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"rateplan","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Months","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false},{"id":"2c92c0f950a292790150af61f49a5f38","uom":null,"name":"Livesport Monthly Charge","type":"Recurring","model":"FlatFee","pricing":[{"price":9.99,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":1500.0,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.0,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.99,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null}],"taxCode":"VAT2","taxMode":"TaxInclusive","taxable":true,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":null,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":null,"listPriceBase":"Per_Billing_Period","pricingSummary":["EUR9.99","JPY1500","GBP10","CHF10.99"],"smoothingModel":null,"applyDiscountTo":null,"defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":null,"endDateCondition":"Subscription_End","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}]]}],"pagination":{"page":1,"page_length":20}}';
SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete',strREs,null);
System.assertNotEquals(null, fakeResponse);
Test.setMock(HttpCalloutMock.class, fakeResponse);*/
        
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
        // PageReference pageRef = new WebserviceCall().getaccesstoken();
        
        ACETProcessFulfillmentWebservice acc= new ACETProcessFulfillmentWebservice();
        acc.GetEndpoint();
        acc.GetHeaders(isl1);
        //acc.GetHeaders(isl2);
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit'); // personOrganisation
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','','memLName','','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'Personorg1','Personorg2','BusinessUnit');    
        
        ACETWSCalloutResult acet = new ACETWSCalloutResult();
        acet.Success = true;
        acet.Message = 'status';
    }
    
    static testMethod void  ACETProcessFulfillmentWebserviceTest3() 
    {
        //Inserting the Custom Setting values
        
        ISL_Webservice_Config__c  isl1 = new ISL_Webservice_Config__c();
        isl1.Name ='OILHttpHeaderActor';
        isl1.Is_Available__c=true;
        isl1.Value__c='ACET';
        insert isl1;
        
        ISL_Webservice_Config__c  isl2 = new ISL_Webservice_Config__c();
        isl2.Name ='OILHttpHeaderScope';
        isl2.Is_Available__c=true;
        isl2.Value__c='read';
        insert isl2;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        //insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        Material_Forms__c mform1 = new Material_Forms__c();
        mform1.FulfillmentType__c = '10700';
        mform1.FulfillmentType_Description__c = 'Blank Form';
        mform1.Business_Unit__c = '';
        listMform.add(mform1);
        
        /*//Calling the methods'
ACETProcessFulfillmentWebservice acc = new ACETProcessFulfillmentWebservice();

ACETProcessFulfillmentWebservice mock = new ACETProcessFulfillmentWebservice(); 
// mock.setStaticResource(ACETTestResources);
//mock.setStatusCode(200); // Or other appropriate HTTP status code
//mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
Test.setMock(HttpCalloutMock.class, mock);

acc.GetEndpoint();
acc.GetHeaders(isl); 
string strREs = '{"success":true,"data":[{"id":69,"code":"38272aae-02bd-4163-8892-7e270789d915","campaign":"JP Sony Playstation April 2016","createdAt":"2016-04-06T15:56:14.648+01:00","updatedAt":"2016-05-04T10:29:38.647+01:00","availableQuantity":999999999999,"effectiveFrom":"2016-04-06T00:00:00.000+01:00","effectiveTo":"2017-04-07T00:00:00.000+01:00","initialQuantity":999999999999,"discount":{"type":"percent","ratePlan":{"id":"2c92c0f953cfa2da0153ec1d544869d2","name":"Livesport Rateplan - Promotion - 3m","status":"Active","description":"Discount applied to give users a service credit. 3 months free trial","OfferType__c":"Discount","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f953cfa2da0153ec1d545b69d4","uom":null,"name":"Discount (Promotion)","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":3,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"subscription","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Billing_Periods","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}},"customFields":{"hey ":{"type":"string","value":"q ","required":false,"validateRequirement":false},"deviceid":{"type":"string","value":"ps","required":false,"validateRequirement":false},"newusers":{"type":"string","value":"0","required":false,"validateRequirement":false},"stringid":{"type":"string","value":"psjp3m","required":false,"validateRequirement":false},"countryid":{"type":"string","value":"jp","required":false,"validateRequirement":false},"frozenuser":{"type":"string","value":"0","required":false,"validateRequirement":false},"expireduser":{"type":"string","value":"0","required":false,"validateRequirement":false},"partialuser":{"type":"string","value":"1","required":false,"validateRequirement":false},"activepaiduser":{"type":"string","value":"0","required":false,"validateRequirement":false},"adctivegraceuser":{"type":"string","value":"0","required":false,"validateRequirement":false},"freesubscription":{"type":"string","value":"0","required":false,"validateRequirement":false}},"ratePlanGroups":[[{"id":"2c92c0f950a292790150af61f31e5f35","name":"Livesport Rateplan - with Free Trial","status":"Active","description":"","OfferType__c":"FreeTrial","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f950d656c10150d8833dc72b9d","uom":null,"name":"Livesport Free Trial ","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"rateplan","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Months","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false},{"id":"2c92c0f950a292790150af61f49a5f38","uom":null,"name":"Livesport Monthly Charge","type":"Recurring","model":"FlatFee","pricing":[{"price":9.99,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":1500.0,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.0,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.99,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null}],"taxCode":"VAT2","taxMode":"TaxInclusive","taxable":true,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":null,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":null,"listPriceBase":"Per_Billing_Period","pricingSummary":["EUR9.99","JPY1500","GBP10","CHF10.99"],"smoothingModel":null,"applyDiscountTo":null,"defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":null,"endDateCondition":"Subscription_End","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}]]},{"id":70,"code":"d4e4bada-4ac7-465b-a3e4-e3ad9f7effc3","campaign":"Test in the Past Promo","createdAt":"2016-04-06T16:02:44.213+01:00","updatedAt":"2016-05-04T07:46:46.016+01:00","availableQuantity":999999999999,"effectiveFrom":"2015-04-06T16:00:00.000+01:00","effectiveTo":"2016-01-01T16:00:00.000+00:00","initialQuantity":999999999999,"discount":{"type":"percent","ratePlan":{"id":"2c92c0f95282215b01528485a5b52a76","name":"Livesport Rateplan - Discount","status":"Active","description":"Discount applied to give users a service credit","OfferType__c":"Discount","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f95282214e015284888fd617ca","uom":null,"name":"Discount (Service Credit)","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"subscription","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Billing_Periods","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}},"customFields":{"country":{"value":"jp","validateRequirement":false}},"ratePlanGroups":[[{"id":"2c92c0f950a292790150af61f31e5f35","name":"Livesport Rateplan - with Free Trial","status":"Active","description":"","OfferType__c":"FreeTrial","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f950d656c10150d8833dc72b9d","uom":null,"name":"Livesport Free Trial ","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"rateplan","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Months","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false},{"id":"2c92c0f950a292790150af61f49a5f38","uom":null,"name":"Livesport Monthly Charge","type":"Recurring","model":"FlatFee","pricing":[{"price":9.99,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":1500.0,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.0,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.99,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null}],"taxCode":"VAT2","taxMode":"TaxInclusive","taxable":true,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":null,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":null,"listPriceBase":"Per_Billing_Period","pricingSummary":["EUR9.99","JPY1500","GBP10","CHF10.99"],"smoothingModel":null,"applyDiscountTo":null,"defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":null,"endDateCondition":"Subscription_End","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}]]},{"id":73,"code":"38272aae-02bd-4163-8892-7e270789d915","campaign":"Test in the Future","createdAt":"2016-04-06T16:04:07.983+01:00","updatedAt":"2016-05-04T07:46:46.182+01:00","availableQuantity":999999999999,"effectiveFrom":"2017-04-06T16:00:00.000+01:00","effectiveTo":"2018-04-07T16:00:00.000+01:00","initialQuantity":999999999999,"discount":{"type":"percent","ratePlan":{"id":"2c92c0f95282215b01528485a5b52a76","name":"Livesport Rateplan - Discount","status":"Active","description":"Discount applied to give users a service credit","OfferType__c":"Discount","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f95282214e015284888fd617ca","uom":null,"name":"Discount (Service Credit)","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":"100"}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"subscription","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Billing_Periods","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}},"customFields":{"country":{"value":"jp","validateRequirement":false}},"ratePlanGroups":[[{"id":"2c92c0f950a292790150af61f31e5f35","name":"Livesport Rateplan - with Free Trial","status":"Active","description":"","OfferType__c":"FreeTrial","effectiveEndDate":"2050-01-01","effectiveStartDate":"2015-01-01","productRatePlanCharges":[{"id":"2c92c0f950d656c10150d8833dc72b9d","uom":null,"name":"Livesport Free Trial ","type":"Recurring","model":"DiscountPercentage","pricing":[{"price":null,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0},{"price":null,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":100.0}],"taxCode":null,"taxMode":"TaxExclusive","taxable":false,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":1,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":"rateplan","listPriceBase":null,"pricingSummary":["100%  discount","100%  discount","100%  discount","100%  discount"],"smoothingModel":null,"applyDiscountTo":"ONETIMERECURRINGUSAGE","defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":"Months","endDateCondition":"Fixed_Period","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false},{"id":"2c92c0f950a292790150af61f49a5f38","uom":null,"name":"Livesport Monthly Charge","type":"Recurring","model":"FlatFee","pricing":[{"price":9.99,"tiers":null,"currency":"EUR","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":1500.0,"tiers":null,"currency":"JPY","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.0,"tiers":null,"currency":"GBP","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null},{"price":10.99,"tiers":null,"currency":"CHF","overagePrice":null,"includedUnits":null,"discountAmount":null,"discountPercentage":null}],"taxCode":"VAT2","taxMode":"TaxInclusive","taxable":true,"billingDay":"DefaultFromCustomer","description":"","upToPeriods":null,"triggerEvent":"ContractEffective","billingPeriod":"Month","discountLevel":null,"listPriceBase":"Per_Billing_Period","pricingSummary":["EUR9.99","JPY1500","GBP10","CHF10.99"],"smoothingModel":null,"applyDiscountTo":null,"defaultQuantity":null,"numberOfPeriods":null,"upToPeriodsType":null,"endDateCondition":"Subscription_End","priceChangeOption":"NoChange","specificBillingPeriod":null,"billingPeriodAlignment":"AlignToCharge","priceIncreasePercentage":null,"usageRecordRatingOption":null,"overageCalculationOption":null,"overageUnusedUnitsCreditOption":null,"useTenantDefaultForPriceChange":false}]}]]}],"pagination":{"page":1,"page_length":20}}';
SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete',strREs,null);
System.assertNotEquals(null, fakeResponse);
Test.setMock(HttpCalloutMock.class, fakeResponse);*/
        
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
        // PageReference pageRef = new WebserviceCall().getaccesstoken();
        
        ACETProcessFulfillmentWebservice acc= new ACETProcessFulfillmentWebservice();
        acc.GetEndpoint();
        acc.GetHeaders(isl1);
        //acc.GetHeaders(isl2);
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit'); // personOrganisation
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','','memLName','','perAdd1','perAdd2','perCity','perState','perZip',listMform,'','','BusinessUnit');
        acc.processRedeliveryWS('recepientId','idQuali','recipientType','memFName','memMName','memLName','memSuffix','perAdd1','perAdd2','perCity','perState','perZip',listMform,'Personorg1','Personorg2','BusinessUnit');    
        
        ACETWSCalloutResult acet = new ACETWSCalloutResult();
        acet.Success = true;
        acet.Message = 'status';
    }
    static testMethod void testGetMaterialForma2(){
        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OL');
        ACETFormsHistoryController acetFrmsHistCntr=new ACETFormsHistoryController();
        
        Material_Forms__c matForms=new Material_Forms__c();
        matForms.Business_Unit__c='Member';
        matForms.Document_Title__c='testdoctitle';
        matForms.Document_URL__c='http://oxfayslive.uhc.com/AYS/CustomerService/Attachments/Acrobat/11_Community_Tools/ADA_Dental_Claim_Form.pdf';
        matForms.FulfillmentType__c='testfullfill';
        matForms.MRE__c='testmrc';
        matForms.Quantity__c='1';
        insert matForms;
        acetFrmsHistCntr.BusinessUnit =matForms.Business_Unit__c;
        acetFrmsHistCntr.bookOfBusinessTypeCode ='OX';
        acetFrmsHistCntr.isLevelFunded = false;
        acetFrmsHistCntr.getMaterialForms();
        
        }
    static testMethod void testGetMaterialForma3(){
        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');
        ACETFormsHistoryController acetFrmsHistCntr=new ACETFormsHistoryController();
        
        Material_Forms__c matForms=new Material_Forms__c();
        matForms.Business_Unit__c='Member';
        matForms.Category__c='testcat';
        matForms.Service_Level__c = 'OX';
        matForms.Document_Title__c='testdoctitle';
        matForms.Document_URL__c='http://oxfayslive.uhc.com/AYS/CustomerSerovice/Attachments/Acrobat/11_Community_Tools/ADA_Dental_Claim_Form.pdf';
        matForms.FulfillmentType__c='testfullfill';
        matForms.MRE__c='testmrc';
        matForms.Quantity__c='1';
        insert matForms;
        acetFrmsHistCntr.BusinessUnit =matForms.Business_Unit__c;
        acetFrmsHistCntr.bookOfBusinessTypeCode ='OX';
        acetFrmsHistCntr.getMaterialForms();
        
        }
    static testMethod void testGetMaterialForma(){
        ACETFormsHistoryController acetFrmsHistCntr=new ACETFormsHistoryController();
        
        Material_Forms__c matForms=new Material_Forms__c();
        matForms.Business_Unit__c='Member';
        matForms.Category__c='testcat';
        matForms.Document_Title__c='testdoctitle';
        matForms.Document_URL__c='http://oxfayslive.uhc.com/AYS/CustomerService/test/Attachments/Acrobat/11_Community_Tools/ADA_Dental_Claim_Form.pdf';
        matForms.FulfillmentType__c='testfullfill';
        matForms.MRE__c='testmrc';
        matForms.Quantity__c='1';
        insert matForms;
        acetFrmsHistCntr.isLevelFunded =true;
        acetFrmsHistCntr.BusinessUnit =matForms.Business_Unit__c;
        acetFrmsHistCntr.getMaterialForms();
        
        //Category__c is NULL
        Material_Forms__c matForms1=new Material_Forms__c();
        matForms1.Business_Unit__c='Member';
        //matForms1.Category__c='testcat';
        matForms1.Document_Title__c='testdoctitle';
        matForms1.Document_URL__c='http://oxfayslive.uhc.com/AYS/CustomerService/Attachments/Acrobat/11_Community_Tools/ADA_Dental_Claim_Form.pdf';
        matForms1.FulfillmentType__c='testfullfill';
        matForms1.MRE__c='testmrc';
        matForms1.Quantity__c='testquantity';
        insert matForms1;
        
        acetFrmsHistCntr.getMaterialForms();
        
        //BusinessUnit NULL
        acetFrmsHistCntr.BusinessUnit=null;
        acetFrmsHistCntr.getMaterialForms();
        
        ACETFormsHistoryController.MaterialForms materialFormsList=new ACETFormsHistoryController.MaterialForms(matForms);
        List<ACETFormsHistoryController.MaterialForms> matFormsList=new List<ACETFormsHistoryController.MaterialForms>();
        matFormsList.add(materialFormsList);
        acetFrmsHistCntr.vListMaterialsForms=matFormsList;
        acetFrmsHistCntr.checkValidQuantity();
        
        acetFrmsHistCntr.selectAddress='AddressOnFile';
        acetFrmsHistCntr.btnSubmit();
        
        acetFrmsHistCntr.selectAddress='AlternateAddress';
        acetFrmsHistCntr.btnSubmit();
    }
    static testMethod void ACETFormHistoryControllerTest1() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b8541');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencods3');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 's5plication/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:84433');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/fulfillment/order/v2.0/processFulfillment');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETProcessFulFillmentWebservice'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
        
           RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
            
       
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        Material_Forms__c matform = new Material_Forms__c();
        matform.Document_Title__c = 'Test';
        matform.Document_URL__c = 'TESTURL';
        matform.Category__c = 'TEST FORMS';
        matform.MRE__c = '10700';
        matform.Business_Unit__c = 'Member';
        Insert matform;
        
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        
        
        PageReference pgRef = Page.ACETFormsHistory;
        Test.setCurrentPageReference (pgRef);
        
        ACETFormsHistoryController objCont = new ACETFormsHistoryController();
        
        
        
        objCont.BusinessUnit = 'Member';
        objCont.selectAddress = 'AddressOnFile';
        objCont.recepientId = '69688001800';
        objCont.idQualifier = 'MemberId';
        objCont.recipientType = 'Member';
        objCont.AddOnFilePersonWrap = new ACETFormsHistoryController.personWrapper();
        objCont.AddOnFilePersonWrap.personAddOne = 'Test 123';
        objCont.AddOnFilePersonWrap.personCity = 'HFD';
        objCont.AddOnFilePersonWrap.personState = 'CT';
        objCont.AddOnFilePersonWrap.personZipCode = '06484';
        objCont.AddOnFilePersonWrap.personFirstName = 'Test';
        objCont.AddOnFilePersonWrap.PersonLastName = 'Kelly';
        objCont.getMaterialForms();
        System.debug('test---->'+objCont.vListMaterialsForms);
        
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        //ApexPages.currentPage().getParameters().put('docId',JSON.serialize(new List<String>{'test123','test1234'}));
        // objCont.showbulkResend();
        objCont.btnSubmit();
        Test.Stoptest();
        
    }
    
    
    
    static testMethod void testMemInfo(){
        
        Test.setMock(HttpCalloutMock.class, new GetIndividuakHttpCalloutMock());
        
        ApexPages.currentPage().getParameters().put('SRK','testsrk');
        
        ApexPages.currentPage().getParameters().put('memberId','testmemberId');
        
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findMemberInfo();
            
        }catch(Exception ex){}
        
    }
    
     static testMethod void test123(){
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Producer';        
        insert interaction;
        
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        Test.setMock(HttpCalloutMock.class, new GetIndividualMailingAddHttpCalloutMock());
        
        ApexPages.currentPage().getParameters().put('SRK','');
        
        ApexPages.currentPage().getParameters().put('memberId','testmemberId');
        ApexPages.currentPage().getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","isMember":"false",Relationship":"Test","SitusState":"Test","DOB":"1955-01-01","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"testsrk"}');
        
        
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findMemberInfo();
            
        }catch(Exception ex){}
        
    }
    static testMethod void testMailingAddressAndAge(){
        
        Test.setMock(HttpCalloutMock.class, new GetIndividualMailingAddHttpCalloutMock());
        
        ApexPages.currentPage().getParameters().put('SRK','');
        
        ApexPages.currentPage().getParameters().put('memberId','testmemberId');
        ApexPages.currentPage().getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"1955-01-01","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"testsrk"}');
        
        
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findMemberInfo();
            
        }catch(Exception ex){}
        
    }
    
    static testMethod void testMemInfo1(){
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"1980-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"MAIL","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        ApexPages.currentPage().getParameters().put('SRK','testsrk');
        
        ApexPages.currentPage().getParameters().put('memberId','testmemberId');
        ACETHighlightsPanelAdditionalInfo addinfo1 = new ACETHighlightsPanelAdditionalInfo();
        addinfo1.memberId = 'testmemberId1';
        string addinfojson = Json.serialize(addinfo1);
        ApexPages.currentPage().getParameters().put('additionalinfo', addinfojson);
        
        
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findMemberInfo();
            
        }catch(Exception ex){}
        
    }
    
    static testMethod void testMemInfoUnder12(){
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"2015-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"MAIL","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        ApexPages.currentPage().getParameters().put('SRK','testsrk');
        
        ApexPages.currentPage().getParameters().put('memberId','testmemberId');
        ACETHighlightsPanelAdditionalInfo addinfo1 = new ACETHighlightsPanelAdditionalInfo();
        addinfo1.memberId = 'testmemberId1';
        string addinfojson = Json.serialize(addinfo1);
        ApexPages.currentPage().getParameters().put('additionalinfo', addinfojson);
        
        
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findMemberInfo();
            String profilenametest = acetFrmsHisCntr.getProfileName();
        }catch(Exception ex){}
        
    }
      static testMethod void testMemInfoUnder13(){
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"562369086","name":{"firstName":"GeorgeChild","lastName":"Delgado","middleName":"","nameSuffix":""},"birthDate":"2019-04-25","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"040770771","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","holdEligInd":"false","address":[{"typeCode":"HOM","addressLine1":"123 Texas St","addressLine2":"","city":"SARASOTA","postalCode":"34240","stateCode":"FL","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"213-471-2299","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{"languageCode":"ENG","languageUsedTypeCode":"5","languageUsedTypeDescription":"Language_Reading"}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"722102046","type":"SRK"}]}}}');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
          
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"findMembershipsResponse":{"memberships":[{"sourceSysCode":"CR","coverages":[{"subscriberSystemSpecificIdentifiers":[{"id":"100000120654","type":"subscriberSystemID"},{"id":"541838151","type":"subscriberIndividualIdentifier"},{"id":"703203458","type":"subscriberSurrogateKey"}],"groupNumber":"1280801","groupName":"CONCEPTS OF INDEPENDENCE","membershipEffectiveDate":"2020-01-01","membershipExpirationDate":"9999-12-31","coverageType":"M","coverageTypeDescription":"MEDICAL","coverageLevelCode":"EMP","product":{"productIdentifier":"PM00000028","productName":"OHI EPO Non Gated","productType":""},"benefit":{"benefitPlanId":"M000000579","benefitPlanName":"NY 25/40/500/100 EPO","planOptionID":"PO100003","riderOnlyIndicator":"N","customerPurchase":[{"customerPurchaseId":"242601-1014406-8636686-PO100003"}],"bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford"},"relationshipCode":"18","privacyIndicator":"N","relationshipDescription":"Self","legacyAttributes":{"eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR"}},{"subscriberSystemSpecificIdentifiers":[{"id":"100000120654","type":"subscriberSystemID"},{"id":"541838151","type":"subscriberIndividualIdentifier"},{"id":"703203458","type":"subscriberSurrogateKey"}],"groupNumber":"1280801","groupName":"CONCEPTS OF INDEPENDENCE","membershipEffectiveDate":"2020-01-01","membershipExpirationDate":"9999-12-31","coverageType":"M","coverageTypeDescription":"MEDICAL","coverageLevelCode":"","product":{"productIdentifier":"PM00000031","productName":"Oxford Non-Gated POS","productType":""},"benefit":{"benefitPlanId":"MR00000082","benefitPlanName":"NY ER $200 Rider No Ded Rider","planOptionID":"PO100003","riderOnlyIndicator":"Y","customerPurchase":[{"customerPurchaseId":"242601-1014406-8636686-PO100003"}],"bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford"},"relationshipCode":"18","privacyIndicator":"N","relationshipDescription":"Self","legacyAttributes":{"eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR"}},{"subscriberSystemSpecificIdentifiers":[{"id":"100000120654","type":"subscriberSystemID"},{"id":"541838151","type":"subscriberIndividualIdentifier"},{"id":"703203458","type":"subscriberSurrogateKey"}],"groupNumber":"1280801","groupName":"CONCEPTS OF INDEPENDENCE","membershipEffectiveDate":"2020-01-01","membershipExpirationDate":"9999-12-31","coverageType":"RX","coverageTypeDescription":"PHARMACY","coverageLevelCode":"","product":{"productIdentifier":"PR00000001","productName":"Pharmacy","productType":""},"benefit":{"benefitPlanId":"RX00000255","benefitPlanName":"$50D $10/$25/$50","planOptionID":"PO100003","riderOnlyIndicator":"Y","customerPurchase":[{"customerPurchaseId":"242601-1014406-8636686-PO100003"}],"bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford"},"relationshipCode":"18","privacyIndicator":"N","relationshipDescription":"Self","legacyAttributes":{"eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR"}}],"identifiers":[{"id":"052828192","type":"EAI"},{"id":"1374973001","type":"PS"},{"id":"93697375600","type":"MCH"},{"id":"93697375600","type":"SCR"}],"enrolleeSystemSpecificIdentifiers":[{"id":"100000120654","type":"enrolleeSystemID"},{"id":"541838151","type":"enrolleeIndividualIdentifier"},{"id":"703203458","type":"enrolleeSurrogateKey"}]}],"pagination":{"pageNumber":"1","pageSize":"50","recordCount":"1","totalCount":"1","totalPages":"1"}}}');
        OILResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
        Test.setMock(HttpCalloutMock.class, MockHttpRes3);
          
          
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"562369086","name":{"firstName":"GeorgeChild","lastName":"Delgado","middleName":"","nameSuffix":""},"birthDate":"2019-04-25","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"040770771","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"142 White Birch Road","addressLine2":"","city":"NEW CANAAN","postalCode":"06840","stateCode":"CT","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1260145","groupName":"HR NUCLEUS","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000833","benefitPlanName":"CT_LG_DIRECT HSA_18HSA01","benefitType":"MD","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"96432336201","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000018","benefitPlanName":"LG $5/$30/$60 Traditional","benefitType":"RX","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006"},"relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"96432336201","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"MD","cobTypeCodeDescription":"Medical","otherInsurancePrimacyIndicator":"P","coverageType":"1","cobEffectiveStartDate":"2016-05-05","cobEffectiveEndDate":"2022-10-31","otherInsuranceVerifyDate":"2017-06-06","otherInsurancePolicyNumber":"12346","otherInsuranceCardholderId":"","otherInsuranceCarrierName":"","cobRelatedEntityContactTelephoneNumber":""}],"providers":[{"providerIdentifiers":[{"id":"1217620","type":"MPI"},{"id":"878546188532357034","type":"LTK"},{"id":"ZP292","type":"PUL"},{"id":"BG2457922","type":"1C"},{"id":"1740357540","type":"NPI"},{"id":"759707183","type":"SSN"}],"assignmentType":"PCP","effectiveDate":"2021-03-04","expirationDate":"2021-05-13","firstName":"EVA","lastName":"GRUNBERG","networkId":"0","organizationLocationId":"0","locationAffiliationId":"61839372","address1":"173 EAST AVE","address2":"","address3":"","address4":"","address5":"","city":"NEW CANAAN","state":"CT","postalCode":"06840-5614","country":"US"},{"providerIdentifiers":[{"id":"892146460","type":"SSN"},{"id":"1699195362","type":"NPI"},{"id":"P5079861","type":"PUL"},{"id":"5038799","type":"MPI"},{"id":"224646187552643656","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2021-05-14","expirationDate":"9999-12-31","firstName":"ELIZABETH","lastName":"CIPOLLA","networkId":"0","organizationLocationId":"44401297","locationAffiliationId":"58560835","address1":"183 CHERRY ST","address2":"","address3":"","address4":"","address5":"","city":"NEW CANAAN","state":"CT","postalCode":"06840-4820","country":"US"}],"clinicalProgram":[],"identifiers":[{"id":"562369086","type":"enrolleeEID"},{"id":"100000477227","type":"subscriberSystemId"},{"id":"100000477226","type":"enrolleeSystemID"},{"id":"722101868","type":"subscriberSurrogateKey"},{"id":"722102046","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"562368928","name":{"firstName":"Zara","lastName":"FluffyPants","middleName":"","nameSuffix":""},"birthDate":"1973-08-09","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"040765431","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"142 White Birch Road","addressLine2":"","city":"HOLTSVILLE","postalCode":"00501","stateCode":"NY","countryCode":"US"}],"dependentDisabilityList":[{}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1260145","groupName":"HR NUCLEUS","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000833","benefitPlanName":"CT_LG_DIRECT HSA_18HSA01","benefitType":"MD","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"96432336200","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1868479","benefitBundleOptionDescription":"HSA PLAN","benefitEffectiveDate":"2020-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000018","benefitPlanName":"LG $5/$30/$60 Traditional","benefitType":"RX","coverageLevelCode":"E1D","product":{"productIdentifier":"PM00000006"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"96432336200","subscriberIdCardSerialNumber":"96432336200","eligibilityStatusCode":"A","cancelReasonTypeCode":"","memberDirectBillingInd":"false","linkedSubscriberId":"","planType":"03","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"E1D","covLevelDesc":"Employee and One Dependent","covLevelEffDate":"2020-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{"providerIdentifiers":[{"id":"378046189529010339","type":"LTK"},{"id":"BP501","type":"PUL"},{"id":"1285697201","type":"NPI"},{"id":"800456","type":"1C"},{"id":"1481731","type":"MPI"},{"id":"263920","type":"1C"},{"id":"815903735","type":"SSN"}],"assignmentType":"PCP","effectiveDate":"2021-01-01","expirationDate":"2021-02-23","firstName":"GLEN","lastName":"BERGER","networkId":"0","organizationLocationId":"0","locationAffiliationId":"59333778","address1":"110 WARREN AVE STE 5","address2":"","address3":"","address4":"","address5":"","city":"HO HO KUS","state":"NJ","postalCode":"07423-1561","country":"US"},{"providerIdentifiers":[{"id":"882864580","type":"SSN"},{"id":"1467563403","type":"NPI"},{"id":"069SG","type":"1C"},{"id":"P4493261","type":"PUL"},{"id":"P3536692","type":"PUL"},{"id":"298546194759224274","type":"LTK"},{"id":"2493034","type":"MPI"}],"assignmentType":"PCP","effectiveDate":"2021-02-24","expirationDate":"2021-03-03","firstName":"EDWARD","lastName":"CELMER","networkId":"0","organizationLocationId":"0","locationAffiliationId":"58921707","address1":"1023 FOREST HILL RD","address2":"","address3":"","address4":"","address5":"","city":"STATEN ISLAND","state":"NY","postalCode":"10314-6323","country":"US"},{"providerIdentifiers":[{"id":"756143571","type":"SSN"},{"id":"P4223497","type":"PUL"},{"id":"3212152","type":"MPI"},{"id":"1285832386","type":"NPI"},{"id":"796246190460960864","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2021-03-04","expirationDate":"2021-03-29","firstName":"LORRAINE","lastName":"BINNS-GREAR","networkId":"0","organizationLocationId":"0","locationAffiliationId":"61445325","address1":"36 WHITING ST","address2":"","address3":"","address4":"","address5":"","city":"PLAINVILLE","state":"CT","postalCode":"06062-3323","country":"US"},{"providerIdentifiers":[{"id":"1083651202","type":"NPI"},{"id":"112778918","type":"SSN"},{"id":"2712730","type":"MPI"},{"id":"803157543870753887","type":"LTK"},{"id":"P3695856","type":"PUL"},{"id":"P4553311","type":"PUL"},{"id":"6594912","type":"MPI"},{"id":"A400027080","type":"1C"},{"id":"393345891109261424","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2021-03-30","expirationDate":"2021-03-30","firstName":"DENNIS","lastName":"CHANG","networkId":"0","organizationLocationId":"0","locationAffiliationId":"59424848","address1":"PO BOX 110580","address2":"","address3":"","address4":"","address5":"","city":"TRUMBULL","state":"CT","postalCode":"06611-0580","country":"US"},{"providerIdentifiers":[{"id":"1083651202","type":"NPI"},{"id":"112778918","type":"SSN"},{"id":"2712730","type":"MPI"},{"id":"803157543870753887","type":"LTK"},{"id":"P3695856","type":"PUL"},{"id":"P4553311","type":"PUL"},{"id":"6594912","type":"MPI"},{"id":"A400027080","type":"1C"},{"id":"393345891109261424","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2021-03-31","expirationDate":"2021-05-04","firstName":"DENNIS","lastName":"CHANG","networkId":"0","organizationLocationId":"44282070","locationAffiliationId":"59424850","address1":"17 E 102ND ST","address2":"","address3":"","address4":"","address5":"","city":"NEW YORK","state":"NY","postalCode":"10029-5204","country":"US"},{"providerIdentifiers":[{"id":"901655773","type":"SSN"},{"id":"5109937","type":"MPI"},{"id":"H505770","type":"1C"},{"id":"1609197888","type":"NPI"},{"id":"125746197655054630","type":"LTK"},{"id":"P5062197","type":"PUL"}],"assignmentType":"OBGYN","effectiveDate":"2021-04-05","expirationDate":"9999-12-31","firstName":"KATIE","lastName":"PROPST","networkId":"0","organizationLocationId":"0","locationAffiliationId":"58071364","address1":"111 PARK ST","address2":"","address3":"","address4":"","address5":"","city":"HARTFORD","state":"CT","postalCode":"06106-2520","country":"US"},{"providerIdentifiers":[{"id":"5289425","type":"MPI"},{"id":"D400236068","type":"1C"},{"id":"PENDING","type":"1C"},{"id":"598848577055736089","type":"LTK"},{"id":"P5138634","type":"PUL"},{"id":"1821232034","type":"NPI"},{"id":"722067031","type":"SSN"}],"assignmentType":"PCP","effectiveDate":"2021-05-05","expirationDate":"2021-05-18","firstName":"THOMAS","lastName":"ABBENANTE","networkId":"0","organizationLocationId":"0","locationAffiliationId":"60462012","address1":"279 CHASE AVE","address2":"","address3":"","address4":"","address5":"","city":"WATERBURY","state":"CT","postalCode":"06704-2236","country":"US"},{"providerIdentifiers":[{"id":"1245219526","type":"NPI"},{"id":"2474324","type":"MPI"},{"id":"706805780","type":"SSN"},{"id":"294048545302705564","type":"LTK"},{"id":"P5140339","type":"PUL"},{"id":"080001369","type":"1C"}],"assignmentType":"PCP","effectiveDate":"2021-05-19","expirationDate":"2021-07-21","firstName":"JERI","lastName":"STEELE","networkId":"0","organizationLocationId":"0","locationAffiliationId":"58893726","address1":"550 MAIN ST","address2":"","address3":"","address4":"","address5":"","city":"HARTFORD","state":"CT","postalCode":"06103-2913","country":"US"},{"providerIdentifiers":[{"id":"6518916","type":"MPI"},{"id":"P6005815","type":"PUL"},{"id":"807753207","type":"SSN"},{"id":"886955078509365497","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2021-07-22","expirationDate":"9999-12-31","firstName":"JAXS","lastName":"DESMOND","networkId":"0","organizationLocationId":"44965077","locationAffiliationId":"61913594","address1":"169 CENTER ST","address2":"","address3":"","address4":"","address5":"","city":"SHELTON","state":"CT","postalCode":"06484-3241","country":"US"}],"identifiers":[{"id":"562368928","type":"enrolleeEID"},{"id":"100000477227","type":"subscriberSystemId"},{"id":"100000477227","type":"enrolleeSystemID"},{"id":"722101868","type":"subscriberSurrogateKey"},{"id":"722101868","type":"enrolleeSurrogat');
        OILResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
          
        ApexPages.currentPage().getParameters().put('SRK','722102046');
        
        ApexPages.currentPage().getParameters().put('memberId','96432336201');
        ACETHighlightsPanelAdditionalInfo addinfo1 = new ACETHighlightsPanelAdditionalInfo();
        addinfo1.memberId = 'testmemberId1';
        string addinfojson = Json.serialize(addinfo1);
        ApexPages.currentPage().getParameters().put('additionalinfo', addinfojson);
        
        
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findMemberInfo();
            String profilenametest = acetFrmsHisCntr.getProfileName();
        }catch(Exception ex){}
        
    }
  
     static testMethod void findProviderInfotest(){
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b8s2');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencods4');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 's6application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:84432');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalHCOResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
          RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
            
       
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Group/Employer';        
        insert interaction;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        
        
        ApexPages.currentPage().getParameters().put('ProvTypeCode','HCO');
        Test.setMock(HttpCalloutMock.class, new FindProviderInfoCalloutMock1());
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findProviderInfo();
        }catch(Exception ex){}
    
        
    }
   
    static testMethod void testGroupInfo(){
        String resp =         '{"getEmployerGroup":{"getEmployerGroupResponse":{"employerGroup":{"groupNumber":"2268479","groupName":"SIT Consumer1","sourceSysCode":"CIRRUS","taxIdentificationNumber":["584632457"],"onshoreRestriction":"07","employeeCounts":[{"employeeCountDescription":"Retired","employeeCount":"50"},{"employeeCountDescription":"Union Eligible","employeeCount":"35"},{"employeeCountDescription":"Part-Time","employeeCount":"35"},{"employeeCountDescription":"Total Count of Full Time Employees","employeeCount":"50"},{"employeeCountDescription":"Average Total Number of Employees (ATNE)","employeeCount":"35"},{"employeeCountDescription":"Other","employeeCount":"34"},{"employeeCountDescription":"Total Eligible","employeeCount":"30"},{"employeeCountDescription":"Full-Time-Equivalent","employeeCount":"50"}],"groupAddress":[{"addressTypeCode":"M","addressTypeDescription":"Consumer Mailing Address","addressLine1":"123 test","addressCity":"CANAAN","addressPostalCode":"06018","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America","phone":[{"phoneType":"B","phoneTypeDescription":"Business","telephoneNumber":"676-887-7890","phonePrimaryIndicator":"0"}]},{"salesOfficeCode":"1","salesOfficeDescription":"Sales Office ID"},{"addressTypeCode":"M","addressTypeDescription":"Consumer Mailing Address","addressLine1":"101 River Side","addressLine2":"App 291","addressCity":"PALM BEACH GARDENS","addressPostalCode":"33418","addressStateCode":"FL","addressCountryCode":"US","addressCountryDescription":"United States of America","phone":[{"phoneType":"W","phoneTypeDescription":"Work","telephoneNumber":"827-282-7278","phoneExtension":"8272","phonePrimaryIndicator":"1"}]},{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"51 Hill View St","addressCity":"PALM BEACH GARDENS","addressPostalCode":"33418","addressStateCode":"FL","addressCountryCode":"US","addressCountryDescription":"United States of America","phone":[{"phoneType":"M","phoneTypeDescription":"Mobile","telephoneNumber":"645-446-2701","phonePrimaryIndicator":"0"}]}],"groupContact":[{"roleType":"1","roleDescription":"Benefit Administrator","primaryIndicatorCode":"1","primaryIndicatorDescription":"Primary","firstName":"Jonas","lastName":"Keuning","middleName":"M","nameSuffix":"3","startDate":"2017-01-01","endDate":"9999-12-31","phone":[{"telephoneNumber":"645-666-2701"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"jonas137@optum.com"}],"address":[{"addressTypeCode":"B","addressTypeDescription":"Billing","addressLine1":"601 Rock Street","addressLine2":"New Site","addressCity":"FORT LEE","addressPostalCode":"07024","addressStateCode":"NJ","addressCountryCode":"US","addressCountryDescription":"United States of America"}]},{"roleType":"3","roleDescription":"Banking Contact","primaryIndicatorCode":"1","primaryIndicatorDescription":"Primary","firstName":"Jonas","lastName":"Keuning","middleName":"M","nameSuffix":"3","startDate":"2017-01-01","endDate":"9999-12-31","phone":[{"telephoneNumber":"645-666-2701"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"jonas137@optum.com"}],"address":[{"addressTypeCode":"B","addressTypeDescription":"Billing","addressLine1":"601 Rock Street","addressLine2":"New Site","addressCity":"FORT LEE","addressPostalCode":"07024","addressStateCode":"NJ","addressCountryCode":"US","addressCountryDescription":"United States of America"}]},{"roleType":"5","roleDescription":"Partner","primaryIndicatorCode":"1","primaryIndicatorDescription":"Primary","firstName":"Jonas","lastName":"Keuning","middleName":"M","nameSuffix":"3","startDate":"2017-01-01","endDate":"9999-12-31","phone":[{"telephoneNumber":"645-666-2701"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"jonas137@optum.com"}],"address":[{"addressTypeCode":"B","addressTypeDescription":"Billing","addressLine1":"601 Rock Street","addressLine2":"New Site","addressCity":"FORT LEE","addressPostalCode":"07024","addressStateCode":"NJ","addressCountryCode":"US","addressCountryDescription":"United States of America"}]},{"roleType":"2","roleDescription":"Billing Contact","primaryIndicatorCode":"1","primaryIndicatorDescription":"Primary","firstName":"Jonas","lastName":"Keuning","middleName":"M","nameSuffix":"3","startDate":"2017-01-01","endDate":"9999-12-31","phone":[{"telephoneNumber":"645-666-2701"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"jonas137@optum.com"}],"address":[{"addressTypeCode":"B","addressTypeDescription":"Billing","addressLine1":"601 Rock Street","addressLine2":"New Site","addressCity":"FORT LEE","addressPostalCode":"07024","addressStateCode":"NJ","addressCountryCode":"US","addressCountryDescription":"United States of America"}]}],"groupSupportTeamContact":[{"serviceTeam":"1","roleType":"BA","roleDescription":"Billing Analyst","startDate":"2014-01-01","endDate":"9999-12-31","phone":[{"phoneType":"N","phoneTypeDescription":"Appointment","telephoneNumber":"900-700-1000","phoneExtension":"111"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"jack@gmail.com"}]},{"serviceTeam":"1008476","roleType":"AMR","roleDescription":"Account Manager","startDate":"2014-01-01","endDate":"9999-12-31"},{"serviceTeam":"1008477","roleType":"CSM","roleDescription":"Client Service Manager","firstName":"Nick","lastName":"Jones","startDate":"2017-01-01","endDate":"9999-12-31","phone":[{"phoneType":"H","phoneTypeDescription":"Home","telephoneNumber":"555-848-3822","phoneExtension":"4545"},{"phoneType":"H","phoneTypeDescription":"Home","telephoneNumber":"555-848-3822"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"nicholas_w_jones@optum.com"}]}],"groupPopulation":[{"classesCode":"82728272827","classesDescription":"Pop100000","openEnrollmentPopulationClassStartDate":"2016-12-01","openEnrollmentPopulationClassEndDate":"2016-12-31"}],"customerAccount":[{"planBillingGroupNumber":"15904","statusCode":"O","statusDescription":"On-Hold","startDate":"2017-01-01","renewalDate":"2018-10-01","terminationDate":"9999-12-31","customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffStartDate":"2017-01-01","dependentCutOffEndDate":"9999-12-31","waiveRehiredIndefiniteIndicator":"1","waiveRehiredWithinCount":"30","waiveRehiredWithinType":"D","terminationLagType":"005","terminationLagDescription":"Last Day of Event Year","terminationLagStartDate":"2017-01-01","terminationLagEndDate":"9999-12-31","newHireWaitingPeriodType":"1118476","newHireWaitingStartDate":"2017-01-01","newHireWaitingEndDate":"9999-12-31"},{"dependentCutOff":"28","dependentCutOffStartDate":"2017-01-01","dependentCutOffEndDate":"9999-12-31","waiveRehiredIndefiniteIndicator":"0","terminationLagStartDate":"2017-01-01","terminationLagEndDate":"9999-12-31","newHireWaitingPeriodType":"1208476","newHireWaitingStartDate":"2017-01-01","newHireWaitingEndDate":"9999-12-31"},{"dependentCutOff":"26","dependentCutOffStartDate":"2017-01-01","dependentCutOffEndDate":"9999-12-31","waiveRehiredIndefiniteIndicator":"0","terminationLagStartDate":"2017-01-01","terminationLagEndDate":"9999-12-31","newHireWaitingPeriodType":"1208476","newHireWaitingStartDate":"2017-01-01","newHireWaitingEndDate":"9999-12-31"},{"dependentCutOff":"28","dependentCutOffStartDate":"2017-01-01","dependentCutOffEndDate":"9999-12-31","waiveRehiredIndefiniteIndicator":"1","waiveRehiredWithinCount":"30","waiveRehiredWithinType":"D","terminationLagType":"005","terminationLagDescription":"Last Day of Event Year","terminationLagStartDate":"2017-01-01","terminationLagEndDate":"9999-12-31","newHireWaitingPeriodType":"1118476","newHireWaitingStartDate":"2017-01-01","newHireWaitingEndDate":"9999-12-31"}],"customerPurchase":[{"stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","coverageStartDate":"2017-01-01","coverageExpirationDate":"9999-12-31","benefitBundleOptionID":"1840004","openEnrollmentStartDate":"2016-12-01","openEnrollmentEndDate":"2016-12-31","timePeriodQualifier":"01","billingSchedule":[{"ratingMethodology":"02","genderLimit":"A","ageBandFromValue":"21","ageBandToValue":"21"},{"ratingMethodology":"02","genderLimit":"A","ageBandFromValue":"22","ageBandToValue":"22"},{"ratingMethodology":"02","genderLimit":"A","ageBandFromValue":"0","ageBandToValue":"20"}]},{"memberGroupContractPlanOptionID":"4310001","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2017-01-01","coverageExpirationDate":"9999-12-31","benefitBundleOptionID":"2020004","openEnrollmentStartDate":"2016-12-01","openEnrollmentEndDate":"2016-12-31","timePeriodQualifier":"01","benefitBasePlan":"M000000014_MOH","benefitPlanDescription":"Copy of MD M000000014","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"networkScheduleId":[""]},{"memberGroupContractPlanOptionID":"4330001","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2017-01-01","coverageExpirationDate":"9999-12-31","benefitBundleOptionID":"1890005","openEnrollmentStartDate":"2016-12-01","openEnrollmentEndDate":"2016-12-31","timePeriodQualifier":"01","benefitBasePlan":"M000000014_ACCUM2","benefitPlanDescription":"M000000014_ACCUM2","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"networkScheduleId":[""]}]}]}}}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', resp);
        OILResponse2.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        ApexPages.currentPage().getParameters().put('groupID','2268479');
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findGroupInfo();
        }catch(Exception ex){}
    }
   /* static testMethod void testGroupInfoCorpAdd(){
        Test.setMock(HttpCalloutMock.class, new FindGroupInfoMockCorpAdd());
        ApexPages.currentPage().getParameters().put('groupID','testgroupid');
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findGroupInfo();
        }catch(Exception ex){}
    }*/
    static testMethod void testProducerInfo(){
        Test.setMock(HttpCalloutMock.class, new FindProducerInfoHttpCalloutMock());
        ApexPages.currentPage().getParameters().put('producerId','testprodid');
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findProducerInfo();
        }catch(Exception ex){}
    }
    static testMethod void testProducerInfo2(){
        Test.setMock(HttpCalloutMock.class, new FindProducerInfoHttpCalloutMockAlt());
        ApexPages.currentPage().getParameters().put('producerId','testprodid');
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findProducerInfo();
        }catch(Exception ex){}
    }
    static testmethod void testProducerWithMember(){
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Producer';        
        insert interaction;
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        pageRef.getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","isMember":false,"Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"Test"}');
        pageRef.getParameters().put('groupID', 'test');
        pageRef.getParameters().put('SRK', 'test');
        
        ACETFormsHistoryController controller = new ACETFormsHistoryController();
        ACETFormsHistoryController.MaterialForms contwrapr = new ACETFormsHistoryController.MaterialForms(mform);
        ACETFormsHistoryController.personWrapper contprsnwrapr = new ACETFormsHistoryController.personWrapper();
        
        controller.getdocumentTypeValues();
        controller.getBusinessUnitValues();
        
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();        
        controller.wrapper  =datawrpr;
        controller.subject =cont;
        
        controller.BusinessUnit ='Test';
        controller.source='Test';
        controller.doctype='Test';
        controller.neworder='Test';
        controller.orderhistory='Data';
        controller.order='Test';
        controller.enddate='2/2/17';
        controller.chooseAddress=true;
        controller.personOrganizationAA1='Test';
        controller.personOrganizationAA2='Test';
        controller.personFirstNameAA='Test';
        controller.personMiddleNameAA='Test';
        controller.personLastNameAA='Test';
        controller.personSuffixAA='Test';
        controller.personAddOneAA='Test';
        controller.personAddTwoAA='Test';
        controller.personCityAA='Test';
        controller.personStateAA='Test';
        controller.personZipCodeAA='Test';
        controller.selectAddress='Test';
        controller.hpAdditionInfoStr='Test'; 
        controller.recepientId='Test';
        controller.idQualifier='Test';
        controller.recipientType='Test';
        
        controller.startdate = interaction;
        controller.Interaction = interaction;
        controller.MaterialForms();
        controller.checkValidQuantity();
        controller.findProducerInfo();
        controller.search();
        controller.calculateEnddate();
        controller.changeOrderDate();
        controller.init();
        controller.clearsearch();
        //controller.findMemberInfo();
        //controller.findProviderInfo();
        controller.btnSubmit();
        controller.checkValidQuantity();
        
    }
    static testmethod void testProviderWithMember(){
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Provider';        
        insert interaction;
        
        Case TestC = new Case(Subject='Test Controller Acct Case',Interaction__c = interaction.id,Status='open');
        insert TestC;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        pageRef.getParameters().put('additionalInfo', '{"OriginatorRelationship":"Test","isMember":false,"Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test","MemberId":"Test"}');
        pageRef.getParameters().put('groupID', 'test');
        pageRef.getParameters().put('SRK', 'test');
        
        ACETFormsHistoryController controller = new ACETFormsHistoryController();
        ACETFormsHistoryController.MaterialForms contwrapr = new ACETFormsHistoryController.MaterialForms(mform);
        ACETFormsHistoryController.personWrapper contprsnwrapr = new ACETFormsHistoryController.personWrapper();
        
        controller.getdocumentTypeValues();
        controller.getBusinessUnitValues();
        
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();        
        controller.wrapper  =datawrpr;
        controller.subject =cont;
        
        controller.BusinessUnit ='Test';
        controller.source='Test';
        controller.doctype='Test';
        controller.neworder='Test';
        controller.orderhistory='Data';
        controller.order='Test';
        controller.enddate='2/2/17';
        controller.chooseAddress=true;
        controller.personOrganizationAA1='Test';
        controller.personOrganizationAA2='Test';
        controller.personFirstNameAA='Test';
        controller.personMiddleNameAA='Test';
        controller.personLastNameAA='Test';
        controller.personSuffixAA='Test';
        controller.personAddOneAA='Test';
        controller.personAddTwoAA='Test';
        controller.personCityAA='Test';
        controller.personStateAA='Test';
        controller.personZipCodeAA='Test';
        controller.selectAddress='Test';
        controller.hpAdditionInfoStr='Test'; 
        controller.recepientId='Test';
        controller.idQualifier='Test';
        controller.recipientType='Test';
        
        controller.startdate = interaction;
        controller.Interaction = interaction;
        controller.MaterialForms();
        controller.checkValidQuantity();
        controller.findProducerInfo();
        controller.search();
        controller.calculateEnddate();
        controller.changeOrderDate();
        controller.init();
        controller.clearsearch();
        //controller.findMemberInfo();
        //controller.findProviderInfo();
        controller.btnSubmit();
        controller.checkValidQuantity();
        
    }
    static testMethod void testProviderInfo(){
        /*Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Tax_ID__c = '123456789';
        cont.EID__c = '123456789';
        insert cont;*/
           RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
            
       
        
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = cont.Id; 
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Group/Employer';        
        insert interaction;
        
        Material_Forms__c mform = new Material_Forms__c();
        mform.FulfillmentType__c = '10700';
        mform.FulfillmentType_Description__c = 'Blank Form';
        mform.Business_Unit__c = '';
        
        insert mform;
        
        List<Material_Forms__c> listMform = new List<Material_Forms__c>();
        listMform.add(mform);
        
        PageReference pageRef = Page.ACETFormsHistory;
        test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('interactionId', interaction.id);
        
        
        ApexPages.currentPage().getParameters().put('ProvTypeCode','HCO');
        Test.setMock(HttpCalloutMock.class, new FindProviderInfoCalloutMock1());
        ACETFormsHistoryController acetFrmsHisCntr=new ACETFormsHistoryController();
        try{
            acetFrmsHisCntr.init();
            acetFrmsHisCntr.findProviderInfo();
        }catch(Exception ex){}
    }
    
    
    /*{findFulfillmentHistoryResult:{findFulfillmentHistoryResponse:{searchParameter: Test,searchResultSet:[{responseRequestHeader:{requestTrailer: Test},responseCurrentEventLog: Test,responseRequestDetail:{responseTransactionalRequestDetail:{responseRecipient:[{mailToAddress: mailto@gmail.com}],responseTemplate: Test},}, responseRequestHistory:[]}]  }}};*/
}