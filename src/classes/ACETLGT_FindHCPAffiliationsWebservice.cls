public class ACETLGT_FindHCPAffiliationsWebservice extends ACETWebservice
{
    public void Init(String healthcareProfessionalId) {
        system.debug(LoggingLevel.INFO, 'healthcareProfessionalId: ' + healthcareProfessionalId);
        
        healthcareProfessionalId = String.isNotBlank(healthcareProfessionalId) ? healthcareProfessionalId : '';
        RequestParameters = new List<String>{healthcareProfessionalId};
    }
    
    public override void GetEndpoint()  {
        GetEndpointDetail('FindHCPAffEndpoint');
    }
     public ACETLGT_FindHCPAffiliationsWebservice() {
        super('Stargate');
    }
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETLGT_FindHCPAffRequestJSON', RequestParameters);     
    }
    
    private ACETWSCalloutResult ParseSuccessResponse(HttpResponse Response)  {
        List<ACETLGT_ProviderLookupDetailResult.ACETProviderAffiliation> Affiliations = new List<ACETLGT_ProviderLookupDetailResult.ACETProviderAffiliation>();
        ACETOILPagination Pagination;
        ACETWSCalloutResult oACETWSCalloutResult = NEW ACETWSCalloutResult();
        ACETFindHCPAffJSON2Apex ACETFHCPAJSON2Apex = (ACETFindHCPAffJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCPAffJSON2Apex.class);        
        system.debug(LoggingLevel.INFO, 'ACETFHCPAJSON2Apex:' + ACETFHCPAJSON2Apex);
        system.debug('Sampath test------>'+ ACETFHCPAJSON2Apex);

        ACETFindHCPAffJSON2Apex.findMedicalHealthcareProfessionalAffiliationsResponse findHCPAffResponse = ACETFHCPAJSON2Apex.findMedicalHealthcareProfessionalAffiliationsResponse;
        //ACETFindHCPAffJSON2Apex.FindMedicalHealthcareProfessionalAffiliationsResponseType findHCPAffResponseType = findHCPAffResponse.findMedicalHealthcareProfessionalAffiliationsResponseType;
        if (findHCPAffResponse.errors == null) {
            Pagination = findHCPAffResponse.pagination;
            if (Integer.valueOf(Pagination.totalCount) > 0) {
                oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                oACETWSCalloutResult.pageSize = Pagination.pageSize;
                oACETWSCalloutResult.recordCount = Pagination.recordCount;
                oACETWSCalloutResult.totalCount = Pagination.totalCount;
                oACETWSCalloutResult.totalPages = Pagination.totalPages;
                List<ACETFindHCPAffJSON2Apex.MedicalHealthcareOrganization> medHCOs = findHCPAffResponse.medicalHealthcareOrganization;
                ACETLGT_ProviderLookupDetailResult.ACETProviderAffiliation Affiliation;
                for (ACETFindHCPAffJSON2Apex.MedicalHealthcareOrganization medHCO :medHCOs) {
                    Affiliation = new ACETLGT_ProviderLookupDetailResult.ACETProviderAffiliation();                     
                    if (medHCO.hco != null) {
                        Affiliation.affiliation = medHCO.hco.name;
                        Affiliation.providerId = medHCO.hco.Id;
                    }
                    if (medHCO.affiliation != null) {
                        Affiliation.effective = ChangeDateFormat(medHCO.affiliation.effectiveDate);
                    }
                    Affiliations.add(Affiliation);
                }
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Affiliations;
            }   
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = GetOILErrorMessage(findHCPAffResponse.errors);
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
            System.debug(LoggingLevel.INFO, 'getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug(LoggingLevel.INFO, 'oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;

    }
}