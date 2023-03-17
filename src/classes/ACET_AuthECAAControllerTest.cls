@isTest
public class ACET_AuthECAAControllerTest {

    @testSetup static void testSetupMethod() {
        
        INSERT new ACETOrgInstanceURLToOrgNameMap__c(Name = 'fullcopy',Org_Name__c = 'qa');   
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c();
        apiEndpointSetting.Name = 'qa_EDMSEndpoint';
        apiEndpointSetting.Is_Available__c = true;
        apiEndpointSetting.Value__c = 'https://edms-cdms-dev.uhc.com/ecaa/resources/?viewDocument=';
        Insert apiEndpointSetting;
    }

    @isTest static void findECAATest(){
                
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACET_AuthECAALetterResponse'];
        responseStr = responseJSONSR.Body.toString();  
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', responseStr);      
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        Test.startTest();
        ACET_AuthECAAController.findECAA('A083883182');
        ACET_AuthECAAController.getEDMSLink();
        Test.stopTest();
    }
    
        @isTest static void findECAA500Error(){
                
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACET_AuthECAALetterResponse'];
        responseStr = null;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', responseStr);      
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        Test.startTest();
        ACET_AuthECAAController.findECAA('A083883182');
        Test.stopTest();
    }
}