@isTest
public class SNI_FL_DocumentsControllerTest {
    @isTest static void documentsTest(){
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Member_ID__c = '123543987';
        ac.Policy_ID__c = '1230987';
        ac.Name = 'FLTestAcc123';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLViewAuthTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);       
        insert accList;
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        AccountContactRelation accConRelation = new AccountContactRelation();
        accConRelation.AccountId = ac.Id;
        accConRelation.ContactId = conId[0].Id;
        insert accConRelation;
        
        Family_Overview__c fo = new Family_Overview__c();
        fo.Name='test'; 
        fo.Account__c = ac.Id;
        insert fo;
        
        Member_Information__c mi = new Member_Information__c();
        mi.Name = 'test';
        mi.Account__c = pa.Id;
        insert mi;
        
        SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
        careTeam.SNI_FL_Family__c = ac.id;
        careTeam.SNI_FL_Member__c=pa.Id;
        careTeam.SNI_FL_Not_Visible_in_Familylink__c = false;
        careTeam.SNI_FL_Status__c='Added';
        careTeam.SNI_FL_Added_Date__c=System.today();
        careTeam.SNI_FL_Primary_Caregiver__c=false;
        careTeam.SNI_FL_Non_Policy_Member__c=false;
        insert careTeam;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'test',
            PathOnClient = 'test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        List<ContentDocumentLink> cdlst = new List<ContentDocumentLink>();
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = fo.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.Visibility = 'AllUsers';
        cdlst.add(cdl);       
        
        ContentDocumentLink cdl2 = new ContentDocumentLink();
        cdl2.LinkedEntityId = mi.Id;
        cdl2.ContentDocumentId = documents[0].Id;
        cdl2.Visibility = 'AllUsers';
        cdlst.add(cdl2);
        insert cdlst;
        List<Id> contdoclst = new List<Id>();
        contdoclst.add(documents[0].Id); 
        
        SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
        roi.SNI_FL_ROI_Signed_With__c = careTeam.id;
        roi.SNI_FL_Status__c = 'Active';
        insert roi;
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User CarTUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = conId[0].Id, isActive =true,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert CarTUser;
        
        system.runAs(CarTUser){
        	SNI_FL_DocumentsController.getdocuments(ac.Id);
        }
        SNI_FL_DocumentsController.DownloadAttachment(documents[0].Id);
        SNI_FL_DocumentsController.editFile(documents[0].Id,'test');
        SNI_FL_RecordsController.getMembers(ac.Id);
        SNI_FL_RecordsController.getUpdatedDocs(contdoclst,ac.Id,ac.Id,'test');
        cdl2.Visibility = 'AllUsers';
        update cdl2;
        documents[0].Title = 'UpdatedTitle';
        update documents[0];
        SNI_FL_DocumentsController.deleteFiles(documents[0].Id);
            
        Test.stopTest();
    }
}