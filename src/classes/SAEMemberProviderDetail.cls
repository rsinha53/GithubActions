public class SAEMemberProviderDetail {

    //Defining class variables for API Reuse
    // US3268922 Member Snapshot Enhancement: Policies Card - All Toggle Button - Sarma - 15/02/2021
    public class EligibilityCalloutRequestWrapper{
        public MemberDetails memberDetailsObject {get;set;}
        public ACET_ProviderSearchCtrl.ProviderDetails providerDetailsObject {get;set;}       
        //US3595185	Implementation : Capture Logs for Eligibility - Sarma - 9th June 2021
        public String firstCallRequest {get;set;}
        public String secondCallRequest {get;set;}
        public String thirdCallRequest {get;set;}
        public String endPoint {get;set;}
    }
    //US3595185
    public class EligibilityErrorLog{
        public String applicationFlow {get;set;}
        public String endPoint {get;set;}
        public String requestBody {get;set;}
        public String responseStatus {get;set;}
        public String responseBody {get;set;}
        public Integer statusCode {get;set;}
    }

    public class SubjectCardSearchResultWrapper{
        @AuraEnabled public SAEProviderMemberSearchInteractionResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }

	public class SearchResultWrapper{
        @AuraEnabled public SAEMemberProviderSearchCoveragesResult resultWrapper {get;set;}

        //  US1813580 - Error Message Translation
        // Sanka Dharmasena - 12/06/2019
        @AuraEnabled public Integer statusCode{get;set;}
        @AuraEnabled public String message{get;set;}
        // End

        //US1933887 - UHG Access
        // Sanka Dharmasena - 30/07/2019
        @AuraEnabled public Boolean hasAccess{get;set;}
        @AuraEnabled public Boolean showRefershError{get;set;}
    }
    //US1970508 - Ravindra - start
    @AuraEnabled
    public static Object upsertPersonAccount(String memberFirstName, String memberLastName, String memberDOB, String memberId, String groupNumber, String memberPhone, String interactionId, String mnf, Boolean isProviderSearchDisabled, Boolean isOtherSearch){ //String xRefId 3rd parameter
        
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Third_Party__c thirdParty = new Third_Party__c();
        Account personContact = new Account();
        Account acc = new Account();
        Interaction__c interaction = new Interaction__c();
        if(mnf == 'mnf') {
            
            if(!isOtherSearch){
                
                //create member third party record
                //DE285331 - Ravindra start
                thirdParty.FullName__c = memberFirstName + ' ' + memberLastName;
                thirdParty.DOB__c = Date.parse(memberDOB);
                //DE285331 - Ravindra end
                thirdParty.First_Name__c = memberFirstName;
                thirdParty.LastName__c = memberLastName;
				if(memberPhone != null)
                thirdParty.Phone_Number__c = memberPhone.remove('-');
                Database.upsert(thirdParty);
                //DE285331 - Ravindra start //DE356886 below two lined Commented by vinay
                //interaction = new Interaction__c(Id=interactionId, Third_Party__c=thirdParty.Id);
                //Database.update(interaction);
                //DE285331 - Ravindra end
                
            }
        } else {
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = memberFirstName;
            acc.LastName = memberLastName;
            acc.PersonBirthdate = Date.parse(memberDOB);
            acc.EID__c = memberFirstName + memberLastName + memberDOB.remove('/') + memberId + groupNumber;
			if(memberPhone != null)
            acc.Phone = memberPhone.remove('-');
            //acc.XRefId__c = xRefId;
            Database.upsert(acc, Account.Fields.EID__c);
            
            personContact = [SELECT Id, FirstName, LastName, PersonContactId FROM Account WHERE Id = :acc.Id];
        }
        //
        if(isProviderSearchDisabled || isOtherSearch){
            
            if(mnf == 'mnf') {
                if(!isOtherSearch){
                    interaction = new Interaction__c(Id=interactionId, Third_Party__c=thirdParty.Id);
                    Database.update(interaction);
                    
                }
                return thirdParty;
            } else {
                if(!isOtherSearch){

                    interaction = new Interaction__c(Id=interactionId, Originator__c=personContact.PersonContactId);
                    Database.update(interaction);
                   
                }
                return personContact;
            }
        }
        if(mnf == 'mnf') {
            return thirdParty;
        } else {
            return personContact;
        }


    }
    //US1970508 - Ravindra - end

    //US2465288 - Avish
    @AuraEnabled
    public static List<ACETGetCases.CaseWrapper> getRelatedCasesHistory(String taxMemberID, String xRefIdIndividual, Boolean toggleOnOff, String flowType){
       
        List<ACETGetCases.CaseWrapper> caseWrapperlst = new List<ACETGetCases.CaseWrapper>();
        caseWrapperlst = ACETGetCases.getRelatedCases(taxMemberID, xRefIdIndividual, toggleOnOff, flowType);
        return caseWrapperlst;
    }
    //Added by ETSBE Team to get the case history
	@AuraEnabled
    public static List<ETSBE_GetCases.CaseWrapper> getRelatedETSBECasesHistory(String producerID,String groupID,String taxMemberID, String xRefIdIndividual, Boolean toggleOnOff, String flowType){
        
        List<ETSBE_GetCases.CaseWrapper> caseWrapperlst = new List<ETSBE_GetCases.CaseWrapper>();
        caseWrapperlst = ETSBE_GetCases.getRelatedCases(producerid,groupid,taxMemberID, xRefIdIndividual, toggleOnOff, flowType);
        
        return caseWrapperlst;
    }
    @AuraEnabled
    public static List<Case> getMemberRelatedCases(String memberID, Boolean toggleOnOff){
        
        List<Case> caseLst = new List<Case>();
        if(toggleOnOff){
            if(String.isNotBlank(memberID))
            	caseLst = [SELECT id, Originator_Type__c, CreatedDate,ID__c,CaseNumber, Status, Surrogate_Key__c,Subject_Name__c FROM CASE where ID__c =: memberID];
        }else{
            if(String.isNotBlank(memberID))
            	caseLst = [SELECT id, Originator_Type__c, CreatedDate,ID__c,CaseNumber, Status, Surrogate_Key__c,Subject_Name__c FROM CASE where Surrogate_Key__c =: memberID];
        }
       
        return caseLst;
    }

    @AuraEnabled
    public static SAEHouseHoldController.SearchResultWrapper getHouseHoldData(String transactionId){
   
        SAEHouseHoldController.SearchResultWrapper response = (SAEHouseHoldController.SearchResultWrapper)SAEHouseHoldController.SearchResultWrapper.getHouseHoldMembers(transactionId);
        
        return response;
    }

    @AuraEnabled
    public static SAECOBController.CobSearchResultWrapper getCobData(String transactionId){
   
        SAECOBController.CobSearchResultWrapper response = (SAECOBController.CobSearchResultWrapper)SAECOBController.CobSearchResultWrapper.getCob(transactionId);
        return response;
    }

    @AuraEnabled(continuation = true cacheable = true) //SearchResultWrapper
    public static Object fetchData(String transactionId, String memberId, String memberDOB, String memberFN, String memberLN, String memberGrpN, String searchOption, String payerID) {
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        
        if (searchOption == null) {
            searchOption = 'NameDateOfBirth';
        }
        SAEGetMemberProviderWebService memberProviderService = new SAEGetMemberProviderWebService();
        ACETWSCalloutResult CalloutResult = null;
        String reqMethod = 'GET';
        HttpResponse response;
        String endPoint = ISL_Webservice_Config__c.getInstance('SAE_ProviderSearch').Value__c;
        String dateStr = SAEUtils.formatDateRequest(memberDOB);
        String serviceStart = SAEUtils.formatDateFutureDate(System.today().addYears(-5).format()); //US2034277 : TECH - Eligibility V2 Request Changes : old value -6
        //String serviceEnd = SAEUtils.formatDateFutureDate(System.today().addYears(1).format());
        String serviceEnd = SAEUtils.formatDateFutureDate(Date.newInstance(System.today().year(), 12, 31).format());
        String strProviderLastName = 'ACET';
        String strTaxIdNumber = '9999999';
        String strProviderNameID = '9999999';
        if (searchOption.equals('MemberIDNameDateOfBirth')) {
            memberGrpN = '';
        } else if (searchOption.equals('MemberIDLastNameDateOfBirth')) {
            memberGrpN = '';
            memberFN = '';
        } else if (searchOption.equals('MemberIDFirstNameDateOfBirth')) {
            memberGrpN = '';
            memberLN = '';
        } else if (searchOption.equals('NameDateOfBirth')) {
            memberGrpN = '';
        } else if (searchOption.equals('MemberIDDateOfBirth')) {
            memberGrpN = '';
            memberFN = '';
            memberLN = '';
        } else if (searchOption.equals('MemberIDName')) {
            memberGrpN = '';
            dateStr = '';
        }
        if (memberId == '101987516') {
            serviceStart = '2016-10-03';
        }

        String resultQuery = formRequestParameters(memberId, memberDOB, memberFN,
                                                memberLN, memberGrpN, searchOption,
                                                strProviderLastName, dateStr, strProviderNameID,
                                                serviceStart, serviceEnd, strTaxIdNumber, payerID);

        // Create continuation. Argument is timeout in seconds.
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod = 'processResponse';
        // Set state
        con.state = 'Hello, World!';
        // Create callout request
        HttpRequest req = new HttpRequest();
        
        String url = endPoint + resultQuery;
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations.keySet()) {
            if (wsConfigurations.containsKey('ISLOAuthContentType')) {
                req.setHeader('Content-Type', wsConfigurations.get('ISLOAuthContentType').Value__c);
            }
        }
        List < Token_Generation__c > acessTokenRec = [SELECT id, name, Token_Name__c, Value__c FROM Token_Generation__c WHERE Token_Name__c = 'ISLConAccessToken'];
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req);
        

        //2 start
        HttpRequest req2 = new HttpRequest();
       

        Integer nextYear = System.today().year() + 1;
        String firstDayOfNextCalendarYear = SAEUtils.formatDateFutureDate(Date.newInstance(nextYear, 01, 01).format());
        String resultQuery2 = formRequestParameters(memberId, memberDOB, memberFN,
                                                memberLN, memberGrpN, searchOption,
                                                strProviderLastName, dateStr, strProviderNameID,
                                                firstDayOfNextCalendarYear, '', strTaxIdNumber, payerID);
        String url2 = endPoint + resultQuery2;
        req2.setEndpoint(url2);
        req2.setMethod('GET');
        req2.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations2 = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations2.keySet()) {
            if (wsConfigurations2.containsKey('ISLOAuthContentType')) {
                req2.setHeader('Content-Type', wsConfigurations2.get('ISLOAuthContentType').Value__c);
            }
        }
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req2.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req2);
        

        //3 start
        HttpRequest req3 = new HttpRequest();
        
        //USS2221006
        String resultQuery3 = formRequestParameters(memberId, memberDOB, memberFN,
                                                memberLN, memberGrpN, 'MemberIDNameDateOfBirth',
                                                strProviderLastName, dateStr, strProviderNameID,
                                                '', '', strTaxIdNumber, payerID);
        String url3 = endPoint + resultQuery3;
        req3.setEndpoint(url3);
        req3.setMethod('GET');
        req3.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations3 = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations3.keySet()) {
            if (wsConfigurations3.containsKey('ISLOAuthContentType')) {
                req3.setHeader('Content-Type', wsConfigurations3.get('ISLOAuthContentType').Value__c);
            }
        }
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req3.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req3);
        
        // Return the continuation
        
        return con;
        ////
    }

    //US3076045 - Avish
    public class MemberDetails {
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String memberDOB {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String searchOption {get;set;}
        @AuraEnabled public String payerId {get;set;}
        @AuraEnabled public String memberUniqueId {get;set;}
        @AuraEnabled public String transactionId {get;set;}   
        @AuraEnabled public Boolean isFourthCallout {get;set;}   
        @AuraEnabled public String serviceStart {get;set;}
        @AuraEnabled public String serviceEnd {get;set;}
        @AuraEnabled public string sourceCode {get;set;}
    }
    
    
    private static Map <String, String> getRequestParamMap(ACET_ProviderSearchCtrl.ProviderDetails providerDetails,MemberDetails memberDetails){
        Map < String, String > requestParamsMap = new Map < String, String > ();
        if(providerDetails.isProviderNotFound || providerDetails.isNoProviderToSearch || providerDetails.isOther) {
            
            requestParamsMap.put('providerLastName', System.Label.SAEProviderLastName);
            requestParamsMap.put('providerFirstName', '');
            requestParamsMap.put('providerNameID', System.Label.SAEProviderNameID);
            requestParamsMap.put('taxIdNumber', System.Label.SAEProviderTaxIdNumber);
            
        } else {
            
            requestParamsMap.put('providerLastName', String.isNotBlank(providerDetails.lastName) ? providerDetails.lastName : '');
            requestParamsMap.put('providerFirstName', String.isNotBlank(providerDetails.firstName) ? providerDetails.firstName : '');
            requestParamsMap.put('providerNameID', String.isNotBlank(providerDetails.providerId) ? providerDetails.providerId : '');
            requestParamsMap.put('taxIdNumber', String.isNotBlank(providerDetails.taxId) ? providerDetails.taxId : '');
        }               
        
        requestParamsMap.put('searchOption', String.isNotBlank(memberDetails.searchOption) ? memberDetails.searchOption : '');
        if(memberDetails.isFourthCallout){
            requestParamsMap.put('memberId', String.isNotBlank(memberDetails.memberId) ? memberDetails.memberId : '');
        }else{
            requestParamsMap.put('memberId','');
        }   
        
        requestParamsMap.put('firstName', String.isNotBlank(memberDetails.firstName) ? memberDetails.firstName : '');
        requestParamsMap.put('lastName', String.isNotBlank(memberDetails.lastName) ? memberDetails.lastName : '');
        requestParamsMap.put('dateOfBirth', String.isNotBlank(memberDetails.memberDOB) ? memberDetails.memberDOB : '');
        requestParamsMap.put('groupNumber', String.isNotBlank(memberDetails.groupNumber) ? memberDetails.groupNumber : '');
        requestParamsMap.put('payerID', String.isNotBlank(memberDetails.payerId) ? memberDetails.payerId : '');
        requestParamsMap.put('serviceStart', String.isNotBlank(memberDetails.serviceStart) ? memberDetails.serviceStart : '');
        requestParamsMap.put('serviceEnd', String.isNotBlank(memberDetails.serviceEnd) ? memberDetails.serviceEnd : '');     
        
        
        return requestParamsMap;
    }
    //US3076045 - Ends
    
    @AuraEnabled(continuation = true cacheable = true) 
    public static Object callEligibilityServices(MemberDetails memberDetails, ACET_ProviderSearchCtrl.ProviderDetails providerDetails) {
        System.debug('memberDetails@@ ' + memberDetails);
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        
        if (memberDetails.searchOption == null) {
            memberDetails.searchOption = 'NameDateOfBirth';
        }
        SAEGetMemberProviderWebService memberProviderService = new SAEGetMemberProviderWebService();
        ACETWSCalloutResult CalloutResult = null;
        HttpResponse response;
        memberDetails.memberDOB = SAEUtils.formatDateRequest(memberDetails.memberDOB);
        // US3268922
        String serviceStart = SAEUtils.formatDateFutureDate(System.today().addYears(-3).format()); //US2034277 : TECH - Eligibility V2 Request Changes : old value -6
        //String serviceEnd = SAEUtils.formatDateFutureDate(System.today().addYears(1).format());
        String serviceEnd = SAEUtils.formatDateFutureDate(Date.newInstance(System.today().year(), 12, 31).format());
        
        Map < String, String > requestParamsMap = new Map < String, String > ();
        
        // Create continuation. Argument is timeout in seconds.
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod = 'processResponse';
        // Set state
        // US3268922	Member Snapshot Enhancement: Policies Card - All Toggle Button - Sarma - 15/02/2021
        EligibilityCalloutRequestWrapper eligibilityCalloutRequestWrapper = new EligibilityCalloutRequestWrapper(); 
        eligibilityCalloutRequestWrapper.memberDetailsObject = memberDetails;
        eligibilityCalloutRequestWrapper.providerDetailsObject = providerDetails;

        System.debug('memberDetails@@ ' + eligibilityCalloutRequestWrapper);

        //con.state = eligibilityCalloutRequestWrapper;
        
        // Create callout request
        memberDetails.serviceStart = serviceStart;
        memberDetails.serviceEnd = serviceEnd;
        requestParamsMap = getRequestParamMap(providerDetails, memberDetails); 
        
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;
        if (!Test.isRunningTest()) {
        HttpRequest firstCalloutReq = wsCallOutFW.getHttpRequest();
        // Add callout request to continuation
        con.addHttpRequest(firstCalloutReq);
        //US3595185
        eligibilityCalloutRequestWrapper.firstCallRequest = firstCalloutReq.getEndpoint();

        String endpointTemp = firstCalloutReq.getEndpoint();
        List<String> endpointStringList = endpointTemp.split('\\?', 2);
        if(endpointStringList.size() > 0){
            eligibilityCalloutRequestWrapper.endPoint = endpointStringList[0];
        }
        }
        
        //2 start
        HttpRequest req2 = new HttpRequest();
        
        Integer nextYear = System.today().year() + 1;
        Integer currentMonth = System.today().Month();
        Date nextYearCurrentMonth = Date.newInstance(nextYear, currentMonth, 01);
        Integer numberOfDays = Date.daysInMonth(nextYearCurrentMonth.year(), nextYearCurrentMonth.month());

        String endDateofNextCalendarYear = SAEUtils.formatDateFutureDate(Date.newInstance(nextYear,currentMonth,numberOfDays).format());
        System.debug('endDateofNextCalendarYear: '+endDateofNextCalendarYear);

        String firstDayOfNextCalendarYear = SAEUtils.formatDateFutureDate(Date.newInstance(nextYear, 01, 01).format());
        
        memberDetails.serviceStart = firstDayOfNextCalendarYear;
        memberDetails.serviceEnd =  endDateofNextCalendarYear;
        requestParamsMap = getRequestParamMap(providerDetails, memberDetails); 
        
        ACET_WebserviceCalloutFramework wsCallOutFWSecond = new ACET_WebserviceCalloutFramework();
        wsCallOutFWSecond.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFWSecond.requestParamsMap = requestParamsMap;
        wsCallOutFWSecond.encodeURLParameters = true;
        if (!Test.isRunningTest()) {
        HttpRequest secondCalloutReq = wsCallOutFWSecond.getHttpRequest();
        // Add callout request to continuation
        con.addHttpRequest(secondCalloutReq);
        //US3595185
        eligibilityCalloutRequestWrapper.secondCallRequest = secondCalloutReq.getEndpoint();
        }
        //3 start
        // US3268922
        serviceStart = SAEUtils.formatDateFutureDate(System.today().addYears(-5).format());  
        serviceEnd = SAEUtils.formatDateFutureDate(System.today().addYears(-3).format());  
        memberDetails.serviceStart = serviceStart;
        memberDetails.serviceEnd = serviceEnd;
        System.debug('Callout3 StartDate@@@ '+ memberDetails.serviceStart);
        System.debug('Callout3 EndDate@@@ '+ memberDetails.serviceEnd);
        //memberDetails.serviceStart = SAEUtils.formatDateFutureDate(System.today().addYears(-5).format());  
        //memberDetails.serviceEnd = SAEUtils.formatDateFutureDate(System.today().addYears(-3).addDays(-1).format()); 
        requestParamsMap = getRequestParamMap(providerDetails, memberDetails); 
        
        ACET_WebserviceCalloutFramework wsCallOutFWThird = new ACET_WebserviceCalloutFramework();
        wsCallOutFWThird.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFWThird.requestParamsMap = requestParamsMap;
        wsCallOutFWThird.encodeURLParameters = true;
        if (!Test.isRunningTest()) {
        HttpRequest thirdCalloutReq = wsCallOutFWThird.getHttpRequest();
        // Add callout request to continuation
        con.addHttpRequest(thirdCalloutReq);
        //US3595185
        eligibilityCalloutRequestWrapper.thirdCallRequest = thirdCalloutReq.getEndpoint();
        // passing data to state, to be reused in the call back method
        con.state = eligibilityCalloutRequestWrapper;
        }
        // Return the continuation   
        return con;
    }

    @AuraEnabled(continuation = true cacheable = true) //SearchResultWrapper
    public static Object getMemberDetails(String transactionId, String memberId, String memberDOB, String memberFN, String memberLN, String memberGrpN, String searchOption, String payerID, ACET_ProviderSearchCtrl.ProviderDetails providerDetails) {
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        
        if (searchOption == null) {
            searchOption = 'NameDateOfBirth';
        }
        SAEGetMemberProviderWebService memberProviderService = new SAEGetMemberProviderWebService();
        ACETWSCalloutResult CalloutResult = null;
        String reqMethod = 'GET';
        HttpResponse response;
        String endPoint = ISL_Webservice_Config__c.getInstance('SAE_ProviderSearch').Value__c;
        String dateStr = SAEUtils.formatDateRequest(memberDOB);
        String serviceStart = SAEUtils.formatDateFutureDate(System.today().addYears(-5).format()); //US2034277 : TECH - Eligibility V2 Request Changes : old value -6
        //String serviceEnd = SAEUtils.formatDateFutureDate(System.today().addYears(1).format());
        String serviceEnd = SAEUtils.formatDateFutureDate(Date.newInstance(System.today().year(), 12, 31).format());
        String strProviderLastName = '';
        String strTaxIdNumber = '';
        String strProviderNameID = '';
        String providerfirstName = '';
        String providerNPI = '';
        if(providerDetails.isProviderNotFound || providerDetails.isNoProviderToSearch || providerDetails.isOther) {
            strProviderLastName = 'ACET'; 
            strTaxIdNumber = '9999999';
            strProviderNameID = '9999999';
        } else {
            strProviderLastName = providerDetails.lastName; 
            strTaxIdNumber = providerDetails.taxId;
            providerfirstName = providerDetails.firstName;
            providerNPI = providerDetails.npi;
            strProviderNameID = providerDetails.providerId;
        }
        
        if (searchOption.equals('MemberIDNameDateOfBirth')) {
            memberGrpN = '';
        } else if (searchOption.equals('MemberIDLastNameDateOfBirth')) {
            memberGrpN = '';
            memberFN = '';
        } else if (searchOption.equals('MemberIDFirstNameDateOfBirth')) {
            memberGrpN = '';
            memberLN = '';
        } else if (searchOption.equals('NameDateOfBirth')) {
            memberGrpN = '';
        } else if (searchOption.equals('MemberIDDateOfBirth')) {
            memberGrpN = '';
            memberFN = '';
            memberLN = '';
        } else if (searchOption.equals('MemberIDName')) {
            memberGrpN = '';
            dateStr = '';
        }
        if (memberId == '101987516') {
            serviceStart = '2016-10-03';
        }

        String resultQuery = formRequestParameters(memberId, memberDOB, memberFN,
                                               memberLN, memberGrpN, searchOption,
                                               strProviderLastName, dateStr, strProviderNameID,
                                               serviceStart, serviceEnd, strTaxIdNumber, payerID,
                                               providerfirstName,providerNPI,false);

        // Create continuation. Argument is timeout in seconds.
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod = 'processResponse';
        // Set state
        con.state = 'Hello, World!';
        // Create callout request
        HttpRequest req = new HttpRequest();
        
        String url = endPoint + resultQuery;
        system.debug('continustionRequest1@@ ' + url);
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations.keySet()) {
            if (wsConfigurations.containsKey('ISLOAuthContentType')) {
                req.setHeader('Content-Type', wsConfigurations.get('ISLOAuthContentType').Value__c);
            }
        }
        List < Token_Generation__c > acessTokenRec = [SELECT id, name, Token_Name__c, Value__c FROM Token_Generation__c WHERE Token_Name__c = 'ISLConAccessToken'];
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req);
        

        //2 start
        HttpRequest req2 = new HttpRequest();


        Integer nextYear = System.today().year() + 1;
        String firstDayOfNextCalendarYear = SAEUtils.formatDateFutureDate(Date.newInstance(nextYear, 01, 01).format());
        String resultQuery2 = formRequestParameters(memberId, memberDOB, memberFN,
                                                memberLN, memberGrpN, searchOption,
                                                strProviderLastName, dateStr, strProviderNameID,
                                                firstDayOfNextCalendarYear, '', strTaxIdNumber, payerID,
                                                providerfirstName, providerNPI,false);
        String url2 = endPoint + resultQuery2;
        system.debug('continustionRequest2@@ ' + url2);
        req2.setEndpoint(url2);
        req2.setMethod('GET');
        req2.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations2 = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations2.keySet()) {
            if (wsConfigurations2.containsKey('ISLOAuthContentType')) {
                req2.setHeader('Content-Type', wsConfigurations2.get('ISLOAuthContentType').Value__c);
            }
        }
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req2.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req2);
        

        //3 start
        HttpRequest req3 = new HttpRequest();
        
        //USS2221006
        String resultQuery3 = formRequestParameters(memberId, memberDOB, memberFN,
                                                memberLN, memberGrpN, searchOption,
                                                strProviderLastName, dateStr, strProviderNameID,
                                                '', '', strTaxIdNumber, payerID, providerfirstName, providerNPI,false);
        String url3 = endPoint + resultQuery3;
        system.debug('continustionRequest3@@ ' + url3);
        req3.setEndpoint(url3);
        req3.setMethod('GET');
        req3.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations3 = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations3.keySet()) {
            if (wsConfigurations3.containsKey('ISLOAuthContentType')) {
                req3.setHeader('Content-Type', wsConfigurations3.get('ISLOAuthContentType').Value__c);
            }
        }
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req3.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req3);
        
        // Return the continuation   
        return con;
    }

	public static Object processResponse( Object state) {
        List<String> labels = new list<String>();
        labels.add('continuation-1');
        labels.add('continuation-2');
        labels.add('continuation-3');
        object result =  processResponse(labels,state);
        return result;
    }
    
    // Callback method
    @AuraEnabled(cacheable = true)
  public static Object processResponse(List<String> labels, Object state) {
        
        // Get the response by using the unique label
        
        ACETWSCalloutResult finalCallOutResult = new ACETWSCalloutResult();
        
        String processedData = '';
        
        HttpResponse response = Continuation.getResponse(labels[0]);
        
        // Set the result variable
        
        String result = response.getBody();                
        
        System.debug(LoggingLevel.INFO,'calloutResultContinution@@ ' + response);
        //US3595185
        EligibilityCalloutRequestWrapper eligibilityCalloutRequestWrapper = new EligibilityCalloutRequestWrapper();
        eligibilityCalloutRequestWrapper = (EligibilityCalloutRequestWrapper) state;

        System.debug('@@ eligibilityCalloutRequestWrapper: ' + eligibilityCalloutRequestWrapper);

        Map<String, Object> errorlogMap = new Map<String, Object>();

        EligibilityErrorLog firstCallLog = new EligibilityErrorLog();
        firstCallLog.applicationFlow = 'Current Policy Callout';
        firstCallLog.requestBody = eligibilityCalloutRequestWrapper.firstCallRequest;
        firstCallLog.endPoint = eligibilityCalloutRequestWrapper.endPoint;
        firstCallLog.responseStatus = response.getStatus();
        firstCallLog.responseBody = response.getBody();
        firstCallLog.statusCode = response.getStatusCode();
        if(firstCallLog.statusCode != 200){
            errorlogMap.put('log1',firstCallLog);
        }

        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
        
        //1st callout reponse ends
        
        //2 starts
        
        // Get the response by using the unique label
        
        HttpResponse response2 = Continuation.getResponse(labels[1]);
        
        // Set the result variable
        
        String result2 = response2.getBody();
        
        System.debug(LoggingLevel.INFO,'calloutResultContinution2@@ ' + response2);
        
        //US3595185
        EligibilityErrorLog secondCallLog = new EligibilityErrorLog();
        secondCallLog.applicationFlow = 'Future Policy Callout';
        secondCallLog.requestBody = eligibilityCalloutRequestWrapper.secondCallRequest;
        secondCallLog.endPoint = eligibilityCalloutRequestWrapper.endPoint;
        secondCallLog.responseStatus = response2.getStatus();
        secondCallLog.responseBody = response2.getBody();
        secondCallLog.statusCode = response2.getStatusCode();
        if(secondCallLog.statusCode != 200){
            errorlogMap.put('log2',secondCallLog);
        }

        ACETWSCalloutResult calloutResult2 = SAEGetMemberProviderWebService.processResponse(response2);
        
        //2nd callout reponse ends
        
        
        
        //call third endpoint
        
        //3 starts
        
        // Get the response by using the unique label
        
        HttpResponse response3 = Continuation.getResponse(labels[2]);
        
        // Set the result variable
        
        String result3 = response3.getBody();

        System.debug(LoggingLevel.INFO,'calloutResultContinution3@@ ' + response3);
        
        //US3595185
        EligibilityErrorLog thirdCallLog = new EligibilityErrorLog();
        thirdCallLog.applicationFlow = 'Past Policy Callout';
        thirdCallLog.requestBody = eligibilityCalloutRequestWrapper.thirdCallRequest;
        thirdCallLog.endPoint = eligibilityCalloutRequestWrapper.endPoint;
        thirdCallLog.responseStatus = response3.getStatus();
        thirdCallLog.responseBody = response3.getBody();
        thirdCallLog.statusCode = response3.getStatusCode();
        if(thirdCallLog.statusCode != 200){
            errorlogMap.put('log3',thirdCallLog);
        }

        ACETWSCalloutResult calloutResult3 = SAEGetMemberProviderWebService.processResponse(response3);
        
        //3rd callout reponse ends                
        
        System.debug(LoggingLevel.INFO,'calloutResultContinution@@ ' + calloutResult);
        
        System.debug(LoggingLevel.INFO,'calloutResultContinution2@@ ' + calloutResult2);
        
        System.debug(LoggingLevel.INFO,'calloutResultContinution3@@ ' + calloutResult3);
        
        SAEMemberProviderSearchCoveragesResult finalReturnResponse = new SAEMemberProviderSearchCoveragesResult();
        List<SAEMemberProviderSearchCoveragesResult.CoverageLine> coverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();

        // US3268922 Member Snapshot Enhancement: Policies Card - All Toggle Button - Sarma - 15/02/2021
        Boolean isFirstCallFailed = false;


        if (calloutResult.Success != null && calloutResult.Success) {
            
            SAEMemberProviderSearchCoveragesResult returnReponse = (SAEMemberProviderSearchCoveragesResult) calloutResult.Response;
            finalReturnResponse = returnReponse;
            if (returnReponse.CoverageLines.size() > 0) {

                coverageLines.addAll(returnReponse.CoverageLines);
                
            }
            
        } else if(!calloutResult.Success){
            isFirstCallFailed = true;
        }
        
        if (calloutResult2.Success != null && calloutResult2.Success) {
            
            SAEMemberProviderSearchCoveragesResult returnReponse = (SAEMemberProviderSearchCoveragesResult) calloutResult2.Response;
            finalReturnResponse = returnReponse;
            if (returnReponse.CoverageLines.size() > 0) {
                
                coverageLines.addAll(returnReponse.CoverageLines);
                
            }
            
        }
        
        if (calloutResult3.Success != null && calloutResult3.Success) {
            
            SAEMemberProviderSearchCoveragesResult returnReponse = (SAEMemberProviderSearchCoveragesResult) calloutResult3.Response;
            finalReturnResponse = returnReponse;
            // US3268922 Member Snapshot Enhancement: Policies Card - All Toggle Button - Sarma - 15/02/2021
            // if (!(calloutResult.Success != null && calloutResult.Success && calloutResult2.Success != null && calloutResult2.Success)) {
                
                if (returnReponse.CoverageLines.size() > 0) {
                    
                    coverageLines.addAll(returnReponse.CoverageLines);
                    System.debug('@@ coverageLines of Callout 3: ' + returnReponse.CoverageLines);
                    
                }
                
            // }
            
        }
        // US3268922 Member Snapshot Enhancement: Policies Card - All Toggle Button - Sarma - 15/02/2021
        if(isFirstCallFailed){
            
            eligibilityCalloutRequestWrapper.memberDetailsObject.serviceStart = '';
            eligibilityCalloutRequestWrapper.memberDetailsObject.serviceEnd = '';
            
            ACETWSCalloutResult failSafeCalloutResult = (ACETWSCalloutResult) fourthCallout(eligibilityCalloutRequestWrapper.memberDetailsObject,eligibilityCalloutRequestWrapper.providerDetailsObject);
            
            
            if (failSafeCalloutResult.Success != null && failSafeCalloutResult.Success) {
            
                SAEMemberProviderSearchCoveragesResult returnReponse = (SAEMemberProviderSearchCoveragesResult) failSafeCalloutResult.Response;
                finalReturnResponse = returnReponse;
                if (returnReponse.CoverageLines.size() > 0) {
                    List<SAEMemberProviderSearchCoveragesResult.CoverageLine> coverageLinesTemp = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
                    coverageLinesTemp.addAll(coverageLines);
                    coverageLines.clear();

                    coverageLines.addAll(returnReponse.CoverageLines);
                    coverageLines.addAll(coverageLinesTemp);
                    System.debug('@@ coverageLines of Callout 4: ' + returnReponse.CoverageLines);
                }
                List<SAEMemberProviderSearchCoveragesResult.CoverageLine> filteredCoverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
    
                filteredCoverageLines = processCoverageLines(coverageLines,eligibilityCalloutRequestWrapper.memberDetailsObject.memberId);
                
                finalReturnResponse.CoverageLines = filteredCoverageLines;
                finalCallOutResult.Response = finalReturnResponse;
                finalCallOutResult.statusCode = 200;
            
            } else if(coverageLines.size() > 0){
                List<SAEMemberProviderSearchCoveragesResult.CoverageLine> filteredCoverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
    
                filteredCoverageLines = processCoverageLines(coverageLines,eligibilityCalloutRequestWrapper.memberDetailsObject.memberId);
                
                finalReturnResponse.CoverageLines = filteredCoverageLines;
                finalCallOutResult.Response = finalReturnResponse;
                finalCallOutResult.statusCode = 200;
            } else {
                finalCallOutResult.Message = failSafeCalloutResult.Message;
                finalCallOutResult.statusCode = failSafeCalloutResult.statusCode;
            }

            SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
            resultwrap = (SAEMemberProviderSearchCoveragesResult)finalCallOutResult.Response;
            
            SearchResultWrapper dataWrap = new SearchResultWrapper();
            dataWrap.resultWrapper = resultwrap;
            dataWrap.message = finalCallOutResult.Message;
            dataWrap.statusCode = finalCallOutResult.statusCode;
            dataWrap.hasAccess = SAEMemberProviderDetail.getHasUHGAccess();
            processedData = JSON.serialize(dataWrap);
            //US3595185
            if(Label.ACET_IsErrorLogEnabledForEligibilityinSS.equals('true')){
                createLogsFromMap(errorlogMap);
            }
            return processedData;

        }
        // US3268922 Ends

        //US3595185
        if(Label.ACET_IsErrorLogEnabledForEligibilityinSS.equals('true')){
            createLogsFromMap(errorlogMap);
        }


        System.debug('@@ coverageLines: ' + coverageLines);

        List<SAEMemberProviderSearchCoveragesResult.CoverageLine> filteredCoverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
      
        filteredCoverageLines = processCoverageLines(coverageLines,eligibilityCalloutRequestWrapper.memberDetailsObject.memberId);
        System.debug('@@ filteredCoverageLines: ' + filteredCoverageLines);

        //SAEMemberProviderSearchCoveragesResult finalReturnResponse = new SAEMemberProviderSearchCoveragesResult();
        finalReturnResponse.CoverageLines = filteredCoverageLines;
        finalCallOutResult.Response = finalReturnResponse;
        finalCallOutResult.statusCode = 200;
        // write code if all services are failed
        
        if(!calloutResult.Success && !calloutResult2.Success && !calloutResult3.Success) {
            finalCallOutResult.Message = calloutResult3.Message;
            finalCallOutResult.statusCode = calloutResult3.statusCode;
        }
        
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        resultwrap = (SAEMemberProviderSearchCoveragesResult)finalCallOutResult.Response;
        
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = finalCallOutResult.Message;
        dataWrap.statusCode = finalCallOutResult.statusCode;
        dataWrap.hasAccess = SAEMemberProviderDetail.getHasUHGAccess();
        processedData = JSON.serialize(dataWrap);
        //new                        
        return processedData;
    }

    // US3268922	Member Snapshot Enhancement: Policies Card - All Toggle Button - Sarma - 15/02/2021    
    private static List<SAEMemberProviderSearchCoveragesResult.CoverageLine> processCoverageLines(List<SAEMemberProviderSearchCoveragesResult.CoverageLine> coverageLines , String memberId){
        List<SAEMemberProviderSearchCoveragesResult.CoverageLine> filteredCoverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
        Set<String> checkDuplicate = new Set<String>();
        Boolean isHighlightedPolicySet = false;
        for (SAEMemberProviderSearchCoveragesResult.CoverageLine cl : coverageLines) {
            //DE403793 Sandeep Dharwar
            String unqiueCoverageKey = cl.patientInfo.MemberId+ cl.GroupNumber + cl.CoverageType + cl.EffectiveDate + cl.EndDate;
            System.debug('###unqiueCoverageKey: '+unqiueCoverageKey);
            if (checkDuplicate.contains(unqiueCoverageKey)) {
                continue;
            }
            checkDuplicate.add(unqiueCoverageKey);
            if (cl.highlightedPolicy != null && cl.highlightedPolicy && !isHighlightedPolicySet) {
                cl.highlightedPolicy = true;
                isHighlightedPolicySet = true;
            } else {
                cl.highlightedPolicy = false;
            }
            filteredCoverageLines.add(cl);
        }
        System.debug('@@ coverageLines.size: ' + coverageLines.size());
        System.debug('@@ filteredCoverageLines.size: ' + filteredCoverageLines.size());
        List<SAEMemberProviderSearchCoveragesResult.CoverageLine> activeCoverages = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
        List<SAEMemberProviderSearchCoveragesResult.CoverageLine> pastCoverages = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
        List<SAEMemberProviderSearchCoveragesResult.CoverageLine> futureCoverages = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
        for (SAEMemberProviderSearchCoveragesResult.CoverageLine cl : filteredCoverageLines) {
            if(cl.planStatus == 'future'){
                futureCoverages.add(cl);
            }else if(cl.planStatus == 'false'){
                pastCoverages.add(cl);
            }else if(cl.planStatus == 'true' && (cl.nonMedicalPolicyBoolean || !cl.nonMedicalPolicyBoolean)){
                activeCoverages.add(cl);
            }
        }
        
        List<SAEMemberProviderSearchCoveragesResult.CoverageLine> finalCoverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
        if(filteredCoverageLines.size() > 0){
            if(activeCoverages.size() > 0){
                finalCoverageLines.addAll(activeCoverages);
            }
            if(pastCoverages.size() > 0){
                finalCoverageLines.addAll(pastCoverages);
            }
            if(futureCoverages.size() > 0){
                finalCoverageLines.addAll(futureCoverages);
            }
            filteredCoverageLines = new List<SAEMemberProviderSearchCoveragesResult.CoverageLine>();
            filteredCoverageLines = finalCoverageLines;
        }
        
        // moving highlighted to first place
        Integer highlightedPolicyIndex;
        for (SAEMemberProviderSearchCoveragesResult.CoverageLine cl : filteredCoverageLines) {
            if (highlightedPolicyIndex == null) {
                highlightedPolicyIndex = 0;
            } else {
                highlightedPolicyIndex++;
            }
            if (cl.highlightedPolicy) {
                break;
            }
        }
        if (highlightedPolicyIndex != null) {
            if (filteredCoverageLines.size() > 1) {
                SAEMemberProviderSearchCoveragesResult.CoverageLine temp1 = filteredCoverageLines[0];
                SAEMemberProviderSearchCoveragesResult.CoverageLine temp2 = filteredCoverageLines[highlightedPolicyIndex];
                filteredCoverageLines[0] = temp2;
                filteredCoverageLines[highlightedPolicyIndex] = temp1;
            }
            
        }
        
        if (!isHighlightedPolicySet && filteredCoverageLines.size() > 0) {
            filteredCoverageLines[0].highlightedPolicy = true;
        }

        if(filteredCoverageLines[0].highlightedPolicy && filteredCoverageLines[0].patientInfo.MemberId != memberId){
            if(filteredCoverageLines.size() > 1){
                if(filteredCoverageLines[1].patientInfo.MemberId == memberId){
                    SAEMemberProviderSearchCoveragesResult.CoverageLine temp1 = filteredCoverageLines[0];
                    filteredCoverageLines[0] = filteredCoverageLines[1];
                    filteredCoverageLines[1] = temp1;
                    filteredCoverageLines[0].highlightedPolicy = true;
                    filteredCoverageLines[1].highlightedPolicy = false;
                }
            }
        }

        return filteredCoverageLines;

    }
    
    
    public static String formRequestParameters(String memberId, String memberDOB, String memberFN,
                                               String memberLN, String memberGrpN, String searchOption,
                                               String strProviderLastName, String dateStr, String strProviderNameID,
                                               String serviceStart, String serviceEnd, String strTaxIdNumber, String payerID,
                                               String providerfirstName, String providerNPI,boolean fourthCalloutFlag) {
                                                   String resultQuery = '?';
                                                   resultQuery += 'searchOption=' + searchOption + '&payerID=' + payerID;
                                                   resultQuery += '&lastName=' + EncodingUtil.urlEncode(memberLN, 'UTF-8');
                                                   resultQuery += '&firstName=' + EncodingUtil.urlEncode(memberFN, 'UTF-8');
                                                   resultQuery += '&providerLastName=' + EncodingUtil.urlEncode(strProviderLastName, 'UTF-8');
                                                   resultQuery += '&providerFirstName=' + EncodingUtil.urlEncode(providerfirstName, 'UTF-8');                                               
                                                   resultQuery += '&dateOfBirth=' + dateStr;
                                                   resultQuery += '&groupNumber=' + memberGrpN;
                                                   //USS2221006 - uncommenetd
                                                   if (searchOption.contains('MemberID') || fourthCalloutFlag) {
                                                       resultQuery += '&memberId=' + memberId;
                                                   }
                                                   resultQuery += '&serviceStart=' + serviceStart;
                                                   resultQuery += '&serviceEnd=' + serviceEnd;
                                                   resultQuery += '&taxIdNumber=' + strTaxIdNumber;
                                                   resultQuery += '&providerNameID=' + strProviderNameID;
                                                   resultQuery += '&npi=' + providerNPI;                                       
                                                   return resultQuery;
                                               }
    
    public static String formRequestParameters(String memberId, String memberDOB, String memberFN,
                                               String memberLN, String memberGrpN, String searchOption,
                                               String strProviderLastName, String dateStr, String strProviderNameID,
                                               String serviceStart, String serviceEnd, String strTaxIdNumber, String payerID) {
                                                   String resultQuery = '?';
                                                   resultQuery += 'searchOption=' + searchOption + '&payerID=' + payerID;
                                                   resultQuery += '&lastName=' + EncodingUtil.urlEncode(memberLN, 'UTF-8');
                                                   resultQuery += '&firstName=' + EncodingUtil.urlEncode(memberFN, 'UTF-8');
                                                   resultQuery += '&providerLastName=' + strProviderLastName;
                                                   resultQuery += '&providerFirstName=' + '';
                                                   resultQuery += '&dateOfBirth=' + dateStr;
                                                   resultQuery += '&groupNumber=' + memberGrpN;
                                                   //USS2221006 - uncommenetd
                                                   if (searchOption.contains('MemberID')) {
                                                       resultQuery += '&memberId=' + memberId;
                                                   }
                                                   resultQuery += '&serviceStart=' + serviceStart;
                                                   resultQuery += '&serviceEnd=' + serviceEnd;
                                                   resultQuery += '&taxIdNumber=' + strTaxIdNumber;
                                                   resultQuery += '&providerNameID=' + strProviderNameID;                                  
                                                   return resultQuery;
                                               }
    
    @testVisible // Thanish - 8th October 2019
    private string formatDate(String dateStr){
        List<String> dateArr = new List<String>();
        if(String.isNotBlank(dateStr)){
            dateArr = dateStr.split('-');
        }
        String returnStr;
        if(dateArr != null && dateArr.size() > 0){
            returnStr = dateArr[1]+'-'+dateArr[2]+'-'+dateArr[0];
        }

        return returnStr;

    }

/**
@Desc: US1761826 - UHC/Optum Exclusion UI
@Date: 18-07-2019
@Dev: Malinda
**/

    @AuraEnabled
    public static List<UHG_Restricted_Plans__mdt> getOptumExlusions() {
        List<UHG_Restricted_Plans__mdt> mapOptumExlusions = new List<UHG_Restricted_Plans__mdt>();
        try {
            mapOptumExlusions = [SELECT DeveloperName,MasterLabel FROM UHG_Restricted_Plans__mdt];

        } catch(Exception e) {
          
        }
        return mapOptumExlusions;
    }
    
    @AuraEnabled
    public static Boolean getMockStatus() {
        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        return isStaticResponseChecked;
    }

    @AuraEnabled
    public static Object getElibilityMockData(MemberDetails memberDetails, ACET_ProviderSearchCtrl.ProviderDetails providerDetails) {
        System.debug('memberDetails@@ ' + memberDetails);
        String processedData = '';
        
        //US3076045 - Avish
        Map < String, String > requestParamsMap = new Map < String, String > ();
        
        requestParamsMap = getRequestParamMap(providerDetails, memberDetails); 
   
        memberDetails.memberDOB = SAEUtils.formatDateRequest(memberDetails.memberDOB);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;   
        if (!Test.isRunningTest()){
        HttpResponse response = wsCallOutFW.getResponse();
        
        //US3076045 - Ends
        
        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        resultwrap= (SAEMemberProviderSearchCoveragesResult)calloutResult.Response;
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = calloutResult.Message;
        dataWrap.statusCode = calloutResult.statusCode;
        dataWrap.hasAccess = SAEMemberProviderDetail.getHasUHGAccess();
        processedData = JSON.serialize(dataWrap);
        }
        return processedData;
    }
    
    @AuraEnabled
    public static Object getMockData(String transactionId, String memberId, String memberDOB, String memberFN, String memberLN, String memberGrpN, String searchOption, String payerID, ACET_ProviderSearchCtrl.ProviderDetails providerDetails) {
        String processedData = '';
        String responseStr = '';
        HttpResponse response;
        String searchparameter='';
        switch on searchOption {
            when 'MemberIDNameGroupNumberDateOfBirth' {
                searchparameter=  memberId+'_'+memberFN+'_'+memberLN+'_'+memberGrpN+'_'+memberDOB; 
                
            }
            when 'MemberIDNameDateOfBirth' {
                searchparameter=  memberId+'_'+memberFN+'_'+memberLN+'_'+memberDOB; 
                
            }
            when 'MemberIDName'{
                searchparameter=  memberId+'_'+memberFN+'_'+memberLN; 
            }
            when 'MemberIDLastNameDateOfBirth' {
                searchparameter=  memberId+'_'+memberLN+'_'+memberDOB; 
            }
            when 'MemberIDFirstNameDateOfBirth'{
                searchparameter=  memberId+'_'+memberFN+'_'+memberDOB; 
            }
            when 'NameDateOfBirth' {
                searchparameter=  memberFN+'_'+memberLN+'_'+memberDOB; 
            }
            when 'MemberIDDateOfBirth'{
                searchparameter=  memberId+'_'+memberDOB; 
            }
            when else {
               
            }
        }
        if(String.isNotBlank(searchparameter)) {
           
            response = SAEUtils.getResponse(searchparameter);
        }
        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        resultwrap= (SAEMemberProviderSearchCoveragesResult)calloutResult.Response;
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = calloutResult.Message;
        dataWrap.statusCode = calloutResult.statusCode;
        dataWrap.hasAccess = SAEMemberProviderDetail.getHasUHGAccess();
        processedData = JSON.serialize(dataWrap);
        return processedData;
    }

    //US1970508 - Ravindra - start
    @AuraEnabled
    public static String postCaseWrapper(String strWrapper) {
        try{

            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper)JSON.deserialize(strWrapper, SAETTSCaseWrapper.class);

            // Load relevent 'SAE Provider' record type
            RecordType recordType = [ SELECT Id, Name FROM RecordType WHERE sObjectType='case' AND name = 'SAE Provider' ];

            Case caseObj = new Case();
             // Case
            caseObj.Interaction__c = caseWrapper.Interaction;
            String strCaseStatus = 'Open';
            if(caseWrapper.AddInfoOrginType.equals('Issue Resolved')){
                strCaseStatus = 'Close';
            }
            caseObj.Status = strCaseStatus;
            caseObj.RecordTypeId = recordType.Id;
            if(caseWrapper.noProviderToSearch) {
               
                if(caseWrapper.mnf != 'mnf') {
                   
                    //Member standalone
                    // Originator
                    caseObj.ContactId = caseWrapper.ContactId; //
                    caseObj.Originator_name__c = caseWrapper.OriginatorName;
                    caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
                    // caseObj.Originator_Type__c = caseWrapper.OriginatorType; // Since this is formula field we don't want to manually assign values
                    caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
                    caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
                    caseObj.Caller__c = caseWrapper.OriginatorContactName;

                    // Subject
                    //caseObj.XrefID__c = caseWrapper.xRefId; //;
                    caseObj.Subject_Name__c = caseWrapper.SubjectName;
                    caseObj.Subject_Type__c = caseWrapper.SubjectType;
                    caseObj.DOB__c = caseWrapper.SubjectDOB;
                    caseObj.ID__c = caseWrapper.SubjectId; //
                    caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;

                    // Group/Family ID
                    caseObj.TaxID__c = caseWrapper.TaxId; //
                } else {
                    //Member Not Found standalone
                   
                }
                /*if(caseWrapper.xRefId != null && caseWrapper.xRefId != '') {

                caseObj.XrefID__c = caseWrapper.xRefId; //;
                }*/

            } else if(caseWrapper.providerNotFound) {
                //Provider not found
                // Originator
                caseObj.ContactId = caseWrapper.ContactId; //
                caseObj.Originator_name__c = caseWrapper.OriginatorName;
                caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
                // caseObj.Originator_Type__c = caseWrapper.OriginatorType; // Since this is formula field we don't want to manually assign values
                caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
                caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
                caseObj.Caller__c = caseWrapper.OriginatorContactName;

                // Subject
                //caseObj.XrefID__c = caseWrapper.xRefId; //;
                caseObj.Subject_Name__c = caseWrapper.SubjectName;
                caseObj.Subject_Type__c = caseWrapper.SubjectType;
                caseObj.DOB__c = caseWrapper.SubjectDOB;
                caseObj.ID__c = caseWrapper.SubjectId; //
                caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;

                // Group/Family ID
                caseObj.TaxID__c = caseWrapper.TaxId; //
            } else if(caseWrapper.isOtherSearch) {

            } else {
                // Originator
                caseObj.ContactId = caseWrapper.ContactId; //
                caseObj.Originator_name__c = caseWrapper.OriginatorName;
                caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
                // caseObj.Originator_Type__c = caseWrapper.OriginatorType; // Since this is formula field we don't want to manually assign values
                caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
                caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
                caseObj.Caller__c = caseWrapper.OriginatorContactName;

                // Subject
                //caseObj.XrefID__c = caseWrapper.xRefId; //;
                caseObj.Subject_Name__c = caseWrapper.SubjectName;
                caseObj.Subject_Type__c = caseWrapper.SubjectType;
                caseObj.DOB__c = caseWrapper.SubjectDOB;
                caseObj.ID__c = caseWrapper.SubjectId; //
                caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;

                // Group/Family ID
                caseObj.TaxID__c = caseWrapper.TaxId; //
            }

            // Subject
            caseObj.Subject_Name__c = caseWrapper.SubjectName;
            caseObj.Subject_Type__c = caseWrapper.SubjectType;
            caseObj.DOB__c = caseWrapper.SubjectDOB;
            caseObj.ID__c = caseWrapper.SubjectId;
            caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;

            // Additional Information
            caseObj.Topic__c = caseWrapper.AddInfoTopic;
            caseObj.Original_Type__c = caseWrapper.AddInfoOrginType;
            caseObj.Original_Subtype__c = caseWrapper.AddInfoOrginSubType;

            INSERT caseObj;
            return caseObj.Id;

        } catch(Exception e){
            
            throw new AuraHandledException(e.getMessage());
        }
    }
    //US1970508 - Ravindra - end

    //US1933887 - UHG Access
    // Sanka Dharmasena - 30/07/2019
    @TestVisible
    private static Boolean getHasUHGAccess()
    {
        List<User> CurrentUser = [SELECT ID,UHG_Access__c FROM User WHERE Id = :USerInfo.getUserId()];
        if(CurrentUser.get(0).UHG_Access__c.equals('Yes')){
            return true;
        }
        else{
            return false;
        }
    }
    
    @AuraEnabled(cacheable=true) 
    // String payerID - US1944108
    public static SubjectCardSearchResultWrapper subjectCardPopulation(MemberDetails memberDetails, ACET_ProviderSearchCtrl.ProviderDetails providerDetails) {
        
        SAEProviderMemberSearchInteractionResult resultwrap = new SAEProviderMemberSearchInteractionResult();                 
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult CalloutResult = null;
        if(String.isNotBlank(memberDetails.memberId) && !String.isNotBlank(memberDetails.memberDOB) && !String.isNotBlank(memberDetails.firstName) && !String.isNotBlank(memberDetails.lastName) &&
           !String.isNotBlank(memberDetails.groupNumber)){
               
               CalloutResult = findIndividualWS.findIndividual(memberDetails.memberId);
               
               if (CalloutResult.Success != null && CalloutResult.Success){
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                  
               }
           }else{
               //payerID - US1944108
               CalloutResult = MemberProviderService.getMemberDetails(memberDetails,providerDetails);
               if (CalloutResult.Success != null && CalloutResult.Success){   
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   
               }
           }
        
        SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
        
    }
	
	@AuraEnabled(cacheable=true) 
    // String payerID - US1944108
    public static SubjectCardSearchResultWrapper findMembers(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID,
                                                    String providerFN, String providerLN, String providerNPI, String providerFlow){
    
        SAEProviderMemberSearchInteractionResult resultwrap = new SAEProviderMemberSearchInteractionResult();                 
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult CalloutResult = null;
        if(String.isNotBlank(memberId) && !String.isNotBlank(memberDOB) && !String.isNotBlank(firstName) && !String.isNotBlank(lastName) &&
           !String.isNotBlank(groupNumber)){
              
               CalloutResult = findIndividualWS.findIndividual(memberId);
               
               if (CalloutResult.Success != null && CalloutResult.Success){
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                  
               }
           }else{
               //payerID - US1944108
               CalloutResult = MemberProviderService.getMemberWS(memberId,memberDOB,firstName,lastName,groupNumber,searchOption, payerID, providerLN, providerFN, providerNPI, providerFlow);
               if (CalloutResult.Success != null && CalloutResult.Success){   
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   
               }
           }
        
        SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
        
    }
   
    /* @AuraEnabled
    public static List<ACET_ORSWebservice.selectIssueWrapper> ORSSlectIssue(string lastName,string alternateId,string state,string callerFirstName,string callerLastName,Boolean isProvider,String providerTaxId,Boolean isToggleOnOff){
        return ACET_ORSWebservice.selectIssues(lastName,alternateId,state,callerFirstName,callerLastName,isProvider,providerTaxId,isToggleOnOff);
    } */
    
     // US2804912 - Avish
    @AuraEnabled(cacheable = true)
    public static Object fourthCallout(MemberDetails memberDetails, ACET_ProviderSearchCtrl.ProviderDetails providerDetails) {
        system.debug(LoggingLevel.INFO,'memberDetails@@ ' + memberDetails);
        String processedData = '';
        //US3076045 - Avish
        Map < String, String > requestParamsMap = new Map < String, String > ();
        
        requestParamsMap = getRequestParamMap(providerDetails, memberDetails); 
        
        memberDetails.memberDOB = SAEUtils.formatDateRequest(memberDetails.memberDOB);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;
		if (!Test.isRunningTest()) {   
        HttpResponse response = wsCallOutFW.getResponse();
        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
        HttpRequest request =  wsCallOutFW.getHttpRequest();
        //US3595185
        String calloutFlow = '';
        if(memberDetails.isFourthCallout){
            calloutFlow = 'LinkEligibility fifth Callout';
        } else {
            calloutFlow = 'LinkEligibility fail-Safe Callout';
        }
        if(Label.ACET_IsErrorLogEnabledForEligibilityinSS.equals('true') && response.getStatusCode() != 200){
            String endpointTemp = request.getEndpoint();
            List<String> endpointStringList = endpointTemp.split('\\?', 2);
            if(endpointStringList.size() > 0){
                endpointTemp = endpointStringList[0];
            }
            createAppErrorLog('ACET_Spire',calloutFlow, endpointTemp ,response.getStatus(),response.getStatusCode(), request.getEndpoint() ,response.getBody());
        }

        // reusing method during failsafe callout
        // US3268922 Member Snapshot Enhancement: Policies Card - All Toggle Button - Sarma - 15/02/2021 
        if(!memberDetails.isFourthCallout){
            return calloutResult;
        }
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        resultwrap = (SAEMemberProviderSearchCoveragesResult)calloutResult.Response;

        Boolean showRefershError = false;
        String endpointTemp = request.getEndpoint();
        List<String> endpointStringList = endpointTemp.split('\\?', 2);
        if(endpointStringList.size() > 0){
            endpointTemp = endpointStringList[0];
        }
        if(String.isNotBlank(memberDetails.sourceCode) && (memberDetails.sourceCode == 'CS' || memberDetails.sourceCode == 'CO') && response.getStatusCode() == 200 ) {
            showRefershError =  createAppLogFinaincalZero(resultwrap);
            switch on string.valueof(showRefershError){
                when 'true' {  createAppErrorLog('ACET_Spire',calloutFlow, endpointTemp ,response.getStatus(),response.getStatusCode(), request.getEndpoint() ,response.getBody());}
                when else {}
            }

        }
        
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = calloutResult.Message;
        dataWrap.statusCode = calloutResult.statusCode;
        dataWrap.hasAccess = SAEMemberProviderDetail.getHasUHGAccess();
        dataWrap.showRefershError = showRefershError;
        processedData = JSON.serialize(dataWrap);
        }
        //US3076045 - Ends
        return processedData;
    }

    public static Boolean createAppLogFinaincalZero(SAEMemberProviderSearchCoveragesResult resultwrap ){
        Boolean showRefershError = false;
        if(resultwrap != null && resultwrap.CoverageLines!= null &&  !resultwrap.CoverageLines.isEmpty()  && resultwrap.CoverageLines[0].financialWrapper != null){
            SAEMemberProviderSearchCoveragesResult.FinancialsWrapper fw = resultwrap.CoverageLines[0].financialWrapper;
            if(fw.inNetwork!= null && fw.onNetwork != null && fw.tierOne != null){
                 SAEMemberProviderSearchCoveragesResult.Financials inNetWork = fw.inNetwork;
                SAEMemberProviderSearchCoveragesResult.Financials outNetwork = fw.onNetwork;
                SAEMemberProviderSearchCoveragesResult.Financials tierOne = fw.tierOne;
                if(check(inNetwork.deductible) && check(inNetwork.dedSatisfied) && check(inNetwork.dedAmountRem) && check(inNetwork.deductibleFam) && check(inNetwork.dedSatisfiedFam) && check(inNetwork.dedAmountRemFam) &&
                   check(outNetwork.deductible) &&  check(outNetwork.dedSatisfied) &&  check(outNetwork.dedAmountRem) && check(outNetwork.deductibleFam) && check(outNetwork.dedSatisfiedFam) && check(outNetwork.dedAmountRemFam) &&
                   check(tierOne.deductible) &&  check(tierOne.dedSatisfied) && check(tierOne.dedAmountRem) && check(tierOne.deductibleFam) && check(tierOne.dedSatisfiedFam) &&  check(tierOne.dedAmountRemFam) &&
                   check(inNetwork.outOP) && check(inNetwork.outOPRemAmount) && check(inNetwork.outOPSatisfied) && check(inNetwork.outOPFam) && check(inNetwork.outOPRemAmountFam) &&  check(inNetwork.outOPSatisfiedFam) &&
                   check(outNetwork.outOP) && check(outNetwork.outOPRemAmount) &&  check(outNetwork.outOPSatisfied) && check(outNetwork.outOPFam) && check(outNetwork.outOPRemAmountFam) && check(outNetwork.outOPSatisfiedFam) &&
                   check(tierOne.outOP) && check(tierOne.outOPRemAmount) &&  check(tierOne.outOPSatisfied) &&  check(tierOne.outOPFam) && check(tierOne.outOPRemAmountFam) && check(tierOne.outOPSatisfiedFam) &&
                   check(inNetwork.OOP_Limit_2) &&  check(inNetwork.OOP_Limit_2_Satisfied) && check(inNetwork.OOP_Limit_2_Rem) && check(inNetwork.OOP_Limit_2_Family ) && check(inNetwork.OOP_Limit_2_Satisfied_Family) && check(inNetwork.OOP_Limit_2_Rem_Family) &&
                   check(outNetwork.OOP_Limit_2) &&  check(outNetwork.OOP_Limit_2_Satisfied) && check(outNetwork.OOP_Limit_2_Rem) && check(outNetwork.OOP_Limit_2_Family ) && check(outNetwork.OOP_Limit_2_Satisfied_Family) &&  check(outNetwork.OOP_Limit_2_Rem_Family) &&
                   check(tierOne.OOP_Limit_2) &&  check(tierOne.OOP_Limit_2_Satisfied) &&  check(tierOne.OOP_Limit_2_Rem) &&  check(tierOne.OOP_Limit_2_Family ) &&  check(tierOne.OOP_Limit_2_Satisfied_Family) &&  check(tierOne.OOP_Limit_2_Rem_Family) &&
                   check(inNetwork.CopayMax) &&  check(inNetwork.CopayMax_Satisfied) &&  check(inNetwork.CopayMax_Remaining) &&  check(inNetwork.CopayMax_Family) && check(inNetwork.CopayMax_Satisfied_Family) && check(inNetwork.CopayMax_Remaining_Family) &&
                   check(outNetwork.CopayMax) && check(outNetwork.CopayMax_Satisfied) && check(outNetwork.CopayMax_Remaining) && check(outNetwork.CopayMax_Family) &&  check(outNetwork.CopayMax_Satisfied_Family) &&  check(outNetwork.CopayMax_Remaining_Family) &&
                   check(tierOne.CopayMax) &&  check(tierOne.CopayMax_Satisfied) && check(tierOne.CopayMax_Remaining) && check(tierOne.CopayMax_Family) && check(tierOne.CopayMax_Satisfied_Family) &&  check(tierOne.CopayMax_Remaining_Family)){
                    showRefershError = true;
                    }
                }
            }
       return  showRefershError;
        }

    
    public static boolean check(Decimal d){
        if(d == null || d == 0 )  return true;
        else  return false;
    }

    //US2804912 - End
    
    //US2478836 - Member Not Found Plan Type Card Link to OneSource - Sravan
    @AuraEnabled
    public static string getOneSourceLink(){
        String orgName = ACETUtility.GetOrgName();
        String swivelSysName = SAEConstants.ONE_SOURCE_LINK;
        String link = ACETUtility.GetSwivelEndpointByOrgName(orgName,swivelSysName);
        return link;
    }

    //US3017101
    @AuraEnabled
    public static string getCSPProviderId(string providerId,string taxId, string addressId){
        string strCSPProviderValue = '';
        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        ACETWSCalloutResult calloutResult = providerContractService.getCAndSContracts(providerId, taxId, addressId, false);
        if(calloutResult.Success) {
            // cast callout result to c and s contract response
            ACET_CAndSContractsResponse contractResponse = (ACET_CAndSContractsResponse) calloutResult.Response;
            system.debug('### contractResponse==>:'+contractResponse);
            if(contractResponse != null && contractResponse.communityandstate != null){
                for(ACET_CAndSContractsResponse.Communityandstate communityAndState : contractResponse.communityandstate) {
                    if(string.isNotBlank(communityAndState.csp_pltfm_prov_id) ){
                        strCSPProviderValue =communityAndState.csp_pltfm_prov_id;
                        break;
                    }
                }

            }
        }
        return strCSPProviderValue;
    }
    //added for avoid block
    public static SubjectCardSearchResultWrapper subjectCardPopulation(String str1, String str2, String str3, String str4, String str5, String str6, String str7, String str8, String str9, String str10, String str11, String str12, String str13)
    {
        return (new SubjectCardSearchResultWrapper());
    }
    // US3595185
    @future
    private static void createAppErrorLog(string AppName, string servName, String endPoint, string respStatus, Integer respStatuscode, string reqBody,string resBody){

        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog(AppName, servName, endPoint, respStatus, respStatuscode);
        List<Attachment> AppErrorLogAtts = new List<Attachment>();
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'EligibilityRequest' , reqBody));
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'EligibilityResponse' , resBody));

        Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
        if (ErrorLogSR.isSuccess()) {
            Id ErrorLogId = ErrorLogSR.getId();
            for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                AppErrorLogAtt.ParentId = ErrorLogId;
            }
           Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
        }
    }
    private static void createLogsFromMap(Map<String,Object> errorMap){
        if(errorMap.containsKey('log1')){
            EligibilityErrorLog log = (EligibilityErrorLog) errorMap.get('log1');
            createAppErrorLog('ACET_Spire', log.applicationFlow, log.endPoint, log.responseStatus,log.statusCode,log.requestBody,log.responseBody);
        }
        if(errorMap.containsKey('log2')){
            EligibilityErrorLog log = (EligibilityErrorLog) errorMap.get('log2');
            createAppErrorLog('ACET_Spire', log.applicationFlow, log.endPoint, log.responseStatus,log.statusCode,log.requestBody,log.responseBody);
        }
        if(errorMap.containsKey('log3')){
            EligibilityErrorLog log = (EligibilityErrorLog) errorMap.get('log3');
            createAppErrorLog('ACET_Spire', log.applicationFlow,log.endPoint, log.responseStatus,log.statusCode,log.requestBody,log.responseBody);
        }
    }
    // US3595185 Ends
}