/*****************************************************************************************************
ACET_FAST_ProviderMatrixDetailCtrl
Test Class Name:  ACET_FAST_ProviderMatrixDetailCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_ProviderMatrixDetailCmp Components. 
Reference US3338284 - Creating RP record from Provider Matrix detail page
24/02/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public without sharing class ACET_FAST_ProviderMatrixDetailCtrl {

    @AuraEnabled
    public static CaseRectypeNameRPNameWrapper getCaseRPWrapper(string pMatrixId, String caseId){
        CaseRectypeNameRPNameWrapper cWrap = new CaseRectypeNameRPNameWrapper();
        string rpNameValue = '';
        if(pMatrixId!='' && pMatrixId!=null){
            List<Provider_Matrix__c> pMatrixList = new List<Provider_Matrix__c>();
            pMatrixList=[SELECT id, CrossWalk_Case_RPI__c FROM Provider_Matrix__c WHERE id=:pMatrixId];
            if(pMatrixList.size()>0){
                rpNameValue=pMatrixList[0].CrossWalk_Case_RPI__c;
            }
        }
        string caseRectypName = '';
        if(caseId!=null){
            List<Case> caseList = new List<Case>();
            caseList=[SELECT Recordtype.name from case where id=:caseId];
            if(caseList.size()>0){
                caseRectypName =caseList[0].Recordtype.name;
                if(caseRectypName=='Reactive Resolution'){
                    cWrap.rpRecTypeId = getRecordTypeIdbyDevName('PIR_Resolution_Partner__c','Reactive_Resolution_Partners');
                }else{
                    cWrap.rpRecTypeId = getRecordTypeIdbyDevName('PIR_Resolution_Partner__c','Proactive_Action_Partner');   
                }
            }
        }
        cWrap.rpName = rpNameValue;
        cWrap.caseRecordType = caseRectypName;
        return cWrap;
    }
    @AuraEnabled
    public static string getResolutionPartnerId(string rpName){
        string rpId = '';
        if(rpName!=null && rpName!=''){
            List<Provider_Matrix__c> rpNamesList = new List<Provider_Matrix__c>();  
            rpNamesList = [SELECT id from Provider_Matrix__c where name=:rpName];
            if(rpNamesList.size()>0){
                rpId =  rpNamesList[0].id;
            }
        }
        return rpId;
    }
    public static Id getRecordTypeIdbyDevName(String objectName, String strRecordTypeDevName){
        return  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(strRecordTypeDevName).getRecordTypeId();
    }
    public class CaseRectypeNameRPNameWrapper{
        @AuraEnabled
        public string caseRecordType;
        @AuraEnabled
        public string rpName;
        @AuraEnabled
        public string rpRecTypeId;
    }
}