/**
 * @name         	:  ACET_CPM_RootCauseController
 * @description  	:  This class is controller for ACET_CPM_RootCauseComponent to process Rootcause functionality for CPM Team
 * @author       	:  Ganesh Medisetti
 * @createddate  	:  13/05/2021
 * @TestClass Name	:  ACET_CPM_RootCauseControllerTest
 **/
public with sharing class ACET_CPM_RootCauseController {
    @AuraEnabled
    public static Project_Details__c fetchRootCauseData(String recordId){
        try{
            return [SELECT Id, Root_Cause_1__c, Root_Cause_1_Key_Code__c, Root_Cause_2__c, Root_Cause_2_Key_Code__c,
               Root_Cause_3__c, Root_Cause_3_Key_Code__c, Root_Cause_4__c, Root_Cause_4_Key_Code__c,
               Root_Cause_5__c, Root_Cause_5_Key_Code__c FROM Project_Details__c WHERE Id =:recordId LIMIT 1];
        }catch(exception e){
            return null;
        }
    }
    
    @AuraEnabled
    public static void saveRootCauseData(Id recordId, Map<String,String> keyValuePairs){
        try{
            sObject cpmProjectObj  = recordId.getSObjectType().newSObject(recordId);
            cpmProjectObj.Id = recordId;
            for(String key: keyValuePairs.keyset()){
                cpmProjectObj.put(key, keyValuePairs.get(key));
            }
            update cpmProjectObj;
        }catch(Exception e){
            system.debug('Excpetion in updating object-->'+e);
        }
        
    }
}