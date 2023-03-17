public class ACETFindAuthorizationWebservice extends ACETWebservice{
    public String vartotalCount;
    public override void GetEndpoint()
    {
        GetEndpointDetail('SearchHlhSvrAuthorizationsEndpoint');
    }
    
	public ACETFindAuthorizationWebservice () {
        super('Stargate');
    }
	
    private void GetRequestBody(String MemberId, String DOB, String FirstName, String LastName, String StartDate, String EndDate, String FederationID)
    {
        
      List<String> SearchParameters = new String[] { MemberId, DOB, FirstName, LastName, StartDate, EndDate};           
        RequestBody = GetRequestBody('FindAuthorizationsRequestJSON',SearchParameters);

    }
    
    /*private List<ACETFindAuthorizationJSON2Apex.authorization> ParseSuccessResponse(String ResponseBody)
    {
        ACETFindAuthorizationJSON2Apex ACTFPJSON2Apex = (ACETFindAuthorizationJSON2Apex)JSON.deserialize(ResponseBody, ACETFindAuthorizationJSON2Apex.class);
        system.debug('ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
        return null;
    }*/
    
    public ACETWSCalloutResult FindAuthorizations(String MemberId, String DOB, String FirstName, String LastName, String StartDate, String EndDate, String FederationID, List<String> SystemLabels)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETAuthorizationSearchResult> inPatientAuthorizations = new List<ACETAuthorizationSearchResult>();
        List<ACETAuthorizationSearchResult> outPatientAuthorizations = new List<ACETAuthorizationSearchResult>();
        List<ACETAuthorizationSearchResult> outPatientFacilityAuthorizations = new List<ACETAuthorizationSearchResult>();
        ACETAuthorizationSearchResult Authorization;        
        List<ACETFindAuthorizationJSON2Apex.InPatientsSummary> inPatientSRAuthorizations =new List<ACETFindAuthorizationJSON2Apex.InPatientsSummary>();
        List<ACETFindAuthorizationJSON2Apex.OutPatientsSummary> outPatientSRAuthorizations =new List<ACETFindAuthorizationJSON2Apex.OutPatientsSummary>();
        List<ACETFindAuthorizationJSON2Apex.OutPatientsFacilitySummary> outPatientFacilitySRAuthorizations =new List<ACETFindAuthorizationJSON2Apex.OutPatientsFacilitySummary>();
        
        try{
            GetEndpoint();
            GetRequestBody(MemberId, DOB, FirstName,  LastName,  StartDate,  EndDate,FederationID);
            HttpResponse Response = Send(OAuthConfig);
          
            Response.setBody(Response.getBody().replaceAll('"desc"','"descr"').replaceAll('"dateTime"','"dteTime"').replaceAll('"date"','"dte"'));
            if (Response.getStatusCode() == 200){
                
                ACETFindAuthorizationJSON2Apex ACTFPJSON2Apex = (ACETFindAuthorizationJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindAuthorizationJSON2Apex.class);
                system.debug('ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                                
                
                if(ACTFPJSON2Apex.AuthSummaryResponse != null){
                    if(ACTFPJSON2Apex.AuthSummaryResponse.pagination != null)
                    {
                       vartotalCount = ACTFPJSON2Apex.AuthSummaryResponse.pagination.totalCount;
                    }
                    system.debug(' *** response : ' + ACTFPJSON2Apex.AuthSummaryResponse );
                 
                if(ACTFPJSON2Apex.AuthSummaryResponse.inPatientsSummary!= null ){    
                     inPatientSRAuthorizations = ACTFPJSON2Apex.AuthSummaryResponse.inPatientsSummary;
                    
                     for (ACETFindAuthorizationJSON2Apex.InPatientsSummary inpatient: inPatientSRAuthorizations ){
                     
                         Authorization = new ACETAuthorizationSearchResult();
                         if(inpatient.serviceSettingType!=null){
                            Authorization.Case_Type_Code = inpatient.serviceSettingType.code==null?'':inpatient.serviceSettingType.code;
                            Authorization.Case_Type_Desc = inpatient.serviceSettingType.description==null?'':inpatient.serviceSettingType.description;
                        }
                             Authorization.Authorization_Number = inpatient.primaryServiceReferenceNumber==null?'':inpatient.primaryServiceReferenceNumber;
                        String statusCodeDescr='';
                        String statusReasonCodeDescr='';
                        if(inpatient.statusType!=null){
                            statusCodeDescr = inpatient.statusType.description==null?'':inpatient.statusType.description;
                        }
                        if(inpatient.statusReasonType!=null){
                            statusReasonCodeDescr = inpatient.statusReasonType.description==null?'':inpatient.statusReasonType.description;
                        }
                            Authorization.authID = inpatient.authId==null?'':inpatient.authId;
                        Authorization.Case_Status = ACETProviderUtility.validateConcatenateOfStrings(statusCodeDescr,statusReasonCodeDescr,'-');
                        if(inpatient.primaryDiagnosisCode!=null && inpatient.primaryDiagnosisCode.code!=null && inpatient.primaryDiagnosisCode.description!=null){
                            Authorization.Primary_Diagnosis = ACETProviderUtility.validateConcatenateOfStrings(inpatient.primaryDiagnosisCode.code,inpatient.primaryDiagnosisCode.description,'-');
                        }
                        
                        if(inpatient.createDatetime!=null){
                            Authorization.Create_Date = inpatient.createDatetime==null?'':ACETUtility.format(Date.valueOf(inpatient.createDatetime));
                        }
                        if(inpatient.placeOfServiceCode!=null){
                            Authorization.POS= inpatient.placeOfServiceCode.description==null?'':inpatient.placeOfServiceCode.description;   
                        }
                        String ServiceDesc= '';
                        String ServiceDetail= '';
                        if(inpatient.serviceDescUrgencyCode!=null){
                            ServiceDesc= inpatient.serviceDescUrgencyCode.description==null?'':inpatient.serviceDescUrgencyCode.description;   
                        }
                        if(inpatient.serviceDetailCategoryCode!=null){
                            ServiceDetail= inpatient.serviceDetailCategoryCode.description==null?'':inpatient.serviceDetailCategoryCode.description;   
                        }
                        Authorization.ServiceDescDetail = ACETProviderUtility.validateConcatenateOfStrings(ServiceDesc,ServiceDetail,'/');
                        
                        // code = 1 check        
                                
                        if(inpatient.preDeterminationInd!=null){
                            Authorization.Pre_Determination = (inpatient.preDeterminationInd=='false')?'No':'Yes';
                        }
                        Authorization.Actual_Admit_Date = inpatient.actualAdmissionDateTime==null?'':ACETUtility.format(Date.valueOf(inpatient.actualAdmissionDateTime));
                        Authorization.Actual_Dscharg_Date = inpatient.actualDischargeDateTime==null?'':ACETUtility.format(Date.valueOf(inpatient.actualDischargeDateTime));
                        Authorization.Expected_Admit_Date = inpatient.expectedAdmitDate==null?'':ACETUtility.format(Date.valueOf(inpatient.expectedAdmitDate));
                        Authorization.Expected_Dscharg_Date = inpatient.expectedDischargeDate==null?'':ACETUtility.format(Date.valueOf(inpatient.expectedDischargeDate));
                        Authorization.LOS = inpatient.lengthOfStay==null?'':inpatient.lengthOfStay;
                        
                        String orgName='';
                        String network1Descr='';
                                
                        orgName = inpatient.facilityProviderOrganizationName==null?'':inpatient.facilityProviderOrganizationName;    
                        if(inpatient.facilityProviderNetworkStatusType!=null){     
                           network1Descr = inpatient.facilityProviderNetworkStatusType.description==null?'':inpatient.facilityProviderNetworkStatusType.description;
                        }
                        Authorization.Facility_Status = ACETProviderUtility.validateConcatenateOfStrings(orgName,network1Descr,'/');
                    
                        inPatientAuthorizations.add(Authorization);
                     }
                 //debug for inpatient list
                 }   
                
                // Logic for outpatients
                
                if(ACTFPJSON2Apex.AuthSummaryResponse.outPatientsSummary!= null ){    
                     outPatientSRAuthorizations = ACTFPJSON2Apex.AuthSummaryResponse.outPatientsSummary ;
                    
                     for (ACETFindAuthorizationJSON2Apex.OutPatientsSummary outpatient: outPatientSRAuthorizations ){
                     
                         Authorization = new ACETAuthorizationSearchResult();
                         if(outpatient.serviceSettingType!=null){
                            Authorization.Case_Type_Code = outpatient.serviceSettingType.code==null?'':outpatient.serviceSettingType.code;
                            Authorization.Case_Type_Desc = outpatient.serviceSettingType.description==null?'':outpatient.serviceSettingType.description;
                        }
                         
                        Authorization.Authorization_Number = outpatient.primaryServiceReferenceNumber==null?'':outpatient.primaryServiceReferenceNumber;
                        String statusCodeDescr='';
                        String statusReasonCodeDescr='';
                        if(outpatient.statusType!=null){
                            statusCodeDescr = outpatient.statusType.description==null?'':outpatient.statusType.description;
                        }
                        if(outpatient.statusReasonType!=null){
                            statusReasonCodeDescr = outpatient.statusReasonType.description==null?'':outpatient.statusReasonType.description;
                        }
                            Authorization.authID = outpatient.authId==null?'':outpatient.authId;
                       
                        Authorization.Case_Status = ACETProviderUtility.validateConcatenateOfStrings(statusCodeDescr,statusReasonCodeDescr,'-');
                        if(outpatient.primaryDiagnosisCode!=null && outpatient.primaryDiagnosisCode.code!=null && outpatient.primaryDiagnosisCode.description!=null){
                            Authorization.Primary_Diagnosis = ACETProviderUtility.validateConcatenateOfStrings(outpatient.primaryDiagnosisCode.code,outpatient.primaryDiagnosisCode.description,'-');
                        }
                        
                        if(outpatient.createDatetime!=null){
                            Authorization.Create_Date = outpatient.createDatetime==null?'':ACETUtility.format(Date.valueOf(outpatient.createDatetime));
                        }
                        if(outpatient.placeOfServiceCode!=null){
                            Authorization.POS= outpatient.placeOfServiceCode.description==null?'':outpatient.placeOfServiceCode.description;   
                        }
                        String ServiceDesc= '';
                        String ServiceDetail= '';
                        if(outpatient.serviceDescUrgencyCode!=null){
                            ServiceDesc= outpatient.serviceDescUrgencyCode.description==null?'':outpatient.serviceDescUrgencyCode.description;   
                        }
                        if(outpatient.serviceDetailCategoryCode!=null){
                            ServiceDetail= outpatient.serviceDetailCategoryCode.description==null?'':outpatient.serviceDetailCategoryCode.description;   
                        }
                        Authorization.ServiceDescDetail = ACETProviderUtility.validateConcatenateOfStrings(ServiceDesc,ServiceDetail,'/');
                        
                        // code = 2 check        
                                
                        if(outpatient.preDeterminationInd!=null){
                            Authorization.Pre_Determination = (outpatient.preDeterminationInd=='false')?'No':'Yes';
                        }
                        
                        if(outpatient.procedureCode!=null && outpatient.procedureCode.code!=null && outpatient.procedureCode.codeDesc!=null){ 
                            Authorization.Procedure_Code = ACETProviderUtility.validateConcatenateOfStrings(outpatient.procedureCode.code, outpatient.procedureCode.codeDesc, '-');
                        } 
                        else
                        {
                            Authorization.Procedure_Code = '';
                        }     
                        
                        if(outPatient.serviceDateRange != null){
                            Authorization.Start_Date = outpatient.serviceDateRange.startDate==null?'':ACETUtility.format(Date.valueOf(outpatient.serviceDateRange.startDate));
                            Authorization.End_Date = outpatient.serviceDateRange.stopDate==null?'':ACETUtility.format(Date.valueOf(outpatient.serviceDateRange.stopDate));
                        }                              
                        // Authorization.Count   Not found in the response   ex: 5 - visits
                        if(outpatient.procedureUnitOfMeasureType != null && outpatient.procedureUnitCount != null && outpatient.procedureUnitOfMeasureType.description != null ){
                            Authorization.Count = ACETProviderUtility.validateConcatenateOfStrings(outpatient.procedureUnitCount, outpatient.procedureUnitOfMeasureType.description , '-');
                        }                  
                         
                        String fName='';
                        String lName='';
                        String network1Descr='';
                        
                        if(outpatient.servicingProviderNetworkStatusType!=null){     
                           network1Descr = outpatient.servicingProviderNetworkStatusType.description==null?'':outpatient.servicingProviderNetworkStatusType.description;
                        }
                        fName = outpatient.servicingProviderFirstName==null?'':outpatient.servicingProviderFirstName;
                        lName = outpatient.servicingProviderLastName==null?'':outpatient.servicingProviderLastName;
                        
                        String nameStr = fName+' '+lName;
                        Authorization.ServiceProviderStatus = ACETProviderUtility.validateConcatenateOfStrings(nameStr,network1Descr,'/');
                        outPatientAuthorizations.add(Authorization);
                     }
                 //debug for outPatientAuthorizations list
                 }
                
                
                // OutPatient Facility
                
                if(ACTFPJSON2Apex.AuthSummaryResponse.outPatientsFacilitySummary!= null ){    
                     outPatientFacilitySRAuthorizations = ACTFPJSON2Apex.AuthSummaryResponse.outPatientsFacilitySummary;
                    
                     for (ACETFindAuthorizationJSON2Apex.OutPatientsFacilitySummary outPatientFacility: outPatientFacilitySRAuthorizations ){
                     
                        Authorization = new ACETAuthorizationSearchResult();
                        if(outPatientFacility.serviceSettingType!=null){
                            Authorization.Case_Type_Code = outPatientFacility.serviceSettingType.code==null?'':outPatientFacility.serviceSettingType.code;
                            Authorization.Case_Type_Desc = outPatientFacility.serviceSettingType.description==null?'':outPatientFacility.serviceSettingType.description;
                        }
                         
                        Authorization.Authorization_Number = outPatientFacility.primaryServiceReferenceNumber==null?'':outPatientFacility.primaryServiceReferenceNumber;
                        String statusCodeDescr='';
                        String statusReasonCodeDescr='';
                        if(outPatientFacility.statusType!=null){
                            statusCodeDescr = outPatientFacility.statusType.description==null?'':outPatientFacility.statusType.description;
                        }
                        if(outPatientFacility.statusReasonType!=null){
                            statusReasonCodeDescr = outPatientFacility.statusReasonType.description==null?'':outPatientFacility.statusReasonType.description;
                        }
                            Authorization.authID = outPatientFacility.authId==null?'':outPatientFacility.authId;
                       
                        Authorization.Case_Status = ACETProviderUtility.validateConcatenateOfStrings(statusCodeDescr,statusReasonCodeDescr,'-');
                        if(outPatientFacility.primaryDiagnosisCode!=null && outPatientFacility.primaryDiagnosisCode.code!=null && outPatientFacility.primaryDiagnosisCode.description!=null){
                            Authorization.Primary_Diagnosis = ACETProviderUtility.validateConcatenateOfStrings(outPatientFacility.primaryDiagnosisCode.code,outPatientFacility.primaryDiagnosisCode.description,'-');
                        }
                        
                        if(outPatientFacility.createDatetime!=null){
                            Authorization.Create_Date = outPatientFacility.createDatetime==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.createDatetime));
                        }
                        if(outPatientFacility.placeOfServiceCode!=null){
                            Authorization.POS= outPatientFacility.placeOfServiceCode.description==null?'':outPatientFacility.placeOfServiceCode.description;   
                        }
                        String ServiceDesc= '';
                        String ServiceDetail= '';
                        if(outPatientFacility.serviceDescUrgencyCode!=null){
                            ServiceDesc= outPatientFacility.serviceDescUrgencyCode.description==null?'':outPatientFacility.serviceDescUrgencyCode.description;   
                        }
                        if(outPatientFacility.serviceDetailCategoryCode!=null){
                            ServiceDetail= outPatientFacility.serviceDetailCategoryCode.description==null?'':outPatientFacility.serviceDetailCategoryCode.description;   
                        }
                        Authorization.ServiceDescDetail = ACETProviderUtility.validateConcatenateOfStrings(ServiceDesc,ServiceDetail,'/');
                        
                        // code = 1 check        
                                
                        if(outPatientFacility.preDeterminationInd!=null){
                            Authorization.Pre_Determination = (outPatientFacility.preDeterminationInd=='false')?'No':'Yes';
                        }
                        
                        if(outPatientFacility.procedureCode!=null && outPatientFacility.procedureCode.code!=null && outPatientFacility.procedureCode.codeDesc!=null){ 
                            Authorization.Procedure_Code = ACETProviderUtility.validateConcatenateOfStrings(outPatientFacility.procedureCode.code, outPatientFacility.procedureCode.codeDesc, '-');
                        } 
                        else
                        {
                            Authorization.Procedure_Code = '';
                        } 
                        Authorization.Actual_Start_Date= outPatientFacility.actualAdmissionDateTime==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.actualAdmissionDateTime));
                        Authorization.Actual_End_Date = outPatientFacility.actualDischargeDateTime==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.actualDischargeDateTime));
                        Authorization.Expected_Start_Date = outPatientFacility.expectedAdmitDate==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.expectedAdmitDate));
                        Authorization.Expected_End_Date = outPatientFacility.expectedDischargeDate==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.expectedDischargeDate));
                        
                        system.debug('*** Date facility'+outPatientFacility.expectedAdmitDate+' after' +Authorization.Expected_Admit_Date );
                        system.debug('*** Date facility'+outPatientFacility.expectedDischargeDate+' after' +Authorization.Expected_Dscharg_Date );
                        String orgName='';
                        String network1Descr='';
                        String fName='';
                        String lName='';
                                
                        orgName = outPatientFacility.facilityProviderOrganizationName==null?'':outPatientFacility.facilityProviderOrganizationName;    
                        if(outPatientFacility.facilityProviderNetworkStatusType!=null){     
                           network1Descr = outPatientFacility.facilityProviderNetworkStatusType.description==null?'':outPatientFacility.facilityProviderNetworkStatusType.description;
                        }
                        fName = outPatientFacility.servicingProviderFirstName==null?'':outPatientFacility.servicingProviderFirstName;
                        lName = outPatientFacility.servicingProviderLastName==null?'':outPatientFacility.servicingProviderLastName;
                        
                        String nameStr = fName+' '+lName;
                        Authorization.ServiceProvider = ACETProviderUtility.validateConcatenateOfStrings(nameStr,network1Descr,'/');
                        Authorization.Facility_Status = ACETProviderUtility.validateConcatenateOfStrings(orgName,network1Descr,'/');
                        system.debug('*** Provider '+nameStr +' after' +Authorization.ServiceProviderStatus );
                        
                        outPatientFacilityAuthorizations.add(Authorization);
                     
                     }
                 //debug for outPatientFacilityAuthorizations list
                 }   
                    
                 List<ACETAuthorizationSearchResult> Authorizations = new List<ACETAuthorizationSearchResult>();
                 if(inPatientAuthorizations.size()>0)
                     Authorizations.addAll(inPatientAuthorizations);
                 if(outPatientAuthorizations.size()>0)
                     Authorizations.addAll(outPatientAuthorizations);
                 if(outPatientFacilityAuthorizations.size()>0)
                     Authorizations.addAll(outPatientFacilityAuthorizations);
                     oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
                    if (Authorizations.size() > 0){
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = Authorizations;
                        oACETWSCalloutResult.totalCount = vartotalCount;
                    }
                   /** else{
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = 'No Authorization Present for this Member';
                        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO; 
                    }*/
                    
                    }
                }
            
                else {
                     oACETWSCalloutResult = ParseFailureResponse(Response);   
                     oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
                 }     
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in FindAuthorizations. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
    
}