public class ACETLGT_FindAuthorizationWebservice extends ACETWebservice{
    public String vartotalCount;
    public override void GetEndpoint()
    {
        GetEndpointDetail('SearchHlhSvrAuthorizationsEndpoint');
    }
    
    public ACETLGT_FindAuthorizationWebservice() {
        super('Stargate');
    } 
    
    private void GetRequestBody(String srk, String DOB, String FirstName, String LastName, String StartDate, String EndDate, String FederationID)
    {
        
        List<String> SearchParameters = new String[] { srk, DOB, FirstName, LastName, StartDate, EndDate};           
            RequestBody = GetRequestBody('FindAuthorizationsRequestJSON',SearchParameters);
        
    }
    
    /*private List<ACETLGT_FindAuthorizationJSON2Apex.authorization> ParseSuccessResponse(String ResponseBody)
{
ACETLGT_FindAuthorizationJSON2Apex ACTFPJSON2Apex = (ACETLGT_FindAuthorizationJSON2Apex)JSON.deserialize(ResponseBody, ACETLGT_FindAuthorizationJSON2Apex.class);
system.debug('ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
return null;
}*/
    
    public ACETWSCalloutResult FindAuthorizations(String srk, String DOB, String FirstName, String LastName, String StartDate, String EndDate, String FederationID, List<String> SystemLabels)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETLGT_AuthorizationSearchResult> inPatientAuthorizations = new List<ACETLGT_AuthorizationSearchResult>();
        List<ACETLGT_AuthorizationSearchResult> outPatientAuthorizations = new List<ACETLGT_AuthorizationSearchResult>();
        List<ACETLGT_AuthorizationSearchResult> outPatientFacilityAuthorizations = new List<ACETLGT_AuthorizationSearchResult>();
        ACETLGT_AuthorizationSearchResult Authorization;        
        List<ACETLGT_FindAuthorizationJSON2Apex.InPatientsSummary> inPatientSRAuthorizations =new List<ACETLGT_FindAuthorizationJSON2Apex.InPatientsSummary>();
        List<ACETLGT_FindAuthorizationJSON2Apex.OutPatientsSummary> outPatientSRAuthorizations =new List<ACETLGT_FindAuthorizationJSON2Apex.OutPatientsSummary>();
        List<ACETLGT_FindAuthorizationJSON2Apex.OutPatientsFacilitySummary> outPatientFacilitySRAuthorizations =new List<ACETLGT_FindAuthorizationJSON2Apex.OutPatientsFacilitySummary>();
        
        try{
            GetEndpoint();
            GetRequestBody(srk, DOB, FirstName,  LastName,  StartDate,  EndDate,FederationID);
            HttpResponse Response = Send(OAuthConfig);
            //Response.setStatusCode(500);
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            Response.setBody(Response.getBody().replaceAll('"desc"','"descr"').replaceAll('"dateTime"','"dteTime"').replaceAll('"date"','"dte"'));
            if (Response.getStatusCode() == 200){
                
                ACETLGT_FindAuthorizationJSON2Apex ACTFPJSON2Apex = (ACETLGT_FindAuthorizationJSON2Apex)JSON.deserialize(Response.getBody(), ACETLGT_FindAuthorizationJSON2Apex.class);
                system.debug('ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                
                
                if(ACTFPJSON2Apex.AuthSummaryResponse != null){
                    if(ACTFPJSON2Apex.AuthSummaryResponse.pagination != null)
                    {
                        vartotalCount = ACTFPJSON2Apex.AuthSummaryResponse.pagination.totalCount;
                    }
                    system.debug(' *** response : ' + ACTFPJSON2Apex.AuthSummaryResponse );
                    
                    if(ACTFPJSON2Apex.AuthSummaryResponse.inPatientsSummary!= null ){    
                        inPatientSRAuthorizations = ACTFPJSON2Apex.AuthSummaryResponse.inPatientsSummary;
                        
                        for (ACETLGT_FindAuthorizationJSON2Apex.InPatientsSummary inpatient: inPatientSRAuthorizations ){
                            
                            Authorization = new ACETLGT_AuthorizationSearchResult();
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
                                system.debug('C Date ::: '+inpatient.createDatetime);
                                Authorization.Create_Date = inpatient.createDatetime==null?'':ACETUtility.format(Date.valueOf(inpatient.createDatetime));
                                Date ipCreatedDate = Date.valueOf(inpatient.createDatetime);                            
                                Authorization.Create_Date = DateTime.newInstance(ipCreatedDate.year(), ipCreatedDate.month(), ipCreatedDate.day()).formatGMT('MM/dd/yyyy');

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

                            //DateTime.parse(inpatient.actualAdmissionDateTime).formatGMT('MM/dd/yyyy');
                            if(inpatient.actualAdmissionDateTime!=null){
                                Authorization.Actual_Admit_Date = inpatient.actualAdmissionDateTime==null?'':ACETUtility.format(Date.valueOf(inpatient.actualAdmissionDateTime));
                                Date ipActualAdmitDate = Date.valueOf(inpatient.actualAdmissionDateTime);                            
                                Authorization.Actual_Admit_Date = DateTime.newInstance(ipActualAdmitDate.year(), ipActualAdmitDate.month(), ipActualAdmitDate.day()).formatGMT('MM/dd/yyyy');
                            }

                            if(inpatient.actualDischargeDateTime!=null){
                                Authorization.Actual_Dscharg_Date = inpatient.actualDischargeDateTime==null?'':ACETUtility.format(Date.valueOf(inpatient.actualDischargeDateTime));
                                Date ipActualDSChargeDate = Date.valueOf(inpatient.actualDischargeDateTime);                            
                                Authorization.Actual_Dscharg_Date = DateTime.newInstance(ipActualDSChargeDate.year(), ipActualDSChargeDate.month(), ipActualDSChargeDate.day()).formatGMT('MM/dd/yyyy');
                            }

                            if(inpatient.expectedAdmitDate!=null){
                                Authorization.Expected_Admit_Date = inpatient.expectedAdmitDate==null?'':ACETUtility.format(Date.valueOf(inpatient.expectedAdmitDate));
                                Date ipExpectedAdmitDate = Date.valueOf(inpatient.expectedAdmitDate);                            
                                Authorization.Expected_Admit_Date = DateTime.newInstance(ipExpectedAdmitDate.year(), ipExpectedAdmitDate.month(), ipExpectedAdmitDate.day()).formatGMT('MM/dd/yyyy');
                            }

                            if(inpatient.expectedDischargeDate!=null){
                                Authorization.Expected_Dscharg_Date = inpatient.expectedDischargeDate==null?'':ACETUtility.format(Date.valueOf(inpatient.expectedDischargeDate));
                                Date ipExpectedDschargeDate = Date.valueOf(inpatient.expectedDischargeDate);                            
                                Authorization.Expected_Dscharg_Date = DateTime.newInstance(ipExpectedDschargeDate.year(), ipExpectedDschargeDate.month(), ipExpectedDschargeDate.day()).formatGMT('MM/dd/yyyy');
                            }
                            Authorization.LOS = inpatient.lengthOfStay==null?'':inpatient.lengthOfStay;
                            
                            String orgName='';
                            String network1Descr='';
                            
                            orgName = inpatient.facilityProviderOrganizationName==null?'':inpatient.facilityProviderOrganizationName;    
                            if(inpatient.facilityProviderNetworkStatusType!=null){     
                                network1Descr = inpatient.facilityProviderNetworkStatusType.description==null?'':inpatient.facilityProviderNetworkStatusType.description;
                            }
                            Authorization.Facility_Status = ACETProviderUtility.validateConcatenateOfStrings(orgName,network1Descr,'/');
                            string jsonString = Authorization.Authorization_Number+'_'+Authorization.Case_Status+'_'+Authorization.Pre_Determination+'_'+Authorization.Create_Date+'_'+Authorization.Expected_Admit_Date+'_'+Authorization.Actual_Admit_Date+'_'+Authorization.Expected_Dscharg_Date+'_'+Authorization.Actual_Dscharg_Date+'_'+Authorization.Facility_Status+'_'+Authorization.Primary_Diagnosis+'_'+Authorization.POS+'_'+Authorization.ServiceDescDetail+'_'+Authorization.LOS;
                            jsonString.replace('null','');  
                            jsonString = EncodingUtil.urlEncode(jsonString, 'UTF-8');                  
                            Authorization.jsonString = jsonString;
                                inPatientAuthorizations.add(Authorization);
                        }
                    }   
                    
                    // Logic for outpatients
                    
                    if(ACTFPJSON2Apex.AuthSummaryResponse.outPatientsSummary!= null ){    
                        outPatientSRAuthorizations = ACTFPJSON2Apex.AuthSummaryResponse.outPatientsSummary ;
                        
                        for (ACETLGT_FindAuthorizationJSON2Apex.OutPatientsSummary outpatient: outPatientSRAuthorizations ){
                            
                            Authorization = new ACETLGT_AuthorizationSearchResult();
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
                                Date opCreatedDate = Date.valueOf(outpatient.createDatetime);                            
                                Authorization.Create_Date = DateTime.newInstance(opCreatedDate.year(), opCreatedDate.month(), opCreatedDate.day()).formatGMT('MM/dd/yyyy');
                            
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
                                Date opStartDate = Date.valueOf(outpatient.serviceDateRange.startDate);                            
                                Authorization.Start_Date = DateTime.newInstance(opStartDate.year(), opStartDate.month(), opStartDate.day()).formatGMT('MM/dd/yyyy');

                                Authorization.End_Date = outpatient.serviceDateRange.stopDate==null?'':ACETUtility.format(Date.valueOf(outpatient.serviceDateRange.stopDate));
                                Date opStopDate = Date.valueOf(outpatient.serviceDateRange.stopDate); 
                                Authorization.End_Date = DateTime.newInstance(opStopDate.year(), opStopDate.month(), opStopDate.day()).formatGMT('MM/dd/yyyy');
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
                            string jsonString = Authorization.Authorization_Number+'_'+Authorization.Case_Status+'_'+Authorization.Pre_Determination+'_'+Authorization.Create_Date+'_'+Authorization.Start_Date+'_'+Authorization.End_Date+'_'+Authorization.ServiceProviderStatus+'_'+Authorization.Primary_Diagnosis+'_'+Authorization.Procedure_Code+'_'+Authorization.Count+'_'+Authorization.POS+'_'+Authorization.ServiceDescDetail;
                   			jsonString.replace('null','');  
                            jsonString = EncodingUtil.urlEncode(jsonString, 'UTF-8');                  
                            Authorization.jsonString = jsonString;
                            outPatientAuthorizations.add(Authorization);
                        }
                        //debug for outPatientAuthorizations list
                    }
                    
                    
                    // OutPatient Facility
                    
                    if(ACTFPJSON2Apex.AuthSummaryResponse.outPatientsFacilitySummary!= null ){    
                        outPatientFacilitySRAuthorizations = ACTFPJSON2Apex.AuthSummaryResponse.outPatientsFacilitySummary;
                        
                        for (ACETLGT_FindAuthorizationJSON2Apex.OutPatientsFacilitySummary outPatientFacility: outPatientFacilitySRAuthorizations ){
                            
                            Authorization = new ACETLGT_AuthorizationSearchResult();
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
                                Date opfCreateDate = Date.valueOf(outPatientFacility.createDatetime); 
                                Authorization.Create_Date = DateTime.newInstance(opfCreateDate.year(), opfCreateDate.month(), opfCreateDate.day()).formatGMT('MM/dd/yyyy');
                                
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

                            if (outPatientFacility.actualAdmissionDateTime != null){
                                Authorization.Actual_Start_Date= outPatientFacility.actualAdmissionDateTime==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.actualAdmissionDateTime));
                                Date opfActualStartDate = Date.valueOf(outPatientFacility.actualAdmissionDateTime); 
                                Authorization.Actual_Start_Date = DateTime.newInstance(opfActualStartDate.year(), opfActualStartDate.month(), opfActualStartDate.day()).formatGMT('MM/dd/yyyy');
                            }
                            
                            if (outPatientFacility.actualDischargeDateTime != null){
                                Authorization.Actual_End_Date = outPatientFacility.actualDischargeDateTime==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.actualDischargeDateTime));
                                Date opfActualEndDate = Date.valueOf(outPatientFacility.actualDischargeDateTime); 
                                Authorization.Actual_End_Date = DateTime.newInstance(opfActualEndDate.year(), opfActualEndDate.month(), opfActualEndDate.day()).formatGMT('MM/dd/yyyy');
                            }

                            if (outPatientFacility.expectedAdmitDate != null){
                                Authorization.Expected_Start_Date = outPatientFacility.expectedAdmitDate==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.expectedAdmitDate));
                                Date opfExpStartDate = Date.valueOf(outPatientFacility.expectedAdmitDate);                            
                                Authorization.Expected_Start_Date = DateTime.newInstance(opfExpStartDate.year(), opfExpStartDate.month(), opfExpStartDate.day()).formatGMT('MM/dd/yyyy');
                            }
                            
                            if (outPatientFacility.expectedDischargeDate != null){
                                Authorization.Expected_End_Date = outPatientFacility.expectedDischargeDate==null?'':ACETUtility.format(Date.valueOf(outPatientFacility.expectedDischargeDate));
                                Date opfExpEndDate = Date.valueOf(outPatientFacility.expectedDischargeDate);
                                Authorization.Expected_End_Date = DateTime.newInstance(opfExpEndDate.year(), opfExpEndDate.month(), opfExpEndDate.day()).formatGMT('MM/dd/yyyy');
                            }

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
                             string jsonString = Authorization.Authorization_Number+'_'+Authorization.Case_Status+'_'+Authorization.Pre_Determination+'_'+Authorization.ServiceProvider+'_'+Authorization.Primary_Diagnosis+'_'+Authorization.Procedure_Code+'_'+Authorization.POS+'_'+Authorization.ServiceDescDetail;
                   		    jsonString.replace('null','');  
                            jsonString = EncodingUtil.urlEncode(jsonString, 'UTF-8');                  
                            Authorization.jsonString = jsonString;
                            outPatientFacilityAuthorizations.add(Authorization);
                            
                        }
                        //debug for outPatientFacilityAuthorizations list
                    }   
                    
                    List<ACETLGT_AuthorizationSearchResult> Authorizations = new List<ACETLGT_AuthorizationSearchResult>();
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
            
            else if (Response.getStatusCode() == 404){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            }else {
                oACETWSCalloutResult.Success = false;
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