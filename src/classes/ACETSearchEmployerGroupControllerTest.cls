@isTest
private class ACETSearchEmployerGroupControllerTest{

    private static testMethod void unitTestMethodForEBAgent(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindEmployerGroupNameJson());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETFindEmployerGroupSearchWebService acetGrpWebClass = new ACETFindEmployerGroupSearchWebService();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.search();
            //acetSEG.updateCache();
            acetGrpWebClass.init('3797692017185927','','37E9769CORG1','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('','','37E9769CORG1','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('379769201','','','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('','D98E06DB78C4','D98E06DB78C4','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            
            
            
            //acetSEG.createInteraction();
            Test.stopTest();       
        }  
    
    private static testMethod void unitTestMethodForEBAgentByGroupID(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindEmployerGroupNameJson());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.groupId = '1158478';
            acetSEG.search();
            coverageForJSON2Apex();  
            //acetSEG.createInteraction();
            
            Test.stopTest();       
        } 
    
    private static testMethod void unitTestMethodForEBAgentByGroupTaxID(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindEmployerGroupNameJson());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);        
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.groupTaxId = '111111111';
            acetSEG.search();
            coverageForJSON2Apex();  
            //acetSEG.createInteraction();
            Test.stopTest();       
        } 

   private static testMethod void unitTestMethodForEBAgentByGroupName(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindEmployerGroupNameJson());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);        
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.gName = '*CORG*';
            acetSEG.state = 'CT';
            acetSEG.search();
            coverageForJSON2Apex();  
            //acetSEG.createInteraction();
            Test.stopTest();       
        } 

   private static testMethod void unitTestMethodForReasearchUser(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindEmployerGroupNameJson());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Interaction__c interact=TestDataFactory.createInteraction();
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        PageReference ACETESearchPage = Page.ACETSearchEmployerGroup; 
        ACETESearchPage.getParameters().put('vccdParams', 'test');
        test.setCurrentPage(ACETESearchPage);
       User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User u;
         System.runAs(thisUser){
        
        u = TestDataFactory.getUser('Research User');
         
        System.runAs(u){
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetSEG.Interaction=interact;
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.groupId = '0987098';
            acetSEG.search();
            
            Test.stopTest();   
           }    
           system.AssertNotEquals(interact.Id,null);
           system.AssertNotEquals(u.Id,null);
         }
        } 
    private static testMethod void unitTestMethodForProducertoGroup(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindEmployerGroupNameJson());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Interaction__c interact=TestDataFactory.createInteraction();
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        PageReference ACETESearchPage = Page.ACETSearchEmployerGroup; 
        ACETESearchPage.getParameters().put('InteractionId', interact.id);
        test.setCurrentPage(ACETESearchPage);
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.search();
            //acetSEG.updateCache();
            Test.stopTest();       
         
    }   
    
    private static testMethod void unitTestMethodForProducertoGroup2(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', '');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Interaction__c interact=TestDataFactory.createInteraction();
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        PageReference ACETESearchPage = Page.ACETSearchEmployerGroup; 
        ACETESearchPage.getParameters().put('InteractionId', interact.id);
        test.setCurrentPage(ACETESearchPage);
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.search();
            //acetSEG.updateCache();
            Test.stopTest(); 
            ACETFindEmployerGroupSearchWebService acetGrpWebClass = new ACETFindEmployerGroupSearchWebService();
            
            acetGrpWebClass.init('3797692017185927','','37E9769CORG1','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('', null ,'37E9769CORG1','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('','379769201','','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('','D98E06DB78C4','','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
    
    }
    
    private static testMethod void unitTestMethodForProducertoGroup3(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', 'asdasdasdasd');
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Interaction__c interact=TestDataFactory.createInteraction();
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        PageReference ACETESearchPage = Page.ACETSearchEmployerGroup; 
        ACETESearchPage.getParameters().put('InteractionId', interact.id);
        test.setCurrentPage(ACETESearchPage);
        Test.startTest();
            ACETSearchEmployerGroupController acetSEG = new ACETSearchEmployerGroupController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetSEG.getSourceOriginators();
            acetSEG.getStateOptions();
            acetSEG.clear();
            acetSEG.search();
            //acetSEG.updateCache();
            Test.stopTest(); 
            ACETFindEmployerGroupSearchWebService acetGrpWebClass = new ACETFindEmployerGroupSearchWebService();
            
            acetGrpWebClass.init('3797692017185927','','37E9769CORG1','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('','','37E9769CORG1','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('379769201','','','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            acetGrpWebClass.init('','D98E06DB78C4','D98E06DB78C4','CT');
            acetGrpWebClass.queryPaginatedData(1, 10, 1);
            
            ACETFindEmployerGroupCallableJSON2Apex.GroupContract grpCon = new ACETFindEmployerGroupCallableJSON2Apex.GroupContract();
            grpCon.groupPurchase = new List<ACETFindEmployerGroupCallableJSON2Apex.GroupPurchase>();
            grpCon.startDate = '123';
            grpCon.renewalDate = '456';
            grpCon.expirationDate = '789';
            grpCon.status = new ACETFindEmployerGroupCallableJSON2Apex.SizeDefinition();
    
    }
    
    public static testMethod void coverageForJSON2Apex(){
            ACETFindEmployerGroupCallableJSON2Apex.EmployerGroup empGrpSearch = new ACETFindEmployerGroupCallableJSON2Apex.EmployerGroup();
            ACETFindEmployerGroupCallableJSON2Apex.FindEmployerGroupsResponse empGrpsSearchResp= new ACETFindEmployerGroupCallableJSON2Apex.FindEmployerGroupsResponse();
            ACETFindEmployerGroupCallableJSON2Apex.Address addrGrpSearch = new ACETFindEmployerGroupCallableJSON2Apex.Address();
            ACETFindEmployerGroupCallableJSON2Apex.Phone phnGrpSearch = new ACETFindEmployerGroupCallableJSON2Apex.Phone();
            //ACETFindEmployerGroupCallableJSON2Apex.Status statusGrpSearch = new ACETFindEmployerGroupCallableJSON2Apex.Status();
            list<ACETFindEmployerGroupCallableJSON2Apex.EmployerGroup> empGrpSearchList = new list<ACETFindEmployerGroupCallableJSON2Apex.EmployerGroup>();
            ACETFindEmployerGroupCallableJSON2Apex.Pagination pagGrpSearch = new ACETFindEmployerGroupCallableJSON2Apex.Pagination();
            list<ACETFindEmployerGroupCallableJSON2Apex.Phone> phnGrpSearchlist = new list<ACETFindEmployerGroupCallableJSON2Apex.Phone>();
            ACETFindEmployerGroupCallableJSON2Apex.GroupPurchase grpPur = new ACETFindEmployerGroupCallableJSON2Apex.GroupPurchase();
            ACETFindEmployerGroupCallableJSON2Apex.SizeDefinition sizeObj = new ACETFindEmployerGroupCallableJSON2Apex.SizeDefinition();
            sizeObj.code = 'abc';
            sizeObj.descr = 'xyz';
            grpPur.stateofIssue = sizeObj;
            grpPur.fundingArrangement = sizeObj;
          
            
            //addrGrpSearch.typeCode = 'Test';
            addrGrpSearch.addressLine1 = 'Test';
            addrGrpSearch.addressLine2= 'Test';
            addrGrpSearch.city= 'Test';
            addrGrpSearch.postalCode= '01010';
            addrGrpSearch.stateCode= 'NJ';
           // addrGrpSearch.countryCode= 'Test';
           // addrGrpSearch.countryDescription= 'Test';
             
            
            phnGrpSearch.phoneType = 'WRK';
            phnGrpSearch.phoneNumber = '9898989898';
            phnGrpSearch.phoneExt = '123';
            //phnGrpSearch.internationalIndicator = 'Y';
            phnGrpSearchlist.add(phnGrpSearch );
            
            //statusGrpSearch.descr = 'Test';
            //statusGrpSearch.code= 'Test';
            
            empGrpSearch.address= addrGrpSearch;
            empGrpSearch.phone= phnGrpSearchlist;
            //empGrpSearch.status= '';//statusGrpSearch ;
           // empGrpSearch.sizeDefinition= '';//statusGrpSearch ;
           // empGrpSearch.fundingArrangement= '';//statusGrpSearch ;
           // empGrpSearch.salesOffice= '';//statusGrpSearch ;
            //empGrpSearch.stateofIssue= '';//statusGrpSearch ;
            empGrpSearch.sourceSysCode = 'Test';
           // empGrpSearch.expirationDate = '01/01/2018';
           // empGrpSearch.startDate = '01/01/2017';
            
            empGrpSearchList.add(empGrpSearch);            
            
            pagGrpSearch.pageNumber = '1';
            pagGrpSearch.pageSize = '1';
            pagGrpSearch.recordCount= '1';
            pagGrpSearch.totalCount= '1';
            pagGrpSearch.totalPages= '1';
            pagGrpSearch.moreRecords= '1';
            
            empGrpsSearchResp.employerGroup = empGrpSearchList;
            empGrpsSearchResp.pagination = pagGrpSearch; 
            
    }
     
}