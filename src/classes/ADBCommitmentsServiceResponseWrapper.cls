public without sharing class ADBCommitmentsServiceResponseWrapper {
    // Commitments Response Wrapper - Sunil 
    
    @AuraEnabled
    public MemberAssignmentsResponse memberAssignmentsResponse;
    
    public class MemberAssignmentsResponse{
        @AuraEnabled
        public ResponseHeader responseHeader;
        @AuraEnabled
        public String sensitiveData;
        @AuraEnabled
        public List<MemberAssignments> memberAssignments;
        @AuraEnabled
        public MemberAssignments singleMemberAssignment;
    } 
    public class ResponseHeader{
        @AuraEnabled
        public String serviceCallStatusCode;
        @AuraEnabled
        public String serviceCallStatus;
    }
    public class MemberAssignments{
        @AuraEnabled
        public String assignmentType;
        @AuraEnabled
        public String createDate;
        @AuraEnabled
        public String assignmentDescriptor;
        @AuraEnabled
        public String dueDate;
    }
    
    public static ADBCommitmentsServiceResponseWrapper parse(String json) {
        return (ADBCommitmentsServiceResponseWrapper) System.JSON.deserialize(json, ADBCommitmentsServiceResponseWrapper.class);
    } 
}