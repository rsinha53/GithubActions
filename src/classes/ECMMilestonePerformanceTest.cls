@isTest(seeAllData=true)
private class ECMMilestonePerformanceTest {
    
    static testMethod void testOwnershipChange_1(){
        Account a1 = new Account(Name='My Account');
        insert a1;
        Entitlement entl = new Entitlement(Name='Testing',AccountId=a1.Id, StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        insert entl;
        //Entitlement entl = [select id from Entitlement limit 1];
        Contact oContact = [select id from Contact limit 1];
        test.startTest();
        Case c = new Case(Subject = 'Test Case with Entitlement ', EntitlementId = entl.Id, ContactId = oContact.id);
        insert c;
        Case_Item__c ci =new Case_Item__c(resolved__C=false,Case__c= c.id);
        insert ci;
                
        Id queueId = [Select Id, Name From Group where Name = 'Accounts Payable/Payment Inquiry' LIMIT 1].Id;
        
        c.ownerId =queueId;
        update c;
        test.stopTest();
    
    }
    
    
    static testMethod void testOwnershipChange_2(){
        set<id> caseIds = new set<id>();
        
        for(CaseHistory ch: [select id, oldValue,createdDate,caseId, Case.Status,case.Target_Date__c,case.CreatedDate,case.createdById from CaseHistory where field='Owner' limit 1000]){
            caseIds.add(ch.caseId);
        }
        
        caseMilestone cm = new caseMileStone();
        for(caseMileStone c : [select id, caseId from caseMilestone where isCompleted=false and case.ownerId != :userInfo.getUserId()  and caseId in:caseIds]){
            cm = c;
            break;
        } 
        if(cm.caseId != null){
            caseIds.add(cm.caseID);
            case_Item__c ci = new Case_Item__c(case__c = cm.caseId, resolved__c = false);
            insert ci;
            case cs = new case(id=cm.caseId, ownerId = userInfo.getuserId());
            update cs;
            test.startTest();
                ECMMilestonePerformance.createOwnerShipChanges(caseIds);
            test.stopTest();
        }
        
    }
    
    static testMethod void closeCaseTest(){
        set<id> caseIds = new set<id>();
        
        for(CaseHistory ch: [select id, oldValue,createdDate,caseId, Case.Status,case.Target_Date__c,case.CreatedDate,case.createdById from CaseHistory where field='Owner' limit 1000]){
            caseIds.add(ch.caseId);
        }
        
        caseMilestone cm = new caseMileStone();
        for(caseMileStone c : [select id, caseId from caseMilestone where isCompleted=false and case.ownerId != :userInfo.getUserId()  and caseId in:caseIds]){
            cm = c;
            break;
        } 
        if(cm.caseId != null){
            caseIds.add(cm.caseID);
            case_Item__c ci = new Case_Item__c(case__c = cm.caseId, resolved__c = false);
            insert ci;
            case cs = new case(id=cm.caseId, ownerId = userInfo.getuserId());
            update cs;
            test.startTest();
                list<case_Item__c> ciLst = new list<case_Item__c>([select id from case_Item__c where case__c=:cs.id]);
                for(case_Item__c cItem :ciLst){
                    cItem.resolved__c = true;
                    cItem.Resolved_Reason__c ='Resolved';
                }
                
                //cs.Status = 'Closed';
            //update cs;
                update cs;
            test.stopTest();
        }
        
    }
    
    static testMethod void closeMilestone(){
        set<id> caseIds = new set<id>();
        
        for(CaseHistory ch: [select id, oldValue,createdDate,caseId, Case.Status,case.Target_Date__c,case.CreatedDate,case.createdById from CaseHistory where field='Owner' limit 1000]){
            caseIds.add(ch.caseId);
        }
        
        caseMilestone cm = new caseMileStone();
        for(caseMileStone c : [select id, caseId from caseMilestone where isCompleted=false and case.ownerId != :userInfo.getUserId()  and caseId in:caseIds]){
            cm = c;
            break;
        } 
        if(cm.caseId != null){
            caseIds.add(cm.caseID);
            case_Item__c ci = new Case_Item__c(case__c = cm.caseId, resolved__c = false);
            insert ci;
            case cs = new case(id=cm.caseId, ownerId = userInfo.getuserId());
            update cs;
            test.startTest();
                try{
                    list<case> caseList = new list<case>{cs};
                    
                    cm.completionDate = system.now();
                    update cm;
                  
                    ECMMilestonePerformance.calcInitialTargetDateFuture(new list<id>{cs.id});
                }catch(exception ex){
                    
                }
            test.stopTest();
        }
        
    }
}