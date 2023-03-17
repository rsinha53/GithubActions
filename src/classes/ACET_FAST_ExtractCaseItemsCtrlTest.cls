/*****************************************************************************************************
ACET_FAST_ExtractCaseItemsCtrlTest
Testing Class Name:  ACET_FAST_ExtractCaseItemsCtrl
Author: Shaik Mohammad Yaseen
Date: 03/02/2021
Description: This is test class and used to get test coverage for ACET_FAST_ExtractCaseItemsCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_ExtractCaseItemsCtrlTest {
    public static testMethod void extractCaseItems() {
        
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;

        System.runAs(sysAdminUser) {
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution', 'New');
            insert caseRec;
    
            case caseRec1 = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution', 'New');
            caseRec1.ParentId = caseRec.Id;
            insert caseRec1;
            id recTypeId = Schema.SObjectType.Case_Item__c.getRecordTypeInfosByName()
                .get('PIR Case Items')
                .getRecordTypeId();
            List<Case_Item__c> caseItemList = new List<Case_Item__c>();
            Case_Item__c caseItem = new Case_Item__c(RecordTypeId = recTypeId, Status__c = 'New', Case__c = caseRec.id);
            caseItemList.add(caseItem);

            Case_Item__c caseItem1 = new Case_Item__c(
                RecordTypeId = recTypeId,
                Status__c = 'New',
                Case__c = caseRec1.id
            );
            caseItemList.add(caseItem1);

            insert caseItemList;

            PageReference pageRef = Page.ACET_FAST_GenerateCaseItemsReport; // Add your VF page Name here
            pageRef.getParameters().put('caseId', caseRec.id);
            Test.setCurrentPage(pageRef);
        
			ACET_FAST_ExtractCaseItemsCtrl  obj = new ACET_FAST_ExtractCaseItemsCtrl();
        
            ACET_FAST_ExtractCaseItemsCtrl.getRelatedCaseItemCount(caseRec.Id);
            String csvContent = 'column1,column2\nvalue1,value2';
            ACET_FAST_ExtractCaseItemsCtrl.attachCaseItem(csvContent, caseRec.Id);
            try {
                ACET_FAST_ExtractCaseItemsCtrl.getExcelFileAsBase64String(caseRec.Id);
            } catch (exception ex) {
                system.debug('error is ==>' + ex.getMessage());
            }
        }
    }
}