public with sharing class ACET_ProviderLookupService extends ACETWebservice {
    static final string COMMON_ERROR_MESSAGE = 'Unexpected Error Occurred in the Provider Lookup Results card. Please try again. If problem persists please contact the help desk.';
    public String taxId;
    public String npi;
    public String providerId;
    public String providerType;
    public String speciality;
    public String lastNameOrFacility;
    public String firstName;
    public String state;
    public String zipCode;
    public String radius;
    public String acceptNewPatients;
    public String prefferedLab;
    public String inactiveProvs;
    public String freestandingFac;
    public String cosmosDiv;
    public String cosmosPanelNum;
    public String tciTableNum;
    public String lineofBusiness;
    public String memType;
    public Integer start;
    public Integer count;
    public Boolean filtered;
    public String benefitLevel;
    public String marketSite;
    public String entityType;
    public String sharedArrangement;
    public String obligorID;
    public String productCode;
    public String marketType;
    
    
    public void init (String taxId,
        String npi,
        String providerId,
        String providerType,
        String speciality,
        String lastNameOrFacility,
        String firstName,
        String state,
        String zipCode,
        String radius,
        String acceptNewPatients,
        String prefferedLab,
        String inactiveProvs,
        String freestandingFac,
        String cosmosDiv,
        String cosmosPanelNum,
        String tciTableNum,
        String lineofBusiness,
        String memType,              
        Integer start,
        Integer count,
        Boolean filtered,
        String benefitLevel,
        String marketSite,
        String entityType,
        String sharedArrangement,
        String obligorID,
        String productCode,
        String marketType
    ) {
        this.taxId = taxId;
        this.npi = npi;
        this.providerId = providerId;
        this.providerType = providerType;
        this.speciality = speciality;
        this.lastNameOrFacility = lastNameOrFacility;
        this.firstName = firstName;
        this.state = state;
        this.zipCode = zipCode;
        this.radius = radius;
        this.acceptNewPatients = acceptNewPatients;
        this.prefferedLab = prefferedLab;
        this.inactiveProvs = inactiveProvs;
        this.freestandingFac = freestandingFac;
        this.cosmosDiv = cosmosDiv;
        this.cosmosPanelNum = cosmosPanelNum;
        this.tciTableNum = tciTableNum;
        this.lineofBusiness = lineofBusiness;
        this.memType = memType;
        this.start = start;
        this.count = count;
        this.filtered = filtered;
        this.benefitLevel = benefitLevel;
        this.marketSite = marketSite;
        this.entityType = entityType;
        this.sharedArrangement = sharedArrangement;
        this.obligorID = obligorID;
        this.productCode = productCode;
        this.marketType = marketType;
    }

    public override void GetEndpoint () {
        //  GetEndpointDetail('findHCPEndpoint');
    }

    // US2782863 - Thanish - 12th Aug 2020 - removed get and set from wrapper
    public class ProviderLookupResultsWrapper {
        @AuraEnabled
        public String benefitLevel;
        @AuraEnabled
        public String providerName;
        @AuraEnabled
        public String miles;
        @AuraEnabled
        public String address;
        @AuraEnabled
        public String addressType;
        @AuraEnabled
        public String taxId;
        @AuraEnabled
        public String npi;
        @AuraEnabled
        public Boolean isPhysician;
        @AuraEnabled
        public String providerId;
        @AuraEnabled
        public String addressSequence;
        // US1958736 - Thanish - 5th Feb 2020
        @AuraEnabled
        public String addressId;
        // US2344866 - Sanka
        @AuraEnabled
        public String uhpd;
        @AuraEnabled
        public String qualityRatingCd;
        @AuraEnabled
        public String qualityRatingDesc;
        @AuraEnabled
        public String effRatingCd;
        @AuraEnabled
        public String effRatingDesc;
        @AuraEnabled 
        public String tierValue;
        //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
        @AuraEnabled
        public Object createSRNProviderDetails;

        //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
        @AuraEnabled public String EffectivePhoneNumber{get;set;}
        @AuraEnabled public string AddressCity{get;set;}
    }

    public override ACETWSCalloutResult queryPaginatedData (Integer pageNumber, Integer pageSize, Integer startRecord) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult ();
         Map<String, String> requestParamsMap = new Map<String, String>();
        try {
            Integer startRecordNo = (pageNumber - 1) * pageSize;

            if (startRecordNo < 0) {
                startRecordNo = 0;
            }
			
            //String url = '?app-nm=acet&start=' + startRecordNo + '&count=' + pageSize;
            String url = '&app-nm=acet&start=' + startRecordNo + '&count=' + pageSize;
            

            if (!String.isBlank (taxId)) {
                url = url + '&tax-id-nbr=' + taxId;
            }
            if (!String.isBlank (npi)) {
                url = url + '&npi-id=' + npi;
            }
            if (!String.isBlank (providerId)) {
                url = url + '&prov-id=' + providerId;
            }
            if (!String.isBlank (providerType)) {
                url = url + '&provider-type=' + providerType;
            }
            /* if (!String.isBlank (speciality)) {

                List<SAE_Speciality__mdt> speciality = [SELECT Label,Specialty_Values__c FROM SAE_Speciality__mdt WHERE Specialty_Values__c = :speciality];

                String spcCode = '';

                if(speciality != null && speciality.size() > 0)
                {
                    spcCode = speciality.get(0).Label;
                }
                
                url = url + '&spcl-typ-cd=' + spcCode;
            } */
            if (!String.isBlank (speciality)) {
                url = url + '&spcl-typ-cd=' + speciality;
            }
            if (!String.isBlank (lastNameOrFacility)) {
                String lnameReplaced = lastNameOrFacility.replace(' ', '%20');
                url = url + '&prof-last-nm=' + lnameReplaced;
            }
            if (!String.isBlank (firstName)) {
                url = url + '&prof-first-nm=' + firstName;
            }
            if (!String.isBlank (state)) {
                url = url + '&st-cd=' + state;
            }
            if (!String.isBlank (zipCode)) {
                url = url + '&zip=' + zipCode;
            }
            if (!String.isBlank (radius)) {
                url = url + '&radius=' + radius;
                if (!String.isBlank (zipCode)) {
                    url = url + '&geo-search=Y';
                }
            }
            if (!String.isBlank (prefferedLab)) {
                url = url + '&prefer-lab-ntwk-ind=Y';
            }
            if (!String.isBlank (inactiveProvs)) {
                url = url + '&active-ind=BOTH';
            }else{
                url = url + '&active-ind=ACTIVE';
            }
            if (!String.isBlank (freestandingFac)) {
                url = url + '&free-stand-facl-ind=Y';
            }
        
            if(benefitLevel == 'Tier 1' && memType == 'MR'){
                //url = url +  '&search-platform-cd=TOP&search-corp-bus-seg-cd='+EncodingUtil.urlEncode('M&R','UTF-8');
                url = url +  '&search-platform-cd=TOP&search-corp-bus-seg-cd=M%R';
                //url = url + '&contract-sel-platform-cd=TOP&contract-sel-corp-bus-seg-cd='+EncodingUtil.urlEncode('M&R','UTF-8');
           		url = url + '&contract-sel-platform-cd=TOP&contract-sel-corp-bus-seg-cd=M%R';
                
                url = url + '&member-product-cd='+ productCode;
                url = url + '&member-mkt-typ='+ marketType;
                url = url + '&process-ind=C';
                url = url + '&sa-id='+ sharedArrangement;
                url = url + '&obligor-id='+ obligorID;
                url = url + '&behavioral-ind=n&pcp-ind=p';// No Change in this Line
                if(!String.isBlank(marketSite)){
                    url = url + '&member-mkt-nbr='+marketSite;
                }
             
                url = url + '&rules-package-key=RP0001';
                url = url + '&tops-uhp-ind=1';
                url = url + '&entity-type='+ entityType;
                if(!String.isBlank(tciTableNum)){
                    url = url + '&contract-sel-ntwk-recip-id='+ tciTableNum;
                    url = url + '&search-ntwk-recip-id='+ tciTableNum;
                }
            }
            if(benefitLevel == 'Tier 1' && memType == 'EI'){
                //url = url +  '&search-platform-cd=TOP&search-corp-bus-seg-cd='+EncodingUtil.urlEncode('E&I','UTF-8');
                url = url +  '&search-platform-cd=TOP&search-corp-bus-seg-cd=E%I';
                //url = url + '&contract-sel-platform-cd=TOP&contract-sel-corp-bus-seg-cd='+EncodingUtil.urlEncode('E&I','UTF-8');
                url = url + '&contract-sel-platform-cd=TOP&contract-sel-corp-bus-seg-cd=E%I';
                
                url = url + '&member-product-cd='+ productCode;
                url = url + '&member-mkt-typ='+ marketType;
                url = url + '&process-ind=C';
                url = url + '&sa-id='+ sharedArrangement;
                url = url + '&obligor-id='+ obligorID;
                url = url + '&behavioral-ind=n&pcp-ind=p';// No Change in this Line
                if(!String.isBlank(marketSite)){
                    url = url + '&member-mkt-nbr='+marketSite;
                }
             
                url = url + '&rules-package-key=RP0001';
                url = url + '&tops-uhp-ind=1';
                url = url + '&entity-type=' + entityType;
                if(!String.isBlank(tciTableNum)){
                    url = url + '&contract-sel-ntwk-recip-id='+ tciTableNum;
                    url = url + '&search-ntwk-recip-id='+ tciTableNum;
                }
            }
            
            if(benefitLevel == 'INN'){
                if (!String.isBlank(memType)) {
                    if(memType == 'MR'){
                        if(acceptNewPatients == 'Y'){
                            url = url + '&mr-anp-sort=Y';
                        }
                        if (!String.isBlank(cosmosDiv)) {
                            url = url + '&cosmos-div='+ cosmosDiv;
                        }
                        if (!String.isBlank(cosmosPanelNum)) {
                            url = url + '&cosmos-panel-nbr='+ cosmosPanelNum; 
                        }
                    }else if(memType == 'EI'){
                        //url = url + '&search-platform-cd=TOP&search-corp-bus-seg-cd='+EncodingUtil.urlEncode('E&I','UTF-8');
                        url = url + '&search-platform-cd=TOP&search-corp-bus-seg-cd=E%I';
                        if(acceptNewPatients == 'Y'){
                            url = url + '&ei-anp-sort=Y';
                        }
                        if(!String.isBlank(tciTableNum)){
                            url = url + '&search-ntwk-recip-id='+ tciTableNum;
                        }
                    }else if(memType == 'CS'){
                        if(acceptNewPatients == 'Y'){
                            url = url + '&cs-anp-sort=Y';
                        }
                        if(!String.isBlank(lineofBusiness)){
                            url = url + '&csp-line-of-bus-cd='+ lineofBusiness;
                        }
                    }
                }
            }

            url = url + '&attribute-set=summary_0002';

            System.debug ('Request URL ::: ' + url);

            SAE_ProviderCardCtrl.ProviderDetails reqParams = new SAE_ProviderCardCtrl.ProviderDetails ();
            reqParams.IsSnapshot = true;
            reqParams.SnapshotParameters = url;
            Map<String, Object> provData = SAE_ProviderCardCtrl.getProviderSearchResponse (reqParams, false);

            Integer statCode = Integer.valueOf (provData.get ('statusCode'));
            System.debug ('Status Code -> ' + statCode);
            oACETWSCalloutResult.statusCode = statCode;

            if (statCode == 200) {
                String DataString = provData.get ('providerResponseJSON').toString ();
                SAE_ProviderResponse responseDes = SAE_ProviderResponse.parse (DataString);

                Integer recordCount = Integer.valueOf (responseDes.metadata.total);

                if (responseDes.PhysicianFacilitySummary0002Response != null && !responseDes.PhysicianFacilitySummary0002Response.isEmpty ()) {

                    List<ProviderLookupResultsWrapper> lookupResults = new List<ProviderLookupResultsWrapper> ();

                    for (SAE_ProviderResponse.PhysicianFacilitySummary0002Response resp : responseDes.PhysicianFacilitySummary0002Response) {
                        ProviderLookupResultsWrapper lookupResult = new ProviderLookupResultsWrapper ();

                         //US2954656 TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
                         ACET_CreateAuthRequest.HscProvider srnProviderDetailObject = new ACET_CreateAuthRequest.HscProvider();

                        //Provider Card Info
                        SAE_ProviderResponse.PhysicianFacilityInformation physicianInfo = resp.physicianFacilityInformation;
                        Boolean acceptNewPt = false;

                        if (!String.isBlank (physicianInfo.eiAcceptingPatientInd) ||
                            !String.isBlank (physicianInfo.mrAcceptingPatientInd) ||
                            !String.isBlank (physicianInfo.csAcceptingPatientInd)) {
                            acceptNewPt = true;
                        }

                        // if ((acceptNewPatients == 'Y') && acceptNewPt)
                      
                        //US2344866
                        String qRatingdCd = physicianInfo.qualityEfficiencyValues.qualityRatingCode;
                        String eRatingCd = physicianInfo.qualityEfficiencyValues.efficiencyRatingCode;
                        //US2954656
                        srnProviderDetailObject.qualityOutcomeType = qRatingdCd;
                        srnProviderDetailObject.efficiencyOutcomeType = eRatingCd;

                        if((qRatingdCd == 'Q03' || qRatingdCd == 'Q02') && (eRatingCd == 'E03' || eRatingCd == 'E02')){
                            lookupResult.uhpd = 'Y';
                        }else if(qRatingdCd == ' ' || eRatingCd == ' '){
                            lookupResult.uhpd = '--';
                        }else{
                            lookupResult.uhpd = 'N';
                        }
                        
                        String tier;
                        String tierType;
                        system.debug('tier::'+physicianInfo.contractInformation.tier);
                        system.debug('tierType::'+physicianInfo.contractInformation.tierType);
                        if(String.isNotBlank(physicianInfo.contractInformation.tier) && String.isNotBlank(physicianInfo.contractInformation.tierType)){
                            tier = physicianInfo.contractInformation.tier;
                            tierType = physicianInfo.contractInformation.tierType;
                            if(tier == '1'){
                                if(tier == '1' && tierType == 'PD'){
                                    lookupResult.tierValue = 'Premium Designated (UHPD)';
                                }else if(tier == '1' && tierType == 'HV'){
                                    lookupResult.tierValue = 'High Value';   
                                }else if(tier == '1' && tierType == 'HA'){
                                    lookupResult.tierValue = 'ACO'; 
                                }else if(tier == '1' && tierType == 'PF'){
                                    lookupResult.tierValue = 'Preferred Lab'; 
                                }
                            }else{
                                lookupResult.tierValue = '--'; 
                            }
                        }else if(lookupResult.uhpd == 'Y'){
                            lookupResult.tierValue  = 'Premium Designated';
                        }else{
                            lookupResult.tierValue = '--';
                        }

                        if (benefitLevel == 'Tier 1') {
                            if (tier == '1') {
                                lookupResult.benefitLevel = 'Tier 1';
                            }else{
                                lookupResult.benefitLevel = '--';
                            }
                        }else if(benefitLevel == 'INN'){
                            lookupResult.benefitLevel = 'INN';
                        }else{
                            lookupResult.benefitLevel = '--';
                        }

                        lookupResult.qualityRatingCd = qRatingdCd;
                        lookupResult.qualityRatingDesc = physicianInfo.qualityEfficiencyValues.qualityRatingDescription;
                        lookupResult.effRatingCd = eRatingCd;
                        lookupResult.effRatingDesc = physicianInfo.qualityEfficiencyValues.efficiencyRatingDescription;

                        //US1816853
                        Boolean isPysician = physicianInfo.providerType == 'P' ? true : false;
                        if (isPysician) {
                            lookupResult.providerName = physicianInfo.firstName + ' ' + physicianInfo.middleName + ' ' + physicianInfo.lastName + ' ' + physicianInfo.suffix;
                            //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
                            //Getting provider name details to be passed in create Auth API
                            srnProviderDetailObject.firstName = physicianInfo.firstName;
                            srnProviderDetailObject.lastName = physicianInfo.lastName;
                            srnProviderDetailObject.middleName = physicianInfo.middleName;
                            if(physicianInfo.taxId  != null && physicianInfo.taxId.corporateOwnerLastName  != null){
                                srnProviderDetailObject.businessName = physicianInfo.taxId.corporateOwnerLastName;
                            }
                            srnProviderDetailObject.providerCategory = 'P';
                        } else {
                            lookupResult.providerName = physicianInfo.facilityName;
                            //US2954656
                            srnProviderDetailObject.businessName =  physicianInfo.facilityName;
                            srnProviderDetailObject.providerCategory = 'H';
                        }
                        lookupResult.miles = physicianInfo.address.distance;
                        lookupResult.address = SAE_ProviderSnapshotController.createAddress (physicianInfo.address, true);
                        //US2954656
                        if(physicianInfo.address != null &&  physicianInfo.address.postalAddress != null){
                            if(physicianInfo.address.postalAddress.addressLine1 != null) srnProviderDetailObject.address1 = physicianInfo.address.postalAddress.addressLine1;
                            if(physicianInfo.address.postalAddress.addressLine2 != null) srnProviderDetailObject.address2 = physicianInfo.address.postalAddress.addressLine2;
                            if(physicianInfo.address.postalAddress.city != null) srnProviderDetailObject.city = physicianInfo.address.postalAddress.city;
                            if(physicianInfo.address.postalAddress.state != null) srnProviderDetailObject.state = physicianInfo.address.postalAddress.state;
                            if(physicianInfo.address.postalAddress.zip != null) srnProviderDetailObject.zip = physicianInfo.address.postalAddress.zip;
                            if(physicianInfo.address.postalAddress.zip4 != null) srnProviderDetailObject.zipSuffix = physicianInfo.address.postalAddress.zip4;
                            if(physicianInfo.address.postalAddress.county != null) srnProviderDetailObject.countyName = physicianInfo.address.postalAddress.county;
                        }
                        //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                         lookupResult.AddressCity = '';  lookupResult.EffectivePhoneNumber = '';
                        if(physicianInfo.address != null &&  physicianInfo.address.postalAddress != null && physicianInfo.address.postalAddress.city != null ) lookupResult.AddressCity =  physicianInfo.address.postalAddress.city;
                        if(physicianInfo.phone  != null){
                            try{
                                for(SAE_ProviderResponse.Phone phn : (List<SAE_ProviderResponse.Phone>)physicianInfo.phone){
                                    if(phn.primaryPhoneIndicator != null && phn.phoneNumber != null && phn.primaryPhoneIndicator == 'P') {
                                        lookupResult.EffectivePhoneNumber = phn.phoneNumber;
                                        srnProviderDetailObject.primaryPhone = phn.areaCode + phn.phoneNumber;
                                    }
                                }
                            }
                            catch(Exception e){system.debug('== Exception at phoneNumber Mapping'+e.getMessage());}
                        }
                        lookupResult.addressType = physicianInfo.address.addressTypeDescription;
                        lookupResult.taxId = physicianInfo.taxId.taxId;
                        //US2954656
                        if(physicianInfo.taxId  != null && physicianInfo.taxId.tpsm  != null && physicianInfo.taxId.tpsm.tpsmInd  != null){
                            srnProviderDetailObject.tpsmType = physicianInfo.taxId.tpsm.tpsmInd;
                        }
                        if(physicianInfo.contractInformation  != null && physicianInfo.contractInformation.acoId  != null ){
                            srnProviderDetailObject.acoID = physicianInfo.contractInformation.acoId;
                        }
                        if(physicianInfo.contractInformation  != null && physicianInfo.contractInformation.acoName  != null ){
                            srnProviderDetailObject.acoName = physicianInfo.contractInformation.acoName;
                        }
                        if(physicianInfo.contractInformation  != null && physicianInfo.contractInformation.topsUhpdInd  != null ){
                            srnProviderDetailObject.uhpdTierDemotInd = physicianInfo.contractInformation.topsUhpdInd;
                        }

                        lookupResult.isPhysician = physicianInfo.providerType == 'P' ? true : false;
                        lookupResult.providerId = physicianInfo.providerId;
                        lookupResult.addressSequence = physicianInfo.address.epdAddressSequenceId;
                        // US1958736 - Thanish - 5th Feb 2020
                        lookupResult.addressId = physicianInfo.address.addressId;


                        List<ACET_CreateAuthRequest.ProviderIdentifier> providerIdentifierList = new List<ACET_CreateAuthRequest.ProviderIdentifier>();
                        ACET_CreateAuthRequest.ProviderIdentifiers providerIdentifiers = new ACET_CreateAuthRequest.ProviderIdentifiers();
                        ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierTax = new ACET_CreateAuthRequest.ProviderIdentifier();
                        providerIdentifierTax.providerIDType = '03'; // US3587915 - adding 0 prefix for id type
                        providerIdentifierTax.providerIDText = lookupResult.taxId;
                        providerIdentifierList.add(providerIdentifierTax);

                        //DE315217
                        lookupResult.npi = physicianInfo.npi.get (0).npi != ' ' ? physicianInfo.npi.get (0).npi : '--';
                        //US2954656
                        ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierNpi = new ACET_CreateAuthRequest.ProviderIdentifier();
                        providerIdentifierNpi.providerIDType = '06';
                        providerIdentifierNpi.providerIDText = lookupResult.npi;
                        providerIdentifierList.add(providerIdentifierNpi);

                        //US3116511 - additional Identifiers for TTAP API - Sarma - 04/01/2021
                        ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierMpin = new ACET_CreateAuthRequest.ProviderIdentifier();
                        providerIdentifierMpin.providerIDType = '01';
                        providerIdentifierMpin.providerIDText = lookupResult.providerId;
                        providerIdentifierList.add(providerIdentifierMpin);

                        if(lookupResult.addressSequence != null && !String.isBlank(lookupResult.addressSequence)){
                            String addSeq = lookupResult.addressSequence;
                            ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierAddSeq = new ACET_CreateAuthRequest.ProviderIdentifier();
                            providerIdentifierAddSeq.providerIDType = '02';
                            providerIdentifierAddSeq.providerIDText = addSeq.replaceFirst('^0+(?!$)', '');
                            providerIdentifierList.add(providerIdentifierAddSeq);
                        }

                        providerIdentifiers.providerIdentifier = providerIdentifierList;
                        srnProviderDetailObject.providerIdentifiers = providerIdentifiers;



                        //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
                        // New Mapping for Provider details for create Auth API
                        // if(physicianInfo.specialty  != null){
                        //     if(physicianInfo.specialty.size() > 0){
                        //         String strSpecialtyType = '', strSpecialtyTypeDes = '';
                        //         System.debug(' @@@ Physician Data Jitendra ' + physicianInfo.specialty);
                        //         for(SAE_ProviderResponse.Specialty_Z objEach : physicianInfo.specialty) {
                        //             if(objEach != null && objEach.specialtyContractOrg != null
                        //                 && objEach.specialtyContractOrg[0] != null && String.isNotBlank(objEach.specialtyContractOrg[0].primaryCode)
                        //                 && objEach.specialtyContractOrg[0].primaryCode == 'P') {
                        //                     strSpecialtyType = objEach.specialty.name;
                        //                     strSpecialtyTypeDes = objEach.specialty.value;
                        //                 }
                        //         }
                        //         if(physicianInfo.specialty[0].specialty  != null && physicianInfo.specialty[0].specialty.name != null){
                        //             srnProviderDetailObject.specialtyType = strSpecialtyType;
                        //         }
                        //         if(physicianInfo.specialty[0].specialty  != null && physicianInfo.specialty[0].specialty.value != null){
                        //             srnProviderDetailObject.specialtyTypeDesc = strSpecialtyTypeDes;
                        //         }
                        //     }
                        // }
                        //

                        // US3507490	Mapping for Contract Org Type and Amendment - Sarma - 20th May 2021
                        List<ACET_CreateAuthRequest.ProviderContractOrg> providerContractOrgsList = new List<ACET_CreateAuthRequest.ProviderContractOrg> ();
                        ACET_CreateAuthRequest.ProviderContractOrgs providerContractOrgs = new ACET_CreateAuthRequest.ProviderContractOrgs ();
                        // Specialty Contract Orgs Mapping - Create Auth Logic
                        if(physicianInfo.specialty  != null){

                            Boolean isPrimaryFound = false;
                            try{
                                for(SAE_ProviderResponse.Specialty_Z specialty : (List<SAE_ProviderResponse.Specialty_Z>)physicianInfo.specialty){

                                    if(specialty.specialtyContractOrg != null){
                                        try{
                                            for(SAE_ProviderResponse.AddressContractOrg specialtyContractOrg : (List<SAE_ProviderResponse.AddressContractOrg>)specialty.specialtyContractOrg){
                                                if(specialtyContractOrg.primaryCode == 'P'){
                                                    ACET_CreateAuthRequest.ProviderContractOrg providerContractOrg = new ACET_CreateAuthRequest.ProviderContractOrg(); // DE453452
                                                    providerContractOrg.providerContractOrg = specialtyContractOrg.contractOrgCode;
                                                    providerContractOrg.providerContractContext = '03';
                                                    providerContractOrg.providerContractOrgPriority = specialtyContractOrg.primaryCode;
                                                    providerContractOrgsList.add(providerContractOrg);
                                                    if(specialty.specialty != null){
                                                        srnProviderDetailObject.specialtyType = specialty.specialty.name;
                                                        srnProviderDetailObject.specialtyTypeDesc = specialty.specialty.value;
                                        }
                                                    isPrimaryFound = true;

                                }

                                }
                                        }
                                        catch(Exception e){system.debug('Exception '+e.getMessage());}
                                }

                            }
                        }
                            catch(Exception e){system.debug('Exception '+e.getMessage());}

                            if(!isPrimaryFound && physicianInfo.specialty.size() > 0){
                                if(physicianInfo.specialty[0].specialtyContractOrg != null && physicianInfo.specialty[0].specialtyContractOrg.size() > 0){
                                    for(SAE_ProviderResponse.AddressContractOrg specialtyContractOrg : (List<SAE_ProviderResponse.AddressContractOrg>)physicianInfo.specialty[0].specialtyContractOrg){
                                        if(specialtyContractOrg != null && specialtyContractOrg.primaryCode == 'S'){
                                            ACET_CreateAuthRequest.ProviderContractOrg providerContractOrg = new ACET_CreateAuthRequest.ProviderContractOrg();
                                            providerContractOrg.providerContractOrg = specialtyContractOrg.contractOrgCode;
                                            providerContractOrg.providerContractContext = '03';
                                            providerContractOrg.providerContractOrgPriority = specialtyContractOrg.primaryCode;
                                            providerContractOrgsList.add(providerContractOrg);
                                        }
                                    }
                                    if(physicianInfo.specialty[0].specialty != null){
                                        srnProviderDetailObject.specialtyType = physicianInfo.specialty[0].specialty.name;
                                        srnProviderDetailObject.specialtyTypeDesc = physicianInfo.specialty[0].specialty.value;
                                    }
                                }
                            }
                        }
                        // Address Contract Orgs Mapping - Create Auth Logic
                        if(physicianInfo.address != null){
                            try{
                                if(physicianInfo.address.addressContractOrg != null && physicianInfo.address.addressContractOrg.size() > 0){
                                    for(SAE_ProviderResponse.AddressContractOrg addressContractOrgObj : (List<SAE_ProviderResponse.AddressContractOrg>)physicianInfo.address.addressContractOrg){
                                        if(addressContractOrgObj.contrOrgEffDate != null && addressContractOrgObj.contrOrgEffDate != '' && addressContractOrgObj.contrOrgCancDate != null && addressContractOrgObj.contrOrgCancDate != ''){
                                            Date startDate = Date.valueOf(addressContractOrgObj.contrOrgEffDate);
                                            Date endDate = Date.valueOf(addressContractOrgObj.contrOrgCancDate);
                                            Date currentDate = Date.today();
                                            if(currentDate >= startDate && currentDate<= endDate){
                                                ACET_CreateAuthRequest.ProviderContractOrg providerContractOrg = new ACET_CreateAuthRequest.ProviderContractOrg();
                                                providerContractOrg.providerContractOrg = addressContractOrgObj.contractOrgCode;
                                                providerContractOrg.providerContractContext = '01';
                                                providerContractOrg.providerContractOrgPriority = addressContractOrgObj.primaryCode;
                                                providerContractOrgsList.add(providerContractOrg);

                                            }
                                        }
                                    }
                                }
                            } catch(Exception e){system.debug('Exception '+e.getMessage());}
                        }
                        // US3507490 Ends
                        providerContractOrgs.providerContractOrg = providerContractOrgsList;

                        srnProviderDetailObject.providerContractOrgs = providerContractOrgs;

                        if(physicianInfo.providerEffectiveDate  != null){srnProviderDetailObject.providerEffectiveDate = physicianInfo.providerEffectiveDate;  }
                        if(physicianInfo.providerCancelDate  != null){srnProviderDetailObject.providerTerminationDate = physicianInfo.providerCancelDate;  }

                        lookupResult.createSRNProviderDetails = srnProviderDetailObject;
                        System.debug('XXX createSRNProviderDetails'+ lookupResult.createSRNProviderDetails);


                        if ((acceptNewPatients == 'Y') && acceptNewPt) {
                            if(this.filtered){
                                if(physicianInfo.address.addressTypeCode == 'D' || physicianInfo.address.addressTypeCode == 'L'){
                                    lookupResults.add (lookupResult);
                                }
                            }else{
                            lookupResults.add (lookupResult);
                            }
                        } else if (acceptNewPatients != 'Y') {
                            // lookupResults.add (lookupResult);
                            if(this.filtered){
                                if(physicianInfo.address.addressTypeCode == 'D' || physicianInfo.address.addressTypeCode == 'L'){
                                    lookupResults.add (lookupResult);
                                }
                            }else{
                            lookupResults.add (lookupResult);
                        }
                        }
                    }

                        oACETWSCalloutResult.Response = lookupResults;
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.pageNumber = String.valueOf (pageNumber);
                        oACETWSCalloutResult.pageSize = String.valueOf (pageSize);
                        oACETWSCalloutResult.recordCount = String.valueOf (recordCount);
                        oACETWSCalloutResult.totalCount = String.valueOf (recordCount);
                        oACETWSCalloutResult.statusCode = statCode;
                    // US2782878 - Thanish - 19th Aug 2020 - Calling provider service again if cosmosDiv is ATL/KEN/NTL
                    } else {
                        if((cosmosDiv == 'ATL') || (cosmosDiv == 'KEN') || (cosmosDiv == 'NTL')){
                            String modifiedUrl = url.replace('&cosmos-div='+ cosmosDiv, '&cosmos-div=MNR');
                            reqParams.SnapshotParameters = modifiedUrl;
                            Map<String, Object> mnrProvData = SAE_ProviderCardCtrl.getProviderSearchResponse(reqParams, false);
                            Integer mnrStatCode = Integer.valueOf(mnrProvData.get('statusCode'));

                            if(mnrStatCode == 200){
                                String mnrDataString = mnrProvData.get('providerResponseJSON').toString();
                                SAE_ProviderResponse mnrResponseDes = SAE_ProviderResponse.parse(mnrDataString);
                                Integer mnrRecordCount = Integer.valueOf(mnrResponseDes.metadata.total);

                                if(mnrResponseDes.PhysicianFacilitySummary0002Response != null && !mnrResponseDes.PhysicianFacilitySummary0002Response.isEmpty()){
                                    List<ProviderLookupResultsWrapper> lookupResults = new List<ProviderLookupResultsWrapper> ();
                
                                    for(SAE_ProviderResponse.PhysicianFacilitySummary0002Response resp : mnrResponseDes.PhysicianFacilitySummary0002Response){
                                        ProviderLookupResultsWrapper lookupResult = new ProviderLookupResultsWrapper();
                                        //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
                                        ACET_CreateAuthRequest.HscProvider srnProviderDetailObject = new ACET_CreateAuthRequest.HscProvider();

                                        //Provider Card Info
                                        SAE_ProviderResponse.PhysicianFacilityInformation physicianInfo = resp.physicianFacilityInformation;
                                        Boolean acceptNewPt = false;
                
                                        if (!String.isBlank (physicianInfo.eiAcceptingPatientInd) || !String.isBlank (physicianInfo.mrAcceptingPatientInd) || !String.isBlank (physicianInfo.csAcceptingPatientInd)) {
                                            acceptNewPt = true;
                                        }
                                        
                                        String qRatingdCd = physicianInfo.qualityEfficiencyValues.qualityRatingCode;
                                        String eRatingCd = physicianInfo.qualityEfficiencyValues.efficiencyRatingCode;
                                        //US2954656
                                        srnProviderDetailObject.qualityOutcomeType = qRatingdCd;
                                        srnProviderDetailObject.efficiencyOutcomeType = eRatingCd;

                                        if((qRatingdCd == 'Q03' || qRatingdCd == 'Q02') && (eRatingCd == 'E03' || eRatingCd == 'E02')){
                                            lookupResult.uhpd = 'Y';
                                        }else if(qRatingdCd == ' ' || eRatingCd == ' '){
                                            lookupResult.uhpd = '--';
                                        }else{
                                            lookupResult.uhpd = 'N';
                                        }
                                        
                                        String tier;
                                        String tierType;
                                        system.debug('tier::'+physicianInfo.contractInformation.tier);
                                        system.debug('tierType::'+physicianInfo.contractInformation.tierType);
                                        if(String.isNotBlank(physicianInfo.contractInformation.tier) && String.isNotBlank(physicianInfo.contractInformation.tierType)){
                                            tier = physicianInfo.contractInformation.tier;
                                            tierType = physicianInfo.contractInformation.tierType;
                                            if(tier == '1'){
                                                if(tier == '1' && tierType == 'PD'){
                                                    lookupResult.tierValue = 'Premium Designated (UHPD)';
                                                }else if(tier == '1' && tierType == 'HV'){
                                                    lookupResult.tierValue = 'High Value';   
                                                }else if(tier == '1' && tierType == 'HA'){
                                                    lookupResult.tierValue = 'ACO'; 
                                                }else if(tier == '1' && tierType == 'PF'){
                                                    lookupResult.tierValue = 'Preferred Lab'; 
                                                }
                                            }else{
                                                lookupResult.tierValue = '--'; 
                                            }
                                        }else if(lookupResult.uhpd == 'Y'){
                                            lookupResult.tierValue  = 'Premium Designated';
                                        }else{
                                            lookupResult.tierValue = '--';
                                        }
                                        
                                        if(benefitLevel == 'Tier 1'){
                                            if(tier == '1'){
                                                lookupResult.benefitLevel = 'Tier 1';
                                            }else{
                                                lookupResult.benefitLevel = '--';
                                            }
                                        }else if(benefitLevel == 'INN'){
                                            lookupResult.benefitLevel = 'INN';
                                        }else{
                                            lookupResult.benefitLevel = '--';
                                        }
                
                                        lookupResult.qualityRatingCd = qRatingdCd;
                                        lookupResult.qualityRatingDesc = physicianInfo.qualityEfficiencyValues.qualityRatingDescription;
                                        lookupResult.effRatingCd = eRatingCd;
                                        lookupResult.effRatingDesc = physicianInfo.qualityEfficiencyValues.efficiencyRatingDescription;
                
                                        Boolean isPysician = physicianInfo.providerType == 'P' ? true : false;
                                        if (isPysician) {
                                            lookupResult.providerName = physicianInfo.firstName + ' ' + physicianInfo.middleName + ' ' + physicianInfo.lastName + ' ' + physicianInfo.suffix;
                                            //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
                                            //Getting provider name details to be passed in create Auth API
                                            srnProviderDetailObject.firstName = physicianInfo.firstName;
                                            srnProviderDetailObject.lastName = physicianInfo.lastName;
                                            srnProviderDetailObject.middleName = physicianInfo.middleName;
                                            if(physicianInfo.taxId  != null && physicianInfo.taxId.corporateOwnerLastName  != null){
                                                srnProviderDetailObject.businessName = physicianInfo.taxId.corporateOwnerLastName;
                                            }
                                            srnProviderDetailObject.providerCategory = 'P';
                                        } else {
                                            lookupResult.providerName = physicianInfo.facilityName;
                                            //US2954656
                                            srnProviderDetailObject.businessName =  physicianInfo.facilityName;
                                            srnProviderDetailObject.providerCategory = 'H';
                                        }
                                        lookupResult.miles = physicianInfo.address.distance;
                                        lookupResult.address = SAE_ProviderSnapshotController.createAddress (physicianInfo.address, true);
                                        //US2954656
                                        if(physicianInfo.address != null &&  physicianInfo.address.postalAddress != null){
                                            if(physicianInfo.address.postalAddress.addressLine1 != null) {srnProviderDetailObject.address1 = physicianInfo.address.postalAddress.addressLine1;}
                                            if(physicianInfo.address.postalAddress.addressLine2 != null) {srnProviderDetailObject.address2 = physicianInfo.address.postalAddress.addressLine2;}
                                            if(physicianInfo.address.postalAddress.city != null) {srnProviderDetailObject.city = physicianInfo.address.postalAddress.city;}
                                            if(physicianInfo.address.postalAddress.state != null) {srnProviderDetailObject.state = physicianInfo.address.postalAddress.state;}
                                            if(physicianInfo.address.postalAddress.zip != null) {srnProviderDetailObject.zip = physicianInfo.address.postalAddress.zip;}
                                            if(physicianInfo.address.postalAddress.zip4 != null) {srnProviderDetailObject.zipSuffix = physicianInfo.address.postalAddress.zip4;}
                                            if(physicianInfo.address.postalAddress.county != null) {srnProviderDetailObject.countyName = physicianInfo.address.postalAddress.county;}
                                        }

                                        lookupResult.addressType = physicianInfo.address.addressTypeDescription;
                                        lookupResult.taxId = physicianInfo.taxId.taxId;
                                        //US2954656
                                        if(physicianInfo.taxId  != null && physicianInfo.taxId.tpsm  != null && physicianInfo.taxId.tpsm.tpsmInd  != null){
                                            srnProviderDetailObject.tpsmType = physicianInfo.taxId.tpsm.tpsmInd;
                                        }
                                        if(physicianInfo.contractInformation  != null && physicianInfo.contractInformation.acoId  != null ){
                                            srnProviderDetailObject.acoID = physicianInfo.contractInformation.acoId;
                                        }
                                        if(physicianInfo.contractInformation  != null && physicianInfo.contractInformation.acoName  != null ){
                                            srnProviderDetailObject.acoName = physicianInfo.contractInformation.acoName;
                                        }
                                        if(physicianInfo.contractInformation  != null && physicianInfo.contractInformation.topsUhpdInd  != null ){
                                            srnProviderDetailObject.uhpdTierDemotInd = physicianInfo.contractInformation.topsUhpdInd;
                                        }
                                        if(physicianInfo.providerEffectiveDate  != null){srnProviderDetailObject.providerEffectiveDate = physicianInfo.providerEffectiveDate;  }
                                        if(physicianInfo.providerCancelDate  != null){srnProviderDetailObject.providerTerminationDate = physicianInfo.providerCancelDate;  }

                                        lookupResult.isPhysician = physicianInfo.providerType == 'P' ? true : false;
                                        lookupResult.providerId = physicianInfo.providerId;
                                        lookupResult.addressSequence = physicianInfo.address.epdAddressSequenceId;
                                        lookupResult.addressId = physicianInfo.address.addressId;
                                        //US2954656

                                        List<ACET_CreateAuthRequest.ProviderIdentifier> providerIdentifierList = new List<ACET_CreateAuthRequest.ProviderIdentifier>();
                                        ACET_CreateAuthRequest.ProviderIdentifiers providerIdentifiers = new ACET_CreateAuthRequest.ProviderIdentifiers();
                                        ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierTax = new ACET_CreateAuthRequest.ProviderIdentifier();
                                        providerIdentifierTax.providerIDType = '03';
                                        providerIdentifierTax.providerIDText = lookupResult.taxId;
                                        providerIdentifierList.add(providerIdentifierTax);

                                        lookupResult.npi = physicianInfo.npi.get (0).npi != ' ' ? physicianInfo.npi.get (0).npi : '--';
                                        //US2954656
                                        ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierNpi = new ACET_CreateAuthRequest.ProviderIdentifier();
                                        providerIdentifierNpi.providerIDType = '06';
                                        providerIdentifierNpi.providerIDText = lookupResult.npi;
                                        providerIdentifierList.add(providerIdentifierNpi);
                                        //US3116511 - additional Identifiers for TTAP API - Sarma - 04/01/2021
                                        ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierMpin = new ACET_CreateAuthRequest.ProviderIdentifier();
                                        providerIdentifierMpin.providerIDType = '01';
                                        providerIdentifierMpin.providerIDText = lookupResult.providerId;
                                        providerIdentifierList.add(providerIdentifierMpin);

                                        if(lookupResult.addressSequence != null && !String.isBlank(lookupResult.addressSequence)){
                                            String addSeq = lookupResult.addressSequence;
                                            ACET_CreateAuthRequest.ProviderIdentifier providerIdentifierAddSeq = new ACET_CreateAuthRequest.ProviderIdentifier();
                                            providerIdentifierAddSeq.providerIDType = '02';
                                            providerIdentifierAddSeq.providerIDText = addSeq.replaceFirst('^0+(?!$)', '');
                                            providerIdentifierList.add(providerIdentifierAddSeq);
                                        }


                                        providerIdentifiers.providerIdentifier = providerIdentifierList;
                                        srnProviderDetailObject.providerIdentifiers = providerIdentifiers;
                                        //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
                                        // New Mapping for Provider details for create Auth API
                                        if(physicianInfo.phone  != null){
                                            try{
                                                for(SAE_ProviderResponse.Phone phn : (List<SAE_ProviderResponse.Phone>)physicianInfo.phone){
                                                    if(phn.primaryPhoneIndicator != null && phn.phoneNumber != null && phn.primaryPhoneIndicator == 'P') {
                                                        srnProviderDetailObject.primaryPhone = phn.areaCode + phn.phoneNumber;
                                                    }
                                                }
                                            }
                                            catch(Exception e){system.debug('== Exception at phoneNumber Mapping'+e.getMessage());}
                                        }
                                         // US3507490	Mapping for Contract Org Type and Amendment - Sarma - 20th May 2021
                                        List<ACET_CreateAuthRequest.ProviderContractOrg> providerContractOrgsList = new List<ACET_CreateAuthRequest.ProviderContractOrg> ();
                                        ACET_CreateAuthRequest.ProviderContractOrgs providerContractOrgs = new ACET_CreateAuthRequest.ProviderContractOrgs ();
                                        // Specialty Contract Orgs Mapping - Create Auth Logic
                                        if(physicianInfo.specialty  != null){

                                            Boolean isPrimaryFound = false;
                                            try{
                                                for(SAE_ProviderResponse.Specialty_Z specialty : (List<SAE_ProviderResponse.Specialty_Z>)physicianInfo.specialty){

                                                    if(specialty.specialtyContractOrg != null){
                                                        try{
                                                            for(SAE_ProviderResponse.AddressContractOrg specialtyContractOrg : (List<SAE_ProviderResponse.AddressContractOrg>)specialty.specialtyContractOrg){
                                                                if(specialtyContractOrg.primaryCode == 'P'){
                                                                    ACET_CreateAuthRequest.ProviderContractOrg providerContractOrg = new ACET_CreateAuthRequest.ProviderContractOrg(); // DE453452
                                                                    providerContractOrg.providerContractOrg = specialtyContractOrg.contractOrgCode;
                                                                    providerContractOrg.providerContractContext = '03';
                                                                    providerContractOrg.providerContractOrgPriority = specialtyContractOrg.primaryCode;
                                                                    providerContractOrgsList.add(providerContractOrg);
                                                                    if(specialty.specialty != null){
                                                                        srnProviderDetailObject.specialtyType = specialty.specialty.name;
                                                                        srnProviderDetailObject.specialtyTypeDesc = specialty.specialty.value;
                                                                    }
                                                                    isPrimaryFound = true;
                                                                }
                                                            }
                                                        }
                                                        catch(Exception e){system.debug('Exception '+e.getMessage());}
                                                    }
                                                }
                                            }
                                            catch(Exception e){system.debug('Exception '+e.getMessage());}

                                            if(!isPrimaryFound && physicianInfo.specialty.size() > 0){
                                                if(physicianInfo.specialty[0].specialtyContractOrg != null && physicianInfo.specialty[0].specialtyContractOrg.size() > 0){
                                                    for(SAE_ProviderResponse.AddressContractOrg specialtyContractOrg : (List<SAE_ProviderResponse.AddressContractOrg>)physicianInfo.specialty[0].specialtyContractOrg){
                                                        if(specialtyContractOrg != null && specialtyContractOrg.primaryCode == 'S'){
                                                            ACET_CreateAuthRequest.ProviderContractOrg providerContractOrg = new ACET_CreateAuthRequest.ProviderContractOrg();
                                                            providerContractOrg.providerContractOrg = specialtyContractOrg.contractOrgCode;
                                                            providerContractOrg.providerContractContext = '03';
                                                            providerContractOrg.providerContractOrgPriority = specialtyContractOrg.primaryCode;
                                                            providerContractOrgsList.add(providerContractOrg);
                                                        }
                                                    }
                                                    if(physicianInfo.specialty[0].specialty != null){
                                                    srnProviderDetailObject.specialtyType = physicianInfo.specialty[0].specialty.name;
                                                    srnProviderDetailObject.specialtyTypeDesc = physicianInfo.specialty[0].specialty.value;
                                                }
                                            }
                                        }
                                        }
                                        // Address Contract Orgs Mapping - Create Auth Logic
                                        if(physicianInfo.address != null){
                                            try{
                                                if(physicianInfo.address.addressContractOrg != null && physicianInfo.address.addressContractOrg.size() > 0){
                                                    for(SAE_ProviderResponse.AddressContractOrg addressContractOrgObj : (List<SAE_ProviderResponse.AddressContractOrg>)physicianInfo.address.addressContractOrg){
                                                        if(addressContractOrgObj.contrOrgEffDate != null && addressContractOrgObj.contrOrgEffDate != '' && addressContractOrgObj.contrOrgCancDate != null && addressContractOrgObj.contrOrgCancDate != ''){
                                                            Date startDate = Date.valueOf(addressContractOrgObj.contrOrgEffDate);
                                                            Date endDate = Date.valueOf(addressContractOrgObj.contrOrgCancDate);
                                                            Date currentDate = Date.today();
                                                            if(currentDate >= startDate && currentDate<= endDate){
                                                                ACET_CreateAuthRequest.ProviderContractOrg providerContractOrg = new ACET_CreateAuthRequest.ProviderContractOrg();
                                                                providerContractOrg.providerContractOrg = addressContractOrgObj.contractOrgCode;
                                                                providerContractOrg.providerContractContext = '01';
                                                                providerContractOrg.providerContractOrgPriority = addressContractOrgObj.primaryCode;
                                                                providerContractOrgsList.add(providerContractOrg);

                                                            }
                                                        }
                                                    }
                                                }
                                            } catch(Exception e){system.debug('Exception '+e.getMessage());}
                                        }
                                        providerContractOrgs.providerContractOrg = providerContractOrgsList;

                                        srnProviderDetailObject.providerContractOrgs = providerContractOrgs;
                                        // US3507490 Ends
                                        lookupResult.createSRNProviderDetails = srnProviderDetailObject;

                                        if ((acceptNewPatients == 'Y') && acceptNewPt) {
                                            if(this.filtered){
                                                if(physicianInfo.address.addressTypeCode == 'D' || physicianInfo.address.addressTypeCode == 'L'){
                                                    lookupResults.add (lookupResult);
                                                }
                                            }else{
                                            lookupResults.add (lookupResult);
                                            }
                                        } else if (acceptNewPatients != 'Y') {
                                            if(this.filtered){
                                                if(physicianInfo.address.addressTypeCode == 'D' || physicianInfo.address.addressTypeCode == 'L'){
                                                    lookupResults.add (lookupResult);
                                                }
                                            }else{
                                                lookupResults.add (lookupResult);
                                            }
                                        }
                                    }
                
                                    oACETWSCalloutResult.Response = lookupResults;
                                    oACETWSCalloutResult.Success = true;
                                    oACETWSCalloutResult.Message = '';
                                    oACETWSCalloutResult.pageNumber = String.valueOf (pageNumber);
                                    oACETWSCalloutResult.pageSize = String.valueOf (pageSize);
                                    oACETWSCalloutResult.recordCount = String.valueOf (recordCount);
                                    oACETWSCalloutResult.totalCount = String.valueOf (recordCount);
                                    oACETWSCalloutResult.statusCode = statCode;
                                }
                            } else{
                                oACETWSCalloutResult.Success = false;
                                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                                oACETWSCalloutResult.statusCode = mnrStatCode;
                
                                String message = '';
                
                                if (mnrStatCode == 400) {
                                    // Not Valid for Provider
                                    // message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
                                    message = 'Bad Request';
                                } else if (mnrStatCode == 404) {
                                    // Not Valid for Provider
                                    // message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                                    message = 'Not Found';
                                } else if (mnrStatCode == 500) {
                                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
                                } else if (mnrStatCode == 100) {
                                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN100);
                                } else {
                                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
                                }
                
                                oACETWSCalloutResult.Message = message;
                            }
                        }
                    }
                    // US2782878 - Thanish - 19th Aug 2020 - Calling provider service again if cosmosDiv is ATL/KEN/NTL - End of Code
            } else {
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                oACETWSCalloutResult.statusCode = statCode;

                String message = COMMON_ERROR_MESSAGE;

                /*if (statCode == 400) {
                    // Not Valid for Provider
                    // message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
                    message = 'Bad Request';
                } else if (statCode == 404) {
                    // Not Valid for Provider
                    // message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                    message = 'Not Found';
                } else if (statCode == 500) {
                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN500A);
                } else if (statCode == 100) {
                    message = SAEMemberProviderWS.getErrorMessage (SAEConstants.GN100);
                } else {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }*/

                oACETWSCalloutResult.Message = message;
            }

        } catch (Exception ex) {
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = COMMON_ERROR_MESSAGE;
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode = 999;

            // For Dev Debugging
            String DevError = SAEConstants.debugMsg;
            DevError.replace ('{ClassName}', 'ACET_ProviderLookupService')
                .replace ('{LineNumber}', String.valueOf (ex.getLineNumber ()));
            System.debug (DevError);
            System.debug ('Error Occured::: '+ ex.getLineNumber ());
        }

        return oACETWSCalloutResult;
    }
}