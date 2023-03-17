@isTest
public with sharing class ETSBE_ArchiveSpecialInsBatchTest {
    public static testMethod void testBatch1(){
    	 Special_Instructions__c specInstObj = new Special_Instructions__c();
            specInstObj.Business_Unit__c = 'ACEC';
            specInstObj.Topic__c = 'Migration';
            specInstObj.Type__c = 'Inquiry';
            specInstObj.Subtype__c = 'Inquiry';
            specInstObj.SLA_Day__c = '2';
            specInstObj.Directions__c = 'Use for migration inquiries';
            specInstObj.Routing_Option__c = 'ETS';
            specInstObj.Department__c = 'Self Resolved';
            specInstObj.DOS_Required_Indicator__c = 'N';
            specInstObj.Validation_on_Routed_Appl__c = 'numeric';
            specInstObj.Routing_Appl_Desc__c = 'Routed Application';
            specInstObj.ACET_Role__c = 'DCSM';
            specInstObj.Supplemental_Routing__c = 'Policy';
            specInstObj.Effective_Date__c = date.today().addDays(-40);
            specInstObj.End_Date__c = date.today().addDays(-30);
            specInstObj.Supplemental_Routing_Ref__c = 'Commissions';
            
            insert specInstObj;
            Test.StartTest();
            Special_Instructions__c siRecord1 = [Select Id, Name, Business_Unit__c, Effective_Date__c, End_Date__c, Topic__c, Type__c,Subtype__c FROM Special_Instructions__c];
            System.debug('TEST RECORD1: ' + siRecord1);
            ETSBE_ArchiveSpecialInsBatch batchObj = new ETSBE_ArchiveSpecialInsBatch();
            Database.executeBatch(batchObj);
        ETSBE_ArchiveSpecialInsScheduler schObj = new ETSBE_ArchiveSpecialInsScheduler();
		String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, schObj); 
        Special_Instructions__c siRecord2 = [Select Id, Name, Business_Unit__c, Effective_Date__c, End_Date__c, Topic__c, Type__c,Subtype__c FROM Special_Instructions__c];
            System.debug('TEST RECORD2: ' + siRecord2);
            Test.StopTest();
    }
}