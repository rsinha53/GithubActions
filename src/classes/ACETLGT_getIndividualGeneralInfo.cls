public class ACETLGT_getIndividualGeneralInfo extends ACETErrorHandler {
    
    public class SearchResultWrapper{
        @AuraEnabled public ACETLGT_MemberSearchCoveragesResult resultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    
    @AuraEnabled
    public static SearchResultWrapper getSearchResults(String srk, string EID, string SurrogateKeysStr,string IntId){
        try{
        ACETLGT_MemberSearchCoveragesResult resultwrap = new ACETLGT_MemberSearchCoveragesResult(); 
        
        system.debug('srk:::'+srk);
        system.debug('EID---------:::'+EID);
        system.debug('SurrogateKeysStr---------:::'+SurrogateKeysStr);
        ACETLGT_GetIndividualWebService getIndMemService = new ACETLGT_GetIndividualWebService();
        ACETWSCalloutResult CalloutResult = null;
        ACETWSCalloutResult getencodeResponse;      // Added by Abhinav for US1926834
        if (srk != null && srk != ''){
            CalloutResult = getIndMemService.getMemberWS(srk);
            if (CalloutResult.Success)
            {   
                resultwrap= (ACETLGT_MemberSearchCoveragesResult)CalloutResult.Response;
                string SrkKeysStr = SurrogateKeysStr != null?SurrogateKeysStr:srk;
        if( resultwrap != null && EID != null){
            system.debug('Res Wrap:::----CHECKPOINT-1------> '+resultwrap.firstName);
           
            
            // Added by Abhinav for US1926834
            if(resultwrap.disabilityInfo!=Null && resultwrap.disabilityInfo.size()>0){
                    List<String> diagCodes = new List<String>();
                    if(resultwrap.disabilityInfo!=null && resultwrap.disabilityInfo.size()>0){
                        for(ACETLGT_MemberSearchCoveragesResult.DependentDisability disab: resultwrap.disabilityInfo){
                         if(!String.isEmpty(disab.diagnosisCode)){
                            diagCodes.add(disab.diagnosisCode);
                         }
                        }
                    }
                    
                    if(diagCodes!=Null && diagCodes.size()>0){
                        system.debug(LoggingLevel.INFO,'getencoder call-----------'+diagCodes);                 
                        ACETEncoderProWebservice encoderWS = new ACETEncoderProWebservice();
                        Map<String, Set<String>> encodeMap =new Map<String, Set<String>>();
                        getencodeResponse=encoderWS.getCodeDescriptions(diagCodes);
                        if(getencodeResponse!=null && getencodeResponse.Success){                    
                            encodeMap = (Map<String, Set<String>>)getencodeResponse.Response;
                            if(resultwrap.disabilityInfo!=null && resultwrap.disabilityInfo.size()>0){
                                for(ACETLGT_MemberSearchCoveragesResult.DependentDisability disab: resultwrap.disabilityInfo){
                                    if(String.isNotBlank(disab.diagnosisCode) && encodeMap!=null && encodeMap.containskey(disab.diagnosisCode)){
                                        disab.diagnosisDesc= String.join(new List<String>(encodeMap.get(disab.diagnosisCode)), ',');
                                    }
                                }  
                            }
                        }
                    }
                }
                
             Account ACETAcc = ACETLGT_createACETConstituents.createAccount(resultwrap.firstName,resultwrap.lastName,resultwrap.dob,EID,SrkKeysStr,IntId);
            //system.debug('----ACETAcc------> '+ACETAcc.Id);
            if(ACETAcc != null){
                Contact ACETCon = ACETLGT_createACETConstituents.getContacts(ACETAcc.Id);
                system.debug('----ACETCon------> '+ACETCon);
                if(ACETCon != null){
                	resultwrap.SFrecId = ACETCon.Id ;
                    if(IntId != null){
                        Interaction__c Intrec = new Interaction__c(id=IntId,Originator__c=ACETCon.Id);
                        update Intrec;
                         
                    }
                }
            }
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = resultwrap;
            system.debug('final res::: '+detWrap );
                    return detWrap;
                }else{
                    SearchResultWrapper detWrap = new SearchResultWrapper();
                    detWrap.resultWrapper = resultwrap;
                    detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
                    system.debug('final res::: '+detWrap );
                    
                    return detWrap;
                }
            }else{
                SearchResultWrapper detWrap = new SearchResultWrapper();
                detWrap.resultWrapper = resultwrap;
                if(CalloutResult.statusCode == 400)
	            	detWrap.ErrorMessage = setLightningErrorMsg('GN400B'); 
	            else
	            	detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
                system.debug('final res::: '+detWrap );
                
                return detWrap;
            }
                 
        }else{
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = resultwrap;
            detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
            system.debug('final res::: '+detWrap );
            
            return detWrap;
        }
        }catch(exception e){
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = new ACETLGT_MemberSearchCoveragesResult();
            detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
            system.debug('final res::: '+detWrap );
            
            return detWrap;
        }
             
    }
    
}