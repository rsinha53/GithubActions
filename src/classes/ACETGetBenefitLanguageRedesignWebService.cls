/**
* @name         :   ACETGetBenefitLanguageRedesignWebService
* @description  :   This class is created for the re-design of benefit language and it holds request and response from the service.
US820398, US849338, US843686
* @author       :   Divya Sindhu B
* @createddate  :   03-11-2017
* @lastmodifiedby:
*
**/
public class ACETGetBenefitLanguageRedesignWebService extends ACETWebService { 
public Boolean CodeIndicator{get;set;}

public override void GetEndpoint() {
    GetEndpointDetail('getPlanBenefitDetailsLangEndpoint');
}
public ACETGetBenefitLanguageRedesignWebService() {
    if(!Test.isRunningTest()){
        super('Stargate');
    }
    }
private void getRequestBody(String benefitBundleOptionId,String strDate,List<String> selectedBenefitCodes,
                            String accumAsOf, String hippaKey, String groupId) { 
    List<String> split = new List<String>();                        
    System.debug('StrDate:::::'+strDate);
    Date dateStrVal = Date.today();
     System.debug('StrDate:::::'+strDate);
    String dateVal = String.valueOf(dateStrVal);
                            
    System.debug('StrDate:::::'+dateVal);
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

public ACETWSCalloutResult getPlanBenefitLanguage(String benefitBundleOptionId,String strDate,String MemberId, List<string> benefitCodes, 
                                                  ACETGroupPlanBenefitWrapper accumulatorWrapper, ACETGroupPlanBenefitWrapper subscriptionWrapper,
                                                  String accumAsOf, String groupId) {
                                          
  ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
  return oACETWSCalloutResult;
}
    

public static boolean showCustomErrorMessage = false;

    
  

public List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> getPlanBenefitLanguageNew(String benefitBundleOptionId,String strDate,String MemberId, List<string> benefitCodes, 
                                                  String accumAsOf, String groupId, string hippaServiceType,boolean multiple,String EffectiveStartDate) {
                                                      
    List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> bwList = new List<ACETPlanBenefitLanguageWrapper.BenefitWrapper>();
    List<ACETPlanBenefitLanguageWrapper.ParStatus> parStatusList = new List<ACETPlanBenefitLanguageWrapper.ParStatus>();
    List<ACETPlanBenefitLanguageWrapper.GeneralCode> generalCodeList = new List<ACETPlanBenefitLanguageWrapper.GeneralCode>();
    ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
    
   
        HttpResponse response = null;
        getEndpoint();  
        Date strDate1 = date.today();
        getRequestBody(benefitBundleOptionId,ChangeDateFormatForOIL(string.valueof(strDate1)),benefitCodes,ChangeDateFormatForOIL(accumAsOf),hippaServiceType,groupId);
        Response = Send(OAuthConfig); 
        String ResponseBody; 
        system.debug('Response :: '+Response);
        system.debug('Response :: '+Response.getBody()); 
        integer responsecode = Response.getStatusCode(); 
          if (responsecode == 200) {
            CodeIndicator = false;
            ResponseBody = Response.getBody();
            ACETPlanBenefitRedesignLanguageJson2Apex ACETJSON2Apex = (ACETPlanBenefitRedesignLanguageJson2Apex)JSON.deserialize(ResponseBody, ACETPlanBenefitRedesignLanguageJson2Apex.class); 
         
            List<ACETPlanBenefitRedesignLanguageJson2Apex.benefitSection> benefitSectionList = ACETJSON2Apex.getBenefitLanguageResponse.benefitSection;
            Map<String,ACETPlanBenefitLanguageWrapper.GeneralCode> benefitLevelMap;
            Map<String,String> benefitDateMap;
            if(benefitSectionList != null && !benefitSectionList.isEmpty()) {
                for(ACETPlanBenefitRedesignLanguageJson2Apex.benefitSection benefitSectionCodes: benefitSectionList) {
                    ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
                    benefitLevelMap = new Map<String,ACETPlanBenefitLanguageWrapper.GeneralCode>();
                    benefitDateMap = new Map<String,String>();
                    bw.BenefitKey = getValidString(benefitSectionCodes.benefitCode)+' - '+getValidString(benefitSectionCodes.benefitName);
                    if(benefitSectionCodes.benefitTierSection != null && !benefitSectionCodes.benefitTierSection.isEmpty()) {
                        bw.parStatusList = new List<ACETPlanBenefitLanguageWrapper.ParStatus>();
                        for(ACETPlanBenefitRedesignLanguageJson2Apex.benefitTierSection benefitTiersectionCode: benefitSectionCodes.benefitTierSection) {
                            ACETPlanBenefitLanguageWrapper.ParStatus ps = new ACETPlanBenefitLanguageWrapper.ParStatus();
                            ps.parStatusKey = getValidString(benefitTiersectionCode.benefitTier)+' - '+getValidString(benefitTiersectionCode.parStatusType)+' - '+getValidString(benefitTiersectionCode.benefitTierDescription);
                            ps.benefitTier = getValidString(benefitTiersectionCode.benefitTier);
                            if(benefitTiersectionCode.benefitCodeLanguageSection != null && !benefitTiersectionCode.benefitCodeLanguageSection.isEmpty()) {
                                ps.generalCodeList = new List<ACETPlanBenefitLanguageWrapper.GeneralCode>();
                                for(ACETPlanBenefitRedesignLanguageJson2Apex.benefitCodeLanguageSection benefitLanguageSectionCode: benefitTiersectionCode.benefitCodeLanguageSection) {
                                    system.debug('BenefitStampIndicator**'+benefitLanguageSectionCode.languageEffectiveIndicator);
                                    if(benefitLanguageSectionCode.languageEffectiveIndicator == 'true') {
                                    ACETPlanBenefitLanguageWrapper.GeneralCode generalCodeInstance = new ACETPlanBenefitLanguageWrapper.GeneralCode();
                                    ACETPlanBenefitLanguageWrapper.GeneralCode generalCodeWrapper = new ACETPlanBenefitLanguageWrapper.GeneralCode();
                                    generalCodeInstance.benefitLevel = String.isNotBlank(benefitLanguageSectionCode.benefitLevel)?benefitLanguageSectionCode.benefitLevel:'';
                                    generalCodeInstance.benefitVersion = String.isNotBlank(benefitLanguageSectionCode.benefitVersion)?benefitLanguageSectionCode.benefitVersion:'';
                                    generalCodeInstance.benefitCodeEffectiveDate = String.isNotBlank(benefitLanguageSectionCode.benefitCodeEffectiveDate)?benefitLanguageSectionCode.benefitCodeEffectiveDate:'';
                                    generalCodeInstance.benefitCodeExpirationDate = String.isNotBlank(benefitLanguageSectionCode.benefitCodeExpirationDate)?benefitLanguageSectionCode.benefitCodeExpirationDate:'';
                                    generalCodeInstance.calculationBasis =  String.isNotBlank(benefitLanguageSectionCode.calculationBasis)?benefitLanguageSectionCode.calculationBasis:'';
                                    generalCodeInstance.benefitLevelDescription = String.isNotBlank(benefitLanguageSectionCode.benefitLevel)?'Level - '+benefitLanguageSectionCode.benefitLevel:'';
                                    generalCodeInstance.benefitCodeGeneralLanguage  = String.isNotBlank(benefitLanguageSectionCode.benefitCodeGeneralLanguage)?benefitLanguageSectionCode.benefitCodeGeneralLanguage:'';
                                    generalCodeInstance.benefitCodeLanguage = String.isNotBlank(benefitLanguageSectionCode.benefitCodeLanguage)?benefitLanguageSectionCode.benefitCodeLanguage:'';
                                    generalCodeInstance.ageFrom = String.isNotBlank(benefitLanguageSectionCode.ageFrom)?benefitLanguageSectionCode.ageFrom:'';
                                    generalCodeInstance.ageFromDuration  = String.isNotBlank(benefitLanguageSectionCode.ageFromDuration)?benefitLanguageSectionCode.ageFromDuration:'';
                                    generalCodeInstance.ageThrough = String.isNotBlank(benefitLanguageSectionCode.ageThrough)?benefitLanguageSectionCode.ageThrough:'';
                                    generalCodeInstance.ageThroughDuration = String.isNotBlank(benefitLanguageSectionCode.ageThroughDuration)?benefitLanguageSectionCode.ageThroughDuration:'';
                                    if(benefitLanguageSectionCode.billTypeSetCategory!= null) {
                                        generalCodeInstance.billTypeSetCategory ='';
                                        for(String billSetCategoryValue : benefitLanguageSectionCode.billTypeSetCategory){
                                            if(generalCodeInstance.billTypeSetCategory.length()>0){
                                              generalCodeInstance.billTypeSetCategory += ', ';
                                             }
                                             generalCodeInstance.billTypeSetCategory += billSetCategoryValue;
                                        }
                                    }else {
                                        generalCodeInstance.billTypeSetCategory = '';
                                    }   
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
                                     if(!benefitLevelMap.isEmpty() && !benefitDateMap.isEmpty()) {
                                        generalCodeWrapper = benefitLevelVersionDate(benefitLevelMap,ChangeDateFormatForOIL(accumAsOf),benefitDateMap,benefitLevelVersionKey,ChangeDateFormatForOIL(EffectiveStartDate));
                                     }
                                     System.debug('generalCodeWrapper'+generalCodeWrapper); 
                                     if(generalCodeWrapper != null) {
                                      ps.generalCodeList.add(generalCodeWrapper); 
                                     }
                                     system.debug('GeneralCode****' + ps.generalCodeList);
                               }
                                    
                            }   
                              
                            }// End of general code logic

                            if(bw.parStatusList == null){
                                bw.parStatusList = new list<ACETPlanBenefitLanguageWrapper.ParStatus>{ps};
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
                    ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
                    bwList.add(bw);
                }
            }
                            
       }else {

           ACETPlanBenefitRedesignLanguageJson2Apex ACETEGDJSON2Apex = (ACETPlanBenefitRedesignLanguageJson2Apex)JSON.deserialize(Response.getBody(), ACETPlanBenefitRedesignLanguageJson2Apex.class);
           ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
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
private static ACETPlanBenefitLanguageWrapper.GeneralCode benefitLevelVersionDate(Map<String,ACETPlanBenefitLanguageWrapper.GeneralCode> benefitLevelMap,String accumAsOf,Map<String,String> benefitDateMap,String benefitLevelVersionKey,String EffectiveStartDate) {
   System.debug('benefitLevelVersionKey'+benefitLevelVersionKey);
   System.debug('benefitLevelMap'+benefitLevelMap);
   System.debug('benefitDateMap'+benefitDateMap);
   ACETPlanBenefitLanguageWrapper.GeneralCode tempGeneralCodeWrapper;
   if(benefitDateMap != null && benefitLevelVersionKey != null && benefitLevelVersionKey != '' && benefitDateMap.containsKey(benefitLevelVersionKey)) {
   for(String benefitKey: benefitDateMap.keyset()) {
           String benefitEffectiveDate = benefitDateMap.get(benefitKey).split('@')[0];
           String benefitExpirationDate = benefitDateMap.get(benefitKey).split('@')[1];
           String calculationBasis  = benefitDateMap.get(benefitKey).split('@')[2];
       system.debug('calculationBasis--->'+calculationBasis+'EffectiveStartDate'+EffectiveStartDate);
           System.debug('benefitEffectiveDate'+benefitEffectiveDate);
           System.debug('benefitExpirationDate' +benefitExpirationDate);
           System.debug('accumAsOf'+accumAsOf);
             if(calculationBasis =='On Renewal'){
         if(EffectiveStartDate >= benefitEffectiveDate && EffectiveStartDate <= benefitExpirationDate) {
              System.debug('date is in between effective and expiration');
             System.debug('benefitEffectiveDate final'+benefitEffectiveDate);
           System.debug('benefitExpirationDate final' +benefitExpirationDate);
          tempGeneralCodeWrapper = benefitLevelMap.get(benefitKey);
        }
       }else{
         if(accumAsOf >= benefitEffectiveDate && accumAsOf <= benefitExpirationDate) {
              System.debug('date is in between effective and expiration');
             System.debug('benefitEffectiveDate final'+benefitEffectiveDate);
           System.debug('benefitExpirationDate final' +benefitExpirationDate);
               tempGeneralCodeWrapper = benefitLevelMap.get(benefitKey);
         
        } 
       }
      }
   }
      System.debug('tempGeneralCodeWrapper'+tempGeneralCodeWrapper);
      return tempGeneralCodeWrapper;
}

public String ChangeDateFormatForOIL(String OILDate) {
    String FormattedDate = '';
    
    if (String.isNotBlank(OILDate)) {
        List<String> OILDateSplit = OILDate.split('/');
        if(OILDateSplit.size() == 3) {
            Integer strMonth = integer.ValueOf(OILDateSplit[0]);
            Integer strDay = integer.ValueOf(OILDateSplit[1]);
            String appendMonth,appendDay;
            if(strMonth < 10)
                appendMonth = 0 + String.valueOf(strMonth);
            else
                appendMonth = String.valueOf(strMonth);
            
            if(strDay < 10)    
                appendDay = 0 + String.valueOf(strDay);
            else 
                appendDay = String.valueOf(strDay);
        
            FormattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
        }
    }
    
    return FormattedDate;
}


}