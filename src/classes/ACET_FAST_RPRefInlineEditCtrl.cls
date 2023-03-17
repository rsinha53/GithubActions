/*****************************************************************************************************
ACET_FAST_RPRefInlineEditCtrl
Test Class Name:  ACET_FAST_RPRefInlineEditCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_RPRefInlineEdit Component. 
Reference US3396494 - RP record Checkbox
30/03/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_RPRefInlineEditCtrl {

    @AuraEnabled
    public static FWrapper getReferences(String rpId){
        FWrapper finalWrap = new FWrapper();
        
        PIR_Resolution_Partner__c rpartner = new PIR_Resolution_Partner__c();
        rpartner= [SELECT id, Case__c, Case_Item__c FROM PIR_Resolution_Partner__c WHERE id=:rpId];
        if(rpartner.Case_Item__c!=null){
            finalWrap.isCaseItem = true;
        }
        
        List<PIR_Resolution_Partners_Reference__c> refList = new List<PIR_Resolution_Partners_Reference__c>();
        refList=[SELECT id, Reference__c, PIR_Resolution_Partner__c, Completed__c, SLA_Indicator__c, 
                 SLA_Routed_Date__c, SLA_Due_Date__c,SLA_Completion_Date__c,
                 PIR_Resolution_Partner__r.Case__c, PIR_Resolution_Partner__r.Case__r.CaseNumber,
                 PIR_Resolution_Partner__r.Case__r.RecordType.Name,
                 PIR_Resolution_Partner__r.Provider_Matrix_Proactive__r.Name, 
                 PIR_Resolution_Partner__r.Provider_Matrix_Reactive__r.Name, 
                 PIR_Resolution_Partner__r.Case_Item__c, PIR_Resolution_Partner__r.Case_Item__r.Name, 
                 PIR_Resolution_Partner__r.Case_Item__r.ExternalID__c
                 FROM PIR_Resolution_Partners_Reference__c
                 WHERE PIR_Resolution_Partner__c=:rpId];
        List<PageRefWrap> wrapList = new List<PageRefWrap>();
        if(refList.size()>0){
            for(PIR_Resolution_Partners_Reference__c ref: refList){
                wrapList.add(assignWrapper(ref));  
            }
        }
        finalWrap.pRefWrapList.addAll(wrapList);
        return finalWrap;
    }
    @AuraEnabled
    public static FWrapper completeSelected(List<PageRefWrap> pagreRefWrapList, string rpId){
        List<PIR_Resolution_Partners_Reference__c> refListToUpdate = new List<PIR_Resolution_Partners_Reference__c>();
        for(PageRefWrap pRefWrap: pagreRefWrapList){
            if(pRefWrap.selectedCheckBox==true){
                PIR_Resolution_Partners_Reference__c prRef = new  PIR_Resolution_Partners_Reference__c();
                prRef.id= pRefWrap.RefId;
                prRef.Completed__c = true;
                refListToUpdate.add(prRef);
            }
        }
        if(refListToUpdate.size()>0){
            update refListToUpdate;
        }
        return getReferences(rpId);
    }
    @AuraEnabled
    public static FWrapper deleteSelected(List<PageRefWrap> pagreRefWrapList, string rpId){
        List<PIR_Resolution_Partners_Reference__c> refListToDelete = new List<PIR_Resolution_Partners_Reference__c>();
        List<PageRefWrap> returnList = new List<PageRefWrap>();
        for(PageRefWrap pRefWrap: pagreRefWrapList){
            if(pRefWrap.selectedCheckBox==true){
                PIR_Resolution_Partners_Reference__c prRef = new  PIR_Resolution_Partners_Reference__c();
                prRef.id= pRefWrap.RefId;
                prRef.Completed__c = true;
                refListToDelete.add(prRef);
            }else{
                returnList.add(pRefWrap);
            }
        }
        if(refListToDelete.size()>0){
            delete refListToDelete;
        }
        return getReferences(rpId);
    }
    public static PageRefWrap assignWrapper(PIR_Resolution_Partners_Reference__c ref){
        PageRefWrap prefWrap = new PageRefWrap();
        prefWrap.RefId=ref.id;
        prefWrap.RefName = ref.Reference__c;
        prefWrap.completed = ref.Completed__c;
        prefWrap.cNumber = ref.PIR_Resolution_Partner__r.Case__r.CaseNumber;
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