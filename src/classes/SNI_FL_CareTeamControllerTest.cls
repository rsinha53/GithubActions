@isTest
public class SNI_FL_CareTeamControllerTest {
	 @testSetup static void testSetupCareTeamData(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            List<Account> accList=new List<Account>();
            List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'FLTestAcc145';
            ac.RecordTypeId = recordTypeId;
            accList.add(ac);
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Community'; 
            pa.lastName = 'FLCreteamTestUser'; 
            pa.RecordTypeId = personAccRecordTypeId;
            accList.add(pa);       
            
            Account pa2 =new account();
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
            pa2.firstName = 'Community'; 
            pa2.lastName = 'FLCreteamTestUser1'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            accList.add(pa2);       
            insert accList;
         	
         	SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
          	teamMemb.SNI_FL_Primary_Caregiver__c = true;
            teamMemb.SNI_FL_Family__c = ac.Id;
            teamMemb.SNI_FL_Member__c = pa.Id;
            teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
            teamlist.add(teamMemb);
         
           	SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
          	teamMemb1.SNI_FL_Primary_Caregiver__c = false;
            teamMemb1.SNI_FL_Family__c = ac.Id;
            teamMemb1.SNI_FL_Member__c = pa.Id;
            teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
            teamlist.add(teamMemb1);
            insert teamlist;
            
         	List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
            List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User'];
          UserRole userrole = [Select Id From UserRole Where DeveloperName = 'mcherCustomerPersonAccount' Limit 1];
          User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
           User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                          TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
            insert u;
            }
    }
    @isTest static void careTeamTest(){
        Test.startTest();
                User u = [SELECT Id ,Email,contact.accountid from User where UserName='flCareTeamtest@testorg.com' LIMIT 1];
         		SNI_FL_Care_Team_Member__c peracc = [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: u.contact.accountid LIMIT 1];       		
        		String familyaccid = peracc.SNI_FL_Family__c;
        		Date membBirthDate = Date.today();
                system.runAs(u){
                 SNI_FL_CareTeamController.getCareTeamMembers(familyaccid);
                 SNI_FL_CareTeamController.calculateAge(membBirthDate);
             }
       Test.stopTest();
    }
    @isTest static void careTeamTestRemove(){
        Test.startTest();
                User u = [SELECT Id ,Email,contact.accountid from User where UserName='flCareTeamtest@testorg.com' LIMIT 1];
         		SNI_FL_Care_Team_Member__c peracc = [SELECT Id,SNI_FL_Family__c,SNI_FL_Member__c from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: u.contact.accountid LIMIT 1];       		
        		String familyaccid = peracc.SNI_FL_Family__c;
        		system.runAs(u){
                 SNI_FL_CareTeamController.updateCareTeam(peracc.Id);
                 SNI_FL_CareTeamController.updateUserRec(peracc.Id, familyaccid);
                 
             }
       Test.stopTest();
    }
}