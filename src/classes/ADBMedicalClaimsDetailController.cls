public without sharing class ADBMedicalClaimsDetailController {
    
    @AuraEnabled public static ADBMedicalClaimResponseWrapper getMedicalClaims(String userId, String memberId, String policy, String memFirstName, String relationship, String consumerApplication) {
        ADBMedicalClaimResponseWrapper responseWrapper = new ADBMedicalClaimResponseWrapper();
        ADBMedicalClaimRequestWrapper requestWrapper = new ADBMedicalClaimRequestWrapper();
        List<ADBMedicalClaimResponseWrapper.Claims> medicalClaimData = new List<ADBMedicalClaimResponseWrapper.Claims>();
        List<ADBMedicalClaimResponseWrapper.Errors> medicalErrorData = new List<ADBMedicalClaimResponseWrapper.Errors>();
        try{
            requestWrapper.userId = userId;
            requestWrapper.memberId = memberId;
            requestWrapper.policy = policy;
            requestWrapper.firstName = memFirstName;
            requestWrapper.relationship = relationship;
            requestWrapper.consumerApplication = consumerApplication;
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMedicalClaimsEndpoint', JSON.serialize(requestWrapper), null);
            HttpResponse response = wsCallOutFW.getResponse();
            // Faking the prod response
            /*HttpResponse response = new HttpResponse();
StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'NonPaidMedicalClaim'];//MedicalClaims_Traye //MedicalClaims_Holly //MedicalClaims_Monica //ADBProviderUtilizationMockResponse //ADBMedicalErrorResponse
String strBody = requestTemplate.Body.toString();
system.debug('strBody Auth service'+strBody);
response.setBody(strBody);
system.debug('response Auth service'+response);
response.setStatusCode(200);*/
            
            // Checking the status code is success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400 || response.getStatusCode() == 500) {
                responseWrapper = (ADBMedicalClaimResponseWrapper) JSON.deserialize(response.getBody(), ADBMedicalClaimResponseWrapper.class);
                system.debug('responseWrapper'+responseWrapper);
                if(responseWrapper!= null && responseWrapper.searchResult != null){
                    if(responseWrapper.searchResult.searchOutput != null){
                        if(responseWrapper.searchResult.searchOutput.claims != null){
                          ADBMedicalClaimResponseWrapper.SearchOutput rs = responseWrapper.searchResult.searchOutput;
                            for(Integer i=0; i < rs.claims.size(); i++){
                                if('PHARMACY'.equalsIgnoreCase(rs.claims[i].providerName))
                                    continue;
                                ADBMedicalClaimResponseWrapper.Claims tempClaims = new ADBMedicalClaimResponseWrapper.Claims();
                                String firstServiceDate = rs.claims[i].firstServiceDate;
                                tempClaims.firstServiceDate = getFormattedDate(firstServiceDate);
                                String lastServiceDate = rs.claims[i].lastServiceDate;
                                tempClaims.lastServiceDate = getFormattedDate(lastServiceDate);
                                String pTier  = getProviderTier(rs.claims[i].providerTier);
                                tempClaims.providerTier = pTier;
                                tempClaims.providerName = rs.claims[i].providerName;
                                String pSpecialty  = getProviderSpecialtyName(rs.claims[i].providerSpecialty);
                                tempClaims.providerSpecialty = pSpecialty;
                                tempClaims.totalPatientResponsibility = rs.claims[i].totalPatientResponsibility;
                                tempClaims.claimType = rs.claims[i].claimType;
                                String providerTaxId = rs.claims[i].providerTaxId;
                                String providerTaxIdPrefix = rs.claims[i].providerTaxIdPrefix;
                                String providerTaxIdSuffix = rs.claims[i].providerTaxIdSuffix;
                                String formattedProviderTaxId  = providerTaxIdPrefix+'-'+providerTaxId+'-'+providerTaxIdSuffix;
                                tempClaims.providerTaxId = formattedProviderTaxId;
                                String auditControlNumber = rs.claims[i].auditControlNumber;
                                String auditControlNumberSuffixCode = rs.claims[i].auditControlNumberSuffixCode;
                                String formattedAuditControlNumber = auditControlNumber+'-'+auditControlNumberSuffixCode;
                                tempClaims.formattedAuditControlNumber = formattedAuditControlNumber;
                                tempClaims.auditControlNumber = rs.claims[i].auditControlNumber;
                                tempClaims.totalCharged = rs.claims[i].totalCharged;
                                tempClaims.processedDate = rs.claims[i].processedDate;
								String pClaimStatus  = getProviderStatus(rs.claims[i].claimStatus);
                                tempClaims.claimStatus = pClaimStatus;	  
                                medicalClaimData.add(tempClaims);
                            }
                            responseWrapper.searchResult.searchOutput.claims = medicalClaimData;
                        }
                    }
                    else{
                        if(responseWrapper.searchResult.errors != null){
                            for(Integer i=0; i < responseWrapper.searchResult.errors.size(); i++){
                                ADBMedicalClaimResponseWrapper.Errors tempError = new ADBMedicalClaimResponseWrapper.Errors();
                                tempError.code = responseWrapper.searchResult.errors[i].code;
                                tempError.name = responseWrapper.searchResult.errors[i].name;
                                tempError.description = responseWrapper.searchResult.errors[i].description;
                                medicalErrorData.add(tempError);
                            }
                            responseWrapper.searchResult.errors = medicalErrorData;
                        } 
                    }
                }
            }
        }catch(Exception e){
            system.debug('ADBMedicalClaimResponseWrapper.getMedicalClaims Exception ::' + e.getMessage());
        }
        return responseWrapper; 
    }
    
    // Call ADBProviderTier Custom Metadata and get providerTier Value
    @AuraEnabled public static String getProviderTier(String providerTier){
        String tierName = '';
        try {
            List<ADBProviderTier__mdt> tier = [SELECT providerTier__c FROM ADBProviderTier__mdt WHERE Label =: providerTier];
            if((tier != null) && (!tier.isEmpty())){
                tierName = tier[0].providerTier__c;
            }
        }catch(Exception e){
            system.debug('ADBMedicalClaimResponseWrapper.getProviderTier Exception ::' + e.getMessage());
        }
        return tierName;
    }
    
    // Call providerSpecialty Custom Metadata and get providerSpecialty Value
    @AuraEnabled public static String getProviderSpecialtyName(String providerSpecialty){
        String pSpecialty = '';
        try {
            List<ADBProviderSpecialty__mdt> specialty = [SELECT ProviderSpecialtyName__c FROM ADBProviderSpecialty__mdt WHERE Label =: providerSpecialty]; 
            if((specialty !=null) && (!specialty.isEmpty())){
                pSpecialty = specialty[0].ProviderSpecialtyName__c;
            } else{
               pSpecialty = 'Not Listed'; 
            }
        }catch(Exception e){
            system.debug('ADBMedicalClaimResponseWrapper.getproviderSpecialtyName Exception ::' + e.getMessage());
        }
        return pSpecialty;
    }
    
    // Used to format date
    @AuraEnabled public static String getFormattedDate (String seleteDate){
        String formattedDate = '';
        if(String.isNotBlank(seleteDate)){
            list<String> splitDate = (seleteDate).split('-');
            String splitDateList = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            formattedDate= splitDateList;                                 
        }  
        return formattedDate;
    }
   // Call ADBMedicalClaimStatus Custom Metadata and get providerStatus Value
    @AuraEnabled public static String getProviderStatus(String providerStatus){
        String status = '';
        try {
            List<ADBMedicalClaimStatus__mdt> stVal = [SELECT Value__c FROM ADBMedicalClaimStatus__mdt WHERE key__c =: providerStatus];
            if((stVal != null) && (!stVal.isEmpty())){
                status = stVal[0].Value__c;
            }
        }catch(Exception e){
            system.debug('ADBMedicalClaimResponseWrapper.getProviderStatus Exception ::' + e.getMessage());
        }
        return status;
    }	 
}