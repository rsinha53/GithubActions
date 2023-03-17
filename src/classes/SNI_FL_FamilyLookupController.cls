/********************************************************************************* 
Class Name     : SNI_FL_FamilyLookupController.apxc
Description    : Handling Family Details Loading Functions
Created By     : Pavithra Fernando
Created Date   : 8/27/2020 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

----------------------------------------------------------------------------------            

*********************************************************************************/

public with sharing class SNI_FL_FamilyLookupController {
    private static List<RecordsData> recordsDataList = new List<RecordsData>();
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value,String userId, String recordType, String familyId, boolean isBackupAgentView) {
        List<String> objlst = ObjectName.split(',');
        if(isBackupAgentView == true){
            if(familyId == 'Undefined' || familyId == null) { //Messaging - My Messages Tab
                fetchFamilyRecordsForMessageTab(objlst, filterField, searchString, value, userId, recordType, familyId);
            } else{ //Provider Messaging - Person Level
                fetchRecordsForMemberLevel(objlst[0], filterField, searchString, value, userId, recordType, familyId);
            } 
        }else if(recordType == 'Provider Group' && isBackupAgentView == false){ //Provider Messaging - Backup Agents
            fetchGroupRecordsForBackupAgents(objlst[0], filterField, searchString, value, userId, recordType, isBackupAgentView);
        }
        else  {//Messaging - Backup Agents
            fetchFamilyRecordsForMessageTab(objlst, filterField, searchString, value, userId, recordType, familyId);
        }
        set<string> setFamids = new set<string>();
            list<RecordsData> lstRd = new list<RecordsData>();
            if(! recordsDataList.isEmpty()){
                for(RecordsData rd:recordsDataList){
                    if(setFamids.isEmpty() || !setFamids.contains(rd.value)){
                        lstRd.add(rd);
                        setFamids.add(rd.value);
                    }
                }
            }
            return lstRd;

    }
    
    @AuraEnabled
    public static List<RecordsData> fetchFamilyRecordsForMessageTab(list<String> objectName, String filterField, String searchString, String value,String userId, String recordType, String familyId) {
        List<String> testSort = new List<String>();
        Map<String, RecordsData> sortMap = new Map<String, RecordsData>();
        if(recordType == 'Family'){
            if(searchString.length() > 2)
            {
                for(String obj : objectName){ 
                    set<string> famIds = new set<string>();
                    if(obj == 'Account'){
                        String query = 'Find {'+searchString+'} IN '+filterField+' Fields RETURNING '+obj+' (Id, Name, Member_Id__c  Where RecordType.Name  = \'' + recordType + '\' AND OwnerID = \''+ userId + '\') ';             
                        List<List <sObject>> searchList = search.query(query);                
                        Account[] aclist = ((Account[])searchList[0]);                
                        for (Account a : aclist) {   
                            famIds.add(a.Id);
                            recordsDataList.add(new RecordsData(a.Name, a.Id, a.Member_Id__c));                    
                        }
                    }
                    else if(obj == 'Family_Partner__c'){
                        string sQuery = 'Select Id,Family__c, Family__r.Name,Family__r.Member_Id__c from '+obj+' where Partner__c  = \''+ userId + '\'';
                        List <Family_Partner__c> lstFamParts = Database.query(sQuery);                
                        for (Family_Partner__c part: lstFamParts) {
                             if(famIds.isempty() || ! famIds.contains(part.Family__c)){
                            system.debug('part----'+part.Family__r.Name);
                            if(part.Family__r.Name.startsWithIgnoreCase(searchString)){
                            recordsDataList.add(new RecordsData(part.Family__r.Name, part.Family__c, part.Family__r.Member_Id__c));
                            }
                             }
                        }
                    }
                }
            }
            else
            {                
                List<RecordsData> dataList = new List<RecordsData>();
                for(String obj : objectName){
                    set<string> famIds = new set<string>();
                    if(obj == 'Account'){
                        String sQuery = 'Select Id, Name,Member_Id__c from '+obj+' where RecordType.Name  = \'' + recordType + '\' AND OwnerID  = \''+ userId + '\'';
                        List <Account> lstOfRecords = Database.query(sQuery);                
                        for (Account acc: lstOfRecords) {
                            famIds.add(acc.id);
                            String name = acc.Name.toUpperCase();
                            dataList.add(new RecordsData(acc.Name, acc.Id, acc.Member_Id__c));                
                            testSort.add(name);                
                            sortMap.put(name,new RecordsData(acc.Name, acc.Id, acc.Member_Id__c));                    
                        }
                    }
                   else if(obj == 'Family_Partner__c'){
                        String sQuery = 'Select Id,Family__c, Family__r.Name,Family__r.Member_Id__c from '+obj+' where  Partner__c  = \''+ userId + '\'';
                        List <Family_Partner__c> lstFamParts = Database.query(sQuery);                
                        for (Family_Partner__c part: lstFamParts) {
                            if(famIds.isempty() || ! famIds.contains(part.Family__c)){
                            String accName = part.Family__r.Name.toUpperCase();
                            system.debug('Family_Partner__c accName---'+accName);
                            dataList.add(new RecordsData(part.Family__r.Name, part.Family__c, part.Family__r.Member_Id__c));                
                            testSort.add(accName);                
                            sortMap.put(accName,new RecordsData(part.Family__r.Name, part.Family__c, part.Family__r.Member_Id__c));                    
                            }
                        }
                    }
                    testSort.sort();
                    for(String s : testSort) {
                        recordsDataList.add(sortMap.get(s));
                    }
                }
            }
        }else if(recordType == 'Provider Group'){
            if(searchString.length() > 2){
                List<RecordsData> dataList = new List<RecordsData>();
                Set<ID> setAcctMem = new Set<ID>();
                List<AccountTeamMember> lstAcctMem = [SELECT id, Account.ParentId, Account.Name FROM AccountTeamMember Where UserId =: userId];
                for(AccountTeamMember am : lstAcctMem){
                    setAcctMem.add(am.Account.ParentId);
                }
                List<List <sObject>> searchList =   [Find :searchString IN Name Fields RETURNING Account (Id, Name,Member_Id__c  Where Id IN : setAcctMem )];         
                Account[] aclist = ((Account[])searchList[0]);                
                for (Account a : aclist) {                    
                    recordsDataList.add(new RecordsData(a.Name, a.Id, a.Member_Id__c));                    
                }
            }else{
                List<RecordsData> dataList = new List<RecordsData>();
                Set<ID> setAcctMem = new Set<ID>();
                List<AccountTeamMember> lstAcctMem = [SELECT id, Account.ParentId, Account.Name FROM AccountTeamMember Where UserId =: userId ];
                for(AccountTeamMember am : lstAcctMem){
                    setAcctMem.add(am.Account.ParentId);
                }
                List <Account> lstOfRecords = [Select Id, Name,Member_Id__c from Account where Id IN :setAcctMem  ];
                for (Account obj: lstOfRecords) {
                    String name = obj.Name.toUpperCase();
                    dataList.add(new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                
                    testSort.add(name);                
                    sortMap.put(name,new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                    
                }
                
                testSort.sort();
                for(String s : testSort) {
                    recordsDataList.add(sortMap.get(s));
                }
            }
        }
        
        return recordsDataList;                        
        
    }
    
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String memberId;
        
        public RecordsData(String label, String value, String memberId) {
            this.label = label;
            this.value = value;
            this.memberId = memberId;
        }
    }
       
    @AuraEnabled
    public static List<RecordsData> fetchRecordsForMemberLevel(String objectName, String filterField, String searchString, String value,String userId, String recordType,  String familyId) {
        List<AccountTeamMember> lstLoggedUser= new List<AccountTeamMember>();
        List<Member_Affiliation__c> lstMember= new List<Member_Affiliation__c>();
        List<ID> lstGroups = new List<ID>();
        List<Account> lstSelectedList= new List<Account>();
        Set<ID> setLoggedUser = new Set<ID>();
        Set<ID> setMember = new Set<ID>();
        List<String> testSort = new List<String>();
        Map<String, RecordsData> sortMap = new Map<String, RecordsData>();
        List<RecordsData> dataList = new List<RecordsData>();

        String uid = UserInfo.getUserId();
        lstLoggedUser = [SELECT id, UserId,Account.ParentId FROM AccountTeamMember Where UserId =:uid ];
        lstMember = [SELECT  Provider_Affiliation__r.ParentId FROM Member_Affiliation__c Where Member__c =:familyId ];
        for(AccountTeamMember lu: lstLoggedUser){
            setLoggedUser.add(lu.Account.ParentId);
        }
        for(Member_Affiliation__c lm: lstMember){
            setMember.add(lm.Provider_Affiliation__r.ParentId);
        }

        for(ID user: setLoggedUser){
            for(ID member: setMember){
                if(user == member){
                    lstGroups.add(member);                  
                }                    
            }
        }

        if(searchString.length() > 2){
            List<List <sObject>> searchList =   [Find :searchString IN Name Fields RETURNING Account (Id, Name,Member_Id__c  Where Id IN : lstGroups )];                        
            Account[] aclist = ((Account[])searchList[0]);                
            for (Account obj: aclist) {
                    String name = obj.Name.toUpperCase();
                    dataList.add(new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                
                    testSort.add(name);                
                    sortMap.put(name,new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                    
            }
            
            testSort.sort();
            for(String s : testSort) {
                recordsDataList.add(sortMap.get(s));
            }

            return recordsDataList;
        }else{
            lstSelectedList = [Select Id, Name,Member_Id__c From Account Where Id IN :lstGroups];
            for (Account obj: lstSelectedList) {
                    String name = obj.Name.toUpperCase();
                    dataList.add(new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                
                    testSort.add(name);                
                    sortMap.put(name,new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                    
            }
            
            testSort.sort();
            for(String s : testSort) {
                recordsDataList.add(sortMap.get(s));
            }
            return recordsDataList;
        }
    }
    
     @AuraEnabled
    public static List<RecordsData> fetchGroupRecordsForBackupAgents(String objectName, String filterField, String searchString, String value,String userId, String recordType,  boolean isBackupAgentView) {
        List<AccountTeamMember> lstLoggedUser= new List<AccountTeamMember>();
        List<AccountTeamMember> lstBkpUser= new List<AccountTeamMember>();
        List<ID> lstGroups = new List<ID>();
        List<Account> lstSelectedList= new List<Account>();
        Set<ID> setLoggedUser = new Set<ID>();
        Set<ID> setBkpUser = new Set<ID>();
        List<String> testSort = new List<String>();
        Map<String, RecordsData> sortMap = new Map<String, RecordsData>();
        List<RecordsData> dataList = new List<RecordsData>();
        
        String loggedUser = UserInfo.getUserId();
        lstLoggedUser = [SELECT id, UserId,Account.ParentId FROM AccountTeamMember Where UserId =:loggedUser];        
        lstBkpUser = [SELECT id, UserId,Account.ParentId FROM AccountTeamMember Where UserId =:userId ];

        for(AccountTeamMember lu: lstLoggedUser){
            setLoggedUser.add(lu.Account.ParentId);
        }
        for(AccountTeamMember lm: lstBkpUser){
            setBkpUser.add(lm.Account.ParentId);
        }

        for(ID user: setLoggedUser){
            for(ID member: setBkpUser){
                if(user == member){
                    lstGroups.add(member);                  
                }                    
            }
        }

        if(searchString.length() > 2){
            List<List <sObject>> searchList =   [Find :searchString IN Name Fields RETURNING Account (Id, Name,Member_Id__c  Where Id IN : lstGroups )];                        
            Account[] aclist = ((Account[])searchList[0]);                
            for (Account obj: aclist) {
                    String name = obj.Name.toUpperCase();
                    dataList.add(new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                
                    testSort.add(name);                
                    sortMap.put(name,new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                    
            }
            
            testSort.sort();
            for(String s : testSort) {
                recordsDataList.add(sortMap.get(s));
            }
            return recordsDataList;
        }else{
            lstSelectedList = [Select Id, Name, Member_Id__c From Account Where Id IN :lstGroups ];
            for (Account obj: lstSelectedList) {
                    String name = obj.Name.toUpperCase();
                    dataList.add(new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                
                    testSort.add(name);                
                    sortMap.put(name,new RecordsData(obj.Name, obj.Id, obj.Member_Id__c));                    
            }
            
            testSort.sort();
            for(String s : testSort) {
                recordsDataList.add(sortMap.get(s));
            }
            return recordsDataList;
        }
    }

    
}