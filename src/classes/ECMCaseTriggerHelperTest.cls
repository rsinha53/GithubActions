@isTest
private class ECMCaseTriggerHelperTest {

    private static User u ;

    static void prepareData(){
        Profile p = [select id from Profile where name ='System Administrator'];
        u = new User(Alias = 'standt', Email='standarduser@ecm.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@ecm.com');
        insert u;

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

    static testMethod void TestOwnerChange(){
        prepareData();
		//User usr = [SELECT Id From User LIMIT 1];
        Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  limit 1].queue.id;
        RecordType rType = [Select Id, Name From RecordType Where sObjectType='Task' AND name='SAE Provider'];
        u = [select id from User where id = :u.id limit 1];//!=:userInfo.getUserId() limit 1];
        List<Case> cases = new List<Case>{};
        	system.runAs(u){
                for(integer i=0;i<5;i++){
                    Case c = new Case(Subject = 'Test Case',ownerid = userInfo.getUserId());
                    c.Topic__c = 'Other';
                    c.Priority_Routing__c = 'No';
                    cases.add(c);
            	}
            insert cases;
    
            list<Case_Item__c> caseItemList = new list<Case_Item__c>();
            for(case c1 : cases){
                caseItemList.add(new Case_Item__c(Resolved__c= false,   Case__c = c1.id));
            }
            insert caseItemList;
    
            list<Task> tskList = new list<Task>();
            for(case c1 : cases){
                Task tsk = new Task();
                tsk.Type = 'Email';
                tsk.Description = 'Description';
                tsk.OwnerId = userInfo.getUserId();
                tsk.WhatId = c1.id;
                tsk.RetainOwnership__c = false;
                tsk.status ='In progress';
                tsk.subject='Email Response';
                tsk.RecordTypeId = rType.Id;
              // tsk.ActivityDate='2017-08-15';
                tskList.add(tsk);
            }
            tsklist[0].RetainOwnership__c = true;
           insert tskList;
    
    
            for(case c1 : cases){
                c1.OwnerId=u.id;
                c1.Milestone_Updated__c = 'Yes';
            }
            try{
                update cases;
            }catch(exception ex){
    
            }
    
            for(Task t : [select id,OwnerId from Task  where RetainOwnership__c = false]){
                system.assert(t.OwnerId == u.id);
            }
    
            for(Task t : [select id,OwnerId from Task  where RetainOwnership__c = true]){
                system.assert(t.OwnerId == userInfo.getUserId());
            }
    
            for(case c1 : cases){
                c1.OwnerId=queueID;
                c1.Milestone_Updated__c = 'Yes';
            }
            try{
                update cases;
            }catch(exception ex){
    
            }
        }
    }
    
    static testmethod void testAutoClosedParentCase() {
        try{
            // Test data setup
            List<RecordType> motionRecList =  [SELECT Id FROM RecordType WHERE Name = 'Motion'];
            Group queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Motion System'];
            
            Case cs = new Case(RecordTypeId = motionRecList[0].Id, Status = 'Working', OwnerId = queueId.Id, Topic__c = 'Motion Inquiry', Type__c = 'Apple', Subtype__c = 'Alternate Activity');
            insert cs; 
            
            Case childCase = new Case(RecordTypeId = motionRecList[0].Id, Status = 'New', ParentId = cs.Id, Topic__c = 'Motion Inquiry', Type__c = 'Apple', Subtype__c = 'Alternate Activity');
            insert childCase;
            
            Case parentCase = [SELECT Id FROM case WHERE Id =: cs.Id];
            
            // Perform test
            Test.startTest();       
            Case updatedParentCase = makeClosedChildCase(parentCase.Id);
            System.debug('Updated Parent Case: '+updatedParentCase.Id+' && '+updatedParentCase.Status);
            //System.assertEquals('Closed', updatedParentCase.Status);       
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }
	}
    
    static Case makeClosedChildCase(Id prntCaseId) {		
		Case childCase = [SELECT Id FROM Case WHERE ParentId =: prntCaseId];
        Case closedChildCase = new Case(Id = childCase.Id, Status = 'Closed');
        update closedChildCase;
        
        Case updatedParentCase = [SELECT Id, Status FROM Case WHERE Id =: prntCaseId];
        return updatedParentCase;
	}
    
    static testmethod void testPreventClosedParentCase() {
        try{
            // Test data setup
            List<RecordType> motionRecList =  [SELECT Id FROM RecordType WHERE Name = 'Motion'];
            
            Case cs = new Case(RecordTypeId = motionRecList[0].Id, Status = 'Working', Topic__c = 'Motion Inquiry', Type__c = 'Apple', Subtype__c = 'Alternate Activity');
            insert cs; 
            
            Case childCase = new Case(RecordTypeId = motionRecList[0].Id, Status = 'New', ParentId = cs.Id, Topic__c = 'Motion Inquiry', Type__c = 'Apple', Subtype__c = 'Alternate Activity');
            insert childCase;
            Case parentCase = [SELECT Id FROM case WHERE Id =: cs.Id];
            
            // Perform test
            Test.startTest();       
            Case updatedParentCase = makeClosedParentCase(parentCase.Id);
            System.debug('Updated Parent Case: '+updatedParentCase.Id+' && '+updatedParentCase.Status);
            System.assertEquals(parentCase.Status, updatedParentCase.Status);       
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug('Error: '+ex.getMessage());
        }
	}
    
    static Case makeClosedParentCase(Id prntCaseId) {		
        Case closedParentCase = new Case(Id = prntCaseId, Status = 'Closed');
        update closedParentCase;
        
        Case updatedParentCase = [SELECT Id, Status FROM Case WHERE Id =: prntCaseId];
        return updatedParentCase;
	}

}