global class ACETORSReadResponseWrapper{
    
    //Fields required to be displayed in the UI
    @AuraEnabled public String orsKey{get;set;}//headerNumber_commmentDate_commentTime_commentType
    @AuraEnabled public String userId{get;set;}//Author 
    @AuraEnabled Public String source{get;set;}
    @AuraEnabled public String commment{get;set;}
    @AuraEnabled public String commmentDate{get;set;}
    @AuraEnabled public String commentTime{get;set;}
    @AuraEnabled public DateTime commentDateTime{get;set;}
    @AuraEnabled public String ownerName{get;set;}
    
    //Fields required to be checked while Updating
    @AuraEnabled public String ownerId{get;set;}
    @AuraEnabled public String author{get;set;} //would be depricated
    @AuraEnabled public String designeeId{get;set;}
    @AuraEnabled public String issueId{get;set;}
    @AuraEnabled public String contactmethodCode{get;set;}
    @AuraEnabled public String callerfirstname{get;set;}
    @AuraEnabled public String callerlastname{get;set;}
    @AuraEnabled public String dependentfirstname{get;set;}
    @AuraEnabled public String dependentlastname{get;set;}
    @AuraEnabled public String originatorTypeCode{get;set;}
    @AuraEnabled public String directionCode{get;set;}
    @AuraEnabled public String status{get;set;}
	
    
    
}