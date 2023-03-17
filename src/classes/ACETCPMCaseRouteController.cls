/**
ACETCPMCaseRouteController
Test Class Name:  ACETCPMCaseRouteControllerTest
Author: Ganesh Medisetti
Description: This class is used for Routing functionality in lightning for CPM team. 
08/17/2020 - Ganesh Medisetti - Initial
*/
public with sharing class ACETCPMCaseRouteController {
	@AuraEnabled  
    public static String fetchCsIdNBaseUrl(String rootRecId) {
        String finalStr='';
        string urlstr =URL.getSalesforceBaseUrl().toExternalForm();
        ID recID = rootRecId;
        String sObjName = recID.getSObjectType().getDescribe().getName();
        try{
            if('Project_Submission_Detail__c'.equalsIgnoreCase(sObjName)){
            //if(!Test.isRunningTest())
            Project_Submission_Detail__c proj = [Select Case__c from Project_Submission_Detail__c where Id =:rootRecId Limit 1];
            finalStr = proj.Case__c+'-##-'+urlstr;
            }else if('Claim_Impact_Report_Form__c'.equalsIgnoreCase(sObjName)){
                Claim_Impact_Report_Form__c imp = [SELECT Id, Name, Project_Details__r.Parent_Case__c, Beginning_Date__c FROM Claim_Impact_Report_Form__c where Id =:rootRecId Limit 1];
                finalStr = imp.Project_Details__r.Parent_Case__c+'-##-'+urlstr;
            }
            return finalStr;
        }catch(exception e){
            return finalStr;
        }
   
    }
}