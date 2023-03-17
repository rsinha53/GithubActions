@isTest public class ADBClientEventTrackerControllerTest {
    
    @testSetup static void setup() {
        String baseURL = 'https://gateway-stage.optum.com/api/test/cdm/cust/ocm-oam-service/v1';
        // create test data for custom setting
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
                new WebserviceConfigurations__c(Name = 'ADBClientEventSearchTemplateList',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBClientEventGetTemplateById',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBClientEventSearchAssessmentList',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBClientEventGetAssessmentById',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBClientEventSaveAssessment',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000)
                };                
                    insert configs;
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,Name = 'QA',recordtypeText__c = 'TokenAPI',EndpointDomain__c = baseURL + '/searchTemplateList'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,Name = 'QA',recordtypeText__c = 'TokenAPI',EndpointDomain__c = baseURL + '/getTemplateById'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[2].Id,Name = 'QA',recordtypeText__c = 'TokenAPI',EndpointDomain__c = baseURL + '/searchAssessmentList'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[3].Id,Name = 'QA',recordtypeText__c = 'TokenAPI',EndpointDomain__c = baseURL + baseURL + '/getAssessmentById'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[4].Id,Name = 'QA',recordtypeText__c = 'TokenAPI',EndpointDomain__c = '/saveAssessment')
        };
        insert orgConfigs;
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
    }   
    // To test fetchSearchTemplateListService
    @isTest static void checkSearchTemplateListService (){
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBSearchTemplateListResp');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        ADBClientEventTrackerController.fetchSearchTemplateListService();
        test.stopTest(); 
    }
    // To test fetchGetTemplateByIdService
    @isTest static void checkGetTemplateByIdService (){
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBGetTemplateByIdResp');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        ADBClientEventTrackerController.fetchGetTemplateByIdService('3434344');
        test.stopTest(); 
    }
    //method to test fetchSearchAssessmentListService
    @isTest static void checkSearchAssessmentListService (){
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBSearchAssessmentListResp');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        ADBClientEventTrackerController.fetchSearchAssessmentListService('3434344', '10276', '9597', '2');
        test.stopTest(); 
    }
    // To test fetchGetAssessmentByIdService
    @isTest static void checkGetAssessmentByIdService (){
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBGetAssesmentByIdResp');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        ADBClientEventTrackerController.fetchGetAssessmentByIdService('3434344');
        test.stopTest(); 
    }
    @isTest static void fetchSaveService(){
        test.startTest();   
        String reqStr = '{    "assessmentID": "297016",    "conductedByUserID": "hrachako",    "conductedByUserName": "RACHAKONDA, HARISH",        "assessmentTemplateID": "10276",    "totalScoreNumber": "0",    "assessmentStatusTypeID": "1",    "assessmentStatusReasonTypeID": "",    "deliveryMethodTypeID": "0",    "builderAssessmentID": "9597",    "builderAssessmentVersionNumber": "1",    "groupTotalScoreNumber": "0",    "totalAvgQuestScore": "0",    "assessmentResponseVOs": [],    "assessmentResponseChoiceVOs": [        {            "questionID": "Q13665",            "responseChoiceID": "1"        },        {            "questionID": "Q13665",            "responseChoiceID": "2"        },        {            "questionID": "Q13665",            "responseChoiceID": "3"        },        {            "questionID": "Q13665",            "responseChoiceID": "7"        },        {            "questionID": "Q13666",            "responseChoiceID": "1"        }    ],	"completedCheckList": [        {            "questionID": "Q13665",            "choiceID": "1"        },        {            "questionID": "Q13665",            "choiceID": "2"        },        {            "questionID": "Q13665",            "choiceID": "3"        },        {            "questionID": "Q13665",            "choiceID": "7"        },        {            "questionID": "Q13666",            "choiceID": "1"        }    ],    "assessmentResponseGridVOs": [],    "assessmentSubjectVOs": [        {            "primarySubjectIndicator": "1",            "sourceApplicationType": "73",            "sourceApplicationSubjectTypeID": "6",            "sourceApplicationSubjectID": "1174010"        }    ],    "parentAssessmentID": "0",    "timeZoneOffset": "Etc/GMT",    "sourceApplicationType": "73",	"sourceApplicationSubjectID":"323",    "userID": "hrachako"}';
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBSaveAssessmentResp');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        ADBClientEventTrackerController.fetchSaveService(reqStr, 63);
        test.stopTest();
    }
	
	@isTest static void coverADBTransactionsWrapperFunction(){
        test.startTest();
        ADBCETGetTemplateByIdUIWrapper tempId = new ADBCETGetTemplateByIdUIWrapper();
        tempId.assessmentTemplateID = '10276';
        tempId.availableList =null;
        tempId.builderAssessmentID = '9597';
        tempId.builderAssessmentVersionNumber = '1';
        tempId.modalList = null;
        test.stopTest();
    }
    //TO test fetchGetIcueMemberIdService
     @isTest static void checkGetIcueMemberIdService (){
           test.startTest();
           StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
           mock.setStaticResource('ADBIcueMemberIdResp');
           mock.setStatusCode(200);
           Test.setMock(HttpCalloutMock.class, mock);
           String sourceMemberID = '123456789';
           ADBClientEventTrackerController.fetchGetIcueMemberIdService(sourceMemberID);
           test.stopTest();
       }
    @isTest static void checkGetIcueMemberIdWrapper (){
        test.startTest();
        
        String reqStr = '{"memberSearchResponse": {"responseHeader": {"serviceCallStatusCode": "Success","serviceCallStatus": ""},"sensitiveData": false,"memberSearchResultList": {"memberSearchResult": {"icueMemberId": 1428010,"firstName": "HARRIS","middleName": "","lastName": "THERIAULT","dateOfBirth": "1968-11-10T00:00:00-06:00","memberIdentifier": {"idType": 1,"memberId": "00879122193"},"baseAddress": {"addressType": 1,"addressLine1": "813 GRAND VIEW DRIVE","addressLine2": "","city": "CHICAGO","state": "IL", "countyName": "COOK","zip": 60647,"zipSuffix": "","countryCode": "US"}}}}}';
        ADBCETGetIcueMemberIdResponseWrapper.parse(reqStr);
        test.stopTest(); 
    }
    
    @isTest static void coverADBCETGetIcueMemberIdResponseWrapper() {
        ADBCETGetIcueMemberIdResponseWrapper.MemberSearchResult msr = new ADBCETGetIcueMemberIdResponseWrapper.MemberSearchResult();
        msr.icueMemberId = '';
        
        ADBCETGetIcueMemberIdResponseWrapper agimirw = new ADBCETGetIcueMemberIdResponseWrapper();
        agimirw.memberSearchResult = msr;
    }
}