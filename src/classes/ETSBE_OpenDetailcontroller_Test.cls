@isTest
public class ETSBE_OpenDetailcontroller_Test {
    static testmethod void mockDataResponse(){
        ETSBE_OpenDetailController.getMockStatus();
        Profile p = [SELECT Id FROM Profile WHERE Name='ACET ETS-BE']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', BEO_Specialty__c='DCSM',
                          LocaleSidKey='en_US', ProfileId = p.Id, FederationIdentifier = 'TestFed',
                          TimeZoneSidKey='America/Los_Angeles', UserName='BEOdetailtestusr@optum.com.acet', UHG_Access__c='No');
        
        Interaction__c interactObj = new Interaction__c();
        interactObj.Interaction_Type__c = 'Phone Call';
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        interactObj.Other_Admin_Type__c = 'Attorney';
        interactObj.Originator_Type__c = 'Other Admin';
        interactObj.Contact_Name__c = 'Willow Best';
        interactObj.Originator_Name__c = 'Willow Best';
        interactObj.Customer_Admin_Type__c = 'Other Admin';
        //interactObj.Originator_Phone__c=603-594-7894;
        interactObj.Originator_Email__c = 'willow@uhc.com';
        interactObj.Bypass_Validation_Rule__c=true;
        interactObj.Current_Status__c='open';
        insert interactObj;
          Special_Instructions__c sysinst = new Special_Instructions__c();
        sysinst.Business_Unit__c ='ACEC';
        sysinst.Business_Unit__c ='Commissions';
        sysinst.Business_Unit__c ='Broker Commissions';
        sysinst.Business_Unit__c ='1099 Inquiry';
        sysinst.ACET_Role__c='System Administrator';
        sysinst.Effective_Date__c=date.today();
        sysinst.Business_Unit__c='NA Activity';
        
        insert sysinst;
        
        Contact c= new contact();
        c.FirstName='test';
        c.LastName='contact';
        insert c;
        
       
        Case caseObj = new Case();
        caseObj.Interaction__c = interactObj.Id;
        caseObj.Event_Type__c = 'Standard';
        caseObj.OriginatorEmail__c='standard@test.com';
        caseObj.Reward_Account_Number__c ='Group Contact';
        caseObj.Email__c='test@test.com';
        caseObj.Platform__c='cirrus';
        caseObj.Policy__c='234';
        caseObj.Subject_Group_ID__c='100002';
        caseObj.Group_Name__c='testclass';
        caseObj.SourceCode__c='3455';
        caseObj.Situs__c='test';
        caseObj.Sales_Office__c='teststtstst';
        caseObj.Policy_Renewal_Year__c= Date.newInstance(2000,10,10);
        caseObj.ContactId=c.id;
        caseObj.Status='Open';
        caseObj.DOB__c='test';
        caseObj.Subject_Type__c='Group/employer';
        caseObj.Member_SSN__c='929394959';
      caseObj.Issue_Category_Desc__c='testst';
        caseObj.Special_Instructions_Description__c='tset';
        
        insert caseObj;
        system.debug('case'+caseObj);
        
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.Originator_Type__c= caseObj.Originator_Type__c;
      
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c =caseObj.OriginatorEmail__c;
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Group Contact';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c =caseObj.Reward_Account_Number__c;
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='';
        originator.Other_Originator_Type__c ='Attorney';
        insert originator;
      system.debug('originator--------->'+originator);
        
        
        
        Merit_Group__c meritGrp = new Merit_Group__c();
        meritGrp.Group_Name__c = 'Test';
        meritGrp.Policy_Renewal_Date__c = Date.today();
        meritGrp.Policy_Number__c = '12345';
        meritGrp.Group_Number__c = '12345';
        meritGrp.Health_Plan_Major__c = 'Test';
        meritGrp.Health_Plan_Minor__c = 'Test';
        meritGrp.Line_of_Business__c = 'Test';
        meritGrp.Platform__c = 'Test';
        meritGrp.Region__c = 'Test';
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
        insert meritGrp;
  
        
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
        sbamGrp.Funding_Type__c = 'FI';
        insert sbamGrp;
        
        List<Merit_Group__c> MG= [Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM Merit_Group__c  WHERE Policy_Number__c = '12345'];
        List<SBam_Group__c>SB =[Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM SBam_Group__c  WHERE Group_Number__c = '12345'  OR Policy_Number__c ='12345'];
        System.assertEquals(MG.size(), 1);
        System.assertEquals(SB.size(), 1);
        Case solarisCase = new Case();
        solarisCase.Group_Solaris_ID__c = 'aaaaaaaaaa';
        solarisCase.Subject_Name__c = 'Ingersoll Auto Group Inc.';
        solarisCase.Interaction__c = interactObj.Id;
        solarisCase.Issue_Category_Desc__c = 'Commissions';
        solarisCase.Special_Instructions_Description__c = 'TESTING';
        insert solarisCase;
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
        String caseId1=caseObj.id;
        String solarisResults= ETSBE_OneClickController.searchGroup('1058476');
         ETSBE_OpenDetailController.getSelectedGroupInfo('1058476', caseId1);
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
        ETSBE_OpenDetailController.searchBroker('011457');
       String resStr = ETSBE_OneClickController.searchGroupSBamMerit('12345');
        ETSBE_SolarisMockupResponse originatorGroup = new ETSBE_SolarisMockupResponse(200,
                                                                                      'Success',
                                                                                      '{"message":null,"groupResults":[{"teamMembers":[{"Role":"Dedicated Customer Service Manager","Phone":null,"Name":"Tameka Aguilera"}],"SitusState":"CT","SalesOffice":"Connecticut","RenewalEffectiveDate":"2020-12-01","PrimaryRewardAccountName":"Quantum Financial Partners","PrimaryRewardAccount":"a0ga000000825YFAAY","PolicyNumber":"10501","Platform":"Cirrus","MarketSegment":"Key Accounts","Id":"0011400001wWj8RAAS","GAName":null,"FundingType":"FI","CustomerNumber":"1048476","contacts":[{"WorkPhoneExt":"308","WorkPhone":"2038828512","Title":"Payroll BK PG Manager","Name":"Lara French","Id":"0031400002yt2gHAAQ","Email":null,"CellPhone":null},{"WorkPhoneExt":"311","WorkPhone":"2038828810","Title":"CFO","Name":"Roger Letso","Id":"0031400002yt2gIAAQ","Email":"rletso@cccdinc.org","CellPhone":null}],"BusinessMinorMarket":"Connecticut Minor","BusinessMarketRegion":"Northeast Region","BusinessMajorMarket":"New England Major","AccountName":"Milestones Behavioral Services, Inc."}],"failureReason":null,"brokerResults":null}',
                                                                                      null);
        Test.setMock(HttpCalloutMock.class, originatorGroup);
        String caseId=caseObj.id;
         ETSBE_OpenDetailController.getSelectedGroupInfo('1058476', caseId);
        ETSBE_OpenDetailController.getCaseInfoMethod(caseId);
        ETSBE_OpenDetailController.getCaseInfoMethod(null);
        // Case CaseData = [select id,Group_Name__c,Subject_Group_ID__c,Platform__c,Policy__c from Case  where id=:caseobj.Id];
        
        try{ETSBE_OpenDetailController.fetchOriginatorRecord(caseId);
            }catch(exception e){}
       
        test.stopTest();
        
    }
    
  
     static testmethod void mockDataResponse1(){
          ETSBE_OpenDetailController.getMockStatus();
     Profile p = [SELECT Id FROM Profile WHERE Name='ACET ETS-BE']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', BEO_Specialty__c='DCSM',
                          LocaleSidKey='en_US', ProfileId = p.Id, FederationIdentifier = 'TestFed',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtets@testorg.com', UHG_Access__c='No');
        
        Interaction__c interactObj = new Interaction__c();
        interactObj.Interaction_Type__c = 'Phone Call';
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        interactObj.Other_Admin_Type__c = 'Attorney';
        interactObj.Originator_Type__c = 'Other Admin';
        interactObj.Contact_Name__c = 'Willow Best';
        interactObj.Originator_Name__c = 'Willow Best';
        interactObj.Customer_Admin_Type__c = 'Other Admin';
        //interactObj.Originator_Phone__c=603-594-7894;
        interactObj.Originator_Email__c = 'willow@uhc.com';
        interactObj.Bypass_Validation_Rule__c=true;
        interactObj.Current_Status__c='open';
        insert interactObj;
          Special_Instructions__c sysinst = new Special_Instructions__c();
        sysinst.Business_Unit__c ='ACEC';
        sysinst.Business_Unit__c ='Commissions';
        sysinst.Business_Unit__c ='Broker Commissions';
        sysinst.Business_Unit__c ='1099 Inquiry';
        sysinst.ACET_Role__c='System Administrator';
        sysinst.Effective_Date__c=date.today();
        sysinst.Business_Unit__c='NA Activity';
        
        insert sysinst;
        
        Contact c= new contact();
        c.FirstName='test';
        c.LastName='contact';
        insert c;
        
       
        Case caseObj = new Case();
        caseObj.Interaction__c = interactObj.Id;
        caseObj.Event_Type__c = 'Standard';
        caseObj.OriginatorEmail__c='standard@test.com';
        caseObj.Reward_Account_Number__c ='Group Contact';
        caseObj.Email__c='test@test.com';
        caseObj.Platform__c='cirrus';
        caseObj.Policy__c='234';
        caseObj.Subject_Group_ID__c='100002';
        caseObj.Group_Name__c='testclass';
        caseObj.SourceCode__c='3455';
        caseObj.Situs__c='test';
        caseObj.Sales_Office__c='teststtstst';
        caseObj.Policy_Renewal_Year__c= Date.newInstance(2000,10,10);
        caseObj.ContactId=c.id;
        caseObj.Status='Open';
        caseObj.DOB__c='test';
        caseObj.Subject_Type__c='Group/employer';
        caseObj.Member_SSN__c='929394959';
      caseObj.Issue_Category_Desc__c='testst';
        caseObj.Special_Instructions_Description__c='tset';
        
        insert caseObj;
        
        One_Click_Originator__c originator = new One_Click_Originator__c();
        originator.Originator_Type__c= caseObj.Originator_Type__c;
      
        originator.First_Name__c ='test';
        originator.Last_Name__c ='test';
        originator.Phone_Number__c ='9032296917';
        originator.Email__c =caseObj.OriginatorEmail__c;
        originator.Phone_Ext__c ='91';
        originator.Originator_Type__c ='Group Contact';
        originator.Agency_Broker_Name__c ='Group Contact';
        originator.Reward_Account_Number__c =caseObj.Reward_Account_Number__c;
        originator.General_Agency__c ='Group Contact';
        originator.Franchise_Code__c ='Group Contact';
        originator.Group_Name__c ='Ingersoll';
        originator.Group_Number__c ='1058476';
        originator.Policy_Number__c ='';
        originator.Other_Originator_Type__c ='Attorney';
        insert originator;
     
        
        
        
        Merit_Group__c meritGrp = new Merit_Group__c();
        meritGrp.Group_Name__c = 'Test';
        meritGrp.Policy_Renewal_Date__c = Date.today();
        meritGrp.Policy_Number__c = '12345';
        meritGrp.Group_Number__c = '12345';
        meritGrp.Health_Plan_Major__c = 'Test';
        meritGrp.Health_Plan_Minor__c = 'Test';
        meritGrp.Line_of_Business__c = 'Test';
        meritGrp.Platform__c = 'Test';
        meritGrp.Region__c = 'Test';
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
        insert meritGrp;
  
        
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
        sbamGrp.Funding_Type__c = 'FI';
        insert sbamGrp;
        
        List<Merit_Group__c> MG= [Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM Merit_Group__c  WHERE Policy_Number__c = '12345'];
        List<SBam_Group__c>SB =[Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM SBam_Group__c  WHERE Group_Number__c = '12345'  OR Policy_Number__c ='12345'];
        System.assertEquals(MG.size(), 1);
        System.assertEquals(SB.size(), 1);
        Case solarisCase = new Case();
        solarisCase.Group_Solaris_ID__c = 'aaaaaaaaaa';
        solarisCase.Subject_Name__c = 'Ingersoll Auto Group Inc.';
        solarisCase.Interaction__c = interactObj.Id;
        solarisCase.Issue_Category_Desc__c = 'Commissions';
        solarisCase.Special_Instructions_Description__c = 'TESTING';
        insert solarisCase;
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
        String solarisResults= ETSBE_OneClickController.searchGroup('1058476');
         ETSBE_OpenDetailController.getSelectedGroupInfo('1058476', '');
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
        ETSBE_OpenDetailController.searchBroker('011457');
       String resStr = ETSBE_OneClickController.searchGroupSBamMerit('12345');
        ETSBE_SolarisMockupResponse originatorGroup = new ETSBE_SolarisMockupResponse(200,
                                                                                      'Success',
                                                                                      '{"message":null,"groupResults":[{"teamMembers":[{"Role":"Dedicated Customer Service Manager","Phone":null,"Name":"Tameka Aguilera"}],"SitusState":"CT","SalesOffice":"Connecticut","RenewalEffectiveDate":"2020-12-01","PrimaryRewardAccountName":"Quantum Financial Partners","PrimaryRewardAccount":"a0ga000000825YFAAY","PolicyNumber":"10501","Platform":"Cirrus","MarketSegment":"Key Accounts","Id":"0011400001wWj8RAAS","GAName":null,"FundingType":"FI","CustomerNumber":"1048476","contacts":[{"WorkPhoneExt":"308","WorkPhone":"2038828512","Title":"Payroll BK PG Manager","Name":"Lara French","Id":"0031400002yt2gHAAQ","Email":null,"CellPhone":null},{"WorkPhoneExt":"311","WorkPhone":"2038828810","Title":"CFO","Name":"Roger Letso","Id":"0031400002yt2gIAAQ","Email":"rletso@cccdinc.org","CellPhone":null}],"BusinessMinorMarket":"Connecticut Minor","BusinessMarketRegion":"Northeast Region","BusinessMajorMarket":"New England Major","AccountName":"Milestones Behavioral Services, Inc."}],"failureReason":null,"brokerResults":null}',
                                                                                      null);
        Test.setMock(HttpCalloutMock.class, originatorGroup);
        String caseId=caseObj.id;
       
        ETSBE_OpenDetailController.getCaseInfoMethod(caseId);
        //ETSBE_OpenDetailController.InteractionInfoMethod(interactObj.Id);
        // Case CaseData = [select id,Group_Name__c,Subject_Group_ID__c,Platform__c,Policy__c from Case  where id=:caseobj.Id];
        try{
            ETSBE_OpenDetailController.fetchOriginatorRecord(null);
        }catch(exception e){}
        
        test.stopTest();
     }   
}