@isTest
public class SNI_FL_InviteControllerTest {
    @isTest static void membInviteTest(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        Account ac = new Account();
        ac.Member_ID__c = '453543987';
        ac.Policy_ID__c = '0070987';
        ac.Name = 'FLTestAcc987';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLInviteTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa2.firstName = 'Community'; 
        pa2.lastName = 'FLInviteTestUser1'; 
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
        teamMemb1.SNI_FL_Member__c = pa2.Id;
        teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamlist.add(teamMemb1);
        insert teamlist;
        
        SNI_FL_InviteController.updateEmailonCT(teamMemb1.id,'ctPersFN@optum.com.ct1');
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User'];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            User u = new User(Alias = 'standt', Email='flInvitetest@optum.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                              TimeZoneSidKey='America/Los_Angeles',UserName='flInvitetest@optum.com.acet',IsActive=true);
            insert u;
            SNI_FL_InviteController.checkDuplicateUserName('flInvitetest@optum.com');
            SNI_FL_InviteController.getuserDetail(pa.Id);
            SNI_FL_InviteController.resendInvite(teamMemb1.id,'flInvitetest@optum.com.acet',u);
            SNI_FL_InviteController.resendInvite(teamMemb1.id,'ctPersFN@optum.com.ct2',u);
            SNI_FL_InviteController.checkDuplicateUserName('flInvitetest@optum.com.acet');
        }
    }
}