// Controller class to callSelectAssociateAPI on ACET_PolicyParent component 
// Ketki J - 5/21/2021
// US3552097
public class ACET_RCEDServiceWS {
    private static final String actor= 'ACET';
    
    @AuraEnabled
    public static SAEPolicyDetailsController.RCEDResponseWrap call_RCED(String subscriberId, String policyNumber, String sourceCode) {
        String responseStr = '';
        SAEPolicyDetailsController.RCEDResponseWrap rcedrRespWrap=new SAEPolicyDetailsController.RCEDResponseWrap();
        try{
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'ADBLoyaltyEndpoint';
            wsCallOut.requestBody = getRCEDRequestBody(subscriberId,policyNumber,sourceCode);
            HttpResponse response = wscallout.getResponse();
            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            
            if(response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                  ADBLoyaltyResponseWrapper loyaltyResponseWrapper = ADBLoyaltyResponseWrapper.parse(responseStr);
				  System.debug('### ACET_RCEDServiceWS - Deserialized responseObj:'+loyaltyResponseWrapper);
                  if(loyaltyResponseWrapper!= null && loyaltyResponseWrapper.readResult != null && loyaltyResponseWrapper.readResult.readOutput != null)
                  {
                    ADBLoyaltyResponseWrapper.ReadResult rs= loyaltyResponseWrapper.readResult;
                    if(!rs.readOutput.eligibilities.isEmpty() && rs.readOutput.eligibilities[0].subscriberDetail != null && rs.readOutput.eligibilities[0].subscriberDetail.eligibility != null && rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics != null)
                    {
                            if(String.isNotBlank(String.valueOf(rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics.cesCustomerName)))
                            {
                                rcedrRespWrap.groupName = rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics.cesCustomerName;
                                rcedrRespWrap.statusCode=response.getStatusCode();
                            }
                            else
                            {
                                rcedrRespWrap.groupName = '--';
                                rcedrRespWrap.statusCode=response.getStatusCode();

                            }
                        if( rs.readOutput.eligibilities[0].subscriberDetail.eligibility.Demographics!=null ){
                            ADBLoyaltyResponseWrapper.Demographics dem =rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics;
                            SAEPolicyDetailsController.Demographics demobj = new SAEPolicyDetailsController.Demographics();
                            demobj.topsOrigCoverageEffectiveDate= dem.topsOrigCoverageEffectiveDate;
                            demobj.retirementDate =dem.retirementDate;
                            rcedrRespWrap.demRes = demobj;
                      }
                    }
                    else
                    {
                        rcedrRespWrap.groupName = '--';
                        rcedrRespWrap.statusCode=response.getStatusCode();

                    }
                    system.debug('rcedrRespWrap>>'+rcedrRespWrap);
                    //Ketki pcp from RCED begin
                    if(!rs.readOutput.eligibilities.isEmpty() &&
                       rs.readOutput.eligibilities[0].subscriberDetail != null &&
                       rs.readOutput.eligibilities[0].subscriberDetail.eligibility != null &&
                       rs.readOutput.eligibilities[0].subscriberDetail.eligibility.pcps != null &&
                       !rs.readOutput.eligibilities[0].subscriberDetail.eligibility.pcps.isEmpty())
                    {
                        ADBLoyaltyResponseWrapper.Pcps pcp = rs.readOutput.eligibilities[0].subscriberDetail.eligibility.pcps[0];
                      	SAEPolicyDetailsController.PCP pcpRes = new SAEPolicyDetailsController.PCP();
                        pcpRes.ipa = pcp.ipa;
                        pcpRes.marketType = pcp.marketType;
                        pcpRes.marketSite = pcp.marketSite;
                        rcedrRespWrap.pcp = pcpRes;

                        SAEPolicyDetailsController.IPAMarketInputs ipaInput=new SAEPolicyDetailsController.IPAMarketInputs();
                        ipaInput.appName='acet';
                        ipaInput.marketNumber=pcp.marketSite;
                        ipaInput.marketType=pcp.marketType;
                        ipaInput.ipa=pcp.ipa;

                        SAEPolicyDetailsController.IPAMarketResponseWrap ipaResponse= SAEPolicyDetailsController.call_IPA_MarketAssociation_API(ipaInput);
                        if(ipaResponse !=null){
                            rcedrRespWrap.ipaMarketRes=ipaResponse;
                        }
                    }
                    else{

                        SAEPolicyDetailsController.PCP pcp = new SAEPolicyDetailsController.PCP();
                        pcp.ipa = '--';
                        pcp.marketType = '--';
                        pcp.marketSite = '--';
                    }

                    if(!rs.readOutput.eligibilities.isEmpty() &&
                       rs.readOutput.eligibilities != null &&
                       rs.readOutput.eligibilities[0].vendors != null &&
                       !rs.readOutput.eligibilities[0].vendors.isEmpty())
                    {
                        ADBLoyaltyResponseWrapper.Vendors vendor = rs.readOutput.eligibilities[0].vendors[0];
                        SAEPolicyDetailsController.Vendor vendorRes = new SAEPolicyDetailsController.Vendor();
                        vendorRes.vendorBenefitOptionTypeCode = vendor.vendorBenefitOptionTypeCode;
                        vendorRes.healthServiceProductCode = vendor.healthServiceProductCode;
                        vendorRes.vendorStartDate = vendor.vendorEffectiveDates.start;
                        vendorRes.vendorEndDate = vendor.vendorEffectiveDates.end_Z;
                        rcedrRespWrap.vendor = vendorRes;
                    }
                    else{

                        SAEPolicyDetailsController.Vendor vendorRes = new SAEPolicyDetailsController.Vendor();
                        vendorRes.healthServiceProductCode = '--';
                        vendorRes.vendorBenefitOptionTypeCode = '--';
                        vendorRes.vendorStartDate = '--';
                        vendorRes.vendorEndDate = '--';
                        rcedrRespWrap.vendor = vendorRes;
                        rcedrRespWrap.statusCode=response.getStatusCode();
                    }
                    system.debug('rcedrRespWrap 2>>'+rcedrRespWrap);
                    //Ketki pcp from RCED end
                }
                else
                {
                    rcedrRespWrap.groupName = '--';
                    rcedrRespWrap.statusCode=response.getStatusCode();
                }
                }
            }
        }
        catch(Exception ex){
            System.debug(ex.getStackTraceString());
        }
        return rcedrRespWrap;
        
    }
    
     //create request body
    private static String getRCEDRequestBody(String subscriberId, String policyNumber, String sourceCode)
    {
        String requestBody='';
        
        System.debug('@@ACET_RCEDServiceWS@@ subscriberID: '+subscriberId+ ' ,policyNumber: '+ policyNumber + ' ,sourceCode: '+sourceCode );
        String cesCustomerName = '';
        ADBLoyaltyRequestWrapper loyaltyRequest = new ADBLoyaltyRequestWrapper();
        loyaltyRequest.readInput  = new ADBLoyaltyRequestWrapper.readInput();
        loyaltyRequest.readInput.controlModifiers = new ADBLoyaltyRequestWrapper.ControlModifiers();
        loyaltyRequest.readInput.controlModifiers.cdbSystemParameters = new ADBLoyaltyRequestWrapper.CdbSystemParameters();
        loyaltyRequest.readInput.controlModifiers.ndbSystemParameters = new ADBLoyaltyRequestWrapper.NdbSystemParameters();
        loyaltyRequest.readInput.controlModifiers.cdbSystemParameters.applicationId = 'ACT';
        loyaltyRequest.readInput.controlModifiers.cdbSystemParameters.roleId = 'ACT';
        loyaltyRequest.readInput.controlModifiers.ndbSystemParameters.platformId = '';
        loyaltyRequest.readInput.controlModifiers.ndbSystemParameters.projectId = '';
        loyaltyRequest.readInput.controlModifiers.requestCodeDescriptionLookup = 'false';
        loyaltyRequest.readInput.controlModifiers.requestProviderDemographic = 'false';
        loyaltyRequest.readInput.controlModifiers.requestTopsEligibilityInformation = 'false';
        loyaltyRequest.readInput.controlModifiers.requestWrittenLanguagePreference = 'false';
        loyaltyRequest.readInput.searchId = subscriberId;
        loyaltyRequest.readInput.policyNumber = policyNumber;
        loyaltyRequest.readInput.sourceCode = sourceCode;
        loyaltyRequest.readInput.requestDemographic = '';
        loyaltyRequest.readInput.requestHealthServices = '';
        loyaltyRequest.readInput.requestFamilyLastUpdateDate = '';
        loyaltyRequest.readInput.requestEmail = '';
        loyaltyRequest.readInput.blsEligibilityInd = 'N';
        loyaltyRequest.readInput.requestCamsDemographic = '';
        loyaltyRequest.readInput.requestExpandedCoverageTimelines = '';
        loyaltyRequest.readInput.requestPrimeLifeAndDisability = '';
        loyaltyRequest.readInput.requestMemberPopulation = '';

        if(sourceCode == 'CS'){
            loyaltyRequest.readInput.asOfDate = System.now().format('YYYY-MM-dd');
            loyaltyRequest.readInput.requestFamilyOrIndividual = 'Family';
            loyaltyRequest.readInput.requestCoverageTimeline = 'CURRENT';
            loyaltyRequest.readInput.requestVendorAndCalendar = 'Y';
        	loyaltyRequest.readInput.requestHealthCoverage = 'ALL';
        }
        else{
            loyaltyRequest.readInput.asOfDate = '';
            loyaltyRequest.readInput.requestFamilyOrIndividual = '';
            loyaltyRequest.readInput.requestCoverageTimeline = '';
        } 
        
        object objResponse = loyaltyRequest;
        requestBody = JSON.serialize(objResponse);
       
        system.debug('ACET_RCEDServiceWS : reqBody:: '+requestBody);
        
        return requestBody;
        
    }
    
}