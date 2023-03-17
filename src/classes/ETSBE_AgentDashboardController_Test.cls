@isTest

Public class ETSBE_AgentDashboardController_Test{
    
    @isTest
    public static void dashboardmethods(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', BEO_Specialty__c='DCSM',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtetsBEO@testorg.com');
        insert u;
        u=[select id,name,BEO_Specialty__c,Role_Name__c from user where id=: u.id];
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
        
        specInsList.add(specInstObj3);       
        
        
        insert specInsList;
        
        
       
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
             List<string> templist=new List<string>();
             templist.add('test');
             templist.add('test1');
            ETSBE_AgentDashboardController.populateBusinessDropdown(templist,'Business Unit',u.BEO_Specialty__c,'System Administrator');
        
             ETSBE_AgentDashboardController.populateBusinessDropdown(templist,'Business Unit','System Administrator','System Administrator');
        
        ETSBE_AgentDashboardController.fetchUser();
        ETSBE_AgentDashboardController.getUsers();
        
        
        Interaction__c lastintdata = new Interaction__c();
        lastintdata.Evt_Recvd_Dt_Time__c =date.today().addDays(-355);
        lastintdata.Resolution_Date__c = date.today();
        lastintdata.Current_Status__c ='Closed';
        insert lastintdata;
            Interaction__c intdata = new Interaction__c();
            intdata.Evt_Recvd_Dt_Time__c =date.today().addDays(-10);
            intdata.Resolution_Date__c = date.today();
            intdata.Current_Status__c ='Closed';
            insert intdata;
              Interaction__c intdata1 = new Interaction__c();
            intdata1.Evt_Recvd_Dt_Time__c =date.today().addDays(-10);
            intdata1.Resolution_Date__c = date.today();
            intdata1.Current_Status__c ='Closed';
            insert intdata1;
        for(integer i=0;i<2;i++){
            Interaction__c openintdata1 = new Interaction__c();
            openintdata1.Evt_Recvd_Dt_Time__c =date.today();
            openintdata1.Current_Status__c ='Open';
            insert openintdata1; 
        }
             for(integer i=0;i<2;i++){
             Interaction__c openintdata111 = new Interaction__c();
            openintdata111.Evt_Recvd_Dt_Time__c =date.today().addDays(-1);
            openintdata111.Current_Status__c ='Open';
            insert openintdata111;
             }
             for(integer i=0;i<2;i++){
        Interaction__c openintdata11 = new Interaction__c();
            openintdata11.Evt_Recvd_Dt_Time__c =date.today().addDays(-2);
            openintdata11.Current_Status__c ='Open';
            insert openintdata11; 
             }
             for(integer i=0;i<2;i++){
        Interaction__c openintdata11 = new Interaction__c();
            openintdata11.Evt_Recvd_Dt_Time__c =date.today().addDays(-3);
            openintdata11.Current_Status__c ='Open';
            insert openintdata11;
             }
             for(integer i=0;i<2;i++){
            Interaction__c openintdata2 = new Interaction__c();
            openintdata2.Evt_Recvd_Dt_Time__c =date.today().addDays(-4);
            openintdata2.Current_Status__c ='Open';
            insert openintdata2;
             }
             for(integer i=0;i<2;i++){
        	Interaction__c openintdata21 = new Interaction__c();
            openintdata21.Evt_Recvd_Dt_Time__c =date.today().addDays(-10);
            openintdata21.Current_Status__c ='Open';
            insert openintdata21;
             } 
             for(integer i=0;i<2;i++){
        	Interaction__c openintdata21 = new Interaction__c();
            openintdata21.Evt_Recvd_Dt_Time__c =date.today().addDays(-15);
            openintdata21.Current_Status__c ='Open';
            insert openintdata21; 
             }
             for(integer i=0;i<2;i++){
        	Interaction__c openintdata21 = new Interaction__c();
            openintdata21.Evt_Recvd_Dt_Time__c =date.today().addDays(-25);
            openintdata21.Current_Status__c ='Open';
            insert openintdata21;
             }
             for(integer i=0;i<2;i++){
        	Interaction__c openintdata21 = new Interaction__c();
            openintdata21.Evt_Recvd_Dt_Time__c =date.today().addDays(-30);
            openintdata21.Current_Status__c ='Open';
            insert openintdata21;
             }
             for(integer i=0;i<2;i++){
        	Interaction__c openintdata21 = new Interaction__c();
            openintdata21.Evt_Recvd_Dt_Time__c =date.today().addDays(-35);
            openintdata21.Current_Status__c ='Open'; 
            insert openintdata21; 
             }
                          for(integer i=0;i<2;i++){
        	Interaction__c openintdata21 = new Interaction__c();
            openintdata21.Evt_Recvd_Dt_Time__c =date.today().addDays(-45);
            openintdata21.Current_Status__c ='Open';
            insert openintdata21;
             }
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
        Case caseData =new Case();
        caseData.Special_Instructions_Business_Unit__c ='ACSM';
        caseData.Status = 'Open';
        caseData.Case_Type__c = 'BEO Case';
		caseData.RecordTypeId = recTypeId;
        insert caseData;
        
        Case closedcaseData =new Case();
        closedcaseData.Special_Instructions_Business_Unit__c ='ACSM';
        closedcaseData.Status = 'Closed';
        // closedcaseData.ClosedDate = date.today();
        closedcaseData.Case_Type__c = 'BEO Case';
		closedcaseData.RecordTypeId = recTypeId;
        insert closedcaseData;
        
        
        
        
       ETSBE_AgentDashboardController.interactionclosedScoreCard(userinfo.getname(),'');
        ETSBE_AgentDashboardController.interactionclosedScoreCard(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
        ETSBE_AgentDashboardController.openCases(userinfo.getname(),'');
        ETSBE_AgentDashboardController.openCases(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
        ETSBE_AgentDashboardController.closedCases(userinfo.getname(),'');
        ETSBE_AgentDashboardController.closedCases(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
        ETSBE_AgentDashboardController.interactionScoreCard(userinfo.getname(),'');
        ETSBE_AgentDashboardController.interactionScoreCard(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
       
     }
    }
    public static void dashboardmethodssystem(){
        
        
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
        
        specInsList.add(specInstObj3);       
        
        
        insert specInsList;
        
        
       
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
             List<string> templist=new List<string>();
             templist.add('test');
            ETSBE_AgentDashboardController.populateBusinessDropdown(templist,'Business Unit','','System Administrator');
        
             ETSBE_AgentDashboardController.populateBusinessDropdown(templist,'Business Unit','System Administrator','System Administrator');
        
        ETSBE_AgentDashboardController.fetchUser();
        ETSBE_AgentDashboardController.getUsers();
        
        
        Interaction__c lastintdata = new Interaction__c();
        lastintdata.Evt_Recvd_Dt_Time__c =date.today().addDays(-355);
        lastintdata.Resolution_Date__c = date.today();
        lastintdata.Current_Status__c ='Closed';
        insert lastintdata;
        for(integer i=0;i<10;i++) {
            Interaction__c intdata = new Interaction__c();
            intdata.Evt_Recvd_Dt_Time__c =date.today().addDays(i-10);
            intdata.Resolution_Date__c = date.today();
            intdata.Current_Status__c ='Closed';
            insert intdata;
        }
        for(integer i=0;i<10;i++) {
            Interaction__c openintdata = new Interaction__c();
            openintdata.Evt_Recvd_Dt_Time__c =date.today().addDays(i+2);
            openintdata.Current_Status__c ='Open';
            insert openintdata;
        }
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
        Case caseData =new Case();
        caseData.Special_Instructions_Business_Unit__c ='ACSM';
        caseData.Status = 'Open';
        caseData.Case_Type__c = 'BEO Case';
		caseData.RecordTypeId = recTypeId;
        insert caseData;
        
        Case closedcaseData =new Case();
        closedcaseData.Special_Instructions_Business_Unit__c ='ACSM';
        closedcaseData.Status = 'Closed';
        closedcaseData.Case_Type__c = 'BEO Case';
		closedcaseData.RecordTypeId = recTypeId;
        insert closedcaseData;
        
        
        
        
       ETSBE_AgentDashboardController.interactionclosedScoreCard(userinfo.getname(),'');
        ETSBE_AgentDashboardController.interactionclosedScoreCard(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
        ETSBE_AgentDashboardController.openCases(userinfo.getname(),'');
        ETSBE_AgentDashboardController.openCases(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
        ETSBE_AgentDashboardController.closedCases(userinfo.getname(),'');
        ETSBE_AgentDashboardController.closedCases(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
        ETSBE_AgentDashboardController.interactionScoreCard(userinfo.getname(),'');
        ETSBE_AgentDashboardController.interactionScoreCard(userinfo.getname(),caseData.Special_Instructions_Business_Unit__c);
       
     }
    
    
}