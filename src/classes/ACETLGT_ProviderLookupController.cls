public class ACETLGT_ProviderLookupController { 
  @AuraEnabled
  public static List<String> getClassifications(string providerType){
    List<string> optionsList = new List<string>();    
      For(String str: ACETLGT_ProviderUtility.getClasifications(providerType).keyset()) {
          Set<String> keyStr = ACETLGT_ProviderUtility.getClasifications(providerType).get(str);
          optionsList.addAll(keyStr);
      }
      System.debug('optionsList'+optionsList);
      return optionsList;
    }
    @AuraEnabled
    public static List <Language_Codes__mdt> getLanguagescmdt(){
       return new List<Language_Codes__mdt>([select Label,DeveloperName from Language_Codes__mdt order by Label asc]);
    }
    @AuraEnabled
    public static List<String> getSpecilities(string providerType,string classification){
        List<string> optionsList = new List<string>();    
        String keyStr = providerType+''+classification;
        System.debug('keyStr'+keyStr);
        Set<String> keyList = ACETLGT_ProviderUtility.getSpecilities(providerType).get(keyStr);
        optionsList.addAll(keyList);
        System.debug('optionsList'+optionsList);
        return optionsList;
    }
    @AuraEnabled
    public static List<Network_Values__mdt> getNetworks(){ 
      return new List<Network_Values__mdt>([select Label,Network_ID__c from Network_Values__mdt order by Label asc]);
  }
    
  @AuraEnabled
    public static List<String> getNetworkVal(String netVal){ 
        List<String> defNetworkList = new List<String>();
        String defNetworkValue, defNetworkName, defNetworkId;
        try {
            List<ACETNetworkValues__mdt> val = [SELECT NetworkValue__c, Network_ID__c from ACETNetworkValues__mdt WHERE Label =: netVal];
            if(val.size() > 0){
                defNetworkName = val[0].NetworkValue__c;
                defNetworkId = val[0].Network_ID__c;
                defNetworkValue = defNetworkId+'_'+defNetworkName;
                defNetworkList.add(defNetworkValue);
                system.debug('@@val'+val);
            }
        }catch(Exception e){
            system.debug('ACETLGT_ProviderLookupController.getNetworkVal Exception ::' + e.getMessage());
        }
        return defNetworkList;
        
  }
  public class SearchResultWrapper{
        @AuraEnabled public List<ACETLGT_ProviderLookupResult> resultWrapper {get;set;}
       @Auraenabled
      public string service;
      public SearchResultWrapper(String service){
            this.service = service;        
        } 
    }
    public class SearchResultBenefitsWrapper {
        @AuraEnabled public Map<String,String> benefitTierMap {get;set;}
        @AuraEnabled  public Map<String,String> serviceAreaTypeMap {get;set;}
        @AuraEnabled  public Map<String,List<String>> networkMap {get;set;}
        @AuraEnabled public Set<String> benefitServiceSet{get;set;}
        @AuraEnabled public String qualityProviderRuleId{get;set;}
    }
    
     @AuraEnabled
    public static SearchResultWrapper getProviderLookupResults(String providerId, String npi, String taxId, String lastName, String firstName, String gender,String classification,String specialty,String searchPcpOBGYNId,String PostalPrefixCode, String radius, String City, String StateCode,
                                                               String PhoneNumber,String networkId,String BenefitServiceArea,String ServiceAreaType,String contractClaimType,String NewPatientIndicator,String languageCode, String ProviderTypeCode,String attributelist, String isLookupflow,String FilterByStatus,String PFS,String networkType,String ddpChecked){
                                                                   return getProviderLookupResults( providerId,  npi,  taxId,  lastName,  firstName,  gender, classification, specialty, searchPcpOBGYNId, PostalPrefixCode,  radius,  City,  StateCode,
                                                                PhoneNumber, networkId, null, null, BenefitServiceArea, ServiceAreaType, contractClaimType, NewPatientIndicator, languageCode,  ProviderTypeCode, attributelist,  isLookupflow, FilterByStatus, PFS,networkType,ddpChecked);
                                                               }

    @AuraEnabled
    public static SearchResultWrapper getProviderLookupResults(String providerId, String npi, String taxId, String lastName, String firstName, String gender,String classification,String specialty,String searchPcpOBGYNId,String PostalPrefixCode, String radius, String City, String StateCode,
                                                                                            String PhoneNumber,String networkId,String qualityTierRuleId,String qualityTierLevel,String BenefitServiceArea,String ServiceAreaType,String contractClaimType,String NewPatientIndicator,String languageCode, String ProviderTypeCode,String attributelist, String isLookupflow,String FilterByStatus,String PFS,String networkType,String ddpChecked){
        String service; 
        String specCode; 
        Map<String,String> SpecCodes = new map<string,string>();
        for(Provider_Taxonomy__mdt prodTax : [select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt order by Classification__c asc]){       
            SpecCodes.put(prodTax.Classification__c+'#'+prodTax.Speciality__c, prodTax.Speciality_Code__c);  
        }                                                                                        
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();   
        if (string.isNotBlank(classification) && string.isNotBlank(specialty)) {
            if (SpecCodes.containsKey(classification+'#'+specialty)) {
                specCode=SpecCodes.get(classification+'#'+specialty);
            }
       } 
       System.debug('specCode' +specCode);  
       System.debug('classification' +classification);   
       System.debug('specialty'+specialty);  
       System.debug('state' +StateCode); 
       System.debug('PhoneNumber' +PhoneNumber);                                                                                       
     if(ProviderTypeCode == '') {
        ACETLGT_FindProviderLookupWebservice ACTFPWS = new ACETLGT_FindProviderLookupWebservice();  
         ACTFPWS.network = String.isNotBlank(networkType) && networkType.trim()=='INN Only'?'A':'';
       
             ACTFPWS.Init(providerId, npi, taxId, lastName, firstName, gender,specCode,searchPcpOBGYNId, PostalPrefixCode, radius, city, StateCode, PhoneNumber,networkId,qualityTierRuleId,qualityTierLevel,BenefitServiceArea,ServiceAreaType,contractClaimType,
                    NewPatientIndicator, languageCode, ProviderTypeCode,attributelist,isLookupflow,FilterByStatus,PFS,ddpChecked);
             ACTFPWS.GetEndpoint();   
             service = JSON.serialize(ACTFPWS).replace('\'', '&#x27;');
             service = service.replace('&#x27;', '\'');
     }else if(ProviderTypeCode == 'Physician') {
            ACETLGT_FindHCPWebservice ACTFHCP = new ACETLGT_FindHCPWebservice();   
         ACTFHCP.network = String.isNotBlank(networkType) && networkType.trim()=='INN Only'?'A':'';
                ACTFHCP.Init(providerId, npi, taxId, lastName, firstName, gender,specCode,searchPcpOBGYNId,PostalPrefixCode, radius, city, StateCode, PhoneNumber,networkId,qualityTierRuleId,qualityTierLevel,BenefitServiceArea,ServiceAreaType,contractClaimType,
                                 NewPatientIndicator, languageCode, ProviderTypeCode,attributelist,isLookupflow,FilterByStatus,PFS);
               ACTFHCP.GetEndpoint();   
               service = JSON.serialize(ACTFHCP).replace('\'', '&#x27;');
         system.debug('service===>'+service);
     }else if(ProviderTypeCode == 'Facility') {
         ACETLGT_FindHCOWebservice ACTFHCO = new ACETLGT_FindHCOWebservice();     
         ACTFHCO.network = String.isNotBlank(networkType) && networkType.trim()=='INN Only'?'A':'';
              ACTFHCO.Init(providerId, npi, taxId, lastName, firstName, gender,specCode,searchPcpOBGYNId,PostalPrefixCode, radius, city, StateCode, PhoneNumber,networkId,BenefitServiceArea,ServiceAreaType,contractClaimType,
                             NewPatientIndicator, languageCode, ProviderTypeCode,attributelist,isLookupflow,FilterByStatus,PFS,ddpChecked);  
               ACTFHCO.GetEndpoint();   
               service = JSON.serialize(ACTFHCO).replace('\'', '&#x27;');
               service = service.replace('&#x27;', '\'');
      }
          return new SearchResultWrapper(JSON.serialize(service));
                                                                                         
    }
    
     @AuraEnabled
    public static SearchResultBenefitsWrapper getSearchResults(String surrogateKey, String bundleId, String enrollerSRK, String startDate, 
                                                               String endDate, String coverageTypes, String groupNumber, String accumAsOf,String SitusState){
                                                                   return getSearchResults( surrogateKey,  bundleId,  enrollerSRK,  startDate, 
                                                                                           endDate,  coverageTypes,  groupNumber,  accumAsOf, SitusState,null,null);
                                                               }
    
    
     @AuraEnabled
    public static SearchResultBenefitsWrapper getSearchResults(String surrogateKey, String bundleId, String enrollerSRK, String startDate, 
    String endDate, String coverageTypes, String groupNumber, String accumAsOf,String SitusState,String planId,String customerPurchaseId){
        
         System.debug('surrogateKey:'+ surrogateKey);
         System.debug('bundleId:'+ bundleId);
         System.debug('enrollerSRK:'+ enrollerSRK);
         System.debug('startDate:'+ startDate);
         System.debug('endDate:'+ endDate);
         System.debug('coverageTypes:'+ coverageTypes);
         System.debug('groupNumber:'+ groupNumber);
         System.debug('accumAsOf:'+ accumAsOf); 
         System.debug('SitusState:'+ SitusState);
         System.debug('planId:'+ planId);
         ACETLGT_NimbusGetSSBAPI getPlanBenefitService = new ACETLGT_NimbusGetSSBAPI();
         ACETWSCalloutResult CalloutResult = getPlanBenefitService.getSubBenefitSearch(bundleId,enrollerSRK,surrogateKey,startDate, 
            endDate, coverageTypes, groupNumber,accumAsOf,SitusState,planId,customerPurchaseId);
       
         ACETGroupPlanBenefitLEXWrapper resultWrapper = new ACETGroupPlanBenefitLEXWrapper(); 
         if (CalloutResult.Success){   
                resultWrapper = (ACETGroupPlanBenefitLEXWrapper)CalloutResult.Response;
         } 
            SearchResultBenefitsWrapper detWrap = new SearchResultBenefitsWrapper();
            if(resultWrapper != null) {
                if(resultWrapper.tierDescMap != null){
                   detWrap.benefitTierMap = resultWrapper.tierDescMap;
                }
                if(resultWrapper.sAreaType != null){
                  detWrap.serviceAreaTypeMap = resultWrapper.sAreaType;
                }
                if(resultWrapper.networkMap != null) {
                    detWrap.networkMap = resultWrapper.networkMap;
                }
                if(resultWrapper.benefitServiceSet != null) {
                     detWrap.benefitServiceSet = resultWrapper.benefitServiceSet;  
                 }
                if(resultWrapper.qualityProviderTierRuleID !=null){
                    detWrap.qualityProviderRuleId = resultWrapper.qualityProviderTierRuleID;
                }
            }
            return detWrap;

    }

  }