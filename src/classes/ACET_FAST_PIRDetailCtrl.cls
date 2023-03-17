/*****************************************************************************************************
ACET_FAST_PIRDetailCtrl
Test Class Name:  ACET_FAST_PIRDetailCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_PIRDetail and ACET_FAST_PIRDetailCmp Components. 
Reference US2982181 - Create PIR Details
11/04/2020 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_PIRDetailCtrl {
    
    @AuraEnabled
    public static User getUserDetails(){
        user usr = [SELECT Id, UserRoleId, ProfileId,profile.name, UserRole.Name FROM User Where Id =:UserInfo.getUserId()];
        return usr;
    }
    @AuraEnabled
    public static case getCaseRecord(string caseRecId){
        case caseRec = new case();
        if(caseRecId!='' && caseRecId!=null){
            caseRec=[SELECT id,RecordType.Name,  CaseNumber,status,Case_Type__c,FAST_PIP_Markets__c,Original_Received_Date__c FROM Case WHERE id=:caseRecId];
        }
        return caseRec;
    }
    @AuraEnabled
    public static Id getPIRRecId(string caseRecId){
      id pirId;
        List<PIR_Detail__c> pirDetailList = new List<PIR_Detail__c>();
        if(caseRecId!='' && caseRecId!=null){
            pirDetailList = [SELECT Id,Case__r.Status,RecordType.Name FROM PIR_Detail__c WHERE Case__c=:caseRecId];
            system.debug('pirDetailList==>'+pirDetailList);
            if(pirDetailList.size() > 0)
            {
                pirId = pirDetailList[0].Id;
            }
        }
           
        return pirId;
    }
    @AuraEnabled
    public static PIRWrapper getPIRRec(string pirID){
        PIRWrapper pWrap = new PIRWrapper();
        pWrap.pirRecord=retrivePIRRecord(pirID);
        pWrap.rc1List = getrootCause1List();
        string rc1 = pWrap.pirRecord.Root_Cause_1_Key_Code__c;
        pWrap.rc2List = (rc1!='' && rc1!=null)? getrootCause2List(rc1) : new List<RootCauseWrap>();
        string rc2 = pWrap.pirRecord.Root_Cause_2_Key_Code__c;
        pWrap.rc3List = (rc2!='' && rc2!=null)? getrootCause3List(rc2) : new List<RootCauseWrap>();
        string rc3 = pWrap.pirRecord.Root_Cause_3_Key_Code__c;
        pWrap.rc4List = (rc3!='' && rc3!=null)? getrootCause4List(rc3) : new List<RootCauseWrap>();
        string rc4 = pWrap.pirRecord.Root_Cause_4_Key_Code__c;
        pWrap.rc5List = (rc4!='' && rc4!=null)? getrootCause5List(rc4) : new List<RootCauseWrap>();
        return pWrap;
    }
    public static PIR_Detail__c retrivePIRRecord(id pirRecId){
        PIR_Detail__c pir = new PIR_Detail__c();
        pir = [SELECT id, RecordtypeId, No_Reference_Facilitated_Referral__c, Exact_Count_Unknown_Multiple_Claims__c,
               Issue_Subcategory__c,Platform__c, 
               Root_Cause_1__c, Root_Cause_2__c, Root_Cause_3__c, Root_Cause_4__c, Root_Cause_5__c,
               Root_Cause_1_Key_Code__c, Root_Cause_2_Key_Code__c, Root_Cause_3_Key_Code__c, Root_Cause_4_Key_Code__c, Root_Cause_5_Key_Code__c 
               FROM PIR_Detail__c WHERE id=:pirRecId];
        return pir;
    }
    @AuraEnabled
    public static List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> getrootCause1List(){
        List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> rc1OptList = new List<ACET_FAST_PIRDetailCtrl.RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE Active__c=true AND Level__c=1 LIMIT 2000]){
            rc1OptList.add(new ACET_FAST_PIRDetailCtrl.RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc1OptList;
    }
    @AuraEnabled
    public static List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> getrootCause2List(string prntRCCode){
        List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> rc2OptList = new List<ACET_FAST_PIRDetailCtrl.RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=2 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc2OptList.add(new ACET_FAST_PIRDetailCtrl.RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc2OptList;
    }
    @AuraEnabled
    public static List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> getrootCause3List(string prntRCCode){
        system.debug('prntRCCode==>'+prntRCCode);
        List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> rc3OptList = new List<ACET_FAST_PIRDetailCtrl.RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=3 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc3OptList.add(new ACET_FAST_PIRDetailCtrl.RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc3OptList;
    }
    @AuraEnabled
    public static List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> getrootCause4List(string prntRCCode){
        List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> rc4OptList = new List<ACET_FAST_PIRDetailCtrl.RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=4 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc4OptList.add(new ACET_FAST_PIRDetailCtrl.RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc4OptList;
    }
    @AuraEnabled
    public static List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> getrootCause5List(string prntRCCode){
        List<ACET_FAST_PIRDetailCtrl.RootCauseWrap> rc5OptList = new List<ACET_FAST_PIRDetailCtrl.RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=5 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc5OptList.add(new ACET_FAST_PIRDetailCtrl.RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc5OptList;
    }   
    public class RootCauseWrap{
    	@AuraEnabled
        public string rcCode{get;set;}
        @AuraEnabled
        public string rcName{get;set;}
        public RootCauseWrap(string rcCode, string rcName){
            this.rcCode=rcCode;
            this.rcName=rcName;
        }
    }
    public class PIRWrapper{
        @AuraEnabled
        public PIR_Detail__c pirRecord{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc1List{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc2List{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc3List{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc4List{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc5List{get;set;}
        public PIRWrapper(){
            pirRecord = new PIR_Detail__c();
            rc1List = new List<RootCauseWrap>();
            rc2List = new List<RootCauseWrap>();
            rc3List = new List<RootCauseWrap>();
            rc4List = new List<RootCauseWrap>();
            rc5List = new List<RootCauseWrap>();
        }
    }
}