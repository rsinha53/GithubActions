public with sharing class ACET_CreateAuthorizationWebService {
    
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
        'Office'=>11,
        'Inpatient Rehabilitation'=>61,
        'Outpatient Facility (POS 22)'=>24
        }; //US3738221
                                                                
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
        'Dialysis' => 45,
        'Chiropractic' => 8,
        'Dental' => 9,
        'DME' => 11,
        'Home Services' => 41,
        'Lab' => 16,
        'Long Term Acute' => 17,
        'Medication' => 18,
        'Orthotics' => 21,
        'Private Duty' => 26,
        'Prosthetic' => 27,
        'Transportation' => 36
        };
                                                                            
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

    public ACETWSCalloutResult createAuth(String authData, ACET_CreateAuthorizationRequest.CaseDetails caseDetails){

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_CreateAuthCtrl.ACET_SRNResponseWrap result = new ACET_CreateAuthCtrl.ACET_SRNResponseWrap();

       try{
    
            String requestBody = requestFormatProcessing(authData, caseDetails);
            // TTAP Config
            HttpResponse ttapResponse;
            ACET_WebserviceCalloutFramework ttapWsCallOutFW = new ACET_WebserviceCalloutFramework();
            ttapWsCallOutFW.serviceName = 'TTAP';
            ttapWsCallOutFW.requestBody = requestBody;
            HttpRequest ttapRequest = ttapWsCallOutFW.getHttpRequest(); 
            ttapResponse = ttapWsCallOutFW.getResponse();

            Integer ttapStatusCode = ttapResponse.getStatusCode();
           
            if(ttapStatusCode==200){
                result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(ttapResponse.getBody(),ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
            }

            if(ttapStatusCode==200 && (!(String.isBlank(String.valueOf(result.returnDecisionValueType)))) && (result.returnDecisionValueType.equalsIgnoreCase('TTAP'))
                && (!(String.isBlank(String.valueOf(result.redirectUrl)))) && ((String.valueOf(result.redirectUrl).containsIgnoreCase('https')))){
                    result.responseType='TTAP';
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = result;
                    createAppErrorLog('ACET_Spire', 'TTAP Response',ttapRequest.getEndpoint(), ttapResponse.getStatus(), ttapResponse.getStatusCode(), requestBody, ttapResponse.getBody());
                    return calloutResult;
            }
            else{

                // Validation API Config
                HttpResponse validationResponse;
                ACET_WebserviceCalloutFramework validationWsCallOutFW = new ACET_WebserviceCalloutFramework();
                validationWsCallOutFW.serviceName = 'CaseSubmitValidation'; 
                validationWsCallOutFW.requestBody = requestBody;
                validationResponse = validationWsCallOutFW.getResponse();
                HttpRequest validationRequest = validationWsCallOutFW.getHttpRequest(); 
            
                //US3068301 - End

                // Case Submit API Config
                HttpResponse caseSubmitResponse;
                ACET_WebserviceCalloutFramework caseSubmitWsCallOutFW = new ACET_WebserviceCalloutFramework();
                caseSubmitWsCallOutFW.serviceName = 'CaseSubmitPOCA'; 
                caseSubmitWsCallOutFW.requestBody = requestBody;
                caseSubmitResponse = caseSubmitWsCallOutFW.getResponse();
                HttpRequest caseSubmitRequest = caseSubmitWsCallOutFW.getHttpRequest(); 

                Integer statusCode = caseSubmitResponse.getStatusCode();
                calloutResult.statusCode = statusCode;

                if(ttapStatusCode==200 && (!(String.isBlank(String.valueOf(result.returnDecisionValueType)))) && (result.returnDecisionValueType.equalsIgnoreCase('TTAP'))
                    && (!(String.isBlank(String.valueOf(result.redirectUrl))))){
                        createAppErrorLog('ACET_Spire', 'TTAP redirectUrl is getting empty or null', ttapRequest.getEndpoint(),ttapResponse.getStatus(), ttapResponse.getStatusCode(), requestBody, ttapResponse.getBody());
                }else{
                    createAppErrorLog('ACET_Spire', 'TTAP Response', ttapRequest.getEndpoint(), ttapResponse.getStatus(), ttapResponse.getStatusCode(), requestBody, ttapResponse.getBody());
                }

                // Case Submit API logs generation
                createAppErrorLog('ACET_Spire', 'CaseSubmitPOCA', caseSubmitRequest.getEndpoint(), caseSubmitResponse.getStatus(), caseSubmitResponse.getStatusCode(), requestBody, caseSubmitResponse.getBody());

                if(statusCode == 200 || statusCode == 201) {
                    result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(caseSubmitResponse.getBody(),ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
                    result.responseType='CaseSubmit';
                } else {
                    result = (ACET_CreateAuthCtrl.ACET_SRNResponseWrap)System.JSON.deserialize(caseSubmitResponse.getBody(),ACET_CreateAuthCtrl.ACET_SRNResponseWrap.class);
                    result.responseType = 'CaseSubmit failed';
                    result.responseCode = String.valueOf(statusCode);
                    calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    calloutResult.Success = true; 
                    calloutResult.statusCode = statusCode;
                    calloutResult.Message = '';
                    calloutResult.Response = result;
                    //US3068301
                    createAppErrorLog('ACET_Spire', 'TTAP errorlog from Validation rules', validationRequest.getEndpoint(), validationResponse.getStatus(), validationResponse.getStatusCode(), requestBody, validationResponse.getBody());
                    return calloutResult;
                    
                } 
                    //US3068301
                    createAppErrorLog('ACET_Spire', 'TTAP errorlog from Validation rules', validationRequest.getEndpoint(), validationResponse.getStatus(), validationResponse.getStatusCode(), requestBody, validationResponse.getBody());
                   
                }

                calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = result; 

       } catch(Exception e){
            System.debug(e.getMessage());
            System.debug('@@@@Exception ## '+e.getLineNumber());
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.statusCode = 999;
        } 
        return calloutResult;
    }



    public String requestFormatProcessing(String authData, ACET_CreateAuthorizationRequest.CaseDetails caseDetailObject ){                
        Map<String, Object> authDetailsMap = (Map<String, Object>)JSON.deserializeUntyped(authData);
        Map<String, Object> sRNDataMap = new Map<String, Object>();
        Map<String, Object> requiredInfoMap = new Map<String, Object>();
        Map<String, Object> commContactMap = new Map<String, Object>();
        Map<String, Object> submitInfoMap = new Map<String, Object>();
        Integer serviceProviderSeqNum;

        if (authDetailsMap.containsKey('SRNData')) {
            Object sRNDataObj  = authDetailsMap.get('SRNData');
            String srnString = String.valueOf(sRNDataObj);
            
            sRNDataMap = (Map<String, Object>)JSON.deserializeUntyped(srnString);
            if (sRNDataMap.containsKey('RequiredInfo')) {
                requiredInfoMap = (Map<String, Object>)sRNDataMap.get('RequiredInfo');
            }     
            if (sRNDataMap.containsKey('CommContact')) {
                commContactMap = (Map<String, Object>)sRNDataMap.get('CommContact');
            }
            if (sRNDataMap.containsKey('SubmitInfo')) {
                submitInfoMap = (Map<String, Object>)sRNDataMap.get('SubmitInfo');
            }                               
        }
        
        String reqJSON;
        ACET_CreateAuthorizationRequest authRequest = new ACET_CreateAuthorizationRequest();       
        
        // Passing Federation ID in userID
        String loggedInUserID = UserInfo.getUserId();
        User loggedInUser = [SELECT Name, Email, FederationIdentifier, Lastname, Firstname FROM User WHERE Id= :loggedInUserID];

        //Fill invocationContext details
        ACET_CreateAuthorizationRequest.InvocationContext invocationContext = new ACET_CreateAuthorizationRequest.InvocationContext();
        invocationContext.clientID = 'ACET';//'EMR-PerfTest';
        invocationContext.locationID = 'ACET';//'EMR-PerfTest';
        invocationContext.userID = loggedInUser.FederationIdentifier; //'ACET'; //'EMR-PerfTest';
        invocationContext.userIDType = 'USER_ID';//'USER_ID';
        invocationContext.clientCorrelationID = '';//'9876-CLIENTCORR-TEST-1234';
        invocationContext.serviceCorrelationID = '';//'9876-CLIENTCORR-TEST-1234';
        authRequest.invocationContext = invocationContext;
        
        //Fill metadata details 
        ACET_CreateAuthorizationRequest.Metadata metaData = new ACET_CreateAuthorizationRequest.Metadata();
        metaData.clientGroup = 'ACET';//'EMR-PerfTest';
        metaData.clientBusiness = 'ACET';//'EMR-PerfTest';
        metaData.clientLocation = '';//'EMR-PerfTest';
        metaData.clientNPI = '';//'12345678';
        metaData.caseSubmissionTransactionID = '';//9876-CASE-TRANSID-TEST-1234;
        authRequest.metadata = metaData;
        
        authRequest.transactionId = '';
        
        //Fill caseDetails
        ACET_CreateAuthorizationRequest.CaseDetails caseDetails = new ACET_CreateAuthorizationRequest.CaseDetails();        
        
        //caseDetails => hscDiagnoses
        ACET_CreateAuthorizationRequest.HscDiagnoses hscDiagnoses = new ACET_CreateAuthorizationRequest.HscDiagnoses();
        List<ACET_CreateAuthorizationRequest.HscDiagnosis> hscDiagnosisLst = new List<ACET_CreateAuthorizationRequest.HscDiagnosis>();
        
        Integer seqNum=1;
        if(requiredInfoMap.containsKey('PrimaryCode') && strNotBlank(requiredInfoMap.get('PrimaryCode'))){
            
            ACET_CreateAuthorizationRequest.HscDiagnosis hscDiagnosis = new ACET_CreateAuthorizationRequest.HscDiagnosis();
            hscDiagnosis.primaryInd = 'true';
            hscDiagnosis.diagnosisCodeType = '0';
            hscDiagnosis.diagnosisSeqNum = String.valueOf(seqNum);
            hscDiagnosis.diagnosisCode = String.valueOf(requiredInfoMap.get('PrimaryCode'));
            hscDiagnosisLst.add(hscDiagnosis);
        }
        
        if(requiredInfoMap.containsKey('AdmittingCode') && strNotBlank(requiredInfoMap.get('AdmittingCode'))){
            seqNum++;
            ACET_CreateAuthorizationRequest.HscDiagnosis hscDiagnosis = new ACET_CreateAuthorizationRequest.HscDiagnosis();
            hscDiagnosis.admitInd = 'true';
            hscDiagnosis.diagnosisCodeType = '0';
            hscDiagnosis.diagnosisSeqNum = String.valueOf(seqNum);
            hscDiagnosis.diagnosisCode = String.valueOf(requiredInfoMap.get('AdmittingCode'));
            hscDiagnosisLst.add(hscDiagnosis);
        }
        
        if(requiredInfoMap.containsKey('DiagnosisData')){
            List<Object> diagnosisData = (List<Object>)requiredInfoMap.get('DiagnosisData');
            for(Object diagnosisObj : diagnosisData){
                Map<String, Object> diagnosisMap = (Map<String, Object>)diagnosisObj;
                if(strNotBlank(diagnosisMap.get('DiagnosisCode'))){
                    seqNum++;
                    ACET_CreateAuthorizationRequest.HscDiagnosis hscDiagnosis = new ACET_CreateAuthorizationRequest.HscDiagnosis();
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
        ACET_CreateAuthorizationRequest.HscProviders hscProviders = new ACET_CreateAuthorizationRequest.HscProviders();
        List<ACET_CreateAuthorizationRequest.HscProvider> hscProviderList = new List<ACET_CreateAuthorizationRequest.HscProvider>();
        if(caseDetailObject != null && caseDetailObject.hscProviders != null &&  caseDetailObject.hscProviders.hscProvider != null){

            for(ACET_CreateAuthorizationRequest.HscProvider providerObject : caseDetailObject.hscProviders.hscProvider){
            
                if(submitInfoMap.containsKey('AlternativeFax')){                
                    providerObject.alternateFax = submitInfoMap.containsKey('AlternativeFax')?objStrOrNull(submitInfoMap.get('AlternativeFax')):null;//String.isNotBlank(String.valueOf(prdDetailMap.get('alternateFax')))?String.valueOf(prdDetailMap.get('alternateFax')):null:null;
                } 
                if(submitInfoMap.containsKey('ConfirmFax')){ 
                    providerObject.alternateFaxConfirmedInd = submitInfoMap.containsKey('ConfirmFax')?Boolean.valueOf(submitInfoMap.get('ConfirmFax')):false;
                }
                if(submitInfoMap.containsKey('SendMail')){ 
                    providerObject.hscLetterOptOutCcInd = submitInfoMap.containsKey('SendMail') ? Boolean.valueOf(submitInfoMap.get('SendMail')) : false;
                }
                
                for(ACET_CreateAuthorizationRequest.ProviderRole roleObj : providerObject.providerRoles.providerRole){
                    if(roleObj.providerRole == 'SJ'){
                        serviceProviderSeqNum = providerObject.providerSeqNum;
                    }
                }

                hscProviderList.add(providerObject);                  
            }
        }                
        hscProviders.hscProvider = hscProviderList;
        caseDetails.hscProviders = hscProviders;
        
        // caseDetails => Member 
        if(caseDetailObject != null && caseDetailObject.member != null){
            caseDetails.member = caseDetailObject.member;
        }
        
        //caseDetails => HscContact
        ACET_CreateAuthorizationRequest.HscContact hscContact = new ACET_CreateAuthorizationRequest.HscContact();
        ACET_CreateAuthorizationRequest.CommunicationContactPhones communicationContactPhones = new ACET_CreateAuthorizationRequest.CommunicationContactPhones();
        List<ACET_CreateAuthorizationRequest.CommunicationContactPhone> communicationContactPhoneLst = new List<ACET_CreateAuthorizationRequest.CommunicationContactPhone>();
         
       // US3589825
       String strCommContactEmail = '';

        if (sRNDataMap.containsKey('CommContact')) {
            commContactMap = (Map<String, Object>)sRNDataMap.get('CommContact');
           
            if(commContactMap.containsKey('ContactNumber')){
                ACET_CreateAuthorizationRequest.CommunicationContactPhone communicationContactPhone = new ACET_CreateAuthorizationRequest.CommunicationContactPhone();
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
                    ACET_CreateAuthorizationRequest.CommunicationContactPhone communicationContactFax = new ACET_CreateAuthorizationRequest.CommunicationContactPhone();
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
        ACET_CreateAuthorizationRequest.HscFollowUpContact hscFollowUpContact = new ACET_CreateAuthorizationRequest.HscFollowUpContact();
        ACET_CreateAuthorizationRequest.CommunicationContactPhones commHSCContactPhones = new ACET_CreateAuthorizationRequest.CommunicationContactPhones();
        List<ACET_CreateAuthorizationRequest.CommunicationContactPhone> commHSCContactPhoneLst = new List<ACET_CreateAuthorizationRequest.CommunicationContactPhone>();
        ACET_CreateAuthorizationRequest.CommunicationContactPhone commHSCContactPhone = new ACET_CreateAuthorizationRequest.CommunicationContactPhone();
        
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
        ACET_CreateAuthorizationRequest.HscServices hscServices = new ACET_CreateAuthorizationRequest.HscServices();
        List<ACET_CreateAuthorizationRequest.HscService> hscServiceLst = new List<ACET_CreateAuthorizationRequest.HscService>();
        
        
        ACET_CreateAuthorizationRequest.HscServiceFacility hscServiceFacility = new ACET_CreateAuthorizationRequest.HscServiceFacility();
       
        //this for setting the expectedProcedureDate based on the condition if patient is admitted or not
        if(String.valueOf(requiredInfoMap.get('HasAdmitted')) == 'Yes'){            
            hscServiceFacility.expectedProcedureDate = String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
            if(requiredInfoMap.containsKey('ActualDischargeDt') && String.valueOf(requiredInfoMap.get('ActualDischargeDt')) != null) {
                hscServiceFacility.actualProcedureDate=String.valueOf(requiredInfoMap.get('ActualAdmissionDt'));
            }
        }else{
            hscServiceFacility.expectedProcedureDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
        }

        if(requiredInfoMap.containsKey('ProcedureData')){
            List<Object> procedureDataLst = (List<Object>)requiredInfoMap.get('ProcedureData');
            Integer j = 1;
            for(Object procedureDataObj : procedureDataLst){
                
                ACET_CreateAuthorizationRequest.HscService hscService = new ACET_CreateAuthorizationRequest.HscService();
                Map<String,Object> prcedureMap = (Map<String,Object>)procedureDataObj;
                if(strNotBlank(prcedureMap.get('ProcedureCode'))){

                    //Outpatient Values
                    // US3222360
                    ACET_CreateAuthorizationRequest.HscServiceNonFacility hscNonFacility = new ACET_CreateAuthorizationRequest.HscServiceNonFacility();
                    if (caseDetails.serviceSettingType == '2' || caseDetails.serviceSettingType == '3') {
                        hscNonFacility.serviceStartDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                        hscNonFacility.serviceEndDate = String.valueOf(requiredInfoMap.get('ServiceEndDt'));
                        if (requiredInfoMap.containsKey('PlaceOfService')) {
                            hscNonFacility.placeOfServiceCode = String.valueOf(placeOfServiceMap.get(String.valueOf(requiredInfoMap.get('PlaceOfService'))));
                        }
                        if (requiredInfoMap.containsKey('ServiceDescription')) {
                            hscNonFacility.serviceDescriptionType = String.valueOf(serviceDescription.get(String.valueOf(requiredInfoMap.get('ServiceDescription')))); 
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
        ACET_CreateAuthorizationRequest.Notes notesObj = new ACET_CreateAuthorizationRequest.Notes();
        List<ACET_CreateAuthorizationRequest.Note> noteList = new List<ACET_CreateAuthorizationRequest.Note>();
        ACET_CreateAuthorizationRequest.Note noteObj=new ACET_CreateAuthorizationRequest.Note();

        // US3557591- New Mapping Needed for Notes to Pass User who is Creating Prior Auth for IP, OP & OPF - Swapnil
        ACET_CreateAuthorizationRequest.Note defaultNoteObj=new ACET_CreateAuthorizationRequest.Note();
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
        ACET_CreateAuthorizationRequest.HscFacility hscFacility = new ACET_CreateAuthorizationRequest.HscFacility();
        if(requiredInfoMap.containsKey('PlaceOfService')){
            hscFacility.placeOfServiceCode = String.valueOf(placeOfServiceMap.get(String.valueOf(requiredInfoMap.get('PlaceOfService'))));
        }
        
        if(requiredInfoMap.containsKey('ServiceDetail') ){
            hscFacility.serviceDetailType = String.valueOf(serviceDetailMap.get(String.valueOf(requiredInfoMap.get('ServiceDetail'))));
        }
        
        hscFacility.serviceDescriptionType = String.valueOf(serviceDescription.get(String.valueOf(requiredInfoMap.get('ServiceDescription'))));//'1'; //TBD wiht varsha
        
        if(caseDetails.serviceSettingType == '1' || caseDetails.serviceSettingType == '3'){ 
            
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

            }
        }else if(caseDetails.serviceSettingType == '2'){
            if(requiredInfoMap.containsKey('ReviewPriority') && (String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Expedited Prospective')){
                caseDetails.reviewPriorityInd = 'Y';
                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt'));  

            } else if(requiredInfoMap.containsKey('ReviewPriority') && (String.valueOf(requiredInfoMap.get('ReviewPriority')) == 'Routine Prospective')){
                caseDetails.reviewPriorityInd = 'N';

                hscFacility.expectedAdmissionDate = String.valueOf(requiredInfoMap.get('ServiceStartDt'));
                hscFacility.expectedDischargeDate = String.valueOf(requiredInfoMap.get('ServiceEndDt')); 
            } 
            
		}
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
        System.debug(LoggingLevel.INFO, 'reqJSON@@' + reqJSON);
        
        return reqJSON;
        
    }


    private static void createAppErrorLog(string appName, string servName, String endPoint, string respStatus, Integer respStatuscode, string reqBody,string resBody){

    Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog(appName, servName, endPoint, respStatus, respStatuscode);
    List<Attachment> appErrorLogAtts = new List<Attachment>();
    String flowName = '';
    if(servName.contains('Validation')){
        flowName = 'Validation';
    } else if(servName.contains('TTAP')){
        flowName = 'TTAP';
    } else {
        flowName = 'CaseSubmit';
    }
    appErrorLogAtts.add(ACETUtility.CreateAttachment(null,flowName+'Request', reqBody));
    appErrorLogAtts.add(ACETUtility.CreateAttachment(null, flowName+'Response', resBody));
   
    Database.SaveResult errorLogSR = Database.insert(appErrorLog);
        if (errorLogSR.isSuccess()) {
            Id errorLogId = errorLogSR.getId();
            for(Attachment appErrorLogAtt : appErrorLogAtts) {
                appErrorLogAtt.ParentId = errorLogId;
            }
           Database.SaveResult[] errorLogAttsSR = Database.insert(appErrorLogAtts);
        }
    }

    public String objStrOrNull(Object strObj){
        return String.isNotBlank(String.valueOf(strObj))?String.valueOf(strObj):null;
    }

    public Boolean strNotBlank(Object str){
        return String.isNotBlank(String.valueOf(str));
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