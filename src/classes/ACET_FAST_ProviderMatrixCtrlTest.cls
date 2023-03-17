/*****************************************************************************************************
ACET_FAST_ProviderMatrixCtrlTest
Testing Class Name:  ACET_FAST_ProviderMatrixCtrl
Author: Shaik Mohammad Yaseen
Date: 26/02/2021
Description: This is test class and used to get test coverage for ACET_FAST_ProviderMatrixCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest
public without sharing class ACET_FAST_ProviderMatrixCtrlTest {
    
    public static testMethod void fastCheck(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            Provider_Matrix__c pmatrix = new Provider_Matrix__c(name='test', LOB__c='C&S',Category__c='CPM', Sub_Category__c='CPM',CrossWalk_Case_RPI__c='test' );
            insert pmatrix;
            ACET_FAST_ProviderMatrixCtrl.getLobValues(caseRec.id);
            ACET_FAST_ProviderMatrixCtrl.getCategoryValues('C&S');
            ACET_FAST_ProviderMatrixCtrl.getSubCategoryValues('CPM');
            ACET_FAST_ProviderMatrixCtrl.getProverMatrixRecs('', '','', 'test',true );
            ACET_FAST_ProviderMatrixCtrl.getProverMatrixRecs('C&S', 'CPM','CPM', 'test',true );
            ACET_FAST_ProviderMatrixCtrl.getRPId(pmatrix.id);
        }
    }
}