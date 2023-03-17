public class ACETGetMedProvAgreementWebservice extends ACETWebservice
{
    public override void GetEndpoint()  {
        GetEndpointDetail('GetMedProvAgrEndpoint');
    }
    public ACETGetMedProvAgreementWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String providerId, String providerTIN, String providerTINTypeCode, String addressId, 
                String addressTypeCode, String contractHeaderId, String contractDetailId, String networkId, 
                String networkSchedule, String benefitPlanId)   {
        RequestBody = GetRequestFormatByName('getMedicalProviderAgreementRequestJSON');
        RequestBody = (String.isNotBlank(providerId)) ? RequestBody.replace('@@providerId@@',providerId) : RequestBody.replace('@@providerId@@', '');
        RequestBody = (String.isNotBlank(providerTIN)) ? RequestBody.replace('@@providerTIN@@',providerTIN) : RequestBody.replace('@@providerTIN@@', '');
        RequestBody = (String.isNotBlank(providerTINTypeCode)) ? RequestBody.replace('@@providerTINTypeCode@@',providerTINTypeCode) : RequestBody.replace('@@providerTINTypeCode@@', '');
        RequestBody = (String.isNotBlank(addressId)) ? RequestBody.replace('@@addressId@@',addressId) : RequestBody.replace('@@addressId@@', '');
        RequestBody = (String.isNotBlank(addressTypeCode)) ? RequestBody.replace('@@addressTypeCode@@',addressTypeCode) : RequestBody.replace('@@addressTypeCode@@', '');
        RequestBody = (String.isNotBlank(contractHeaderId)) ? RequestBody.replace('@@contractHeaderId@@',contractHeaderId) : RequestBody.replace('@@contractHeaderId@@', '');
        RequestBody = (String.isNotBlank(contractDetailId)) ? RequestBody.replace('@@contractDetailId@@',contractDetailId) : RequestBody.replace('@@contractDetailId@@', '');
        RequestBody = (String.isNotBlank(networkId)) ? RequestBody.replace('@@networkId@@',networkId) : RequestBody.replace('@@networkId@@', '');
        RequestBody = (String.isNotBlank(networkSchedule)) ? RequestBody.replace('@@networkSchedule@@',networkSchedule) : RequestBody.replace('@@networkSchedule@@', '');
        RequestBody = (String.isNotBlank(benefitPlanId)) ? RequestBody.replace('@@benefitPlanId@@',benefitPlanId) : RequestBody.replace('@@benefitPlanId@@', '');
    }
    
    public Boolean isActiveContract(String EffectiveDate, String EndDate){
        if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
        
        Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
        Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
        
        return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
    }
    
    private ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement ParseSuccessResponse(String ResponseBody)  {
        ACETGetMedProvAgreementJSON2Apex ACETGMPAJSON2Apex = (ACETGetMedProvAgreementJSON2Apex)JSON.deserialize(ResponseBody, ACETGetMedProvAgreementJSON2Apex.class);
        ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement MPA = ACETGMPAJSON2Apex.getMedicalProviderAgreementResponse.medicalProviderAgreement;
        if(MPA.contractDetail != null) {
            if (MPA.contractDetail.statusCode == 'A') {
                MPA.contractDetail.statusCode = 'Active';
            } else  {
                MPA.contractDetail.statusCode = 'Inactive';
            }
             MPA.contractDetail.effectiveDate = ChangeDateFormat(MPA.contractDetail.effectiveDate);
             MPA.contractDetail.cancelDate = ChangeDateFormat(MPA.contractDetail.cancelDate);
             MPA.contractDetail.processOrderNumber = String.isNotBlank(MPA.contractDetail.processOrderNumber) ? MPA.contractDetail.processOrderNumber : '';
        }
        if(MPA.Key != null) {
            MPA.Key.contractDetailId = String.isNotBlank(MPA.Key.contractDetailId)? MPA.Key.contractDetailId : '';
        }
        MPA.network.effectiveDate = ChangeDateFormat(MPA.network.effectiveDate);
        MPA.network.cancelDate = ChangeDateFormat(MPA.network.cancelDate);
        MPA.pricingSet.effectiveDate = ChangeDateFormat(MPA.pricingSet.effectiveDate);
        //US3284134 - Filing limit changes - Added by Abhinav
        List<ACETGetMedProvAgreementJSON2Apex.FilingLimit> activeProvContList = new List<ACETGetMedProvAgreementJSON2Apex.FilingLimit>();
        List<ACETGetMedProvAgreementJSON2Apex.FilingLimit> activeContList = new List<ACETGetMedProvAgreementJSON2Apex.FilingLimit>();
        List<ACETGetMedProvAgreementJSON2Apex.FilingLimit> finalFilingList = new List<ACETGetMedProvAgreementJSON2Apex.FilingLimit>();
        String effDate, endDate;
        for (ACETGetMedProvAgreementJSON2Apex.FilingLimit FL :MPA.filingLimit) {
            ACETGetMedProvAgreementJSON2Apex.FilingLimit item = new ACETGetMedProvAgreementJSON2Apex.FilingLimit();
            effDate = ChangeDateFormat(FL.effectiveDate);
            endDate = ChangeDateFormat(FL.cancelDate);
            if(isActiveContract(effDate,endDate)){
                item = FL;
                if (item.typeCode== 'A') {
                    item.typeCode= 'Allowed';            
                }
                else if (item.typeCode== 'P') {
                    item.typeCode= 'Paid';            
                } else  {
                    item.typeCode= 'Billed';
                }
                item.effectiveDate = effDate;
                item.cancelDate = endDate; 
                if(FL.assignmentLevel == 'providerContract'){
                    activeProvContList.add(item);
                    break;
                }else if(FL.assignmentLevel == 'contract'){
                    activeContList.add(item);
                }
            }
        }
        system.debug('****Filing Provider contract'+activeProvContList+'****Filing contract'+activeContList);
        
        if(!activeProvContList.isEmpty())
            finalFilingList.addAll(activeProvContList);
        else
            finalFilingList.addAll(activeContList);
        
        MPA.filingLimit = finalFilingList;
        system.debug('******Final Filing limit'+MPA.filingLimit);
        
        for (ACETGetMedProvAgreementJSON2Apex.PricingSchedule PS :MPA.pricingSchedule) {
            PS.assignmentEffectiveDate = ChangeDateFormat(PS.assignmentEffectiveDate);
            PS.assignmentCancelDate = ChangeDateFormat(PS.assignmentCancelDate);    
        }
        
        return MPA;
    }
    
    public Continuation StartRequest(String providerId, String providerTIN, String providerTINTypeCode, String addressId, String addressTypeCode, 
                String contractHeaderId, String contractDetailId, String networkId, String networkSchedule, String benefitPlanId, 
                String CallbackMethodName, Continuation oContinuation)
    {
        system.debug(LoggingLevel.INFO, 'providerId: ' + providerId +', providerTIN: ' + providerTIN + ', providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'addressId: ' + addressId +', addressTypeCode: ' + addressTypeCode + ', contractHeaderId: ' + contractHeaderId);
        system.debug(LoggingLevel.INFO, 'contractDetailId: ' + contractDetailId + ', networkId: ' + networkId + ', networkSchedule: ' + networkSchedule);
        system.debug(LoggingLevel.INFO, 'benefitPlanId: ' + benefitPlanId+ ', CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        
        GetEndpoint();
        GetRequestBody(providerId, providerTIN, providerTINTypeCode, addressId, addressTypeCode, contractHeaderId, contractDetailId, 
                    networkId, networkSchedule, benefitPlanId);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
             if (Response.getStatusCode() == 200) {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ParseSuccessResponse(Response.getBody());
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
            }   
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }

        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
    
    public ACETWSCalloutResult GetProvider(String providerId, String providerTIN, String providerTINTypeCode, String addressId, String addressTypeCode, 
                String contractHeaderId, String contractDetailId, String networkId, String networkSchedule, String benefitPlanId) {
        system.debug(LoggingLevel.INFO, 'providerId: ' + providerId +', providerTIN: ' + providerTIN + ', providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'addressId: ' + addressId +', addressTypeCode: ' + addressTypeCode + ', contractHeaderId: ' + contractHeaderId);
        system.debug(LoggingLevel.INFO, 'contractDetailId: ' + contractDetailId + ', networkId: ' + networkId + ', networkSchedule: ' + networkSchedule);
        system.debug(LoggingLevel.INFO, 'benefitPlanId: ' + benefitPlanId);
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        
        try {
            GetEndpoint();
            GetRequestBody(providerId, providerTIN, providerTINTypeCode, addressId, addressTypeCode, contractHeaderId, contractDetailId, 
                    networkId, networkSchedule, benefitPlanId);
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200) {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ParseSuccessResponse(Response.getBody());
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);        
            }
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Exception in GetProvider. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }

        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
}