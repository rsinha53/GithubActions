/**
* @name         :   ACETLGT_GetBenefitLanguageWebService

*
**/
public class ACETLGT_GetBenefitLanguageWebService extends ACETWebService { 
public Boolean CodeIndicator{get;set;}

public override void GetEndpoint() {
    GetEndpointDetail('getPlanBenefitDetailsLangEndpoint');
}
public ACETLGT_GetBenefitLanguageWebService() {
        super('Stargate');
    }
private void getRequestBody(String benefitBundleOptionId,List<String> selectedBenefitCodes,String accumAsOf,
                            String hippaKey, String groupId) { 
    List<String> split = new List<String>();                        
    //System.debug('StrDate:::::'+strDate);
    //Date dateStrVal = Date.today();
    // System.debug('StrDate:::::'+strDate);
    //String dateVal = String.valueOf(dateStrVal);
                            
    //System.debug('StrDate:::::'+dateVal);
    String benefitRequestFormat = '';
    string benefitCodeList = '';
    for(String splitString : selectedBenefitCodes){
        System.debug('splitString' + splitString);
        split = splitString.split(',');
        System.debug('splitString :' + split[0]);
    }
    for(String s: split){
        benefitCodeList = benefitCodeList+'"'+s.trim()+'",';    
    }
    benefitCodeList = benefitCodeList.removeEnd(',');
    System.debug('benefitCodeList :' + benefitCodeList);
                         
                                
     String benefitArray = '{"getBenefitLanguageRequest":{'+'"benefitBundleOptionId":'+'"'+benefitBundleOptionId+'",'+'"benefitCodes":'+'['+benefitCodeList+'],'+'"asOfDate":"'+accumAsOf+'",'+'"hippaServiceType":"'+hippaKey+'",'+'"groupNumber":"'+groupId+'"}}';
     RequestBody = benefitArray;
     system.debug('RequestBody  :: '+RequestBody);
} 



public static boolean showCustomErrorMessage = false;


public List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> getPlanBenefitLanguageNew(String benefitBundleOptionId,List<string> benefitCodes, 
                                                  String accumAsOf, String groupId, string hippaServiceType,boolean multiple,Map<String,String> benefitDisplayMap,List<String> benefitLanguageIndicatorWrapperList,String EffectiveStartDate) {
                                                      
    List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> bwList = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>();
    List<ACETLGT_PlanBenefitLanguageWrapper.ParStatus> parStatusList = new List<ACETLGT_PlanBenefitLanguageWrapper.ParStatus>();
    List<ACETLGT_PlanBenefitLanguageWrapper.GeneralCode> generalCodeList = new List<ACETLGT_PlanBenefitLanguageWrapper.GeneralCode>();
    ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
    system.debug('accumAsOf--->'+accumAsOf);
    //try {
        HttpResponse response = null;
        getEndpoint();  
        Date strDate1 = date.today();
        getRequestBody(benefitBundleOptionId,benefitCodes,accumAsOf,hippaServiceType,groupId);
        Response = Send(OAuthConfig); 
        String ResponseBody; // = ResponseJSONSR.Body.toString();
        system.debug('Response :: '+Response);
        system.debug('multiple' +multiple);                                             
        system.debug('Response :: '+Response.getBody()); 
           integer responsecode = Response.getStatusCode();                                           
       if (responsecode == 200) {
            CodeIndicator = false;
            ResponseBody = Response.getBody();
            ACETLGT_PlanBenefitLanguageJson2Apex ACETJSON2Apex = (ACETLGT_PlanBenefitLanguageJson2Apex)JSON.deserialize(ResponseBody , ACETLGT_PlanBenefitLanguageJson2Apex.class); 
          Map<String,ACETLGT_PlanBenefitLanguageWrapper.GeneralCode> benefitLevelMap;
            Map<String,String> benefitDateMap;
            List<ACETLGT_PlanBenefitLanguageJson2Apex.benefitSection> benefitSectionList = ACETJSON2Apex.getBenefitLanguageResponse.benefitSection;
            if(benefitSectionList != null && !benefitSectionList.isEmpty()) {
                for(ACETLGT_PlanBenefitLanguageJson2Apex.benefitSection benefitSectionCodes: benefitSectionList) {
                    ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper();      
                    benefitLevelMap = new Map<String,ACETLGT_PlanBenefitLanguageWrapper.GeneralCode>();
                    benefitDateMap = new Map<String,String>();
                    bw.BenefitKey = getValidString(benefitSectionCodes.benefitCode)+' - '+getValidString(benefitSectionCodes.benefitName);
                    bw.benefitLanguageCode = getValidString(benefitSectionCodes.benefitCode);
                    bw.benefitDisplay = '';
                    bw.benefitLanguageIndicator = false;
                    if(benefitDisplayMap != null && !benefitDisplayMap.isEmpty()) {
                       if(benefitDisplayMap.containsKey(bw.benefitLanguageCode) && benefitDisplayMap.get(bw.benefitLanguageCode) != null) {
                          bw.benefitDisplay = benefitDisplayMap.get(bw.benefitLanguageCode);
                        }
                    }
                     System.debug('bw.benefitDisplay' +bw.benefitDisplay);
                     if(benefitLanguageIndicatorWrapperList != null && !benefitLanguageIndicatorWrapperList.isEmpty()) {
                         if(benefitLanguageIndicatorWrapperList.indexOf(bw.benefitLanguageCode) != -1)
                           bw.benefitLanguageIndicator = true;
                     }
                    System.debug('bw.benefitLanguageIndicator' +bw.benefitLanguageIndicator);
                    if(benefitSectionCodes.benefitTierSection != null && !benefitSectionCodes.benefitTierSection.isEmpty()) {
                        bw.parStatusList = new List<ACETLGT_PlanBenefitLanguageWrapper.ParStatus>();
                        for(ACETLGT_PlanBenefitLanguageJson2Apex.benefitTierSection benefitTiersectionCode: benefitSectionCodes.benefitTierSection) {
                            ACETLGT_PlanBenefitLanguageWrapper.ParStatus ps = new ACETLGT_PlanBenefitLanguageWrapper.ParStatus();
                           ps.benefitTier = getValidString(benefitTiersectionCode.benefitTier);

                            ps.parStatusKey = getValidString(benefitTiersectionCode.benefitTier)+' - '+getValidString(benefitTiersectionCode.parStatusType)+' - '+getValidString(benefitTiersectionCode.benefitTierDescription);
                            if(benefitTiersectionCode.benefitCodeLanguageSection != null && !benefitTiersectionCode.benefitCodeLanguageSection.isEmpty()) {
                                ps.generalCodeList = new List<ACETLGT_PlanBenefitLanguageWrapper.GeneralCode>();
                                for(ACETLGT_PlanBenefitLanguageJson2Apex.benefitCodeLanguageSection benefitLanguageSectionCode: benefitTiersectionCode.benefitCodeLanguageSection) {
                                    system.debug('BenefitStampIndicator**'+benefitLanguageSectionCode.languageEffectiveIndicator);
                                    if(benefitLanguageSectionCode.languageEffectiveIndicator == 'true') {
                                    ACETLGT_PlanBenefitLanguageWrapper.GeneralCode generalCodeInstance = new ACETLGT_PlanBenefitLanguageWrapper.GeneralCode();
                                              ACETLGT_PlanBenefitLanguageWrapper.GeneralCode generalCodeWrapper = new ACETLGT_PlanBenefitLanguageWrapper.GeneralCode();

                                    generalCodeInstance.benefitLevel =  String.isNotBlank(benefitLanguageSectionCode.benefitLevel) ? benefitLanguageSectionCode.benefitLevel : '';
                                    generalCodeInstance.benefitLevelCode = integer.valueOf(generalCodeInstance.benefitLevel);
                                    generalCodeInstance.benefitLevelDescription = String.isNotBlank(benefitLanguageSectionCode.benefitLevel)?'Level - '+benefitLanguageSectionCode.benefitLevel:'';
                                    generalCodeInstance.benefitCodeGeneralLanguage  = String.isNotBlank(benefitLanguageSectionCode.benefitCodeGeneralLanguage)?benefitLanguageSectionCode.benefitCodeGeneralLanguage:'';
                                    generalCodeInstance.benefitCodeLanguage = String.isNotBlank(benefitLanguageSectionCode.benefitCodeLanguage)?benefitLanguageSectionCode.benefitCodeLanguage:'';
                                    generalCodeInstance.ageFrom = String.isNotBlank(benefitLanguageSectionCode.ageFrom)?benefitLanguageSectionCode.ageFrom:'';
                                    generalCodeInstance.ageFromDuration  = String.isNotBlank(benefitLanguageSectionCode.ageFromDuration)?benefitLanguageSectionCode.ageFromDuration:'';
                                    generalCodeInstance.ageThrough = String.isNotBlank(benefitLanguageSectionCode.ageThrough)?benefitLanguageSectionCode.ageThrough:'';
                                    generalCodeInstance.ageThroughDuration = String.isNotBlank(benefitLanguageSectionCode.ageThroughDuration)?benefitLanguageSectionCode.ageThroughDuration:'';
                                    generalCodeInstance.benefitVersion = String.isNotBlank(benefitLanguageSectionCode.benefitVersion)?benefitLanguageSectionCode.benefitVersion:'';
                                    generalCodeInstance.benefitCodeEffectiveDate = String.isNotBlank(benefitLanguageSectionCode.benefitCodeEffectiveDate)?benefitLanguageSectionCode.benefitCodeEffectiveDate:'';
                                    generalCodeInstance.benefitCodeExpirationDate = String.isNotBlank(benefitLanguageSectionCode.benefitCodeExpirationDate)?benefitLanguageSectionCode.benefitCodeExpirationDate:'';
                                    generalCodeInstance.calculationBasis = String.isNotBlank(benefitLanguageSectionCode.calculationBasis)?benefitLanguageSectionCode.calculationBasis:'';

                                        if(benefitLanguageSectionCode.billTypeSetCategory!= null) {
                                        generalCodeInstance.billTypeSetCategory = benefitLanguageSectionCode.billTypeSetCategory;
                                    }
                                    System.debug('generalCodeInstance.billTypeSetCategory' +generalCodeInstance.billTypeSetCategory);
                                    if(benefitLanguageSectionCode.coverageIndicator !=null  ){
                                        generalCodeInstance.coverageIndicator = (benefitLanguageSectionCode.coverageIndicator=='false')?'No':'Yes';
                                    }
                                    else{
                                        generalCodeInstance.coverageIndicator = ' ';
                                    }
                                     benefitLevelMap.put(ps.benefitTier+generalCodeInstance.benefitLevel+generalCodeInstance.benefitVersion,generalCodeInstance);
                                     System.debug('benefitLevelMap'+benefitLevelMap);
                                     benefitDateMap.put(ps.benefitTier+generalCodeInstance.benefitLevel+generalCodeInstance.benefitVersion,generalCodeInstance.benefitCodeEffectiveDate+'@'+generalCodeInstance.benefitCodeExpirationDate+'@'+generalCodeInstance.calculationBasis);
                                     System.debug('benefitDateMap'+benefitDateMap);
                                     String benefitLevelVersionKey = ps.benefitTier+generalCodeInstance.benefitLevel+generalCodeInstance.benefitVersion;
                                     System.debug('benefitLevelVersionKey'+benefitLevelVersionKey);
                                        system.debug('accumAsOf--->'+accumAsOf);
                                     if(!benefitLevelMap.isEmpty() && !benefitDateMap.isEmpty()) {
                                        generalCodeWrapper = benefitLevelVersionDate(benefitLevelMap,accumAsOf,benefitDateMap,benefitLevelVersionKey,EffectiveStartDate);
                                     }
                                     if(generalCodeWrapper != null) {
                                      ps.generalCodeList.add(generalCodeWrapper); 
                                     }   
                                    // ps.generalCodeList.add(generalCodeInstance); 
                                    //  system.debug('GeneralCode****' + ps.generalCodeList);
                               }
                                    
                            }   
                                
                            }// End of general code logic
                            if(bw.parStatusList == null){
                                bw.parStatusList = new list<ACETLGT_PlanBenefitLanguageWrapper.ParStatus>{ps};
                            }else{
                                bw.parStatusList.add(ps);
                            }
                        }
                    }
                    String benefitKeyId = '';
                    bw.isSuccess = true;
                    bwList.add(bw);
                    system.debug('bwList ::'+bwList);
                   
                }
            }else{
                
                if(multiple){
                    ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper();
                    bwList.add(bw);
                }
            }
                            
       }else {
           ACETLGT_PlanBenefitLanguageJson2Apex ACETEGDJSON2Apex = (ACETLGT_PlanBenefitLanguageJson2Apex)JSON.deserialize(Response.getBody(), ACETLGT_PlanBenefitLanguageJson2Apex.class);
           ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper();
            system.debug('ACETEGDJSON2Apex ....'+ACETEGDJSON2Apex.getBenefitLanguageResponse);
            oACETWSCalloutResult.Success = false;
            List<ACETOILError> authErrors = new List<ACETOILError>();
            if(ACETEGDJSON2Apex != null && ACETEGDJSON2Apex.getBenefitLanguageResponse != null)
            authErrors = ACETEGDJSON2Apex.getBenefitLanguageResponse.errors;  
            oACETWSCalloutResult.Message = GetOILErrorMessage(authErrors);
            system.debug('oACETWSCalloutResult.Message...'+oACETWSCalloutResult.Message);
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
            if(responsecode != 500){
                bw.isSuccess = false;
                //bw.Message = GetOILErrorMessage(authErrors);
                bw.MessageSeverity = ApexPages.Severity.ERROR; 
                bw.Message = oACETWSCalloutResult.Message;
                bwList.add(bw);
                CodeIndicator = true;
            }else if(responsecode == 500){
                bw.isSuccess = false;
                bw.Message = 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.';
                bw.MessageSeverity = ApexPages.Severity.ERROR; 
                bwList.add(bw);
                CodeIndicator = false;
            }
       }
        /* doubt */
            system.debug('bw::'+bwList.size()+bwList);
    //}
      /*catch(Exception ex) {
        for(ACETPlanBenefitLanguageWrapper.BenefitWrapper bw1 :bwList){
            bw1.isSuccess = false;
            bw1.Message = ex.getMessage();
            bw1.MessageSeverity = ApexPages.Severity.ERROR; 
        }
        
    }*/
                                                      
    return bwList;
}


public string getValidString(string inputStr){
    if(string.isNotBlank(inputStr)){
        inputStr = inputStr.replaceAll('\"','');
        return inputStr;
        
    }else{
        return '';
    }
}
    private static ACETLGT_PlanBenefitLanguageWrapper.GeneralCode benefitLevelVersionDate(Map<String,ACETLGT_PlanBenefitLanguageWrapper.GeneralCode> benefitLevelMap,String accumAsOf,Map<String,String> benefitDateMap,String benefitLevelVersionKey,String EffectiveStartDate) {
   System.debug('benefitLevelVersionKey'+benefitLevelVersionKey);
   System.debug('benefitLevelMap'+benefitLevelMap);
   System.debug('benefitDateMap'+benefitDateMap);
   ACETLGT_PlanBenefitLanguageWrapper.GeneralCode tempGeneralCodeWrapper;
   if(benefitDateMap != null && benefitLevelVersionKey != null && benefitLevelVersionKey != '' && benefitDateMap.containsKey(benefitLevelVersionKey)) {
   for(String benefitKey: benefitDateMap.keyset()) {
           String benefitEffectiveDate = benefitDateMap.get(benefitKey).split('@')[0];
           String benefitExpirationDate = benefitDateMap.get(benefitKey).split('@')[1];
           String calculationBasis = benefitDateMap.get(benefitKey).split('@')[2];
           System.debug('benefitEffectiveDate'+benefitEffectiveDate);
           System.debug('benefitExpirationDate' +benefitExpirationDate);
           System.debug('accumAsOf'+accumAsOf);
           System.debug('calculationBasis--->'+calculationBasis+'EffectiveStartDate---->'+EffectiveStartDate);
           if(calculationBasis =='On Renewal'){
         if(EffectiveStartDate >= benefitEffectiveDate && EffectiveStartDate <= benefitExpirationDate) {
              System.debug('date is in between effective and expiration');
               tempGeneralCodeWrapper = benefitLevelMap.get(benefitKey);
         
        } 
           }else{
              if(accumAsOf >= benefitEffectiveDate && accumAsOf <= benefitExpirationDate) {
              System.debug('date is in between effective and expiration');
               tempGeneralCodeWrapper = benefitLevelMap.get(benefitKey);
         
        }   
           }
      }
   }
      System.debug('tempGeneralCodeWrapper'+tempGeneralCodeWrapper);
      return tempGeneralCodeWrapper;
}



}