public class ACETHouseHoldWrapper {
	@AuraEnabled public List<HouseHold> houseHoldList {get;set;}
    @AuraEnabled public memberDetails memberDetails{get;set;}
    public class HouseHold{
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String fullName {get;set;}
        @AuraEnabled public String dob {get;set;}
        @AuraEnabled public String relationship {get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String alternateId {get;set;}
        @AuraEnabled public Boolean isMainMember {get;set;}
        @AuraEnabled public String policyId {get;set;} //Chandan
        @AuraEnabled public String cosmosDivision {get;set;} //Derek
        @AuraEnabled public String sourceCode {get;set;} //Derek
        @AuraEnabled public addressInfo address{get;set;}
        @AuraEnabled public String gender{get;set;}
       	@AuraEnabled public Boolean CHNEligibile {get;set;}
       	@AuraEnabled public Boolean CHNQualified {get;set;}
        @AuraEnabled public String CHNReferralIdentifier {get;set;}
        @AuraEnabled public String UniqueIdentifier {get;set;} //format - firstName~LastName~-~DOB
        @AuraEnabled public String enterpriseId {get;set;}
        @AuraEnabled public String complexIndicator {get;set;}
        public HouseHold(){}
    }
     public class addressInfo{
        
          @AuraEnabled public String city {get;set;}
          @AuraEnabled public String country {get;set;}
          @AuraEnabled public String state {get;set;}
          @AuraEnabled public String street {get;set;}
          @AuraEnabled public String zip {get;set;}
        }
    public class memberDetails{
        @AuraEnabled public List<HouseHold> houseHoldList {get;set;}
        @AuraEnabled public List<String> memberName{get;set;} 
        @AuraEnabled Public List<AccountContactRelation> existingMemDetails{get;set;} // for first popup with in family details
        @AuraEnabled public String accountId{get;set;}
        @AuraEnabled Public boolean isSniEligible{get;set;}
        @AuraEnabled Public boolean isSniUser{get;set;}
        @AuraEnabled public Map<String,List<AccountContactRelation>> newMemberMatch{get;set;} //for second popup,in ACET with member from service as key and list of matches  from acet
        @AuraEnabled Public Map<String,Sobject> selectedMemberDetails{get;set;}
        @AuraEnabled Public String isAcetSearch {get;set;}
        @AuraEnabled Public String relationship{get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String alternateId {get;set;}
        //@AuraEnabled public Boolean isMainMember {get;set;}
        @AuraEnabled public String policyId {get;set;}
        @AuraEnabled public String assignTo {get;set;}
        @AuraEnabled Public Map<String,String> nameRelationMap{get;set;}
    }
}