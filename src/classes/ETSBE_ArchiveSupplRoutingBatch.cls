global class ETSBE_ArchiveSupplRoutingBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        String curr = date.today().addDays(-30).format();
        String month = curr.split('/')[0];
        String day = curr.split('/')[1];
        String year = curr.split('/')[2];
        if(integer.valueof(month) < 10){
            month = '0' + month;
        }
        if(integer.valueof(day) < 10){
            day = '0' + day;
        }
        curr = year + '-' + month + '-' + day;
        
        //Below is to archive termed Supplemental Routing Records
        String query = 'Select Id FROM Supplemental_Routing__c Where End_Date__c <= '+ curr;
        return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<Supplemental_Routing__c> supplmentalRoutingRecsList) {
        if(Supplemental_Routing__c.sObjectType.getDescribe().isDeletable()){
            delete supplmentalRoutingRecsList;
        }
    }    
    
    global void finish(Database.BatchableContext BC) {
    }

}