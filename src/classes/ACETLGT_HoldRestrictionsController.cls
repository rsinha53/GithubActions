public class ACETLGT_HoldRestrictionsController {
	 public class SearchResultWrapper{
        @AuraEnabled public ACETLGT_MemberSearchCoveragesResult resultWrapper {get;set;}
    }
    @AuraEnabled 
    public static SearchResultWrapper getHoldRestrictions(String groupNumber, string memberId){
        ACETLGT_MemberSearchCoveragesResult resultwrap = new ACETLGT_MemberSearchCoveragesResult(); 
        
        system.debug('grp-mem:::'+groupNumber+memberId);
        ACETLGT_HoldRestrictionsWebservice getHRService = new ACETLGT_HoldRestrictionsWebservice();
        ACETWSCalloutResult CalloutResult = null;
        
        if (groupNumber != null && groupNumber != '' && memberId != null && memberId != ''){
            CalloutResult = getHRService.holdRestriction(memberId, groupNumber,'','All','All');
            if (CalloutResult.Success)
            {   
                resultwrap= (ACETLGT_MemberSearchCoveragesResult)CalloutResult.Response;
            } 
                 
        }
        system.debug('Res Wrap::: '+resultwrap.holdCodeList);
        
        SearchResultWrapper detWrap = new SearchResultWrapper();
        detWrap.resultWrapper = resultwrap;
        system.debug('final res::: '+detWrap );
        
        return detWrap;
        
    }
}