public with sharing class ECMTestDataUtil {
    public static list<Routing_Configuration__c> createRoutingConfiguration(string queueName, decimal sortOrder,Integer noOfRecords ,boolean insertRecords){
        list<Routing_Configuration__c> objLst = new list<Routing_Configuration__c>();
        for(Integer i=0;i<noOfRecords; i++){
            Routing_Configuration__c tmp = new Routing_Configuration__c(Queue_Name__c =queueName, SortOrder__c = sortOrder+i );
            objLst.add(tmp);
        }
        if(insertRecords){
            insert objLst;
        }
        return objLst;
    }
    
    public static list<Case> createCase(string status,id ownerId,Integer noOfRecords ,boolean insertRecords){
        list<Case> objLst = new list<Case>();
        for(Integer i=0;i<noOfRecords; i++){
            Case tmp = new Case(Status = status,OwnerID = ownerId);
            objLst.add(tmp);
        }
        if(insertRecords){
            insert objLst;
        }
        return objLst;
    }
}