@isTest
public class ACETMilestoneUtils_Test{
    static testMethod void ACETMilestoneUtils_TestMethod(){
        Workorder wo = new Workorder();
        wo.status = 'new';
        insert wo;
        
        List<Id> woList = new List<Id>();
        woList.add(wo.id);
        
        
        ACETMilestoneUtils.completeMilestone(woList);
    }
}