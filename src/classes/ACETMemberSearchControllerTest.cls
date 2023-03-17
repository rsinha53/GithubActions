@isTest
Public class ACETMemberSearchControllerTest{
    
    @testSetup
    static void dataSetup () {
        List<User> memberAgent = new List<User>();
        memberAgent.add(TestDataFactory.getUser('ACET Provider')); 
        memberAgent.add(TestDataFactory.getUser('ACET Member')); 
        memberAgent.add(TestDataFactory.getUser('Research User')); 
        insert memberAgent;
    }
    
    Public static testMethod void unitTestMethodForProivder(){
        
        //User memberAgent = TestDataFactory.getUser('ACET Provider'); 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetMemberSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);        
        setTestData('Provider');
        List<user> memberAgent = [select id from user where profile.name = 'ACET Member'];
        
        System.runAs(memberAgent[0]){
            Test.startTest();
            ACETMemberSearchController acetSC = new ACETMemberSearchController();
            acetSC.MemberId = '323454332';
            acetSC.getMisdirectedReasons();
            string ClosedReason = '';
            acetSC.getClosedReasons();
            acetSC.getSourceOriginators();
            
            acetSC.init();
            acetSC.clear();
            acetSC.search();

            acetSC.sortBy = 'MiddleInitial';
            acetSC.sortTable();            
            acetSC.saveMisredirectedCase();
            Interaction__c sourceApplication= TestDataFactory.createInteraction();
            ApexPages.currentPage().getParameters().put('InteractionId',sourceApplication.id);
   
            
            acetSC.saveSystemUnavailableCase();
            acetSC.showMisdirectedCall();
            acetSC.renderMisdirectCaseSection();
            string str1 = 'test1';
            string str2 = 'test2';
            ACETMemberSearchController.createInteraction(str1,str2);
        
            Test.stopTest();        
        }
    }
    
    Public static testMethod void unitTestMethodForMember(){
        
        //User memberAgent = TestDataFactory.getUser('ACET Member'); 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetMemberSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        setTestData('Member');  
        List<user> memberAgent = [select id from user];

        System.runAs(memberAgent[1]){
            Test.startTest();
            ACETMemberSearchController acetSC = new ACETMemberSearchController();
            acetSC.getMisdirectedReasons();
            acetSC.getClosedReasons();
            acetSC.getSourceOriginators();
            acetSC.init();
            
            acetSC.search();
            
            //By rahul
   //       acetSC.selectedResult = new ACETMemberSearchResult ();
   //       acetSC.ACETMemberSearchResult .sortby = 'raj'; 
   //       acetSC.results.add(acetSC.selectedResult) ;
   //       acetSC.results = OILResponse ; 
  
         
            
            ACETMemberSearchResult acetmsr = new ACETMemberSearchResult ();
            acetmsr.ID =  '1234567890';
            acetmsr.FirstName =  'Raju';
            acetmsr.MiddleInitial = 'M';
            acetmsr.Gender = 'M';
            acetmsr.DOB = '09-09-1996';
            acetmsr.SCRId = '12345';
            acetmsr.SSNum = '12345';
            acetmsr.SSN = '123456789';
            acetmsr.City = 'Test';
            acetmsr.State = 'CT';
            acetmsr.Zip = '12345';
            acetmsr.SurrogateKey = '123456789';
            acetmsr.SurrogateKeysStr = '123456789';
            acetmsr.SourceCode = '12345';
            acetmsr.individualIdentifier = '123456789';
            acetmsr.Address = 'Test Address';
            
            acetmsr.compareTo((object)acetmsr);
            
            ACETMemberSearchResult acetmsr1 = new ACETMemberSearchResult ();
            acetmsr1.ID =  '1214567890';
            acetmsr1.FirstName =  'Raju1';
    //      acetSC.results.add(acetmsr);
    //      acetSC.results.add(acetmsr1);
            
            ACETMemberSearchResult.SortBy = 'FirstName';
            acetmsr1.compareTo((object)acetmsr1);
            acetSC.sortTable();
            
            ACETMemberSearchResult acetmsr2 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'DOB';
            acetmsr2.compareTo((object)acetmsr2);  
            
            ACETMemberSearchResult acetmsr3 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'SSN';
            acetmsr3.compareTo((object)acetmsr3);           
            
            ACETMemberSearchResult acetmsr4 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'City';
            acetmsr4.compareTo((object)acetmsr4); 
            
            ACETMemberSearchResult acetmsr5 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'ID';
            acetmsr5.compareTo((object)acetmsr5);  
            
            ACETMemberSearchResult acetmsr6 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'Address';
            acetmsr6.compareTo((object)acetmsr6);                                             

            
            acetSC.saveMisredirectedCase();
            acetSC.saveSystemUnavailableCase();
            acetSC.showMisdirectedCall();    
            acetSC.clear();
            
                   
            Test.stopTest();      
        }  
    }
    Public static testMethod void unitTestMethodForMemberInvalidResponse(){
        
      //  User memberAgent = TestDataFactory.getUser('ACET Member'); 
        //User memberAgent = TestDataFactory.getUser('Research User'); 

        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetMemberSearchInvalidJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);        
        setTestData('Member');
        List<user> memberAgent = [select id from user];
        
        System.runAs(memberAgent[2]){
            Test.startTest();
            ACETMemberSearchController acetSC = new ACETMemberSearchController();
            acetSC.getMisdirectedReasons();
            acetSC.getClosedReasons();
            acetSC.getSourceOriginators();
            acetSC.init();
            acetSC.clear();
           string  vccdParams  ='test';
           string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
          
           acetSC.search();
            acetSC.sortBy = 'Gender';
            acetSC.sortTable();           
            acetSC.search();
            ACETMemberSearchResult acetmsr1 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'FirstName';
            acetmsr1.compareTo((object)acetmsr1);
            
            ACETMemberSearchResult acetmsr2 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'Gender';
            acetmsr2.compareTo((object)acetmsr2);
            
            ACETMemberSearchResult acetmsr3 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'MiddleInitial';
            acetmsr3.compareTo((object)acetmsr3);  
            
            ACETMemberSearchResult acetmsr4 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'State';
            acetmsr4.compareTo((object)acetmsr4);   
            
            ACETMemberSearchResult acetmsr5 = new ACETMemberSearchResult ();
            ACETMemberSearchResult.SortBy = 'Zip';
            acetmsr5.compareTo((object)acetmsr5);                                   
                        
 //           acetSC.saveMisredirectedCase();
            acetSC.saveSystemUnavailableCase();
            acetSC.showMisdirectedCall();
            Test.stopTest();       
        }  
    }    
    
     Public static testMethod void unitTestFindMemberWebService(){
        
        //User memberAgent = TestDataFactory.getUser('ACET Member'); 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetMemberSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);     
        setTestData('Member');   
        List<user> memberAgent = [select id from user];
         
        System.runAs(memberAgent[1]){
            Test.startTest();
            ACETFindMemberWebService findMemWS = new ACETFindMemberWebService();
            
            String pagination= '{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}';
            JSONParser parser = JSON.createParser(pagination);
           ACETFindIndividualResultJSON2Apex.Pagination pagi = new ACETFindIndividualResultJSON2Apex.Pagination(parser);
            
            
            findMemWS.queryPaginatedData(0, 5, 0);     
            
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.findindividualsResponceJSON());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
         Test.setMock(HttpCalloutMock.class, MockHttpRes1);           
  findMemWS.queryPaginatedData(0, 5, 0);  
              findMemWS.queryPaginatedData(0, 5, 0);     
            findMemWS.findMemberWS(); 
       
findMemWS.findMembers ('memberId','firstname','lastName','dob','state','zip');
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'OK', '');
         OILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes3);           
  findMemWS.queryPaginatedData(0, 5, 0);  
findMemWS.findMemberWS(); 
            
            Test.stopTest();        
        }
    }
 
    Public static testMethod void unitTestMethodForPagination(){
        
        //User memberAgent = TestDataFactory.getUser('ACET Member'); 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetMemberSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);     
        setTestData('Member');   
        List<user> memberAgent = [select id from user];
        
        System.runAs(memberAgent[1]){
            Test.startTest();
            ACETFindMemberWebService findMemWS = new ACETFindMemberWebService();
            
            String pagination= '{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}';
            JSONParser parser = JSON.createParser(pagination);
           ACETFindIndividualResultJSON2Apex.Pagination pagi = new ACETFindIndividualResultJSON2Apex.Pagination(parser);
            
            
            findMemWS.queryPaginatedData(0, 5, 0);     
            
            String Address= '{"typeCode":"0","addressLine1":"UK","addressLine2":"QW","city":"qwe","postalCode":"01234","stateCode":"01234","countryCode":"01234","countryDescription":"qwerty"}';
            JSONParser parser1 = JSON.createParser(Address);
            ACETFindIndividualResultJSON2Apex.Address pagi1 = new ACETFindIndividualResultJSON2Apex.Address(parser1);
            
            String Telephone = '{"phoneType":"QW","phoneNumber":"0123456789"}';
            JSONParser parser2 = JSON.createParser(Telephone);
            ACETFindIndividualResultJSON2Apex.Telephone pagi2 = new ACETFindIndividualResultJSON2Apex.Telephone(parser2);

            String Name_Z = '{"firstName":"John","lastName":"Matt"}';
            JSONParser parser3 = JSON.createParser(Name_Z);
            ACETFindIndividualResultJSON2Apex.Name_Z pagi3 = new ACETFindIndividualResultJSON2Apex.Name_Z(parser3);  
            
            String Individuals  = '{"individualIdentifier":"John","birthDate":"2/2/2017","genderCode":"123","socialSecurityNumber":"0123"}';
            JSONParser parser4 = JSON.createParser(Individuals);
            ACETFindIndividualResultJSON2Apex.Individuals pagi4 = new ACETFindIndividualResultJSON2Apex.Individuals(parser4);  
            
            String Identifiers   = '{"id":"1234567890","type_Z":"qwe","sourceSysCode":"123"}';
            JSONParser parser5 = JSON.createParser(Identifiers);
            ACETFindIndividualResultJSON2Apex.Identifiers pagi5 = new ACETFindIndividualResultJSON2Apex.Identifiers(parser5);  
            
            String Address_Z   = '{"typeCode":"1234567890","addressLine1":"qwe","city":"London","postalCode":"12312","stateCode":"123","countryCode":"123","countryDescription":"good"}';
            JSONParser parser6 = JSON.createParser(Address_Z);
            ACETFindIndividualResultJSON2Apex.Address_Z pagi6 = new ACETFindIndividualResultJSON2Apex.Address_Z(parser6);  

            String Name = '{"firstName":"raj","lastName":"qwe","middleName":"qwerty"}';
            JSONParser parser7 = JSON.createParser(Name);
            ACETFindIndividualResultJSON2Apex.Name pagi7 = new ACETFindIndividualResultJSON2Apex.Name(parser7);  
            
            String FindIndividualsResponse = '{"firstName":"raj","lastName":"qwe","middleName":"qwerty"}';
            JSONParser parser8 = JSON.createParser(FindIndividualsResponse);
            ACETFindIndividualResultJSON2Apex.FindIndividualsResponse pagi8 = new ACETFindIndividualResultJSON2Apex.FindIndividualsResponse(parser8);

                    
            Test.stopTest();        
        }
    }
    
    Public static void setTestData(String flow){
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
        if(flow == 'Provider'){
            Interaction__c inte = TestDataFactory.createInteraction();
            ApexPages.currentPage().getParameters().put('InteractionId',inte.id);
        }
        
        ApexPages.currentPage().getParameters().put('id',con.id);
        
        
    } 
}