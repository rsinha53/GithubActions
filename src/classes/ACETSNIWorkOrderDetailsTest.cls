@isTest
public class ACETSNIWorkOrderDetailsTest {
    @testSetup static void setup() {
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User userObj;
         System.runAs(thisUser){

         userObj =  TestDataFactory.getUser('System Administrator');
        userObj.Username='tUserAuth@testorg.acet';
        userObj.FederationIdentifier='tUser';
        INSERT userObj;        
        workOrder workOrderObj = new workOrder();
        workOrderObj.HSC_Unique_ID__c='156627064';
        workOrderObj.Xref_ID__c='625871210';
        workOrderObj.Status_Detail__c	 = 'Prior Authorization Received';
        workOrderObj.Host_System_Date_and_Time__c = datetime.now();
        INSERT workOrderObj;
         }
    }
    @isTest static void getauthorizeDetailsTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpGetAuthResponseGenerator(200,'GetAuthCHSMockResponse'));
        WorkOrder workOrderObj =[select Id,HSC_Unique_ID__c,Xref_ID__c from WorkOrder limit 1].get(0);
        System.debug('workOrderObj'+workOrderObj);
        ACET_GetAuthorizationStatusDetails.AuthDetailsRequest requestObj = new ACET_GetAuthorizationStatusDetails.AuthDetailsRequest();
        requestObj.AUTH_ID = '165591771';
        requestObj.XREF_ID = '962558261';
        ACET_AuthorizationController.SearchResultWrapperAuthStatus response = ACET_AuthorizationController.getAuthorizationStatus(requestObj);
        ACETSNIWorkOrderDetails.getAuthorizeDetails(workOrderObj.Id);
        MockHttpGetAuthResponseGenerator authGen = new MockHttpGetAuthResponseGenerator(200,'GetAuthCHSMockResponse');
        authGen.respond(new HttpRequest());
        Test.stopTest();
    }
}