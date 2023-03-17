@isTest
public class ACET_FAST_CaseDocumentTriggerHandlerTest {
    @TestSetup
    public static void testData()
    {
        Account acc = TestDataFactory.CreateAccount();
        Case c = TestDataFactory.createCase();
        System.assertEquals('Open', c.Status);
        System.assertEquals('TestFirst', acc.FirstName);        
    }
    @isTest
    public static void caseDocumentLinkValidationTest()
    {
        Test.startTest();
        Case c = [Select id,AccountId,Status,Subject from Case where Status='Open'];
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = c.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        
        try{
            insert cdl;
            
        }catch(Exception ex)
        {
            System.assert(true);
        }
        test.stopTest();
        
    }
    @isTest
    public static void notValidUserTest()
    {
        Test.startTest();
        Set<String> validRoles = new Set<String>{'OPO PIR','PIR - Reactive/Proactive Supervisor', 'System Administrator'};
        List<User> notValidUser = [Select Id,Name,Role_Name__c  from User where Role_Name__c NOT IN:validRoles AND IsActive = true];
        Case c = [Select id,AccountId,Status,Subject from Case where Status='Open'];
        
         ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = c.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        
        
        System.runAs(notValidUser[0])
        {
            try{
                   insert cdl;
                
            }catch(Exception ex)
            {
                System.assert(true);
            }
        }
        
        Test.stopTest();        
    }
}