public with sharing class ACETClaimSearchUtility {
    public static ACETWSCalloutResult getClaims(String strTaxId,String strNetworkStatus, String strCoverageType, String strStartDate,String strEndDate, String strDeductibleOnly,String strClaimId, String strAuthorizationNumber,String strReferrelNumber, String filterBy, String SortBy, String SortOrder, List<String> SystemLabels){
        ACETFindClaimWebservice claimService = new ACETFindClaimWebservice();
        ACETWSCalloutResult oACETWSCalloutResult;// = claimService.findClaims(strTaxId, strNetworkStatus, strCoverageType, strStartDate,strEndDate, strDeductibleOnly, strClaimId, strAuthorizationNumber, strReferrelNumber, filterBy, SortBy, SortOrder, SystemLabels);
        return oACETWSCalloutResult;
    }
  /**  public static ACETWSCalloutResult getMedicalClaims(String strClaimId){
        ACETGetMedicalClaimWebService claimDetailService = new ACETGetMedicalClaimWebService();
        ACETWSCalloutResult oACETWSCalloutResult = claimDetailService.getMedicalClaims(strClaimId);
        return oACETWSCalloutResult;
    }**/
    /*public static ACETWSCalloutResult getClaimPayments(String strProviderId, String strTaxId, String strNPI,String strCallCode, String strCheckNumber, String strSeriesDesignator,String strTotalPayment,String strLastName,String strFirstName,String strMemberId,String strPolicyNumber){         
        ACETClaimPaymentWebService claimPaymentService = new ACETClaimPaymentWebService();
        ACETWSCalloutResult oACETWSCalloutResult = claimPaymentService.findClaimPayments(strProviderId, strTaxId, strNPI,strCallCode, strCheckNumber, strSeriesDesignator,strTotalPayment,strLastName,strFirstName,strMemberId,strPolicyNumber);      
        return oACETWSCalloutResult;
    }*/
    public static ACETWSCalloutResult getCheckStatus(String strcheckNumber,string strSeriesDesignator){
        ACETGetClaimCheckStatusWebService checkStatusService = new ACETGetClaimCheckStatusWebService();
        ACETWSCalloutResult oACETWSCalloutResult = checkStatusService.getCheckstatus(strCheckNumber, strSeriesDesignator);      
        return oACETWSCalloutResult;
    }
}