/*
********************************************
* @ Author      : Vishnu Kasu
* @ Create Date: May-08-2020
* @ Description: to get all the Policy Details using extended service callout. 
**
*********************************************
*/
////US2579637
public class ACET_ExtendedServiceController {
	
	Public ACETWSCalloutResult extendedServiceCallout(String transactionId)
	{
		ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            String responseStr = '';
            HttpResponse response;
            Map <String, String> requestParamsMap = new Map <String, String> (); //US3076045 - Avish

            /*** US3076045 - Avish **/
            requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkExtendedCoverage';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;
            response = wsCallOutFW.getResponse();
            //US3076045 - Ends
			
			calloutResult.statusCode= response.getStatusCode();
			responseStr=response.getBody();

			ExtendedServiceWrapper extendWrap = new ExtendedServiceWrapper();			

			if(calloutResult.statusCode == 200)
			{				
				extendWrap =  getPolicyResponse(responseStr);
				
				calloutResult.Response=extendWrap;
				calloutResult.Success=true;
				
			}
			else if(SAEConstants.RESPONSECODE_FAULTCODE_MAP.containsKey(calloutResult.statusCode) && String.isNotBlank(responseStr))
			{
				String faultCode = '';
        		String statusMessage = '';
        		Map<String, Object> httpResponseJSON=(Map<String, Object>)JSON.deserializeUntyped(responseStr);
				faultCode = (String)httpResponseJSON.get('faultCode');
				extendWrap.faultCode=faultCode;//error handling UI Change
				calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
				if(faultCode != null) 
				{
					for(String str:SAEConstants.RESPONSECODE_FAULTCODE_MAP.get(calloutResult.statusCode))
					{
						if(str.containsIgnoreCase(faultCode))
						{
							calloutResult.Message=getErrorMessage(str);
							break;
						}
					}
				}
			}
			else if (SAEConstants.viewAuthStatusCodeErrorMSG.containsKey(calloutResult.statusCode))
			{
					calloutResult.Message = SAEConstants.viewAuthStatusCodeErrorMSG.get(response.getStatusCode());
			}
			else
			{
				calloutResult.Success = true;
				calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
			}
		}
		catch(exception e)
		{
			calloutResult.Success = true;
			calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            
            return calloutResult;
		}
        return calloutResult;
	}
    
    Public ExtendedServiceWrapper getPolicyResponse(String responseStr){
        ExtendedServiceWrapper extendWrap = new ExtendedServiceWrapper();
        PlanLevelBenefits plBenefits=new PlanLevelBenefits();
        
        //US2715295:MVP- Plan Benefits: Map Additional Accumulation Fields for Financial Section Implementation_Vishnu Kasu
        if(responseStr.contains('planLevelBenefits'))
        {
            plBenefits.isPlanLevelBenefits=true;
            
            Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
            
            Map<String, Object> planeLevelBenMap = (Map<String, Object>)policyMainMap.get('planLevelBenefits');
            plBenefits.copayMaxAmount=responseStr.contains('copayMaximumAmount')?SAEGetMemberProviderWebService.valueFormate(String.valueOf(planeLevelBenMap.get('copayMaximumAmount'))):0.00;
            plBenefits.cmbInnDeductInd=responseStr.contains('combinedInnDeductibleIndicator')?(String.isNotBlank(String.valueOf(planeLevelBenMap.get('combinedInnDeductibleIndicator')))?(String)planeLevelBenMap.get('combinedInnDeductibleIndicator'):''):'';
            plBenefits.cmbOonDeductInd=responseStr.contains('combinedOonDeductibleIndicator')?(String.isNotBlank(String.valueOf(planeLevelBenMap.get('combinedOonDeductibleIndicator')))?(String)planeLevelBenMap.get('combinedOonDeductibleIndicator'):''):'';
            plBenefits.cmbInnOopInd=responseStr.contains('combinedInnOopIndicator')?(String.isNotBlank(String.valueOf(planeLevelBenMap.get('combinedInnOopIndicator')))?(String)planeLevelBenMap.get('combinedInnOopIndicator'):''):'';
            plBenefits.cmbOonOopInd=responseStr.contains('combinedOonOopIndicator')?(String.isNotBlank(String.valueOf(planeLevelBenMap.get('combinedOonOopIndicator')))?(String)planeLevelBenMap.get('combinedOonOopIndicator'):''):'';
            plBenefits.crsApplyCopayInd=responseStr.contains('crossApplyCopayIndicator')?(String.isNotBlank(String.valueOf(planeLevelBenMap.get('crossApplyCopayIndicator')))?Integer.valueOf(planeLevelBenMap.get('crossApplyCopayIndicator')):0):0;
            plBenefits.crsApplyCoreInd=responseStr.contains('crossApplyCoreIndicator')?(String.isNotBlank(String.valueOf(planeLevelBenMap.get('crossApplyCoreIndicator')))?Integer.valueOf(planeLevelBenMap.get('crossApplyCoreIndicator')):0):0;
            plBenefits.crsApplyOopInd=responseStr.contains('crossApplyOopIndicator')?(String.isNotBlank(String.valueOf(planeLevelBenMap.get('crossApplyOopIndicator')))?Integer.valueOf(planeLevelBenMap.get('crossApplyOopIndicator')):0):0;
            plBenefits.medLifMaxAmt=responseStr.contains('medicalLifetimeMaximum')?SAEGetMemberProviderWebService.valueFormate(String.valueOf(planeLevelBenMap.get('medicalLifetimeMaximum'))):0.00;
            plBenefits.medLifMaxApplied=responseStr.contains('medicalLifetimeMaximumApplied')?SAEGetMemberProviderWebService.valueFormate(String.valueOf(planeLevelBenMap.get('medicalLifetimeMaximumApplied'))):0.00;
            plBenefits.medLifMaxRemain=responseStr.contains('medicalLifetimeMaximumRemaining')?SAEGetMemberProviderWebService.valueFormate(String.valueOf(planeLevelBenMap.get('medicalLifetimeMaximumRemaining'))):0.00;
            //US2774251
            plBenefits.medLifMaxPercent=SAEGetMemberProviderWebService.checkAndCall(plBenefits.medLifMaxAmt,plBenefits.medLifMaxRemain,plBenefits.medLifMaxApplied);
            
            if(plBenefits.medLifMaxAmt>0 && plBenefits.medLifMaxApplied>0 && plBenefits.medLifMaxRemain>0)
            {
                plBenefits.medLifMaxPercent=Double.valueOf((plBenefits.medLifMaxApplied/plBenefits.medLifMaxAmt)*100);
                plBenefits.medLifMaxPercent=plBenefits.medLifMaxPercent>0?plBenefits.medLifMaxPercent:0;
            }
            else{
                
                plBenefits.medLifMaxPercent=0;
                
            }
            System.debug('planeLevelBenMa'+plBenefits);
        }
        else
        {
            plBenefits.isPlanLevelBenefits=false;
            
            Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
            
            Map<String, Object> planeLevelBenMap = (Map<String, Object>)policyMainMap.get('planLevelBenefits');
            
            plBenefits.copayMaxAmount=0.00;
            plBenefits.cmbInnDeductInd='';
            plBenefits.cmbOonDeductInd='';
            plBenefits.cmbInnOopInd='';
            plBenefits.cmbOonOopInd='';
            plBenefits.crsApplyCopayInd=0;
            plBenefits.crsApplyCoreInd=0;
            plBenefits.crsApplyOopInd=0;
            plBenefits.medLifMaxAmt=0;
            plBenefits.medLifMaxApplied=0.00;
            plBenefits.medLifMaxRemain=0.00;
            plBenefits.medLifMaxPercent=0.00;
            
        }
        
        extendWrap.planLevelBenefitsRes=plBenefits;
        
        extendWrap.cobWrapper = (SAECOBWrapper)(new SAEGetCOBWebService().getCOBResult(responseStr));
        extendWrap.houseHoldWrapper = (SAEHouseHoldWrapper)(new SAEGetHouseHoldWebService().getHouseHoldResult(responseStr));
        
        ACET_ExtendedServiceController.SearchResultWrapper policyResultWrapper = new ACET_ExtendedServiceController.SearchResultWrapper();
        policyResultWrapper.resultWrapper = (SAEPolicyDetailsResult)(new SAEExtendedCoverageWS().getPolicyResult(responseStr));
        
        extendWrap.policyResultWrapper =  policyResultWrapper;
        
        return extendWrap;
    }
	
	 // Get ACET Error messages from metadata records
    public static String getErrorMessage(String errorCode){
        String errorMessage = '';
        AcetErrorMessage__mdt[] ErrorCodes = [ SELECT DeveloperName, Label, Error_Message__c, Message_Type__c
        FROM AcetErrorMessage__mdt WHERE Label = :errorCode ];
        if(ErrorCodes.size() > 0) {
            errorMessage = ErrorCodes[0].Error_Message__c;
        }
        return errorMessage;
	}
	
	public class SearchResultWrapper {
        @AuraEnabled public SAEPolicyDetailsResult resultWrapper {get;set;}
		@AuraEnabled public Integer statusCode {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public Boolean hasAccess {get;set;}
    }
	//US2715295:MVP- Plan Benefits: Map Additional Accumulation Fields for Financial Section Implementation_Vishnu Kasu
	public class PlanLevelBenefits {
        @AuraEnabled public Decimal copayMaxAmount {get;set;}
		@AuraEnabled public String cmbInnDeductInd {get;set;}
        @AuraEnabled public String cmbOonDeductInd {get;set;}
		@AuraEnabled public String cmbInnOopInd {get;set;}
        @AuraEnabled public String cmbOonOopInd {get;set;}
        @AuraEnabled public Integer crsApplyCopayInd {get;set;}
		@AuraEnabled public Integer crsApplyCoreInd {get;set;}
		@AuraEnabled public Integer crsApplyOopInd {get;set;}
		@AuraEnabled public Decimal medLifMaxAmt {get;set;}
		@AuraEnabled public Decimal medLifMaxApplied {get;set;}
		@AuraEnabled public Decimal medLifMaxRemain {get;set;}
		@AuraEnabled public Decimal medLifMaxPercent {get;set;}
		@AuraEnabled public Boolean isPlanLevelBenefits {get;set;}

    }

	//wrapper holds the all policy Wrapper
	public class ExtendedServiceWrapper 
	{
		@AuraEnabled public String faultCode {get;set;}
        @AuraEnabled public SAECOBWrapper cobWrapper {get;set;}
		@AuraEnabled public SAEHouseHoldWrapper houseHoldWrapper {get;set;}
		@AuraEnabled public SearchResultWrapper policyResultWrapper {get;set;}
		@AuraEnabled public PlanLevelBenefits planLevelBenefitsRes {get;set;}
	}
}