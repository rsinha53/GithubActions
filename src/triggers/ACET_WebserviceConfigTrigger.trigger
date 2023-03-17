trigger ACET_WebserviceConfigTrigger on WebserviceConfigurations__c(Before insert, Before update) {
    
    // populate external id and duplicate check
    List<RecordType> recTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'WebserviceConfigurations__c'];
    system.debug('@@@recTypes'+recTypes );
    
    for (WebserviceConfigurations__c wsc: Trigger.new) {
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            //wsc.CheckDuplicate__c = wsc.Name;
            for(RecordType rt:recTypes){
                if(wsc.RecordTypeText__c == rt.DeveloperName ){
                    system.debug('Inside Match');
                    wsc.RecordTypeId = rt.Id;
                }
            }
        }
    }
}