@isTest
public class SAE_BookmarkLinksTest {

    @testSetup static void setup() {
        Profile profAdmin = SAETestDataFactory.loadProfile(SAEConstants.SAE_PROFILE_SYSADMIN_NAME);
        Profile profProvider = SAETestDataFactory.loadProfile(SAEConstants.SAE_PROFILE_PROVIDERSERVICE_NAME);
        Bookmark_Links__c bookmarkObj = SAETestDataFactory.insertBookmarkLink(
            SAEConstants.SAE_BOOKMARKLINKS_DISPLAYNAME_SAMPLE,
            SAEConstants.SAE_PROFILE_SYSADMIN_NAME,
            SAEConstants.SAE_BOOKMARKLINKS_URL_SAMPLE,
            SAEConstants.SAE_BOOKMARKLINKS_ACTIVE
        );
        INSERT bookmarkObj;
        User userObj01,userObj02;
        system.runAs(new user(Id = userinfo.getUserId())){
            userObj01 = SAETestDataFactory.createUser(SAEConstants.SAE_USER_SYSADMIN_ALIAS, SAEConstants.SAE_USER_SYSADMIN_EMAIL, 
            SAEConstants.SAE_USER_EMAILENCODINGKEY, SAEConstants.SAE_USER_SYSADMIN_LASTNAME, SAEConstants.SAE_USER_LANGLOCALEKEY, 
            SAEConstants.SAE_USER_LOCALESIDKEY, profAdmin.Id, SAEConstants.SAE_USER_TIMEZONESIDKEY, SAEConstants.SAE_USER_ADMIN_USERNAME);
            INSERT userObj01;
            userObj02 = SAETestDataFactory.createUser(SAEConstants.SAE_USER_PROVIDER_ALIAS, SAEConstants.SAE_USER_PROVIDER_EMAIL, 
            SAEConstants.SAE_USER_EMAILENCODINGKEY, SAEConstants.SAE_USER_PROVIDER_LASTNAME, SAEConstants.SAE_USER_LANGLOCALEKEY, 
            SAEConstants.SAE_USER_LOCALESIDKEY, profProvider.Id, SAEConstants.SAE_USER_TIMEZONESIDKEY, SAEConstants.SAE_USER_PROVIDER_USERNAME);
            INSERT userObj02;
		}
        System.assertNotEquals(profAdmin, null);
        System.assertNotEquals(profProvider, null);
        System.assertNotEquals(bookmarkObj, null);
        System.assertNotEquals(userObj01, null);
        System.assertNotEquals(userObj02, null);
    }

    static testMethod void test_getAllBookmarks() {
        Test.startTest();
        System.runAs(SAETestDataFactory.loadUser(SAEConstants.SAE_USER_ADMIN_USERNAME)) {
            Bookmark_Links__c[] lstBookmarks = SAE_BookmarkLinks.getAllBookmarks();
            System.assertEquals(lstBookmarks.size(), 1);
        }
        System.runAs(SAETestDataFactory.loadUser(SAEConstants.SAE_USER_PROVIDER_USERNAME)) {
            Bookmark_Links__c[] lstBookmarks = SAE_BookmarkLinks.getAllBookmarks();
            System.assertEquals(lstBookmarks.size(), 0);
        }
        Test.stopTest();
    }

}