@isTest
public class ACETEligibilityUpdControllerTest {
    
    @testsetup
    static void prepareData(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        //WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('EHub Update API', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        
    }
    
    public static testmethod void test1(){
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user us;
        System.runAs(thisUser){
            us=  TestDataFactory.getUser('System Administrator');
            us.Username='tUserEHUPnew@testorg.acet';
            us.FederationIdentifier='tUsernew';
            Insert us;
        }
        
        
        
        Account acc = TestDataFactory.createBulkAccounts().get(0);
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.OwnerId=us.Id;
        acc.Policy_ID__c = '12345';
        acc.Member_ID__c = '78910';
        update acc;
        
        Family_Overview__c fam=new Family_Overview__c();
        fam.Account__c=acc.Id;
        fam.Family_Status__c='Active';
        fam.Family_Needs__c='Low';
        //fam.First_Family_Contact_Into_Center__c='FEC Initiated';
        fam.UHG_Restriction__c='No';
        fam.Onshore_Restriction__c='No';
        insert fam;
        fam.Designation__c='Assigned';
        fam.EHub_Update_Check__c=true;
        Update fam;
        Account personAccount = new Account();
        personAccount.firstName = 'PAccEligFname';
        personAccount.lastName = 'PAccEligLname';
        personAccount.personBirthDate = Date.today();
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        Test.startTest();
        Account pa1 = [select id,personcontactid from account where id =: personAccount.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;
        acr.Accountid = acc.id;
        acr.Policy_Id__c = '12345';
        acr.Member_ID__c = '78910';
        acr.Relationship__c = 'Subscriber/Recipient';
        insert acr;
        Test.stopTest();
        try{
            ACETEligibilityUpdController.updateEHub(fam.Id, 'Family_Overview__c');
        }catch(Exception e){}
        
        
        /*account pa1 = [select id,personcontactid from account where id =: personAccount.id];
AccountContactRelation acr = new AccountContactRelation();
acr.ContactId = pa1.personcontactid;
acr.Accountid = acc.id;
acr.Relationship__c = 'Child/Other';
insert acr;

List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>();
ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
webConfig.Name = 'dev_SNIEligibilityAPI';
webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v4/search';
webConfigList.add(webConfig);

ISL_Webservice_Config__c webConfig1 = new ISL_Webservice_Config__c();
webConfig1.Name = 'dev_DesignationUpdateAPI';
webConfig1.ACET_Common_Name__c = 'DesignationUpdateAPI';
webConfig1.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/designations/v1';
webConfigList.add(webConfig1);

ISL_Webservice_Config__c webConfig2 = new ISL_Webservice_Config__c();
webConfig2.Name = 'SNIAPIAccessToken';
webConfig2.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
webConfig2.ACET_Common_Name__c = 'SNIApiEndpoint';
webConfigList.add(webConfig2);

ISL_Webservice_Config__c webConfig3 = new ISL_Webservice_Config__c();
webConfig3.Name = 'dev_SNIEligibiltyUpdateAPI';
webConfig3.ACET_Common_Name__c = 'SNIEligibiltyUpdateAPI';
webConfig3.Value__c = 'https://gateway-stage-dmz.optum.com/api/dev/cel/sni-riptide/families/v2';
webConfigList.add(webConfig3);

insert webConfigList;*/
        
    }
    
    public static testmethod void test2(){
        Account acc = TestDataFactory.createBulkAccounts().get(0);
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.OwnerId=UserInfo.getUserId();
        update acc;
        
        Account personAccount = new Account();
        personAccount.firstName = 'PAccEligHubApiFname';
        personAccount.lastName = 'PAccEligHubApiLname';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        
        Member_Information__c memInfo = new Member_Information__c();
        memInfo.Account__c = personAccount.id ;
        insert memInfo;
        memInfo.Behavioral_Condition__c = 'test';
        memInfo.EHub_Update_Check__c = true;
        update memInfo;
        
        Account pa1 = [select id,personcontactid from account where id =: personAccount.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;
        acr.Accountid = acc.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        try{
            ACETEligibilityUpdController.updateEHub(memInfo.Id, 'Member_Information__c');
        }catch(Exception e){}
        try{
            ACETEligibilityUpdController.updateEHub(pa1.Id, 'Account');
        }catch(Exception e){}
        try{
            ACETEligibilityUpdController.updateEHub(acc.Id, 'Account');
        }catch(Exception e){}
    }
    
    public static testmethod void test3(){
        ACETEligibilityUpdController.getErrorMessage('');
    }
    /*
@isTest static void EligibilityHubApiAccount_200() 
{
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(200,'ACETDesignationMockResponse'));
Account accRec = [Select Id,EHub_Update_Check__c from Account limit 1].get(0);
ACETEligibilityUpdController.SearchResultWrapper returnWrapperMemInf = ACETEligibilityUpdController.updateEHub(accRec.id,'Account');
//System.assertEquals(200, returnWrapperMemInf.statusCode);
Test.stopTest();
}


@isTest static void EligibilityHubApi_200() 
{
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(200,'ACETDesignationMockResponse'));
Member_Information__c memInfo = [Select Id,EHub_Update_Check__c from Member_Information__c limit 1].get(0);
//ACETDesignationUpdRequest designationUpdParse = ACETDesignationUpdRequest.parse('{"acetFamilyId":"memInfo.id","adviserMsId":"memInfo.id","advisorFullName":"Frank","designation":"Advisor"}');
ACETEligibilityUpdController.SearchResultWrapper returnWrapperMemInf = ACETEligibilityUpdController.updateEHub(memInfo.id,'Member_Information__c');
System.assertEquals(200, returnWrapperMemInf.statusCode);
Test.stopTest();
}

@isTest static void EligibilityHubApi_400() 
{
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(400,'ACETDesignationMockResponse'));
Member_Information__c memInfo = [Select Id,EHub_Update_Check__c from Member_Information__c limit 1].get(0); 
ACETEligibilityUpdController.SearchResultWrapper returnWrapperMemInf = ACETEligibilityUpdController.updateEHub(memInfo.id,'Member_Information__c');
System.assertEquals(400, returnWrapperMemInf.statusCode);
Test.stopTest();
}
@isTest static void EligibilityHubApi_401() 
{
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(401,'ACETDesignationMockResponse'));
Member_Information__c memInfo = [Select Id,EHub_Update_Check__c from Member_Information__c limit 1].get(0);
ACETEligibilityUpdController.SearchResultWrapper returnWrapperMemInf = ACETEligibilityUpdController.updateEHub(memInfo.id,'Member_Information__c');
System.assertEquals(401, returnWrapperMemInf.statusCode);
Test.stopTest();
}
@isTest static void EligibilityHubApi_404() 
{
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(404,'ACETDesignationMockResponse'));
Member_Information__c memInfo = [Select Id,EHub_Update_Check__c from Member_Information__c limit 1].get(0);
ACETEligibilityUpdController.SearchResultWrapper returnWrapperMemInf = ACETEligibilityUpdController.updateEHub(memInfo.id,'Member_Information__c');
System.assertEquals(404, returnWrapperMemInf.statusCode);
Test.stopTest();
}
@isTest static void EligibilityHubApi_500() 
{
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(500,'ACETDesignationMockResponse'));
Member_Information__c memInfo = [Select Id,EHub_Update_Check__c from Member_Information__c limit 1].get(0);
ACETEligibilityUpdController.SearchResultWrapper returnWrapperMemInf = ACETEligibilityUpdController.updateEHub(memInfo.id,'Member_Information__c');
System.assertEquals(500, returnWrapperMemInf.statusCode);
Test.stopTest();
}
@isTest static void EligibilityHubApi_513() 
{
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(513,'ACETDesignationMockResponse'));
Member_Information__c memInfo = [Select Id,EHub_Update_Check__c from Member_Information__c limit 1].get(0);
ACETEligibilityUpdController.SearchResultWrapper returnWrapperMemInf = ACETEligibilityUpdController.updateEHub(memInfo.id,'Member_Information__c');
System.assertEquals(513, returnWrapperMemInf.statusCode);
Test.stopTest();
}

@isTest static void ACETDesinationUpdMethod_200() 
{

Test.startTest();
Family_Overview__c fam = [Select Id from Family_Overview__c limit 1].get(0);
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(200,'ACETDesignationMockResponse'));
ACETEligibilityUpdController.SearchResultWrapper returnWrapper = ACETEligibilityUpdController.updateEHub(fam.id,'Family_Overview__c');
System.assertEquals(200, returnWrapper.statusCode);
Test.stopTest();
}

@isTest static void ACETDesinationUpdMethod_500() 
{

Test.startTest();
Family_Overview__c fam = [Select Id from Family_Overview__c limit 1].get(0);
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(500,'ACETDesignationMockResponse'));
ACETEligibilityUpdController.SearchResultWrapper returnWrapper = ACETEligibilityUpdController.updateEHub(fam.id,'Family_Overview__c');
System.assertEquals(500, returnWrapper.statusCode);
Test.stopTest();
}

@isTest static void ACETDesinationUpdMethod_400() 
{

Test.startTest();
Family_Overview__c fam = [Select Id from Family_Overview__c limit 1].get(0);
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(400,'ACETDesignationMockResponse'));
ACETEligibilityUpdController.SearchResultWrapper returnWrapper = ACETEligibilityUpdController.updateEHub(fam.id,'Family_Overview__c');
System.assertEquals(400, returnWrapper.statusCode);
Test.stopTest();
}

@isTest static void ACETDesinationUpdMethod_404() 
{

Test.startTest();
Family_Overview__c fam = [Select Id from Family_Overview__c limit 1].get(0);
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(404,'ACETDesignationMockResponse'));
ACETEligibilityUpdController.SearchResultWrapper returnWrapper = ACETEligibilityUpdController.updateEHub(fam.id,'Family_Overview__c');
System.assertEquals(404, returnWrapper.statusCode);
Test.stopTest();
}

@isTest static void ACETDesinationUpdMethod_999() 
{
Test.startTest();
Family_Overview__c fam = [Select Id from Family_Overview__c limit 1].get(0);
Test.setMock(HttpCalloutMock.class, new MockHttpEHUBResponseGenerator(999,'ACETDesignationMockResponse'));
ACETEligibilityUpdController.SearchResultWrapper returnWrapper = ACETEligibilityUpdController.updateEHub(fam.id,'Family_Overview__c');
System.assertEquals(999, returnWrapper.statusCode);
Test.stopTest();
}
@isTest static void ACETDesinationUpdFailureMethod() 
{

Test.startTest();
Family_Overview__c fam = [Select Id from Family_Overview__c limit 1].get(0);
String responseJSON = '{"status":{"messages":[{"code":"500","name":"failure","severity":"low","description":"Internal server error"}]}}';
system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
MockHttpCalloutResponseGenerator.MockHttpResponse designationResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', responseJSON);
Test.setMock(HttpCalloutMock.class, new MockHttpCalloutResponseGenerator(null,designationResponse));
ACETEligibilityUpdController.SearchResultWrapper returnWrapper = ACETEligibilityUpdController.updateEHub(fam.id,'Family_Overview__c');
Test.stopTest();
}*/
}