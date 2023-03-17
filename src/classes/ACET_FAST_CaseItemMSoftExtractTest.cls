/*****************************************************************************************************
ACET_FAST_CaseItemMSoftExtractTest
Testing Class Name:  ACET_FAST_CaseItemMSoftExtract
Author: Shaik Mohammad Yaseen
Date: 16/07/2021
Description: This is test class and used to get test coverage for ACET_FAST_CaseItemMSoftExtract. 
Initial: Mukiri Rathna Kumar 
******************************************************************************************************/
@isTest(seeAllData=false)
public class ACET_FAST_CaseItemMSoftExtractTest {
    
    public static testmethod  void getLatestCaseAttachmentTest(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user sysAdminUser;
        System.runAs(thisUser){
            sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
            insert sysAdminUser;
        }
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        System.runAs(sysAdminUser){
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = caseRec.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            
            ACET_FAST_CaseItemMSoftExtract.getLatestCaseAttachment(caseRec.Id);
            Object obj='{"errors": [ "Data failed validation rules" ],"message": "Please edit and retry","details": {"record": "001000000000001","record_type": "Account"}}';
            string caseMEssage = ACET_FAST_CaseItemMSoftExtract.createJSON(obj,caseRec.Id);
            system.debug('caseMEssage==>'+caseMEssage);  
        }
    }
    
}