/*************************************************************************************************************
 * @name			ACET_FAST_CaseController_Test
 * @author			mrajen15 <muthukumarr@optum.com>
 * @created			08 / 11 / 2020
 * @description		Test Class for ACET_FAST_CaseController
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-11-08		mrajen15				Changes desription
 *
**************************************************************************************************************/
@isTest
public class ACET_FAST_CaseController_Test {
    public static testmethod void testAccountData(){
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
             
            insert caseRec;
        Account acc = new Account (name='Test', 
                                   Provider_Contact__c = 'Test Contact',
							       Provider_Contact_Email__c = 'test@123.com',
								   Provider_Contact_Phone__c ='1234567890',
								   Provider_Contact_Preference__c='Email');
        insert acc;
        caseRec.AccountId = acc.id;
        update caseRec;
        
        case fastCase = ACET_FAST_CaseController.getAccountRecord(caseRec.id);
        
        system.assertEquals('Email', fastCase.Account.Provider_Contact_Preference__c);
    }

}