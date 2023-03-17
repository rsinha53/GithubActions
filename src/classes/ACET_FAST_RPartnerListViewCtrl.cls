/*****************************************************************************************************
ACET_FAST_RPartnerListViewCtrl
Test Class Name:  ACET_FAST_RPartnerListViewCtrlTest
Author: Santhosh Kukunarapu
Description: This class is used an controller for ACET_FAST_RPRefInlineEdit Component. 
09/06/2021 - Santhosh Kukunarapu
******************************************************************************************************/
public with sharing class ACET_FAST_RPartnerListViewCtrl {

    @AuraEnabled
    public static FWrapper getReferences(String caseId){
        FWrapper finalWrap = new FWrapper();
        
        List<PIR_Resolution_Partner__c> rpartner = new List<PIR_Resolution_Partner__c>();
        rpartner= [SELECT id, Case__c, Case_Item__c FROM PIR_Resolution_Partner__c WHERE Case__c=:caseId];
      
        List<PIR_Resolution_Partners_Reference__c> refList = new List<PIR_Resolution_Partners_Reference__c>();
        refList=[SELECT id, Reference__c, PIR_Resolution_Partner__c, Completed__c, SLA_Indicator__c, 
                 SLA_Routed_Date__c, SLA_Due_Date__c,SLA_Completion_Date__c,
                 PIR_Resolution_Partner__r.Case__c, PIR_Resolution_Partner__r.Case__r.CaseNumber,
                 PIR_Resolution_Partner__r.Case__r.RecordType.Name,
                 PIR_Resolution_Partner__r.Name,
                  PIR_Resolution_Partner__r.Id,
                 PIR_Resolution_Partner__r.Provider_Matrix_Proactive__r.Name, 
                 PIR_Resolution_Partner__r.Provider_Matrix_Reactive__r.Name, 
                 PIR_Resolution_Partner__r.Case_Item__c, PIR_Resolution_Partner__r.Case_Item__r.Name, 
                 PIR_Resolution_Partner__r.Case_Item__r.ExternalID__c
                 FROM PIR_Resolution_Partners_Reference__c
                 WHERE PIR_Resolution_Partner__c IN :rpartner AND Completed__c!=true];
        List<PageRefWrap> wrapList = new List<PageRefWrap>();
        if(refList.size()>0){
            for(PIR_Resolution_Partners_Reference__c ref: refList){
                wrapList.add(assignWrapper(ref));  
            }
        }
        finalWrap.pRefWrapList.addAll(wrapList);
        return finalWrap;
    }
   
   
    public static PageRefWrap assignWrapper(PIR_Resolution_Partners_Reference__c ref){
        PageRefWrap prefWrap = new PageRefWrap();
        prefWrap.RefId=ref.PIR_Resolution_Partner__r.Id;
        prefWrap.RefName = ref.Reference__c;
        prefWrap.cNumber = ref.PIR_Resolution_Partner__r.Name;
        prefWrap.cItemNumber = ref.PIR_Resolution_Partner__r.Case_Item__r.Name;
        prefWrap.extId = ref.PIR_Resolution_Partner__r.Case_Item__r.ExternalID__c;
        if(ref.PIR_Resolution_Partner__r.Case__r.RecordType.Name=='Proactive Action'){
            prefWrap.rpName = ref.PIR_Resolution_Partner__r.Provider_Matrix_Proactive__r.Name;
        }else if(ref.PIR_Resolution_Partner__r.Case__r.RecordType.Name=='Reactive Resolution'){
            prefWrap.rpName = ref.PIR_Resolution_Partner__r.Provider_Matrix_Reactive__r.Name;
        }
        prefWrap.slaIndicator = slaIndicatorClr(ref);
        prefWrap.slaRoutedDate = String.valueOf(ref.SLA_Routed_Date__c);
        prefWrap.slaDueDate = String.valueOf(ref.SLA_Due_Date__c);
        prefWrap.slaCompletionDate = String.valueOf(ref.SLA_Completion_Date__c);
        return prefWrap;
    }
    public static string slaIndicatorClr(PIR_Resolution_Partners_Reference__c ref){
       string color = 'ERROR';
        if(ref.SLA_Completion_Date__c != null && ref.SLA_Completion_Date__c < ref.SLA_Due_Date__c && ref.Completed__c == TRUE ){
            color = 'CONFIRM';
        }else if(ref.SLA_Due_Date__c > system.today() && ref.Completed__c==FALSE){
            color = 'WARNING';
        }
        return color;
    }
    public class FWrapper{
        @AuraEnabled public boolean isCaseItem{set;get;}
        @AuraEnabled public List<PageRefWrap> pRefWrapList{set;get;}
        public FWrapper(){
            pRefWrapList = new List<PageRefWrap>();
        }
    }
    public class PageRefWrap{
        @AuraEnabled public boolean selectedCheckBox{set;get;}
        @AuraEnabled public string RefId{set;get;}
        @AuraEnabled public String RefName{set;get;}
        @AuraEnabled public boolean completed{set;get;}
        @AuraEnabled public string cNumber{set;get;}
        @AuraEnabled public string cItemNumber{set;get;}
        @AuraEnabled public string extId{set;get;}
        @AuraEnabled public string rpName{set;get;}
        @AuraEnabled public string slaIndicator{set;get;}
        @AuraEnabled public string slaRoutedDate{set;get;}
        @AuraEnabled public string slaDueDate{set;get;}
        @AuraEnabled public string slaCompletionDate{set;get;}
    }
}