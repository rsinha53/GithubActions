global class SNI_FECGraduationBatch implements Database.Batchable<sObject>, Database.Stateful {
    public List<String> caseStatuses = new List<String>{'Open','Waiting'};
    public List<String> proactiveAlertStatuses = new List<String>{'New','Assigned'};
    public List<String> taskStatuses = new List<String>{'Not Started','In Progress'};
    global List<Id> famOverIdListToUpdate = new List<Id>();
    public Map<String, Integer> activitiesMap = new Map<String,Integer>();
    public User[] unassignedUser;
    //make map of activity count by family account level
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Fo_validations__c obj = fo_validations__c.getOrgDefaults();
        obj.Is_Automation__c = true;
        upsert obj;
        //INFO: querying all family overview records
        return Database.getQueryLocator('SELECT Id, Family_Status__c, Last_Active_Date__c, Account__r.Id, Exception__c, Designation__c, Designation_Changed_Date__c,EHub_Update_Check__c FROM Family_Overview__c');
    }
    global void execute(Database.BatchableContext bc, List<Family_Overview__c> records){
    	unassignedUser = [select id from User where Name ='Unassigned'];
        //INFO: creating map of all Family Overviews and their record ids
        Map<Id, Family_Overview__c> familyOverviewIds = new Map<Id, Family_Overview__c>();
        Map<Id, Family_Overview__c> familyOverviewIdsMasterList = new Map<Id, Family_Overview__c>();
        for(Family_Overview__c fo : records){
            familyOverviewIds.put(fo.Account__r.Id,fo);
        }
        familyOverviewIdsMasterList = new Map<Id, Family_Overview__c>(familyOverviewIds);
        //INFO: querying all ACRS for Family Overviews
        List<AccountContactRelation> acrList = [SELECT ContactId, Contact.AccountId, AccountId FROM AccountContactRelation WHERE AccountId IN :familyOverviewIds.keySet()];
        //INFO: mapping person contact ids to family account ids
        Map<Id, Set<Id>> famAcctMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> acrIdList = new Map<Id, Set<Id>>();
        for(AccountContactRelation acr: acrList){
            if(acrIdList.containsKey(acr.Contact.AccountId)){
                acrIdList.get(acr.Contact.AccountId).add(acr.AccountId);
            } else {
                Set<Id> accSet = new Set<Id>();
                accSet.add(acr.AccountId);
                acrIdList.put(acr.Contact.AccountId, accSet);
            }
            if(famAcctMap.containsKey(acr.AccountId)){
                famAcctMap.get(acr.AccountId).add(acr.Contact.AccountId);
            } else {
                Set<Id> accSet = new Set<Id>();
                accSet.add(acr.Contact.AccountId);
                famAcctMap.put(acr.AccountId, accSet);
            }
        }
        //INFO: querying list of all person account ids for ACRs
        List<Family_Overview__c> familyOverviewsToUpdate = new List<Family_Overview__c>();
        Set<Id> familyOverviewIdsAlreadyToBeUpdatedToActive = new Set<Id>();
        //INFO: querying all open cases, proactive alerts and tasks, and messages in the last 30 days
        Set<Id> allAcctIdList = new Set<Id>(acrIdList.keySet());
        allAcctIdList.addAll(familyOverviewIds.keySet());
     	Set<Id> acctIdsWithOpenItems = getOpenItemsIdSet(allAcctIdList,famAcctMap,acrIdList);
        for(Id acct: acctIdsWithOpenItems){
            //INFO: get the family overview for the current person account
            for(Id acctId: acrIdList.get(acct)){
                Family_Overview__c fo = familyOverviewIds.get(acctId); 
            //INFO: check if the family has already been determined to be active due to another person account, if so skip logic below
            if(fo != null && !familyOverviewIdsAlreadyToBeUpdatedToActive.contains(fo.id)){
                //INFO: Family has open items
                //INFO: Try/Catch is needed
                try{
                    //INFO: update last active date to today & family status to active
                    fo.Last_Active_Date__c = Date.today();
                    fo.Family_Status__c = 'Active';
                    familyOverviewsToUpdate.add(fo);
                    //INFO: add fmaily id to this list so we can avoid doing this same logic for the same family again
                    familyOverviewIdsAlreadyToBeUpdatedToActive.add(fo.id);
                    //INFO: remove the current family overview so the remaining unmatched family overview list can be used later
                        familyOverviewIds.remove(acctId);
                }
                catch(Exception ex){
                    
                    }
                }
            }
        }
        for(Family_Overview__c fo : familyOverviewIds.values()) {
            if(fo.Family_Status__c == 'Active'){
                fo.Last_Active_Date__c = Date.today();
                fo.Family_Status__c = 'Inactive';
                familyOverviewsToUpdate.add(fo);
            }
        }
        update familyOverviewsToUpdate;
        checkGraduationProcess(familyOverviewIdsMasterList);
    }
    
    global void finish(Database.BatchableContext bc){
        if(famOverIdListToUpdate.size() > 0 && !Test.isRunningTest()){
            SNI_FECGraduationEHUBBatch myBatchObject = new SNI_FECGraduationEHUBBatch(famOverIdListToUpdate);
            Id batchId = Database.executeBatch(myBatchObject,Integer.valueOf(System.Label.FEC_Graduation_Batch_Size));
        }
        Fo_validations__c obj = fo_validations__c.getOrgDefaults();
        Obj.Is_Automation__c = false;
        upsert obj;
    }
    
    public Set<Id> getOpenItemsIdSet(Set<Id> acctIdList, Map<Id,Set<Id>> famAcctMap,Map<Id, Set<Id>> acrIdList){
        Set<Id> acctIdsWithOpenItems = new Set<Id>();
        //INFO: Check messages in last 30 days
        List<SNI_FL_Message__c> messageList = [select Id, Feed_Id__c, Family_ID__c from SNI_FL_Message__c where Family_ID__c IN :acctIdList];
        Map<Id, Id> feedsMap = new Map<Id, Id>();
        for(SNI_FL_Message__c msg: messageList){
            feedsMap.put(msg.Feed_Id__c, msg.Family_ID__c);
        }
        for(FeedComment feedMsg: [SELECT Id,CreatedById,CreatedDate,RelatedRecordId,CommentBody,FeedItemId FROM FeedComment WHERE CreatedDate = LAST_N_DAYS:30 AND FeedItemId IN :feedsMap.keySet()]){
            acctIdsWithOpenItems.addAll(famAcctMap.get(feedsMap.get(feedMsg.FeedItemId)));
            Set<Id> idSet = new Set<Id>();
            idSet.add(feedsMap.get(feedMsg.FeedItemId));
            checkIf180days(feedMsg.CreatedDate, idSet);
            checkIf14days(feedMsg.CreatedDate, idSet);
        }
        //INFO: Check open cases - statuses are defined in global caseStatuses list
        for(Case c : [SELECT AccountId, LastModifiedDate FROM Case WHERE (AccountId IN :acctIdList AND Status IN :caseStatuses AND RecordTypeId IN (SELECT Id FROM RecordType WHERE Name = 'ECM') AND Case_Type__c = 'Opportunity')]){
            acctIdsWithOpenItems.add(c.AccountId);
            checkIf180days(c.LastModifiedDate, acrIdList.get(c.AccountId));
            checkIf14days(c.LastModifiedDate, acrIdList.get(c.AccountId));
        }
        //INFO: Check open proactive alerts - statuses are defined in global proactiveAlertStatuses list
        for(Case pa : [SELECT AccountId, LastModifiedDate FROM Case WHERE (AccountId IN :acctIdList AND Status IN :proactiveAlertStatuses AND RecordTypeId IN (SELECT Id FROM RecordType WHERE Name = 'Proactive Alert'))]){
            acctIdsWithOpenItems.add(pa.AccountId);
            checkIf180days(pa.LastModifiedDate, acrIdList.get(pa.AccountId));
            checkIf14days(pa.LastModifiedDate, acrIdList.get(pa.AccountId));
        }
        //INFO: Check open tasks - statuses are defined in global taskStatuses list
        for(Task t : [SELECT AccountId, LastModifiedDate FROM Task WHERE (AccountId IN :acctIdList AND Status IN :taskStatuses AND RecordTypeId IN (SELECT Id FROM RecordType WHERE Name = 'SENS Task'))]){
            if(famAcctMap.containsKey(t.AccountId)){
                acctIdsWithOpenItems.addAll(famAcctMap.get(t.AccountId));
                Set<Id> idSet = new Set<Id>();
                idSet.add(t.AccountId);
                checkIf180days(t.LastModifiedDate, idSet);
            	checkIf14days(t.LastModifiedDate, idSet);
            } else {
                acctIdsWithOpenItems.add(t.AccountId);
                checkIf180days(t.LastModifiedDate, acrIdList.get(t.AccountId));
            	checkIf14days(t.LastModifiedDate, acrIdList.get(t.AccountId));
            }
        }
        return acctIdsWithOpenItems;
    }
    public void checkIf180days(DateTime lmd, Set<Id> famAcctId){
        for(Id acctId: famAcctId){
        if(lmd >= (Date.today()-180)){
                if(!activitiesMap.containsKey('180-'+acctId)){
                    activitiesMap.put('180-'+acctId,1);
                } else {
                    activitiesMap.put('180-'+acctId,activitiesMap.get('180-'+acctId)+1);
            }
        }
    }
    }
    public void checkIf14days(DateTime lmd, Set<Id> famAcctId){
        for(Id acctId: famAcctId){
            if(lmd >= (Date.today()-14)){
                if(!activitiesMap.containsKey('14-'+acctId)){
                    activitiesMap.put('14-'+acctId,1);
                } else {
                    activitiesMap.put('14-'+acctId,activitiesMap.get('14-'+acctId)+1);
                }
            }
        }
    }
    public void checkGraduationProcess(Map<Id, Family_Overview__c> foMasterList){
        List<Family_Overview__c> foToUpdate = new List<Family_Overview__c>();
        List<Account> famAcctToUpdate = new List<Account>();
        for(Id famId: foMasterList.keyset()){
            Family_Overview__c fo = foMasterList.get(famId);
            if(fo.Exception__c == 'No' || fo.Exception__c == ''){
                if(fo.Designation__c == 'Assigned' || fo.Designation__c == 'Attempted' || fo.Designation__c == 'Worked' || fo.Designation__c == ''){
                    if(fo.Family_Status__c == 'Inactive' && fo.Last_Active_Date__c <= (Date.today() - 365)){
                        fo.Designation__c = 'Dormant';
                        fo.Designation_Changed_Date__c = Date.today();
                        foToUpdate.add(fo);
                        Account acc = new Account();
                        acc.Id = famId;
                        acc.OwnerId = unassignedUser[0].Id;
                        fo.EHub_Update_Check__c = true;
                        famAcctToUpdate.add(acc);
                    } else if(fo.Family_Status__c == 'Inactive' && fo.Last_Active_Date__c <= (Date.today() - 180)){
                        fo.Designation__c = 'Deferred';
                        fo.Designation_Changed_Date__c = Date.today();
                        fo.EHub_Update_Check__c = true;
                        foToUpdate.add(fo);
                    }
                } else if(fo.Designation__c == 'Deferred'){
                    if((fo.Designation_Changed_Date__c <= (Date.today() - 180)) && (fo.Last_Active_Date__c <= (Date.today() - 180))){
                        fo.Designation__c = 'Dormant';
                        fo.Designation_Changed_Date__c = Date.today();
                        fo.EHub_Update_Check__c = true;
                        foToUpdate.add(fo);
                        Account acc = new Account();
                        acc.Id = famId;
                        acc.OwnerId = unassignedUser[0].Id;
                        famAcctToUpdate.add(acc);
                    } else if((activitiesMap.containsKey('14-'+famId) && activitiesMap.get('14-'+famId) >= 3) || (activitiesMap.containsKey('180-'+famId) && activitiesMap.get('180-'+famId) >= 10)) {
                        fo.Designation__c = 'Assigned';
                        fo.Designation_Changed_Date__c = Date.today();
                        fo.EHub_Update_Check__c = true;
                        foToUpdate.add(fo);
                    }
                }
            }
        }
        update famAcctToUpdate;
        update foToUpdate;
        famOverIdListToUpdate.addAll(new List<Id>(New Map<Id, Family_Overview__c>(foToUpdate).keySet()));
    }
}