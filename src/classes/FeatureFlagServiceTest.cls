/**
 * @Author: Prajnith Karra
 * @Version: 1.0
 * @Email: prajnith_karra@optum.com
 * @Date: August 1st, 2021
 * @See:  FeatureFlagService
 * @CodeCoverage: 98%
 */
@isTest
private class FeatureFlagServiceTest {
    /**
     * description - a postive test case to validate whether TestOnlyFeatureFlag is enabled or not
     **/
    @isTest static void isFeatureEnabledTest() {
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.isFeatureEnabled('TestOnlyFeatureFlag');
        System.assertEquals(true, isEnabled, 'isFeatureEnabledTest');
        Test.stopTest();
    }
    /**
     * description - a negative test case to with in correct name
     **/
    @isTest static void isFeatureEnabledTestIncorrectName() {
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.isFeatureEnabled('IncorrectFeatureFlag');
        System.assertEquals(false, isEnabled, 'isFeatureEnabledTestIncorrectName');
        Test.stopTest();
    }
    /**
     * description - a postive test case to with in empty value
     **/
    @isTest static void isFeatureEnabledTestEmptyName() {
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.isFeatureEnabled('');
        System.assertEquals(false, isEnabled, 'isFeatureEnabledTestEmptyName');
        Test.stopTest();
    }
    /**
     * description - isFeatureEnabledSwitchOnTest
     **/
    @isTest static void isFeatureEnabledSwitchOnTest() {
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.isFeatureEnabled('TestOnlyFeatureFlagSwithcOn');
        System.assertEquals(true, isEnabled, 'isFeatureEnabledSwitchOnTest');
        Test.stopTest();
    }
    /**
     * description - positive test case get all enabled profiles from child records
     **/
    @isTest static void getFeatureEnabledProfilesTest() {
        Test.startTest();
        List < String > enabledProfiles = FeatureFlagService.getFeatureEnabledProfiles('TestOnlyFeatureFlag');
        System.debug('enabledProfiles=>' + enabledProfiles);
        System.assertEquals(true, enabledProfiles.contains('System Administrator'), 'getFeatureEnabledProfilesTest');
        Test.stopTest();
    }
    /**
     * description - negative test case get all enabled profiles from child records
     **/
    @isTest static void getFeatureEnabledProfilesSwitchOffTest() {
        Test.startTest();
        List < String > enabledProfiles = FeatureFlagService.getFeatureEnabledProfiles('TestOnlyFeatureFlagSwithcOff');
        System.assertEquals(0, enabledProfiles.size(), 'getFeatureEnabledProfilesSwitchOffTest');
        Test.stopTest();
    }
    /**
     * description - negative test case get all enabled profiles from child records with empty names
     **/
    @isTest static void getFeatureEnabledProfilesEmptyNameTest() {
        Test.startTest();
        List < String > enabledProfiles = FeatureFlagService.getFeatureEnabledProfiles('');
        System.assertEquals(0, enabledProfiles.size(), 'getFeatureEnabledProfilesEmptyNameTest');
        Test.stopTest();
    }
    /**
     * description - postive test case get all the roles added to feature flag
     **/
    @isTest static void getFeatureEnabledRolesTest() {
        Test.startTest();
        List < String > enabledProfiles = FeatureFlagService.getFeatureEnabledRoles('TestOnlyFeatureFlag');
        System.assertEquals(true, enabledProfiles.contains('Test'), 'getFeatureEnabledRolesTest');
        Test.stopTest();
    }
    /**
     * description - negative test case get all the roles added to feature flag
     **/
    @isTest static void getFeatureEnabledRolesSwitchOffTest() {
        Test.startTest();
        List < String > enabledProfiles = FeatureFlagService.getFeatureEnabledRoles('TestOnlyFeatureFlagSwithcOff');
        System.assertEquals(0, enabledProfiles.size(), 'getFeatureEnabledRolesSwitchOffTest');
        Test.stopTest();
    }
    /**
     * description - negative test case get all the roles added to feature flag
     **/
    @isTest static void getFeatureEnabledRolesEmptyNameTest() {
        Test.startTest();
        List < String > enabledProfiles = FeatureFlagService.getFeatureEnabledRoles('');
        System.assertEquals(0, enabledProfiles.size(), 'getFeatureEnabledRolesEmptyNameTest');
        Test.stopTest();
    }
    /**
     * description - getFeatureEnabledUsersSwitchOffTest
     **/
    @isTest static void getFeatureEnabledUsersSwitchOffTest() {
        Test.startTest();
        List < String > enabledUsers = FeatureFlagService.getFeatureEnabledUsers('TestOnlyFeatureFlagSwithcOff');
        System.assertEquals(0, enabledUsers.size(), 'getFeatureEnabledUsersSwitchOffTest');
        Test.stopTest();
    }
    /**
     * description - getgetFeatureEnabledtoCheckUserName
     **/
    @isTest static void getgetFeatureEnabledtoCheckUserName() {
        Test.startTest();
        List < String > enabledUsers = FeatureFlagService.getFeatureEnabledUsers('TestOnlyFeatureFlagCheckUserName');
        System.assertEquals(0, enabledUsers.size(), 'getgetFeatureEnabledtoCheckUserName');
        Test.stopTest();
    }
    /**
     * description - get feature flag details test
     **/
    @isTest static void getFeatureFlagDetailTest() {
        Test.startTest();
        FeatureFlagConfig__mdt featureDetail = FeatureFlagService.getFeatureFlagDetail('TestOnlyFeatureFlag');
        System.assertEquals('TestOnlyFeatureFlag', featureDetail.FeatureName__c, 'getFeatureFlagDetailTest');
        Test.stopTest();
    }
    /**
     * description - get feature flag details with empty name
     **/
    @isTest static void getFeatureFlagDetailEmptyNameTest() {
        Test.startTest();
        FeatureFlagConfig__mdt featureDetail = FeatureFlagService.getFeatureFlagDetail('');
        System.assertEquals(null, featureDetail.FeatureName__c, 'getFeatureFlagDetailEmptyNameTest');
        Test.stopTest();
    }
    /**
     * description - check profile access
     **/
    @isTest static void checkUserProfileAccessEmptyListTest() {
        List < String > profileList = new List < String > ();
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.checkUserProfileAccess(profileList);
        System.assertEquals(false, isEnabled, 'checkUserProfileAccessEmptyListTest');
        Test.stopTest();
    }
    /**
     * description - check role access
     **/
    @isTest static void checkUserRoleAccessEmptyListTest() {
        List < String > roleList = new List < String > ();
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.checkUserRoleAccess(roleList);
        System.assertEquals(false, isEnabled, 'checkUserRoleAccessEmptyListTest');
        Test.stopTest();
    }
    /**
     * description - check username access with empty list
     **/
    @isTest static void checkUserNameAccessEmptyListTest() {
        List < String > userList = new List < String > ();
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.checkUserNameAccess(userList);
        System.assertEquals(false, isEnabled, 'checkUserNameAccessEmptyListTest');
        Test.stopTest();
    }
    /**
     * description - check username access
     **/
    @isTest static void checkUserNameAccessTest() {
        Profile p = [select id from profile where name = 'System Administrator'];
        User featureTestUser = new User(alias = 'fftest', email = 'u1@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id, country = 'United States', timezonesidkey = 'America/Los_Angeles', username = 'featureflagtestuser@testoptum.com');
        System.runAs(featureTestUser) {
            Test.startTest();
            Boolean isEnabled = FeatureFlagService.isFeatureEnabled('TestOnlyFeatureFlagCheckUserName');
            System.assertEquals(true, isEnabled, 'checkUserNameAccessTest');
            Test.stopTest();
        }
    }
    /**
     * description - test with enabled date - future date
     **/
    @isTest static void isFeatureEnabledTestFutureDate() {
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.isFeatureEnabled('TestOnlyFeatureFlagFutureDate');
        System.assertEquals(false, isEnabled, 'isFeatureEnabledTestFutureDate');
        Test.stopTest();
    }
    /**
     * description - isFeatureEnabledTestAura
     **/
    @isTest static void isFeatureEnabledTestAura() {
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.isFeatureEnabledAura('TestOnlyFeatureFlag');
        System.assertEquals(true, isEnabled, 'isFeatureEnabledTestAura');
        Test.stopTest();
    }
    /**
     * description - isFeatureEnabledTestDisabled
     **/
    @isTest static void isFeatureEnabledTestDisabled() {
        Test.startTest();
        Boolean isEnabled = FeatureFlagService.isFeatureEnabled('TestOnlyFeatureFlagSwithcOff');
        System.assertEquals(false, isEnabled, 'isFeatureEnabledTestDisabled');
        Test.stopTest();
    }
    /**
     * description - isFeatureEnabledRoleTest
     **/
    @isTest static void isFeatureEnabledRoleTest() {
        Profile p = [select id from profile where name = 'System Administrator'];
        UserRole r = new UserRole(DeveloperName = 'Test', Name = 'Test');
        insert r;
        User featureTestUser = new User(alias = 'fftest', email = 'u1@testorg.com', UserRoleId = r.ID, emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id, country = 'United States', timezonesidkey = 'America/Los_Angeles', username = 'featureflagtestuser@testoptum.com');
        System.runAs(featureTestUser) {
            Test.startTest();
            Boolean isEnabled = FeatureFlagService.isFeatureEnabled('TestOnlyFeatureFlagRole');
            System.assertEquals(true, isEnabled, 'isFeatureEnabledRoleTest');
            Test.stopTest();
        }
    }
    /**
     * description - isFeatureEnabledUserTest
     **/
    @isTest static void isFeatureEnabledUserTest() {
        Profile p = [select id from profile where name = 'System Administrator'];
        User featureTestUser = new User(alias = 'fftest', email = 'u1@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id, country = 'United States', timezonesidkey = 'America/Los_Angeles', username = 'featureflagtestuser@testoptum.com');
        System.runAs(featureTestUser) {
            Test.startTest();
            Boolean isEnabled = FeatureFlagService.isFeatureEnabled('TestOnlyFeatureFlagUser');
            System.assertEquals(true, isEnabled, 'isFeatureEnabledUserTest');
            Test.stopTest();
        }
    }
}