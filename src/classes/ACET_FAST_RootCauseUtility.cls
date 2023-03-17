/*****************************************************************************************************
ACET_FAST_RootCauseUtility
Test Class Name:  ACET_FAST_RootCauseUtilityTest
Author: Shaik Mohammad Yaseen
Description: This class is used an helper for ACET_FAST_RootCauseCtrl ACET_FAST_RootCauseComp. 
US3544639 - Root Cause - Reusable Component.
13/05/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_RootCauseUtility {
    
    @AuraEnabled
    public static FinalJson getRootCauseWrapper(string wrapperJSON){
        system.debug('wrapperJSON==>'+wrapperJSON);
        FinalJson fJsonWrap = new FinalJson();
        try{
            JsonWrap wrap = new JsonWrap();
            wrap = (JsonWrap)JSON.deserialize(wrapperJSON, JsonWrap.class);
            system.debug('wrap==>'+wrap);
            fJsonWrap.rc1List = getrootCause1List();
            if(wrap.rc1!='' && wrap.rc1!=null && wrap.rc1KeyCode!='' && wrap.rc1KeyCode!=null){
                fJsonWrap.rc2List = getrootCause2List(wrap.rc1KeyCode);
            }
            if(wrap.rc2!='' && wrap.rc2!=null && wrap.rc2KeyCode!='' && wrap.rc2KeyCode!=null){
                fJsonWrap.rc3List = getrootCause3List(wrap.rc2KeyCode);
            }
            if(wrap.rc3!='' && wrap.rc3!=null && wrap.rc3KeyCode!='' && wrap.rc3KeyCode!=null){
                fJsonWrap.rc4List = getrootCause4List(wrap.rc3KeyCode);
            }
            if(wrap.rc4!='' && wrap.rc4!=null && wrap.rc4KeyCode!='' && wrap.rc4KeyCode!=null){
                fJsonWrap.rc5List = getrootCause5List(wrap.rc4KeyCode);
            }
            fJsonWrap.fMessage = 'SUCCESS';
        }
        catch(exception ex){
            system.debug('error is '+ex.getMessage());
            fJsonWrap.fMessage = ex.getMessage();
        }
        return fJsonWrap;
    }
    @AuraEnabled
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
    public class FinalJson{
        @AuraEnabled
        public string fMessage{set;get;}
        @AuraEnabled
        public List<RootCauseWrap> rc1List{set;get;}
        @AuraEnabled
        public List<RootCauseWrap> rc2List{set;get;}
        @AuraEnabled
        public List<RootCauseWrap> rc3List{set;get;}
        @AuraEnabled
        public List<RootCauseWrap> rc4List{set;get;}
        @AuraEnabled
        public List<RootCauseWrap> rc5List{set;get;}
    }
    public class JsonWrap{
        @AuraEnabled
        public string rc1{set;get;}
        @AuraEnabled
        public string rc1KeyCode{set;get;}
        @AuraEnabled
        public string rc2{set;get;}
        @AuraEnabled
        public string rc2KeyCode{set;get;}
        @AuraEnabled
        public string rc3{set;get;}
        @AuraEnabled
        public string rc3KeyCode{set;get;}
        @AuraEnabled
        public string rc4{set;get;}
        @AuraEnabled
        public string rc4KeyCode{set;get;}
        @AuraEnabled
        public string rc5{set;get;}
        @AuraEnabled
        public string rc5KeyCode{set;get;}
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
}