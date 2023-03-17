/*************************************************************************************************************
 * @name      ACET_FAST_HomePage_RPCtrlTest
 * @author      kvalakon <karthik@optum.com>
 * @created      11 / 09 / 2020
 * @description    Test class for ACET_FAST_HomePage_RPCtrl.
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 *         No.    Date              Author          Description
 *         ----  ------------  --------------------  ----------------------------------------------
 * @version    1.0    2020-09-11    kvalakon        Initial
 *
**************************************************************************************************************/
@isTest
public class ACET_FAST_HomePage_RPCtrlTest {
    @testSetup
    public static void testData()
    {
       
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        PIR_Resolution_Partner__c rpRec = ACET_Fast_TestDataFactory.getPIRRPRec(caseRec.id);
        rpRec.Resolution_Partner_Outcome__c = 'Open';
        insert rpRec;
       
        case caseRec1 = ACET_Fast_TestDataFactory.getCaseRecord('Proactive_Action','Open');
        insert caseRec1;
        PIR_Resolution_Partner__c rpRec1 = ACET_Fast_TestDataFactory.getPIRRPRec(caseRec1.id);
        rpRec1.Resolution_Partner_Outcome__c = 'Open';
        insert rpRec1;
    }
	
    static testMethod void getData(){
        testData();
         
        ACET_FAST_HomePage_RPCtrl.resolutionData();
        ACET_FAST_HomePage_RPCtrl.getProactiveRPRec();
        ACET_FAST_HomePage_RPCtrl.getUserDetails();
    }
}