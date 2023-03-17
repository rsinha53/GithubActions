public without sharing class ADBEligibilityResponseWrapper {
    public String responseCode;
    public String responseMsg;
    public String responseDetailMsg;
    
    // response parameters for ELigibility V2 response
    
    public List<MemberPolicies> memberPolicies;
    public class MemberPolicies{
        public DeductibleInfo outOfPocketInfo;
        public List<patientInfo> patientInfo;
        public insuranceInfo InsuranceInfo;
        public policyInfo policyInfo;
        public primaryCarePhysicianInfo primaryCarePhysicianInfo;
        public String transactionId;
    }
    public class DeductibleInfo {
        public Individual individual;
        public Individual family;
    }
    public class Individual {
        public InNetwork inNetwork;
        public InNetwork outOfNetwork;
        public InNetwork inNetworkTier1;
    }
    public class InNetwork {
        public Boolean found;
        public String metYtdAmount; 
    }
    public class patientInfo {
        public String gender;
        public String firstName;
        public String lastName;
        public String dateOfBirth;
        public String addressLine1;
        public String addressLine2;
        public String city;
        public String state;
        public String zip;
    }
    public class insuranceInfo {
        public String planDescription;
        public String insuranceType;
        public String groupNumber;
        public String payerName;
    }
    public class policyInfo {
        public String coverageType;
        public String memberId;
        public planDates planDates;
        public String policyStatus; 
    }
    public class primaryCarePhysicianInfo {
        public String firstName;
        public String lastName;
    }
    public class  planDates{
        public String startDate;
        public String endDate;
    } 
    public static ADBEligibilityResponseWrapper parse(String json) {
        return (ADBEligibilityResponseWrapper) System.JSON.deserialize(json, ADBEligibilityResponseWrapper.class);
    }
}