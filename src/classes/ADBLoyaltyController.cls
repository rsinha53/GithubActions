public without sharing class ADBLoyaltyController {
@AuraEnabled public static Map<String,String> getLoyaltyDetails(String memberId,String policyNumber,String asofDate){
        ADBLoyaltyResponseWrapper loyaltyResponseWrapper = new ADBLoyaltyResponseWrapper();
        ADBLoyaltyRequestWrapper loyaltyRequest = new ADBLoyaltyRequestWrapper();
        String topsOrigCoverageEffectiveDate = '';
        String cesCustomerName = '';
        Map<String,String> resmap = new Map<String,String>();
        try {
            loyaltyRequest.readInput  = new ADBLoyaltyRequestWrapper.readInput();
            ADBLoyaltyRequestWrapper.readInput req = loyaltyRequest.readInput;
            req.controlModifiers = new ADBLoyaltyRequestWrapper.ControlModifiers();
            req.controlModifiers.cdbSystemParameters = new ADBLoyaltyRequestWrapper.CdbSystemParameters();
            req.controlModifiers.ndbSystemParameters = new ADBLoyaltyRequestWrapper.NdbSystemParameters();
            req.controlModifiers.cdbSystemParameters.applicationId = 'ACT';
            req.controlModifiers.cdbSystemParameters.roleId = 'ACT';                        
            req.controlModifiers.ndbSystemParameters.platformId = 'W';
            req.controlModifiers.ndbSystemParameters.projectId = '06';            
            req.controlModifiers.requestCodeDescriptionLookup = 'false';
            req.controlModifiers.requestProviderDemographic = 'false';
            req.controlModifiers.requestTopsEligibilityInformation = 'false';
            req.controlModifiers.requestWrittenLanguagePreference = 'false';                        
            req.searchId = memberId;
            req.policyNumber = policyNumber;
            req.sourceCode = 'CS';
            req.requestFamilyOrIndividual = 'Family';
            req.asOfDate = asofDate;
            req.requestCoverageTimeline = 'CURRENT';
            req.requestDemographic = 'ALL';
            req.requestHealthServices = 'ALL';
            req.requestFamilyLastUpdateDate = 'Y';
            req.requestEmail = 'N';
            req.blsEligibilityInd = 'N';
            req.requestCamsDemographic = 'N';
            req.requestExpandedCoverageTimelines = 'false';
            req.requestPrimeLifeAndDisability = 'false';
            req.requestMemberPopulation = 'Y';
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBLoyaltyEndpoint', JSON.serialize(loyaltyRequest), null);
            HttpResponse response = wsCallOutFW.getResponse();
            if(response.getStatusCode() == 200) {
                loyaltyResponseWrapper = (ADBLoyaltyResponseWrapper) JSON.deserialize(response.getBody(), ADBLoyaltyResponseWrapper.class);
                if(loyaltyResponseWrapper!= null && loyaltyResponseWrapper.readResult != null && loyaltyResponseWrapper.readResult.readOutput != null){
                    ADBLoyaltyResponseWrapper.ReadResult rs= loyaltyResponseWrapper.readResult;
                    if(!rs.readOutput.eligibilities.isEmpty() && rs.readOutput.eligibilities[0].subscriberDetail != null 
                       && rs.readOutput.eligibilities[0].subscriberDetail.eligibility != null 
                       && rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics != null){
                           topsOrigCoverageEffectiveDate = rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics.topsOrigCoverageEffectiveDate;
                           cesCustomerName = rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics.cesCustomerName;
                           resmap.put('topsOrigCoverageEffectiveDate',topsOrigCoverageEffectiveDate);
                           resmap.put('cesCustomerName',cesCustomerName);
                       }
                }               
            } else {
                system.debug('CallerProfileController.getLoyaltyDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('CallerProfileController.getLoyaltyDetails Exception ::' + e.getMessage());
        }
        return resmap;
    }
}