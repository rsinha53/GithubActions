@IsTest
public class ACETLGT_MisdirectedCallControllerTest {
    @IsTest
    Public static void LightningMisdirectedMethod()
    {
        //String result=LightningForgotPasswordController.forgotPassword('test@test.test', 'http://www.checkemailfake');
        User memberAgent = TestDataFactory.getUser('ACET Member'); 
        System.runAs(memberAgent){
            
            Test.startTest();
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
            
            Account accountTest = new Account();
            accountTest.FirstName = 'Test Contact FN';
            accountTest.LastName = 'Test Contact LN';
            accountTest.EID__c = 'TestEID1';
            accountTest.EID__pc = 'TestEID1';
            accountTest.Tax_Id__c = 'TstTaxID1';
            accountTest.RecordTypeId = newRecord.Id;
            insert accountTest;
            Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
            Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
            Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
            insert oInteraction;
            String highlightPanelDetails = '{"accumAsOfDate":"12/11/2019","benefitBundleOptionId":"1738484","EffectiveDate":"10/1/2018","EndDate":"12/31/9999","GroupNumber":"1168520","image":"active","MemberDOB":"8/27/1979","MemberId":"97161070000","SubscriberId":"97161070000","memberStatus":"ACTIVE","Network":"FREEDOM_CHOICEPLUS","onshoreCode":"01","onshoreValue":"No","subjectID":"'+oContact.Id+'","subjectName":"LORINA ONORATI","originatorID":"'+oContact.Id+'"}';
            ACETLGT_HighlightPanelInfo hlgset = ACETLGT_MemberDetailIntController.prepareHighlightPanelWrapper(highlightPanelDetails,oInteraction.id );
        
            ACETLGT_MisdirectedCallController mdc = new ACETLGT_MisdirectedCallController();
            Case cObj = ACETLGT_MisdirectedCallController.createMisdirectCase(oInteraction.id,'Phone Call','65656565','Member Overview',hlgset);
            ACETLGT_MisdirectedCallController.upsertMisdirectedCase(cObj, 'Other', 'Test comments');
            Test.stopTest();
            
        }
    }
}