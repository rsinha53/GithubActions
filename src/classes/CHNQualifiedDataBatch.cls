public  class CHNQualifiedDataBatch implements Database.Batchable<CHN_Qualified_Data__c>{
   
    public List<CHN_Qualified_Data__c> start(Database.BatchableContext BC){
        List<CHN_Qualified_Data__c> query = [SELECT ID, First_Name__c, Last_Name__c,Policy_Number__c, EID__c, Subscriber_Member_ID__c FROM CHN_Qualified_Data__c WHERE First_Name__c = null AND EID__c != null];
        return query;
    }
    
    public  void execute(Database.BatchableContext BC, List<CHN_Qualified_Data__c> listQualData){
        for (CHN_Qualified_Data__c q: listQualData) {
            ID jobID = System.enqueueJob(new CHNQualifiedDataUpdate(q));
        }
    }
    
    public  void finish(Database.BatchableContext BC){
        
    }
}