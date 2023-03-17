public class SAEPolicyDetailsController {
    
    public class SearchResultWrapper{
        @AuraEnabled public SAEPolicyDetailsResult resultWrapper {get;set;}
    }

    @AuraEnabled
    public static ACET_SAECalloutResult getMarketTypeCode(String strMarketType, String strSourceCode, String strRequestBody) {
        String strMarketTypeValue = '';
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        if(!strSourceCode.equalsIgnoreCase('CS')) {
            calloutResult.statusCode = 200;
            calloutResult.Response = strMarketTypeValue;
            return calloutResult;
        }

        List<String> lstStringToCompare = new List<String>{'eligible','engaged'};
        ACETWSCalloutResult objResponse = ACET_SNIWebService.getSNIDetails(strRequestBody);

        if(objResponse != null && objResponse.Response != null) {
            strMarketTypeValue = String.Valueof(objResponse.Response);
        }

        List<SAE_Market_Type_Code__mdt> lstMarketTypeCodes  = [Select id, Market_Type_Code__c, Market_Type_Code_Display_Name__c from SAE_Market_Type_Code__mdt Where Market_Type_Code__c = :strMarketType];
        if(lstMarketTypeCodes.isEmpty() == false) {
            if(String.isNotBlank(lstMarketTypeCodes[0].Market_Type_Code_Display_Name__c) && String.isNotBlank(strMarketTypeValue)) {
                strMarketTypeValue = strMarketTypeValue + ', ' + lstMarketTypeCodes[0].Market_Type_Code_Display_Name__c;
            } else if(String.isNotBlank(lstMarketTypeCodes[0].Market_Type_Code_Display_Name__c) && String.isBlank(strMarketTypeValue)){
                strMarketTypeValue = lstMarketTypeCodes[0].Market_Type_Code_Display_Name__c;
            } else if(String.isBlank(lstMarketTypeCodes[0].Market_Type_Code_Display_Name__c) && String.isNotBlank(strMarketTypeValue)) {
                strMarketTypeValue = strMarketTypeValue;
            }
        }
        calloutResult.statusCode = objResponse.statusCode;
        calloutResult.Response = strMarketTypeValue;
        System.debug('calloutResult::'+calloutResult);
        return calloutResult;
    }
    //start Raj
	@AuraEnabled(cacheable=true)
    public static PolicyAddrWrap getPolicyAddress(String transactionId){
        String responseStr = '';
         system.debug('transactionId PolicyAddrWrap'+transactionId);
        PolicyAddrWrap policyaddresswp = new PolicyAddrWrap();
        ACETWSCalloutResultAddress CalloutResult = null;
        ACET_AddressFillingWS claimServiceadd = new ACET_AddressFillingWS();
        system.debug('transactionId PolicyAddrWrap1');
        if(transactionId != null || transactionId!=''){
             system.debug('transactionId PolicyAddrWrap2');
            CalloutResult = claimServiceadd.getClaimAddressWS(transactionId);
            System.debug('CalloutAddressResult is:'+CalloutResult);
            policyaddresswp.city= CalloutResult.city;
            policyaddresswp.state= CalloutResult.state;
            policyaddresswp.street1= CalloutResult.street1;
            policyaddresswp.street2= CalloutResult.street2;
            policyaddresswp.zip= CalloutResult.zip;
            policyaddresswp.zip4= CalloutResult.zip4;
            policyaddresswp.originalEffectiveDate=CalloutResult.originalEffectiveDate;
        }
       
      return policyaddresswp;  
    }

    

    
    @AuraEnabled(cacheable=true)
    public static SearchResultWrapper getPolicyData(String transactionId){
        SAEPolicyDetailsResult resultwrap = new SAEPolicyDetailsResult(); 
        SAEPolicyDetailsResult.policyResults policyResultwrap = new SAEPolicyDetailsResult.policyResults(); 
        system.debug('transactionId::'+transactionId);
        SAEExtendedCoverageWS policyDetailsWS = new SAEExtendedCoverageWS();
        ACETWSCalloutResult CalloutResult = null;
        
        CalloutResult = policyDetailsWS.getPolicyWS(transactionId);
        if (CalloutResult.Success)
        {   
            //policyResultwrap= (SAEPolicyDetailsResult.policyResults)CalloutResult.Response;
            resultwrap= (SAEPolicyDetailsResult)CalloutResult.Response;
            //resultwrap= (SAEPolicyDetailsResult)CalloutResult.Response;
            System.debug('resultwrap::: ' + resultwrap);
            System.debug('policyResultwrap::: ' + resultwrap.policyRes);
            
        } 
        else
        {
            
        }           
        
        
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        system.debug('dataWrap:::'+dataWrap);
        return dataWrap;
    }    

    //US2646403
    @AuraEnabled
    public static RCEDResponseWrap call_RCED_API(String subscriberId, String policyNumber, String sourceCode){

        System.debug('@@SAEPolicyDetailsController@@ subscriberID: '+subscriberId+ ' ,policyNumber: '+ policyNumber + ' ,sourceCode: '+sourceCode );
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
         //US2770009
        RCEDResponseWrap rcedResponseWrpRes = get_RCED_API(loyaltyRequest, 'ADBLoyaltyEndpoint',
        'ADBStargateDashboardTokenParams', 'Eligibility', 'ACET');
         //US2770009
        /*if(loyaltyResponseWrapper!= null && loyaltyResponseWrapper.readResult != null && loyaltyResponseWrapper.readResult.readOutput != null){
            ADBLoyaltyResponseWrapper.ReadResult rs= loyaltyResponseWrapper.readResult;
           if(!rs.readOutput.eligibilities.isEmpty() && rs.readOutput.eligibilities[0].subscriberDetail != null
              && rs.readOutput.eligibilities[0].subscriberDetail.eligibility != null
              && rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics != null){
                  cesCustomerName = rs.readOutput.eligibilities[0].subscriberDetail.eligibility.demographics.cesCustomerName;
              }
       }*/

       return rcedResponseWrpRes;

    }

    //US2646403
    public static RCEDResponseWrap get_RCED_API(ADBLoyaltyRequestWrapper loyaltyRequest, String endPoint,
    String serviceName, String metadataType, String actor){

        String topsOrigCoverageEffectiveDate = '';
        String strgtToken ='';
        ADBLoyaltyResponseWrapper loyaltyResponseWrapper;

        RCEDResponseWrap rcedrRespWrap=new RCEDResponseWrap();
        try {

            if(!Test.isRunningTest()){
                strgtToken  = ADBWebService.generateTokenbyMetadata(serviceName, metadataType);
            }
            //US2770009
            String epoint=(!Test.isRunningTest())?ADBWebService.getEndpoint(endPoint):'RCEDS';
            String method = 'POST';

            Map<String, String> headers = new map<String, String> {'Authorization' => 'Bearer ' + strgtToken, 'Content-Type' => 'application/json', 'Actor' => actor};
            String serializedBody = JSON.serialize(loyaltyRequest);
            HttpResponse response = ADBWebService.sendRequest(serializedBody, headers, epoint, method);
			System.debug('serializedBody: ' +  serializedBody);
            System.debug('headers: ' +  headers);
            System.debug('epoint: ' +  epoint);
            System.debug('method: ' +  method);
            //US2770009
            if(response.getStatusCode() == 200)
            {
                System.debug('response: ' +  response.getBody());
                loyaltyResponseWrapper = (ADBLoyaltyResponseWrapper) JSON.deserialize(response.getBody(), ADBLoyaltyResponseWrapper.class);

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

                        IPAMarketInputs ipaInput=new IPAMarketInputs();
                        ipaInput.appName='acet';
                        ipaInput.marketNumber=pcp.marketSite;
                        ipaInput.marketType=pcp.marketType;
                        ipaInput.ipa=pcp.ipa;

                        IPAMarketResponseWrap ipaResponse= call_IPA_MarketAssociation_API(ipaInput);
                        if(ipaResponse !=null){
                            rcedrRespWrap.ipaMarketRes=ipaResponse;
                        }



                    }
                    else{

                        PCP pcp = new PCP();
                        pcp.ipa = '--';
                        pcp.marketType = '--';
                        pcp.marketSite = '--';
                        rcedrRespWrap.pcp = pcp;
                        rcedrRespWrap.statusCode=response.getStatusCode();

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
                    //Ketki pcp from RCED end
                }
                else
                {
                    rcedrRespWrap.groupName = '--';
                    rcedrRespWrap.statusCode=response.getStatusCode();

                }
            }
            else if(response.getStatusCode()==404)
            {
                System.debug('SAEPolicyDetailsController.getLoyaltyDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
                rcedrRespWrap.statusCode=response.getStatusCode();
                rcedrRespWrap.groupName='--';
            }
            else if(response.getStatusCode()==400 || response.getStatusCode()==500)
            {
                System.debug('SAEPolicyDetailsController.getLoyaltyDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
                rcedrRespWrap.statusCode=response.getStatusCode();
                rcedrRespWrap.message='Unexpected error occurred. Please try again. If problem persists contact help desk.';
            }
            else
            {
                System.debug('SAEPolicyDetailsController.getLoyaltyDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
                rcedrRespWrap.statusCode=response.getStatusCode();
                rcedrRespWrap.message='Unexpected error occurred. Please try again. If problem persists contact help desk.';
            }
        }catch(Exception e)
        {
            System.debug('SAEPolicyDetailsController.getLoyaltyDetails Exception ::' + e.getMessage());
            rcedrRespWrap.statusCode=999;
            rcedrRespWrap.message='Exception -->'+e.getMessage();
            rcedrRespWrap.message='Unexpected error occurred. Please try again. If problem persists contact help desk.';
        }
        return rcedrRespWrap;
    }

    //ketki - 5/21 - code optimization to call rced using new framework
    @AuraEnabled
    public static RCEDResponseWrap call_RCED(String subscriberId, String policyNumber, String sourceCode){
       RCEDResponseWrap result= ACET_RCEDServiceWS.call_RCED(subscriberId,policyNumber,sourceCode);
       System.debug(' @@SAEPolicyDetailsController : response ::'+result);
       return result;
    }
     //ketki - 5/21 - code optimization to call rced using new framework
    @AuraEnabled
    public static IPAMarketResponseWrap call_IPA_MarketAssociation_API(IPAMarketInputs ipaInputs){
        IPAMarketResponseWrap ipaMRespWrap=new IPAMarketResponseWrap();
        try{
             ACETIPAMarketAssociationWS ipaMarketAss=new ACETIPAMarketAssociationWS();
             ACETWSCalloutResult CalloutResult = ipaMarketAss.call_IPA_MarketAssociation_API(ipaInputs);
             system.debug('CalloutResult***'+CalloutResult);
             if(CalloutResult.statusCode ==200){
                ACETIPAMarketAssociationResponseWrapper fullresult=new ACETIPAMarketAssociationResponseWrapper();
                fullresult = (ACETIPAMarketAssociationResponseWrapper) CalloutResult.Response;
                system.debug('**ipa service response**'+fullresult);
                 if(fullresult.SvcResponse.size() >0 && fullresult.SvcResponse[0].marketIpa != null){
                     ipaMRespWrap.utilizationManagementDelegateIndicator=fullresult.SvcResponse[0].marketIpa.utilizationManagementDelegateIndicator;
                     ipaMRespWrap.financialRiskDelegateIndicator= fullresult.SvcResponse[0].marketIpa.financialRiskDelegateIndicator;
                     ipaMRespWrap.claimAdminDelegateIndicator= fullresult.SvcResponse[0].marketIpa.claimAdminDelegateIndicator;
                     ipaMRespWrap.providerCredentialDelegateIndicator=fullresult.SvcResponse[0].marketIpa.providerCredentialDelegateIndicator;
                     ipaMRespWrap.mktIPAName=fullresult.SvcResponse[0].marketIpa.mktIPAName;

                 }
             }
        }catch(Exception e){
        	System.debug('exception::'+e.getStackTraceString());
   		}
        return ipaMRespWrap;
    }


    //US2770009
    Public Class RCEDResponseWrap
    {
       @AuraEnabled public String message {get;set;}
       @AuraEnabled public Integer statusCode {get;set;}
       @AuraEnabled public String groupName {get;set;}
       //Ketki pcp from RCED begin
       @AuraEnabled public PCP pcp {get;set;}
       @AuraEnabled public Vendor vendor {get;set;}
       @AuraEnabled public IPAMarketResponseWrap ipaMarketRes {get;set;}
        @AuraEnabled public Demographics demRes {get;set;}
       //Ketki pcp from RCED end

    }

    Public Class PCP{

       @AuraEnabled public String ipa {get;set;}
       @AuraEnabled public String marketType {get;set;}
       @AuraEnabled public String marketSite {get;set;}
    }
    Public Class Vendor{
       @AuraEnabled public String vendorBenefitOptionTypeCode {get;set;}
        @AuraEnabled public String healthServiceProductCode {get;set;}
       @AuraEnabled public String vendorStartDate {get;set;}
       @AuraEnabled public String vendorEndDate {get;set;}
    }
    Public Class IPAMarketInputs {
        @AuraEnabled public String appName {get;set;}
        @AuraEnabled public String marketNumber {get;set;}
        @AuraEnabled public String marketType {get;set;}
        @AuraEnabled public String ipa {get;set;}
    }

    Public Class IPAMarketResponseWrap
    {
        @AuraEnabled public String utilizationManagementDelegateIndicator{get;set;}
        @AuraEnabled public String financialRiskDelegateIndicator{get;set;}
        @AuraEnabled public String claimAdminDelegateIndicator{get;set;}
        @AuraEnabled public String providerCredentialDelegateIndicator{get;set;}
         @AuraEnabled public String mktIPAName{get;set;}
    }
    public class Demographics{
        @AuraEnabled public String topsOrigCoverageEffectiveDate {get;set;}
        @AuraEnabled public string retirementDate{get;set;}
        @AuraEnabled public String cesCustomerName{get;set;}
    }
        public static RCEDResponseWrap get_RCED_MockData(HttpResponse response){
                RCEDResponseWrap rcedrRespWrap=new RCEDResponseWrap();
                ADBLoyaltyResponseWrapper loyaltyResponseWrapper;
                if(response.getStatusCode() == 200){
                        System.debug('response: ' +  response.getBody());
                        loyaltyResponseWrapper = (ADBLoyaltyResponseWrapper) JSON.deserialize(response.getBody(), ADBLoyaltyResponseWrapper.class);

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
                            }
                            else
                            {
                                rcedrRespWrap.groupName = '--';
                                rcedrRespWrap.statusCode=response.getStatusCode();

                            }

                            if(!rs.readOutput.eligibilities.isEmpty() && rs.readOutput.eligibilities[0].vendors !=null && !rs.readOutput.eligibilities[0].vendors.isEmpty() && String.isNotBlank(String.valueOf(rs.readOutput.eligibilities[0].vendors)))
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
                        }
                        else
                        {
                            rcedrRespWrap.groupName = '--';
                            rcedrRespWrap.statusCode=response.getStatusCode();

                        }
                    }
                    else if(response.getStatusCode()==404)
                    {
                        System.debug('SAEPolicyDetailsController.getLoyaltyDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
                        rcedrRespWrap.statusCode=response.getStatusCode();
                        rcedrRespWrap.groupName='--';
                    }
                    else if(response.getStatusCode()==400 || response.getStatusCode()==500)
                    {
                        System.debug('SAEPolicyDetailsController.getLoyaltyDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
                        rcedrRespWrap.statusCode=response.getStatusCode();
                        rcedrRespWrap.message='Unexpected error occurred. Please try again. If problem persists contact help desk.';
                    }
                    else
                    {
                        System.debug('SAEPolicyDetailsController.getLoyaltyDetails Error ::' + response.getStatusCode() +'-'+ response.getBody());
                        rcedrRespWrap.statusCode=response.getStatusCode();
                        rcedrRespWrap.message='Unexpected error occurred. Please try again. If problem persists contact help desk.';
                    }
                return rcedrRespWrap;
     }
    public class PolicyAddrWrap
    {
        @AuraEnabled public String city {get;set;}
    	@AuraEnabled public String state {get;set;}
    	@AuraEnabled public String street1 {get;set;}
    	@AuraEnabled public String street2 {get;set;}
    	@AuraEnabled public String zip {get;set;}
    	@AuraEnabled public String zip4 {get;set;}
		@AuraEnabled public String originalEffectiveDate {get;set;}
    }


}