@isTest(SeeAllData=false)
public class ACET_FAST_ReopenNotificationCtrl_Test {  
    
    public static testMethod void method1(){
                case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        
        PIR_Detail__c pirRec = ACET_Fast_TestDataFactory.getPIRRec(caseRec.id);
        insert pirRec;
        
        ACET_FAST_ReopenNotificationController reOpenCase = new ACET_FAST_ReopenNotificationController();
        reOpenCase.caseId = caseRec.id;
    }

}