public without sharing class ADBRallyIncentiveRequestWrapper {
    
    @AuraEnabled public String firstName{ get; set; }
    @AuraEnabled public String lastName{ get; set; }
    @AuraEnabled public String dob{ get; set; }
    @AuraEnabled public String memberNumber{ get; set; }
    @AuraEnabled public String partnerUserId{ get; set; }
    @AuraEnabled public String groupNumber{ get; set; }
    
    @AuraEnabled public Plan plan;
    @AuraEnabled
    public List<Activities> activities;
    
    public class Plan {
        @AuraEnabled public String planName;
        @AuraEnabled public String planStartDate;
        @AuraEnabled public String planEndDate;
        @AuraEnabled public Integer maxCap;
        @AuraEnabled public Integer earnedAmount;
        @AuraEnabled public String awardMedia;
    }
    
    public class Activities {
        @AuraEnabled public String activityStatus;
        @AuraEnabled public String activityStartDate;
        @AuraEnabled public String activityEndDate;
        @AuraEnabled public String activityCompletionDate;
        @AuraEnabled public String activityName;
        @AuraEnabled public String activityDescription;
        @AuraEnabled public Integer coinYield;
        @AuraEnabled public Reward reward;
    }
    
    public class Reward {
        @AuraEnabled public Decimal amount;
        @AuraEnabled public String awardMedia;
    }
}