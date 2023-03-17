public class ACETFindProviderLookupWebservice extends ACETWebservice {
    public String providerType;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public string NetworkId2;
    public string isLookupflow1;
    public string attSet2;  
    private String specialityCheck;
    public String addressCheck;
    public String network;
    public String qualityTierLevelGlobal;
	public Boolean isDDP;
    
    public void Init(String ProviderId, String NPI, String TIN, String LastName, String FirstName, String GenderCode, 
                     String SpecialtyTypeCode,String searchPcpOBGYNId,String PostalPrefixCode, String Distance, String City, String StateCode,
                     String PhoneNumber,String NetworkId,String BenefitServiceArea,String ServiceAreaType,String contractClaimType,String NewPatientIndicator, String ExistingPatientIndicator, 
                     String LanguageCode, String ProviderTypeCode,String attributelist, String isLookupflow,String FilterByStatus,String PFS) {
                         Init(ProviderId,  NPI,  TIN,  LastName,  FirstName,  GenderCode, 
                              SpecialtyTypeCode, searchPcpOBGYNId, PostalPrefixCode,  Distance,  City,  StateCode,
                              PhoneNumber, NetworkId, null, null, BenefitServiceArea, ServiceAreaType, contractClaimType, NewPatientIndicator,  ExistingPatientIndicator, 
                              LanguageCode,  ProviderTypeCode, attributelist,  isLookupflow, FilterByStatus, PFS, false);   
                     }
    
    public void Init(String ProviderId, String NPI, String TIN, String LastName, String FirstName, String GenderCode, 
                     String SpecialtyTypeCode,String searchPcpOBGYNId,String PostalPrefixCode, String Distance, String City, String StateCode,
                     String PhoneNumber,String NetworkId,String qualityProviderRuleId,String qualityRuleLevel,String BenefitServiceArea,String ServiceAreaType,String contractClaimType,String NewPatientIndicator, String ExistingPatientIndicator, 
                     String LanguageCode, String ProviderTypeCode,String attributelist, String isLookupflow,String FilterByStatus,String PFS,Boolean isDDP) {
                         this.NetworkId2 = NetworkId;
                         NetworkId = 'strFormatIssue';
                         this.attSet2 = attributelist;
                         attributelist = 'strFormatIssue2';
                         isLookupflow1 = isLookupflow;
                         //system.debug(LoggingLevel.INFO, 'Provider Id: ' + ProviderId + ', NPI: ' + NPI + ', TIN: ' + TIN);
                         //system.debug(LoggingLevel.INFO, 'Last Name: ' + LastName + ', First Name: ' + FirstName + ', Gender Code: ' + GenderCode);
                         //system.debug(LoggingLevel.INFO, 'Specialty Type Code: ' + SpecialtyTypeCode + ', Postal Prefix Code: ' + PostalPrefixCode + ', Distance: ' + Distance);
                         //system.debug(LoggingLevel.INFO, 'City: ' + City + ', State Code Issue: ' + StateCode + ', Phone Number: ' + PhoneNumber);
                         //system.debug(LoggingLevel.INFO, 'Network Schedule: ' + NetworkSchedule + ', Network Benefit Plan: ' + NetworkBenefitPlan + ', New Patient Indicator: ' + NewPatientIndicator);
                         //system.debug(LoggingLevel.INFO, 'Existing Patient Indicator: ' + ExistingPatientIndicator + ', Language Code: ' + LanguageCode + ', Provider Type Code: ' + ProviderTypeCode);
                         //system.debug(LoggingLevel.INFO, 'tax** Id: ' + TIN + ', State****: ' + StateCode);
                         ProviderId = String.isNotBlank(ProviderId) ? ProviderId : '';
                         NPI = String.isNotBlank(NPI) ? NPI : '';
                         TIN = String.isNotBlank(TIN) ? TIN : '';
                         GenderCode = String.isNotBlank(GenderCode) ? GenderCode : '';
                         SpecialtyTypeCode = String.isNotBlank(SpecialtyTypeCode) ? SpecialtyTypeCode : '';
                         searchPcpOBGYNId = String.isNotBlank(searchPcpOBGYNId ) ? searchPcpOBGYNId : '';
                         PostalPrefixCode = String.isNotBlank(PostalPrefixCode) ? PostalPrefixCode : '';
                         Distance = String.isNotBlank(Distance) ? Distance : '';
                         StateCode = String.isNotBlank(StateCode) ? StateCode : '';
                         //NetworkSchedule = String.isNotBlank(NetworkSchedule) ? NetworkSchedule : '';
                         //NetworkBenefitPlan = String.isNotBlank(NetworkBenefitPlan) ? NetworkBenefitPlan : '';
                         NetworkId = String.isNotBlank(NetworkId) ? NetworkId : '';
                         qualityProviderRuleId = String.isNotBlank(qualityProviderRuleId) ? qualityProviderRuleId : '';
                         qualityRuleLevel = String.isNotBlank(qualityRuleLevel) ? '1' : '';
                         qualityTierLevelGlobal = qualityRuleLevel;
                         BenefitServiceArea = String.isNotBlank(BenefitServiceArea) ? BenefitServiceArea : '';
                         ServiceAreaType = String.isNotBlank(ServiceAreaType) ? ServiceAreaType : '';
                         contractClaimType = String.isNotBlank(contractClaimType) ? contractClaimType : '';
                         NewPatientIndicator = String.isNotBlank(NewPatientIndicator) ? NewPatientIndicator : '';
                         ExistingPatientIndicator = String.isNotBlank(ExistingPatientIndicator) ? ExistingPatientIndicator : '';
                         PFS = String.isNotBlank(PFS ) ? PFS : '';
                         LanguageCode = String.isNotBlank(LanguageCode) ? LanguageCode : '';
                         ProviderTypeCode = String.isNotBlank(ProviderTypeCode) ? ProviderTypeCode : '';
                         network = String.isNotBlank(network) ? 'A' : '';
                         String AreaCode, Phone, PhoneTypeCode, providerTINStatusCode, npiStatusCode, addressStatusCode,providerStatusCode,addressTypeCode;
                         AreaCode = '';
                         Phone = '';
                         PhoneTypeCode = '';
                         providerTINStatusCode = '';
                         npiStatusCode = '';
                         addressStatusCode = '';
                         providerStatusCode = '';
                         addressTypeCode = '';
                         if(String.isNotBlank(PhoneNumber)) {
                             AreaCode = PhoneNumber.substring(0, 3);
                             Phone = PhoneNumber.substring(3, 10);
                             PhoneTypeCode = 'TEL';
                         }
                         if(String.isNotBlank(FilterByStatus)) {
                             if(FilterByStatus == 'Active') {
                                 if(isLookupflow1 == 'false') {
                                    providerTINStatusCode = 'A';
                                    npiStatusCode = 'A';  
                                    addressStatusCode = 'A';
                                 }else {
                                  providerTINStatusCode = 'A';
                                  npiStatusCode = 'A';  
                                  addressStatusCode = 'A';
                                  providerStatusCode = 'A';
                              }
                            }else {
                                  providerTINStatusCode = '';
                                  npiStatusCode = '';
                                  addressStatusCode = '';
                                  providerStatusCode = '';
                              }
                               }
                         system.debug(LoggingLevel.INFO, 'AreaCode: ' + AreaCode + ', Phone: ' + Phone + ', Phone Type Code: ' + PhoneTypeCode+', providerTINStatusCode: ' + providerTINStatusCode+', npiStatusCode: ' + npiStatusCode+', PFSVal***: ' + PFS+', providerStatusCode: ' + providerStatusCode+',addressStatusCode:'+addressStatusCode);
                         LastName = String.isNotBlank(LastName) ? LastName.toUpperCase() : '';
                         FirstName = String.isNotBlank(FirstName) ? FirstName.toUpperCase() : '';
                         City = String.isNotBlank(City) ? City.toUpperCase() : '';
                         GenderCode = GenderCode == 'Male' ? 'M' : GenderCode == 'Female' ? 'F' : '';
                         this.addressCheck = addressTypeCode;
                         addressTypeCode = 'strFormatIssue3';
                         RequestParameters = new List<String>{ProviderId, NPI, TIN, LastName, FirstName, GenderCode, SpecialtyTypeCode,searchPcpOBGYNId,PostalPrefixCode, 
                             Distance, City, StateCode, PhoneTypeCode, AreaCode, Phone,NetworkId,BenefitServiceArea,ServiceAreaType,contractClaimType,NewPatientIndicator, 
                             ExistingPatientIndicator, LanguageCode, ProviderTypeCode,attributelist,providerTINStatusCode,npiStatusCode,addressStatusCode,providerStatusCode,PFS,addressTypeCode,qualityProviderRuleId,qualityRuleLevel,network};
                                 this.specialityCheck = SpecialtyTypeCode;
                         mapTaxonomyMDT = ACETProviderUtility.getProviderTaxonomy();
						 this.isDDP = isDDP;
                     }
    
    public override void GetEndpoint() {
        GetEndpointDetail('findMedicalProviderAdapterEndpoint');
    }
     public ACETFindProviderLookupWebservice() {
        super('Stargate');
    }
    private void GetRequestBody() {        
        RequestBody = GetRequestBody('ACETFindMedicalProvidersRequestJSON', RequestParameters);
        if (test.isRunningTest())  {
            RequestBody =' {"findMedicalProvidersRequest":{"providerId":"","providerStatusCode":"","npi":"","npiStatusCode":"","providerTIN":"","providerTINStatusCode":"","name":"","providerFirstName":"","providerGenderCode":"","providerRoleTypeCode":"","specialtyTypeCode":"","providerLocationAffiliationID":"","primarySpecialityIndicator":"","specialityStatusCode":"","addressTypeCode":[],"primaryAddressIndicator":"","addressStatusCode":"","addressPostalPrefixCode":"","addressPostalSuffixCode":"","addressDistance":"","addressCity":"","addressStateCode":"","addressCountyDescription":"","phoneTypeCode":[""],"phoneStatusCode":"","phoneCountryCode":"","primaryPhoneIndicator":"","phoneAreaCode":"","phoneNumber":"","networkId":[""],"benefitServiceArea":"","serviceAreaType":"","contractClaimType":"","businessSegmentCode":[],"contractStatusCode":"","acceptingNewPatientIndicator":"","acceptingExistingPatientIndicator":"","languageCode":"","providerTypeCode":"","attributeDataSet":"","pagination":{"pageNumber":"","pageSize":"","startRecord":""}}} ';
        }
        system.debug(' :: Request Body :: ' + RequestBody);
        
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
        addressCheck = '["PRAC"]';
        if(isLookupflow1 =='true') {
            attSet2 =  '["tax","tpsms","address","phones","premiumDesignations","roles","specialties","providerLocationAffiliations","qualityTiers","labTypes"]';
        }
        else
        {
            attSet2 =  '["tax","tpsms","address","phones","qualityTiers"]';
        }
        system.debug('NetworkId2'+NetworkId2+'tmpNetworkId'+tmpNetworkId);
        RequestBody = RequestBody.replace('["strFormatIssue2"]',attSet2);
        RequestBody = RequestBody.replace('["strFormatIssue"]',tmpNetworkId);
        RequestBody = RequestBody.replace('["strFormatIssue3"]',addressCheck);
         
    }
    
    
    private ACETWSCalloutResult ParseSuccessResponse(HttpResponse Response) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
       // StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'findMedicalProvider_HardcodedRequest'];
       // String ResponseBody = ResponseJSONSR.Body.toString();  
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        Map<String,ACETProviderLookupController.ProviderLookupResult> locationAffiliationIdMap;
        ACETProviderLookupController.ProviderLookupResult Provider;
        Map<String,String> locationAffiliationMap;
        Map<String,ACETProviderLookupController.ProviderLookupResult> providerLookupResultsMap;
        List<ACETFindMedclProvidrLookupSrvceJSON2Apex.medicalProviders> SRProviders;

        ACETOILPagination Pagination;
        
        ACETFindMedclProvidrLookupSrvceJSON2Apex ACETJSON2Apex = (ACETFindMedclProvidrLookupSrvceJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindMedclProvidrLookupSrvceJSON2Apex.class);
        system.debug(LoggingLevel.INFO, 'ACETFindProviderLookupWS. ACETJSON2Apex:' + ACETJSON2Apex);
        List<ACETFindMedclProvidrLookupSrvceJSON2Apex.providerLocationAffiliations> providerLocationAffiliationDetails;
        if (ACETJSON2Apex.findMedicalProvidersResponse.errors == null) { 
            Pagination = ACETJSON2Apex.findMedicalProvidersResponse.pagination;
            if (Integer.valueOf(Pagination.totalCount) > 0) {
               oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                oACETWSCalloutResult.pageSize = Pagination.pageSize;
                oACETWSCalloutResult.recordCount = Pagination.recordCount;
                oACETWSCalloutResult.totalCount = Pagination.totalCount;
                oACETWSCalloutResult.totalPages = Pagination.totalPages;
                Map<String,UnitedHealth_Premium_Designation__mdt> uphdMap = new Map<String,UnitedHealth_Premium_Designation__mdt>();
                for(UnitedHealth_Premium_Designation__mdt uphd:[
                                SELECT Id, Designation__c,Efficiency_Code__c,Quality_Code__c
                                FROM UnitedHealth_Premium_Designation__mdt 
                ]){
                    uphdMap.put(uphd.Efficiency_Code__c+'----'+uphd.Quality_Code__c,uphd);
                }
                SRProviders = ACETJSON2Apex.findMedicalProvidersResponse.medicalProviders;
                system.debug(LoggingLevel.INFO, 'ACETFindProviderLookupWS. SRProviders: ' + SRProviders);
                if(SRProviders !=null && !SRProviders.isEmpty()){  
                   locationAffiliationIdMap = new Map<String,ACETProviderLookupController.ProviderLookupResult>();
                   locationAffiliationMap = new Map<String,String>();
                   providerLookupResultsMap = new Map<String,ACETProviderLookupController.ProviderLookupResult>();
                 for (ACETFindMedclProvidrLookupSrvceJSON2Apex.medicalProviders SRProvider: SRProviders) { 
                    providerLocationAffiliationDetails = new List<ACETFindMedclProvidrLookupSrvceJSON2Apex.providerLocationAffiliations>();
                    Provider = new ACETProviderLookupController.ProviderLookupResult();
                    Provider.radious = String.isNotBlank(SRProvider.address.distance) ? SRProvider.address.distance : '';
                    Provider.providerId = String.isNotBlank(SRProvider.key.providerId) ? SRProvider.key.providerId : ''; 
                    Provider.taxId = String.isNotBlank(SRProvider.providerTIN.id) ? SRProvider.providerTIN.id : '';
                    Provider.providerTINTypeCode = String.isNotBlank(SRProvider.providerTIN.typeCode) ? SRProvider.providerTIN.typeCode : '';
                    Provider.providerTINStatusCode = String.isNotBlank(SRProvider.providerTIN.statusCode) ? SRProvider.providerTIN.statusCode : '';
                    Provider.addressId = String.isNotBlank(SRProvider.address.addressId) ? SRProvider.address.addressId : '';
                    Provider.addressTypeCode = String.isNotBlank(SRProvider.address.typeCode) ? SRProvider.address.typeCode : '';
                    Provider.fullName = '';
                    if (String.isNotBlank(SRProvider.healthcareProvider.providerTypeCode)) {
                        if (SRProvider.healthcareProvider.providerTypeCode == 'HCO') {
                            Provider.providerTypeCode = SRProvider.healthcareProvider.providerTypeCode;
                            if (String.isNotBlank(SRProvider.healthcareProvider.name)) {
                                Provider.fullName = SRProvider.healthcareProvider.name;
                            }
                            Provider.providerType = 'Facility';
                        } else if (SRProvider.healthcareProvider.providerTypeCode == 'HCP') {
                            Provider.providerTypeCode = SRProvider.healthcareProvider.providerTypeCode;
                            if (String.isNotBlank(SRProvider.healthcareProvider.providerFirstName)) {
                                Provider.fullName = SRProvider.healthcareProvider.providerFirstName;
                            }
                            if (String.isNotBlank(SRProvider.healthcareProvider.providerMiddleName)) {
                                 Provider.fullName +=  ' ' + SRProvider.healthcareProvider.providerMiddleName;
                            } 
                            if (String.isNotBlank(SRProvider.healthcareProvider.name)) {
                                 Provider.fullName +=  ' ' + SRProvider.healthcareProvider.name;
                            }                                                                
                            if(String.isNotBlank (SRProvider.healthcareProvider.providerNameSuffix)) {
                                 Provider.fullName +=  ' ' + SRProvider.healthcareProvider.providerNameSuffix;
                            } 
                            Provider.providerType = 'Physician';
                        }
                    }   
                   //added for provider fast track
                    Provider.addressStatusCode = String.isNotBlank(SRProvider.address.statusCode) ? SRProvider.address.statusCode : '';
                    Provider.addressCountyDesc = String.isNotBlank(SRProvider.address.countyDescription) ? SRProvider.address.countyDescription : '';
                    Provider.postalPrefixCode = String.isNotBlank(SRProvider.address.postalPrefixCode) ? SRProvider.address.postalPrefixCode : '';
                    Provider.postalSuffixCode = String.isNotBlank(SRProvider.address.postalSuffixCode) ? SRProvider.address.postalSuffixCode : '';
                    //Fast track changes end here                    
                    Provider.address = '';
                    Provider.street = '';
                    Provider.city = '';
                    Provider.state = '';
                    Provider.zipCode = '';
                    if (String.isNotBlank(SRProvider.address.addressLine1)) {
                        Provider.address = SRProvider.address.addressLine1;
                        Provider.street = SRProvider.address.addressLine1;
                    }
                    if (String.isNotBlank(SRProvider.address.addressLine2)) {
                        Provider.address += ' ' + SRProvider.address.addressLine2;
                        Provider.street  += ' ' + SRProvider.address.addressLine2;
                    }
                    if (String.isNotBlank(SRProvider.address.city)) {
                        Provider.address += ' ' + SRProvider.address.city;
                        Provider.city = SRProvider.address.city;
                    }
                    if (String.isNotBlank(SRProvider.address.stateCode)) {
                        Provider.address += ' ' + SRProvider.address.stateCode;
                        Provider.state = SRProvider.address.stateCode;
                    }
                    if (String.isNotBlank(SRProvider.address.postalPrefixCode)) {
                        Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                        Provider.zipCode = SRProvider.address.postalPrefixCode;
                    }                                                 
                    Provider.phoneNumber = '';
                    if ( SRProvider.phone != null && !SRProvider.phone.isEmpty()) {
                        for (ACETFindMedclProvidrLookupSrvceJSON2Apex.phone phone :SRProvider.phone) {
                            if (phone.primaryPhoneIndicator == 'Y') {
                                if (phone.phoneTypeCode == 'TEL') {
                                    if (String.isNotBlank(phone.phoneNumber)) {
                                        Provider.phoneNumber = '(' + phone.areaCode + ')';
                                        Provider.phoneNumber += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                        Provider.phoneNumber += phone.phoneNumber.substring(3);
                                }    
                            } 
                        }  
                    }
                 }
                    Provider.speciality = '';
                    if (String.isNotBlank(specialityCheck)) {  
                        if (String.isNotBlank(specialityCheck)) {
                            Provider.speciality = (mapTaxonomyMDT.get(specialityCheck).Speciality__c != null) ? mapTaxonomyMDT.get(specialityCheck).Speciality__c : specialityCheck;
                        }
                    } else {
                    if(SRProvider.Specialty !=null && !SRProvider.Specialty.isEmpty()){
                        for (ACETFindMedclProvidrLookupSrvceJSON2Apex.Specialty Specialty :SRProvider.Specialty) {
                            if (Specialty.primarySpecialtyIndicator == 'Y') {
                                if(String.isNotBlank(Specialty.typeDescription)) {
                                    Provider.speciality = Specialty.typeDescription;
                                }
                            }
                         } 
                      }  
                    }
                    Provider.gender = '';
                    if (SRProvider.healthcareProvider != null) {
                        if (String.isNotBlank(SRProvider.healthcareProvider.providerGenderCode)) {
                            Provider.gender = SRProvider.healthcareProvider.providerGenderCode;
                        }
                    }
                    Provider.platinum = '';
                    if ( SRProvider.Tpsm != null && !SRProvider.Tpsm.isEmpty()) {
                        system.debug(LoggingLevel.INFO, 'SRProvider.Tpsm :: ' + SRProvider.Tpsm );
                        for (ACETFindMedclProvidrLookupSrvceJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
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
                    system.debug(LoggingLevel.INFO, 'Provider.platinum :: ' + Provider.platinum );
                    Provider.uphd = '';
                    /*if (SRProvider.premiumDesignation != null) {                        
                        if (String.isNotBlank(SRProvider.premiumDesignation[0].qualityTypeDescription) && 
                            String.isNotBlank(SRProvider.premiumDesignation[0].efficiencyTypeDescription)){
                                Provider.uphd ='Q - ' + SRProvider.premiumDesignation[0].qualityTypeDescription
                                    + ' E - ' + SRProvider.premiumDesignation[0].efficiencyTypeDescription;
                            }
                    }*/
                    
                    if ( SRProvider.premiumDesignation != null && !SRProvider.premiumDesignation.isEmpty()) {
                               if (String.isNotBlank(SRProvider.premiumDesignation[0].qualityTypeCode) && 
                                    String.isNotBlank(SRProvider.premiumDesignation[0].efficiencyTypeCode)) {
                                        if(uphdMap.get(SRProvider.premiumDesignation[0].efficiencyTypeCode+'----'+SRProvider.premiumDesignation[0].qualityTypeCode)!=null)
                                            Provider.uphd = 
                                            uphdMap.get(SRProvider.premiumDesignation[0].efficiencyTypeCode+'----'+SRProvider.premiumDesignation[0].qualityTypeCode).Designation__c;
                                        
                                        else
                                            Provider.uphd = 'N/A';
                                    }
                                else
                                    Provider.uphd = 'N/A';
                            }
                            else
                                Provider.uphd = 'N/A';
                    
                    //Added by Avish on 06282017 as a part of US643104
                    Map<String,String> maprole = new Map<String,string>();
                    List<String> roleLst = new List<String>();
                    if (SRProvider.Role != null && !SRProvider.Role.isEmpty()) {
                        for (ACETFindMedclProvidrLookupSrvceJSON2Apex.Role Role :SRProvider.Role) {
                            if (String.isNotBlank(role.code) && String.isNotBlank(role.statusCode)){
                                if (role.statusCode == 'A' && (role.code == 'PCP' || role.code == 'OBGYN')){
                                    maprole.put(role.code+role.statusCode,role.code);
                                }   
                            }
                        }
                    
                        for (String key : maprole.keySet()) {
                            roleLst.add(maprole.get(key));
                        }

                        system.debug(LoggingLevel.INFO,' ::Size :: ' + roleLst.size());
                        if (roleLst.size() == 1) {
                            system.debug(LoggingLevel.INFO,' ::roleLst:: ' + roleLst); 
                            Provider.PCPRole = ACETProviderUtility.validateConcatenateOfStrings(roleLst[0],'','');
                        } else if(roleLst.size() == 2){  
                            Provider.PCPRole = ACETProviderUtility.validateConcatenateOfStrings(roleLst[0],roleLst[1],'/');
                        } else{
                            Provider.PCPRole = '';
                        }     
                    }  
                     if(SRProvider.providerLocationAffiliations != null && !SRProvider.providerLocationAffiliations.isEmpty()) {
                                providerLocationAffiliationDetails = SRProvider.providerLocationAffiliations;
                      }
                      locationAffiliationMap = providerLocationAffiliationMapping(providerLocationAffiliationDetails);
                      System.debug('locationAffiliationMap'+locationAffiliationMap);
                     if(!locationAffiliationIdMap.isEmpty()) {
                            if(locationAffiliationIdMap.containsKey(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode)) {
                                Provider = locationAffiliationIdMap.get(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode);
                            }else {
                                locationAffiliationIdMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode,Provider);
                           }
                        }else {
                             locationAffiliationIdMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode,Provider);
                         }
                    /*** End of Role ***/  
                    System.debug('locationAffiliationIdMap' +locationAffiliationIdMap);
					
					 if(SRProvider.labTypes!=null && !SRProvider.labTypes.isEmpty()){
                          String labTypeStr = '';
							Provider.labTypes = new List<ACETProviderLookupController.labType>();																  
                          for(ACETFindMedclProvidrLookupSrvceJSON2Apex.labType lb:SRProvider.labTypes){
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
                    ACETProviderLookupController.ProviderLookupResult temp;
                    if(!locationAffiliationMap.isEmpty() && locationAffiliationIdMap.size() > 0) {
                       for(String pcpId :locationAffiliationMap.keyset()) {
                        if(locationAffiliationIdMap.containsKey(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode)) {
                                 temp =  locationAffiliationIdMap.get(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode);
                        }
                            ACETProviderLookupController.ProviderLookupResult  locationAffiliation = new ACETProviderLookupController.ProviderLookupResult(temp);
                            System.debug('temp'+temp);
                            locationAffiliation.providerLocationAffiliationsStatusCode = locationAffiliationMap.get(pcpId);
                            locationAffiliation.pcpObgnID =  pcpId;
                           locationAffiliation.qualityBenefitTier = 'No';
                           if(SRProvider.qualityTiers!=null && !SRProvider.qualityTiers.isEmpty()){
                               for(ACETFindMedclProvidrLookupSrvceJSON2Apex.qualityTier qt: SRProvider.qualityTiers){
                                   if(qt.level == '1'){
                                       locationAffiliation.qualityBenefitTier = 'Yes';
                                       break;
                                   }
                               }
                           }
                           if((qualityTierLevelGlobal=='1' && locationAffiliation.qualityBenefitTier == 'Yes') || qualityTierLevelGlobal!='1'){
                                if(this.isDDP != NULL && this.isDDP){
                                   if(SRProvider.labTypes!=null && !SRProvider.labTypes.isEmpty() && SRProvider.labTypes[0].code != null){
                                     providerLookupResultsMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode+locationAffiliation.pcpObgnID,locationAffiliation);
                                   }
                               }else {
                                   providerLookupResultsMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode+locationAffiliation.pcpObgnID,locationAffiliation);
                               }
                            System.debug('providerLookupResultsMap'+providerLookupResultsMap);        
                           }       
                        }
                      }else if(locationAffiliationMap.isEmpty() && locationAffiliationIdMap.size() > 0){
                              if(locationAffiliationIdMap.containsKey(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode)) {
                                   temp =  locationAffiliationIdMap.get(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode);
                              }
                          temp.qualityBenefitTier = 'No';
                          if(SRProvider.qualityTiers!=null && !SRProvider.qualityTiers.isEmpty()){
                              for(ACETFindMedclProvidrLookupSrvceJSON2Apex.qualityTier qt: SRProvider.qualityTiers){
                                  if(qt.level == '1'){
                                      temp.qualityBenefitTier = 'Yes';
                                      break;
                                  }
                              }
                          }
                          if((qualityTierLevelGlobal=='1' && temp.qualityBenefitTier == 'Yes') || qualityTierLevelGlobal!='1'){
                              if(this.isDDP != NULL && this.isDDP){
                                   if(SRProvider.labTypes!=null && !SRProvider.labTypes.isEmpty() && SRProvider.labTypes[0].code!=null){
                                       system.debug('labType code1 valid');
                               			providerLookupResultsMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode,temp);
                                   }
                               }else {
                                   providerLookupResultsMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode,temp);
                               }
                          }
                      }
                    
                }  if(!providerLookupResultsMap.isEmpty()) {
                       Providers.addAll(providerLookupResultsMap.values());
                    }
                        System.debug('Providers'+Providers);
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
               oACETWSCalloutResult.statuscode =  Response.getStatusCode() ;

            }    
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.findMedicalProvidersResponse.errors);
            oACETWSCalloutResult.Message = oACETWSCalloutResult.Message == Label.OILNoRecordErrorMessage ? Label.ACETNoRecordErrorMessage : oACETWSCalloutResult.Message;
            oACETWSCalloutResult.Response = null;
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
           oACETWSCalloutResult.statuscode =  Response.getStatusCode() ;
        }
        return oACETWSCalloutResult;
    }    
    
    private static Map<String,String> providerLocationAffiliationMapping(List<ACETFindMedclProvidrLookupSrvceJSON2Apex.providerLocationAffiliations> providerLocationAffiliationDetails) {
            Map<String, String> finalizedLocationMap = new Map<String, String>();
            for(ACETFindMedclProvidrLookupSrvceJSON2Apex.providerLocationAffiliations pcpId :providerLocationAffiliationDetails) {
               if(String.isNotBlank(pcpId.id) && String.isNotBlank(pcpId.statusCode)) {
                 finalizedLocationMap.put(pcpId.id,pcpId.statusCode);
               }
            }
            return finalizedLocationMap;
    }    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindMedclProvidrLookupSrvceJSON2Apex.medicalProviders> SRProviders;
        ACETOILPagination Pagination;
        
        try {
            RequestParameters.AddAll(new List<String>{String.valueOf(pageNumber), String.valueOf(PageSize), String.valueOf(startRecord)});
            GetRequestBody();
            HttpResponse Response = Send(OAuthConfig);  
            system.debug(LoggingLevel.INFO,' :: Response Body :: ' + Response);          
            
                   
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                oACETWSCalloutResult = ParseSuccessResponse(Response );
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                oACETWSCalloutResult.statuscode =   Response.getStatusCode() ;     
            }
        }
        catch(Exception ex) {
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