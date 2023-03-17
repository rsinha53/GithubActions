public class ACETLGT_ProviderLookupDetailController {
     public class custException extends Exception {}
      public class DetailResultWrapper{
        @AuraEnabled public ACETLGT_ProviderLookupDetailResult resultWrapper {get;set;} 
        @AuraEnabled  public string LanguageList {get;set;}
        //@AuraEnabled Public string FindAgreementsservice{get;set;}
    }
    public class SearchResultWrapper{
        @AuraEnabled public List<ACETLGT_ProviderLookupResult> resultWrapper {get;set;}
       @Auraenabled
      public string service;
      public SearchResultWrapper(String service){
            this.service = service;        
        } 
    }
    public class SearchAffiliationsWrapper{
        @AuraEnabled public List<ACETLGT_ProviderLookupDetailResult> resultWrapper {get;set;}
       @Auraenabled
      public string service;
      public SearchAffiliationsWrapper(String service){
            this.service = service;        
        } 
    }
    public class DetailResultWrapperFacility{
        @AuraEnabled public ACETLGT_ProviderLookupDetailResult resultWrapper {get;set;} 
        @AuraEnabled public string NPIList {get;set;}
        //@AuraEnabled public string FindAgreementsservice{get;set;}
        
    }
    public class contractResultWrapper {
       @AuraEnabled public List<ACETLGT_ProviderContractResult> resultWrapper {get;set;}
      @Auraenabled public string responce;
        public contractResultWrapper(String responce){
            this.responce = responce;        
        }     
    }
    @AuraEnabled 
    public static DetailResultWrapper getProviderDetail(String providerId,String taxId,String providerTINTypeCode,String addressId,String addressTypeCode,String returningFrom) {
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();   
        String LanguageList = '';
        ACETLGT_ProviderLookupDetailResult resultwrap = new ACETLGT_ProviderLookupDetailResult(); 
        ACETLGT_GetHCPWebservice ACTGHCP = new ACETLGT_GetHCPWebservice();
        CalloutResult = ACTGHCP.init(providerId, taxId,providerTINTypeCode, addressId, addressTypeCode, returningFrom);
        if (CalloutResult.Success)
        {   
            resultwrap= (ACETLGT_ProviderLookupDetailResult)CalloutResult.Response;
              if(resultwrap != null && resultwrap.languages != null){
                    for(ACETLGT_ProviderLookupDetailResult.Language lang: resultwrap.languages){
                        system.debug(LoggingLevel.INFO,'lang***'+lang.language);
                        if(lang.language != null && lang.language != ''){ 
                            LanguageList += lang.language+','; 
                        }
                    }
                    LanguageList = !String.isBlank(LanguageList) ? LanguageList.substring(0,LanguageList.length()-1) : '';
                }
                
        } 
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
            throw new custException('Webservice Error');
        }
        system.debug('>>>resultwrap------'+resultwrap);
        
        DetailResultWrapper detWrap = new DetailResultWrapper();
        detWrap.resultWrapper = resultwrap;
        detWrap.LanguageList = LanguageList;
        //detWrap.FindAgreementsservice = FindAgreementsservice;
        system.debug('>1>>finalresult'+detWrap );
        return detWrap;
  }
  
   @AuraEnabled 
    public static SearchResultWrapper getProviderLookupResults(String providerId, String npi, String taxId, String lastName, String firstName, String gender,String specialty,String searchPcpOBGYNId,String PostalPrefixCode, String radius, String City, String StateCode,
                                                               String PhoneNumber,String networkId, String BenefitServiceArea,String ServiceAreaType,String contractClaimType,String NewPatientIndicator,String languageCode, String ProviderTypeCode,String attributelist, String isLookupflow,String FilterByStatus,String PFS,String networkType){
                                                                   return getProviderLookupResults( providerId,  npi,  taxId,  lastName,  firstName,  gender, specialty, searchPcpOBGYNId, PostalPrefixCode,  radius,  City,  StateCode,
                                                                                             PhoneNumber, networkId, null,  null,  BenefitServiceArea, ServiceAreaType, contractClaimType, NewPatientIndicator, languageCode,  ProviderTypeCode, attributelist,  isLookupflow, FilterByStatus, PFS,networkType);
                                                               }
															   
   @AuraEnabled 
    public static SearchResultWrapper getProviderLookupResults(String providerId, String npi, String taxId, String lastName, String firstName, String gender,String specialty,String searchPcpOBGYNId,String PostalPrefixCode, String radius, String City, String StateCode,
                                                                                            String PhoneNumber,String networkId,String qualityProviderRuleId, String QualityTierLevel, String BenefitServiceArea,String ServiceAreaType,String contractClaimType,String NewPatientIndicator,String languageCode, String ProviderTypeCode,String attributelist, String isLookupflow,String FilterByStatus,String PFS,String networkType){
        String service; 
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();                                                      
     if(ProviderTypeCode == 'Physician') {
            ACETLGT_FindHCPWebservice ACTFHCP = new ACETLGT_FindHCPWebservice();
         ACTFHCP.network = String.isNotBlank(networkType) && networkType=='INN Only'?'A':'';
                ACTFHCP.Init(providerId, npi, taxId, lastName, firstName, gender, specialty,searchPcpOBGYNId,PostalPrefixCode, radius, city, StateCode, PhoneNumber,networkId,qualityProviderRuleId,QualityTierLevel,BenefitServiceArea,ServiceAreaType,contractClaimType,
                                 NewPatientIndicator, languageCode, ProviderTypeCode,attributelist,isLookupflow,FilterByStatus,PFS);
               ACTFHCP.GetEndpoint();   
               service = JSON.serialize(ACTFHCP).replace('\'', '&#x27;');
               service = service.replace('&#x27;', '\'');
     }else if(ProviderTypeCode == 'Facility') {
         ACETLGT_FindHCOWebservice ACTFHCO = new ACETLGT_FindHCOWebservice(); 
         ACTFHCO.network = String.isNotBlank(networkType) && networkType=='INN Only'?'A':'';
              ACTFHCO.Init(providerId, npi, taxId, lastName, firstName, gender, specialty,searchPcpOBGYNId,PostalPrefixCode, radius, city, StateCode, PhoneNumber,networkId,BenefitServiceArea,ServiceAreaType,contractClaimType,
                             NewPatientIndicator, languageCode, ProviderTypeCode,attributelist,isLookupflow,FilterByStatus,PFS);  
               ACTFHCO.GetEndpoint();   
               service = JSON.serialize(ACTFHCO).replace('\'', '&#x27;');
               service = service.replace('&#x27;', '\'');
      }
             return new SearchResultWrapper(JSON.serialize(service));
                                                                                         
    }
     @AuraEnabled
    public static SearchAffiliationsWrapper getProviderAffiliationResults(String providerId, String ProviderTypeCode){
        String service; 
         if(ProviderTypeCode == 'Physician') {
         ACETLGT_FindHCPAffiliationsWebservice  ACTFHCP = new ACETLGT_FindHCPAffiliationsWebservice ();                                                  
               ACTFHCP.Init(providerId);  
               ACTFHCP.GetEndpoint();   
               service = JSON.serialize(ACTFHCP).replace('\'', '&#x27;');
               service = service.replace('&#x27;', '\'');
         }else if(ProviderTypeCode == 'Facility') {
         ACETLGT_FindHCOAffiliationsWebservice ACTFHCO = new ACETLGT_FindHCOAffiliationsWebservice();                                                  
               ACTFHCO.Init(providerId);  
               ACTFHCO.GetEndpoint();   
               service = JSON.serialize(ACTFHCO).replace('\'', '&#x27;');
               service = service.replace('&#x27;', '\'');
      }
             return new SearchAffiliationsWrapper(JSON.serialize(service));
                                                                                         
    }
     @AuraEnabled 
    public static DetailResultWrapperFacility getProviderDetailFacility(String providerId,String taxId,String providerTINTypeCode,String addressId,String addressTypeCode,String returningFrom) {
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult(); 
        integer count=1;
        String NPIList = '';
        //String FindAgreementsservice = '';
        ACETLGT_ProviderLookupDetailResult resultwrap = new ACETLGT_ProviderLookupDetailResult(); 
        ACETLGT_GetHCOWebservice ACTGHCP = new ACETLGT_GetHCOWebservice();
        CalloutResult = ACTGHCP.init(providerId, taxId,providerTINTypeCode, addressId, addressTypeCode, returningFrom);
        if (CalloutResult.Success)
        {   
            resultwrap= (ACETLGT_ProviderLookupDetailResult)CalloutResult.Response;
              if(resultwrap != null && resultwrap.npis != null){
                    for(ACETLGT_ProviderLookupDetailResult.NPI npi: resultwrap.npis){
                         if(npi.npiName != null && npi.npiName != ''){ 
                           if(count <=10){
                                 if(math.mod(count, 3)==0){
                                    NPIList += npi.npiName+'\n';
                                }else{
                                    NPIList += npi.npiName+',';
                                }
                            count++;
                         }
                      }
                    }
                    NPIList = !String.isBlank(NPIList) ? NPIList.substring(0,NPIList.length()-1) : '';
                }
          } 
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
            throw new custException('Webservice Error');
        }   

        system.debug('>>>resultwrap------'+resultwrap);
                
        system.debug('>>>resultwrap------'+resultwrap);
        
        DetailResultWrapperFacility detWrap = new DetailResultWrapperFacility();
        detWrap.resultWrapper = resultwrap;
        detWrap.NPIList = NPIList;
        //detwrap.FindAgreementsservice = FindAgreementsservice;
        system.debug('>1>>finalresult'+detWrap );
        return detWrap;
  }
    @AuraEnabled 
    public static contractResultWrapper getProviderContractResults(String providerId,String taxId,String providerTINTypeCode,String addressId,String addressTypeCode){
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult(); 
        ACETLGT_FindAgreementsWebservice  findAgreementService = new ACETLGT_FindAgreementsWebservice();                                                  
        findAgreementService.init(providerId, taxId, providerTINTypeCode, addressId, addressTypeCode);
        findAgreementService.GetEndpoint();  
        String service = JSON.serialize(findAgreementService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');
        System.debug('result' +JSON.serialize(service));
        return new contractResultWrapper(JSON.serialize(service));
                                                                                         
    }
    public class familyMembsResultWrapper{
        @AuraEnabled public ACETLGT_MemberDetail resultWrapper {get;set;}
    }
    @AuraEnabled 
    public static familyMembsResultWrapper getPCP(String subsrk, string groupNumber, String effectiveDate, string memberId){
        ACETLGT_MemberDetail resultwrap = new ACETLGT_MemberDetail(); 
        ACETLGT_MemberDetail memberDetail = new ACETLGT_MemberDetail();
        ACETLGT_GetFamilyMemberWebService getFamMemService = new ACETLGT_GetFamilyMemberWebService();
        ACETWSCalloutResult CalloutResult = null;
             memberDetail.SurrogateKey = subsrk;
             memberDetail.PreferredCoverage = new ACETLGT_MemberDetail.CoverageLine();
             memberDetail.PreferredCoverage.groupNumber = groupNumber;
             memberDetail.PreferredCoverage.effectiveDate = effectiveDate;
             memberDetail.PreferredCoverage.SurrogateKey = subsrk;         
        CalloutResult = getFamMemService.getFamilyMembers(memberId, memberdetail);
        system.debug('~~~After callout'+CalloutResult);
        if (CalloutResult != null && CalloutResult.Success == true){   
            resultwrap= (ACETLGT_MemberDetail)CalloutResult.Response;
        } 
        system.debug('~~~resultwrap------'+resultwrap);
        familyMembsResultWrapper detWrap = new familyMembsResultWrapper();
        detWrap.resultWrapper = resultwrap;
        return detWrap;
    }
        
    public class CurrentPhysicianList{
        @AuraEnabled public list <CurrentPhysician> lstCurrentPhysician { get; set; }
    }
    public class startDate{
        @AuraEnabled public Case StartDateNew { get; set; }
    }
    
    @AuraEnabled
    public static ACETLGT_WSCalloutResult UpdatePCPOBGYN(String pcpObgnID, String memberId,String currentpcpAssignmentType, String effectiveDate, String scrId,
                                                         String groupNumber, String lastName,String firstName,String middleName, String nameSuffix,String ssn,
                                                         String gender, String dob, String relationshipcode, String npiType,String npiVal,String existpatientindicator){
        List<ACETLGT_MemberSearchCoveragesResult.Phone> PhoneList_val = new List<ACETLGT_MemberSearchCoveragesResult.Phone>();
        ACETLGT_UpdateIndividualWebService service = new ACETLGT_UpdateIndividualWebService();
        ACETLGT_WSCalloutResult finalWrapper = new ACETLGT_WSCalloutResult();
		system.debug('???update pcp call'+pcpObgnID+firstname+lastName+'//'+middleName+'//'+nameSuffix+existpatientindicator);
        //DE383511 : Added null checks for FirstName and LastName
        if(lastName !=null && firstName !=null && firstName !='' && lastName !='' && firstName !='null' && lastName !='null')
        {
        	finalWrapper = service.updateMembers(memberId, scrId, groupNumber, lastName, firstname, middleName, nameSuffix, ssn, 
                                                 gender, dob, relationshipcode,'', '', 'EML', PhoneList_val, pcpObgnID, 
                                                 currentpcpAssignmentType, effectiveDate, '', npiType, npiVal, existpatientindicator);
		}else{ // DE383511 : Added null checks for FirstName and LastName
            finalWrapper.statusCode=  500;
            finalWrapper.MessageSeverity=ApexPages.Severity.INFO;
            finalWrapper.Message='Unexpected error occurred.';
            }
    return finalWrapper;
    }
 
    public class CurrentPhysician {
        
        public CurrentPhysician(){
            CaseEndDate = new Case();
        }
        
        public string firstName {get;set;}
        public Boolean isChecked {get;set;}  
        public string lastName {get;set;}
        public string pcpAssignmentType {get;set;}
        public string effDate {get;set;}
        public Date EndDate {get; set;}
        public string pcpid {get;set;}
        public string pcptype {get;set;}
        public Case CaseEndDate { get; set; }
    } 
}