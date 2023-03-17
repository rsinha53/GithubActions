@isTest
public class ACET_RoutingScreenControllerTest {
    public static List<ACET_RoutingScreenController.Claim> templist=new List<ACET_RoutingScreenController.Claim>();
   static{
        ACET_RoutingScreenController.Claim claim=new ACET_RoutingScreenController.Claim();
                claim.paymentNoInput='ghghhjh';
                claim.claimId='ghghhjh';
                claim.ServiceDate='10/01/2020 - 10/01/2020';
                claim.types='ghghhjh';
                claim.cashed ='ghghhjh';
                claim.matchingSRN ='ghghhjh';
                claim.charged ='ghghhjh';
                claim.underAmmount ='ghghhjh';
                claim.PCMValue ='ghghhjh';
                claim.sourceValue='ghghhjh';
                claim.FLNNumber='4567686878';
                claim.MISInfo='ghghhjh';
                claim.externalID='ghghhjh';
                claim.reason='ghghhjh';
                claim.eReasonValue='ghghhjh';
                claim.coverageLevel='ghghhjh';
                claim.eligibilityDates='ghghhjh';
                claim.receivedDate='ghghhjh';
                claim.tflDate='ghghhjh';
                claim.uhcErrorValue='ghghhjh';
                claim.FLNValue='ghghhjh';
        		claim.RODreason='ghghhjh';
                claim.CheckValue='ghghhjh';
                claim.DateValue='10/01/2020';
                claim.overPayValue='ghghhjh';
                claim.ReasonValue='ghghhjh';
                claim.expectedAllowed='ghghhjh';
                claim.benfitLevel='benfitLevel';
        		claim.providerStatus='providerStatus';
				claim.engCode='ebg';
       			claim.flndcc='trt';
       			claim.checkAmount='red';
       			claim.CheckDate=String.valueOf(Date.today());
       			claim.ChashDate = String.valueOf(Date.today());

        templist.add(claim);


    }


    @testSetup static void setupCS(){
         final String headerValues='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';

        Profile p = [SELECT Id FROM Profile WHERE Name='Provider Service'];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User u2;
         System.runAs(thisUser){
      	  u2 = new User(Alias = 'newUser', Email='user@testorg.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = p.Id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newProviderServicesTestinguser@Optum.com.acet');
         insert u2;

         Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        TestDataFactory.createInteraction();

        List<WebserviceConfigurations__c> webConRelatedDocumentsList = new List<WebserviceConfigurations__c>();
         List<Mock_Response_Details__c> mockResponseRecList = new List<Mock_Response_Details__c>();
         List<OrgSpecificConfigurations__c> orgConfigList = new List<OrgSpecificConfigurations__c>();
         RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];

        WebserviceConfigurations__c  webConRelatedDocuments = new WebserviceConfigurations__c ();
        webConRelatedDocuments.GrantType__c  = 'client_credentials';
        webConRelatedDocuments.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments.Method__c  = 'POST';
        webConRelatedDocuments.Name  = 'SelectionAssociatesAPI';
        webConRelatedDocuments.Timeout__c = 10000;
        webConRelatedDocuments.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        webConRelatedDocuments.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = \'LinkServiceTokenAPIToken\'';
        insert webConRelatedDocuments;


        Mock_Response_Details__c mockResponseRec1=new Mock_Response_Details__c();
        mockResponseRec1.Status_Code__c='200';
        mockResponseRec1.FileName__c='NullAssociates';
        mockResponseRec1.SearchParameter__c='IndividualsSelectAssociate_723_RHK_OHS';
        mockResponseRec1.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec1);

        Mock_Response_Details__c mockResponseRe21=new Mock_Response_Details__c();
        mockResponseRe21.Status_Code__c='200';
        mockResponseRe21.FileName__c='IndividualsSelectAssociate';
        mockResponseRe21.SearchParameter__c='IndividualsSelectAssociate_420_CHK_DHS';
        mockResponseRe21.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRe21);

        Mock_Response_Details__c mockResponseRec31=new Mock_Response_Details__c();
        mockResponseRec31.Status_Code__c='200';
        mockResponseRec31.FileName__c='NoAssociates';
        mockResponseRec31.SearchParameter__c='IndividualsSelectAssociate_720_RHK_OHS';
        mockResponseRec31.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec31);


        OrgSpecificConfigurations__c orgConfig = new OrgSpecificConfigurations__c();
        orgConfig.Name = 'qa';
        orgConfig.WebserviceConfigurations__c = webConRelatedDocuments.id;
        orgConfig.EnableMock__c = true;
        orgConfig.EndpointDomain__c='https://gateway-stage.optum.com/api/stage/ccs/ci/selection-associates-offices/v1';
        orgConfig.RecordTypeText__c  = 'ServiceAPI'; 
        orgConfigList.add(orgConfig);




         ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'SAE_ProviderSearch';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;

        ISL_Webservice_Config__c webConfig_token = new ISL_Webservice_Config__c();
        webConfig_token.Name = 'ISLOAuthContentType';
        webConfig_token.Value__c = 'bearer';
        insert webConfig_token;

        Token_Generation__c tokenGen = new Token_Generation__c();
        tokenGen.Token_Name__c = 'ISLConAccessToken';
        tokenGen.Value__c = '1234567890hagjhadgsayytqyetxhzcxhgsdadaudyia';
        insert tokenGen;

          ISL_Webservice_Config__c webConfig1 = new ISL_Webservice_Config__c();
        webConfig1.Name = 'SAE_ProviderSearch';
        webConfig1.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig1;


		insert mockResponseRecList;
		insert orgConfigList;
         }

         System.runAs(u2){
       		 Case testCase=new  Case();
             	testCase.Status='Closed';
             	testCase.ORS_Issue_ID__c='D10780603345234';
                insert testCase;
         }
    }


    static testMethod void method1(){
        ACET_RoutingScreenController.getRoutingInfo();
        ACET_RoutingScreenController.getSAEReasonCodes();
        //ACET_RoutingScreenController.saveOrsCase('wrapperdata','5005500000AQIX0AAP');
		ACET_RoutingScreenController.getDelegatedProviderData('5005500000AQIX0AAP');
    }


    @isTest static void testCreateORSCaseForClaimsResolved() {
		User u2=[Select Id,Email,LastName,ProfileId from User where UserName='newProviderServicesTestinguser@Optum.com.acet'];

         System.runAs(u2){
             Case testCase=[Select Id,Status,ORS_Issue_ID__c From Case where Status='Closed'];
                ACET_RoutingScreenController.UniquePolicyToClaims uc=new ACET_RoutingScreenController.UniquePolicyToClaims();
                uc.policyType='ghghhjh';
                uc.groupNo='ghghhjh';
                uc.memberId='ghghhjh';
                List<ACET_RoutingScreenController.Claim> claims=ACET_RoutingScreenControllerTest.templist;
                uc.claims=claims;
                List<ACET_RoutingScreenController.UniquePolicyToClaims> uniqPolClaims=new List<ACET_RoutingScreenController.UniquePolicyToClaims> ();
                uniqPolClaims.add(uc);
                List<StaticResource> responseJSONSR =new List<StaticResource>();
                responseJSONSR = [SELECT Body FROM StaticResource WHERE Name ='CaseWrapperForClaims'];
             	if(responseJSONSR.size()>0){
                    Test.startTest();
                     ACET_RoutingScreenController.createORSCaseForClaimsResolved(responseJSONSR[0].Body.toString(),testCase.Id,uniqPolClaims,true);
                     Test.stopTest();
             	}

         }


     }


    @isTest static void testCreateStateResolved() {

        SAETTSCaseWrapper caseWrapper = new SAETTSCaseWrapper();
        caseWrapper.claimNumber = 'test';
        caseWrapper.policyNumber = 'test';
		caseWrapper.AddInfoOrginSubType = 'test';
		caseWrapper.TaxId = 'test';
		caseWrapper.mnf = 'mnf';
		caseWrapper.mnfExternalId = 'mnfExternalId';
		caseWrapper.providerNotFound = false;
		caseWrapper.pnfExternalId = 'pnfExternalId';
        Case caseRecord = new Case();
        ACET_RoutingScreenController.createState(caseWrapper, caseRecord,'test',true,'test');
    }


     @isTest static void testProcessResponseUnResolved() {

        SAETTSCaseWrapper caseWrapper = new SAETTSCaseWrapper();
        caseWrapper.claimNumber = 'test';
        caseWrapper.policyNumber = 'test';
		caseWrapper.AddInfoOrginSubType = 'test';
		caseWrapper.TaxId = 'test';
		caseWrapper.mnf = 'mnf';
		caseWrapper.mnfExternalId = 'mnfExternalId';
		caseWrapper.providerNotFound = false;
		caseWrapper.pnfExternalId = 'pnfExternalId';
        Case caseRecord = new Case();
        ACET_RoutingScreenController.StateInfo stateInfo = ACET_RoutingScreenController.createState(caseWrapper, caseRecord,'test',true,'test');
        HttpResponse response = new HttpResponse();
         response.setBody('{}');
         response.setStatus('500');
        // Set the fake response for the continuation
        Test.setContinuationResponse('testlable', response);
        List<String> labels = new List<String>();
        labels.add('testlable');

          Map<String,ACET_RoutingScreenController.StateInfo> requestLServiceMap=new Map<String,ACET_RoutingScreenController.StateInfo>();
          requestLServiceMap.put('testlable',stateInfo );

         ACET_RoutingScreenController.processResponseUnresolved(labels, requestLServiceMap);

     }


      @isTest static void testProcessResponseResolved() {

        SAETTSCaseWrapper caseWrapper = new SAETTSCaseWrapper();
        caseWrapper.claimNumber = 'test';
        caseWrapper.policyNumber = 'test';
		caseWrapper.AddInfoOrginSubType = 'test';
		caseWrapper.TaxId = 'test';
		caseWrapper.mnf = 'mnf';
		caseWrapper.mnfExternalId = 'mnfExternalId';
		caseWrapper.providerNotFound = false;
		caseWrapper.pnfExternalId = 'pnfExternalId';


        Case caseRecord = new Case();
        ACET_RoutingScreenController.StateInfo stateInfo = ACET_RoutingScreenController.createState(caseWrapper, caseRecord,'test',true,'test');


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

     }


      @isTest static void testCreateORSCaseForClaimsUnresolved() {
          User u2=[Select Id,Email,LastName,ProfileId from User where UserName='newProviderServicesTestinguser@Optum.com.acet'];
         System.runAs(u2){
               Case testCase=[Select Id,Status,ORS_Issue_ID__c From Case where Status='Closed'];
                List<ACET_RoutingScreenController.Claim> claims=ACET_RoutingScreenControllerTest.templist;
                ACET_RoutingScreenController.ClaimAddDetails claimAddDetails=new ACET_RoutingScreenController.ClaimAddDetails();
                ACET_RoutingScreenController.DemographicInfo demographicInfo=new ACET_RoutingScreenController.DemographicInfo();
                ACET_RoutingScreenController.AdditionalReqDtl additionalReqDtl=new ACET_RoutingScreenController.AdditionalReqDtl();
                ACET_RoutingScreenController.SendToInfo sendToInfo=new ACET_RoutingScreenController.SendToInfo();
               sendToInfo.officeAPI='qwerty';
               sendToInfo.departmentAPI='qwerty';
               sendToInfo.teamAPI='qwerty';
               additionalReqDtl.escalationReason='qwerty';
               additionalReqDtl.isEscalatedValue='qwerty';
               additionalReqDtl.priorExternalId='qwerty';
               additionalReqDtl.expPaymentValue='qwerty';
               additionalReqDtl.days=true;
               additionalReqDtl.doesNotKnow=true;
               additionalReqDtl.Commentvalue='qwerty';
               additionalReqDtl.tatProvided='ghghgjhj';
               demographicInfo.firstNameValue='qwerty';
               demographicInfo.lastNameValue='qwerty';
               demographicInfo.addressValue='qwerty';
               demographicInfo.cityValue='qwerty';
               demographicInfo.stateValue='qwerty';
               demographicInfo.zipCodeValue='qwerty';
               demographicInfo.phone='qwerty';
               demographicInfo.issue ='qwerty';
               demographicInfo.methofDelValue='qwerty';
               demographicInfo.fax ='qwerty';
               claimAddDetails.demographicInfo=demographicInfo;
               claimAddDetails.additionalReqDtl=additionalReqDtl;
               claimAddDetails.sendToInfo=sendToInfo;
               List<StaticResource> responseJSONSR =new List<StaticResource>();
               responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'CaseWrapperForClaims'];

               if(responseJSONSR.size()>0){


                   Object result= ACET_RoutingScreenController.createORSCaseForClaimsUnresolved(responseJSONSR[0].Body.toString(),testCase.Id,claims,claimAddDetails);
               }
         }
      }
    @isTest static void searchMember()
    {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderSearchResponseMock(200));
        SAEMemberProviderWS memProvider = new SAEMemberProviderWS();
        String searchOption = '968780264'+'_'+'firstName'+'_'+'lastName';
        ACETWSCalloutResult ret = memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','valid');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','valid','9999999','9999999');
        Test.stopTest();
    }
    @isTest static void searchMember_errorStatusTest()
    {

        String searchOption = '968780264'+'_'+'firstName'+'_'+'lastName';

        Test.startTest();
        SAEMemberProviderWS memProvider = new SAEMemberProviderWS();
        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'AAA:73'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'AAA:79'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'ED270UG'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'AAA:Fault Code'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'ED270IP'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'ED270BP'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'ED2SS70BP'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(400,'ED270BR'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(404,''));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(404,'AEFNND'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(406,'ED270IA'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(424,'ED270UR'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(424,'AAA:42'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(500,''));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(500,'ED270SE'));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');

        Test.setMock(HttpCalloutMock.class, new ACET_MemberSearchCtrl_Test.WebservicecalloutFrameworkMock(999,''));
        memProvider.getMemberWS('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found');
        memProvider.getMemberDetails('968780264', '01/01/1980','firstName','lastName','898452',searchOption,'989895','providerLastName', 'providerFirstName', '131623978','Provider Not Found','9999999','9999999');
        Test.stopTest();
    }

    @isTest static void testSelectAssociateAPI()
    {
        String officeId='420';
        String departmentCode='CHK';
        String teamCode='DHS';

        Test.startTest();

        List<ACET_SelectAssociateWS.SelectAssociateOutput> names=ACET_RoutingScreenController.callSelectAssociateAPI(officeId,departmentCode,teamCode);
        System.debug('@@ ACET_RoutingScreenControllerTest : names:'+ names);
        String name=names[0].associateName;
        System.assertEquals('SHARMI MITRA',name);
        Test.stopTest();

    }

    @isTest static void testNegativeSelectAssociateAPI1()
    {
        String officeId='720';
        String departmentCode='RHK';
        String teamCode='OHS';
        Test.startTest();

       // Test.setMock(HttpCalloutMock.class, new SelectAssociateMockResponse(200));
        List<ACET_SelectAssociateWS.SelectAssociateOutput> names=ACET_RoutingScreenController.callSelectAssociateAPI(officeId,departmentCode,teamCode);
        System.debug('@@ ACET_RoutingScreenControllerTest : names:'+ names);
        String name=names[0].associateName;
        System.assertEquals('--None--', name);
        Test.stopTest();

    }

     @isTest static void testNegativeSelectAssociateAPI2()
    {
        String officeId='723';
        String departmentCode='RHK';
        String teamCode='OHS';

        Test.startTest();

        List<ACET_SelectAssociateWS.SelectAssociateOutput> names=ACET_RoutingScreenController.callSelectAssociateAPI(officeId,departmentCode,teamCode);
        System.debug('@@ ACET_RoutingScreenControllerTest : names:'+ names);
        String name=names[0].associateName;
        System.assertEquals('--None--', name);
        Test.stopTest();

    }
    @isTest static void testCreateORSCaseForClaimsUnresolved1() {
          User u2=[Select Id,Email,LastName,ProfileId from User where UserName='newProviderServicesTestinguser@Optum.com.acet'];
         System.runAs(u2){
                Case testCase=[Select Id,Status,ORS_Issue_ID__c From Case where Status='Closed'];
                List<ACET_RoutingScreenController.Claim> claims=ACET_RoutingScreenControllerTest.templist;
                ACET_RoutingScreenController.ClaimAddDetails claimAddDetails=new ACET_RoutingScreenController.ClaimAddDetails();
                ACET_RoutingScreenController.DemographicInfo demographicInfo=new ACET_RoutingScreenController.DemographicInfo();
                ACET_RoutingScreenController.AdditionalReqDtl additionalReqDtl=new ACET_RoutingScreenController.AdditionalReqDtl();
                ACET_RoutingScreenController.SendToInfo sendToInfo=new ACET_RoutingScreenController.SendToInfo();
               sendToInfo.officeAPI='qwerty';
               sendToInfo.departmentAPI='qwerty';
               sendToInfo.teamAPI='qwerty';
               additionalReqDtl.escalationReason='qwerty';
               additionalReqDtl.isEscalatedValue='qwerty';
               additionalReqDtl.priorExternalId='qwerty';
               additionalReqDtl.expPaymentValue='qwerty';
               additionalReqDtl.days=true;
               additionalReqDtl.doesNotKnow=true;
               additionalReqDtl.Commentvalue='qwerty';
               additionalReqDtl.tatProvided='ghghgjhj';
               demographicInfo.firstNameValue='qwerty';
               demographicInfo.lastNameValue='qwerty';
               demographicInfo.addressValue='qwerty';
               demographicInfo.cityValue='qwerty';
               demographicInfo.stateValue='qwerty';
               demographicInfo.zipCodeValue='qwerty';
               demographicInfo.phone='qwerty';
               demographicInfo.issue ='Paid Correctly, Pre-Appeal Reconsideration';
               demographicInfo.methofDelValue='qwerty';
               demographicInfo.fax ='qwerty';
               claimAddDetails.demographicInfo=demographicInfo;
               claimAddDetails.additionalReqDtl=additionalReqDtl;
               claimAddDetails.sendToInfo=sendToInfo;
               List<StaticResource> responseJSONSR =new List<StaticResource>();
               responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'CaseWrapperForClaims'];

               if(responseJSONSR.size()>0){
                   //ACET_RoutingScreenController.ORSResultWrapper result= ACET_RoutingScreenController.createORSCaseForClaimsUnresolvedOld(responseJSONSR[0].Body.toString(),testCase.Id,claims,claimAddDetails);
                   //System.assertEquals(testCase.Id, result.caseId);
                   Object result= ACET_RoutingScreenController.createORSCaseForClaimsUnresolved(responseJSONSR[0].Body.toString(),testCase.Id,claims,claimAddDetails);
                   //System.assertNotEquals(result, null);

               }
         }
      }

      static testMethod void createCaseItems(){
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
        String caseVal= '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"Test Test","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"Test","OriginatorPhone":"0112223330","OriginatorEmail":"example@abc.com","SubjectName":"ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"100167575","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(caseVal, SAETTSCaseWrapper.class);
        Map<String,SAECaseCreationController.ORSResultWrapper> orsResultMap = new Map<String,SAECaseCreationController.ORSResultWrapper>();
        SAECaseCreationController.ORSResultWrapper res = new SAECaseCreationController.ORSResultWrapper();
        res.resultStatusMessage = 'test';
        res.orsReturnId = 'testId';
        res.relatedGroupNumber = '52332';
        res.relatedclaimNumber = 'testId';
        res.isResolved = true;
        orsResultMap.put('test',res);
        SAETTSCaseWrapper.ACETCaseItem caseItem = new SAETTSCaseWrapper.ACETCaseItem();
        caseItem.uniqueKey = '52332';
        caseItem.isResolved =  true;
        caseItem.topic = 'View Member Eligibility';
        relatedCaseItemMap.put('0',caseItem);
        caseWrapper.relatedCaseItemsMap = relatedCaseItemMap;
        Map<String,String> policyOrsmap = new Map<String,String>();

        Test.startTest();
        ACET_RoutingScreenController.createCaseItems(orsResultMap,caseWrapper,caseRec,caseRec.Id,policyOrsmap);
        ACET_RoutingScreenController.insertCaseItems(caseRec.Id,caseVal);
        ACET_RoutingScreenController.getRelatedCaseItemMap(caseWrapper);
        Test.stopTest();
      }


     static testMethod void createCaseItemsClaimsTest(){
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
        String caseVal= '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"Test Test","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"Test","OriginatorPhone":"0112223330","OriginatorEmail":"example@abc.com","SubjectName":"ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"100167575","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2", "allrelatedCaseItemMap":{"523119ONEX":{"0":{"uniqueKey":"18A9027070123","isResolved":true,"topic":"View Claims"},"1":{"uniqueKey":"18A902525253","isResolved":true,"topic":"View Claims"},"2":{"uniqueKey":"18A9022531124","isResolved":true,"topic":"View Claims"},"3":{"uniqueKey":"18A902253134","isResolved":true,"topic":"View Claims"},"4":{"uniqueKey":"18A902253132","isResolved":true,"topic":"View Claims"},"5":{"uniqueKey":"18A902253131","isResolved":true,"topic":"View Claims"},"6":{"uniqueKey":"18A902253133","isResolved":false,"topic":"View Claims"}}}}';
        Test.startTest();
        ACET_RoutingScreenController.createCaseItemsClaims(caseVal,caseRec.Id,false);

        Test.stopTest();
      }


}