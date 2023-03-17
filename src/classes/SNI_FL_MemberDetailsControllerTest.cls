@IsTest
public class SNI_FL_MemberDetailsControllerTest 
{
	@testSetup static void dataSetup() {
		SNI_FL_MembersDataFactoryTest.initialDataPreparation();
    }
	static testmethod void getMemberDetails() {
		Member_Affiliation__c memberAffiliationRecord = [SELECT id, Status__c FROM Member_Affiliation__c WHERE Email__c = 'PersonEmail@gmail.com' limit 1];
        Test.startTest();
       	    SNI_FL_MemberDetailsController.getMemberDetails(memberAffiliationRecord.Id);
        Test.stopTest();
    }
	static testmethod void getMemberRecord() {
		Member_Affiliation__c memberAffiliationRecord = [SELECT id, Status__c FROM Member_Affiliation__c WHERE Email__c = 'PersonEmail@gmail.com' limit 1];
        Test.startTest();
       	    SNI_FL_MemberDetailsController.getMemberRecord(memberAffiliationRecord.Id);
        Test.stopTest();
    }
    static testmethod void getMemberProgramHistory() {
		Member_Affiliation__c memberAffiliationRecord = [SELECT id, Status__c FROM Member_Affiliation__c WHERE Email__c = 'PersonEmail@gmail.com' limit 1];
		Test.startTest();
        	System.assertEquals(0,[Select Id FROM Member_Affiliation__History].size());
        	memberAffiliationRecord.Status__c = false;
        	update memberAffiliationRecord;
        	SNI_FL_MemberDetailsController.getMemberProgramHistory(memberAffiliationRecord.Id);
        Test.stopTest();
    }
 	static testmethod void getMemberDocuments() {
        ContentVersion contentVersionInsert = new ContentVersion(Title = 'Test',PathOnClient = 'Test.jpg',VersionData = Blob.valueOf('Test Content Data'),IsMajorVersion = true);
			Test.startTest();
        	insert contentVersionInsert;
        	ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
       	    List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	System.assertEquals(documents.size(), 1);
         Test.stopTest();
    }
    @isTest static void getUpdatedDocs() {
        Member_Affiliation__c memberAffiliationRecord = [SELECT Id, Status__c FROM Member_Affiliation__c WHERE Email__c = 'PersonEmail@gmail.com' limit 1];
        ContentVersion contentVersion = new ContentVersion(
            Title = 'test',
            PathOnClient = 'test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        List<ContentDocumentLink> cdlst = new List<ContentDocumentLink>();                     
        ContentDocumentLink cdl1 = new ContentDocumentLink();
        cdl1.LinkedEntityId = memberAffiliationRecord.Id;
        cdl1.ContentDocumentId = documents[0].Id;
        cdl1.Visibility = 'InternalUsers';
        cdlst.add(cdl1);
        insert cdlst;
        List<Id> contdoclst = new List<Id>();
        contdoclst.add(documents[0].Id);  
        Test.startTest();
        List<ContentDocument> Ldocuments = SNI_FL_MemberDetailsController.getUpdatedDocs(contdoclst,memberAffiliationRecord.Id,'test');
        contentDocumentLink cdocl = [select Id, Visibility from contentDocumentLink 
                                     where LinkedEntityid = :memberAffiliationRecord.Id];
        System.assertEquals('AllUsers', cdocl.Visibility);
        Test.stopTest();
        
    }
    
    static testmethod void downloadEditRemoveDocs() {
        ContentVersion contentVersionInsert = new ContentVersion(Title = 'Test',PathOnClient = 'Test.jpg',VersionData = Blob.valueOf('Test Content Data'),IsMajorVersion = true);
        Test.startTest();
        
        insert contentVersionInsert;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title FROM ContentDocument];
        System.assertEquals(1, documents.size());
        Integer originalSize = documents.size();
        ContentDocument doc = documents.remove(0);
        
        /*-- Download File --*/
        SNI_FL_MemberDetailsController.downloadFile(doc.Id);
        
        /*-- Edit File --*/
        String newTitle = doc.Title + ' test1';
        SNI_FL_MemberDetailsController.editFile(doc.Id, newTitle);
        System.assertEquals('Test test1', newTitle);
        
        /*-- Remove File --*/
        List<ContentDocument> documents2 = [SELECT Id, Title FROM ContentDocument];
        ContentDocument doc2 = documents2.remove(0);
        SNI_FL_MemberDetailsController.deleteSelectedFile(doc2.Id);
        List<ContentDocument> documents3 = [SELECT Id, Title FROM ContentDocument];
        System.assertEquals(originalSize - 1, documents3.size());
        
        Test.stopTest();
    }
 }