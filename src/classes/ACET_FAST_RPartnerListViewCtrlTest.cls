@isTest
public class ACET_FAST_RPartnerListViewCtrlTest {
    
     public static testMethod void inlineEditTestMethod(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        System.runAs(sysAdminUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;              
            
            Provider_Matrix__c pmRec = new Provider_Matrix__c();
            pmRec.Name = 'Test RP';
            pmRec.Resolution_Partner_SLA__c = 20;
            insert pmRec;
            
            PIR_Resolution_Partner__c rp = new PIR_Resolution_Partner__c();
            rp.Case__c = caseRec.id;
            rp.Provider_Matrix_Reactive__c = pmRec.Id;
            insert rp;
            
            List<PIR_Resolution_Partners_Reference__c> rpRefListToInsert = new List<PIR_Resolution_Partners_Reference__c>();
            
            PIR_Resolution_Partners_Reference__c rpRef1 = new PIR_Resolution_Partners_Reference__c();
            rpRef1.PIR_Resolution_Partner__c = rp.id;
            rpRef1.Reference__c = 'qwerty';
            rpRef1.Completed__c = false;
            rpRefListToInsert.add(rpRef1);
            
            PIR_Resolution_Partners_Reference__c rpRef2 = new PIR_Resolution_Partners_Reference__c();
            rpRef2.PIR_Resolution_Partner__c = rp.id;
            rpRef2.Reference__c = 'qwerty';
            rpRef2.Completed__c = false;
            rpRefListToInsert.add(rpRef2);
            
            insert rpRefListToInsert;
            
            ACET_FAST_RPartnerListViewCtrl.fWrapper fWrap = ACET_FAST_RPartnerListViewCtrl.getReferences(caseRec.Id);
           system.debug('Final Wrap-->'+fwrap);
            
        }

}
    
}