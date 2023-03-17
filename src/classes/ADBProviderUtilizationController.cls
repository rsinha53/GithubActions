public without sharing class ADBProviderUtilizationController{
    
    //  Constant Request parameter values for MemberSearchV2 Service         
    final static String OPTUM_CID_EXT = 'ACETDASHBOARD-ONBRDTESTCLM'; 
    final static String CONSUMERAPPID = 'ACETDASHBOARD';
    final static String CONSUMERAPPTYPE = 'IA';
    final static String CONSUMERTYPE = 'CA';
    final static String BU = 'https://';	// starting base URL portion
	

    @AuraEnabled
    public static ADBMemberDetailWrapper memberSearchV2 (String memberId, String memDob, String firstName, String lastName, String timestamp){
       ADBMemberDetailWrapper rxDetails = ADBMemberSearchController.getMemberSearchResponse(memberId, memDob, firstName, lastName, timestamp);
        return rxDetails; 
    }
    
    @AuraEnabled
    public static ADBClaimDetailWrapper claimsSearchV2 (String carrierID, String accountId, String groupId, String rxMemberId, String instanceId, String timestamp, String fillDateThru, String fillDateFrom) {
       ADBClaimDetailWrapper claimDetails = ADBClaimsSearchController.getClaimsSearch(carrierID, accountId, groupId, rxMemberId, instanceId, timestamp, fillDateThru, fillDateFrom);
        return claimDetails;
    }
       
    // Call ADBMedicalClaimsDetailController for getting medical claim details
    @AuraEnabled
    public static ADBMedicalClaimResponseWrapper topDashboardClaims (String userId, String memberId, String policy, String memFirstName, String relationship, String consumerApplication) {
      ADBMedicalClaimResponseWrapper medicalClaimDetails = ADBMedicalClaimsDetailController.getMedicalClaims(userId, memberId, policy, memFirstName, relationship, consumerApplication);
        return medicalClaimDetails;
    }
}