public class ACETLGT_FamilyMemberController{
    public class SearchResultWrapper{
        @AuraEnabled public ACETLGT_MemberSearchCoveragesResult resultWrapper {get;set;}
    }
    
    @AuraEnabled 
    public static SearchResultWrapper getFamilyMembershipResults(String srk, String Esrk, string groupNumber, String effectiveDate,String beneffDate, String benefitPlanId, string memberId){
       system.debug('test sam');
        ACETLGT_MemberSearchCoveragesResult resultwrap = new ACETLGT_MemberSearchCoveragesResult (); 
        system.debug('~~~Inside Aura method');
        //memberId = (memberId!= null)?memberId.trim():''; 
        //dob = (dob!=null)?dob:'';
        ACETLGT_GetFamilyMemberWebService getFamMemService = new ACETLGT_GetFamilyMemberWebService();
        ACETWSCalloutResult CalloutResult = null;
        
        CalloutResult = getFamMemService.getFamilyMembers(srk, Esrk,groupNumber, effectiveDate, beneffDate, benefitPlanId , resultwrap, memberId);
        //CalloutResult = getFamMemService.getFamilyMembers('642281208', '1168520', '10/1/2018', resultwrap);
        system.debug('~~~After callout'+CalloutResult);
        
        if (CalloutResult != null && CalloutResult.Success == true)
        {   
            resultwrap= (ACETLGT_MemberSearchCoveragesResult )CalloutResult.Response;
            
            //for(ACETLGT_MemberSearchCoveragesResult.FamilyMember fam :resultwrap.FamilyMembers){
                //Account ACETAcc = ACETLGT_CreateConstituents.createAccount(fam.FirstName,fam.LastName,fam.DOB,fam.EID,null);
                //Contact ACETCon = ACETLGT_CreateConstituents.getContacts(ACETAcc.Id);
                // fam.SFrecId = ACETCon.Id;
            //}
        } 
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
        }           
        system.debug('~~~resultwrap------'+resultwrap);
        
        SearchResultWrapper detWrap = new SearchResultWrapper();
        detWrap.resultWrapper = resultwrap;
        system.debug('>1>>finalresult'+detWrap );
        system.debug('>2>>finalresult'+detWrap );
        system.debug('>3>>finalresult'+detWrap );
        return detWrap;
        
    }
    
}