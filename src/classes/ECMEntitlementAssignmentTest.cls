/**
 * This class contains unit tests for validating the behavior of Apex class ECMEntitlementAssignment

 */
@isTest
private class ECMEntitlementAssignmentTest {

    @testsetup static void createTestQueues(){
        Account acc = new Account(Name = 'TopAccount');
        insert acc;
        Entitlement ent = new Entitlement(Name = 'TestEntitleMent',AccountId = acc.id);
        insert ent;
    }
    
      @isTest static void test_method_SubjectType() {
        
         Entitlement ent =[select id,name from Entitlement];
         Account acc = [select id from account limit 1];
         Entitlement ent1 = new Entitlement(Name = 'TestEntitleMent',AccountId = acc.id);
          
        insert ent1;
         EntitlementAssignment__c assignment = new EntitlementAssignment__c( Topic1__c='Other Inquiry',EntitlementName__c = ent.id,SOrtOrder__c = 1,IsActive__c = true ,  Subject_Type__c = 'Member');
         insert assignment;
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Subject_Type__c = 'Member';      
        insert cas;
        Sobject accObj = (sObject) new Account();
        ECMEntitlementAssignmentHelper.IsFieldAvliable(accObj,'Name');
    }
    
    
    @isTest static void test_method_Topic() {
         Entitlement ent =[select id,name from Entitlement];
         EntitlementAssignment__c assignment = new EntitlementAssignment__c( Topic1__c='Other Inquiry',EntitlementName__c = ent.id,SOrtOrder__c = 1,IsActive__c = true);
         insert assignment;
     
        Case cas = TestDataFactory.createCases(1)[0];
         cas.Topic__c = 'Other Inquiry';         
        insert cas;
        cas = [select EntitlementId from case];
        //System.assertEquals(ent.id,cas.EntitlementId);
    }
    
    @isTest static void entitlmentWithProfileName() {
         Entitlement ent =[select id,name from Entitlement];
         EntitlementAssignment__c assignment = new EntitlementAssignment__c(ProfileName__c='System Administrator', Topic1__c='Other Inquiry',EntitlementName__c = ent.id,SOrtOrder__c = 1,IsActive__c = true);
         insert assignment;
     
        Case cas = TestDataFactory.createCases(1)[0];
         cas.Topic__c = 'Other Inquiry';          
        insert cas;
        cas = [select EntitlementId from case];
        //System.assertEquals(ent.id,cas.EntitlementId);
    }
    
   
}