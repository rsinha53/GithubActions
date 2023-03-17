/*****************************************************************************************************
ACET_FAST_ProviderMatrixDetailCtrlTest
Testing Class Name:  ACET_FAST_ProviderMatrixDetailCtrl
Author: Shaik Mohammad Yaseen
Date: 12/03/2021
Description: This is test class and used to get test coverage for ACET_FAST_ProviderMatrixDetailCtrl. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest
public class ACET_FAST_ProviderMatrixDetailCtrlTest {
    
    public static testMethod void pMatrixDetailTest(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
            Provider_Matrix__c pmatrix = new Provider_Matrix__c(name='test', LOB__c='C&S',Category__c='CPM', Sub_Category__c='CPM',CrossWalk_Case_RPI__c='test' );
            insert pmatrix;
            
            ACET_FAST_ProviderMatrixDetailCtrl.getCaseRPWrapper(pmatrix.Id,caseRec.id);
            
            Provider_Matrix__c pmRec = new Provider_Matrix__c();
            pmRec.Name = 'Test RP';
            pmRec.Resolution_Partner_SLA__c = 20;
            insert pmRec;
            
           	ACET_FAST_ProviderMatrixDetailCtrl.getResolutionPartnerId(pmRec.Name);
        }
    }
}