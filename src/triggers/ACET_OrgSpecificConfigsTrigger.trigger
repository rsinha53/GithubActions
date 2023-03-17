trigger ACET_OrgSpecificConfigsTrigger on OrgSpecificConfigurations__c(Before insert, Before update) {
    
    // populate external id and duplicate check
    List<RecordType> recTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'OrgSpecificConfigurations__c'];
    system.debug('@@@recTypes'+recTypes );
    
    for (OrgSpecificConfigurations__c osc: Trigger.new) {
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            //osc.CheckDuplicate__c = osc.Name;
            for(RecordType rt:recTypes){
                if(osc.RecordTypeText__c == rt.DeveloperName ){
                    system.debug('Inside Match');
                    osc.RecordTypeId = rt.Id;
                }
            }
        }
    }
}