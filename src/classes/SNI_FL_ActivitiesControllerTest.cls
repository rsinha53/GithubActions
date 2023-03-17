@isTest
public class SNI_FL_ActivitiesControllerTest {
	
  @testsetup static void SNI_FL_ActivitiesControllerMethod() 
  {
      UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@optum.com.acet',
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
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SNIFLActivities123';
        ac.RecordTypeId = recordTypeId;
        insert ac;   
        
        Family_Overview__c fo = new Family_Overview__c();
        fo.Account__c	= ac.id;
        insert fo;
        
        String filesContent = 'File upload content for test coverage';
 
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = 'testingActivities.txt'; 
        conVer.Title = 'Testing Activity Files'; 
        conVer.VersionData = EncodingUtil.base64Decode(filesContent); 
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = fo.id; 
        conDocLink.ContentDocumentId = conDoc;  
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        Account personAccount = new Account();
        personAccount.firstName = 'PAccActivityFname';
        personAccount.lastName = 'PAccActivitylname';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        account pa1 = [select id,personcontactid from account where id =: personAccount.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;            
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
       /* Case cs = new Case(subject='test');
        insert cs;*/
       
        Case cas = [select Id from Case LIMIT 1];
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = personAccount.id;
        ecmCas.ContactId = pa1.personcontactid;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0915181';
        ecmCas.ParentId =cas.Id;
        ecmCas.status='Open';
        
        insert ecmCas;  
          
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User']; 
        User u = new User(Alias = 'standt', Email='fltest@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =pa1.personcontactid,
                          TimeZoneSidKey='America/Los_Angeles',MobilePhone='8876543456', UserName='fltestActivities@optum.com.acettest',IsActive=true);
        Database.insert(u);
      }
         
  }
    @isTest public static void testgetDashboardData(){
         Test.startTest();
        User u = [SELECT Id ,Email from User where Email='fltest@testorg.com' LIMIT 1];
      	account ac = [select Id from account where Member_ID__c = '453543543' LIMIT 1];
        system.runAs(u){
        SNI_FL_ActivitiesController.getDashboardData(ac.id);
  }
        Test.stopTest();
    }
}