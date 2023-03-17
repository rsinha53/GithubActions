@isTest
private class ECMMilestoneUtilsTest {
    
    static testMethod void testMileStoneUpdate(){
    	
    	List<Account> acts = new List<Account>();
        Account busAcc= new Account(Name='UHG', phone='1001290986');
        acts.add(busAcc);
        insert acts;
        
        
        Entitlement entl = new Entitlement(Name='TestEntitlement', AccountId=busAcc.Id);
        insert entl;
        String entlId;
        if (entl != null){
            entlId = entl.Id;
        }
    	List<SlaProcess> lstEntitlementProcess = [SELECT Id, Name FROM SlaProcess  LIMIT 1];
	    if (lstEntitlementProcess.size()>0)
	    {
	        entl.SlaProcessId = lstEntitlementProcess[0].id;
	        update entl;        
	    }
    	
    	
		List<Case> caseLst = new list<Case>();
		caseLst.addAll(ECMTestDataUtil.createCase('Open',userInfo.getUserId(),2, false));
		for(Case c : caseLst){
         	c.EntitlementId = entlId;
        }
        insert caseLst;
        for(Case c : caseLst){
         	c.slaStartDate = system.now();
        }
        update caseLst;
        list<id> caseIds = new list<id>();
        for(Case c : caseLst){
        	caseIds.add(c.id);
        }
        dateTime complDate = system.now();
        ECMMilestoneutils.completeMilestone(caseIds, complDate);
        
    }
}