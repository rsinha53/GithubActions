global class ETSBE_ArchiveSpecialInsBatch implements Database.Batchable<sObject> {

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
        
        //Below is to archive termed special instructions
        String query = 'Select Id, BusinessDirectionExternalID__c, End_Date__c FROM Special_Instructions__c Where End_Date__c <= '+ curr;
        return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<Special_Instructions__c> scope) {
        if(Special_Instructions__c.sObjectType.getDescribe().isDeletable()){
            delete scope;
        }
    }    
    
    global void finish(Database.BatchableContext BC) {
    }
}