public class ACETLGT_MemberSearchController {
    public class custException extends Exception {}
    public class SearchResultWrapper{
        @AuraEnabled public List<ACETLGT_MemberSearchCoveragesResult> resultWrapper {get;set;}
    }
    @AuraEnabled 
    public static SearchResultWrapper getSearchResults(String memberId, String firstName, String lastName, String dob, String state, String zip, String intType){
        List<ACETLGT_MemberSearchCoveragesResult> resultwrap = new List<ACETLGT_MemberSearchCoveragesResult>(); 
        System.debug('>>memId'+memberId+intType);
        memberId = (memberId!= null)?memberId.trim():''; 
        dob = (dob!=null)?dob:'';
        ACETLGT_FindIndMemberShipsWebService FindIndMemService = new ACETLGT_FindIndMemberShipsWebService();
        ACETWSCalloutResult CalloutResult = null;
        
        CalloutResult = FindIndMemService.findMemberWS(memberId, firstName, lastName, dob, state, zip, intType);
        if (CalloutResult.Success)
        {   
            resultwrap= (list<ACETLGT_MemberSearchCoveragesResult>)CalloutResult.Response;
        } 
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
            throw new custException('Webservice Error');
        }           
        system.debug('>>>resultwrap------'+resultwrap);
        
        SearchResultWrapper detWrap = new SearchResultWrapper();
        detWrap.resultWrapper = resultwrap;
        system.debug('>1>>finalresult'+detWrap );
        system.debug('>2>>finalresult'+detWrap );
        system.debug('>3>>finalresult'+detWrap );
        return detWrap;
        
    }
    
    @AuraEnabled
    public static Interaction__c createInteraction(String interactionType, String userProfile){
        system.debug('userProfile ::: '+userProfile+interactionType);
        Interaction__c interaction = new Interaction__c();
        if (System.Label.ACETResearchUserProfile == userProfile)
			interaction.Interaction_Type__c = System.Label.ACETResearchUserInteractionType;
        else
             interaction.Interaction_Type__c = interactionType;        
        
        Interaction.Originator_Type__c = 'Member';
        
        if (Schema.sObjectType.Interaction__c.isCreateable())
        insert interaction;         
        return interaction;    
            
    }
    
    
    @AuraEnabled 
    public static user getUser(){
     // query current user information  
      User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        return oUser;
    }
	
    
}