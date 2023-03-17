/**
* Author: Hasara Disanayaka
* Description : Wrapper class to get the response for incentive details
*               
* AuraEnabled : False
* Created Date : 03/03/2020
*/
public without sharing class ADBHealthAssessmentResponceWrapper {
    
    public String responseCode;
    public String responseMsg;
    public String responseDetailMsg;
    
    
    @AuraEnabled public List<ADBRallyIncentiveRequestWrapper.Activities> completedActivitiesList;
    @AuraEnabled public List<ADBRallyIncentiveRequestWrapper.Activities> pendingActivitiesList;
    @AuraEnabled public ADBRallyIncentiveRequestWrapper.Plan plan;
    @AuraEnabled public Integer totalCOinYield;
    @AuraEnabled public String personId;
    @AuraEnabled public String populationId;
    
}