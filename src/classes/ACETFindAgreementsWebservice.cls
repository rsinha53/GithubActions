public class ACETFindAgreementsWebservice extends ACETWebservice {
    private string providerId;
    private string providerTIN;
    private string providerTINTypeCode;
    private string addressId;
    private string addressTypeCode;
    private string benefitPlanId;
    public string networkval;
    private string claimType;
   
    public override void GetEndpoint() {
        GetEndpointDetail('findAgreementsEndpoint');
    }
     public ACETFindAgreementsWebservice() {
         super(SAEConstants.STARGATE_STG_SERVICENAME);  
         if(Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c){
             this(SAEConstants.STARGATE_PRD_SERVICENAME);
         }
    }
    
    public ACETFindAgreementsWebservice(String serviceName) {
        super(serviceName);
    }
    
    //Added for the user story US1035659 
    public void init(String strProviderId,String strProviderTIN, String strProviderTINTypeCode, String strAddressId, String strAddressTypeCode,String 
        strBenefitPlanId,string strNetworkval,String strClaimType){
        providerId = String.isNotBlank(strProviderId) ? strProviderId: '';
        providerTIN = String.isNotBlank(strProviderTIN) ? strProviderTIN: '';
        providerTINTypeCode = String.isNotBlank(strProviderTINTypeCode) ? strProviderTINTypeCode: '';
        addressId = String.isNotBlank(strAddressId) ? strAddressId: '';
        addressTypeCode = String.isNotBlank(strAddressTypeCode) ? strAddressTypeCode: '';
        benefitPlanId = String.isNotBlank(strBenefitPlanId) ? strBenefitPlanId: '';
        networkval = String.isNotBlank(strNetworkval) ? strNetworkval: '';
        claimType = String.isNotBlank(strClaimType) ? strClaimType: '';
    }
   //Added for the user story US1035659 
    private void GetRequestBody() {
        String strstaticfilename = 'findMedicalProviderAgreementsRequestTemplate'; 
            
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
           prefix = '';
        } else {
           prefix += '__';
        }
        
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
        PageReference pg = new PageReference(srPath);
        if(!Test.isRunningTest())
        {        
            RequestBody = pg.getContent().toString();
        }
        else 
        {
            RequestBody = 'UNIT.TEST';
        }
        string tmpNetworkId =''; 
        if(networkval != null && networkval.contains('@')){
            for(string s : networkval.split('@')){
                if(tmpNetworkId == ''){
                    tmpNetworkId = s;                
                }else{
                    tmpNetworkId = tmpNetworkId+'"' + ',"'+s;
                }
            }
            networkval =  tmpNetworkId;
        }
       string attributedataset = '["key","contractDetail","pricingSet","contractHeader","contractDerivedDates","network"]';
              
        RequestBody = (providerId != null) ? RequestBody.replace('@@providerId@@',providerId) : RequestBody.replace('@@providerId@@', '') ;
        RequestBody = (providerTIN != null) ? RequestBody.replace('@@providerTIN@@',providerTIN) : RequestBody.replace('@@providerTIN@@', '') ;
        RequestBody = (providerTINTypeCode != null) ? RequestBody.replace('@@providerTINTypeCode@@',providerTINTypeCode) : RequestBody.replace('@@providerTINTypeCode@@', '') ;
        RequestBody = (addressId != null) ? RequestBody.replace('@@addressId@@',addressId) : RequestBody.replace('@@addressId@@', '') ; 
        RequestBody = (addressTypeCode != null)  ? RequestBody.replace('@@addressTypeCode@@',addressTypeCode) : RequestBody.replace('@@addressTypeCode@@', '') ;
        RequestBody = (benefitPlanId != null)  ? RequestBody.replace('@@benefitPlanId@@',benefitPlanId) : RequestBody.replace('@@benefitPlanId@@', '') ;
        RequestBody = (claimType!= null)  ? RequestBody.replace('@@contractClaimType@@',claimType) : RequestBody.replace('@@contractClaimType@@', '') ;
        RequestBody = (networkval!= null)  ? RequestBody.replace('@@networkId@@',networkval) : RequestBody.replace('@@networkId@@', '') ;
        RequestBody = (attributeDataSet != null)  ? RequestBody.replace('@@attributeDataSet@@',attributedataset ) : RequestBody.replace('@@attributeDataSet@@', '') ;

        system.debug('RequestBody1::'+RequestBody);
    }
    
   /* private void GetRequestBody(String strProviderId,String strProviderTIN, String strProviderTINTypeCode, String strAddressId, String strAddressTypeCode,String 

strBenefitPlanId,string strNetwork, String strCliamType) {
        String strstaticfilename = 'findMedicalProviderAgreementsRequestTemplate'; 
            
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
           prefix = '';
        } else {
           prefix += '__';
        }
        
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
        PageReference pg = new PageReference(srPath);
        if(!Test.isRunningTest())
        {        
            RequestBody = pg.getContent().toString();
        }
        else 
        {
            RequestBody = 'UNIT.TEST';
        }
        
        RequestBody = (strProviderId != null) ? RequestBody.replace('@@providerId@@',strProviderId) : RequestBody.replace('@@providerId@@', '') ;
        RequestBody = (strProviderTIN != null) ? RequestBody.replace('@@providerTIN@@',strProviderTIN) : RequestBody.replace('@@providerTIN@@', '') ;
        RequestBody = (strProviderTINTypeCode != null) ? RequestBody.replace('@@providerTINTypeCode@@',strProviderTINTypeCode) : RequestBody.replace

('@@providerTINTypeCode@@', '') ;
        RequestBody = (strAddressId != null) ? RequestBody.replace('@@addressId@@',strAddressId) : RequestBody.replace('@@addressId@@', '') ; 
        RequestBody = (strAddressTypeCode != null)  ? RequestBody.replace('@@addressTypeCode@@',strAddressTypeCode) : RequestBody.replace('@@addressTypeCode@@', '') ;
        RequestBody = (strBenefitPlanId != null)  ? RequestBody.replace('@@benefitPlanId@@',strBenefitPlanId) : RequestBody.replace('@@benefitPlanId@@', '') ;
    RequestBody = (strCliamType != null)  ? RequestBody.replace('@@contractClaimType@@',strCliamType) : RequestBody.replace('@@contractClaimType@@', '') ;
        RequestBody = (strNetwork != null)  ? RequestBody.replace('@@networkId@@',strNetwork) : RequestBody.replace('@@networkId@@', '') ;
        system.debug('RequestBody::'+RequestBody);
    }*/
    
    private ACETWSCalloutResult ParseSuccessResponse(HttpResponse Response) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderContractResult> Agreements = new List<ACETProviderContractResult>();
        Map<String,ACETProviderContractResult> contractDetailIdMap;
        Map<String,ACETProviderContractResult> agreementMap;
        Map<String,String> contractDateMap;
        String tempContractDetailId;
        String tempNetworkId;
        ACETOILPagination Pagination;
        
        String ResponseBody = ReplaceKeywords(Response.getBody());
        ACETFindProviderAgreementsJSON2APEX ACETJSON2Apex = (ACETFindProviderAgreementsJSON2APEX)JSON.deserialize(ResponseBody, 
                                                                   ACETFindProviderAgreementsJSON2APEX.class);
        system.debug('ACETFindAgreementsWebservice. ACETJSON2Apex : ' + ACETJSON2Apex);
        List<ACETFindProviderAgreementsJSON2APEX.ContractDerivedDates> contractDetails;
        if (ACETJSON2Apex.findMedicalProviderAgreementsResponse.errors == null) {
            Pagination = ACETJSON2Apex.findMedicalProviderAgreementsResponse.pagination;
            if (Integer.valueOf(Pagination.totalCount) > 0) {
                oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                oACETWSCalloutResult.pageSize = Pagination.pageSize;
                oACETWSCalloutResult.recordCount = Pagination.recordCount;
                oACETWSCalloutResult.totalCount = Pagination.totalCount;
                oACETWSCalloutResult.totalPages = Pagination.totalPages;
                ACETFindProviderAgreementsJSON2APEX.findMedicalProviderAgreementsResponse SRAgreements = ACETJSON2Apex.findMedicalProviderAgreementsResponse;
                system.debug('AgreementsList*******: ' + SRAgreements);
                if (SRAgreements.medicalproviderAgreements != null && !SRAgreements.medicalproviderAgreements.isEmpty()) {
                    contractDetailIdMap = new Map<String,ACETProviderContractResult>();
                    contractDateMap = new Map<String,String>();
                    agreementMap = new  Map<String,ACETProviderContractResult>();
                    for(ACETFindProviderAgreementsJSON2APEX.medicalproviderAgreements SRAgreement : SRAgreements.medicalproviderAgreements){
                             contractDetails = new List<ACETFindProviderAgreementsJSON2APEX.ContractDerivedDates>();
                             tempContractDetailId = '';
                             tempNetworkId = '';
                             ACETProviderContractResult Agreement = new ACETProviderContractResult();
                            if (String.isNotBlank(SRAgreement.network.id)){
                               tempNetworkId =  Agreement.Network_ID = SRAgreement.network.Id;
                               System.debug('tempNetworkId' +tempNetworkId);
                            }
                            if (String.isNotBlank(SRAgreement.network.name)){
                                Agreement.Network_Name = SRAgreement.network.name;
                            }
                            if (String.isNotBlank(SRAgreement.network.statusCode)){
                                Agreement.Network_Status = SRAgreement.network.statusCode;
                            }
                            /**if (String.isNotBlank(SRAgreement.contractDetail.statusCode)) {
                                if(SRAgreement.contractDetail.statusCode== 'A'){
                                    Agreement.Contract_Status = 'Active';
                                }
                                else if (SRAgreement.contractDetail.statusCode== 'I') {
                                    Agreement.Contract_Status = 'Inactive';   
                                } 
                                else  {
                                    Agreement.Contract_Status = '';
                                } 
                            }*/
                        
                            if (String.isNotBlank(SRAgreement.pricingSet.id)) {
                                Agreement.Pricing_Set_ID = SRAgreement.pricingSet.id;
                            }
                            if (String.isNotBlank(SRAgreement.network.name) && String.isNotBlank(SRAgreement.pricingSet.id) ){
                                Agreement.NetworkNamePricngSet = SRAgreement.network.name+ '_' + SRAgreement.pricingSet.id;
                                System.debug('NetworkNamePricngSet'+Agreement.NetworkNamePricngSet);
                            }  
                         /*   if (String.isNotBlank(SRAgreement.benefitPlan.productName)) {
                                Agreement.Product = SRAgreement.benefitPlan.planTypeCode;
                            }  */
                             
                             if(SRAgreement.contractDetail != null) {
                                if (String.isNotBlank(SRAgreement.contractDetail.acceptingNewPatientsIndicator)) {
                                    Agreement.Accepting_New_Patients = SRAgreement.contractDetail.acceptingNewPatientsIndicator;
                                } 
                                if (String.isNotBlank(SRAgreement.contractDetail.acceptingExistingPatientsIndicator)) {
                                    Agreement.Accepting_Existing_Patients = SRAgreement.contractDetail.acceptingExistingPatientsIndicator;
                                } 
                                if (String.isNotBlank(SRAgreement.contractDetail.providerAssignmentTypeCode)) {
                                    Agreement.ProviderAssignmentType = SRAgreement.contractDetail.providerAssignmentTypeCode;
                                }
                                if (String.isNotBlank(SRAgreement.contractDetail.processOrderNumber)) {
                                   Agreement.process_Order_Number = SRAgreement.contractDetail.processOrderNumber;
                                }
                                if (String.isNotBlank(SRAgreement.contractDetail.providerAssignmentIndicator)) {
                                   Agreement.providerAssignmentIndicator = SRAgreement.contractDetail.providerAssignmentIndicator;
                                }
                            }
                            if (String.isNotBlank(SRAgreement.key.contractDetailId)) {
                                tempContractDetailId = Agreement.ContractDetailId = SRAgreement.key.contractDetailId;
                                System.debug('tempContractDetailId'+tempContractDetailId);
                            }
                            if (String.isNotBlank(SRAgreement.key.contractHeaderId)) {
                                Agreement.ContractHeaderId = SRAgreement.key.contractHeaderId;
                            }           
                            if(SRAgreement.contractHeader != null) {
                                 if (String.isNotBlank(SRAgreement.contractHeader.organizationName)) {
                                    Agreement.organizationName = SRAgreement.contractHeader.organizationName;
                                }
                            }
                      /*   if(String.isNotBlank(SRAgreement.ContractDetail.claimTypeCode)){
                            Agreement.claimType = SRAgreement.ContractDetail.claimTypeCode;
                        }
                       if (String.isNotBlank(SRAgreement.key.benefitPlanId)) {
                            Agreement.BenefitPlanId = SRAgreement.key.benefitPlanId;
                        }
                        if (String.isNotBlank(SRAgreement.key.networkScheduleId)) {
                            Agreement.NetworkSchedule = SRAgreement.key.networkScheduleId;
                        } */
                       /* if(SRAgreement.contractDerivedDates != null && !SRAgreement.contractDerivedDates.isEmpty()) {
                          for (ACETFindProviderAgreementsJSON2APEX.ContractDerivedDates contractDerivedDates :SRAgreement.contractDerivedDates) {
                              if (String.isNotBlank(contractDerivedDates.statusCode)) {
                                 Agreement.Contract_Status = contractDerivedDates.statusCode;
                              }
                              if (String.isNotBlank(contractDerivedDates.effectiveDate)) {
                                Agreement.Effective = ChangeDateFormat(contractDerivedDates.effectiveDate);                    
                              }
                              if (String.isNotBlank(contractDerivedDates.cancelDate)) {                 
                                Agreement.Cancel = ChangeDateFormat(contractDerivedDates.cancelDate);
                             }
                          }
                        }*/
                        if(SRAgreement.contractDerivedDates != null && !SRAgreement.contractDerivedDates.isEmpty()) {
                                   contractDetails = SRAgreement.contractDerivedDates;
                        }
                        contractDateMap = populateDate(contractDetails);
                        if(!contractDetailIdMap.isEmpty()) {
                            if(contractDetailIdMap.containsKey(tempContractDetailId+tempNetworkId)) {
                                Agreement = contractDetailIdMap.get(tempContractDetailId+tempNetworkId);
                              }
                            else {
                                contractDetailIdMap.put(tempContractDetailId+tempNetworkId,Agreement);
                            }
                        }else {
                             contractDetailIdMap.put(tempContractDetailId+tempNetworkId,Agreement);
                        }
                        System.debug('contractDateMap'+contractDateMap);
                        System.debug('contractDetailIdMap'+contractDetailIdMap);
                        ACETProviderContractResult temp;
                        if(contractDateMap.size() > 0 && contractDetailIdMap.size() > 0) {
                             for(String contractDate :contractDateMap.keyset()) {
                               if(contractDateMap.get(contractDate).contains('@')) {
                                      if(contractDetailIdMap.containsKey(tempContractDetailId+tempNetworkId)) { //tempContractDetailId == contractDetailIdMap.get(tempContractDetailId).ContractDetailId
                                           temp =  contractDetailIdMap.get(tempContractDetailId+tempNetworkId);
                                      }
                                        ACETProviderContractResult  contractAgreement = new ACETProviderContractResult(temp);
                                        System.debug('temp'+temp);
                                        List<String> splitDateAndStatus  = new List<String>(contractDateMap.get(contractDate).split('@'));
                                        contractAgreement.Contract_Status = splitDateAndStatus[1];
                                        contractAgreement.Cancel =  ChangeDateFormat(splitDateAndStatus[0]);
                                        contractAgreement.Effective =  ChangeDateFormat(contractDate);
                                        agreementMap.put(tempContractDetailId+tempNetworkId+'@'+contractAgreement.Effective,contractAgreement);
                                        System.debug('agreementMap'+agreementMap);
                                   }
                                }
                            } 
                       }
                     if(!agreementMap.isEmpty()) {
                            System.debug('Agreemenetmaptt'+agreementMap.keyset());
                            Agreements.addAll(agreementMap.values());
                        }
                        
                    System.debug('Agreements'+Agreements);
                }
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Agreements;
            }
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.findMedicalProviderAgreementsResponse.errors);
        oACETWSCalloutResult.Message = oACETWSCalloutResult.Message == Label.OILNoRecordErrorMessage ? Label.ACETNoRecordErrorMessage : oACETWSCalloutResult.Message;
            oACETWSCalloutResult.Response = null;
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
        }
        return oACETWSCalloutResult;
    }
    private static Map<String,String> populateDate(List<ACETFindProviderAgreementsJSON2APEX.ContractDerivedDates> contractDetails) {
       Map<String,String> dateMap= new Map<String,String>();
       Map<String, String> finalizedDateMap = new Map<String, String>();
       for(ACETFindProviderAgreementsJSON2APEX.ContractDerivedDates con :contractDetails) {
           if(String.isNotBlank(con.effectiveDate) && String.isNotBlank(con.cancelDate) && String.isNotBlank(con.statusCode)) {
             dateMap.put(con.effectiveDate, con.cancelDate+'@'+con.statusCode);
           }
      }
        List<String> effectiveDates = new List<String>();
        if(!dateMap.isEmpty()) {
            effectiveDates.addAll(dateMap.keyset());
            effectiveDates.sort();
        }
        System.debug('effectiveDates'+effectiveDates);
        String cancelledDate;
        String effectiveDate;
        Integer getRecordIndex = 0;
        Integer count = 0;
        String statusCode;
        List<String> tempSplitDate;
        String splitDateStr;
        do{              
           if(!effectiveDates.isEmpty()) {
               effectiveDate = effectiveDates.get(getRecordIndex);
               splitDateStr = finalizedDateMap.containsKey(effectiveDate) ? finalizedDateMap.get(effectiveDate): dateMap.get(effectiveDate);
               if(splitDateStr.contains('@')) {
                   tempSplitDate = new List<String>(splitDateStr.split('@'));
                   cancelledDate = tempSplitDate[0];
                   statusCode =  tempSplitDate[1];
               }
               if(dateMap.containsKey(String.valueOf(Date.valueOf(cancelledDate).addDays(1)))){
                    getRecordIndex = effectiveDates.indexOf(effectiveDate)+1;
                    splitDateStr = dateMap.get(String.valueOf(Date.valueOf(cancelledDate).addDays(1)));
                    if(splitDateStr.contains('@')) {
                        tempSplitDate = new List<String>(splitDateStr.split('@'));
                        cancelledDate = tempSplitDate[0];
                        statusCode =  tempSplitDate[1];
                    }
                    finalizedDateMap.put(effectiveDate, cancelledDate+'@'+statusCode);
                    System.debug('finalizedDateMap' +finalizedDateMap);
               }else{
                    finalizedDateMap.put(effectiveDate, cancelledDate+'@'+statusCode); 
                    }
                    getRecordIndex++;
                    count++;
               }
            }while(count < dateMap.size() && getRecordIndex < effectiveDates.size());
           return finalizedDateMap;
    }
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        
        try{
            GetRequestBody();
            RequestBody = RequestBody.replace('"pageNumber": ""','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"startRecord": ""','"startRecord": "' + startRecord + '"');
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                oACETWSCalloutResult = ParseSuccessResponse(Response);
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in Find Agreements Providers. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug(LoggingLevel.INFO, 'oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
}