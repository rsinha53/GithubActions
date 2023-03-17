public class ACETLGT_FindClaimWebservice extends ACETWebService{
    private String c_strTaxId;
    private String c_strNetworkStatus;
    private String c_strStartDate;
    private String c_strEndDate;
    private String c_strDeductibleOnly;
    private String c_strClaimId; 
    private String c_strAuthorizationNumber;
    private String c_strReferrelNumber;
    private String c_ProviderType;
    private String c_MCHID;
    Private String c_EID;
     Private String c_Encounters;
    
    public void init(String strTaxId,String strNetworkStatus, String strStartDate,String strEndDate, String strDeductibleOnly,String strClaimId, String strAuthorizationNumber,String strReferrelNumber,String strProviderType,String strMCHId,string strEID,string Encounters){ 
        c_strTaxId = strTaxId;
        c_strNetworkStatus = strNetworkStatus;
        c_strStartDate = strStartDate;
        c_strEndDate = strEndDate;
        c_strDeductibleOnly = strDeductibleOnly;
        system.debug('c_strDeductibleOnly--->>'+c_strDeductibleOnly);
        c_strClaimId = strClaimId; 
        c_strAuthorizationNumber = strAuthorizationNumber;
        c_strReferrelNumber = strReferrelNumber;
        c_ProviderType = strProviderType;
        c_MCHID = strMCHId;
        c_EID = strEID;
        c_Encounters = Encounters; 
        //c_SortBy = SortBy; 
        //c_SortOrder = SortOrder;
        system.debug('inside the init method    ');                             
    }
    public override void GetEndpoint(){
        GetEndpointDetail('SearchClaimsEndpoint');
             
    }
     public ACETLGT_FindClaimWebservice() {
        super('Stargate');
    }
    
    private void getRequestBody(String strClaimID, String strMCHId, String strEID){
        RequestBody = '{"findClaimsRequest": {"claimID": "'+strClaimID+'","enrolleeIdentifiers": [{"id": "'+strEID+'","type": "EID"},{"id": "'+strMCHId+'","type": "MCH"}]}}';    
    }
    private void getRequestBody(Integer pageNumber, Integer pageSize, Integer startRecord){
        system.debug('c_strClaimId'+c_strClaimId);
                system.debug('c_Encounters--->'+c_Encounters);

        if(string.isNOTBlank(c_strClaimId)){
                GetRequestBody(c_strClaimId,c_MCHID,c_EID);
            }
            else{
                //RequestBody = GetRequestBody('FindClaimSearchAdapter',RequestParameters);
                RequestBody = '{"findClaimsRequest": {"claimSearchDateType": "ClaimServiceDate","claimSearchStartDate": "'+ c_strStartDate +'","claimSearchEndDate": "'+ c_strEndDate +'",';
                if(String.IsNOTBlank(c_strTaxId)){
                    RequestBody += '"provider": [{"providerType": "Billing","providerTIN": "'+ c_strTaxId +'"}],';   
                }
                if(String.IsNOTBlank(c_strAuthorizationNumber) || String.IsNOTBlank(c_strReferrelNumber) || String.IsNOTBlank(c_ProviderType) || String.IsNOTBlank(c_strNetworkStatus) ||String.IsNOTBlank(c_strDeductibleOnly)||String.isNotBlank(c_Encounters)){
                    RequestBody += '"additionalFilters":{';
                    if(c_ProviderType != null){
                        RequestBody += '"claimType": "'+ c_ProviderType+'"';
                    }
                    if(c_ProviderType == null && c_strNetworkStatus != null)
                    {
                        RequestBody += '"claimNetworkIndicator": "'+ c_strNetworkStatus+'"';
                    }
                    else if(c_ProviderType != null && c_strNetworkStatus != null){
                        RequestBody += ',"claimNetworkIndicator": "'+ c_strNetworkStatus+'"';
                    }
                    if(c_ProviderType != null && c_strDeductibleOnly != null || c_strNetworkStatus != null && c_strDeductibleOnly != null){
                        RequestBody += ',"deductibleAmount": "'+ c_strDeductibleOnly;
                    }
                    else if(c_ProviderType == null && c_strDeductibleOnly != null || c_strNetworkStatus == null && c_strDeductibleOnly != null){
                        RequestBody += '"deductibleAmount": "'+ c_strDeductibleOnly+'"';
                    }
                    if((c_ProviderType != null && c_strDeductibleOnly != null && c_strAuthorizationNumber != null) || (c_ProviderType == null && c_strDeductibleOnly != null && c_strAuthorizationNumber != null) || (c_ProviderType != null && c_strDeductibleOnly == null && c_strAuthorizationNumber != null)){
                        RequestBody += '","authorizationNotificationNumber": "'+ c_strAuthorizationNumber+'"';
                    }
                    else if((c_ProviderType == null && c_strDeductibleOnly == null && c_strAuthorizationNumber != null) || (c_ProviderType == null && c_strDeductibleOnly != null && c_strAuthorizationNumber != null) || (c_ProviderType != null && c_strDeductibleOnly == null && c_strAuthorizationNumber != null)){
                        RequestBody += '"authorizationNotificationNumber": "'+ c_strAuthorizationNumber+'"';
                    }
                    if((c_ProviderType != null && c_strDeductibleOnly != null && c_strAuthorizationNumber != null && c_strReferrelNumber != null) || (c_ProviderType == null && c_strDeductibleOnly != null && c_strAuthorizationNumber != null && c_strReferrelNumber != null) || (c_ProviderType == null && c_strDeductibleOnly == null && c_strAuthorizationNumber != null && c_strReferrelNumber != null) || (c_ProviderType != null && c_strDeductibleOnly == null && c_strAuthorizationNumber == null && c_strReferrelNumber != null) || (c_ProviderType == null && c_strDeductibleOnly != null && c_strAuthorizationNumber == null && c_strReferrelNumber != null) || (c_ProviderType == null && c_strDeductibleOnly == null && c_strAuthorizationNumber != null && c_strReferrelNumber != null) || (c_ProviderType != null && c_strDeductibleOnly != null && c_strAuthorizationNumber == null && c_strReferrelNumber != null) || (c_ProviderType != null && c_strDeductibleOnly == null && c_strAuthorizationNumber != null && c_strReferrelNumber != null)){
                        RequestBody += ',"referralNumber": "'+ c_strReferrelNumber+'"';
                    }
                    else if(c_ProviderType == null && c_strDeductibleOnly == null && c_strAuthorizationNumber == null && c_strReferrelNumber != null)
                    {
                        RequestBody += '"referralNumber": "'+ c_strReferrelNumber+'"';
                   
                    }
                         if( c_Encounters != null)
                    {
                        RequestBody += ',"includeDelegatedEncounterClaim": "'+ c_Encounters+'"';
                    }
                    RequestBody += '},';
                }
           RequestBody += '"enrolleeIdentifiers": [{"id": "'+c_EID +'","type": "EID"},{"id": "'+ c_MCHID +'","type": "MCH"}],"pagination": {"pageNumber": "' + pageNumber + '","pageSize": "' + pageSize + '"},"sorting": [{"sortColumnName": "Date of service","sortOrderType": ""}]}}';
            }
     }
     public String formattedDate(String exisDate){
        String FormattedDate = '';
        List<String> exisDateList = exisDate.split('/');
        
        exisDateList[1] = exisDateList[1].subString(0,2);   
        
        FormattedDate = exisDateList[0] + '/' + exisDateList[1] + '/' + exisDateList[2];
        
        return FormattedDate;
    }
    
     public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        list<ACETClaimSearchResult> claimSearchResult = new list<ACETClaimSearchResult>();
        ACETClaimSearchResult claim;
        RequestParameters = new String[]{c_strStartDate,c_strEndDate,c_strTaxId,c_ProviderType,c_strNetworkStatus,c_strDeductibleOnly,c_strAuthorizationNumber,c_strReferrelNumber,c_MCHID};
        list<ACETFindClaimJSON2Apex.claims> SRClaims;
        try{
            GetEndpoint();
            GetRequestBody(pageNumber, pageSize, startRecord);
            
            
             HttpResponse Response = Send(OAuthConfig); 
             oACETWSCalloutResult.statusCode = response.getStatusCode();
             if (oACETWSCalloutResult.statusCode == 200){
                String ResponseBody = Response.getBody();
                ACETFindClaimJSON2Apex ACTclaimJSON2Apex = (ACETFindClaimJSON2Apex)JSON.deserialize(ResponseBody, ACETFindClaimJSON2Apex.class);
                SRClaims = ACTclaimJSON2Apex.findClaimsResponse.claims;
                if (SRClaims != null && SRClaims.size() > 0){
                    for (ACETFindClaimJSON2Apex.claims SRClaim : SRClaims){
                        claim = new ACETClaimSearchResult();
                        claim.ClaimID = String.isNOTBlank(SRClaim.claimID)?SRClaim.claimID:'';
                        claim.SourceClaimId = String.isNOTBlank(SRClaim.sourceClaimId)?SRClaim.sourceClaimId:'';
                        claim.PHIRestriction = String.isNOTBlank(SRClaim.privacyIndicator)?SRClaim.privacyIndicator:'';
                        //claim.TaxID = SRClaim.provider[0].providerTIN;
                        List<ACETFindClaimJSON2Apex.provider> lstProv = new list<ACETFindClaimJSON2Apex.Provider>();
                        lstProv = SRClaim.Provider;
                        system.debug('lstProv'+lstProv);
                        
                        //get provider name from rendering first
                        for(Integer i = 0; i < lstProv.size(); i++){                            
                            if (lstProv[i].providerType == 'Rendering'){
                                claim.Provider = getProviderName(lstProv[i]);     
                            }
                        }
                        
                        for(Integer i=0;i<lstProv.size();i++){
                            if (lstProv[i].providerType == 'Billing'){
                                claim.TaxID = lstProv[i].ProviderTIN != null? lstProv[i].ProviderTIN:'';  
                                //get provider name from billing
                                if(String.isEmpty(claim.Provider)){
                                    claim.Provider = getProviderName(lstProv[i]);
                                }
                            }                            
                        }
                         
                        //claim.Provider = SRClaim.provider[0].name.firstName;
                        claim.Network = String.isNOTBlank(SRClaim.claimNetworkIndicator)?SRClaim.claimNetworkIndicator:'';
                        claim.ServiceStart = ChangeDateFormat(SRClaim.claimFirstDateofService);
                        claim.claimEncounterIndicator = String.isNOTBlank(SRClaim.claimEncounterIndicator)?SRClaim.claimEncounterIndicator:'';
                        claim.ServiceEnd = ChangeDateFormat(SRClaim.claimLastDateofService);
                        claim.TotalCharged = String.isNOTBlank(SRClaim.claimTotalBilledChargeAmount)?SRClaim.claimTotalBilledChargeAmount:'';
                        claim.TotalPaid  = String.isNOTBlank(SRClaim.claimTotalPaidAmount)?SRClaim.claimTotalPaidAmount:'';
                        claim.Deductible = String.isNOTBlank(SRClaim.claimTotalDeductibleAmount)?SRClaim.claimTotalDeductibleAmount:'';
                        system.debug('SRClaim.claimEventAdjudicationDateTime is '+SRClaim.claimEventAdjudicationDateTime);
                        
                       if(SRClaim.diagnosisCode!=null && !SRClaim.diagnosisCode.isempty()){
                            system.debug('SRClaim.diagnosisCode[0].code is '+SRClaim.diagnosisCode[0].code);
                            claim.PrimaryDiagnosisCode = SRClaim.diagnosisCode[0].code;   
                        }
                        else{
                            system.debug('SRClaim.diagnosisCode is' + SRClaim.diagnosisCode);
                        }
                       
                        if(SRClaim.claimEventAdjudicationDateTime != null)
                        {
                            if(SRClaim.claimEventStatus == Label.Claim_StatusCode_to_display_Processed_Date){
                            
                                claim.Processed = formattedDate(ChangeDateFormat(String.isNOTBlank(SRClaim.claimEventAdjudicationDateTime)?SRClaim.claimEventAdjudicationDateTime:''));
                            }
                       }
                        if(SRClaim.claimEventTypeCode != null){
                            claim.claimEvtType = String.isNOTBlank(SRClaim.claimEventTypeCode.description)?SRClaim.claimEventTypeCode.description:'';
                        }
                        claim.patientResponsibility = String.isNOTBlank(SRClaim.totalPatientResponsibilityAmount)?SRClaim.totalPatientResponsibilityAmount:'';
                        //claim.BenefitLevel = SRClaim
                                                
                        //if(SRClaim.claimStatusCode!=null){
                        claim.Status = SRClaim.claimEventStatusDescription;
                        claim.Statuscode = SRClaim.claimEventStatus;
                        claim.claimEventStatusDate = formattedDate(ChangeDateFormat(String.isNOTBlank(SRClaim.claimEventStatusDate)?SRClaim.claimEventStatusDate:''));
                        //system.debug('SRClaim.claimStatusCode.description is '+SRClaim.claimStatusCode.description);
                        //}
                        
                       
                        claim.claimType = SRClaim.claimType;
                        claimSearchResult.add(claim);   
                    }
                    if (claimSearchResult.size() > 0){
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = claimSearchResult;
                                                                        
                        ACETFindClaimJSON2Apex.Pagination pagination = ACTclaimJSON2Apex.findClaimsResponse.pagination;    
                        if(pagination != null){                                                                     
                            oACETWSCalloutResult.pageNumber =  pagination.pageNumber; 
                            oACETWSCalloutResult.pageSize = pagination.pageSize; 
                            oACETWSCalloutResult.recordCount = pagination.recordCount;
                            oACETWSCalloutResult.totalCount = pagination.totalCount;     
                        }else{
                            //assume it is searched by claim ID and will only be returned with one record if pagination information is not returned
                            oACETWSCalloutResult.pageNumber =  '1'; 
                            oACETWSCalloutResult.pageSize = '1'; 
                            oACETWSCalloutResult.recordCount = '1';
                            oACETWSCalloutResult.totalCount = '1';  
                        }                                           
                    }else{
                        oACETWSCalloutResult.Success = false;
                        oACETWSCalloutResult.Message = 'No results found. Modify the search criteria.';
                        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;    
                    }
                    
                }
             }else if(oACETWSCalloutResult.statusCode == 404){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = 'No results found. Modify the search criteria.';
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;    
                    
             }else if(oACETWSCalloutResult.statusCode == 400){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = 'No matching records found.';
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;    
                    
             }else if(oACETWSCalloutResult.statusCode == 500){
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.statusCode = response.getStatusCode();
                oACETWSCalloutResult.Message = 'Problem with FindClaim Webservice: ' + oACETWSCalloutResult.Message;        
             }         
             system.debug('Response in claim'+Response);
        }
        catch(exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in Find Claim. Line'+ex.getLineNumber()+' Details: ' + ex); 
            System.debug(LoggingLevel.INFO, 'getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage()+'at line'+ex.getLineNumber();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            
        }
        system.debug(LoggingLevel.INFO, 'oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
        
    }
    
    private String getProviderName(ACETFindClaimJSON2Apex.provider provider){
        if(provider.name != null){
            return getFullName(provider.name.firstName, provider.name.middleName, provider.name.lastName);
        }else{
            return getValue(provider.organizationName);

        }   
    }
    
    private String getFullName(String firstName, String middleName, String lastName){
        String name = '';
        if(!String.isEmpty(firstName)){
            name = firstName;
            name = name.trim();
        }
        if(!String.isEmpty(middleName)){
            name += ' ' + middleName;
            name = name.trim();
        }
        if(!String.isEmpty(lastName)){
            name += ' ' + lastName;
            name = name.trim();
        }
        return name;
    }
    
    private String getValue(String v){
        return v == null? '':v;
    }
    
}