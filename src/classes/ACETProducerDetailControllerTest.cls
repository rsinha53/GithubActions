@istest(seeAllData = false)
public Class ACETProducerDetailControllerTest{
	public static String getProducerAPIResponseBody =  '{"response":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"74a0a206-7fbb-4568-ad39-5de31abb6db3","producerGroupAssociation":"future","pageNumber":1,"recordsPerPage":50,"requestEffectiveDate":"05/26/2021","totalNumberOfRecords":1,"responseCode":200,"responseDescription":"Success"},"getProducerResponse":{"producerID":"213913","producerCompanyName":"INSURLYNX LLC","producerIndividualName":{"firstName":"","middleInitial":"","lastName":""},"producerSSN":"","producerTIN":"460583017","producerType":"B","producerContact":"","producerEffectiveStartDate":"09/10/2012","producerEffectiveEndDate":"12/31/9999","producerAddress":{"addressTypeCode":"M","producerStreetLine1":"10 BROADWAY APT 2","producerStreetLine2":"","producerCity":"TRUMBULL","producerState":"CT","producerZipCode":"06611","producerZipCodeSuffix":"1368","producerPhoneNumber":"2035380508"},"producerStatus":"Active","legacyProducers":[{"legacyProducerSystem":"PUL","legacyProducerID":"PC9277"}],"customerDetails":[{"customerNumber":"1270220","customerName":"NORWALK MARINE CONTACTORS","adminSystem":"CR"}]}}}'; 
    @testsetup
    public static void testdata(){
        Organization_Properties__c settings = Organization_Properties__c.getOrgDefaults();
        settings.OrganizationName__c = 'qa';
        upsert settings Organization_Properties__c.Id;
        WebserviceConfigurations__c ws= new WebserviceConfigurations__c();
        ws.Name = 'ACETGetProducerAPI';
        ws.Method__c = 'POST';
        ws.Timeout__c = 1000;
        ws.RecordTypeText__c  = 'Token_API';
        
        insert ws;
        OrgSpecificConfigurations__c osc = new OrgSpecificConfigurations__c();
        osc.WebserviceConfigurations__c = ws.id;
        osc.Name='qa';
        osc.EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/cdm/prodr/basics/bookofbusinesses/v1';
        osc.RecordTypeText__c  = 'TokenAPI';
        insert osc;
    }
    
       static testMethod void ProducerDetailControllerTest() 
        {    
             
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
            Account producerAccount = new Account();
            producerAccount.FirstName = 'TestFirstname';
            producerAccount.LastName = 'Testlastname';
            producerAccount.EID__c = '167106';
            producerAccount.EID__pc = '167106';
            producerAccount.Tax_ID__c = '';
            producerAccount.RecordTypeId = newRecord.Id;
            insert producerAccount;   
            
            Interaction__c inter = new Interaction__c();
            Account acc = [SELECT Id,personcontactid from Account where Id=:producerAccount.Id];
            Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            inter.Originator__c = con.id;
            inter.Interaction_Type__c = 'Producer';            
            insert inter;
            
            
            List<Alert__c> listalert = new List<Alert__c>();
            Alert__c alert = new Alert__c();
            alert.ID_Number__c = '167106';
            alert.Type__c = 'Producer';
             Date today = date.today();
            alert.Effective_Date__c = today; 
            Date endate = date.today()+5;          
            alert.End_Date__c = endate;
            alert.Alert_Title__c = 'Testing';
            alert.Alert_Comments__c = 'Testing components';
            insert alert;   
            listalert.add(alert);      
            System.debug('interaction =================='+alert);
            
           Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '167108';
            alert1.Type__c = 'Producer';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
            listalert.add(alert);  
            
                 
            Test.startTest();  
            
             
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetProducerJSON());
           system.debug('test response==========>'+OILResponse);
            OILResponse.TokenExpired = false;
            
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            PageReference ACETPDPage = Page.ACETProducerDetail;
            test.setCurrentPage(ACETPDPage);
             apexpages.currentpage().getparameters().put('Id', '167106');
             apexpages.currentpage().getparameters().put('interactionId', inter.id);
             apexpages.currentpage().getparameters().put('subjectId', producerAccount.personcontactid);
             apexpages.currentpage().getparameters().put('firstName', 'Firstname');
             apexpages.currentpage().getparameters().put('lastName','Testlasttname');
             apexpages.currentpage().getparameters().put('contactName','Testcontactname');
             apexpages.currentpage().getparameters().put('fastTrack','True');
             apexpages.currentpage().getparameters().put('SourceOriginator','test');
             apexpages.currentpage().getparameters().put('originatorName','test');
            
             ACETInteractionHighlightsPanelController interactioninfo = new ACETInteractionHighlightsPanelController();
              interactioninfo.Interaction = TestDataFactory.createInteraction();
              interactioninfo.Interaction.Originator_Type__c = 'Producer';
              interactioninfo.Subject =  TestDataFactory.createContact();
              interactioninfo.getProducerAlert();
              
              ACETMaskSSNComponentController maskssn = new ACETMaskSSNComponentController();
              maskssn.SSNUnMaskValue = '123456789';
              maskssn.constituentEID = '324567286';
              maskssn.constituentType = 'Producer';             
              maskssn.maskedSSN= '123456789';             
              maskssn.copySSN=false;           
              maskssn.getInserteventlog();
              
                       
            ACETProducerDetailController ACETPDExt = new ACETProducerDetailController(); 
            list<Alert__c> test1 =ACETPDExt.lstMemAlert;
            ACETCallTopicsDataWrapper test2 = ACETPDExt.wrapper;
            ACETProducerResult test3 = ACETPDExt.prodDetailresltfuture;
            
               id[] fixedSearchResults = new id[1];
               fixedSearchResults[0] = alert1.id;
               Test.setFixedSearchResults(fixedSearchResults); 
            String hpAdditionInfoStr = ACETPDExt.hpAdditionInfoStr;
           
            system.debug('local alert list information'+listalert);     
           // system.debug('alert list information'+ACETPDExt.lstProducerAlert);
            ACETPDExt.contactName = 'testcontactname';
            ACETPDExt.SourceOriginator= 'testcontactname';
            ACETPDExt.originatorName= 'testcontactname';           
            ACETPDExt.updateContact();        
            ACETPDExt.updateInteraction();          
            ACETPDExt.getCaseHistory();
            ACETPDExt.getCallTopicOptions();
            ACETPDExt.groupHistoryWindow();
            ACETPDExt.resetWindow();
            Continuation conti = (Continuation)ACETPDExt.CallGetProducerWS1();
                Map<String, HttpRequest> requests = conti.getRequests();
                system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
                HttpResponse response = new HttpResponse();
                response.setBody(ACETTestDataUtility.GetProducerJSON());
                response.setStatusCode(200);
                Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
                Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
                Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
                ACETProducerResult resulttest = new ACETProducerResult();
                resulttest.interactionId = inter.id;
                resulttest.effectiveStartDate = '12/2/2107';
                resulttest.groupName = 'Testing';
                resulttest.contactid = producerAccount.id;
                resulttest.contactType = 'Broker';
                resulttest.Interaction = inter;
                Account acc1 = [SELECT Id,personcontactid from Account where Id=:producerAccount.Id];
                Contact con1 = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc1.personcontactid];

                resulttest.Subject = con1;
           Test.stopTest();
        }
        
         static testMethod void ProducerDetailControllerTest1() 
         {
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK','');
            system.debug('test response==========>'+OILResponse);
            OILResponse.TokenExpired = false;
            
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            
            PageReference ACETPDPage = Page.ACETProducerDetail;
            test.setCurrentPage(ACETPDPage);
             apexpages.currentpage().getparameters().put('Id', '16712');
                       
             ACETGetProducerAdapterWebservice servicecall = new ACETGetProducerAdapterWebservice();
             servicecall.GetProducer('16712');
         
        } 
        
         static testMethod void ProducerDetailControllerTest2() 
         {
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetProducerJSON());
            system.debug('test response==========>'+OILResponse);
            OILResponse.TokenExpired = false;
            
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            
             PageReference ACETPDPage = Page.ACETProducerDetail;
             test.setCurrentPage(ACETPDPage);
             apexpages.currentpage().getparameters().put('Id', '16712');
                       
             ACETGetProducerAdapterWebservice servicecall = new ACETGetProducerAdapterWebservice();
             servicecall.GetProducer('16712');
             
             ACETGetProducerAdapterJSON2Apex.cls_serviceAttributes  jasontoapex = new ACETGetProducerAdapterJSON2Apex.cls_serviceAttributes();
             jasontoapex.applicationIdentifier = 'Testing';
             jasontoapex.requestIdentifier = '123';
             jasontoapex.responseCode = '200';
             jasontoapex.responseDescription = 'Success:Trace of all the success calls';
             jasontoapex.totalNumberOfRecords = '2';
             jasontoapex.pageNumber = '2';
             jasontoapex.recordsPerPage = '2';
             
             ACETGetProducerAdapterJSON2Apex.cls_memberGroupDetails jasontoapexmember = new ACETGetProducerAdapterJSON2Apex.cls_memberGroupDetails();
             jasontoapexmember.groupNumber = '9800108';
             jasontoapexmember.groupName = 'Testing group';

           
          
        }
         
        static testMethod void ProducerDetailControllerTest3() 
        {    
                
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
            Account producerAccount = new Account();
            producerAccount.FirstName = 'TestFirstname';
            producerAccount.LastName = 'Testlastname';
            producerAccount.EID__c = '167106';
            producerAccount.EID__pc = '167106';
            producerAccount.Tax_ID__c = '';
            producerAccount.RecordTypeId = newRecord.Id;
            insert producerAccount;   
            
            Interaction__c inter = new Interaction__c();
            Account acc = [SELECT Id,personcontactid from Account where Id=:producerAccount.Id];
            Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            inter.Originator__c = con.id;
            inter.Interaction_Type__c = 'Producer';            
            insert inter;
            
            
            List<Alert__c> listalert = new List<Alert__c>();
            Alert__c alert = new Alert__c();
            alert.ID_Number__c = '167108';
            alert.Type__c = 'Producer';
             Date today = date.today();
            alert.Effective_Date__c = today; 
            Date endate = date.today()+5;          
            alert.End_Date__c = endate;
            alert.Alert_Title__c = 'Testing';
            alert.Alert_Comments__c = 'Testing components';
            insert alert;   
            listalert.add(alert);      
            System.debug('interaction =================='+alert);
            
           Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '167106';
            alert1.Type__c = 'Producer';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
            listalert.add(alert);  
            
                 
            Test.startTest();  
            
             
           MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetProducerJSON());
           system.debug('test response==========>'+OILResponse);
            OILResponse.TokenExpired = false;
            
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            PageReference ACETPDPage = Page.ACETProducerDetail;
            test.setCurrentPage(ACETPDPage);
             apexpages.currentpage().getparameters().put('Id', '167106');
             apexpages.currentpage().getparameters().put('interactionId', inter.id);
             apexpages.currentpage().getparameters().put('subjectId', producerAccount.personcontactid);
             apexpages.currentpage().getparameters().put('firstName', 'Firstname');
             apexpages.currentpage().getparameters().put('lastName','Testlasttname');
             apexpages.currentpage().getparameters().put('contactName','Testcontactname');
             apexpages.currentpage().getparameters().put('fastTrack','True');
             apexpages.currentpage().getparameters().put('SourceOriginator','test');
             apexpages.currentpage().getparameters().put('originatorName','test');
             apexpages.currentpage().getparameters().put('pnf', '1');
            
             
             ACETInteractionHighlightsPanelController interactioninfo = new ACETInteractionHighlightsPanelController();
              interactioninfo.Interaction = TestDataFactory.createInteraction();
              interactioninfo.Interaction.Originator_Type__c = 'Producer';
              interactioninfo.Subject =  TestDataFactory.createContact();
              interactioninfo.getProducerAlert();
              
              ACETMaskSSNComponentController maskssn = new ACETMaskSSNComponentController();
              maskssn.SSNUnMaskValue = '123456789';
              maskssn.constituentEID = '324567286';
              maskssn.constituentType = 'Producer';             
              maskssn.maskedSSN= '123456789';             
              maskssn.copySSN=false;           
              maskssn.getInserteventlog();
              
                       
            ACETProducerDetailController ACETPDExt = new ACETProducerDetailController(); 
            
               id[] fixedSearchResults = new id[1];
               fixedSearchResults[0] = alert1.id;
               Test.setFixedSearchResults(fixedSearchResults); 
           
            system.debug('local alert list information'+listalert);     
           // system.debug('alert list information'+ACETPDExt.lstProducerAlert);
            ACETPDExt.contactName = 'testcontactname';
            ACETPDExt.SourceOriginator= 'testcontactname';
            ACETPDExt.originatorName= 'testcontactname';           
            ACETPDExt.updateContact();        
            ACETPDExt.updateInteraction(); 
            ACETPDExt.getCaseHistory();
            ACETPDExt.getCallTopicOptions();
            ACETPDExt.groupHistoryWindow();
            ACETPDExt.resetWindow();
            Continuation conti = (Continuation)ACETPDExt.CallGetProducerWS1();
                Map<String, HttpRequest> requests = conti.getRequests();
                system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
                HttpResponse response = new HttpResponse();
                response.setBody(ACETTestDataUtility.GetProducerJSON());
                response.setStatusCode(200);
                Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
                Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
                Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
                
                ACETProducerResult resulttest = new ACETProducerResult();
                resulttest.interactionId = inter.id;
                resulttest.effectiveStartDate = '12/2/2107';
                resulttest.groupName = 'Testing';
                resulttest.contactid = producerAccount.personcontactid;
                resulttest.contactType = 'Broker';
                resulttest.Interaction = inter;
                Account acc2 = [SELECT Id,personcontactid from Account where Id=:producerAccount.Id];
                Contact con2 = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc2.personcontactid];

                resulttest.Subject = con2;
                 Test.stopTest();
        }
    
    public static testmethod void getProducerAPITest(){
        String respBody = getProducerAPIResponseBody;
        ACETGetProducerAPI gpa = new ACETGetProducerAPI();
        gpa.parseSuccessAdapterResponse(ACET_WebServiceUtils.ReplaceKeywords(respBody));
    }
     
}