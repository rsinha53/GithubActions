public class SAEHouseHoldWrapper {
    /*US1970508 - Ravindra - start
    //@AuraEnabled public String xRefId {get;set;}
    US1970508 - Ravindra - end*/
	@AuraEnabled public List<HouseHold> houseHoldList {get;set;}
    
    public class HouseHold{
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String fullName {get;set;}
        //US1970508 - Ravindra - start
        @AuraEnabled public String dob {get;set;}
        //US1970508 - Ravindra - end
        //US2574803 - Vishnu
        @AuraEnabled public String gender {get;set;}
        @AuraEnabled public String relationship {get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public Boolean isMainMember {get;set;}
        
        public HouseHold(){}
    }
}