/*****************************************************************************************************
ACET_FAST_PIRResolutionParterCtrl 
Test Class Name:  ACET_FAST_PIRResolutionParterCtrlTest
Author: Ratna Kumar Mukiri
Description: This class will provide the business logic for both aura Components ACET_FAST_PIRResolutionParteCmp and ACET_FAST_PIRResolutionParterdetails
Reference:US2941823 - FAST Case Permissions and Fields Validations
17/04/2021 - Ratna Kumar Mukiri - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_PIRResolutionParterCtrl {
    
     @AuraEnabled 
    public static CaseItemWrapper getCaseItemRecord(string caseItemId){
       
        CaseItemWrapper caseItemWrap = new CaseItemWrapper();
        Case_Item__c caseItemRec = new Case_Item__c();
        if(caseItemId!='' && caseItemId!=null){
            caseItemRec=[SELECT Id,Name,ExternalID__c, Case__c,Reference_Number__c FROM Case_Item__c WHERE id=:caseItemId];
            caseItemWrap.caseItem = caseItemRec;
        }
   
        return caseItemWrap;
    }
    
    @AuraEnabled 
    public static void updateCaseItem(Case_Item__c caseItemRec){
    
        
      }
    @AuraEnabled
    public static PIR_Resolution_Partner__c getRPRecord(string caseItemRPRecId){
        PIR_Resolution_Partner__c caseItemRPRec = new PIR_Resolution_Partner__c();
        if(caseItemRPRecId!='' && caseItemRPRecId!=null){
            caseItemRPRec=[SELECT Id,Name,Case_Item__c,External_ID__c,createdby.name, Case__c, Escalation_Notes__c, SLA_Routed_Date__c,
                           Resolution_Partner_Outcome__c, SLA_Completion_Date__c,
                           SLA_Due_Date__c, Days_Past_SLA__c, Case_Resolution_Partner_Number__c,
                           Partner_Reference_Number__c, Comments__c, SLA_Indicator__c, Provider_Matrix_Reactive__c,Provider_Matrix_Reactive__r.Name, 
                           Provider_Matrix_Proactive__c FROM PIR_Resolution_Partner__c WHERE id=:caseItemRPRecId];
        }
        return caseItemRPRec;
    }

    @AuraEnabled
    public static PIR_Resolution_Partners_Reference__c getReferenceRecord(String caseItemRPRecId)
    {
        System.debug('check '+caseItemRPRecId);
         PIR_Resolution_Partners_Reference__c caseItemRPRec = new PIR_Resolution_Partners_Reference__c();
        if(caseItemRPRecId!='' && caseItemRPRecId!=null){
            caseItemRPRec=[SELECT Id,Name,CreatedBy.Name, SLA_Routed_Date__c,
                            SLA_Completion_Date__c,PIR_Resolution_Partner__c,CreatedById
                            FROM PIR_Resolution_Partners_Reference__c WHERE PIR_Resolution_Partner__c=:caseItemRPRecId];
        }
        return caseItemRPRec;
    }
    
    @AuraEnabled
    public static case getCaseRecord(string caseRecId){
        case caseRec = new case();
        if(caseRecId!='' && caseRecId!=null){
            caseRec=[SELECT id,RecordType.Name, CaseNumber,status,Case_Type__c,FAST_PIP_Markets__c,Original_Received_Date__c FROM Case WHERE id=:caseRecId];
        }
        return caseRec;
    }
  @AuraEnabled  
  public static PIR_Resolution_Partners_Reference__c  getRPRefrenceNumberRecord(String caseItemRefNoId)
  {
    PIR_Resolution_Partners_Reference__c caseItemRefNo = new PIR_Resolution_Partners_Reference__c();
        if(caseItemRefNoId!='' && caseItemRefNoId!=null){
            caseItemRefNo=[SELECT Id,Name,Case_Item__r.Name,Reference__c,SLA_Completion_Date__c,SLA_Routed_Date__c 
                                                  from PIR_Resolution_Partners_Reference__c WHERE Reference__c=:caseItemRefNoId ];
        }
        return caseItemRefNo;
    }   
 

  @AuraEnabled
  public static ACET_FAST_PIRResolutionParterCtrl.ResultWrapper validateRPRecord(ID prMatrixId,ID caseId){ 
  
     ACET_FAST_PIRResolutionParterCtrl.ResultWrapper finalResult = new  ACET_FAST_PIRResolutionParterCtrl.ResultWrapper();
       
    List<PIR_Resolution_Partner__c> rPRecord = new List<PIR_Resolution_Partner__c>();
      if(prMatrixId!=null && caseId!=null ){
         rPRecord=[SELECT Id,name, Case__c,Provider_Matrix_Reactive__r.Name from  PIR_Resolution_Partner__c where Case__c =:caseId and Provider_Matrix_Reactive__c =:prMatrixId];
       }  
      if(rPRecord.size()>0){
          finalResult.rpName = rPRecord[0].Name;
        finalResult.rpID = rPRecord[0].id;
       }
        return finalResult;
    
   }
      @AuraEnabled
     public static ACET_FAST_PIRResolutionParterCtrl.ResultWrapper getRPName(id recId){
        ACET_FAST_PIRResolutionParterCtrl.ResultWrapper finalResult = new  ACET_FAST_PIRResolutionParterCtrl.ResultWrapper();
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
    public class CaseItemWrapper{
        @AuraEnabled
        public Case_Item__c caseItem;
        @AuraEnabled
        public String prNumber;
         @AuraEnabled
        public String prRefNumber;
        
    }
}