public class SNI_FL_SelectMemberAffiliationController {
    
    public class MemberAffiliationWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String AffiliationID;
        @AuraEnabled
       	public String ProviderAffiliationName; 
        @AuraEnabled
        public String EnrollmentDate;
        @AuraEnabled
        public String MemberName;
        
    }
    @AuraEnabled
    public static List<MemberAffiliationWrapper> getMemberAffiliationList(String accountID){
        List<Member_Affiliation__c> memberAfflst = new List<Member_Affiliation__c>();
        List<MemberAffiliationWrapper> memberAff = new List<MemberAffiliationWrapper>();
            if(accountID != null && !String.isEmpty(accountID)){
                memberAfflst = [Select Id, Name,Provider_Affiliation__r.Name, Enrollment_Date__c,Member__r.Name,Historical_Message__c from Member_Affiliation__c where Member__c =: accountID and Historical_Message__c = true];
                if(memberAfflst.size() > 0){
                    for(Member_Affiliation__c ma : memberAfflst){
                        MemberAffiliationWrapper maObj = new MemberAffiliationWrapper();
                        maObj.id = ma.Id;
                        maObj.AffiliationID = ma.Name;
                        maObj.ProviderAffiliationName = ma.Provider_Affiliation__r.Name;
                        maObj.EnrollmentDate = ma.Enrollment_Date__c.month() + '/' + ma.Enrollment_Date__c.day() + '/' + ma.Enrollment_Date__c.year();
                        maObj.MemberName = ma.Member__r.Name;
                        memberAff.add(maObj);
                    }
                }
                
            }
        return memberAff;
    }
}