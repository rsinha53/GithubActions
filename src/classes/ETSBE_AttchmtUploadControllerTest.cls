@isTest
public class ETSBE_AttchmtUploadControllerTest {    
    
    @isTest
    static void docFileTest(){
        
        Id phoneRTID = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Phone').getRecordTypeId();
        Interaction__c interact = new Interaction__c();
        interact.Originator_Type__c = 'Agency/Broker';
        interact.RecordTypeId = phoneRTID;
        interact.Interaction_Type__c = 'Phone Call';
        insert interact; 
        
        Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
        Case cseObj = new Case();
        cseObj.RecordTypeId = caseRTID;
        cseObj.Case_Type__c = 'BEO Case';
        cseObj.Interaction__c = interact.id;
        insert cseObj;
                                
        EmailMessage incomingMail = new EmailMessage();
        incomingMail.fromaddress= 'test@optum.com';
        incomingMail.toAddress = 'test@optum.com';
        incomingMail.subject = 'Test Message';
        incomingMail.TextBody= 'This is the message body ';
        incomingMail.ParentId= cseObj.id;
        incomingMail.incoming=true;
        insert incomingMail ;   
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = cseObj.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        Attachment attach = new Attachment(); 
        attach.Name ='Unit Test Attachment'; 
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body'); 
        attach.body = bodyBlob; 
        attach.parentId = cseObj.id;
        insert attach;
        
        List<Attachment> attachments = [select id, name from Attachment where parent.id =: cseObj.id]; 
        System.assertEquals(1, attachments.size());
        
        Attachments__c attchCustObj = new Attachments__c();
        attchCustObj.Case__c = cseObj.id;
        attchCustObj.Name  ='Unit Test Attachment'; 
        attchCustObj.File_Name__c ='Unit Test Attachment'; 
        insert attchCustObj;
        
        List<Attachments__c> custAtt = [select id, name from Attachments__c where Case__c =: cseObj.id]; 
        System.assertEquals(1, custAtt.size());
        
        Test.startTest();
        ETSBE_AttchmtUploadController.fetchFiles(cseObj.Id);
        
        
        Test.stopTest();
    }
    
        @isTest
    static void docFileDeleteTest(){
        
        Id phoneRTID = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Phone').getRecordTypeId();
        Interaction__c interact = new Interaction__c();
        interact.Originator_Type__c = 'Agency/Broker';
        interact.RecordTypeId = phoneRTID;
        interact.Interaction_Type__c = 'Phone Call';
        insert interact; 
        
        Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
        Case cseObj = new Case();
        cseObj.RecordTypeId = caseRTID;
        cseObj.Case_Type__c = 'BEO Case';
        cseObj.Interaction__c = interact.id;
        insert cseObj;
                                
        EmailMessage incomingMail = new EmailMessage();
        incomingMail.fromaddress= 'test@optum.com';
        incomingMail.toAddress = 'test@optum.com';
        incomingMail.subject = 'Test Message';
        incomingMail.TextBody= 'This is the message body ';
        incomingMail.ParentId= cseObj.id;
        incomingMail.incoming=true;
        insert incomingMail ;   
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = cseObj.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        Attachment attach = new Attachment(); 
        attach.Name ='Unit Test Attachment'; 
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body'); 
        attach.body = bodyBlob; 
        attach.parentId = cseObj.id;
        insert attach;
        
        List<Attachment> attachments = [select id, name from Attachment where parent.id =: cseObj.id]; 
        System.assertEquals(1, attachments.size());
        
        Attachments__c attchCustObj = new Attachments__c();
        attchCustObj.Case__c = cseObj.id;
        attchCustObj.Name  ='Unit Test Attachment'; 
        attchCustObj.File_Name__c ='Unit Test Attachment'; 
        insert attchCustObj;
        
        List<Attachments__c> custAtt = [select id, name from Attachments__c where Case__c =: cseObj.id]; 
        System.assertEquals(1, custAtt.size());
        
        Test.startTest();
        ETSBE_AttchmtWrapper attwrapper = new ETSBE_AttchmtWrapper();
        attwrapper.fileId = documents[0].id;
        ETSBE_AttchmtUploadController.fetchSingleFile(documents[0].id,null);
        ETSBE_AttchmtUploadController.updateFiles(json.serialize(attwrapper));
         ETSBE_AttchmtUploadController.fetchSingleFile(null,custAtt[0].id);
        ETSBE_AttchmtUploadController.deleteFiles(documents[0].id);
        Test.stopTest();
    }
}