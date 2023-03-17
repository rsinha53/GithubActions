/*
 Name           : OPTUM_MemberAccountController_Test
 Created By     : Prasad kammella
 Created Date   : Oct 29th, 2020
 Description    : Code coverage for OPTUM_MemberAccountController 
 */
@isTest
public with sharing class OPTUM_MemberAccountController_Test {
public static String endDomain ='https://stg-faro-dmz-api.optum.com/faro/financial/accounts/v4.0/lookup';
    static testMethod void createint() {
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    //Insert Account record
        Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
		accountTest1.SRK_KeyChain__c ='abc';
        accountTest1.SRK_KeyChain__pc ='abc';
        accountTest1.ParticipantEmployeeExternalId__c = '0006851714';
        accountTest1.ParticipantEmployerCode__c = 'OPT';
	    accountTest1.ParticipantAdminAlias__c = 'J17894';
        accountTest1.RecordTypeId = newRecord.Id;
        insert accountTest1;
        //Insert Contact record
        Contact con = new Contact();
        con.FirstName = 'TestFname';
        con.lastname = 'TestLName';
        con.Tax_ID__c = '123456';
        con.NPI__c = '123457';
        insert con;
         //Insert Interaction record
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"Support","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c inte = new Interaction__c();
        inte.Originator__c = con.id;
        inte.Originator_Type__c = 'Member';
        inte.Highlight_Panel_GroupInfo__c = JSONStr;
        insert inte;
      //Passing parameters to controller method
      string dt = '01/01/2020';
      OPTUM_MemberAccountController member = new OPTUM_MemberAccountController();
        OPTUM_MemberAccountController.getUser();
		OPTUM_MemberAccountController.getorg();
        OPTUM_MemberAccountController.queryInteraction('inte.id'); 
        OPTUM_MemberAccountController.createInteraction('Phone call','Member',accountTest1,'','');
        OPTUM_MemberAccountController.addPersonAccount('test','Optum',dt,'Eid','0006851714','J17894','OPT');
		OPTUM_MemberAccountController.addPersonAccount('test','Optum',dt,'Eid','0006851714','J17894','OPT');
        OPTUM_VCCDBridgeController.addPersonAccount('test','Optum',dt,'Eid','0006851714','J17894','OPT');
		OPTUM_VCCDBridgeController.addPersonAccount('test','Optum',dt,'Eid','0006851714','J17894','OPT');
        OPTUM_VCCDBridgeController.createInteraction('Phone call','Member',accountTest1,'','');
		OPTUM_MemberAccountController.getPersonAccounts('Eid');
        OPTUM_MemberAccountController.getPlatformCacheResponse('optum');
		OPTUM_MemberAccountController.updateIntOriginator('originatorId','subjectID','tpRel');
		OPTUM_MemberAccountController.getPersonAccounts('');
        OPTUM_MemberAccountController.formatDatewithslash('');
		//US3668445-Genesys controller test class
        OPTUM_GenesysController osc = new OPTUM_GenesysController();
        osc.run();
        OPTUM_GenesysController.parsedDate('01011988');
		

    }

    
	@isTest static void testSearchMemberWithSSN() {
        String faroId='73939F194FBA4104E053326C750A8837';
		String serviceApi='ServiceAPI';
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
            Headers__c = '[{"key":"FAROID","value":"<:FARO_ID:>"},{"key":"Content-Type","value":"application/json"}]',
            AuthorizationToken__c = '',
            Timeout__c = 10000,
            Has_Mutual_Authentication__c =true
        );
        Insert tokenAPIWSConfig;
         OrgSpecificConfigurations__c orgsp = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get(serviceApi).getRecordTypeId(),
               Name ='qa',
               EndpointDomain__c =endDomain,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp;
        OrgSpecificConfigurations__c orgsp2 = new OrgSpecificConfigurations__c(
               RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get(serviceApi).getRecordTypeId(),
               Name ='Rollstonqa',
               EndpointDomain__c =endDomain,
               WebserviceConfigurations__c=tokenAPIWSConfig.Id
        );
        Insert orgsp2;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('OptumMemberserviceresponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        Test.startTest();
        OPTUM_MemberAccountController.searchMemberWithSSN(faroId);
        Test.stopTest();
    }
     static testMethod void createint2() {
       OPTUM_MemberAccountController.SRKKeyChain='test';
        string dt = '01/01/2020';
      OPTUM_MemberAccountController.addPersonAccount('test','Optum',dt,'!abc','0006851714','J17894','OPT'); 
      OPTUM_Utils.convertReqURLToReqParamMap('test.com');
    }
}