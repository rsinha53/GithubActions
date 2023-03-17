public without sharing class ADBMemberProgramsServiceResponseWrapper {
    // method to call actual read population service - Sunil : US2727248 - Read Population API 
    @AuraEnabled
    public availableProgramsResponse availableProgramsResponse;
    @AuraEnabled public SingleAvailableProgramsResponse singleAvailableProgramsResponse;
	@AuraEnabled public String systemErrorMessage;
    
    public class availableProgramsResponse{
        @AuraEnabled public List<availableProgramsResponseTypeList> availableProgramsResponseTypeList;
		@AuraEnabled public StatusMessage statusMessage;												
    }

    public class SingleAvailableProgramsResponse{
        @AuraEnabled public availableProgramsResponseTypeList singleAvailableProgramsResponseList;
        @AuraEnabled public StatusMessage statusMessage;
    }

	public class StatusMessage{
        @AuraEnabled public String statusMessage;
    }					   
    public class availableProgramsResponseTypeList{
        @AuraEnabled public String programName;
        @AuraEnabled public String programType;
        @AuraEnabled public String programPhone;
        @AuraEnabled public String isAcceptingReferrals;
        @AuraEnabled public String hoursOfOperation;
        @AuraEnabled public String iCUEProgram;
        @AuraEnabled public String programVendor;
        @AuraEnabled public String programStatus;
        @AuraEnabled public String memberProgramId;
        @AuraEnabled public String programICUESSOURL;
        @AuraEnabled public String programDescription;
        @AuraEnabled public String ownerName;
        @AuraEnabled public String ownerPhone;
        @AuraEnabled public String ownerEmail;
        @AuraEnabled public String rejectReason;
    }
    
    public static ADBMemberProgramsServiceResponseWrapper parse(String json) {
        return (ADBMemberProgramsServiceResponseWrapper) System.JSON.deserialize(json, ADBMemberProgramsServiceResponseWrapper.class);
    } 
}