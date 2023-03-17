@isTest(SeeAllData=false)
private class ACETReferralSearchControllerTest{
    static testMethod void testACETReferralSearchController(){        
        Interaction__c inte = TestDataFactory.createInteraction();

        insert new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey',Algorithm_Name__c= 'AES256',Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9');
        insert new ACETOrgInstanceURLToOrgNameMap__c(Name = 'salesforce', Org_name__c='qa');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEConsumerDashboard',Swivel_Endpoint__c='/idp/login?app=0sp21000000CaSo&RelayState=https://icuealpha.uhc.com/icue/consumerDashboardSSOLogin.uhg?');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEPCPReferral',Swivel_Endpoint__c='/idp/login?app=0spg0000000Cadr&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?');
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        ACETReferralWebservice ACETRW=new ACETReferralWebservice();
        ACETWSCalloutResult findReferralServiceCalloutResult = new ACETWSCalloutResult();
        findReferralServiceCalloutResult = ACETRW.findReferrals('Jacqueline','Henry','01/01/1965','890504607');
        String dateToFormat = '01/02/1955';
        dateToFormat = ACETRW.formattedDate(dateToFormat);
        dateToFormat = ACETRW.formatDateWithZeros(dateToFormat);
                  
         
                  
        PageReference pageRef = Page.ACETReferralSearch;
        Test.setCurrentPage(pageRef);
        string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';
        apexpages.currentpage().getparameters().put('additionalInfo',additional);
        apexpages.currentpage().getparameters().put('interactionId',inte.Id);
        apexpages.currentpage().getparameters().put('contactId',contactObj.id);
        apexpages.currentpage().getparameters().put('SRK','testkey');
        apexpages.currentpage().getparameters().put('ReferalNumber','3345353');

            
        ApexPages.currentPage().getParameters().put('qp', 'yyyy');
        ACETReferralSearchController Controller  = new ACETReferralSearchController();
        controller.init();
        Controller.strReferralNumber = '';
        list<ACETReferralSearchResult> referralsearchlist = new List<ACETReferralSearchResult>();
        ACETReferralSearchResult referralsearch = new ACETReferralSearchResult();
        List<ACETReferralSearchResult.Provider> providerlist = new List<ACETReferralSearchResult.Provider>();
        ACETReferralSearchResult.Provider referralsearchprovider = new ACETReferralSearchResult.Provider();
        
        List<ACETReferralSearchResult.Service> Servicelist = new List<ACETReferralSearchResult.Service>();
        ACETReferralSearchResult.Service referralsearchservice = new ACETReferralSearchResult.Service();        
        List<ACETReferralSearchResult.Diagnosis> Diagnosislist = new List<ACETReferralSearchResult.Diagnosis>();
        ACETReferralSearchResult.Diagnosis referralsearchDiagnosis = new ACETReferralSearchResult.Diagnosis();
        
        referralsearchprovider.resultAddress = 'Test';
        referralsearchprovider.resultCity = 'TX';
        referralsearchprovider.resultMPIN = '75039';
        referralsearchprovider.resultName = 'Test';
        referralsearchprovider.resultNetworkStatus = 'New';
        referralsearchprovider.resultProviderRole = 'Test';
        referralsearchprovider.resultState = 'Test';
        referralsearchprovider.resultTIN = 'Test';
        referralsearchprovider.resultZip = '75039';
        referralsearchprovider.speciality = 'Test';
        providerlist.add(referralsearchprovider);
        
        referralsearchservice.resultProcedureType = 'Test';
        referralsearchservice.resultProcedureCode = 'Test';
        referralsearchservice.resultDescription = 'Test';
        
        Servicelist.add(referralsearchservice);
        
        referralsearchDiagnosis.resultdiagCode = 'Test';
        referralsearchDiagnosis.resultdiadDesc = 'Test';
        Diagnosislist.add(referralsearchDiagnosis);
        
        referralsearch.resultMembername = 'Test';
        referralsearch.resultReferralnumber = '3423422';
        referralsearch.resultReferralstatus= 'New';
        referralsearch.resultStartdate = '12/16';
        referralsearch.resultEnddate = '14/16';
        referralsearch.resultReferaltype = 'Test';
        referralsearch.resultRequestingtin = 'Test';
        referralsearch.resultRequestingprovider = 'Test';
        referralsearch.resultServicingtin = 'Test';
        referralsearch.resultServicingprovider = 'Test';
        referralsearch.resultDxcode = 'Test';
        referralsearch.resultDXDescription = 'Test';
        referralsearch.selected = true;
        referralsearch.resultreferralExternalID = 'Test';
        referralsearch.resultCreatedDate = 'Test';
        referralsearch.numberofvisit = '10';
        referralsearch.noteText='Test';
        referralsearch.providerlst = providerlist;
        referralsearch.servicelst = Servicelist;
        referralsearch.diagnosisList = Diagnosislist;
        referralsearchlist.add(referralsearch);
        Controller.lstReferrals = new list<ACETReferralSearchResult>();
        Controller.lstReferrals = referralsearchlist;
       
        controller.navigateTodetail();
        controller.applyfilter();
        controller.clearfilter();
        controller.getReferralTypeValues();
    }
    
    static testMethod void testACETReferralSearchController3(){
        
        Interaction__c inte = TestDataFactory.createInteraction();

        
        insert new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey',Algorithm_Name__c= 'AES256',Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9');
        insert new ACETOrgInstanceURLToOrgNameMap__c(Name = 'salesforce', Org_name__c='qa');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEConsumerDashboard',Swivel_Endpoint__c='/idp/login?app=0sp21000000CaSo&RelayState=https://icuealpha.uhc.com/icue/consumerDashboardSSOLogin.uhg?');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEPCPReferral',Swivel_Endpoint__c='/idp/login?app=0spg0000000Cadr&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?');
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        PageReference pageRef = Page.ACETReferralSearch;
        Test.setCurrentPage(pageRef);
        string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';
        apexpages.currentpage().getparameters().put('additionalInfo',additional);
        apexpages.currentpage().getparameters().put('interactionId',inte.Id);
        apexpages.currentpage().getparameters().put('contactId',contactObj.id);
        apexpages.currentpage().getparameters().put('SRK','testkey');
            
        ApexPages.currentPage().getParameters().put('qp', 'yyyy');
        ACETReferralSearchController Controller  = new ACETReferralSearchController();
        controller.init();
        Controller.strReferralNumber = '';
        
         
        list<ACETReferralSearchResult> referralsearchlist = new List<ACETReferralSearchResult>();
        ACETReferralSearchResult referralsearch = new ACETReferralSearchResult();
        List<ACETReferralSearchResult.Provider> providerlist = new List<ACETReferralSearchResult.Provider>();
        ACETReferralSearchResult.Provider referralsearchprovider = new ACETReferralSearchResult.Provider();
        
        List<ACETReferralSearchResult.Service> Servicelist = new List<ACETReferralSearchResult.Service>();
        ACETReferralSearchResult.Service referralsearchservice = new ACETReferralSearchResult.Service();
        
        
        List<ACETReferralSearchResult.Diagnosis> Diagnosislist = new List<ACETReferralSearchResult.Diagnosis>();
        ACETReferralSearchResult.Diagnosis referralsearchDiagnosis = new ACETReferralSearchResult.Diagnosis();
        
        referralsearchprovider.resultAddress = 'Test';
        referralsearchprovider.resultCity = 'TX';
        referralsearchprovider.resultMPIN = '75039';
        referralsearchprovider.resultName = 'Test';
        referralsearchprovider.resultNetworkStatus = 'New';
        referralsearchprovider.resultProviderRole = 'Primary Care Provider';
        referralsearchprovider.resultState = 'Test';
        referralsearchprovider.resultTIN = 'Test';
        referralsearchprovider.resultZip = '75039';
        referralsearchprovider.speciality = 'Test';
        providerlist.add(referralsearchprovider);
        
        referralsearchservice.resultProcedureType = 'Test';
        referralsearchservice.resultProcedureCode = 'Test';
        referralsearchservice.resultDescription = 'Test';
        
        Servicelist.add(referralsearchservice);
        
        referralsearchDiagnosis.resultdiagCode = 'Test';
        referralsearchDiagnosis.resultdiadDesc = 'Test';
        Diagnosislist.add(referralsearchDiagnosis);
        
        referralsearch.resultMembername = 'Test';
        referralsearch.resultReferralnumber = '1234';
        referralsearch.resultReferralstatus= 'New';
        referralsearch.resultStartdate = '12/16';
        referralsearch.resultEnddate = '14/16';
        referralsearch.resultReferaltype = 'Test';
        referralsearch.resultRequestingtin = 'Test';
        referralsearch.resultRequestingprovider = 'Test';
        referralsearch.resultServicingtin = 'Test';
        referralsearch.resultServicingprovider = 'Test';
        referralsearch.resultDxcode = 'Test';
        referralsearch.resultDXDescription = 'Test';
        referralsearch.selected = true;
        referralsearch.resultreferralExternalID = 'Test';
        referralsearch.resultCreatedDate = 'Test';
        referralsearch.numberofvisit = '10';
        referralsearch.providerlst = providerlist;
        referralsearch.servicelst = Servicelist;
        referralsearch.diagnosisList = Diagnosislist;
        referralsearchlist.add(referralsearch);
        Controller.lstReferrals = new list<ACETReferralSearchResult>();
        Controller.lstReferrals = referralsearchlist;
        Controller.referralsresult=referralsearchlist;
        Controller.ReferralType = 'Test';
                Controller.navigateTodetail(); 
        controller.applyfilter();
        controller.clearfilter();
        controller.getReferralTypeValues();
    }
    
    static testMethod void testACETReferralSearchController4(){
        
        Interaction__c inte = TestDataFactory.createInteraction();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        insert new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey',Algorithm_Name__c= 'AES256',Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9');
        insert new ACETOrgInstanceURLToOrgNameMap__c(Name = 'salesforce', Org_name__c='qa');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEConsumerDashboard',Swivel_Endpoint__c='/idp/login?app=0sp21000000CaSo&RelayState=https://icuealpha.uhc.com/icue/consumerDashboardSSOLogin.uhg?');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEPCPReferral',Swivel_Endpoint__c='/idp/login?app=0spg0000000Cadr&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?');
        
        
        PageReference pageRef = Page.ACETReferralSearch;
        Test.setCurrentPage(pageRef);
        string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';
        apexpages.currentpage().getparameters().put('additionalInfo',additional);
        apexpages.currentpage().getparameters().put('interactionId',inte.Id);
        apexpages.currentpage().getparameters().put('contactId',contactObj.id);
        apexpages.currentpage().getparameters().put('SRK','testkey');
                apexpages.currentpage().getparameters().put('referralNumber','128u93uj');
    
        ApexPages.currentPage().getParameters().put('qp', 'yyyy');
        ACETReferralSearchController Controller  = new ACETReferralSearchController();
        controller.init();
        Controller.strReferralNumber = '';
        
        list<ACETReferralSearchResult> referralsearchlist = new List<ACETReferralSearchResult>();
        ACETReferralSearchResult referralsearch = new ACETReferralSearchResult();
        List<ACETReferralSearchResult.Provider> providerlist = new List<ACETReferralSearchResult.Provider>();
        ACETReferralSearchResult.Provider referralsearchprovider = new ACETReferralSearchResult.Provider();
        
        List<ACETReferralSearchResult.Service> Servicelist = new List<ACETReferralSearchResult.Service>();
        ACETReferralSearchResult.Service referralsearchservice = new ACETReferralSearchResult.Service();
        
        
        List<ACETReferralSearchResult.Diagnosis> Diagnosislist = new List<ACETReferralSearchResult.Diagnosis>();
        ACETReferralSearchResult.Diagnosis referralsearchDiagnosis = new ACETReferralSearchResult.Diagnosis();
        
        referralsearchprovider.resultAddress = 'Test';
        referralsearchprovider.resultCity = 'TX';
        referralsearchprovider.resultMPIN = '75039';
        referralsearchprovider.resultName = 'Test';
        referralsearchprovider.resultNetworkStatus = 'New';
        referralsearchprovider.resultProviderRole = 'Test';
        referralsearchprovider.resultState = 'Test';
        referralsearchprovider.resultTIN = 'Test';
        referralsearchprovider.resultZip = '75039';
        referralsearchprovider.speciality = 'Test';
        providerlist.add(referralsearchprovider);
        
        referralsearchservice.resultProcedureType = 'Test';
        referralsearchservice.resultProcedureCode = 'Test';
        referralsearchservice.resultDescription = 'Test';
        
        Servicelist.add(referralsearchservice);
        
        referralsearchDiagnosis.resultdiagCode = 'Test';
        referralsearchDiagnosis.resultdiadDesc = 'Test';
        Diagnosislist.add(referralsearchDiagnosis);
        
        referralsearch.resultMembername = 'Test';
        referralsearch.resultReferralnumber = '1234';
        referralsearch.resultReferralstatus= 'Active';
        referralsearch.resultStartdate = '12/16';
        referralsearch.resultEnddate = '12/16';
        referralsearch.resultReferaltype = 'Test';
        referralsearch.resultRequestingtin = 'Test';
        referralsearch.resultRequestingprovider = 'Test';
        referralsearch.resultServicingtin = 'Test';
        referralsearch.resultServicingprovider = 'Test';
        referralsearch.resultDxcode = 'Test';
        referralsearch.resultDXDescription = 'Test';
        referralsearch.selected = true;
        referralsearch.resultreferralExternalID = 'Test';
        referralsearch.resultCreatedDate = 'Test';
        referralsearch.numberofvisit = '10';
        referralsearch.providerlst = providerlist;
        referralsearch.servicelst = Servicelist;
        referralsearch.diagnosisList = Diagnosislist;
        referralsearchlist.add(referralsearch);
        Controller.lstReferrals = new list<ACETReferralSearchResult>();
        Controller.lstReferrals = referralsearchlist;
        Controller.referralsresult=referralsearchlist;
       
        Controller.RefrStatus = 'Active'; 
        controller.applyfilter();
        controller.clearfilter();
        controller.getReferralTypeValues();
        Call_Topic_Access__c aacc = new Call_Topic_Access__c();
        aacc.CallTopicAccessExternalID__c='test';
        aacc.Call_Topic__c = 'Create PCP Referral';
        insert aacc;
        list<Call_Topic_Access__c> aacclst = new list<Call_Topic_Access__c>();
        aacclst.add(aacc);
    }
    
     static testMethod void testACETReferralSearchController2(){
        
        Interaction__c inte = TestDataFactory.createInteraction();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        insert new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey',Algorithm_Name__c= 'AES256',Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9');
        insert new ACETOrgInstanceURLToOrgNameMap__c(Name = 'salesforce', Org_name__c='qa');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEConsumerDashboard',Swivel_Endpoint__c='/idp/login?app=0sp21000000CaSo&RelayState=https://icuealpha.uhc.com/icue/consumerDashboardSSOLogin.uhg?');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEPCPReferral',Swivel_Endpoint__c='/idp/login?app=0spg0000000Cadr&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?');
        
        
        PageReference pageRef = Page.ACETReferralSearch;
        Test.setCurrentPage(pageRef);
        string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';
        apexpages.currentpage().getparameters().put('additionalInfo',additional);
        apexpages.currentpage().getparameters().put('interactionId',inte.Id);
        apexpages.currentpage().getparameters().put('contactId',contactObj.id);
        apexpages.currentpage().getparameters().put('SRK','testkey');
            
        ApexPages.currentPage().getParameters().put('qp', 'yyyy');
        ACETReferralSearchController Controller  = new ACETReferralSearchController();
        controller.init();
        
        list<ACETReferralSearchResult> referralsearchlist = new List<ACETReferralSearchResult>();
        ACETReferralSearchResult referralsearch = new ACETReferralSearchResult();
        List<ACETReferralSearchResult.Provider> providerlist = new List<ACETReferralSearchResult.Provider>();
        ACETReferralSearchResult.Provider referralsearchprovider = new ACETReferralSearchResult.Provider();
        
        List<ACETReferralSearchResult.Service> Servicelist = new List<ACETReferralSearchResult.Service>();
        ACETReferralSearchResult.Service referralsearchservice = new ACETReferralSearchResult.Service();
        
        
        List<ACETReferralSearchResult.Diagnosis> Diagnosislist = new List<ACETReferralSearchResult.Diagnosis>();
        ACETReferralSearchResult.Diagnosis referralsearchDiagnosis = new ACETReferralSearchResult.Diagnosis();
        
        referralsearchprovider.resultAddress = 'Test';
        referralsearchprovider.resultCity = 'TX';
        referralsearchprovider.resultMPIN = '75039';
        referralsearchprovider.resultName = 'Test';
        referralsearchprovider.resultNetworkStatus = 'New';
        referralsearchprovider.resultProviderRole = 'Test';
        referralsearchprovider.resultState = 'Test';
        referralsearchprovider.resultTIN = 'Test';
        referralsearchprovider.resultZip = '75039';
        referralsearchprovider.speciality = 'Test';
        providerlist.add(referralsearchprovider);
        
        referralsearchservice.resultProcedureType = 'Test';
        referralsearchservice.resultProcedureCode = 'Test';
        referralsearchservice.resultDescription = 'Test';
        
        Servicelist.add(referralsearchservice);
        
        referralsearchDiagnosis.resultdiagCode = 'Test';
        referralsearchDiagnosis.resultdiadDesc = 'Test';
        Diagnosislist.add(referralsearchDiagnosis);
        
        referralsearch.resultMembername = 'Test';
        referralsearch.resultReferralnumber = '1234';
        referralsearch.resultReferralstatus= 'New';
        referralsearch.resultStartdate = '12/16';
        referralsearch.resultEnddate = '12/16';
        referralsearch.resultReferaltype = 'Test';
        referralsearch.resultRequestingtin = 'Test';
        referralsearch.resultRequestingprovider = 'Test';
        referralsearch.resultServicingtin = 'Test';
        referralsearch.resultServicingprovider = 'Test';
        referralsearch.resultDxcode = 'Test';
        referralsearch.resultDXDescription = 'Test';
        referralsearch.selected = true;
        referralsearch.resultreferralExternalID = 'Test';
        referralsearch.resultCreatedDate = 'Test';
        referralsearch.numberofvisit = '10';
        referralsearch.providerlst = providerlist;
        referralsearch.servicelst = Servicelist;
        referralsearch.diagnosisList = Diagnosislist;
        referralsearchlist.add(referralsearch);
        Controller.lstReferrals = new list<ACETReferralSearchResult>();
        Controller.lstReferrals = referralsearchlist;
       
        Controller.strReferralNumber = '1234'; 
        controller.applyfilter();
        controller.clearfilter();
        controller.getReferralTypeValues();
    }
    
    
    static testMethod void testACETClaimSearchControllertest2() 
    {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'c01f9e68-d976-4a52-83e9-ae0fe164f3b2');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_SearchClinicalReferralsEndpoint',  '/api/alpha/eisl/clinical/referrals/v2.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        insert new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey',Algorithm_Name__c= 'AES256',Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9');
        insert new ACETOrgInstanceURLToOrgNameMap__c(Name = 'salesforce', Org_name__c='qa');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEConsumerDashboard',Swivel_Endpoint__c='/idp/login?app=0sp21000000CaSo&RelayState=https://icuealpha.uhc.com/icue/consumerDashboardSSOLogin.uhg?');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEPCPReferral',Swivel_Endpoint__c='/idp/login?app=0spg0000000Cadr&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?');
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.FindReferralSearchResponseJSON());
        OILResponse.TokenExpired = false;
        
        Test.startTest();
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        PageReference ACETRSPage = Page.ACETReferralSearch;
        Test.setCurrentPage(ACETRSPage);
        
        ACETReferralSearchController ACETRSCtrl = new ACETReferralSearchController();
        
        //ACETRSCtrl.lstReferrals = referralsearchlist;
        ACETRSCtrl.init();
        
        ACETReferralJSON2Apex temp  = new ACETReferralJSON2Apex();
        ACETReferralJSON2Apex.SourceMemberId srcMemId = new ACETReferralJSON2Apex.SourceMemberId(); 
        ACETReferralJSON2Apex.Member mmbr = new ACETReferralJSON2Apex.Member();
        srcMemId.id = 'test';
    srcMemId.type_Z = 'test';
    mmbr.SourceMemberId = new ACETReferralJSON2Apex.SourceMemberId();
    mmbr.SourceMemberId = srcMemId;
    mmbr.firstName = 'test';
    mmbr.lastName = 'test';
    mmbr.middleName = 'test';
    mmbr.suffixCode = 'test';
    mmbr.birthDate = 'test';
    ACETReferralJSON2Apex.statusCode gen = new ACETReferralJSON2Apex.statusCode();
    gen.code = 'test';
    gen.desc_Z = 'test';
    mmbr.gender = new ACETReferralJSON2Apex.statusCode();
    mmbr.gender = gen;
    mmbr.relationshipCode = 'test';
    ACETReferralJSON2Apex.EnrolleIdentifiers enId = new ACETReferralJSON2Apex.EnrolleIdentifiers(); 
    enId.id = 'test';
    enId.typeCode = 'test';
    enId.typeCodeDesc = 'test';
    mmbr.enrolleIdentifiers = new List<ACETReferralJSON2Apex.EnrolleIdentifiers>();
    mmbr.enrolleIdentifiers.add(enId);
    //temp.Member = mmbr;
        ACETReferralJSON2Apex.Pagination page = new ACETReferralJSON2Apex.Pagination();
    page.pageSize = 'test';
    page.totalCount = 'test';
    page.startRecord = 'test';
    page.moreRecords = 'test';
    ACETReferralJSON2Apex.Services serv = new ACETReferralJSON2Apex.Services();
    serv.sequenceNumber = 'test';
    serv.providerSeqNumber = 'test';
    ACETReferralJSON2Apex.SpecialityType specType = new ACETReferralJSON2Apex.SpecialityType();
    specType.code = 'test';
    specType.sourceSystem = 'test';
    ACETReferralJSON2Apex.Providers prov = new ACETReferralJSON2Apex.Providers();
    prov.providerSeqNumber = 'test';
    prov.category = 'test';
    prov.telephoneNumber = 'test';
    prov.faxNumber = 'test';
    /*ACETReferralJSON2Apex.Organization_Z t = new  ACETReferralJSON2Apex.Organization_Z();
        ACETReferralJSON2Apex.CanonicalResponseHeader tt = new ACETReferralJSON2Apex.CanonicalResponseHeader();
        try{
        t.tinOwner.add(tt);
        }
        catch(exception e){}*/
        //temp.referral  = new temp.referral();
        //x.referralData  = new x.referralData();
        //Correspondence_Z[0].contact_Z[0].telephone[0].telephoneNumber.telephoneNumber = '123456789';
        
        Test.stopTest();
    }
    
     //Success response for ACETReferralWebservice, number of records found is greater than zero
    static testMethod void ACETAAProviderLookupControllerTest1() {
      
      Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        insert new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey',Algorithm_Name__c= 'AES256',Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9');
        insert new ACETOrgInstanceURLToOrgNameMap__c(Name = 'salesforce', Org_name__c='qa');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEConsumerDashboard',Swivel_Endpoint__c='/idp/login?app=0sp21000000CaSo&RelayState=https://icuealpha.uhc.com/icue/consumerDashboardSSOLogin.uhg?');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEPCPReferral',Swivel_Endpoint__c='/idp/login?app=0spg0000000Cadr&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?');
        
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETReferralResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETReferralSearch;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
         ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
         ACETPL.getParameters().put('contactId', oContact.Id);
         ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
         Test.setCurrentPageReference(ACETPL);
         
        ACETReferralSearchController ACETPLCtrl = new ACETReferralSearchController();
         ACETPLCtrl .init(); 
      Test.stopTest();
    } 
   static testMethod void ACETAAProviderLookupControllerTestone() {
      
      Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        insert new ACETWrapEncryptionKey__c(Name = 'qa_ICUEEncryptionKey',Algorithm_Name__c= 'AES256',Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9');
        insert new ACETOrgInstanceURLToOrgNameMap__c(Name = 'salesforce', Org_name__c='qa');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEConsumerDashboard',Swivel_Endpoint__c='/idp/login?app=0sp21000000CaSo&RelayState=https://icuealpha.uhc.com/icue/consumerDashboardSSOLogin.uhg?');
        insert new ACETOrgNameToSwivelEndpointMap__c(Name = 'qa_ICUEPCPReferral',Swivel_Endpoint__c='/idp/login?app=0spg0000000Cadr&RelayState=https://icuealpha.uhc.com/icue/pcpReferralSSOLogin.uhg?');
        
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETReferralResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        AdditionalInfo.FirstName='samtest&pp';
       AdditionalInfo.LastName ='lastname';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETReferralSearch;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
         ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
         ACETPL.getParameters().put('contactId', oContact.Id);
         ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
         Test.setCurrentPageReference(ACETPL);
         
        ACETReferralSearchController ACETPLCtrl = new ACETReferralSearchController();
         ACETPLCtrl .init(); 
      Test.stopTest();
    } 
     
}