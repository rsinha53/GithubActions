public class ACETGetHCOWebservice extends ACETWebservice
{
    public String returningFromService;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public ACETProviderUtility providerUtility = new ACETProviderUtility();
        
    public override void GetEndpoint()  {
        GetEndpointDetail('getHCOEndpoint');
    }
    public ACETGetHCOWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String ProviderId, String ProviderStatusCode, String ProviderTIN, String ProviderTINStatusCode, 
            String ProviderTINTypeCode, String AddressId, String AddressTypeCode)   {
        ProviderId = String.IsNotBlank(ProviderId) ? ProviderId : '';
        ProviderStatusCode = String.IsNotBlank(ProviderStatusCode) ? ProviderStatusCode : '';
        ProviderTIN = String.IsNotBlank(ProviderTIN) ? ProviderTIN : '';
        ProviderTINStatusCode = String.IsNotBlank(ProviderTINStatusCode) ? ProviderTINStatusCode : '';
        ProviderTINTypeCode = String.IsNotBlank(ProviderTINTypeCode) ? ProviderTINTypeCode : '';
        AddressId = String.IsNotBlank(AddressId) ? AddressId : '';
        AddressTypeCode = String.IsNotBlank(AddressTypeCode) ? AddressTypeCode : '';        
        RequestParameters = new List<String>{ProviderId, ProviderStatusCode, ProviderTIN, ProviderTINStatusCode, ProviderTINTypeCode, 
                AddressId, AddressTypeCode};
        RequestBody = GetRequestBody('ACETGetHCORequestJSON', RequestParameters);         
    }
    
    private ACETProviderDetailController.ACETProviderDetail ParseSuccessResponse(String ResponseBody, String providerTINOwner)  {
        ACETProviderDetailController.ACETProviderDetail providerDetail = new ACETProviderDetailController.ACETProviderDetail();
        ACETGetHCOJSON2Apex ACTPDGIJSON2Apex = (ACETGetHCOJSON2Apex)JSON.deserialize(ResponseBody, ACETGetHCOJSON2Apex.class);
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
                                ACETProviderDetailController.ACETProviderSpeciality specialityObj = new ACETProviderDetailController.ACETProviderSpeciality();
                                if(specialityObj != null){
                                   specialityObj.primarySpeciality = String.isNotBlank(practiceInformationLst[index].primarySpecialtyIndicator) ? practiceInformationLst[index].primarySpecialtyIndicator : 'N';
                                   specialityObj.speciality = String.isNotBlank(practiceInformationLst[index].typeDescription) ? practiceInformationLst[index].typeDescription : '';
                                }
                                 if (String.isNotBlank(practiceInformationLst[index].statusCode)) {
                                   specialityObj.statusCode = practiceInformationLst[index].statusCode == 'A' ? 'active' : 'inactive';
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
                                ACETProviderDetailController.NPI npiObj = new ACETProviderDetailController.NPI(); 
                                npiObj.npiName = npisLst[index].hcoNPI;
                                providerDetail.npis.add(npiObj);
                            }
                        }
                    }
                }
             }
        return providerDetail;
    }

    
    public Continuation StartRequest(String providerId, String providerTIN, String providerStatusCode, String providerTINStatusCode, 
            String providerTINTypeCode, String addressId, String addressTypeCode, String returningFrom, 
            String CallbackMethodName, Continuation oContinuation)
    {
        system.debug(LoggingLevel.INFO, 'providerId1: ' + providerId +', providerStatusCode: ' + providerStatusCode + ', providerTIN: ' + providerTIN);
        system.debug(LoggingLevel.INFO, 'providerTINStatusCode: ' + providerTINStatusCode +', providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'addressId: ' + addressId + ', addressTypeCode: ' + addressTypeCode + ', returningFrom: ' + returningFrom);
        system.debug(LoggingLevel.INFO, 'CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        
        this.returningFromService = returningFrom;
        GetEndpoint();
        GetRequestBody(ProviderId, providerStatusCode, providerTIN, providerTINStatusCode,providerTINTypeCode, addressId,addressTypeCode);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String providerTINOwner, String HttpRequestLabel)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            if (Response.getStatusCode() == 200) {
                ACETProviderDetailController.ACETProviderDetail ProviderDetail = ParseSuccessResponse(Response.getBody(), providerTINOwner);
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ProviderDetail;
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
    
}