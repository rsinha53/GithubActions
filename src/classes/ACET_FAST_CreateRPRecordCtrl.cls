/*****************************************************************************************************
ACET_FAST_CreateRPRecordCtrl
Test Class Name:  ACET_FAST_CreateRPRecordCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_CreateRPRecord Components. 
Reference US3338284 - Creating RP record from Provider Matrix detail page
11/03/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_CreateRPRecordCtrl {
    @AuraEnabled 
    public static ResultWrapper getRPNameId(id recId){
        ResultWrapper finalResult = new  ResultWrapper();
        PIR_Resolution_Partner__c rpRec = [select id, Name from PIR_Resolution_Partner__c where id =: recId];
        finalResult.rpName = rpRec.Name;
        finalResult.rpID = rpRec.id;
        return finalResult;
    }
    public class ResultWrapper{
        @AuraEnabled
        public string rpName{get;set;}
        @AuraEnabled
        public string rpID{get;set;}
    }
}