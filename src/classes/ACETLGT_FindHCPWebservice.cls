public class ACETLGT_FindHCPWebservice extends ACETWebservice
{
    public String providerType;
    public String specialityCheck;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public string NetworkId2;
    public string attSet2;
    public string adrattSet;
    public string isLookupflow1;
    public String addressCheck;
    public string qualityTierLevelGlobal;
    public string network;
	
	public void Init(String ProviderId, String NPI, String TIN, String LastName, String FirstName, String GenderCode, String SpecialtyTypeCode, 
                     string pcpObgnId,String PostalPrefixCode, String Distance, String City, String StateCode, String PhoneNumber,String NetworkId,String BenefitServiceArea,String ServiceAreaType,String contractClaimType,
                     String NewPatientIndicator, String LanguageCode, String ProviderType,String attributelist,String isLookupflow,String FilterByStatus,String PFS) { 
                         Init( ProviderId,  NPI,  TIN,  LastName,  FirstName,  GenderCode,  SpecialtyTypeCode, 
                              pcpObgnId, PostalPrefixCode,  Distance,  City,  StateCode,  PhoneNumber, NetworkId, null, null, BenefitServiceArea, ServiceAreaType, contractClaimType,
                              NewPatientIndicator,  LanguageCode,  ProviderType, attributelist, isLookupflow, FilterByStatus, PFS); 
                     }
					 
    public void Init(String ProviderId, String NPI, String TIN, String LastName, String FirstName, String GenderCode, String SpecialtyTypeCode, 
        string pcpObgnId,String PostalPrefixCode, String Distance, String City, String StateCode, String PhoneNumber,String NetworkId,String QualityTierRuleId,String QualityTierLevel,String BenefitServiceArea,String ServiceAreaType,String contractClaimType,
        String NewPatientIndicator, String LanguageCode, String ProviderType,String attributelist,String isLookupflow,String FilterByStatus,String PFS) { 
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        this.NetworkId2 = NetworkId;
        NetworkId = 'strFormatIssue';
        this.attSet2 = attributelist;
        attributelist = 'strFormatIssue2';
        isLookupflow1 = isLookupflow;
        system.debug(LoggingLevel.INFO, 'Provider Id: ' + ProviderId + ', NPI: ' + NPI + ', TIN: ' + TIN + ', Last Name: ' + LastName + ', First Name: ' + FirstName);
        system.debug(LoggingLevel.INFO, 'Specialty Type Code: ' + SpecialtyTypeCode + ', Postal Prefix Code: ' + PostalPrefixCode + ', Distance: ' + Distance);
        system.debug(LoggingLevel.INFO, 'Gender Code: ' + GenderCode + ', City: ' + City + ', State Code: ' + StateCode + ', Phone Number: ' + PhoneNumber);
        system.debug(LoggingLevel.INFO, 'NewPatientIndicator: ' + NewPatientIndicator + ', Provider Type: ' + ProviderType);
        system.debug(LoggingLevel.INFO, 'LanguageCode: ' + LanguageCode + ', Network Id: ' + NetworkId + ', BenefitServiceArea: ' + BenefitServiceArea + ', ServiceAreaType: ' + ServiceAreaType);
        ProviderId = String.isNotBlank(ProviderId) ? ProviderId : '';
        NPI = String.isNotBlank(NPI) ? NPI : '';
        TIN = String.isNotBlank(TIN) ? TIN : '';
        GenderCode = String.isNotBlank(GenderCode) ? GenderCode : '';
        SpecialtyTypeCode = String.isNotBlank(SpecialtyTypeCode) ? SpecialtyTypeCode : '';
        PostalPrefixCode = String.isNotBlank(PostalPrefixCode) ? PostalPrefixCode : '';
        Distance = String.isNotBlank(Distance) ? Distance : '';
        StateCode = String.isNotBlank(StateCode) ? StateCode : '';
        NetworkId = String.isNotBlank(NetworkId) ? NetworkId : '';
            QualityTierRuleId = String.isNotBlank(QualityTierRuleId) ? QualityTierRuleId :'';
            QualityTierLevel = String.isNotBlank(QualityTierLevel) ? '1' :'';
            qualityTierLevelGlobal = QualityTierLevel;
        BenefitServiceArea = String.isNotBlank(BenefitServiceArea) ? BenefitServiceArea : '';
        ServiceAreaType = String.isNotBlank(ServiceAreaType) ? ServiceAreaType : '';
        contractClaimType = String.isNotBlank(contractClaimType) ? contractClaimType : '';
        NewPatientIndicator = String.isNotBlank(NewPatientIndicator) ? NewPatientIndicator : '';
        LanguageCode = String.isNotBlank(LanguageCode) ? LanguageCode : '';
        ProviderType = String.isNotBlank(ProviderType) ? ProviderType : '';
        pcpObgnId = string.isNotBlank(pcpObgnId) ? pcpObgnId : '';
        
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
        System.debug('phonenumber' +PhoneNumber);
        if(String.isNotBlank(PhoneNumber)) {
            AreaCode = PhoneNumber.substring(0, 3);
            System.debug('AreaCode' +AreaCode);
            Phone = PhoneNumber.substring(3, 10);
            System.debug('Phone' +Phone);
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
        system.debug(LoggingLevel.INFO, 'AreaCode: ' + AreaCode + ', Phone: ' + Phone + ', Phone Type Code: ' + PhoneTypeCode+', providerTINStatusCode: ' + providerTINStatusCode+', npiStatusCode: ' + npiStatusCode+', providerStatusCode: ' + providerStatusCode+',specialtyStatusCode:'+specialtyStatusCode+',addressStatusCode:'+addressStatusCode);
        LastName = String.isNotBlank(LastName) ? LastName.toUpperCase() : '';
        FirstName = String.isNotBlank(FirstName) ? FirstName.toUpperCase() : '';
        GenderCode = GenderCode == 'Male' ? 'M' : GenderCode == 'Female' ? 'F' : '';
        City = String.isNotBlank(City) ? City.toUpperCase() : '';
        this.addressCheck = addressTypeCode;
        addressTypeCode = 'strFormatIssue3';
        RequestParameters = new List<String>{ProviderId, NPI, TIN, LastName, FirstName, GenderCode, SpecialtyTypeCode,pcpObgnId, PostalPrefixCode, 
            Distance, City, StateCode, PhoneTypeCode, AreaCode, Phone,NetworkId,BenefitServiceArea,ServiceAreaType,contractClaimType,NewPatientIndicator, 
             LanguageCode,attributelist,providerTINStatusCode,npiStatusCode,addressStatusCode,providerStatusCode,specialtyStatusCode,addressTypeCode,QualityTierRuleId,QualityTierLevel,network};
        this.specialityCheck = SpecialtyTypeCode;
        mapTaxonomyMDT = ACETProviderUtility.getProviderTaxonomy();
           
        }
    
    public override void GetEndpoint()
    {
         GetEndpointDetail('findHCPEndpoint');
    }
    public ACETLGT_FindHCPWebservice() {
        super('Stargate');
    }
    private void GetRequestBody() {         
        RequestBody = GetRequestBody('ACETLGT_FindMedicalHCPRequestJSON', RequestParameters);   
        if (test.isRunningTest())  {
           RequestBody =  '{"findMedicalHealthcareProfessionalsRequest":{"providerId":"","providerStatusCode":"","npi":"","npiStatusCode":"","providerTIN":"263520640","providerTINStatusCode":"","medicaidId":"","medicaidIdStatusCode":"","medicareId":"","medicareIdStatusCode":"","providerLastName":"","providerFirstName":"","providerGenderCode":"","providerRoleTypeCode":"","specialtyTypeCode":"","primarySpecialtyIndicator":"","specialtyStatusCode":"","addressTypeCode":[""],"primaryAddressIndicator":"","addressStatusCode":"","addressPostalPrefixCode":"","addressPostalSuffixCode":"","addressDistance":"","addressCity":"","addressStateCode":"","addressCountyDescription":"","phoneStatusCode":"","phoneTypeCode":[""],"primaryPhoneIndicator":"","phoneCountryCode":"","phoneAreaCode":"","phoneNumber":"","networkId":["strFormatIssue"],"benefitServiceArea":"","serviceAreaType":"","contractClaimType":"l","businessSegmentCode":[""],"contractStatusCode":"","acceptingNewPatientIndicator":"","acceptingExistingPatientIndicator":"","premiumDesignationIndicator":"","providerLocationAffiliationId":"","premiumDesignationLevel":[""],"languageCode":"","pagination":{"pageNumber":"","pageSize":"","startRecord":""},"sorting":[{"sortColumnName":"","sortOrderType":"","sortPriority":""}]}';
        }
         string tmpNetworkId ='[';
        if(this.NetworkId2 != null){
            for(string s : this.NetworkId2.split('@')){
                if(tmpNetworkId == '['){
                    tmpNetworkId = tmpNetworkId + '"'+s+'"';                
                }else{
                    tmpNetworkId = tmpNetworkId + ',"'+s+'"';
                }
            }
        }
        
        tmpNetworkId = tmpNetworkId + ']';
        adrattSet =  '["key","hcp","tax","address"]'; 
        if(isLookupflow1 =='true') {
           addressCheck = '["PRAC"]';
           attSet2 =  '["key","hcp","tax","tpsms","specialties","address","phones","electronicCommunications","premiumDesignations","roles","providerLocationAffiliations","qualityTiers"]'; 
        }else {
            addressCheck = '[""]';
            attSet2 =  '["key","hcp","tax","tpsms","specialties","address","phones","electronicCommunications","premiumDesignations","roles","qualityTiers"]'; 
        }
        RequestBody = RequestBody.replace('["strFormatIssue"]',tmpNetworkId);
        RequestBody = RequestBody.replace('["strFormatIssue2"]',attSet2);
        RequestBody = RequestBody.replace('["strFormataddress"]',adrattSet);
        RequestBody = RequestBody.replace('["strFormatIssue3"]',addressCheck);

    }
    
    private ACETWSCalloutResult ParseSuccessResponse(HttpResponse Response) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETLGT_ProviderLookupResult> Providers = new List<ACETLGT_ProviderLookupResult>();
        Map<String,ACETLGT_ProviderLookupResult> locationAffiliationIdMap;
        ACETLGT_ProviderLookupResult Provider;
        Map<String,String> locationAffiliationMap;
        Map<String,ACETLGT_ProviderLookupResult> providerLookupResultsMap;
        List<ACETLGT_FindHCPJSON2Apex.medicalHealthcareProfessionals> SRProviders;
        ACETOILPagination Pagination;
        List<ACETLGT_ProviderLookupResult> providerList = new List<ACETLGT_ProviderLookupResult>();
        
        ACETLGT_FindHCPJSON2Apex  ACETJSON2Apex = (ACETLGT_FindHCPJSON2Apex)JSON.deserialize(Response.getBody(), ACETLGT_FindHCPJSON2Apex.class);
        system.debug(LoggingLevel.INFO, 'ACETFindHCPWebservice. ACETJSON2Apex: ' + ACETJSON2Apex);
        List<ACETLGT_FindHCPJSON2Apex.providerLocationAffiliations> providerLocationAffiliationDetails;
        if (ACETJSON2Apex.findMedicalHealthcareProfessionalsResponse.errors == null) {
            Pagination = ACETJSON2Apex.findMedicalHealthcareProfessionalsResponse.pagination;
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
                SRProviders = ACETJSON2Apex.findMedicalHealthcareProfessionalsResponse.medicalHealthcareProfessionals;
                system.debug(LoggingLevel.INFO, 'SRProviders: '+ SRProviders);
                if(SRProviders !=null && !SRProviders.isEmpty()){
                    locationAffiliationIdMap = new Map<String,ACETLGT_ProviderLookupResult>();
                    locationAffiliationMap = new Map<String,String>();
                    providerLookupResultsMap = new Map<String,ACETLGT_ProviderLookupResult>();
                    for (ACETLGT_FindHCPJSON2Apex.medicalHealthcareProfessionals SRProvider: SRProviders) {
                        if(SRProvider != null){
                            providerLocationAffiliationDetails = new List<ACETLGT_FindHCPJSON2Apex.providerLocationAffiliations>();
                            Provider = new ACETLGT_ProviderLookupResult();
                            Provider.radious = String.isNotBlank(SRProvider.address.distance) ? SRProvider.address.distance : ''; 
                            Provider.fullName = '';
                            if(SRProvider.hcp !=null){
                                if (String.isNotBlank(SRProvider.hcp.providerFirstName)) {
                                    Provider.fullName += SRProvider.hcp.providerFirstName;
                                    Provider.firstName = SRProvider.hcp.providerFirstName;//added by Vishakha for Communication and Material Request call topic 6/29
                                }  
                                if (String.isNotBlank(SRProvider.hcp.providerMiddleName)) {
                                    Provider.fullName += ' ' + SRProvider.hcp.providerMiddleName;
                                    Provider.middleName = SRProvider.hcp.providerMiddleName;//added by Vishakha for Communication and Material Request call topic 6/29
                                } 
                                if (String.isNotBlank(SRProvider.hcp.providerLastName)) {
                                    Provider.fullName += ' ' + SRProvider.hcp.providerLastName;
                                    Provider.lastName = ' ' + SRProvider.hcp.providerLastName;//added by Vishakha for Communication and Material Request call topic 6/29
                                } 
                                if (String.isNotBlank(SRProvider.hcp.providerNameSuffix)) {
                                    Provider.fullName += ' ' + SRProvider.hcp.providerNameSuffix;
                                    Provider.suffix = ' ' + SRProvider.hcp.providerNameSuffix;//added by Vishakha for Communication and Material Request call topic 6/29
                                }                                        
                                
                                Provider.Email = '';
                                if(SRProvider.electronicCommunication != null && !SRProvider.electronicCommunication.isEmpty()){
                                    for (ACETLGT_FindHCPJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication) {
                                        if (electronicCommunication.communicationTypeCode == 'EMAIL') {
                                            Provider.Email = electronicCommunication.message;
                                        }
                                    }
                                }    
                                Provider.providerId = String.isNotBlank(SRProvider.hcp.providerId) ? SRProvider.hcp.providerId : ''; 
                            }
                            Provider.providerType = String.isNotBlank(providerType) ? providerType : '';
                            if(SRProvider.providerTIN != null){
                                Provider.taxId = String.isNotBlank(SRProvider.providerTIN.id) ? SRProvider.providerTIN.id : '';
                                Provider.providerTINTypeCode= String.isNotBlank(SRProvider.providerTIN.typeCode) ? SRProvider.providerTIN.typeCode : '';
                            }
                            if(SRProvider.address != null){
                                Provider.addressId = String.isNotBlank(SRProvider.address.addressId) ? SRProvider.address.addressId : '';
                                Provider.addressTypeCode = String.isNotBlank(SRProvider.address.typeCode) ? SRProvider.address.typeCode : '';
                                Provider.County = String.isNotBlank(SRProvider.address.countyDescription) ? SRProvider.address.countyDescription : '';
                                Provider.addressStatusCode = String.isNotBlank(SRProvider.address.statusCode) ? SRProvider.address.statusCode : '';
                            }
                            
                            //Added by Avish on 06282017 as a part of US643104
                            Map<String,String> maprole = new Map<String,string>();
                            List<String> roleLst = new List<String>();
                            if(SRProvider.Role != null && !SRProvider.Role.isEmpty()){
                                for(ACETLGT_FindHCPJSON2Apex.Role Role :SRProvider.Role){
                                system.debug('role ststus ====>'+role.statusCode);
                                    if(String.isNotBlank(role.code)&& String.isNotBlank(role.statusCode)){
                                        if(role.statusCode == 'A' &&(role.code == 'PCP' || role.code == 'OBGYN')){
                                            maprole.put(role.code+role.statusCode,role.code);
                                        }   
                                    }
                                }
                                for(String key : maprole.keySet()){
                                    roleLst.add(maprole.get(key));
                                }
                                
                                if(roleLst.size() == 1){
                                    Provider.PCPRole = ACETProviderUtility.validateConcatenateOfStrings(roleLst[0],'','');
                                }else if(roleLst.size() == 2){  
                                    Provider.PCPRole = ACETProviderUtility.validateConcatenateOfStrings(roleLst[0],roleLst[1],'/');
                                }else{
                                
                                    Provider.PCPRole = '';
                                }
                            }  
                            if(SRProvider.address != null){
                                Provider.addressLine1 = Provider.address = String.isNotBlank(SRProvider.address.addressLine1) ? SRProvider.address.addressLine1 : '';
                                if (String.isNotBlank(SRProvider.address.addressLine2)) {
                                    Provider.address += ' ' + SRProvider.address.addressLine2;
                                    Provider.addressLine2 =  SRProvider.address.addressLine2;//added by Vishakha for Communication and Material Request call topic 6/29
                                }
                                if (String.isNotBlank(SRProvider.address.city)) {
                                    Provider.address += ' ' + SRProvider.address.city;
                                    Provider.city =  SRProvider.address.city;//added by Vishakha for Communication and Material Request call topic 6/29
                                }
                                if (String.isNotBlank(SRProvider.address.stateCode)) {
                                    Provider.address += ' ' + SRProvider.address.stateCode;
                                    Provider.state = ' ' + SRProvider.address.stateCode;//added by Vishakha for Communication and Material Request call topic 6/29
                                }
                                if (String.isNotBlank(SRProvider.address.postalPrefixCode)) {
                                    Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                                    Provider.zipCode = ' ' + SRProvider.address.postalPrefixCode;//added by Vishakha for Communication and Material Request call topic 6/29
                                }  
                            }    
                            Provider.phoneNumber = '';
                            Provider.Fax = '';
                            if(SRProvider.phone !=null && !SRProvider.phone.isEmpty()){         
                                for (ACETLGT_FindHCPJSON2Apex.phone phone :SRProvider.phone) {
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
                            /* for(ACETFindHCPJSON2Apex.contract contr :SRProvider.contract){

} */
                            
                            Provider.speciality = '';
                            if (String.isNotBlank(specialityCheck)) {  
                                if (String.isNotBlank(specialityCheck)) {
                                    Provider.speciality = (mapTaxonomyMDT.get(specialityCheck).Speciality__c != null) ? mapTaxonomyMDT.get(specialityCheck).Speciality__c : specialityCheck;
                                }
                            } else {
                                if(SRProvider.Specialty !=null && !SRProvider.Specialty.isEmpty()){
                                    for (ACETLGT_FindHCPJSON2Apex.Specialty Specialty :SRProvider.Specialty) {
                                        if (Specialty.primarySpecialtyIndicator == 'Y') {
                                            if(String.isNotBlank(Specialty.typeDescription)) {
                                                Provider.speciality = Specialty.typeDescription;
                                            }
                                        }
                                    }
                                }                        
                            }
                            
                            Provider.gender = String.isNotBlank(SRProvider.hcp.providerGenderCode) ? SRProvider.hcp.providerGenderCode : '';
                            Provider.uphd = '';
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
                            Provider.platinum = '';
                            if (SRProvider.Tpsm != null && !SRProvider.Tpsm.isEmpty()) {
                                for (ACETLGT_FindHCPJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
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
                             System.debug('locationAffiliationIdMap' +locationAffiliationIdMap);
                             ACETLGT_ProviderLookupResult temp;
                             if(!locationAffiliationMap.isEmpty() && locationAffiliationIdMap.size() > 0) {
                                 for(String pcpId :locationAffiliationMap.keyset()) {
                                  if(locationAffiliationIdMap.containsKey(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode)) {
                                       temp =  locationAffiliationIdMap.get(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode);
                                  }
                                       ACETLGT_ProviderLookupResult  locationAffiliation = new ACETLGT_ProviderLookupResult(temp);
                                       System.debug('temp'+temp);
                                       locationAffiliation.providerLocationAffiliationsStatusCode = locationAffiliationMap.get(pcpId);
                                       locationAffiliation.pcpObgnID =  pcpId;
                                      locationAffiliation.qualityBenefitTier = 'No';
                                         if(SRProvider.qualityTiers!=null && !SRProvider.qualityTiers.isEmpty()){
                                             for(ACETLGT_FindHCPJSON2Apex.qualityTier qt: SRProvider.qualityTiers){
                                                 if(qt.level == '1'){
                                                     locationAffiliation.qualityBenefitTier = 'Yes';
                                                     break;
                                                 }
                                             }
                                         } 
                                     //if((qualityTierLevel=='1' && locationAffiliation.qualityBenefitTier == 'Yes') || qualityTierLevel==''){
                                       providerLookupResultsMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode+locationAffiliation.pcpObgnID,locationAffiliation);
                                     //}
                                       System.debug('providerLookupResultsMap'+providerLookupResultsMap);        
                               }
                            } else if(locationAffiliationMap.isEmpty() && locationAffiliationIdMap.size() > 0){
                                     if(locationAffiliationIdMap.containsKey(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode)) {
                                         temp =  locationAffiliationIdMap.get(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode);
                                     }
                                temp.qualityBenefitTier = 'No';
                                if(SRProvider.qualityTiers!=null && !SRProvider.qualityTiers.isEmpty()){
                                    for(ACETLGT_FindHCPJSON2Apex.qualityTier qt: SRProvider.qualityTiers){
                                        if(qt.level == '1'){
                                            temp.qualityBenefitTier = 'Yes';
                                            break;
                                        }
                                    }
                                }
                                //if((qualityTierLevel=='1' && temp.qualityBenefitTier == 'Yes') || qualityTierLevel==''){
                                providerLookupResultsMap.put(Provider.providerId+Provider.taxId+Provider.providerTINTypeCode+Provider.addressId+Provider.addressTypeCode,temp);
                                //}
                             }
                        }
                    }
                      if(!providerLookupResultsMap.isEmpty()) {
                         Providers.addAll(providerLookupResultsMap.values());
                    }
                }
            
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Providers; 
            }
        } else {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.findMedicalHealthcareProfessionalsResponse.errors);
            oACETWSCalloutResult.Message = oACETWSCalloutResult.Message == Label.OILNoRecordErrorMessage ? Label.ACETNoRecordErrorMessage : oACETWSCalloutResult.Message;
            oACETWSCalloutResult.Response = null;
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
        }
        return oACETWSCalloutResult;
    }
    private static Map<String,String> providerLocationAffiliationMapping(List<ACETLGT_FindHCPJSON2Apex.providerLocationAffiliations> providerLocationAffiliationDetails) {
            Map<String, String> finalizedLocationMap = new Map<String, String>();
            for(ACETLGT_FindHCPJSON2Apex.providerLocationAffiliations pcpId :providerLocationAffiliationDetails) {
               if(String.isNotBlank(pcpId.id) && String.isNotBlank(pcpId.statusCode)) {
                 finalizedLocationMap.put(pcpId.id,pcpId.statusCode);
               }
            }
            return finalizedLocationMap;
    }    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        
        try
        {
            RequestParameters.AddAll(new List<String>{String.valueOf(pageNumber), String.valueOf(PageSize), String.valueOf(startRecord), '', '', ''});
            GetRequestBody();
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                oACETWSCalloutResult = ParseSuccessResponse(Response);       
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Success = false;
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
  
    //Webservice method to call findHCP Adapter Lookup service
    public ACETWSCalloutResult FindHCP(String TaxId, String NPI, String providerId, String networkType, String LastName, String PhoneNumber, String providerType, 
                                    String FirstName, String city, String specialityType, String language, String state, String radius, String gender,String ZipCode,String NewpatientsInd,String existingpatientsInd, String benefitPlanId,string pcpObgnId){
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try
        {
            GetEndpoint();
            providerId = String.isNotBlank(providerId) ? providerId : '';
            NPI = String.isNotBlank(NPI) ? NPI : '';
            TaxId = String.isNotBlank(TaxId) ? TaxId : '';
            LastName = String.isNotBlank(LastName) ? LastName.toUpperCase() : '';
            FirstName = String.isNotBlank(FirstName) ? FirstName.toUpperCase() : '';
            gender = gender == 'Male' ? 'M' : gender == 'Female' ? 'F' : '';
            specialityType = String.isNotBlank(specialityType) ? specialityType : '';
            ZipCode = String.isNotBlank(ZipCode) ? ZipCode : '';
            radius = String.isNotBlank(radius) ? radius : '';
            city = String.isNotBlank(city) ? city.toUpperCase() : '';
            State = String.isNotBlank(State) ? State : '';
            networkType = String.isNotBlank(networkType) ? networkType : '';
            benefitPlanId = String.isNotBlank(benefitPlanId) ? benefitPlanId : '';
            NewpatientsInd = String.isNotBlank(NewpatientsInd) ? NewpatientsInd : '';
            existingpatientsInd = String.isNotBlank(existingpatientsInd) ? existingpatientsInd : '';
            language = String.isNotBlank(language) ? language : '';
            pcpObgnId = String.isNotBlank(pcpObgnId) ? pcpObgnId : '';
            system.debug('pcpObgnId++++'+pcpObgnId);
            String AreaCode, Phone, PhoneTypeCode;
            AreaCode = '';
            Phone = '';
            PhoneTypeCode = '';
            if(String.isNotBlank(PhoneNumber)) {
                AreaCode = PhoneNumber.substring(0, 3);
                Phone = PhoneNumber.substring(3, 10);
                PhoneTypeCode = 'TEL';
            }
            system.debug(LoggingLevel.INFO, 'AreaCode: ' + AreaCode + ', Phone: ' + Phone + ', Phone Type Code: ' + PhoneTypeCode);
            mapTaxonomyMDT = ACETProviderUtility.getProviderTaxonomy();
            if(String.isNotBlank(specialityType))
               this.specialityCheck = mapTaxonomyMDT.get(specialityType).Speciality__c;              
                                   string attributelist = '';
                                               this.adrattSet = attributelist;
                                              attributelist = 'strFormataddress';
                         
            
            /** RequestParameters = new List<String>{providerId, NPI, TaxId, LastName, FirstName, gender, specialityType, ZipCode, radius, city, State, 
                         PhoneTypeCode, AreaCode, Phone, networkType, benefitPlanId, NewpatientsInd, existingpatientsInd, language,'','', pcpObgnId, attributelist, '0', '50', '0','','',''}; */
            RequestParameters = new List<String>{providerId, NPI, TaxId, LastName, FirstName, gender, specialityType, ZipCode, radius, city, State, 
                         PhoneTypeCode, AreaCode, Phone, networkType, benefitPlanId, '','',NewpatientsInd, existingpatientsInd, language,'','','','','','', attributelist,network,'','0', '50', '0'};
                                              GetRequestBody();
            
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                oACETWSCalloutResult = ParseSuccessResponse(Response);
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Success = false;
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