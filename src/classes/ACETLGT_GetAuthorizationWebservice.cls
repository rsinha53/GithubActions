public class ACETLGT_GetAuthorizationWebservice extends ACETWebservice
{
    public override void GetEndpoint()
    {
        GetEndpointDetail('GetHealthSvrAuthorizationEndpoint');
    }
    
	public ACETLGT_GetAuthorizationWebservice () {
        super('Stargate');
    } 
	
    public static string displayDateTimeFormat(string strDatetimeFormat){
        list<string> lstSplit = strDatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
        integer myHour = Integer.valueOf(lsttimeformat[0]);
        string strAMPM = myHour>=12?'PM':'AM';
        Integer myClockHour = 12;
        Integer myTime = myHour>12?myHour-myClockHour:myHour;
        
        string strDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0]+' '+myTime+':'+lsttimeformat[1]+' '+strAMPM;
        return strDateFormat;
    } 
    
    public static string strDateFormat(string strDateFormat){
        list<string> lstDateformat = strDateFormat.split('-');
        if(lstDateformat.size()==3){
            return lstDateformat[1]+'/'+lstDateformat[2]+'/'+lstDateformat[0];
        }
        else
            return '';
    }
    public static string convertToDateFormat(string str2DatetimeFormat){
        list<string> lstSplit = str2DatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
                
        string finalDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0];
        return finalDateFormat;
    }    
    
    private void GetRequestBody(String AuthId, String SRK)
    {
        List<String> SearchParameters = new String[] {AuthId, SRK};
            RequestBody = GetRequestBody('GetAuthorizationsRequestJSON',SearchParameters);
    }
    
    //public ACETWSCalloutResult GetAuthorizationDetail(String AuthId, String SRK, String Type,String federationID,List<String> SystemLabels)
    public ACETWSCalloutResult GetAuthorizationDetail(String AuthId, String SRK)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETLGT_AuthorizationDetailResult Authorization = new ACETLGT_AuthorizationDetailResult();        
        ACETLGT_GetAuthorizationJSON2Apex.AuthDetailsResponse DRAuthorization =new ACETLGT_GetAuthorizationJSON2Apex.AuthDetailsResponse();
        
        try
        {
            GetEndpoint();
            GetRequestBody(AuthId, SRK);
            HttpResponse Response = Send(OAuthConfig);
            //Response.setStatusCode(400);
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            
            if (Response.getStatusCode() == 200){
                ACETLGT_GetAuthorizationJSON2APEX ACTGAJSON2Apex = (ACETLGT_GetAuthorizationJSON2APEX)JSON.deserialize(ReplaceKeywords(Response.getBody()), ACETLGT_GetAuthorizationJSON2APEX.class);
                system.debug('ACTGAJSON2Apex : ' + ACTGAJSON2Apex);
                
                DRAuthorization = ACTGAJSON2Apex.authDetailsResponse ;
                if (DRAuthorization != null){
                    system.debug(' DRAuthorization : ' + DRAuthorization);
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';    
                    
                    //Start:: Authorization Details section Mapping
                    //Common for IP, OP and OPS
                    
                    if(DRAuthorization.serviceSettingTypeCode!=null)
                        Authorization.Authorization_Type = DRAuthorization.serviceSettingTypeCode.description==null?'':DRAuthorization.serviceSettingTypeCode.description;
                    if(DRAuthorization.statusCode !=null)
                        Authorization.Case_Status = DRAuthorization.statusCode.description==null?'':DRAuthorization.statusCode.description;
                    if(DRAuthorization.statusReasonCode!=null)
                        Authorization.Case_Reason_Desc = DRAuthorization.statusReasonCode.description==null?'':DRAuthorization.statusReasonCode.description;
                    if(DRAuthorization.reviewPriority!=null)
                        Authorization.Review_Priority = DRAuthorization.reviewPriority.description==null?'':DRAuthorization.reviewPriority.description;
                    if(DRAuthorization.serviceCategoryTypeCode!=null)
                        Authorization.Coverage_Type = DRAuthorization.serviceCategoryTypeCode.description==null?'':DRAuthorization.serviceCategoryTypeCode.description;
                    Authorization.caseOwner = (DRAuthorization.caseOwner != null)?DRAuthorization.caseOwner:'';
                    system.debug('***details');
                    
                    
                    //Notification Type mapping for facility
                    //Common for IP, OP and OPS
                    if(DRAuthorization.facility !=null){
                        Authorization.notifications = new list<ACETLGT_AuthorizationDetailResult.notification>();
                        if(DRAuthorization.facility.admissionNotifyDateTime!=null){
                            ACETLGT_AuthorizationDetailResult.notification noti  = new ACETLGT_AuthorizationDetailResult.notification();
                            noti.Notification_Type = 'Admission';
                            noti.Notified_Date_Time = displayDateTimeFormat(DRAuthorization.facility.admissionNotifyDateTime==null?'':DRAuthorization.facility.admissionNotifyDateTime);
                            Authorization.notifications.add(noti);
                        }
                        if(DRAuthorization.facility.dischargeNotifyDateTime!=null){
                            ACETLGT_AuthorizationDetailResult.notification noti  = new ACETLGT_AuthorizationDetailResult.notification();
                            noti.Notification_Type = 'Discharge';
                            noti.Notified_Date_Time = displayDateTimeFormat(DRAuthorization.facility.dischargeNotifyDateTime==null?'':DRAuthorization.facility.dischargeNotifyDateTime);
                            Authorization.notifications.add(noti);
                        }
                        if(DRAuthorization.facility.advanceNotificationTimeStamp!=null){
                            ACETLGT_AuthorizationDetailResult.notification noti  = new ACETLGT_AuthorizationDetailResult.notification();
                            noti.Notification_Type = 'Advance';
                            noti.Notified_Date_Time = displayDateTimeFormat(DRAuthorization.facility.advanceNotificationTimestamp==null?'':DRAuthorization.facility.advanceNotificationTimestamp);
                            Authorization.notifications.add(noti);
                        }
                        
                    }
                    
                    
                    
                    //Providers section Mapping::Providers
                    //Common for IP, OP and OPS
                    if(DRAuthorization.providers!=null){
                        Authorization.authProviderDetails = new list<ACETLGT_AuthorizationDetailResult.authProviderDetail>();
                        
                        for(ACETLGT_GetAuthorizationJSON2APEX.providers authProv: DRAuthorization.providers){
                            ACETLGT_AuthorizationDetailResult.authProviderDetail aPD = new ACETLGT_AuthorizationDetailResult.authProviderDetail();
                            if(authProv.providerIdentifiers!=null) {
                                for(ACETLGT_GetAuthorizationJSON2APEX.providerIdentifiers aPDId:authProv.providerIdentifiers){
                                    if(aPDId.typeCode!=null) {
                                        if(aPDId.typeCodeDesc=='Provider Lifetime ID'){
                                            aPD.Provider_ID =  aPDId.Id;  
                                        }
                                       else if(aPDId.typeCodeDesc=='NDBMpin'){
                                            aPD.Provider_ID =  aPDId.Id;  
                                        }
                                        if(aPDId.typeCodeDesc=='Federal Tax ID'){
                                            aPD.TIN =  aPDId.Id;  
                                        }
                                    } 
                                }
                            }
                            system.debug('***ID/TIN');
                            system.debug('***roel structure'+authProv.role);
                    
                            if(authProv.role!=null && !authProv.role.isEmpty()) {
                                Boolean isOnlyFacilitycheck= true;
                                for(ACETLGT_GetAuthorizationJSON2APEX.Role aPR:authProv.role){
                                    system.debug('***Inside');
                                    if(aPR.descr!=null) {
                                            
                                            if(aPD.Provider_Facility_Role !=null){
                                                system.debug('***Inside if'+aPD.Provider_Facility_Role );
                                    
                                                aPD.Provider_Facility_Role = aPD.Provider_Facility_Role + ',' +aPR.descr;
                                            } 
                                            else{
                                                system.debug('***Inside else');
                                    
                                                aPD.Provider_Facility_Role = aPR.descr;
                                            }
                                        }
                                    }
                                }
                                else
                                    aPD.Provider_Facility_Role = '';

                                system.debug('***Role'+aPD.Provider_Facility_Role  );
                    
                                if(authProv.categoryCode!=null){
                                    if((authProv.categoryCode=='H')||(authProv.categoryCode=='A')){
                                        aPD.Facility_Service_Provider_Status = authProv.organizationName==null?'':authProv.organizationName;
                                        if(authProv.organizationName==null){
                                                aPD.Facility_Service_Provider_Status = ((authProv.lastName==null?'':authProv.lastName)+(authProv.middleName==null?'':','+authProv.middleName)+(authProv.firstName==null?'':','+authProv.firstName));
                                        }
                                    }                                                
                                    else{
                                        if(authProv.organizationName==null){
                                            aPD.Facility_Service_Provider_Status =((authProv.lastName==null?'':authProv.lastName)+(authProv.middleName==null?'':','+authProv.middleName)+(authProv.firstName==null?'':','+authProv.firstName));
                                        }
                                        else{
                                            aPD.Facility_Service_Provider_Status = authProv.organizationName==null?'':authProv.organizationName; 
                                        }
                                        if(aPD.Facility_Service_Provider_Status =='')
                                            aPD.Facility_Service_Provider_Status = authProv.organizationName==null?'':authProv.organizationName; 
                                    }
                                }
                                else{
                                    aPD.Facility_Service_Provider_Status='';
                                }
                                system.debug('***provider status'+aPD.Facility_Service_Provider_Status);
                    
                                
                                if(aPD.Facility_Service_Provider_Status==null || aPD.Facility_Service_Provider_Status=='')
                                    aPD.Facility_Service_Provider_Status='NA';
                                
                              //Code added by Avish on 06272017
                                  aPD.Facility_Service_Provider_Status = ACETProviderUtility.validateConcatenateOfStrings(aPD.Facility_Service_Provider_Status,'','/');
                                if(authProv.networkStatusType!=null){
                                    aPD.Facility_Service_Provider_Status += authProv.networkStatusType.description==null?'':authProv.networkStatusType.description;
                                }
                            
                            system.debug('***networkstatus type desciption'+aPD.Facility_Service_Provider_Status);
                                                        
                            
                            if(authProv.address!=null){
                                aPD.Address_1 = authProv.address.addressLine1 ==null?'':authProv.address.addressLine1 ;
                                aPD.city = authProv.address.City==null?'':authProv.address.City;
                                if(authProv.address.State!=null)                 
                                    aPD.state = authProv.address.State.code==null?'':authProv.address.State.code;
                                
                                    aPD.ZIP = authProv.address.postalCode1==null?'':authProv.address.postalCode1;
                                
                            }
                            system.debug('***address');
                            system.debug('***spec before'+authProv.specialtyType);
                    
                            if(authProv.specialtyType !=null){
                                for(ACETLGT_GetAuthorizationJSON2APEX.AvaliabilityeffectiveDateRange a:authProv.specialtyType ){
                                    system.debug('*** spec'+a.descr) ;
                                    aPD.Speciality = a.descr==null?'':a.descr;
                                }
                            }
                            system.debug('***speciality'+aPD.Speciality);
                    
                            system.debug('***Provider Info'+aPD);
                            Authorization.authProviderDetails.add(aPD);
                        }
                   }  
                     
                    
                    //Facility Line Mapping : Facility
                    //Common for IP and OPS
                    Authorization.authFacilityDetails = new List<ACETLGT_AuthorizationDetailResult.authFacilityDetail>();
                                
                    if(DRAuthorization.facility!=null){
                        ACETLGT_AuthorizationDetailResult.authFacilityDetail authFac = new ACETLGT_AuthorizationDetailResult.authFacilityDetail();
                    
                        authFac.Facility_Authorization_Number = DRAuthorization.facility.serviceReferenceNumber==null?'':DRAuthorization.facility.serviceReferenceNumber;
                        if(DRAuthorization.facility.expectedAdmissionDate!=null){
                            Authorization.Expected_Admission_Date = DRAuthorization.facility.expectedAdmissionDate==null?'':ACETUtility.format(Date.valueOf(DRAuthorization.facility.expectedAdmissionDate));
                        }
                        if(DRAuthorization.facility.expectedDischargeDate!=null){
                            Authorization.Expected_Discharge_Date = DRAuthorization.facility.expectedDischargeDate==null?'':ACETUtility.format(Date.valueOf(DRAuthorization.facility.expectedDischargeDate));
                        }
                        if(DRAuthorization.facility.actualAdmissionDateTime!=null){
                            Authorization.Actual_Admission_Date = displayDateTimeFormat(DRAuthorization.facility.actualAdmissionDateTime==null?'':DRAuthorization.facility.actualAdmissionDateTime);
                        }
                        if(DRAuthorization.facility.actualDischargeDateTime!=null){
                            Authorization.Actual_Discharge_Date = displayDateTimeFormat(DRAuthorization.facility.actualDischargeDateTime==null?'':DRAuthorization.facility.actualDischargeDateTime);
                        }
                        if(DRAuthorization.facility.placeOfServiceCode!=null){
                               authFac.POS = ACETProviderUtility.validateConcatenateOfStrings(DRAuthorization.facility.placeOfServiceCode.code, DRAuthorization.facility.placeOfServiceCode.description, '-');
                        }
                        if(DRAuthorization.facility.serviceDetailCategoryCode!=null){
                            authFac.Service_Detail = DRAuthorization.facility.serviceDetailCategoryCode.description==null?'':DRAuthorization.facility.serviceDetailCategoryCode.description;
                        }
                        if(DRAuthorization.facility.dischargeDispositionType!=null){
                                Authorization.Discharge_Location = DRAuthorization.facility.dischargeDispositionType.description==null?'':DRAuthorization.facility.dischargeDispositionType.description;
                            }
                        if(DRAuthorization.facility.servicedescUrgencyCode!=null){
                            authFac.Service_Desc = DRAuthorization.facility.servicedescUrgencyCode.description==null?'':DRAuthorization.facility.servicedescUrgencyCode.description;
                        }
                        if(DRAuthorization.facility.facilityDecision!=null){
                            if(DRAuthorization.facility.facilityDecision.decisionOutcomeCode!=null){
                                authFac.Facility_Decision_Outcome = DRAuthorization.facility.facilityDecision.decisionOutcomeCode.description==null?'':DRAuthorization.facility.facilityDecision.decisionOutcomeCode.description;
                            }   
                            if(DRAuthorization.facility.facilityDecision.subTypeCode!=null){
                                authFac.Facility_Decision_Sub_Type = DRAuthorization.facility.facilityDecision.subTypeCode.description==null?'':DRAuthorization.facility.facilityDecision.subTypeCode.description;
                          }
                           if (DRAuthorization.facility.facilityDecision.overrideClaimRemarkCode!=null) {
                                 authFac.Facility_Claim_Remark_Code = ACETProviderUtility.validateConcatenateOfStrings(DRAuthorization.facility.facilityDecision.overrideClaimRemarkCode.code, DRAuthorization.facility.facilityDecision.overrideClaimRemarkCode.description,' - ' );
                         }

                          else if(DRAuthorization.facility.facilityDecision.derivedClaimRemarkCode!=null){
                                 authFac.Facility_Claim_Remark_Code = ACETProviderUtility.validateConcatenateOfStrings(DRAuthorization.facility.facilityDecision.derivedClaimRemarkCode.code, DRAuthorization.facility.facilityDecision.derivedClaimRemarkCode.description,' - ' );
                         }  
                                                      
                            if(DRAuthorization.facility.facilityDecision.gapReviewOutcomeCode!=null){
                                authFac.Facility_Gap_Outcome = DRAuthorization.facility.facilityDecision.gapReviewOutcomeCode.description==null?'':DRAuthorization.facility.facilityDecision.gapReviewOutcomeCode.description;
                            }
                            if(DRAuthorization.facility.facilityDecision.sourceCommentText!=null){
                                authFac.Facility_Decision_Comment = DRAuthorization.facility.facilityDecision.sourceCommentText==null?'':DRAuthorization.facility.facilityDecision.sourceCommentText;
                            }
                            if(DRAuthorization.facility.facilityDecision.decisionReasonCode!=null){
                                authFac.Facility_Decision_Reason = DRAuthorization.facility.facilityDecision.decisionReasonCode.description==null?'':DRAuthorization.facility.facilityDecision.decisionReasonCode.description;
                            }
                            if(DRAuthorization.facility.facilityDecision.renderedDateTime!=null){
                                authFac.Facility_Decision_Rendered_Date = displayDateTimeFormat(DRAuthorization.facility.facilityDecision.renderedDateTime==null?'':DRAuthorization.facility.facilityDecision.renderedDateTime);
                            }
                            if(Authorization.authProviderDetails!=null && !Authorization.authProviderDetails.isEmpty()){
                                for(ACETLGT_AuthorizationDetailResult.authProviderDetail a:Authorization.authProviderDetails){
                                    if(a.Provider_Facility_Role != null && a.Provider_Facility_Role != '') {
                                       if( a.Provider_Facility_Role.containsIgnoreCase('Facility')|| a.Provider_Facility_Role.containsIgnoreCase('Association')){
                                         authFac.Facility_Provider_Status = a.Facility_Service_Provider_Status;
                                        }
                                    }
                                }
                            }
                            Authorization.authFacilityDetails.add(authFac);
                            
                            if(DRAuthorization.facility.facilityDecision.bedDayDecision != null) {
                                Authorization.bedDayDecision = new List<ACETLGT_AuthorizationDetailResult.BedDayDec>();
                                for(ACETLGT_GetAuthorizationJSON2APEX.BedDayDec bedDay:DRAuthorization.facility.facilityDecision.bedDayDecision) {
                                    ACETLGT_AuthorizationDetailResult.BedDayDec bedDec = new ACETLGT_AuthorizationDetailResult.BedDayDec();
                                    if(bedDay.bedDates != null) {
                                        bedDec.bedDatesStart = (bedDay.bedDates.startDate != null)?strDateFormat(bedDay.bedDates.startDate):'';
                                        bedDec.bedDatesStop = (bedDay.bedDates.stopDate!= null)?strDateFormat(bedDay.bedDates.stopDate):'';
                                    }
                                    if(bedDay.bedTypeCode != null) {
                                        bedDec.bedTypeCode= (bedDay.bedTypeCode.code != null)?bedDay.bedTypeCode.code:'';
                                        bedDec.bedTypeDescription = (bedDay.bedTypeCode.description!= null)?bedDay.bedTypeCode.description:'';
                                    }
                                    if(bedDay.revenueCode != null) {
                                        bedDec.revenueCode = (bedDay.revenueCode.code != null)?bedDay.revenueCode.code:'';
                                        bedDec.revenueDescription = (bedDay.revenueCode.description!= null)?bedDay.revenueCode.description:'';
                                    }
                                    if(bedDay.decisionReasonCode != null) {
                                        bedDec.decisionReasonCode = (bedDay.decisionReasonCode.code != null)?bedDay.decisionReasonCode.code:'';
                                        bedDec.decisionReasonDescription = (bedDay.decisionReasonCode.description!= null)?bedDay.decisionReasonCode.description:'';
                                    }
                                    if(bedDay.overrideClaimRemarkCode!= null) {
                                        bedDec.systemClaimRemarkCode = (bedDay.overrideClaimRemarkCode.code != null)?bedDay.overrideClaimRemarkCode.code:'';
                                        bedDec.systemClaimRemarkDescription = (bedDay.overrideClaimRemarkCode.description!= null)?bedDay.overrideClaimRemarkCode.description:'';
                                    }
                                    else if(bedDay.systemClaimRemarkCode != null) {
                                        bedDec.systemClaimRemarkCode = (bedDay.systemClaimRemarkCode.code != null)?bedDay.systemClaimRemarkCode.code:'';
                                        bedDec.systemClaimRemarkDescription = (bedDay.systemClaimRemarkCode.description!= null)?bedDay.systemClaimRemarkCode.description:'';
                                    }
                                    if(bedDay.decisionOutcomeCode != null) {
                                        bedDec.decisionOutcomeCode = (bedDay.decisionOutcomeCode.code != null)?bedDay.decisionOutcomeCode.code:'';
                                        bedDec.decisionOutcomeDescription = (bedDay.decisionOutcomeCode.description!= null)?bedDay.decisionOutcomeCode.description:'';
                                    }
                                    bedDec.decisionUpdateDateTime = (bedDay.decisionUpdateDateTime != null)?displayDateTimeFormat(bedDay.decisionUpdateDateTime):'';

                                    Authorization.bedDayDecision.add(bedDec);
                                }
                            }
                            system.debug('###Inside facility Decision'+DRAuthorization.facility.facilityDecision);
                            
                        }
                    }
                    
                    /*if(Authorization.authProviderDetails!=null && !Authorization.authProviderDetails.isEmpty()){
                        for(ACETLGT_AuthorizationDetailResult.authProviderDetail a:Authorization.authProviderDetails){
                            if(a.Provider_Facility_Role != null && a.Provider_Facility_Role != '') {
                               if( a.Provider_Facility_Role.containsIgnoreCase('Facility')|| a.Provider_Facility_Role.containsIgnoreCase('Association')){
                                 Authorization.Facility_Provider_Status = a.Facility_Service_Provider_Status;
                            }
                        }
                    }
                }*/
                    
                    // Service Line Mapping :  Services
                    // Common for IP, OP and OPS
                    if(DRAuthorization.services!=null && !DRAuthorization.services.isEmpty()){
                        Authorization.authServiceDetails = new list<ACETLGT_AuthorizationDetailResult.authServiceDetail>();
                        for(ACETLGT_GetAuthorizationJSON2APEX.Services authServ: DRAuthorization.services){
                            ACETLGT_AuthorizationDetailResult.authServiceDetail aSD = new ACETLGT_AuthorizationDetailResult.authServiceDetail();
                            
                            aSD.Service_Authorization_Number = authServ.serviceReferenceNumber==null?'':authServ.serviceReferenceNumber;   
                            if(DRAuthorization.providers!=null && !DRAuthorization.providers.isEmpty())
                            for(ACETLGT_GetAuthorizationJSON2APEX.providers a:DRAuthorization.providers ){  
                                if(a.seqNum==authServ.providerSeqNumber){
                                    if(a.lastName!=null || a.middleName!=null || a.firstName!=null ){
                                        aSD.Service_Provider_Status = ((a.lastName==null?'':a.lastName)+(a.middleName==null?'':','+a.middleName)+(a.firstName==null?'':+','+a.firstName));
                                    } 
                                    else{
                                        aSD.Service_Provider_Status = a.organizationName==null?'':a.organizationName; 
                                    }
                                    if(aSD.Service_Provider_Status==null || aSD.Service_Provider_Status=='')
                                    aSD.Service_Provider_Status='NA';
                                    aSD.Service_Provider_Status +='/';  
                                    if(a.networkStatusType!=null){
                                        aSD.Service_Provider_Status += a.networkStatusType.description==null?'NA':a.networkStatusType.description;                                                
                                    }
                                }
                            }
                            if(authServ.procedureCode!=null){
                                aSD.Procedure_Code = authServ.procedureCode.code==null?'':authServ.procedureCode.code;
                                aSD.Procedure_Description = authServ.procedureCode.codeDesc==null?'':authServ.procedureCode.codeDesc;
                            }
                            if(authServ.serviceFacility!=null){
                                if(authServ.serviceFacility.expectedProcedureDate!=null){
                                    aSD.Expected_Procedure_Date = authServ.serviceFacility.expectedProcedureDate==null?'':ACETUtility.format(Date.valueOf(authServ.serviceFacility.expectedProcedureDate));
                                }
                                if(authServ.serviceFacility.actualProcedureDate!=null){
                                    aSD.Actual_Procedure_Date = authServ.serviceFacility.actualProcedureDate==null?'':ACETUtility.format(Date.valueOf(authServ.serviceFacility.actualProcedureDate));
                                }
                            }
                            if(authServ.serviceNonFacility !=null){
                                if(authServ.serviceNonFacility.serviceEffDates!=null){
                                    aSD.Service_StartDate = strDateFormat(authServ.serviceNonFacility.serviceEffDates.startDate==null?'':authServ.serviceNonFacility.serviceEffDates.startDate);
                                    aSD.Service_StopDate = strDateFormat(authServ.serviceNonFacility.serviceEffDates.stopDate==null?'':authServ.serviceNonFacility.serviceEffDates.stopDate);
                                }
                            }
                                                       
                            if(authServ.serviceDecision!=null){
                                if(authServ.serviceDecision.decisionOutcomeCode!=null){
                                    aSD.Service_Decision_Outcome = authServ.serviceDecision.decisionOutcomeCode.description==null?'':authServ.serviceDecision.decisionOutcomeCode.description;
                                }
                                if(authServ.serviceDecision.decisionSubTypeCode!=null){
                                    aSD.Service_Decision_Sub_Type = authServ.serviceDecision.decisionSubTypeCode.description==null?'':authServ.serviceDecision.decisionSubTypeCode.description;
                                }
                                if(authServ.serviceDecision.overrideClaimRemarkCode!=null){
                                    aSD.Service_Claim_Remark_Code = ACETProviderUtility.validateConcatenateOfStrings (authServ.serviceDecision.overrideClaimRemarkCode.code , authServ.serviceDecision.overrideClaimRemarkCode.description, ' - ' );
                                }
                                else if(authServ.serviceDecision.derivedClaimRemarkCode!=null){
                                    aSD.Service_Claim_Remark_Code = ACETProviderUtility.validateConcatenateOfStrings (authServ.serviceDecision.derivedClaimRemarkCode.code , authServ.serviceDecision.derivedClaimRemarkCode.description, ' - ' );
                                }
                                aSD.Service_Gap_Outcome ='';
                                if(authServ.serviceDecision.gapReviewOutcomeCode!=null){
                                    aSD.Service_Gap_Outcome = authServ.serviceDecision.gapReviewOutcomeCode.description==null?'':authServ.serviceDecision.gapReviewOutcomeCode.description;
                                }
                                if(authServ.serviceDecision.decisionReasonCode!=null){
                                    aSD.Service_Decision_Reason = authServ.serviceDecision.decisionReasonCode.description==null?'':authServ.serviceDecision.decisionReasonCode.description;
                                }
                                if(authServ.serviceDecision.decisionRenderedDatetime!=null){
                                    aSD.Service_Decision_Rendered_Date = convertToDateFormat(authServ.serviceDecision.decisionRenderedDatetime==null?'':authServ.serviceDecision.decisionRenderedDatetime);
                                }
                                if(authServ.serviceDecision.claimNoteText!=null){
                                    aSD.Service_Decision_Comment = authServ.serviceDecision.claimNoteText==null?'':authServ.serviceDecision.claimNoteText;
                                }
                            }
                            if(authServ.procedureOtherText!=null){
                                aSD.Proc_Text = authServ.procedureOtherText==null?'':authServ.procedureOtherText;
                            }
                            system.debug('***Done');
                            Authorization.authServiceDetails.add(aSD); 
                        }
                    }
                    
                    //Diagnosis Mapping
                    //Common for IP, OP and OPS
                    if(DRAuthorization.diagnosis !=null && !DRAuthorization.diagnosis.isEmpty()){
                        Authorization.diagnosisList = new list<ACETLGT_AuthorizationDetailResult.diagnosis>();
                        for(ACETLGT_GetAuthorizationJSON2APEX.Diagnosis authDiag: DRAuthorization.diagnosis ){
                            
                            if(authDiag.diagnosisCode!=null){
                                ACETLGT_AuthorizationDetailResult.diagnosis diag  = new ACETLGT_AuthorizationDetailResult.diagnosis();
                                diag.Dx_Code = authDiag.diagnosisCode.code==null?'':authDiag.diagnosisCode.code;
                                diag.Dx_Description = authDiag.diagnosisCode.codeDesc ==null?'':authDiag.diagnosisCode.codeDesc ;
                                Authorization.diagnosisList.add(diag);
                            }
                        }
                    }
                    
                    //Notes mapping
                    //Common for IP, OP and OPS
                    if(DRAuthorization.notes!=null && !DRAuthorization.notes.isEmpty()){
                        Authorization.notesList = new list<ACETLGT_AuthorizationDetailResult.notes>();
                        for(ACETLGT_GetAuthorizationJSON2APEX.notes authNote: DRAuthorization.notes){
                            ACETLGT_AuthorizationDetailResult.notes nte  = new ACETLGT_AuthorizationDetailResult.notes();
                                nte.Created_By = authNote.createdByUserid==null?'':authNote.createdByUserid;
                            if(authNote.categoryCode !=null){
                                nte.Note_Type = '';
                                nte.Subject_Type = authNote.categoryCode.description==null?'':authNote.categoryCode.description;
                            }
                                nte.Note_details = authNote.text ==null?'':authNote.text;
                            if(authNote.createDateTime!=null){
                                nte.Create_Date = displayDateTimeFormat(String.isBlank(authNote.createDateTime)?'':authNote.createDateTime);
                            }
                            nte.Department='';
                            Authorization.notesList.add(nte);
                        }
                    }
                    
                    //Follow Up Contact Mapping
                    //Common for IP, OP and OPS
                    if(DRAuthorization.authFollowUpContact !=null){
                        if(DRAuthorization.authFollowupContact.contactFullName !=null){
                            Authorization.Name= DRAuthorization.authFollowupContact.contactFullName ==null?'':DRAuthorization.authFollowupContact.contactFullName ;
                        }
                        //system.debug('***partner'+DRAuthorization.authFollowupContact.communicationContactRoleCode.description);
                        if(DRAuthorization.authFollowupContact.communicationContactRoleCode!=null){
                            Authorization.Role = DRAuthorization.authFollowupContact.communicationContactRoleCode.description==null?'':DRAuthorization.authFollowupContact.communicationContactRoleCode.description;
                        }
                        system.debug('*** partner after'+Authorization.Role );
                        
                        //system.debug('***dept'+DRAuthorization.authFollowupContact.departmentTypeCode.description);
                        
                        if(DRAuthorization.authFollowupContact.departmentTypeCode!=null){
                            Authorization.Contact_Department = DRAuthorization.authFollowupContact.departmentTypeCode.description==null?'':DRAuthorization.authFollowupContact.departmentTypeCode.description;
                        }
                        system.debug('*** dept after'+Authorization.Contact_Department );
                        
                        if(DRAuthorization.authFollowupContact.emailAddressText!=null){
                            Authorization.Email_Address = DRAuthorization.authFollowupContact.emailAddressText==null?'':DRAuthorization.authFollowupContact.emailAddressText;
                        }
                        Authorization.Medical_Record_Number = DRAuthorization.authFollowupContact.medicalRecordNumber ==null?'':DRAuthorization.authFollowupContact.medicalRecordNumber;
                        
                        if(DRAuthorization.authFollowupContact.phoneNumber!=null && !DRAuthorization.authFollowupContact.phoneNumber.isEmpty()){
                            For(ACETLGT_GetAuthorizationJSON2APEX.PhoneNumber phn: DRAuthorization.authFollowupContact.phoneNumber){
                                if(phn.phoneTypeCode!=null && phn.phoneTypeCode=='14'){
                                    Authorization.Primary_Phone = phn.telephoneNumber;
                                } 
                                if(phn.phoneTypeCode!=null && phn.phoneTypeCode=='3'){
                                    Authorization.Fax = phn.telephoneNumber;
                                }
                            }
                        }
                    }
                    
                    system.debug('***AuthorizationDetail:' + Authorization);
                   
                }
           if (Authorization!=null){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Authorization;
            }
                else{
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = 'No Record found for this Authorization';
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO; 
            } 
                         
        } else {
            oACETWSCalloutResult.statusCode = (response != null) ? response.getStatusCode() : null;
            oACETWSCalloutResult.Success = false;
                }

        }
               catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in GetAuthorizationDetail. Details: ' + ex); 
            system.debug('getStackTraceString' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode = 999;
        } 
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}