@isTest
private class ECMTypeSubTypeUtilTest{
     static testmethod void testECMTestDataUtilTestMethod1(){
        case cas = new case();
        cas.Topic__c = 'View Authorizations';
        cas.Type__c = 'Appeal';
        cas.Subtype__c='';
        insert cas;
        map<id,case> mapcase = new map<id,case>();
        list<case> lstCase = [SELECT Id,Topic__c, Type__c,Subtype__c FROM case ];       
        for(case c: lstCase ) {
            mapcase .put(c.id, c);
        }   
        list<Case_item__c> caseItemList = new list<Case_Item__c>();
        for(integer i=0;i<10;i++){
            caseItemList.add(new Case_Item__c(Case__c= cas.id,resolved__c=false));
        }
        insert caseItemList;
        cas.Topic__c = 'View Authorizations';
        cas.Type__c = 'Authorization';
        cas.Subtype__c='';
        update cas;
        List<Case> caselist = new List<Case>();
        caselist.add(cas);
        Test.startTest();
        ECMTypeSubTypeUtil.updateTypeAndSubTypeOnCaseItem(caselist,mapcase);   
        Test.stopTest();   
    }
}