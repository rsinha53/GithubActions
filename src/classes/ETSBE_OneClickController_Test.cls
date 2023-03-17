@isTest
public class ETSBE_OneClickController_Test {
    private static final String FPS_USER_EMAIL = 'fpsagent1@optum.acet.com';
    private final static String businessUnit = 'CSO Resource Line';
    @testSetup static void setup() {
        ISL_Webservice_Config__c configObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_GetSolarisBaseURL',
            'GetSolarisEndpoint',
            true,
            true,
            'GetSolarisEndpoint',
            0,
            false,
            '',
            'https://test.salesforce.com'
        );  
        ISL_Webservice_Config__c tokenconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'ISLConAccessToken',
            'ISLConAccessToken',
            true,
            true,
            'ISLConAccessToken',
            0,
            false,
            '',
            '0a66b01d-be12-4cdf-983d-b1dd0b406fa2'
        );  
        ISL_Webservice_Config__c grantconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_SolarisApiGrantType',
            'SolarisApiGrantType',
            true,
            true,
            '',
            0,
            false,
            '',
            'password'
        ); 
        ISL_Webservice_Config__c clientconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_SolarisApiOAuthClientId',
            'SolarisApiOAuthClientId',
            true,
            true,
            '',
            0,
            false,
            '',
            '3MVG9RezSyZYLh2v3P93rV1_Le0UZGAK1_MXdDLKCoMJzrKleQhXHAJKP2rz.BFmRElUTPym5ovJhzKb5zAG_'
        ); 
        ISL_Webservice_Config__c secretconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_SolarisApiOAuthClientSecret',
            'SolarisApiOAuthClientSecret',
            true,
            true,
            '',
            0,
            false,
            '',
            'F872775E1E674A897EB0589F7A215C26E27CF76B8114369B7056832CBC780F49'
        ); 
        ISL_Webservice_Config__c userconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_SolarisApiOAuthUsername',
            'SolarisApiOAuthUsername',
            true,
            true,
            '',
            0,
            false,
            '',
            'test@test.com'
        ); 
        ISL_Webservice_Config__c pwdconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_SolarisApiOAuthPassword',
            'SolarisApiOAuthPassword',
            true,
            true,
            '',
            0,
            false,
            '',
            'test@'
        );
        ISL_Webservice_Config__c configObj1 = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_POLICYSEARCH_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_POLICYSEARCH_SERVICENAME,
            SAEConstants.SAE_POLICYSEARCH_VALUE
        );
        List<One_Click_Originator__c> orgLst=new List<One_Click_Originator__c>();
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c ='test@test.com';
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Group Contact';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c ='Group Contact';
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='';
        originator.Other_Originator_Type__c ='Attorney';
        originator.Originator_Role__c ='';
        orgLst.add(originator);
        insert orgLst;
        
        List<Special_Instructions__c> specLst=new List<Special_Instructions__c>();
        Special_Instructions__c sysinst = new Special_Instructions__c();
        sysinst.Business_Unit__c ='ACEC';
        sysinst.Business_Unit__c ='Commissions';
        sysinst.Business_Unit__c ='Broker Commissions';
        sysinst.Business_Unit__c ='1099 Inquiry';
        sysinst.ACET_Role__c='System Administrator';
        sysinst.Effective_Date__c=date.today();
        
        Special_Instructions__c inst = new Special_Instructions__c();
        inst.Business_Unit__c ='DCSM';
        inst.ACET_Role__c='System Administrator';
        inst.Effective_Date__c=date.today()-10;
        specLst.add(sysinst);
        specLst.add(inst);
        insert specLst;
        
        List<Third_Party__c> thrdPartyLst=new List<Third_Party__c>();
        Third_Party__c tp =new Third_Party__c();
        tp.First_Name__c ='test';
        tp.LastName__c ='test';
        thrdPartyLst.add(tp);
        insert thrdPartyLst;
        
        Interaction__c interactObj = new Interaction__c();       
        interactObj.Interaction_Type__c = 'Phone Call';
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        interactObj.Other_Admin_Type__c = 'Attorney';
        interactObj.Originator_Type__c = 'Other Admin';
        interactObj.Third_Party__c = tp.Id;
        interactObj.Contact_Name__c = 'Willow Best';
        interactObj.Originator_Name__c = 'Willow Best';
        interactObj.Customer_Admin_Type__c = 'Other Admin';
        interactObj.Originator_Email__c = 'willow@uhc.com';
        interactObj.Bypass_Validation_Rule__c=true;        
        insert interactObj;
        
		Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
        List<Case> caseLst=new List<Case>();
        Case caseObj = new Case();
        caseObj.Interaction__c = interactObj.Id;
        caseObj.Event_Type__c = 'Standard';
        caseObj.Surrogate_Key__c='Test';
        caseObj.Subject_Type__c='Member';
		caseObj.RecordTypeId=RecordTypeIdCase;
        
        Case solarisCase = new Case();
        solarisCase.Group_Solaris_ID__c = 'aaaaaaaaaa';
        solarisCase.Subject_Name__c = 'Ingersoll Auto Group Inc.';
        solarisCase.Interaction__c = interactObj.Id;
        solarisCase.Issue_Category_Desc__c = 'Commissions';
        solarisCase.Special_Instructions_Description__c = 'TESTING';
        solarisCase.RecordTypeId=RecordTypeIdCase;
		
        caseLst.add(caseObj);
        caseLst.add(solarisCase);
        insert caseLst;
        
        List<Merit_Group__c> meriGpLst=new List<Merit_Group__c>();
        Merit_Group__c meritGrp = new Merit_Group__c();
        meritGrp.Group_Name__c = 'Test';
        meritGrp.Policy_Renewal_Date__c = Date.today();
        meritGrp.Policy_Number__c = '12345';
        meritGrp.Group_Number__c = '12345';
        meritGrp.Health_Plan_Major__c = 'Test';
        meritGrp.Health_Plan_Minor__c = 'Test';
        meritGrp.Line_of_Business__c = 'Test';
        meritGrp.Platform__c = 'Test';
        meritGrp.Region__c = 'Test FLORIDA MIAMI';
        meritGrp.Situs_State__c = 'MN';
        meritGrp.Funding_Type__c = 'FI';
        meritGrp.CM_First_Name__c = 'Test';
        meritGrp.CM_Last_Name__c = 'Test';
        meritGrp.CM_Email__c = 'Test@test.com';
        meritGrp.CM_Phone__c = '1234567890';
        meritGrp.SCE_First_Name__c = 'Test';
        meritGrp.SCE_Last_Name__c = 'Test';
        meritGrp.SCE_Email__c = 'Test@test.com';
        meritGrp.SCE_Phone__c = '1234567890';
        meriGpLst.add(meritGrp);
        insert meriGpLst;
        
        List<SBam_Group__c> sbmGRPLST=new List<SBam_Group__c>();
        SBam_Group__c sbamGrp = new SBam_Group__c();
        sbamGrp.Group_Name__c = 'Test';
        sbamGrp.Policy_Renewal_Date__c = Date.today();
        sbamGrp.Policy_Number__c = '12345';
        sbamGrp.Group_Number__c = '12345';
        sbamGrp.Health_Plan_Major__c = 'Test';
        sbamGrp.Health_Plan_Minor__c = 'Test';
        sbamGrp.Line_of_Business__c = 'Test';
        sbamGrp.Platform__c = 'Test';
        sbamGrp.Region__c = 'Test';
        sbamGrp.Situs_State__c = 'MN';
        sbamGrp.Funding_Type__c = 'FII';       
        sbmGRPLST.add(sbamGrp);
        insert sbmGRPLST;   
    }
	
       static testmethod void oneclickmethod(){  
        Profile p = [SELECT Id FROM Profile WHERE Name='ACET ETS-BE']; 

        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', BEO_Specialty__c='DCSM',
                          LocaleSidKey='en_US', ProfileId = p.Id, FederationIdentifier = 'TestFed',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtets@testorg.com', UHG_Access__c='No');
       System.runAs(u) {    
       One_Click_Originator__c originator=[select id,Other_Originator_Type__c,Policy_Number__c,Group_Name__c,Group_Number__c,Agency_Broker_Name__c,Franchise_Code__c,General_Agency__c,Reward_Account_Number__c,First_Name__c,Last_Name__c,Phone_Ext__c,Phone_Number__c,Email__c,Originator_Type__c,Originator_Role__c from One_Click_Originator__c where Group_Name__c='Ingersoll' limit 1];
       //System.debug('originator==GP'+originator.Group_Name__c);
       Merit_Group__c meritGrp=[Select id,Group_Name__c,Group_Number__c from Merit_Group__c where Region__c='Test FLORIDA MIAMI' limit 1 ];
       SBam_Group__c sbamGrp=[Select id,Group_Name__c,Group_Number__c from SBam_Group__c where Funding_Type__c='FII' limit 1 ];
       //Case solarisCase=[select id,Group_Solaris_ID__c from Case where Group_Solaris_ID__c='aaaaaaaaaa' limit 1];     
        ETSBE_OneClickController.findOriginatorUpdate('test test', 'Group Contact', '8032296917', 'test@test.com',originator.Id);
        ETSBE_OneClickController.getOtherOriginatorDropdown();
        ETSBE_OneClickController.getUser();
        ETSBE_OneClickController.correctTimezone('2016-06-10T13:53:22'); 
        ETSBE_OneClickController.findOriginator(originator.First_Name__c);
        ETSBE_OneClickController.findOriginator('test,test');
        ETSBE_OneClickController.findOriginator('903-229-6917');
        ETSBE_OneClickController.createPersonAccount('Group','','Ingersoll','1058476','','No');
        ETSBE_OpenDetailController.getMockStatus();
        Date eventDatevar = date.valueOf('2020-09-23T00:00:00.000Z'); 
		String dateOfBirth=ACETUtility.format(System.today().addDays(2));
        ETSBE_OneClickController.createInteractionBot('a1Im000000BWIYVEA5', 'Phone Call', eventDatevar, '19:31:00.000', 'Latin', 'Marks',dateOfBirth,'111000',true);
        ETSBE_OneClickController.submitEdit(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                            originator.Phone_Number__c,originator.Phone_Ext__c,
                                            originator.Email__c,originator.Originator_Type__c,
                                            originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                            originator.General_Agency__c,originator.Franchise_Code__c,
                                            originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                            originator.Other_Originator_Type__c, originator.Originator_Role__c);
        ETSBE_OneClickController.submitAdd(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                           originator.Phone_Number__c,originator.Phone_Ext__c,
                                           originator.Email__c,originator.Originator_Type__c,
                                           originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                           originator.General_Agency__c,originator.Franchise_Code__c,
                                           originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                           originator.Other_Originator_Type__c,originator.Originator_Role__c);
      


      
        List<Merit_Group__c> MG= [Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM Merit_Group__c  WHERE Policy_Number__c = '12345'];
        List<SBam_Group__c>SB =[Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM SBam_Group__c  WHERE Group_Number__c = '12345'  OR Policy_Number__c ='12345'];
        System.assertEquals(MG.size(), 1);
        System.assertEquals(SB.size(), 1);

        ETSBE_SolarisGroupDetailResult newResult=new ETSBE_SolarisGroupDetailResult();
        newResult.groupName=MG[0].Group_Name__c;
        newResult.groupId=MG[0].Group_Number__c;
        newResult.renewalEffectiveDate=ACETUtility.format(MG[0].Policy_Renewal_Date__c);
        
        set<string> meritgpname=new set<string>();
        set<string> sbapgpname=new set<string>();
        meritgpname.add(MG[0].Group_Name__c);
        sbapgpname.add(SB[0].Group_Name__c);
        
        string callmerit=ETSBE_OneClickController.searchGroupSBamMeritName(meritgpname,sbapgpname);
        
        
        ISL_Webservice_Config__c provideronfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'SAE_ProviderSearch',
            'SAE_ProviderSearch',
            true,
            true,
            '',
            0,
            false,
            '',
            'test@'
        );
        
            Test.startTest();
            List<Merit_Group__c> meritGpLst=ETSBE_OneClickController.searchMeritResults(meritGrp.Group_Number__c);
            List<SBam_Group__c> sbamGpLst=ETSBE_OneClickController.searchSBAMResults(sbamGrp.Group_Number__c);
            // The following code runs as user 'u' 
            //System.debug('Current User: ' + UserInfo.getUserName());
            //System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            ETSBE_OneClickController.populateBusinessDropdown('Business Unit','ACEC','Commissions','Broker Commissions',u.BEO_Specialty__c,'ACET ETS-BE');
            ETSBE_OneClickController.populateBusinessDropdown('Topic','ACEC','Commissions','Broker Commissions',u.BEO_Specialty__c,'ACET ETS-BE');
            ETSBE_OneClickController.populateBusinessDropdown('Type','ACEC','Commissions','Broker Commissions',u.BEO_Specialty__c,'ACET ETS-BE');
            ETSBE_OneClickController.populateBusinessDropdown('Subtype','ACEC','Commissions','Broker Commissions',u.BEO_Specialty__c,'ACET ETS-BE');
           
        
        ETSBE_OneClickController.populateBusinessDropdown('Business Unit','ACEC','','','System Administrator','System Administrator');
        ETSBE_OneClickController.populateBusinessDropdown('Topic','ACEC','Commissions','Broker Commissions','System Administrator','System Administrator');
        ETSBE_OneClickController.populateBusinessDropdown('Type','ACEC','Commissions','Broker Commissions','System Administrator','System Administrator');
        ETSBE_OneClickController.populateBusinessDropdown('Subtype','ACEC','Commissions','Broker Commissions','System Administrator','System Administrator');
        
        ETSBE_SolarisMockupResponse fakeResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"access_token": "sForceTest1"}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ETSBE_SolarisMockupResponse groupResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                    'Success',
                                                                                    '{"message":null,"groupResults":[{"teamMembers":[{"Role":"Medical IM","Phone":null,"Name":"Ramirez Karen"}],"SitusState":"CT","SalesOffice":"Connecticut","RenewalEffectiveDate":"2020-12-01","PrimaryRewardAccountName":null,"PrimaryRewardAccount":null,"PolicyNumber":"20501","Platform":"Oxford","MarketSegment":"Key Accounts","Id":"0011400001wWKPMAA4","GAName":null,"FundingType":"FI","CustomerNumber":"1058476","contacts":[{"WorkPhoneExt":null,"WorkPhone":"2037305766","Title":null,"Name":"Beth Boguess","Id":"0030r00000KvlYPAAZ","Email":"test@optum.com","CellPhone":null}],"BusinessMinorMarket":"Connecticut Minor","BusinessMarketRegion":"Northeast Region","BusinessMajorMarket":"New England Major","AccountName":"Ingersoll Auto Group Inc."}],"failureReason":null,"brokerResults":null}',
                                                                                    null);
        Test.setMock(HttpCalloutMock.class, groupResponse);
        ETSBE_OneClickController.searchGroup('1058476');
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ETSBE_SolarisMockupResponse groupResponse1 = new ETSBE_SolarisMockupResponse(200,
                                                                                     'Success',
                                                                                     '{"message":null,"groupResults":[{"teamMembers":[{"Role":"Medical IM","Phone":null,"Name":"Ramirez Karen"}],"SitusState":"CT","SalesOffice":"Connecticut","RenewalEffectiveDate":"2020-12-01","PrimaryRewardAccountName":null,"PrimaryRewardAccount":null,"PolicyNumber":"20501","Platform":"Oxford","MarketSegment":"Key Accounts","Id":"0011400001wWKPMAA4","GAName":null,"FundingType":"FI","CustomerNumber":"1058476","contacts":[{"WorkPhoneExt":null,"WorkPhone":"2037305766","Title":null,"Name":"Beth Boguess","Id":"0030r00000KvlYPAAZ","Email":"test@optum.com","CellPhone":null}],"BusinessMinorMarket":"Connecticut Minor","BusinessMarketRegion":"Northeast Region","BusinessMajorMarket":"New England Major","AccountName":"Ingersoll Auto Group Inc."}],"failureReason":null,"brokerResults":null}',
                                                                                     null);
        Test.setMock(HttpCalloutMock.class, groupResponse1);
        
        ETSBE_SolarisMockupResponse brokerResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                     'Success',
                                                                                     '{"response":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","requestedDate":"04/16/2020","producerGroupAssociation":"","producerAndGroupFlag":"N","pageNumber":1,"recordsPerPage":20,"totalNumberOfRecords":1,"responseCode":200,"responseDescription":"Success"},"findProducerResponse":[{"producerCustomerValidated":"","producerID":"011457","producerSSN":"045620713","producerTIN":"","producerType":"I","producerContact":"DOUGLAS FINANCIAL SERVICES INC","producerCompanyName":"","producerStatus":"Active","producerEffectiveStartDate":"04/10/1995","producerEffectiveEndDate":"12/31/9999","legacyProducers":[{"legacyProducerSystem":"PUL","legacyProducerID":"BN3182"},{"legacyProducerSystem":"PUT","legacyProducerID":"BA3182"}],"customerDetails":[{"customerNumber":"John","customerName":"Smith","adminSystem":"test","producerCustomerStartDate":"04/16/2020","producerCustomerEndDate":"04/16/2020"}],"coverageType":"","producerRoleType":"","producerRole":"","producerServiceRightsOnly":"","producerCRID":"","producerSplitPercent":"","producerIndividualName":{"firstName":"ROBERTA","middleInitial":"W","lastName":"CZARNECKI"},"producerAddress":{"addressTypeCode":"M","producerStreetLine1":"500 E MAIN ST STE 316","producerStreetLine2":"","producerCity":"BRANFORD","producerState":"CT","producerZipCode":"06405","producerZipCodeSuffix":"2937","producerPhoneNumber":"2034887200"}}]}}',
                                                                                     null);
        Test.setMock(HttpCalloutMock.class, brokerResponse);
        ETSBE_OneClickController.searchBroker('011457');
        
        ETSBE_SolarisMockupResponse originatorAgency = new ETSBE_SolarisMockupResponse(200,
                                                                                       'Success',
                                                                                       '{"message":null,"groupResults":null,"failureReason":null,"brokerResults":[{"RewardAccountNumber":"104288","RewardAccountName":"New England Benefit Companies, Inc.","RewardAccountContacts":[{"Zip":"02886","WorkPhone":"4017393330","Type":"Other","Street":"144 Metro Center Blvd","State":"RI","Name":"Mike Branca","MobilePhone":null,"Id":"a2K14000000K9f5EAC","Email":null,"City":"Warwick"},{"Zip":"02860","WorkPhone":"4017342403","Type":"Other","Street":"100 Lafayette St","State":"RI","Name":"Brian Clarke","MobilePhone":null,"Id":"a2K14000000K9f6EAC","Email":"bclarke@nebenefit.com","City":"Pawtucket"}],"Producers":[{"Zip":"02852","Type":"Individual","Street":"50 WHITECAP DR","State":"RI","Phone":"4017344121","Name":"SAMUEL HAMIN FLEET","FranchiseCode":null,"Email":"group_retiree_broker@uhc.com","City":"N KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC","FranchiseCode":null,"Email":"timothy.mccarthy@amwins.com","City":"NORTH KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC NY","FranchiseCode":null,"Email":null,"City":"NORTH KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC CT","FranchiseCode":null,"Email":null,"City":"NORTH KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC NJ","FranchiseCode":null,"Email":null,"City":"NORTH KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC CA","FranchiseCode":null,"Email":null,"City":"NORTH KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC PA","FranchiseCode":null,"Email":null,"City":"NORTH KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC DC/MD","FranchiseCode":null,"Email":null,"City":"NORTH KINGSTOWN"},{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC VA","FranchiseCode":null,"Email":null,"City":"NORTH KINGSTOWN"}],"Id":"a0ga0000008384wAAA"}]}',
                                                                                       null);
        Test.setMock(HttpCalloutMock.class, originatorAgency);
        ETSBE_OneClickController.searchOriginatorSolaris('','','','','','', 'Agency/Broker','New England Benefit Companies, Inc.', '104288','','','','','','');
        ETSBE_SolarisMockupResponse originatorGA = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"message":null,"groupResults":null,"failureReason":null,"brokerResults":[{"RewardAccountNumber":"104288","RewardAccountName":"New England Benefit Companies, Inc.","RewardAccountContacts":[{"Zip":"02886","WorkPhone":"4017393330","Type":"Other","Street":"144 Metro Center Blvd","State":"RI","Name":"Mike Branca","MobilePhone":null,"Id":"a2K14000000K9f5EAC","Email":null,"City":"Warwick"},{"Zip":"02860","WorkPhone":"4017342403","Type":"Other","Street":"100 Lafayette St","State":"RI","Name":"Brian Clarke","MobilePhone":null,"Id":"a2K14000000K9f6EAC","Email":"bclarke@nebenefit.com","City":"Pawtucket"}],"Producers":[{"Zip":"02852","Type":"Business","Street":"50 WHITECAP DR","State":"RI","Phone":"8002421991","Name":"AMWINS GROUP BENEFITS INC NJ","FranchiseCode":"0000923","Email":null,"City":"NORTH KINGSTOWN"}],"Id":"a0ga0000008384wAAA"}]}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, originatorGA);
        ETSBE_OneClickController.searchOriginatorSolaris('','','','','','', 'General Agent','', '','','0000923','','','', '');
        ETSBE_SolarisMockupResponse originatorGroup = new ETSBE_SolarisMockupResponse(200,
                                                                                      'Success',
                                                                                      '{"message":null,"groupResults":[{"teamMembers":[{"Role":"Dedicated Customer Service Manager","Phone":null,"Name":"Tameka Aguilera"}],"SitusState":"CT","SalesOffice":"Connecticut","RenewalEffectiveDate":"2020-12-01","PrimaryRewardAccountName":"Quantum Financial Partners","PrimaryRewardAccount":"a0ga000000825YFAAY","PolicyNumber":"10501","Platform":"Cirrus","MarketSegment":"Key Accounts","Id":"0011400001wWj8RAAS","GAName":null,"FundingType":"FI","CustomerNumber":"1048476","contacts":[{"WorkPhoneExt":"308","WorkPhone":"2038828512","Title":"Payroll BK PG Manager","Name":"Lara French","Id":"0031400002yt2gHAAQ","Email":null,"CellPhone":null},{"WorkPhoneExt":"311","WorkPhone":"2038828810","Title":"CFO","Name":"Roger Letso","Id":"0031400002yt2gIAAQ","Email":"rletso@cccdinc.org","CellPhone":null}],"BusinessMinorMarket":"Connecticut Minor","BusinessMarketRegion":"Northeast Region","BusinessMajorMarket":"New England Major","AccountName":"Milestones Behavioral Services, Inc."}],"failureReason":null,"brokerResults":null}',
                                                                                      null);
        Test.setMock(HttpCalloutMock.class, originatorGroup);
        ETSBE_OneClickController.searchOriginatorSolaris('','','','','','', 'Group Contact','', '','','','','1048476','10501', '');
        
        ETSBE_BrokerSearchJSON2Apex testJson2Apex = new ETSBE_BrokerSearchJSON2Apex();
        testJson2Apex.response = new ETSBE_BrokerSearchJSON2Apex.BrokerResponse();
        testJson2Apex.response.serviceAttributes = new ETSBE_BrokerSearchJSON2Apex.ServiceAttributes();
        testJson2Apex.response.serviceAttributes.applicationIdentifier = 'test';
        testJson2Apex.response.serviceAttributes.requestIdentifier = 'test';
        testJson2Apex.response.serviceAttributes.requestedDate = 'test';
        testJson2Apex.response.serviceAttributes.producerGroupAssociation = 'test';
        testJson2Apex.response.serviceAttributes.producerAndGroupFlag = 'test';
        testJson2Apex.response.serviceAttributes.pageNumber = 1;
        testJson2Apex.response.serviceAttributes.recordsPerPage = 1;
        testJson2Apex.response.serviceAttributes.totalNumberOfRecords = 1;
        testJson2Apex.response.serviceAttributes.responseCode = 1;
        testJson2Apex.response.serviceAttributes.responseDescription = 'test';
        
        ETSBE_SolarisMockupResponse sendSolarisCaseResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                              'Success',
                                                                                              '{"response":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"","pageNumber":1,"recordsPerPage":20,"requestEffectiveDate":"04/16/2020","totalNumberOfRecords":10,"responseCode":200,"responseDescription":"Success"},"getProducerResponse":{"producerID":"011457","producerCompanyName":"","producerIndividualName":{"firstName":"ROBERTA","middleInitial":"W","lastName":"CZARNECKI"},"producerSSN":"045620713","producerTIN":"","producerType":"I","producerContact":"DOUGLAS FINANCIAL SERVICES INC","producerEffectiveStartDate":"04/10/1995","producerEffectiveEndDate":"12/31/9999","producerAddress":{"addressTypeCode":"M","producerStreetLine1":"500 E MAIN ST STE 316","producerStreetLine2":"","producerCity":"BRANFORD","producerState":"CT","producerZipCode":"06405","producerZipCodeSuffix":"2937","producerPhoneNumber":"2034887200"},"producerStatus":"Active","legacyProducers":[{"legacyProducerSystem":"PUL","legacyProducerID":"BN3182"}],"customerDetails":[{"customerNumber":"0280340","customerName":"NICHOLAS MONICK JR. EXCAVATING","adminSystem":"PR"},{"customerNumber":"04Y7677","customerName":"AGEMY FINANCIAL STRATEGIES INC","adminSystem":"PR"},{"customerNumber":"1259580","customerName":"BALLARDS DIESEL SERVICE LLC","adminSystem":"CR"},{"customerNumber":"1259793","customerName":"SC BALLARD LLC","adminSystem":"CR"},{"customerNumber":"1265277","customerName":"LJ NEW HAVEN LLC","adminSystem":"CR"},{"customerNumber":"1266582","customerName":"AGEMY FINANCIAL STRATEGIES INC","adminSystem":"CR"},{"customerNumber":"1269111","customerName":"HI TECH PACKAGING INC","adminSystem":"CR"},{"customerNumber":"1272778","customerName":"CONTINUUM CARE HOLDINGS LLC","adminSystem":"CR"},{"customerNumber":"1277876","customerName":"PARENT & PARENT LLP","adminSystem":"CR"},{"customerNumber":"1278851","customerName":"JMA ENTERPRISES INC","adminSystem":"CR"}]}}}',
       
                                                                                              null);
        Test.setMock(HttpCalloutMock.class, brokerResponse);
      
        /*List<String> caseLst = new List<String>();
        caseLst.add(solarisCase.Id);
        ECMSolarisCloseCase.sendSolarisClosedCases(caseLst);*/
        
        string   memberResponse   = '{"memberId":"956876492","memberDOB":"","firstName":"","lastName":"","groupNumber":"","searchOption":"","payerID":"","providerFlow":"Other"}';
        ETSBE_OneClickController.searchMembers(memberResponse);
        String originatorId = (String) originator.id;
        Date eventDate = Date.today();
        Interaction__c interaction1 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', eventDate, '06:00:00.000', 'John', 'Smith', '1/1/2001','123456789');
        String intId = (String) interaction1.Id;
        String contactId = ETSBE_OneClickController.createPersonAccount('Group','','Ingersoll','1058476','01/01/1990','No');
        ETSBE_OneClickController.getOptumExlusions();
        ETSBE_OneClickController.fetchData(null,'856876492','12/12/1989','Test First','Test Last','','MemberIDDateOfBirth','87726');
        ETSBE_OneClickController.formRequestParameters('856876492','12/12/1989','Test First','Test Last', '','','','','','','','','');
        Boolean uhgAccess = ETSBE_OneClickController.getHasUHGAccess();
        ETSBE_OneClickController.SearchResultWrapper1 srw1 = new ETSBE_OneClickController.SearchResultWrapper1();
        srw1.statusCode = 200;
        srw1.message = 'test';
        srw1.hasAccess = false; 
        String strRecord = '{"providerNotFound":false,"specialInstructions":"","specialInstructionsBusinessUnit":"ACEC","issueCategoryDesc":"Accident Protection","taskCategoryTypeDesc":"","taskCategorySubtypeDesc":"","specialInstructionsSubject":"","specialInstructionsDescription":"","specialInstructionsReferenceID":"","specialInstructionsDateOfService":"dsdsd","specialInstructionsQueue":"dsd","groupSolarisId":"0011400001wWKPMAA4","groupName":"Ingersoll Auto Group Inc.","groupId":"1058476","groupPolicyYear":"12/01/2020","SubjectSitus":"CT","groupFundingType":"FI","groupPlatform":"Oxford","groupLineOfBusiness":"Key Accounts","groupRegion":"Northeast ","groupSalesOffice":"Connecticut","groupHelathPlanMajor":"New England ","groupHelathPlanMinor":"Connecticut ","groupPolicyRenewalYear":"12/01/2020","groupPolicy":"20501","brokerName":"","brokerId":"","SubjectId":"1058476","SubjectName":"Ingersoll Auto Group Inc.","SubjectDOB":"","SubjectGroupId":"1058476","SubjectMemberSSN":"","emailURL":"","otherAdminType":"","Interaction":"' + intId + '","memberRelationship":"","AddInfoTopic":"","AddInfoOrginType":"","AddInfoOrginSubType":"","ttsType":"","ttsSubType":"","noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":""}';
        List<String> results = ETSBE_OneClickController.createOneNDoneCase(originatorId,strRecord,false,contactId, 'Group','Testing Resolution','', null,'TTS/ACSE','TTS/ACSE');//DE385766
        
        List<String> results1 = ETSBE_OneClickController.createBotCase(originatorId,strRecord,false,contactId, 'Group','Testing Resolution', 'TestFed','TTS/ACSE','TTS/ACSE');//DE385766
        
       // ContentDocumentLink conLnk=ETSBE_OneClickController.createContentDocumentLink(docStrLst[0],caseObj.id);
        //ETSBE_OneClickController.insertAttachments(docStrLst,caseObj.id);  //change
        
        ETSBE_OneClickController.SubjectCardSearchResultWrapper returnWrapper = ETSBE_OneClickController.findMembers('956876492', '12/12/1989', 'Test First', 'Test Last', '098099', '', '', 'test Provider', 'test Provider Last', '45345345', '');
        String resStr = ETSBE_OneClickController.searchGroupSBamMerit('12345');
        
        
        // String acctName = ETSBE_OneClickController.createPersonAccount('Group/Employer','','Ingersoll Auto Group Inc.','1058476test');
       // List<Interaction__c> interactObj1 = [Select Id from Interaction__c limit 1];//change
       // System.debug('HERE IS THE INTERACTION ' + interactObj1);
        //String strRecord = '{"providerNotFound":false,"specialInstructions":"","specialInstructionsBusinessUnit":"ACEC","issueCategoryDesc":"Accident Protection","taskCategoryTypeDesc":"","taskCategorySubtypeDesc":"","specialInstructionsSubject":"","specialInstructionsDescription":"","specialInstructionsReferenceID":"","specialInstructionsDateOfService":"sdsds","specialInstructionsQueue":"sds","groupName":"Ingersoll Auto Group Inc.","groupId":"1058476","groupPolicyYear":"12/01/2020","SubjectSitus":"CT","groupFundingType":"FI","groupPlatform":"Oxford","groupLineOfBusiness":"Key Accounts","groupRegion":"Northeast ","groupSalesOffice":"Connecticut","groupHelathPlanMajor":"New England ","groupHelathPlanMinor":"Connecticut ","groupPolicyRenewalYear":"12/01/2020","groupPolicy":"20501","SubjectId":"1058476","SubjectName":"Ingersoll Auto Group Inc.","SubjectDOB":"","SubjectGroupId":"1058476","emailURL":"","otherAdminType":"","Interaction":" '+interactObj1[0].Id+  '","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Alternative Medicine Provider","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":""}';
        
        //List<String> results = ETSBE_OneClickController.createOneNDoneCase(originatorId, strRecord, false, acctName, 'Group/Employer', 'String resolution');
        test.stopTest();
        }
        
    }
	
	 static testmethod void sendSolarisClosedCasesTest (){
        test.startTest();
        Case solarisCase=[select id,Group_Solaris_ID__c from Case where Group_Solaris_ID__c='aaaaaaaaaa' limit 1];
        System.assertEquals('aaaaaaaaaa', solarisCase.Group_Solaris_ID__c);
        List<String> caseLst = new List<String>();
        caseLst.add(solarisCase.Id);
        ECMSolarisCloseCase.sendSolarisClosedCases(caseLst);
        test.stopTest();
         
     }
	    	
	   static testmethod void attachementTest(){
        test.startTest();
		//Test class change for document upload functionality US2564216 || US2564216 
        List<ContentVersion> conVerLst=new List<ContentVersion>();
        List<string> docStrLst=new List<string>();
        //Case caseRec=[select id from case where Surrogate_Key__c='Test Me Here' limit 1];
        Case caseRec = new Case();
        //caseRec.Interaction__c = interactObj.Id;
        caseRec.Event_Type__c = 'Standard';
        caseRec.Surrogate_Key__c='Test Me Here';
        caseRec.Subject_Type__c='Member';
        insert caseRec;
        ContentVersion contentVersiondata = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        ContentVersion contentVersiondata2 = new ContentVersion(
            Title = 'Test22',
            PathOnClient = 'Test1.jpg',
            VersionData = Blob.valueOf('Test Content Data2'),
            IsMajorVersion = true
        );
        conVerLst.add(contentVersiondata);
        conVerLst.add(contentVersiondata2);     
        insert conVerLst;
        
        List<ContentVersion>contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id IN : conVerLst];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 2];
        System.assertEquals(documents.size(), 2);
        System.assertEquals(contentVersionSelect.size(), 2);
        
        for(ContentVersion conVer:conVerLst){
            docStrLst.add(conVer.ContentDocumentId);
        }
        
        List<ContentDocumentLink> conDocLinkLst=new List<ContentDocumentLink>();
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = caseRec.Id;
        cdl.ContentDocumentId = contentVersionSelect[0].ContentDocumentId;
        cdl.Visibility = 'AllUsers';
        
        ContentDocumentLink cdlink = New ContentDocumentLink();
        cdlink.LinkedEntityId = caseRec.Id;
        cdlink.ContentDocumentId = contentVersionSelect[1].ContentDocumentId;
        cdlink.Visibility = 'AllUsers';
        
        conDocLinkLst.add(cdl);
        conDocLinkLst.add(cdlink);
        
        insert conDocLinkLst;
		   
        ContentDocumentLink conLnk=ETSBE_OneClickController.createContentDocumentLink(docStrLst[0],caseRec.id);
        ETSBE_OneClickController.insertAttachments(docStrLst,caseRec.id); 
		
		test.stopTest();
        
    }
	
    static testmethod void oneclickmethodInteractions(){
        
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c ='test@test.com';
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Group Contact';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c ='Group Contact';
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='23456';
        originator.Other_Originator_Type__c ='Attorney';
        originator.Originator_Role__c ='';
        insert originator;
        
        
        ETSBE_OneClickController.submitEdit(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                            originator.Phone_Number__c,originator.Phone_Ext__c,
                                            originator.Email__c,originator.Originator_Type__c,
                                            originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                            originator.General_Agency__c,originator.Franchise_Code__c,
                                            originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                            originator.Other_Originator_Type__c,originator.Originator_Role__c);
        ETSBE_OneClickController.submitAdd(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                           originator.Phone_Number__c,originator.Phone_Ext__c,
                                           originator.Email__c,originator.Originator_Type__c,
                                           originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                           originator.General_Agency__c,originator.Franchise_Code__c,
                                           originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                           originator.Other_Originator_Type__c,originator.Originator_Role__c);
        Profile p = [SELECT Id FROM Profile WHERE Name='ACET ETS-BE']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', BEO_Specialty__c='DCSM',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtets@testorg.com');
        
        test.startTest();
        String originatorId = (String) originator.id;
        Date eventDate = Date.today()-1;
        Interaction__c interaction1 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', eventDate, '06:00:00.000', 'John', 'Smith', '1/1/2001','123456789');
        Interaction__c interaction2 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        Interaction__c interaction3 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', null, '', '', '', '','');
        String updateIntId = (String) interaction3.id;
        ETSBE_OneClickController.updateInteractionOneNDone(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateIntId);
        Interaction__c interaction4 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', eventDate, '06:00:00.000', 'Jane', 'Smith', '1/2/2001','123456789',true);
        Interaction__c interaction7 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', eventDate, '06:00:00.000', 'Jane', 'Smith', '1/2/2001','123456789');
        Interaction__c interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        String updateStandardIntId = (String) interaction8.id;
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        Interaction__c interaction9 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        originator.Originator_Type__c = 'Agency/Broker';
        upsert originator;
        interaction2 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        interaction3 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', null, '', '', '', '','');
        interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        interaction9 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        originator.Originator_Type__c = 'General Agent';
        upsert originator;
        interaction2 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        interaction3 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', null, '', '', '', '','');
        interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        interaction9 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        originator.Originator_Type__c = 'Other Originator';
        upsert originator;
        interaction2 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        interaction3 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', null, '', '', '', '','');
        interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        interaction9 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        
        
        test.stopTest();
        
    }
    static testmethod void oneclickmethodInteractions2(){
        
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c ='test@test.com';
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Group Contact';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c ='Group Contact';
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='';
        originator.Other_Originator_Type__c ='Attorney';
        originator.Originator_Role__c ='';
        insert originator;
        
        
        ETSBE_OneClickController.submitEdit(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                            originator.Phone_Number__c,originator.Phone_Ext__c,
                                            originator.Email__c,originator.Originator_Type__c,
                                            originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                            originator.General_Agency__c,originator.Franchise_Code__c,
                                            originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                            originator.Other_Originator_Type__c,originator.Originator_Role__c);
        ETSBE_OneClickController.submitAdd(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                           originator.Phone_Number__c,originator.Phone_Ext__c,
                                           originator.Email__c,originator.Originator_Type__c,
                                           originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                           originator.General_Agency__c,originator.Franchise_Code__c,
                                           originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                           originator.Other_Originator_Type__c,originator.Originator_Role__c);
        Profile p = [SELECT Id FROM Profile WHERE Name='ACET ETS-BE']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', BEO_Specialty__c='DCSM',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtets@testorg.com');
        
        test.startTest();
        String originatorId = (String) originator.id;
        Date eventDate = Date.today()-1;
        Interaction__c interaction4 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', eventDate, '06:00:00.000', 'Jane', 'Smith', '1/2/2001','123456789',true);
        Interaction__c interaction5 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','',true);
        Interaction__c interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        String updateStandardIntId = (String) interaction6.id;
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', 'Jane', 'Smith', '1/2/2001','123456789', updateStandardIntId);
        ETSBE_OneClickController.updateInteractionOneNDone(originatorId, 'Phone Call', eventDate, '07:00:00.000', 'Jane', 'Smith', '1/2/2001','123456789', updateStandardIntId);
        originator.Originator_Type__c = 'Agency/Broker';
        upsert originator;
        interaction5 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','',true);
        interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        originator.Originator_Type__c = 'General Agent';
        upsert originator;
        interaction5 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','',true);
        interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        originator.Originator_Type__c = 'Other Originator';
        upsert originator;
        interaction5 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','',true);
        interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        
        originator.Originator_Type__c = 'Group Contact';
        originator.First_Name__c ='Jims';
        originator.Last_Name__c ='Fredericksons';
        originator.Phone_Number__c ='9039846917';
        originator.Email__c ='Jim@test.coms';
        upsert originator;
        interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        updateStandardIntId = (String) interaction6.id;
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        ETSBE_OneClickController.updateInteractionOneNDone(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        originator.Originator_Type__c = 'Agency/Broker';
        originator.First_Name__c ='Tims';
        originator.Last_Name__c ='Johnsons';
        originator.Phone_Number__c ='9098146917';
        originator.Email__c ='Tim@test.coms';
        upsert originator;
        interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        ETSBE_OneClickController.updateInteractionOneNDone(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        originator.Originator_Type__c = 'General Agent';
        originator.First_Name__c ='Jills';
        originator.Last_Name__c ='Hendrickss';
        originator.Phone_Number__c ='9039996917';
        originator.Email__c ='Jill@test.com';
        upsert originator;
        
        
        test.stopTest();
        
    }
    static testmethod void oneclickmethodInteractions3InternalUHG(){
        
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c ='test@test.com';
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Internal UHG Employee';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c ='Group Contact';
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='';
        originator.Other_Originator_Type__c ='Attorney';
        originator.Originator_Role__c ='';
        insert originator;
        
        
        ETSBE_OneClickController.submitEdit(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                            originator.Phone_Number__c,originator.Phone_Ext__c,
                                            originator.Email__c,originator.Originator_Type__c,
                                            originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                            originator.General_Agency__c,originator.Franchise_Code__c,
                                            originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                            originator.Other_Originator_Type__c,originator.Originator_Role__c);
        ETSBE_OneClickController.submitAdd(originator.id,originator.First_Name__c,originator.Last_Name__c,
                                           originator.Phone_Number__c,originator.Phone_Ext__c,
                                           originator.Email__c,originator.Originator_Type__c,
                                           originator.Agency_Broker_Name__c,originator.Reward_Account_Number__c,
                                           originator.General_Agency__c,originator.Franchise_Code__c,
                                           originator.Group_Name__c,originator.Group_Number__c,originator.Policy_Number__c,
                                           originator.Other_Originator_Type__c,originator.Originator_Role__c);
        Profile p = [SELECT Id FROM Profile WHERE Name='ACET ETS-BE']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', BEO_Specialty__c='DCSM',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtets@testorg.com');
        
        test.startTest();
        String originatorId = (String) originator.id;
        Date eventDate = Date.today();
        Interaction__c interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        Interaction__c interaction2 = ETSBE_OneClickController.createInteractionOneNDone(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        Interaction__c interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', eventDate, '06:00:00.000', '', '', '','');
        Interaction__c interaction9 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','');
        
        
        test.stopTest();
        
    }
    
    static testmethod void oneclickmethodInteractions3InternalUHG2(){
        
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c ='test@test.com';
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Internal UHG Employee';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c ='Group Contact';
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='';
        originator.Other_Originator_Type__c ='Attorney';
        insert originator;
        
        test.startTest();
        String originatorId = (String) originator.id;
        Date eventDate = Date.today()-1;
        Interaction__c interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        String updateStandardIntId = (String) interaction6.id;
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        ETSBE_OneClickController.updateInteractionOneNDone(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        ETSBE_OneClickController.updateInteractionOneNDone(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        originator.Originator_Type__c = 'Other Originator';
        originator.First_Name__c ='Sarahs';
        originator.Last_Name__c ='Walls';
        originator.Phone_Number__c ='9039156987';
        originator.Email__c ='Sarah@test.com';
        upsert originator;
        interaction6 = ETSBE_OneClickController.createInteractionBot(originatorId, 'Phone Call', null, '', '', '', '','',true);
        ETSBE_OneClickController.updateInteractionStandard(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        ETSBE_OneClickController.updateInteractionOneNDone(originatorId, 'Phone Call', eventDate, '07:00:00.000', '', '', '','', updateStandardIntId);
        
        
        test.stopTest();
        
    }
    
    static testmethod void oneclickmethodInteractions4(){
        
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c ='test@test.com';
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Group Contact';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c ='Group Contact';
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='';
        originator.Other_Originator_Type__c ='Attorney';
        insert originator;
        
        String originatorId = (String) originator.id;
        test.startTest();
        Interaction__c interaction8 = new Interaction__c();
    	interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        originator.Originator_Type__c = 'Group Contact';
        originator.First_Name__c ='Jim';
        originator.Last_Name__c ='Frederickson';
        originator.Phone_Number__c ='9039846917';
        originator.Email__c ='Jim@test.com';
        upsert originator;
        interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        originator.Originator_Type__c = 'Agency/Broker';
        originator.First_Name__c ='Tim';
        originator.Last_Name__c ='Johnson';
        originator.Phone_Number__c ='9098146917';
        originator.Email__c ='Tim@test.com';
        upsert originator;
        interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        originator.Originator_Type__c = 'General Agent';
        originator.First_Name__c ='Jill';
        originator.Last_Name__c ='Hendricks';
        originator.Phone_Number__c ='9039996917';
        originator.Email__c ='Jill@test.com';
        upsert originator;
        interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        originator.Originator_Type__c = 'Other Originator';
        originator.First_Name__c ='Sarah';
        originator.Last_Name__c ='Wall';
        originator.Phone_Number__c ='9039156987';
        originator.Email__c ='Sarah@test.com';
        upsert originator;
        interaction8 = ETSBE_OneClickController.createInteractionStandard(originatorId, 'Phone Call', null, '', '', '', '','');
        
        test.stopTest();

    }
    
    static testmethod void mockDataResponse(){
        try{
        ISL_Webservice_Config__c provideronfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'SAE_ProviderSearch',
            'SAE_ProviderSearch',
            true,
            true,
            '',
            0,
            false,
            '',
            'test@'
        );
        test.startTest();
        ETSBE_OneClickController.getMockStatus();
        ETSBE_OneClickController.getMockData(null,'','1960-01-02','Caleb','Galleco','','NameDateOfBirth','');
            string searchOption='';        
            switch on searchOption {
                when 'NameDateOfBirth' {
                  ETSBE_OneClickController.getMockData(null,'','1960-01-02','Caleb','Galleco','','NameDateOfBirth','');
               
                } 
                when 'MemberIDNameGroupNumberDateOfBirth'{
                      ETSBE_OneClickController.getMockData(null,'','1960-01-02','Caleb','Galleco','','MemberIDNameGroupNumberDateOfBirth','');
                }
                 when 'MemberIDNameDateOfBirth'{
                      ETSBE_OneClickController.getMockData('sks','sksk','1960-01-02','Caleb','Galleco','','MemberIDNameDateOfBirth','');
                }  
                 when 'MemberIDName'{
                      ETSBE_OneClickController.getMockData('sks','sksk','1960-01-02','Caleb','Galleco','','MemberIDName','');
                }
                   when 'MemberIDLastNameDateOfBirth'{
                      ETSBE_OneClickController.getMockData('sks','sksk','1960-01-02','Caleb','Galleco','','MemberIDLastNameDateOfBirth','');
                }
                    when 'MemberIDFirstNameDateOfBirth'{
                      ETSBE_OneClickController.getMockData('sks','sksk','1960-01-02','Caleb','Galleco','','MemberIDFirstNameDateOfBirth','');
                }
                 when 'MemberIDDateOfBirth'{
                      ETSBE_OneClickController.getMockData('sks','sksk','1960-01-02','Caleb','Galleco','','MemberIDDateOfBirth','');
                }
                
            }
 
         test.stopTest();
        }catch(exception e){}
    }
        
    
    @isTest
    static void testfetchdata() {
        
        List<ISL_Webservice_Config__c> wsConfigs = new List<ISL_Webservice_Config__c>();
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        wsConfigs.add(webConfig);
        wsConfigs.add(new ISL_Webservice_Config__c(Name='SAE_ProviderSearch', Value__c='https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'));
        Insert wsConfigs;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        System.assertEquals('ISLConAccessToken', tokenRec.Token_Name__c);
        Test.startTest();
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', null, '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDLastNameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDFirstNameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'NameDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDDateOfBirth', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDName', '');
        SAEMemberProviderDetail.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '101987516','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDName', '');
        //System.assertNotEquals(null, result);
        
        Test.stopTest();
    } 
    
    @isTest
    static void testContinuationMethod() {
        
        List<ISL_Webservice_Config__c> wsConfigs = new List<ISL_Webservice_Config__c>();
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'ISLOAuthContentType';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        wsConfigs.add(webConfig);
        wsConfigs.add(new ISL_Webservice_Config__c(Name='SAE_ProviderSearch', Value__c='https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'));
        Insert wsConfigs;
        
        //Insert Token Record
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityContinuationMock());
        ETSBE_OneClickController onclickController = new ETSBE_OneClickController();
        Continuation contin = (Continuation)ETSBE_OneClickController.fetchData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID, '111765063','3/26/1949', 'Mark', 'Johnson', '', 'MemberIDNameDateOfBirth', '');
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(SAETestDataFactory.getStaticResourceResponse('SAEEligibilityResponseMockData'));
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(onclickController, contin);   
    }   
    @isTest
    Static void populateEvntTypeBusinessUnitTest(){
        Interaction__c interactObj = new Interaction__c();       
        interactObj.Interaction_Type__c = 'Phone Call';
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        interactObj.Other_Admin_Type__c = 'Attorney';
        interactObj.Originator_Type__c = 'Other Admin';
        interactObj.Contact_Name__c = 'Willow Best';
        interactObj.Originator_Name__c = 'Willow Best';
        interactObj.Customer_Admin_Type__c = 'Other Admin';
        interactObj.Originator_Email__c = 'willowFake@uhc.com';
        
        
        insert interactObj;
        
        Case caseObj = new Case();
        caseObj.Interaction__c = interactObj.Id;
        caseObj.Special_Instructions_Business_Unit__c='CSO Resource Line';
        caseObj.Event_Type__c = 'Standard';       
        insert caseObj;
        
        interactObj.Business_Unit__c=caseObj.Special_Instructions_Business_Unit__c;
        interactObj.CSS_SRT__c ='Others'; 
        interactObj.Event_Type__c=caseObj.Event_Type__c;
        update interactObj;
        System.assertEquals('Others', interactObj.CSS_SRT__c);
        
    }
    
    @isTest
    Static void deleteAttachedFilesTest(){
        Case caseObj = new Case();
        caseObj.Event_Type__c = 'Standard';       
        insert caseObj;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        Test.startTest();
        ETSBE_OneClickController.deleteAttachedFiles(cv.id,caseObj.id);
        //Get Content Version
        ContentVersion cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        ContentDocument cdList = [SELECT Id FROM ContentDocument where id=:cvList.ContentDocumentId];
        System.assertEquals(cdList.Id, cvList.ContentDocumentId);
        Delete cdList;
      
        ETSBE_OneClickController oneclickCon=new ETSBE_OneClickController();
        SAEHouseHoldController.SearchResultWrapper resWrp=new SAEHouseHoldController.SearchResultWrapper();
        resWrp=ETSBE_OneClickController.getHouseHoldData('23232');
        Test.stopTest();
        
    }
    //FPS Testing.
      @isTest
    Static void getOrgFieldsetFieldsTest(){
        Test.startTest();
        ETSBE_OneClickController.getCustomMetadata();
        ETSBE_OneClickController.getOrgFieldsetFields();
        Test.stopTest();
    }
    @isTest
    Static void fps_createCaseTest(){
           Test.startTest();
           One_Click_Originator__c originator=[select id,Other_Originator_Type__c,Policy_Number__c,Group_Name__c,Group_Number__c,Agency_Broker_Name__c,Franchise_Code__c,General_Agency__c,Reward_Account_Number__c,First_Name__c,Last_Name__c,Phone_Ext__c,Phone_Number__c,Email__c,Originator_Type__c,Originator_Role__c from One_Click_Originator__c where Group_Name__c='Ingersoll' limit 1];
		   String originatorId= (String)originator.Id;
           String originatorInformation='{"Agency_Broker_Name__c":"JANE RYAN INSURANCE, LLC","First_Name__c":"KRISHNA","Id":"'+originatorId+'","Phone_Number__c":"238-204-9384","Reward_Account_Number__c":"653060","Originator_Type__c":"Agency/Broker","Last_Name__c":"KUMAR","Email__c":"test@test.com"}';
           String groupInformation='{"sourceCode":"SO","situsState":"NC","salesOffice":"","salesforceInternalId":null,"renewalEffectiveDate":"2/1/2017","policyNumber":"Y7Y2","platform":"JD","lineOfBusiness":"Small Business","groupTeamMembers":null,"groupName":"CAVINESS & CATES BUILDING AND","groupId":"TBDX","generalAgentName":null,"fundingType":"FI","contacts":[],"businessMinorMarket":"NORTH CAROLINA","businessMarketRegion":"Southeast","businessMajorMarket":"South Atlantic","brokerSalesforceId":null,"brokerName":""}';        
           System.debug('originatorInformation' +originatorInformation);
           ETSBE_OneClickController.fps_createCase(originatorInformation,groupInformation,'Email');
           Test.stopTest();
    }
    @isTest
    Static void fps_UpdateCaseTest(){
           Test.startTest();
           One_Click_Originator__c originator=[select id,Other_Originator_Type__c,Policy_Number__c,Group_Name__c,Group_Number__c,Agency_Broker_Name__c,Franchise_Code__c,General_Agency__c,Reward_Account_Number__c,First_Name__c,Last_Name__c,Phone_Ext__c,Phone_Number__c,Email__c,Originator_Type__c,Originator_Role__c from One_Click_Originator__c where Group_Name__c='Ingersoll' limit 1];
           String originatorId = (String)originator.Id;
           String originatorInformation='{"Agency_Broker_Name__c":"JANE RYAN INSURANCE, LLC","First_Name__c":"KRISHNA","Id":"'+originatorId+'","Phone_Number__c":"238-204-9384","Reward_Account_Number__c":"653060","Originator_Type__c":"Agency/Broker","Last_Name__c":"KUMAR","Email__c":"test@test.com"}';
           String groupInformation='{"sourceCode":"SO","situsState":"NC","salesOffice":"","salesforceInternalId":null,"renewalEffectiveDate":"2/1/2017","policyNumber":"Y7Y2","platform":"JD","lineOfBusiness":"Small Business","groupTeamMembers":null,"groupName":"CAVINESS & CATES BUILDING AND","groupId":"TBDX","generalAgentName":null,"fundingType":"FI","contacts":[],"businessMinorMarket":"NORTH CAROLINA","businessMarketRegion":"Southeast","businessMajorMarket":"South Atlantic","brokerSalesforceId":null,"brokerName":""}';
           Interaction__c interactObj = new Interaction__c();       
           interactObj.Interaction_Type__c = 'Phone Call';
           interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
           interactObj.Other_Admin_Type__c = 'Attorney';
           interactObj.Originator_Type__c = 'Other Admin';
           interactObj.Contact_Name__c = 'Willow Best';
           interactObj.Originator_Name__c = 'Willow Best';
           interactObj.Customer_Admin_Type__c = 'Other Admin';
           interactObj.Originator_Email__c = FPS_USER_EMAIL;
           insert interactObj;
           Case caseObj = new Case();
           caseObj.Interaction__c = interactObj.Id;
           caseObj.Event_Type__c = 'Standard'; 
           insert caseObj;
           ETSBE_OneClickController.fps_UpdateCase(originatorInformation,groupInformation,caseObj.Id,'Email');
           Test.stopTest();
    } 
       
    @isTest
    Static void populateEvntTypeBusinessUnitSecondTest(){
             Test.startTest();
		     Interaction__c interactObj = new Interaction__c();       
             interactObj.Interaction_Type__c = 'Phone Call';
             interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
             interactObj.Other_Admin_Type__c = 'Attorney';
             interactObj.Originator_Type__c = 'Other Admin';
             interactObj.Contact_Name__c = 'Willow Best';
             interactObj.Originator_Name__c = 'Willow Best';
             interactObj.Customer_Admin_Type__c = 'Other Admin';
             interactObj.Originator_Email__c = FPS_USER_EMAIL;
             insert interactObj;
             Case caseObj = new Case();
             caseObj.Interaction__c = interactObj.Id;
             caseObj.Special_Instructions_Business_Unit__c= businessUnit;
             caseObj.Event_Type__c = 'Standard';       
             insert caseObj;
             ETSBE_OneClickController.populateEvntTypeBusinessUnit(caseObj.Id);
             Test.stopTest();
    }
}