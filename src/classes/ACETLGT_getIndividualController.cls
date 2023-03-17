public class ACETLGT_getIndividualController {
    public class SearchResultWrapper{
        @AuraEnabled public ACETLGT_MemberSearchCoveragesResult resultWrapper {get;set;}
    }
    
    @AuraEnabled
    public static String fetchDemographicDetails(String lastName,String firstName,
                                                                String policyNumber,String subscriberId,
                                                                String dob)
    {
		User u = [SELECT Id,federationIdentifier FROM User Where Id=:UserInfo.getUserId()];
        ACET_EPMPMemberDetailsWebService edw = new ACET_EPMPMemberDetailsWebService();
        ACET_EPMPMemberDetailsResult emdr  = 
            edw.getEPMPMemberDetailsFormattedResult(lastName,firstName,policyNumber,subscriberId,
                                                    formatMMDDYYYYwithSlashToYYYYMMDDwithDash(dob),u.federationIdentifier,'agent','ACET_USP');
        return JSON.serialize(emdr);
        
    }
    @AuraEnabled
    public static SearchResultWrapper getSearchResults(String srk){
        ACETLGT_MemberSearchCoveragesResult resultwrap = new ACETLGT_MemberSearchCoveragesResult(); 
        
        //memberId = (memberId!= null)?memberId.trim():''; 
        //dob = (dob!=null)?dob:'';
        system.debug('srk:::'+srk);
        ACETLGT_GetIndividualWebService getIndMemService = new ACETLGT_GetIndividualWebService();
        ACETWSCalloutResult CalloutResult = null;
        
        if (srk != null && srk != ''){
            CalloutResult = getIndMemService.getMemberWS(srk);
            if (CalloutResult.Success)
            {   
                resultwrap= (ACETLGT_MemberSearchCoveragesResult)CalloutResult.Response;
            } 
            else
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
            } 
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
     public Static String GetEncryptedValue(String tempquerystring,String dob){
        tempquerystring = tempquerystring+'&dob='+formatMMDDYYYYwithSlashToYYYYMMDDwithDash(dob)+'&appID=ACET_USP';
        system.debug('tempquerystring---->'+tempquerystring);
        String orginstance;
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        orginstance = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        Blob blobdata = Blob.valueOf(tempquerystring);
        ACETWrapEncryptionKey__c  WrapEncryptionKey = ACETWrapEncryptionKey__c.getValues(orginstance+'_EPMP_EncryptionKey');
        String Key = WrapEncryptionKey.Key__c;
        ACETOrgNameToSwivelEndpointMap__c  ExernalSystemURL = ACETOrgNameToSwivelEndpointMap__c.getValues(orginstance+'_epmp');
        Blob EncryptKey = Blob.valueOf(Key);
        String algorithmname = WrapEncryptionKey.Algorithm_Name__c;
        String epmpbaseurl = ExernalSystemURL.Swivel_Endpoint__c;
        Blob encryptedtempBaseURLData = Crypto.encryptWithManagedIV(algorithmname, EncryptKey , blobdata);
        String  encryptedquerystring = EncodingUtil.base64Encode(encryptedtempBaseURLData);
        String salesforcebaseurl = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('epmpbaseurl+encryptedquerystring'+epmpbaseurl+encryptedquerystring);
        return salesforcebaseurl+epmpbaseurl+encryptedquerystring;
    }   
    
     public static String formatMMDDYYYYwithSlashToYYYYMMDDwithDash(String dateWithSlash){
        String[] temp = dateWithSlash.split('/');
        String Month;
        String day;
         if(temp[0].length()> 1){
          Month = temp[0]; 
         }else{
          Month = '0'+temp[0];   
         }
         if(temp[1].length()> 1){
          day = temp[1]; 
         }else{
          day = '0'+temp[1];   
         }
        String dateYYYYMMDD = temp[2] + '-' +  Month + '-' + day;
        
        return dateYYYYMMDD;
    } 
    
   /**
   * @Definiton: This is the method which get all the PCP information from webservice..
   */	
   /* @AuraEnabled
    public static ACETLGT_MemberSearchCoveragesResult getPCPInfoWrapper(){
        try{
            
            ACETLGT_MemberSearchCoveragesResult ACETMemberSearchCoveragesResultWrapper = new ACETLGT_MemberSearchCoveragesResult();
            
            List<ACETLGT_MemberSearchCoveragesResult.PCPAssignment> PCPAssignments = new List<ACETLGT_MemberSearchCoveragesResult.PCPAssignment>();
            
            ACETLGT_MemberSearchCoveragesResult.PCPAssignment PCPAssignment1 = new ACETLGT_MemberSearchCoveragesResult.PCPAssignment();
            PCPAssignment1.FirstName = 'John';
            PCPAssignment1.LastName = 'Smith';
            PCPAssignment1.pcpAssignmentType = 'Family Practice';
            PCPAssignment1.effectiveDate = '1/1/2019';
            PCPAssignment1.endDate = '12/31/2020';
            PCPAssignments.add(PCPAssignment1);
            
            ACETLGT_MemberSearchCoveragesResult.PCPAssignment PCPAssignment2 = new ACETMemberSearchCoveragesResult.PCPAssignment();
            PCPAssignment2.FirstName = 'John';
            PCPAssignment2.LastName = 'Smith 02';
            PCPAssignment2.pcpAssignmentType = 'Family Practice 02';
            PCPAssignment2.effectiveDate = '1/1/2019';
            PCPAssignment2.endDate = '12/31/2020';
            PCPAssignments.add(PCPAssignment2);
            
            ACETMemberSearchCoveragesResultWrapper.PCPAssignments = PCPAssignments;
            
            return ACETMemberSearchCoveragesResultWrapper;
            
        }catch(AuraHandledException auraex){
            System.debug(LoggingLevel.ERROR, 'ACETLGT_getIndividualController - getPCPInfoWrapper() : Line ' + auraex.getLineNumber() + ' - ' + auraex.getMessage());
            throw auraex;
        }
    }*/
    
}