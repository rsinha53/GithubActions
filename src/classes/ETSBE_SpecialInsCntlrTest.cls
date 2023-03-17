@isTest
public class ETSBE_SpecialInsCntlrTest {
    
    @testSetup static void createTestData() {
        
        UserRole ur = new UserRole(Name = 'System Administrator');
        insert ur;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User(Alias = 'sysadm', Email='systemadmin@testorg.com', EmailEncodingKey='UTF-8', LastName='Test Admin', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pf.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testadminBEO@testorg.com');
        
        insert u;
        
        System.runAs(u) {
                        
            List<Special_Instructions__c> specInsList = new List<Special_Instructions__c>();
            
            Special_Instructions__c specInstObj = new Special_Instructions__c();
            specInstObj.Business_Unit__c = 'ACEC';
            specInstObj.Topic__c = 'Migration';
            specInstObj.Type__c = 'Inquiry';
            specInstObj.Subtype__c = 'Inquiry';
            specInstObj.SLA_Day__c = '2';
            specInstObj.Directions__c = 'Use for migration inquiries';
            specInstObj.Routing_Option__c = 'ETS';
            specInstObj.Department__c = 'Self Resolved';
            specInstObj.DOS_Required_Indicator__c = 'N';
            specInstObj.Validation_on_Routed_Appl__c = 'numeric';
            specInstObj.Routing_Appl_Desc__c = 'Routed Application';
            specInstObj.ACET_Role__c = 'DCSM';
            specInstObj.Supplemental_Routing__c = 'Policy';
            specInstObj.Effective_Date__c = System.today();
            specInstObj.Supplemental_Routing_Ref__c = 'Commissions';
            specInstObj.Platform__c= 'PRIME';
            specInsList.add(specInstObj);
            
            Special_Instructions__c specInstObj1 = new Special_Instructions__c();
            specInstObj1.Business_Unit__c = 'ACEC';
            specInstObj1.Topic__c = 'Web Portal';
            specInstObj1.Type__c = 'MYUHC Inquiry';
            specInstObj1.Subtype__c = 'Error-provider data';
            specInstObj1.SLA_Day__c = '30';
            specInstObj1.Routing_Option__c = 'URL';
            specInstObj1.Department__c = 'Provider Data Integrity SharePoint Site';
            specInstObj1.DOS_Required_Indicator__c = 'N';
            specInstObj1.Validation_on_Routed_Appl__c = 'numeric';
            specInstObj1.Routing_Appl_Desc__c = 'CA Network Mgmt';
            specInstObj1.ACET_Role__c = 'DCSM - West';
            specInstObj.Supplemental_Routing__c = 'ETS';
            specInstObj1.Effective_Date__c = System.today();  
            specInstObj1.Supplemental_Routing_Ref__c = 'Commissions';
            specInstObj1.Platform__c= 'PRIME';
            
            
            specInsList.add(specInstObj1);  
            
            Special_Instructions__c specInstObj2 = new Special_Instructions__c();
            specInstObj2.Business_Unit__c = 'ACEC';
            specInstObj2.Topic__c = 'Accident Protection';
            specInstObj2.Type__c = 'FACETS';
            specInstObj2.Subtype__c = 'All mbr/grp elig issue/inquiry';
            specInstObj2.SLA_Day__c = '30';
            specInstObj2.Routing_Option__c = 'URL';
            specInstObj2.Department__c = 'Provider Data Integrity SharePoint Site';
            specInstObj2.DOS_Required_Indicator__c = 'N';
            specInstObj2.Validation_on_Routed_Appl__c = 'numeric';
            specInstObj2.Routing_Appl_Desc__c = 'CA Network Mgmt';
            specInstObj2.ACET_Role__c = 'DCSM - West';
            specInstObj.Supplemental_Routing__c = 'Policy';
            specInstObj2.Effective_Date__c = System.today();  
            specInstObj2.Supplemental_Routing_Ref__c = 'Commissions';
            specInstObj2.Platform__c= 'PRIME';
            specInsList.add(specInstObj2);
            
            Special_Instructions__c specInstObj3 = new Special_Instructions__c();
            specInstObj3.Business_Unit__c = 'ACEC';
            specInstObj3.Topic__c = 'Migration';
            specInstObj3.Type__c = 'Inquiry';
            specInstObj3.Subtype__c = 'Inquiry';
            specInstObj3.SLA_Day__c = '2';
            specInstObj3.Directions__c = 'Use for migration inquiries';
            specInstObj3.Routing_Option__c = 'ETS';
            specInstObj3.Department__c = 'Self Resolved';
            specInstObj3.DOS_Required_Indicator__c = 'N';
            specInstObj3.Validation_on_Routed_Appl__c = 'numeric';
            specInstObj3.Routing_Appl_Desc__c = 'Routed Application';
            specInstObj3.ACET_Role__c = 'DCSM';
            specInstObj3.Supplemental_Routing__c = 'Policy';
            specInstObj3.Effective_Date__c = System.today();
            specInstObj3.Supplemental_Routing_Ref__c = 'Commissions';
            specInstObj3.Platform__c='PRIME';
            
            specInsList.add(specInstObj3);       
            
            
            insert specInsList;
            
            Supplemental_Routing__c suppRoutingObj1 = new Supplemental_Routing__c();
            suppRoutingObj1.Policy_Category_Desc__c = 'Commissions';
            suppRoutingObj1.Policy_Number__c = '702476';
            suppRoutingObj1.Platform_Desc__c = 'UNET';
            suppRoutingObj1.Priority_CD__c = '10';
            suppRoutingObj1.Routing_Partner_ID__c = 'test@abc.com';
            
            insert suppRoutingObj1; 
            
            Supplemental_Routing__c suppRoutingObj4 = new Supplemental_Routing__c();
            suppRoutingObj4.Policy_Category_Desc__c = 'Commissions';
            suppRoutingObj4.Policy_Number__c = '702476';
            suppRoutingObj4.Platform_Desc__c = 'ETS';
            suppRoutingObj4.Routing_Partner_ID__c = '15322';
            suppRoutingObj4.Property_Txt__c = 'Issue.GroupRegionID';
            suppRoutingObj4.Val_Txt__c='Northeast|SouthEast';
            
            insert suppRoutingObj4;
            
            Third_Party__c tp =new Third_Party__c();
            tp.First_Name__c ='test';
            tp.LastName__c ='test';
            insert tp;
            
            Interaction__c interactObj = new Interaction__c();
            
            interactObj.Interaction_Type__c = 'Phone Call';
            interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
            interactObj.Other_Admin_Type__c = 'Attorney';
            interactObj.Originator_Type__c = 'Other Admin';
            interactObj.Third_Party__c = tp.Id;
            interactObj.Contact_Name__c = 'Willow Best';
            interactObj.Originator_Name__c = 'Willow Best';
            interactObj.Customer_Admin_Type__c = 'Other Admin';
            //interactObj.Originator_Phone__c=603-594-7894;
            interactObj.Originator_Email__c = 'willow@uhc.com';
            
            insert interactObj;
            contact con=new contact();
            con.FirstName='test';
            con.LastName='sks';
            insert con;
            Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
            
            Case caseObj = new Case();
            caseObj.Interaction__c = interactObj.Id;
            caseObj.Event_Type__c = 'Standard';
            caseObj.SourceCode__c = 'NA';
            caseObj.Policy__c = '12345';
            caseobj.Case_Type__c='BEO Case';
            caseobj.RecordTypeId = recTypeId;
            caseobj.Date_of_Service__c='05/04/2020';
            caseobj.Broker_Name__c='ROBERTA DON';
            caseobj.Group_Name__c='Ingersoll Auto Group Inc.';
            caseobj.Group_ID__c='1058476';
            caseobj.Policy_Year__c='12/01/2020';
            caseobj.Funding_Type__c='ASO';
            caseobj.Platform__c='Cirrus';
            caseobj.Line_of_Business__c='Key Accounts';
            caseobj.Region__c='NortheastBihar';
            caseobj.Policy__c='20501';
            caseobj.Policy_Renewal_Year__c= Date.valueof(Date.newInstance(2020, 12, 9));
            caseobj.Situs__c='CT';
            caseobj.SLA__c=10.0;
            caseobj.Email__c='agtcomp@uhc.com';
            caseobj.TaxID__c='264777940';
            caseobj.ContactId=con.id;
            caseobj.Subject_Type__c='Provider';
            caseobj.Broker_ID__c='011457';
            
            insert caseObj;
            
            Case caseObj1 = new Case();
            caseObj1.Interaction__c = interactObj.Id;
            caseObj1.Event_Type__c = 'Standard';
            caseObj1.SourceCode__c = 'SO';
            caseObj1.Policy__c = '12345';
            caseObj1.Case_Type__c='BEO Case';
            caseObj1.RecordTypeId = recTypeId;
            caseObj1.Date_of_Service__c='05/04/2020';
            caseObj1.Broker_Name__c='ROBERTA CZARNECKI';
            caseObj1.Group_Name__c='Ingersoll Auto Group Inc.';
            caseObj1.Policy_Year__c='12/01/2020';
            caseObj1.Funding_Type__c='ASO';
            caseObj1.Platform__c='Cirrus';
            caseObj1.Line_of_Business__c='Key Accounts';
            caseObj1.Region__c='Northeast';
            caseObj1.Policy__c='20501';
            caseObj1.Policy_Renewal_Year__c= Date.valueof(Date.newInstance(2020, 12, 9));
            caseObj1.Situs__c='CT';
            caseObj1.SLA__c=10.0;
            caseObj1.Email__c='agtcomp@uhc.com';
            caseObj1.TaxID__c='264777940';
            caseObj1.ContactId=con.id;
            caseObj1.Subject_Type__c='Provider';
            insert caseObj1;
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
            
            List<Supplemental_Routing__c> routingLst = new List<Supplemental_Routing__c>();
            
            Supplemental_Routing__c suppRoutingObj = new Supplemental_Routing__c();
            suppRoutingObj.Policy_Category_Desc__c = 'DENTAL CLAIMS DED GRP CNT';
            suppRoutingObj.Policy_Number__c = '702476';
            suppRoutingObj.Platform_Desc__c = 'ETS';
            suppRoutingObj.Routing_Partner_ID__c = '15322';
            
            routingLst.add(suppRoutingObj);
            
            Supplemental_Routing__c suppRoutingObj3 = new Supplemental_Routing__c();
            suppRoutingObj3.Policy_Category_Desc__c = 'Commissions';
            suppRoutingObj3.Routing_Rule_Category_Desc__c = 'Commissions';
            suppRoutingObj3.Policy_Number__c = '702476';
            suppRoutingObj3.Platform_Desc__c = 'ETS';
            suppRoutingObj3.Routing_Partner_ID__c = '15322';
            suppRoutingObj3.Property_Txt__c = 'Issue.CustomerSitus';
            suppRoutingObj3.Val_Txt__c='CT|NC|NY';
            routingLst.add(suppRoutingObj3);
            
            Supplemental_Routing__c suppRoutingObj5 = new Supplemental_Routing__c();
            suppRoutingObj5.Policy_Category_Desc__c = 'Commissions';
            suppRoutingObj5.Routing_Rule_Category_Desc__c = 'Commissions';
            suppRoutingObj5.Policy_Number__c = '702476';
            suppRoutingObj5.Platform_Desc__c = 'ETS';
            suppRoutingObj5.Routing_Partner_ID__c = '15322';
            suppRoutingObj5.Property_Txt__c = 'Issue.GroupRegionID';
            suppRoutingObj5.Val_Txt__c='Northeast|SouthEast';
            routingLst.add(suppRoutingObj5);
            
            Supplemental_Routing__c suppRoutingObj6 = new Supplemental_Routing__c();
            suppRoutingObj6.Policy_Category_Desc__c = 'Commissions CT';
            suppRoutingObj6.Routing_Rule_Category_Desc__c = 'Commissions CT';
            suppRoutingObj6.Policy_Number__c = '702476';
            suppRoutingObj6.Platform_Desc__c = 'ETS';
            suppRoutingObj6.Routing_Partner_ID__c = '15322';
            suppRoutingObj6.Property_Txt__c = 'Issue.CustomerSitus';
            suppRoutingObj6.Val_Txt__c='CT';
            routingLst.add(suppRoutingObj6);  
            
            Supplemental_Routing__c suppRoutingObj7 = new Supplemental_Routing__c();
            suppRoutingObj7.Policy_Category_Desc__c = 'Commissions ETS';
            suppRoutingObj7.Routing_Rule_Category_Desc__c = 'Commissions ETS';
            suppRoutingObj7.Policy_Number__c = '702476';
            suppRoutingObj7.Platform_Desc__c = 'ETS';
            suppRoutingObj7.Routing_Partner_ID__c = '15322';
            suppRoutingObj7.Priority_CD__c = '10';
            suppRoutingObj7.Property_Txt__c = 'Issue.GroupRegionID';
            suppRoutingObj7.Val_Txt__c='Northeast';
            
            routingLst.add(suppRoutingObj7);
            
            Supplemental_Routing__c suppRoutingObj9 = new Supplemental_Routing__c();
            suppRoutingObj9.Policy_Category_Desc__c = 'Commissions ETS';
            suppRoutingObj9.Routing_Rule_Category_Desc__c = 'Commissions ETS';
            suppRoutingObj9.Policy_Number__c = '702476';
            suppRoutingObj9.Platform_Desc__c = 'ETS';
            suppRoutingObj9.Routing_Partner_ID__c = '15322';
            suppRoutingObj9.Priority_CD__c = '20';
            suppRoutingObj9.Property_Txt__c = 'Issue.GroupRegionID';
            suppRoutingObj9.Val_Txt__c='Northeast';
            
            routingLst.add(suppRoutingObj9);
            
            Supplemental_Routing__c suppRoutingObj8 = new Supplemental_Routing__c();
            suppRoutingObj8.Policy_Category_Desc__c = 'Commissions Agency';
            suppRoutingObj8.Routing_Rule_Category_Desc__c = 'Commissions Agency';
            suppRoutingObj8.Policy_Number__c = '702476';
            suppRoutingObj8.Platform_Desc__c = 'ETS';
            suppRoutingObj8.Routing_Partner_ID__c = '15322';
            suppRoutingObj8.Priority_CD__c = '10';
            suppRoutingObj8.Property_Txt__c = 'Event.AgencyName';
            suppRoutingObj8.Val_Txt__c='John Brokerman';
            
            routingLst.add(suppRoutingObj8);
            
            insert routingLst;
            
            
            
            Group g1 = new Group(Name='Test Queue', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            insert q1;
            
        }
        
    }
    
    static testmethod void validateData2() {
        Case caseObj = [Select Id from Case where SourceCode__c='NA' ];
        
        Special_Instructions__c specInstObj1 = new Special_Instructions__c();
        specInstObj1.Business_Unit__c = 'ACEC';
        specInstObj1.Topic__c = 'Web Portal';
        specInstObj1.Type__c = 'MYUHC Inquiry';
        specInstObj1.Subtype__c = 'Error-provider data';
        specInstObj1.SLA_Day__c = '30';
        specInstObj1.Routing_Option__c = 'URL';
        specInstObj1.Department__c = 'Provider Data Integrity SharePoint Site';
        specInstObj1.DOS_Required_Indicator__c = 'N';
        specInstObj1.Validation_on_Routed_Appl__c = 'numeric';
        specInstObj1.Routing_Appl_Desc__c = 'CA Network Mgmt';
        specInstObj1.ACET_Role__c = 'DCSM - West';
        specInstObj1.Supplemental_Routing__c = 'ETS';
        specInstObj1.Effective_Date__c = System.today();  
        specInstObj1.Supplemental_Routing_Ref__c = 'Commissions';
        specInstObj1.Platform__c = 'UNET';
        
        insert specInstObj1;
        
        Special_Instructions__c specInstObj2 = new Special_Instructions__c();
        specInstObj2.Business_Unit__c = 'ACEC';
        specInstObj2.Topic__c = 'Web Portal';
        specInstObj2.Type__c = 'MYUHC Inquiry';
        specInstObj2.Subtype__c = 'Error-provider data';
        specInstObj2.SLA_Day__c = '30';
        specInstObj2.Routing_Option__c = 'URL';
        specInstObj2.Department__c = 'Provider Data Integrity SharePoint Site';
        specInstObj2.DOS_Required_Indicator__c = 'N';
        specInstObj2.Validation_on_Routed_Appl__c = 'numeric';
        specInstObj2.Routing_Appl_Desc__c = 'CA Network Mgmt';
        specInstObj2.ACET_Role__c = 'DCSM - West';
        specInstObj2.Supplemental_Routing__c = '';
        specInstObj2.Effective_Date__c = System.today();  
        specInstObj2.Supplemental_Routing_Ref__c = '';
        specInstObj2.Platform__c = 'UNET';
        
        insert specInstObj2;
        
        List<Special_Instructions__c> specInsList = new List<Special_Instructions__c>();
        specInsList.add(specInstObj1);
        specInsList.add(specInstObj2);
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','ASO');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','ASO');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast"}';

        ETSBE_SpecialInstructionsController.GroupDetails groupData = (ETSBE_SpecialInstructionsController.GroupDetails) System.JSON.deserialize(groupDetailsJSON2, ETSBE_SpecialInstructionsController.GroupDetails.class);        

        ETSBE_SpecialInstructionsController.fetchSpecInstructionData(specInsList, groupData);
        
        Test.stopTest();
    }


    static testmethod void validateData3() {
        Case caseObj = [Select Id from Case  where SourceCode__c='NA'];
        
        Special_Instructions__c specInstObj1 = new Special_Instructions__c();
        specInstObj1.Business_Unit__c = 'ACEC';
        specInstObj1.Topic__c = 'Web Portal';
        specInstObj1.Type__c = 'MYUHC Inquiry';
        specInstObj1.Subtype__c = 'Error-provider data';
        specInstObj1.SLA_Day__c = '30';
        specInstObj1.Routing_Option__c = 'URL';
        specInstObj1.Department__c = 'Provider Data Integrity SharePoint Site';
        specInstObj1.DOS_Required_Indicator__c = 'N';
        specInstObj1.Validation_on_Routed_Appl__c = 'numeric';
        specInstObj1.Routing_Appl_Desc__c = 'CA Network Mgmt';
        specInstObj1.ACET_Role__c = 'DCSM - West';
        specInstObj1.Supplemental_Routing__c = 'ETS';
        specInstObj1.Effective_Date__c = System.today();  
        specInstObj1.Supplemental_Routing_Ref__c = 'Commissions';
        specInstObj1.Platform__c= 'PRIME';
        
        insert specInstObj1; 
        
        List<Special_Instructions__c> specInsList = new List<Special_Instructions__c>();
        specInsList.add(specInstObj1);
        
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast"}';

        ETSBE_SpecialInstructionsController.GroupDetails groupData = (ETSBE_SpecialInstructionsController.GroupDetails) System.JSON.deserialize(groupDetailsJSON2, ETSBE_SpecialInstructionsController.GroupDetails.class);        
        ETSBE_SpecialInstructionsController.fetchSpecInstructionData(specInsList,groupData);
        
        Test.stopTest();
    }    
    
    static testmethod void validateSingleRegionData() {
        Case caseObj = [Select Id from Case  where SourceCode__c='NA'];
        
        Special_Instructions__c specInstObj1 = new Special_Instructions__c();
        specInstObj1.Business_Unit__c = 'ACEC';
        specInstObj1.Topic__c = 'Web Portal';
        specInstObj1.Type__c = 'MYUHC Inquiry';
        specInstObj1.Subtype__c = 'Error-provider data';
        specInstObj1.SLA_Day__c = '30';
        specInstObj1.Routing_Option__c = 'URL';
        specInstObj1.Department__c = 'Provider Data Integrity SharePoint Site';
        specInstObj1.DOS_Required_Indicator__c = 'N';
        specInstObj1.Validation_on_Routed_Appl__c = 'numeric';
        specInstObj1.Routing_Appl_Desc__c = 'CA Network Mgmt';
        specInstObj1.ACET_Role__c = 'DCSM - West';
        specInstObj1.Supplemental_Routing__c = 'ETS';
        specInstObj1.Effective_Date__c = System.today();  
        specInstObj1.Supplemental_Routing_Ref__c = 'Commissions ETS';
        specInstObj1.Platform__c= 'PRIME';
        
        insert specInstObj1;  
        
        List<Special_Instructions__c> specInsList = new List<Special_Instructions__c>();
        specInsList.add(specInstObj1);
        
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast"}';

        ETSBE_SpecialInstructionsController.GroupDetails groupData = (ETSBE_SpecialInstructionsController.GroupDetails) System.JSON.deserialize(groupDetailsJSON2, ETSBE_SpecialInstructionsController.GroupDetails.class);        
        ETSBE_SpecialInstructionsController.fetchSpecInstructionData(specInsList,groupData);
        
        Test.stopTest();
    }
    
    static testmethod void validateSingleCTData() {
        Case caseObj = [Select Id from Case  where SourceCode__c='NA'];
        
        Special_Instructions__c specInstObj1 = new Special_Instructions__c();
        specInstObj1.Business_Unit__c = 'ACEC';
        specInstObj1.Topic__c = 'Web Portal';
        specInstObj1.Type__c = 'MYUHC Inquiry';
        specInstObj1.Subtype__c = 'Error-provider data';
        specInstObj1.SLA_Day__c = '30';
        specInstObj1.Routing_Option__c = 'URL';
        specInstObj1.Department__c = 'Provider Data Integrity SharePoint Site';
        specInstObj1.DOS_Required_Indicator__c = 'N';
        specInstObj1.Validation_on_Routed_Appl__c = 'numeric';
        specInstObj1.Routing_Appl_Desc__c = 'CA Network Mgmt';
        specInstObj1.ACET_Role__c = 'DCSM - West';
        specInstObj1.Supplemental_Routing__c = 'ETS';
        specInstObj1.Effective_Date__c = System.today();  
        specInstObj1.Supplemental_Routing_Ref__c = 'Commissions CT';
        specInstObj1.Platform__c= 'PRIME';
        
        insert specInstObj1;
        
        List<Special_Instructions__c> specInsList = new List<Special_Instructions__c>();
        specInsList.add(specInstObj1);
        
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast"}';

        ETSBE_SpecialInstructionsController.GroupDetails groupData = (ETSBE_SpecialInstructionsController.GroupDetails) System.JSON.deserialize(groupDetailsJSON2, ETSBE_SpecialInstructionsController.GroupDetails.class);        
        ETSBE_SpecialInstructionsController.fetchSpecInstructionData(specInsList,groupData);
        
        Test.stopTest();
    }
    
    static testmethod void validateAgencyData() {
        Case caseObj = [Select Id from Case  where SourceCode__c='NA'];
        
        Special_Instructions__c specInstObj1 = new Special_Instructions__c();
        specInstObj1.Business_Unit__c = 'ACEC';
        specInstObj1.Topic__c = 'Web Portal';
        specInstObj1.Type__c = 'MYUHC Inquiry';
        specInstObj1.Subtype__c = 'Error-provider data';
        specInstObj1.SLA_Day__c = '30';
        specInstObj1.Routing_Option__c = 'URL';
        specInstObj1.Department__c = 'Provider Data Integrity SharePoint Site';
        specInstObj1.DOS_Required_Indicator__c = 'N';
        specInstObj1.Validation_on_Routed_Appl__c = 'numeric';
        specInstObj1.Routing_Appl_Desc__c = 'CA Network Mgmt';
        specInstObj1.ACET_Role__c = 'DCSM - West';
        specInstObj1.Supplemental_Routing__c = 'ETS';
        specInstObj1.Effective_Date__c = System.today();  
        specInstObj1.Supplemental_Routing_Ref__c = 'Commissions Agency';
        specInstObj1.Platform__c= 'PRIME';
        
        insert specInstObj1;
         
        List<Special_Instructions__c> specInsList = new List<Special_Instructions__c>();
        specInsList.add(specInstObj1);
        
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast"}';

        ETSBE_SpecialInstructionsController.GroupDetails groupData = (ETSBE_SpecialInstructionsController.GroupDetails) System.JSON.deserialize(groupDetailsJSON2, ETSBE_SpecialInstructionsController.GroupDetails.class);        
        ETSBE_SpecialInstructionsController.fetchSpecInstructionData(specInsList,groupData);
        
        Test.stopTest();
    }
    
    static testmethod void validateCDXData() {
        Case caseObj = [Select Id from Case  where SourceCode__c='NA'];
        
        Special_Instructions__c specInstObj1 = new Special_Instructions__c();
        specInstObj1.Business_Unit__c = 'ACEC';
        specInstObj1.Topic__c = 'Web Portal';
        specInstObj1.Type__c = 'MYUHC Inquiry';
        specInstObj1.Subtype__c = 'Error-provider data';
        specInstObj1.SLA_Day__c = '30';
        specInstObj1.Routing_Option__c = 'URL';
        specInstObj1.Department__c = 'Provider Data Integrity SharePoint Site';
        specInstObj1.DOS_Required_Indicator__c = 'N';
        specInstObj1.Validation_on_Routed_Appl__c = 'numeric';
        specInstObj1.Routing_Appl_Desc__c = 'CA Network Mgmt';
        specInstObj1.ACET_Role__c = 'DCSM - West';
        specInstObj1.Supplemental_Routing__c = 'CDX';
        specInstObj1.Effective_Date__c = System.today();  
        specInstObj1.Supplemental_Routing_Ref__c = 'Commissions Agency';
        specInstObj1.Platform__c= 'PRIME';
        insert specInstObj1;
         
        List<Special_Instructions__c> specInsList = new List<Special_Instructions__c>();
        specInsList.add(specInstObj1);
        
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','None');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"12345","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast","sourceCode":"NA"}';
        
        ETSBE_SpecialInstructionsController.GroupDetails groupData = (ETSBE_SpecialInstructionsController.GroupDetails) System.JSON.deserialize(groupDetailsJSON2, ETSBE_SpecialInstructionsController.GroupDetails.class);        
        ETSBE_SpecialInstructionsController.fetchSpecInstructionData(specInsList,groupData);
        
        Test.stopTest();
    }
    static testmethod void validateDataWithNoSOurceCode() {
        
        Case caseObj = [Select Id,CaseNumber,Broker_Name__c,Broker_ID__c,Group_Name__c,Group_ID__c,Policy_Year__c,Funding_Type__c,Platform__c,RecordTypeId,Date_of_Service__c,ContactId,TaxID__c,Subject_Type__c from Case  where Region__c = 'NortheastBihar' limit 1]; 
        
        Case caseObj1= [Select Id from Case  where SourceCode__c='SO'];
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast"}';
        ETSBE_SpecialInstructionsController.processTTSResults(groupDetailsJSON, 'ACEC', 'Migration', 'Inquiry', 'Inquiry', 'DCSM', '');
        ETSBE_SpecialInstructionsController.processTTSResults(groupDetailsJSON2, 'ACEC', 'Web Portal', 'MYUHC Inquiry', 'Error-provider data', 'DCSM - West', '');        
        
        Special_Instructions__c[] specInsObj = [Select Id,Business_Unit__c,Topic__c,Type__c,Subtype__c from Special_Instructions__c];
        Interaction__c interactObj = [Select Id from Interaction__c];
        Schema.SObjectType.Case.getRecordTypeInfosByName().get('SAE Provider').getRecordTypeId();
        String caseWrapper = '{"providerNotFound":false,"updateCaseId":"'+caseObj.id+'",specialInstructions":"'+specInsObj[0].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[0].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[0].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[0].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[0].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","isCloned":false,"specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsQueue":"Test Queue","groupName":"","groupId":"","groupPolicyYear":"","groupSitusState":"","groupFundingType":"","platformType":"","SubjectId":"","SubjectGroupId":"","slaDay":"2","emailURL":"life_eligibility@uhc.com","otherAdminType":"Attorney","Interaction":"'+interactObj.Id+'","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectName":"ROBERT ROBERTS","SubjectDOB":"11/24/1979","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":"","groupPolicyRenewalYear":"12/1/2018"}';
        String caseId = ETSBE_SpecialInstructionsController.saveTTSCase(caseWrapper, false, '', null, 'Standard', '','saveTTSCase@uhc.com','TTS/ACSE','TTS/ACSE');//DE385766
        Interaction__c intTest = ETSBE_SpecialInstructionsController.getInteractionDetails(interactObj.Id);
        
        CaseComment newCaseComment = new CaseComment();
        newCaseComment.CommentBody = 'Test Comments';
        newCaseComment.ParentId = caseObj.id;
        insert newCaseComment;
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.txt';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = caseObj.id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        //String caseWrapper1 = '{"providerNotFound":false,"specialInstructions":"'+specInsObj[0].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[0].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[0].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[0].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[0].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"","specialInstructionsQueue":"","groupName":"","groupId":"","groupPolicyYear":"","groupSitusState":"","groupFundingType":"","platformType":"","SubjectId":"","SubjectGroupId":"","slaDay":"2","emailURL":"life_eligibility@uhc.com","otherAdminType":"Attorney","Interaction":"'+interactObj.Id+'","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Alternative Medicine Provider","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectName":"ROBERT ROBERTS","SubjectDOB":"11/24/1979","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":"","parentCaseId":"'+caseId+'"}';
        String caseWrapper1 = '{"providerNotFound":false,"updateCaseId":"'+caseObj.id+'","isCloned":false,"specialInstructions":"'+specInsObj[0].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[0].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[0].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[0].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[0].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsQueue":"Test Queue","groupName":"","groupId":"","groupPolicyYear":"","groupSitusState":"","groupFundingType":"","platformType":"","SubjectId":"","SubjectGroupId":"","slaDay":"2","emailURL":"life_eligibility@uhc.com","otherAdminType":"Attorney","Interaction":"'+interactObj.Id+'","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectName":"ROBERT ROBERTS","SubjectDOB":"11/24/1979","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":"","memberRelationship":"child","parentCaseId":"'+caseId+'"}';
        ETSBE_SpecialInstructionsController.saveTTSCase(caseWrapper1, false, '', null, 'Standard', '','','TTS/ACSE','TTS/ACSE');//DE385766
        
        //Excpetion Code Covered
        ETSBE_SpecialInstructionsController.saveTTSCase(caseWrapper, false, '', '', 'Standard', '','test@test.com','TTS/ACSE','TTS/ACSE');//DE385766
        ETSBE_SolarisMockupResponse fakeResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"access_token": "sForceTest1"}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ETSBE_SolarisMockupResponse groupResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                    'Success',
                                                                                    '{"message":null,"groupResults":[{"teamMembers":[{"Role":"Medical IM","Phone":null,"Name":"Ramirez Karen"}],"SitusState":"CT","SalesOffice":"Connecticut","RenewalEffectiveDate":"2020-12-01","PrimaryRewardAccountName":null,"PrimaryRewardAccount":null,"PolicyNumber":"20501","Platform":"Oxford","MarketSegment":"Key Accounts","Id":"0011400001wWKPMAA4","GAName":null,"FundingType":"FI","CustomerNumber":"12345","contacts":[{"WorkPhoneExt":null,"WorkPhone":"2037305766","Title":null,"Name":"Beth Boguess","Id":"0030r00000KvlYPAAZ","Email":"test@optum.com","CellPhone":null}],"BusinessMinorMarket":"Connecticut Minor","BusinessMarketRegion":"Northeast Region","BusinessMajorMarket":"New England Major","AccountName":"Ingersoll Auto Group Inc."}],"failureReason":null,"brokerResults":null}',
                                                                                    null);
        Test.setMock(HttpCalloutMock.class, groupResponse);
        ETSBE_SpecialInstructionsController.getCaseDetails(caseObj1.id, '');
        
        ETSBE_SpecialInstructionsController.getcloneCaseDetails(caseObj1.id, '');
        ETSBE_SpecialInstructionsController.getCaseDetails(caseObj1.id, 'ChildCase');
        
        String contactId = ETSBE_SpecialInstructionsController.getContactIdForHouseHoldMember('Member','John','Smith','1235678904','01/01/1990','No');
        
        
        //String caseWrapper2 = '{"providerNotFound":false,"specialInstructions":"'+specInsObj[1].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[1].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[1].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[1].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[1].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsQueue":"Test Queue","slaDay":"2","emailURL":"life_eligibility1@uhc.com"}';
        String caseWrapper2 = '{"providerNotFound":false,"specialInstructions":"'+specInsObj[1].Id+'","issueCategoryDesc":"'+specInsObj[1].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[1].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[1].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsQueue":"Test Queue","slaDay":"2","emailURL":"life_eligibility1@uhc.com"}';
    
        ETSBE_SpecialInstructionsController.updateTTSCase(caseWrapper2, '', 'Test Desc', caseObj.id);
        
        Test.stopTest();
        
    }
    
    static testmethod void validateData() {
        
        Case caseObj = [Select Id,Broker_Name__c,Broker_ID__c,Group_Name__c,Group_ID__c,Policy_Year__c,Funding_Type__c,Platform__c,RecordTypeId,Date_of_Service__c,ContactId,TaxID__c,Subject_Type__c from Case  where Region__c = 'NortheastBihar' limit 1]; 
        
        Test.startTest();
        
        ETSBE_SpecialInstructionsController.getUser();
        
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Business Unit', '', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'ACEC', '', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Topic', 'UHC Service Resolution Team', '', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'System Administrator', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'ACEC', 'Medical', '', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Type', 'UHC Service Resolution Team', 'Medical', '', 'SRT - West', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Report', 'System Administartor', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'ACEC', 'Medical', 'Claims - Corrected Claim Pends', 'DCSM', '','');
        ETSBE_SpecialInstructionsController.populateBusinessDropdown('Subtype', 'UHC Service Resolution Team', 'Medical', 'Benefit Exception', 'SRT - West', '','');
        
        String groupDetailsJSON = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":""}';
        String groupDetailsJSON2 = '{"policyNumber":"702476","groupNumber":"702476","platform":"UNET","situsState":"CT","lineOfBusiness":"Key Accounts","AgencyBrokerName":"John Brokerman","region":"Northeast"}';
        ETSBE_SpecialInstructionsController.processTTSResults(groupDetailsJSON, 'ACEC', 'Migration', 'Inquiry', 'Inquiry', 'DCSM', '');
        ETSBE_SpecialInstructionsController.processTTSResults(groupDetailsJSON2, 'ACEC', 'Web Portal', 'MYUHC Inquiry', 'Error-provider data', 'DCSM - West', '');        
        
        Special_Instructions__c[] specInsObj = [Select Id,Business_Unit__c,Topic__c,Type__c,Subtype__c from Special_Instructions__c];
        Interaction__c interactObj = [Select Id from Interaction__c];
        Schema.SObjectType.Case.getRecordTypeInfosByName().get('SAE Provider').getRecordTypeId();
        String caseWrapper = '{"providerNotFound":true,"updateCaseId":"'+caseObj.id+'","specialInstructions":"'+specInsObj[0].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[0].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[0].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[0].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[0].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","isCloned":false,"specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsQueue":"Test Queue","groupName":"","groupId":"","groupPolicyYear":"","groupSitusState":"","groupFundingType":"","platformType":"","SubjectId":"","SubjectGroupId":"","slaDay":"2","emailURL":"life_eligibility@uhc.com","otherAdminType":"Attorney","Interaction":"'+interactObj.Id+'","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":false,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectName":"ROBERT ROBERTS","SubjectDOB":"11/24/1979","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":"","groupPolicyRenewalYear":"12/1/2018"}';
        String caseId = ETSBE_SpecialInstructionsController.saveTTSCase(caseWrapper, false, '', null, 'Standard', '','life_eligibility@uhc.com','TTS/ACSE','TTS/ACSE');//DE385766
        
        System.debug('caseId-'+caseId);
        List<Case> caseOb = [Select Id,Policy__c,SourceCode__c from Case where Id =:caseId];
        if(caseOb.size()!=null &&caseOb.size()>0){
            caseOb[0].Policy__c = '12345';
            caseOb[0].SourceCode__c = 'NA';
            update caseOb;
        }
        Interaction__c intTest = ETSBE_SpecialInstructionsController.getInteractionDetails(interactObj.Id);
        
        CaseComment newCaseComment = new CaseComment();
        newCaseComment.CommentBody = 'Test Comments';
        newCaseComment.ParentId = caseObj.id;
        insert newCaseComment;
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.txt';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = caseObj.id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        //String caseWrapper1 = '{"providerNotFound":false,"specialInstructions":"'+specInsObj[0].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[0].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[0].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[0].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[0].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"","specialInstructionsQueue":"","groupName":"","groupId":"","groupPolicyYear":"","groupSitusState":"","groupFundingType":"","platformType":"","SubjectId":"","SubjectGroupId":"","slaDay":"2","emailURL":"life_eligibility@uhc.com","otherAdminType":"Attorney","Interaction":"'+interactObj.Id+'","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Alternative Medicine Provider","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectName":"ROBERT ROBERTS","SubjectDOB":"11/24/1979","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":"","parentCaseId":"'+caseId+'"}';
        String caseWrapper1 = '{"providerNotFound":false,"updateCaseId":"'+caseObj.id+'","isCloned":false,"specialInstructions":"'+specInsObj[0].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[0].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[0].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[0].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[0].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":'+caseObj.Date_of_Service__c+'"","specialInstructionsQueue":"Test Queue","groupName":"","groupId":"","groupPolicyYear":"","groupSitusState":"","groupFundingType":"","platformType":"","SubjectId":"","SubjectGroupId":"","slaDay":"2","emailURL":"life_eligibility@uhc.com","otherAdminType":"Attorney","Interaction":"'+interactObj.Id+'","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":false,"isOtherSearch":true,"mnf":"mnf","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectName":"ROBERT ROBERTS","SubjectDOB":"11/24/1979","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":"","memberRelationship":"child","parentCaseId":"'+caseId+'"}';
        ETSBE_SpecialInstructionsController.saveTTSCase(caseWrapper1, true, '', null, 'Standard', '','test@test.com','TTS/ACSE','TTS/ACSE');//DE385766
        
        //Excpetion Code Covered
        ETSBE_SpecialInstructionsController.saveTTSCase(caseWrapper, false, '', '', 'Standard', '','test@test.com','TTS/ACSE','TTS/ACSE');//DE385766
        ETSBE_SolarisMockupResponse fakeResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"access_token": "sForceTest1"}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ETSBE_SolarisMockupResponse groupResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                    'Success',
                                                                                    '{"message":null,"groupResults":[{"teamMembers":[{"Role":"Medical IM","Phone":null,"Name":"Ramirez Karen"}],"SitusState":"CT","SalesOffice":"Connecticut","RenewalEffectiveDate":"2020-12-01","PrimaryRewardAccountName":null,"PrimaryRewardAccount":null,"PolicyNumber":"20501","Platform":"Oxford","MarketSegment":"Key Accounts","Id":"0011400001wWKPMAA4","GAName":null,"FundingType":"FI","CustomerNumber":"12345","contacts":[{"WorkPhoneExt":null,"WorkPhone":"2037305766","Title":null,"Name":"Beth Boguess","Id":"0030r00000KvlYPAAZ","Email":"test@optum.com","CellPhone":null}],"BusinessMinorMarket":"Connecticut Minor","BusinessMarketRegion":"Northeast Region","BusinessMajorMarket":"New England Major","AccountName":"Ingersoll Auto Group Inc."}],"failureReason":null,"brokerResults":null}',
                                                                                    null);
        Test.setMock(HttpCalloutMock.class, groupResponse);
        ETSBE_SpecialInstructionsController.getCaseDetails(caseObj.id, '');
        ETSBE_SpecialInstructionsController.getCaseDetails(caseObj.id, 'ChildCase');
        
        String contactId = ETSBE_SpecialInstructionsController.getContactIdForHouseHoldMember('Member','John','Smith','1235678904','01/01/1990','No');
        
        
        //String caseWrapper2 = '{"providerNotFound":false,"specialInstructions":"'+specInsObj[1].Id+'","specialInstructionsBusinessUnit":"'+specInsObj[1].Business_Unit__c+'","issueCategoryDesc":"'+specInsObj[1].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[1].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[1].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsQueue":"Test Queue","slaDay":"2","emailURL":"life_eligibility1@uhc.com"}';
        String caseWrapper2 = '{"providerNotFound":false,"specialInstructions":"'+specInsObj[1].Id+'","issueCategoryDesc":"'+specInsObj[1].Topic__c+'","taskCategoryTypeDesc":"'+specInsObj[1].Type__c+'","taskCategorySubtypeDesc":"'+specInsObj[1].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","specialInstructionsReferenceID":"123","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsQueue":"Test Queue","slaDay":"2","emailURL":"life_eligibility1@uhc.com"}';
     
        ETSBE_SpecialInstructionsController.updateTTSCase(caseWrapper2, '', 'Test Desc', caseObj.id);
        
        Test.stopTest();
        
    }
    
    static testmethod void testSpecialInstructionsConstants() {
        
        ETSBE_SpecialInstructions etsbeSpecInsConst = new ETSBE_SpecialInstructions();
        etsbeSpecInsConst.businessUnit = '';
        etsbeSpecInsConst.topic = '';        
        etsbeSpecInsConst.topic = '';
        etsbeSpecInsConst.type = '';
        etsbeSpecInsConst.subtype = '';
        etsbeSpecInsConst.urlEmail = '';
        etsbeSpecInsConst.formLink = '';
        etsbeSpecInsConst.directions = '';
        etsbeSpecInsConst.slaDay = '';
        etsbeSpecInsConst.routingOptions = '';
        etsbeSpecInsConst.departmentDesc = '';
        etsbeSpecInsConst.dosRequired = false;
        etsbeSpecInsConst.queueName = '';
        etsbeSpecInsConst.sfId = '';
        etsbeSpecInsConst.acetTopic = '';
        etsbeSpecInsConst.acetType = '';
        etsbeSpecInsConst.acetSubtype = '';
        etsbeSpecInsConst.valOnRoutedAppl = '';     
        etsbeSpecInsConst.routingApplDesc = '';
        etsbeSpecInsConst.isCDX = true;
    }
    
    static testmethod void fetchSpecInstructionDataTest() {   
        list<Special_Instructions__c> specialIns=[select id,Name,Member_ID_Required_Indicator__c,Queue_Name__c,Department__c,SLA_Day__c,URL_Email__c,Form_Link__c,Directions__c,Business_Unit__c,Topic__c,Type__c,Subtype__c,Routing_Option__c,
                                                  DOS_Required_Indicator__c,Validation_on_Routed_Appl__c,Routing_Appl_Desc__c,ACET_Role__c,Supplemental_Routing__c,Effective_Date__c,Supplemental_Routing_Ref__c,Platform__c from Special_Instructions__c where Supplemental_Routing_Ref__c = 'Commissions'];
        ETSBE_SpecialInstructionsController.SpecialInstructionsWrapper wrapper = new ETSBE_SpecialInstructionsController.SpecialInstructionsWrapper();
        
        ETSBE_SpecialInstructionsController.GroupDetails gpdetails=new ETSBE_SpecialInstructionsController.GroupDetails();
        
        Test.startTest();
        wrapper=ETSBE_SpecialInstructionsController.fetchSpecInstructionData(specialIns,gpdetails);            
        Test.stopTest();
        
        
    }
    
    static testmethod void saveTTSCaseTest() {   
        Interaction__c interactObj = [Select Id from Interaction__c];
        Case caseObj = [Select Id,Region__c,Broker_Name__c,Broker_ID__c,Group_Name__c,Group_ID__c,Policy_Year__c,Funding_Type__c,Platform__c,RecordTypeId,Date_of_Service__c,ContactId,TaxID__c,Subject_Type__c from Case  where Region__c = 'NortheastBihar' limit 1]; 
        Special_Instructions__c[] specialIns = [Select Id,Business_Unit__c,Topic__c,Type__c,Subtype__c from Special_Instructions__c];      
        System.assertEquals('NortheastBihar',caseObj.Region__c);
        String caseWrapper = '{"providerNotFound":false,"updateCaseId":"'+caseObj.id+'","groupFundingType":"'+caseObj.Funding_Type__c+'",groupId":"'+caseObj.Group_ID__c+'","groupPolicyYear":"'+caseObj.Policy_Year__c+'","groupName":"'+caseObj.Group_Name__c+'",brokerId":"'+caseObj.Broker_ID__c+'",brokerName":"'+caseObj.Broker_Name__c+'",specialInstructions":"'+specialIns[0].Id+'","specialInstructionsDateOfService":"'+caseObj.Date_of_Service__c+'","specialInstructionsBusinessUnit":"'+specialIns[0].Business_Unit__c+'","issueCategoryDesc":"'+specialIns[0].Topic__c+'","taskCategoryTypeDesc":"'+specialIns[0].Type__c+'","taskCategorySubtypeDesc":"'+specialIns[0].Subtype__c+'","specialInstructionsSubject":"1","specialInstructionsDescription":"sdsfd","isCloned":false,"specialInstructionsReferenceID":"123","specialInstructionsQueue":"Test Queue","platformType":"","SubjectId":"","SubjectGroupId":"","slaDay":"2","emailURL":"life_eligibility@uhc.com","otherAdminType":"Attorney","Interaction":"'+interactObj.Id+'","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"System Unavailable","AddInfoOrginSubType":"CAM Fee Dispute","ttsType":"Alternative Medicine Provider","ttsSubType":"CAM Fee Dispute","noProviderToSearch":false,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectName":"ROBERT ROBERTS","SubjectDOB":"11/24/1979","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":0,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":"","groupPolicyRenewalYear":"12/1/2018","mnf :"pnf"}';
        
        Test.startTest();
        String caseId = ETSBE_SpecialInstructionsController.saveTTSCase(caseWrapper,true,'', null, 'Standard', '','saveTTSCase@uhc.com','TTS/ACSE','TTS/ACSE');//DE385766
        Test.stopTest();
        
    }
    
    static testmethod void insertAttachmentsAndCaseCommentstoChildCaseTest() {   
        
        List<case> caseObj=[select id,Event_Type__c from case where Event_Type__c = 'Standard' limit 1];
        CaseComment newCaseComment = new CaseComment();
        newCaseComment.CommentBody = 'Test Comments';
        newCaseComment.ParentId = caseObj[0].id;
        newCaseComment.IsPublished=true;
        insert newCaseComment;
        System.assertEquals(true,newCaseComment.IsPublished);
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.txt';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;       
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = caseObj[0].id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;  
       
        Test.startTest();      
        ETSBE_SpecialInstructionsController.insertAttachmentsAndCaseCommentstoChildCase(caseObj[0].id,caseObj[0].id);      
        Test.stopTest();          
    }
    
    Static testmethod void submitRootCauseAnalysisTest(){
        String rootCauseDetailsJSON = '[{"issueCategory":"Accident Protection","defectType":"Maintenance","rootCauseIssueCategory":"Maintenance","rootCause":"DEFAULT","briefDesc":"","serviceImpactDate":"04/16/2020","businessUnit":"ACEC"}]';
        Case caseObj = [Select Id,CaseNumber,Broker_Name__c,Broker_ID__c,Group_Name__c,Group_ID__c,Policy_Year__c,Funding_Type__c,Platform__c,RecordTypeId,Date_of_Service__c,ContactId,TaxID__c,Subject_Type__c from Case  where Region__c = 'NortheastBihar' AND Broker_Name__c='ROBERTA DON' limit 1]; 
        Root_Cause__c rootCause=new Root_Cause__c();
        rootCause.Case__c=caseObj.Id;
        rootCause.Issue_ID__c=caseObj.CaseNumber;
        insert rootCause;
        System.assertEquals('ROBERTA DON',caseObj.Broker_Name__c);
       
        Test.startTest();
        ETSBE_SpecialInstructionsController.submitRootCauseAnalysis(rootCauseDetailsJSON, caseObj.id);
        Test.stopTest();
    }
    
}