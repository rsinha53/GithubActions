/*************************
Class Name     : sensPublishCustomAPI.cls
Description    : Used to send SENS member information (usually used by OMNI)
Created By     : Vamshee Vunyala
Created Date   : 04/15/2022

Modification Log:



****************************/


@RestResource(urlMapping = '/senspublish/*')
global with sharing class sensPublishCustomAPI{

@HTTPGet
global static List<sobject> getSensPublishDetails(){
    RestRequest Req = RestContext.request;
    List<Sens_Publish__c> sensPublishList = new List<Sens_Publish__c>();
    system.debug('****today==>'+system.today());
    DateTime today = system.today(); 
    sensPublishList = [SELECT ID, CHN_Referral_Identifier__c,SENS_Unique_ID__c,First_Name__c,Last_Name__c,DOB__c,Member_ID__c,Policy_ID__c,Designation__c,Designation_Changed_Date__c,Enrollment_Date__c,State_Code__c,Family_Status__c,First_Family_Contact_Into_Center__c,Relationship__c,Source_Code__c,Advisor_Employee_ID__c,Advisor_MSID__c,Advisor_Name__c,CHN_Qualified__c,LastModifiedDate FROM Sens_Publish__c WHERE LastModifiedDate >=: today.addDays(-30) AND LastModifiedDate  <=: today.addDays(1)];
    return sensPublishList;
}

@HTTPPost
global static List<sobject> getSensMemberInfo(){
    RestRequest req = RestContext.request;
    system.debug('****req==>'+req);
    String requestBody = req.requestBody.toString();
    Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
    system.debug('****params==>'+params.get('MemberId'));
    String memberId = string.valueOf(params.get('MemberId'));
    String policyID = string.valueOf(params.get('PolicyId'));
    system.debug('****params DOB==>'+params.get('DOB'));
    string dob = string.valueOf(params.get('DOB'));
    List<Sens_Publish__c> sensPublishList = new List<Sens_Publish__c>();
    String query = 'SELECT ID, CHN_Qualified__c, Family_Status__c, Designation__c, Designation_Changed_Date__c , Enrollment_Date__c , First_Name__c, Last_Name__c ,DOB__c, Member_ID__c, Policy_ID__c, Relationship__c, SENS_Unique_ID__c, Advisor_Name__c, Advisor_MSID__c,LastModifiedDate FROM Sens_Publish__c WHERE ';
    if(memberId != '' && memberID != null){
        query = query + ' Member_Id__c = \''+  memberId+'\'';
    }
    if(policyId != '' && policyID != null){
        query = query + ' AND Policy_ID__c = \''+  policyID+'\'';
    }
    if(dob != '' && dob != null){
        query = query + ' AND DOB__c = '+  dob;
    }
    //sensPublishList = [SELECT ID, Family_Status__c, Designation__c, Designation_Changed_Date__c , Enrollment_Date__c , First_Name__c, Last_Name__c ,DOB__c, Member_ID__c, Policy_ID__c, Relationship__c, SENS_Unique_ID__c, Advisor_Name__c, Advisor_MSID__c,LastModifiedDate FROM Sens_Publish__c WHERE Member_ID__c =: memberId];
    //return sensPublishList;
    system.debug('****query***'+query);
    sensPublishList = database.query(query);
    if(sensPublishList.size()==0){
        query = '';
        query = 'SELECT ID, First_Name__c, Last_Name__c, Advisor_Name__c , Advisor_MSID__c , Subscriber_Member_ID__c, Policy_Number__c, Date_of_Birth__c, CHN_Qualified__c FROM CHN_Qualified_Data__c WHERE ';
        if(memberId != '' && memberID != null){
        query = query + ' Subscriber_Member_ID__c = \''+  memberId+'\'';
        }
        if(policyId != '' && policyID != null){
            query = query + ' AND Policy_Number__c = \''+  policyID+'\'';
        }
        if(dob != '' && dob != null){
            query = query + ' AND Date_of_Birth__c = '+  dob;
        }
    }
    return database.query(query);
}

}