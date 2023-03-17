/**
 * Will be used as the controller for the ACETLGT_UpdateMemberDetail component
 * Created as part of US2098495
 *
 **/
public with sharing class ACETLGT_UpdateMemberDetailController extends ACETErrorHandler{

    public class SearchResultWrapper{
        @AuraEnabled public ACETLGT_MemberSearchCoveragesResult resultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }

    @AuraEnabled 
    public static SearchResultWrapper getSearchResults(String srk){
        try{
        ACETLGT_MemberSearchCoveragesResult resultwrap = new ACETLGT_MemberSearchCoveragesResult(); 
        SearchResultWrapper detWrap = new SearchResultWrapper();
        system.debug('srk:::'+srk);
        ACETWSCalloutResult CalloutResult = null;
        ACETLGT_GetIndividualWebService getIndMemService = new ACETLGT_GetIndividualWebService(); 
        if (srk != null && srk != ''){
            CalloutResult = getIndMemService.getMemberNewFramework(srk);
            if (CalloutResult != null && CalloutResult.Success)  
            {   
                resultwrap = (ACETLGT_MemberSearchCoveragesResult)CalloutResult.Response;
                
                detWrap.resultWrapper = resultwrap;
                system.debug('Val res::: '+detWrap );
               // return detWrap;
            }else{
              //  SearchResultWrapper detWrap = new SearchResultWrapper();
                detWrap.resultWrapper = new ACETLGT_MemberSearchCoveragesResult();
        
                if(CalloutResult.statusCode == 400)
                    detWrap.ErrorMessage = setLightningErrorMsg('GN400B'); 
                else
                    detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
                system.debug('Val res::: '+detWrap );
               // return detWrap;
            } 
                 
        }else{
        
       // SearchResultWrapper detWrap = new SearchResultWrapper();
        detWrap.resultWrapper = new ACETLGT_MemberSearchCoveragesResult();
        detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
        system.debug('Val res::: '+detWrap );
        
        }
            return detWrap;
        }catch(exception e){
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = new ACETLGT_MemberSearchCoveragesResult();
            detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
        system.debug('final res::: '+detWrap );
        
        return detWrap;        
        }     
    } 
    
    @AuraEnabled
    public static List < State__mdt > getStateValues() {
        List < State__mdt > stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName ASC];
        return stateList;
    }
    
    @AuraEnabled
    public static ACETLGT_WSCalloutResult updateMemberDetail(String memberId, String scrId, String groupId, String lastName,
            String firstName, String middleName, String nameSuffix, String ssn, String gender, String dob,
            String relationShipCode, String emailType, String strEmail, List<ACETLGT_MemberSearchCoveragesResult.Phone> PhoneList) {
        
        ACETLGT_UpdateIndividualWebService service = new ACETLGT_UpdateIndividualWebService();
        //ACETWSCalloutResult resultWrapper = new ACETWSCalloutResult();
        ACETLGT_WSCalloutResult finalWrapper = new ACETLGT_WSCalloutResult();
        try{

        for(ACETLGT_MemberSearchCoveragesResult.Phone phone : PhoneList) {            
            phone.PhoneNumberType = 'Home'.equals(phone.PhoneNumberType) ? 'H' : 
                                    'Work'.equals(phone.PhoneNumberType) ? 'W' : 
                                    'Mobile'.equals(phone.PhoneNumberType) ? 'M' : 
                                    'Fax'.equals(phone.PhoneNumberType) ? 'F' : '';

            phone.primaryIndicator = 'Yes'.equals(phone.primaryIndicator) ? 'true' :
                                     'No'.equals(phone.primaryIndicator) ? 'false' : '';
                                     System.debug('phone.primaryIndicator : '+ phone);
        }

        emailType = ('Primary'.equals(emailType)) ? 'true' : 'false';
        System.debug('PhoneList : ' + PhoneList);
        finalWrapper = service.updateMembers(memberId, scrId, groupId, lastName, firstname, middleName, nameSuffix, ssn, gender, dob, relationshipcode, emailType, strEmail, 'EML', PhoneList, '', '', '', '', '', '', '');
                /*finalWrapper.Success = resultWrapper.Success;
                finalWrapper.Message = resultWrapper.Message;*/
                system.debug('>>>resultmessage'+finalWrapper.Success);
                                                                     if(finalWrapper.Success == true) {
        return finalWrapper;
                                                                     } else {
                                                                         finalWrapper.ErrorMessage = setLightningErrorMsg('GN' + finalWrapper.statusCode);
                                                                         return finalWrapper;
                                                                     }            
        }catch(exception e){
            finalWrapper = new ACETLGT_WSCalloutResult();
            finalWrapper.ErrorMessage = setLightningErrorMsg('MGD997');
            system.debug('Val res::: '+finalWrapper );
        return finalWrapper;
        }
    }
    
    @AuraEnabled
    public static ACETLGT_WSCalloutResult updateMemberDemographics(String demographicData, String addressData){
        ACETLGT_WSCalloutResult updateResult;
        try{
            updateResult = ACETLGT_UpdateCOBDetails.updateMembers(demographicData, addressData);
            if(updateResult.Success == true) {
                return updateResult;
            } else {
                updateResult.ErrorMessage = updateResult.message;
                return updateResult;
            }
        }catch(exception e){
            updateResult = new ACETLGT_WSCalloutResult();
            updateResult.ErrorMessage = setLightningErrorMsg('MGD997');
            return updateResult;
        }
    }
}