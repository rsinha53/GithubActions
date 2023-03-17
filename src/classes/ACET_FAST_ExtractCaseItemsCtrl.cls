/*****************************************************************************************************
ACET_FAST_ExtractCaseItemsCtrl
Test Class Name:  ACET_FAST_ExtractCaseItemsCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_ExtractCaseItems Components. 
Reference US3288262 - POC - Export Child Cases into CSV
02/26/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public  with sharing class ACET_FAST_ExtractCaseItemsCtrl {

    public List<CaseItem> caseItemList{get;set;}
    public Case curCase{get;set;}
    
    //Constructor to generate the list of records
    public ACET_FAST_ExtractCaseItemsCtrl(){
        curCase = new Case();
        string cId =  apexpages.currentpage().getparameters().get('caseId'); 
        if(cId!='' && cId!=null){
            curCase = [SELECT id, CaseNumber, Interaction__c, Interaction__r.Name FROM Case WHERE id=:cId];
            set<id> caseIDSet = new set<id>();
            caseIDSet.add(cId);
            for(Case childCase: [SELECT id from case where parentId =:cId]){
                caseIDSet.add(childCase.id);
            }
            caseItemList = getCaseItems(caseIDSet);
        }
    }
    public List<CaseItem> getCaseItems(set<Id> cIdSet){
        List<CaseItem> cItemList = new List<CaseItem>();
        for(Case_Item__c cItem : queryCaseItems(cIdSet)){
            cItemList.add(assignWrapper(cItem));
        }
        return cItemList;
    }
    public List<Case_Item__c> queryCaseItems(set<Id> cIdSet){
        List<Case_Item__c> cItemList = new List<Case_Item__c>();
        cItemList = [SELECT id, name, Member_Number__c, Group_Number__c, Line_of_Business__c, 
                     Member_First_Name__c, Member_Last_Name__c, Total_Billed_Charges__c, 
                     Patient_Account_Number__c, ExternalID__c, Reference_Number__c, 
                     Reimbursement_Expected__c, DOB__c, Date_of_Service_Start__c, Date_of_Service_End__c, 
                     Provider_Comments__c, Status__c, Claim_Outcome_Status__c, Advocate_Comments__c, 
                     Case__c, Case__r.CaseNumber, Case__r.Interaction__c, Case__r.Interaction__r.Name,
                     Tax_ID__c 
                     FROM Case_Item__c WHERE Case__c IN:cIdSet ];
        return cItemList;
    }
    @AuraEnabled
    public static ACET_FAST_ExtractCaseItemsCtrl.CaseWrapper getRelatedCaseItemCount(string caseID){
        set<id> caseIDSet = new set<id>();
        caseIDSet.add(caseID);
        ACET_FAST_ExtractCaseItemsCtrl.CaseWrapper caseWrap = new ACET_FAST_ExtractCaseItemsCtrl.CaseWrapper();
        caseWrap.caseRec = [SELECT id, CaseNumber FROM Case WHERE id=:caseID];
        
        for(Case childCase: [SELECT id from case where parentId =:caseID]){
            caseIDSet.add(childCase.id);
        }
        caseWrap.caseItemCount = [SELECT count() FROM Case_Item__c WHERE Case__c IN:caseIDSet];
        return caseWrap;
    }
    @AuraEnabled
    public static ACET_FAST_ExtractCaseItemsCtrl.FResult attachCaseItem(string caseId, string caseNum){
        ACET_FAST_ExtractCaseItemsCtrl.FResult finalResult = new ACET_FAST_ExtractCaseItemsCtrl.FResult();
        
        
        try {
            insertAttchment(caseNum, caseId);
            finalResult.result = 'SUCCESS';
            finalResult.excelStr = getExcelFileAsBase64String(caseId);
        } catch (exception ex) {
            system.debug('body==>'+ex.getMessage());
            finalResult.result = ex.getMessage();
        }
        return finalResult;
    }
    
    public static void insertAttchment(string caseNum, string caseId){
        PageReference reportPage = Page.ACET_FAST_GenerateCaseItemsReport;
        reportPage.getParameters().put('caseId',caseId);
        
        Attachment attach = new Attachment();
        attach.Body = reportPage.getContent();
        attach.Name = 'Case Items - '+caseNum+'.xls';
        attach.IsPrivate = false;
        attach.ParentId = caseId;
        insert attach;
    }
    public static String getExcelFileAsBase64String(string cId) {
        PageReference excelPage = Page.ACET_FAST_GenerateCaseItemsReport;
        excelPage.getParameters().put('caseId',cId);
        Blob excelBlob = excelPage.getContent();
        String base64Excel = EncodingUtil.base64Encode(excelBlob);
        return base64Excel;
    }
    public static CaseItem assignWrapper(Case_Item__c csItem){
        CaseItem cItem = new CaseItem();
        cItem.CaseItem = (csItem.Name==null)? '' : csItem.Name;
        cItem.CaseNumber = (csItem.Case__r.CaseNumber==null)? '' : csItem.Case__r.CaseNumber;
        cItem.InteractionNumber = (csItem.Case__r.Interaction__r.Name==null)? '' : csItem.Case__r.Interaction__r.Name;
        cItem.MemberNumber = (csItem.Member_Number__c==null)? '' : csItem.Member_Number__c;
        cItem.GroupNumber = (csItem.Group_Number__c==null)? '' : csItem.Group_Number__c;
        cItem.LineOfBusiness = (csItem.Line_of_Business__c==null)? '' : csItem.Line_of_Business__c;
        cItem.MemberFirstName = (csItem.Member_First_Name__c==null)? '' : csItem.Member_First_Name__c;
        cItem.MemberLastName = (csItem.Member_Last_Name__c==null)? '' : csItem.Member_Last_Name__c;
        cItem.TotalBillCharges = (csItem.Total_Billed_Charges__c==null)? '' : string.valueOf(csItem.Total_Billed_Charges__c);
        cItem.PatientAccountNumber = (csItem.Patient_Account_Number__c==null)? '' : csItem.Patient_Account_Number__c;
        cItem.ExternalId = (csItem.ExternalID__c==null)? '' : csItem.ExternalID__c;
        cItem.CallRefrenceNumber = (csItem.Reference_Number__c==null)? '' : csItem.Reference_Number__c;
        cItem.ReimbursementExpected = (csItem.Reimbursement_Expected__c==null)? '' : string.valueOf(csItem.Reimbursement_Expected__c);
        cItem.dob = (csItem.DOB__c==null)? '' : string.valueOf(csItem.DOB__c);
        cItem.taxId = (csItem.Tax_ID__c==null)? '' : string.valueOf(csItem.Tax_ID__c);
        cItem = additionalFieldCheck(cItem,csItem);
        return cItem;
    }
    public static CaseItem additionalFieldCheck(CaseItem cItem,Case_Item__c csItem){
        cItem.DateOfServiceStart = (csItem.Date_of_Service_Start__c==null)? '' : string.valueOf(csItem.Date_of_Service_Start__c);
        cItem.DateOfServiceEnd = (csItem.Date_of_Service_End__c==null)? '' : string.valueOf(csItem.Date_of_Service_End__c);
        cItem.ProviderComments  = (csItem.Provider_Comments__c==null)? '' : csItem.Provider_Comments__c;
        cItem.Status = (csItem.Status__c==null)? '' : csItem.Status__c;
        cItem.ClaimOutCome = (csItem.Claim_Outcome_Status__c==null)? '' : csItem.Claim_Outcome_Status__c;
        cItem.AdvocateComments = (csItem.Advocate_Comments__c==null)? '' : csItem.Advocate_Comments__c;
        return cItem;
       
    }
    public class CaseWrapper{
        @AuraEnabled public Integer caseItemCount{set;get;}
        @AuraEnabled public Case caseRec{set;get;}
        public caseWrapper(){
            caseRec = new Case();
        }
    }
    public class CaseItem{
        @AuraEnabled public string CaseItem{set;get;}
        @AuraEnabled public string CaseNumber{set;get;}
        @AuraEnabled public string InteractionNumber{set;get;}
        @AuraEnabled public string MemberNumber{set;get;}
        @AuraEnabled public string GroupNumber{set;get;}
        @AuraEnabled public string LineOfBusiness{set;get;}
        @AuraEnabled public string MemberFirstName{set;get;}
        @AuraEnabled public string MemberLastName{set;get;}
        @AuraEnabled public string TotalBillCharges{set;get;}
        @AuraEnabled public string PatientAccountNumber{set;get;}
        @AuraEnabled public string ExternalId{set;get;}
        @AuraEnabled public string CallRefrenceNumber{set;get;}
        @AuraEnabled public string ReimbursementExpected{set;get;}
        @AuraEnabled public string dob{set;get;}
        @AuraEnabled public string DateOfServiceStart{set;get;}
        @AuraEnabled public string DateOfServiceEnd{set;get;}
        @AuraEnabled public string ProviderComments{set;get;}
        @AuraEnabled public string Status{set;get;}
        @AuraEnabled public string ClaimOutCome{set;get;}
        @AuraEnabled public string AdvocateComments{set;get;}
        @AuraEnabled public string taxId{set;get;}
    }
    public class FResult{
        @AuraEnabled public string result;
        @AuraEnabled public string excelStr;
    }
}