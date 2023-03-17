/*
Created By: Chandan
Created Date: 24th Jan 2020
Description: This class is replica of ACETLinkMemberSearch but it contains ACET level naming and changes.
*/
public without sharing class ACETSNILinkMemberSearch  { //extends ACETWebservice
    
    public class SearchResultWrapper{
        //@AuraEnabled public ACETMemberSearchInteractionResult resultWrapper {get;set;} //Code Not Required for ITE-Required for SAE
        @AuraEnabled public ACETLinkCoveragesResult resultWrapper {get;set;} //Code Required for ITE
        @AuraEnabled public ACETHouseHoldWrapper houseHoldResultWrapper {get;set;}
        @AuraEnabled public ACETSNIWrapper SNIresultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
        @AuraEnabled public boolean CHNQualified {get; set;}
        @AuraEnabled public boolean CHNEligible {get;set;}
        @AuraEnabled public boolean multlpleEntriesFound {get;set;}
        @AuraEnabled public List<object> recordsFoundInCDB {get;set;}
        @AuraEnabled public boolean IsSandbox {get;set;}
        @AuraEnabled public Map<String,WebserviceConfigurations__c> mapNameToWebservice {get;set;}
        @AuraEnabled public string token {get;set;}
        @AuraEnabled public String woId{get;set;}
		@AuraEnabled public String referralIdentifier{get;set;}
    }
    public static String memberId;
    public static Date memberDOB; 
    public static String firstName;
    public static String lastName; 
    public static String groupNumber;
    public static String searchOption;
    
    //US2216710 :Code Added By Chandan - Start
    @AuraEnabled 
    public static user fetchLoginUser(){
     // query current user information  
      User oUser = [select id,Name,TimeZoneSidKey,FederationIdentifier,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                 FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    //US2216710 :Code Added By Chandan - End
    
    @AuraEnabled 
    public static Boolean validateMembers(List<String> lstEids){ 
        List<String> lstMemebersNotExist;
        List<Account> lstAcc = [SELECT Id, EID__c, AccountNumber FROM Account where EID__c In: lstEids];        
        if(lstEids.size() == lstAcc.size()){
            return true;
        }else{
            return false;            
        }        
    }
    
    @AuraEnabled
    public static Boolean fetchUser(){
        // query current user information
        Set<String> allProfiles = new Set<String>();
        Boolean profileCheck;
        //User oUser = [select id,Name,Profile.Name FROM User Where id =: userInfo.getUserId()];
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        for(Profile_Routing__mdt s:[SELECT DeveloperName, Profile_Name__c,MasterLabel  FROM Profile_Routing__mdt where MasterLabel ='SNI']){
            allProfiles.add(s.Profile_Name__c);
        }
        system.debug('usrProfileName........'+usrProfileName);
        system.debug('allProfiles........'+allProfiles);
        if(allProfiles.contains(usrProfileName)){
            profileCheck = false;
        }else{
            profileCheck = true;
        }
        return profileCheck;
    }
    @AuraEnabled
    public static boolean checkUHGaccess(String policyId){
        system.debug('checkUHGaccess---------');
        system.debug('checkUHGaccess-----checkUHGPolicy----'+ACETUtility.checkUHGPolicy(policyId));
        if(ACETUtility.checkUHGPolicy(policyId)){
            system.debug('checkUHGaccess----checkUserUhgAccess-----'+ACETUtility.checkUserUhgAccess());
            if(! ACETUtility.checkUserUhgAccess()){
                return false;
            }
        }
        return true;
        /*
        string uhgPolicies = label.UHGPolicies;
        Boolean chkUhgAccess = true;
        if(uhgPolicies != null){
             
            List<string> lstUhgPol = new List<string>();
            if(uhgPolicies.contains(';')){
                lstUhgPol = uhgPolicies.split(';');
            }
            else{
                lstUhgPol.add(uhgPolicies);
            }
            Boolean checkPolicy = false;
            for(string pol:lstUhgPol){
                if(pol.equals(policyId)){
                    checkPolicy = true;
                }
            }
            if(checkPolicy){
                string uId = userInfo.getUserId();
                string uhgAccess = [select UHG_Access__c from user where id =: uId].UHG_Access__c;
                if(uhgAccess != 'Yes' || uhgAccess != 'yes' || uhgAccess != 'YES'){
                   chkUhgAccess = false;
                }
            }
        }
        return chkUhgAccess;
        */
       // return true;    
    }
    @AuraEnabled
    public static boolean checkOnshoreRestriction(String sourceCode, String policyNumber, String groupNumber, String cosmosDivision){
        List<String> restrictionLevel = new List<String>();
        String srcCode = '';
        String param = '';
        if(sourceCode == 'CO'){
            srcCode = 'MR';
            if(cosmosDivision != null && String.isNotBlank(cosmosDivision) && groupNumber != null && groupNumber != '--'){
                param = groupNumber + '_' + cosmosDivision;
            }
        } else if(sourceCode == 'CS'){
            srcCode = 'EI';
            if(policyNumber != null && String.isNotBlank(policyNumber) && groupNumber != null && groupNumber != '--'){
                String polNum = policyNumber;
                String grpNum = groupNumber;
                if(policyNumber.startsWith('0')){
                    polNum = policyNumber.substring(1, policyNumber.length());
                }
                if(groupNumber.startsWith('0')){
                    grpNum = groupNumber.substring(1, groupNumber.length());
                }
                param = polNum + '_' + grpNum;
            }
        }
        restrictionLevel = ACETUtility.getPolicyRestrictionLevel(srcCode,param); 
        if((restrictionLevel == null || restrictionLevel.size() == 0) && policyNumber != null && String.isNotBlank(policyNumber)){
            String polNum = policyNumber;
            if(policyNumber.startsWith('0')){
                polNum = policyNumber.substring(1, policyNumber.length());
            }
            param = polNum;
        	restrictionLevel = ACETUtility.getPolicyRestrictionLevel(srcCode,param); 
        }
        Boolean isAllowedAccess = true;
        Boolean onshoreRestricted = false;
        if(restrictionLevel != null && restrictionLevel.size() > 0 && (restrictionLevel.contains('L7') || restrictionLevel.contains('L5') || restrictionLevel.contains('L3'))){
            onshoreRestricted = true;
            if(ACETUtility.isOffShoreUser()){
                isAllowedAccess = false;
            }
        }
        return isAllowedAccess;
    }
    @AuraEnabled
    public static SearchResultWrapper findSNIDetails(String memberId, String policyId,String firstName, String lastName, String memDob){
        ACETLinkSNIWebService sniEligibilityCls = new ACETLinkSNIWebService();
        //ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETSNIWrapper resultwrap = new ACETSNIWrapper();
        //system.debug('memDob from 1stcalss -----'+memDob);
        ACETWSCalloutResult CalloutResult  = sniEligibilityCls.getMemberWS(memberId, policyId, firstName, lastName, memDob);
        SearchResultWrapper returnData = new SearchResultWrapper();
        if (CalloutResult.Success){
            resultwrap= (ACETSNIWrapper)CalloutResult.Response;
        }
         system.debug('resultwrap snieligibility -----'+resultwrap.sniEligibility);
        system.debug('resultwrap snieligibility -----'+resultwrap.advisorFullName);
        returnData.SNIresultWrapper = resultwrap;
        returnData.message = CalloutResult.Message;
        returnData.statusCode = CalloutResult.statusCode;
        // returnData.message = 'Custom error message';
        // returnData.statusCode = 213;
        system.debug('CalloutResult Message-----------'+CalloutResult.Message);
        system.debug('CalloutResult statusCode-----------'+CalloutResult.statusCode);
        return returnData;

    }
    @AuraEnabled
    public static SearchResultWrapper findMembers(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption){
        
        //Below code commented for ITE-But required for SAe
        //ACETMemberSearchInteractionResult resultwrap = new ACETMemberSearchInteractionResult(); //Code Added By Chandan
        ACETLinkCoveragesResult resultwrap = new ACETLinkCoveragesResult();
        ACETLinkEligibilityWebService MemberProviderService = new ACETLinkEligibilityWebService(); //Code Added By Chandan
        ACETWSCalloutResult CalloutResult = null;
        System.debug('parameters....'+'member'+memberId+'memberdob'+memberDOB+'first'+firstName+'last'+lastName+'group'+groupNumber+'search'+searchOption);
        //Call the below method for SAE
        //CalloutResult = MemberProviderService.getMemberWS(memberId,memberDOB,firstName,lastName,groupNumber,searchOption,'87726','LOTSOFF','DAVID','1205807328');
        //For Ite I am changing the method -Chandan -Code need to be tuned
        CalloutResult = MemberProviderService.getMemberWS(memberId,memberDOB,firstName,lastName,groupNumber,searchOption);

        if (CalloutResult.Success){
            resultwrap= (ACETLinkCoveragesResult)CalloutResult.Response; //Code Added By Chandan
            system.debug('CalloutResult.Response');
            system.debug(CalloutResult.Response);
            System.debug('resultwrap.@@@ ' + resultwrap);
            /*   if(resultwrap.memberProviderResultlst != null){
createAccountContact(resultwrap.memberProviderResultlst[0].firstName,resultwrap.memberProviderResultlst[0].middleName,resultwrap.memberProviderResultlst[0].lastName,resultwrap.memberProviderResultlst[0].dob,resultwrap.subjectCard.memberId);
} */
        }
        /* Som has modified the code for coverage api */
        //CalloutResult = MemberProviderService.getHouseHoldMembers(resultwrap.transactionId);

        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;

        
        
    }
    @AuraEnabled
    public static SearchResultWrapper findMembersTemp(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption){
        
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"eligibilities":[{"sourceIndividual":{"active":true,"alternateIdentifiers":{"alternateIds":[{"identifier":"533113548"}],"alternateSubscriberId":"533113548","employerAssignedIds":[{"identifier":"053310"}],"enterpriseIndividualIdentifier":null,"familyId":10638463,"hicNumbers":null,"medicaidRecipientNumbers":null,"memberAlternateIds":null,"memberFamilyLinkIds":null,"memberId":"","priorMemberIds":null,"sourceSystemIds":[{"identifier":"SPT 1527267579   2 533113548"}],"survivingSpouseIds":null},"birthSequenceNumber":"","demographicInfo":{"birthDate":"2000-07-09","ethnicity":null,"genderType":{"code":"M"},"race":null},"eligibilityAttributes":{"enrolleeMemberFacingIdentifier":"","relationshipType":{"description":"Child"},"subscriberMemberFacingIdentifier":""},"enrolleeSourceCode":"OP","enrolleeSourceId":"SPT 1527267579   2 533113548","individualIdentifier":"cdb:5:297933425:OP:SPT 1527267579   2 533113548","legacyAttributes":{"customerNumber":"","relationshipCode":""},"organizationType":{"code":""},"personName":{"firstName":"MAXWELL","lastName":"SMITH","middleName":"","suffix":""},"postalAddresses":[{"addressType":{"code":"P"},"beginDate":"0001-01-01","endDate":null,"isoCountry":{"code":""},"line1Text":"17620 228TH PLACE NE","line2Text":"","postalCode":"98072","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":true,"stateProvinceCode":"WA","townName":"WOODINVILLE"}],"primeDependentCode":"","researchAuthorizationIndicator":false,"socialSecurityNumber":"","sourceSystemAttributes":{"cdb":{"consumerId":297933425,"customerAccountIdentifier":"00001702","familyPartitionNumber":163,"migratedMemberships":null,"partitionNumber":5,"referenceData":{"subscriberRelationshipTypeCode":"002"},"spclProcHndlCd":"","xrefId":19591612}},"sourceSystemCode":"CDB"},"memberships":[{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2009-03-02","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2099-01-01"}]},{"sourceIndividual":{"active":true,"alternateIdentifiers":{"alternateIds":[{"identifier":"533113548"}],"alternateSubscriberId":"533113548","employerAssignedIds":[{"identifier":"053310"}],"enterpriseIndividualIdentifier":null,"familyId":10638463,"hicNumbers":null,"medicaidRecipientNumbers":null,"memberAlternateIds":null,"memberFamilyLinkIds":null,"memberId":"","priorMemberIds":null,"sourceSystemIds":[{"identifier":"SPT 833048033    1 533113548"}],"survivingSpouseIds":null},"birthSequenceNumber":"","demographicInfo":{"birthDate":"1976-12-31","ethnicity":null,"genderType":{"code":"M"},"race":null},"eligibilityAttributes":{"enrolleeMemberFacingIdentifier":"","relationshipType":{"description":"Spouse"},"subscriberMemberFacingIdentifier":""},"enrolleeSourceCode":"OP","enrolleeSourceId":"SPT 833048033    1 533113548","individualIdentifier":"cdb:13:297863333:OP:SPT 833048033    1 533113548","legacyAttributes":{"customerNumber":"","relationshipCode":""},"organizationType":{"code":""},"personName":{"firstName":"COREY","lastName":"SMITH","middleName":"","suffix":""},"postalAddresses":[{"addressType":{"code":"P"},"beginDate":"0001-01-01","endDate":null,"isoCountry":{"code":""},"line1Text":"17620 228TH PLACE NE","line2Text":"","postalCode":"98072","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":true,"stateProvinceCode":"WA","townName":"WOODINVILLE"}],"primeDependentCode":"","researchAuthorizationIndicator":false,"socialSecurityNumber":"024562545","sourceSystemAttributes":{"cdb":{"consumerId":297863333,"customerAccountIdentifier":"00001702","familyPartitionNumber":163,"migratedMemberships":null,"partitionNumber":13,"referenceData":{"subscriberRelationshipTypeCode":"001"},"spclProcHndlCd":"","xrefId":19491533}},"sourceSystemCode":"CDB"},"memberships":[{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2012-01-01","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2099-01-01"}]},{"sourceIndividual":{"active":true,"alternateIdentifiers":{"alternateIds":[{"identifier":"533113548"}],"alternateSubscriberId":"533113548","employerAssignedIds":[{"identifier":"053310"}],"enterpriseIndividualIdentifier":null,"familyId":10638463,"hicNumbers":null,"medicaidRecipientNumbers":null,"memberAlternateIds":null,"memberFamilyLinkIds":null,"memberId":"","priorMemberIds":null,"sourceSystemIds":[{"identifier":"SPT 462453429    2 533113548"}],"survivingSpouseIds":null},"birthSequenceNumber":"","demographicInfo":{"birthDate":"2006-02-15","ethnicity":null,"genderType":{"code":"F"},"race":null},"eligibilityAttributes":{"enrolleeMemberFacingIdentifier":"","relationshipType":{"description":"Child"},"subscriberMemberFacingIdentifier":""},"enrolleeSourceCode":"OP","enrolleeSourceId":"SPT 462453429    2 533113548","individualIdentifier":"cdb:11:297728171:OP:SPT 462453429    2 533113548","legacyAttributes":{"customerNumber":"","relationshipCode":""},"organizationType":{"code":""},"personName":{"firstName":"SAMANTHA","lastName":"SMITH","middleName":"","suffix":""},"postalAddresses":[{"addressType":{"code":"P"},"beginDate":"0001-01-01","endDate":null,"isoCountry":{"code":""},"line1Text":"13222 BEAR MOUNTAIN RD SE","line2Text":"","postalCode":"98272","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":true,"stateProvinceCode":"WA","townName":"MONROE"}],"primeDependentCode":"","researchAuthorizationIndicator":false,"socialSecurityNumber":"","sourceSystemAttributes":{"cdb":{"consumerId":297728171,"customerAccountIdentifier":"00001702","familyPartitionNumber":163,"migratedMemberships":null,"partitionNumber":11,"referenceData":{"subscriberRelationshipTypeCode":"002"},"spclProcHndlCd":"","xrefId":19305043}},"sourceSystemCode":"CDB"},"memberships":[{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2008-01-15","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2008-03-06"},{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2008-03-25","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2008-04-01"},{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2008-04-22","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2099-01-01"}]},{"sourceIndividual":{"active":true,"alternateIdentifiers":{"alternateIds":[{"identifier":"533113548"}],"alternateSubscriberId":"533113548","employerAssignedIds":[{"identifier":"053310"}],"enterpriseIndividualIdentifier":"34271581","familyId":10638463,"hicNumbers":null,"medicaidRecipientNumbers":null,"memberAlternateIds":null,"memberFamilyLinkIds":null,"memberId":"","priorMemberIds":null,"sourceSystemIds":[{"identifier":"SPT 462453279    0 533113548"}],"survivingSpouseIds":null},"birthSequenceNumber":"","demographicInfo":{"birthDate":"1974-12-16","ethnicity":null,"genderType":{"code":"F"},"race":null},"eligibilityAttributes":{"enrolleeMemberFacingIdentifier":"","relationshipType":{"description":"Self"},"subscriberMemberFacingIdentifier":""},"enrolleeSourceCode":"OP","enrolleeSourceId":"SPT 462453279    0 533113548","individualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","legacyAttributes":{"customerNumber":"","relationshipCode":"EE"},"organizationType":{"code":""},"personName":{"firstName":"GENEVIEVE","lastName":"DUJENSKI","middleName":"H","suffix":""},"postalAddresses":[{"addressType":{"code":"P"},"beginDate":"0001-01-01","endDate":null,"isoCountry":{"code":""},"line1Text":"20395 SPRINGBROOK ROAD SE","line2Text":"","postalCode":"98272","postalSuffixCode":"","preferredIndicator":false,"primaryIndicator":true,"stateProvinceCode":"WA","townName":"MONROE"}],"primeDependentCode":"","researchAuthorizationIndicator":false,"socialSecurityNumber":"533113548","sourceSystemAttributes":{"cdb":{"consumerId":297899202,"customerAccountIdentifier":"00001702","familyPartitionNumber":163,"migratedMemberships":null,"partitionNumber":2,"referenceData":{"subscriberRelationshipTypeCode":"000"},"spclProcHndlCd":"","xrefId":19542563}},"sourceSystemCode":"CDB"},"memberships":[{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2008-01-15","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2008-03-06"},{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2008-03-25","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2008-04-01"},{"active":true,"cancelReasonType":null,"claimSystemType":null,"coveragePaidThruDate":"9999-12-31","customerAccount":{"businessArrangement":{"code":"","description":null},"customerAccountIdentifier":"00001702","obligor":{"code":""},"purchasePlanIdentifier":null,"sharedArrangement":{"code":""}},"customerAccountIdentifier":"00001702","divisionCode":"","effectiveDate":"2008-04-22","eligibilityGracePeriodThruDate":null,"eligibilitySystemType":{"code":"05"},"legacyAttributes":{"cancelReasonType":{"code":""},"governmentProgramType":null,"stateIssueCode":""},"marketSegment":null,"marketType":null,"memberEnrollmentOtherIdentifiers":null,"memberMarketNumber":null,"organization":{"planVariationCode":"","reportingCode":""},"panelNumber":null,"passportGroupNumber":"","plan":{},"planCode":"","product":{"categoryType":null,"healthCoverageType":{"description":"GETWELL"},"serviceType":null},"recordType":"HEALTH_SERVICE","sourceSystemAttributes":{"cdb":{"cesGroupNumber":"","legacyProductCode":"WELS","legacyProductId":"","referenceData":{"coverageLevelTypeCode":"","coverageTypeCode":null}}},"sourceSystemCode":"CDB","subscriberIndividualIdentifier":"cdb:2:297899202:OP:SPT 462453279    0 533113548","terminationDate":"2099-01-01"}]}],"eligibilityMetaData":{"totalResults":4}}');
        String responseStr = response.getBody();
        system.debug('responseStr** ' + responseStr);
        //TestJSONClass jsonwraptemp = TestJSONClass.parse(responseStr);                 
                         
    
        return null;         

    }
    public static list<SelectOption> getPicklistValues(SObject obj, String fld){
        list<SelectOption> options = new list<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values)
        {
            options.add(new SelectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    @AuraEnabled
    public static SearchResultWrapper getHouseHoldData(String transactionId){
        System.debug('transactionId@@@:'+transactionId);
        ACETLinkExtendedCoverageWebservice callWS = new ACETLinkExtendedCoverageWebservice();
        ACETHouseHoldWrapper resultwrap = new ACETHouseHoldWrapper();
        ACETWSCalloutResult CalloutResult = null;
        CalloutResult = callWS.getHouseHoldData(transactionId);

        if (CalloutResult.Success)
        {
            system.debug('CalloutResult');
            system.debug(CalloutResult);
            resultwrap = (ACETHouseHoldWrapper)CalloutResult.Response;
            System.debug('resultwrap.houseHoldList@@@ ' + resultwrap.houseHoldList);
        }
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
        }
        system.debug('>>>resultwrap------'+resultwrap);
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.houseHoldResultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        system.debug('dataWrap....'+dataWrap.message+CalloutResult.Message);
        system.debug('dataWrap....'+dataWrap.message+CalloutResult.statusCode);
        system.debug('dataWrap....'+dataWrap.message+dataWrap.statusCode);
        system.debug('dataWrap....'+dataWrap.message+dataWrap.statusCode);
        return dataWrap;
    }
    
    //Code Added for Oxford -Begin
    @AuraEnabled
    public static SearchResultWrapper getFamilyInfo(String memberId, String surrogateKey, String groupNumber, String effectiveDate,String bundleOptionId,String benefitPlanId){
       
        ACETGetFamilyMemberWebService familyService = new ACETGetFamilyMemberWebService();
        ACETHouseHoldWrapper resultwrap = new ACETHouseHoldWrapper();
        ACETWSCalloutResult CalloutResult = null;
        CalloutResult = familyService.getHouseHoldData(memberId,surrogateKey,groupNumber,effectiveDate,bundleOptionId,benefitPlanId);
        if (CalloutResult.Success){
            resultwrap= (ACETHouseHoldWrapper)CalloutResult.Response; //Code Added By Chandan
            system.debug('CalloutResult.Response');
            system.debug(CalloutResult.Response);
        }
        else{
            
        }
        system.debug('---resultwrap------'+resultwrap);
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.houseHoldResultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        system.debug('dataWrap....'+dataWrap.message+CalloutResult.Message);
        system.debug('dataWrap....'+dataWrap.message+CalloutResult.statusCode);
        system.debug('dataWrap....'+dataWrap.message+dataWrap.statusCode);
        system.debug('dataWrap....'+dataWrap.message+dataWrap.statusCode);
        return dataWrap;
    }
    //end
     
    public static List<ACETSNILinkMemberSearch.wrapperResponse> returnResponseData(AcetLinkEligibilityJSON2Apex.MemberPolicies pat){
        ACETSNILinkMemberSearch.wrapperResponse returnObj = new ACETSNILinkMemberSearch.wrapperResponse();
        List<ACETSNILinkMemberSearch.wrapperResponse> wrapperLst = new List<ACETSNILinkMemberSearch.wrapperResponse>();
        List<AcetLinkEligibilityJSON2Apex.PatientInfo> patInfoLst = null;
        if(pat.patientInfo != null){
            patInfoLst = pat.patientInfo;
            if(patInfoLst != null && patInfoLst.size() > 0){
                for(AcetLinkEligibilityJSON2Apex.PatientInfo patObj : patInfoLst){
                    returnObj.name = patObj.firstName + ' ' + patObj.middleName + ' '  + patObj.lastName;
                    returnObj.dob = patObj.dateOfBirth;
                    returnObj.relationship = patObj.relationship;
                    wrapperLst.add(returnObj);

                }
            }
        }
        return wrapperLst;
    }
    public class wrapperResponse{

        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String dob{get;set;}
        @AuraEnabled public String relationship{get;set;}
    }

    @future
    public static void createAccountContact(String firstName, String middleName, String lastName, String dob, String memberId){
        Account acc = new Account();
        acc.name = firstName + ' ' + middleName + ' ' + lastName;
        acc.EID__c = memberId + dob;
        Database.upsert(acc, Account.Fields.EID__c);

        Contact con = new Contact();
        con.accountid = acc.Id;
        con.LastName = lastName;
        con.EID__c = memberId + dob;
        Database.upsert(con, Contact.Fields.EID__c);
    }

    /* added it to test from the static resource in case if we need it. */
    @AuraEnabled
    public Static String getMemberResponse(){
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'SAEMemberSearchResponseJSON'];
        responseStr = responseJSONSR.Body.toString();
        return responseStr;
    }
    public static String GetRequestFormatByName(String StaticResourceName)  {
        system.debug(LoggingLevel.INFO, 'StaticResourceName: ' + StaticResourceName);
        String RequestBodyFormat = '';
        StaticResource RequestJSONSR;
        if (!test.isRunningTest())  {
            RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name =:StaticResourceName];
            RequestBodyFormat = RequestJSONSR.Body.toString();
        }
        system.debug(LoggingLevel.INFO, 'RequestBodyFormat: ' + RequestBodyFormat);
        return RequestBodyFormat;
    }

    public static String GetRequestBody(String StaticResourceName, List<String> RequestParameters)  {
        String RequestBodyFormat = GetRequestFormatByName(StaticResourceName);
        String RequestBody;
        if (!test.isRunningTest())  {
            RequestBody = String.format(RequestBodyFormat, RequestParameters).replaceAll('~', '{');
        }
        system.debug(LoggingLevel.INFO, 'RequestBody: ' + RequestBody);
        return RequestBody;
    }

    /*@AuraEnabled
    public static List<State__mdt> getStateValues() {
        List<State__mdt> stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName asc];
        return stateList;
    }*/
                         
     //Cherry - added to fetch data from CDB API                    
     @AuraEnabled
    public static SearchResultWrapper findMembersFromCDB (String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String workOrderId){

        SearchResultWrapper dataWrap = new SearchResultWrapper();
        System.debug('parameters....'+'member'+memberId+'memberdob'+memberDOB+'first'+firstName+'last'+lastName+'group'+groupNumber+'search'+searchOption);
        dataWrap = CDB_ACETWebservice.getCDBData(memberId,memberDOB,firstName,lastName,groupNumber,searchOption,workOrderId);
        dataWrap = memberExistInSENS(dataWrap,memberId, memberDOB, firstName, lastName, groupNumber, searchOption);
        system.debug('dataWrap'+dataWrap);
        return dataWrap;        
    }
                         
     @AuraEnabled
     public static SearchResultWrapper setWrapperData(String apiIdentifier,String memberId,boolean IsSandbox, Map<String,WebserviceConfigurations__c> mapNameToWebservice,string token,string woId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption){   
    	system.debug('INside setwrapperdaata***');
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap = CDB_ACETWebservice.setWrapperData(apiIdentifier,IsSandbox,mapNameToWebservice,token,woId,memberId);
    	dataWrap = memberExistInSENS(dataWrap,memberId, memberDOB, firstName, lastName, groupNumber, searchOption);
    	system.debug('-------->'+ dataWrap.houseHoldResultWrapper.memberDetails);
        system.debug('----s---->'+ dataWrap.statusCode);
        system.debug('dataWrap'+dataWrap);
        return dataWrap;
    } 
                                      
    @AuraEnabled
    public static SearchResultWrapper memberExistInSENS(SearchResultWrapper dataWrap, String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption){
         ACETHouseHoldWrapper hhW = new ACETHouseHoldWrapper();
                             ACETHouseHoldWrapper.memberDetails md = new ACETHouseHoldWrapper.memberDetails();
                             List<AccountContactRelation> ACR = new List<AccountContactRelation>();
                             system.debug('memberExistInSENS=='+dataWrap.statusCode);
                             String fullname = firstName + ' ' + lastName;
                             if (dataWrap.statusCode == 404 || (dataWrap.statusCode == 200 && (String.isEmpty(dataWrap.houseHoldResultWrapper.memberDetails.accountId) || dataWrap.houseHoldResultWrapper.memberDetails.accountId == null))) {           
                                 String Querystr = 'SELECT Id, AccountId, Contact.Name FROM AccountContactRelation ';
                                 if(searchOption == 'MemberIDNameGroupNumberDateOfBirth' || searchOption == 'MemberIDNameDateOfBirth' || searchOption == 'MemberIDLastNameDateOfBirth' || searchOption == 'MemberIDFirstNameDateOfBirth' || searchOption == 'MemberIDDateOfBirth'){  
                                     Date Dateval= Date.valueOf(memberDOB);
                                     Date dValue = Date.newInstance(Dateval.year(), Dateval.month(), Dateval.day());
                                     system.debug(dValue);
                                     //String dtVal = Dateval.format('yyyy-MM-dd');
                                     system.debug(Dateval);
                                     system.debug(memberId);
                                     Querystr+='WHERE Account.Member_ID__c =: memberId AND Contact.Birthdate =: dValue LIMIT 1';
                                 }else if (searchOption == 'MemberIDName') {
                                     Querystr += 'WHERE Account.Member_ID__c =: memberId';
                                 } 
                                 else if (searchOption == 'NameDateOfBirth') {
                                     Date Dateval= Date.valueOf(memberDOB);
                                     Querystr += 'WHERE Contact.Birthdate =: dValue';
                                 }
                                 /*if(searchOption == 'MemberIDName'){
                                    Querystr+='WHERE Account.Member_ID__c =: memberId AND Contact.Name =: fullname LIMIT 1';
                                    }
                                    If(searchOption == 'NameDateOfBirth'){
                                    Date Dateval= Date.valueOf(memberDOB);
                                    Querystr+='WHERE Contact.Name =: fullname AND  Contact.Birthdate =: Dateval LIMIT 1';            
                                    }*/
                                 system.debug('Querystr99--'+Querystr);
                                 ACR = Database.query(Querystr);
                                 system.debug('ACR--'+ACR);
                                 if (ACR.size()>0){
                                     String accountStr;
                                     if(searchOption == 'MemberIDNameGroupNumberDateOfBirth' || searchOption == 'MemberIDNameDateOfBirth' || searchOption == 'MemberIDLastNameDateOfBirth' || searchOption == 'MemberIDFirstNameDateOfBirth' || searchOption == 'MemberIDDateOfBirth'){
                                         accountStr = 'SNI@' + ACR[0].AccountId;
                                     } else if (searchOption == 'MemberIDName' || searchOption == 'NameDateOfBirth') {
                                         for (AccountContactRelation ac : ACR) {
                                             system.debug('ac.Contact.Name-'+ac.Contact.Name);
                                             system.debug('fullname-'+fullname);
                                             if (ac.Contact.Name == fullname) {
                                                 accountStr = 'SNI@' + ac.AccountId;
                                                 system.debug('accountStr-'+accountStr);
                                             }
                                         }	
                                     }
                                     if (accountStr != null) {
                                     md.accountId = accountStr;
                                     hhW.memberDetails = md;
                                     dataWrap.houseHoldResultWrapper= hhW;
                                     dataWrap.statusCode = 200;
                                     }
                                 }
                             }
                             return dataWrap;
                         }
}