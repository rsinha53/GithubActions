/*************************************************************************************************************
* @name			ACET_FAST_AlertsCtrl_Test
* @author			mrajen15 <muthukumarr@optum.com>
* @created			08 / 11 / 2020
* @description		Test Class for ACET_FAST_AlertsCtrl
*
* Changes (version)
* -----------------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	----------------------------------------------
* @version		1.0		2020-11-08		mrajen15				Changes desription
*
**************************************************************************************************************/
@isTest
public class ACET_FAST_AlertsCtrl_Test {
    public static testmethod void testAccountData(){
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        
        case fastCase = ACET_FAST_AlertsCtrl.getCaseRecord(caseRec.id);
        system.assertEquals(caseRec.id, fastCase.id);
        
    }
    
}