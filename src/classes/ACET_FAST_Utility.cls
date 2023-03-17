/*****************************************************************************************************
ACET_FAST_Utility
Test Class Name:  ACET_FAST_UtilityTest
Author: Shaik Mohammad Yaseen
Date: 10/20/2020
Description: This is a utility class where we wwill have reusable methods. 
Initial: Shaik Mohammad Yaseen
*****************************************************************************************************/
public without sharing class ACET_FAST_Utility {
    public static Boolean isFirstTime = true;
    
    public static string getLoggedInUserRole(){
        string roleName='Not a Valid Role';
        String uRoleId = UserInfo.getUserRoleId();
        String loggeduser = Userinfo.getFirstName()+' '+Userinfo.getLastName();
        List<UserRole> userRoleList = new List<UserRole>();
        if(uRoleId!=null && loggeduser!=null && loggeduser!='Connection User'){
            userRoleList = [SELECT Id, Name FROM UserRole WHERE id =: uRoleId];
            if(userRoleList.size()>0){
                roleName = userRoleList[0].Name;
            }            
        }
        return roleName;
    }

    public static string getLoggedInUserProfile(){
        String profileName;
        Id profileId= userinfo.getProfileId();
        // Added below if condition to skip the query exception for SF Connection user
        String loggeduser = Userinfo.getFirstName()+' '+Userinfo.getLastName();
        
        if(loggeduser!=null && profileId!=null && loggeduser!='Connection User' && loggeduser!='Automated Process'){
            profileName=[SELECT Id,Name FROM Profile WHERE Id=:profileId].Name;
        }
        return profileName;
    }
    public static Map<id,set<id>> getCaseTeamMemberMap(Set<id> caseIds){

        List<CaseTeamMember> caseTeamMemberList = [SELECT MemberId, ParentId FROM CaseTeamMember where ParentId IN:caseIds];
        set<Id> caseTeamMemberSet = new set<Id>();
        Map<id,set<id>> caseTeamMemberMap = new Map<id,set<id>>();
        for(CaseTeamMember ct :caseTeamMemberList){
            caseTeamMemberSet.add(ct.MemberId);
            if(caseTeamMemberMap.containsKey(ct.ParentId)){
                caseTeamMemberMap.get(ct.ParentId).add(ct.MemberId);
            }
            else{
                caseTeamMemberMap.put(ct.ParentId,new set<Id>{ct.MemberId});
            }   
        }
        return caseTeamMemberMap;
    }

    public static string getObjectName(id recordID){
        return recordID.getSObjectType().getDescribe().getName();
    }
    public static List<sObject> getRecord(string objName, set<Id> recordIdSet){
        String fields = ACET_FAST_Utility.convertFieldListToString(ACET_FAST_Utility.getFieldList(objName));
        List<sObject> objRecList = Database.query('SELECT '+fields+' FROM '+objName+' WHERE id IN: recordIdSet');
        return objRecList;
    }
    public static List<String> getFieldList(string objName){
        SObjectType objType = Schema.getGlobalDescribe().get(objName);
        Map<String,Schema.SObjectField> fieldsMap = objType.getDescribe().fields.getMap();
        List<String> fieldsList = new List<String>();
        for(Schema.SobjectField field : fieldsMap.values())
        {
            Schema.DescribeFieldResult dfr = field.getDescribe();
            if(dfr.isCreateable())
                fieldsList.add(dfr.getName());
            
        }
        return fieldsList;
    }
    public Static String convertFieldListToString(List<String> strList){
        String queryStr = '';
        for(String str: strList){
            if(queryStr==''){
                queryStr=str;
            }else{
                queryStr=queryStr+' ,'+str;
            }
        }
        return queryStr;
    }
    public static List <String> getPiklistValues(string objAPIName, string fieldAPIName){
        List<String> plValues = new List<String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objAPIName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get(fieldAPIName).getDescribe();
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        return plValues;
    }
    //logged in user class
    public class LoggedInUserWrapper{
        //get the current logged in user role
        public string loggedInUserRole;
          //get the current logged in user Profile
        public string loggedInUserProfile;
        //get current logged in user Id
        public Id loggedInUserId;
        //check if the logged users role is a valid role
        public boolean isValidUser;
        public LoggedInUserWrapper(){
            loggedInUserRole = ACET_FAST_Utility.getLoggedInUserRole();  
            loggedInUserProfile =  ACET_FAST_Utility.getLoggedInUserProfile();
            loggedInUserId = UserInfo.getUserId();
            isValidUser = ACET_FAST_Constants.validRoles.contains(loggedInUserRole) || ACET_FAST_Constants.validProfiles.contains(loggedInUserProfile);
        }
    }
    // Dependent Pick list values
   public static Map<String, List<String>> getDependentPicklistValues(Schema.sObjectField dependToken) {
    Schema.DescribeFieldResult depend = dependToken.getDescribe();
    Schema.sObjectField controlToken = depend.getController();
    if (controlToken == null) {
        return new Map<String, List<String>>();
    }
 
    Schema.DescribeFieldResult control = controlToken.getDescribe();
    List<Schema.PicklistEntry> controlEntries;
    if(control.getType() != Schema.DisplayType.Boolean) {
        controlEntries = control.getPicklistValues();
    }
 
    String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
    for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
        if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
            List<String> base64chars =
                    String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
            for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                Object controlValue =
                        (controlEntries == null
                                ?   (Object) (index == 1)
                                :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                        );
                Integer bitIndex = index / 6;
                if (bitIndex > base64chars.size() - 1) {
                    break;
                }
                Integer bitShift = 5 - Math.mod(index, 6);
                if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                    continue;
                if (!dependentPicklistValues.containsKey((String) controlValue)) {
                    dependentPicklistValues.put((String) controlValue, new List<String>());
                }
                dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
            }
        }
    }
    return dependentPicklistValues;
}
}