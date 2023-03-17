public class ACETSNIWorkOrderDetails {
    @AuraEnabled
    public static ACETSNIWorkOrderDetailsWrapper getAuthorizeDetails(string recid){ 
        ACETSNIWorkOrderDetailsWrapper workOrdDetail = new ACETSNIWorkOrderDetailsWrapper();
        
        if(string.isNotBlank(recid)){
            WorkOrder wo =[select Id,HSC_Unique_ID__c,Xref_ID__c,Host_System_Date_and_Time__c,Notification_Date__c from WorkOrder where Id=:recid];
            if(wo!=Null && wo.HSC_Unique_ID__c!=Null && wo.Xref_ID__c!=Null){
                ACET_GetAuthorizationStatusDetails.AuthDetailsRequest requestObject = new ACET_GetAuthorizationStatusDetails.AuthDetailsRequest();
                requestObject.AUTH_ID = wo.HSC_Unique_ID__c;
                requestObject.XREF_ID = wo.Xref_ID__c;
                system.debug('--------requestObject-------'+requestObject);
                ACET_AuthorizationController.SearchResultWrapperAuthStatus wrapper = ACET_AuthorizationController.getAuthorizationStatus(requestObject);
                if(wrapper!=Null && wrapper.statusCode==200){
                    Map<String,string> roleMap = new Map<String,string>{
                        'AD' => 'Admitting Services',
                            'AT' => 'Attending Physician',
                            'FA' => 'Facility',
                            'PC' => 'Primary Care Provider',
                            'RF' => 'Requesting Provider',
                            'AT' => 'Attending Physician',
                            'SJ' => 'Servicing',
                            'SO' => 'Surgical Opinion'};
                                
                                Map<string,string> provMap = new Map<string,string>();
                    Map<string,ACETSNIWorkOrderDetailsWrapper.ServiceEffDates> servMap = new Map<string,ACETSNIWorkOrderDetailsWrapper.ServiceEffDates>();
                    ACET_AuthorizationStatusResponse authresp = wrapper.resultWrapper;
                    
                    
                    
                    ACET_AuthorizationStatusResponse.Facility facility = new ACET_AuthorizationStatusResponse.Facility();
                    List<ACET_AuthorizationStatusResponse.Providers> providlst = new List<ACET_AuthorizationStatusResponse.Providers>();
                    List<ACET_AuthorizationStatusResponse.Services> servlst= new List<ACET_AuthorizationStatusResponse.Services>(); 
                    List<ACET_AuthorizationStatusResponse.Notes> Noteslst= new List<ACET_AuthorizationStatusResponse.Notes>(); 
                    List<ACET_AuthorizationStatusResponse.assignments> assignmentlst= new List<ACET_AuthorizationStatusResponse.assignments>(); 
                    if(authresp!=Null){
                        if(authresp.AuthDetailsResponse!=Null){
                            if(authresp.AuthDetailsResponse.facility!=Null){
                                facility = authresp.AuthDetailsResponse.facility;
                            }
                            if(authresp.AuthDetailsResponse.Providers!=Null){
                                providlst= authresp.AuthDetailsResponse.Providers;
                            }
                            if(authresp.AuthDetailsResponse.services!=Null){
                                servlst= authresp.AuthDetailsResponse.services;
                            }
                            if(authresp.AuthDetailsResponse.serviceSettingTypeCode!=Null){
                                workOrdDetail.patientType = (authresp.AuthDetailsResponse.serviceSettingTypeCode.description!=Null)?authresp.AuthDetailsResponse.serviceSettingTypeCode.description:'';
                            }
                            if(authresp.AuthDetailsResponse.notes!=Null){
                                Noteslst = authresp.AuthDetailsResponse.notes;
                            }
                            if(authresp.AuthDetailsResponse.assignments!=Null){
                                assignmentlst = authresp.AuthDetailsResponse.assignments;
                            }
                            workOrdDetail.priorAuthOwner = authresp.AuthDetailsResponse.caseOwner;
                            workOrdDetail.hostSysDatTime = wo.Host_System_Date_and_Time__c;
                            if(authresp.AuthDetailsResponse.statusCode != null && authresp.AuthDetailsResponse.statusCode.description != null && authresp.AuthDetailsResponse.statusCode.description != '' && authresp.AuthDetailsResponse.statusCode.description == 'Cancelled'){
                                if(authresp.AuthDetailsResponse.statusReasonCode != null && authresp.AuthDetailsResponse.statusReasonCode.description != null && authresp.AuthDetailsResponse.statusReasonCode.description != ''){
                                   workOrdDetail.canceledReason = authresp.AuthDetailsResponse.statusReasonCode.description;
                                }
                            }
                        }
                    }  
                    system.debug('--------facility----------'+facility);                    
                    List<ACETSNIWorkOrderDetailsWrapper.ProviderDetail> wrapProvlst= new List<ACETSNIWorkOrderDetailsWrapper.ProviderDetail>();
                    List<ACETSNIWorkOrderDetailsWrapper.serviceLineDetail> wrapServicelst= new List<ACETSNIWorkOrderDetailsWrapper.serviceLineDetail>();
                    ACETSNIWorkOrderDetailsWrapper.FacilityDetail wrapfacility= new ACETSNIWorkOrderDetailsWrapper.FacilityDetail();
                    List<ACETSNIWorkOrderDetailsWrapper.NotesDetail> wrapNoteslst= new List<ACETSNIWorkOrderDetailsWrapper.NotesDetail>();
                    //Providers logic start
                    if(providlst!=Null && providlst.size()>0){
                        for(ACET_AuthorizationStatusResponse.Providers prov : providlst){
                            ACETSNIWorkOrderDetailsWrapper.ProviderDetail wrapProv = new ACETSNIWorkOrderDetailsWrapper.ProviderDetail();
                            wrapProv.status = (prov.networkStatusType!=Null && prov.networkStatusType.description!= Null && prov.networkStatusType.description!= '')?prov.networkStatusType.description:'';
                            if(prov.categoryCode!=Null && prov.categoryCode=='P'){
                                string pname='';
                                pname = pname + ((prov.firstName!= Null && prov.firstName!= '')?prov.firstName:'');
                                pname = pname + ((prov.middleName!= Null && prov.middleName!= '')?+' '+prov.middleName:'');
                                pname = pname + ((prov.lastName!= Null && prov.lastName!= '')?+' '+prov.lastName:'');
                                pname = pname + ((prov.suffixCode!= Null && prov.suffixCode!= '')?+' '+prov.suffixCode:'');
                                wrapProv.name =  (((pname !=Null && pname != '')? pname :'--') +'/'+ ((wrapProv.status != Null && wrapProv.status != '')?wrapProv.status:'--'));
                            }else{
                                wrapProv.name = (((prov.organizationName !=Null && prov.organizationName != '')? prov.organizationName :'--') +'/'+ ((wrapProv.status != Null && wrapProv.status != '')?wrapProv.status:'--'));
                            }
                            if(prov.categoryCode!=Null && prov.categoryCode=='H'){
                                workOrdDetail.facilityProvName = wrapProv.name;
                            }
                            string taxid='';
                            List<ACET_AuthorizationStatusResponse.EnrolleIdentifiers> provEnrol= prov.providerIdentifiers;
                            if(provEnrol!=Null && provEnrol.size()>0){
                                for(ACET_AuthorizationStatusResponse.EnrolleIdentifiers provenId : provEnrol){
                                    if(string.isNotBlank(provenId.typeCodeDesc) && provenId.typeCodeDesc=='Federal Tax ID'){
                                        taxid = provenId.id;
                                        break;
                                    }
                                }
                            }
                            wrapProv.tin = taxid;
                            string address='';
                            address = address + ((prov.address!=Null && prov.address.addressLine1!= Null && prov.address.addressLine1!= '')?prov.address.addressLine1:'');
                            address = address +', '+((prov.address!=Null && prov.address.city!= Null && prov.address.city!= '')?prov.address.city:'');
                            address = address +', '+ ((prov.address!=Null && prov.address.state!= Null && prov.address.state.code!= Null && prov.address.state.code!= '')?prov.address.state.code:'');
                            address = address +', '+ ((prov.address!=Null && prov.address.postalCode1!= Null && prov.address.postalCode1!= '')?prov.address.postalCode1:'');
                            wrapProv.address = address;
                            wrapProv.phoneNumber = (prov.primaryPhone!= Null && prov.primaryPhone!= '')?prov.primaryPhone:'';
			    wrapProv.faxNumber = (prov.faxNumber!= Null && prov.faxNumber!= '')?prov.faxNumber:'';		
                            List<string> provSpeclst = new List<string>();
                            List<ACET_AuthorizationStatusResponse.SpecialtyType> provSpec = prov.specialtyType;
                            if(provSpec!=Null && provSpec.size()>0){
                                for(ACET_AuthorizationStatusResponse.SpecialtyType spectyp : provSpec){
                                    if(string.isNotBlank(spectyp.desc_x)){
                                        provSpeclst.add(spectyp.desc_x);
                                    }
                                }
                            }
                            if(provSpeclst!=Null && provSpeclst.size()>0){
                                String separator = ', ';
                                wrapProv.speciality = String.join(provSpeclst, separator);
                            }else{
                                wrapProv.speciality='';
                            }
                            List<string> rolelst = new List<string>();
                            List<ACET_AuthorizationStatusResponse.Role> provRole = prov.role;
                            if(provRole!=Null && provRole.size()>0){
                                for(ACET_AuthorizationStatusResponse.Role roletyp : provRole){
                                    if(string.isNotBlank(roletyp.id)){
                                        string sr = roleMap.containsKey(roletyp.id)?roleMap.get(roletyp.id):'';
                                        if(string.isNotBlank(sr)){
                                            rolelst.add(sr);
                                        }
                                    }
                                }
                            }
                            if(rolelst!=Null && rolelst.size()>0){
                                String separator = ', ';
                                wrapProv.role = String.join(rolelst, separator);
                            }else{
                                wrapProv.role='';
                            }
                            
                            wrapProvlst.add(wrapProv);
                            if(string.isNotBlank(prov.seqNum)){
                                provMap.put(prov.seqNum,wrapProv.name); 
                            }
                            
                        } 
                    }
                    //Service Line Logic start
                    if(servlst!=Null && servlst.size()>0){
                        for(ACET_AuthorizationStatusResponse.Services serv : servlst){
                            ACETSNIWorkOrderDetailsWrapper.serviceLineDetail wrapService = new ACETSNIWorkOrderDetailsWrapper.serviceLineDetail();
                            wrapService.serviceRef = (serv.serviceReferenceNumber!= Null && serv.serviceReferenceNumber!= '')?serv.serviceReferenceNumber:'';
                            wrapService.serviceDesc = (facility!=Null && facility.serviceDescUrgencyCode!= Null && facility.serviceDescUrgencyCode.description!= Null && facility.serviceDescUrgencyCode.description!= '')?facility.serviceDescUrgencyCode.description:'';
                            wrapService.procedureCode = serv.procedureCode !=Null ?(((serv.procedureCode.code !=Null && serv.procedureCode.code != '')? serv.procedureCode.code :'--') +'/'+ ((serv.procedureCode.codeDesc != Null && serv.procedureCode.codeDesc != '')?serv.procedureCode.codeDesc:'--')):'--/--';
                            wrapService.procedureType = (serv.procedureCode!=Null && serv.procedureCode.typeCodeDesc!= Null && serv.procedureCode.typeCodeDesc!= '')?serv.procedureCode.typeCodeDesc:'';
                            wrapService.procedureTotCount = (serv.serviceNonFacility!=Null && serv.serviceNonFacility.procedureUnitCount!= Null && serv.serviceNonFacility.procedureUnitCount!= '')?serv.serviceNonFacility.procedureUnitCount:'';
                            wrapService.procedureFreqCount = (serv.serviceNonFacility!=Null && serv.serviceNonFacility.unitPerFrequencyCount!= Null && serv.serviceNonFacility.unitPerFrequencyCount!= '')?serv.serviceNonFacility.unitPerFrequencyCount:'';
                            wrapService.procedUnitOfMeasure = (serv.serviceNonFacility!=Null && serv.serviceNonFacility.procedureUnitOfMeasureCode.description!= Null && serv.serviceNonFacility.procedureUnitOfMeasureCode.description!= '')?serv.serviceNonFacility.procedureUnitOfMeasureCode.description:'';
                            wrapService.procedFreqCode = (serv.serviceNonFacility!=Null && serv.serviceNonFacility.procedureFrequencyCode.description!= Null && serv.serviceNonFacility.procedureFrequencyCode.description!= '')?serv.serviceNonFacility.procedureFrequencyCode.description:'';
                            wrapService.decisionOutcome = (serv.serviceDecision!=Null && serv.serviceDecision.decisionOutcomeCode!=Null && serv.serviceDecision.decisionOutcomeCode.description!= Null && serv.serviceDecision.decisionOutcomeCode.description!= '')?serv.serviceDecision.decisionOutcomeCode.description:'';
                            wrapService.decisionSubType = (serv.serviceDecision!=Null && serv.serviceDecision.decisionSubTypeCode!=Null && serv.serviceDecision.decisionSubTypeCode.description!= Null && serv.serviceDecision.decisionSubTypeCode.description!= '')?serv.serviceDecision.decisionSubTypeCode.description:'';
                            wrapService.renderedDate = (serv.serviceDecision!=Null && serv.serviceDecision.decisionRenderedDatetime!= Null && serv.serviceDecision.decisionRenderedDatetime!= '')?formatDateMMDDYYYY(serv.serviceDecision.decisionRenderedDatetime):'';
                            wrapService.decisionReason = (serv.serviceDecision!=Null && serv.serviceDecision.decisionReasonCode!=Null && serv.serviceDecision.decisionReasonCode.description!= Null && serv.serviceDecision.decisionReasonCode.description!= '')?serv.serviceDecision.decisionReasonCode.description:'';
                            // wrapService.decisionUserPosition = (serv.serviceDecision!=Null && serv.serviceDecision.decisionMadeByUserPosition!= Null && serv.serviceDecision.decisionMadeByUserPosition!= '')?serv.serviceDecision.decisionMadeByUserPosition:'';
                            List<String> mdLst = new List<String>();
                            for(ACET_AuthorizationStatusResponse.Assignments assignmnt : assignmentlst){
                                if(assignmnt.assignmentType != null && assignmnt.assignmentType.code != null && assignmnt.assignmentType.code == '11' ){
                                    mdLst.add((assignmnt.assignedTo != null ? assignmnt.assignedTo : '')+'@'+assignmnt.assignmentDateAndTime); //List of assignments with assigned and date and time to compare the recent ones
                                }
                            }
                            if(mdLst.Size()>0){
                                String assignedDateTime = mdLst[0].split('@') != null?mdLst[0].split('@')[1]:'';
                                //Datetime format 2020-12-21T17:30:38Z convert to datetime format to compare
                                String formatedTime = assignedDateTime != '' ? assignedDateTime.split('T')[0]+' '+(assignedDateTime.split('T')[1] != null ? assignedDateTime.split('T')[1].split('Z')[0] : '') : '';
                                DateTime maxValue = DateTime.valueOf(formatedTime) ;
                                String assignedMD = mdLst[0].split('@')[0];
                                for(String s : mdLst){   
                                    assignedDateTime = s.split('@') !=null ? s.split('@')[1] : '';
                                    //Datetime format 2020-12-21T17:30:38Z convert to datetime format to compare
                                    formatedTime = assignedDateTime != '' ? assignedDateTime.split('T')[0]+' '+(assignedDateTime.split('T')[1] != null ? assignedDateTime.split('T')[1].split('Z')[0] : '') :'';
                                    DateTime formattedDateTime = DateTime.valueOf(formatedTime) ;
                                    if(formattedDateTime > maxValue){
                                        maxValue = formattedDateTime;
                                        assignedMD = s.split('@') !=null ? s.split('@')[0] : '';
                                    }
                                }
                                system.debug('assignedMD='+assignedMD);
                                wrapService.decisionUserPosition = assignedMD ;
                            }
                            else 
                                wrapService.decisionUserPosition = '';
                            //if(string.isNotBlank(wrapService.decisionUserPosition) && wrapService.decisionUserPosition.containsIgnoreCase('Medical Director')){
                            wrapService.decisionBy = (serv.serviceDecision!=Null && serv.serviceDecision.decisionMadeByUserId!= Null && serv.serviceDecision.decisionMadeByUserId!= '')?serv.serviceDecision.decisionMadeByUserId:'';
                            // }else{
                            //    wrapService.decisionBy ='';
                            // }
                            wrapService.derivedClaimRemarkCode = (serv.serviceDecision!=Null && serv.serviceDecision.derivedClaimRemarkCode!=Null) ?(((serv.serviceDecision.derivedClaimRemarkCode.code !=Null && serv.serviceDecision.derivedClaimRemarkCode.code != '')? serv.serviceDecision.derivedClaimRemarkCode.code :'--') +'/'+ ((serv.serviceDecision.derivedClaimRemarkCode.description != Null && serv.serviceDecision.derivedClaimRemarkCode.description != '')?serv.serviceDecision.derivedClaimRemarkCode.description:'--')):'--/--';
                            
                            wrapService.overrideClaimRemarkCode = (serv.serviceDecision!=Null && serv.serviceDecision.overrideClaimRemarkCode!=Null) ?(((serv.serviceDecision.overrideClaimRemarkCode.code !=Null && serv.serviceDecision.overrideClaimRemarkCode.code != '')? serv.serviceDecision.overrideClaimRemarkCode.code :'--') +'/'+ ((serv.serviceDecision.overrideClaimRemarkCode.description != Null && serv.serviceDecision.overrideClaimRemarkCode.description != '')?serv.serviceDecision.overrideClaimRemarkCode.description:'--')):'--/--';
                            wrapService.gapreviewoutcome  = ((serv.serviceDecision!= Null && serv.serviceDecision.gapReviewOutcomeCode!=Null && serv.serviceDecision.gapReviewOutcomeCode.description!=Null && serv.serviceDecision.gapReviewOutcomeCode.description!='')?serv.serviceDecision.gapReviewOutcomeCode.description:'');    
                            if(string.isNotBlank(serv.providerSeqNumber)){
                                wrapService.providerNameStatus = provMap.containsKey(serv.providerSeqNumber)?provMap.get(serv.providerSeqNumber):''; 
                            } 
                            if(string.isNotBlank(workOrdDetail.patientType) && workOrdDetail.patientType=='Inpatient'){
                                wrapService.procedureTotCount='';
                                wrapService.procedureFreqCount='';
                                wrapService.procedUnitOfMeasure='';
                                wrapService.procedFreqCode='';
                                //wrapService.gapreviewoutcome  = ((facility!=Null && facility.facilityDecision!= Null && facility.facilityDecision.gapReviewOutcomeCode!=Null && facility.facilityDecision.gapReviewOutcomeCode.description!=Null && facility.facilityDecision.gapReviewOutcomeCode.description!='')?facility.facilityDecision.gapReviewOutcomeCode.description:'');
                                
                                wrapService.advanceNotifiTime = ((facility!=Null && facility.advanceNotificationTimestamp!= Null && facility.advanceNotificationTimestamp!= '')?facility.advanceNotificationTimestamp:'');
                                	wrapService.serviceStartDate=(serv.serviceFacility!=Null && serv.serviceFacility.expectedProcedureDate!= Null && serv.serviceFacility.expectedProcedureDate!= '')?formatDateMMDDYYYY(serv.serviceFacility.expectedProcedureDate):'';
                                    wrapService.serviceEndDate =(serv.serviceFacility!=Null && serv.serviceFacility.actualProcedureDate!= Null && serv.serviceFacility.actualProcedureDate!= '')?formatDateMMDDYYYY(serv.serviceFacility.actualProcedureDate):'';                                   
                            }else if(string.isNotBlank(workOrdDetail.patientType) && workOrdDetail.patientType=='Outpatient'){
                                //wrapService.gapreviewoutcome  = ((serv.serviceDecision!= Null && serv.serviceDecision.gapReviewOutcomeCode!=Null && serv.serviceDecision.gapReviewOutcomeCode.description!=Null && serv.serviceDecision.gapReviewOutcomeCode.description!='')?serv.serviceDecision.gapReviewOutcomeCode.description:'');
                                
                                wrapService.advanceNotifiTime = ((serv.serviceNonFacility!=Null && serv.serviceNonFacility.advanceNotificationTimestamp!= Null && serv.serviceNonFacility.advanceNotificationTimestamp!= '')?serv.serviceNonFacility.advanceNotificationTimestamp:'');
                                wrapService.serviceDesc = (serv.serviceNonFacility!=Null && serv.serviceNonFacility.serviceDescUrgencyCode!= Null && serv.serviceNonFacility.serviceDescUrgencyCode.description!= Null && serv.serviceNonFacility.serviceDescUrgencyCode.description!= '')?serv.serviceNonFacility.serviceDescUrgencyCode.description:'';
                                    wrapService.serviceStartDate = (serv.serviceNonFacility!=Null && serv.serviceNonFacility.serviceEffDates!=Null && serv.serviceNonFacility.serviceEffDates.startDate!= Null && serv.serviceNonFacility.serviceEffDates.startDate!= '')?formatDateMMDDYYYY(serv.serviceNonFacility.serviceEffDates.startDate):'';
                           			wrapService.serviceEndDate = (serv.serviceNonFacility!=Null && serv.serviceNonFacility.serviceEffDates!=Null && serv.serviceNonFacility.serviceEffDates.stopDate!= Null && serv.serviceNonFacility.serviceEffDates.stopDate!= '')?formatDateMMDDYYYY(serv.serviceNonFacility.serviceEffDates.stopDate):'';
                                    /*ACETSNIWorkOrderDetailsWrapper.ServiceEffDates servdates = new ACETSNIWorkOrderDetailsWrapper.ServiceEffDates();
                                    servdates.startDate=(serv.serviceNonFacility!=Null && serv.serviceNonFacility.serviceEffDates!=Null && serv.serviceNonFacility.serviceEffDates.startDate!= Null && serv.serviceNonFacility.serviceEffDates.startDate!= '')?serv.serviceNonFacility.serviceEffDates.startDate:'';
                                    servdates.stopDate =(serv.serviceNonFacility!=Null && serv.serviceNonFacility.serviceEffDates!=Null && serv.serviceNonFacility.serviceEffDates.stopDate!= Null && serv.serviceNonFacility.serviceEffDates.stopDate!= '')?serv.serviceNonFacility.serviceEffDates.stopDate:'';   
                                    if(string.isNotBlank(wrapService.serviceRef)){
                                        servMap.put(wrapService.serviceRef,servdates);
                                    }*/
                                
                            }else if(string.isNotBlank(workOrdDetail.patientType) && workOrdDetail.patientType=='Outpatient Facility'){
                                //wrapService.gapreviewoutcome  = ((facility!=Null && facility.facilityDecision!= Null && facility.facilityDecision.gapReviewOutcomeCode!=Null && facility.facilityDecision.gapReviewOutcomeCode.description!=Null && facility.facilityDecision.gapReviewOutcomeCode.description!='')?facility.facilityDecision.gapReviewOutcomeCode.description:'');
                                
                                wrapService.advanceNotifiTime = ((facility!=Null && facility.advanceNotificationTimestamp!= Null && facility.advanceNotificationTimestamp!= '')?facility.advanceNotificationTimestamp:'');
                                    wrapService.serviceStartDate=(serv.serviceFacility!=Null && serv.serviceFacility.expectedProcedureDate!= Null && serv.serviceFacility.expectedProcedureDate!= '')?formatDateMMDDYYYY(serv.serviceFacility.expectedProcedureDate):'';
                                    wrapService.serviceEndDate =(serv.serviceFacility!=Null && serv.serviceFacility.actualProcedureDate!= Null && serv.serviceFacility.actualProcedureDate!= '')?formatDateMMDDYYYY(serv.serviceFacility.actualProcedureDate):'';   
                                    /*ACETSNIWorkOrderDetailsWrapper.ServiceEffDates servdates = new ACETSNIWorkOrderDetailsWrapper.ServiceEffDates();
                                    servdates.startDate=(serv.serviceFacility!=Null && serv.serviceFacility.expectedProcedureDate!= Null && serv.serviceFacility.expectedProcedureDate!= '')?serv.serviceFacility.expectedProcedureDate:'';
                                    servdates.stopDate =(serv.serviceFacility!=Null && serv.serviceFacility.actualProcedureDate!= Null && serv.serviceFacility.actualProcedureDate!= '')?serv.serviceFacility.actualProcedureDate:'';   
                                    
                                    if(string.isNotBlank(wrapService.serviceRef)){
                                        servMap.put(wrapService.serviceRef,servdates);
                                    }*/
                            }
                            wrapServicelst.add(wrapService);
                        }
                    }
                    //Facility Details
                    if(facility!=Null){
                        if(workOrdDetail.patientType!=Null && workOrdDetail.patientType !='' && workOrdDetail.patientType!='Outpatient'){
                            wrapfacility.nameStatus = (workOrdDetail.facilityProvName!= Null && workOrdDetail.facilityProvName!= '')?workOrdDetail.facilityProvName:'';
                        }
                        wrapfacility.expectedAdmissionDischargeDate = ((facility.expectedAdmissionDate!= Null && facility.expectedAdmissionDate!= '')?formatDateMMDDYYYY(facility.expectedAdmissionDate):'')+' - '+((facility.expectedDischargeDate!= Null && facility.expectedDischargeDate!= '')?formatDateMMDDYYYY(facility.expectedDischargeDate):'');
                        wrapfacility.actualAdmissionDischargeDates = ((facility.actualAdmissionDateTime!= Null && facility.actualAdmissionDateTime!= '')?formatDateMMDDYYYY(facility.actualAdmissionDateTime):'')+' - '+((facility.actualDischargeDateTime!= Null && facility.actualDischargeDateTime!= '')?formatDateMMDDYYYY(facility.actualDischargeDateTime):'');
                        wrapfacility.placeOfService = (facility.placeOfServiceCode!= Null && facility.placeOfServiceCode.description!= Null && facility.placeOfServiceCode.description!= '')?facility.placeOfServiceCode.description:'';
                        wrapfacility.expirationDate = (facility.expirationDate!= Null && facility.expirationDate!= '')?formatDateMMDDYYYY(facility.expirationDate):'';
                        wrapfacility.decisionOutcome = (facility.facilityDecision!=Null && facility.facilityDecision.decisionOutcomeCode!= Null && facility.facilityDecision.decisionOutcomeCode.description!=Null && facility.facilityDecision.decisionOutcomeCode.description!= '')?facility.facilityDecision.decisionOutcomeCode.description:'';
                        wrapfacility.decisionSubType = (facility.facilityDecision!=Null && facility.facilityDecision.subTypeCode!= Null && facility.facilityDecision.subTypeCode.description!=Null && facility.facilityDecision.subTypeCode.description!= '')?facility.facilityDecision.subTypeCode.description:'';
                        wrapfacility.decisionMadeBy = (facility.facilityDecision!=Null && facility.facilityDecision.madeByUserid!= Null && facility.facilityDecision.madeByUserid!= '')?facility.facilityDecision.madeByUserid:'';
                        wrapfacility.rolePosition = (facility.facilityDecision!=Null && facility.facilityDecision.madeByUserPosition!= Null && facility.facilityDecision.madeByUserPosition!= '')?facility.facilityDecision.madeByUserPosition:'';
                        wrapfacility.claimCode = (facility.facilityDecision!=Null && facility.facilityDecision.overrideClaimRemarkCode!= Null) ?(((facility.facilityDecision.overrideClaimRemarkCode.code !=Null && facility.facilityDecision.overrideClaimRemarkCode.code != '')? facility.facilityDecision.overrideClaimRemarkCode.code :'--') +'/'+ ((facility.facilityDecision.overrideClaimRemarkCode.description != Null && facility.facilityDecision.overrideClaimRemarkCode.description != '')?facility.facilityDecision.overrideClaimRemarkCode.description:'--')):'--/--';
                        wrapfacility.advanceNotification = (facility.advanceNotificationTimestamp!= Null && facility.advanceNotificationTimestamp!= '')?formatDateMMDDYYYY(facility.advanceNotificationTimestamp):'';
                        wrapfacility.admissionNotification = (facility.admissionNotifyDateTime!= Null && facility.admissionNotifyDateTime!= '')?formatDateMMDDYYYY(facility.admissionNotifyDateTime):'';
                        wrapfacility.dischargeNotification = (facility.dischargeNotifyDateTime!= Null && facility.dischargeNotifyDateTime!= '')?formatDateMMDDYYYY(facility.dischargeNotifyDateTime):'';
                        wrapfacility.decisionReason = (facility.facilityDecision!=Null && facility.facilityDecision.decisionReasonCode!= Null && facility.facilityDecision.decisionReasonCode.description!=Null && facility.facilityDecision.decisionReasonCode.description!= '')?facility.facilityDecision.decisionReasonCode.description:'';
                        /*if(workOrdDetail.patientType!=Null && workOrdDetail.patientType !='' && workOrdDetail.patientType=='Inpatient'){
                            wrapfacility.expectedAdmissionDischargeDate = ((facility.expectedAdmissionDate!= Null && facility.expectedAdmissionDate!= '')?formatDateMMDDYYYY(facility.expectedAdmissionDate):'')+' - '+((facility.expectedDischargeDate!= Null && facility.expectedDischargeDate!= '')?formatDateMMDDYYYY(facility.expectedDischargeDate):'');
                            wrapfacility.actualAdmissionDischargeDates = ((facility.actualAdmissionDateTime!= Null && facility.actualAdmissionDateTime!= '')?formatDateMMDDYYYY(facility.actualAdmissionDateTime):'')+' - '+((facility.actualDischargeDateTime!= Null && facility.actualDischargeDateTime!= '')?formatDateMMDDYYYY(facility.actualDischargeDateTime):'');
                        }else if(workOrdDetail.patientType!=Null && workOrdDetail.patientType !='' && workOrdDetail.patientType=='Outpatient Facility'){
                            if(servMap.containsKey(facility.serviceReferenceNumber)){
                                ACETSNIWorkOrderDetailsWrapper.ServiceEffDates servdates = servMap.get(facility.serviceReferenceNumber);  
                                wrapfacility.expectedAdmissionDischargeDate = (servdates.startDate!= Null && servdates.startDate!= '')?formatDateMMDDYYYY(servdates.startDate):'';
                                wrapfacility.actualAdmissionDischargeDates = (servdates.stopDate!= Null && servdates.stopDate!= '')?formatDateMMDDYYYY(servdates.stopDate):'';
                                
                            }else{
                                wrapfacility.expectedAdmissionDischargeDate ='';
                                wrapfacility.actualAdmissionDischargeDates ='';
                            }
                        }*/
                    }
                    //Notes logic start
                    if(Noteslst!=Null && Noteslst.size()>0){
                        for(ACET_AuthorizationStatusResponse.Notes authNote : Noteslst){
                            ACETSNIWorkOrderDetailsWrapper.NotesDetail wrapnote = new ACETSNIWorkOrderDetailsWrapper.NotesDetail();                        	    
                            wrapnote.categoryCode = (authNote.categoryCode!= Null && authNote.categoryCode.description!= Null && authNote.categoryCode.description!= '')?authNote.categoryCode.description:'';
                            wrapnote.text = (authNote.text!= Null && authNote.text!= '')?authNote.text:'';
                            wrapnote.createdByUserId = (authNote.createdByUserId!= Null && authNote.createdByUserId!= '')?authNote.createdByUserId:'';
                            wrapnote.department = (authNote.department!= Null && authNote.department!= '')?authNote.department:'';
                            wrapnote.createDateTime = (authNote.createDateTime!= Null && authNote.createDateTime!= '')?authNote.createDateTime:'';
                            wrapNoteslst.add(wrapnote);
                        }
                    }
                    
                    ACET_AuthorizationStatusResponse.facility facilitylst= new ACET_AuthorizationStatusResponse.facility();
                    List<ACET_AuthorizationStatusResponse.diagnosis> diagnosislst= new List<ACET_AuthorizationStatusResponse.diagnosis>();
                    ACET_AuthorizationStatusResponse.authFollowUpContact followUplst= new ACET_AuthorizationStatusResponse.authFollowUpContact() ;
                    if(authresp!=Null){
                        if(authresp.AuthDetailsResponse!=Null){
                            if(authresp.AuthDetailsResponse.facility!=Null){
                                facilitylst = authresp.AuthDetailsResponse.facility;
                            }
                            if(authresp.AuthDetailsResponse.diagnosis!=Null){
                                diagnosislst= authresp.AuthDetailsResponse.diagnosis;
                            }
                            if(authresp.AuthDetailsResponse.AuthFollowUpContact!=Null){
                                followUplst= authresp.AuthDetailsResponse.AuthFollowUpContact;
                            }
                        }
                    }
                    List<ACETSNIWorkOrderDetailsWrapper.BedDayDecisionDetail> wrapbedDaylst= new List<ACETSNIWorkOrderDetailsWrapper.BedDayDecisionDetail>();
                    List<ACETSNIWorkOrderDetailsWrapper.DiagnosisDetail> wrapDiagnosislst= new List<ACETSNIWorkOrderDetailsWrapper.DiagnosisDetail>();
                    ACETSNIWorkOrderDetailsWrapper.FollowUpDetail wrapFollowUp = new ACETSNIWorkOrderDetailsWrapper.FollowUpDetail();
                    //List<ACETSNIWorkOrderDetailsWrapper.FollowUpDetail> wraFollowUplst= new List<ACETSNIWorkOrderDetailsWrapper.FollowUpDetail>();
                    //Diagnosis logic start
                    if(diagnosislst!=Null && diagnosislst.size()>0){
                        for(ACET_AuthorizationStatusResponse.diagnosis diag : diagnosislst){
                            ACETSNIWorkOrderDetailsWrapper.DiagnosisDetail wrapDiagnosis = new ACETSNIWorkOrderDetailsWrapper.DiagnosisDetail();
                            wrapDiagnosis.dxCode=((diag.diagnosisCode!= Null && diag.diagnosisCode.code!= Null)? diag.diagnosisCode.code:'');
                            wrapDiagnosis.diagnosisDescription = ((diag.diagnosisCode!= Null && diag.diagnosisCode.codeDesc!= Null)?diag.diagnosisCode.codeDesc:'');
                            wrapDiagnosis.primary = (diag.primaryInd !=null && diag.primaryInd != '' && diag.primaryInd == 'true') ? true :false;
                            wrapDiagnosislst.add(wrapDiagnosis);
                        } 
                    }
                    //Diagnosis Logic end
                    //followUp Logic start
                    
                    if(followUplst!=Null){
                        wrapFollowUp.name= followUplst.contactFullName !=null ?followUplst.contactFullName : '';
                        wrapFollowUp.role = (followUplst.communicationContactRoleCode!=null && followUplst.communicationContactRoleCode.description!= null && followUplst.communicationContactRoleCode.description!= '')?followUplst.communicationContactRoleCode.description:'';
                        wrapFollowUp.department = (followUplst.departmentTypecode!=null && followUplst.departmentTypecode.description!= null && followUplst.departmentTypecode.description!= '')?followUplst.departmentTypecode.description:'';
                        if(followUplst.phoneNumber != null){
                            for( ACET_AuthorizationStatusResponse.PhoneNumber phne: followUplst.phoneNumber){
                                if( phne.phoneTypeCode != null && phne.phoneTypeCode !='' && (phne.phoneTypeCode == '14' || phne.phoneTypeCode == '15') )
                                    wrapFollowUp.phone = phne.telephoneNumber;
                                
                                if( phne.phoneTypeCode !=null && phne.phoneTypeCode !='' && phne.phoneTypeCode == '3' )
                                    wrapFollowUp.fax =  phne.telephoneNumber;
                            }
                        }    
                    }
                    
                    //followUp Logic End
                    //BedDayDecision Logic start
                    if(facilitylst!=Null && facilitylst.facilityDecision!=Null && facilitylst.facilityDecision.bedDayDecision != Null){
                        for(ACET_AuthorizationStatusResponse.BedDayDecision bdayDcsn : facilitylst.facilityDecision.bedDayDecision){
                            ACETSNIWorkOrderDetailsWrapper.BedDayDecisionDetail wrapBedDayDecision = new ACETSNIWorkOrderDetailsWrapper.BedDayDecisionDetail();
                            wrapBedDayDecision.beginEndDate = ((bdayDcsn.bedDates!= null && bdayDcsn.bedDates.startDate != null && bdayDcsn.bedDates.startDate !='') ? ACETUtility.formatDateFromDashToSlash(bdayDcsn.bedDates.startDate) : '')+' - '+((bdayDcsn.bedDates!= null && bdayDcsn.bedDates.stopDate != null && bdayDcsn.bedDates.stopDate !='') ? ACETUtility.formatDateFromDashToSlash(bdayDcsn.bedDates.stopDate) : '');
                            wrapBedDayDecision.IPMNRAllowed = facilitylst.ipcmTypeId !=null ?facilitylst.ipcmTypeId.code: '';
                            wrapBedDayDecision.decisionUpdate =(bdayDcsn.decisionUpdateDateTime!=null && bdayDcsn.decisionUpdateDateTime !='') ?formatDateMMDDYYYY(bdayDcsn.decisionUpdateDateTime) : '';
                            wrapBedDayDecision.decision = (bdayDcsn.decisionOutcomeCode !=null && bdayDcsn.decisionOutcomeCode.description !=null && bdayDcsn.decisionOutcomeCode.description!='') ? bdayDcsn.decisionOutcomeCode.description :''; 
                            
                            wrapBedDayDecision.reason = (bdayDcsn.decisionReasonCode !=null && bdayDcsn.decisionReasonCode.description !=null && bdayDcsn.decisionReasonCode.description!='') ? bdayDcsn.decisionReasonCode.description :'';
                            
                            wrapBedDayDecision.claimComments = bdayDcsn.claimNoteText !=null ?bdayDcsn.claimNoteText :'';
                            wrapBedDayDecision.decisionBy = (facilitylst.facilityDecision !=null && facilitylst.facilityDecision.madeByUserId !=null) ? facilitylst.facilityDecision.madeByUserId :'';
                            wrapBedDayDecision.bedType = bdayDcsn.bedTypeCode !=null?(((bdayDcsn.bedTypeCode.code !=null && bdayDcsn.bedTypeCode.code != '')?bdayDcsn.bedTypeCode.code:'--') +'/'+ ((bdayDcsn.bedTypeCode.description !=null &&bdayDcsn.bedTypeCode.description != '')?bdayDcsn.bedTypeCode.description : '--')) : '--/--';
                            wrapBedDayDecision.dischargeLocation = (facilitylst.dischargeDispositionType !=null && facilitylst.dischargeDispositionType.description !=null && facilitylst.dischargeDispositionType.description!='') ? facilitylst.dischargeDispositionType.description :'';
                            
                            wrapbedDaylst.add(wrapBedDayDecision);   
                        }
                    }
                    //BedDayDecision Logic End
                    workOrdDetail.serviceLineDetail = wrapServicelst;
                    workOrdDetail.providerDetail = wrapProvlst;
                    workOrdDetail.facilityDetail =wrapfacility;
                    workOrdDetail.bedDayDecisionDetail =wrapbedDaylst ;
                    workOrdDetail.diagnosisDetail = wrapDiagnosislst;
                    workOrdDetail.followUpDetail = wrapFollowUp ;
                    workOrdDetail.notesDetail = wrapNoteslst;
                }
                
                return workOrdDetail;
            }
        }
        return null; 
    }
    public static string formatDateMMDDYYYY(String dateStr){
        string formatedDate='';
        if(string.isNotBlank(dateStr)){
            DateTime dt=Date.valueOf(dateStr);
            formatedDate = dt.formatGmt('MM/dd/yyyy');
        }
        return formatedDate;
    }
   /* @AuraEnabled
    public static datetime getWODetails(string woId){
        list<WorkOrder> lstWO = [select id,Host_System_Date_and_Time__c from WorkOrder where id =: woId];
        if(lstWO != null && ! lstWO.isEmpty()){
            return lstWO[0].Host_System_Date_and_Time__c;
        }
        else{
            return null;
        }
    }
    */    
}