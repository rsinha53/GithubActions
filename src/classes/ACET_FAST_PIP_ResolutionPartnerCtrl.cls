/*****************************************************************************************************
ACET_FAST_PIP_ResolutionPartnerCtrl
Test Class Name:  ACET_FAST_PIP_ResolutionPartnerCtrlTest
Author: Karimulla Shaik
Description: This class is used to get case record type value. 
Reference US2853229 - E2E - Edit & Save a Resolution Partner
11/26/2020 - Karimulla Shaik - Initial
Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 *              No.     Date            Author                  Description
 *              ----    ------------    --------------------    ----------------------------------------------
 * @version     1.0     2020-11-26      Karimulla                Initial version
 * @version     2.0     2021-02-04      mredd145                 US3246254 

******************************************************************************************************/
public with sharing class ACET_FAST_PIP_ResolutionPartnerCtrl {
    @AuraEnabled
    //US3246254 - RP record - Details page view 
    public static ACET_FAST_PIP_ResolutionPartnerCtrl.ResultWrapper getRPName(id recId){
        ACET_FAST_PIP_ResolutionPartnerCtrl.ResultWrapper finalResult = new  ACET_FAST_PIP_ResolutionPartnerCtrl.ResultWrapper();
        PIR_Resolution_Partner__c rpRec = [select id, Name from PIR_Resolution_Partner__c where id =: recId];
        finalResult.rpName = rpRec.Name;
        finalResult.rpID = rpRec.id;
        return finalResult;
    }
        
    @AuraEnabled
    public static CaseResolutionWrapper getCaseRecordType(string caseRecId){
        CaseResolutionWrapper caseWrap = new CaseResolutionWrapper();
        String objectName = findObjectNameFromRecordIdPrefix(caseRecId);
        caseWrap.objectName = objectName;
        System.debug('obj Name-->'+objectName);
        if(caseRecId!='' && caseRecId!=null ){
            if(objectName =='Case'){
                caseWrap.caseRec=[SELECT id, RecordType.Name, CaseNumber, status, Case_Type__c FROM Case WHERE id=:caseRecId];
            if(caseWrap.caseRec.RecordType.Name=='Reactive Resolution'){
                caseWrap.resolutionRcordtypeId = ACET_FAST_PIP_ResolutionPartnerCtrl.getRecordTypeIdbyDevName('PIR_Resolution_Partner__c','Reactive_Resolution_Partners');
            }else{
               caseWrap.resolutionRcordtypeId = ACET_FAST_PIP_ResolutionPartnerCtrl.getRecordTypeIdbyDevName('PIR_Resolution_Partner__c','Proactive_Action_Partner');   
            }
            } else if(objectName =='Case_Item__c'){
                caseWrap.caseItemRec=[SELECT id, RecordType.Name, Case__c, Status__c, ExternalID__c FROM Case_Item__c WHERE id=:caseRecId];
                caseWrap.resolutionRcordtypeId = ACET_FAST_PIP_ResolutionPartnerCtrl.getRecordTypeIdbyDevName('PIR_Resolution_Partner__c','Reactive_Resolution_Partners');
               caseWrap.caseRec=[SELECT id, RecordType.Name, CaseNumber, status, Case_Type__c FROM Case WHERE id=:caseWrap.caseItemRec.Case__c];
            
            }
        } 
        return caseWrap;
    }
    
    public static string findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){

                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
    
    public static Id getRecordTypeIdbyDevName(String objectName, String strRecordTypeDevName){
        return  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(strRecordTypeDevName).getRecordTypeId();
    }
    public class CaseResolutionWrapper{
        @AuraEnabled
        public Case caseRec{set;get;}
        @AuraEnabled
        public Case_Item__c caseItemRec{set;get;}
        @AuraEnabled
        public String objectName{set;get;}
        @AuraEnabled
        public id resolutionRcordtypeId{set;get;}
        public CaseResolutionWrapper(){
            CaseRec = new case();
            caseItemRec = new Case_Item__c();
        }
    }
    //US3246254 - RP record - Details page view
    public class ResultWrapper{
        @AuraEnabled
        public string rpName{get;set;}
        @AuraEnabled
        public string rpID{get;set;}
    }

}