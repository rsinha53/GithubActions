public without sharing class ACET_GetJWTAuthTokenBatch implements Database.Batchable < WebserviceConfigurations__c > , Database.AllowsCallouts, Database.Stateful {
    private final Set<String> serviceNamesJWT;
    
    public ACET_GetJWTAuthTokenBatch(Set<String> serviceNamesJWT) {
        this.serviceNamesJWT = serviceNamesJWT;
    }
    
    public Iterable < WebserviceConfigurations__c > start(Database.BatchableContext info){
        return [SELECT Id, Name, Is_JWT_Token__c FROM WebserviceConfigurations__c WHERE Name IN :serviceNamesJWT];
    }
    
    public void execute(Database.BatchableContext info, List<WebserviceConfigurations__c> scope){
        // calling webservice
        ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
        List < String> jwtTokens= wsCallOut.getjwToken(serviceNamesJWT);
    }
    
    public void finish(Database.BatchableContext info) {
        System.debug('@@ ACET_GetAuthTokenBatch: finish: serviceNames: ' + serviceNamesJWT);
    }
    
}