public class ACETLGT_GetMedProvAgreementWebservice extends ACETWebservice
{
    public override void GetEndpoint()  {
        GetEndpointDetail('GetMedProvAgrEndpoint');
    }
    public ACETLGT_GetMedProvAgreementWebservice() {
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
    
    private ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement ParseSuccessResponse(String ResponseBody)  {
        ACETLGT_GetMedProvAgreementJSON2Apex ACETGMPAJSON2Apex = (ACETLGT_GetMedProvAgreementJSON2Apex)JSON.deserialize(ResponseBody, ACETLGT_GetMedProvAgreementJSON2Apex.class);
        ACETLGT_GetMedProvAgreementJSON2Apex.MedicalProviderAgreement MPA = ACETGMPAJSON2Apex.getMedicalProviderAgreementResponse.medicalProviderAgreement;
        if (MPA.contractDetail.statusCode == 'A') {
            MPA.contractDetail.statusCode = 'Active';
        } else  {
            MPA.contractDetail.statusCode = 'Inactive';
        }
        
        MPA.contractDetail.effectiveDate = ChangeDateFormat(MPA.contractDetail.effectiveDate);
        MPA.contractDetail.cancelDate = ChangeDateFormat(MPA.contractDetail.cancelDate);
        MPA.network.effectiveDate = ChangeDateFormat(MPA.network.effectiveDate);
        MPA.network.cancelDate = ChangeDateFormat(MPA.network.cancelDate);
        MPA.pricingSet.effectiveDate = ChangeDateFormat(MPA.pricingSet.effectiveDate);
        //US3284134 - Filing limit changes - Added by Abhinav
        List<ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit> activeProvContList = new List<ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit>();
        List<ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit> activeContList = new List<ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit>();
        List<ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit> finalFilingList = new List<ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit>();
        String effDate, endDate;
        for (ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit FL :MPA.filingLimit) {
            ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit item = new ACETLGT_GetMedProvAgreementJSON2Apex.FilingLimit();
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
        
        for (ACETLGT_GetMedProvAgreementJSON2Apex.PricingSchedule PS :MPA.pricingSchedule) {
            PS.assignmentEffectiveDate = ChangeDateFormat(PS.assignmentEffectiveDate);
            PS.assignmentCancelDate = ChangeDateFormat(PS.assignmentCancelDate);    
        }
        
        return MPA;
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