@isTest
    private class ACETLGT_MaterialsRequestControllerTest{
        static testMethod void ACETLGT_MaterialsRequestContrMethod(){
            
            ACETLGT_FormsHistoryWebService acetFrmsHisWebServ = new ACETLGT_FormsHistoryWebService ();
            acetFrmsHisWebServ.init();
            acetFrmsHisWebServ.init('testSrcID',1,'testStDate','testEndDate','testRecID','testQualiID');
            acetFrmsHisWebServ.formatDatetime('2017-07-08T12:00:00Z');
            acetFrmsHisWebServ.formatDatetime('2017-07-08');
            acetFrmsHisWebServ.FormatRecpt('testrecep');
            acetFrmsHisWebServ.formatStartDate('2017-07-08T12:00:00Z');
            acetFrmsHisWebServ.formatStartDate('2017-07T12:00:00Z');
            acetFrmsHisWebServ.formatEndDate('2017/07/08T12:00:00Z');
            acetFrmsHisWebServ.formatEndDate('2017/07T12:00:00Z');
               StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'AcetFindFulfillmentHistoryResultJSON'];
             String ResponseJSON = ResponseJSONSR.Body.toString(); 
            system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
              MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
                OILTestResponse1.TokenExpired = false;
                MockHttpCalloutResponseGenerator MockHttpResponse1 = new MockHttpCalloutResponseGenerator(null, OILTestResponse1);
                Test.setMock(HttpCalloutMock.class, MockHttpResponse1);
                 ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','test');           
            ACETLGT_MaterialsRequestController.getMaterialForms('test');  
        }
    
        static testMethod void ACETLGT_MaterialsRequestContrMethod1(){
            ACETLGT_MaterialsRequestController tst= new ACETLGT_MaterialsRequestController();
            Material_Forms__c mform = new Material_Forms__c();
            mform.FulfillmentType__c = '107001';
            mform.FulfillmentType_Description__c = 'Blank Form';
            mform.Category__c='';
            mform.Business_Unit__c = '';
            
            insert mform;
            
            Material_Forms__c mform1 = new Material_Forms__c();
            mform1.FulfillmentType__c = '10700';
            mform1.Category__c='test';
            mform1.FulfillmentType_Description__c = 'Blank Form';
            mform1.Business_Unit__c = '';
            insert mform1;
            ACETLGT_MaterialsRequestController.resultswrap  vform = new ACETLGT_MaterialsRequestController.resultswrap();
            List< Material_Forms__c> listMform = new List<Material_Forms__c >();
            listMform.add(mform);
            listMform.add(mform1);
            
            //ACETLGT_MaterialsRequestController.resultswrap  tst1= new ACETLGT_MaterialsRequestController.resultswrap();
            //tst1.vListMaterialsForms = listMform;
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
            
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseInpatient = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetInpatientDetailResponseJSONTest() );
            OILResponseInpatient.TokenExpired = false;    
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseInpatient);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
    
            ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','test');           
            ACETLGT_MaterialsRequestController.getMaterialForms('test');  
           
        }
            
        static testMethod void ACETLGT_MaterialsRequestContrMethodNeg1(){
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '{"externalCorrelationID": null,"metaInformation": {"responseMessageList":[{"code": 400,"message": "memberGroupID: Value is required","type": "error"}]}');
            OILResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            ACETLGT_FormsHistoryWebService webs = new ACETLGT_FormsHistoryWebService();
            webs.init();
            webs.init('searchSourceID', 123, '10-2-2019','10-02-2020','recipientID', 'idQualifier');
            webs.FormatRecpt('test@salesforce.com');
            webs.formatStartDate('2017-10-20');
            webs.formatEndDate ('10/2017');  
            ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','test');
            ACETLGT_MaterialsRequestController.getMaterialForms('test');        
        }
        static testMethod void ACETLGT_MaterialsRequestContrMethodNeg2(){
             
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(201, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
            OILResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            ACETLGT_FormsHistoryWebService webs = new ACETLGT_FormsHistoryWebService();
            webs.init();
            webs.FormatRecpt('test@salesforce.com');
            webs.formatStartDate('2017-10-20');
            webs.formatEndDate ('10/2017');    
            ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','test');
            ACETLGT_MaterialsRequestController.getMaterialForms('test');        
        }
        
        static testMethod void ACETLGT_MaterialsRequestContrMethod2(){
            Material_Forms__c mform = new Material_Forms__c();
            mform.FulfillmentType__c = '10700';
            mform.FulfillmentType_Description__c = 'Blank Form';
            mform.Business_Unit__c = '';
            insert mform;
            StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'AcetFindFulfillmentHistoryResultJSON'];
            String ResponseJSON = ResponseJSONSR.Body.toString(); 
            ResponseJSON = ResponseJSON.replaceAll('TransactionalInlineDataOnly', 'TransactionalInlinePrintReadySingleItem');       
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
              ACETLGT_MaterialsRequestController.MaterialForms contwrapr = new ACETLGT_MaterialsRequestController.MaterialForms(mform);
            ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','test');
            ACETLGT_MaterialsRequestController.getMaterialForms('test');        
        }
    static testMethod void searchOrderHistorymtd3() {
       ACETLGT_MaterialsRequestController tst= new ACETLGT_MaterialsRequestController();
            Material_Forms__c mform = new Material_Forms__c();
            mform.FulfillmentType__c = '107001';
            mform.FulfillmentType_Description__c = 'Blank Form';
            mform.Category__c='';
            mform.Business_Unit__c = '';
            
            insert mform;
            
            Material_Forms__c mform1 = new Material_Forms__c();
            mform1.FulfillmentType__c = '10700';
            mform1.Category__c='test';
            mform1.FulfillmentType_Description__c = 'Blank Form';
            mform1.Business_Unit__c = '';
            insert mform1;
            
        
            List< Material_Forms__c> listMform = new List<Material_Forms__c >();
            listMform.add(mform);
            listMform.add(mform1);
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'AcetFindFulfillmentHistoryResultJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
               
        Test.startTest();

            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
             ACETLGT_FormsHistoryResult objACETFormsHistoryResult = new ACETLGT_FormsHistoryResult();
            objACETFormsHistoryResult.requestdate='';
            objACETFormsHistoryResult.documentname='';
            objACETFormsHistoryResult.quantity=1;
            objACETFormsHistoryResult.status='';
            objACETFormsHistoryResult.maileddate='';
            objACETFormsHistoryResult.recipient='';
            objACETFormsHistoryResult.Address='';
            objACETFormsHistoryResult.documenttype='';
            objACETFormsHistoryResult.source='';
            objACETFormsHistoryResult.isAvailable= true;
            objACETFormsHistoryResult.statusToolTip='';
            objACETFormsHistoryResult.recipientId='';
            
            Map<String, List<ACETLGT_FormsHistoryResult>> testResultMap =new Map<String, List<ACETLGT_FormsHistoryResult>>();
            testResultMap.put('Order History',new List<ACETLGT_FormsHistoryResult>());  
        
            ACETLGT_MaterialsRequestController.getMaterialForms('test'); 
            ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','order history');
           
        Test.stopTest();
        }
        
          static testMethod void searchOrderHistorymtd2() {
       ACETLGT_MaterialsRequestController tst= new ACETLGT_MaterialsRequestController();
            Material_Forms__c mform = new Material_Forms__c();
            mform.FulfillmentType__c = '107001';
            mform.FulfillmentType_Description__c = 'Blank Form';
            mform.Category__c='';
            mform.Business_Unit__c = '';
            
            insert mform;
            
            Material_Forms__c mform1 = new Material_Forms__c();
            mform1.FulfillmentType__c = '10700';
            mform1.Category__c='test';
            mform1.FulfillmentType_Description__c = 'Blank Form';
            mform1.Business_Unit__c = '';
            insert mform1;
            
        
            List< Material_Forms__c> listMform = new List<Material_Forms__c >();
            listMform.add(mform);
            listMform.add(mform1);
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindFulfillmentHistoryResultJSON_IDCard'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
          ResponseJSON = ResponseJSON.replaceAll('TransactionalInlineDataOnly', 'TransactionalInlinePrintReadySingleItem');       
        Test.startTest();

            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
                    
            Map<String, List<ACETLGT_FormsHistoryResult>> testResultMap =new Map<String, List<ACETLGT_FormsHistoryResult>>();
            testResultMap.put('Order History',new List<ACETLGT_FormsHistoryResult>());  
        
            ACETLGT_MaterialsRequestController.getMaterialForms('test'); 
            ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','order history');
           
        Test.stopTest();
        }
          static testMethod void searchOrderHistorymtd4() {
       ACETLGT_MaterialsRequestController tst= new ACETLGT_MaterialsRequestController();
            Material_Forms__c mform = new Material_Forms__c();
            mform.FulfillmentType__c = '107001';
            mform.FulfillmentType_Description__c = 'Blank Form';
            mform.Category__c='';
            mform.Business_Unit__c = '';
            
            insert mform;
            
            Material_Forms__c mform1 = new Material_Forms__c();
            mform1.FulfillmentType__c = '10700';
            mform1.Category__c='test';
            mform1.FulfillmentType_Description__c = 'Blank Form';
            mform1.Business_Unit__c = '';
            insert mform1;
            
        
            List< Material_Forms__c> listMform = new List<Material_Forms__c >();
            listMform.add(mform);
            listMform.add(mform1);
            StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindFulfillmentHistoryResultJSON_IDCard'];
            String ResponseJSON = ResponseJSONSR.Body.toString(); 
        
        Test.startTest();

            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
                    
            Map<String, List<ACETLGT_FormsHistoryResult>> testResultMap =new Map<String, List<ACETLGT_FormsHistoryResult>>();
            testResultMap.put('Order History',new List<ACETLGT_FormsHistoryResult>());  
        
            ACETLGT_MaterialsRequestController.getMaterialForms('test'); 
            //ACETLGT_MaterialsRequestController.searchOrderHistory('10-2-2019','10-02-2020','test','test','order history');
           
        Test.stopTest();
        }
    }