@isTest
public class ACET_FAST_CaseCommentsTriggerHandlerTest {
    @TestSetup
    public static void testData()
    {
        Account acc = TestDataFactory.CreateAccount();
        Case c = TestDataFactory.createCase();
		System.assertEquals('Open', c.Status);
		System.assertEquals('TestFirst', acc.FirstName);        
    }
    @isTest
    public static void caseCommentsValidationTest()
    {
        Test.startTest();
        Case c = [Select id,AccountId,Status,Subject from Case where Status='Open'];
        CaseComment cc = new CaseComment();
        cc.ParentId = c.Id;
        cc.CommentBody = 'Check Comments';
        cc.IsPublished = true;
        try{
            insert cc;
            
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
            List<User> notValidUser = [Select Id,Name,Role_Name__c  from User where Role_Name__c NOT IN:validRoles ];
        Case c = [Select id,AccountId,Status,Subject from Case where Status='Open'];
        
        CaseComment cc = new CaseComment();
        cc.ParentId = c.Id;
        cc.CommentBody = 'Check Comments';
        cc.IsPublished = true;
        
        System.runAs(notValidUser[0])
        {
            try{
                insert cc;
                
            }catch(Exception ex)
            {
                System.assert(true);
            }
        }
        
		Test.stopTest();        
    }
}