@isTest(SeeAllData=false)
public class ACETViewEmployerGroupControllerTest
{
////
	public static Boolean failureScenario = false;
	@testsetup
    public static void testdata(){
        Organization_Properties__c settings = Organization_Properties__c.getOrgDefaults();
        settings.OrganizationName__c = 'qa';
        upsert settings Organization_Properties__c.Id;
        WebserviceConfigurations__c ws= new WebserviceConfigurations__c();
        ws.Name = 'Get Employer Group API';
        ws.recordtypeText__c = 'Token_API';
        insert ws;
        OrgSpecificConfigurations__c osc = new OrgSpecificConfigurations__c();
        osc.WebserviceConfigurations__c = ws.id;
        osc.Name='qa';
        osc.recordtypeText__c = 'TokenAPI';
        osc.EndpointDomain__c = 'https://gateway-stage.optum.com/api/alpha/cust/cirrus/employer-groups/v1/read';
        insert osc;
    }
    static testMethod void ACETViewEmployerGroupControllerTest1() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read'); 
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =TestDataFactory.createInteraction();
        ProviderTestInteraction.Originator_Type__c = 'Producer';
        update ProviderTestInteraction;
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','thirdPartId');
        ACETEGPage.getParameters().put('contactName', 'testing');
        
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"gnf":1,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');

        test.setCurrentPage(ACETEGPage);
        
        
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
         Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '1278571';
            alert1.Type__c = 'Group';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
        
       id[] fixedSearchResults = new id[1];
       fixedSearchResults[0] = alert1.id;
       Test.setFixedSearchResults(fixedSearchResults); 
       
       
       //Test JSON2Apex
       ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup dummyjson = new ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup();
       dummyjson.employeeCounts = new List<ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts>();
       ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts empCount = new ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts();
       empCount.employeeCountDescription = 'test';
       empCount.employeeCount = 'test';        
       empCount.reportingYear= '1999';
       empCount.transactionDate= '1-1-2018';
       dummyjson.employeeCounts.add(empCount);
       dummyjson.groupSettings = new List<ACETGetEmployerGroupAdapterJSON2Apex.CobAttestation>();
       ACETGetEmployerGroupAdapterJSON2Apex.CobAttestation cobAtt = new ACETGetEmployerGroupAdapterJSON2Apex.CobAttestation();
       cobAtt.cobAttestationFrequency = 'test';
       cobAtt.cobAttestationDuration = 'test';
       cobAtt.cobAttestationDenyGracePeriod = 'test';
       cobAtt.cobAttestationDenyGracePeriodDuration = 'test';
       cobAtt.effectiveDate= '1-1-2018';       
       cobAtt.effectiveDate= '1-1-2019';       
       dummyjson.groupSettings.add(cobAtt);
       dummyjson.GroupInsuringRules = new List<ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules>();
       ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules groupRules = new ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules();
       groupRules.pcpRadomization = 'test';
       groupRules.survivingSpouseIndicator = 'test';
       groupRules.newBornAutoAddIndicator = 'test';
       groupRules.countNewbornForCoverageLevelCodeIndicator = 'test';
       groupRules.earlyRetirementIndicator = 'test';
       groupRules.earlyRetirementMinimumAge = 'test';
       groupRules.workingRetirementIndicator = 'test';
       groupRules.workingRetirementMinimumAge = 'test';
       dummyjson.GroupInsuringRules.add(groupRules);
       dummyjson.GroupPopulation = new List<ACETGetEmployerGroupAdapterJSON2Apex.GroupPopulation>();
       ACETGetEmployerGroupAdapterJSON2Apex.GroupPopulation groupPop = new ACETGetEmployerGroupAdapterJSON2Apex.GroupPopulation();
       groupPop.classesCode = 'test';
       groupPop.classesDescription = 'test';
       groupPop.populationEnrollmentType = 'test';
       dummyjson.GroupPopulation.add(groupPop);
       dummyjson.customerAccount = new List<ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount>();
       ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount custAcc = new ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount();
       custAcc.CustomerAccountOption = new List<ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption>();
       ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption custAccOpt = new ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption();
       custAccOpt.statusCode = 'test';
       custAccOpt.renewalDate = '1-1-2018';
       custAccOpt.terminationReasonCode = 'test';
       custAccOpt.terminationReasonDescription = 'test';
       custAccOpt.statusHistory = new List<ACETGetEmployerGroupAdapterJSON2Apex.StatusHistory>();
       ACETGetEmployerGroupAdapterJSON2Apex.StatusHistory statHist = new ACETGetEmployerGroupAdapterJSON2Apex.StatusHistory();
       statHist.statusCode = 'test';
       statHist.statusDescription = 'test';
       statHist.effectiveDate = '1-1-2018';
       statHist.transactionDate = '1-1-2018';
       statHist.transactionUserId = 'test';
       custAccOpt.StatusHistory.add(statHist);
       custAccOpt.CustomerAccountInsuringRules = new List<ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules>();
       ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules insRules = new ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules();
       insRules.studentMaximumAge = 'test';
       insRules.studentMaximumAgeType = 'test';
       insRules.terminationLagType = 'test';
       insRules.overrideRetroBenefitAddIndicator = 'test';
       insRules.overrideRetroBenefitAddDays = 'test';
       insRules.overrideRetroBenefitChangeIndicator = 'test';
       insRules.overrideRetroBenefitChangeDays = 'test';
       insRules.overrideRetroBenefitTerminationIndicator = 'test';
       insRules.overrideRetroBenefitTerminationDays = 'test';
       insRules.classesCode = 'test';
       custAccOpt.CustomerAccountInsuringRules.add(insRules);
       custAcc.customerAccountOption.add(custAccOpt);
       dummyjson.customerAccount.add(custAcc);
           
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '12345678';
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = 'test123456';
        ACETPDExt.groupDetails.genGroupInfo.groupName = 'Contact Name';
        ACETPDExt.OnshoreRestrictionCode='All Services Offshore';
        ACETPDExt.polContractId = '20002';
        ACETPDExt.polContractEffDate = '1/1/2018';
        ACETPDExt.polContractEndDate = '12/31/2018';
        ACETPDExt.polStatus = 'Active';
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
        system.debug('result ----->'+result );
        ACETPDExt.CallGroupDetailCWS();
        system.debug('groupDetails ----->'+ACETPDExt.groupDetails);
       
        //ACETGroupDetail Wrapper test data
        //ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        //ACETPDExt.groupDetails.genGroupInfo.groupId = 'test123456';
        //ACETPDExt.groupDetails.genGroupInfo.groupName = 'Contact Name';
        
        ACETPDExt.updateProcucertab();
        List<Interaction__c> getProviderTestInteraction = [Select Id, Originator_Type__c from Interaction__c where Id = :ProviderTestInteraction.Id];
        getProviderTestInteraction.get(0).Originator_Type__c = 'Other';
        update getProviderTestInteraction;
        ACETPDExt.updateProcucertab();
        ACETPDExt.getCallTopicOptions();
        ACETPDExt.OriginatorName='UHG';
        ACETPDExt.createInteraction();
        ACETPDExt.getOriginatorNames();
        ACETPDExt.OriginatorNames = new List<SelectOption>();
        ACETPDExt.updateTPContactName();
        ACETPDExt.createThirdPartySubject();
        ACETPDExt.showHoldCode();
        ACETPDExt.hideHoldCode();
        ACETPDExt.getNoOfGroupAlert();
        ACETPDExt.updatePolicySection();
        ACETPDExt.OriginatorName = 'Contact Name';
        ACETPDExt.ContactType = 'Primary Benefits Administrator';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = 'Primary Billing Administrator';
        
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = 'Owner';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = '----None----';
        ACETPDExt.createUpdateContact();
        ACETEGPage.getParameters().put('selectedVal','Broker 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','Agent 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','UHG');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','----None----');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','ascv');
        
        ACETPDExt.getContactTypes();
        ACETEGPage.getParameters().put('InteractionId', null);
       
        ACETPDExt.createInteraction();
        ACETPDExt.contactHistoryWindow();
        ACETPDExt.CallWSOnProdHistoryClick();
        ACETPDExt.ContactName = 'abcd';
        ACETPDExt.createUpdateContact();
        ACETPDExt.createUpdateAccountContact(new contact(),new account(),'abc'); 
        List<ACETProducerSearchResult> producList = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult = new ACETProducerSearchResult();
        prodSResult.producerType = 'B';
        producList.add(prodSResult);
        prodSResult = new ACETProducerSearchResult();
        prodSResult.producerType = 'I';
        producList.add(prodSResult);
        ACETPDExt.producerSerachResultsSplit(producList,'Y'); 
        ACETPDExt.findSelectedProducerHistoryMap();
        ACETPDExt.findSelectedProducerMap();
        ACETPDExt.updatePolicyContract();
        ACETPDExt.updateContactType();
        Test.stopTest();  
      
    } 
    
    static testMethod void ACETViewEmployerGroupControllerTest1OnshoreRestriction() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read'); 
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =TestDataFactory.createInteraction();
        ProviderTestInteraction.Originator_Type__c = 'Producer';
        update ProviderTestInteraction;
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','thirdPartId');
        ACETEGPage.getParameters().put('contactName', 'testing');
        
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"gnf":1,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');

        test.setCurrentPage(ACETEGPage);
        
        
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse_OnshoreRestriction'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
         Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '1278571';
            alert1.Type__c = 'Group';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
        
       id[] fixedSearchResults = new id[1];
       fixedSearchResults[0] = alert1.id;
       Test.setFixedSearchResults(fixedSearchResults); 
       
       
       //Test JSON2Apex
       ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup dummyjson = new ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup();
       dummyjson.employeeCounts = new List<ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts>();
       ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts empCount = new ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts();
       empCount.employeeCountDescription = 'test';
       empCount.employeeCount = 'test';        
       empCount.reportingYear= '1999';
       empCount.transactionDate= '1-1-2018';
       dummyjson.employeeCounts.add(empCount);
       dummyjson.groupSettings = new List<ACETGetEmployerGroupAdapterJSON2Apex.CobAttestation>();
       ACETGetEmployerGroupAdapterJSON2Apex.CobAttestation cobAtt = new ACETGetEmployerGroupAdapterJSON2Apex.CobAttestation();
       cobAtt.cobAttestationFrequency = 'test';
       cobAtt.cobAttestationDuration = 'test';
       cobAtt.cobAttestationDenyGracePeriod = 'test';
       cobAtt.cobAttestationDenyGracePeriodDuration = 'test';
       cobAtt.effectiveDate= '1-1-2018';       
       cobAtt.effectiveDate= '1-1-2019';       
       dummyjson.groupSettings.add(cobAtt);
       dummyjson.GroupInsuringRules = new List<ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules>();
       ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules groupRules = new ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules();
       groupRules.pcpRadomization = 'test';
       groupRules.survivingSpouseIndicator = 'test';
       groupRules.newBornAutoAddIndicator = 'test';
       groupRules.countNewbornForCoverageLevelCodeIndicator = 'test';
       groupRules.earlyRetirementIndicator = 'test';
       groupRules.earlyRetirementMinimumAge = 'test';
       groupRules.workingRetirementIndicator = 'test';
       groupRules.workingRetirementMinimumAge = 'test';
       groupRules.insuringRulesEffectiveDates='8-8-2018';
       groupRules.insuringRulesExpirationDates='12-31-2018';
       dummyjson.GroupInsuringRules.add(groupRules);
       dummyjson.GroupPopulation = new List<ACETGetEmployerGroupAdapterJSON2Apex.GroupPopulation>();
       ACETGetEmployerGroupAdapterJSON2Apex.GroupPopulation groupPop = new ACETGetEmployerGroupAdapterJSON2Apex.GroupPopulation();
       groupPop.classesCode = 'test';
       groupPop.classesDescription = 'test';
       groupPop.populationEnrollmentType = 'test';
       dummyjson.GroupPopulation.add(groupPop);
       dummyjson.customerAccount = new List<ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount>();
       ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount custAcc = new ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount();
       custAcc.CustomerAccountOption = new List<ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption>();
       ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption custAccOpt = new ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption();
       custAccOpt.statusCode = 'test';
       custAccOpt.renewalDate = '1-1-2018';
       custAccOpt.terminationReasonCode = 'test';
       custAccOpt.terminationReasonDescription = 'test';
       custAccOpt.statusHistory = new List<ACETGetEmployerGroupAdapterJSON2Apex.StatusHistory>();
       ACETGetEmployerGroupAdapterJSON2Apex.StatusHistory statHist = new ACETGetEmployerGroupAdapterJSON2Apex.StatusHistory();
       statHist.statusCode = 'test';
       statHist.statusDescription = 'test';
       statHist.effectiveDate = '1-1-2018';
       statHist.transactionDate = '1-1-2018';
       statHist.transactionUserId = 'test';
       custAccOpt.StatusHistory.add(statHist);
       custAccOpt.CustomerAccountInsuringRules = new List<ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules>();
       ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules insRules = new ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules();
       insRules.studentMaximumAge = 'test';
       insRules.studentMaximumAgeType = 'test';
       insRules.terminationLagType = 'test';
       insRules.overrideRetroBenefitAddIndicator = 'test';
       insRules.overrideRetroBenefitAddDays = 'test';
       insRules.overrideRetroBenefitChangeIndicator = 'test';
       insRules.overrideRetroBenefitChangeDays = 'test';
       insRules.overrideRetroBenefitTerminationIndicator = 'test';
       insRules.overrideRetroBenefitTerminationDays = 'test';
       insRules.classesCode = 'test';
       custAccOpt.CustomerAccountInsuringRules.add(insRules);
       custAcc.customerAccountOption.add(custAccOpt);
       dummyjson.customerAccount.add(custAcc);
           
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '12345678';
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = 'test123456';
        ACETPDExt.groupDetails.genGroupInfo.groupName = 'Contact Name';
        ACETPDExt.OnshoreRestrictionCode='All Services Offshore';
        ACETPDExt.polContractId = '20002';
        ACETPDExt.polContractEffDate = '1/1/2017';
        ACETPDExt.polContractEndDate = '12/31/2017';
        ACETPDExt.polStatus = 'Termed';
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
        system.debug('result ----->'+result );
        ACETPDExt.CallGroupDetailCWS();
        system.debug('groupDetails ----->'+ACETPDExt.groupDetails);
       
        //ACETGroupDetail Wrapper test data
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = 'test123456';
        ACETPDExt.groupDetails.genGroupInfo.groupName = 'Contact Name';
        
        ACETPDExt.updateProcucertab();
        ACETPDExt.getCallTopicOptions();
        ACETPDExt.OriginatorName='UHG';
        ACETPDExt.createInteraction();
        ACETPDExt.getOriginatorNames();
        ACETPDExt.OriginatorNames = new List<SelectOption>();
        ACETPDExt.updateTPContactName();
        ACETPDExt.createThirdPartySubject();
        ACETPDExt.showHoldCode();
        ACETPDExt.hideHoldCode();
        ACETPDExt.getNoOfGroupAlert();
        ACETPDExt.updatePolicySection();
        ACETPDExt.OriginatorName = 'Contact Name';
        ACETPDExt.ContactType = 'Primary Benefits Administrator';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = 'Primary Billing Administrator';
        
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = 'Owner';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = '----None----';
        ACETPDExt.createUpdateContact();
        ACETEGPage.getParameters().put('selectedVal','Broker 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','Agent 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','UHG');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','----None----');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','ascv');
        
        ACETPDExt.getContactTypes();
        ACETEGPage.getParameters().put('InteractionId', null);
       
        ACETPDExt.createInteraction();
        ACETPDExt.contactHistoryWindow();
        ACETPDExt.CallWSOnProdHistoryClick();
        ACETPDExt.ContactName = 'abcd';
        ACETPDExt.createUpdateContact();
        ACETPDExt.createUpdateAccountContact(new contact(),new account(),'abc'); 
        List<ACETProducerSearchResult> producList = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult = new ACETProducerSearchResult();
        prodSResult.producerType = 'B';
        prodSResult.hasName=false;
        producList.add(prodSResult);
        prodSResult = new ACETProducerSearchResult();
        prodSResult.producerType = 'I';
        prodSResult.hasName=True;
        producList.add(prodSResult);
        ACETPDExt.producerSerachResultsSplit(producList,'Y');           
        ACETPDExt.updatePolicyContract();
        Test.stopTest();  
      
    } 
    
    
    static testMethod void ACETViewEmployerGroupControllerTest2() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
              
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction = TestDataFactory.createInteraction();
        ProviderTestInteraction.Originator_Type__c = 'Producer';
        ProviderTestInteraction.Caller_Type__c = 'General Agent';
        update ProviderTestInteraction ;
        
           Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '1278571';
            alert1.Type__c = 'Group';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
        
       id[] fixedSearchResults = new id[1];
       fixedSearchResults[0] = alert1.id;
       Test.setFixedSearchResults(fixedSearchResults); 
        
        
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','thirdPartId');
        ACETEGPage.getParameters().put('contactName','Contact Name');
        
        test.setCurrentPage(ACETEGPage);
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '12345678';
        ACETHighlightsPanelAdditionalInfo addinfo=new ACETHighlightsPanelAdditionalInfo();
        addinfo.RelationshipType='test';
        
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        response.setBody(ACETTestDataUtility.getEmployerGroupDetailJson());
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
      //  system.debug('result ----->'+result );
       
       ACETPDExt.CallGroupDetailCWS();
        system.debug('groupDetails ----->'+ACETPDExt.groupDetails );
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Fname';
        accountTest.LastName = '37E9769CORG1';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.Tax_ID__c = '123456';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        
        ACETPDExt.caseHistory();
          ACETPDExt.CallWSOnProdHistoryClick();
        ACETPDExt.resetWindow();
        ACETPDExt.updateProcucertab();
        ACETPDExt.PopulateGroupNotFoundDefaults(); 
        ACETPDExt.ContactType = 'Primary Benefits Administrator';
        ACETPDExt.OriginatorName = '37E9769CORG1';
        ACETPDExt.ContactType = 'abc';
        ACETPDExt.OriginatorName = '123as3';
        ACETPDExt.ContactType = 'Primary Benefits Administrator';        
        
        ACETPDExt.getOriginatorNames();
        ACETEGPage.getParameters().put('fastTrack','True');
        ACETPDExt.updateProcucertab();
        String gnf =Apexpages.currentPage().getParameters().get('gnf');
        ACETPDExt.updateAlertValue();
        ACETPDExt.RedirectToRestrictedPage();

               Test.stopTest(); 
    }
    
    static testMethod void ACETViewEmployerGroupControllerTest3() 
    {
         Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        Test.startTest();
        
         ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '3797692017185927';
 
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        ACETPDExt.updateContactNameFieldExt();
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
        
        ACETPDExt.ContactType ='Primary Billing Administrator';
        ACETPDExt.OriginatorName = '37E9769CORG1';
        ACETPDExt.updateContactNameField();

        ACETPDExt.ContactType ='abc';
        ACETPDExt.OriginatorName = '37E9769CORG1';
        
        Test.stopTest(); 
    
    }
    
    static testMethod void ACETViewEmployerGroupControllerTest4() 
    {
         Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Fname';
        accountTest.LastName = '37E9769CORG1';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.Tax_ID__c = '123456';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Test.startTest();
         
         ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '12345678';
 
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
        ACETPDExt.ContactType ='Primary Benefits Administrator';
        ACETPDExt.OriginatorName = '37E9769CORG1';
        ACETPDExt.updateContactNameField();
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'thirdPartId';
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'abc';
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = 'test123456';
        ACETPDExt.updateContactNameField();
        
        ACETPDExt.updateContactType();
                
        
        ACETGetEmployerGroupAdapterJSON2Apex.Phone testObj1= new ACETGetEmployerGroupAdapterJSON2Apex.Phone();
        testObj1.phoneType = 'tests';
        testObj1.phoneTypeDescription = 'tests';
        testObj1.telephoneNumber = 'tests';
        testObj1.phoneExtension = 'tests';
        
        ACETGetEmployerGroupAdapterJSON2Apex.LineOfBusiness testObj2= new ACETGetEmployerGroupAdapterJSON2Apex.LineOfBusiness();
        testObj2.name = 'tests';
        testObj2.description = 'tests';
        
        ACETGetEmployerGroupAdapterJSON2Apex.GroupAddress testObj3= new ACETGetEmployerGroupAdapterJSON2Apex.GroupAddress();
        testObj3.addressTypeCode = 'tests';
        testObj3.addressTypeDescription = 'tests';
        testObj3.addressLine1 = 'tests';
        testObj3.addressLine2 = 'tests';
        testObj3.addressLine3 = 'tests';
        testObj3.addressCity = 'tests';
        testObj3.addressPostalCode = 'tests';
        testObj3.addressStateCode = 'tests';
        testObj3.addressCountryCode= 'tests';
        testObj3.addressCountryDescription = 'tests';
        testObj3.salesOfficeCode = 'tests';
        testObj3.salesOfficeDescription = 'tests';
        
        ACETGetEmployerGroupAdapterJSON2Apex.Email testObj4= new ACETGetEmployerGroupAdapterJSON2Apex.Email();
        testObj4.communicationTypeCode = 'test';
        
        ACETGetEmployerGroupAdapterJSON2Apex.Address testObj5= new ACETGetEmployerGroupAdapterJSON2Apex.Address();
        testObj5.addressTypeDescription = 'tests';
        testObj5.addressCountryCode= 'tests';
        testObj5.addressCountryDescription = 'tests';
        
        
        ACETGetEmployerGroupAdapterJSON2Apex.CustomerPurchase testObj6= new ACETGetEmployerGroupAdapterJSON2Apex.CustomerPurchase();
        testObj6.memberGroupContractPlanOptionID = 'tests';
        testObj6.fundingArrangementCode = 'tests';
        
        ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount testObj7= new ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount();
        testObj7.planBillingGroupNumber = 'tests';
        
        ACETGetEmployerGroupAdapterJSON2Apex.BillingSchedule testObj8= new ACETGetEmployerGroupAdapterJSON2Apex.BillingSchedule();
        testObj8.ratingMethodology = 'tests';
        testObj8.contractTypeCode = 'tests';
        testObj8.contractTypeDescription = 'tests';
        testObj8.genderLimit = 'tests';
        
        Test.stopTest(); 
    
    }
    static testMethod void ACETViewEmployerGroupControllerTest5() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =  TestDataFactory.createInteraction();
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','thirdPartId');
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');
        test.setCurrentPage(ACETEGPage);
        
        
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
         Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '1278571';
            alert1.Type__c = 'Group';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
        
       id[] fixedSearchResults = new id[1];
       fixedSearchResults[0] = alert1.id;
       Test.setFixedSearchResults(fixedSearchResults); 
        
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        
        ACETPDExt.groupNumber = '12345678';
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        response.setBody(ACETTestDataUtility.getEmployerGroupDetailJson());
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
        system.debug('result ----->'+result );
        ACETPDExt.CallGroupDetailCWS();
        system.debug('groupDetails ----->'+ACETPDExt.groupDetails);
      
     
        ACETPDExt.updateProcucertab();
        ACETPDExt.getCallTopicOptions();     
        ACETPDExt.OriginatorName='UHG';
        ACETPDExt.createInteraction();
        ACETPDExt.getOriginatorNames();
        ACETPDExt.OriginatorNames = new List<SelectOption>();
        ACETPDExt.updateTPContactName();
        
           ACETPDExt.ContactType = 'Primary Billing Contact';
        ACETPDExt.OriginatorName = '37E9769CORG1';
        ACETPDExt.updateContactNameField();
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'thirdPartId';
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'abc';
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = 'test123456';
        ACETPDExt.updateContactNameField();
        
        ACETPDExt.updateContactType();
        
        ACETPDExt.OriginatorName = 'Contact Name';
        ACETPDExt.ContactType = 'Primary Benefits Administrator';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = 'Primary Billing Administrator';
        
        ACETPDExt.updateContactNameField();
        ACETPDExt.ContactType = 'Owner';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = '----None----';
        ACETPDExt.createUpdateContact();
        ACETEGPage.getParameters().put('selectedVal','Broker 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','Agent 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','UHG');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','----None----');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','ascv');
        
    
        ACETPDExt.getContactTypes();
        ACETEGPage.getParameters().put('InteractionId', null);
        ACETPDExt.createInteraction();
        ACETPDExt.contactHistoryWindow();
        ACETPDExt.CallWSOnProdHistoryClick();
                     
        Test.stopTest();        
    } 
  static testMethod void ACETViewEmployerGroupControllerTest6() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =TestDataFactory.createInteraction();
        ProviderTestInteraction.Originator_Type__c = 'Producer';
        update ProviderTestInteraction;
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','thirdPartId');
	ACETEGPage.getParameters().put('tpChoosenName','Testing');
	ACETEGPage.getParameters().put('prodChoosenName','Testing');
        ACETEGPage.getParameters().put('selThirdPartyRecId','123456789');
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');
        test.setCurrentPage(ACETEGPage);
        
        
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
         Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '1278571';
            alert1.Type__c = 'Group';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
        
       id[] fixedSearchResults = new id[1];
       fixedSearchResults[0] = alert1.id;
       Test.setFixedSearchResults(fixedSearchResults); 
        
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.TooltipText = 'test';
       ACETPDExt.Zip = 'test';
        ACETPDExt.PhoneNumber = 'test';
        ACETPDExt.State = 'test';
       ACETPDExt.EmployerName = 'test';
       ACETPDExt.isGroupALertModal = true;
        ACETPDExt.groupNumber = '1068479';
        ACETPDExt.groupDetails.groupExternalContactInfoList = new List<ACETGroupDetail.groupContactInfo>();
        ACETGroupDetail.groupContactInfo testContact = new ACETGroupDetail.groupContactInfo();
        testContact.firstName = 'test';
        testContact.lastName = 'testing';
        testContact.AddrLine1 = 'Test';
        testContact.AddrLine2 = 'Test';
        testContact.city = 'Test';
        testContact.state = 'Test';
        testContact.zip = 'Test';
        testContact.country = 'Test';
        testContact.effeDate= '1/1/2018';
        ACETGroupDetail.contactPhoneInfo cpi = new ACETGroupDetail.contactPhoneInfo();
        cpi.phonePrimaryIndicator= 'test';
        cpi.internationalIndicator= 'testing';
        
        ACETPDExt.groupDetails.groupExternalContactInfoList.add(testContact);
        ACETPDExt.producerTypeBRestuls = new List<ACETProducerSearchResult>();
        ACETPDExt.ProducerSearchResults= new List<ACETProducerSearchResult>();
        ACETPDExt.ProducerSearchResultsFuture= new List<ACETProducerSearchResult>();
        ACETPDExt.ProducerSearchHistResults= new List<ACETProducerSearchResult>();
        ACETProducerSearchResult res1 = new ACETProducerSearchResult();
        res1.CompanyName = 'UHG';
        ACETPDExt.producerTypeBRestuls.add(res1);
        ACETPDExt.producerTypeIRestuls = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult res2 = new ACETProducerSearchResult();
        res2.FirstName = 'John';
        res2.LastName = 'Smith';
        ACETPDExt.producerTypeIRestuls.add(res2);
        ACETPDExt.ProducerSearchResults.add(res2);
        ACETPDExt.ProducerSearchResultsFuture.add(res2);
        ACETPDExt.ProducerSearchHistResults.add(res2);
        ACETGroupDetail grpDet = new ACETGroupDetail();
        grpDet.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        grpDet.genGroupInfo.groupName = 'UHG';
        ACETPDExt.groupDetails = grpDet;
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        GetEmpGrpRes = GetDummyResp.Body.toString();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
        system.debug('result ----->'+result );
        ACETPDExt.CallGroupDetailCWS();
        ACETPDExt.groupnotfound = True;
        system.debug('groupDetails ----->'+ACETPDExt.groupDetails);
       
        ACETPDExt.updateProcucertab();
        ACETPDExt.getCallTopicOptions();
        ACETPDExt.OriginatorName='UHG';
        ACETPDExt.createInteraction();
        ACETPDExt.getOriginatorNames();
        ACETPDExt.OriginatorNames = new List<SelectOption>();
        ACETPDExt.updateTPContactName();
            ACETPDExt.ContactType = 'SBC Contact';
        ACETPDExt.OriginatorName = '37E9769CORG1';
        ACETPDExt.updateContactNameField();
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'thirdPartId';
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'abc';
        ACETPDExt.groupDetails.genGroupInfo.groupId = '1068479';
        ACETPDExt.updateContactNameField();
        
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'Contact Name';
        ACETPDExt.ContactType = 'Primary Benefits Administrator';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = 'Primary Billing Administrator';
        ACETPDExt.createUpdateContact();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Fname';
        accountTest.LastName = '37E9769CORG1';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.Tax_ID__c = '123456';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        ACETPDExt.ContactType = 'Primary Billing Contact';
         ACETPDExt.contactType='Primary';
        
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = 'SBC Contact' ;
        ACETPDExt.createUpdateContact(); 
        ACETPDExt.ContactType = 'Owner';
        ACETPDExt.createUpdateContact();
        ACETPDExt.ContactType = '----None----';
        ACETPDExt.createUpdateContact();
        ACETEGPage.getParameters().put('selectedVal','Broker 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','Agent 1');
        
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','John Smith');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','UHG');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','----None----');
        ACETPDExt.updateContactType();
        ACETEGPage.getParameters().put('selectedVal','ascv');
        
        ACETPDExt.getContactTypes();
        ACETEGPage.getParameters().put('InteractionId', null);
        ACETPDExt.createInteraction();
        ACETPDExt.contactHistoryWindow();
        ACETPDExt.CallWSOnProdHistoryClick();
        ACETPDExt.callProducerWS();
        ACETPDExt.ContactName = 'abcd';
        ACETPDExt.createUpdateContact();
        ACETPDExt.createUpdateAccountContact(new contact(),new account(),'abc'); 
        List<ACETProducerSearchResult> producList = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult = new ACETProducerSearchResult();
        prodSResult.producerType = 'B';
        prodSResult.CompanyName = 'Testing Co';
        prodSResult.hasName = false;
        producList.add(prodSResult);
        prodSResult = new ACETProducerSearchResult();
        prodSResult.producerType = 'I';
        prodSResult.FirstName = 'John';
        prodSResult.LastName = 'Smith';
        prodSResult.hasName = true;
        producList.add(prodSResult);
        ACETPDExt.producerSerachResultsSplit(producList,'Y');     
        ACETPDExt.callProducerWS();
        ACETPDExt.createUpdateContact();
        
        List<ACETProducerSearchResult> producList1 = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult1 = new ACETProducerSearchResult();
        prodSResult1.producerRoleType = 'A';
        prodSResult1.producerRole = 'W';
        prodSResult1.producerMemberGrpEndDate = '12/31/2017';
        producList1.add(prodSResult1);
        
        prodSResult1.producerRoleType = 'A';
        prodSResult1.producerRole = 'P';
        prodSResult1.producerMemberGrpEndDate = '12/31/2017';
        producList1.add(prodSResult1);
        ACETPDExt.producerSerachResultsSplit(producList1,'Y');  
         
        List<ACETProducerSearchResult> producList2 = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult2a = new ACETProducerSearchResult();
        prodSResult2a.producerRoleType = 'O';
        prodSResult2a.producerRole = 'W';
        prodSResult2a.producerMemberGrpEndDate = '12/12/2017';
        producList2.add(prodSResult2a);
        ACETProducerSearchResult prodSResult2b = new ACETProducerSearchResult();
        prodSResult2b.producerRoleType = 'A';
        prodSResult2b.producerRole = 'P';
        prodSResult2b.producerMemberGrpEndDate = '12/13/2017';
        producList2.add(prodSResult2b);
        ACETProducerSearchResult prodSResult2c = new ACETProducerSearchResult();
        prodSResult2c.producerRoleType = 'A';
        prodSResult2c.producerRole = 'P';
        prodSResult2c.producerMemberGrpEndDate = '12/14/2017';
        producList2.add(prodSResult2c);
        ACETProducerSearchResult prodSResult2d = new ACETProducerSearchResult();
        prodSResult2d.producerRoleType = 'A';
        prodSResult2d.producerRole = 'W';
        prodSResult2d.producerMemberGrpEndDate = '12/15/2017';
        producList2.add(prodSResult2d);
        ACETProducerSearchResult prodSResult2e = new ACETProducerSearchResult();
        prodSResult2e.producerRoleType = 'O';
        prodSResult2e.producerRole = 'W';
        prodSResult2e.producerMemberGrpEndDate = '12/16/2017';
        producList2.add(prodSResult2e);
        ACETProducerSearchResult prodSResult2f = new ACETProducerSearchResult();
        prodSResult2f.producerRoleType = 'O';
        prodSResult2f.producerRole = 'P';
        prodSResult2f.producerMemberGrpEndDate = '12/17/2017';
        producList2.add(prodSResult2f);
        ACETProducerSearchResult prodSResult2g = new ACETProducerSearchResult();
        prodSResult2g.producerRoleType = 'P';
        prodSResult2g.producerRole = 'W';
        prodSResult2g.producerMemberGrpEndDate = '12/18/2017';
        producList2.add(prodSResult2g);
        ACETProducerSearchResult prodSResult2h = new ACETProducerSearchResult();
        prodSResult2h.producerRoleType = 'P';
        prodSResult2h.producerRole = 'P';
        prodSResult2h.producerMemberGrpEndDate = '12/19/2017';
        producList2.add(prodSResult2h);
        ACETPDExt.producerSerachResultsSplit(producList2,'Y'); 
        
        List<ACETProducerSearchResult> producList3 = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult3a = new ACETProducerSearchResult();
        prodSResult3a.producerRoleType = 'P';
        prodSResult3a.producerRole = 'W';
        prodSResult3a.producerMemberGrpEndDate = '12/20/2017';
        producList3.add(prodSResult3a);
        ACETProducerSearchResult prodSResult3b = new ACETProducerSearchResult();
        prodSResult3b.producerRoleType = 'A';
        prodSResult3b.producerRole = 'W';
        prodSResult3b.producerMemberGrpEndDate = '12/21/2017';
        producList3.add(prodSResult3b);
        ACETPDExt.producerSerachResultsSplit(producList3,'Y');
        
        List<ACETProducerSearchResult> producList4 = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult4a = new ACETProducerSearchResult();
        prodSResult4a.producerRoleType = 'O';
        prodSResult4a.producerMemberGrpEndDate = '12/22/2017';
        producList4.add(prodSResult4a);
        ACETProducerSearchResult prodSResult4b = new ACETProducerSearchResult();
        prodSResult4b.producerRoleType = 'P';
        prodSResult4b.producerRole = 'W';
        prodSResult4b.producerMemberGrpEndDate = '12/23/2017';
        producList4.add(prodSResult4b);
        ACETPDExt.producerSerachResultsSplit(producList4,'Y'); 
        List<ACETProducerSearchResult> producList5 = new List<ACETProducerSearchResult>();
        ACETProducerSearchResult prodSResult5a = new ACETProducerSearchResult();
        prodSResult5a.producerRoleType = 'O';
        prodSResult5a.producerRole = 'W';
        producList5.add(prodSResult5a);
        ACETProducerSearchResult prodSResult5b = new ACETProducerSearchResult();
        prodSResult5b.producerRoleType = 'A';
        prodSResult5b.producerRole = 'P';
        producList5.add(prodSResult5b);
        ACETProducerSearchResult prodSResult5c = new ACETProducerSearchResult();
        prodSResult5c.producerRoleType = 'A';
        prodSResult5c.producerRole = 'P';
        producList5.add(prodSResult5c);
        ACETProducerSearchResult prodSResult5d = new ACETProducerSearchResult();
        prodSResult5d.producerRoleType = 'A';
        prodSResult5d.producerRole = 'W';
        prodSResult5d.producerCRID = '32564';
        producList5.add(prodSResult5d);
        ACETProducerSearchResult prodSResult5e = new ACETProducerSearchResult();
        prodSResult5e.producerRoleType = 'O';
        prodSResult5e.producerRole = 'W';
        producList5.add(prodSResult5e);
        ACETProducerSearchResult prodSResult5f = new ACETProducerSearchResult();
        prodSResult5f.producerRoleType = 'O';
        prodSResult5f.producerRole = 'P';
        producList5.add(prodSResult5f);
        ACETProducerSearchResult prodSResult5g = new ACETProducerSearchResult();
        prodSResult5g.producerRoleType = 'P';
        prodSResult5g.producerRole = 'W';
        prodSResult5g.producerCRID = '56432';
        producList5.add(prodSResult5g);
        ACETProducerSearchResult prodSResult5h = new ACETProducerSearchResult();
        prodSResult5h.producerRoleType = 'P';
        prodSResult5h.producerRole = 'P';
        prodSResult5h.producerCRID = '25643';
        producList5.add(prodSResult5h);
        ACETPDExt.producerSerachResultsSplit(producList5,'Y');
        
        ACETPDExt.updateContactNameFieldProd();
        ACETPDExt.addProdToOriginator();
        ACETPDExt.addTPtoOriginator();
        ACETPDExt.producerAddInfoGeneralSelected='';
        ACETPDExt.producerAddInfoAgentSelected='';
        ACETPDExt.producerAddInfoServiceSelected='';
    	ACETPDExt.producerAddInfoHistGeneralSelected ='';
    	ACETPDExt.producerAddInfoHistAgentSelected ='';
    	ACETPDExt.producerAddInfoHistServiceSelected = '';
    	ACETPDExt.selectedProducer ='';
    	ACETPDExt.producerMaskedSSn ='';
        ACETPDExt.extContactSelected='';
        Test.stopTest();  
      
    } 
    static testMethod void ACETViewEmployerGroupControllerTest7() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =  TestDataFactory.createInteraction();
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','thirdPartId');
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');
        ACETEGPage.getParameters().put('gnf', '1');
        ACETEGPage.getParameters().put('ContactName', 'test');
        test.setCurrentPage(ACETEGPage);
        
        
//MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
         Alert__c alert1 = new Alert__c();
            alert1.ID_Number__c = '1278571';
            alert1.Type__c = 'Group';
             Date today1 = date.today();
            alert1.Effective_Date__c = today1; 
            Date endate1 = date.today()+5;          
            alert1.End_Date__c = endate1;
            alert1.Alert_Title__c = 'Testing';
            alert1.Alert_Comments__c = 'Testing components';
            insert alert1;
        
       id[] fixedSearchResults = new id[1];
       fixedSearchResults[0] = alert1.id;
       Test.setFixedSearchResults(fixedSearchResults); 
       
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '1068479';   
        //ACETPDExt.CallGroupDetailCWS();   
        ACETPDExt.updateProcucertab();
        ACETPDExt.getCallTopicOptions();     
        ACETPDExt.OriginatorName='UHG';
        ACETPDExt.createInteraction();
        ACETPDExt.getOriginatorNames();
        ACETPDExt.OriginatorNames = new List<SelectOption>();
        ACETPDExt.updateTPContactName();
        
        ACETPDExt.ContactType = 'Primary Billing Contact';
        ACETPDExt.OriginatorName = 'INGERSOLL AUTO GROUP INC.';
        ACETPDExt.updateContactNameField();
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'thirdPartId';
        ACETPDExt.updateContactType();
        ACETPDExt.OriginatorName = 'abc';
        ACETPDExt.updateContactNameField();

        ACETPDExt.updateContactType();
        
        ACETPDExt.OriginatorName = 'Contact Name';
        ACETPDExt.ContactType = 'Primary Benefits Administrator';
        ACETPDExt.createandUpdateProdContact('test','test','test','test');
        //ACETPDExt.updatePolicyContract();             
        Test.stopTest();        
    } 
    
    static testMethod void ACETViewEmployerGroupControllerTest8(){
          ACETGroupDetail acetGrp = new ACETGroupDetail();
          acetGrp.groupName='test';
          acetGrp.groupId='12345';
          acetGrp.groupTaxId='12345678';
          acetGrp.groupRenewalDate='1/1/2018';
          acetGrp.groupAddress='test';
          acetGrp.groupCity='test';
          acetGrp.groupState='test';
          acetGrp.groupZip='test';
          acetGrp.groupStatus='test';
          ACETGroupDetail.groupGeneralInfo genrinfo = new ACETGroupDetail.groupGeneralInfo();
          genrinfo.insured='test';
          genrinfo.onshoreRestriction='test';
          genrinfo.effectiveEndDate ='1/1/2020';
          genrinfo.terminationDate='1/1/2018';
          genrinfo.terminationReason='testReason';
          genrinfo.classesIncluded='test';
          genrinfo.fundingArrangement='test';
          genrinfo.exchangeType ='test';
          genrinfo.enrollmentMethod='test';
          acetGrp.genGroupInfo = genrinfo;
          ACETGroupDetail.addGroupInfo  grpAdditnal =new  ACETGroupDetail.addGroupInfo();
          grpAdditnal.industryClassCodeType='test';
          grpAdditnal.industryClassCode='test';
          grpAdditnal.medicareEstimation='test';
          grpAdditnal.medicareCrossoverAvailable='test';
          grpAdditnal.medicareCrossoverElected='test';
          grpAdditnal.timelyFilingID='test';
          grpAdditnal.industryClassCodeDesc='test';
          
          acetGrp.additionalGroupInfo =grpAdditnal;
          List<ACETGroupDetail.employeeCountInfo> emplcontlist = new List<ACETGroupDetail.employeeCountInfo>();
          ACETGroupDetail.employeeCountInfo grpEmpcount =new ACETGroupDetail.employeeCountInfo();
          grpEmpcount.employeeAtne ='test';
          grpEmpcount.efectiveFrom='1/1/2018';
          grpEmpcount.effectiveThrough='12/31/2018';
          grpEmpcount.fullTime='test';
          grpEmpcount.partTime='test';
          grpEmpcount.unionEligible='test';
          grpEmpcount.totalEligible='test';
          grpEmpcount.lastUpdate='test'; 
          emplcontlist.add(grpEmpcount);
          acetGrp.groupEmployeeCountInfoList=emplcontlist;
          List<ACETGroupDetail.PolicyContractStatus> polcycontstatlst = new List<ACETGroupDetail.PolicyContractStatus>();
          ACETGroupDetail.PolicyContractStatus polcyContStat = new ACETGroupDetail.PolicyContractStatus();
          polcyContStat.status ='test';
          polcyContStat.effectiveDate='1/1/2018';
          polcyContStat.endDate='12/31/2018';
          polcyContStat.processedOn='2/1/2018';
          polcyContStat.processedBy='test';
          polcyContStat.reason='test';
          polcycontstatlst.add(polcyContStat);
          acetGrp.policyStatusList=polcycontstatlst;
          List<ACETGroupDetail.StatusDetails> polcynotestlst =new List<ACETGroupDetail.StatusDetails>();
          ACETGroupDetail.StatusDetails grpstat = new ACETGroupDetail.StatusDetails();
          grpstat.status='test';
          grpstat.effectDate='1/1/2018';
          grpstat.endDate='12/31/2018';
          grpstat.processedOn='2/1/2018';
          grpstat.processedBy='test';
          grpstat.reason='test';
          polcynotestlst.add(grpstat);
          acetGrp.groupStatusDetailsList=polcynotestlst;
          List<ACETGroupDetail.Notes> grpnoteslst = new List<ACETGroupDetail.Notes>();
          ACETGroupDetail.Notes grpnotes= new ACETGroupDetail.Notes();
          grpnotes.noteSubject ='test';
          grpnotes.noteType ='test';
          grpnotes.createdBy ='test';
          grpnotes.createdDate ='1/1/2018';
          grpnotes.contractId ='12345';
          grpnoteslst.add(grpnotes);
          acetGrp.groupNotes = grpnoteslst;
          acetGrp.accumulator ='test';
          acetGrp.PlanClass='test';
          acetGrp.Product='test';
          acetGrp.Gated='test';
          acetGrp.PCPRequired='test';
          acetGrp.PlanMettalicLevel='test';
          acetGrp.Network='test';
          acetGrp.Tier='test';
          acetGrp.policyNo='12345';
          acetGrp.planID='1234';
          acetGrp.effecDate='1/1/2018';
          acetGrp.endDate='12/1/2018';
          acetGrp.situsState='test';
          acetGrp.hsaAvailable='test';
          acetGrp.hsaElected='test';
          acetGrp.administeredBy='test';
          acetGrp.phone='test';
          
          
          
          List<ACETGroupDetail.CurveOut> CurveOutList = new List<ACETGroupDetail.CurveOut>();
        ACETGroupDetail.CurveOut curveOut = new ACETGroupDetail.CurveOut();
        curveOut.high = 'Yes';
        curveOut.low = 'No';
        CurveOutList.add(curveOut);
        acetGrp.curveOutList =  CurveOutList;
        
        List<ACETGroupDetail.Riders> l_grpRidersList = new List<ACETGroupDetail.Riders>();
        ACETGroupDetail.Riders l_grpRiders = new ACETGroupDetail.Riders();
        l_grpRiders.riderCode = '12345';
        l_grpRiders.description = 'Test Description';
        l_grpRiders.fromDate = '3/2/2016';
        l_grpRiders.thruDate = '3/2/2016';
        l_grpRidersList.add(l_grpRiders);
        
        List<ACETGroupDetail.CSPDetails> l_grpCSPDetailsList = new List<ACETGroupDetail.CSPDetails>();
        ACETGroupDetail.CSPDetails l_grpCSPDetails = new ACETGroupDetail.CSPDetails();
        l_grpCSPDetails.cspDetail = '12345';
        l_grpCSPDetails.conType = 'Test Type';
        l_grpCSPDetails.fdType = 'Test FD Type';
        l_grpCSPDetails.amount = '2345';
        l_grpCSPDetails.fromDate = '2/3/2016';
        l_grpCSPDetails.thruDate = '2/3/2016';
        l_grpCSPDetails.reason = 'Test Reason';
        l_grpCSPDetails.deactivated = 'Yes';
        l_grpCSPDetailsList.add(l_grpCSPDetails);
        
        List<ACETGroupDetail.contactType> l_grpcontactTypeList = new List<ACETGroupDetail.contactType>();
        ACETGroupDetail.contactType l_grpcontactType = new ACETGroupDetail.contactType();
        l_grpcontactType.contactType = 'Test Contact Type';
        l_grpcontactType.amount = '12345';
        l_grpcontactTypeList.add(l_grpcontactType);
        
        ACETGroupDetail.single singleType = new ACETGroupDetail.single();
        singleType.male = 'Y';
        singleType.female = 'N';
        
        ACETGroupDetail.parentwoChildren parentChild = new ACETGroupDetail.parentwoChildren();
        parentChild.male = 'Y';
        parentChild.female = 'N';
        
        ACETGroupDetail.couple coupleDetail = new ACETGroupDetail.couple();
        coupleDetail.male = 'Y';
        coupleDetail.female = 'N';
        
        ACETGroupDetail.family familyDetail = new ACETGroupDetail.family();
        familyDetail.male = 'Y';
        familyDetail.female = 'N';
        
        ACETGroupDetail.medicare medicareDetail = new ACETGroupDetail.medicare();
        medicareDetail.status= 'Y';
        
        List<ACETGroupDetail.ageBand> l_grpageBandList = new List<ACETGroupDetail.ageBand>();
        ACETGroupDetail.ageBand l_grpageBand = new ACETGroupDetail.ageBand();
        l_grpageBand.ageBand = 'Test Age Band';
        l_grpageBand.singleDetails = singleType;
        l_grpageBand.parentDetails = parentChild;
        l_grpageBand.coupleDetails = coupleDetail;
        l_grpageBand.familyDetails = familyDetail;
        l_grpageBand.medicareDetails = medicareDetail;
        l_grpageBandList.add(l_grpageBand);
        
        List<ACETGroupDetail.purchasedBenefits> l_grppurchasedList = new List<ACETGroupDetail.purchasedBenefits>();
        ACETGroupDetail.purchasedBenefits l_grppurchasedBenefits = new ACETGroupDetail.purchasedBenefits();
        l_grppurchasedBenefits.product = 'Test Product';
        l_grppurchasedBenefits.benefit = 'Test Benefit';
        l_grppurchasedBenefits.planMetalicLevel = 'Test PML';
        l_grppurchasedBenefits.network = 'Test Network';
        l_grppurchasedBenefits.tier = 'Test Tier';
        l_grppurchasedBenefits.CarveOutDetails = curveOut;
        l_grppurchasedBenefits.ridersList = l_grpRidersList;
        l_grppurchasedBenefits.CSPDetailsList = l_grpCSPDetailsList;
        l_grppurchasedBenefits.contactTypeList = l_grpcontactTypeList;
        l_grppurchasedBenefits.ageBandList = l_grpageBandList;
        l_grppurchasedList.add(l_grppurchasedBenefits);
        
        acetGrp.purchasedBenefitsList = l_grppurchasedList;
         
    } 
   static testMethod void ACETViewEmployerGroupControllerTest9() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read'); 
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',01);
        mapOnshoreVerbgs.put('Claim Transactions',02);
        mapOnshoreVerbgs.put('All Services Onshore',08);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =TestDataFactory.createInteraction();
        ProviderTestInteraction.Originator_Type__c = 'Producer';
        update ProviderTestInteraction;
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        //ACETEGPage.getParameters().put('selectedVal','thirdPartId');
        //ACETEGPage.getParameters().put('contactName', 'testing');
        
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"gnf":1,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');

        test.setCurrentPage(ACETEGPage);
       
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmployerResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('------test9---' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
          
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
         
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '4061351';
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = '4061351';
        ACETPDExt.groupDetails.genGroupInfo.groupName = 'Best Buy';
        ACETPDExt.OnshoreRestrictionCode='All Services Offshore';
        ACETPDExt.polContractId = '612766';
        ACETPDExt.polContractEffDate = '1/1/2018';
        ACETPDExt.polContractEndDate = '12/31/2017';
        ACETPDExt.polStatus = 'Inactive';
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);
        system.debug('result ----->'+result );
        //ACETPDExt.CallGroupDetailCWS();
        //system.debug('groupDetails --test9--->'+ACETPDExt.groupDetails);
       
        ACETPDExt.updatePolicyContract(); 

        ACETPDExt.polContractId = '602613';
        ACETPDExt.polContractEffDate = '1/1/2018';
        ACETPDExt.polContractEndDate = '12/31/2018';
        ACETPDExt.polStatus = 'Active';
        ACETPDExt.updatePolicyContract(); 
        
        ACETPDExt.polContractId = '602614';
        ACETPDExt.polContractEffDate = '1/1/2099';
        ACETPDExt.polContractEndDate = '12/31/2099';
        ACETPDExt.polStatus = 'Active';
        ACETPDExt.updatePolicyContract(); 
        Test.stopTest();  
      
    }  
    static testMethod void ACETViewEmployerGroupControllerTest10() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read'); 
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',01);
        mapOnshoreVerbgs.put('Claim Transactions',02);
        mapOnshoreVerbgs.put('All Services Onshore',08);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =TestDataFactory.createInteraction();
        ProviderTestInteraction.Originator_Type__c = 'Producer';
        update ProviderTestInteraction;
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');
        ACETEGPage.getParameters().put('extContName', '');            
        ACETEGPage.getParameters().put('selectedVal','Best Buy');
        ACETEGPage.getParameters().put('RelationshipType','Benefit Administrator');
       // ACETEGPage.getParameters().put('contactName', 'testing');
        
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"gnf":1,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');

        test.setCurrentPage(ACETEGPage);
       
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmployerResponseMultiple'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('------test910---' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
          
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
         
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '4061351';
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = '4061351';
        ACETPDExt.groupDetails.genGroupInfo.groupName = 'Best Buy';
        ACETPDExt.OnshoreRestrictionCode='All Services Offshore';
        ACETPDExt.OnshoreRestrictionText='All Services Offshore';
        ACETPDExt.OnshoreRestrictionTooltip='All Services Offshore';
        ACETPDExt.polContractId = '612766';
        ACETPDExt.polContractEffDate = '1/1/2018';
        ACETPDExt.polContractEndDate = '12/31/2017';
        ACETPDExt.polStatus = 'Inactive';
        ACETPDExt.isGroupHistory = true;
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);      
        ACETPDExt.updatePolicyContract(); 

        ACETPDExt.polContractId = '602613';
        ACETPDExt.polContractEffDate = '1/1/2018';
        ACETPDExt.polContractEndDate = '12/31/2018';
        ACETPDExt.polStatus = 'Active';
        ACETPDExt.updatePolicyContract(); 

        ACETPDExt.polContractId = '602614';
        ACETPDExt.polContractEffDate = '1/1/2099';
        ACETPDExt.polContractEndDate = '12/31/2099';
        ACETPDExt.polStatus = 'Active';
        ACETPDExt.updatePolicyContract(); 
        ACETPDExt.selectedValue='Best Buy';

        ACETPDExt.updateContactType();
        ACETPDExt.updateContactNameField();
        ACETPDExt.updateContactNameFieldExt();
        Test.stopTest();  
      
    }
    static testMethod void ACETViewEmployerGroupControllerTest11ExternalContacts() 
    {
        
        ACETViewEmployerGroupControllerTest.failureScenario = true;
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read'); 
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',01);
        mapOnshoreVerbgs.put('Claim Transactions',02);
        mapOnshoreVerbgs.put('All Services Onshore',08);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =TestDataFactory.createInteraction();
        ProviderTestInteraction.Originator_Type__c = 'Producer';
        update ProviderTestInteraction;
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','Best Buy');
        ACETEGPage.getParameters().put('extContName', 'Jennifer Hargrave');
        ACETEGPage.getParameters().put('RelationshipType','Additional Contact');
       // ACETEGPage.getParameters().put('contactName', 'testing');
        
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"gnf":1,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');

        test.setCurrentPage(ACETEGPage);
       
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmployerResponseMultiple'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('------test910---' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
          
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
         
        ACETViewEmployerGroupController  ACETPDExt = new ACETViewEmployerGroupController();
        ACETPDExt.groupNumber = '4061351';
        ACETPDExt.groupDetails.genGroupInfo = new ACETGroupDetail.groupGeneralInfo();
        ACETPDExt.groupDetails.genGroupInfo.groupId = '4061351';
        ACETPDExt.groupDetails.genGroupInfo.groupName = 'Best Buy';
        ACETPDExt.OnshoreRestrictionCode='All Services Offshore';
        ACETPDExt.OnshoreRestrictionText='All Services Offshore';
        ACETPDExt.OnshoreRestrictionTooltip='All Services Offshore';
        ACETPDExt.polContractId = '612766';
        ACETPDExt.polContractEffDate = '1/1/2018';
        ACETPDExt.polContractEndDate = '12/31/2017';
        ACETPDExt.polStatus = 'Inactive';
        ACETPDExt.isGroupHistory = true;
        Continuation conti = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.debug('--------->'+new List<String> (requests.keySet()).get(0) +'-----'+requests);
        HttpResponse response = new HttpResponse();
        response.setBody(GetEmpGrpRes);
        response.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests.keySet()).get(0), response);
        
        Object result = Test.invokeContinuationMethod(ACETPDExt, conti);      
        ACETPDExt.updatePolicyContract(); 

        ACETPDExt.polContractId = '602613';
        ACETPDExt.polContractEffDate = '1/1/2018';
        ACETPDExt.polContractEndDate = '12/31/2018';
        ACETPDExt.polStatus = 'Active';
        ACETPDExt.updatePolicyContract(); 

        ACETPDExt.polContractId = '602614';
        ACETPDExt.polContractEffDate = '1/1/2099';
        ACETPDExt.polContractEndDate = '12/31/2099';
        ACETPDExt.polStatus = 'Active';
        ACETPDExt.updatePolicyContract(); 
        ACETPDExt.selectedValue='Best Buy';

        ACETPDExt.updateContactType();
        ACETPDExt.updateContactNameField();
        ACETPDExt.updateContactNameFieldExt();
        ProviderTestInteraction.Originator_Type__c = 'Group';
        Continuation conti2 = (Continuation)ACETPDExt.CallGroupDetailCWS();
        Map<String, HttpRequest> requests2 = conti2.getRequests();
        HttpResponse response2 = new HttpResponse();
        response2.setBody(GetEmpGrpRes);
        response2.setStatusCode(200);
        Test.setContinuationResponse(new List<String> (requests2.keySet()).get(0), response2);
        Object result2 = Test.invokeContinuationMethod(ACETPDExt, conti2); 
        ACETPDExt.getInserteventlog();
        ACETPDExt.updategroupaffliations();
        Test.stopTest();  
      
    }
}