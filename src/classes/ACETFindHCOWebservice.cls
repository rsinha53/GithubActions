public class ACETFindHCOWebservice extends ACETWebservice {
    
    public String providerType;
    public String specialityCheck;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public string NetworkId2;    
    public string attSet2;
    public string adrattSet;
    public string network;
    public string isLookupflow1;
	public Boolean isDDP; 
    
	 public void Init(String ProviderId, String NPI, String TIN, String LastName, String SpecialtyTypeCode, String PostalPrefixCode, 
        String Distance, String City, String StateCode, String PhoneNumber,String NetworkId,String BenefitServiceArea,String contractClaimType,String ServiceAreaType,String ProviderType, String PFS,String FilterByStatus,String attributelist,String isLookupflow) {
       			 Init( ProviderId,  NPI,   TIN,   LastName,   SpecialtyTypeCode,   PostalPrefixCode, 
          Distance,   City,   StateCode,   PhoneNumber,  NetworkId,  BenefitServiceArea,  contractClaimType,  ServiceAreaType,  ProviderType,   PFS,  FilterByStatus,  attributelist,  isLookupflow,false);
        
            
        }
    public void Init(String ProviderId, String NPI, String TIN, String LastName, String SpecialtyTypeCode, String PostalPrefixCode, 
       String Distance, String City, String StateCode, String PhoneNumber,String NetworkId,String BenefitServiceArea,String contractClaimType,String ServiceAreaType,String ProviderType, String PFS,String FilterByStatus,String attributelist,String isLookupflow,Boolean isDDP) {
        this.NetworkId2 = NetworkId;
        NetworkId = 'strFormatIssue';
        this.attSet2 = attributelist;
        attributelist = 'strFormatIssue2';
		isLookupflow1 = isLookupflow;
        system.debug(LoggingLevel.INFO, 'Provider Id: ' + ProviderId + ', NPI: ' + NPI + ', TIN: ' + TIN + ', Last Name: ' + LastName);
        system.debug(LoggingLevel.INFO, 'Specialty Type Code: ' + SpecialtyTypeCode + ', Postal Prefix Code: ' + PostalPrefixCode + ', Distance: ' + Distance);
        //system.debug(LoggingLevel.INFO, 'City: ' + City + ', State Code: ' + StateCode + ', Phone Number: ' + PhoneNumber + ', Provider Type: ' + ProviderType+ ', Network Id: ' + NetworkId + ', BenefitServiceArea: ' + BenefitServiceArea + ', ServiceAreaType: ' + ServiceAreaType);
        //system.debug(LoggingLevel.INFO, 'Network Schedule: ' + NetworkSchedule + ', Network Benefit Plan: ' + NetworkBenefitPlan);
        ProviderId = String.isNotBlank(ProviderId) ? ProviderId : '';
        NPI = String.isNotBlank(NPI) ? NPI : '';
        TIN = String.isNotBlank(TIN) ? TIN : '';
        SpecialtyTypeCode = String.isNotBlank(SpecialtyTypeCode) ? SpecialtyTypeCode : '';
        PostalPrefixCode = String.isNotBlank(PostalPrefixCode) ? PostalPrefixCode : '';
        Distance = String.isNotBlank(Distance) ? Distance : '';
        StateCode = String.isNotBlank(StateCode) ? StateCode : '';
        PFS = String.isNotBlank(PFS) ? PFS: '';
        //NetworkSchedule = String.isNotBlank(NetworkSchedule) ? NetworkSchedule : '';
        //NetworkBenefitPlan = String.isNotBlank(NetworkBenefitPlan) ? NetworkBenefitPlan : '';
        NetworkId = String.isNotBlank(NetworkId) ? NetworkId : '';
        BenefitServiceArea = String.isNotBlank(BenefitServiceArea) ? BenefitServiceArea : '';
        contractClaimType = String.isNotBlank(contractClaimType) ? contractClaimType : '';
        ServiceAreaType = String.isNotBlank(ServiceAreaType) ? ServiceAreaType : '';
        system.debug('Service Area Type----'+ ServiceAreaType);
        ProviderType = String.isNotBlank(ProviderType) ? ProviderType : '';
        network = String.isNotBlank(network) ? network : '';
        this.providerType = ProviderType;
        String AreaCode, Phone, PhoneTypeCode,providerTINStatusCode, npiStatusCode, addressStatusCode,providerStatusCode,specialtyStatusCode,addressTypeCode;
        AreaCode = '';
        Phone = '';
        PhoneTypeCode = '';
        providerTINStatusCode = '';
        npiStatusCode = '';
        addressStatusCode = '';
        providerStatusCode = '';
        specialtyStatusCode = '';
		addressTypeCode = ''; 
        if(String.isNotBlank(PhoneNumber)) {
            AreaCode = PhoneNumber.substring(0, 3);
            Phone = PhoneNumber.substring(3, 10);
            PhoneTypeCode = 'TEL';
        }
        if(String.isNotBlank(FilterByStatus)) {
          if(FilterByStatus == 'Active') {      
            providerTINStatusCode = 'A';
            npiStatusCode = 'A';  
            addressStatusCode = 'A';
            providerStatusCode = 'A';
            specialtyStatusCode = 'A'; 
          }else {
             providerTINStatusCode = '';
             npiStatusCode = '';
             addressStatusCode = '';
             providerStatusCode = '';
             specialtyStatusCode = '';                 
          }
        }
		 if(isLookupflow1 =='true') {
           addressTypeCode = 'PRAC';
        }else {
            addressTypeCode = '';
        }
        system.debug(LoggingLevel.INFO, 'AreaCode: ' + AreaCode + ', Phone: ' + Phone + ', Phone Type Code: ' + PhoneTypeCode+', providerTINStatusCode: ' + providerTINStatusCode+', npiStatusCode: ' + npiStatusCode+', PFSVal***: ' + PFS+', providerStatusCode: ' + providerStatusCode+',specialtyStatusCode:'+specialtyStatusCode+',addressStatusCode:'+addressStatusCode);
        LastName = String.isNotBlank(LastName) ? LastName.toUpperCase() : '';
        City = String.isNotBlank(City) ? City.toUpperCase() : '';
        RequestParameters = new List<String>{ProviderId, NPI, TIN, LastName, SpecialtyTypeCode, PostalPrefixCode, 
            Distance, City, StateCode, PhoneTypeCode, AreaCode, Phone,NetworkId,BenefitServiceArea,contractClaimType,ServiceAreaType,PFS,providerTINStatusCode,npiStatusCode,addressStatusCode,providerStatusCode,specialtyStatusCode,attributelist,addressTypeCode,network};
        this.specialityCheck = SpecialtyTypeCode;
         mapTaxonomyMDT = ACETProviderUtility.getProviderTaxonomy();
		 this.isDDP = isDDP;
    }
    
    public override void GetEndpoint()
    {
         GetEndpointDetail('findHCOEndpoint');
    }
    public ACETFindHCOWebservice() {
        super('Stargate');
    }
   private void GetRequestBody() {
       RequestBody = GetRequestBody('ACETFindMedicalHCORequestJSON', RequestParameters);
       if (test.isRunningTest())  {
           RequestBody =  '{"findMedicalHealthcareOrganizationsRequest":{"providerId":"","providerStatusCode":"","npi":"","npiStatusCode":"","providerTIN":"060871419","providerTINStatusCode":"","providerTINOwnerIndicator":"","medicaidId":"","medicaidIdStatusCode":"","medicareId":"","medicareIdStatusCode":"","providerName":"","hcoTypeCode":"","specialtyTypeCode":"","primarySpecialtyIndicator":"","specialtyStatusCode":"","addressTypeCode":"","primaryAddressIndicator":"","addressStatusCode":"","addressPostalPrefixCode":"","addressPostalSuffixCode":"","addressDistance":"","addressCity":"","addressStateCode":"","addressCountyDescription":"","phoneTypeCode":[],"phoneStatusCode":"","primaryPhoneIndicator":"","phoneCountryCode":"","phoneAreaCode":"","phoneNumber":"","networkId":["strFormatIssue"],"businessSegmentCode":[],"benefitServiceArea":"OXFORD_TRI_STATE","contractClaimType":"Medical","serviceAreaType":"In/Out Of Srvc Area","contractStatusCode":"","acceptingNewPatientIndicator":"","acceptingExistingPatientIndicator":"","pagination":{"pageNumber":"0","pageSize":"50","startRecord":"0"}}}';
        }
        
        string tmpNetworkId ='[';
        if(this.NetworkId2 != null && this.NetworkId2 != ''){
            for(string s : this.NetworkId2.split('@')){
                if(tmpNetworkId == '['){
                    tmpNetworkId = tmpNetworkId + '"'+s+'"';                
                }else{
                    tmpNetworkId = tmpNetworkId + ',"'+s+'"';
                }
            }
        }
        
        tmpNetworkId = tmpNetworkId + ']';
        attSet2 =  '["key","hco","tax","tpsms","specialties","address","phones","electronicCommunications","labTypes","qualityTiers"]';  
        adrattSet = '["key","hco","tax","address"]';
        RequestBody = RequestBody.replace('["strFormataddress"]',adrattSet);
        RequestBody = RequestBody.replace('["strFormatIssue"]',tmpNetworkId);
        RequestBody = RequestBody.replace('["strFormatIssue2"]',attSet2);                 
    }
    
    private ACETWSCalloutResult ParseSuccessResponse(HttpResponse Response) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindHCOJSON2Apex.medicalHealthcareOrganizations> SRProviders;
        ACETOILPagination Pagination;
        
        ACETFindHCOJSON2Apex ACETJSON2Apex = (ACETFindHCOJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCOJSON2Apex.class);
        system.debug(LoggingLevel.INFO, 'ACETFindHCOWebservice. ACETJSON2Apex : ' + ACETJSON2Apex);
        if (ACETJSON2Apex.findMedicalHealthcareOrganizationsResponse.errors == null) {
            Pagination = ACETJSON2Apex.findMedicalHealthcareOrganizationsResponse.pagination;
            if (Integer.valueOf(Pagination.totalCount) > 0) {
                oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                oACETWSCalloutResult.pageSize = Pagination.pageSize;
                oACETWSCalloutResult.recordCount = Pagination.recordCount;
                oACETWSCalloutResult.totalCount = Pagination.totalCount;
                oACETWSCalloutResult.totalPages = Pagination.totalPages;
                SRProviders = ACETJSON2Apex.findMedicalHealthcareOrganizationsResponse.medicalHealthcareOrganizations;
                system.debug(LoggingLevel.INFO, 'SRProviders' + SRProviders);
                if(SRProviders != null && !SRProviders.isEmpty()){
                    for (ACETFindHCOJSON2Apex.medicalHealthcareOrganizations SRProvider: SRProviders) {
                        if(SRProvider != null){
                            provider = new ACETProviderLookupController.ProviderLookupResult();
                            Provider.radious = String.isNotBlank(SRProvider.address.distance) ? SRProvider.address.distance : '';                        
                            Provider.fullName = String.isNotBlank(SRProvider.hco.providerName) ? SRProvider.hco.providerName : '';
                            Provider.providerId = String.isNotBlank(SRProvider.hco.providerId) ? SRProvider.hco.providerId : ''; 
                            Provider.TaxId = String.isNotBlank(SRProvider.providerTIN.Id) ? SRProvider.providerTIN.Id : ''; 
                            Provider.providerTINTypeCode= String.isNotBlank(SRProvider.providerTIN.typeCode) ? SRProvider.providerTIN.typeCode : '';
                            Provider.addressId = String.isNotBlank(SRProvider.address.addressId) ? SRProvider.address.addressId : '';
                            Provider.addressTypeCode = String.isNotBlank(SRProvider.address.typeCode) ? SRProvider.address.typeCode : '';
                            Provider.providerType = String.isNotBlank(providerType) ? providerType : '';
                            Provider.addressLine1 = String.isNotBlank(SRProvider.address.addressLine1) ? SRProvider.address.addressLine1 : '';
                            Provider.addressLine2 = String.isNotBlank(SRProvider.address.addressLine2) ? SRProvider.address.addressLine2 : '';
                            Provider.city = String.isNotBlank(SRProvider.address.city) ? SRProvider.address.city : '';
                            Provider.state = String.isNotBlank(SRProvider.address.stateCode) ? SRProvider.address.stateCode : '';
                            provider.zipcode = String.isNotBlank(SRProvider.address.postalPrefixCode) ? SRProvider.address.postalPrefixCode : '';
                            Provider.addressId = String.isNotBlank(SRProvider.address.addressId) ? SRProvider.address.addressId : '';
                            Provider.County = String.isNotBlank(SRProvider.address.countyDescription) ? SRProvider.address.countyDescription : '';
                            Provider.Email = '';
                            Provider.addressStatusCode = String.isNotBlank(SRProvider.address.statusCode) ? SRProvider.address.statusCode : '';
                             
                            /**if(Provider.addressTypeCode == 'PRAC')
                            Provider.addressTypeCode = 'Practice';
                            else if (Provider.addressTypeCode== 'BILL')
                            Provider.addressTypeCode = 'Billing'; */
                            if (SRProvider.electronicCommunication != null && !SRProvider.electronicCommunication.isEmpty()) {
                                for(ACETFindHCOJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication) {
                                    if (electronicCommunication.communicationTypeCode == 'EMAIL') {
                                        Provider.Email = electronicCommunication.message;
                                    }
                                }
                            }
                            if(SRProvider.address != null){
                                Provider.addressLine1 = Provider.address = String.isNotBlank(SRProvider.address.addressLine1) ? SRProvider.address.addressLine1 : '';
                                if (String.isNotBlank(SRProvider.address.addressLine2)) {
                                    Provider.address += ' ' + SRProvider.address.addressLine2;
                                }
                                if (String.isNotBlank(SRProvider.address.city)) {
                                    Provider.address += ' ' + SRProvider.address.city;
                                }
                                if (String.isNotBlank(SRProvider.address.stateCode)) {
                                    Provider.address += ' ' + SRProvider.address.stateCode;
                                }
                                if (String.isNotBlank(SRProvider.address.postalPrefixCode)) {
                                    Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                                }
                            }
                            Provider.phoneNumber = '';
                            Provider.Fax = '';
                            if (SRProvider.phone != null && !SRProvider.phone.isEmpty()) {
                                for (ACETFindHCOJSON2Apex.phone phone :SRProvider.phone) {
                                    if (phone.primaryPhoneIndicator == 'Y') {
                                        if (phone.phoneTypeCode == 'TEL') {
                                            Provider.phoneNumber = '(' + phone.areaCode + ')';
                                            Provider.phoneNumber += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                            Provider.phoneNumber += phone.phoneNumber.substring(3);
                                     }
                                 }
                                 if (phone.phoneTypeCode == 'FAX') {
                                    Provider.Fax = '(' + phone.areaCode + ')';
                                    Provider.Fax += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                    Provider.Fax += phone.phoneNumber.substring(3);
                                 }
                            }
                        }                   
                            Provider.speciality = '';
                            if (String.isNotBlank(specialityCheck)) {  
                                if (String.isNotBlank(specialityCheck))  {
                                    Provider.speciality = (mapTaxonomyMDT.get(specialityCheck).Speciality__c != null) ? mapTaxonomyMDT.get(specialityCheck).Speciality__c : specialityCheck;
                                }
                            } else {
                                for (ACETFindHCOJSON2Apex.Specialty Specialty :SRProvider.Specialty) {
                                    if(Specialty.primarySpecialtyIndicator == 'Y') {
                                        if(String.isNotBlank(Specialty.typeDescription)) {
                                            Provider.speciality = Specialty.typeDescription;
                                        }
                                    }
                                }                        
                            }
                            Provider.platinum = '';
                            if (SRProvider.Tpsm != null && !SRProvider.Tpsm.isEmpty()) {
                                for (ACETFindHCOJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
                                    if (platinum != null) {
                                        if (platinum.code == '99Z') {
                                            Provider.platinum = 'No';                                        
                                        } else if (String.isBlank(platinum.code)) {
                                            Provider.platinum = '';
                                        } else {
                                            Provider.platinum = 'Yes - ' +  platinum.code;   
                                        }
                                    }
                                }    
                            }
                                     Provider.qualityBenefitTier = 'No';
                            system.debug('qualityTiers'+SRProvider.qualityTiers);
                           if(SRProvider.qualityTiers!=null && !SRProvider.qualityTiers.isEmpty()){
                              for(ACETFindHCOJSON2Apex.qualityTier qt: SRProvider.qualityTiers){
                                  if(qt.level == '1'){
                                      Provider.qualityBenefitTier = 'Yes';
                                      break;
                                  }
                              }
                          }
                            
                            if(SRProvider.labTypes!=null && !SRProvider.labTypes.isEmpty()){
                          String labTypeStr = '';
							Provider.labTypes = new List<ACETProviderLookupController.labType>();																		 
                          for(ACETFindHCOJSON2Apex.labType lb:SRProvider.labTypes){
                              system.debug('labType effective Date'+lb.effectiveDate);
                              system.debug('labType calcel Date'+lb.cancelDate);
                              system.debug('labType today date '+Date.today());
                              Date labTypeEffectiveDate = String.isNotBlank(lb.effectiveDate) ? Date.valueOf(lb.effectiveDate) : null;
                              Date labTypeCancelDt = String.isNotBlank(lb.cancelDate) ? Date.valueOf(lb.cancelDate) : null;
                              if(labTypeEffectiveDate != null && labTypeCancelDt != null && Date.today() <= labTypeCancelDt && Date.today() >= labTypeEffectiveDate) {
                                  system.debug('labType Date condition matched');
                                  if(lb.code != null && lb.statusCode == 'A'){
                                      if(labTypeStr == ''){
                                            labTypeStr = lb.code;      
                                      }else{
                                          labTypeStr = labTypeStr+'-'+lb.code;
                                      }
									  
									  ACETProviderLookupController.labType lbt = new ACETProviderLookupController.labType();
                                      lbt.code = lb.code;
                                      lbt.description = lb.description;
                                      Provider.labTypes.add(lbt);
                              }
                              	
                              }
                              
                          }
                          Provider.labTypeCode = labTypeStr;
                          }

                            if(this.isDDP != NULL && this.isDDP){
                                   if(SRProvider.labTypes!=null && !SRProvider.labTypes.isEmpty() && SRProvider.labTypes[0].code != null){
                                     	Providers.add(Provider);
                                   }
                             }else{
                                 Providers.add(Provider);
                             }
                        }
                    }
                }
				 if(this.isDDP != NULL && this.isDDP && Providers.size() > 0 ){
                    system.debug('Providers size'+Providers.size());
                    Decimal pageSize = Decimal.valueOf(Pagination.pageSize);
                    Decimal pageSz = Providers.size()/pageSize;
                    oACETWSCalloutResult.pageSize = String.valueOf(pageSz.round(SYSTEM.RoundingMode.CEILING));
                    oACETWSCalloutResult.totalCount =String.valueOf(Providers.size());
                }									 
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Providers;
            }
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.findMedicalHealthcareOrganizationsResponse.errors);
            oACETWSCalloutResult.Message = oACETWSCalloutResult.Message == Label.OILNoRecordErrorMessage ? Label.ACETNoRecordErrorMessage : oACETWSCalloutResult.Message;
            oACETWSCalloutResult.Response = null;
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
        }
        return oACETWSCalloutResult;
    }   
     
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        
        try
        {
            RequestParameters.AddAll(new List<String>{String.valueOf(pageNumber), String.valueOf(PageSize), String.valueOf(startRecord)});
            GetRequestBody();
            HttpResponse Response = Send(OAuthConfig);
			if(Test.isRunningTest()){
                Response.setHeader('Content-Type', 'application/json');
                 String findHCPAdapterJSONR = '{"findMedicalHealthcareOrganizationsResponse":{"medicalHealthcareOrganizations":[{"key":{"providerId":"112146172317638062","providerTINId":"810477845","providerTINTypeCode":"TIN","addressId":"311145240310106692","addressTypeCode":"PRAC"},"hco":{"providerId":"112146172317638062","providerName":"GABERT CLINIC","providerStatusCode":"A","providerStatusEffectiveDate":"2005-01-01","providerStatusCancelDate":"9999-12-31","hcoTypeCode":"HCG"},"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"810477845","typeCode":"TIN","owner":"GABERT MEDICAL SERVICES"},"tpsm":[{"statusEffectiveDate":"0001-01-01","statusCancelDate":"0001-01-01"}],"npi":[{"npiStatusCode":"A","effectiveDate":"2006-08-05","cancelDate":"9999-12-31","id":"1336158930","validationDate":"0001-01-01"}],"contract":[{"contractStatusCode":"A","businessSegmentCode":"E&I","networkIds":["1008476"],"contractClaimTypes":["Medical"]}],"specialty":[{"statusCode":"A","effectiveDate":"2007-05-09","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"207Q00000X","typeDescription":"Family Medicine~"}],"address":{"addressLine1":"107 DILWORTH ST","addressLine2": "107 DILWORTH ST","city":"GLENDIVE","latitude":"47.118511","longitude":"-104.704","postalPrefixCode":"59330","postalSuffixCode":"2053","countryCode":"US","countyCode":"021","countyDescription":"Dawson County","stateCode":"MT","addressId":"311145240310106692","typeCode":"PRAC","effectiveDate":"2008-01-01","cancelDate":"9999-12-31","statusCode":"A","primaryIndicator":"Y","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458920"},{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3452229"},{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458930"},{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458910"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}]},{"key":{"providerId":"243245238846421777","providerTINId":"810477845","providerTINTypeCode":"TIN","addressId":"311145240310106692","addressTypeCode":"PRAC"},"hco":{"providerId":"243245238846421777","providerName":"GABERT MEDICAL SERVICES","providerStatusCode":"A","providerStatusEffectiveDate":"1992-08-19","providerStatusCancelDate":"9999-12-31","hcoTypeCode":"HCG"},"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"810477845","typeCode":"TIN","owner":"GABERT MEDICAL SERVICES"},"tpsm":[{"statusEffectiveDate":"0001-01-01","statusCancelDate":"0001-01-01"}],"npi":[{"npiStatusCode":"A","effectiveDate":"2009-02-26","cancelDate":"9999-12-31","id":"1699845461","validationDate":"0001-01-01"}],"contract":[{}],"specialty":[{"statusCode":"A","effectiveDate":"1992-08-19","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"207Q00000X","typeDescription":"Family Medicine~"},{"statusCode":"A","effectiveDate":"2012-01-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"207V00000X","typeDescription":"Obstetrics & Gynecology~"}],"address":{"addressLine1":"107 DILWORTH ST","city":"GLENDIVE","latitude":"47.118511","longitude":"-104.704","postalPrefixCode":"59330","postalSuffixCode":"2053","countryCode":"US","countyCode":"021","countyDescription":"Dawson County","stateCode":"MT","addressId":"311145240310106692","typeCode":"PRAC","effectiveDate":"1989-04-26","cancelDate":"9999-12-31","statusCode":"A","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3658901"},{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458901"}],"electronicCommunication":[{"statusCode":"","message":"abc@test.com","communicationTypeCode":"EMAIL"}],"medicare":[{"statusCode":"A","medicareIdEffectiveDate":"1900-01-01","medicareIdCancelDate":"9999-12-31","medicareId":"273411"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}]},{"key":{"providerId":"243245238846421777","providerTINId":"810477845","providerTINTypeCode":"TIN","addressId":"949345240366777735","addressTypeCode":"PRAC"},"hco":{"providerId":"243245238846421777","providerName":"GABERT MEDICAL SERVICES","providerStatusCode":"A","providerStatusEffectiveDate":"1992-08-19","providerStatusCancelDate":"9999-12-31","hcoTypeCode":"HCG"},"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"810477845","typeCode":"TIN","owner":"GABERT MEDICAL SERVICES"},"tpsm":[{"statusEffectiveDate":"0001-01-01","statusCancelDate":"0001-01-01"}],"npi":[{"npiStatusCode":"A","effectiveDate":"2009-02-26","cancelDate":"9999-12-31","id":"1699845461","validationDate":"0001-01-01"}],"contract":[{}],"specialty":[{"statusCode":"A","effectiveDate":"1992-08-19","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"207Q00000X","typeDescription":"Family Medicine~"},{"statusCode":"A","effectiveDate":"2012-01-01","cancelDate":"9999-12-31","primarySpecialtyIndicator":"N","typeCode":"207V00000X","typeDescription":"Obstetrics & Gynecology~"}],"address":{"addressLine1":"202 PROSPECT DR","city":"GLENDIVE","latitude":"47.117333","longitude":"-104.7048","postalPrefixCode":"59330","postalSuffixCode":"1943","countryCode":"US","countyCode":"021","countyDescription":"Dawson County","stateCode":"MT","addressId":"949345240366777735","typeCode":"PRAC","effectiveDate":"2012-01-01","cancelDate":"9999-12-31","statusCode":"A","primaryIndicator":"N","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458901"}],"electronicCommunication":[{}],"medicare":[{"statusCode":"A","medicareIdEffectiveDate":"1900-01-01","medicareIdCancelDate":"9999-12-31","medicareId":"273411"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}]},{"key":{"providerId":"127046173210213466","providerTINId":"810477845","providerTINTypeCode":"TIN","addressId":"1452407774425","addressTypeCode":"PRAC"},"hco":{"providerId":"127046173210213466","providerName":"WIBAUX CLINIC","providerStatusCode":"A","providerStatusEffectiveDate":"2008-01-01","providerStatusCancelDate":"9999-12-31","hcoTypeCode":"HCG"},"providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"810477845","typeCode":"TIN","owner":"GABERT MEDICAL SERVICES"},"tpsm":[{"statusEffectiveDate":"0001-01-01","statusCancelDate":"0001-01-01"}],"npi":[{"npiStatusCode":"A","effectiveDate":"2006-08-05","cancelDate":"9999-12-31","id":"1043229776","validationDate":"0001-01-01"}],"contract":[{"contractStatusCode":"A","businessSegmentCode":"E&I","networkIds":["1008476"],"contractClaimTypes":["Medical"]}],"specialty":[{"statusCode":"A","effectiveDate":"2009-03-23","cancelDate":"9999-12-31","primarySpecialtyIndicator":"Y","typeCode":"207Q00000X","typeDescription":"Family Medicine~"}],"address":{"addressLine1":"710 DRAKE ST","city":"WIBAUX","latitude":"46.9861","longitude":"-104.1867","postalPrefixCode":"59353","postalSuffixCode":"9086","countryCode":"US","countyCode":"109","countyDescription":"Wibaux County","stateCode":"MT","addressId":"1452407774425","typeCode":"PRAC","effectiveDate":"2008-01-01","cancelDate":"9999-12-31","statusCode":"A","primaryIndicator":"Y","handicapAccessibleIndicator":"Y"},"phone":[{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3452229"},{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458920"},{"statusCode":"A","primaryPhoneIndicator":"Y","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458930"},{"statusCode":"A","primaryPhoneIndicator":"N","phoneTypeCode":"TEL","phoneCountryCode":"1","areaCode":"406","phoneNumber":"3458910"}],"electronicCommunication":[{}],"medicare":[{"medicareIdEffectiveDate":"0001-01-01","medicareIdCancelDate":"0001-01-01"}],"medicaid":[{"medicaidIdEffectiveDate":"0001-01-01","medicaidIdCancelDate":"0001-01-01"}]}],"pagination":{"pageNumber":"0","pageSize":"50","recordCount":"4","totalCount":"4","totalPages":"1"}}}';
        
                Response.setBody(findHCPAdapterJSONR);
                Response.setStatusCode(200);
            }
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                oACETWSCalloutResult = ParseSuccessResponse(Response);
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Medical Providers. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug(LoggingLevel.INFO, 'oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
    //Webservice method to call findHCP Lookup service
    public ACETWSCalloutResult FindHCO(String TaxId, String NPI, String providerId, String networkType, String LastName, String PhoneNumber, String providerType, 
                                    String FirstName, String city, String specialityType, String language, String state, String radius, String gender,String ZipCode,String NewpatientsInd,String existingpatientsInd, String benefitPlanId, String networkSchedule){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        
        try
        {
            GetEndpoint();
            mapTaxonomyMDT = ACETProviderUtility.getProviderTaxonomy(); 
            providerId = String.isNotBlank(providerId) ? providerId : '';
            NPI = String.isNotBlank(NPI) ? NPI : '';
            TaxId = String.isNotBlank(TaxId) ? TaxId : '';
            LastName = String.isNotBlank(LastName) ? LastName.toUpperCase() : '';
            specialityType = String.isNotBlank(specialityType) ? specialityType : '';
            ZipCode = String.isNotBlank(ZipCode) ? ZipCode : '';
            radius = String.isNotBlank(radius) ? radius : '';
            City = String.isNotBlank(City) ? City.toUpperCase() : '';
            State = String.isNotBlank(State) ? State : '';
            networkType = String.isNotBlank(networkType) ? networkType : '';
            benefitPlanId = String.isNotBlank(benefitPlanId) ? benefitPlanId : '';
            this.specialityCheck = specialityType;
            String AreaCode, Phone, PhoneTypeCode;
            AreaCode = '';
            Phone = '';
            PhoneTypeCode = '';
            if(String.isNotBlank(PhoneNumber)) {
                AreaCode = PhoneNumber.substring(0, 3);
                Phone = PhoneNumber.substring(3, 10);
                PhoneTypeCode = 'TEL';
            }
              string attributelist = '';
              this.adrattSet = attributelist;
              attributelist = 'strFormataddress';
                         
           
            system.debug(LoggingLevel.INFO, 'AreaCode: ' + AreaCode + ', Phone: ' + Phone + ', Phone Type Code: ' + PhoneTypeCode);
            RequestParameters = new List<String>{providerId, NPI, TaxId, LastName, specialityType, ZipCode, radius, City, State, PhoneTypeCode, AreaCode, Phone, networkType, benefitPlanId,'','','','','','','','',attributelist,'','','0','50','0'};    
            GetRequestBody();
            if(String.isNotBlank(specialityType))
                this.specialityCheck = mapTaxonomyMDT.get(specialityType).Speciality__c;            
            HttpResponse Response = Send(OAuthConfig);
            if(Test.isRunningTest()){
                Response.setHeader('Content-Type', 'application/json');
                Response.setBody('{ "findMedicalHealthcareOrganizationsResponse:{ "medicalHealthcareOrganizations":[{ "key":{"providerId":"117945496991462395","providerTINId":"362340413","providerTINTypeCode":"TIN","addressId":"1452423968971","addressTypeCode":"PRAC" }, "hco":{"providerId":"117945496991462395","providerName":"NORTHWEST COMMUNITY HOSPITAL","providerStatusCode":"A","providerStatusEffectiveDate":"1996-08-20","providerStatusCancelDate":"9999-12-31","hcoTypeCode":"HCF" }, "providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"362340413","typeCode":"TIN","owner":"NORTHWEST COMMUNITY HOSPITAL" }, "tpsm":[{ "statusCode":"A", "statusEffectiveDate":"2016-01-01", "statusCancelDate":"9999-12-31", "code":"306", "description":""} ], "npi":[{ "npiStatusCode":"A", "effectiveDate":"2007-07-25", "cancelDate":"9999-12-31", "id":"1467652669", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2015-03-09", "cancelDate":"9999-12-31", "id":"1053704577", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-02-20", "cancelDate":"9999-12-31", "id":"1457318701", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2006-12-01", "cancelDate":"9999-12-31", "id":"1770531600", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-11-14", "cancelDate":"9999-12-31", "id":"1609057082", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2011-06-10", "cancelDate":"9999-12-31", "id":"1619270089", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-04-23", "cancelDate":"9999-12-31", "id":"1932327137", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-02-20", "cancelDate":"9999-12-31", "id":"1528026168", "validationDate":"0001-01-01"} ], "contract":[{ "contractStatusCode":"A", "businessSegmentCode":"E&I"} ], "specialty":[{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"281P00000X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"284300000X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"282NW0100X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"282NC0060X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"Y", "typeCode":"282N00000X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"282NR1301X", "typeDescription":""} ], "address":{"addressLine1":"1632 W CENTRAL RD","addressLine2":"1632 W CENTRAL RD","city":"ARLINGTON HEIGHTS","latitude":"17.746289","longitude":"-64.707256","postalPrefixCode":"60005","postalSuffixCode":"2407","countryCode":"US","countryDescription":"","countyCode":"127","countyDescription":"US","stateCode":"IL","addressId":"1452423968971","typeCode":"PRAC","effectiveDate":"1996-08-20","cancelDate":"9999-12-31","statusCode":"A","primaryIndicator":"N","distance":"","handicapAccessibleIndicator":"Y" }, "phone":[{ "statusCode":"A", "primaryPhoneIndicator":"N", "phoneTypeCode":"FAX", "phoneCountryCode":"1", "areaCode":"847", "phoneNumber":"6183719", "phoneExtensionNumber":""},{ "statusCode":"A", "primaryPhoneIndicator":"Y", "phoneTypeCode":"TEL", "phoneCountryCode":"1", "areaCode":"847", "phoneNumber":"2538050", "phoneExtensionNumber":""} ], "electronicCommunication":[{ "statusCode":"", "message":"abc@test.com", "communicationTypeCode":"EMAIL"} ], "medicare":[{ "statusCode":"A", "medicareIdEffectiveDate":"1900-01-01", "medicareIdCancelDate":"9999-12-31", "medicareId":"140252"},{ "statusCode":"A", "medicareIdEffectiveDate":"1900-01-01", "medicareIdCancelDate":"9999-12-31", "medicareId":"147094"} ], "medicaid":[{ "statusCode":"", "medicaidIdEffectiveDate":"0001-01-01", "medicaidIdCancelDate":"0001-01-01", "medicaidId":"", "issuingStateProvinceCode":""} ]},{ "key":{"providerId":"117945496991462395","providerTINId":"362340413","providerTINTypeCode":"TIN","addressId":"1452423968972","addressTypeCode":"PRAC" }, "hco":{"providerId":"117945496991462395","providerName":"NORTHWEST COMMUNITY HOSPITAL","providerStatusCode":"A","providerStatusEffectiveDate":"1996-08-20","providerStatusCancelDate":"9999-12-31","hcoTypeCode":"HCF" }, "providerTIN":{"statusCode":"A","effectiveDate":"0001-01-01","cancelDate":"9999-12-31","id":"362340413","typeCode":"TIN","owner":"NORTHWEST COMMUNITY HOSPITAL" }, "tpsm":[{ "statusCode":"A", "statusEffectiveDate":"2016-01-01", "statusCancelDate":"9999-12-31", "code":"306", "description":""} ], "npi":[{ "npiStatusCode":"A", "effectiveDate":"2007-07-25", "cancelDate":"9999-12-31", "id":"1467652669", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2015-03-09", "cancelDate":"9999-12-31", "id":"1053704577", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-02-20", "cancelDate":"9999-12-31", "id":"1457318701", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2006-12-01", "cancelDate":"9999-12-31", "id":"1770531600", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-11-14", "cancelDate":"9999-12-31", "id":"1609057082", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2011-06-10", "cancelDate":"9999-12-31", "id":"1619270089", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-04-23", "cancelDate":"9999-12-31", "id":"1932327137", "validationDate":"0001-01-01"},{ "npiStatusCode":"A", "effectiveDate":"2007-02-20", "cancelDate":"9999-12-31", "id":"1528026168", "validationDate":"0001-01-01"} ], "contract":[{ "contractStatusCode":"A", "businessSegmentCode":"E&I"} ], "specialty":[{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"281P00000X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"284300000X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"282NW0100X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"282NC0060X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"Y", "typeCode":"282N00000X", "typeDescription":""},{ "statusCode":"A", "effectiveDate":"1996-08-20", "cancelDate":"9999-12-31", "primarySpecialtyIndicator":"N", "typeCode":"282NR1301X", "typeDescription":""} ], "address":{"addressLine1":"15 S MCHENRY RD","addressLine2":"","city":"BUFFALO GROVE","latitude":"17.746289","longitude":"-64.707256","postalPrefixCode":"60089","postalSuffixCode":"6705","countryCode":"US","countryDescription":"","countyCode":"128","countyDescription":"","stateCode":"IL","addressId":"1452423968972","typeCode":"PRAC","effectiveDate":"1996-08-20","cancelDate":"9999-12-31","statusCode":"A","primaryIndicator":"N","distance":"","handicapAccessibleIndicator":"N" }, "phone":[{ "statusCode":"A", "primaryPhoneIndicator":"N", "phoneTypeCode":"FAX", "phoneCountryCode":"1", "areaCode":"847", "phoneNumber":"6183719", "phoneExtensionNumber":""},{ "statusCode":"A", "primaryPhoneIndicator":"Y", "phoneTypeCode":"TEL", "phoneCountryCode":"1", "areaCode":"847", "phoneNumber":"4596100", "phoneExtensionNumber":""} ], "electronicCommunication":[{ "statusCode":"", "message":"", "communicationTypeCode":""} ], "medicare":[{ "statusCode":"A", "medicareIdEffectiveDate":"1900-01-01", "medicareIdCancelDate":"9999-12-31", "medicareId":"140252"},{ "statusCode":"A", "medicareIdEffectiveDate":"1900-01-01", "medicareIdCancelDate":"9999-12-31", "medicareId":"147094"} ], "medicaid":[{ "statusCode":"", "medicaidIdEffectiveDate":"0001-01-01", "medicaidIdCancelDate":"0001-01-01", "medicaidId":"", "issuingStateProvinceCode":""} ]} ], "pagination":{"pageNumber":"0","pageSize":"2","recordCount":"2","totalCount":"6","totalPages":"3" }}}');
                Response.setStatusCode(200);
            }
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                oACETWSCalloutResult = ParseSuccessResponse(Response);
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Medical Providers. Details: ' + ex); 
            System.debug(LoggingLevel.INFO, 'getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug(LoggingLevel.INFO, 'oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
}