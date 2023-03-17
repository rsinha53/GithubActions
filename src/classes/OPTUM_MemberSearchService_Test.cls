/*
 Name           : OPTUM_MemberSearchService_Test
 Created By     :(Prasad kammella)
 Created Date   : Sep 14th, 2020
 Description    : Code coverage for OPTUM_MemberSearchService 
 */
@isTest
public with sharing class OPTUM_MemberSearchService_Test {
 public static String endDomain='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v2.0';
 public static String endDomain2 ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v4.0/lookup';
 public static String endDomain3= 'https://stg-api-faro.optum.com/faro/financial/accounts/v3.0';
 public static String header1 = '[{"key":"FAROID","value":"<:FARO_ID:>"},{"key":"Content-Type","value":"application/json"}]';
 public static String header2 = '[{"key":"Content-Type","value":"application/json"}]';

    @isTest static void testCallout() {
        String faroId='73939F194FBA4104E053326C750A8837';
        Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
        orgProps1.OrganizationName__c = 'Rollstonqa';
        Upsert orgProps1;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumVCCDMemberSearch',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'GET',
            Headers__c = header1,
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert tokenAPIWSConfig;
        OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c =endDomain2,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c =endDomain2,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('OptumMemberserviceresponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        Test.startTest();
        OPTUM_VCCDBridgeController.getMemberDetails(faroId);
        Test.stopTest();
    }
    //Test Methods for searchtranactions method
    @isTest static void testCallout2() {
        String syntheticId = 'NHw5MDQwMzczMzN8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==';
        String employerAlias = 'B22222';
        Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
        orgProps1.OrganizationName__c = 'Rollstonqa';
        Upsert orgProps1;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumTransactionsEndPoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'GET',
            Headers__c = '[{"key":"Content-Type","value":"application/json"},{"key":"Host","value":"stg-faro-dmz-api.optum.com"}]',
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert tokenAPIWSConfig;
        OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c =endDomain3,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c =endDomain3,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('OptumTransactionResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        Test.startTest();
        OPTUM_MemberSearchService.searchtranactions(syntheticId,employerAlias);
        Test.stopTest();
    }
    //Testmethod for AccountactivityService API
    @isTest static void testCallout3() {
        String syntheticId = 'MnwwMDA2NzY5MTMzfDAwMDAyMjk0NTJ8T1BUfE1lZGljYWxGbGV4fDkxNzY0NXxudWxs';
        Integer nonExpiringPlan = 2;
        String acctPlanYearEffectiveDate = '2020-01-01';
        String acctPlanYearExpirationDate = '2020-12-31';
        String acctOpenedDate = '2020-01-01';
        String employerAlias = 'B22222';
        Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
        orgProps1.OrganizationName__c = 'Rollstonqa';
        Upsert orgProps1;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumAccountActivityEndpoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'GET',
            Headers__c = header2,
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert tokenAPIWSConfig;
        OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c =endDomain3,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c =endDomain3,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('OptumAccountactivityResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        Test.startTest();
        OPTUM_MemberSearchService.getTransactions(syntheticId, nonExpiringPlan, acctPlanYearEffectiveDate, acctPlanYearExpirationDate, acctOpenedDate, employerAlias);
        Test.stopTest();
    }
    //Test Class method for External Account API
    @isTest static void testCallout4() {
        String syntheticId = 'NHw5MDQyNTgxNTF8bnVsbHxPUFR8SFNBfG51bGx8NjA1NzY5';
        Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
        orgProps1.OrganizationName__c = 'Rollstonqa';
        Upsert orgProps1;
       Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumExternalAccountEndpoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'GET',
            Headers__c = '[{"key":"Content-Type","value":"application/json"},{"key":"Host","value":"stg-faro-dmz-api.optum.com"}]',
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert tokenAPIWSConfig;
        OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c =endDomain,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c =endDomain,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('OptumExternalAccountsResponse');
            mock.setStatusCode(200);
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);  
         Test.startTest();
        OPTUM_MemberSearchService.externalaccounts(syntheticId);
         Test.stopTest();
    } 
    @isTest static void testCallout5() {
 	    String ssn = '975144482';
        Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
        orgProps1.OrganizationName__c = 'Rollstonqa';
        Upsert orgProps1;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        WebserviceConfigurations__c tokenAPIWSConfigur = new WebserviceConfigurations__c(
            Name = 'StarGateTokenAPI',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Token_API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]',
            AuthorizationToken__c = '',
            IsCachedToken__c=true,
            GrantType__c = 'client_credentials',
            EndpointPath__c ='/auth/oauth2/cached/token',
            Timeout__c = 10000
       );
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumManualAlert',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"}]',
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            TokenAPI__c=tokenAPIWSConfigur.Id
       );
        Insert tokenAPIWSConfig;
        OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c ='https://gateway-stage.optum.com/api/stage/fin/ftps/account-informations/v1/GetAccountInfoByFirstLastSSN',
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c ='https://gateway-stage.optum.com/api/stage/fin/ftps/account-informations/v1/GetAccountInfoByFirstLastSSN',
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('OptumManualAlertsResponse');
        mock.setStatusCode(200);
         // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        Test.startTest();
        OPTUM_MemberSearchService.getManualAlerts(ssn);
        Test.stopTest();
    }
	//Testmethod for UpdateDemographics API
    @isTest static void testCallout7() {
        String faroId = '73939F194FBA4104E053326C750A8837';
        String emailId = 'sanjaypandey@optum.com';
        String mAddessLine1 = '111 Queen St';
        String mAddessLine2 = 'P.O. Box 123';
        String mAddressCity = 'Tampa';
        String mAddressState = 'FL';
        String pMobile = '9206549874';
        String pWork = '9206549874';
        String pHome = '9206549874';
        String phonePreferred = 'W';
        String wBrandId = 'EXANT';
        String zip = '96321';
        String zipPlus4 = '6514';
        Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
        orgProps1.OrganizationName__c = 'Rollstonqa';
        Upsert orgProps1;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumUpdateDemographicsEndPoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'GET',
            Headers__c = '[{"key":"FAROID","value":"<:FARO_ID:>"},{"key":"userId","value":"<:user_Id:>"},{"key":"Content-Type","value":"application/json"}]',
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert tokenAPIWSConfig;
        OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c =endDomain,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c =endDomain,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('OptumUpdateDemographicsResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        Test.startTest();
        OPTUM_MemberSearchService.updateDemographics(faroId, emailId, mAddessLine1, mAddessLine2, mAddressCity, mAddressState, pMobile, pWork, pHome, phonePreferred, wBrandId, zip, zipPlus4);
        Test.stopTest();
    }
//Testmethod for memberWithAdvanceSearch
    @isTest static void testCallout8() {
        String firstName ='JOYCELYN';
        String lastName = 'HOYT';
        String dob ='10/16/1976';
        String accountNumber ='123456';
        String email = 'desham.sangeetha@optum.com';
        String ssn = '2087';

        String firstName1 ='';
        String lastName1 = '';
        String dob1 ='';
        String accountNumber1 ='';
        String email1 = '';
        String ssn1 = '';

        Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
        orgProps1.OrganizationName__c = 'Rollstonqa';
        Upsert orgProps1;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumAdvanceMemberSearchEndPoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = header2,
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert tokenAPIWSConfig;
        OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c ='https://stg-faro-gateway.optumbank.com/faro/financial/accounts/v1.0/accountholder',
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c ='https://stg-faro-gateway.optumbank.com/faro/financial/accounts/v1.0/accountholder',
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
        Test.startTest();
        // Creating mock response using Static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('OptumAdvanceSearch');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        if (accountNumber != null) {
           OPTUM_MemberSearchService.memberWithAdvanceSearch(ssn1,dob1,accountNumber,email1,firstName1,lastName1);
        }
        // Creating mock response using Static resource
        StaticResourceCalloutMock mock1 = new StaticResourceCalloutMock();
        mock1.setStaticResource('OptumAdvanceSearch');
        mock1.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock1);
        if(firstName !=null && lastName !=null && dob !=null){
           OPTUM_MemberSearchService.memberWithAdvanceSearch(ssn1,dob,accountNumber1,email1,firstName,lastName);
        }
         // Creating mock response using Static resource
        StaticResourceCalloutMock mock2 = new StaticResourceCalloutMock();
        mock2.setStaticResource('OptumAdvanceSearch');
        mock2.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock2);
        if(email !=null){
           OPTUM_MemberSearchService.memberWithAdvanceSearch(ssn1,dob1,accountNumber1,email,firstName1,lastName1);
        }
        // Creating mock response using Static resource
        StaticResourceCalloutMock mock3 = new StaticResourceCalloutMock();
        mock3.setStaticResource('OptumAdvanceSearch');
        mock3.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock3);
        if(ssn !=null && lastName !=null){
           OPTUM_MemberSearchService.memberWithAdvanceSearch(ssn,dob1,accountNumber1,email1,firstName1,lastName);
        }
        Test.stopTest();

    }
    //Test Class method for Notification
        @isTest static void testCallout9() {
            String syntheticId1 = '';
            String faroId1 = '';
            Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
            orgProps1.OrganizationName__c = 'Rollstonqa';
            Upsert orgProps1;
            Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
            orgProps.OrganizationName__c = 'QA';
            Upsert orgProps;
            WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumNotificationPreferenceEndPoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'GET',
            Headers__c = header1,
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
            );
            Insert tokenAPIWSConfig;
            OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
            Name ='qa',
            EndpointDomain__c =endDomain,
            WebserviceConfigurations__c=tokenAPIWSConfig.Id
            );
            Insert orgsp;
            OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
            Name ='Rollstonqa',
            EndpointDomain__c =endDomain,
            WebserviceConfigurations__c=tokenAPIWSConfig.Id
            );
            Insert orgsp2;
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('OptumNotificationsResponse');
            mock.setStatusCode(200);
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);  
            Test.startTest();
            OPTUM_MemberSearchService.notifications(syntheticId1,faroId1);
            Test.stopTest();
        }
        //Test Class method for View All Cards
        @isTest static void testCallout10() {
            String syntheticId1 = '';
            String faroId1 = '';
            String accountAlias1='';
            String accountId1='';
            Integer accountCode1;
            String employerId1='';

            Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
            orgProps1.OrganizationName__c = 'Rollstonqa';
            Upsert orgProps1;
            Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
            orgProps.OrganizationName__c = 'QA';
            Upsert orgProps;
            WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumDebitCardsEndpoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = header1,
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
            );
            Insert tokenAPIWSConfig;
            OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v4.0/cards',
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
            );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v4.0/cards',
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
            );
            Insert orgsp2;
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('OptumDebitcardResponse');
            mock.setStatusCode(200);
           // Set the mock callout mode
           Test.setMock(HttpCalloutMock.class, mock);  
           Test.startTest();
           OPTUM_MemberSearchService.getDebitCards(faroId1,syntheticId1,accountAlias1,accountId1,accountCode1,employerId1);
           Test.stopTest();
          }
        //Testmethod for Show additional claim details
            @isTest static void testCallout11() {
                String faroId = '73939F194FBA4104E053326C750A8837';
                String accountId = '904258151';
                String claimNumber = 'OPTP69070201203W0000101';
                String syntheticId = 'NHw5MDQyNTgxNTF8bnVsbHxPUFR8SFNBfG51bGx8NjA1NzY5';
            Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
                orgProps1.OrganizationName__c = 'Rollstonqa';
                Upsert orgProps1;
            Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
                orgProps.OrganizationName__c = 'QA';
                Upsert orgProps;
            WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
                Name = 'OptumRMIandAdmitNotesEndpoint',
                RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
                Method__c = 'POST',
                Headers__c = header1,
                AuthorizationToken__c = '',
                Timeout__c = 10000,
                Has_Mutual_Authentication__c =true
              );
           Insert tokenAPIWSConfig;
           OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
                  RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
                  Name ='qa',
                  EndpointDomain__c ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v1.0/wexHistory',
                  WebserviceConfigurations__c=tokenAPIWSConfig.Id
           );
           Insert orgsp;
           OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
                  RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
                  Name ='Rollstonqa',
                  EndpointDomain__c ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v1.0/wexHistory',
                  WebserviceConfigurations__c=tokenAPIWSConfig.Id
           );
           Insert orgsp2;
           StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
           mock.setStaticResource('OptumAdditionalClaimDetailsResponse');
           mock.setStatusCode(200);
           // Set the mock callout mode
           Test.setMock(HttpCalloutMock.class, mock);  
           Test.startTest();
           OPTUM_MemberSearchService.showAddClaimsDetails(faroId, accountId, claimNumber, syntheticId);
           Test.stopTest();
            }
            //Testmethod for investment Summery
            @isTest static void testCallout12() {
            String syntheticId = 'NHwyNzAwMDAwMDB8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==';
            Organization_Properties__c orgProps1 = Organization_Properties__c.getOrgDefaults();
            orgProps1.OrganizationName__c = 'Rollstonqa';
            Upsert orgProps1;
            Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
            orgProps.OrganizationName__c = 'QA';
            Upsert orgProps;
            WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'OptumInvestmentsEndpoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'GET',
            Headers__c = header2,
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
            );
            Insert tokenAPIWSConfig;
            OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
            Name ='qa',
            EndpointDomain__c ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v4.0',
            WebserviceConfigurations__c=tokenAPIWSConfig.Id
           );
            Insert orgsp;
            OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
            Name ='Rollstonqa',
            EndpointDomain__c ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v4.0',
            WebserviceConfigurations__c=tokenAPIWSConfig.Id
           );
          Insert orgsp2;
          StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
          mock.setStaticResource('OptumInvestmentSummeryResponse');
          mock.setStatusCode(200);
        // Set the mock callout mode
          Test.setMock(HttpCalloutMock.class, mock);  
          Test.startTest();
          OPTUM_MemberSearchService.investmentSummery(syntheticId);
          Test.stopTest();
           }
		  @isTest static void testCalloutMemberSearch() {
         String ssn = '{"ssn" : "' + 920003129 + '",' + '"dob":"1992-02-27",' + '"filterDetails" : false }';
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap1.Name = 'rollstone';
        orgnamemap1.Org_Name__c = 'qa';
        insert orgnamemap1;
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap2 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap2.Name = 'Develop';
        orgnamemap2.Org_Name__c = 'dev';
        insert orgnamemap2;
       
	    Organization_Properties__c oProp = Organization_Properties__c.getOrgDefaults();
        oProp.OrganizationName__c = 'Rollstonqa';
        Upsert oProp;
        Organization_Properties__c oProp2 = Organization_Properties__c.getOrgDefaults();
        oProp2.OrganizationName__c = 'QA';
        Upsert oProp2;
        WebserviceConfigurations__c toknAPICnf = new WebserviceConfigurations__c(
            Name = 'OptumMemberSearchEndpoint',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Service_API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = header2,
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert toknAPICnf;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c =endDomain2,
               WebserviceConfigurations__c=toknAPICnf.Id
        );
        Insert orgsp2;
        OrgSpecificConfigurations__c orgsp3 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get('ServiceAPI').getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c =endDomain2,
               WebserviceConfigurations__c=toknAPICnf.Id
        );
        Insert orgsp3;
        StaticResourceCalloutMock mock1 = new StaticResourceCalloutMock();
        mock1.setStaticResource('OptumMemberserviceresponse');
        mock1.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock1);
        Test.startTest();
        if (ssn != null) {
            OPTUM_MemberSearchService.searchMemberWithSSN(ssn);
        } 
		Test.stopTest();
     }
     //US3243924   
    @isTest static void notionalAutodocAccountDetails(){
        OPTUM_MemberSearchService.NotionalAccountDetails wrapcls = new OPTUM_MemberSearchService.NotionalAccountDetails();
        wrapcls.submittedClaims = '3.28';
        wrapcls.pendingClaims = '2.14' ;
        wrapcls.deniedClaims = '3.44' ;
        wrapcls.paidClaims = '2.18' ;
      List <OPTUM_MemberSearchService.NotionalAccountDetails> wrapList = new List <OPTUM_MemberSearchService.NotionalAccountDetails>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.setCredentialData(wrapList);
    } 

  //US3243924
    @isTest static void notionalAutodocExternalDetails(){
        OPTUM_MemberSearchService.NotionalAccount wrap = new OPTUM_MemberSearchService.NotionalAccount();
        wrap.nickname = 'NICKNAME1';
        wrap.bankName = 'ZIONS BANCORPORATION, NA D' ;
        wrap.bankRoutingNumber = '124000054' ;
        wrap.bankAccountNumber = '550000338' ;
		wrap.bankAccountType = 'Checking';
        wrap.bankAccountStatus = 'Verified' ;
        wrap.cmpdateAdded = '11/21/2017' ;
        wrap.cmpdateVerified = '11/21/2017' ;
		wrap.hasScheduledTransactions = 'false' ;
        List <OPTUM_MemberSearchService.NotionalAccount> wrapList = new List <OPTUM_MemberSearchService.NotionalAccount>();
        wrapList.add(wrap);
        OPTUM_MemberSearchService.getautoDocExternalAccounts(wrapList);
    } 
	//US3254502   
    @isTest static void investmentSweepAutodoc(){
        OPTUM_MemberSearchService.InvestSweepDetails wrapcls = new OPTUM_MemberSearchService.InvestSweepDetails();
        wrapcls.status = 'Inactive';
        wrapcls.threshold = '0' ;
        wrapcls.account = '' ;
       List <OPTUM_MemberSearchService.InvestSweepDetails> wrapList = new List <OPTUM_MemberSearchService.InvestSweepDetails>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getautoDocInvestmentSweep(wrapList);
    }
    //US3254502   
    @isTest static void investmentDetailsAutodoc(){
        OPTUM_MemberSearchService.InvestDetails wrapcls = new OPTUM_MemberSearchService.InvestDetails();
        wrapcls.title = 'Mutual Funds';
        wrapcls.balance = '0' ;
        wrapcls.status = 'Investment allowed' ;
        wrapcls.plan = '3.28';
        wrapcls.cashBalance = '2.14' ;
        wrapcls.investThreshold = '2000' ;
       List <OPTUM_MemberSearchService.InvestDetails> wrapList = new List <OPTUM_MemberSearchService.InvestDetails>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getautoDocInvestment(wrapList);
    }
	//for auto doc contributions
	 @isTest static void autoDocContributionsForCy(){
        OPTUM_MemberSearchService.Contribution wrap = new OPTUM_MemberSearchService.Contribution();
        wrap.cyFilingStatus = 'Family';
        wrap.cyContributionLimit = '7100' ;
        wrap.cyEmployeeContribution = '10' ;
        wrap.cyEmployerContribution = '0' ;
		wrap.pyEmployeeContributionForCy = '10';
        wrap.pyEmployerContributionForCy = '0' ;
        wrap.totalContribution='10';
        List <OPTUM_MemberSearchService.Contribution> wrapList = new List <OPTUM_MemberSearchService.Contribution>();
        wrapList.add(wrap);
        OPTUM_MemberSearchService.getautoDocContributions(wrapList);
    }
    @isTest static void autoDocContributionsForPy(){
        OPTUM_MemberSearchService.ContributionForPy wrap = new OPTUM_MemberSearchService.ContributionForPy();
        wrap.pyFilingStatus = 'Family';
        wrap.pyContributionLimit = '7100' ;
        wrap.pyEmployeeContribution = '10' ;
        wrap.pyEmployerContribution = '0' ;
        wrap.totalPrevious='10';
        List <OPTUM_MemberSearchService.ContributionForPy> wrapList = new List <OPTUM_MemberSearchService.ContributionForPy>();
        wrapList.add(wrap);
        OPTUM_MemberSearchService.getautoDocContpreviousyear(wrapList);
    }
	// for notification
	 @isTest static void notification(){
        OPTUM_MemberSearchService.NotificationList wrapcls = new OPTUM_MemberSearchService.NotificationList();
        wrapcls.documents = 'Account Statments ';
        wrapcls.preference = 'Paper ';
        List <OPTUM_MemberSearchService.NotificationList> wrapList = new List <OPTUM_MemberSearchService.NotificationList>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getautoDocNotifications(wrapList);
    } 
	//for deinal history
    @isTest static void denialHistory(){
        OPTUM_MemberSearchService.DenialHistory wrapcls = new OPTUM_MemberSearchService.DenialHistory();
        wrapcls.denialStatusDate = '05/05/2020';
        wrapcls.reasonForDenial =  '040 - No EOB submitted';
        wrapcls.denialBy = '';
        wrapcls.deniedClaimAmount = '$3.99';
        wrapcls.status='';
        List <OPTUM_MemberSearchService.DenialHistory> wrapList = new List <OPTUM_MemberSearchService.DenialHistory>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getAutoDocDenialHis(wrapList);
    } 
	// for rmi
    @isTest static void rmiNotes(){
        OPTUM_MemberSearchService.RmiNotes wrapcls = new OPTUM_MemberSearchService.RmiNotes();
        wrapcls.actionTs = '06/05/2020';
        wrapcls.reason =  '040 - No EOB submitted';
        wrapcls.user = '';
        wrapcls.actionAmount = '$3.99';
        wrapcls.status='';
        wrapcls.rmiNote='';
        List <OPTUM_MemberSearchService.RmiNotes> wrapList = new List <OPTUM_MemberSearchService.RmiNotes>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getAutoDocRmiNotes(wrapList);
    } 
	//for Admin Notes
	@isTest static void adminNotes(){
        OPTUM_MemberSearchService.AdminNotesDetails wrapcls = new OPTUM_MemberSearchService.AdminNotesDetails();
        wrapcls.noteTs = '07/05/2020';
        wrapcls.user = '';
        wrapcls.adminNote='';
        List <OPTUM_MemberSearchService.AdminNotesDetails> wrapList = new List <OPTUM_MemberSearchService.AdminNotesDetails>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getAutoDocAdminNotes(wrapList);
    }
    //US3241994 Autodoc Demographics  
    @isTest static void autodocContributionsPhone(){
        OPTUM_MemberSearchService.demographicPhoneValues wrapcls = new OPTUM_MemberSearchService.demographicPhoneValues();
        wrapcls.pwork = '9999999999';
        wrapcls.extension = '' ;
        wrapcls.ptype = 'Work' ;
        wrapcls.priIndi = '(P)' ;
      List <OPTUM_MemberSearchService.demographicPhoneValues> wrapList = new List <OPTUM_MemberSearchService.demographicPhoneValues>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getAutoDocDemographicsPhone(wrapList);
    }
    //US3254524 Autodoc Account Activity   
    @isTest static void accountActivityAutodoc(){
        OPTUM_MemberSearchService.NotionalAccountActivity wrapcls = new OPTUM_MemberSearchService.NotionalAccountActivity();
        wrapcls.paymentDate = '08/28/2020';
        wrapcls.paymentAmount = '15.15' ;
        wrapcls.contributionComments = '' ;
        wrapcls.Type = 'DB';
       wrapcls.paymentCheckNum = '0000000347' ;
       List <OPTUM_MemberSearchService.NotionalAccountActivity> wrapList = new List <OPTUM_MemberSearchService.NotionalAccountActivity>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getautoDocTabDataTransactions(wrapList,'10','10','10','1');
    }  
    //US3242040: Autodoc Debit Cards
  /*  @isTest static void debitCardAutodoc(){
        OPTUM_MemberSearchService.DebitCard wrapcls = new OPTUM_MemberSearchService.DebitCard();
        wrapcls.cardDigits = '583X';
        wrapcls.embossedName = 'QATESTTWO REDDING' ;
        wrapcls.cardType = 'Primary' ;
        wrapcls.status = 'Active';
        wrapcls.orderStatus = '' ;
        wrapcls.requestDate = '08/28/2020' ;
        wrapcls.mailedDate = '' ;
        wrapcls.expirationDate = '07/2023' ;
        List <OPTUM_MemberSearchService.DebitCard> wrapList = new List <OPTUM_MemberSearchService.DebitCard>();
        wrapList.add(wrapcls);
        OPTUM_MemberSearchService.getAutoDocDebitCard(wrapList);
    } */
	 //for transactions
    @isTest static void transactionsAutodoc(){
        OPTUM_MemberSearchService.Transactions wrapcls = new OPTUM_MemberSearchService.Transactions();
        wrapcls.transactionDate = '08/28/2020';
        wrapcls.convertAmount = '15.15' ;
        wrapcls.runningBalance = '' ;
        wrapcls.debitOrCreditType = 'DB';
       wrapcls.type = 'PROCESSED' ;
       wrapcls.descriptionMemo ='interest Payment';
       wrapcls.documentNumber ='0';
       wrapcls.transactionCode ='804';
       List <OPTUM_MemberSearchService.Transactions> wrapList = new List <OPTUM_MemberSearchService.Transactions>();
       wrapList.add(wrapcls);
       OPTUM_MemberSearchService.getautoDocTableDataTransactionsForHSA(wrapList,'10','10','10','1');
    }
}