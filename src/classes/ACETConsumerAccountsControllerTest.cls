@isTest(seealldata=true)
private class ACETConsumerAccountsControllerTest{
    private static testMethod void unitTestMethodForProvider(){
        user memberAgent;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            setTestData('Provider');
            memberAgent = TestDataFactory.getUser('ACET Provider'); 
        }
        System.runAs(memberAgent){
            ACETConsumerAccountsController acetCA = new ACETConsumerAccountsController();
            acetCA.getTopics();
            acetCA.getAccountTypes();
            acetCA.getCancelReasons();
            acetCA.endCall();
            acetCA.renderCancelCaseSection();
        }
    }
    private static testMethod void unitTestMethodForMember(){
        user memberAgent;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            setTestData('Member');
            memberAgent = TestDataFactory.getUser('ACET Member'); 
        }
        System.runAs(memberAgent){
            ACETConsumerAccountsController acetCA = new ACETConsumerAccountsController();
            acetCA.getTopics();
            acetCA.getAccountTypes();
            acetCA.getCancelReasons();
            acetCA.endCall();
            acetCA.renderCancelCaseSection();
        }
    }  
    private static testMethod void unitTestMethodForResearch(){
        user memberAgent;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            ApexPages.currentPage().getParameters().put('SRK','1234');
            setTestData('Research User');
            memberAgent = TestDataFactory.getUser('Research User');
        }
        System.runAs(memberAgent){
            ACETConsumerAccountsController acetCA = new ACETConsumerAccountsController();
            acetCA.getTopics();
            acetCA.getAccountTypes();
            acetCA.getCancelReasons();
            acetCA.endCall();
            acetCA.renderCancelCaseSection();
        }
    }  
    private static testMethod void unitTestMethodTestCases(){
        user memberAgent;
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        System.runAs(thisUser){
            setTestData('Member');
            memberAgent = TestDataFactory.getUser('ACET Member'); 
        }
        System.runAs(memberAgent){
            ACETConsumerAccountsController acetCA = new ACETConsumerAccountsController();
            acetCA.getTopics();
            acetCA.getAccountTypes();
            acetCA.getCancelReasons();
            acetCA.endCall();
            acetCA.renderCancelCaseSection();
        }
    }    
    private static void setTestData(String flow){
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        if(flow == 'Provider'){
            Interaction__c inte = TestDataFactory.createInteraction();
            ApexPages.currentPage().getParameters().put('InteractionId',inte.id);
        }
        ApexPages.currentPage().getParameters().put('contactId',con.id);
        ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());    
    } 
}