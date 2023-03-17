@isTest
public class ACET_FAST_ReferenceNumberTriggerTest {
    
    public static testMethod void testWithFastUser(){
        Profile sysAdminPrf = ACET_Fast_TestDataFactory.getSysAdminPrf();
        user sysAdminUser = ACET_Fast_TestDataFactory.getUserRecord(sysAdminPrf.id);
        insert sysAdminUser;
        system.runAs(sysAdminUser){
     		case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
            PIR_Resolution_Partner__c rPRecord =ACET_Fast_TestDataFactory.getPIRRPRec(caseRec.id);
            insert rPRecord;
            
            Case_Item__c casItem=new Case_Item__c (Case__c	=caseRec.id);
            insert casItem;
            PIR_Resolution_Partners_Reference__c casRPR=new PIR_Resolution_Partners_Reference__c(Case_Item__c=casItem.id,
                                                                                                 PIR_Resolution_Partner__c=rPRecord.id,
                                                                                                 Reference__c='1234');
            casRPR.SLA_Routed_Date__c = system.today();
            insert casRPR;
            PIR_Resolution_Partners_Reference__c casRPR1=new PIR_Resolution_Partners_Reference__c(Case_Item__c=casItem.id,
                                                                                                  PIR_Resolution_Partner__c=rPRecord.id,
                                                                                                  Reference__c='12324');
            casRPR1.SLA_Routed_Date__c = system.today() - 20;
            insert casRPR1;
            
            casRPR1.SLA_Routed_Date__c = system.today() - 40;
            update casRPR1;
        }
   
    }
    
}