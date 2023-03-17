@isTest(SeeAllData=false)
private class ACETProviderLookUpDetailControllerTest{
    
    static testMethod void ACETProviderLookUpDetailControllerTestMethod1() 
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
        mapISLWSConfigs.put('dev_SearchMedProvAgreementsEndpoint', 'ISLStageFindAgreementEndpoint');    
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_SearchMedicalProvidersEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/search');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/bravo/eisl/clinical/medicalhealthservicecaseauthorizations/v1.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary';     
        Test.startTest();//
        PageReference ACETPDPage = Page.ACETProviderLookUpDetails;
        String IntId = InteractionId.Id;
        ACETPDPage.getParameters().put('Id', IntId);
        ACETPDPage.getParameters().put('additionalInfo', 'PolicyNumber');
        
       /* Account acc = ACETTestDataUtility.createAccount('testName');
        insert acc;
        
        Contact con = ACETTestDataUtility.createContact(acc.id, 'John', 'Miller');            
        insert con;*/
        
       RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        ACETPDPage.getParameters().put('CheckNumber', '1123');
        ACETPDPage.getParameters().put('SeriesDesignator ', 'Test');             
        ACETPDPage.getParameters().put('contactId', con.Id);   
        ACETPDPage.getParameters().put('strType', 'Inactive');         
        ACETProviderUtility.GetContactByID(con.Id);    
        ACETPDPage.getParameters().put('providerType', 'Physician');               
        
        con.LastName = 'Doe';
        con.FirstName = 'John';
        con.EID__c = '123';
        Apexpages.StandardController ACETPDStdCtrl1 = new Apexpages.standardController(InteractionId);
      //  ACETProviderDetailController pd = new ACETProviderDetailController (ACETPDStdCtrl1);
        
        ACETProviderUtility.GetInteractionByID(InteractionId.Id);
        Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
        
       // ACETProviderLookUpDetailController ACETPDExt2 = new ACETProviderLookUpDetailController();
    //    List<SelectOption> radioVals = ACETPDExt2.radioValues;
    //    ACETPDExt2.toggleShowCoverages();     
    //    ACETPDExt2.providerContractResult('Active');  
    //    ACETPDExt2.optSelected = 'Active';
    //    ACETPDExt2.providerType = 'Physician';
            
        Test.stopTest();     
    }  
 /**   static testMethod void ACETProviderLookUpDetailControllerTestMethod2() 
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
        mapISLWSConfigs.put('dev_SearchMedProvAgreementsEndpoint', 'ISLStageFindAgreementEndpoint');    
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_SearchMedicalProvidersEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/search');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/bravo/eisl/clinical/medicalhealthservicecaseauthorizations/v1.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary'; 
        AdditionalInfo.MemberId = '12345678901';    
        Test.startTest();//
        PageReference ACETPDPage = Page.ACETProviderLookUpDetails;
        String IntId = InteractionId.Id;
        ACETPDPage.getParameters().put('Id', IntId);
        ACETPDPage.getParameters().put('additionalInfo', json.serialize(AdditionalInfo));
        
        Account acc = ACETTestDataUtility.createAccount('testName');
        insert acc;
        
        Contact con = ACETTestDataUtility.createContact(acc.id, 'John', 'Miller');            
        insert con;
        
        ACETPDPage.getParameters().put('CheckNumber', '1123');
        ACETPDPage.getParameters().put('SeriesDesignator ', 'Test');             
        ACETPDPage.getParameters().put('contactId', con.Id); 
        ACETPDPage.getParameters().put('strType', 'Active');
        ACETPDPage.getParameters().put('providerType', 'Facility');         
        ACETProviderUtility.GetContactByID(con.Id);    
        con.LastName = 'Doe';
        con.FirstName = 'John';
        con.EID__c = '123';
        
        ACETProviderUtility.GetInteractionByID(InteractionId.Id);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseProvider = new MockHttpCalloutResponseGenerator.MockHttpResponse
            (200, 'OK', ACETTestDataUtility.getHCOCallableJSON());
        OILResponseProvider.TokenExpired = false; 
       /* contact c = new Contact();
        c.lastname = 'test';
        c.EID__c = '1235';
        c.Tax_ID__c = '@@healthcareProfessionalId@@12312';
        insert c;*/
        
     /**  RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact c = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
            
        Third_Party__c tp =new Third_Party__c();
        tp.Npi__c = '1231238888';
        insert tp;
        
        Interaction__c inta = new Interaction__c();
        inta.Originator__c = c.id;      
        inta.Third_Party__c= tp.id;
        inta.Originator_Type__c = 'Facility ';
        
        insert inta;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseProvider);        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
       ApexPages.currentPage().getParameters().put('interactionId',inta.id); 
        ApexPages.currentPage().getParameters().put('Id','00589997121');
      ApexPages.currentPage().getParameters().put('SRK','894666785'); //894666785
        
        Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
        
        ACETProviderLookUpDetailController ACETPDExt1 = new ACETProviderLookUpDetailController();        
       
        ACETPDExt1.returningFromServiceParam='ProviderLookup';
        List<SelectOption> radioVals = ACETPDExt1.radioValues;
       // ACETPDExt1.toggleShowCoverages();   
       // ACETPDExt1.providerContractResult('InActive');  
         ACETPDExt1.AdditionalInfo = AdditionalInfo;
        ACETPDExt1.optSelected = 'InActive';
        ACETPDExt1.strType = 'Active';  
        ACETPDExt1.netWork = 'Acsds';      
    ACETPDExt1.npis='Test';
        ACETPDExt1.istProviderContratResult=true;
        ACETPDExt1.isContractControl=true;
        ACETProviderLookupController.ProviderLookupResult providerResult= new ACETProviderLookupController.ProviderLookupResult();
        providerResult.providerType = 'Physician';
        List<ACETProviderLookupController.ProviderLookupResult> providerTypeList= new List<ACETProviderLookupController.ProviderLookupResult>{providerResult};
        ACETPDExt1.lstProviderLookup = providerTypeList;
        ACETPDExt1.CallFindAgreements();
        ACETProviderLookUpDetailController.ProviderDemographics prdddem = new ACETProviderLookUpDetailController.ProviderDemographics();
        prdddem.address = '';
        prdddem.addressType = '';
        prdddem.County = '';
        prdddem.email = '';
        prdddem.fax = '';
        prdddem.phone = '';
        
        ACETProviderLookUpDetailController.ACETactiveAffiliationsResult affres = new ACETProviderLookUpDetailController.ACETactiveAffiliationsResult();
        affres.affiliation = '';
        affres.providerID = '';
        affres.effective = '';
        
        ACETProviderLookUpDetailController.PraticeInformation pracinfo = new ACETProviderLookUpDetailController.PraticeInformation();
        pracinfo.extendedHours = '';
        pracinfo.network = '';
        pracinfo.speciality = '';
        pracinfo.status = '';
        pracinfo.panel = '';
        pracinfo.pratiseStartDate = '';
        pracinfo.patientAgeRange = ''; 
        
        ACETProviderLookUpDetailController.Credencialing credenc = new ACETProviderLookUpDetailController.Credencialing();
        credenc.affilation = '';
        credenc.providerRep = '';
        credenc.pti = null;
        credenc.uhn = '';
        credenc.qualification = '';
        
        ACETProviderLookUpDetailController.UnitedHealthPremium utdprm = new ACETProviderLookUpDetailController.UnitedHealthPremium();
        utdprm.cancel = '';
        utdprm.effective = '';
        utdprm.premiumSpeciality = '';
        utdprm.premiumDesigination = '';
        
        ACETProviderLookUpDetailController.CurrentPhysician crntphy = new ACETProviderLookUpDetailController.CurrentPhysician();
        crntphy.firstName = '';
        crntphy.isChecked = true;
        crntphy.lastName = '';
        crntphy.lastName = '';
        crntphy.pcpAssignmentType = '';
        crntphy.effDate = '';
        crntphy.EndDate = system.today();
        crntphy.EndDate = system.today();
        crntphy.pcptype = '';
    crntphy.pcpid='';
        ACETPDExt1.conObj = null;
        set < SelectOption > setdata = new set < SelectOption >();
        ACETPDExt1.networkOptions = setdata;
        
        
        
    ACETPDExt1.caseItem = null;
        ACETPDExt1.hpAdditionInfoStr = 'Active';
        ACETPDExt1.policyNumber = '23456788999';
        ACETPDExt1.memberId = '0987665443';
        ACETPDExt1.sourceOriginator = 'Active';
        ACETPDExt1.Dummy = 'A';
        ACETPDExt1.genInfoLanguage = 'Active';
        ACETPDExt1.proferredCoverageGUID = 'dddd';
        ACETPDExt1.providerID = '123445567777';
        ACETPDExt1.disableContractType = true;
        
        ACETPDExt1.callFindMedicalProvider();
        ACETPDExt1.CallFindAffiliations();
      ACETPDExt1.isErrorMessageAdded =false;
        ACETPDExt1.providerType = 'Physician';
    string lang;
        inta.Originator_Type__c = 'other';
        List<ACETProviderDetailController.NPI> npiList = new List<ACETProviderDetailController.NPI>();
        
        ACETProviderDetailController.NPI npi = new ACETProviderDetailController.NPI();
        npi.npiName = 'Testing';
        npiList.add(npi);
        
        
        //List<ACETProviderDetailController.providerLocationAffiliation> pcpOBGYNList = new List<ACETProviderDetailController.providerLocationAffiliation>();
        ACETProviderDetailController.ACETProviderDetail pd = new ACETProviderDetailController.ACETProviderDetail();
        list<string> lststr = new list<string>();
       
        ACETProviderDetailController.Language lan = new ACETProviderDetailController.Language();
        // ACETPDExt1.UpdatePCPOBGYN();
        //ACETPDExt1.CallWSOnPageLoadCallback1();
        ACETPDExt1.CallWSOnPageLoad1();
      ACETPDExt1.providerType = 'Facility';
        ACETPDExt1.callFindMedicalProvider();
    ACETPDExt1.providerType = 'Facility';
        ACETPDExt1.CallFindAffiliations();
        //  ACETPDExt1.CallWSOnPageLoadCallback1();
        ACETPDExt1.CallWSOnPageLoad1();
    ACETMemberDetail ACETmemdet = new ACETMemberDetail();
        ACETmemdet.PCPAssignments = null;
        ACETPDExt1.onPageLoad();
        ACETPDExt1.findMemberships();
        
    ACETProviderLookUpDetailController.NewPhysician newphys = new ACETProviderLookUpDetailController.NewPhysician();
        newphys.Address = '';
        newphys.Name = '';
        newphys.Network = '';
        newphys.newEffDate = '';
        newphys.pcpNewAssignmentType = '';
        newphys.PhoneNo = '';
        newphys.Speciality = '';
        
    ACETProviderLookUpDetailController.ContrcatInfo contrinfo = new ACETProviderLookUpDetailController.ContrcatInfo();
        contrinfo.acceptingNewPatient = '';
        contrinfo.cancel = '';
        contrinfo.Capitation = '';
        contrinfo.effective = '';
        contrinfo.feeRegion = '';
        contrinfo.networkID = '';
        contrinfo.networkName = '';
        contrinfo.networkStatus = '';
        contrinfo.product = '';
        contrinfo.AgreementStatusCode='';
        
        list <ACETProviderLookUpDetailController.ContrcatInfo> lstContrcat1 = new list <ACETProviderLookUpDetailController.ContrcatInfo>();
        lstContrcat1.add(contrinfo);  
        ACETPDExt1.lstContrcat = lstContrcat1;
        ACETMemberDetail mb = new ACETMemberDetail ();
        mb.FirstName = 'John';
        mb.LastName = 'Doe';
        mb.MiddleName = 'Yo';
        mb.effectiveDate = '1/1/2017';   
        
       
        
        ACETMemberDetail.PCPAssignment md = new ACETMemberDetail.PCPAssignment ();
        md.FirstName = 'Ruby';
        md.LastName = 'Kelly';
        //md.TaxId = '940123';
        //md.Specialty = 'OBGYN';                
        //md.EffectiveDate = '2/3/2017';       
        
    ACETGetHCOJSON2Apex.specialty spc= new ACETGetHCOJSON2Apex.specialty();
        List<ACETGetHCOJSON2Apex.specialty> spclist = new List<ACETGetHCOJSON2Apex.specialty>();
        spclist.add(spc);
        ACETPDExt1.lstspc=spclist;
        ACETProviderDetailController.ACETProviderSpeciality apspc = new ACETProviderDetailController.ACETProviderSpeciality();
        List<ACETProviderDetailController.ACETProviderSpeciality> apspclst = new  list<ACETProviderDetailController.ACETProviderSpeciality>();
        apspclst.add(apspc);
        ACETPDExt1.specialityLst=apspclst;
        ACETGetHCOJSON2Apex.tpsm acgt = new ACETGetHCOJSON2Apex.tpsm();
        acgt.statusCode= 'A';
        acgt.statusEffectiveDate= '0001-01-01';
        acgt.statusCancelDate='0001-01-01';
        Test.stopTest();     **/
  /**  } **/
   static testMethod void ACETProviderLookUpDetailControllerTestMethod3() {   
    Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
   /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
       
       RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
                Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];

        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
      //  Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
    ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary'; 
    Test.startTest();
    PageReference ACETPDPage = Page.ACETProviderLookUpDetails;
        String IntId = InteractionId.Id;
        ACETPDPage.getParameters().put('Id', IntId);
        //ACETPDPage.getParameters().put('additionalInfo', 'PolicyNumber');
        ACETPDPage.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
    ApexPages.currentPage().getParameters().put('interactionId',InteractionId.id); 
        ApexPages.currentPage().getParameters().put('Id','88358551100');
        ApexPages.currentPage().getParameters().put('SRK','894666785'); //894666785
    Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
    ACETPDPage.getParameters().put('CheckNumber', '1123');
        ACETPDPage.getParameters().put('SeriesDesignator ', 'Test');             
        ACETPDPage.getParameters().put('contactId', oContact.Id); 
        ACETPDPage.getParameters().put('strType', 'Active');
        ACETPDPage.getParameters().put('providerType', 'Physician'); 
        //Test.setCurrentPage(ACETPDPage);
        ACETProviderLookUpDetailController ACETPDExt1 = new ACETProviderLookUpDetailController(); 
        ACETPDExt1.additionalInfo = AdditionalInfo;
        ACETPDExt1.providerType = 'Facility';
        ACETMemberDetail ACETmemdet = new ACETMemberDetail();
        ACETMemberDetail.PCPAssignment PCPAssignment = new  ACETMemberDetail.PCPAssignment();
        PCPAssignment.FirstName = 'Test FirstName';
        PCPAssignment.LastName = 'Test LastName';
        PCPAssignment.pcpAssignmentType = 'Type';
        PCPAssignment.isChecked= true;
        PCPAssignment.isActive = true; 
        PCPAssignment.pcpAssignmentType = 'OBGYN';
        Date endDate = Date.today().addDays(3);
        PCPAssignment.endDate = AcetUtility.format(endDate);
        Date effectiveDate = Date.today().addDays(-3);
        PCPAssignment.effectiveDate = AcetUtility.format(effectiveDate); 
        List<ACETMemberDetail.PCPAssignment> PCPAssignmentList = new List<ACETMemberDetail.PCPAssignment>{PCPAssignment};
        ACETmemdet.PCPAssignments = PCPAssignmentList;
        ACETPDExt1.onPageLoad();
        ACETProviderLookUpDetailController.CurrentPhysician crntphy1 = new ACETProviderLookUpDetailController.CurrentPhysician();
        crntphy1.isChecked = true;
        crntphy1.effDate= '08/01/2018';
        List<ACETProviderLookUpDetailController.CurrentPhysician> currentPhysicainList = new list<ACETProviderLookUpDetailController.CurrentPhysician>{crntphy1};
        ACETPDExt1.lstCurrentPhysician = currentPhysicainList;    
        ACETPDExt1.UpdatePCPOBGYN();
        Continuation conti = (Continuation)ACETPDExt1.CallWSOnPageLoad1();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(1, requests.size());
        
    HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
      response.setBody(ACETTestDataUtility.getHCOCallableJSON());     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(ACETPDExt1, conti); 
        Test.stopTest();
    }
    static testMethod void ACETProviderLookUpDetailControllerTestMethod5() {
      Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
        
       RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        //Contact cont = TestDataFactory.createContact();
                Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];

        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary';     
        Test.startTest();
        
        
        PageReference ACETPDPage = Page.ACETProviderLookUpDetails;
        String IntId = InteractionId.Id;
        ACETPDPage.getParameters().put('Id', IntId);
        ACETPDPage.getParameters().put('additionalInfo', 'PolicyNumber');
        
        
        ApexPages.currentPage().getParameters().put('interactionId',InteractionId.id); 
        ApexPages.currentPage().getParameters().put('Id','88358551100');
        ApexPages.currentPage().getParameters().put('SRK',''); //894666785
        
        Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
                
        ACETPDPage.getParameters().put('CheckNumber', '1123');
        ACETPDPage.getParameters().put('SeriesDesignator ', 'Test');             
        ACETPDPage.getParameters().put('contactId', oContact.Id); 
        ACETPDPage.getParameters().put('strType', 'Active');
        ACETPDPage.getParameters().put('providerType', 'Physician'); 
        //Test.setCurrentPage(ACETPDPage);
        ACETProviderLookUpDetailController ACETPDExt1 = new ACETProviderLookUpDetailController(); 
        ACETPDExt1.providerType = 'Physician';
        ACETProviderLookUpDetailController.ContrcatInfo CI = new ACETProviderLookUpDetailController.ContrcatInfo();
         CI.product='test';
        Continuation conti = (Continuation)ACETPDExt1.CallWSOnPageLoad1();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(1, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
          response.setBody(ACETTestDataUtility.getHCPAdapterJSONHrsOper());     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(ACETPDExt1, conti); 
        Test.stopTest();

    }
    
 /**   static testMethod void ACETProviderLookUpDetailControllerTestMethod4() 
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
        mapISLWSConfigs.put('dev_SearchMedProvAgreementsEndpoint', 'ISLStageFindAgreementEndpoint');    
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_SearchMedicalProvidersEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/search');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_SearchHlhSvrAuthorizationsEndpoint', '/api/bravo/eisl/clinical/medicalhealthservicecaseauthorizations/v1.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary'; 
        AdditionalInfo.MemberId = '12345678901';   
        ACETRelationshipCodes__c rCodes = new ACETRelationshipCodes__c (Name = '18',Description__c = 'Self');
        insert rCodes; 
        Test.startTest();//
        PageReference ACETPDPage = Page.ACETProviderLookUpDetails;
        String IntId = InteractionId.Id;
        ACETPDPage.getParameters().put('Id', IntId);
        ACETPDPage.getParameters().put('additionalInfo', json.serialize(AdditionalInfo));
    StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'GetIndividualMembershipDetailJSON'];
        //String ResponseJSON = ResponseJSONSR.Body.toString();
        //String ResponseJSON = '{"getMembershipResponse":{"memberships":[{"coordinationOfBenefits":[{"insuranceTypeCode":{"code":"Commercial"},"insurancePolicyNumberId":{"id":"0124578"},"coverageTypeCode":{"code":"Part A"},"insuranceEffectiveDateRange":{"startDate":"2015-02-08","stopDate":"9999-12-31"},"cardHolderFirstName":"TOM","cardHolderLastName":"THOMUS","cardHolderTelephone":"333-888-9999","cardHolderId":{"id":"898989"},"insuranceVerificationDate":{"date":"2015-01-01"},"payerResponsibilitySequenceCode":{"code":"Primary"},"medicareEntitlementTypeCode":{"code":"A"},"uhgOrderOfBenefits":{"code":"UHG Code"}}],"customerAccount":{"businessArrangement":[{"id":[{"typeCode":{},"id":"0909003"}]}],"customerPurchase":[{"productClassificationCode":{},"customerPurchaseId":{"id":"0909003"},"fundingArrangementCode":{"effectiveDateRange":{},"code":"F"},"situsStateCode":{"code":"IA"},"legislativeLanguageComplianceIndicator":"LLCI"}],"insuringRule":[{"code":"Waiting period","desc":"EligibilityGracePeriodThruDate"}],"customerAccountId":{"id":"0909003"}},"financialAccount":[{"productNumber":"8948989","productName":"PPR","riskType":{"code":"044"},"individualAccountNumberId":{"id":"76788909"}}],"organization":{"name":[{"name":"UHG"}],"organizationId":{"id":"01500"},"typeCode":{"code":"UHG"}},"plan":{"businessSegment":[{"planMarketSegment":[{"marketSegmentCode":{"code":"0014480"}}]}],"healthCoverage":[{"healthCoverageTypeCode":{"code":"M"}}],"planLegalEntity":{"legalEntityIdentifier":{"id":"01"}},"benefitSetId":{},"planId":{},"status":"Active","packageBenfitPlan":"No","name":"Brand","legalDescription":{"text":"HEALTH MAINTENANCE ORGANIZATION COMMERCIAL"},"planCode":{"code":"MS1"},"planTypeCode":{"code":"HMO"},"productCode":{"code":"MS1-HMO"}},"providerSelection":[{"effectiveDateRange":{"startDate":"2015-01-01","stopDate":"9999-12-31"},"practiceAddressId":{"id":"Mailing"},"networkId":{"id":"788909"},"healthCareProfessional":{"otherIdentifier":[{"otherIdentifierTypeCode":{},"otherId":{"id":"485742631"}}],"lastName":"MINDY","firstName":"WILHELMI","middleName":"A","address":{"line1":"131","line2":"Morristown Rd","city":"Bernards","state":{"code":"NJ"},"postalCode":{"part1":"07920","part2":"0000"},"countyCode":{"code":"Union"}},"telephoneNumber":{"phoneTypeCode":{},"areaCode":{"code":"555"},"telephoneNumber":["444-9999"],"extensionNumber":"0001"},"professionalId":{"id":"788909"}},"productCode":"HMO","marketType":{"code":"75"},"marketNumber":"0014480","PCPAssignmentIndicator":"A","sourceSysCode":{"code":"CS"}}],"divisionNumberId":{"id":"555"},"divisionCode":{"code":"DCC"},"lastModifiedDateTime":"2001-12-17","migrationDate":"2001-12-17","alertCode":{"code":"AC"},"otherIndicator":[{"typeCode":{"code":"Hospice Indicator"},"id":"700932"}],"planIdentifier":{"code":"CO"},"eligibilitySystemTypeCode":{"code":"01"},"claimSystemTypeCode":{"code":"ECHO"},"panelNumber":"78493","coverageSet":"tops","baseMme":"tops base","cme":"CME","medicare":"Medicare","claimOffice":[{"name":"UHG","tollFreeNumber":"444-555-8888","phoneNumber":"444-555-8888","officeNumber":"444-555-8888","postalAddress":{"line1":"131","line2":"Morristown Rd","city":"Bernards","state":{"code":"NJ"},"postalCode":{"part1":"07920"},"countyCode":{"code":"001"}}}],"populationId":{"code":"7834784"},"populationEffectiveDate":{"startDate":"2015-01-01","stopDate":"9999-01-01"},"populationRuleFired":"PRF","populationTimeStamp":"2001-12-17","populationDateAssigned":"2015-02-01","certificateOfCoverageYear":"UHG","benefitsStatusCode":{"code":"ACTIVE"},"coverageLevelCode":{"code":"part B"},"effectiveDateRange":{"startDate":"2010-09-01","stopDate":"9999-12-31"},"eligibilityRelationshipCode":{"code":"00","desc":"Subscriber/Recipient"},"enrolleeIndividualId":{"sourceSysCode":"7293281"},"memberMarketNumberId":{"id":"77"},"organizationPopulationGroupId":[{"id":"02"}],"organizationPopulationGroupName":"yes","sequenceCode":{"code":"001"},"sourceSystemCode":{"code":"01"},"subscriberIndividualId":{"id":"001"}}]}}'; 
    String ResponseJSON = '{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"4061353","groupName":"Small 20180817060629","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1018480","benefitBundleOptionDescription":"Plan_1","benefitEffectiveDate":"2018-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000745","benefitPlanName":"CTSM SMART HSA PPO D30/D50 ER D/200","benefitType":"MD","coverageLevelCode":"EMP","product":{"productIdentifier":"PM00000007","productName":"Pediatric Vision"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"11593523700","subscriberIdCardSerialNumber":"11593523700","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"06","networkScheduleID":"FREEDOM_CHOICEPLUS","coverageLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2018-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"Y"}},{"benefitBundleOptionId":"1018480","benefitBundleOptionDescription":"Plan_1","benefitEffectiveDate":"2018-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"PEDD000005","benefitPlanName":"PEDIATRIC DENTAL CTSM SMART HSA 01","benefitType":"DN","coverageLevelCode":"EMP","product":{"productIdentifier":"PM00000007","productName":"Pediatric Vision"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"11593523700","subscriberIdCardSerialNumber":"11593523700","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"","networkScheduleID":"","coverageLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2018-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1018480","benefitBundleOptionDescription":"Plan_1","benefitEffectiveDate":"2018-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"PEDV000005","benefitPlanName":"PEDIATRIC VISION CTSM SMART HSA 01","benefitType":"VS","coverageLevelCode":"EMP","product":{"productIdentifier":"PM00000007","productName":"Pediatric Vision"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"11593523700","subscriberIdCardSerialNumber":"11593523700","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"","networkScheduleID":"","coverageLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2018-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}},{"benefitBundleOptionId":"1018480","benefitBundleOptionDescription":"Plan_1","benefitEffectiveDate":"2018-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000003","benefitPlanName":"SG $5/$50/30% to $500 max/50% to $750","benefitType":"RX","coverageLevelCode":"EMP","product":{"productIdentifier":"PM00000007","productName":"Pediatric Vision"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"11593523700","subscriberIdCardSerialNumber":"11593523700","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"03","networkScheduleID":"","coverageLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2018-01-01","covLevelExpDate":"9999-12-31"}],"holdList":[{}],"indicators":{"qmscoIndicator":"N","hsaIndicator":"N"}}]}]}],"cob":[{}],"providers":[{"expirationDate":"2019-12-31","providerIdentifiers":[{"id_z":"12345","type_z":"NPI"},{"id_z":"","type_z":"LTK"}]}],"identifiers":[{"id":"637882060","type":"enrolleeSurrogateKey"},{"id":"474346629","type":"enrolleeIndividualIdentifier"},{"id":"100000604013","type":"enrolleeSystemID"},{"id":"100000604013","type":"subscriberSystemID"},{"id":"474346629","type":"subscriberIndividualIdentifer"},{"id":"637882060","type":"subscriberSurrogateKey"}]}}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseProvider = new MockHttpCalloutResponseGenerator.MockHttpResponse
            (200, 'OK', ResponseJSON);
        OILResponseProvider.TokenExpired = false; 
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseProvider);        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
    ACETProviderLookUpDetailController ACETPDExt1 = new ACETProviderLookUpDetailController();
    ACETPDExt1.AdditionalInfo = AdditionalInfo;
    if(ACETPDExt1.MemberDetail == null){
      ACETPDExt1.MemberDetail = new ACETMemberDetail();
    }
    ACETPDExt1.MemberDetail.PreferredCoverage = new ACETMemberDetail.CoverageLine();
    ACETPDExt1.MemberDetail.PreferredCoverage.benefitPlanId = 'M000000745';
    ACETPDExt1.MemberDetail.PreferredCoverage.coverageMemberId = '11593523700';
    ACETPDExt1.MemberDetail.PreferredCoverage.EffectiveDate = '5/1/2018';
    ACETPDExt1.MemberDetail.PreferredCoverage.EndDate = '12/31/2019';
    ACETPDExt1.CallWSOnPageLoad1();
      ACETPDExt1.findMemberships();
      ACETGetmembershipWebService testWeb = new ACETGetMembershipWebService();
      testWeb.getAgeFromBirthday('12/31/2001');
      testWeb.getMaskedSSN('123456789');
      Test.StopTest();
  } **/
    
    static testMethod void testParse() { 
        String json=        '{"UpdateIndividualMembershipResponse": {"response": {'+
        '   "responseCode": "200",'+
        '   "responseDesc": " STS0003-Member [1] - Record(s) updated. STS3021-Member Benefit Plan Elections [1] - All member benefit records associated to this bundle option are successfully updated. STS0003-Member Benefit Plan Elections [1] - Record(s) updated. STS3021-Member Benefit Plan Elections [1] - All member benefit records associated to this bundle option are successfully updated. STS0003-Member Benefit Plan Elections [1] - Record(s) updated. STS0003-Member Provider Assignment: Member Provider ID: 1588483: Record(s) updated."'+
        '}}}';
     //   ACETUpdIndividualMemResJSON2Apex obj = ACETUpdIndividualMemResJSON2Apex.parse(json);
     //   System.assert(obj != null);
               
    }
    static testMethod void ProviderLookUpDetailControllertestone() { 
         Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
         ApexPages.currentPage().getParameters().put('grpnum','gronum'); 
                 ApexPages.currentPage().getParameters().put('srk','test1234'); 

        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary';  
        AdditionalInfo.memberid ='123456';
        
        
          ACETMemberDetail mb = new ACETMemberDetail ();
        mb.FirstName = 'John';
        mb.LastName = 'Doe';
        mb.MiddleName = 'Yo';
        mb.effectiveDate = '1/1/2017'; 
        mb.SurrogateKey ='srk123';
        
        
ACETProviderLookUpDetailController controller = new ACETProviderLookUpDetailController();
        controller.AdditionalInfo = AdditionalInfo;
            controller.genInfoLanguage ='genInfoLanguage';
        controller.Dummy ='Dummy';
        controller.FreeStandingFacl=true;
        controller.isErrorMessageAdded=true;
        controller.npis ='npis';
        controller.conObj = TestDataFactory.createContact();
        controller.memberId='memberId';
        controller.policyNumber ='policyNumber';
        controller.hpAdditionInfoStr ='hpAdditionInfoStr';
        controller.netWork ='netWork';
        controller.istProviderContratResult =true;
        controller.isContractControl=false;
        controller.disableContractType =true;
        controller.strType ='strType';
        controller.providerType ='Facility';
        controller.proferredCoverageGUID='proferredCoverageGUID';
        controller.memId =true;
        controller.optSelected='optSelected';
        controller.membNetwork='membNetwork';
        
        controller.CallFindAgreements();
        controller.CallFindAffiliations();
        controller.CallFindMedicalProvider();
        
        
    }
     static testMethod void ProviderLookUpDetailControllertesttwo() { 
         Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
         contact con   = TestDataFactory.createContact();      
         ApexPages.currentPage().getParameters().put('srk','test1234'); 
         ApexPages.currentPage().getParameters().put('contactId',con.id);
ACETMemberDetail mb = new ACETMemberDetail ();
        mb.FirstName = 'John';
        mb.LastName = 'Doe';
        mb.MiddleName = 'Yo';
        mb.effectiveDate = '1/1/2017'; 
        mb.SurrogateKey ='';
       
           ACETProviderLookUpDetailController ACETPDExt1 = new ACETProviderLookUpDetailController();
    if(ACETPDExt1.MemberDetail == null){
      ACETPDExt1.MemberDetail = new ACETMemberDetail();
    }
    
         
         ACETProviderLookUpDetailController.CurrentPhysician cp = new ACETProviderLookUpDetailController.CurrentPhysician();
         cp.firstName = 'firstName';
         cp.lastName='lastName';
         cp.EndDate=system.today();
         cp.CaseEndDate=TestDataFactory.createCase();
         ACETProviderLookupController.ProviderLookupResult pl = new ACETProviderLookupController.ProviderLookupResult();
         pl.PCPRole ='PCPRole';
         
         

         
         
         
         
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary';     
         ApexPages.currentPage().getParameters().put('additionalInfo',JSON.serialize(AdditionalInfo));
ACETProviderLookUpDetailController controller = new ACETProviderLookUpDetailController();
            controller.genInfoLanguage ='genInfoLanguage';
        controller.Dummy ='Dummy';
        controller.FreeStandingFacl=true;
        controller.isErrorMessageAdded=true;
        controller.npis ='npis';
        controller.memberId='memberId';
        controller.policyNumber ='policyNumber';
        controller.hpAdditionInfoStr ='hpAdditionInfoStr';
        controller.netWork ='netWork';
        controller.istProviderContratResult =true;
        controller.isContractControl=false;
        controller.disableContractType =true;
        controller.strType ='strType';
        controller.providerType ='';
        controller.proferredCoverageGUID='proferredCoverageGUID';
        controller.memId =true;
        controller.optSelected='optSelected';
        controller.membNetwork='membNetwork';
        controller.CallFindAgreements();
        controller.CallFindAffiliations();
        controller.CallFindMedicalProvider();
controller.findMemberships();
         controller.onPageLoad();
        
        
        
    }
 }