/********************************************************************************* 
Class Name     : AccountTeamTriggerHandlerTest.cls
Description    : AccountTeamTriggerHandlerTest data for Account Team Member 
Created By     : Srilakshmi Rayala
Created Date   : 12/10/2020

Modification Log:

*********************************************************************************/

@IsTest
public class AccountTeamTriggerHandlerTest {    
    @isTest 
    static void AccountTeamTriggerHandlerTestMethod(){
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id proAffrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id proTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        Id proUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
        
        Test.startTest();
        RecordType myRecordType = [select id from RecordType where SobjectType='Account' AND Name = 'Provider User' limit 1];
        
        Account acc = new Account(
            FirstName='test',
            LastName='Acc',
            PersonEmail='test@optum.com' ,
            Recordtypeid=proUserrecordTypeId);
        insert acc;
        // create Contact
        Contact con = [Select id, FirstName, LastName from Contact where AccountId=:acc.Id];
        // Setup test data
        // This code runs as the system user
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1]; 
        User usr = new User(
            LastName = 'testP',
            FirstName='testP',
            Alias = 'tp',
            Email = 'abc@optum.com',
            Username = 'abc@optum.com',
            profileId=p.Id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US',
            Agent_Type__c='Offshore',
            ContactId = con.Id
            
        );
        acc.PersonEmail='er@abc.com';
        update acc;
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Name =   'ProviderGroup';
        ac.RecordTypeId = progrouprecordTypeId;
        accList.add(ac);
        Account acff = new Account();
        acff.Name =   'ProviderAffiliation';
        acff.RecordTypeId = proAffrecordTypeId;
        accList.add(acff);            
        insert accList;
        
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
        Account ProvAcct = [Select Id from Account Where RecordTypeId =: proAffrecordTypeId];
        User ussr =[Select Id from User Limit 1];
        AccountContactRelation accCntRel = new AccountContactRelation(
            AccountId = ProvAcct.Id,
            Contactid = con.Id,
            Relationship__c = 'Provider User');
        Insert accCntRel;
        List<AccountTeamMember> lstAcctTmMem= new List<AccountTeamMember>();
        AccountTeamMember acctTmMem = new AccountTeamMember(
            AccountId = ProvAcct.Id, 
            UserId = UserInfo.getUserId(), 
            TeamMemberRole = 'Account Team Member',
            AccountAccessLevel = '', 
            OpportunityAccessLevel = '', 
            CaseAccessLevel = '', 
            ContactAccessLevel = ''
        );
        try{lstAcctTmMem.Add(acctTmMem);}catch(Exception e){System.debug('--'+e.getMessage());}
        AccountTeamTriggerHandler acctTeamsTrigger = new AccountTeamTriggerHandler();
        acctTeamsTrigger.RemoveAccountTeams(lstAcctTmMem);
        try{acctTeamsTrigger.MapAccountTeams(lstAcctTmMem);}catch(Exception ex){System.debug('--'+ex.getMessage());}
        AccountTeamTriggerHandler.validationTeamRole(lstAcctTmMem);
        Test.stopTest();
        
    }
    
}