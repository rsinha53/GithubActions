public with sharing class ACETLGT_GetHCPWebservice extends ACETWebservice {
    public String returningFromService;
    
    public override void GetEndpoint() {
        GetEndpointDetail('getHCPAdapterEndpoint');
    }
    public ACETLGT_GetHCPWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String ProviderId, String TaxID, String ProviderTINTypeCode, String AddressId, String AddressTypeCode) {                
        ProviderId = String.IsNotBlank(ProviderId) ? ProviderId : '';
        TaxID = String.IsNotBlank(TaxID) ? TaxID : '';
        ProviderTINTypeCode = String.IsNotBlank(ProviderTINTypeCode) ? ProviderTINTypeCode : '';
        AddressId = String.IsNotBlank(AddressId) ? AddressId : '';
        AddressTypeCode = String.IsNotBlank(AddressTypeCode) ? AddressTypeCode : '';        
        RequestParameters = new List<String>{ProviderId, '', TaxId, ProviderTINTypeCode, '', AddressId, AddressTypeCode};
        RequestBody = GetRequestBody('ACETGetHCPRequestJSON', RequestParameters);
    }
   
        
    private ACETLGT_ProviderLookupDetailResult ParseSuccessResponse(HttpResponse Response)  {
        ACETLGT_ProviderLookupDetailResult providerDetail = new ACETLGT_ProviderLookupDetailResult();
        ACETGetHCPAdapterJSON2Apex ACTGetHCPJSON2Apex = (ACETGetHCPAdapterJSON2Apex)JSON.deserialize(Response.getBody(), ACETGetHCPAdapterJSON2Apex.class);
        Map<String,UnitedHealth_Premium_Designation__mdt> uphdMap = new Map<String,UnitedHealth_Premium_Designation__mdt>();
        for(UnitedHealth_Premium_Designation__mdt uphd:[
            SELECT Id, Designation__c,Efficiency_Code__c,Quality_Code__c
            FROM UnitedHealth_Premium_Designation__mdt 
        ]){
            uphdMap.put(uphd.Efficiency_Code__c+'----'+uphd.Quality_Code__c,uphd);
        }
        if (ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse != null) {
            if (ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.MedicalHealthcareProfessional != null) {
                ACETGetHCPAdapterJSON2Apex.MedicalHealthcareProfessional generalInformation = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.MedicalHealthcareProfessional;
                if(generalInformation != null){
                    if (returningFromService == 'providerSearch') {
                         providerDetail.generalInfo.lastName = (String.isNotBlank(generalInformation.hcp.providerLastName)? generalInformation.hcp.providerLastName : '')+ ' ' + (String.isNotBlank(generalInformation.hcp.providerNameSuffix)? generalInformation.hcp.providerNameSuffix : '');
                         providerDetail.generalInfo.firstName = String.isNotBlank(generalInformation.hcp.providerFirstName) ? generalInformation.hcp.providerFirstName : '';
                    } else {
                        providerDetail.generalInfo.lastName = String.isNotBlank(generalInformation.Hcp.providerFirstName) ? generalInformation.Hcp.providerFirstName : '';
                        providerDetail.generalInfo.lastName += String.isNotBlank(generalInformation.Hcp.providerMiddleName) ? ' ' + generalInformation.Hcp.providerMiddleName : '';
                        providerDetail.generalInfo.lastName += String.isNotBlank(generalInformation.Hcp.providerLastName) ? ' ' + generalInformation.Hcp.providerLastName : '';
                        providerDetail.generalInfo.lastName += String.isNotBlank(generalInformation.Hcp.providerNameSuffix) ? ' ' + generalInformation.Hcp.providerNameSuffix : '';
                        providerDetail.generalInfo.providerType = 'Physician';
                    }
                    providerDetail.generalInfo.providerID = String.isNotBlank(generalInformation.hcp.providerId) ? generalInformation.hcp.providerId : '';
                    providerDetail.generalInfo.providerGenderCode = String.isNotBlank(generalInformation.Hcp.providerGenderCode) ? generalInformation.Hcp.providerGenderCode : '';
                    providerDetail.generalInfo.providerBirthDate = ChangeDateFormat(generalInformation.Hcp.providerBirthDate);
                    if (generalInformation.PatientAgeLimit != null && generalInformation.PatientAgeLimit.size() > 0) {
                        providerDetail.generalInfo.patientAgeRange = String.isNotBlank(generalInformation.PatientAgeLimit[0].beginAgeNumber) ? generalInformation.PatientAgeLimit[0].beginAgeNumber : '';
                        providerDetail.generalInfo.patientAgeRange += String.isNotBlank(generalInformation.PatientAgeLimit[0].endAgeNumber) ? ' - ' + generalInformation.PatientAgeLimit[0].endAgeNumber : '';
                    }
                    providerDetail.generalInfo.taxId = String.isNotBlank(generalInformation.providerTIN.id) ? generalInformation.providerTIN.id : '';
                    providerDetail.generalInfo.providerTINOwner = String.isNotBlank(generalInformation.providerTIN.owner) ? generalInformation.providerTIN.owner : '';
                    providerDetail.generalInfo.providerTINTypeCode = String.isNotBlank(generalInformation.ProviderTIN.typeCode) ? generalInformation.ProviderTIN.typeCode : '';
                    providerDetail.generalInfo.npi = (generalInformation.npi != null && generalInformation.npi.size() > 0 && String.isNotBlank(generalInformation.npi[0].id)) ? generalInformation.npi[0].id : '';
                    //providerDetail.generalInfo.pcpObgnId = String.isNotBlank(generalInformation.providerLocationAffiliations.id) ? generalInformation.providerLocationAffiliations.id: '';
                }
                
                List<ACETGetHCPAdapterJSON2Apex.Specialty> practiceInformationLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.medicalHealthcareProfessional.specialty;
                if (practiceInformationLst != null &&  practiceInformationLst.size() > 0 && !practiceInformationLst.isEmpty()) {
                    for (Integer index = 0; index < practiceInformationLst.size(); index++) {
                        ACETLGT_ProviderLookupDetailResult.ACETProviderSpeciality specialityObj = new ACETLGT_ProviderLookupDetailResult.ACETProviderSpeciality();
                        specialityObj.primarySpeciality = String.isNotBlank(practiceInformationLst[index].primarySpecialtyIndicator) ? practiceInformationLst[index].primarySpecialtyIndicator : 'N';
                        specialityObj.speciality = String.isNotBlank(practiceInformationLst[index].typeDescription) ? practiceInformationLst[index].typeDescription : '';
                        if (String.isNotBlank(practiceInformationLst[index].BoardCertification.boardCertificationCode)) {
                            specialityObj.boardCert = practiceInformationLst[index].BoardCertification.boardCertificationCode == 'Certified' ? 'Yes' : 'No';
                        } else {
                            specialityObj.boardCert = 'No';
                        }
                        specialityObj.cancelDate = ChangeDateFormat(practiceInformationLst[index].BoardCertification.boardCertificationCancelDate);
                         if (String.isNotBlank(practiceInformationLst[index].statusCode)) {
                            specialityObj.statusCode = practiceInformationLst[index].statusCode;
                        }else {
                            specialityObj.statusCode = '';
                        }
                       providerDetail.specialities.add(specialityObj);
                    }
                }
                
                List<ACETGetHCPAdapterJSON2Apex.PremiumDesignation> premiumDesignLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.medicalHealthcareProfessional.PremiumDesignation;                 
                if (premiumDesignLst != null && premiumDesignLst.size() > 0 && !premiumDesignLst.isEmpty()) {  
                    for (Integer index = 0; index < premiumDesignLst.size(); index++) {  
                        ACETLGT_ProviderLookupDetailResult.ACETProviderUnitedPremium aCETProUniPremium = new ACETLGT_ProviderLookupDetailResult.ACETProviderUnitedPremium();
                         if (String.isNotBlank(premiumDesignLst[index].qualityTypeCode) && String.isNotBlank(premiumDesignLst[index].efficiencyTypeCode)){
                            
                             if(uphdMap.get(premiumDesignLst[index].efficiencyTypeCode+'----'+premiumDesignLst[index].qualityTypeCode)!=null){
                                aCETProUniPremium.PremiumDesignation 
                                = uphdMap.get(premiumDesignLst[index].efficiencyTypeCode+'----'+premiumDesignLst[index].qualityTypeCode).Designation__c;
                             }
                             else{
                                aCETProUniPremium.PremiumDesignation = 'N/A';
                             }
                        }
                        else
                                aCETProUniPremium.PremiumDesignation = 'N/A';
                        aCETProUniPremium.premiumSpeciality = String.isNotBlank(premiumDesignLst[index].diseaseGroupTypeCode) ? premiumDesignLst[index].diseaseGroupTypeCode : '';
                        aCETProUniPremium.effectiveDate = ChangeDateFormat(premiumDesignLst[index].effectiveDate);
                        aCETProUniPremium.premiumCancelDate = ChangeDateFormat(premiumDesignLst[index].cancelDate);
                        ProviderDetail.unitedPremiums.add(ACETProUniPremium);
                    }  
                }
                
                List<ACETGetHCPAdapterJSON2Apex.Degree> degreeLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.medicalHealthcareProfessional.Degree;   
                if (degreeLst != null && degreeLst.size() > 0 && !degreeLst.isEmpty()) {
                    for (Integer index = 0; index < degreeLst.size(); index++) {
                        ACETLGT_ProviderLookupDetailResult.Degree degreeObj = new ACETLGT_ProviderLookupDetailResult.Degree();
                        degreeObj.code = String.isNotBlank(degreeLst[index].code) ? degreeLst[index].code : '';
                        degreeObj.schoolName = String.isNotBlank(degreeLst[index].schoolName) ? degreeLst[index].schoolName : '';
                        providerDetail.degrees.add(degreeObj);
                    }
                }
                
                List<ACETGetHCPAdapterJSON2Apex.providerLocationAffiliations> providerLocationAffiliationsLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.medicalHealthcareProfessional.providerLocationAffiliations;   
                if (providerLocationAffiliationsLst != null && providerLocationAffiliationsLst.size() > 0 && !providerLocationAffiliationsLst.isEmpty()) {
                    for (Integer index = 0; index < providerLocationAffiliationsLst.size(); index++) {
                        ACETLGT_ProviderLookupDetailResult.providerLocationAffiliation providerLocationAffiliationObj = new ACETLGT_ProviderLookupDetailResult.providerLocationAffiliation();
                        providerLocationAffiliationObj.id = String.isNotBlank(providerLocationAffiliationsLst[index].id) ? providerLocationAffiliationsLst[index].id: '';
                        providerDetail.providerLocationAffiliations.add(providerLocationAffiliationObj);
                    }
                }
                List<ACETGetHCPAdapterJSON2Apex.Tpsm> tpsmLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.medicalHealthcareProfessional.Tpsm;
                if (tpsmLst != null && tpsmLst.size() > 0 && !tpsmLst.isEmpty()) {                             
                    for (ACETGetHCPAdapterJSON2Apex.Tpsm platinum :tpsmLst) {
                        if (platinum != null){
                            if (platinum.code == '99Z') {
                                providerDetail.generalInfo.platinumProvider = 'No';                                        
                            } else if (String.isBlank(platinum.code)) {
                                providerDetail.generalInfo.platinumProvider = '';
                            } else {
                                providerDetail.generalInfo.platinumProvider = 'Yes - ' +  platinum.code;   
                            }
                        }
                    }    
                }
                
                List<ACETGetHCPAdapterJSON2Apex.language> languageLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.medicalHealthcareProfessional.Language;    
                if (languageLst != null && languageLst.size() > 0 && !languageLst.isEmpty()) {
                    for (Integer index = 0; index < languageLst.size(); index++) { 
                        ACETLGT_ProviderLookupDetailResult.Language langaugeObj = new ACETLGT_ProviderLookupDetailResult.Language();
                        langaugeObj.language = String.isNotBlank(languageLst[index].language) ? languageLst[index].language : '';
                        providerDetail.languages.add(langaugeObj);
                        
                    }    
                } 
                
                List<ACETGetHCPAdapterJSON2Apex.HoursOfOperation> hoursOfOperationLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResponse.medicalHealthcareProfessional.hoursOfOperation;   
                if (hoursOfOperationLst != null && hoursOfOperationLst.size() > 0 && String.isNotBlank(hoursOfOperationLst[0].weekcode) && !hoursOfOperationLst.isEmpty()) {
                    for (Integer index = 0; index < hoursOfOperationLst.size(); index++) { 
                        ACETLGT_ProviderLookupDetailResult.HoursOfOperation hrsOfOperationObj = new ACETLGT_ProviderLookupDetailResult.HoursOfOperation();
                        hrsOfOperationObj.weekCode = String.isNotBlank(hoursOfOperationLst[index].weekCode) ? hoursOfOperationLst[index].weekCode : '';
                        hrsOfOperationObj.startTime1 =  String.isNotBlank(hoursOfOperationLst[index].startTime1) ? format24HrsTo12Hrs(hoursOfOperationLst[index].startTime1.substring(0,5)) : '';
                        hrsOfOperationObj.endTime1 = String.isNotBlank(hoursOfOperationLst[index].startTime1) ? format24HrsTo12Hrs(hoursOfOperationLst[index].endTime1.substring(0,5)) : '';
                        hrsOfOperationObj.startTime2 =  String.isNotBlank(hoursOfOperationLst[index].startTime2) ? format24HrsTo12Hrs(hoursOfOperationLst[index].startTime2.substring(0,5)) : '';
                        hrsOfOperationObj.endTime2 = String.isNotBlank(hoursOfOperationLst[index].startTime2) ? format24HrsTo12Hrs(hoursOfOperationLst[index].endTime2.substring(0,5)) : '';
                        providerDetail.hoursOfOperations.add(hrsOfOperationObj);                                    
                    }
                    
                }
                //}
            }
        }
        return providerDetail;  
    }
    public ACETWSCalloutResult init(String ProviderId, String TaxID, String providerTINTypeCode, String addressId, String addressTypeCode, 
                String returningFrom) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETLGT_ProviderLookupDetailResult providerDetail = new ACETLGT_ProviderLookupDetailResult();
        this.returningFromService = returningFrom;
       system.debug(LoggingLevel.INFO, 'returningFrom*** ' + returningFrom);
        try {
		    GetEndpoint();
		    GetRequestBody(ProviderId, TaxID, providerTINTypeCode, addressId, addressTypeCode);
            //HttpResponse Response = GetHttpResponse(HttpRequestLabel);
			HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200) {
                ProviderDetail = ParseSuccessResponse(Response);
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ProviderDetail; 
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);  
            }    
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex);
            system.debug(ex.getlinenumber());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
    
    private String format24HrsTo12Hrs(String timeToFormat) {
        Integer formatHour = (Integer.valueOf(timeToFormat.subString(0,2)) - ((Integer.valueOf(timeToFormat.subString(0,2)) == 0)? -12 : (Integer.valueOf(timeToFormat.subString(0,2)) <= 12)? 0 : 12));
        String AMtoPM = (Integer.valueOf(timeToFormat.subString(0,2)) < 12 ? ' AM' : ' PM');
        String FormattedTime = String.valueOf(formatHour)+ ':'+timeToFormat.subString(3,5) + AMtoPM;
        return FormattedTime;
    }
}