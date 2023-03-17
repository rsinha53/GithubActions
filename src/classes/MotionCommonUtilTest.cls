@isTest
public class MotionCommonUtilTest {
    
    static testMethod void  MotionCommonUtilTest1(){
        MotionCommonUtil.displayDateTimeFormat('2020-12-30T14:20:46.000Z');
        MotionCommonUtil.strDateFormat('1-1-2021');
        MotionCommonUtil.convertToDateFormat('2020-12-30T14:20:46.000Z');
        MotionCommonUtil.changeDateWithHypen('1/1/2021');
        MotionCommonUtil.changeDateWithHypen('10/10/2021');
        MotionCommonUtil.returnDateFormat('2021-1-1');
        MotionCommonUtil.heightConversion('5');
        MotionCommonUtil.heightConversion('60');
        MotionCommonUtil.heightConvInFeetAndInch('6');
        MotionCommonUtil.heightConvInFeetAndInch('65');
        MotionCommonUtil.weightConversion('0');
        MotionCommonUtil.weightConversion('50');
        MotionCommonUtil.Dateconversion('2021-01-04');
        MotionCommonUtil.dollerconvertion('25');
        MotionCommonUtil.dollerconvertion('$5');
        MotionCommonUtil.validEmailconversion('abbott@optum.com');
        MotionCommonUtil.GetOrgName();
		MotionCommonUtil.GetSSNFormat('123456789');
        MotionCommonUtil.GetSSNFormat('12454878');
		MotionCommonUtil.GetSSNFormat('abbottopt');										   
    } 
    
    static testMethod void TestCompleteMilestoneCase(){
        
        List<Account> acts = new List<Account>();
        
        Account myAcc = new Account(Name='TestAct', phone='1001231234');
        acts.add(myAcc);
        insert acts;
        
        Contact cont = new Contact(FirstName = 'TestFirstName', LastName = 'TestLastName', phone='4567890999', accountid = myAcc.Id);
        insert(cont);
        
        Id contactId = cont.Id;
        
        Entitlement entl = new Entitlement(Name='TestEntitlement', AccountId=myAcc.Id);
        insert entl;
        
        String entlId;
        if (entl != null)
            entlId = entl.Id; 
        
        List<Case> cases = new List<Case>();
        if (entlId != null){
        	Case c = new Case(Subject = 'Test Case with Entitlement ', EntitlementId = entlId, ContactId = contactId);
            cases.add(c);
        }
        
        //List<CaseMilestone> CaseMilestones = new List<CaseMilestone>();
        //MilestoneType mt = new MilestoneType(Name = 'Test Milestone Name');
        //String caseMilestoneId = mt.Id;
        
        if (cases.isEmpty()==false){
            insert cases;
            List<Id> caseIds = new List<Id>();
            for (Case cL : cases){
                caseIds.add(cL.Id);               
                //CaseMilestone cm = new CaseMilestone(CaseId = cL.Id, MilestoneTypeId = caseMilestoneId);
                //CaseMilestones.add(cm);
            }
            set<string> milestonestrings = new set<string>{'Test Milestone Name'};
            MotionCommonUtil.completeMilestone(caseIds,milestonestrings , System.now());
        }
    }
    
    static testMethod void testCompleteMilestoneViaCase(){
        
        List<Account> acts = new List<Account>();
        Account myAcc = new Account(Name='TestAct', phone='1001231234');
        acts.add(myAcc);
        insert acts;
        
        Contact cont = new Contact(FirstName = 'Test', LastName = 'LastName', phone='4567890999', accountid = myAcc.id);
        insert(cont);
        
        Id contactId = cont.Id;
        
        Entitlement entl = new Entitlement(Name='TestEntitlement', AccountId=myAcc.Id);
        insert entl;
        
        String entlId;
        if (entl != null)
            entlId = entl.Id; 
        
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < 1; i++){
            Case c = new Case(Subject = 'Test Case ' + i);
            cases.add(c);
            if (entlId != null){
                c = new Case(Subject = 'Test Case with Entitlement ' + i, EntitlementId = entlId);
                cases.add(c);
            }
        }
    }
}