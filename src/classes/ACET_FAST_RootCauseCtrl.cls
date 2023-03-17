/*****************************************************************************************************
ACET_FAST_RootCauseCtrl
Test Class Name:  ACET_FAST_RootCauseCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an helper for ACET_FAST_RootCauseCtrl ACET_FAST_RootCauseComp. 
US3504044 - Root Cause fields - Case Items Related list - Part 2
26/04/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_RootCauseCtrl {
    
    @AuraEnabled
    public static PIRWrapper getRootCauseValues(string caseItemId){
        PIRWrapper pWrap = new PIRWrapper();
        pWrap.CaseItemName = [SELECT id, Name FROM Case_Item__c WHERE id=:caseItemId].Name;
        pWrap.rootCauseCaseItem = getRCcaseItem(caseItemId);
        pWrap.rc1List = getrootCause1List();
        string rc1 = pWrap.rootCauseCaseItem.Root_Cause_1_Key_Code__c;
        pWrap.rootCause1Code = rc1;
        pWrap.rootCause1 = pWrap.rootCauseCaseItem.Root_Cause_1__c;
        pWrap.rc2List = (rc1!='' && rc1!=null)? getrootCause2List(rc1) : new List<RootCauseWrap>();
        string rc2 = pWrap.rootCauseCaseItem.Root_Cause_2_Key_Code__c;
        pWrap.rootCause2Code = rc2;
        pWrap.rootCause2 = pWrap.rootCauseCaseItem.Root_Cause_2__c;
        pWrap.rc3List = (rc2!='' && rc2!=null)? getrootCause3List(rc2) : new List<RootCauseWrap>();
        string rc3 = pWrap.rootCauseCaseItem.Root_Cause_3_Key_Code__c;
        pWrap.rootCause3Code = rc3;
        pWrap.rootCause3 = pWrap.rootCauseCaseItem.Root_Cause_3__c;
        pWrap.rc4List = (rc3!='' && rc3!=null)? getrootCause4List(rc3) : new List<RootCauseWrap>();
        string rc4 = pWrap.rootCauseCaseItem.Root_Cause_4_Key_Code__c;
        pWrap.rootCause4Code = rc4;
        pWrap.rootCause4 = pWrap.rootCauseCaseItem.Root_Cause_4__c;
        pWrap.rc5List = (rc4!='' && rc4!=null)? getrootCause5List(rc4) : new List<RootCauseWrap>();
        string rc5 = pWrap.rootCauseCaseItem.Root_Cause_5_Key_Code__c;
        pWrap.rootCause5Code = rc5;
        pWrap.rootCause5 = pWrap.rootCauseCaseItem.Root_Cause_5__c;
        system.debug('pWrap==>'+pWrap);
        return pWrap;
    }
    @AuraEnabled
    public static PIR_Root_Cause_Case_Item__c getRCcaseItem(string caseItemId){
        PIR_Root_Cause_Case_Item__c rcCaseItem = new PIR_Root_Cause_Case_Item__c();
        List<PIR_Root_Cause_Case_Item__c> rcCaseItemList = new List<PIR_Root_Cause_Case_Item__c>();
        rcCaseItemList = [SELECT Id, Name, Root_Cause_1__c, Root_Cause_1_Key_Code__c, Root_Cause_2__c, 
                          Root_Cause_2_Key_Code__c, Root_Cause_3__c, Root_Cause_3_Key_Code__c, Root_Cause_4__c, 
                          Root_Cause_4_Key_Code__c, Root_Cause_5__c, Root_Cause_5_Key_Code__c, Case_Item__c 
                          FROM PIR_Root_Cause_Case_Item__c WHERE Case_Item__c = : caseItemId];
        if(rcCaseItemList.size()>0){
            rcCaseItem = rcCaseItemList[0];
        }
        return rcCaseItem;
    }
    @AuraEnabled
    public static ResultWrapper saveRootCause(string wrapperJSON, string caseItemId){
        ResultWrapper rfWrap = new ResultWrapper();
        try{
            PIRWrapper pirWrap = (PIRWrapper)JSON.deserialize(wrapperJSON, PIRWrapper.class);
            system.debug('pirWrap==>'+pirWrap);
            system.debug('pirWrap.rootCause3==>'+pirWrap.rootCause3);
            system.debug('pirWrap.rootCause3Code==>'+pirWrap.rootCause3Code);
            pirWrap.rootCauseCaseItem.Root_Cause_1__c = pirWrap.rootCause1;
            pirWrap.rootCauseCaseItem.Root_Cause_1_Key_Code__c = pirWrap.rootCause1Code;
            pirWrap.rootCauseCaseItem.Root_Cause_2__c = pirWrap.rootCause2;
            pirWrap.rootCauseCaseItem.Root_Cause_2_Key_Code__c = pirWrap.rootCause2Code;
            pirWrap.rootCauseCaseItem.Root_Cause_3__c = pirWrap.rootCause3;
            pirWrap.rootCauseCaseItem.Root_Cause_3_Key_Code__c = pirWrap.rootCause3Code;
            pirWrap.rootCauseCaseItem.Root_Cause_4__c = pirWrap.rootCause4;
            pirWrap.rootCauseCaseItem.Root_Cause_4_Key_Code__c = pirWrap.rootCause4Code;
            pirWrap.rootCauseCaseItem.Root_Cause_5__c = pirWrap.rootCause5;
            pirWrap.rootCauseCaseItem.Root_Cause_5_Key_Code__c = pirWrap.rootCause5Code;
            if(pirWrap.rootCauseCaseItem.Id==null){pirWrap.rootCauseCaseItem.Case_Item__c = caseItemId;}
            system.debug('pirWrap.rootCauseCaseItem==>'+pirWrap.rootCauseCaseItem);
            
            upsert pirWrap.rootCauseCaseItem;
            rfWrap.finalMessage = 'Success';
        }
        catch(exception ex){
            system.debug('error is '+ex.getMessage());
            rfWrap.finalMessage = ex.getMessage();
        }
        rfWrap.rcCaseItem = getRCcaseItem(caseItemId);
        return rfWrap;
    }
    public static List<RootCauseWrap> getrootCause1List(){
        List<RootCauseWrap> rc1OptList = new List<RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE Active__c=true AND Level__c=1 LIMIT 2000]){
            rc1OptList.add(new RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc1OptList;
    }
    @AuraEnabled
    public static List<RootCauseWrap> getrootCause2List(string prntRCCode){
        List<RootCauseWrap> rc2OptList = new List<RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=2 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc2OptList.add(new RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc2OptList;
    }
    @AuraEnabled
    public static List<RootCauseWrap> getrootCause3List(string prntRCCode){
        system.debug('prntRCCode==>'+prntRCCode);
        List<RootCauseWrap> rc3OptList = new List<RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=3 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc3OptList.add(new RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc3OptList;
    }
    @AuraEnabled
    public static List<RootCauseWrap> getrootCause4List(string prntRCCode){
        List<RootCauseWrap> rc4OptList = new List<RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=4 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc4OptList.add(new RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
        }
        return rc4OptList;
    }
    @AuraEnabled
    public static List<RootCauseWrap> getrootCause5List(string prntRCCode){
        List<RootCauseWrap> rc5OptList = new List<RootCauseWrap>();
        for(PIR_Root_Cause__c rc: [SELECT id, Level__c, Name, Root_Cause_Key__c FROM PIR_Root_Cause__c WHERE  Active__c=true AND  Level__c=5 AND Parent_Root_Cause__r.Root_Cause_Key__c=:prntRCCode LIMIT 2000]){
            rc5OptList.add(new RootCauseWrap(rc.Root_Cause_Key__c, rc.Name));
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
        public PIR_Root_Cause_Case_Item__c rootCauseCaseItem{get;set;}
        @AuraEnabled
        public string CaseItemName{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc1List{get;set;}
        @AuraEnabled
        public String rootCause1Code{get;set;}
        @AuraEnabled
        public String rootCause1{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc2List{get;set;}
        @AuraEnabled
        public String rootCause2Code{get;set;}
        @AuraEnabled
        public String rootCause2{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc3List{get;set;}
        @AuraEnabled
        public String rootCause3Code{get;set;}
        @AuraEnabled
        public String rootCause3{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc4List{get;set;}
        @AuraEnabled
        public String rootCause4Code{get;set;}
        @AuraEnabled
        public String rootCause4{get;set;}
        @AuraEnabled
        public List<RootCauseWrap> rc5List{get;set;}
        @AuraEnabled
        public String rootCause5Code{get;set;}
        @AuraEnabled
        public String rootCause5{get;set;}
        public PIRWrapper(){
            rootCauseCaseItem = new PIR_Root_Cause_Case_Item__c();
            rc1List = new List<RootCauseWrap>();
            rc2List = new List<RootCauseWrap>();
            rc3List = new List<RootCauseWrap>();
            rc4List = new List<RootCauseWrap>();
            rc5List = new List<RootCauseWrap>();
        }
    }
    public class ResultWrapper{
        @AuraEnabled
        public PIR_Root_Cause_Case_Item__c rcCaseItem{set;get;}
        @AuraEnabled
        public string finalMessage{set;get;}
        public ResultWrapper(){
            rcCaseItem = new PIR_Root_Cause_Case_Item__c();
        }
    }
}