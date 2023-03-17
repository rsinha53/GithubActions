@isTest
public class ACET_FAST_PIP_ReOpenCaseCtrlTest {
	
    static testMethod void insertRecords(){
        insert new ACET_FAST_ManageReOpenCase__c(Do_Not_Allow_ReOpen__c = true);
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Closed');
        insert caseRec;
        caseRec.Status = 'Reopen';
        update caseRec;
		
        ACET_FAST_PIP_ReOpenCaseCtrl.getValiduser(caseRec.id);
         PIR_Detail__c rpRec = ACET_Fast_TestDataFactory.getPIRRec(caseRec.id);
         insert rpRec;
        
        ACET_FAST_PIP_ReOpenCaseCtrl.getUserDetails();
        ACET_FAST_PIP_ReOpenCaseCtrl.getPIRRecId(caseRec.Id);
        ACET_FAST_PIP_ReOpenCaseCtrl.updateCaseRecord(caseRec.Id);
        ACET_FAST_PIP_ReOpenCaseCtrl.updatePIR(caseRec.Id);
        
    }
}