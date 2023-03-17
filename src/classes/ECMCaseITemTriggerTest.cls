@isTest
private class ECMCaseITemTriggerTest {
    
    @testsetup
    static void prepareData(){
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'View Authorizations';
       // cas.Type__c = 'OptumHealth Therapy'; 
        cas.Type__c = 'eviCore Issues';  
        insert cas;
    }
    
    
    static testmethod void testTypeAndSubtypeOnCaseItemInsert(){
        Case cs = [select id from Case];
        list<Case_item__c> caseItemList = new list<Case_Item__c>();
        for(integer i=0;i<10;i++){
            caseItemList.add(new Case_Item__c(Case__c= cs.id));
        }
        insert caseItemList;
    } 
    
    
    
}