@isTest
public with sharing class ACETCallTopicsPicklistUtilityTest {
  
  @testSetup
    static void prepareData(){
      list<TTS_Access__c> ttsAccess = new list<TTS_Access__c>();
      ttsAccess.add(new TTS_Access__c( Topic__c='Accumulator',  Type__c='Accumulator Inquiry',Subtype__c='1st Level Appeal', Limit_To_Profiles__c='ACET EB Agent',Limit_To_Roles__c='E&I Appeals & Grievances',Except_To_Roles__c='ECM'));
      insert ttsAccess;
      
      list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
      callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Accumulator',Detail_Page__c='Member Detail'));
      insert callTopicAccess;
      
    }
    
    static testmethod void getTTSFilterTest(){
      Profile profileId = [SELECT Id FROM Profile WHERE Name = 'ACET EB Agent' LIMIT 1];
        
       User usr = new User(LastName = 'testP',
                           FirstName='testP',
                           Alias = 'tp',
                           Email = 'aceagenttest6677656@ac.com',
                           Username = 'aceagenttest6677656@ac.com',
                           profileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        system.runAs(usr){
          ACETCallTopicsPicklistUtility.getTTSFilter('Accumulator');
        }
    }
    static testmethod void getTTSFilterTest1(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'ACET EB Agent' LIMIT 1];
      UserRole RoleId = [SELECT Id FROM UserRole WHERE Name = 'E&I Appeals & Grievances' LIMIT 1];
        
       User usr = new User(LastName = 'testq',
                           FirstName='testq',
                           Alias = 'tq',
                           Email = 'aceagenttest66776566@ac.com',
                           Username = 'aceagenttest66776566@ac.com',
                           UserRoleId = RoleId.id,
                           ProfileId= profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        system.runAs(usr){
          ACETCallTopicsPicklistUtility.getTTSFilter('Accumulator');
        }
    }
     static testmethod void getTTSFilterTest2(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'ACET EB Agent' LIMIT 1];
      UserRole RoleId = [SELECT Id FROM UserRole WHERE Name = 'ECM' LIMIT 1];
        
       User usr = new User(LastName = 'testq',
                           FirstName='testq',
                           Alias = 'tq',
                           Email = 'aceagenttest66776566@ac.com',
                           Username = 'aceagenttest66776566@ac.com',
                           UserRoleId = RoleId.id,
                           ProfileId= profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        system.runAs(usr){
          ACETCallTopicsPicklistUtility.getTTSFilter('Accumulator');
        }
    }
    
    static testmethod void getCallTopicOptionsTest(){
      Profile profileId = [SELECT Id FROM Profile WHERE Name = 'ACET EB Agent' LIMIT 1];
        
       User usr = new User(LastName = 'testP',
                           FirstName='testP',
                           Alias = 'tp',
                           Email = 'aceagenttest6677656@ac.com',
                           Username = 'aceagenttest6677656@ac.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        system.runAs(usr){
          ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Detail',null);
          ACETCallTopicsPicklistUtility.getCallTopics('Member Detail');
          ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Detail');
          ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Detail', null, 'Self', null, 'Self');
            ACETCallTopicsPicklistUtility.getCallTopicOptionsWithRestrictions('Member Detail',null,'test','test11');
            ACETCallTopicsPicklistUtility.isMatchedWithCurrentPublicGrps('abc',new Set<String>{'a'});
            ACETCallTopicsPicklistUtility.isMatchedWithCurrentOrParentOrGrandParentRole('ac',new Map<Id,UserRole>{null=>new UserRole(Name='ac')});
            ACETCallTopicsPicklistUtility.getCallTopics('Abc','Abc',new List<Id>(),'Accumulator');
            ACETCallTopicsPicklistUtility.getUserPublicGrps(new List<Call_Topic_Access__c>{new Call_Topic_Access__c(Limit_to_Public__c='a;b')});
        }
    }
    
}