@isTest
public class ACET_FAST_TeamMemberOpenTaskCaseTest {
     static final String PIR_PROFILE = 'Provider Issue Resolution';
     public static final String fastTaskRecordType = 'Reactive_Resolution_Proactive_Action';
     public static final String TASK_SUBJECT = 'Callback Needed';
    public static final String TASK_STATUS = 'Open';
    public static final String OPO_PIR = 'OPO PIR';
    @isTest
    public static void getOpenCases()
    {
        Profile fastUserProfile = ACET_Fast_TestDataFactory.getProfile(PIR_PROFILE);
        UserRole fastRole = ACET_Fast_TestDataFactory.getRole('PIR - Reactive/Proactive Supervisor');
        user pirfastuser = ACET_Fast_TestDataFactory.getUserRecordWithRole(fastUserProfile.id,fastRole.Id);
        insert pirfastuser;
        UserRole fastRole1 = ACET_Fast_TestDataFactory.getRole('PIR - Reactive Resolution');
        user fastUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(fastUserProfile.id,fastRole1.Id);
        fastUser.ManagerId= pirfastuser.id;
        fastUser.Username = 'TESTUSERANME@SFDC.COM';
        insert fastUser;
        System.runAS(fastUser)
        {
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            task tsk = ACET_Fast_TestDataFactory.getTaskRecord(fastTaskRecordType, caseRec.id,TASK_SUBJECT,system.today(),TASK_STATUS,'Standard'); 
            insert tsk;
        }
        System.runAs(pirfastuser)
        {
           
            ACET_FAST_TeamMemberOpentskCtrl.getRPRecords();
            ACET_FAST_TeamMemberOpentaskCtrl.getOpenTasks();
        }
    }
    
}