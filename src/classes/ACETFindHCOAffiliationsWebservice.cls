public class ACETFindHCOAffiliationsWebservice extends ACETWebservice
{
    public void Init(String healthcareOrganizationId, String providerStatusCode, String primarySpecialtyIndicator, String specialtyStatusCode) {
        system.debug(LoggingLevel.INFO, 'healthcareOrganizationId: ' + healthcareOrganizationId + ', providerStatusCode: ' + providerStatusCode);
        system.debug(LoggingLevel.INFO, ', primarySpecialtyIndicator: ' + primarySpecialtyIndicator + ', specialtyStatusCode: ' + specialtyStatusCode);
        
        healthcareOrganizationId = String.isNotBlank(healthcareOrganizationId) ? healthcareOrganizationId : '';
        providerStatusCode = String.isNotBlank(providerStatusCode) ? providerStatusCode : '';
        primarySpecialtyIndicator = String.isNotBlank(primarySpecialtyIndicator) ? primarySpecialtyIndicator : '';
        specialtyStatusCode = String.isNotBlank(specialtyStatusCode) ? specialtyStatusCode : '';
        RequestParameters = new List<String>{healthcareOrganizationId, providerStatusCode, primarySpecialtyIndicator, specialtyStatusCode};
    }
    
    public override void GetEndpoint()  {
        GetEndpointDetail('FindHCOAffEndpoint');
    }
    public ACETFindHCOAffiliationsWebservice() {
        super('Stargate');
    }
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETFindHCOAffRequestJSON', RequestParameters);     
    }
    
    private ACETWSCalloutResult ParseSuccessResponse(HttpResponse Response)  {
        List<ACETProviderDetailController.ACETProviderAffiliation> Affiliations = new List<ACETProviderDetailController.ACETProviderAffiliation>();
        ACETOILPagination Pagination;
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETFindHCOAffJSON2Apex ACETFHCOAJSON2Apex = (ACETFindHCOAffJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCOAffJSON2Apex.class);        
        system.debug(LoggingLevel.INFO, 'ACETFHCOAJSON2Apex:' + ACETFHCOAJSON2Apex);
        ACETFindHCOAffJSON2Apex.findMedicalHealthcareOrganizationAffiliationsResponse findHCOAffiliationsResponse = ACETFHCOAJSON2Apex.findMedicalHealthcareOrganizationAffiliationsResponse;
       // ACETFindHCOAffJSON2Apex.FindMedicalHealthcareOrganizationAffiliationsResponseType findHCOAffiliationsResponseType = findHCOAffiliationsResponse.findMedicalHealthcareOrganizationAffiliationsResponseType;
        if (findHCOAffiliationsResponse.errors == null) {
            Pagination = findHCOAffiliationsResponse.pagination;
            if (Integer.valueOf(Pagination.totalCount) > 0) {
                oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                oACETWSCalloutResult.pageSize = Pagination.pageSize;
                oACETWSCalloutResult.recordCount = Pagination.recordCount;
                oACETWSCalloutResult.totalCount = Pagination.totalCount;
                oACETWSCalloutResult.totalPages = Pagination.totalPages;
                List<ACETFindHCOAffJSON2Apex.MedicalHealthcareOrganizationAffiliations> MedAffiliations = findHCOAffiliationsResponse.medicalHealthcareOrganizationAffiliations;
                ACETProviderDetailController.ACETProviderAffiliation Affiliation;
               if(MedAffiliations !=null && !MedAffiliations.isEmpty()){
                for (ACETFindHCOAffJSON2Apex.MedicalHealthcareOrganizationAffiliations MedAffiliation :MedAffiliations) {
                    Affiliation = new ACETProviderDetailController.ACETProviderAffiliation();   
                    if (MedAffiliation.hcp != null) {
                        Affiliation.affiliation = '';
                        if(String.isNotBlank(MedAffiliation.hcp.firstName)) {
                             Affiliation.affiliation +=  MedAffiliation.hcp.firstName;
                        }  
                        if(String.isNotBlank(MedAffiliation.hcp.middleName)) {
                             Affiliation.affiliation +=  ' ' + MedAffiliation.hcp.middleName;
                        } 
                        if(String.isNotBlank(MedAffiliation.hcp.LastName)) {
                             Affiliation.affiliation +=  ' ' + MedAffiliation.hcp.lastName;
                        } 
                        Affiliation.providerId = MedAffiliation.hcp.Id;
                    }
                    if (MedAffiliation.affiliation != null) {
                        Affiliation.effective = ChangeDateFormat(MedAffiliation.affiliation.effectiveDate);
                    }
                    if (MedAffiliation.speciality != null && !MedAffiliation.speciality.isEmpty()) { 
                        for(ACETFindHCOAffJSON2Apex.Speciality Speciality :MedAffiliation.speciality) {
                            if (Speciality.primarySpecialtyIndicator == 'Y') {
                                Affiliation.PrimarySpeciality  = Speciality.typeDescription;    
                            }
                        }
                    }   
                    Affiliations.add(Affiliation);
                }
               }
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Affiliations;
            }   
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = GetOILErrorMessage(findHCOAffiliationsResponse.errors);
        oACETWSCalloutResult.Message = oACETWSCalloutResult.Message == Label.OILNoRecordErrorMessage ? Label.ACETNoRecordErrorMessage : oACETWSCalloutResult.Message;
            oACETWSCalloutResult.Response = null;
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
        }   
        return oACETWSCalloutResult;
    }
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        
        try
        {
            RequestParameters.AddAll(new List<String>{String.valueOf(pageNumber), String.valueOf(PageSize), String.valueOf(startRecord)});
            GetRequestBody();
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                oACETWSCalloutResult = ParseSuccessResponse(Response);
            }
            else  {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Affiliations. Details: ' + ex); 
            System.debug(LoggingLevel.INFO,'getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug(LoggingLevel.INFO,'oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;

    }
    
}