global class SNI_FECGraduationEHUBBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    public List<String> famOverIdList = new List<String>();
    public SNI_FECGraduationEHUBBatch(List<Id> foIdList){
        famOverIdList =(List<String>)foIdList;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Family_Overview__c WHERE Id IN :famOverIdList');
    }
    global void execute(Database.BatchableContext bc, List<Family_Overview__c> records){
        for(Family_Overview__c fo: records){
            ACETEligibilityUpdController.SearchResultWrapper retwrap = ACETEligibilityUpdController.updateEHub(fo.id, 'Family_Overview__c');
        }
    }
    global void finish(Database.BatchableContext bc){
    }
}