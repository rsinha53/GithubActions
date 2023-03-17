/*
ACET_FAST_InteractionCtrl_Test
Testing Class Name:  ACET_FAST_InteractionCtrl
Author: Manohar Reddy
Date: 11/18/2020
Description: This is test class and used to get test coverage for ACET_FAST_InteractionCtrl. 
Initial: Manohar Reddy 
*/
@isTest
public class ACET_FAST_InteractionCtrl_Test {
    
    public static testMethod void fastCheck(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            
			
            //insert interaction record
            Interaction__c inter = new Interaction__c();
            inter.Interaction_Type__c = 'Email';
            insert inter;
            
            //inserting person account record
            Account acc = new Account();
            acc.RecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount');
            acc.LastName = 'Test';
            acc.EID__c = '001490295111111111';
            acc.Tax_Id__c= '111111111';
            acc.Par_Provider__c = 'Yes';
            acc.Provider_Contact__c = 'Test Name';
            acc.Provider_Contact_Email__c = 'test@test.com';
            acc.Provider_Contact_Phone__c = '1234567890';
            acc.Provider_Contact_Preference__c = 'Email';
            insert acc;
            
            string caseRecordType = 'Reactive Resolution';
            string caseRecordTypeDevName = 'Reactive_Resolution';
            ACET_FAST_InteractionCtrl.InteractionWrapper intWrap = ACET_FAST_InteractionCtrl.getInteractionWrapper(acc.id,inter.id, caseRecordType);
            intWrap.caseRec.RecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Case',caseRecordTypeDevName);
            intWrap.caseRec.subject = 'Test subject';
            intWrap.caseRec.description = 'Test Description';
            intWrap.caseRec.accountId= acc.Id;
            intWrap.caseRec.origin = 'Internal';
            intWrap.caseRec.Provider_Type__c='Physician';
            intWrap.selectedMarketList =new List<String>{'Alabama'};
            intWrap.caseRec.Topic__c='Balance Billing';
            string wrapStr = JSON.serialize(intWrap);
            intWrap.caseRec.Type__c='Central';
            intWrap.caseRec.Type__c='';
            intWrap.caseRec.PC_Internal_Contact_Name__c='Test Contact';
            intWrap.caseRec.PC_Internal_Contact_Phone__c='999999999';
            intWrap.caseRec.Submitting_Department__c='A.C.N.';
            intWrap.caseRec.Original_Received_Date__c= system.today();
            intWrap.caseRec.PC_Internal_Contact_Email__c='test@123.com';
            ACET_FAST_InteractionCtrl.finalSubmit(wrapStr);
        }
    }
}