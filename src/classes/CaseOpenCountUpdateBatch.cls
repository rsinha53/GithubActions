/************************************************************
Class Name: CaseOpenCountUpdateBatch
Description: Using this class to update open case count on person account and family account
--------------------------------------------------------------
DEVELOPER         DATE             
---------------------------------------------------------------
Ravi Kishore      22/03/2021         
***************************************************************/
global without sharing class CaseOpenCountUpdateBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        set<String> sniRtSet= new set<String>();
        for(SNICaseRecordType__mdt st:[SELECT MasterLabel FROM SNICaseRecordType__mdt]){
            sniRtSet.add(st.MasterLabel);
        }
        //string casSta = 'Closed';
        string casType = 'Opportunity';
        string qry = 'Select Id, ParentID,Parent.ContactID From Case Where Recordtype.name in: sniRtSet and Case_Type__c=: casType and ID__c != null and Subject_Group_ID__c != null';
        return Database.getQueryLocator(qry); // include case tpye SENS and consider status not closed ...
    }
    global void execute(Database.BatchableContext BC, List<case> lstCase) {
        if(lstCase != null && !lstCase.isEmpty()){
            set<id> conIdTempSet=new set<id>();
            //getting all contacts realted to cases...
            for(Case c : lstCase) {
                if(c.Parent.ContactiD!=null){
                    conIdTempSet.add(c.Parent.ContactiD);
                }
            }
            // getting all the family accounts...
            set<id> accIdTempset=new set<id>();
            for(AccountContactRelation ac: [select accountid,contactid from accountcontactrelation
                                            where contactid in :conIdTempSet]){
                                                accIdTempset.add(ac.accountid);
                                            }
            
            map<id,string> famMembPol = new map<id,string>();
            set<id> conIdset=new set<id>();
            for(AccountContactRelation ac: [select accountid,contactid,account.member_Id__c,account.policy_Id__c from accountcontactrelation where accountid in :accIdTempset]){
                conIdset.add(ac.contactid);
                famMembPol.put(ac.accountid,ac.account.member_Id__c+':'+ac.account.policy_Id__c );
            }
            map<string,integer> mapMemPolCnt = new map<string,integer>();
            set<string> conCheckSet=new set<string>();
            set<string> conCheckSet2=new set<string>();
            set<String> sniRtSet= new set<String>();
            for(SNICaseRecordType__mdt st:[SELECT MasterLabel FROM SNICaseRecordType__mdt]){
                sniRtSet.add(st.MasterLabel);
                System.debug('Label='+st.MasterLabel);
            }
            map<id,Integer> accCaseCountMap=new map<id,Integer>();
            for(Case c:[SELECT id,parent.ContactID ,parent.accountId,status,ID__c,Subject_Group_ID__c FROM Case
                        Where parent.ContactID in:conIdSet and RecordType.Name in:sniRtSet and Case_Type__c = 'Opportunity' and Subject_Group_ID__c != null and ID__c != null ]){	
                            if(!conCheckSet.contains(c.ID__c+':'+c.Subject_Group_ID__c)){
                                conCheckSet.add(c.ID__c+':'+c.Subject_Group_ID__c);
                                Integer totalCount=0;
                                if(c.Status!='Closed'){
                                    totalCount+=1;
                                }
                                mapMemPolCnt.put(c.ID__c+':'+c.Subject_Group_ID__c,totalCount);
                            }
                            else{
                                Integer totalCount=  mapMemPolCnt.get(c.ID__c+':'+c.Subject_Group_ID__c);
                                if(c.Status!='Closed' ){
                                    totalCount+=1;
                                }
                                mapMemPolCnt.put(c.ID__c+':'+c.Subject_Group_ID__c,totalCount);
                            }
                            /* for person accounts */
                            if(!conCheckSet2.contains(c.parent.ContactID)){
                                conCheckSet2.add(c.parent.ContactID);
                                Integer totalCnt=0;
                                if(c.Status!='Closed'){
                                    totalCnt+=1;
                                }
                                accCaseCountMap.put(c.parent.accountId,totalCnt);
                                
                            }
                            else{
                                Integer totalCnt = accCaseCountMap.containskey(c.parent.accountId)?accCaseCountMap.get(c.parent.accountId):null;
                                if(c.Status!='Closed' && totalCnt != null){
                                    totalCnt+=1;
                                }
                                accCaseCountMap.put(c.parent.accountId,totalCnt);
                            }
                            //}
             }
            // open case count is zero then family overview status will be inactive..
            List<Family_Overview__c> famOverViewList=[select id,Family_Status__c,Account__c from Family_Overview__c where Account__c in:accIdTempset];
            map<id,Family_Overview__c> accFamMap= new map<id,Family_Overview__c>();
            for(Family_Overview__c fam:famOverViewList){
                accFamMap.put(fam.Account__c,fam);
            }
            List<Account> accList=new List<Account>();
            List<Family_Overview__c> famOvUpList =new List<Family_Overview__c>();
            for(Id accId:famMembPol.keyset()){
                string keyVal = famMembPol.get(accId);
                Integer totalCount= mapMemPolCnt.containskey(keyVal)?mapMemPolCnt.get(keyVal): 0;
                Account acc = new Account(
                    Id = accId,
                    Open_Cases__c = totalCount
                );
                accList.add(acc);
                if(accFamMap.containskey(accId)){
                    Family_Overview__c fam=accFamMap.get(accId);
                    fam.Family_Status__c=totalCount>0?'Active':'Inactive';
                    famOvUpList.add(fam);
                }
            }
            for(Id accId:accCaseCountMap.keyset()){
                Integer totalCount= accCaseCountMap.get(accId);
                Account acc = new Account(
                    Id = accId,
                    Open_Cases__c = totalCount
                );
                accList.add(acc);
            }
            if(accList!=null && accList.size()>0)
                update accList;
            if(famOvUpList!=null && famOvUpList.size()>0)
                update famOvUpList;
        }
    }   
    global void finish(Database.BatchableContext BC) {
        
    }
}