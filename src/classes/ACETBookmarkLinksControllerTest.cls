@istest
private class ACETBookmarkLinksControllerTest{

static testMethod void testACETBookmarkLinksController (){
        ACETOrgNameToSwivelEndpointMap__c CirrusURLTemplate = ACETTestDataUtility.createORGNameToSwivelData('dev_CIRRUSWrapURL','/idp/login?app=0spm0000000008y&RelayState=https://cirrus-dev.optum.com/pingfederatesso.uhg?externalIDType=SC&landingPage={2}&encryptedData=affiliationExternalID={0}&memGroup={1}');
        insert CirrusURLTemplate;
        ACETWrapEncryptionKey__c CirrusEncryptionKey= new ACETWrapEncryptionKey__c(Name='dev_CirrusEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert CirrusEncryptionKey;
        
       User u = [select id,profile.name from user where profile.name = 'System Administrator' and isactive = true limit 1];
       PageReference pageRef = Page.ACETBookmarkLinks;
       Test.setCurrentPage(pageRef);
      
      List<Bookmark_Links__c > lstbookmark= new List<Bookmark_Links__c >();
        
        for(Integer i=0;i<5;i++) {
            Bookmark_Links__c a = new Bookmark_Links__c (Display_Name__c = 'test' + i,Profiles__c = 'System Administrator',URL__c = 'www.test.com',Active__c=true);
            lstbookmark.add(a);
        }
        insert lstbookmark;
      Test.startTest();
       System.runAs(u) {
       ACETBookmarkLinksController bookmark  = new ACETBookmarkLinksController();
       bookmark.fetchCirrusSSOURL();
       System.assertEquals(bookmark.lstBookmarkLinks.size(),lstbookmark.size());
       }
       Test.stopTest();
      
}

}