@isTest(SeeAllData=false)
private class ACETAutoDocExtensionTest
{
    static testMethod void  ACETAutoDocExtensionMethod() 
    {
        Case cs = new Case();
        insert cs;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;        
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.ShareType= 'V';
        newFileShare.LinkedEntityId = cs.Id;
        insert newFileShare;
        
        PageReference pageRef = Page.ACETAutoDoc;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',cs.id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(cs);
        ACETAutoDocExtension autodocExt = new ACETAutoDocExtension(sc);
        
    }
}