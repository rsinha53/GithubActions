public class ACETLGT_GetHCOWebservice extends ACETWebservice
{
    public String returningFromService;
        
    public override void GetEndpoint()  {
        GetEndpointDetail('getHCOEndpoint');
    }
    public ACETLGT_GetHCOWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String ProviderId, String TaxID, String providerTINTypeCode, String addressId, String addressTypeCode)   {
        ProviderId = String.IsNotBlank(ProviderId) ? ProviderId : '';
        TaxID = String.IsNotBlank(TaxID) ? TaxID : '';
        providerTINTypeCode = String.IsNotBlank(providerTINTypeCode) ? providerTINTypeCode : '';
        addressId = String.IsNotBlank(addressId) ? addressId : '';
        addressTypeCode = String.IsNotBlank(addressTypeCode) ? addressTypeCode : '';        
        RequestParameters = new List<String>{ProviderId,TaxID,providerTINTypeCode, 
                addressId, addressTypeCode};
        RequestBody = GetRequestBody('ACETLGT_GetHCORequestJSON', RequestParameters);         
    }
    
    private ACETLGT_ProviderLookupDetailResult ParseSuccessResponse(HttpResponse Response)  {
        ACETLGT_ProviderLookupDetailResult providerDetail = new ACETLGT_ProviderLookupDetailResult();
        ACETGetHCOJSON2Apex ACTPDGIJSON2Apex = (ACETGetHCOJSON2Apex)JSON.deserialize(Response.getBody(), ACETGetHCOJSON2Apex.class);
        if (ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResponse != null) {
             if (ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResponse.medicalHealthcareOrganization!= null) {
                    ACETGetHCOJSON2Apex.medicalHealthcareOrganization generalInformation = ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResponse.medicalHealthcareOrganization;
                    if (generalInformation != null) {
                        providerDetail.generalInfo.lastName = String.isNotBlank(generalInformation.hco.providerName) ? generalInformation.hco.providerName : '';
                        providerDetail.generalInfo.providerID = String.isNotBlank(generalInformation.hco.providerId) ? generalInformation.hco.providerId : '';
                        providerDetail.generalInfo.hcoTypeCode = String.isNotBlank(generalInformation.hco.hcoTypeCode) ? generalInformation.hco.hcoTypeCode : '';
                        providerDetail.generalInfo.taxId = String.isNotBlank(generalInformation.providerTIN.id) ? generalInformation.providerTIN.id : '';
                        providerDetail.generalInfo.providerTINOwner = String.isNotBlank(generalInformation.providerTIN.owner) ? generalInformation.providerTIN.owner : '';
                        providerDetail.generalInfo.npi = String.isNotBlank(generalInformation.npi[0].hcoNPI) ? generalInformation.npi[0].hcoNPI : '';
                        if(String.isNotBlank(generalInformation.address.facilityType) && generalInformation.address.facilityType== 'FSF' ) {
                                providerDetail.generalInfo.PFS = 'Yes';                        
                        } else {
                            providerDetail.generalInfo.PFS = 'No'; 
                        }
                        if (generalInformation.PatientAgeLimit != null && generalInformation.PatientAgeLimit.size() > 0) {
                           providerDetail.generalInfo.patientAgeRange = String.isNotBlank(generalInformation.PatientAgeLimit[0].beginAgeNumber) ? generalInformation.PatientAgeLimit[0].beginAgeNumber : '';
                           providerDetail.generalInfo.patientAgeRange += String.isNotBlank(generalInformation.PatientAgeLimit[0].endAgeNumber) ? ' - ' + generalInformation.PatientAgeLimit[0].endAgeNumber : '';
                        }
                        List<ACETGetHCOJSON2Apex.Specialty> practiceInformationLst = generalInformation.specialty;
                        if (practiceInformationLst != null && !practiceInformationLst.isEmpty()) {
                            for (Integer index = 0; index < practiceInformationLst.size(); index++) {
                                ACETLGT_ProviderLookupDetailResult.ACETProviderSpeciality specialityObj = new ACETLGT_ProviderLookupDetailResult.ACETProviderSpeciality();
                                if(specialityObj != null){
                                   specialityObj.primarySpeciality = String.isNotBlank(practiceInformationLst[index].primarySpecialtyIndicator) ? practiceInformationLst[index].primarySpecialtyIndicator : 'N';
                                   specialityObj.speciality = String.isNotBlank(practiceInformationLst[index].typeDescription) ? practiceInformationLst[index].typeDescription : '';
                                }
                                 if (String.isNotBlank(practiceInformationLst[index].statusCode)) {
                                   specialityObj.statusCode = practiceInformationLst[index].statusCode;
                               }else {
                                  specialityObj.statusCode = '';
                               }
                                providerDetail.specialities.add(specialityObj);
                            }
                        }
                        List<ACETGetHCOJSON2Apex.tpsm> tpsmLst = generalInformation.tpsm;    
                        if (tpsmLst != null && !tpsmLst.isEmpty()) {                             
                            for (ACETGetHCOJSON2Apex.Tpsm Platinum :tpsmLst) {
                                if (Platinum != null) {
                                    if (Platinum.code == '99Z') {
                                        providerDetail.generalInfo.platinumProvider = 'No';                                        
                                    } else if (String.isBlank(Platinum.code)) {
                                        providerDetail.generalInfo.platinumProvider = '';
                                    } else {
                                        providerDetail.generalInfo.platinumProvider = 'Yes - ' +  Platinum.code;   
                                    }
                                }
                            }    
                        }
                        List<ACETGetHCOJSON2Apex.NPI> npisLst = generalInformation.npi;    
                        if (npisLst != null && !npisLst.isEmpty()) {
                            for (Integer index =0; index < npisLst.size(); index++) {
                                ACETLGT_ProviderLookupDetailResult.NPI npiObj = new ACETLGT_ProviderLookupDetailResult.NPI(); 
                                npiObj.npiName = npisLst[index].hcoNPI;
                                providerDetail.npis.add(npiObj);
                            }
                        }
                    }
                }
             }
        return providerDetail;
    }
     public ACETWSCalloutResult init(String ProviderId, String TaxID, String providerTINTypeCode, String addressId, String addressTypeCode, 
                String returningFrom) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETLGT_ProviderLookupDetailResult providerDetail = new ACETLGT_ProviderLookupDetailResult();
        this.returningFromService = returningFrom;
       system.debug(LoggingLevel.INFO, 'returningFrom*** ' + returningFrom);
        try {
		    GetEndpoint();
		    GetRequestBody(ProviderId, TaxID, providerTINTypeCode, addressId, addressTypeCode);
            //HttpResponse Response = GetHttpResponse(HttpRequestLabel);
			HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200) {
                ProviderDetail = ParseSuccessResponse(Response);
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ProviderDetail; 
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);  
            }    
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex);
            system.debug(ex.getlinenumber());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
    
    
    
}