public class ACET_CreateAuthWS extends ACETWebService{
    Map<String,String> eniLOBMap = new Map<String,String>{'23' => '7',
        '42' => '14',
        '77' => '14',
        '79' => '14',
        '78' => '14',
        '41' => '15',
        '90' => '15'
        };

    Map<String,Integer> sourceTypeMap = new Map<String,Integer>{
        'Phone' => 1,
            'Email' => 3,
            'FAX' => 11        
            };
                
                Map<String,Integer> roleMap = new Map<String,Integer>{
                    'Facility' => 1,
                        'Member' => 2,
                        'Member Rep' => 3,
                        'Primary Physician' => 4,
                        'Specialist' => 5,
                        'Ancillary Provider' => 6,
                        'Pharmacy' => 182
                        };
                            
                            Map<String,Integer> departmentMap = new Map<String,Integer>{
                                'Admitting' => 1,
                                    'Business Office' => 2,
                                    'Discharge Planning' => 3,
                                    'Emergency Room' => 4,
                                    'Medical Records' => 5,
                                    'Social Services' => 6,
                                    'Utilization Review' => 7
                                    };
                                        
                                        Map<String,Integer> serviceSettingMap = new Map<String,Integer>{
                                            'Inpatient' => 1,
                                                'Outpatient' => 2,
                                                'Outpatient Facility' => 3        
                                                };
                                                    
                                                    Map<String,Integer> placeOfServiceMap = new Map<String,Integer>{
                                                        'Inpatient Rehab' => 61,
                                                            'Acute Hospital' => 21,
                                                            'Hospice' => 34,
                                                            'Skilled Nursing Facility' => 31,
                                                            'Residential' => 56,
                                                            'Home'=>12,
                                                            'Outpatient'=>22,
                                                            'Outpatient Facility'=>24,
                                                            'Ambulatory Surgical Center'=>25,
                                                            'Observation'=>99,
                                                            'Office'=>11
                                                            };
                                                                
                                                                Map<String,Integer> serviceDetailMap = new Map<String,Integer>{
                                                                    'Therapy Services' => 35,
                                                                        'Medical' => 1,
                                                                        'Long Term Acure' => 42,
                                                                        'NICU' => 19,
                                                                        'Maternity' => 3,
                                                                        'Surgical' => 2,
                                                                        'Skilled Nursing' => 31,
                                                                        'Infusion Services' => 15,
                                                                        'Pain Management' => 22,
                                                                        'Mental Health' => 6,
                                                                        'Substance Use Disorder' => 33,
                                                                        'Transplant' => 4,
                                                                        'Transplant Services' => 38,
                                                                        'Custodial'=>51,
                                                                        'Hospice' => 12,
                                                                        'Diagnostic Testing' => 10,
                                                                        'Durable Medical Equipment' => 11,
                                                                        'Pharmacy' => 23,
                                                                        'Dialysis' => 45
                                                                        };  // US3222360
                                                                            
                                                                            Map<String,Integer> procedureCodeTypeMap = new Map<String,Integer>{
                                                                                'CPT' => 2,
                                                                                    'HCPCS' => 4       
                                                                                    };
                                                                                        Map<String,Integer> serviceDescription = new Map<String,Integer>{
                                                                                					'Scheduled' => 1,
                                                                                    				'Urgent' => 2,
                                                                                                    'Emergent' => 3
                                                                                    			};
                                                                                                     Map<String,Integer> proceUnitofMeasureType = new Map<String,Integer>{
                                                                                					'Days' => 1,
                                                                                    				'Hours' => 2,
                                                                                                    'Units' => 3,
                                                                                                    'Visits' => 5
                                                                                    			};
                                                                                                  Map<String,Integer> proceFrequencyType = new Map<String,Integer>{
                                                                                					'Daily' => 1,
                                                                                    				'Weekly' => 2,
                                                                                                    'Monthly' => 3,
                                                                                                    'Yearly' => 4,
                                                                                                    'Every other Day' => 5,
                                                                                    				'Every other Week' => 6,
                                                                                                    'Time(s)' => 7
                                                                                    			};
                                                                                                    Map<String,Integer> dmeProcurementType = new Map<String,Integer>{
                                                                                					'Purchase' => 1,
                                                                                    				'Rental' => 2
                                                                                    			};
                                                                                                Map<String,String> fundingArrangIDMap = new Map<String,String>{'ASO - Erisa' => 'A',
                                                                                                        'ASO' => 'B',
                                                                                                        'Fully Insured' => 'F',
                                                                                                        'All' => 'L',
                                                                                                        'ASO - Non Erisa' => 'N',
                                                                                                        'Excessive Risk' => 'R',
                                                                                                        'Self-Insured / ASO' => 'S',
                                                                                                        'Unknown' => 'U'};

                                                                                                //US3067275 - Swapnil
                                                                                                Map<String,Integer> dischargeDispositionMap = new Map<String,Integer>{
                                                                                                                                    'Ambulance-Air or Water' => 1,
                                                                                                                                    'Assisted Living Facility' => 2,
                                                                                                                                    'Community Mental Health Center' => 3,
                                                                                                                                    'Comprehensive Inpatient Rehabilitation Facility' => 4,
                                                                                                                                    'Comprehensive Outpatient Rehabilitation Facility' => 5,
                                                                                                                                    'Custodial Care Facility' => 6,
                                                                                                                                    'Default Portal Disposition' => 7,
                                                                                                                                    'End-Stage Renal Disease Treatment Facility' => 8,
                                                                                                                                    'Expected Discharge' => 9,
                                                                                                                                    'Group Home' => 10,
                                                                                                                                    'Home with Home Care and/or DME' => 11,
                                                                                                                                    'Home/Against Medical Advice' => 12,
                                                                                                                                    'Hospice' => 13,
                                                                                                                                    'Independent Clinic' => 14,
                                                                                                                                    'Inpatient Hospital' => 15,
                                                                                                                                    'Inpatient Psychiatric Facility' => 16,
                                                                                                                                    'Intermediate Care Facility' => 17,
                                                                                                                                    'Long Term Care' => 18,
                                                                                                                                    'Military Treatment Facility' => 19,
                                                                                                                                    'Expired' => 20,
                                                                                                                                    'No Services/Home' => 21,
                                                                                                                                    'Non-residential Substance Abuse Treatment Facility' => 22,
                                                                                                                                    'Other Place of Service' => 23,
                                                                                                                                    'Partial Hospitalization' => 24,
                                                                                                                                    'Residential Treatment Center' => 25,
                                                                                                                                    'Skilled Nursing Facility' => 26,
                                                                                                                                    'SNF Days Exhausted' => 27,
                                                                                                                                    'Subacute Unit/Ec Team' => 28,
                                                                                                                                    'Home Care' => 29,
                                                                                                                                    'Group Home with Services' => 30,
                                                                                                                                    'Alternate Placement O/S Service Area' => 31,
                                                                                                                                    'Incarcerated' => 32,
                                                                                                                                    'Homeless' => 33,
                                                                                                                                    'Psychiatric Residential Treatment Facility' => 34,
                                                                                                                                    'OASAS Res Tx PerDiem' => 35,
                                                                                                                                    'Other' => 99
                                                                                                                                    };
                                                                                                   //US3067275 ends
                                                                                                   Map<String,String> coverageTypeMap = new Map<String,String>{
                                                                                                                                        'Physical therapy' => 'A',
                                                                                                                                        'Optum Behavioral Health' => 'B',
                                                                                                                                        'Chiropractic' => 'C',
                                                                                                                                        'Dental' => 'D',
                                                                                                                                        'Discount Dental' => 'DD',
                                                                                                                                        'Delta Dental Embedded' => 'DE',
                                                                                                                                        'Delta Dental' => 'DM',
                                                                                                                                        'Discount Pharmacy' => 'DP',
                                                                                                                                        'Discount Vision' => 'DV',
                                                                                                                                        'EAP' => 'E',
                                                                                                                                        'Medical - Commercial'=>'M',
                                                                                                                                        'HealthAllies' => 'HA',
                                                                                                                                        'Medical' => 'M',
                                                                                                                                        'Secondary Medical' => 'MC',
                                                                                                                                        'Executive Medical' => 'ME',
                                                                                                                                        'Secondary Medical' => 'MH',
                                                                                                                                        'Executive Medical' => 'MS',
                                                                                                                                        'Pharmacy' => 'RX',
                                                                                                                                        'Complex Medical Conditions' => 'U',
                                                                                                                                        'Vision' => 'V',
                                                                                                                                        'Medical/Vision' => 'VE',
                                                                                                                                        'Life' => 'W'
                                                                                                                                        };
    //US3116511 TTAP Vishnu
	Map<String,String> insuranceTypeCodeMap = new Map<String,String>{
                                                                        'C1' => '0',
                                                                        'IP' => '0',
                                                                        'MC' => '1',
                                                                        'MA' => '2',
                                                                        'MB' => '2',
                                                                        'MC' => '2'
                                                                     };
                                                                                        static final String OIL_RESOURCE = 'CaseSubmitEndpoint';
    static final Integer RESPONSE_SUCCESS_CODE = 200;
    static final String TTAP_Value = 'TTAPEndPoint';//US2356238 TTAP
    static final String VALIDATION_SERVICE_RESOURCE = 'ACET_ValidationApiEndpoint'; //US3068301 - Sarma - 20/01/2021
    Public static String oilString=TTAP_Value;

    // US3137520
    public ACET_CreateAuthWS(){
        super(SAEConstants.STARGATE_STG_SERVICENAME); 
        if(Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c){
            this(SAEConstants.STARGATE_STG_SERVICENAME);
        }
    }

    // US3137520
    public ACET_CreateAuthWS(String serviceName){
        super(serviceName, 'Training');
    }
    
    //set endpoints
    public override void getEndpoint(){
        GetEndpointDetail(oilString);
    }
    
    //create request body
    public void getRequestBody(String reqParams) {
        RequestBody = reqParams;
        System.debug('###REQUEST-BODY:'+RequestBody);
    }    
    
    public ACETWSCalloutResult createAuth(String authData){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_CreateAuthCtrl.ACET_SRNResponseWrap result = new ACET_CreateAuthCtrl.ACET_SRNResponseWrap();
        try{
            HttpResponse response;
            HttpResponse ttapResponse;
            Boolean isStaticResponseChecked = false;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                calloutResult=getTTAPMockResponse();
                result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)CalloutResult.Response;
                if(result.returnDecisionValueType.equalsIgnoreCase('TTAP'))//US2356238 TTAP _by Vishnu
                {
                    return CalloutResult;
                }
                else
                {
              calloutResult = processResponse();
                    return calloutResult;
                }
            }else{//US2356238 TTAP _by Vishnu
                String reqParams = requestFormatProcessing(authData);
                getRequestBody(reqParams);  
                getEndpoint();
                Headers.put('EISL-Channel', 'ACET');
                Headers.put('EISL-Partner', 'ACET');
                ttapResponse=response = Send(OAuthConfig);
                Integer ttapStatusCode = response.getStatusCode();
                System.debug('TTAP@@@ ' + ttapStatusCode);
                result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(response.getBody(),ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
                if(ttapStatusCode==200 && (!(String.isBlank(String.valueOf(result.returnDecisionValueType)))) && (result.returnDecisionValueType.equalsIgnoreCase('TTAP'))
                   && (!(String.isBlank(String.valueOf(result.redirectUrl)))) && ((String.valueOf(result.redirectUrl).containsIgnoreCase('https'))))
                {
                    result.responseType='TTAP';
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = result;
                    createAppErrorLog('ACET_Spire', 'TTAP Response',ttapResponse.getStatus(), ttapResponse.getStatusCode(),reqParams,ttapResponse.getBody());
                    return calloutResult;
                }else{
                    //US3068301 - Sarma - 20/01/2021
                    // Updating Real service Logic to cater Validation API callout.
                    // Will be calling it whenever TTAP fails & create a record in custom object.
                    HttpResponse validationResponse;
                    oilString = VALIDATION_SERVICE_RESOURCE;
                    getEndpoint();
                    validationResponse = Send(OAuthConfig);
                    System.debug('Validation API statuscode @@@ ' + validationResponse.getStatusCode());
                    System.debug('Validation API @@@ validationResponse' + validationResponse);
                    //US3068301 - End

                    //case submit
                    oilString=OIL_RESOURCE;
                    getEndpoint();
                response = Send(OAuthConfig);
                    Integer statusCode = response.getStatusCode();
                    calloutResult.statusCode = statusCode;
                    if(ttapStatusCode==200 && (!(String.isBlank(String.valueOf(result.returnDecisionValueType)))) && (result.returnDecisionValueType.equalsIgnoreCase('TTAP'))
                       && (!(String.isBlank(String.valueOf(result.redirectUrl)))))
                    {
                        createAppErrorLog('ACET_Spire', 'TTAP redirectUrl is getting empty or null',ttapResponse.getStatus(), ttapResponse.getStatusCode(),reqParams,ttapResponse.getBody());

                    }else
                    {
                        createAppErrorLog('ACET_Spire', 'TTAP Response',ttapResponse.getStatus(), ttapResponse.getStatusCode(),reqParams,ttapResponse.getBody());
                    }

                    if(statusCode == 200 || statusCode == 201) {
                    result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(response.getBody(),ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
                        result.responseType='CaseSubmit';
                }else{
                    result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(response.getBody(),ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
                        result.responseType='CaseSubmit failed';
                        result.responseCode = String.valueOf(statusCode);
                        system.debug('Error Case Submit@@@ ' + response.getBody());
                    calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    calloutResult.Success = true; 
                        calloutResult.statusCode = statusCode;
                        calloutResult.Message = '';
                        calloutResult.Response = result;
                        //US3068301
                        createAppErrorLog('ACET_Spire', 'TTAP errorlog from Validation rules',validationResponse.getStatus(), validationResponse.getStatusCode(),reqParams,validationResponse.getBody());
                        return calloutResult;
                    /*if(StatusCode == 404)
                        {
                        	calloutResult.Message = SAEMemberStandaloneSearchWebService.getErrorMessage(SAEConstants.GN404);
                        }else if(StatusCode == 500 || StatusCode == 400)
                        {
                        	calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                    	} */
                } 
                    //US3068301
                    createAppErrorLog('ACET_Spire', 'TTAP errorlog from Validation rules',validationResponse.getStatus(), validationResponse.getStatusCode(),reqParams,validationResponse.getBody());
                }


                calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = result; 
            }
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            //System.debug('@@@@Exceptionr'+e);
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.statusCode=999;
        } 
        return calloutResult;
    }
    
    
    private String requestFormatProcessing(String authData){                
        system.debug(loggingLevel.Info, 'authData@@' + authData);
        Map<String, Object> authDetailsMap = (Map<String, Object>)JSON.deserializeUntyped(authData);
        Map<String, Object> SRNDataMap = new Map<String, Object>();
        Map<String, Object> requiredInfoMap = new Map<String, Object>();
        List<Object> prdvDetailLst = new List<Object>();
        Map<String, Object> commContactMap = new Map<String, Object>();
        Map<String, Object> submitInfoMap = new Map<String, Object>();
        String serviceProviderSeqNum;
        if (authDetailsMap.containsKey('SRNData')) {
            Object SRNDataObj  = authDetailsMap.get('SRNData');
            String srnString = String.valueOf(SRNDataObj);
            
            SRNDataMap = (Map<String, Object>)JSON.deserializeUntyped(srnString);
            if (SRNDataMap.containsKey('RequiredInfo')) {
                requiredInfoMap = (Map<String, Object>)SRNDataMap.get('RequiredInfo');
            }     

            if (SRNDataMap.containsKey('CommContact')) {
                commContactMap = (Map<String, Object>)SRNDataMap.get('CommContact');
            }
            
            if (SRNDataMap.containsKey('SubmitInfo')) {
                submitInfoMap = (Map<String, Object>)SRNDataMap.get('SubmitInfo');
            }                               
        }
        
        if (authDetailsMap.containsKey('providerDetail')) {
            Object providerDetailObj  = authDetailsMap.get('providerDetail');
            String providerDetailStr = String.valueOf(providerDetailObj);
            prdvDetailLst = (List<Object>)JSON.deserializeUntyped(providerDetailStr);
            System.debug('providerDetailMap@@@' + prdvDetailLst);
        }
        
        ACET_ExtendedServiceController.ExtendedServiceWrapper extendeResult = (ACET_ExtendedServiceController.ExtendedServiceWrapper)JSON.deserialize((String)authDetailsMap.get('extendeResult'),ACET_ExtendedServiceController.ExtendedServiceWrapper.Class);
        //system.debug('extendeResult' + extendeResult);
        SAEMemberProviderSearchCoveragesResult memberDataResult= (SAEMemberProviderSearchCoveragesResult)(JSON.deserialize((String)authDetailsMap.get('memberDataResult'),SAEMemberProviderSearchCoveragesResult.Class));
        //system.debug('memberDataResult' + memberDataResult);
        // US3507486 - Create Auth  Update Funding Arrangement Value : Sarma - 10th May 2021
        ACET_ReadConsumerEligibilityService.RCEDDetailsForCreateAuth rcedResult = (ACET_ReadConsumerEligibilityService.RCEDDetailsForCreateAuth)(JSON.deserialize((String)authDetailsMap.get('RcedData'),ACET_ReadConsumerEligibilityService.RCEDDetailsForCreateAuth.Class));
        system.debug('RCED Response' + rcedResult);

        String reqJSON;
        ACET_CreateAuthRequest authRequest = new ACET_CreateAuthRequest();       
        
        // Passing Federation ID in userID
        String loggedInUserID= UserInfo.getUserId();
        User loggedInUser= [SELECT Name, Email, FederationIdentifier, Lastname, Firstname FROM User WHERE Id= :loggedInUserID];
        System.debug('Logged in USER : '+ loggedInUser);

        //Fill invocationContext details
        ACET_CreateAuthRequest.InvocationContext invocationContext = new ACET_CreateAuthRequest.InvocationContext();
        invocationContext.clientID = 'ACET';//'EMR-PerfTest';
        invocationContext.locationID = 'ACET';//'EMR-PerfTest';
        invocationContext.userID = loggedInUser.FederationIdentifier; //'ACET'; //'EMR-PerfTest';
        invocationContext.userIDType = 'USER_ID';//'USER_ID';
        invocationContext.clientCorrelationID = '';//'9876-CLIENTCORR-TEST-1234';
        invocationContext.serviceCorrelationID = '';//'9876-CLIENTCORR-TEST-1234';
        authRequest.invocationContext = invocationContext;
        
        //Fill metadata details 
        ACET_CreateAuthRequest.Metadata metaData = new ACET_CreateAuthRequest.Metadata();
        metaData.clientGroup = 'ACET';//'EMR-PerfTest';
        metaData.clientBusiness = 'ACET';//'EMR-PerfTest';
        metaData.clientLocation = '';//'EMR-PerfTest';
        metaData.clientNPI = '';//'12345678';
        metaData.caseSubmissionTransactionID = '';//9876-CASE-TRANSID-TEST-1234;
        authRequest.metadata = metaData;
        
        authRequest.transactionId = '';
        
        //Fill caseDetails
        ACET_CreateAuthRequest.CaseDetails caseDetails = new ACET_CreateAuthRequest.CaseDetails();        
        
        //caseDetails => hscDiagnoses
        ACET_CreateAuthRequest.HscDiagnoses hscDiagnoses = new ACET_CreateAuthRequest.HscDiagnoses();
        List<ACET_CreateAuthRequest.HscDiagnosis> hscDiagnosisLst = new List<ACET_CreateAuthRequest.HscDiagnosis>();
        
        Integer seqNum=1;
        if(requiredInfoMap.containsKey('PrimaryCode') && strNotBlank(requiredInfoMap.get('PrimaryCode'))){
            System.debug('PrimaryCode@@ ' + requiredInfoMap.get('PrimaryCode'));
            ACET_CreateAuthRequest.HscDiagnosis hscDiagnosis = new ACET_CreateAuthRequest.HscDiagnosis();
            hscDiagnosis.primaryInd = 'true';
            hscDiagnosis.diagnosisCodeType = '0';
            hscDiagnosis.diagnosisSeqNum = String.valueOf(seqNum);
            hscDiagnosis.diagnosisCode = String.valueOf(requiredInfoMap.get('PrimaryCode'));
            hscDiagnosisLst.add(hscDiagnosis);
        }
        
        if(requiredInfoMap.containsKey('AdmittingCode') && strNotBlank(requiredInfoMap.get('AdmittingCode'))){
            seqNum++;
            ACET_CreateAuthRequest.HscDiagnosis hscDiagnosis = new ACET_CreateAuthRequest.HscDiagnosis();
            hscDiagnosis.admitInd = 'true';
            hscDiagnosis.diagnosisCodeType = '0';
            hscDiagnosis.diagnosisSeqNum = String.valueOf(seqNum);
            hscDiagnosis.diagnosisCode = String.valueOf(requiredInfoMap.get('AdmittingCode'));
            hscDiagnosisLst.add(hscDiagnosis);
        }
        
        if(requiredInfoMap.containsKey('DiagnosisData')){
            List<Object> DiagnosisData = (List<Object>)requiredInfoMap.get('DiagnosisData');
            for(Object diagnosisObj : DiagnosisData){
                Map<String, Object> diagnosisMap = (Map<String, Object>)diagnosisObj;
                if(strNotBlank(diagnosisMap.get('DiagnosisCode'))){
                    seqNum++;
                    ACET_CreateAuthRequest.HscDiagnosis hscDiagnosis = new ACET_CreateAuthRequest.HscDiagnosis();
                    hscDiagnosis.primaryInd = 'false';
                    hscDiagnosis.diagnosisCodeType = '0';
                    hscDiagnosis.diagnosisSeqNum = String.valueOf(seqNum);
                    hscDiagnosis.diagnosisCode = String.valueOf(diagnosisMap.get('DiagnosisCode'));
                    hscDiagnosisLst.add(hscDiagnosis);

                }                
            }
        }
        if(hscDiagnosisLst != null && hscDiagnosisLst.size() > 0){
            hscDiagnoses.hscDiagnosis = hscDiagnosisLst;
        }        
        
        caseDetails.hscDiagnoses = hscDiagnoses;
        
        //caseDetails => hscProviders
        ACET_CreateAuthRequest.HscProviders hscProviders = new ACET_CreateAuthRequest.HscProviders();
        List<ACET_CreateAuthRequest.HscProvider> hscProviderLst = new List<ACET_CreateAuthRequest.HscProvider>();
        
               

        system.debug('prdvDetailLst@@ ' + prdvDetailLst);
        for(Object provdDetailObj : prdvDetailLst){
            //hscProviders => providerRoles
            ACET_CreateAuthRequest.ProviderRoles providerRoles = new ACET_CreateAuthRequest.ProviderRoles();
            List<ACET_CreateAuthRequest.ProviderRole> providerRoleLst = new List<ACET_CreateAuthRequest.ProviderRole>();
            Map<String, Object> prdDetailMap = (Map<String, Object>)provdDetailObj;
            
            ACET_CreateAuthRequest.HscProvider hscProvider = new ACET_CreateAuthRequest.HscProvider();
            system.debug('providerRoles@@ ' + prdDetailMap.get('providerRoles'));
            if(prdDetailMap.containsKey('providerRoles')){
                Object providerRolesObj  = prdDetailMap.get('providerRoles');
                Map<String, Object> prdRolesMap = (Map<String, Object>)providerRolesObj;
                List<Object> prdvRoleLst = new List<Object>();
                if(prdRolesMap.containsKey('providerRole')){
                    prdvRoleLst = (List<Object>)prdRolesMap.get('providerRole');
                }
                
                if(prdvRoleLst != null){
                    for(Object provdRoleObj : prdvRoleLst){
                        Map<String, Object> roleMapObj = (Map<String, Object>)provdRoleObj;
                        
                        ACET_CreateAuthRequest.ProviderRole providerRole = new ACET_CreateAuthRequest.ProviderRole();
                        providerRole.providerRole = roleMapObj.containsKey('providerRole')?objStrOrNull(roleMapObj.get('providerRole')):null;//String.isNotBlank(String.valueOf(roleMapObj.get('providerRole')))?String.valueOf(roleMapObj.get('providerRole')):null:null;
                        if(providerRole.providerRole=='SJ')
                        {
                           serviceProviderSeqNum= prdDetailMap.containsKey('providerSeqNum') ? String.valueOf(prdDetailMap.get('providerSeqNum')) : null;
                        }
                        providerRole.providerRoleDesc = roleMapObj.containsKey('providerRoleDesc')?objStrOrNull(roleMapObj.get('providerRoleDesc')):null;//String.isNotBlank(String.valueOf(roleMapObj.get('providerRoleDesc')))?String.valueOf(roleMapObj.get('providerRoleDesc')):null:null;
                        providerRoleLst.add(providerRole);
                        providerRoles.providerRole = providerRoleLst;
                    } 
                    
                }				
            }else{
                ACET_CreateAuthRequest.ProviderRole providerRole = new ACET_CreateAuthRequest.ProviderRole();
                providerRole.providerRole = null;
                providerRole.providerRoleDesc = null;
                providerRoleLst.add(providerRole);
                providerRoles.providerRole = providerRoleLst;
            }
            
            hscProvider.providerRoles = providerRoles;
            system.debug('hscProvider.providerRoles@@ ' + hscProvider.providerRoles);
            //hscProviders => providerContractOrgs
            ACET_CreateAuthRequest.ProviderContractOrgs providerContractOrgs = new ACET_CreateAuthRequest.ProviderContractOrgs();
            List<ACET_CreateAuthRequest.ProviderContractOrg> providerContractOrgLst = new List<ACET_CreateAuthRequest.ProviderContractOrg>();
            
            // US3507490	Mapping for Contract Org Type and Amendment - Sarma - 20th May 2021
            if(prdDetailMap.containsKey('providerContractOrgs')){
                Map<String, Object> contrctOrgsMap = (Map<String, Object>)prdDetailMap.get('providerContractOrgs');
                
               if(contrctOrgsMap.containsKey('providerContractOrg')){
                    List<Object> contractOrgsLst = (List<Object>)contrctOrgsMap.get('providerContractOrg');

                   if(contractOrgsLst != null){
                       for(Object provdContractOrgsObj : contractOrgsLst){
                            Map<String, Object> contractOrgsMap = (Map<String, Object>)provdContractOrgsObj;
                            
                            ACET_CreateAuthRequest.ProviderContractOrg providerContractOrg = new ACET_CreateAuthRequest.ProviderContractOrg();  
                            providerContractOrg.providerContractOrg = contractOrgsMap.containsKey('providerContractOrg')?objStrOrNull(contractOrgsMap.get('providerContractOrg')):null;// contractOrgsMap.containsKey('providerContractOrg')?String.isNotBlank(String.valueOf(contractOrgsMap.get('providerContractOrg')))?String.valueOf(contractOrgsMap.get('providerContractOrg')):null:null;
                            providerContractOrg.providerContractContext = contractOrgsMap.containsKey('providerContractContext')?objStrOrNull(contractOrgsMap.get('providerContractContext')):null;
                            providerContractOrg.providerContractOrgPriority = contractOrgsMap.containsKey('providerContractOrgPriority')?objStrOrNull(contractOrgsMap.get('providerContractOrgPriority')):null;
                            providerContractOrgLst.add(providerContractOrg);
                            providerContractOrgs.providerContractOrg = providerContractOrgLst;
                       }

                   }

                }
            }
            providerContractOrgs.providerContractOrg = providerContractOrgLst;
            hscProvider.providerContractOrgs = providerContractOrgs;



            //hscProviders => providerContractAmendment
            ACET_CreateAuthRequest.ProviderContractAmendments providerContractAmendments = new ACET_CreateAuthRequest.ProviderContractAmendments();
            List<ACET_CreateAuthRequest.ProviderContractAmendment> providerContractAmendmentList = new List<ACET_CreateAuthRequest.ProviderContractAmendment>();

            if(prdDetailMap.containsKey('providerContractAmendments')){
                Map<String, Object> contrctAmendmentMap = (Map<String, Object>)prdDetailMap.get('providerContractAmendments');

               if(contrctAmendmentMap.containsKey('providerContractAmendment')){
                    List<Object> contractAmendmentsLst = (List<Object>)contrctAmendmentMap.get('providerContractAmendment');

                   if(contractAmendmentsLst != null){
                       for(Object contractAmendmentObj : contractAmendmentsLst){
                            Map<String, Object> contractAmendmentsMap = (Map<String, Object>)contractAmendmentObj;

                            ACET_CreateAuthRequest.ProviderContractAmendment providerContractAmendment = new ACET_CreateAuthRequest.ProviderContractAmendment();
                            providerContractAmendment.contractDocumentID = contractAmendmentsMap.containsKey('contractDocumentID')?objStrOrNull(contractAmendmentsMap.get('contractDocumentID')):null;
                            providerContractAmendment.startDate = contractAmendmentsMap.containsKey('startDate')?objStrOrNull(contractAmendmentsMap.get('startDate')):null;
                            providerContractAmendment.endDate = contractAmendmentsMap.containsKey('endDate')?objStrOrNull(contractAmendmentsMap.get('endDate')):null;
                            providerContractAmendment.medicalNecessityTypeID = contractAmendmentsMap.containsKey('medicalNecessityTypeID')?objStrOrNull(contractAmendmentsMap.get('medicalNecessityTypeID')):null;
                            providerContractAmendment.providerContractAmendmentType = contractAmendmentsMap.containsKey('providerContractAmendmentType')?objStrOrNull(contractAmendmentsMap.get('providerContractAmendmentType')):null;
                            providerContractAmendmentList.add(providerContractAmendment);
                            providerContractAmendments.providerContractAmendment = providerContractAmendmentList;
                       }

                   }

                }
            }
            providerContractAmendments.providerContractAmendment = providerContractAmendmentList;
            hscProvider.providerContractAmendments = providerContractAmendments;


            // US3507490 Ends
            
            //hscProviders => providerIdentifiers //US3587915 - Removing 0 prefix for new provider API
            ACET_CreateAuthRequest.ProviderIdentifiers providerIdentifiers = new ACET_CreateAuthRequest.ProviderIdentifiers();
            List<ACET_CreateAuthRequest.ProviderIdentifier> providerIdentifierLst = new List<ACET_CreateAuthRequest.ProviderIdentifier>();
            system.debug('ProviderIdentifier@@ s' + prdDetailMap.get('providerIdentifiers'));
            if(prdDetailMap.containsKey('providerIdentifiers')){
                Object idtfierObj = prdDetailMap.get('providerIdentifiers');
                Map<String, Object> identifiersMap = (Map<String, Object>)idtfierObj;
                List<Object> prdvIdentifiersLst = new List<Object>();
                if(identifiersMap.containsKey('providerIdentifier')){
                    prdvIdentifiersLst = (List<Object>)identifiersMap.get('providerIdentifier');
                    
                    if(prdvIdentifiersLst != null){
                        for(Object identifierObj : prdvIdentifiersLst){
                            Map<String, Object> provdIdentifierMap = (Map<String, Object>)identifierObj;
                            ACET_CreateAuthRequest.ProviderIdentifier providerIdentifier = new ACET_CreateAuthRequest.ProviderIdentifier();  
                            if(String.valueOf(provdIdentifierMap.get('providerIDType')) != '4'){
                                providerIdentifier.providerIDType = provdIdentifierMap.containsKey('providerIDType')?String.valueOf(provdIdentifierMap.get('providerIDType')):null;
                                providerIdentifier.providerIDText = provdIdentifierMap.containsKey('providerIDText')?String.valueOf(provdIdentifierMap.get('providerIDText')):null;
                                providerIdentifier.providerIDDesc = null;
                                providerIdentifierLst.add(providerIdentifier);
                                providerIdentifiers.providerIdentifier = providerIdentifierLst;
                            }
                            
                        }
                        //hscProvider.providerIdentifiers = providerIdentifiers;
                    }else{
                        ACET_CreateAuthRequest.ProviderIdentifier providerIdentifier = new ACET_CreateAuthRequest.ProviderIdentifier(); 
                        providerIdentifier.providerIDType = '';
                        providerIdentifier.providerIDText = ''; 
                        providerIdentifier.providerIDDesc = '';
                        providerIdentifierLst.add(providerIdentifier);
                    } 
                    hscProvider.providerIdentifiers = providerIdentifiers;  
                }
            }                                  

            hscProvider.providerSeqNum = prdDetailMap.containsKey('providerSeqNum') ? Integer.valueOf(prdDetailMap.get('providerSeqNum')) : null;
            hscProvider.providerCategory = prdDetailMap.containsKey('providerCategory')?objStrOrNull(prdDetailMap.get('providerCategory')):null;    					//String.isNotBlank(String.valueOf(prdDetailMap.get('providerCategory')))?String.valueOf(prdDetailMap.get('providerCategory')):null:null;
            hscProvider.businessName = prdDetailMap.containsKey('businessName')?objStrOrNull(prdDetailMap.get('businessName')):null;    						        //String.isNotBlank(String.valueOf(prdDetailMap.get('businessName')))?String.valueOf(prdDetailMap.get('businessName')):null:null;
            hscProvider.firstName = prdDetailMap.containsKey('firstName')?objStrOrNull(prdDetailMap.get('firstName')):null;    						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('firstName')))?String.valueOf(prdDetailMap.get('firstName')):null:null;
            hscProvider.middleName = prdDetailMap.containsKey('middleName')?objStrOrNull(prdDetailMap.get('middleName')):null;    						        			   //String.isNotBlank(String.valueOf(prdDetailMap.get('middleName')))?String.valueOf(prdDetailMap.get('middleName')):null:null;
            hscProvider.lastName = prdDetailMap.containsKey('lastName')?objStrOrNull(prdDetailMap.get('lastName')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('lastName')))?String.valueOf(prdDetailMap.get('lastName')):null:null;
            hscProvider.suffixName = prdDetailMap.containsKey('suffixName')?objStrOrNull(prdDetailMap.get('suffixName')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('suffixName')))?String.valueOf(prdDetailMap.get('suffixName')):null:null;
            hscProvider.address1 = prdDetailMap.containsKey('address1')?objStrOrNull(prdDetailMap.get('address1')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('address1')))?String.valueOf(prdDetailMap.get('address1')):null:null;
            hscProvider.address2 = prdDetailMap.containsKey('address2')?objStrOrNull(prdDetailMap.get('address2')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('address2')))?String.valueOf(prdDetailMap.get('address2')):null:null;
            hscProvider.city = prdDetailMap.containsKey('city')?objStrOrNull(prdDetailMap.get('city')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('city')))?String.valueOf(prdDetailMap.get('city')):null:null;
            hscProvider.vanityCity = prdDetailMap.containsKey('vanityCity')?objStrOrNull(prdDetailMap.get('vanityCity')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('vanityCity')))?String.valueOf(prdDetailMap.get('vanityCity')):null:null;
            hscProvider.state = prdDetailMap.containsKey('state')?objStrOrNull(prdDetailMap.get('state')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('state')))?String.valueOf(prdDetailMap.get('state')):null:null;
            hscProvider.stateDesc = prdDetailMap.containsKey('stateDesc')?objStrOrNull(prdDetailMap.get('stateDesc')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('stateDesc')))?String.valueOf(prdDetailMap.get('stateDesc')):null:null;
            hscProvider.zip = prdDetailMap.containsKey('zip')?objStrOrNull(prdDetailMap.get('zip')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('zip')))?String.valueOf(prdDetailMap.get('zip')):null:null;
            hscProvider.zipSuffix = prdDetailMap.containsKey('zipSuffix')?objStrOrNull(prdDetailMap.get('zipSuffix')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('zipSuffix')))?String.valueOf(prdDetailMap.get('zipSuffix')):null:null;
            hscProvider.specialtyType = prdDetailMap.containsKey('specialtyType')?objStrOrNull(prdDetailMap.get('specialtyType')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('specialtyType')))?String.valueOf(prdDetailMap.get('specialtyType')):null:null;
            hscProvider.specialtyTypeDesc = prdDetailMap.containsKey('specialtyTypeDesc')?objStrOrNull(prdDetailMap.get('specialtyTypeDesc')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('specialtyTypeDesc')))?String.valueOf(prdDetailMap.get('specialtyTypeDesc')):null:null;
            hscProvider.specialtyTypeCirrus = prdDetailMap.containsKey('specialtyTypeCirrus')?objStrOrNull(prdDetailMap.get('specialtyTypeCirrus')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('specialtyTypeCirrus')))?String.valueOf(prdDetailMap.get('specialtyTypeCirrus')):null:null;
            hscProvider.specialtyTypeCirrusDesc = prdDetailMap.containsKey('specialtyTypeCirrusDesc')?objStrOrNull(prdDetailMap.get('specialtyTypeCirrusDesc')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('specialtyTypeCirrusDesc')))?String.valueOf(prdDetailMap.get('specialtyTypeCirrusDesc')):null:null;
            hscProvider.marketNumber = prdDetailMap.containsKey('marketNumber')?objStrOrNull(prdDetailMap.get('marketNumber')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('marketNumber')))?String.valueOf(prdDetailMap.get('marketNumber')):null:null;
            hscProvider.productType = prdDetailMap.containsKey('productType')?objStrOrNull(prdDetailMap.get('productType')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('productType')))?String.valueOf(prdDetailMap.get('productType')):null:null;
            if(prdDetailMap.containsKey('primaryPhone') && (objStrOrNull('primaryPhone') !=null)){
                String primaryPhStr = String.valueOf(prdDetailMap.get('primaryPhone'));
                hscProvider.primaryPhone = primaryPhStr.substring(0, 3)+'-'+primaryPhStr.substring(3, 6)+'-'+primaryPhStr.substring(6, primaryPhStr.length());
            }
            
            hscProvider.primaryPhoneInternationalInd = prdDetailMap.containsKey('primaryPhoneInternationalInd') ? Boolean.valueOf(prdDetailMap.get('primaryPhoneInternationalInd')) : false;
            hscProvider.fax = prdDetailMap.containsKey('fax')?objStrOrNull(prdDetailMap.get('fax')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('fax')))?String.valueOf(prdDetailMap.get('fax')):null:null;
            hscProvider.faxInternationalInd = prdDetailMap.containsKey('faxInternationalInd')? Boolean.valueOf(prdDetailMap.get('faxInternationalInd')):false;
            hscProvider.detailInd = prdDetailMap.containsKey('detailInd') ? Boolean.valueOf(prdDetailMap.get('detailInd')) : false;
            hscProvider.countyName = prdDetailMap.containsKey('countyName')?objStrOrNull(prdDetailMap.get('countyName')):null;       						        			//String.isNotBlank(String.valueOf(prdDetailMap.get('countyName')))?String.valueOf(prdDetailMap.get('countyName')):null:null;
            hscProvider.countryCode = prdDetailMap.containsKey('countryCode')?objStrOrNull(prdDetailMap.get('countryCode')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('countryCode')))?String.valueOf(prdDetailMap.get('countryCode')):null:null;
            hscProvider.productMarketType = prdDetailMap.containsKey('productMarketType')?objStrOrNull(prdDetailMap.get('productMarketType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('productMarketType')))?String.valueOf(prdDetailMap.get('productMarketType')):null:null;
            hscProvider.contractID = prdDetailMap.containsKey('contractID')?objStrOrNull(prdDetailMap.get('contractID')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('contractID')))?String.valueOf(prdDetailMap.get('contractID')):null:null;
            hscProvider.contractInd = prdDetailMap.containsKey('contractInd') ? Boolean.valueOf(prdDetailMap.get('contractInd')) : false;
            hscProvider.providerEffectiveDate = prdDetailMap.containsKey('providerEffectiveDate')?objStrOrNull(prdDetailMap.get('providerEffectiveDate')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('providerEffectiveDate')))?String.valueOf(prdDetailMap.get('providerEffectiveDate')):null:null;
            hscProvider.providerTerminationDate = prdDetailMap.containsKey('providerTerminationDate')?objStrOrNull(prdDetailMap.get('providerTerminationDate')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('providerTerminationDate')))?String.valueOf(prdDetailMap.get('providerTerminationDate')):null:null;
            hscProvider.individualProvAssociationID = prdDetailMap.containsKey('individualProvAssociationID')?objStrOrNull(prdDetailMap.get('individualProvAssociationID')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('individualProvAssociationID')))?String.valueOf(prdDetailMap.get('individualProvAssociationID')):null:null;
            hscProvider.emergentWrapContractTypeID = prdDetailMap.containsKey('emergentWrapContractTypeID')?objStrOrNull(prdDetailMap.get('emergentWrapContractTypeID')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('emergentWrapContractTypeID')))?String.valueOf(prdDetailMap.get('emergentWrapContractTypeID')):null:null;
            hscProvider.optOutLabVendorType = prdDetailMap.containsKey('optOutLabVendorType')?objStrOrNull(prdDetailMap.get('optOutLabVendorType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('optOutLabVendorType')))?String.valueOf(prdDetailMap.get('optOutLabVendorType')):null:null;
            hscProvider.providerOrgType = prdDetailMap.containsKey('providerOrgType')?objStrOrNull(prdDetailMap.get('providerOrgType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('providerOrgType')))?String.valueOf(prdDetailMap.get('providerOrgType')):null:null;
            hscProvider.tpsmType = prdDetailMap.containsKey('tpsmType')?objStrOrNull(prdDetailMap.get('tpsmType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('tpsmType')))?String.valueOf(prdDetailMap.get('tpsmType')):null:null;
            hscProvider.providerMedicaidLocationCode = prdDetailMap.containsKey('providerMedicaidLocationCode')?objStrOrNull(prdDetailMap.get('providerMedicaidLocationCode')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('providerMedicaidLocationCode')))?String.valueOf(prdDetailMap.get('providerMedicaidLocationCode')):null:null;
            hscProvider.medicalRecordNumber = commContactMap.containsKey('MedicalRecord')?objStrOrNull(commContactMap.get('MedicalRecord')):null;
            //hscProvider.medicalRecordNumber = prdDetailMap.containsKey('medicalRecordNumber')?objStrOrNull(prdDetailMap.get('medicalRecordNumber')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('medicalRecordNumber')))?String.valueOf(prdDetailMap.get('medicalRecordNumber')):null:null;
            hscProvider.networkSteerageReasonType = prdDetailMap.containsKey('networkSteerageReasonType')?objStrOrNull(prdDetailMap.get('networkSteerageReasonType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('networkSteerageReasonType')))?String.valueOf(prdDetailMap.get('networkSteerageReasonType')):null:null;
            hscProvider.networkTier = prdDetailMap.containsKey('networkTier')?objStrOrNull(prdDetailMap.get('networkTier')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('networkTier')))?String.valueOf(prdDetailMap.get('networkTier')):null:null;
            hscProvider.networkStatusTypeDesc = prdDetailMap.containsKey('networkStatusTypeDesc')?objStrOrNull(prdDetailMap.get('networkStatusTypeDesc')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('networkStatusTypeDesc')))?String.valueOf(prdDetailMap.get('networkStatusTypeDesc')):null:null;
            hscProvider.networkStatusType = prdDetailMap.containsKey('networkStatusType')?objStrOrNull(prdDetailMap.get('networkStatusType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('networkStatusType')))?String.valueOf(prdDetailMap.get('networkStatusType')):null:null;
            hscProvider.preferredNetworkInd = prdDetailMap.containsKey('preferredNetworkInd')?objStrOrNull(prdDetailMap.get('preferredNetworkInd')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('preferredNetworkInd')))?String.valueOf(prdDetailMap.get('preferredNetworkInd')):null:null;
            hscProvider.incentInd = prdDetailMap.containsKey('incentInd')?objStrOrNull(prdDetailMap.get('incentInd')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('incentInd')))?String.valueOf(prdDetailMap.get('incentInd')):null:null;
            hscProvider.contractRoleCode = prdDetailMap.containsKey('contractRoleCode')?objStrOrNull(prdDetailMap.get('contractRoleCode')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('contractRoleCode')))?String.valueOf(prdDetailMap.get('contractRoleCode')):null:null;
            hscProvider.uhpdTierDemotInd = prdDetailMap.containsKey('uhpdTierDemotInd')?objStrOrNull(prdDetailMap.get('uhpdTierDemotInd')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('uhpdTierDemotInd')))?String.valueOf(prdDetailMap.get('uhpdTierDemotInd')):null:null;
            hscProvider.providerContract = prdDetailMap.containsKey('providerContract')?objStrOrNull(prdDetailMap.get('providerContract')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('providerContract')))?String.valueOf(prdDetailMap.get('providerContract')):null:null;
            hscProvider.acoName = prdDetailMap.containsKey('acoName')?objStrOrNull(prdDetailMap.get('acoName')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('acoName')))?String.valueOf(prdDetailMap.get('acoName')):null:null;
            hscProvider.acoID = prdDetailMap.containsKey('acoID')?objStrOrNull(prdDetailMap.get('acoID')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('acoID')))?String.valueOf(prdDetailMap.get('acoID')):null:null;
            hscProvider.niceProviderType = prdDetailMap.containsKey('niceProviderType')?objStrOrNull(prdDetailMap.get('niceProviderType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderType')))?String.valueOf(prdDetailMap.get('niceProviderType')):null:null;
            hscProvider.niceProviderOrganizationName = prdDetailMap.containsKey('niceProviderOrganizationName')?objStrOrNull(prdDetailMap.get('niceProviderOrganizationName')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderOrganizationName')))?String.valueOf(prdDetailMap.get('niceProviderOrganizationName')):null:null;
            hscProvider.niceProviderContractArrangType = prdDetailMap.containsKey('niceProviderContractArrangType')?objStrOrNull(prdDetailMap.get('niceProviderContractArrangType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderContractArrangType')))?String.valueOf(prdDetailMap.get('niceProviderContractArrangType')):null:null;
            hscProvider.niceProviderOoaInd = prdDetailMap.containsKey('niceProviderOoaInd') ? Boolean.valueOf(prdDetailMap.get('niceProviderOoaInd')) : false;
            hscProvider.niceProviderContractTextInd = prdDetailMap.containsKey('niceProviderContractTextInd') ? Boolean.valueOf(prdDetailMap.get('niceProviderContractTextInd')) : false;
            hscProvider.niceProviderClaimTextInd = prdDetailMap.containsKey('niceProviderClaimTextInd') ? Boolean.valueOf(prdDetailMap.get('niceProviderClaimTextInd')) : false;
            hscProvider.niceProviderMedicalRiskType = prdDetailMap.containsKey('niceProviderMedicalRiskType')?objStrOrNull(prdDetailMap.get('niceProviderMedicalRiskType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderMedicalRiskType')))?String.valueOf(prdDetailMap.get('niceProviderMedicalRiskType')):null:null;
            hscProvider.niceProviderHospitalRiskType = prdDetailMap.containsKey('niceProviderHospitalRiskType')?objStrOrNull(prdDetailMap.get('niceProviderHospitalRiskType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderHospitalRiskType')))?String.valueOf(prdDetailMap.get('niceProviderHospitalRiskType')):null:null;
            hscProvider.niceProviderPhsRiskType = prdDetailMap.containsKey('niceProviderPhsRiskType')?objStrOrNull(prdDetailMap.get('niceProviderPhsRiskType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderPhsRiskType')))?String.valueOf(prdDetailMap.get('niceProviderPhsRiskType')):null:null;
            hscProvider.niceProviderUmType = prdDetailMap.containsKey('niceProviderUmType')?objStrOrNull(prdDetailMap.get('niceProviderUmType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderUmType')))?String.valueOf(prdDetailMap.get('niceProviderUmType')):null:null;
            hscProvider.niceCompanyCodeType = prdDetailMap.containsKey('niceCompanyCodeType')?objStrOrNull(prdDetailMap.get('niceCompanyCodeType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceCompanyCodeType')))?String.valueOf(prdDetailMap.get('niceCompanyCodeType')):null:null;
            hscProvider.niceProviderNetworkInfoType = prdDetailMap.containsKey('niceProviderNetworkInfoType')?objStrOrNull(prdDetailMap.get('niceProviderNetworkInfoType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('niceProviderNetworkInfoType')))?String.valueOf(prdDetailMap.get('niceProviderNetworkInfoType')):null:null;
            hscProvider.assocNiceProvGroupNum = prdDetailMap.containsKey('assocNiceProvGroupNum')?objStrOrNull(prdDetailMap.get('assocNiceProvGroupNum')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('assocNiceProvGroupNum')))?String.valueOf(prdDetailMap.get('assocNiceProvGroupNum')):null:null;
            hscProvider.assocNiceProvGroupName = prdDetailMap.containsKey('assocNiceProvGroupName')?objStrOrNull(prdDetailMap.get('assocNiceProvGroupName')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('assocNiceProvGroupName')))?String.valueOf(prdDetailMap.get('assocNiceProvGroupName')):null:null;
            hscProvider.assocNiceProvServiceLocNum = prdDetailMap.containsKey('assocNiceProvServiceLocNum')?objStrOrNull(prdDetailMap.get('assocNiceProvServiceLocNum')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('assocNiceProvServiceLocNum')))?String.valueOf(prdDetailMap.get('assocNiceProvServiceLocNum')):null:null;
            hscProvider.assocNiceProvServiceLocName = prdDetailMap.containsKey('assocNiceProvServiceLocName')?objStrOrNull(prdDetailMap.get('assocNiceProvServiceLocName')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('assocNiceProvServiceLocName')))?String.valueOf(prdDetailMap.get('assocNiceProvServiceLocName')):null:null;
            hscProvider.derivedNiceProviderRiskType = prdDetailMap.containsKey('derivedNiceProviderRiskType')?objStrOrNull(prdDetailMap.get('derivedNiceProviderRiskType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('derivedNiceProviderRiskType')))?String.valueOf(prdDetailMap.get('derivedNiceProviderRiskType')):null:null;
            hscProvider.productCategoryType = prdDetailMap.containsKey('productCategoryType')?objStrOrNull(prdDetailMap.get('productCategoryType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('productCategoryType')))?String.valueOf(prdDetailMap.get('productCategoryType')):null:null;
            hscProvider.secondaryPhone = prdDetailMap.containsKey('secondaryPhone')?objStrOrNull(prdDetailMap.get('secondaryPhone')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('secondaryPhone')))?String.valueOf(prdDetailMap.get('secondaryPhone')):null:null;
            hscProvider.secondaryPhoneInternationalInd = prdDetailMap.containsKey('secondaryPhoneInternationalInd') ? Boolean.valueOf(prdDetailMap.get('secondaryPhoneInternationalInd')) : false;
            
            if(submitInfoMap.containsKey('AlternativeFax')){                
                hscProvider.alternateFax = submitInfoMap.containsKey('AlternativeFax')?objStrOrNull(submitInfoMap.get('AlternativeFax')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('alternateFax')))?String.valueOf(prdDetailMap.get('alternateFax')):null:null;
            } 
            if(submitInfoMap.containsKey('ConfirmFax')){ 
                hscProvider.alternateFaxConfirmedInd = submitInfoMap.containsKey('ConfirmFax')?Boolean.valueOf(submitInfoMap.get('ConfirmFax')):false;
            }
            if(submitInfoMap.containsKey('SendMail')){ 
                hscProvider.hscLetterOptOutCcInd = submitInfoMap.containsKey('SendMail') ? Boolean.valueOf(submitInfoMap.get('SendMail')) : false;
            }
                                    
            hscProvider.alternateFaxInternationalInd = prdDetailMap.containsKey('alternateFaxInternationalInd')?Boolean.valueOf(prdDetailMap.get('alternateFaxInternationalInd')):false;
            hscProvider.conditionFocusDescription = prdDetailMap.containsKey('conditionFocusDescription')?objStrOrNull(prdDetailMap.get('conditionFocusDescription')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('conditionFocusDescription')))?String.valueOf(prdDetailMap.get('conditionFocusDescription')):null:null;
            hscProvider.qualityOutcomeType = prdDetailMap.containsKey('qualityOutcomeType')?objStrOrNull(prdDetailMap.get('qualityOutcomeType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('qualityOutcomeType')))?String.valueOf(prdDetailMap.get('qualityOutcomeType')):null:null;
            hscProvider.efficiencyOutcomeType = prdDetailMap.containsKey('efficiencyOutcomeType')?objStrOrNull(prdDetailMap.get('efficiencyOutcomeType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('efficiencyOutcomeType')))?String.valueOf(prdDetailMap.get('efficiencyOutcomeType')):null:null;
            hscProvider.correspNdbAddressSeqNum = prdDetailMap.containsKey('correspNdbAddressSeqNum')?Integer.valueOf(prdDetailMap.get('correspNdbAddressSeqNum')):null;
            hscProvider.correspAddress1 = prdDetailMap.containsKey('correspAddress1')?objStrOrNull(prdDetailMap.get('correspAddress1')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspAddress1')))?String.valueOf(prdDetailMap.get('correspAddress1')):null:null;
            hscProvider.correspAddress2 = prdDetailMap.containsKey('correspAddress2')?objStrOrNull(prdDetailMap.get('correspAddress2')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspAddress2')))?String.valueOf(prdDetailMap.get('correspAddress2')):null:null;
            hscProvider.correspCountyName = prdDetailMap.containsKey('correspCountyName')?objStrOrNull(prdDetailMap.get('correspCountyName')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspCountyName')))?String.valueOf(prdDetailMap.get('correspCountyName')):null:null;
            hscProvider.correspCity = prdDetailMap.containsKey('correspCity')?objStrOrNull(prdDetailMap.get('correspCity')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspCity')))?String.valueOf(prdDetailMap.get('correspCity')):null:null;
            hscProvider.correspState = prdDetailMap.containsKey('correspState')?objStrOrNull(prdDetailMap.get('correspState')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspState')))?String.valueOf(prdDetailMap.get('correspState')):null:null;
            hscProvider.correspZip = prdDetailMap.containsKey('correspZip')?objStrOrNull(prdDetailMap.get('correspZip')):null;//@@String.isNotBlank(String.valueOf(prdDetailMap.get('correspZip')))?String.valueOf(prdDetailMap.get('correspZip')):null:null;
            hscProvider.correspZipSuffix = prdDetailMap.containsKey('correspZipSuffix')?objStrOrNull(prdDetailMap.get('correspZipSuffix')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspZipSuffix')))?String.valueOf(prdDetailMap.get('correspZipSuffix')):null:null;
            hscProvider.correspCountryCode = prdDetailMap.containsKey('correspCountryCode')?objStrOrNull(prdDetailMap.get('correspCountryCode')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspCountryCode')))?String.valueOf(prdDetailMap.get('correspCountryCode')):null:null;
            hscProvider.correspAttentionToName = prdDetailMap.containsKey('correspAttentionToName')?objStrOrNull(prdDetailMap.get('correspAttentionToName')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('correspAttentionToName')))?String.valueOf(prdDetailMap.get('correspAttentionToName')):null:null;
            hscProvider.autoApprovalLetterInd = prdDetailMap.containsKey('autoApprovalLetterInd')?Boolean.valueOf(prdDetailMap.get('autoApprovalLetterInd')): false;
            hscProvider.cirrusBenefitPlanID = prdDetailMap.containsKey('cirrusBenefitPlanID')?objStrOrNull(prdDetailMap.get('cirrusBenefitPlanID')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusBenefitPlanID')))?String.valueOf(prdDetailMap.get('cirrusBenefitPlanID')):null:null;
            hscProvider.cirrusBenefitPlanName = prdDetailMap.containsKey('cirrusBenefitPlanName')?objStrOrNull(prdDetailMap.get('cirrusBenefitPlanName')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusBenefitPlanName')))?String.valueOf(prdDetailMap.get('cirrusBenefitPlanName')):null:null;
            hscProvider.cirrusNetworkScheduleIDType = prdDetailMap.containsKey('cirrusNetworkScheduleIDType')?objStrOrNull(prdDetailMap.get('cirrusNetworkScheduleIDType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusNetworkScheduleIDType')))?String.valueOf(prdDetailMap.get('cirrusNetworkScheduleIDType')):null:null;
            hscProvider.cirrusServiceAreaIDType = prdDetailMap.containsKey('cirrusServiceAreaIDType')?objStrOrNull(prdDetailMap.get('cirrusServiceAreaIDType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusServiceAreaIDType')))?String.valueOf(prdDetailMap.get('cirrusServiceAreaIDType')):null:null;
            hscProvider.cirrusNetworkID = prdDetailMap.containsKey('cirrusNetworkID')?objStrOrNull(prdDetailMap.get('cirrusNetworkID')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusNetworkID')))?String.valueOf(prdDetailMap.get('cirrusNetworkID')):null:null;
            hscProvider.cirrusNetworkIDDesc = prdDetailMap.containsKey('cirrusNetworkIDDesc')?objStrOrNull(prdDetailMap.get('cirrusNetworkIDDesc')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusNetworkIDDesc')))?String.valueOf(prdDetailMap.get('cirrusNetworkIDDesc')):null:null;
            hscProvider.cirrusContractType = prdDetailMap.containsKey('cirrusContractType')?objStrOrNull(prdDetailMap.get('cirrusContractType')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusContractType')))?String.valueOf(prdDetailMap.get('cirrusContractType')):null:null;
            hscProvider.cirrusContractTypeDesc = prdDetailMap.containsKey('cirrusContractTypeDesc')?objStrOrNull(prdDetailMap.get('cirrusContractTypeDesc')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusContractTypeDesc')))?String.valueOf(prdDetailMap.get('cirrusContractTypeDesc')):null:null;
            hscProvider.cirrusProviderAddressServiceAreas = prdDetailMap.containsKey('cirrusProviderAddressServiceAreas')?objStrOrNull(prdDetailMap.get('cirrusProviderAddressServiceAreas')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('cirrusProviderAddressServiceAreas')))?String.valueOf(prdDetailMap.get('cirrusProviderAddressServiceAreas')):null:null;
            hscProvider.newProviderInd = prdDetailMap.containsKey('newProviderInd')?objStrOrNull(prdDetailMap.get('newProviderInd')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('newProviderInd')))?String.valueOf(prdDetailMap.get('newProviderInd')):null:null;
            
            hscProviderLst.add(hscProvider);
            hscProviders.hscProvider = hscProviderLst;
        }                
        
        caseDetails.hscProviders = hscProviders;
        
        
        //Fill Member details 
        ACET_CreateAuthRequest.Member memberDetail = new ACET_CreateAuthRequest.Member();
        ACET_CreateAuthRequest.MemberPcp memPcp=new ACET_CreateAuthRequest.MemberPcp();
        List<ACET_CreateAuthRequest.MemberPcp> memPcpList=new List<ACET_CreateAuthRequest.MemberPcp>();
        ACET_CreateAuthRequest.MemberPcps memPcps=new ACET_CreateAuthRequest.MemberPcps();
        System.debug('331MemberPcps'+extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider);
        if(strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider) && !String.isEmpty(String.valueof(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpStartDate))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpFirstName))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpLastName))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpPhoneNumber))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpEndDate))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.acoNetworkId))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.acoNetworkDescription))
           && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.taxId)))
        {
            memPcp.pcpSeqNbr='1';
            memPcp.phoneInternationalInd=true;//if we are not adding we are unable to get success
            memPcp.effectiveDate=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpStartDate)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpStartDate):'';
            memPcp.firstName=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpFirstName)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpFirstName):'';
            memPcp.lastName=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpLastName)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpLastName):'';
            memPcp.phone=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpPhoneNumber)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpPhoneNumber):'';
            memPcp.endDate=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpEndDate)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.pcpEndDate):'';
            memPcp.acoID=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.acoNetworkId)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.acoNetworkId):'';
            memPcp.acoName=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.acoNetworkDescription)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.acoNetworkDescription):'';
            memPcp.federalTaxID=strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.taxId)?
                               objStrOrNull(extendeResult.policyResultWrapper.resultWrapper.policyRes.primaryCareProvider.taxId):'';
            memPcp.ndbMpin='';
            memPcpList.add(memPcp);
            memPcps.memberPcp=memPcpList;
            memberDetail.memberPcps =memPcps;
        }
        else
        {
            memberDetail.memberPcps =null;
        }


        //memberDetail => memberIdentifiers
        ACET_CreateAuthRequest.MemberIdentifiers memberIdentifiers = new ACET_CreateAuthRequest.MemberIdentifiers();
        List<ACET_CreateAuthRequest.MemberIdentifier> memberIdentifierLst = new List<ACET_CreateAuthRequest.MemberIdentifier>();
        
        
        
        System.debug('hello');
        for(Integer i=1;i<=36;i++)
        {
            
            if(i==1 || i==2 || i==3 || i==4 || i==36)
            {
                String idValue = '1';
                if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){
                    idValue=(i==1 && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.subscriberID)))
                        ?(String.valueOf(extendeResult.policyResultWrapper.resultWrapper.policyRes.subscriberID))
                        :(i==2 && (strNotBlank(memberDataResult.MemberId)))
                    ?(String.valueOf(memberDataResult.MemberId))
                        :(i==3 && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.alternateId)))
                    ?(String.valueOf(extendeResult.policyResultWrapper.resultWrapper.policyRes.alternateId))
                        :(i==4 && (strNotBlank(memberDataResult.SSNum)))
                    ?(String.valueOf(memberDataResult.SSNum))
                        :(i==36 && (strNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.xrefId)))
                    ?(String.valueOf(extendeResult.policyResultWrapper.resultWrapper.policyRes.xrefId))
                        :'';
                }
                
                if(idValue!='')
                {System.debug('---->'+i+'--->'+idValue);//memberIdentifier.memberIDText
                 ACET_CreateAuthRequest.MemberIdentifier memberIdentifier = new ACET_CreateAuthRequest.MemberIdentifier();
                 memberIdentifier.memberIDType = String.valueOf(i);
                 memberIdentifier.memberIDText = idValue;
                 memberIdentifier.memberIDDesc = null;
                 memberIdentifierLst.add(memberIdentifier);
                 memberIdentifiers.memberIdentifier = memberIdentifierLst;
                 memberDetail.memberIdentifiers = memberIdentifiers;   
                }
            }  
        }
        System.debug('007yyyy'+memberDetail.memberIdentifiers);
        //memberDetail => MemberPhones
        ACET_CreateAuthRequest.MemberPhones memberPhones = new ACET_CreateAuthRequest.MemberPhones();
        List<ACET_CreateAuthRequest.MemberPhone> memberPhoneLst = new List<ACET_CreateAuthRequest.MemberPhone>();
        
        if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){
            if(String.isNotBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.homeTelephoneNumber)){
                ACET_CreateAuthRequest.MemberPhone memberPhone = new ACET_CreateAuthRequest.MemberPhone();
                memberPhone.phoneType = '1';
                memberPhone.phone = extendeResult.policyResultWrapper.resultWrapper.policyRes.homeTelephoneNumber;	
                memberPhone.phoneInternationalInd = false; //Boolean
                memberPhone.preferredInd = false; //Boolean
                memberPhoneLst.add(memberPhone);
            }
        }
        
        memberPhones.memberPhone = memberPhoneLst;
        memberDetail.memberPhones = memberPhones;
        
        if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){
            memberDetail.sourceMemberID = extendeResult.policyResultWrapper.resultWrapper.policyRes.xrefId; //TBD with varsha
            memberDetail.claimPlatformId = extendeResult.policyResultWrapper.resultWrapper.policyRes.claimSourceSystemCode;
            memberDetail.sourceMemberPartitionID = extendeResult.policyResultWrapper.resultWrapper.policyRes.xrefIdPartitionNumber;
            memberDetail.relationshipCode =extendeResult.policyResultWrapper.resultWrapper.policyRes.relationshipCode;
        }else{
            memberDetail.sourceMemberID = '';
            memberDetail.claimPlatformId = '';
        }
        
        memberDetail.sourceMemberIDType = 'CDB';

        if(extendeResult != null && extendeResult.houseHoldWrapper != null && extendeResult.houseHoldWrapper.houseHoldList != null){
            memberDetail.firstName = extendeResult.houseHoldWrapper.houseHoldList[0].firstName;
            memberDetail.lastName = extendeResult.houseHoldWrapper.houseHoldList[0].lastName;
            memberDetail.genderType = extendeResult.houseHoldWrapper.houseHoldList[0].gender;
            memberDetail.middleName = '';
            memberDetail.suffixName = '';
            if(extendeResult.houseHoldWrapper.houseHoldList.size() > 0){
                for(Integer k = 0; k <extendeResult.houseHoldWrapper.houseHoldList.size(); k++){
                    if(extendeResult.houseHoldWrapper.houseHoldList[k].relationship == 'Subscriber'){
                        memberDetail.subscriberFirstName = extendeResult.houseHoldWrapper.houseHoldList[k].firstName;
                        memberDetail.subscriberLastName = extendeResult.houseHoldWrapper.houseHoldList[k].lastName;  
                    }
                }
            }
        }
        
        //memberDetail.birthDate =jsonDateFormatYYYYMMDD(memberDataResult.dob);//String.valueOf(Date.parse(dob).year())+'-'+mm+'-'+dd;
        if(memberDataResult != null && memberDataResult.CoverageLines != null)
            memberDetail.birthDate = jsonDateFormatYYYYMMDD(memberDataResult.CoverageLines[0].patientInfo.dobVal);  
                  
        memberDetail.genderTypeDesc = null;
        memberDetail.spokenLanguageText = null;
        memberDetail.writtenLanguageText = null;
        memberDetail.detailInd = null;
        memberDetail.settingOfCareText = null;
        memberDetail.categoryEligibilityDesc = null;
        memberDetail.race = null;
        memberDetail.ethnicity = null;
        memberDetail.calapPreferenceInd = false; //Boolean
        memberDetail.hmoLicenseCode = null;
        memberDetail.calapWrittenLangType = null;
        memberDetail.calapSpokenLangType = null;
        memberDetail.preferredSpokenLangType = null;
        memberDetail.preferredWrittenLangType = null;
        memberDetail.captureReasonType = null;
        memberDetail.recordSourceType = null;
        memberDetail.memberNoContactInd = false; //Boolean
        memberDetail.subscriberEmploymentDate = null; //'6847804800000'
        memberDetail.subscriberEmployeeStatusType = null;
        memberDetail.bestDayToContact = null;
        memberDetail.bestTimeToContact = null;
        memberDetail.alternateRelationshipCode = null; //'00'
        memberDetail.consumerID = null; //Integer
        memberDetail.totalMonetizedValueAmount = null; //Integer
        memberDetail.initialGestationalWeekCount = null; //Integer
        memberDetail.envDisasterPlanInd = false; //Boolean
        memberDetail.advanceDirectiveType = null;
        memberDetail.autoMedReferralAssignmentInd = false; //Boolean
        memberDetail.geriatricMedChkInd = false; //Boolean
        memberDetail.categoryEligibilityCode = null;
        memberDetail.lastRsaReceivedDateTime = null;
        memberDetail.lastRsaRequestedDateTime = null;
        memberDetail.rsaRenewalDate = null;
        memberDetail.dnrIndicator = false; //Boolean
        memberDetail.exchangeType = null;
        memberDetail.noPhoneReasonType = null;
        memberDetail.primaryMedMemberCoverageSeqNum = null; //Integer
        memberDetail.sourceMemberLastUpdateDateTime = null;
        memberDetail.alternateEthncCode = null;
        memberDetail.alternateRaceCode = null;
        memberDetail.altPrefWriteLangTypId = null;
        memberDetail.altPrefSpokenLangTypId = null;
        memberDetail.primaryISLIndividualGuid = null;
        memberDetail.customerID = null; //Integer
        memberDetail.purchaserID = null; //Integer
        memberDetail.hasLivingWillInd = 'false'; //Boolean
        memberDetail.rsaPopulationType = null;
        memberDetail.nextRsaDueDate = null;
        memberDetail.firstPocProblemDate = null;
        memberDetail.confidentialInd = null; //Integer
        memberDetail.niceMemberMigrationStartDate = null;
        memberDetail.medicareAStartDate = null;
        memberDetail.medicareBStartDate = null;
        memberDetail.medicareAEndDate = null;
        memberDetail.medicareBEndDate = null;
        memberDetail.cobInd = 'false'; //Boolean
        memberDetail.otherCoverageCarrierName = null;
        memberDetail.otherCoveragePolicyNumber = null;
        memberDetail.otherCoverageCardHolderId = null;
        memberDetail.otherCoverageCarrierTelNo = null;
        memberDetail.otherCovCarrierIntlInd = false; //Boolean
        memberDetail.otherCoveragePolicyHolderName = null;
        memberDetail.cobStartDate = null;
        memberDetail.cobEndDate = null;
        memberDetail.otherCoverageOrderType = null;
        memberDetail.otherCoverageReasonTypeID = null;
        memberDetail.medicarePrimaryInd = false; //Boolean
        memberDetail.cobVerifyDate = null;
        memberDetail.populationId = null;
        if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){
            memberDetail.origSystemMemberIDType = extendeResult.policyResultWrapper.resultWrapper.policyRes.sourceCode;
            memberDetail.eligibilitySystemTypeID = extendeResult.policyResultWrapper.resultWrapper.policyRes.eligibilitySourceSystemCode;
            memberDetail.origSystemMemberID =  extendeResult.policyResultWrapper.resultWrapper.policyRes.groupNumber + ' ' + memberDataResult.MemberId;//'00F4082 942991932';
        }
         
        memberDetail.deathDate = null;
        
        
        //memberDetail => MemberAddresses        
        ACET_CreateAuthRequest.MemberAddresses memberAddresses = new ACET_CreateAuthRequest.MemberAddresses();
        List<ACET_CreateAuthRequest.MemberAddress> memberAddressLst = new List<ACET_CreateAuthRequest.MemberAddress>();
        ACET_CreateAuthRequest.MemberAddress memberAddress = new ACET_CreateAuthRequest.MemberAddress();
        memberAddress.addressType = '1';
        memberAddress.addressTypeDesc = 'Primary Address';
        //memberAddress.address1 = memberDataResult.Addresses[0].AddressLine1;
        if(memberDataResult != null && memberDataResult.CoverageLines != null){
            if(memberDataResult.CoverageLines[0].patientInfo != null){
                memberAddress.address1 = memberDataResult.CoverageLines[0].patientInfo.AddressLine1;
                memberAddress.city = memberDataResult.CoverageLines[0].patientInfo.City;
                memberAddress.state = memberDataResult.CoverageLines[0].patientInfo.State;
                memberAddress.zip = memberDataResult.CoverageLines[0].patientInfo.Zip;
            }
        }

        memberAddress.address2 = null;
        memberAddress.stateDesc = null;
        memberAddress.zipSuffix = null;
        memberAddress.countryCode = 'US';
        memberAddress.countryCodeDesc = null;
        memberAddress.effectiveDate = null;
        memberAddress.endDate = null;
        memberAddress.countyFIPS = null;
        memberAddress.countyName = null;
        memberAddressLst.add(memberAddress);
        memberAddresses.memberAddress = memberAddressLst;
        memberDetail.memberAddresses = memberAddresses;
        
        //memberDetail => MemberCoverage
        ACET_CreateAuthRequest.MemberCoverage memberCoverage = new ACET_CreateAuthRequest.MemberCoverage();
        memberCoverage.memberCoverageSeqNum = 0; //Integer
        if(extendeResult != null &&  extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper !=null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){
            memberCoverage.policyNumber = extendeResult.policyResultWrapper.resultWrapper.policyRes.policyNumber;
        }
        memberCoverage.coverageType = (coverageTypeMap.containsKey(String.valueOf(authDetailsMap.get('policyCoverageType'))))?coverageTypeMap.get(String.valueOf(authDetailsMap.get('policyCoverageType'))):'M';//'M'; //TBD with varsha
        String coverageStartDT = null;
        String coverageStartET = null;
        String coveragePolicyName = null; // US3557591 Swapnil
        if(!Test.isRunningTest())
        {
            if(memberDataResult.CoverageLines != null){
                if(memberDataResult.CoverageLines.size() > 0){
                    for(Integer k=0; k < memberDataResult.CoverageLines.size(); k++){
                        //if(String.isNotBlank(String.valueOf(memberDataResult.CoverageLines[k].highlightedPolicy))){ fix for DE431457
                        if(memberDataResult.CoverageLines[k].highlightedPolicy) {
                            coveragePolicyName = memberDataResult.CoverageLines[k].PolicyName; // US3557591 Swapnil
                            if(memberDataResult.CoverageLines[k].eligibleDates.contains('-')){
                                List<String> coverageDateSplit = memberDataResult.CoverageLines[k].eligibleDates.split('-');
                                if(coverageDateSplit.size() > 0){
                                    coverageStartDT = strNotBlank(coverageDateSplit[0])?String.valueOf(coverageDateSplit[0]):null;
                                    coverageStartET = strNotBlank(coverageDateSplit[1])?String.valueOf(coverageDateSplit[1]):null;
                                }
                            }
                        }
                    }
                }            
            }
        }
            if(String.isNotBlank(coverageStartDT)){
                if(coverageStartDT.contains('/')){
                    List<String> covStrtDtLst = coverageStartDT.split('/');
                    memberCoverage.coverageEffectiveDate = covStrtDtLst[2].trim() + '-' + covStrtDtLst[0].trim() + '-' + covStrtDtLst[1].trim();
                }
            }
            if(String.isNotBlank(coverageStartET)){
                if(coverageStartET.contains('/')){
                    List<String> covEndDtLst = coverageStartET.split('/');
                    memberCoverage.coverageEndDate = covEndDtLst[2].trim() + '-' + covEndDtLst[0].trim() + '-' + covEndDtLst[1].trim();
                }
            }else{
                memberCoverage.coverageEndDate = '9999-12-31';
            }            
        
        
        
        memberCoverage.marketNumber = extendeResult.policyResultWrapper.resultWrapper.policyRes.marketSite;
        memberCoverage.marketType = extendeResult.policyResultWrapper.resultWrapper.policyRes.marketType;
        memberCoverage.divID = extendeResult.policyResultWrapper.resultWrapper.policyRes.cosmosDivision;
        memberCoverage.productType = extendeResult.policyResultWrapper.resultWrapper.policyRes.productType;
        memberCoverage.productCategoryType = ((strNotBlank(authDetailsMap.get('insuranceTypeCode'))) && (insuranceTypeCodeMap.containsKey(String.valueOf(authDetailsMap.get('insuranceTypeCode')))))
            								?(insuranceTypeCodeMap.get(String.valueOf(authDetailsMap.get('insuranceTypeCode')))):'';//US3116511 TTAP Vishnu
        memberCoverage.lineOfBusinessType = (strNotBlank(authDetailsMap.get('lineOfBusiness')))?(String.valueOf(authDetailsMap.get('lineOfBusiness'))):'';//US3116511 TTAP Vishnu
        memberCoverage.lineOfBusinessType=memberCoverage.lineOfBusinessType=='2'?'5':memberCoverage.lineOfBusinessType;
        if(memberCoverage.lineOfBusinessType=='1')
        {
            memberCoverage.lineOfBusinessType=eniLOBMap.containsKey(memberCoverage.marketType)?eniLOBMap.get(memberCoverage.marketType):'11';
        }
        memberCoverage.groupNumber = extendeResult.policyResultWrapper.resultWrapper.policyRes.groupNumber;
        memberCoverage.businessSegmentID = null;
        memberCoverage.legalEntityID = null;
        //memberCoverage.obligorID = extendeResult.policyResultWrapper.resultWrapper.policyRes.obligorID; //TBD with varsha;
        //memberCoverage.sharedArrangementID = extendeResult.policyResultWrapper.resultWrapper.policyRes.sharedArrangement; //TBD with varsha
        memberCoverage.memberNetworkID = null;
        memberCoverage.panelID = extendeResult.policyResultWrapper.resultWrapper.policyRes.groupPanelNumber; //TBD with varsha	
        memberCoverage.policyIssueState = extendeResult.policyResultWrapper.resultWrapper.policyRes.stateOfIssueCode; //TBD with varsha
        memberCoverage.coverageSetID = rcedResult!=null?rcedResult.topsCoverageSetId:null;//added by vishnu next 3 to
        memberCoverage.coverageSetMMECode = rcedResult!=null?setData(rcedResult.baseMme):null;
        memberCoverage.coverageSetCMECode = rcedResult!=null?setData(rcedResult.cme):null;
        memberCoverage.coverageSetMedicareCode = rcedResult!=null?setData(rcedResult.medicare):null;
        //fundingArrangIDMap

        // US3507486 - Create Auth  Update Funding Arrangement Value : Sarma - 10th May 2021
        // String fundArrStr=extendeResult.policyResultWrapper.resultWrapper.policyRes.fundingType;
        // if(fundArrStr!=null && fundArrStr!='' && fundingArrangIDMap.containsKey(fundArrStr))
        // {
        //     memberCoverage.fundingArrangementID = fundingArrangIDMap.get(fundArrStr);
            
        // }else
        // {
        //      memberCoverage.fundingArrangementID ='U';
        // }
        if(rcedResult != null && rcedResult.fundingArrangement != null){
            memberCoverage.fundingArrangementID = rcedResult.fundingArrangement;
        }

        // US3507488: Create Auth Med Nec Indicator - Swapnil 13 May 2021
        if(rcedResult != null){
            memberCoverage.obligorID = rcedResult.obligorID;
            memberCoverage.productCode = rcedResult.productCode;
            memberCoverage.sharedArrangementID = rcedResult.sharedArrangementID;
            memberCoverage.productClassifierType = rcedResult.productClassifierType;
        } // US3507488 ends

        memberCoverage.planVariationID = null;
        memberCoverage.reportCode = null;
        memberCoverage.marketNetworkID = null;
        memberCoverage.marketNetworkInd = 'false'; //Boolean
        
        if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){           
            memberCoverage.claimPlatformID = extendeResult.policyResultWrapper.resultWrapper.policyRes.claimSourceSystemCode;
        }
        memberCoverage.cdhPlanType = null;
        memberCoverage.policyName = rcedResult!=null?rcedResult.cesCustomerName:null; // US3557591 Swapnil
        memberCoverage.marketSegmentCode = null;
        memberCoverage.claimOfficeID = null; //Integer TBD with varsha
        memberCoverage.claimOfficeName = null;
        memberCoverage.claimOfficeCustomerServicePhone = null;
        memberCoverage.claimOfficePhone = null;
        memberCoverage.claimOfficeAddress1 = null;
        memberCoverage.claimOfficeAddress2 = null;
        memberCoverage.claimOfficeCity = null;
        memberCoverage.claimOfficeState = null;
        memberCoverage.claimOfficeZip = null;
        memberCoverage.claimOfficeZipSuffix = null;
        memberCoverage.recordSourceType = null;
        //memberCoverage.productCode = null;
        memberCoverage.niceCoveragePlanCode = null;
        memberCoverage.niceCoveragePlanDescription = null;
        memberCoverage.niceBenefitNetworkIndicator = null;
        memberCoverage.erisaIndicator = null;
        memberCoverage.hcfaStatusType = null;
        memberCoverage.hcfaPlanID = null;
        memberCoverage.niceCompanyCodeType = null;
        memberCoverage.niceCompanyRegionType = null;
        memberCoverage.medNecessityApplInd = false; //Boolean
        memberCoverage.productYearText = null;
        memberCoverage.healthServiceProductLineCode = null;
        memberCoverage.healthServiceProductCode = null;
        memberCoverage.alternatePolicyNumber = null;
        //memberCoverage.productClassifierType = null;
        memberCoverage.productBrandName = null;
        memberCoverage.masterGroupNumber = null;
        memberCoverage.marketPackageNumber = null;
        memberCoverage.marketPackageName = null;
        memberCoverage.financialProductNumber = null;
        memberCoverage.financialProductDescription = null;
        memberCoverage.riskTypeCode = null;
        memberCoverage.subscriberPackageBenefitPlanID = null;
        memberCoverage.coreMedNecTypID = rcedResult!=null?objStrOrNull(rcedResult.siteOfCareCoreMed):null;
        memberCoverage.policyEffectiveDate = null;
        memberCoverage.policyEndDate = null;
        memberCoverage.indvContrInd = false; //Boolean
        memberCoverage.businessSegmentName = null;
        memberCoverage.cmsSnpInd = false; //Boolean
        memberCoverage.cmsSnpTypeName = null;
        memberCoverage.cmsStateShortName = null;
        memberCoverage.cmsProductTypeName = null;
        memberCoverage.radiologyMedNecType = null;
        memberCoverage.cardiologyMedNecType = null;
        memberCoverage.contractLabVendorType = null;
        memberCoverage.legacyBenefitPlanID = null;
        memberCoverage.gracePeriodThroughDate = null;
        memberCoverage.paidThroughDate = null;
        memberCoverage.emergentWrapBeneficiaryTypeID = null;
        memberCoverage.cosmosUmDelegationTypeID = null;
        memberCoverage.oncologyMedNecType = null;
        memberCoverage.legacyBenPlanDesc = null;
        memberCoverage.delegatedEntityName = null;
        memberCoverage.productTypeDescription = null;
        memberCoverage.providerNetworkDescription = null;
        memberCoverage.planVariationDesc = null;
        memberCoverage.reciprocityNumber = null;
        memberCoverage.planFeatureCode = null;
        memberCoverage.planFeatureDescription = 'N/A';
        memberCoverage.ltcInd = false; //Boolean
        memberCoverage.mmpInd = false; //Boolean
        memberCoverage.uhpdInd = null;
        memberCoverage.topsTieredPlanSetup = null;
        memberCoverage.groupBenefitNumber = null;
        memberCoverage.genTstMedNecType = null;
        memberCoverage.cirrusProductID = null;
        memberCoverage.cirrusProductName = null;
        memberCoverage.cirrusBenefitBundleID = null;
        memberCoverage.cirrusBenefitBundleName = null;
        memberCoverage.cirrusBenefitBundleOptionID = null;
        memberCoverage.cirrusBenefitBundleOptionName = null;
        memberCoverage.cirrusBenefitPlanID = null;
        memberCoverage.cirrusBenefitPlanName = null;
        memberCoverage.cirrusServiceAreaIDType = null;
        memberCoverage.radiationMedNecType = null;
        memberCoverage.providerNetworkReciprocityType = null;
        memberCoverage.providerTierRulePackageKey = null;
        memberDetail.memberCoverage = memberCoverage;
        
        //memberDetail => memberCoverages
        ACET_CreateAuthRequest.MemberCoverages memberCoverages = new ACET_CreateAuthRequest.MemberCoverages();
        List<ACET_CreateAuthRequest.MemberCoverage> memberCoverageLst = new List<ACET_CreateAuthRequest.MemberCoverage>();
        ACET_CreateAuthRequest.MemberCoverage memberCoverageObj = new ACET_CreateAuthRequest.MemberCoverage();
        
        memberCoverageObj.memberCoverageSeqNum = 1; //Integer
        memberCoverageObj.policyNumber = null;
        memberCoverageObj.coverageType = null;
        memberCoverageObj.coverageEffectiveDate = null;
        memberCoverageObj.coverageEndDate = '9999-12-31';
        memberCoverageObj.marketNumber = extendeResult.policyResultWrapper.resultWrapper.policyRes.marketSite;
        memberCoverageObj.marketType = extendeResult.policyResultWrapper.resultWrapper.policyRes.marketType;
        memberCoverageObj.divID = null;
        memberCoverageObj.productType = extendeResult.policyResultWrapper.resultWrapper.policyRes.productType; 
        memberCoverageObj.productCategoryType = ((strNotBlank(authDetailsMap.get('insuranceTypeCode'))) && (insuranceTypeCodeMap.containsKey(String.valueOf(authDetailsMap.get('insuranceTypeCode')))))
            								?(insuranceTypeCodeMap.get(String.valueOf(authDetailsMap.get('insuranceTypeCode')))):'';//US3116511 TTAP Vishnu
        memberCoverageObj.lineOfBusinessType = (strNotBlank(authDetailsMap.get('lineOfBusiness')))?(String.valueOf(authDetailsMap.get('lineOfBusiness'))):'';//US3116511 TTAP Vishnu
        memberCoverage.lineOfBusinessType=memberCoverage.lineOfBusinessType=='2'?'5':memberCoverage.lineOfBusinessType;
        if(memberCoverage.lineOfBusinessType=='1')
        {
            memberCoverage.lineOfBusinessType=eniLOBMap.containsKey(memberCoverage.marketType)?eniLOBMap.get(memberCoverage.marketType):'11';
        }
        memberCoverageObj.groupNumber = null;
        memberCoverageObj.businessSegmentID = null;
        memberCoverageObj.legalEntityID = null;
        memberCoverageObj.obligorID = extendeResult.policyResultWrapper.resultWrapper.policyRes.obligorID; //TBD with varsha; 
        memberCoverageObj.sharedArrangementID = extendeResult.policyResultWrapper.resultWrapper.policyRes.sharedArrangement; //TBD with varsha	
        memberCoverageObj.memberNetworkID = null;
        memberCoverageObj.panelID = extendeResult.policyResultWrapper.resultWrapper.policyRes.groupPanelNumber; //TBD with varsha	
        memberCoverageObj.policyIssueState = extendeResult.policyResultWrapper.resultWrapper.policyRes.stateOfIssueCode; //TBD with varsha
        memberCoverageObj.coverageSetID = null;
        memberCoverageObj.coverageSetMMECode = null;
        memberCoverageObj.coverageSetCMECode = null;
        memberCoverageObj.coverageSetMedicareCode = null;
        memberCoverageObj.fundingArrangementID = 'F';//extendeResult.policyResultWrapper.resultWrapper.policyRes.fundingType; //TBD with varsha
        memberCoverageObj.planVariationID = null;
        memberCoverageObj.reportCode = null;
        memberCoverageObj.marketNetworkID = null;
        memberCoverageObj.marketNetworkInd = 'false'; //Boolean
        
        if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){           
            memberCoverageObj.claimPlatformID = extendeResult.policyResultWrapper.resultWrapper.policyRes.claimSourceSystemCode;
        }
        
        memberCoverageObj.cdhPlanType = null;
        memberCoverageObj.policyName = null;
        memberCoverageObj.marketSegmentCode = null;
        memberCoverageObj.claimOfficeID = null; //Integer
        memberCoverageObj.claimOfficeName = null;
        memberCoverageObj.claimOfficeCustomerServicePhone = '';
        memberCoverageObj.claimOfficePhone = null;
        memberCoverageObj.claimOfficeAddress1 = null;
        memberCoverageObj.claimOfficeAddress2 = null;
        memberCoverageObj.claimOfficeCity = null;
        memberCoverageObj.claimOfficeState = null;
        memberCoverageObj.claimOfficeZip = null;
        memberCoverageObj.claimOfficeZipSuffix = null;
        memberCoverageObj.recordSourceType = '1';
        memberCoverageObj.productCode = extendeResult.policyResultWrapper.resultWrapper.policyRes.productCode;
        memberCoverageObj.niceCoveragePlanCode = null;
        memberCoverageObj.niceCoveragePlanDescription = null;
        memberCoverageObj.niceBenefitNetworkIndicator = null;
        memberCoverageObj.erisaIndicator = null;
        memberCoverageObj.hcfaStatusType = null;
        memberCoverageObj.hcfaPlanID = null;
        memberCoverageObj.niceCompanyCodeType = null;
        memberCoverageObj.niceCompanyRegionType = null;
        memberCoverageObj.medNecessityApplInd = false; //Boolean
        memberCoverageObj.productYearText = null;
        memberCoverageObj.healthServiceProductLineCode = null;
        memberCoverageObj.healthServiceProductCode = null;
        memberCoverageObj.alternatePolicyNumber = null;
        memberCoverageObj.productClassifierType = null;
        memberCoverageObj.productBrandName = null;
        memberCoverageObj.masterGroupNumber = null;
        memberCoverageObj.marketPackageNumber = null;
        memberCoverageObj.marketPackageName = null;
        memberCoverageObj.financialProductNumber = null;
        memberCoverageObj.financialProductDescription = null;
        memberCoverageObj.riskTypeCode = null;
        memberCoverageObj.subscriberPackageBenefitPlanID = null;
        memberCoverageObj.coreMedNecTypID = null;
        memberCoverageObj.policyEffectiveDate = null;
        memberCoverageObj.policyEndDate = null;
        memberCoverageObj.indvContrInd = false; //Boolean
        memberCoverageObj.businessSegmentName = null;
        memberCoverageObj.cmsSnpInd = false; //Boolean
        memberCoverageObj.cmsSnpTypeName = null;
        memberCoverageObj.cmsStateShortName = null;
        memberCoverageObj.cmsProductTypeName = null;
        memberCoverageObj.radiologyMedNecType = null;
        memberCoverageObj.cardiologyMedNecType = null;
        memberCoverageObj.contractLabVendorType = null;
        memberCoverageObj.legacyBenefitPlanID = null;
        memberCoverageObj.gracePeriodThroughDate = null;
        memberCoverageObj.paidThroughDate = null;
        memberCoverageObj.emergentWrapBeneficiaryTypeID = null;
        memberCoverageObj.cosmosUmDelegationTypeID = null;
        memberCoverageObj.oncologyMedNecType = null;
        memberCoverageObj.legacyBenPlanDesc = null;
        memberCoverageObj.delegatedEntityName = null;
        memberCoverageObj.productTypeDescription = null;
        memberCoverageObj.providerNetworkDescription = null;
        memberCoverageObj.planVariationDesc = null;
        memberCoverageObj.reciprocityNumber = null;
        memberCoverageObj.planFeatureCode = null;
        memberCoverageObj.planFeatureDescription = 'N/A';
        memberCoverageObj.ltcInd = false; //Boolean
        memberCoverageObj.mmpInd = false; //Boolean
        memberCoverageObj.uhpdInd = '';
        memberCoverageObj.topsTieredPlanSetup = null;
        memberCoverageObj.groupBenefitNumber = null;
        memberCoverageObj.genTstMedNecType = null;
        memberCoverageObj.cirrusProductID = null;
        memberCoverageObj.cirrusProductName = null;
        memberCoverageObj.cirrusBenefitBundleID = null;
        memberCoverageObj.cirrusBenefitBundleName = null;
        memberCoverageObj.cirrusBenefitBundleOptionID = null;
        memberCoverageObj.cirrusBenefitBundleOptionName = null;
        memberCoverageObj.cirrusBenefitPlanID = null;
        memberCoverageObj.cirrusBenefitPlanName = null;
        memberCoverageObj.cirrusServiceAreaIDType = null;
        memberCoverageObj.radiationMedNecType = null;
        memberCoverageObj.providerNetworkReciprocityType = null;
        memberCoverageObj.providerTierRulePackageKey = null;
        memberCoverageLst.add(memberCoverage);//need to check
        memberCoverages.memberCoverage = memberCoverageLst;
        memberDetail.memberCoverages = memberCoverages;
        
        //memberDetail => MemberOtherCoverages
        ACET_CreateAuthRequest.MemberOtherCoverages memberOtherCoverages = new ACET_CreateAuthRequest.MemberOtherCoverages();
        List<ACET_CreateAuthRequest.MemberOtherCoverage> memberOtherCoverageLst = new List<ACET_CreateAuthRequest.MemberOtherCoverage>();
        ACET_CreateAuthRequest.MemberOtherCoverage memberOtherCoverage = new ACET_CreateAuthRequest.MemberOtherCoverage();
        
        memberOtherCoverage.otherCoverageSequenceNumber = null;
        memberOtherCoverage.otherCoveragePolicyNumber = null;
        memberOtherCoverage.carrierName = null;
        memberOtherCoverage.startDate = null;
        memberOtherCoverage.endDate = null;
        memberOtherCoverage.otherCoverageOrderType = null;
        memberOtherCoverage.otherCoverageReasonTypeID = null;
        memberOtherCoverageLst.add(memberOtherCoverage);
        memberOtherCoverages.memberOtherCoverage = memberOtherCoverageLst;
        
        memberDetail.memberOtherCoverages = memberOtherCoverages;
        
        //memberDetail => MemberShareCosts
        ACET_CreateAuthRequest.MemberShareCosts memberShareCosts = new ACET_CreateAuthRequest.MemberShareCosts();
        List<ACET_CreateAuthRequest.MemberShareCost> memberShareCostLst = new List<ACET_CreateAuthRequest.MemberShareCost>();
        ACET_CreateAuthRequest.MemberShareCost memberShareCost = new ACET_CreateAuthRequest.MemberShareCost();
        
        memberShareCost.shareAmount = 1; //Integer
        memberShareCost.shareAmountStartDate = null;
        memberShareCost.shareAmountEndDate = null;
        memberShareCostLst.add(memberShareCost);
        memberShareCosts.memberShareCost = memberShareCostLst;
        
        memberDetail.memberShareCosts = memberShareCosts;
        
        memberDetail.memberCNSHealthStatuses = null;
        memberDetail.memberPopulations = null;
       // memberDetail.memberPcps = null;
        memberDetail.memberContacts = null;
        memberDetail.memberAlerts = null;
        memberDetail.memberAdditionalPlanFeatures = null;
        memberDetail.memberBenefitPlanTiers = null;
        if(extendeResult != null && extendeResult.houseHoldWrapper != null && extendeResult.houseHoldWrapper.houseHoldList != null){
            if(extendeResult.houseHoldWrapper.houseHoldList.size() > 0){
                for(Integer k = 0; k <extendeResult.houseHoldWrapper.houseHoldList.size(); k++){
                    if(extendeResult.houseHoldWrapper.houseHoldList[k].relationship == 'Subscriber'){
                        memberDetail.subscriberFirstName = extendeResult.houseHoldWrapper.houseHoldList[k].firstName;
                        memberDetail.subscriberLastName = extendeResult.houseHoldWrapper.houseHoldList[k].lastName;  
                    }
                }
            }
        }
        
        caseDetails.member = memberDetail;
        
        //caseDetails => HscContact
        ACET_CreateAuthRequest.HscContact hscContact = new ACET_CreateAuthRequest.HscContact();
        ACET_CreateAuthRequest.CommunicationContactPhones communicationContactPhones = new ACET_CreateAuthRequest.CommunicationContactPhones();
        List<ACET_CreateAuthRequest.CommunicationContactPhone> communicationContactPhoneLst = new List<ACET_CreateAuthRequest.CommunicationContactPhone>();
        //ACET_CreateAuthRequest.CommunicationContactPhone communicationContactPhone = new ACET_CreateAuthRequest.CommunicationContactPhone();        
        
        //SRNDataMap = (Map<String, Object>)JSON.deserializeUntyped(srnString);
       // Map<String, Object> commContactMap = new Map<String, Object>();

       // US3589825
       String strCommContactEmail = '';

        if (SRNDataMap.containsKey('CommContact')) {
            commContactMap = (Map<String, Object>)SRNDataMap.get('CommContact');
            System.debug('ContactNumber@@@' + commContactMap.get('Name'));
            System.debug('ContactNumber@@@' + commContactMap.get('Role'));
            
            if(commContactMap.containsKey('ContactNumber')){
                ACET_CreateAuthRequest.CommunicationContactPhone communicationContactPhone = new ACET_CreateAuthRequest.CommunicationContactPhone();
                communicationContactPhone.phoneType = String.valueOf(14);   
                string strCon = String.valueOf(commContactMap.get('ContactNumber'));
                if(strCon.containsAny('(')){
                    strCon = String.valueOf(commContactMap.get('ContactNumber')).replaceAll('[^a-zA-Z0-9\\s+]', '').replaceAll(' ', '');
                    communicationContactPhone.phone = strCon.substring(0, 3)+'-'+strCon.substring(3, 6)+'-'+strCon.substring(6, strCon.length()) + ' ' + String.valueOf(commContactMap.get('Ext'));
                }else{
                    communicationContactPhone.phone = strCon.substring(0, 3)+'-'+strCon.substring(3, 6)+'-'+strCon.substring(6, strCon.length()) + ' ' + String.valueOf(commContactMap.get('Ext')); //String.valueOf(commContactMap.get('ContactNumber')) + ' ' + String.valueOf(commContactMap.get('Ext'));
                }
                
                communicationContactPhone.phoneInternationalInd = 'false';
                communicationContactPhone.preferredInd = 'true'; //as phone is primary field, TBD with varsha
                communicationContactPhoneLst.add(communicationContactPhone);
            }
            
            if(commContactMap.containsKey('Fax')){
                String faxStr = String.valueOf(commContactMap.get('Fax'));
                if(String.isNotBlank(faxStr)){
                    ACET_CreateAuthRequest.CommunicationContactPhone communicationContactFax = new ACET_CreateAuthRequest.CommunicationContactPhone();
                    communicationContactFax.phoneType = String.valueOf(3); 
                    communicationContactFax.phone = faxStr;
                    communicationContactFax.phoneInternationalInd = 'false';
                    communicationContactFax.preferredInd = 'false';
                    communicationContactPhoneLst.add(communicationContactFax);
                }
            }
            communicationContactPhones.communicationContactPhone = communicationContactPhoneLst;
            
            hscContact.communicationContactPhones = communicationContactPhones;
            hscContact.contactName = String.valueOf(commContactMap.get('Name')); 
            hscContact.contactRoleType = String.valueOf(roleMap.get(String.valueOf(commContactMap.get('Role'))));
            hscContact.medicalRecordNumber = commContactMap.containsKey('MedicalRecord')?objStrOrNull(commContactMap.get('MedicalRecord')):null;//Added By Vishnu as new mapping
            //TTAP vishnu
            if(hscContact.contactRoleType=='1')
            {
                 hscContact.departmentType=String.valueOf(departmentMap.get(String.valueOf(commContactMap.get('Department'))));
            }
            hscContact.communicationDateTime = String.valueOf(commContactMap.get('DateTimeFormatted'));
            hscContact.channelSourceType = '73';
            
            // US3589825
            if(String.valueOf(commContactMap.get('Source')).equals('Email')) {
                if(commContactMap.containsKey('Email')){
                    strCommContactEmail = objStrOrNull(commContactMap.get('Email'));
                }
            }
            if(String.valueOf(commContactMap.get('Source')).equals('Email') && strCommContactEmail.length() > 0) {
                hscContact.emailAddress = strCommContactEmail;
            }

            caseDetails.hscContact = hscContact;
        }                                    
        
        //caseDetails => HscFollowUpContact
        ACET_CreateAuthRequest.HscFollowUpContact hscFollowUpContact = new ACET_CreateAuthRequest.HscFollowUpContact();
        ACET_CreateAuthRequest.CommunicationContactPhones commHSCContactPhones = new ACET_CreateAuthRequest.CommunicationContactPhones();
        List<ACET_CreateAuthRequest.CommunicationContactPhone> commHSCContactPhoneLst = new List<ACET_CreateAuthRequest.CommunicationContactPhone>();
        ACET_CreateAuthRequest.CommunicationContactPhone commHSCContactPhone = new ACET_CreateAuthRequest.CommunicationContactPhone();
        
        commHSCContactPhone.phoneType = String.valueOf(2);   
        commHSCContactPhone.phone = String.valueOf(commContactMap.get('ContactNumber')) + ' ' + String.valueOf(commContactMap.get('Ext'));
        commHSCContactPhone.phoneInternationalInd = 'false';
        commHSCContactPhone.preferredInd = 'false';
        commHSCContactPhoneLst.add(commHSCContactPhone);
        commHSCContactPhones.communicationContactPhone = commHSCContactPhoneLst;
        hscFollowUpContact.communicationContactPhones = commHSCContactPhones;
        hscFollowUpContact.medicalRecordNumber = commContactMap.containsKey('MedicalRecord')?objStrOrNull(commContactMap.get('MedicalRecord')):null;//Added By Vishnu as new mapping

        hscFollowUpContact.communicationContactPhones = communicationContactPhones;
        hscFollowUpContact.contactName = String.valueOf(commContactMap.get('Name'));
        hscFollowUpContact.contactRoleType = String.valueOf(roleMap.get(String.valueOf(commContactMap.get('Role'))));
        if(hscFollowUpContact.contactRoleType=='1')
        {
            hscFollowUpContact.departmentType=String.valueOf(departmentMap.get(String.valueOf(commContactMap.get('Department'))));
        }

        // US3589825
        if(strCommContactEmail.length() > 0){
            hscFollowUpContact.emailAddress = strCommContactEmail;
        }

        caseDetails.hscFollowUpContact = hscFollowUpContact;
        
        if(requiredInfoMap.containsKey('ServiceSetting')){
            caseDetails.serviceSettingType = String.valueOf(serviceSettingMap.get(String.valueOf(requiredInfoMap.get('ServiceSetting'))));
        }
        //caseDetails => hscServices
        ACET_CreateAuthRequest.HscServices hscServices = new ACET_CreateAuthRequest.HscServices();
        List<ACET_CreateAuthRequest.HscService> hscServiceLst = new List<ACET_CreateAuthRequest.HscService>();
        
        
        ACET_CreateAuthRequest.HscServiceFacility hscServiceFacility = new ACET_CreateAuthRequest.HscServiceFacility();
       
        //this for setting the expectedProcedureDate based on the condition if patient is admitted or not
        if(String.valueOf(requiredInfoMap.get('HasAdmitted')) == 'Yes'){            
            hscServiceFacility.expectedProcedureDate = String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
            if(requiredInfoMap.containsKey('ActualDischargeDt') && String.valueOf(requiredInfoMap.get('ActualDischargeDt')) != null) {
                hscServiceFacility.actualProcedureDate=String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
            }
        }else{
            hscServiceFacility.expectedProcedureDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
        }

        // hscServiceFacility.expectedProcedureDate = String.valueOf(requiredInfoMap.get('ServiceStartDt')); //TBD with varsha

        if(requiredInfoMap.containsKey('ProcedureData')){
            List<Object> procedureDataLst = (List<Object>)requiredInfoMap.get('ProcedureData');
            Integer j = 1;
            for(Object procedureDataObj : procedureDataLst){
                
                ACET_CreateAuthRequest.HscService hscService = new ACET_CreateAuthRequest.HscService();
                Map<String,Object> prcedureMap = (Map<String,Object>)procedureDataObj;
                System.debug('prcedureMap@@' + prcedureMap);
                if(strNotBlank(prcedureMap.get('ProcedureCode'))){

                    //Outpatient Values
                    // US3222360
                    ACET_CreateAuthRequest.HscServiceNonFacility hscNonFacility = new ACET_CreateAuthRequest.HscServiceNonFacility();
                    if (caseDetails.serviceSettingType == '2' || caseDetails.serviceSettingType == '3') {
                        hscNonFacility.serviceStartDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                        hscNonFacility.serviceEndDate = String.valueOf(requiredInfoMap.get('ServiceEndDt'));
                        if (requiredInfoMap.containsKey('PlaceOfService')) {
                            hscNonFacility.placeOfServiceCode = String.valueOf(placeOfServiceMap.get(String.valueOf(requiredInfoMap.get('PlaceOfService'))));
                        }
                        if (requiredInfoMap.containsKey('ServiceDescription')) {
                            hscNonFacility.serviceDescriptionType = String.valueOf(serviceDescription.get(String.valueOf(requiredInfoMap.get('ServiceDescription')))); // '1';//String.valueOf(requiredInfoMap.get('ServiceDescription'));
                        }
                        if (requiredInfoMap.containsKey('ServiceDetail')) {
                            hscNonFacility.serviceDetailType = String.valueOf(serviceDetailMap.get(String.valueOf(requiredInfoMap.get('ServiceDetail'))));
                        }
                        if (prcedureMap.containsKey('Total')) {
                            hscNonFacility.procedureUnitCount = String.valueOf(prcedureMap.get('Total'));
                        }
                        if (prcedureMap.containsKey('Count')) {
                            hscNonFacility.unitPerFrequencyCount = String.valueOf(prcedureMap.get('Count')); //hscNonFacility.procedureUnitCount=
                        }
                        hscNonFacility.dmeProcurementType = String.valueOf(dmeProcurementType.get(String.valueOf(prcedureMap.get('DMEProcurementType'))));
                        hscNonFacility.dmeTotalCost = String.valueOf(prcedureMap.get('DMETotalCost'));
                        hscNonFacility.procedureFrequencyType = String.valueOf(proceFrequencyType.get(String.valueOf(prcedureMap.get('Frequency'))));
                        hscNonFacility.procedureUnitOfMeasureType = String.valueOf(proceUnitofMeasureType.get(String.valueOf(prcedureMap.get('StandardOfMeasures'))));
                        //hscNonFacility.advanceNotifyDateTime='2020-10-06'; //commented as ICUE will handled it
                    }

                    if(caseDetails.serviceSettingType == '1' || caseDetails.serviceSettingType == '3')
                    {
                        hscService.hscServiceFacility = hscServiceFacility;
                    }
                    if(caseDetails.serviceSettingType == '2' || caseDetails.serviceSettingType == '3')
                    {
                        hscService.hscServiceNonFacility = hscNonFacility;
                    }
                    
                    hscService.serviceSeqNum = String.valueOf(j);
                    hscService.procedureCode = String.valueOf(prcedureMap.get('ProcedureCode'));
                    hscService.procedureCodeType = String.valueOf(procedureCodeTypeMap.get(String.valueOf(prcedureMap.get('ProcedureType'))));
                    hscService.serviceProviderSeqNum = serviceProviderSeqNum;//'1';
                    hscServiceLst.add(hscService);
                    j++;
                }
                
            }
        }
        ACET_CreateAuthRequest.Notes notesObj = new ACET_CreateAuthRequest.Notes();
        List<ACET_CreateAuthRequest.Note> noteList = new List<ACET_CreateAuthRequest.Note>();
        ACET_CreateAuthRequest.Note noteObj=new ACET_CreateAuthRequest.Note();

        // US3557591- New Mapping Needed for Notes to Pass User who is Creating Prior Auth for IP, OP & OPF - Swapnil
        ACET_CreateAuthRequest.Note defaultNoteObj=new ACET_CreateAuthRequest.Note();
        defaultNoteObj.noteCategoryType=132;
        defaultNoteObj.noteCategoryTypeDesc='System Communication';
        defaultNoteObj.noteText= 'Case created in Spire by '+loggedInUser.Name+'.';
        defaultNoteObj.createUserID=loggedInUser.FederationIdentifier;
        defaultNoteObj.createDateTime=(String.valueOf(authDetailsMap.get('creationDateNTime')));
        defaultNoteObj.createUserFirstName= loggedInUser.Firstname;
        defaultNoteObj.createUserLastName= loggedInUser.Lastname;
        noteList.add(defaultNoteObj);

        if(caseDetails.serviceSettingType == '2' || caseDetails.serviceSettingType == '3')
        {
            if(requiredInfoMap.containsKey('NoteDetails') && (!String.isBlank(String.valueOf(requiredInfoMap.get('NoteDetails')))))// && (requiredInfoMap.get('NoteDetails')!=null) && (requiredInfoMap.get('NoteDetails')!=''))
            {
                noteObj.noteCategoryType=1;
                noteObj.noteCategoryTypeDesc=String.valueOf(requiredInfoMap.get('NoteType'));
                noteObj.noteText=String.valueOf(requiredInfoMap.get('NoteDetails'));
                noteObj.createUserID=loggedInUser.FederationIdentifier;
                noteObj.createDateTime=(String.valueOf(authDetailsMap.get('creationDateNTime')));
                noteObj.createUserFirstName= loggedInUser.Firstname;
                noteObj.createUserLastName= loggedInUser.Lastname;
                noteList.add(noteObj);
            }
        }
        notesObj.note=noteList;
        caseDetails.notes=notesObj;
        
        hscServices.hscService = hscServiceLst;
        
        caseDetails.hscServices = hscServices;
        
        //caseDetails => HscFacility
        ACET_CreateAuthRequest.HscFacility hscFacility = new ACET_CreateAuthRequest.HscFacility();
        if(requiredInfoMap.containsKey('PlaceOfService')){
            hscFacility.placeOfServiceCode = String.valueOf(placeOfServiceMap.get(String.valueOf(requiredInfoMap.get('PlaceOfService'))));
        }
        
        if(requiredInfoMap.containsKey('ServiceDetail') ){
            hscFacility.serviceDetailType = String.valueOf(serviceDetailMap.get(String.valueOf(requiredInfoMap.get('ServiceDetail'))));
        }
        
        hscFacility.serviceDescriptionType = String.valueOf(serviceDescription.get(String.valueOf(requiredInfoMap.get('ServiceDescription'))));//'1'; //TBD wiht varsha
        //hscFacility.expectedAdmissionDate = '';
        //hscFacility.expectedDischargeDate = null;
        
        
        
        if(caseDetails.serviceSettingType == '1' || caseDetails.serviceSettingType == '3'){ //String.valueOf(serviceSettingMap.get(String.valueOf(requiredInfoMap.get('ServiceSetting'))))){
            
            //US3067275 - Swapnil - DE385238
            if(caseDetails.serviceSettingType == '1') {
                if(requiredInfoMap.containsKey('DischargeDisposition') && String.valueOf(requiredInfoMap.get('ActualDischargeDt')) != null) {
                    hscFacility.dischargeDispositionType = String.valueOf(dischargeDispositionMap.get(String.valueOf(requiredInfoMap.get('DischargeDisposition'))));
                }
            }
            //US3067275 ends - DE385238
            if(requiredInfoMap.containsKey('ReviewPriority') && String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Concurrent Expedited'){                
                caseDetails.reviewPriorityInd = 'Y';

                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt'));

                if(caseDetails.serviceSettingType == '1'){
                    if(String.valueOf(requiredInfoMap.get('HasAdmitted')) == 'Yes'){ 
                        hscFacility.actualAdmissionDateTime = String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
                        hscFacility.actualDischargeDateTime = strNotBlank(requiredInfoMap.get('ActualDischargeDt'))?String.valueOf(requiredInfoMap.get('ActualDischargeDt')):null;
                    }else{
                        hscFacility.actualAdmissionDateTime = null;
                        hscFacility.actualDischargeDateTime = null;
                    }
                }

                //hscFacility.admissionNotifyDateTime = '';  //this will be automatically set to communication date and time
            } else if(requiredInfoMap.containsKey('ReviewPriority') && String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Expedited Prospective'){
                caseDetails.reviewPriorityInd = 'Y';
                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt'));
                
                if(caseDetails.serviceSettingType == '1'){
                    if(String.valueOf(requiredInfoMap.get('HasAdmitted')) == 'Yes'){ 
                        hscFacility.actualAdmissionDateTime = String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
                        hscFacility.actualDischargeDateTime = strNotBlank(requiredInfoMap.get('ActualDischargeDt'))?String.valueOf(requiredInfoMap.get('ActualDischargeDt')):null;
                    }else{
                        hscFacility.actualAdmissionDateTime = null;
                        hscFacility.actualDischargeDateTime = null;
                    }
                }

                //hscFacility.admissionNotifyDateTime = '';  //this will be automatically set to communication date and time
            } else if(requiredInfoMap.containsKey('ReviewPriority') && String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Concurrent Routine'){
                caseDetails.reviewPriorityInd = 'N';
                
                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt')); 

                if(caseDetails.serviceSettingType == '1'){
                    if(String.valueOf(requiredInfoMap.get('HasAdmitted')) == 'Yes'){ 
                        hscFacility.actualAdmissionDateTime = String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
                        hscFacility.actualDischargeDateTime = strNotBlank(requiredInfoMap.get('ActualDischargeDt'))?String.valueOf(requiredInfoMap.get('ActualDischargeDt')):null;
                    }else{
                        hscFacility.actualAdmissionDateTime = null;
                        hscFacility.actualDischargeDateTime = null;
                    }
                }

                //hscFacility.admissionNotifyDateTime = '';  //this will be automatically set to communication date and time
            } else if(requiredInfoMap.containsKey('ReviewPriority') && String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Routine Prospective'){
                caseDetails.reviewPriorityInd = 'N';
                
                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                                
                if(caseDetails.serviceSettingType == '1'){
                    if(String.valueOf(requiredInfoMap.get('HasAdmitted')) == 'Yes'){ 
                        hscFacility.actualAdmissionDateTime = String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
                        hscFacility.actualDischargeDateTime = strNotBlank(requiredInfoMap.get('ActualDischargeDt'))?String.valueOf(requiredInfoMap.get('ActualDischargeDt')):null;
                    }else{
                        hscFacility.actualAdmissionDateTime = null;
                        hscFacility.actualDischargeDateTime = null;
                    }
                }

                //hscFacility.admissionNotifyDateTime = '';  //this will be automatically set to communication date and time
            }
        }else if(caseDetails.serviceSettingType == '2'){
            if(requiredInfoMap.containsKey('ReviewPriority') && (String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Expedited Prospective')){
                caseDetails.reviewPriorityInd = 'Y';
                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt'));  

                //hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                //hscFacility.admissionNotifyDateTime = '';  //TBD with varsha
            } else if(requiredInfoMap.containsKey('ReviewPriority') && (String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Routine Prospective')){
                caseDetails.reviewPriorityInd = 'N';

                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt')); 

                //hscFacility.actualAdmissionDateTime = String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
                //hscFacility.admissionNotifyDateTime = '';  //TBD with varsha
            } 
            
		}/*else if(caseDetails.serviceSettingType.contains('Outpatient Facility')){
		} */
        system.debug('caseDetails.reviewPriorityInd@@ ' + caseDetails.reviewPriorityInd);
        if(requiredInfoMap.containsKey('ActualDischargeDt')){
            hscFacility.actualDischargeDateTime = String.valueOf(requiredInfoMap.get('ActualDischargeDt'));
        }               
        
        if(requiredInfoMap.containsKey('ServiceEndDt')){
            hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt'));
        }   
        if(caseDetails.serviceSettingType == '1' || caseDetails.serviceSettingType == '3')
        {
            caseDetails.hscFacility = hscFacility;
        }
      
        authRequest.caseDetails = caseDetails;
        
        reqJSON = SYSTEM.JSON.serialize(authRequest);
        system.debug(LoggingLevel.INFO, 'reqJSON@@' + reqJSON);
        
        return reqJSON;
        
    }
    
    private ACETWSCalloutResult processResponse(){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        //vishnu Start
        String RespStr;
        if(UserInfo.getName()!='Senani Halpe'  || UserInfo.getName()!='Vishnu Kasu')
        {
            StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'AuthSRN_Response' LIMIT 1];
        	RespStr = response.Body.toString();
        }
        else
        {
                StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'CreateAuth_ErrorResponse' LIMIT 1];
        		RespStr = response.Body.toString();
        }
       ACET_CreateAuthCtrl.ACET_SRNResponseWrap result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(RespStr,ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
        calloutResult.Success = true;
        calloutResult.Message = '';
        calloutResult.Response = result; 
        
        return calloutResult;
        //vishnu End
    }
    private ACETWSCalloutResult getTTAPMockResponse(){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
         String respStr;

        if (UserInfo.getName()=='Vishnu Kasu'){
            StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'TTAP_URL_Response' LIMIT 1];
        	respStr = response.Body.toString();
        } else {

            StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'Validation_Api_MockResponse' LIMIT 1];
            respStr = response.Body.toString();
            StaticResource request = [SELECT Id, Body FROM StaticResource WHERE Name = 'Validation_Api_MockRequest' LIMIT 1];
            String requestString = request.Body.toString();
            createAppErrorLog('ACET_Spire', 'TTAP errorlog from Validation rules','', 400,requestString,respStr);

            response = [SELECT Id, Body FROM StaticResource WHERE Name = 'TTAP_CaseSubmit_Response' LIMIT 1];
            respStr = response.Body.toString();
        }
       ACET_CreateAuthCtrl.ACET_SRNResponseWrap result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(RespStr,ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
        result.responseType='TTAP';
        calloutResult.Success = true;
        calloutResult.Message = '';
        calloutResult.Response = result;

        return calloutResult;
    }
    // US3068301 Validation API Integration - Sarma - 20/01/2021

    private static void createAppErrorLog(string AppName, string servName, string respStatus, Integer respStatuscode, string reqBody,string resBody){

        String endPoint = '';
        endPoint = Label.ACET_ValidationAPI_EndPoint;
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog(AppName, servName, endPoint, respStatus, respStatuscode);
        List<Attachment> AppErrorLogAtts = new List<Attachment>();
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null,servName.contains('Validation')?'ValidationRequest':'TTAPRequest', reqBody));
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, servName.contains('Validation')?'ValidationResponse':'TTAPResponse', resBody));
        system.debug(LoggingLevel.INFO, 'AppErrorLog @@@ CreateAuth Validation: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
        Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
        if (ErrorLogSR.isSuccess()) {
            Id ErrorLogId = ErrorLogSR.getId();
            for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                AppErrorLogAtt.ParentId = ErrorLogId;
            }
           Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
        }
    }

    Public String jsonDateFormatYYYYMMDD(String dob)
    {
        String dd = '';
        String mm = '';
        if(String.valueOf(Date.parse(dob).day()).length() == 1){
            dd = '0' + String.valueOf(Date.parse(dob).day());
        }else{
            dd = String.valueOf(Date.parse(dob).day());
        }
        
        if(String.valueOf(Date.parse(dob).month()).length() == 1){
            mm = '0' + String.valueOf(Date.parse(dob).month());
        }else{
            mm = String.valueOf(Date.parse(dob).month());
        }
        return String.valueOf(Date.parse(dob).year())+'-'+mm+'-'+dd;
    }
    Public String objStrOrNull(Object strObj)
    {

        return String.isNotBlank(String.valueOf(strObj))?String.valueOf(strObj):null;
    }
    Public Boolean strNotBlank(Object str)
    {
        return String.isNotBlank(String.valueOf(str));
    }
	Public String setData(String str)
    {
	String str1='0';
	String str2='00';
	Integer size1=1;
	Integer size2=2;
        return String.isNotBlank(str)?str.length()==size1?str2+str:str.length()==size2?str1+str:str:null;
    }
    public class AuthDetails {
        @AuraEnabled public Boolean isValidMember {get;set;}
        @AuraEnabled public Boolean isFindIndividualSearch {get;set;}
        @AuraEnabled public Boolean isNoMemberToSearch {get;set;}
        @AuraEnabled public Boolean isMemberNotFound {get;set;}
        @AuraEnabled public Boolean isAdvancedSearch {get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String dob {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String zip {get;set;}
        @AuraEnabled public String phoneNumber {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String searchOption {get;set;}
        @AuraEnabled public String payerId {get;set;}
        @AuraEnabled public String memberUniqueId {get;set;}
    }
}