/**
 * A feature flag service is a mechanism that allows code to be turned “on” or “off” remotely without the need for a deploy
 * This service class validates whether the logged-in user is accessable to the new feature/Change implemented
 *   can be validated by
 *          - isEnabled Flag
 *          - Profile Name
 *          - Role
 *          - user
 * @Author: Prajnith Karra 
 * @Version: 1.0 
 * @Email: prajnith_karra@optum.com
 * @Date: August 1st, 2021
 * @See:  FeatureFlagAccess__mdt, FeatureFlagConfig__mdt, FeatureFlagServiceTest
 * @PreRequesies: Provde access to above custom metadata to all the profiles
 */
/*
Validate in Developer Console
for(FeatureFlagConfig__mdt feature :[SELECT ID,FeatureName__c FROM FeatureFlagConfig__mdt]){
    system.debug('*****'+feature.FeatureName__c+'*****Enabled****'+FeatureFlagService.isFeatureEnabled(feature.FeatureName__c));
}
system.debug('****getHeapSize***'+Limits.getHeapSize());
system.debug('****getQueries***'+Limits.getQueries());
*/

public without sharing class FeatureFlagService {
    public static final map < String, FeatureFlagConfig__mdt > featureFlagsMap = getFeatureFlagsMap();
    private static List < FeatureFlagConfig__mdt > featureFlagList = new List < FeatureFlagConfig__mdt > ();
    private static List < FeatureFlagAccess__mdt > featureFlagAccessList = new List < FeatureFlagAccess__mdt > ();
    @auraEnabled
    public static Boolean isFeatureEnabledAura(String featureName) {
        return isFeatureEnabled(featureName);
    }
    /*
     * This method checks if feature is enabled or not based on on/off switch or specificed access types(Profile/Role/User) if any.
     */
    @RemoteAction
    public static Boolean isFeatureEnabled(String featureName) {
        Boolean featureStatus = false;
        List < String > profileList = new List < String > ();
        List < String > roleList = new List < String > ();
        List < String > userList = new List < String > ();
        // get feature info
        getFeatureFlagInfo(featureName);
        //If there is no feature flag with this name return false or  If feature flag is disabled then return
        if (featureFlagList.size() == 0 || !featureFlagList.get(0).isEnabled__c) {
            return featureStatus;
        }
        // get feature flag status
        featureStatus = featureFlagList.get(0).isEnabled__c;
        // mention enabling date only if feature needs to enabled for future date
        // if enabling date filled in and is greater than today return false
        // Change the below criteria if there are timezone issues with date
        if (featureStatus && featureFlagList.get(0).Enabling_Date__c != null && featureFlagList.get(0).Enabling_Date__c > system.TODAY()) {
            return !featureStatus;
        }
        // Get access setting for feature flag
        featureFlagAccessList = featureFlagList.get(0).Feature_Flag_Profiles_Roles__r;
        System.debug('Feature Flag Access size: ' + featureFlagAccessList.size());
        // if it's only on/off switch then return from here
        // no further validation on profiles/roles/users
        if (featureFlagAccessList.size() == 0) {
            return featureStatus;
        }
        // collect all the access controlls for a particular feature
        for (FeatureFlagAccess__mdt featureFlag: featureFlagAccessList) {
            System.debug('Feature Flag Access: ' + featureFlag.AccessType__c);
            string accessType = featureFlag.AccessType__c;
            switch on accessType {
                when 'Profile' {
                    profileList.add(featureFlag.Value__c);
                }
                when 'Role' {
                    roleList.add(featureFlag.Value__c);
                }
                when 'User' {
                    userList.add(featureFlag.Value__c);
                }
            }
        }
        // check if access is controlled by profile
        if (profileList.size() > 0 && checkUserProfileAccess(profileList)) {
            featureStatus = true;
            return featureStatus;
        }
        // check if access is controlled by role
        if (roleList.size() > 0 && checkUserRoleAccess(roleList)) {
            featureStatus = true;
            return featureStatus;
        }
        // check if access is controlled by user
        if (userList.size() > 0 && checkUserNameAccess(userList)) {
            featureStatus = true;
            return featureStatus;
        }
        return featureStatus;
    }
    //Query custom metadata to get feature flag info, refered in isFeatureEnabled
    @TestVisible
    private static void getFeatureFlagInfo(String featureName) {
        system.debug('***getFeatureFlagInfo***' + featureName);
        // if empty string then return
        if (String.isEmpty(featureName) || !featureFlagsMap.containsKey(featureName)) {
            return;
        }
        if (featureFlagsMap != null && featureFlagsMap.size() > 0) {
            system.debug('***getFeatureFlagInfo***' + featureFlagsMap.get(featureName));
            featureFlagList.clear();
            featureFlagList.add(featureFlagsMap.get(featureName));
        }
    }
    // Get the list of enabled profiles
    public static List < String > getFeatureEnabledProfiles(String featureName) {
        List < String > profileList = new List < String > ();
        // get feature info
        getFeatureFlagInfo(featureName);
        // If there is not feature flag with this name return empty list
        if (featureFlagList.size() == 0) {
            return profileList;
        }
        // If feature flag is not enabled then return empty list
        if (!featureFlagList.get(0).isEnabled__c) {
            return profileList;
        }
        // Get access setting for feature flag
        featureFlagAccessList = featureFlagList.get(0).Feature_Flag_Profiles_Roles__r;
        // Find the list of profiles
        for (FeatureFlagAccess__mdt featureFlag: featureFlagAccessList) {
            System.debug('Feature Flag Access: ' + featureFlag.AccessType__c);
            if ((featureFlag.AccessType__c).equalsIgnoreCase('Profile')) {
                profileList.add(featureFlag.Value__c);
            }
        }
        return profileList;
    }
    // Get list of enabled roles
    public static List < String > getFeatureEnabledRoles(String featureName) {
        List < String > roleList = new List < String > ();
        // get feature info
        getFeatureFlagInfo(featureName);
        // If there is not feature flag with this name return empty list
        if (featureFlagList.size() == 0) {
            return roleList;
        }
        // If feature flag is not enabled then return empty list
        if (!featureFlagList.get(0).isEnabled__c) {
            return roleList;
        }
        // Get access setting for feature flag
        featureFlagAccessList = featureFlagList.get(0).Feature_Flag_Profiles_Roles__r;
        // Find the list of profiles
        for (FeatureFlagAccess__mdt featureFlag: featureFlagAccessList) {
            System.debug('Feature Flag Access: ' + featureFlag.AccessType__c);
            if ((featureFlag.AccessType__c).equalsIgnoreCase('Role')) {
                roleList.add(featureFlag.Value__c);
            }
        }
        return roleList;
    }
    // Get list of feature enabled users
    public static List < String > getFeatureEnabledUsers(String featureName) {
        List < String > userList = new List < String > ();
        // get feature info
        getFeatureFlagInfo(featureName);
        // If there is not feature flag with this name return empty list
        if (featureFlagList.size() == 0) {
            return userList;
        }
        // If feature flag is not enabled then return empty list
        if (!featureFlagList.get(0).isEnabled__c) {
            return userList;
        }
        // Get access setting for feature flag
        featureFlagAccessList = featureFlagList.get(0).Feature_Flag_Profiles_Roles__r;
        // Find the list of profiles
        for (FeatureFlagAccess__mdt featureFlag: featureFlagAccessList) {
            System.debug('Feature Flag Access: ' + featureFlag.AccessType__c);
            if ((featureFlag.AccessType__c).equalsIgnoreCase('User')) {
                System.debug('User Name: ' + featureFlag.Value__c);
                userList.add(featureFlag.Value__c);
            }
        }
        return userList;
    }
    //Get all the info related to the feature flag
    public static FeatureFlagConfig__mdt getFeatureFlagDetail(String featureName) {
        FeatureFlagConfig__mdt featureDetail = new FeatureFlagConfig__mdt();
        // get feature info
        getFeatureFlagInfo(featureName);
        // If there is not feature flag with this name return empty list
        if (featureFlagList.size() == 0) {
            return featureDetail;
        }
        featureDetail = featureFlagList.get(0);
        return featureDetail;
    }
    // check if current user profile exists in the feature enabled profileList
    @TestVisible
    private static Boolean checkUserProfileAccess(List < String > profileList) {
        String userProfile = '';
        Boolean isUserProfileEnabled = false;
        System.debug('Inside checkUserProfileAccess');
        if (profileList == null || profileList.size() == 0) {
            return isUserProfileEnabled;
        }
        List < Profile > userProfileList = [Select Name from Profile where Id = : UserInfo.getProfileId() WITH SECURITY_ENFORCED limit 1];
        if (userProfileList.size() > 0) {
            Profile profileObj = userProfileList.get(0);
            userProfile = profileObj.Name;
            System.debug('UserProfile: ' + userProfile);
        }
        if (!String.isEmpty(userProfile) && profileList.size() > 0 && profileList.contains(userProfile)) {
            isUserProfileEnabled = true;
        }
        return isUserProfileEnabled;
    }
    // check if current user role exists in the feature enabled roleList
    @TestVisible
    private static Boolean checkUserRoleAccess(List < String > roleList) {
        String userRole = '';
        Boolean isUserRoleEnabled = false;
        System.debug('Inside checkUserRoleAccess');
        if (roleList == null || roleList.size() == 0) {
            return isUserRoleEnabled;
        }
        List < UserRole > userRoleList = [Select Name from UserRole where Id = : UserInfo.getUserRoleId() WITH SECURITY_ENFORCED limit 1];
        if (userRoleList.size() > 0) {
            UserRole userRoleObj = userRoleList.get(0);
            userRole = userRoleObj.Name;
            System.debug('UserRole: ' + userRole);
        }
        if (!String.isEmpty(userRole) && roleList.size() > 0 && roleList.contains(userRole)) {
            isUserRoleEnabled = true;
        }
        return isUserRoleEnabled;
    }
    // check if current user exists in the feature enabled userList
    @TestVisible
    private static Boolean checkUserNameAccess(List < String > userList) {
        Boolean isUserEnabled = false;
        String userName = '';
        System.debug('Inside checkUserNameAccess');
        if (userList.size() == 0) {
            return isUserEnabled;
        }
        // get Current user's user name
        userName = UserInfo.getUserName();
        System.debug('Current User Name: ' + userName);
        System.debug('Current userList: ' + userList);
        if (userList.size() > 0 && !String.isEmpty(userName) && userList.contains(userName)) {
            isUserEnabled = true;
        }
        return isUserEnabled;
    }
    public static map < String, FeatureFlagConfig__mdt > getFeatureFlagsMap() {
        system.debug('****Executed*****' + system.now());
        map < String, FeatureFlagConfig__mdt > temp = new map < String, FeatureFlagConfig__mdt > ();
        for (FeatureFlagConfig__mdt featureConfig: [Select Id, isEnabled__c, FeatureName__c, FlagLocation__c, FlagLocationValue__c,
                Enabling_Date__c, (Select Id, AccessType__c, Value__c from Feature_Flag_Profiles_Roles__r)
                from FeatureFlagConfig__mdt
            ]) {
            temp.put(featureConfig.FeatureName__c, featureConfig);
        }
        return temp;
    }
}