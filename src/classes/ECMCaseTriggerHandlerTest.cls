@isTest
private class ECMCaseTriggerHandlerTest {

    @testsetup 
    static void createTestQueues(){
        //create Test queue  
        Group  testQueue1 = new Group(Type = 'Queue' , Name= 'ECMTestQueue1');
        Group  testQueue2 = new Group(Type = 'Queue' , Name= 'ECMTestQueue2');
        insert new list<Group>{testQueue1,testQueue2};
        
        QueuesObject q1 = new QueueSObject(QueueID = testQueue1.id, SobjectType = 'Case');
        QueuesObject q2 = new QueueSObject(QueueID = testQueue2.id, SobjectType = 'Case');
        insert new list<QueuesObject>{q1,q2};
        
        MilestoneType mt = new MilestoneType(name='Test milestone', description='description');       
        insert mt;

    }
    
    static testMethod void TestCompleteMilestoneCase(){
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
        
        Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue1' limit 1].queue.id;
        List<Case> cases = new List<Case>{};
        if (entlId != null){
            Case c = new Case(Subject = 'Test Case with Entitlement ',
            EntitlementId = entlId);
            c.Topic__c = 'Other Inquiry';
            cases.add(c);
        }
        Case cas = new Case(Subject = 'Test Case with Entitlement ');
        cas.Topic__c = 'Other Inquiry';       
        cas.ownerid = queueId;
        cas.Priority_Routing__c= 'No';
        cases.add(cas);
        if (cases.isEmpty()==false){
            insert cases;
            List<Id> caseIds = new List<Id>();
            for (Case cL : cases){
                caseIds.add(cL.Id);
            
          }
           List<case> casestoUpdate = [Select id, slaStartDate , slaExitDate,status  From case Limit 1];
           if(casestoUpdate.isEmpty() == False){
               Case casetoClose = new Case ();
               casetoClose=casestoUpdate[0];
               casetoClose.slaStartDate = system.now().addHours(-13);
           
               casetoClose.status= 'Closed';
          
             update casetoClose;
           }
            for(case c1 : cases){
                c1.Priority_Routing__c = 'Yes';
            }
            update cases;
        }
        
                
    }
        
    static testMethod void TestMilestonePerformance(){
        try{
            List<Account> acts = new List<Account>();
            Account busAcc= new Account(Name='UHG', phone='1001290986');
            acts.add(busAcc);
            insert acts;
            
            Contact con = new contact(lastName= 'Test con',accountId=busAcc.id);
            insert con;
            Entitlement entl = new Entitlement(Name='TestEntitlement', AccountId=busAcc.Id);
            insert entl;
            String entlId;
            if (entl != null){
                entlId = entl.Id;
            }
            
            Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue1' limit 1].queue.id;
            List<Case> cases = new List<Case>{};
                if (entlId != null){
                    Case c = new Case(Subject = 'Test Case with Entitlement ',
                                      EntitlementId = entlId,ownerid = queueId);
                    c.Topic__c = 'Other Inquiry';
                    cases.add(c);
                }
            Case cas = new Case(Subject = 'Test Case with Entitlement ');
            cas.Topic__c = 'Other Inquiry';        
            cas.ownerid = queueId;
            cas.Priority_Routing__c= 'No';
            cases.add(cas);
            insert cases;  
            for(case c1 : cases){
                c1.Priority_Routing__c = 'Yes';
                c1.OwnerId=userInfo.getUserId();
                c1.Milestone_Updated__c = 'Yes';
            }
            update cases;
            
            for(case c1 : cases){
                c1.status = 'Closed';
            }
            RecursiveTriggerHandler.isFirstTime = false;
            update cases;
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }        
    }

    static testMethod void TestOwnerChange(){
        Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  limit 1].queue.id;
        List<Case> cases = new List<Case>{};
        for(integer i=0;i<10;i++){
            Case c = new Case(Subject = 'Test Case',ownerid = userInfo.getUserId());
            c.Topic__c = 'Other Inquiry';
            c.Priority_Routing__c = 'No';
            cases.add(c);
        }
        insert cases;
        for(case c1 : cases){
            c1.OwnerId=queueID;
            c1.Milestone_Updated__c = 'Yes';
        }
        try{
            update cases;
        }catch(exception ex){
            
        }
    }
    
    static testmethod void testTypeSubtye(){
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'View Authorizations';
        cas.Type__c = 'eviCore Issues';
        insert cas;
        
        list<Case_item__c> caseItemList = new list<Case_Item__c>();
        for(integer i=0;i<10;i++){
            caseItemList.add(new Case_Item__c(Case__c= cas.id,resolved__c=false));
        }
        insert caseItemList;
        
        
        cas.Type__c = 'Additional Information Needed';
        cas.subType__C = 'Provider Outreach';
        RecursiveTriggerHandler.isFirstTime = false;
        update cas;
        
    }
    
     public static testMethod void onshoreRestriction(){
        
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'View Authorizations';
        cas.Type__c = 'eviCore Issues';
        insert cas;
        
        
        insert (new Case_Item__c(Case__c= cas.id,resolved__c=false));
        
        Queue_Config__mdt queueConfig =  [select id, MasterLabel,Queue_Type__c from Queue_Config__mdt where Queue_Type__c = 'All' And MasterLabel = 'Billing' limit 1 ];
        Group gp = [select id from Group where Group.Name =:queueConfig.MasterLabel and Group.Type = 'Queue' limit 1];
        test.startTest();
        cas.OwnerId = gp.id;
        try{
            update cas;
        }catch(exception ex){
           // system.assert(ex.getMessage().contains('This is a globally restricted group. You are not able to change owner to this queue'));
        }
        test.stopTest();
        
    }
    
    static testMethod void testHandleOwnerChnageRestriction(){
        try{
            Group grp = new Group(Type = 'Queue', Name = 'ECMTestQueue1'); 
            insert grp;
            Map<Id, Case> oldCaseMap = new Map<Id, Case>();
            List<Case> newCaseList = new List<Case>();
            Case oldCase = new Case(Onshore_Restriction__c = 'Yes');
            insert oldCase;
            oldCaseMap.put(oldCase.Id, oldCase);
            Case_Item__c csItem = new Case_Item__c(Case__c = oldCase.Id, resolved__c = false);
            insert csItem;
            Case newCase = new Case(Id = oldCase.Id, OwnerId = grp.Id);
            update newCase;
            newCaseList.add(newCase);	
            
            Test.startTest();
            ECMCaseTriggerHandler.HandleOwnerChnageRestriction(newCaseList, oldCaseMap);
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }           
    }
    
    static testMethod void testDeleteFilesOnCaseDeletion(){
        try{
            Map<Id, Case> csMap = new Map<Id, Case>();
            Case cs = new Case();
            insert cs;
            csMap.put(cs.Id, cs);
            
            ContentVersion conVerInsert = new ContentVersion(Title = 'Test', PathOnClient = 'Test.jpg', VersionData = Blob.valueOf('Test Content Data'), IsMajorVersion = true);
            insert conVerInsert;
            ContentVersion conVerSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVerInsert.Id LIMIT 1];
            ContentDocumentLink cncDocLink = new ContentDocumentLink(LinkedEntityId = cs.Id, ContentDocumentId = conVerSelect.ContentDocumentId);
            insert cncDocLink;
            
            Test.startTest();
            ECMCaseTriggerHandler.deleteFilesOnCaseDeletion(csMap);
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }
    }
    
    static testMethod void testAutoCompleteMilestoneWorking(){
        
        try{
            List<MilestoneType> milestoneIdList = [SELECT Id FROM MilestoneType WHERE Name = 'Move to Working'];
            List<RecordType> motionRecList = [SELECT Id FROM RecordType WHERE Name = 'Motion'];
            
            Case entlCase = new Case(RecordTypeId = motionRecList[0].Id, Origin = 'Phone Call', Status = 'New', Topic__c = 'Motion Inquiry', Type__c = 'Apple', Subtype__c = 'Alternate Activity', SlaStartDate=System.now().addMinutes(-30));
            insert entlCase;
            
            Test.startTest();
            Case workingEntlCase = makeWorkingCase(entlCase.Id);
            List<CaseMilestone> csMilestoneList = [SELECT IsCompleted FROM CaseMilestone WHERE CaseId =: workingEntlCase.Id AND MilestoneTypeId =: milestoneIdList[0].Id];
            Boolean isMilestoneCompleted = csMilestoneList[0].IsCompleted;
            System.assertEquals(true, isMilestoneCompleted);        
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }
    }
    
    static testMethod void testAutoCompleteMilestoneClosed(){
        
        try{
            List<MilestoneType> milestoneIdList = [SELECT Id FROM MilestoneType WHERE Name = 'Move to Working'];
            List<RecordType> motionRecList = [SELECT Id FROM RecordType WHERE Name = 'Motion'];
            
            Case entlCase = new Case(RecordTypeId = motionRecList[0].Id, Origin = 'Phone Call', Status = 'New', Topic__c = 'Motion Inquiry', Type__c = 'Apple', Subtype__c = 'Alternate Activity', SlaStartDate=System.now().addMinutes(-30));
            insert entlCase;
            
            Test.startTest();
            Case closedEntlCase = makeClosedCase(entlCase.Id);
            List<CaseMilestone> csMilestoneList = [SELECT IsCompleted FROM CaseMilestone WHERE CaseId =: closedEntlCase.Id AND MilestoneTypeId =: milestoneIdList[0].Id];
            Boolean isMilestoneCompleted = csMilestoneList[0].IsCompleted;
            System.assertEquals(true, isMilestoneCompleted);        
            Test.stopTest();	
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }
    }
    
    static Case makeWorkingCase(Id caseId) {
        Case closedCase = new Case(Id = caseId, Status = 'Working');        
        update closedCase;
        return closedCase;
    }
    
    static Case makeClosedCase(Id caseId) {
        Case closedCase = new Case(Id = caseId, Status = 'Closed');        
        update closedCase;
        return closedCase;
    }
}