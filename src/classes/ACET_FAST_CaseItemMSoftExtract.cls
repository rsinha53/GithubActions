/*****************************************************************************************************
ACET_FAST_CaseItemMSoftExtract
Test Class Name:  ACET_FAST_CaseItemMSoftExtractTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_CaseItemMSoftExtract Component. 
Reference US3630752 - CPU: Case Mapping  - Multiple Tab Spreadsheets
06/15/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_CaseItemMSoftExtract{
    public static string metaDataErrorMessage='There is no Custom meta data loaded for fieldsets in "ACET_FAST_CaseItemsFieldSet" please contact system adminstrator'; 
    public static string noMuleSoftFile= 'There is no mulesoft file exists to process';
    @AuraEnabled
    public static LoadRsponse getLatestCaseAttachment(string caseId){
        LoadRsponse lResp = new LoadRsponse();
        try{
            lResp.caseNuber = getCaseNumber(caseId);
            lResp.message = 'SUCCESS';
            lResp.fieldSets = getFieldsData();
            checkMetaData(lResp, caseId);
        }
        catch(exception ex){
            lResp.message =  ex.getMessage();
            
        }
        return lResp;
    }
    public static string getCaseNumber(string caseID){
        string caseNumber='';
        List<Case> caseList = new List<Case>();
        caseList=[SELECT id, casenumber FROM case WHERE id=:caseID];
        if(caseList.size()>0){
            caseNumber = caseList[0].casenumber;
        }
        return caseNumber;
    }
    public static void checkMetaData(LoadRsponse lResp, string caseId){
        lResp.message = metaDataErrorMessage;
        if(lResp.fieldSets.size()>0){
            validateFile(lResp, caseId);
        }
    }
    public static void validateFile(LoadRsponse lResp, string caseId){
        lResp.message = noMuleSoftFile;
        ContentVersion contVer = getContetntVersion(caseId);
        if(contVer!=null && contVer.id!=null){
            lResp.fileJson = json.deserializeuntyped(contVer.versiondata.tostring());
           	lResp.message='SUCCESS';
        }
    }
    public static ContentVersion getContetntVersion(string caseID){
        ACETFAST_MuleSoftMappingFileNaming__c setting = ACETFAST_MuleSoftMappingFileNaming__c.getOrgDefaults();
        string mulSoftFileName = setting.InboundFileName__c;
        string fileType = setting.filetype__C;
        List<ContentDocumentLink> docLink = new List<ContentDocumentLink>();
        docLink=[SELECT id,LinkedEntityId,ContentDocumentId, ContentDocument.Title, ContentDocument.FileType 
                 FROM ContentDocumentLink  
                 WHERE LinkedEntityId=:caseID AND ContentDocument.Title=:mulSoftFileName
                 AND ContentDocument.FileType=:fileType ORDER BY SystemModstamp DESC LIMIT 1 ];
        List<ContentVersion> contVerList = new List<ContentVersion>();
        if(docLink.size()>0){
            contVerList= [SELECT id, versiondata, ContentDocumentId 
                          FROM ContentVersion 
                          WHERE ContentDocumentId=:docLink[0].ContentDocumentId AND IsLatest=true LIMIT 1];
        }
        ContentVersion contVer = new ContentVersion();
        if(contVerList.size()>0){
            contVer = contVerList[0];
        }
        return contVer;
    }
    public static List<ACET_FAST_CaseItemsFieldSet__mdt> getFieldsData(){
        List<ACET_FAST_CaseItemsFieldSet__mdt> fieldList = new List<ACET_FAST_CaseItemsFieldSet__mdt>();
        fieldList=[SELECT Label, DeveloperName, Field_Label__c, Field_API__c, Display_Order__c FROM ACET_FAST_CaseItemsFieldSet__mdt ORDER BY Display_Order__c ASC];
        return fieldList;
    }
    @AuraEnabled
    public static string createJSON(Object jSONFile,string caseId){
        string result='SUCCESS';
        try{
            ACETFAST_MuleSoftMappingFileNaming__c csConfig = ACETFAST_MuleSoftMappingFileNaming__c.getOrgDefaults();
            
            ContentVersion contVer = new ContentVersion(
                Title = csConfig.OutboundFileName__c,
                PathOnClient = csConfig.OutboundFileName__c +'.json',
                VersionData = Blob.valueOf(JSON.serialize(jSONFile)),
                IsMajorVersion = false           
            );
            insert contVer;
           Id contdocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contVer.Id].ContentDocumentId;
            
            ContentDocumentLink cdLink = 
                new ContentDocumentLink(
                    ContentDocumentId=contdocId,
                    LinkedEntityId=caseId);
            
            insert cdLink;
            case caseRec = new case (id=caseID, CPU_Processing_Status__c='Mapping Complete');
            update caseRec;
            List<case> caseList=[SELECT id,status,CPU_Processing_Status__c,Interaction__c,casenumber FROM case WHERE id=:caseID];
            List<Spire_to_MuleSoft__e> sPMEList=new List<Spire_to_MuleSoft__e> (); 
            Spire_to_MuleSoft__e sPME=new Spire_to_MuleSoft__e(CaseId__c=caseId,
                                                               Status__c=caseList[0].status,
                                                               CPU_Processing_Status__c=caseList[0].CPU_Processing_Status__c,
                                                               InteractionID__c=caseList[0].Interaction__c                                                               
                                                              );
            sPMEList.add(sPME);
            if(sPMEList.size()>0){
               List<Database.SaveResult> results = EventBus.publish(sPMEList);
                system.debug('result-->'+results); 
            }
                
        }
        catch(exception ex){
            result = ex.getMessage();
        }
        return result;
    }
    public class LoadRsponse{
        @AuraEnabled public string caseNuber{set;get;}
        @AuraEnabled public object fileJson{set;get;}
        @AuraEnabled public List<ACET_FAST_CaseItemsFieldSet__mdt> fieldSets{set;get;}
        @AuraEnabled public string message{set;get;}
    }
}