@isTest
public class ACETFamilyGuideCreationControllerTest {
    public static testMethod void FamilyGuideCreationTestMethod() {
        
RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Family' and SObjectType = 'Account'];
        Account accountTest1 = new Account();
        accountTest1.Name = 'TestFirst';
        //accountTest1.LastName = 'TestLast';
     
        accountTest1.RecordTypeId = newRecord.Id;
        
        insert accountTest1;         
        Family_Story_Guide__c famGuide = new Family_Story_Guide__c();
        famGuide.Status__c	= 'Declined (Busy, Try Again)';
        famGuide.Status_Modified_Date__c	= system.today();
        famGuide.Expiration_Date__c	= system.today().addMonths(6);
        famGuide.Account__c = accountTest1.Id;
        insert famGuide;

        ACETFamilyGuideCreationController FGcontroller = new ACETFamilyGuideCreationController();
        ACETFamilyGuideCreationController.createFSG('Later',accountTest1.id,famGuide.id);
        ACETFamilyGuideCreationController.getFsgRecord(accountTest1.id);
        ACETFamilyGuideCreationController.getUhgOnshoreRestriction(accountTest1.id);
        ACETFamilyGuideCreationController.getUserProfile();
        
    }
 public static testMethod void FamilyGuideCreationTestMethodOne() {
        
RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Family' and SObjectType = 'Account'];
        Account accountTest1 = new Account();
        accountTest1.Name = 'TestFirst';
        accountTest1.Policy_ID__c = '0755742';
     
        accountTest1.RecordTypeId = newRecord.Id;
        
        insert accountTest1;         
        Family_Story_Guide__c famGuide = new Family_Story_Guide__c();
        famGuide.Status__c	= 'Declined (Not Interested)';
        famGuide.Status_Modified_Date__c	= system.today();
        famGuide.Expiration_Date__c	= system.today().addMonths(6);
        famGuide.Account__c = accountTest1.Id;
        insert famGuide;

        ACETFamilyGuideCreationController FGcontroller = new ACETFamilyGuideCreationController();
        ACETFamilyGuideCreationController.createFSG('NO',accountTest1.id,famGuide.id);
        ACETFamilyGuideCreationController.getFsgRecord(accountTest1.id);
        ACETFamilyGuideCreationController.getUhgOnshoreRestriction(accountTest1.id);
        ACETFamilyGuideCreationController.getUserProfile();
        
    }
    @isTest public static void FamilyGuideCreationTestMethodTwo() {
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'FamilyGuideCreationTestMethodTwo@test.optum.acet.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
      
      System.runAs ( portalAccountOwner1 ) {
        
RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Family' and SObjectType = 'Account'];
        Account accountTest2 = new Account();
        accountTest2.Name = 'TestSecond';
        accountTest2.Policy_ID__c = '0755745';
        accountTest2.Onshore_Restriction__c = 'Yes';
     
        accountTest2.RecordTypeId = newRecord.Id;
        
        insert accountTest2;         
        Family_Story_Guide__c famGuide = new Family_Story_Guide__c();
        famGuide.Status__c	= 'Declined (Not Interested)';
        famGuide.Status_Modified_Date__c	= system.today();
        famGuide.Expiration_Date__c	= system.today().addMonths(6);
        famGuide.Account__c = accountTest2.Id;
        insert famGuide;
        	                
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name = 'Center for Health Navigation']; 
        User u = new User(Alias = 'standt', Email='fltest@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', Agent_Type__c='Offshore', 
                          LocaleSidKey='en_US', ProfileId = pList.get(0).id, 
                          TimeZoneSidKey='America/Los_Angeles',MobilePhone='8876543456', UserName='fltestActivities@optum.com.acettest',IsActive=true);
        Database.insert(u);
      }
        User u1 = [SELECT Id ,Email from User where Email='fltest@testorg.com' LIMIT 1];
      	account ac2 = [select Id from account where Policy_ID__c = '0755745' LIMIT 1];
        Family_Story_Guide__c famGuide2 = [select Id from Family_Story_Guide__c where Account__c =: ac2.Id LIMIT 1 ];
		
        System.runAs ( u1 ) {
        ACETFamilyGuideCreationController FGcontroller = new ACETFamilyGuideCreationController();
        ACETFamilyGuideCreationController.createFSG('NO',ac2.id,famGuide2.id);
        ACETFamilyGuideCreationController.getFsgRecord(ac2.id);
        ACETFamilyGuideCreationController.getUhgOnshoreRestriction(ac2.id);
        ACETFamilyGuideCreationController.getUserProfile();
        }
        system.assertEquals(1, [select count() from family_overview__c]);
        system.assertequals('Yes',[select Id, Onshore_Restriction__c from family_overview__c].Onshore_Restriction__c);
    }
}