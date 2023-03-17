/********************************************************************************* 
Class Name     : SNI_FL_CaseCreateUpdateNotification_Test.cls
Description    : created Test class for SNI_FL_CaseCreateUpdateNotification
Created By     : Balakrishnan
Created Date   : 10/13/2020

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Balakrishnan          	110/13/2020		       created Test class				                       
----------------------------------------------------------------------------------            

*********************************************************************************/
@IsTest
public class SNI_FL_CaseCreateUpdateNotification_Test {

     @testSetup static void setupData() {
   
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            List<Account> accList=new List<Account>();
            List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'FLTestAcc';
            ac.RecordTypeId = recordTypeId;
            accList.add(ac);
            
         
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Community'; 
            pa.lastName = 'FLCreteamTestUser'; 
            pa.RecordTypeId = personAccRecordTypeId;
            pa.MultiPolicyCheck__c=true;
            pa.Policy_ID__c='0070145';
            pa.Member_ID__c='453543145';
            //pa.Text_Message_SMS_Notification__c = true;
            pa.Email_Notification__c = false;
            accList.add(pa);       
            
            Account pa2 =new account();
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
            pa2.firstName = 'Community'; 
            pa2.lastName = 'FLCreteamTestUser1'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            pa2.MultiPolicyCheck__c=true;
            //pa2.Text_Message_SMS_Notification__c = true;
            pa2.Email_Notification__c = true;
            accList.add(pa2);   
            insert accList;
         
            set<id> accSet=new set<id>{(pa.Id),(pa2.Id)};
            Id contactId,contactId1;
            for(Contact con:[SELECT id,accountId from contact where accountId in : accSet]){
             if(con.accountId==pa.Id)
                contactId=con.id;
              else
                contactId1=con.id; 
            }
            
            /*Contact con = new Contact();
            con.accountId = ac.id;
            con.LastName ='TestFl';
            con.EID__c ='453543145';
            insert con;*/
            
            
           List<AccountContactRelation> acrList=new List<AccountContactRelation>();
            AccountContactRelation acr=new AccountContactRelation();
            acr.AccountId=ac.id;
            acr.contactID= contactId;
            acrList.add(acr);
         
            AccountContactRelation acr1=new AccountContactRelation();
            acr1.AccountId=ac.id;
            acr1.contactID= contactId1;
            acrList.add(acr1);
         
            insert acrList;
            
            
            
         	SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
          	teamMemb.SNI_FL_Primary_Caregiver__c = false;
            teamMemb.SNI_FL_Status__c='Registered';
            teamMemb.SNI_FL_Family__c = ac.Id;
            teamMemb.SNI_FL_Member__c = pa.Id;
            teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
            teamlist.add(teamMemb);
         
           	SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
          	teamMemb1.SNI_FL_Primary_Caregiver__c = false;
            teamMemb1.SNI_FL_Family__c = ac.Id;
            teamMemb1.SNI_FL_Member__c = pa2.Id;
            teamMemb1.SNI_FL_Status__c='Registered';
            teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
            teamlist.add(teamMemb1);
            insert teamlist;
            
            List<SNI_FL_Members_ROI__c> RoiList = new List<SNI_FL_Members_ROI__c>();
            SNI_FL_Members_ROI__c roi1 = new SNI_FL_Members_ROI__c();
            roi1.SNI_FL_Status__c = 'Active';
            roi1.SNI_FL_ROI_Signed_With__c = teamMemb.id;
            roi1.SNI_FL_Member__c =teamMemb.id;
            RoiList.add(roi1);
            SNI_FL_Members_ROI__c roi2 = new SNI_FL_Members_ROI__c();
            roi2.SNI_FL_Status__c = 'Active';
            roi2.SNI_FL_ROI_Signed_With__c = teamMemb1.id;
            RoiList.add(roi2);
            insert RoiList;
            
                
            List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
            List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User'];
           User thisUser = [Select Id From User Where Id=:UserInfo.getUserId()];
           System.runAs(thisUser){
         	User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                          EmailEncodingKey='UTF-8', FirstName='Test007',LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                          TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
            insert u;
         }
            List<Contact> conId1 = [SELECT id from contact where accountId =: pa2.Id];
            List<Profile> pList1 = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User'];
            User thisUsr = [Select Id From User Where Id=:UserInfo.getUserId()];
            System.runAs(thisUsr){
         	User u1 = new User(Alias = 'standt1', Email='flCareTeamtest1@testorg.com', 
                          EmailEncodingKey='UTF-8', FirstName='Test008',LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pList1.get(0).id, contactId =conId1[0].Id,
                          TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000001', UserName='flCareTeamtest1@testorg.com',IsActive=true);
            insert u1;
         
         }
         
            List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>();
        	ISL_Webservice_Config__c webConfig1 = new ISL_Webservice_Config__c();
        	webConfig1.Name = 'dev_SNI_FL_Notification_AuthEndPoint';
        	webConfig1.ACET_Common_Name__c = 'SNI FL Notification AuthEndPoint';
        	webConfig1.Value__c = 'https://gateway-stage.optum.com/auth/oauth2/cached/token';
        	webConfigList.add(webConfig1);
        
         
        	ISL_Webservice_Config__c webConfig2 = new ISL_Webservice_Config__c();
        	webConfig2.Name = 'dev_SNI_FL_Notification_ClientSecret';
        	webConfig2.ACET_Common_Name__c = 'SNI FL Notification ClientSecret';
        	webConfig2.Value__c = '0X8HKY8BIF1KqnuEuDDk435afQTU6dND';
        	webConfigList.add(webConfig2);
        
         	ISL_Webservice_Config__c webConfig3 = new ISL_Webservice_Config__c();
        	webConfig3.Name = 'dev_SNI_FL_Notification_ClientID';
        	webConfig3.ACET_Common_Name__c = 'SNI FL Notification ClientSecret';
        	webConfig3.Value__c = 'R5zUdTcSaEMWHPQ8lylXr7ktDCOUKFcQ';
        	webConfigList.add(webConfig3);


  			ISL_Webservice_Config__c webConfig4 = new ISL_Webservice_Config__c();
        	webConfig4.Name = 'dev_SNI_FL_Notification_ProgramID';
        	webConfig4.ACET_Common_Name__c = 'SNI FL Notification Program ID';
        	webConfig4.Value__c = '501345';
        	webConfigList.add(webConfig4);        
        	//
        	ISL_Webservice_Config__c webConfig5 = new ISL_Webservice_Config__c();
        	webConfig5.Name = 'dev_SNI_FL_Notification_EmailEndPoint1';
        	webConfig5.ACET_Common_Name__c = 'SNI FL Notification EmailEndPoint';
        	webConfig5.Value__c = 'https://gateway-stage.optum.com/api/test/ccs/comm/communications/electronic-mails/v2';
        	webConfigList.add(webConfig5);    
        
         	ISL_Webservice_Config__c webConfig6 = new ISL_Webservice_Config__c();
        	webConfig6.Name = 'dev_SNI_FL_Notification_SMSEndPoint';
        	webConfig6.ACET_Common_Name__c = 'SNI FL Notification SMSEndPoint';
        	webConfig6.Value__c = 'https://gateway-stage.optum.com/api/test/ccs/comm/communications/text-messages/v2';
        	webConfigList.add(webConfig6); 
        
        	insert webConfigList;
                 
        
            List<case> caselist = new List<case>();
            Case cas = new case();
	        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
    	    Case ecmCas = TestDataFactory.createCases(1)[0];
        	ecmCas.RecordTypeId =ecmRecordTypeID;
       		ecmCas.Topic__c = 'Appeals - Post Service';
            ecmCas.AccountId = pa.Id;
        	ecmCas.ContactId = contactId;
        	ecmCas.UHG_Restriction__c = 'No';
        	ecmCas.DOB__c = '1999/08/09';
        	//ecmCas.ID__c = '';
        	ecmCas.Onshore_Restriction__c = 'No';
        	ecmCas.Subject_Name__c = 'ECM Test case' ;
        	ecmCas.Subject_Group_ID__c = '0070145';
        	ecmCas.ParentId =cas.Id;
        	ecmCas.status='Open';
            ecmcas.Case_Type__c = 'Opportunity';
            //ecmcas.Community__c = true;
            ecmcas.ID__c = '453543145';
            ecmcas.Policy_ID__c = '0070145';
        	//cases.add(ecmCas);
        	caselist.add(ecmCas);
        	insert caselist;
            ecmcas.Community__c = true;
            update ecmcas;
    }    
    
    
    @istest static void CallNotificationtest(){
			List<case> caselist = [select Id from case];
     		List<id> caseid = new List<id>();
        	for(case cas: caselist){
            	caseid.add(cas.id);
        	}
     		Test.StartTest();
     		Test.setMock(HttpCalloutMock.class, new SNI_FL_Notification_Center_MockCallout());
        	SNI_FL_CaseCreateUpdateNotification.CallNotification(caseid);    
     		Test.stopTest();    
    }
    
    
}