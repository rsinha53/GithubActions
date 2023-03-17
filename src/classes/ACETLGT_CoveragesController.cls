public class ACETLGT_CoveragesController extends ACETErrorHandler{
    public class SearchResultWrapper{
        @AuraEnabled public ACETLGT_MemberSearchCoveragesResult resultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
     
    
    
     public class memberdatawrapper{
         public String fname {get;set;}
         public String lname {get;set;}
         public String DOB{get;set;}
    }
    
    @AuraEnabled
    public static SearchResultWrapper getFamilyMembershipResults(String srk,String Esrk, string groupNumber, String effectiveDate,String endDate, String benefitPlanId,string memberId,String EID){ //,String endDate
        try{
        ACETLGT_MemberSearchCoveragesResult resultwrap = new ACETLGT_MemberSearchCoveragesResult(); 
      
        ACETLGT_GetFamilyMemberWebService getFamMemService = new ACETLGT_GetFamilyMemberWebService();
        ACETWSCalloutResult CalloutResult = null;
        CalloutResult = getFamMemService.getFamilyMembers(srk, Esrk, groupNumber, effectiveDate,endDate, benefitPlanId, resultwrap, memberId);  //,endDate
        system.debug('~~~After callout'+CalloutResult);
        List<Sobject> accConRelationList = new List<Sobject>();
        if (CalloutResult != null && CalloutResult.Success == true)
        {   
            resultwrap= (ACETLGT_MemberSearchCoveragesResult)CalloutResult.Response;
            
            list<account> acclisttoupdate = new list<account>();
            //Each EID will map to only one person account
            Map<String,Account> eidVsAccountMap = new Map<String,Account>();
            //Each EID will map to only one Family Members 
            Map<String,ACETLGT_MemberSearchCoveragesResult.FamilyMember> eidVsFamilyMemberMap = new Map<String,ACETLGT_MemberSearchCoveragesResult.FamilyMember>();
            list<string> eidlist = new list<string>();
            if(resultwrap != null && resultwrap.familyMembers != null){
                getEIDList(resultwrap, eidlist, groupNumber);
                system.debug('EIDlist--->'+JSON.serialize(eidlist));
                List<Account> accRecList = [SELECT id,PersonContactId,EID__c FROM Account WHERE EID__c =: eidlist];
                system.debug('accRecList--->'+JSON.serialize(accRecList));
                getEIDVSAccountAndFamilyMemberMap(resultwrap, eidVsAccountMap, eidVsFamilyMemberMap, memberId, eid);
                acclisttoupdate = eidVsAccountMap.values();
                updatePersonAccount(acclisttoupdate);
                system.debug('acclisttoupdate-->'+acclisttoupdate);
                addPersonAccountSFRecIdToFamilyMember(acclisttoupdate, accRecList, eidVsFamilyMemberMap);
                system.debug('familyMembers--->'+JSON.serialize(resultwrap.familyMembers));
            }
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = resultwrap;
            system.debug('>1>>finalresult'+detWrap );
            system.debug('accountsmethodlimits ===>'+Limits.getQueries());
            system.debug('accountdml'+Limits.getDMLStatements());
            return detWrap;
        } 
        else{
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = resultwrap;
                if(CalloutResult.statusCode == 400)
                    detWrap.ErrorMessage = setLightningErrorMsg('GN'+'400B');
                else
                    detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
            system.debug('final res::: '+detWrap );
            return detWrap;
        }  
        }catch(exception e){
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = new ACETLGT_MemberSearchCoveragesResult();
            detWrap.ErrorMessage = setLightningErrorMsg('GN997');
            system.debug('final res::: '+detWrap );
            return detWrap;
        }
    }
    
    private static void getEIDList(ACETLGT_MemberSearchCoveragesResult resultwrap, list<string> eidlist, String groupNumber)
    {
        for(ACETLGT_MemberSearchCoveragesResult.FamilyMember fm:resultwrap.familyMembers){
            fm.groupNumber = groupNumber;
            if(fm.EID != null){
                eidlist.add(fm.EID);  
            }
        }
    }
    private static void getEIDVSAccountAndFamilyMemberMap(ACETLGT_MemberSearchCoveragesResult resultwrap, Map<String,Account> eidVsAccountMap, Map<String,ACETLGT_MemberSearchCoveragesResult.FamilyMember> eidVsFamilyMemberMap, string memberId,String eid)
    {
        String  personaccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Map<String,String>  relationshipmap = ACETUtility.getHouseholdRelationshipMap();
        for(ACETLGT_MemberSearchCoveragesResult.FamilyMember fm:resultwrap.familyMembers){
            if(FM.EID != null){
                memberdatawrapper mw = new memberdatawrapper();
                system.debug('========1========>>'+fm.EID +'-===-'+ EID);
                eidVsFamilyMemberMap.put(fm.EID, fm);
                
                Account acc = new Account();
                acc.Eid__c = fm.EID;
                acc.FirstName = fm.FirstName;
                acc.LastName  = fm.LastName;
                acc.SRK_KeyChain__c=fm.ESRK;
                acc.SRK_KeyChain__pc=fm.ESRK;
                acc.EID__c=fm.EID;
                acc.EID__pc = fm.EID;
                if(fm!=null && fm.Relationship!=null)
                    acc.Relationship__pc = relationshipmap.get(fm.Relationship);
                if(fm.DOB != null && formatDatewithslash(fm.DOB) != null)
                    acc.PersonBirthdate = Date.valueOf(formatDatewithslash(fm.DOB)) ;
                acc.RecordTypeId =personaccountRecordType;
                eidVsAccountMap.put(fm.EID, acc);
                
                if(fm.EID == EID && fm.subscriberIndividualId == memberId){
                    mw.fname = fm.FirstName;
                    mw.lname = fm.LastName; 
                    mw.DOB = fm.DOB;   
                }
            }
        }
    }
    private static void updatePersonAccount(List<account> acclisttoupdate)
    {
        try{
          	
            Database.upsert(acclisttoupdate, Account.Fields.EID__c,false);
            system.debug('acclisttoupdate after upsert -->'+ JSON.serialize(acclisttoupdate));
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
        }
    }
    private static void addPersonAccountSFRecIdToFamilyMember(List<account> acclisttoupdate, List<Account> accRecList,  Map<String,ACETLGT_MemberSearchCoveragesResult.FamilyMember> eidVsFamilyMemberMap)
    {
        List<id> accountidslist = new List<id>();
        String subaccountid ;
        if(acclisttoupdate.isempty()){
            acclisttoupdate.addall(accRecList);
        }
        for(account acc:acclisttoupdate){
            accountidslist.add(acc.Id);
        }
        system.debug('accountidslist--->'+JSON.serialize(accountidslist));
        map<id,id> accconids = new map<id,id>();
        List<Contact> ACETContactList = [SELECT id,AccountId FROM Contact WHERE AccountId =:accountidslist ];
        for(Contact con:ACETContactList){
            accconids.put(con.AccountId,con.id);
        }
        system.debug('accconids--->'+JSON.serialize(accconids));
        map<string,string> acceids = new map<string,string>();
        List<account> accediList = [SELECT id,eid__c FROM account WHERE id =:accountidslist ];
        system.debug('accediList--->'+JSON.serialize(accediList));
        for(account a:accediList){
            acceids.put(a.eid__c,a.id);
        }
        system.debug('acceids--->'+JSON.serialize(acceids));
        /*
        * If there are multiple family members having same EID
        * SFrecId will be added to only one family member per EID
        * This will give only one originator value per EID
        */
        for(ACETLGT_MemberSearchCoveragesResult.FamilyMember FM:eidVsFamilyMemberMap.values()){
            fm.SFrecId =  accconids.get(acceids.get(fm.eid));  
            fm.accountid = acceids.get(fm.eid);
            if(FM.Relationship =='Self'){
                subaccountid = acceids.get(fm.eid);
            }
        }
    }
    @AuraEnabled
    public static SearchResultWrapper getGroupDetailsResults(string groupNumber, String effectiveDate,String endDate, String benefitPlanId, String bundleId, String originatorType, boolean isOnshore, String planOptionId){
        try{
        ACETLGT_MemberSearchCoveragesResult resultwrap = new ACETLGT_MemberSearchCoveragesResult(); 
        system.debug('~~~Inside Aura Group method'+planOptionId);
        //system.debug('!!!!'+preferredCoverage);
        //system.debug('!!!!'+JSON.parse(preferredCoverage));
        ACETLGT_GetEmployerGroupWebService getEmpService = new ACETLGT_GetEmployerGroupWebService();
        ACETWSCalloutResult CalloutResult = null;
        system.debug('~~~~originator Type and isOnshore'+originatorType+isOnshore);
        
        CalloutResult = getEmpService.getGroupInfo(groupNumber,effectiveDate,endDate,benefitPlanId,bundleId,originatorType,isOnshore, planOptionId);
        system.debug('~~~After callout group'+CalloutResult);
        
        if (CalloutResult != null && CalloutResult.Success == true)
        {   
            resultwrap= (ACETLGT_MemberSearchCoveragesResult)CalloutResult.Response;
            system.debug('~~resultwrap group------'+resultwrap);
            
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = resultwrap;
            system.debug('>1>>finalresult group'+detWrap );
            return detWrap;
        }else
        {
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = resultwrap;
                if(CalloutResult.statusCode == 400)
                    detWrap.ErrorMessage = setLightningErrorMsg('GN'+'400B');
                else
                    detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
            system.debug('final res::: '+detWrap );
            return detWrap;
        }  
        }catch(exception e){
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = new ACETLGT_MemberSearchCoveragesResult();
            detWrap.ErrorMessage = setLightningErrorMsg('GN997');
            system.debug('final res::: '+detWrap );
            return detWrap;
        }          
        
    }
    public static String formatDatewithslash(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        
        List<String> dateParts = dateString.split('/');
        if (dateParts.size() == 3)  {
            String mm = dateParts[0];
            String dd = dateParts[1];
            String yyyy = dateParts[2]; 
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','0') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','0') : dd; 
            
            return  yyyy +'-'+mm +'-' +dd;
        } else  { 
            return dateString;
        }
    }
    
}