@isTest
public class SAECaseCreationControllerTest {
    
    @testSetup static void createTestData() {
               
       TestDataFactory.createInteraction();
  }

     static testMethod void test_getTTSFilterMapKeyStr(){
        test.startTest();
        list<string> testList = new list<String>();
        list<string> keylist = SAECaseCreationController.getTTSFilterMapKeyStr('View Member Eligibility', true);
        list<string> keylist1 = SAECaseCreationController.getTTSFilterMapKeyStr('Provider Only', false);
        list<string> keylist2 = SAECaseCreationController.getTTSFilterMapValueStr('View Member Eligibility','View Member Eligibility');
        System.debug('Test Result::: '+ keylist);
        System.assertEquals(testList, keylist);
        test.stopTest();
    }

    static testMethod void test_saveTTSCase(){

      List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];

      String caseString = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
      String caseString2 = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","contactNumber":"123","contactExt":"123","onShoreRestriction":"abc","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06-08-1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","Status":"Open","AddInfoOrginSubType":"","AddInfoOrginType":"System Unavailable","CaseCreationFrom":"Member_Snapshot_Policies","PolicyCount":"0","AutoDoc":"<div></div>"}';
      String caseStringMnf = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"mnf":"mnf","providerId":"","TaxId":"Commercial","noMemberToSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"rythjthjtyj","contactNumber":"123","contactExt":"","OriginatorPhone":"556-758-7687","OriginatorEmail":"","SubjectName":"WEFWE CASCASC","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"--","SubjectGroupId":"--","OriginatorName":"undefined CASCASC","AddInfoTopic":"Member Not Found","Status":"Closed","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"","ttsType":"Issue Resolved","ttsSubType":"","AutoDoc":"<div></div>"}';

      test.startTest();
      String caseId = SAECaseCreationController.saveTTSCase(caseString, true);
      String caseId2 = SAECaseCreationController.saveTTSCase(caseString2, true);
      String caseIdMnf = SAECaseCreationController.saveTTSCase(caseStringMnf, true);

      //Case cs = [SELECT ID,Status FROM Case WHERE Id =:caseId];
      //Case cs2 = [SELECT ID,Status FROM Case WHERE Id =:caseId2];
      //Case csMnf = [SELECT ID,Status FROM Case WHERE Id =:caseIdMnf];

      //System.assertEquals('Closed', cs.Status);
      //System.assertEquals('Closed', cs2.Status);
      //System.assertEquals('Closed', csMnf.Status);

      //SAECaseCreationController.getTTSFilterMapValueStr('provider lookup', 'lkp');
      String s = '';
        // for case routing info class
        ACET_RoutingScreenController.getRoutingInfo();
      test.stopTest();
    }

    static testMethod void test_saveTTSCase2(){

        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];

        String caseStringProviderNF = '{"Interaction":"'+lstInteractions[0].Id+'","Status":"Closed","OriginatorName":" WQEFWEGFWGFFGWFGE","OriginatorType":"Provider","OriginatorContactName":"sdvsdv","SubjectName":" WQEFWEGFWGFFGWFGE","SubjectType":"Member","SubjectDOB":"--","SubjectId":"--","SubjectGroupId":"--","TaxId":"4345544444","noProviderToSearch":false,"providerNotFound":true,"noMemberToSearch":true,"mnf":"","isOtherSearch":false,"AddInfoTopic":"Provider Not Found","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"","ttsType":"Issue Resolved","ttsSubType":"","AutoDoc":"<div></div>"}';
        String caseStringOther = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":true,"mnf":"mnf","providerId":"88989898999","TaxId":"1212322233","noMemberToSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"SDGSDG SARMA","OriginatorType":"Other","OriginatorRelationship":"Internal/UHG Employee","OriginatorContactName":"SDGSDG SARMA","OriginatorPhone":"234-234-2342","OriginatorEmail":"--","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"COB Investigation Initiated","ttsType":"Issue Resolved","ttsSubType":"COB Investigation Initiated","AutoDoc":"<div></div>"}';

        test.startTest();
        String caseIdPnf = SAECaseCreationController.saveTTSCase(caseStringProviderNF, true);
        String caseIdOther = SAECaseCreationController.saveTTSCase(caseStringOther, false);

        //Case csPnf = [SELECT ID,Status FROM Case WHERE Id =:caseIdPnf];
        //Case csOther = [SELECT ID,Status FROM Case WHERE Id =:caseIdOther];

        //System.assertEquals('Closed', csPnf.Status);
       // System.assertEquals('Closed', csOther.Status);

        test.stopTest();
    }



    static testMethod void test_saveTTSCase3(){

        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];

        String caseStringMemberFromIO = '{"Interaction":"'+lstInteractions[0].Id+'","providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"mnf":"mnf","noMemberToSearch":false,"OriginatorName":"LARRY MARCUS","OriginatorType":"Provider","OriginatorRelationship":"","OriginatorContactName":"sdvsdv","OriginatorPhone":"203-384-3975","OriginatorEmail":"--","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","memberContactId":"","AddInfoTopic":"View Member Eligibility","Status":"Closed","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AddInfoOrginType":"Issue Routed","AddInfoOrginSubType":"Eligibility Investigation Initiated","ttsType":"Issue Routed","ttsSubType":"Eligibility Investigation Initiated","AutoDoc":"<div></div>"}';
        String caseStringProviderOnly = '{"Interaction":"'+lstInteractions[0].Id+'","providerId":"000006798","TaxId":"061330992","noProviderToSearch":false,"providerNotFound":false,"noMemberToSearch":true,"mnf":"","OriginatorName":"LARRY M MARCUS  ","OriginatorType":"Provider","OriginatorContactName":"sdvsdv","SubjectName":"LARRY MARCUS","SubjectType":"Provider","SubjectDOB":"--","SubjectId":"--","SubjectGroupId":"--","AddInfoTopic":"Provider Details","Status":"Closed","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Details Provided","ttsType":"Issue Resolved","ttsSubType":"Details Provided","AutoDoc":"<div></div>"}';

        test.startTest();
        String caseIdMemberFromIO = SAECaseCreationController.saveTTSCase(caseStringMemberFromIO, true);
        String caseIdProviderOnly = SAECaseCreationController.saveTTSCase(caseStringProviderOnly, true);

       // Case csMemberFromIO = [SELECT ID,Status FROM Case WHERE Id =:caseIdMemberFromIO];
       // Case csProviderOnly = [SELECT ID,Status FROM Case WHERE Id =:caseIdProviderOnly];

        //System.assertEquals('Open', csMemberFromIO.Status);
       // System.assertEquals('Closed', csProviderOnly.Status);

        test.stopTest();
    }

  static testMethod void test_saveTTSCase4(){

        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];

        String caseStringProviderNF = '{"Interaction":"'+lstInteractions[0].Id+'","Status":"Closed","OriginatorName":" WQEFWEGFWGFFGWFGE","OriginatorType":"Provider","OriginatorContactName":"sdvsdv","SubjectName":" WQEFWEGFWGFFGWFGE","SubjectType":"Member","SubjectDOB":"--","SubjectId":"--","SubjectGroupId":"--","TaxId":"4345544444","noProviderToSearch":false,"providerNotFound":true,"noMemberToSearch": null,"mnf":"mnf","isOtherSearch":false,"AddInfoTopic":"Provider Not Found","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"","ttsType":"Issue Resolved","ttsSubType":"","AutoDoc":"<div></div>"}';

        test.startTest();
        String caseIdPnf = SAECaseCreationController.saveTTSCase(caseStringProviderNF, true);

       // Case csPnf = [SELECT ID,Status FROM Case WHERE Id =:caseIdPnf];

        //System.assertEquals('Closed', csPnf.Status);
        test.stopTest();
    }

    static testMethod void test_saveTTCase6(){
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
    String caseCPMChild = '{"isOtherSearch":false,"noProviderToSearch":true,"providerNotFound":false,"mnf":"mnf","providerId":"","TaxId":"Commercial","noMemberToSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"rythjthjtyj","contactNumber":"123","contactExt":"","OriginatorPhone":"556-758-7687","OriginatorEmail":"","SubjectName":"WEFWE CASCASC","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"--","SubjectGroupId":"--","OriginatorName":"undefined CASCASC","AddInfoTopic":"View Claims","Status":"Closed","AddInfoOrginType":"Issue Routed","AddInfoOrginSubType":"Claims Project 20+ Claims","ttsType":"Issue Routed","ttsSubType":"Claims Project 20+ Claims","SRClaimMap":{"CS":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223551","7392722355"],"comment":"CS"},"CO - Physician":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223556","7392722357"],"comment":"COP"},"CO - Hospital":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223558","7392722359"],"comment":"COH"},"AP":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223552","7392722353"],"comment":"AP"}},"AutoDoc":"<div></div>"}';
        String caseCPMChild2 = '{"noProviderToSearch":true,"providerNotFound":false,"isOtherSearch":false,"mnf":"mnf","providerId":"","TaxId":"Commercial","noMemberToSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"rythjthjtyj","contactNumber":"123","contactExt":"","OriginatorPhone":"556-758-7687","OriginatorEmail":"","SubjectName":"WEFWE CASCASC","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"--","SubjectGroupId":"--","OriginatorName":"undefined CASCASC","AddInfoTopic":"View Claims","Status":"Closed","AddInfoOrginType":"Issue Routed","AddInfoOrginSubType":"Claims Project 20+ Claims","ttsType":"Issue Routed","ttsSubType":"Claims Project 20+ Claims","SRClaimMap":{"CS":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223551","7392722355"],"comment":"CS"},"CO - Hospital":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223558","7392722359"],"comment":"COH"},"CO - Physician":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223556","7392722357"],"comment":"COP"},"AP":{"email":"testtset@test.com","BeginDOS":"2021-06-13","EndDOS":"2021-06-15","ClaimsInfo":["73927223552","7392722353"],"comment":"AP"}},"AutoDoc":"<div></div>"}';
        Test.startTest();
        String caseCPMChildId = SAECaseCreationController.saveTTSCase(caseCPMChild, true);
        String caseCPMChildId2 = SAECaseCreationController.saveTTSCase(caseCPMChild2, true);
        Test.stopTest();

    }

    // ORS Creation
    static testMethod void createORS_Test_1() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_ORSCreateIssueMicroService';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-coui/issues/v1';
        insert webConfig;

        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c();
        apiEndpointSetting.Name = 'SNIAPIAccessToken';
        apiEndpointSetting.Is_Available__c = true;
        apiEndpointSetting.Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g';
        Insert apiEndpointSetting;

    Case caseRec = new Case(Status = 'Open');
        Insert caseRec;

        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        String caseWrapper = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","subjectFirstName":"AMANDA","subjectLastName":"ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","misdirectComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","manualEnteredComments":"TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","freeFormCommentsVal": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","concatinatedComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","isFromAuth":true,"AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
    String caseWrapper2 = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjt hjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","misdirectComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","manualEnteredComments":"TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","freeFormCommentsVal": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","concatinatedComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","isFromAuth":true,"AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
 
        //String caseWrapper = '{"Interaction":"1233","providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"mnf":"mnf","noMemberToSearch":false,"OriginatorName":"LARRY MARCUS","OriginatorType":"Provider","OriginatorRelationship":"","OriginatorContactName":"sdv sdv","OriginatorPhone":"203-384-3975","OriginatorEmail":"--","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","misdirectComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","manualEnteredComments ":"TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","freeFormCommentsVal":"","manualEnteredComments":"Test Manual Test manualEnteredComments manualEnteredComments manualEnteredComments","concatinatedComments":"Issue-Issuetest,memberId-2348923472389",memberContactId":"","AddInfoTopic":"View Member Eligibility","Status":"Closed","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AddInfoOrginType":"Issue Routed","AddInfoOrginSubType":"Eligibility Investigation Initiated","ttsType":"Issue Routed","ttsSubType":"Eligibility Investigation Initiated","isFromAuth":true,"AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1||caseitem2::caseitem2"}';
    String caseIdMemberFromIO = SAECaseCreationController.saveTTSCase(caseWrapper, true);
        String caseIdMemberFromIO2 = SAECaseCreationController.saveTTSCase(caseWrapper2, true);
        
        SAETTSCaseWrapper caseWrappernew = new SAETTSCaseWrapper();
        caseWrappernew.claimNumber = 'test';
        caseWrappernew.policyNumber = 'test';
    caseWrappernew.AddInfoOrginSubType = 'test';
    caseWrappernew.TaxId = 'test';
    caseWrappernew.mnf = 'mnf';
    caseWrappernew.mnfExternalId = 'mnfExternalId';
    caseWrappernew.providerNotFound = false;
    caseWrappernew.pnfExternalId = 'pnfExternalId';
        
        ACET_RoutingScreenController.StateInfo stateInfo = ACET_RoutingScreenController.createState(caseWrappernew, caseRec,'test',true,'test');


        List<ACET_RoutingScreenController.UniquePolicyToClaims> resolvedCaseClaims = new List<ACET_RoutingScreenController.UniquePolicyToClaims>();
        ACET_RoutingScreenController.UniquePolicyToClaims uniquePolicyToClm = new ACET_RoutingScreenController.UniquePolicyToClaims();
        resolvedCaseClaims.add(uniquePolicyToClm);

        stateInfo.resolvedCaseClaims = resolvedCaseClaims;
        //stateInfo.allUnresolvedResolvedFlg = false;

        HttpResponse response = new HttpResponse();
         response.setBody('{}');
         response.setStatus('500');
        // Set the fake response for the continuation
        Test.setContinuationResponse('testlable', response);
        List<String> labels = new List<String>();
        labels.add('testlable');

          Map<String,ACET_RoutingScreenController.StateInfo> requestLServiceMap=new Map<String,ACET_RoutingScreenController.StateInfo>();
          requestLServiceMap.put('testlable',stateInfo );

         ACET_RoutingScreenController.processResponseResolved(labels, requestLServiceMap);

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ORSMockResponse());
          String caseIdMemberFromIO3 = SAECaseCreationController.saveTTSCase(caseWrapper, true);
          // Thanish - Bug fix - 25th Jun 2020
            List<SAECaseCreationController.ORSResultWrapper> orsId = SAECaseCreationController.CreateORSRecord(caseWrapper, caseRec.Id);
            SAECaseCreationController.StateInfo ctrl = new SAECaseCreationController.StateInfo();
            ctrl.isResolved = true;
            ctrl.finalOrsIssueID = 'test';
        Test.stopTest();
    }

    static testMethod void createORS_Test_ProviderDetails()
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_ORSCreateIssueMicroService';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-coui/issues/v1';
        insert webConfig;

        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c();
        apiEndpointSetting.Name = 'SNIAPIAccessToken';
        apiEndpointSetting.Is_Available__c = true;
        apiEndpointSetting.Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g';
        Insert apiEndpointSetting;

    Case caseRec = new Case(Status = 'Routed');
        Insert caseRec;

        List<Case_Item__c> cis = new List<Case_Item__c>();
        Case_Item__c resCaseItem = new Case_Item__c();
        resCaseItem.Case__c = caseRec.ID;
        resCaseItem.ExternalID__c = 'ExtResolvedExtResolvedExtResolvedExtResolvedExtResolvedExtResolvedExtResolvedExtResolvedExtResolved ';
        resCaseItem.tax_id__c = '';
        resCaseItem.Resolved__c = true;
        resCaseItem.Resolved_Reason__c = 'Resolved';
            resCaseItem.Type__c = 'Issue Resolved';
        resCaseItem.Subtype__c = 'Issue Resolved';
        cis.add(resCaseItem);


        Case_Item__c unresCaseItem = new Case_Item__c();
        unresCaseItem.Case__c = caseRec.ID;
        unresCaseItem.ExternalID__c = 'ExtUnResolvedExtUnResolvedExtUnResolvedExtUnResolvedExtUnResolvedExtUnResolvedExtUnResolvedExtUnResolvedExtUnResolved';
        unresCaseItem.tax_id__c = '';
        unresCaseItem.Resolved__c = false;
        unresCaseItem.Resolved_Reason__c = 'unResolved';
            unresCaseItem.Type__c = 'Issue Routed';
        unresCaseItem.Subtype__c = 'Issue Routed';
        cis.add(unresCaseItem);

        insert cis;

        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        String caseWrapper = '{"providerNotFound":false,"ttsType":"Issue Routed","noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","subjectFirstName":"AMANDA","subjectLastName":"ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","misdirectComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","manualEnteredComments":"TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","freeFormCommentsVal": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","concatinatedComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","AddInfoTopic":"Provider Details","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","isFromAuth":true,"AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';

        //String caseWrapper = '{"Interaction":"1233","providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"mnf":"mnf","noMemberToSearch":false,"OriginatorName":"LARRY MARCUS","OriginatorType":"Provider","OriginatorRelationship":"","OriginatorContactName":"sdv sdv","OriginatorPhone":"203-384-3975","OriginatorEmail":"--","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","misdirectComments": "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","manualEnteredComments ":"TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest","freeFormCommentsVal":"","manualEnteredComments":"Test Manual Test manualEnteredComments manualEnteredComments manualEnteredComments","concatinatedComments":"Issue-Issuetest,memberId-2348923472389",memberContactId":"","AddInfoTopic":"View Member Eligibility","Status":"Closed","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AddInfoOrginType":"Issue Routed","AddInfoOrginSubType":"Eligibility Investigation Initiated","ttsType":"Issue Routed","ttsSubType":"Eligibility Investigation Initiated","isFromAuth":true,"AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1||caseitem2::caseitem2"}';
    String caseIdMemberFromIO = SAECaseCreationController.saveTTSCase(caseWrapper, true);

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ORSMockResponse());
          String caseIdMemberFromIO3 = SAECaseCreationController.saveTTSCase(caseWrapper, true);

            List<SAECaseCreationController.ORSResultWrapper> orsId = SAECaseCreationController.CreateORSRecord(caseWrapper, caseRec.Id);
            SAECaseCreationController.mapOrsValuesToFinancialCaseItems(cis,'123456','Close');
        Test.stopTest();
    }

     static testMethod void providerLookupExternaIdTest()
        {
            string rowdata = '{"caseItemsExtId":"000160744","checkBoxDisabled":false,"checked":true,"linkDisabled":false,"resolved":true,"rowColumnData":[{"fieldType":"outputText","fieldValue":"000160744","isOutputText":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"INN","isOutputText":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"--","isOutputText":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"--","isOutputText":true,"isReportable":true},{"fieldType":"link","fieldValue":"WESTLAKE MEDICAL CENTER","isLink":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"0.00","isOutputText":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"5201 HARRY HINES BLVD, DALLAS, TX, 75235","isOutputText":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"PLACE OF SERVICE","isOutputText":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"756004221","isOutputText":true,"isReportable":true},{"fieldType":"outputText","fieldValue":"1699134882","isOutputText":true,"isReportable":true}],"rowDetails":"756004221,000160744,001126082,000000011,WESTLAKE MEDICAL CENTER,false","uniqueKey":"001126082000160744"}';
            object rowdata2 = JSON.deserializeUntyped(rowdata);
            Map < String, Object > row = (Map < String, Object > ) rowdata2;
            SAECaseCreationController.processAddressDataForProviderLookupExternalId(row);
        }
    static testMethod void test_saveTTSCase5(){
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        StaticResource sr= [select id,body from StaticResource Where Name = 'SavedAutoDocMockData'];
        String allcontents = sr.body.toString();
        String caseString = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        String caseString2 = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","contactNumber":"123","contactExt":"123","onShoreRestriction":"abc","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06-08-1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","Status":"Open","AddInfoOrginSubType":"","AddInfoOrginType":"System Unavailable","CaseCreationFrom":"Member_Snapshot_Policies","PolicyCount":"0","savedAutodoc":"' + allcontents + '"}';
        String caseStringMnf = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"mnf":"mnf","providerId":"","TaxId":"Commercial","noMemberToSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"rythjthjtyj","contactNumber":"123","contactExt":"","OriginatorPhone":"556-758-7687","OriginatorEmail":"","SubjectName":"WEFWE CASCASC","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"--","SubjectGroupId":"--","OriginatorName":"undefined CASCASC","AddInfoTopic":"Member Not Found","Status":"Closed","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"","ttsType":"Issue Resolved","ttsSubType":"","AutoDoc":"<div></div>","savedAutodoc":"' +allcontents+ '"}';
        SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(caseString, SAETTSCaseWrapper.class);
        caseWrapper.savedAutodoc = allcontents;
        //caseWrapper.createFacetsCase = true;
        //caseWrapper.createORSCase = false;
        String caseWithSavedAutodoc = JSON.serialize(caseWrapper);
        test.startTest();
        String caseIdSavedAutodoc = SAECaseCreationController.saveTTSCase(caseWithSavedAutodoc, true);
        String caseId = SAECaseCreationController.saveTTSCase(caseString, true);
        String caseId2 = SAECaseCreationController.saveTTSCase(caseString2, true);
        String caseIdMnf = SAECaseCreationController.saveTTSCase(caseStringMnf, true);
        //if(caseId != null) {
            //SAECaseCreationController.createADReporting(allcontents, caseId);
        //}
        test.stopTest();
    }

    static testMethod void testCreateCaseItems(){
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        StaticResource sr= [select id,body from StaticResource Where Name = 'SavedAutoDocMockData'];
        String allcontents = sr.body.toString();
        String caseVal= '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"Test Test","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"Test","OriginatorPhone":"0112223330","OriginatorEmail":"example@abc.com","SubjectName":"ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"100167575","SubjectGroupId":"706577","AddInfoTopic":"Plan Benefits","componentType":"financials","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(caseVal, SAETTSCaseWrapper.class);
        caseWrapper.savedAutodoc = allcontents;
        List<String> relatedKeys = new List<String>();
        relatedKeys.add('52332');
        Test.startTest();
        SAECaseCreationController.createCaseItems(true,'test',caseRec.Id,'52332',relatedKeys,'test',caseWrapper);
        SAECaseCreationController.getPhoneNumber('1234567');
        Test.stopTest();
    }

    static testMethod void testInsertCaseItems(){
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
        StaticResource sr= [select id,body from StaticResource Where Name = 'SavedAutoDocMockData'];
        String allcontents = sr.body.toString();
        String caseVal= '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"Vaneesa Venhelisng","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"Vanheesa","OriginatorPhone":"01122233202","OriginatorEmail":"veneesa@abc.com","SubjectName":"Veneesa","SubjectDOB":"06/08/1956","SubjectType":"Member","SubjectId":"100167574","SubjectGroupId":"706579","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(caseVal, SAETTSCaseWrapper.class);
        caseWrapper.savedAutodoc = allcontents;
        SAETTSCaseWrapper.ACETCaseItem caseItem = new SAETTSCaseWrapper.ACETCaseItem();
        caseItem.uniqueKey = '52332';
        caseItem.isResolved =  true;
        caseItem.topic = 'View Member Eligibility';
        relatedCaseItemMap.put('0',caseItem);
        caseWrapper.relatedCaseItemsMap = relatedCaseItemMap;
        String caseWrap = JSON.serialize(caseWrapper);
        List<String> str = new List<String>{'1','2'};
        
        List<Case> caseList =new List<Case>();
        caseList.add(caseRec);
        
        List<SAE_Reason_Codes__mdt> saeMdtLst = [SELECT ID FROM SAE_Reason_Codes__mdt];
        
        Test.startTest();
        SAECaseCreationController.insertCaseItems(caseRec.Id,caseWrap);
        SAECaseCreationController.getPhoneNumber('1234567890');
        SAECaseCreationController.commentsValidation(str);
        SAECaseCreationController.createFacetsRecord('test','123456');
        //SAECaseCreationController.CreateORSRecordClaim(caseWrapper,caseList,saeMdtLst);
        Test.stopTest();

    }
    static testMethod void testInsertCaseItems1(){
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
        StaticResource sr= [select id,body from StaticResource Where Name = 'SavedAutoDocMockData'];
        String allcontents = sr.body.toString();
        String caseVal= '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"Vaneesa Venhelisng","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"Vanheesa","OriginatorPhone":"01122233202","OriginatorEmail":"veneesa@abc.com","SubjectName":"Veneesa","SubjectDOB":"06/08/1956","SubjectType":"Member","SubjectId":"100167574","SubjectGroupId":"706579","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(caseVal, SAETTSCaseWrapper.class);
        caseWrapper.savedAutodoc = allcontents;
        SAETTSCaseWrapper.ACETCaseItem caseItem = new SAETTSCaseWrapper.ACETCaseItem();
        caseItem.uniqueKey = '52332';
        caseItem.isResolved =  true;
        caseItem.topic = 'View Member Eligibility';
        relatedCaseItemMap.put('0',caseItem);
        caseWrapper.relatedCaseItemsMap = relatedCaseItemMap;
        String caseWrap = JSON.serialize(caseWrapper);
        List<String> str = new List<String>{'1','2'};
        
        List<Case> caseList =new List<Case>();
        caseList.add(caseRec);
        
        List<SAE_Reason_Codes__mdt> saeMdtLst = [SELECT ID FROM SAE_Reason_Codes__mdt];
        try{
            Test.startTest();
            SAECaseCreationController.insertCaseItems(caseRec.Id,caseWrap);
            SAECaseCreationController.getPhoneNumber('1234567890');
            SAECaseCreationController.commentsValidation(str);
            SAECaseCreationController.createFacetsRecord('test','123456');
            SAECaseCreationController.CreateORSRecordClaim(caseWrapper,caseList,saeMdtLst);
            Test.stopTest();
        }catch(exception e){}

    }
}