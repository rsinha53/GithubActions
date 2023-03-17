/****************************************************************************** 
Class Name     : SNI_FL_CaseManagementController.apxc
Description    : 
Created By     : Sameera De Silva - ACDC
Created Date   : 11/6/2020
******************************************************************************/

@isTest
public class SNI_FL_CaseManagementUtilTest {

    @isTest
    static void checkWrapperObjectTest2(){

        SNI_FL_CaseManagementUtilTestDataFactory.checkWrapperObjectTest2Data();

        Account familyAccount = [SELECT Id FROM Account WHERE EID__c='!123abc_ACDC'];
        Test.startTest();
        User member1 = [SELECT Id, AccountId, ContactId FROM User WHERE UserName='test_uer_second@optum.acet.com'];
 
        List<SNI_FL_CaseManagementController.CaseObjectWrapper> lstData = SNI_FL_CaseManagementUtil.getListOfCases(member1.id,FamilyAccount.id);
        List<SNI_FL_CaseManagementController.CaseCommentWrapper> lstCaseComments = lstData[0].caseComments;
        system.debug('lstData+  '+lstData);
        Integer size = lstCaseComments.size();
        System.assertNotEquals(0,size,'Empty comment test failed');

        Test.stopTest();

    }
    


    @isTest
    static void roiExceptionCheckTest3(){

        SNI_FL_CaseManagementUtilTestDataFactory.checkWrapperObjectTest2Data();
        User member1 = [SELECT Id FROM User WHERE UserName='test_uer_second@optum.acet.com'];
        
        Test.startTest();
            List<SNI_FL_Members_ROI__c> lstROI = SNI_FL_CaseManagementROIController.getActiveROIRecords(member1, '123');
        Test.stopTest();

        System.assertEquals(null, lstROI);
    }

    @isTest
    static void getCasesWithROISignedCasesExceptionTest4(){
        Test.startTest();
        List<SNI_FL_CaseManagementController.CaseObjectWrapper> lstData = SNI_FL_CaseManagementUtil.getListOfCases('a','123');
        Test.stopTest();

        System.assertEquals(null,lstData);
    }
   

}