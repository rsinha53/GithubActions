@isTest
public class SNI_FL_LoginPopUpControllerTest {
    @isTest static void SNI_FL_LoginPopUpControllerMethod() 
    {
        User uName = SNI_FL_LoginPopUpController.getLoginUserName(); 
        String isMemLogFirst = SNI_FL_LoginPopUpController.isMemLoginFirstTime();
        SNI_FL_LoginPopUpController.savePAccountDetails(false,false,'9000000001');
        SNI_FL_LoginPopUpController.saveUserDetails('(123) 123-1234');
    }
    @isTest static void getFirstTimePopupDataMethod() {
        SNI_FL_Utility__c util = new SNI_FL_Utility__c();
        util.name = 'abc';
        util.SNI_FL_Design__c = 'abc';
        insert util;
        string design = SNI_FL_NotificationsController.getFirstTimePopupData('abc');
    }
    @isTest static void testSetupData2() {
        
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
        pa.SNI_FL_Terms_of_use__pc = false;
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
        Account pa3 =new account();
        pa3.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa3.firstName = 'Digital'; 
        pa3.lastName = 'OnboardingTest1'; 
        pa3.RecordTypeId = personAccRecordTypeId;
        pa3.MultiPolicyCheck__c=true;
        //pa2.Text_Message_SMS_Notification__c = true;
        pa3.Email_Notification__c = true;
        pa3.SNI_FL_Terms_of_use__pc = true;
        accList.add(pa3); 
        insert accList;
        
        set<id> accSet=new set<id>{(pa.Id),(pa2.Id),(pa3.Id)};
            Id contactId,contactId1,contactId2;
        for(Contact con:[SELECT id,accountId from contact where accountId in : accSet]){
            if(con.accountId==pa.Id){
                contactId=con.id;
            } else if(con.accountId == pa2.Id){
                contactId1=con.id; 
            } else {
                contactId2=con.Id;
            }
        }
        
        
        List<AccountContactRelation> acrList=new List<AccountContactRelation>();
        AccountContactRelation acr=new AccountContactRelation();
        acr.AccountId=ac.id;
        acr.contactID= contactId;
        acrList.add(acr);
        
        AccountContactRelation acr1=new AccountContactRelation();
        acr1.AccountId=ac.id;
        acr1.contactID= contactId1;
        acrList.add(acr1);
        AccountContactRelation acr2=new AccountContactRelation();
        acr2.AccountId=ac.id;
        acr2.contactID= contactId2;
        acrList.add(acr2);
        
        insert acrList;
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User']; 
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                              EmailEncodingKey='UTF-8', FirstName='Test007',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                              TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
            insert u;
            
            List<Contact> conId1 = [SELECT id from contact where accountId =: pa2.Id];
            List<Profile> pList1 = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User'];
            
            User u1 = new User(Alias = 'standt1', Email='flCareTeamtest1@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='Test008',LastName='Testing1', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = pList1.get(0).id, contactId =conId1[0].Id,
                               TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000001', UserName='flCareTeamtest1@testorg.com',IsActive=true);
            insert u1;
            User u2 = new User(Alias = 'standt2', Email='flCareTeamtest2@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='Test009',LastName='Testing1', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = pList1.get(0).id, contactId =contactId2,
                               TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000002', UserName='flCareTeamtest2@testorg.com',IsActive=true, Digital_Onboarding__c = true);
            insert u2;
            System.runAs (u) {
                String member = SNI_FL_LoginPopUpController.isMemLoginFirstTime();
            }
            System.runAs (u2) {
                String member = SNI_FL_LoginPopUpController.isMemLoginFirstTime();
            }
            
            System.runAs (u1) {
                SNI_FL_LoginPopUpController.savePAccountDetails(false,false,'9000000001');
            }
        }
        
        
    }
    
    
    
}