public without sharing class ACET_GetAuthTokenBatch implements Database.Batchable < WebserviceConfigurations__c > , Database.AllowsCallouts, Database.Stateful {
    private final Set<String> serviceNames;

    public ACET_GetAuthTokenBatch(Set<String> serviceNames) {
        this.serviceNames = serviceNames;
    }

    public Iterable < WebserviceConfigurations__c > start(Database.BatchableContext info){ 
        return [SELECT Id, Name FROM WebserviceConfigurations__c WHERE Name IN :serviceNames]; 
    }

    public void execute(Database.BatchableContext info, List<WebserviceConfigurations__c> scope){
        // calling webservice
        ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
        List < HttpResponse > httpResponses = wsCallOut.getAuthToken(serviceNames);
    }

    public void finish(Database.BatchableContext info) {
        System.debug('@@ ACET_GetAuthTokenBatch: finish: serviceNames: ' + serviceNames);
    }

}