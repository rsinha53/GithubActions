@isTest
public class ACETLGT_ViewAuthorizationsControllerTest {

    @isTest
    static void testInpatient() {
        Test.startTest();

        List<ACETLGT_AuthorizationSearchResult> resultList = new List<ACETLGT_AuthorizationSearchResult>();
        ACETLGT_AuthorizationSearchResult res1 = new ACETLGT_AuthorizationSearchResult();
        res1.Case_Type_Desc = 'Inpatient';
        resultList.add(res1);
        ACETLGT_ViewAuthorizationsController.getAuthorizationsByType(resultList, 'Inpatient');
            
        Test.stopTest();
    }
    
    @isTest
    static void testOutpatient() {
        Test.startTest();

        List<ACETLGT_AuthorizationSearchResult> resultList = new List<ACETLGT_AuthorizationSearchResult>();
        ACETLGT_AuthorizationSearchResult res1 = new ACETLGT_AuthorizationSearchResult();
        res1.Case_Type_Desc = 'Outpatient';
        resultList.add(res1);
        ACETLGT_ViewAuthorizationsController.getAuthorizationsByType(resultList, 'Outpatient');
            
        Test.stopTest();
    }
    
    @isTest
    static void testInOutpatient() {
        Test.startTest();
        
        List<ACETLGT_AuthorizationSearchResult> resultList = new List<ACETLGT_AuthorizationSearchResult>();
        ACETLGT_AuthorizationSearchResult res1 = new ACETLGT_AuthorizationSearchResult();
        res1.Case_Type_Desc = 'Outpatient Facility';
        resultList.add(res1);
        ACETLGT_ViewAuthorizationsController.getAuthorizationsByType(resultList, 'Outpatient Facility');
        
        Test.stopTest();
    }

    @isTest
    static void testFindAuthorizations() {
        Test.startTest();
        ACETLGT_ViewAuthorizationsController.SearchResultWrapper wr;
        //  Error flow starts
        try{
            wr = ACETLGT_ViewAuthorizationsController.findAuthorizations('', '11/7/1966', 'Joe', 'Root', '11/7/2000', '11/7/2020');
        } catch(Exception ex) {
            System.assert(wr == null);
        }
        //  Error flow ends
        
        //  Success flow starts
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        wr = ACETLGT_ViewAuthorizationsController.findAuthorizations('', '11/7/1966', 'Joe', 'Root', '11/7/2000', '11/7/2020');
        System.assert(wr != null);
        //  Success flow ends
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testGenerateICUEURL() {
        Test.startTest();
        
        List<ACETOrgInstanceURLToOrgNameMap__c> orgNames = new List<ACETOrgInstanceURLToOrgNameMap__c>();
        List<ACETOrgNameToSwivelEndpointMap__c> endPoints = new List<ACETOrgNameToSwivelEndpointMap__c>();
        List<ACETWrapEncryptionKey__c> keys = new List<ACETWrapEncryptionKey__c>();
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap1.Name = 'qaacet--acetqa.cs26';
        orgnamemap1.Org_Name__c = 'qa';
        orgNames.add(orgnamemap1);
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap.Name = 'devacet--acetdev.cs26';
        orgnamemap.Org_Name__c = 'dev';
        orgNames.add(orgnamemap);
            
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        orgNames.add(urlinstance3);
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        orgNames.add(urlinstance4);
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        orgNames.add(urlinstance5);
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'fullcopy';
        urlinstance6.Org_Name__c = 'qa';
        orgNames.add(urlinstance6);
        insert orgNames;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_ICUECreateAuthorization';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        endPoints.add(SwivelEndpoint);
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        endPoints.add(SwivelEndpoint1);
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        endPoints.add(SwivelEndpoint2);
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_ICUECreateAuthorization';
        swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
        endPoints.add(swivel3);
        
        insert endPoints;
                
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='dev_ICUEEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(encryptKey);
                
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_ICUEEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(encryptKey1);
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_ICUEEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(dev1key);
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_ICUEEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        keys.add(prdkey);
        
        insert keys;
        
        String url = ACETLGT_ViewAuthorizationsController.GenerateICUEURL('0123456789', 'David', 'Warner', 'David Warner', 'Member', '111111');
        Test.stopTest();
        System.assert(String.isNotBlank(url));
    }
    
    @isTest
    static void testWrapperAttributes() {
        ACETLGT_AuthorizationSearchResult result = new ACETLGT_AuthorizationSearchResult();
        result.Case_Reason_Code = '';
        result.Case_Reason_Desc = '';
        result.Admit_Date = '';
        result.Dscharg_Date = '';
        result.Actual_End_Date = '';
        result.Actual_Start_Date = '';
        result.CountCode = '';
        result.CountDesc = '';
        result.selected = false;
    }
    
    @isTest
    static void testButtonAccess() {
        Test.startTest();
        
        List<Call_Topic_Access__c> callTopicAccess = new List<Call_Topic_Access__c>();
        callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist Customer Support Team - Agent; Resolution Specialist Customer Support Team - Supervisor; Resolution Specialist - Supervisor'));
        insert callTopicAccess;
        String allowedUser = ACETLGT_ViewAuthorizationsController.buttonAccess('Resolution Specialist - Agent');
        System.assert(allowedUser.equals('true'));
        
        Test.stopTest();
    }
}