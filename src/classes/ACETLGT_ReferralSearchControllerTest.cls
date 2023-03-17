@isTest

private class ACETLGT_ReferralSearchControllerTest {
    Private static final string date1 = '1969-06-17';
        @testsetup
    static void prepareData(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        System.debug('tokenAPIOrgSpecificConfigs::'+tokenAPIOrgSpecificConfigs);
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Search Clinical Referrals Endpoint', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);       
    }

    static testMethod void ACETLGT_ReferralSearchControllerTest1() {
      
       // MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.FindReferralSearchResponseJSON());
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"referralDetailsResponse":{"referrals":[{"referralId":"3308","referralTypeID":"1","referralDescription":"Consultation and Treatment","numberOfVisits":"4","referralDateRange":{"startDate":"2018-02-15","stopDate":"2018-08-15"},"statusCode":{"code":"2","desc":"Active"},"sourceApplicationCode":{},"referralDate":"2018-02-16","createDateTime":"2018-02-16T10:38:19Z","member":{"sourceMemberId":{"id":"624410015","type":"SRK"},"firstName":"CASSIDY","lastName":"CIARDULLO","birthDate":"1962-06-17","gender":{"code":"M","desc":"Male"},"relationshipCode":"SF","enrolleIdentifiers":[{"id":"62749217100","typeCode":"1","typeCodeDesc":"Subscriber ID"},{"id":"62749217100","typeCode":"2","typeCodeDesc":"Member ID"},{"id":"62749217100","typeCode":"20","typeCodeDesc":"Rx Member ID"},{"id":"62749217100","typeCode":"28","typeCodeDesc":"ID Card Serial Number"},{"id":"624410015","typeCode":"31","typeCodeDesc":"Enrollee Surrogate Key"},{"id":"045704353","typeCode":"4","typeCodeDesc":"Social Security Number"}]},"providers":[{"providerSeqNumber":"1","category":"P","firstName":"KATHLEEN","middleName":"S","lastName":"AFRICANO","address":{"addressLine1":"147 EAST AVE","city":"NORWALK","state":{"code":"CT","desc":"CONNECTICUT"},"postalCode1":"06851","postalCode2":"5723"},"specialityType":[{},{"code":"363LP0808X","desc":"Psych/Mental Health - Nurse Practitioner","sourceSystem":"CR"}],"role":[{"id":"RF","desc":"Requesting Provider"}],"providerIdentifiers":[{"id":"204300466","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1659300416","typeCode":"06","typeCodeDesc":"NPI"},{"id":"559346195117983451","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"275445382099509793","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]},{"providerSeqNumber":"2","category":"P","firstName":"JOSEPH","middleName":"THEODORE","lastName":"ANQUILLARE","address":{"addressLine1":"1 EMILY WAY","city":"WEST HARTFORD","state":{"code":"CT","desc":"CONNECTICUT"},"postalCode1":"06107","postalCode2":"3136"},"specialityType":[{},{"code":"207R00000X","desc":"Internal Medicine","sourceSystem":"CR"}],"telephoneNumber":"860-561-7022","faxNumber":"860-561-7023","role":[{"id":"PC","desc":"Primary Care Provider"},{"id":"SJ","desc":"Servicing"}],"providerIdentifiers":[{"id":"061440890","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1316043045","typeCode":"06","typeCodeDesc":"NPI"},{"id":"891446204433348065","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"1452407740674","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]}],"services":[{"sequenceNumber":"1","procedureCode":{"code":"27560","codeDesc":"CLOSED TX PATELLAR DISLOCATION W/O ANESTHESIA","typeCode":"2","typeCodeDesc":"CPT4"},"providerSeqNumber":"0"}],"diagnosis":[{"sequenceNumber":"1","diagnosisCode":{"code":"H02.402","codeDesc":"UNSPECIFIED PTOSIS OF LEFT EYELID","typeCode":"0","typeCodeDesc":"ICD10"}}]},{"referralId":"3307","referralTypeID":"1","referralDescription":"Consultation and Treatment","numberOfVisits":"4","referralDateRange":{"startDate":"2018-02-15","stopDate":"2018-08-15"},"statusCode":{"code":"2","desc":"Active"},"sourceApplicationCode":{},"referralDate":"2018-02-16","createDateTime":"2018-02-16T09:28:48Z","member":{"sourceMemberId":{"id":"624410015","type":"SRK"},"firstName":"CASSIDY","lastName":"CIARDULLO","birthDate":"1962-06-17","gender":{"code":"M","desc":"Male"},"relationshipCode":"SF","enrolleIdentifiers":[{"id":"62749217100","typeCode":"1","typeCodeDesc":"Subscriber ID"},{"id":"62749217100","typeCode":"2","typeCodeDesc":"Member ID"},{"id":"62749217100","typeCode":"20","typeCodeDesc":"Rx Member ID"},{"id":"62749217100","typeCode":"28","typeCodeDesc":"ID Card Serial Number"},{"id":"624410015","typeCode":"31","typeCodeDesc":"Enrollee Surrogate Key"},{"id":"045704353","typeCode":"4","typeCodeDesc":"Social Security Number"}]},"providers":[{"providerSeqNumber":"1","category":"P","firstName":"JOSEPH","middleName":"THEODORE","lastName":"ANQUILLARE","address":{"addressLine1":"1 EMILY WAY","city":"WEST HARTFORD","state":{"code":"CT","desc":"CONNECTICUT"},"postalCode1":"06107","postalCode2":"3136"},"specialityType":[{},{"code":"207R00000X","desc":"Internal Medicine","sourceSystem":"CR"}],"telephoneNumber":"860-561-7022","faxNumber":"860-561-7023","role":[{"id":"PC","desc":"Primary Care Provider"},{"id":"RF","desc":"Requesting Provider"},{"id":"SJ","desc":"Servicing"}],"providerIdentifiers":[{"id":"061440890","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1316043045","typeCode":"06","typeCodeDesc":"NPI"},{"id":"891446204433348065","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"1452407740674","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]}],"services":[{"sequenceNumber":"1","procedureCode":{"code":"27560","codeDesc":"CLOSED TX PATELLAR DISLOCATION W/O ANESTHESIA","typeCode":"2","typeCodeDesc":"CPT4"},"providerSeqNumber":"0"}],"diagnosis":[{"sequenceNumber":"1","diagnosisCode":{"code":"H02.402","codeDesc":"UNSPECIFIED PTOSIS OF LEFT EYELID","typeCode":"0","typeCodeDesc":"ICD10"}}]},{"referralId":"3305","referralTypeID":"1","referralDescription":"Consultation and Treatment","numberOfVisits":"4","referralDateRange":{"startDate":"2018-02-15","stopDate":"2018-08-15"},"statusCode":{"code":"2","desc":"Active"},"sourceApplicationCode":{},"referralDate":"2018-02-16","createDateTime":"2018-02-16T09:25:34Z","member":{"sourceMemberId":{"id":"624410015","type":"SRK"},"firstName":"CASSIDY","lastName":"CIARDULLO","birthDate":"1962-06-17","gender":{"code":"M","desc":"Male"},"relationshipCode":"SF","enrolleIdentifiers":[{"id":"62749217100","typeCode":"1","typeCodeDesc":"Subscriber ID"},{"id":"62749217100","typeCode":"2","typeCodeDesc":"Member ID"},{"id":"62749217100","typeCode":"20","typeCodeDesc":"Rx Member ID"},{"id":"62749217100","typeCode":"28","typeCodeDesc":"ID Card Serial Number"},{"id":"624410015","typeCode":"31","typeCodeDesc":"Enrollee Surrogate Key"},{"id":"045704353","typeCode":"4","typeCodeDesc":"Social Security Number"}]},"providers":[{"providerSeqNumber":"1","category":"P","firstName":"KATHLEEN","middleName":"S","lastName":"AFRICANO","address":{"addressLine1":"147 EAST AVE","city":"NORWALK","state":{"code":"CT","desc":"CONNECTICUT"},"postalCode1":"06851","postalCode2":"5723"},"specialityType":[{},{"code":"363LP0808X","desc":"Psych/Mental Health - Nurse Practitioner","sourceSystem":"CR"}],"role":[{"id":"SJ","desc":"Servicing"}],"providerIdentifiers":[{"id":"204300466","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1659300416","typeCode":"06","typeCodeDesc":"NPI"},{"id":"559346195117983451","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"275445382099509793","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]},{"providerSeqNumber":"2","category":"P","firstName":"JOSEPH","middleName":"THEODORE","lastName":"ANQUILLARE","address":{"addressLine1":"1 EMILY WAY","city":"WEST HARTFORD","state":{"code":"CT","desc":"CONNECTICUT"},"postalCode1":"06107","postalCode2":"3136"},"specialityType":[{},{"code":"207R00000X","desc":"Internal Medicine","sourceSystem":"CR"}],"telephoneNumber":"860-561-7022","faxNumber":"860-561-7023","role":[{"id":"PC","desc":"Primary Care Provider"},{"id":"RF","desc":"Requesting Provider"}],"providerIdentifiers":[{"id":"061440890","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1316043045","typeCode":"06","typeCodeDesc":"NPI"},{"id":"891446204433348065","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"1452407740674","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]}],"services":[{"sequenceNumber":"1","procedureCode":{"code":"27560","codeDesc":"CLOSED TX PATELLAR DISLOCATION W/O ANESTHESIA","typeCode":"2","typeCodeDesc":"CPT4"},"providerSeqNumber":"0"}],"diagnosis":[{"sequenceNumber":"1","diagnosisCode":{"code":"H02.402","codeDesc":"UNSPECIFIED PTOSIS OF LEFT EYELID","typeCode":"0","typeCodeDesc":"ICD10"}}]}],"pagination":{"pageNumber":"1","pageSize":"3","totalCount":"3","startRecord":"1","moreRecords":"false"}}}');
       OILResponse.TokenExpired = false;  
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);       
        ACETLGT_ReferralWebservice  ACETRW =new ACETLGT_ReferralWebservice ();   
        ACETWSCalloutResult findReferralServiceCalloutResult = ACETRW.findReferrals('Jacqueline','Henry','date1','890504607');
        String dateToFormat = '1/2/1955';
        dateToFormat = ACETRW.formattedDate(dateToFormat);
        dateToFormat = ACETRW.formatDateWithZeros(dateToFormat);
        findReferralServiceCalloutResult.Success = true;
        
         String dateToFormat1 = '01/02/1955';
        dateToFormat1 = ACETRW.formattedDate(dateToFormat1);
        dateToFormat1 = ACETRW.formatDateWithZeros(dateToFormat1);
        
        ACETLGT_ReferralSearchController.getReferralSearchResults('Test','Test','01/02/1955','Test');
        ACETLGT_ReferralSearchController.getReferralDetailResults('Test','Test','01/02/1955','Test');  
        ACETLGT_ReferralSearchController.getStdErrMsg('',123);
        ACETLGT_ReferralSearchController.getStdErrMsg('4',400);       
    }
    static testMethod void ACETLGT_ReferralSearchControllerTest2() {
        ACETLGT_ReferralJSON2Apex.SourceMemberId srcMemId = new ACETLGT_ReferralJSON2Apex.SourceMemberId(); 
         srcMemId.id = 'test';
        srcMemId.type_Z = 'test';
        
        ACETLGT_ReferralJSON2Apex.Member mmbr = new ACETLGT_ReferralJSON2Apex.Member();       
        mmbr.SourceMemberId = new ACETLGT_ReferralJSON2Apex.SourceMemberId();
        mmbr.SourceMemberId = srcMemId;
        mmbr.firstName = 'test';
        mmbr.lastName = 'test';
        mmbr.middleName = 'test';
        mmbr.suffixCode = 'test';
        mmbr.birthDate = 'test';
        
        ACETLGT_ReferralJSON2Apex.statusCode gen = new ACETLGT_ReferralJSON2Apex.statusCode();
        gen.code = 'test';
        gen.desc_Z = 'test';
        mmbr.gender = new ACETLGT_ReferralJSON2Apex.statusCode();
        mmbr.gender = gen;
        mmbr.relationshipCode = 'test';
        
        ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers enId = new ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers(); 
        enId.id = 'test';
        enId.typeCode = 'test';
        enId.typeCodeDesc = 'test';
        mmbr.enrolleIdentifiers = new List<ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers>();
        mmbr.enrolleIdentifiers.add(enId);
        
        ACETLGT_ReferralJSON2Apex.Pagination page = new ACETLGT_ReferralJSON2Apex.Pagination();
        page.pageSize = 'test';
        page.totalCount = 'test';
        page.startRecord = 'test';
        page.moreRecords = 'test';
        
        ACETLGT_ReferralJSON2Apex.Services serv = new ACETLGT_ReferralJSON2Apex.Services();
        serv.sequenceNumber = 'test';
        serv.providerSeqNumber = 'test';
        ACETLGT_ReferralJSON2Apex.SpecialityType specType = new ACETLGT_ReferralJSON2Apex.SpecialityType();
        specType.code = 'test';
        specType.sourceSystem = 'test';
        
        ACETLGT_ReferralJSON2Apex.Providers prov = new ACETLGT_ReferralJSON2Apex.Providers();
        prov.providerSeqNumber = 'test';
        prov.category = 'test';
        prov.telephoneNumber = 'test';
        prov.faxNumber = 'test';
                
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.FindReferralSearchResponseJSON());
        OILResponse.TokenExpired = false;  
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);   
          
        ACETLGT_ReferralWebservice ACETRW1 = new ACETLGT_ReferralWebservice();
        //Test      
       ACETRW1.ChangeDateFormat('date1'); 
       ACETRW1.setStringToDateFormat('date1'); 
       
        ACETWSCalloutResult queryPaginatedDataResult =  ACETRW1.queryPaginatedData(1,50,1);
         
    }
    static testMethod void ACETLGT_ReferralSearchControllerTest3() {
      
       MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', '');
        OILResponse4.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes4 = new MockHttpCalloutResponseGenerator(null, OILResponse4);
        Test.setMock(HttpCalloutMock.class, MockHttpRes4); 
        ACETLGT_ReferralWebservice aws4 = new ACETLGT_ReferralWebservice();
         aws4.findReferrals('Jacqueline','Henry','date1','890504607'); 
        
         MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'ERR003-No Records found', '' );
        OILResponse5.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes5 = new MockHttpCalloutResponseGenerator(null, OILResponse5);
        Test.setMock(HttpCalloutMock.class, MockHttpRes5); 
          ACETLGT_ReferralWebservice aws5 = new ACETLGT_ReferralWebservice();
       aws5.findReferrals('Jacqueline','Henry','date1','890504607'); 
       
        MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse7 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'ERR004-Member not found', 'ERR004-Member not found');
        OILResponse7.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes7 = new MockHttpCalloutResponseGenerator(null, OILResponse7);
        Test.setMock(HttpCalloutMock.class, MockHttpRes7); 
          ACETLGT_ReferralWebservice aws7 = new ACETLGT_ReferralWebservice();
       aws7.findReferrals('Jacqueline','Henry','date1','890504607'); 

        MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'Resource Not Found', '');
        OILResponse6.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes6 = new MockHttpCalloutResponseGenerator(null, OILResponse6);
        Test.setMock(HttpCalloutMock.class, MockHttpRes6); 
           ACETLGT_ReferralWebservice aws6 = new ACETLGT_ReferralWebservice();
       aws6.findReferrals('Jacqueline','Henry','date1','890504607');      
    }   
    static testMethod void ACETLGT_ReferralSearchControllerTest4() {
      
       MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', '');
        OILResponse4.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes4 = new MockHttpCalloutResponseGenerator(null, OILResponse4);
        Test.setMock(HttpCalloutMock.class, MockHttpRes4); 
        ACETLGT_ReferralWebservice aws4 = new ACETLGT_ReferralWebservice();
         aws4.queryPaginatedData(1,1,1);
         
         ACETLGT_ReferralJSON2Apex.errors err = new ACETLGT_ReferralJSON2Apex.errors();
        err.code = 404;
        err.severity = 'INFORMATIONAL';
        err.origin ='eisl';
        err.description = 'test';
        err.name = 'ERR003-No Records found';
        
         MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'ERR003-No Records found', 'ERR003-Member not found');
        OILResponse5.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes5 = new MockHttpCalloutResponseGenerator(null, OILResponse5);
        Test.setMock(HttpCalloutMock.class, MockHttpRes5); 
          ACETLGT_ReferralWebservice aws5 = new ACETLGT_ReferralWebservice();
       aws5.queryPaginatedData(1,1,1);
       
        MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse7 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'ERR004-Member not found', 'ERR004-Member not found');
        OILResponse7.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes7 = new MockHttpCalloutResponseGenerator(null, OILResponse7);
        Test.setMock(HttpCalloutMock.class, MockHttpRes7); 
          ACETLGT_ReferralWebservice aws7 = new ACETLGT_ReferralWebservice();
       aws7.queryPaginatedData(1,1,1);

        MockHttpCalloutResponseGenerator.MockHttpResponse  OILResponse6 = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'Resource Not Found', '');
        OILResponse6.TokenExpired = false; 
         MockHttpCalloutResponseGenerator MockHttpRes6 = new MockHttpCalloutResponseGenerator(null, OILResponse6);
        Test.setMock(HttpCalloutMock.class, MockHttpRes6); 
           ACETLGT_ReferralWebservice aws6 = new ACETLGT_ReferralWebservice();
       aws6.queryPaginatedData(1,1,1);

    }   
    static testMethod void ACETLGT_ReferralSearchControllerTest5(){   
        Test.startTest();
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        System.debug('tokenAPIOrgSpecificConfigs::'+tokenAPIOrgSpecificConfigs);
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Search Clinical Referrals Endpoint', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);  
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK','{"searchType":"M","requestDateRange":{"stopDate":"9999-12-31","startDate":"","dateRangeTypeCode":""},"pagination":{"startRecord":"1","pageSize":"50","pageNumber":"1"},"member":{"lastName":null,"firstName":null,"enrolleeIdentifier":{"type":"SRK","id":null},"birthDate":""}}}');
        OILResponse.TokenExpired = false;  
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);   
        ACETLGT_ReferralWebservice ACETRW1 = new ACETLGT_ReferralWebservice(); 
        ACETWSCalloutResult queryPaginatedDataResult =  ACETRW1.queryPaginatedData(1,50,1);
        Test.stopTest();
    }
    static testMethod void ACETLGT_ReferralSearchControllerTest6(){   
        Test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK','{"pcp-referrals-response":{"referrals":[{"referralId":"23302","referralTypeID":"2","referralDescription":"Referral Exceptions/Standing Referral","numberOfVisits":"12","numberOfVisitsUsed":"0","numberOfVisitsRemaining":"12","referralDateRange":{"startDate":"2021-07-19","stopDate":"2022-01-14"},"statusCode":{"code":"2","desc":"Active"},"sourceApplicationCode":{},"noteText":"CREATING TEST DATA","referralDate":"2021-07-21","createDateTime":"2021-07-21T20:44:50.971-05:00","member":{"sourceMemberId":{"id":"721727886","type":"SRK"},"firstName":"Dale","lastName":"Reeves","middleName":"Z","birthDate":"1992-05-25","gender":{"code":"F","desc":"Female"},"relationshipCode":"SF","enrolleIdentifiers":[{"id":"65186417600","typeCode":"1","typeCodeDesc":"Subscriber ID"},{"id":"65186417600","typeCode":"2","typeCodeDesc":"Member ID"},{"id":"65186417600","typeCode":"28","typeCodeDesc":"ID Card Serial Number"},{"id":"721727886","typeCode":"31","typeCodeDesc":"Enrollee Surrogate Key"},{"id":"564767834","typeCode":"4","typeCodeDesc":"Social Security Number"},{"id":"721727886","typeCode":"43","typeCodeDesc":"Subscriber Surrogate Key"}]},"providers":[{"providerSeqNumber":"1","category":"P","firstName":"BEATRICE","middleName":"O","lastName":"ONYEADOR","address":{"addressLine1":"304 LAKEVIEW AVE","city":"CLIFTON","state":{"code":"NJ","desc":"NEW JERSEY"},"postalCode1":"07011","postalCode2":"4069"},"specialityType":[{},{"code":"207R00000X","desc":"Internal Medicine","sourceSystem":"CR"}],"telephoneNumber":"973-478-8600","faxNumber":"973-478-8601","role":[{"id":"PC","desc":"Primary Care Provider"},{"id":"RF","desc":"Requesting Provider"}],"providerIdentifiers":[{"id":"352175617","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1114969870","typeCode":"06","typeCodeDesc":"NPI"},{"id":"966646192388966245","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"1485382627881","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]},{"providerSeqNumber":"2","category":"P","firstName":"ERIC","middleName":"M","lastName":"JACKSON","address":{"addressLine1":"16 RIDGE RD","city":"NORTH ARLINGTON","state":{"code":"NJ","desc":"NEW JERSEY"},"postalCode1":"07031","postalCode2":"6339"},"specialityType":[{},{"code":"207R00000X","desc":"Internal Medicine","sourceSystem":"CR"}],"role":[{"id":"SJ","desc":"Servicing"}],"providerIdentifiers":[{"id":"814623262","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1235131251","typeCode":"06","typeCodeDesc":"NPI"},{"id":"317145891138338030","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"1458850304704","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]}],"services":[{"sequenceNumber":"1","procedureCode":{"code":"93797","codeDesc":"OUTPATIENT CARDIAC REHAB W/O CONT ECG MONITOR","typeCode":"2","typeCodeDesc":"CPT4"},"providerSeqNumber":"0"}],"diagnosis":[{"sequenceNumber":"1","diagnosisCode":{"code":"I20.0","codeDesc":"UNSTABLE ANGINA","typeCode":"0","typeCodeDesc":"ICD10"}}]},{"referralId":"23301","referralTypeID":"1","referralDescription":"Consultation and Treatment","numberOfVisits":"6","numberOfVisitsUsed":"0","numberOfVisitsRemaining":"6","referralDateRange":{"startDate":"2021-07-21","stopDate":"2022-01-16"},"statusCode":{"code":"2","desc":"Active"},"sourceApplicationCode":{},"noteText":"TEST COMMENTS","referralDate":"2021-07-21","createDateTime":"2021-07-21T20:41:41.984-05:00","member":{"sourceMemberId":{"id":"721727886","type":"SRK"},"firstName":"Dale","lastName":"Reeves","middleName":"Z","birthDate":"1992-05-25","gender":{"code":"F","desc":"Female"},"relationshipCode":"SF","enrolleIdentifiers":[{"id":"65186417600","typeCode":"1","typeCodeDesc":"Subscriber ID"},{"id":"65186417600","typeCode":"2","typeCodeDesc":"Member ID"},{"id":"65186417600","typeCode":"28","typeCodeDesc":"ID Card Serial Number"},{"id":"721727886","typeCode":"31","typeCodeDesc":"Enrollee Surrogate Key"},{"id":"564767834","typeCode":"4","typeCodeDesc":"Social Security Number"},{"id":"721727886","typeCode":"43","typeCodeDesc":"Subscriber Surrogate Key"}]},"providers":[{"providerSeqNumber":"1","category":"P","firstName":"BEATRICE","middleName":"O","lastName":"ONYEADOR","address":{"addressLine1":"304 LAKEVIEW AVE","city":"CLIFTON","state":{"code":"NJ","desc":"NEW JERSEY"},"postalCode1":"07011","postalCode2":"4069"},"specialityType":[{},{"code":"207R00000X","desc":"Internal Medicine","sourceSystem":"CR"}],"telephoneNumber":"973-478-8600","faxNumber":"973-478-8601","role":[{"id":"PC","desc":"Primary Care Provider"},{"id":"RF","desc":"Requesting Provider"}],"providerIdentifiers":[{"id":"352175617","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1114969870","typeCode":"06","typeCodeDesc":"NPI"},{"id":"966646192388966245","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"1485382627881","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]},{"providerSeqNumber":"2","category":"P","firstName":"JAYENDRA","lastName":"PATEL","address":{"addressLine1":"1220 HIGHWAY 70","city":"WHITING","state":{"code":"NJ","desc":"NEW JERSEY"},"postalCode1":"08759","postalCode2":"1000"},"specialityType":[{},{"code":"207RC0000X","desc":"Cardiovascular Disease","sourceSystem":"CR"}],"role":[{"id":"SJ","desc":"Servicing"}],"providerIdentifiers":[{"id":"462219798","typeCode":"03","typeCodeDesc":"Federal Tax ID"},{"id":"TIN","typeCode":"04","typeCodeDesc":"Federal Tax ID Prefix"},{"id":"1023044104","typeCode":"06","typeCodeDesc":"NPI"},{"id":"546446190820068268","typeCode":"14","typeCodeDesc":"Provider Lifetime ID"},{"id":"1452407781749","typeCode":"20","typeCodeDesc":"Cirrus Provider Address ID"},{"id":"PRAC","typeCode":"21","typeCodeDesc":"Cirrus Provider Address Type"}]}],"services":[{"sequenceNumber":"1","procedureCode":{"code":"99204","codeDesc":"OFFICE/OUTPATIENT NEW MODERATE MDM 45-59 MINUTES","typeCode":"2","typeCodeDesc":"CPT4"},"providerSeqNumber":"0"}],"diagnosis":[{"sequenceNumber":"1","diagnosisCode":{"code":"L02.13","codeDesc":"CARBUNCLE OF NECK","typeCode":"0","typeCodeDesc":"ICD10"}}]}],"pagination":{"pageSize":"50","totalCount":"2","startRecord":"1","moreRecords":"false"}}}');
        OILResponse.TokenExpired = false;  
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);   
        ACETLGT_ReferralWebservice ACETRW1 = new ACETLGT_ReferralWebservice(); 
        ACETWSCalloutResult queryPaginatedDataResult =  ACETRW1.queryPaginatedData(1,50,1);  
        ACETWSCalloutResult findReferralServiceCalloutResult = ACETRW1.findReferrals('Jacqueline','Henry','date1','890504607');
        Test.stopTest();
    }  
 
    static testMethod void ACETLGT_ReferralSearchControllerTest7(){   
        Test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'ERROR','{"pcp-referrals-response":{"errors":[{"code":"404","description":"ERR003-No Records found"}],"pagination":{"pageSize":"50","totalCount":"2","startRecord":"1","moreRecords":"false"}}}');
        OILResponse.TokenExpired = false;  
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);   
        ACETLGT_ReferralWebservice ACETRW1 = new ACETLGT_ReferralWebservice(); 
        ACETWSCalloutResult queryPaginatedDataResult =  ACETRW1.queryPaginatedData(1,50,1);  
        ACETWSCalloutResult findReferralServiceCalloutResult = ACETRW1.findReferrals('Jacqueline','Henry','date1','890504607');
        Test.stopTest();
    }
}