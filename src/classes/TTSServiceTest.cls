@istest
public class TTSServiceTest {
	  static testMethod void serviceTest() { 
          List<TTS_Access__c> ttaccessLst = new List<TTS_Access__c>();
          TTS_Access__c tAccess1 = new TTS_Access__c();
          TTS_Access__c tAccess2 = new TTS_Access__c();
          ttaccessLst.add(tAccess1);
          ttaccessLst.add(tAccess2);
          insert ttaccessLst;
          Group testGroup = new Group(Name='QUEUE NAME', Type='Queue');
          insert testGroup;
          //EntitlementName__c, SortOrder__c
          Account acct = new Account(Name = 'entAcct');
          insert acct;
          Entitlement ent = new Entitlement(name = 'test',accountId = acct.id);
          insert ent;
          List<EntitlementAssignment__c> enAssignLst = new List<EntitlementAssignment__c>();
          EntitlementAssignment__c enAssgn1 = new EntitlementAssignment__c(TTS_Access__c = tAccess1.Id,EntitlementName__c = ent.id, SortOrder__c = 1);
          enAssignLst.add(enAssgn1);
          EntitlementAssignment__c enAssgn2 = new EntitlementAssignment__c(EntitlementName__c = ent.id, SortOrder__c = 1);
          enAssignLst.add(enAssgn2);
          insert enAssignLst;
          Routing_Configuration__c rConfig = new Routing_Configuration__c(TTS_Access__c = tAccess1.Id,Queue_Name__c = testGroup.Id, SortOrder__c = 1);
          insert rConfig;
          TTSService.doGet();
          TTSMaster mas = new TTSMaster();
    } 
}