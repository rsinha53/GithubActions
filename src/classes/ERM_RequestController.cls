public  without sharing class ERM_RequestController {
    
    Public static string dualPlatform='Dual Platform';
    Public static string multiplepolicies= 'Add Multiple Policies to an Existing Broker Agency';
    Public static string reportGenerator = 'Report Generator';
    Public static string contentType = 'Content-Type';
    Public static string bearer = 'bearer ';
    Public static string useraccess='Update User Access to Existing Policies';
    Public static string changepolicy='Change Permissions to an Existing Policy';
	Public static string changeemppolicy='Change Permission to an Existing Employer Policy';
    Public static string errorMessage='Unable to add additional permissions at the User Level.Additional Permissions must be added at the Policy Level';
    Public static map<string,string>platformMap = new map<String,string>(); 
    Public static map<string,string>requestMap = new map<String,string>();
    Public static map<string,string>vendorMap = new Map<string,string>();
    Public static map<string,string>reprtmap = new Map<string,string>();
    Public static map<string,string>genderMap = new Map<string,string>();
    Public static map<string,string>relationshipMap = new Map<string,string>();
    Public static map<string,string>divaccMap = new Map<string,string>();
    Public static map<string,string>cptinrelationshipMap = new Map<string,string>();
    Public static map<string,string>martialStatusMap = new Map<string,string>();
    Public static map<string,string>retroExclusiveMap = new Map<string,string>();
    Public static map<string,string>qualifiingMap = new Map<string,string>();
    Public static map<string,string>terminationMap = new Map<string,string>();
    Public static map<string,string>reportMap = new Map<string,string>();
    Public static map<string,string>terminationLevelMap = new Map<string,string>();
    Public static map<string,string>departmentMap = new Map<string,string>();
    @AuraEnabled
      public static SubjectCardSearchResultWrapper getElibilityMockData(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID){
      SAEMemberProviderDetail.MemberDetails md = new SAEMemberProviderDetail.MemberDetails();
        md.memberId = memberId;
        md.memberDOB = memberDOB;
        md.firstName = firstName;
        md.lastName = lastName;
        md.searchOption = searchOption;
        md.payerID= payerID;
        md.isFourthCallout = false;
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails =new ACET_ProviderSearchCtrl.ProviderDetails ();
        providerDetails.isNoProviderToSearch =true;
        providerDetails.isProviderNotFound =true;
        providerDetails.isOther=true;
        Map < String, String > requestParamsMap = new Map < String, String > ();
        
        requestParamsMap = getRequestParamMap(providerDetails, md); 
        
        md.memberDOB = SAEUtils.formatDateRequest(md.memberDOB);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;        
        HttpResponse response = wsCallOutFW.getResponse();
        
        //US3076045 - Ends
        
        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
          SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = null;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
      }
    @AuraEnabled
    Public static SubjectCardSearchResultWrapper getMemberDetails(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID){
     SAEMemberProviderDetail.MemberDetails md = new SAEMemberProviderDetail.MemberDetails();
        md.memberId = memberId;
        md.memberDOB = memberDOB;
        md.firstName = firstName;
        md.lastName = lastName;
        md.searchOption = searchOption;
        md.payerID= payerID;
        md.isFourthCallout = false;
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails =new ACET_ProviderSearchCtrl.ProviderDetails ();
        providerDetails.isNoProviderToSearch =true;
        providerDetails.isProviderNotFound =true;
        providerDetails.isOther=true;
        SAEMemberProviderWS memberService = new SAEMemberProviderWS();
        ACETWSCalloutResult CalloutResult =    memberService.getMemberDetails(md,providerDetails);
        system.debug('>>>>>>>>>>>>'+CalloutResult);
        SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = (SAEProviderMemberSearchInteractionResult)CalloutResult.response;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
    }
    private static Map <String, String> getRequestParamMap(ACET_ProviderSearchCtrl.ProviderDetails providerDetails,SAEMemberProviderDetail.MemberDetails memberDetails){
        Map < String, String > requestParamsMap = new Map < String, String > ();
      system.debug('////////////'+providerDetails);        
        if(providerDetails == null|| providerDetails.isProviderNotFound || providerDetails.isNoProviderToSearch || providerDetails.isOther) {
            
            requestParamsMap.put('providerLastName', System.Label.SAEProviderLastName);
            requestParamsMap.put('providerFirstName', '');
            requestParamsMap.put('providerNameID', System.Label.SAEProviderNameID);
            requestParamsMap.put('taxIdNumber', System.Label.SAEProviderTaxIdNumber);
            
        } else {
            
            requestParamsMap.put('providerLastName',providerDetails.lastName);
            requestParamsMap.put('providerFirstName', providerDetails.firstName);
            requestParamsMap.put('providerNameID', providerDetails.providerId);
            requestParamsMap.put('taxIdNumber', providerDetails.taxId);
        }               
        
        requestParamsMap.put('searchOption', String.isNotBlank(memberDetails.searchOption) ? memberDetails.searchOption : '');
        if(!memberDetails.isFourthCallout){
            requestParamsMap.put('memberId', String.isNotBlank(memberDetails.memberId) ? memberDetails.memberId : '');
        }else{
            requestParamsMap.put('memberId','');
        }   
        
        requestParamsMap.put('firstName', String.isNotBlank(memberDetails.firstName) ? memberDetails.firstName : '');
        requestParamsMap.put('lastName', String.isNotBlank(memberDetails.lastName) ? memberDetails.lastName : '');
        requestParamsMap.put('dateOfBirth', String.isNotBlank(memberDetails.memberDOB) ? memberDetails.memberDOB : '');
        requestParamsMap.put('groupNumber',  '');
        requestParamsMap.put('payerID', String.isNotBlank(memberDetails.payerId) ? memberDetails.payerId : '');
        requestParamsMap.put('serviceStart',  '');
        requestParamsMap.put('serviceEnd',  '');     
        
        
        return requestParamsMap;
    }
    public static map<string,string> fetchuserid(set<id>enrolleIds){
        map<string,string> userids = new map<string,string>();
        for(ERM_EServices_Policy_User__c policy : [select id,policy__c from ERM_EServices_Policy_User__c
                                                   where policy__c in : enrolleIds ]){
            userids.put(policy.policy__c,policy.id);
        }
        return userids;
    }
    @AuraEnabled
    Public static string validateBeforeSimonRequest(string caseId){
        string returnMessage='';
        List<string>attarequesttypes = new List<string>();
        List<string>polrequesttypes = new List<string>();
        List<string>brokerAgencyreqTypes = new List<String>();
        List<string>enrolleereqTypes = new List<String>();
        attarequesttypes.add('CalPERS Electronic Fallout');
        attarequesttypes.add('Host System Error Reports');
        attarequesttypes.add('POEMM');
        attarequesttypes.add('TPA Reports');
        attarequesttypes.add(dualPlatform);
        attarequesttypes.add('Host System Error Reports (Multiple Policy Numbers)'); 
        attarequesttypes.add('TPA Reports (Multiple Policy Numbers)');
        
        polrequesttypes.add('Add a New User Profile Under Existing Broker Agency');
        polrequesttypes.add('Add Multiple Policies to an Existing Broker Agency');
        polrequesttypes.add('Add New Policy to an Existing Broker Agency Profile');
        polrequesttypes.add('Add/Update Multiple Policies to an Existing User Profile');
        polrequesttypes.add('Change Existing Broker Agency Reporting');
        polrequesttypes.add('Create new Broker Agency Profile');
        polrequesttypes.add('Inactivate an Existing Broker Agency Profile');
        polrequesttypes.add('Inactivate Multiple Policies Under Existing Broker Agency');
        polrequesttypes.add('Request Broker Client reports'); 
        polrequesttypes.add('Add a new user Profile under Existing Employer');
        polrequesttypes.add('Add New policy to an Existing Employer Profile/Create New GPS Employer Profile');
        brokerAgencyreqTypes.add(multiplepolicies);
        polrequesttypes.add('Change Existing Employer Reporting or Update Paper Invoice');
        polrequesttypes.add(changeemppolicy);
        polrequesttypes.add('Inactivate Existing Policy Under Employer');
        polrequesttypes.add('Request Employer Client Reports');
        brokerAgencyreqTypes.add('Add New Policy to an Existing Broker Agency Profile');
        brokerAgencyreqTypes.add(changepolicy);
        brokerAgencyreqTypes.add('Create new Broker Agency Profile');
        brokerAgencyreqTypes.add(useraccess);
        polrequesttypes.add('Update User Access to Existing Policies');
        enrolleereqTypes.add('COBRA Change');
        enrolleereqTypes.add('Correction to Previously Mailed/Faxed Document');
        enrolleereqTypes.add('Duplicate Member');
        enrolleereqTypes.add('Electronic Fallout');
        enrolleereqTypes.add('Member SSN Update');
        enrolleereqTypes.add('SHOP/Individual Exchange');
        List<Contentdocumentlink> docLinks = [select id from Contentdocumentlink where linkedentityid=:caseId];
        Stream_Request_Details__c details = [select id,Plat_form__c,Report_Dates_Requested__c,Report_Dates_Requested_1__c,Report_Dates_Requested_2__c,Communication_Center_Only__c,INactivate_the_user_profile_abo__c,All_users_have_same_permission_as_policy__c,Subscriber_CPTIN__c,Count_of_Reports_Requested__c,
                                             case__r.casenumber,Effective_Date__c,Estimated_Transactions__c,Case__c,RequestType__c,Report_Needed__c
                                             from Stream_Request_Details__c where case__c=: caseId];
        List<Enrolees__c> enrolleList = [select id,Request_Details__r.RequestType__c from Enrolees__c where Request_Details__c = :details.id and
                                         Request_Details__r.RequestType__c = 'Dual Platform' ];
        List<Enrolees__c> defaultenrolleList = [select id,Request_Details__r.RequestType__c from Enrolees__c where case__c = :details.case__c 
                                               ];
        
        List<Enrolees__c> polenrolleList = [select id,All_users_have_same_permission_as_policy__c,Request_Details__r.RequestType__c from Enrolees__c where Request_Details__c = :details.id 
                                            and recordtype.name='Policies' ];
        List<casecomment>commentList=[select id,parentid from casecomment where parentid=:caseId  and ispublished =false];
        boolean policyUser=false;
        
        set<id> enrolleIds = new set<id>();
        map<string,string> userids = new Map<string,string>();
        for(Enrolees__c enrollee :polenrolleList ){
            if(enrollee.All_users_have_same_permission_as_policy__c==false)
                enrolleIds.add(enrollee.id);
        }                 
        userids = fetchUserid(enrolleIds);
            policyUser = checkpolicyuser( details,enrolleIds,
                                           brokerAgencyreqTypes,userids);
        if(details.RequestType__c !='CPTIN' &&
           details.RequestType__c !=reportGenerator &&
           details.RequestType__c !='Reporting'&& details.Estimated_Transactions__c == null){
               returnMessage='error';
           }
        else if (attarequesttypes.contains(details.RequestType__c) && docLinks.size()<=0){
            returnMessage ='attacherror';
        }
        else if(enrolleereqTypes.contains(details.RequestType__c)
                &&docLinks.size()==0 && defaultenrolleList.size()==0 && commentList.size()==0){                   
                    returnMessage ='duperror';                                      
                }
         else if(details.Communication_Center_Only__c==false && polrequesttypes.contains(details.RequestType__c) 
                && polenrolleList.size()<1){
            returnMessage ='polerror';
        }
        
        else{
            returnMessage=validateSubmethod(details,enrolleList,policyUser,polenrolleList,commentList);
        }
        if(returnMessage ==''){
            Case updateCase =[select id,CaseNumber,status from case where id=:details.Case__c];
            
            returnMessage = updatecase.CaseNumber+';';
        }
        
        return returnMessage;
    }
    private static boolean checkpolicyuser(Stream_Request_Details__c details,set<id>enrolleIds,
                                           List<string>brokerAgencyreqTypes,map<string,string> userids){
        boolean policyUser=false;
        for(string s :enrolleIds ){
            if(!userids.containskey(s)&& brokerAgencyreqTypes.contains(details.RequestType__c)){
                policyUser = true;
            }
            
        }
        return policyUser;
    } 
    private static string validateinnerError(Stream_Request_Details__c	details){
        string returnMessage='';
         if(details.RequestType__c ==reportGenerator && details.Count_of_Reports_Requested__c == null){
            returnMessage='error';
        }
          else if(details.RequestType__c =='CPTIN' && details.Subscriber_CPTIN__c == null){
               returnMessage='error';
           }
        else if(details.RequestType__c =='Reporting' && details.Report_Needed__c == null){
            returnMessage='error';
        }
        return returnMessage;
    }
    private static string validateSubmethod(Stream_Request_Details__c details ,List<Enrolees__c>  enrolleList,
                                           boolean policyUser,List<Enrolees__c>  polenrolleList ,List<CaseComment>commentList){
        string returnmessage='';
        
         returnmessage  =      validateinnerError(details); 
                                               
    if(returnmessage == ''){                                     
        if (details.RequestType__c ==dualPlatform && enrolleList.size()<2){
            returnMessage='dualerror';
        }
        else if(details.RequestType__c =='W2 Report'&& details.Report_Dates_Requested__c== null&& 
                details.Report_Dates_Requested_1__c == null && details.Report_Dates_Requested_2__c == null	){
            returnMessage ='w2error';
        }
        else if(commentList.size()==0 && (details.RequestType__c =='Customer Profile Updates' || details.RequestType__c =='Research')){
        returnMessage ='commenterror';
        }
        else if(policyUser == true){
            returnMessage = 'brokerError';
        }
        else if(details.RequestType__c=='Update/Inactivate/Reactivate an Existing User Profile' && polenrolleList.size()<1 && 
                details.INactivate_the_user_profile_abo__c != 'INactivate the user profile'
               
               ){
            returnMessage = 'employeeError';
        } else{
            returnMessage=''; 
          }              
                                               }
        return returnmessage;
    }
    @AuraEnabled    
    Public static list<Enrolees__c> getEnrolleList(string caseId){
        
        List<Enrolees__c> enrolleList =[select id,First_Name__c,MiddleName__c,Last_Name__c,SSN__c,Date_of_Birth__c,Gender__c,Employee_ID__c,
                                        
                                        Relationship__c,CorrectedUpdatedSSN__c,Address__c,City__c,State__c,Zip__c,HomePhone__c,Email__c,
                                        
                                        PrimaryCarePhysician__c,PrimaryCareDentist__c,AnnualSalary__c,CoordinationofBenefitsBegin_Date__c,
                                        
                                        CoordinationofBenefitsEnd_Date__c,MedicarePartAStartDate__c,MedicarePartAEndDate__c,MedicarePartBStartDate__c,
                                        
                                        MedicarePartBEndDate__c,MedicarePartDStartDate__c,MedicarePartDEndDate__c,PriorCoverageBeginDate__c,PriorCoverageEndDate__c,
                                        
                                        ExistingPatient__c,DeliveryPreference__c from Enrolees__c
                                        
                                        where Case__c=: caseId];
        
        return enrolleList;        
    }
    
    @AuraEnabled
    Public static string updateEnrolleData(string enrolleId,Enrolees__c updateData,string caseId){
        Enrolees__c updatenerollee = new Enrolees__c();
        updatenerollee = updateData;
        if(updatenerollee.id  == null){
            updatenerollee.Case__c = caseId;
            insert updatenerollee;            
        }else{
            update updateData;
        }
        return updatenerollee.id;
    }
    
    @AuraEnabled
    Public static void deleteEnrolleData(Enrolees__c deleteData){      
        if(deleteData.Id != null)
            delete  deleteData;
    }
    
    @AuraEnabled
    Public static requestDetails getrequestdata(string caseId){
        string requestType='';
        Stream_Request_Details__c details = [select id,Plat_form__c,Case__c,RequestType__c from Stream_Request_Details__c where case__c=: caseId];
        requestType =details.RequestType__c;
        requestDetails req = new requestDetails();
        req.platform = details.Plat_form__c;
        req.reqType = details.RequestType__c;
        req.reqid =details.id;
        return req;
    }
    
    @AuraEnabled
    public static SAEHouseHoldController.SearchResultWrapper getHouseHoldData(String transactionId){
        SAEHouseHoldController.SearchResultWrapper response = (SAEHouseHoldController.SearchResultWrapper)SAEHouseHoldController.SearchResultWrapper.getHouseHoldMembers(transactionId);       
        return response;
    }
    
    @testVisible @AuraEnabled
    public static List<UHG_Restricted_Plans__mdt> getOptumExlusions() {
        List<UHG_Restricted_Plans__mdt> mapOptumExlusions = new List<UHG_Restricted_Plans__mdt>();
        try {
            mapOptumExlusions = [SELECT DeveloperName,MasterLabel FROM UHG_Restricted_Plans__mdt];
            
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,e.getMessage());
        }
        return mapOptumExlusions;
    }
    
    
    @AuraEnabled
    Public static SubjectCardSearchResultWrapper searchMembers(String memberDetails){
        SAEProviderSearch.MemberDetails md = (SAEProviderSearch.MemberDetails) System.JSON.deserialize(memberDetails, SAEProviderSearch.MemberDetails.class);
        SAEProviderMemberSearchInteractionResult resultwrap = new SAEProviderMemberSearchInteractionResult();                 
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult CalloutResult = null;
        if(String.isNotBlank(md.memberId) && !String.isNotBlank(md.memberDOB) && !String.isNotBlank(md.firstName) && !String.isNotBlank(md.lastName) &&
           !String.isNotBlank(md.groupNumber)){
               CalloutResult = findIndividualWS.findIndividual(md.memberId);
               if (CalloutResult.Success != null && CalloutResult.Success){
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   System.debug('resultwrap ' + resultwrap);
               }
           }else{
               CalloutResult = MemberProviderService.getMemberWS(md.memberId,md.memberDOB,md.firstName,md.lastName,md.groupNumber,md.searchOption,md.payerID,md.providerLastName,md.providerFirstName,md.npi,md.providerFlow);
               if (CalloutResult.Success){   
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
               } 
           }
        SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
    }
    
    
   public class SubjectCardSearchResultWrapper{
        @AuraEnabled public SAEProviderMemberSearchInteractionResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }

     public class SearchResultWrapper{
        @AuraEnabled public SAEProviderMemberSearchInteractionResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    
    
    
    @AuraEnabled
    public static Boolean getMockStatus() {
        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        return isStaticResponseChecked;
    }
    
    
    
    
    
    
    
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
    
    @AuraEnabled
    public static List<Stream__c> getStreamRequestDetails(String searchString, String platform){
        System.debug('Method Param Values  '  + searchString + '::' +platform);
        String likeStr= '%'+searchString+'%';
        System.debug('likeStr  '  +likeStr);
        List<Stream__c> finalStreamList=new List<Stream__c>();
        List<Stream__c> streamData=new List<Stream__c>();
        List<list<SObject>> SearchList = new List<List<SObject>>();
        String searchQuery='';
        try{
            if(!(String.isBlank(searchString)) && (!(String.isBlank(platform)))){ 
                
                streamData=[Select id,Customer_Name__c,PolicyNumber__c,Customer_Number__c,PeopleSoftID__c,Source__c,AccountID__c,IEX_Picklist__c from Stream__c where Source__c=:platform AND
                            ((Customer_Name__c LIKE :likeStr) OR (PolicyNumber__c = :searchString) OR (Customer_Number__c = :searchString) OR (PeopleSoftID__c = :searchString) OR (AccountID__c = :searchString) )];                                            
                System.debug('streamData SQL=='+streamData);
                finalStreamList.addall(streamData);                              
            } 
            else if(!(String.isBlank(searchString)) && String.isBlank(platform)){
                searchQuery='FIND \'' + searchString + '\' IN ALL FIELDS RETURNING Stream__c(Customer_Name__c,Customer_Number__c,PolicyNumber__c,PeopleSoftID__c,Source__c,AccountID__c,IEX_Picklist__c)';
                SearchList=search.query(searchQuery);
                System.debug('SearchList SOSL=='+SearchList);
                finalStreamList=(List<Stream__c>)SearchList[0];
                System.debug('\n\n\n' + finalStreamList.size() + '\n\n\n');
            }            
            
            
        }catch(exception e){ 
        
        system.debug('errorMessage'+e.getmessage());
                        
        }       
        return finalStreamList;
        
    }
    
    @AuraEnabled
    Public static string insertEnrollee(object enrolleeListJSON,String RequestDetailObjectRecordID,String caseRecordId){
        Enrolees__c insertnewEnrollee = (Enrolees__c)enrolleeListJSON;
        insert insertnewEnrollee;
        return insertnewEnrollee.id;
    }
    
    @auraEnabled   
    public static string insertDataEnrollee(String enrolleeListJSON,String RequestDetailObjectRecordID,String caseRecordId){
        enrolleeWrapper resultwrapper = (enrolleeWrapper) JSON.deserialize(enrolleeListJSON,enrolleeWrapper.class);
        List<enrolleeWrapper>resultsList = new List<enrolleeWrapper>();
        resultsList.add(resultwrapper);
        System.debug('resultsList==='+resultsList);
        Enrolees__c enroleeRec = new Enrolees__c();
        string returnMessage='';
        List<Enrolees__c> enroleeList = new List<Enrolees__c>();
        try{
            for(Integer i = 0; i < resultsList.size(); i++){
                enroleeRec = new Enrolees__c(); 
                enroleeRec.First_Name__c=(resultsList[i].firstName!=null)?resultsList[i].firstName:'';
                enroleeRec.Last_Name__c=(resultsList[i].lastName!=null)?resultsList[i].lastName:'';
                enroleeRec.MiddleName__c=(resultsList[i].middleName!=null)?resultsList[i].middleName:'';
                enroleeRec.SSN__c=(resultsList[i].SSN!=null)?resultsList[i].SSN:'';
                enroleeRec.CorrectedUpdatedSSN__c=(resultsList[i].updatedSSN!=null)?resultsList[i].updatedSSN:'';
                enroleeRec.Date_of_Birth__c=Date.valueOf((resultsList[i].DateOfBirth!=null)?resultsList[i].DateOfBirth:null);
                enroleeRec.Gender__c=(resultsList[i].gender!=null)?resultsList[i].gender:'';
                enroleeRec.Employee_ID__c =(resultsList[i].EmployeeId!=null)?resultsList[i].EmployeeId:'';        
                enroleeRec.Address__c=(resultsList[i].address!=null)?resultsList[i].address:'';
                enroleeRec.City__c=(resultsList[i].city!=null)?resultsList[i].city:'';
                enroleeRec.Zip__c=(resultsList[i].zip!=null)?resultsList[i].zip:null;
                enroleeRec.State__c=(resultsList[i].state!=null)?resultsList[i].state:'';
                enroleeRec.Relationship__c=(resultsList[i].relationship!=null)?resultsList[i].relationship:'';
                enroleeRec.HomePhone__c=(resultsList[i].HomePhone!=null)?resultsList[i].HomePhone:'';
                enroleeRec.PrimaryCarePhysician__c=(resultsList[i].PrimaryCarePhysician!=null)?resultsList[i].PrimaryCarePhysician:'';
                enroleeRec.PrimaryCareDentist__c=(resultsList[i].PrimaryCareDentist!=null)?resultsList[i].PrimaryCareDentist:'';
                enroleeRec.AnnualSalary__c=Integer.valueOf((resultsList[i].anuualSalary!=null)?resultsList[i].anuualSalary:null);
                enroleeRec.CoordinationofBenefitsBegin_Date__c=Date.valueOf((resultsList[i].cobBeginDate!=null)?resultsList[i].cobBeginDate:null);
                enroleeRec.CoordinationofBenefitsEnd_Date__c=Date.valueOf((resultsList[i].cobEndDate!=null)?resultsList[i].cobEndDate:null);
                enroleeRec.MedicarePartAStartDate__c=Date.valueOf((resultsList[i].medCareAStrtDate!=null)?resultsList[i].medCareAStrtDate:null);
                enroleeRec.MedicarePartAEndDate__c=Date.valueOf((resultsList[i].medCareAEndDate!=null)?resultsList[i].medCareAEndDate:null);
                enroleeRec.MedicarePartBStartDate__c=Date.valueOf((resultsList[i].medCareBStrtDate!=null)?resultsList[i].medCareBStrtDate:null);
                enroleeRec.MedicarePartBEndDate__c=Date.valueOf((resultsList[i].medCareBEndDate!=null)?resultsList[i].medCareBEndDate:null);
                enroleeRec.MedicarePartDStartDate__c=Date.valueOf((resultsList[i].medCareDStrtDate!=null)?resultsList[i].medCareDStrtDate:null);
                enroleeRec.MedicarePartDEndDate__c=Date.valueOf((resultsList[i].medCareDEndDate!=null)?resultsList[i].medCareDEndDate:null);
                enroleeRec.PriorCoverageBeginDate__c=Date.valueOf((resultsList[i].priorCovBegnDate!=null)?resultsList[i].priorCovBegnDate:null);
                enroleeRec.PriorCoverageEndDate__c=Date.valueOf((resultsList[i].priorCovEndDate!=null)?resultsList[i].priorCovEndDate:null);
                enroleeRec.DeliveryPreference__c=(resultsList[i].deliveryPreffered!=null)?resultsList[i].deliveryPreffered:'';
                enroleeRec.Email__c=(resultsList[i].emailAttr!=null)?resultsList[i].emailAttr:'';
                enroleeRec.ExistingPatient__c=(resultsList[i].existingPatient!=null)?resultsList[i].existingPatient:false;                
                enroleeRec.Case__c=caseRecordId;
                enroleeList.add(enroleeRec);
            }
            if(enroleeList.size()>0) {
                insert enroleeList;
                returnMessage = enroleeList[0].id;
            }
        }catch (Exception ex) {
            
            returnMessage = ex.getMessage();
            
        }
        return returnMessage;
    }
    
    @auraEnabled   
    public static void insertDataEnrolleeList(String enrolleeListJSON,String RequestDetailObjectRecordID,String caseRecordId){
        List<enrolleeWrapper> resultsList = (List<enrolleeWrapper>) JSON.deserialize(enrolleeListJSON,List<enrolleeWrapper>.class);
        System.debug('resultsList==='+resultsList);
        Enrolees__c enroleeRec = new Enrolees__c();
        List<Enrolees__c> enroleeList = new List<Enrolees__c>();
        try{
            for(Integer i = 0; i < resultsList.size(); i++){
                enroleeRec = new Enrolees__c(); 
                enroleeRec.First_Name__c=(resultsList[i].firstName!=null)?resultsList[i].firstName:'';
                enroleeRec.Last_Name__c=(resultsList[i].lastName!=null)?resultsList[i].lastName:'';
                enroleeRec.MiddleName__c=(resultsList[i].middleName!=null)?resultsList[i].middleName:'';
                enroleeRec.SSN__c=(resultsList[i].SSN!=null)?resultsList[i].SSN:'';
                enroleeRec.CorrectedUpdatedSSN__c=(resultsList[i].updatedSSN!=null)?resultsList[i].updatedSSN:'';
                enroleeRec.Date_of_Birth__c=Date.valueOf((resultsList[i].DateOfBirth!=null)?resultsList[i].DateOfBirth:null);
                enroleeRec.Gender__c=(resultsList[i].gender!=null)?resultsList[i].gender:'';
                enroleeRec.Employee_ID__c =(resultsList[i].EmployeeId!=null)?resultsList[i].EmployeeId:'';        
                enroleeRec.Address__c=(resultsList[i].address!=null)?resultsList[i].address:'';
                enroleeRec.City__c=(resultsList[i].city!=null)?resultsList[i].city:'';
                enroleeRec.Zip__c=(resultsList[i].zip!=null)?resultsList[i].zip:null;
                enroleeRec.State__c=(resultsList[i].state!=null)?resultsList[i].state:'';
                enroleeRec.Relationship__c=(resultsList[i].relationship!=null)?resultsList[i].relationship:'';
                enroleeRec.HomePhone__c=(resultsList[i].HomePhone!=null)?resultsList[i].HomePhone:'';
                enroleeRec.PrimaryCarePhysician__c=(resultsList[i].PrimaryCarePhysician!=null)?resultsList[i].PrimaryCarePhysician:'';
                enroleeRec.PrimaryCareDentist__c=(resultsList[i].PrimaryCareDentist!=null)?resultsList[i].PrimaryCareDentist:'';
                enroleeRec.AnnualSalary__c=Integer.valueOf((resultsList[i].anuualSalary!=null)?resultsList[i].anuualSalary:null);
                enroleeRec.CoordinationofBenefitsBegin_Date__c=Date.valueOf((resultsList[i].cobBeginDate!=null)?resultsList[i].cobBeginDate:null);
                enroleeRec.CoordinationofBenefitsEnd_Date__c=Date.valueOf((resultsList[i].cobEndDate!=null)?resultsList[i].cobEndDate:null);
                enroleeRec.MedicarePartAStartDate__c=Date.valueOf((resultsList[i].medCareAStrtDate!=null)?resultsList[i].medCareAStrtDate:null);
                enroleeRec.MedicarePartAEndDate__c=Date.valueOf((resultsList[i].medCareAEndDate!=null)?resultsList[i].medCareAEndDate:null);
                enroleeRec.MedicarePartBStartDate__c=Date.valueOf((resultsList[i].medCareBStrtDate!=null)?resultsList[i].medCareBStrtDate:null);
                enroleeRec.MedicarePartBEndDate__c=Date.valueOf((resultsList[i].medCareBEndDate!=null)?resultsList[i].medCareBEndDate:null);
                enroleeRec.MedicarePartDStartDate__c=Date.valueOf((resultsList[i].medCareDStrtDate!=null)?resultsList[i].medCareDStrtDate:null);
                enroleeRec.MedicarePartDEndDate__c=Date.valueOf((resultsList[i].medCareDEndDate!=null)?resultsList[i].medCareDEndDate:null);
                enroleeRec.PriorCoverageBeginDate__c=Date.valueOf((resultsList[i].priorCovBegnDate!=null)?resultsList[i].priorCovBegnDate:null);
                enroleeRec.PriorCoverageEndDate__c=Date.valueOf((resultsList[i].priorCovEndDate!=null)?resultsList[i].priorCovEndDate:null);
                enroleeRec.DeliveryPreference__c=(resultsList[i].deliveryPreffered!=null)?resultsList[i].deliveryPreffered:'';
                enroleeRec.Email__c=(resultsList[i].emailAttr!=null)?resultsList[i].emailAttr:'';
                enroleeRec.ExistingPatient__c=(resultsList[i].existingPatient!=null)?resultsList[i].existingPatient:false;                
                enroleeRec.Case__c=caseRecordId;
                enroleeList.add(enroleeRec);
                System.debug('enrolee List'+enroleeList);
            }
            insert enroleeList;
        }catch (Exception ex) {
            system.debug('Uh oh an error occurred!' +ex.getMessage());
            System.debug(LoggingLevel.ERROR,'####ERROR LINE:'+ex.getLineNumber());
        }
    }
    
    public static Map<String, List<String>> getDependentPicklistValues(Schema.sObjectField dependToken) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
             
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
        
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            boolean checkvalid = checkentry(entry);
            if (checkvalid==true) {
                List<String> base64chars =
                    String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < controlEntries.size(); index++) {
                    Object controlValue =dependentdata(controlEntries,index);
                        
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                   boolean checkbit= validateIndexMethod( controlvalue, bitIndex, base64map,base64chars, bitShift);
                    if(checkbit==true)
                        continue;
                    dependentPicklistValues = dependentpickMap(dependentPicklistValues,controlValue, entry);
                    
                }
            }
        }
        return dependentPicklistValues;
    }
    private static boolean validateIndexMethod(object controlvalue,integer bitIndex,string base64map,list<string>base64chars,integer bitShift){
        boolean valid=false;
        valid = controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0;
        return valid;
    }
    private static boolean checkentry(Schema.PicklistEntry entry){
        boolean valid=false;
        valid = entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')));
        return valid;
    }
    private static Map<String,List<String>> dependentpickMap(Map<String,List<String>> dependentPicklistValues,object controlValue,Schema.PicklistEntry entry){
     
         if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
        dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
        return dependentPicklistValues;
    }
    private static object dependentdata(List<Schema.PicklistEntry> controlEntries,integer index){
        Object controlValue = (controlEntries == null
                         ?   (Object) (index == 1)
                         :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                        );
        return controlValue;
    }
    @AuraEnabled
    public static List<String> getRelationshipValues(String platform){
        List<String> optionlist = new List<String>();       
        Map<String,List<String>> dependentPicklistValuesMap = getDependentPicklistValues(Enrolees__c.Relationship__c);
        
        
        if(dependentPicklistValuesMap.containskey(platform)){
            optionlist.addall(dependentPicklistValuesMap.get(platform));
        }
        optionlist.sort();
        return optionlist;
    }
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        List<String> optionlist = new List<String>();       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();       
        if(nullRequired == true){
            optionlist.add('None');
        }       
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        system.debug('optionlist=='+optionlist);
        return optionlist;
    }
    
  
    
    @AuraEnabled
    Public static returnwrap uploadNotestoERM(string caseId){
        returnwrap wrap = new returnwrap();
        
        case caserec = [select id,external_reference_id__c from case where id=:caseid];
        
        
        List<CaseComment> commentList = [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, 
                                         SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted 
                                         From CaseComment where ParentId=:caseId and IsPublished =false];
        List<Casecomment>updateNotes = new List<CaseComment>();
        if(commentList.size()>0){
            for(CaseComment comment: commentList){
                string commentbody=comment.CommentBody;
                Map<string,string>reqParams = new Map<string,string>();
                reqParams.put('RequestID',caserec.External_Reference_ID__c);
                reqParams.put('Comments',commentbody.replaceAll(' ', '%20'));
               ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'ERMNotesRequest';
                wsCallOutFW.requestParamsMap = reqParams;
                wsCallOutFW.requestBody = 'test';
                    
                HttpResponse  docres ;
                try{
                   
               docres = wsCallOutFW.getResponse();
                
                if(docres.getstatuscode()==200){
                    casecomment updatenote = new casecomment();
                    updatenote.id =comment.id;
                    updatenote.IsPublished =true;
                    updateNotes.add(updatenote);
                    wrap.returnMessage = '';
                    wrap.status='200';
                }else{
                   
                    wrap.returnMessage = 'Comments failed to update';
                    wrap.status='500';
                }
                    }catch(exception e){
                        
                    wrap.status= '500';
            wrap.returnMessage = e.getMessage();
                        system.debug('.........wrap..'+wrap);
                }
            }
        }
        else{
            wrap.returnMessage='No Comments to update';
            wrap.status ='0';
        }
        try{
        if(updateNotes.size()>0){
            update updateNotes;
        }
        }catch(exception e){
            wrap.status= '500';
            wrap.returnMessage = e.getMessage();
        }
        return wrap;
    }
    
    @AuraEnabled
    Public static string sendUpdateRequestToERM(string caseId){
        returnwrap finalwrap = new returnwrap();
        returnwrap wrap = new returnwrap();       
        List<attachments__c>attachList =new List<attachments__c>();
        Case caserec =[select id,casenumber,external_reference_id__c from case where id=:caseId];
        map<Id,string> contentDocIds = new map<Id,string>();
        List<string>failedIds = new List<string>();
        map<string,string> attachid = new map<string,string>();
        for(Attachments__c attch : [select id,document_id__c from Attachments__c where case__c=:caseId]){
            attachid.put(attch.Document_Id__c,attch.id);
        }
        List<ContentDocumentLink> contentDocLinkList=[SELECT ContentDocumentId,Id,LinkedEntityId,ShareType FROM ContentDocumentLink WHERE LinkedEntityId = :caseId];
        for(ContentDocumentLink doclinks : contentDocLinkList){
            if(!attachid.containsKey(doclinks.ContentDocumentId) ){
                contentDocIds.put(doclinks.ContentDocumentId,doclinks.LinkedEntityId);
            }
        }
        if(contentDocIds.size()>0){
            for(ContentVersion versiondata : [SELECT VersionData,PathOnClient,ContentDocumentId,contentdocument.description FROM ContentVersion
                                              WHERE ContentDocumentId in: contentDocIds.keyset() AND IsLatest = true and contentdocument.IsArchived=false]){
                                                  
                                                  returnWrap attchresponsewrapper =new returnwrap();                                            
                                                  attchresponsewrapper = uploadAttachmentstoERM(versiondata,caserec.external_reference_id__c);
                                                  system.debug('...........'+attchresponsewrapper);
                                                  if(attchresponsewrapper.status != '0'){ 
                                                      Attachments__c attwrap = new Attachments__c();
                                                      attwrap.name =   versiondata.PathOnClient ;
                                                      attwrap.case__c = caserec.id;
                                                      attwrap.Document_Id__c = versiondata.ContentDocumentId;
                                                      attwrap.ERM_ServerPath__c = attchresponsewrapper.returnMessage;
                                                      attwrap.file_name__c = attchresponsewrapper.status;
                                                      attachList.add(attwrap);
                                                      attchresponsewrapper.status = '200';
                                                      wrap =  attchresponsewrapper;
                                                  }else{
                                                      failedIds.add(versiondata.PathOnClient );
                                                      wrap.returnMessage = json.serialize(failedIds);
                                                      wrap.status='400';
                                                  }
                                                  
                                              }
            
        }else{
            wrap.returnMessage='No files to update';
            wrap.status ='0';
        }
        returnwrap noteswrap = new returnwrap();
        noteswrap  = uploadNotestoERM(caserec.id);
        try{
                if(attachList.size()>0){
                    insert attachList;
                }
            }catch(exception e){
            wrap.status= '500';
            wrap.returnMessage = e.getMessage();
           }
        finalwrap = checkStatus(wrap,noteswrap);
        
        return json.serialize(finalWrap);    
    }
    Public static returnWrap checkInnerStatus(returnwrap wrap,returnwrap noteswrap){
        returnwrap finalwrap = new returnwrap();
        if((wrap.status != '0' && wrap.status != '200') && (noteswrap.status !='0'&& wrap.status !='200')){
            
            	finalwrap.status = '500';
                finalWrap.returnmessage = 'Failed to update Additional Information';
            
        }
        else if( wrap.status != '200'&& wrap.status !='0'&& noteswrap.status =='200' && noteswrap.status !='0' ){
            
            	finalwrap.status = '400';
                finalWrap.returnmessage = 'Case Comments updated Successfully, failed to update Attachments';
        }
        else if( wrap.status == '200'&& wrap.status !='0' && noteswrap.status !='200'&& noteswrap.status !='0'){
            
            	finalwrap.status = '400';
                finalWrap.returnmessage = 'Attachments updated successfully, failed to update Case Comments';
        }
        return finalWrap;
    }
    Public static returnwrap checkStatus(returnwrap wrap,returnwrap noteswrap){
        returnwrap finalwrap = new returnwrap();
        system.debug('llllllll'+wrap+noteswrap);
        
        finalwrap = checkInnerStatus(wrap,noteswrap);
        if(finalwrap.status == null){
         if((wrap.status == '200'&& wrap.status !='0' && noteswrap.status =='200'&& noteswrap.status !='0')
               || (wrap.status == '200'&& noteswrap.status =='0')
                || (wrap.status =='0'&& noteswrap.status=='200')){
            
            	finalwrap.status = '200';
                finalWrap.returnmessage = 'Additional information updated Succesfully';
        }
        else if( wrap.status =='0' && noteswrap.status !='200' && noteswrap.status !='0'){
            		finalwrap.status = '500';
                finalWrap.returnmessage = 'Failed to update Case Comments';
        }
        else if (wrap.status !='0'&& wrap.status !='200' && noteswrap.status =='0'){
            		finalwrap.status = '500';
                finalWrap.returnmessage = 'Failed to update Attachments';
        }
         else if( wrap.status =='0' && noteswrap.status =='0'){
            
            	finalwrap.status = '500';
                finalWrap.returnmessage = 'No additional information to update';
        }
        }
        system.debug('...........'+finalwrap);
        return finalWrap;
    }
    Public static returnwrap uploadAttachmentstoERM(Contentversion filedata,string reqid){
        if(reqid == ''){
            reqid=null;
        }
        returnwrap wrapper = new returnwrap();
        try{
            transient string Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';
            transient string contentType = ETSBE_HttpFileFormBuilder.GetContentType();          
            transient string form64 = '';
            form64 += ETSBE_HttpFileFormBuilder.WriteBoundary();
            
            ETSBE_HttpFileFormBuilder.WriteFileResult result = ETSBE_HttpFileFormBuilder.WriteFile('file_007', fileData.PathOnClient, 'application/octet-stream', filedata.VersionData);
            
            form64 += result.Content;
            form64 += ETSBE_HttpFileFormBuilder.WriteBoundary(result.EndingType);
            
            blob formBlob = EncodingUtil.base64Decode(form64);
            string contentLength = string.valueOf(formBlob.size());
             
            string orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
            orgName = orgName.toLowerCase();
            WebserviceConfigurations__c config = [select id,name,Method__c,EndpointPath__c FROM WebserviceConfigurations__c
                                                  where name='ERMFileUploadRequest'];
            OrgSpecificConfigurations__c orgConfig =[select id,EndpointDomain__c from OrgSpecificConfigurations__c where
                                                     WebserviceConfigurations__c=:config.id and name=:orgName];
           ACET_WebserviceCalloutFramework frmework=new ACET_WebserviceCalloutFramework('StarGateTokenAPI','',null);

            List<httpresponse>  res = frmework.getAuthToken(new set<string>{'StarGateTokenAPI'});
            
            system.debug(res[0].getbody());
            map<string,object> tokenaccess = (map<string,object>)json.deserializeUntyped(res[0].getbody());
            HttpRequest docreq =new HttpRequest();
            docreq.setHeader('Content-Type','multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"');
            docreq.setTimeout(120000);
            docreq.setEndpoint(orgConfig.EndpointDomain__c+'?RequestID='+reqId );
           
            docreq.setHeader('Authorization',Bearer +tokenaccess.get('access_token'));
            
            docreq.setMethod(config.Method__c);
            docreq.setBodyasblob(formBlob);
            Http dochttp =new Http();
            HTTPResponse docres = dochttp.send(docreq );
            if(docres.getStatusCode() == 200){
                List<attachmentWrapper> wrappList = (List<attachmentWrapper>)json.deserialize(docres.getBody(), List<attachmentWrapper>.class);
                wrapper.status= wrappList[0].fileName;
                wrapper.returnMessage = wrappList[0].serverPath;
            }else{
                wrapper.status= '0';
                wrapper.returnMessage = filedata.ContentDocumentId;
            }
            
        }catch(exception e){
            wrapper.status= '0';
            wrapper.returnMessage = filedata.ContentDocumentId;
        }
        return wrapper;
    }
    
    @AuraEnabled
    Public static String updatecaseStatusToOpen(String caseId){
      
        Case caserec =[select id,Status,External_Reference_ID__c from case where id=:caseId];
        System.debug('== case Status' +caserec.Status);
        returnWrap wrapper = new returnWrap(); 
        string orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
        if(test.isRunningTest()){
            orgName = 'QA';
        }
            orgName = orgName.toLowerCase();
        if(caserec.Status=='Pended'){
            
            string returnMessage='';
            string url='';
            
            pendedWrap pendWrapJSON=new pendedWrap();
            pendWrapJSON.requestID=caserec.External_Reference_ID__c;
            pendWrapJSON.requestStatus='Open';
            Map<string,string>reqParams = new Map<string,string>();
                reqParams.put('RequestID',caserec.External_Reference_ID__c);
            system.debug('pend data' +JSON.serialize(pendWrapJSON));
             ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'ERMPendedRequest';
                wsCallOutFW.requestParamsMap = reqParams;
                wsCallOutFW.requestBody = JSON.serialize(pendWrapJSON);
                HttpResponse  response = wsCallOutFW.getResponse();
            
            try {
                
                System.debug('body result==' +response.getBody()); 
                if(response.getStatusCode() == 200){
                    caserec.Status='Open';
                    caserec.No_More_Comments__c =true;
                    update caserec;
                    wrapper.status='200';
                    wrapper.returnMessage = response.getBody();                              
                } else if(response.getStatusCode() == 501){
                    map<string,object>errorParsing = (map<string,object>)json.deserializeUntyped(response.getBody());
                    wrapper.status='500';
                    wrapper.returnMessage = (string)errorParsing.get('ErrorMessage');
                } else{
                    wrapper.status='500';
                    wrapper.returnMessage = response.getstatus();
                }            
                System.debug('HTTP Response Code data: ' + response.getStatusCode()); 
                System.debug('Response Body Data: ' + response.getBody());   
            } catch(System.CalloutException e) {
                wrapper.status='500';           
                wrapper.returnMessage = e.getMessage();
                 
            }        
        }    
        system.debug('......'+wrapper);
        return json.serialize(wrapper);
    }
    Public static ERM_RequestWrapper elrObject(Stream_Request_Details__c requestDetailsvar,case caserec,user usr){
         ERM_RequestWrapper requestJSONWrapper=new ERM_RequestWrapper();    
         //Request Data Assignment   
            requestJSONWrapper.ElrID=Integer.valueOf(requestDetailsvar.Name.substring(3));
            
            if(platformMap.containskey(requestDetailsvar.Plat_form__c))
                requestJSONWrapper.ElrPlatform=integer.valueof(platformMap.get(requestDetailsvar.Plat_form__c));
            else
                requestJSONWrapper.ElrPlatform= null;
             boolean reqkey = false;
            string reqmap='';
            reqmap = requestJSONWrapper.ElrPlatform+':'+requestDetailsvar.RequestType__c;
             system.debug('/////reqkeyreqkey/////'+reqmap);
            reqkey = requestMap.containskey(reqmap);
            system.debug('/////reqkeyreqkey/////'+reqkey);
            if(reqkey==false){
            reqkey = requestMap.containskey(requestDetailsvar.RequestType__c);
            reqmap = requestDetailsvar.RequestType__c;
            }
            if(reqkey)
                requestJSONWrapper.ElrRequestType=integer.valueof(requestMap.get(reqmap));
            else
                requestJSONWrapper.ElrRequestType= null;
            requestJSONWrapper.ElrMemberSeekingServices=false;
            requestJSONWrapper.ElrPlatinumBroker=false;
            requestJSONWrapper.ElrRequestReceivedDate=string.valueof(system.now());
            requestJSONWrapper.ElrQualifyingEventDate=  string.valueof(requestDetailsvar.Qualifying_Event_Date__c);
            requestJSONWrapper.ElrDateOfHire=checkNUllFUnction(String.valueOf(requestDetailsvar.Date_Of_Hire__c));
            requestJSONWrapper.ElrCOBRAPaidThruDate=checkNUllFUnction(String.valueOf(requestDetailsvar.COBRA_Paid_Thru_Stop_Date__c));
            requestJSONWrapper.ElrPolicyId= caseRec.Policy__c!=null?caseRec.Policy__c:'0';
            
            
            requestJSONWrapper.ElrIA= requestDetailsvar.Integrated_Administration__c=='Yes'?1:2;           
            requestJSONWrapper.ElrQualifyingEventReason =requestDetailsvar.Qualifying_Event_Reason__c!=null?integer.valueof(qualifiingMap.get(requestDetailsvar.Qualifying_Event_Reason__c)):null;
            requestJSONWrapper.ElrQualifyingEventReasonNotes =requestDetailsvar.Explanation__c!=null?requestDetailsvar.Explanation__c:'';
            requestJSONWrapper.ElrETrackNbr =requestDetailsvar.ETS_BE_ISET_ACET_Request_ID__c;
            if(requestDetailsvar.requesttype__c != reportGenerator)
                requestJSONWrapper.ElrEstimatedTransactions=checkNUllinteger(Integer.valueOf(requestDetailsvar.Estimated_Transactions__c));
            else
                requestJSONWrapper.ElrEstimatedTransactions=checkNUllinteger(Integer.valueOf(requestDetailsvar.Count_of_Reports_Requested__c));
            
            requestJSONWrapper.ElrCallerPhone=requestDetailsvar.Caller_Phone__c != null?requestDetailsvar.Caller_Phone__c.replaceall('-',''):'';
            requestJSONWrapper.ElrCallerName=requestDetailsvar.Caller_Name__c;
            requestJSONWrapper.elrCustomerName=caseRec.Group_Name__c;
            requestJSONWrapper.elrPeopleSoftID= checkNUllfunction(string.valueof(caseRec.Subject_Group_ID__c));
            requestJSONWrapper.ElrSSNChecked=requestDetailsvar.Unmasked_SSN_data_required__c;
            
            requestJSONWrapper.ElrCompleteForm=requestDetailsvar.I_have_a_completed_form_document__c;
            requestJSONWrapper.ElrCQER=requestDetailsvar.CQER__c;
            requestJSONWrapper.ElrEffectiveDate=  (requestDetailsvar.Effective_Date__c!= null)?String.valueOf(requestDetailsvar.Effective_Date__c)+'T00:00:00':'';            
            requestJSONWrapper.ElrAddDate=String.valueOf(requestDetailsvar.CreatedDate).replace(' ','T');
            requestJSONWrapper.ElrExternalEmail=requestDetailsvar.ExternalClientEmail__c;
            requestJSONWrapper.ElrIEX=requestDetailsvar.IEX__c;
            
            requestJSONWrapper.ElrCompanyCode= requestDetailsvar.NICE_Company_Code__c != null ?integer.valueof(departmentmap.get(requestDetailsvar.NICE_Company_Code__c)):0;
            requestJSONWrapper.ElrReportNeeded=requestDetailsvar.Report_Needed__c != null ?Integer.valueOf(reportMap.get(requestDetailsvar.Report_Needed__c)):0;
            requestJSONWrapper.ElrRequesterName=usr.FederationIdentifier;
            requestJSONWrapper.ElrRequester=1;
            requestJSONWrapper.elrSubmitted=true;
        return requestJSONWrapper;
    }
   
    Public static List<ERM_RequestWrapper.Enrollees> enrObject(ERM_RequestWrapper requestJSONWrapper,Stream_Request_Details__c requestDetailsvar,case caseRec){
        List<ERM_RequestWrapper.Enrollees> enroleeLstWrap=new List<ERM_RequestWrapper.Enrollees>(); 
        if(requestDetailsvar.RequestType__c=='CPTIN'){
                ERM_RequestWrapper.Enrollees enrolWrap=new ERM_RequestWrapper.Enrollees();
                
                enrolWrap.EnrFirstName=requestDetailsvar.Subscriber_First_Name__c;
                enrolWrap.EnrLastName=requestDetailsvar.Subscriber_Last_Name__c;
                enrolWrap.Enrcptin=requestDetailsvar.Subscriber_CPTIN__c;
                enrolwrap.EnrDOB =string.valueof(requestDetailsvar.Date_of_Birth__c);
                enrolwrap.EnrEmployeeId =requestDetailsvar.Employee_ID__c;
                
                enrolWrap.EnrRelationshipToSubscriber= 16;
                if(relationshipMap.containskey(requestJSONWrapper.ElrPlatform+':'+requestDetailsvar.Relationship__c)){
                    enrolWrap.EnrRelationshipToSubscriber= 16;
                }    
                enroleeLstWrap.add(enrolWrap);
            }
            if(requestDetailsvar.RequestType__c=='Standard Alt-ID Change'){
                ERM_RequestWrapper.Enrollees enrolWrap=new ERM_RequestWrapper.Enrollees();
                
                enrolWrap.EnrFirstName=requestDetailsvar.First_Name__c;
                enrolWrap.EnrLastName=requestDetailsvar.Last_Name__c;
                enrolWrap.EnrmiddleName=requestDetailsvar.middle_Name__c;
                enrolWrap.Enrssn=requestDetailsvar.ssn__c;
                enrolwrap.EnrDOB =string.valueof(requestDetailsvar.Date_of_Birth__c);
                enrolwrap.EnrEmployeeId =requestDetailsvar.Employee_ID__c;
                
                if(relationshipMap.containskey(requestJSONWrapper.ElrPlatform+':'+requestDetailsvar.Relationship__c)){
                    enrolWrap.EnrRelationshipToSubscriber= integer.valueof(relationshipMap.get(requestJSONWrapper.ElrPlatform+':'+requestDetailsvar.Relationship__c)); 
                }    
                enrolWrap.EnrAlternateID=requestDetailsvar.Alternate_ID__c; 
                enrolWrap.EnrApproverName=requestDetailsvar.Approver_s_Name__c;  
                enrolWrap.EnrApproverTitle=requestDetailsvar.Approver_s_Title__c;
                enroleeLstWrap.add(enrolWrap);
            }
            for(Enrolees__c Enrolee:caseRec.Enrollees__r) {
                ERM_RequestWrapper.Enrollees enrolWrap=new ERM_RequestWrapper.Enrollees();
                enrolWrap.EnrID=1; 
                enrolWrap.EnrRequestId=Enrolee.Request_Details__c;
                enrolWrap.EnrName=Enrolee.Name;  
                
                enrolWrap.EnrSSN=Enrolee.SSN__c; 
                if(genderMap.containskey(Enrolee.Gender__c))
                    enrolWrap.EnrGender=integer.valueof(genderMap.get(Enrolee.Gender__c));
                else
                    enrolWrap.EnrGender=null; 
                if(relationshipMap.containskey(requestJSONWrapper.ElrPlatform+':'+Enrolee.Relationship__c)){
                    enrolWrap.EnrRelationshipToSubscriber= integer.valueof(relationshipMap.get(requestJSONWrapper.ElrPlatform+':'+Enrolee.Relationship__c)); 
                    
                }               
                enrolWrap.EnrAddress=Enrolee.Address__c;
                enrolWrap.EnrCity=Enrolee.City__c; 
                enrolWrap.EnrState=Enrolee.State__c;  
                enrolWrap.EnrZip=Enrolee.Zip__c; 
                enrolWrap.EnrDOB=checkNUllfunction(String.valueOf(Enrolee.Date_of_Birth__c)); 
                enrolWrap.EnrFirstName=Enrolee.First_Name__c;
                enrolWrap.EnrLastName=Enrolee.Last_Name__c;
                enrolWrap.EnrMiddleName=Enrolee.MiddleName__c; 
                enrolWrap.EnrDateOfHire=checkNUllfunction(String.valueOf(requestDetailsvar.Date_Of_Hire__c));
                enrolWrap.EnrCOBBeginDate=checkNUllfunction(String.valueOf(Enrolee.CoordinationofBenefitsBegin_Date__c));
                enrolWrap.EnrCOBEndDate=checkNUllfunction(String.valueOf(Enrolee.CoordinationofBenefitsEnd_Date__c)); 
                enrolWrap.EnrPriorCoverageBeginDate=checkNUllfunction(String.valueOf(Enrolee.PriorCoverageBeginDate__c)); 
                enrolWrap.EnrPriorCoverageEndDate=checkNUllfunction(String.valueOf(Enrolee.PriorCoverageEndDate__c)); 
                enrolWrap.EnrDentist=Enrolee.PrimaryCareDentist__c; 
                enrolWrap.EnrMedicarePartAStart=checkNUllfunction(String.valueOf(Enrolee.MedicarePartAStartDate__c)); 
                enrolWrap.EnrMedicarePartAEnd=checkNUllfunction(String.valueOf(Enrolee.MedicarePartAEndDate__c)); 
                enrolWrap.EnrMedicarePartBStart=checkNUllfunction(String.valueOf(Enrolee.MedicarePartBStartDate__c)); 
                enrolWrap.EnrMedicarePartBEnd=checkNUllfunction(String.valueOf(Enrolee.MedicarePartBEndDate__c)); 
                enrolWrap.EnrMedicarePartDStart=checkNUllfunction(String.valueOf(Enrolee.MedicarePartDStartDate__c)); 
                enrolWrap.EnrMedicarePartDEnd=checkNUllfunction(String.valueOf(Enrolee.MedicarePartDEndDate__c)); 
                enrolWrap.EnrExistingPatient=Enrolee.ExistingPatient__c; 
                enrolWrap.EnrHomePhone=Enrolee.HomePhone__c; 
                enrolWrap.EnrRetirementDate=null;           
                enrolWrap.EnrSalary=checkNUllfunction(String.valueOf(Enrolee.AnnualSalary__c)); 
                enrolWrap.EnrPhysician=Enrolee.PrimaryCarePhysician__c; 
                enrolWrap.EnrEmployeeId=Enrolee.Employee_ID__c; 
                enrolWrap.EnrCorrectedSSN=Enrolee.CorrectedUpdatedSSN__c; 
                enrolWrap.EnrAddDate=String.valueOf(Enrolee.CreatedDate).replace(' ','T');
                enrolWrap.EnrDeliveryPreference=Enrolee.MiddleName__c; 
                enrolWrap.EnrEmail=Enrolee.Email__c; 
                enrolWrap.EnrAddress2=Enrolee.Address__c; 
                
                enrolWrap.EnrCPTIN=Enrolee.CPTIN__c; 
                enroleeLstWrap.add(enrolWrap);
            }
            return enroleeLstWrap;
    }
    @AuraEnabled
    Public static  ERM_RequestWrapper.RequestDetails  erdObject(Stream_Request_Details__c requestDetailsvar){
        ERM_RequestWrapper.RequestDetails requestDetailsWrap =new ERM_RequestWrapper.RequestDetails();
        requestDetailsWrap.ErdID=Integer.valueOf(requestDetailsvar.Name.substring(3));
            requestDetailsWrap.ErdLifeAmount=requestDetailsvar.Flat_Amount_suppl_life__c!=null?Integer.valueOf(requestDetailsvar.Flat_Amount_suppl_life__c):0;
            requestDetailsWrap.ErdLifeSalary=null;
            requestDetailsWrap.ErdDifferExplanation=requestDetailsvar.Explanation__c;
            requestDetailsWrap.ErdNonContributory=false;
            requestDetailsWrap.ErdDescription=null;
            requestDetailsWrap.ErdRequestId=requestDetailsvar.ETS_BE_ISET_ACET_Request_ID__c!=null?requestDetailsvar.ETS_BE_ISET_ACET_Request_ID__c:null;
            
            requestDetailsWrap.ErdGrpPreviousNumber=requestDetailsvar.Previous_Group_Number__c!=null?String.valueOf(requestDetailsvar.Previous_Group_Number__c):'';
            requestDetailsWrap.ErdGrpNumber=requestDetailsvar.Medical_Group_Number_s__c;
            requestDetailsWrap.ErdGroupPhoneNumber=requestDetailsvar.Group_Phone_Number__c;
            requestDetailsWrap.ErdGroupFaxNumber=requestDetailsvar.Group_Phone_Fax__c;
            requestDetailsWrap.ErdGroupNewPhysicalAddress=requestDetailsvar.New_Physical_Address__c;
            requestDetailsWrap.ErdGroupNewPhysicalCity=requestDetailsvar.New_Physical_City__c;
            requestDetailsWrap.ErdGroupNewPhysicalState=requestDetailsvar.New_Physical_State__c;
            requestDetailsWrap.ErdGroupNewPhysicalZip=requestDetailsvar.New_Physical_Zip__c!=null?String.valueOf(requestDetailsvar.New_Physical_Zip__c):'';
            requestDetailsWrap.ErdGroupNewBillingAddress=requestDetailsvar.New_Billing_Address__c;
            requestDetailsWrap.ErdGroupNewBillingCity=requestDetailsvar.New_Billing_City__c;
            requestDetailsWrap.ErdGroupNewBillingState=requestDetailsvar.New_Billing_State__c;
            requestDetailsWrap.ErdGroupNewBillingZip=requestDetailsvar.New_Billing_Zip__c!= null?String.valueOf(requestDetailsvar.New_Billing_Zip__c):'';
            requestDetailsWrap.ErdApprovingChangeName=requestDetailsvar.Approver_s_Name__c;
            requestDetailsWrap.ErdApprovingChangeTitle=requestDetailsvar.Approver_s_Title__c;
            requestDetailsWrap.ErdTransferringUHG=requestDetailsvar.Is_Policy_Transferred__c=='Yes'?1:0;
            requestDetailsWrap.ErdNewPolicyNumber=requestDetailsvar.New_Policy_Number__c!=null?string.valueof(requestDetailsvar.New_Policy_Number__c):'';
            requestDetailsWrap.ErdPrimePolicyNumberTerm=requestDetailsvar.PRIME_Policy_Number_s_to_be_Terminated__c;
            requestDetailsWrap.ErdPrimeCustomerNumberTerm=requestDetailsvar.PRIME_Customer_Number_s_to_Terminate__c;
            requestDetailsWrap.ErdPeopleSoftIDTerm=requestDetailsvar.PeopleSoft_Customer_Number_s_to_be_Term__c;
            requestDetailsWrap.ErdRetroExclustionReason=requestDetailsvar.Retro_Exclusion_Reason__c!=null?integer.valueof(retroExclusiveMap.get(requestDetailsvar.Retro_Exclusion_Reason__c)):null;
            if(terminationmap.containskey(requestDetailsvar.termination_Reason__c))
                requestDetailsWrap.ErdTerminationReason=integer.valueof(terminationMap.get(requestDetailsvar.termination_Reason__c));
            if(terminationLevelMap.containskey(requestDetailsvar.Termination_Level__c))
                requestDetailsWrap.ErdTerminationLevel=integer.valueof(terminationLevelMap.get(requestDetailsvar.Termination_Level__c));
            requestDetailsWrap.ErdTerminationNotes=requestDetailsvar.Termination_Notes__c;
            requestDetailsWrap.ErdSameForAll=requestDetailsvar.Products_Same_for_All_Dependents__c== true?1:0;
            requestDetailsWrap.ErdOriginalCOBRAStartDate=requestDetailsvar.Original_COBRA_Start_Date__c!=null?String.valueOf(requestDetailsvar.Original_COBRA_Start_Date__c).replace(' ','T'):'';
            requestDetailsWrap.ErdNewPlatform=requestDetailsvar.New_Platform__c;
            requestDetailsWrap.ErdTermDependentCount=requestDetailsvar.Dependent_Count__c!=null?Integer.valueOf(requestDetailsvar.Dependent_Count__c):0;            
            requestDetailsWrap.ErdAddDate=String.valueOf(requestDetailsvar.CreatedDate).replace(' ','T');            
            requestDetailsWrap.ErdPrimePolicyNumberReinstate=requestDetailsvar.PRIME_Policy_Number_s_to_Reinstate__c;
            requestDetailsWrap.ErdPrimeCustomerNumberReinstate=requestDetailsvar.PRIME_Customer_Number_s_to_Reinstate__c;
            requestDetailsWrap.ErdPeopleSoftIDReinstate=requestDetailsvar.PeopleSoft_Number_s_to_Reinstate__c;
            requestDetailsWrap.ErdDolFinal=requestDetailsvar.DOL_Final_Rule_Exception__c;    
            requestDetailsWrap.ErdSubscriberFirstName=requestDetailsvar.Subscriber_First_Name__c;
        return requestDetailsWrap;
	}
    Public static ERM_RequestWrapper.Products prdObject(Stream_Request_Details__c requestDetailsvar){
        ERM_RequestWrapper.Products prdWrap = new ERM_RequestWrapper.Products();
          prdwrap.prdMedical= requestDetailsvar.Medical__c;
            prdwrap.prdDental= requestDetailsvar.Dental__c  ;
            prdwrap.prdVision= requestDetailsvar.Vision__c  ;
            prdwrap.prdRx = requestDetailsvar.Rx__c;
            prdwrap.prdHSA = requestDetailsvar.HSA__c;
            prdwrap.prdHMO = requestDetailsvar.HMO__c;
            prdwrap.prdPPO = requestDetailsvar.PPO__c;
            prdwrap.prdPOS = requestDetailsvar.POS__c;
            prdwrap.prdBasicLife = requestDetailsvar.Basic_Life__c;
            prdwrap.prdSTD = requestDetailsvar.STD__c;
            prdwrap.prdSTDBuyUp = requestDetailsvar.STD_Buy_Up__c;
            prdwrap.prdLTD = requestDetailsvar.LTD__c;
            prdwrap.prdLTDBuyUp = requestDetailsvar.LTD_Buy_Up__c;
            prdwrap.prdSDHP = requestDetailsvar.SDHP__c;
            prdwrap.prdMedicalSupplemental = requestDetailsvar.Medical_Supplemental__c;
            prdwrap.prdSupplementalEE = requestDetailsvar.Supplemental_EE_Life__c;
            prdwrap.prdSupplementalCH = requestDetailsvar.Supplemental_CH_Life__c;
            prdwrap.prdSupplementalSP = requestDetailsvar.Supplemental_SP_Life__c;
            prdwrap.prdStandalone = requestDetailsvar.Standalone__c;
            prdwrap.prdMedicalMarket = checkNUllinteger(integer.valueof(requestDetailsvar.Market_Site_Medical__c));
            prdwrap.prdVisionMarket = checkNUllinteger(integer.valueof(requestDetailsvar.Market_Site_Vision__c));
            prdwrap.prdDentalMarket = checkNUllinteger(integer.valueof(requestDetailsvar.Market_Site_Dental__c));
            prdwrap.prdMedicalSuppMarket = checkNUllinteger(integer.valueof(requestDetailsvar.Market_Site_med_suppl__c));
            prdwrap.prdRxMarket = checkNUllinteger(integer.valueof(requestDetailsvar.Market_Site_Rx__c));
            prdwrap.prdStandaloneMarket = checkNUllinteger(integer.valueof(requestDetailsvar.Market_Site_standalone__c));
            prdwrap.prdMedicalPVRC = requestDetailsvar.PVRC_Medical__c;
            prdwrap.prdVisionPVRC = requestDetailsvar.PVRC_Vision__c;
            prdwrap.prdDentalPVRC = requestDetailsvar.PVRC_Dental__c;
            prdwrap.prdMedicalSuppPVRC = requestDetailsvar.PVRC_Med_Suppl__c;
            prdwrap.prdRxPVRC = requestDetailsvar.PVRC_Rx__c;
            prdwrap.prdStandalonePVRC = requestDetailsvar.PVRC_standalone__c;
            //prdwrap.prdBasicLifePVRC = requestDetailsvar.pvrc
            prdwrap.prdSupplemental = requestDetailsvar.Supplemental_Life__c;
            prdwrap.prdSupplementalAmount = checkNUllfunction(string.valueof( requestDetailsvar.Flat_Amount_suppl_life__c));
            prdwrap.prdSupplementBenefitFactor = requestDetailsvar.Benefit_Factor_suppl_life__c;
            prdwrap.prdADnDAmount = checkNUllfunction(string.valueof(requestDetailsvar.Flat_Amount_suppl_ad_d__c));
            prdwrap.prdADnDBenefitFactor = requestDetailsvar.Benefit_Factor_suppl_ad_d__c;
            prdwrap.prdPlanCode = requestDetailsvar.Plan_Code__c;
            prdwrap.prdLocationCode = requestDetailsvar.Location_Code__c;
            prdwrap.prdDentalPlan = requestDetailsvar.Dental_Plan__c;
            prdwrap.prdSuppEEAmount =checkNUllfunction(string.valueof(requestDetailsvar.Suppl_EE_Benefit_Amount_Requested__c));
            prdwrap.prdSuppSPAmount = checkNUllfunction(string.valueof(requestDetailsvar.Suppl_SP_Benefit_Amount_Requested__c));
            prdwrap.prdSuppCHAmount = checkNUllfunction(string.valueof(requestDetailsvar.Suppl_CH_Benefit_Amount_Requested__c));
            prdwrap.prdOHSB = requestDetailsvar.OHSB_PRIME_LD_Class_Description__c;
            prdwrap.prdSupplementalADnD = requestDetailsvar.Supplemental_Life_AD_D__c==true?1:0;
        system.debug('..........'+prdwrap.prdSupplementalLifeADnD);
            if(requestDetailsvar.Family_Selection__c!=null){
                if(requestDetailsvar.Family_Selection__c.contains('Employee')){
                    prdwrap.prdFamilySelf = true;
                }
                if(requestDetailsvar.Family_Selection__c.contains('Spouse')){
                    prdwrap.prdFamilySpouse = true;
                }
                if(requestDetailsvar.Family_Selection__c.contains('Domestic Partner/Civil Union')){
                    prdwrap.prdFamilyPartner = true;
                }
                if(requestDetailsvar.Family_Selection__c.contains('Child(ren)')){
                    prdwrap.prdFamilyDependents = true;
                }
                
                prdwrap.prdFamilyChildCount = checkNUllfunction(string.valueOf(requestDetailsvar.Child_Count__c));
                
            }
            prdwrap.prdBLOC = requestDetailsvar.Basic_Life_Occupational_Class__c;
            prdwrap.prdBasicLifeAmount = checkNUllfunction(string.valueof( requestDetailsvar.flat_amount_basic__c));
            prdwrap.prdBasicLifeBenefitFactor = requestDetailsvar.Benefit_Factor_basic__c;           
            prdwrap.prdAddDate = string.valueof(requestDetailsvar.createddate).replace(' ','T');
           
            prdwrap.prdStatus = requestDetailsvar.ERM_Case_Status__c;
           return prdwrap;
}
    Public static ERM_RequestWrapper.ReportSelection  reportObject(Stream_Request_Details__c	 requestDetailsvar){
        ERM_RequestWrapper.ReportSelection reportWrap = new ERM_RequestWrapper.ReportSelection();
        
                    reportWrap.rptMedical = checkboolean(requestDetailsvar,'Medical'); 
                
               
                    reportWrap.rptDental = checkboolean(requestDetailsvar,'Dental'); 
                
               
                    reportWrap.rptVision = checkboolean(requestDetailsvar,'Vision'); 
                
                
                    reportWrap.rptRx = checkboolean(requestDetailsvar,'RX - Medco/Express Scripts'); 
                
                    reportWrap.rptGx = checkboolean(requestDetailsvar,'GX - OptumRx'); 
                
                    reportWrap.rptStandAlone = checkboolean(requestDetailsvar,'S - Stand Alone'); 
                
               
                    reportWrap.rptLife = checkboolean(requestDetailsvar,'Life');  
                
                reportWrap.rptSystem = requestDetailsvar.System__c;
                reportWrap.rptStartDate = String.valueof(requestDetailsvar.Report_Start_Date__c);
                reportWrap.rptStopDate =requestDetailsvar.Report_End_Date__c!=null? String.valueof(requestDetailsvar.Report_End_Date__c):'';
          
                    reportWrap.rptAddresses = checkreportneeded(requestDetailsvar,'Addresses');
     
                    reportWrap.rptAnnual_W2_Reporting = checkreportneeded(requestDetailsvar,'Annual W2 Reporting');
         
                    reportWrap.rptCBIZ_VBP_Eligibility_Report = checkreportneeded(requestDetailsvar,'CBIZ VBP Eligibility Report');
   
                    reportWrap.rptDHP_Elig_Report = checkreportneeded(requestDetailsvar,'DHP Elig Report');

                    reportWrap.rptED_Count_by_Age_Range = checkreportneeded(requestDetailsvar,'E/D Count by Age Range');
     
                    reportWrap.rptED_Count_by_Age_Range_Variable = checkreportneeded(requestDetailsvar,'E/D Count by Age Range (Variable)');

                    reportWrap.rptED_Count_by_Age_Range_Sex = checkreportneeded(requestDetailsvar,'E/D Count by Age Range, Sex');
      
                    reportWrap.rptED_Count_by_Mbrs_Covered = checkreportneeded(requestDetailsvar,'E/D Count by Mbrs Covered');
       
                    reportWrap.rptED_Count_by_Mkt_Site_Prod_Type = checkreportneeded(requestDetailsvar,'E/D Count by Mkt Site, Prod Type');

                    reportWrap.rptED_Count_by_PCP_MPIN = checkreportneeded(requestDetailsvar,'E/D Count by PCP MPIN');
         
                    reportWrap.rptED_Count_by_Prod_Type = checkreportneeded(requestDetailsvar,'E/D Count by Prod Type');
                
                    reportWrap.rptED_Count_by_Prod_Type_Mbrs_Cov = checkreportneeded(requestDetailsvar,'E/D Count by Prod Type, Mbrs Cov');
    
                    reportWrap.rptED_Count_by_Prod_Type_PVRC = checkreportneeded(requestDetailsvar,'E/D Count by Prod Type, PV/RC');
      
                    reportWrap.rptED_Count_by_PV_RC = checkreportneeded(requestDetailsvar,'E/D Count by PV/ RC');
  
                    reportWrap.rptED_Count_by_PVRC_Mbrs_Covered = checkreportneeded(requestDetailsvar,'E/D Count by PV/RC, Mbrs Covered');
         
                    reportWrap.rptED_Count_by_PVRC_State = checkreportneeded(requestDetailsvar,'E/D Count by PV/RC, State');
               
                    reportWrap.rptED_Count_by_Sex_Age = checkreportneeded(requestDetailsvar,'E/D Count by Sex, Age');
          
                    reportWrap.rptED_Count_by_State_ZIP = checkreportneeded(requestDetailsvar,'E/D Count by State, ZIP');
    
                    reportWrap.rptED_Count_by_Suffix_State = checkreportneeded(requestDetailsvar,'E/D Count by Suffix, State');
            
                    reportWrap.rptED_Count_by_Suffix_State_City = checkreportneeded(requestDetailsvar,'E/D Count by Suffix, State, City');
         
                    reportWrap.rptED_Count_by_UnderOver_65 = checkreportneeded(requestDetailsvar,'E/D Count by Under/Over 65');
         
                    reportWrap.rptED_Table_by_Mkt_Site =checkreportneeded(requestDetailsvar,'E/D Table by Mkt Site');
    
                    reportWrap.rptED_Table_by_PVRC_and_Cov_Type =checkreportneeded(requestDetailsvar,'E/D Table by PV/RC and Cov Type');
               
                    reportWrap.rptEDCount_by_Age = checkreportneeded(requestDetailsvar,'E/D Count by Age');
          
                    reportWrap.rptHarvard_Pilgrim_Roster = checkreportneeded(requestDetailsvar,'Harvard Pilgrim Roster');
        
                    reportWrap.rptMarketplace_Census = checkreportneeded(requestDetailsvar,'Marketplace Census');
              
                    reportWrap.rptMedicare_Report = checkreportneeded(requestDetailsvar,'Medicare Report');
        
                    reportWrap.rptMember_SSN_Collection_Report = checkreportneeded(requestDetailsvar,'Member SSN Collection Report');
                
                    reportWrap.rptName_and_Address_Report = checkreportneeded(requestDetailsvar,'Name and Address Report');
        
                    reportWrap.rptNew_Business_Report = checkreportneeded(requestDetailsvar,'New Business Report');
        
                    reportWrap.rptOne_Line_Edit_Report_Feedback_File = checkreportneeded(requestDetailsvar,'Feedback File');
               
                    reportWrap.rptPassport_Membership_Standard_Report = checkreportneeded(requestDetailsvar,'Passport Membership Standard Report');
              
                    reportWrap.rptPCP = checkreportneeded(requestDetailsvar,'PCP');
                               
                    reportWrap.rptPhone_Number_Report = checkreportneeded(requestDetailsvar,'Phone Number Report');
                
                    reportWrap.rptRetirees =checkreportneeded(requestDetailsvar,'Retirees');

                    reportWrap.rptRoster_Report =checkreportneeded(requestDetailsvar,'Roster Report');
                
                    reportWrap.rptSpreadsheet_Solutions_Template =  checkreportneeded(requestDetailsvar,'Spreadsheet Solutions Template');
                
                    reportWrap.rptSurviving_Spouses = checkreportneeded(requestDetailsvar,'Surviving Spouses');
                
                    reportWrap.rptCES_Member_Master = checkreportneeded(requestDetailsvar,'Member Master');
                
                reportWrap.rptPrivacyAttestation = requestDetailsvar.Privacy_Attestation__c;
                reportWrap.rptUnmaskSSN = requestDetailsvar.Unmasked_SSN_data_required__c;
                reportWrap.rptBusinessJustification = requestDetailsvar.Business_Justification_for_unmasked_SSN__c  ;
                reportWrap.rptPVRC = requestDetailsvar.PVRC__c  ;
                reportWrap.rptPVRCValues = requestDetailsvar.PVRC_Inclusions_Exclusions__c      ;
                reportWrap.rptEnvironment = requestDetailsvar.Environment__c        ;
        return reportWrap;
    }
    Public static boolean checkreportneeded(Stream_Request_Details__c	 requestDetailsvar ,string data){
        boolean reportneed = false;
        if(requestDetailsvar.Report_Needed_RG__c.contains(data)){
            reportneed = true;
        }
        return reportneed;
    }
   
    Public static ERM_RequestWrapper.Dependents_CPTIN depObject(ERM_RequestWrapper requestJSONWrapper ,List<Enrolees__c>enrolleList){
    ERM_RequestWrapper.Dependents_CPTIN dependentsWrapper = new ERM_RequestWrapper.Dependents_CPTIN();
        integer enrollecount = enrolleList.size();
                dependentsWrapper.Dep1FirstName = enrolleList[0].First_Name__c;
                dependentsWrapper.Dep1LastName = enrolleList[0].Last_Name__c;
                dependentsWrapper.Dep1DOB = checknullfunction(string.valueOf(enrolleList[0].Date_of_Birth__c));
                    dependentsWrapper.Dep1Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[0].Relationship_CPTIN_Dependent__c)); 
                 
                dependentsWrapper.dep1CPTIN = enrolleList[0].CPTIN__c;
                if(enrollecount>=2){
                    dependentsWrapper.Dep2FirstName = enrolleList[1].First_Name__c;
                    dependentsWrapper.Dep2LastName = enrolleList[1].Last_Name__c;
                    dependentsWrapper.Dep2DOB = checknullfunction(string.valueOf(enrolleList[1].Date_of_Birth__c));
                        dependentsWrapper.Dep2Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[1].Relationship_CPTIN_Dependent__c)); 
                    
                    dependentsWrapper.dep2CPTIN = enrolleList[1].CPTIN__c;
                }
                if(enrollecount>=3){
                    dependentsWrapper.Dep3FirstName = enrolleList[2].First_Name__c;
                    dependentsWrapper.Dep3LastName = enrolleList[2].Last_Name__c;
                    dependentsWrapper.Dep3DOB = checknullfunction(string.valueOf(enrolleList[2].Date_of_Birth__c));
                        dependentsWrapper.Dep3Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[2].Relationship_CPTIN_Dependent__c)); 
                    
                    dependentsWrapper.dep3CPTIN = enrolleList[2].CPTIN__c;
                }
                if(enrollecount>=4){
                    dependentsWrapper.Dep4FirstName = enrolleList[3].First_Name__c;
                    dependentsWrapper.Dep4LastName = enrolleList[3].Last_Name__c;
                    dependentsWrapper.Dep4DOB = checknullfunction(string.valueOf(enrolleList[3].Date_of_Birth__c));
                        dependentsWrapper.Dep4Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[3].Relationship_CPTIN_Dependent__c)); 
                    
                    dependentsWrapper.dep4CPTIN = enrolleList[3].CPTIN__c;
                }
                if(enrollecount>=5){
                    dependentsWrapper.Dep5FirstName = enrolleList[4].First_Name__c;
                    dependentsWrapper.Dep5LastName = enrolleList[4].Last_Name__c;
                    dependentsWrapper.Dep5DOB = checknullfunction(string.valueOf(enrolleList[4].Date_of_Birth__c));
                        dependentsWrapper.Dep5Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[4].Relationship_CPTIN_Dependent__c)); 
                    
                    dependentsWrapper.dep5CPTIN = enrolleList[4].CPTIN__c;
                }
                if(enrollecount>=6){
                    dependentsWrapper.Dep6FirstName = enrolleList[5].First_Name__c;
                    dependentsWrapper.Dep6LastName = enrolleList[5].Last_Name__c;
                    dependentsWrapper.Dep6DOB = checknullfunction(string.valueOf(enrolleList[5].Date_of_Birth__c));
                        dependentsWrapper.Dep6Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[5].Relationship_CPTIN_Dependent__c)); 
                    
                    dependentsWrapper.dep6CPTIN = enrolleList[5].CPTIN__c;
                }
                if(enrollecount>=7){
                    dependentsWrapper.Dep7FirstName = enrolleList[6].First_Name__c;
                    dependentsWrapper.Dep7LastName = enrolleList[6].Last_Name__c;
                    dependentsWrapper.Dep7DOB =checknullfunction(string.valueOf(enrolleList[6].Date_of_Birth__c));
                        dependentsWrapper.Dep7Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[6].Relationship_CPTIN_Dependent__c)); 
                     
                    dependentsWrapper.dep7CPTIN = enrolleList[6].CPTIN__c;
                }
                if(enrollecount>=8){
                    dependentsWrapper.Dep8FirstName = enrolleList[7].First_Name__c;
                    dependentsWrapper.Dep8LastName = enrolleList[7].Last_Name__c;
                    dependentsWrapper.Dep8DOB = checknullfunction(string.valueOf(enrolleList[7].Date_of_Birth__c));
                        dependentsWrapper.Dep8Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[7].Relationship_CPTIN_Dependent__c)); 
                    
                    dependentsWrapper.dep8CPTIN = enrolleList[7].CPTIN__c;
                }
                if(enrollecount>=9){
                    dependentsWrapper.Dep9FirstName = enrolleList[8].First_Name__c;
                    dependentsWrapper.Dep9LastName = enrolleList[8].Last_Name__c;
                    dependentsWrapper.Dep9DOB = checknullfunction(string.valueOf(enrolleList[8].Date_of_Birth__c));
                        dependentsWrapper.Dep9Relationship= integer.valueof(cptinrelationshipMap.get(requestJSONWrapper.elrplatform+':'+enrolleList[8].Relationship_CPTIN_Dependent__c)); 
                    
                    dependentsWrapper.dep9CPTIN = enrolleList[8].CPTIN__c;
                }
        return dependentsWrapper;
    }
    @AuraEnabled
    public Static string sendRequestToERM(String caseObjectId){   
        returnWrap wrapper = new returnWrap();
        try{
            ERM_RequestWrapper requestJSONWrapper=new ERM_RequestWrapper();           
            List<ERM_RequestWrapper.Enrollees> enroleeLstWrap=new List<ERM_RequestWrapper.Enrollees>();                      
            ERM_RequestWrapper.RequestDetails requestDetailsWrap =new ERM_RequestWrapper.RequestDetails();           
            List<ERM_RequestWrapper.Files> filesLstWrap=new List<ERM_RequestWrapper.Files>();            
            List<ERM_RequestWrapper.Notes> notesLstWrap=new List<ERM_RequestWrapper.Notes>();
            
            ERM_RequestWrapper.Products prdWrap = new ERM_RequestWrapper.Products();
            /*Querying case Information */      
            Case caseRec=[Select id,Policy__c,Subject_Group_ID__c,Group_Name__c,(Select id,OwnerId,Name,CreatedDate,RequestType__c,Plat_form__c,Requester__c,ReceiptDate__c,Qualifying_Event_Date__c,Date_Of_Hire__c,COBRA_Paid_Thru_Stop_Date__c,Policy_Number__c,Qualifying_Event_Reason__c,Explanation__c,ETS_BE_ISET_ACET_Request_ID__c,Estimated_Transactions__c,Caller_Phone__c,Caller_Name__c,Customer_Name__c,PSCustomerNumber__c,
                                                                                 Unmasked_SSN_data_required__c,Medical__c,Environment__c,PVRC_Inclusions_Exclusions__c,Business_Justification_for_unmasked_SSN__c,Privacy_Attestation__c,Report_Needed_RG__c,PVRC__c,Report_End_Date__c,Report_Start_Date__c,System__c,Coverage_Type__c,Dental__c,Vision__c,Subscriber_First_Name__c,Rx__c,HSA__c,HMO__c,PPO__c,POS__c,Basic_Life__c,STD__c,STD_Buy_Up__c,LTD__c,LTD_Buy_Up__c,SDHP__c,Medical_Supplemental__c,Supplemental_EE_Life__c,Supplemental_CH_Life__c,Supplemental_SP_Life__c,Standalone__c,Market_Site_Medical__c,Market_Site_Vision__c,Market_Site_Dental__c,Market_Site_med_suppl__c,Market_Site_standalone__c,PVRC_Medical__c,PVRC_Vision__c,PVRC_Dental__c,PVRC_Rx__c,PVRC_standalone__c,Supplemental_Life__c,Benefit_Factor_suppl_life__c,Flat_Amount_suppl_ad_d__c,Benefit_Factor_suppl_ad_d__c,Plan_Code__c,Location_Code__c,Dental_Plan__c,Suppl_EE_Benefit_Amount_Requested__c,Suppl_SP_Benefit_Amount_Requested__c,Suppl_CH_Benefit_Amount_Requested__c,OHSB_PRIME_LD_Class_Description__c,Supplemental_Life_AD_D__c,Basic_Life_Occupational_Class__c,Basic_Life_Benefit_Amount_Requested__c,ERM_Case_Status__c,Vendor__c,I_have_a_completed_form_document__c,CQER__c,Effective_Date__c,Is_Submitted__c,Name_of_person_authorizing_this_change__c,ExternalClientEmail__c,IEX__c,NICE_Company_Code__c,Report_Needed__c,Flat_Amount_suppl_life__c,Previous_Group_Number__c,Group_Phone_Number__c,INactivate_the_user_profile_abo__c,Group_Phone_Fax__c,
                                                                                 New_Physical_Address__c,New_Physical_City__c,PVRC_Med_Suppl__c,Market_Site_Rx__c,Benefit_Factor_basic__c,SSN__c,Alternate_ID__c,New_Physical_State__c,New_Physical_Zip__c,New_Billing_Address__c,New_Billing_City__c,New_Billing_State__c,New_Billing_Zip__c,Approver_s_Name__c,Approver_s_Title__c,Date_of_Birth__c,Employee_ID__c,Is_Policy_Transferred__c,New_Policy_Number__c,PRIME_Policy_Number_s_to_be_Terminated__c,PRIME_Customer_Number_s_to_Terminate__c,
                                                                                 PeopleSoft_Customer_Number_s_to_be_Term__c,First_Name__c,User_Email__c,User_Phone__c,Check_to_make_this_user_CMA__c,
                                                                                 No_Reporting__c,Communication_Center_Only__c,Medical_Group_Number_s__c,requesterdepartment__c,Middle_Name__c,
                                                                                 Count_of_Reports_Requested__c,User_First_Name__c,User_Last_Name__c,User_Email_Updated__c,Phone_Number__c,
                                                                                 Request_new_User_ID__c,Subscriber_Last_Name__c,Subscriber_CPTIN__c,Relationship__c,Last_Name__c,Street_Address__c,
                                                                                 Street_Address2__c,City__c,State__c,Zip__c,Check_for_Name_Address_Change__c,Division_Account_type__c,Reporting__c,
                                                                                 Reporting_Level__c,Access_Level_Confidential__c,CES_ASO_Only_Claims_EOB_View__c,Comments_or_Special_Instructions__c,
                                                                                 Please_check_the_acknowledgement__c,Name__c,Retro_Exclusion_Reason__c,Termination_Reason__c,Termination_Level__c,
                                                                                 Termination_Notes__c,Original_COBRA_Start_Date__c,Products_Same_for_All_Dependents__c,New_Platform__c,
                                                                                 Dependent_Count__c,PRIME_Policy_Number_s_to_Reinstate__c,PRIME_Customer_Number_s_to_Reinstate__c,
                                                                                 PeopleSoft_Number_s_to_Reinstate__c,DOL_Final_Rule_Exception__c,Integrated_Administration__c,Optum_ID__c,
                                                                                 Family_Selection__c,child_count__c,flat_amount_basic__c,Customer_Number__c,Request_Year__c,Invoice_Month_s_Needed__c,
                                                                                 Report_Dates_Requested_1__c,Report_Dates_Requested_2__c,Report_Dates_Requested__c,Additional_NICE_Policy_Number_s__c
                                                                                  from Request_Details__r),
                          (Select id,CreatedDate,Last_Name__c,Platform__c,Division_Account_type__c,Select_Division_Account_Change_Type__c,Policy__c,Employer_Name__c,Customer_Number__c,Communication_Center_Only__c,Permissions__c,Confirm_it_has_been_atleast_48_hours__c,Inactivate_Policy_Under_User__c,Discontinue_Paper__c,Bill_groups__c,Allow_Reporting__c,Reporting_Level__c,Access_Level_Confidential__c,Verify_the_selected_permissions__c,ESP_Enrollment__c,First_Name__c,Relationship__c,MiddleName__c,Name,PrimaryCarePhysician__c,SSN__c,Gender__c,Address__c,City__c,State__c,Zip__c,Date_of_Birth__c,CoordinationofBenefitsBegin_Date__c,CoordinationofBenefitsEnd_Date__c,PriorCoverageBeginDate__c,PriorCoverageEndDate__c,AnnualSalary__c,MedicarePartAStartDate__c,MedicarePartAEndDate__c,MedicarePartBStartDate__c,
                           MedicarePartBEndDate__c,MedicarePartDStartDate__c,MedicarePartDEndDate__c,HomePhone__c,PrimaryCareDentist__c,ExistingPatient__c,Employee_ID__c,Email__c,Plan_Code__c,DeliveryPreference__c,CorrectedUpdatedSSN__c,CPTIN__c,Request_Details__c from Enrollees__r) ,(Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComments)
                          from Case where id = : caseObjectId limit 1];
            
            caseRec.Status='Open';
            System.debug('caseRec@@'+caseRec.Enrollees__r);            
            Stream_Request_Details__c requestDetailsvar=caseRec.Request_Details__r;
            User usr=[select FederationIdentifier from User where id=:requestDetailsvar.OwnerId limit 1];
            
            List<Attachments__c>attachList = new List<Attachments__c>();
            //Get data from Custom Metadata and do Mapping
            for(ERM_To_Stream__mdt ermStreamMdt : [select id,Type__c,key__c,value__c from ERM_To_Stream__mdt]){
                if(ermStreamMdt.Type__c=='pltID'){
                    platformMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='rqtID'){
                    requestMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                    system.debug(',,,,,,,,,,,'+requestMap);
                }
                if(ermStreamMdt.Type__c=='vndID'){
                    vendorMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='genID'){
                    genderMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='relID'){
                    relationshipMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='msID'){
                    martialStatusMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='rteID'){
                    retroExclusiveMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='qerID'){
                    qualifiingMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='terID'){
                    terminationMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c=='terLevelID'){
                    terminationLevelMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }  
                if(ermStreamMdt.Type__c =='NiceccID'){
                    departmentmap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c =='CPTINrelID'){
                    cptinrelationshipMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c =='reptID'){
                    reportMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c =='DivID'){
                    divaccMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
                if(ermStreamMdt.Type__c =='reptID'){
                    reprtmap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);
                }
            }
            //Do call out for getting File attached from case and generate file name dynamically
            map<Id,string> contentDocIds = new map<Id,string>();
            List<ContentDocumentLink> contentDocLinkList=[SELECT ContentDocumentId,Id,LinkedEntityId,ShareType FROM ContentDocumentLink WHERE LinkedEntityId = :caseObjectId];
            for(ContentDocumentLink doclinks : contentDocLinkList){
                if(String.valueof(doclinks.LinkedEntityId).substring(0,3) !='02s' ){
                    contentDocIds.put(doclinks.ContentDocumentId,doclinks.LinkedEntityId);
                }
            }
            for(ContentVersion versiondata : [SELECT VersionData,PathOnClient,ContentDocumentId,contentdocument.description FROM ContentVersion
                                              WHERE ContentDocumentId in: contentDocIds.keyset()
                                              AND IsLatest = true and contentdocument.IsArchived=false]){
                                                  returnWrap attchresponsewrapper =new returnwrap();
                                                  attchresponsewrapper = uploadAttachmentstoERM(versiondata,'');
                                                  if(attchresponsewrapper.status != '0'){                                  
                                                      Attachments__c attwrap = new Attachments__c();
                                                      attwrap.name =   versiondata.PathOnClient ;
                                                      attwrap.Document_Id__c = versiondata.ContentDocumentId;
                                                      attwrap.case__c = contentDocIds.get(versiondata.ContentDocumentId);
                                                      attwrap.ERM_ServerPath__c = attchresponsewrapper.returnMessage;
                                                      attwrap.file_name__c = attchresponsewrapper.status;
                                                      attachList.add(attwrap);
                                                  }
                                                  
                                              }
            /****Prepare JSON Data Wrapper Mapping***/
           //ELR request Formation
           requestJSONWrapper = 	elrObject(requestDetailsvar,caserec,usr);
            //Enrollee data Assignment
             
            requestJSONWrapper.Enrollees=enrObject(requestJSONWrapper,requestDetailsvar,caserec);
            //Request Details Data Assignment       
            
            requestJSONWrapper.RequestDetails=erdObject(requestDetailsvar);        
            
            //Files Data Assignment :Need to to soql on attachements of cases and then do mapping
            for(Attachments__c attch:attachList){
                ERM_RequestWrapper.Files filesWrap= new ERM_RequestWrapper.Files();
                filesWrap.ErfDisplayName=attch.Name;
                filesWrap.ErfServerPath=attch.ERM_ServerPath__c;
                filesWrap.ErfFileName=attch.File_Name__c;
                filesWrap.ErfAddDate=string.valueof(attch.createddate);
                filesLstWrap.add(filesWrap);
            }
            requestJSONWrapper.Files=filesLstWrap;
          
            requestJSONWrapper.products=prdObject(requestDetailsvar);
            List<casecomment> commentlist = new List<casecomment>();
            for(CaseComment comm : caserec.CaseComments){ 
                ERM_RequestWrapper.Notes notesWrap= new ERM_RequestWrapper.Notes();
                 string commentbody=comm.CommentBody;
                notesWrap.hstDescription =commentbody;
                comm.IsPublished=true;
                commentlist.add(comm);
                notesLstWrap.add(notesWrap); 
            }
            
            requestJSONWrapper.Notes = notesLstWrap;
            
            if(requestDetailsvar.RequestType__c == 'CPTIN'){
                List<Enrolees__c> enrolleList =[select id,First_Name__c,Last_Name__c,
                                                Date_of_Birth__c,CPTIN__c,Relationship_CPTIN_Dependent__c,Platform__c,Policy__c,CreatedDate from Enrolees__c 
                                                where recordtype.name='CPTIN Dependents' and Request_Details__c=:requestDetailsvar.id];               
              if(enrolleList.size()>0){
              
                requestJSONWrapper.Dependents =depObject(requestJSONWrapper,enrolleList);
               }
            }
            if(requestDetailsvar.RequestType__c == dualPlatform){
                List<ERM_RequestWrapper.DualPlatformDetails>DPList = new List<ERM_RequestWrapper.DualPlatformDetails>();
                List<Enrolees__c> enrolleList =[select id,Platform__c,Policy__c,Plan_Code__c,CreatedDate from Enrolees__c
                                                where recordtype.name='Dual Platform Plan Codes' and Request_Details__c=:requestDetailsvar.id ];
                system.debug('.....enrolleList....'+enrolleList);
                for(Enrolees__c enrole : enrolleList){
                    ERM_RequestWrapper.DualPlatformDetails dualPlatformWrapper = new ERM_RequestWrapper.DualPlatformDetails();
                    dualPlatformWrapper.dualAddDate = string.valueof(enrole.CreatedDate);
                    dualPlatformWrapper.dualPolicy = enrole.Policy__c;
                    dualPlatformWrapper.dualPlanCode = enrole.Plan_Code__c;
                    
                    if(platformMap.containskey(enrole.Platform__c))
                        dualPlatformWrapper.dualPlatformId=integer.valueof(platformMap.get(enrole.Platform__c));
                    else
                        dualPlatformWrapper.dualPlatformId = null;
                    DPList.add(dualPlatformWrapper);
                    
                }
                requestJSONWrapper.dualPlatformDetails = DPList;
            }
            
            if(requestDetailsvar.RequestType__c == 'Report Generator'){
                ERM_RequestWrapper.ReportSelection reportWrap = new ERM_RequestWrapper.ReportSelection();
                
                requestJSONWrapper.ReportSelection = reportObject(requestDetailsvar);
            }
            if(requestDetailsvar.RequestType__c == 'W2 Report'){
                ERM_RequestWrapper.W2ReportSelection w2Wrap = new ERM_RequestWrapper.W2ReportSelection();
                w2Wrap.w2rptRequestYear =  requestDetailsvar.Report_Dates_Requested__c!= null?integer.valueof(requestDetailsvar.Report_Dates_Requested__c.split('/')[0]):2021;
                
                w2Wrap.w2rptReportDates2 =repordtDates(requestDetailsvar.Report_Dates_Requested_1__c);
                 w2Wrap.w2rptReportDates3 =repordtDates(requestDetailsvar.Report_Dates_Requested_2__c);
                w2Wrap.w2rptReportDates1 = repordtDates(requestDetailsvar.Report_Dates_Requested__c);
                w2Wrap.w2rptInvoiceMonth = w2Wrap.w2rptReportDates1.split('/')[0] ;
                w2Wrap.w2rptAdditionalNicePolicyNumbers=requestDetailsvar.Additional_NICE_Policy_Number_s__c;
                w2wrap.w2rptUnmaskSSN = requestDetailsvar.Unmasked_SSN_data_required__c;
                w2wrap.w2rptBusinessJustification = requestDetailsvar.Business_Justification_for_unmasked_SSN__c;
                w2wrap.w2rptPrivacyAttestation = requestDetailsvar.Privacy_Attestation__c;
                
                requestJSONWrapper.W2ReportSelection = w2wrap;
            }
            if(requestDetailsvar.Plat_form__c == 'EServices/Broker' || requestDetailsvar.Plat_form__c == 'EServices/Employer'){
                ERM_RequestWrapper.EServiceSelection eServicesWrapper = new ERM_RequestWrapper.EServiceSelection();
                eServicesWrapper.esrName = requestDetailsvar.Name__c;
                eServicesWrapper.esrAddress = requestDetailsvar.Street_Address__c;
                eServicesWrapper.esrAddress2 = requestDetailsvar.Street_Address2__c;
                eServicesWrapper.esrCity = requestDetailsvar.City__c;
                eServicesWrapper.esrState = requestDetailsvar.State__c;
                eServicesWrapper.esrZip = requestDetailsvar.Zip__c;
                eServicesWrapper.esrAddressChange = requestDetailsvar.Check_for_Name_Address_Change__c;
                eServicesWrapper.esrNameNew = requestDetailsvar.Name__c;
                eServicesWrapper.esrAddressNew = requestDetailsvar.Street_Address__c;
                eServicesWrapper.esrAddress2New = requestDetailsvar.Street_Address2__c;
                eServicesWrapper.esrCityNew = requestDetailsvar.City__c;
                eServicesWrapper.esrStateNew = requestDetailsvar.State__c;
                eServicesWrapper.esrZipNew = requestDetailsvar.Zip__c;
                eServicesWrapper.esrAccountType = requestDetailsvar.Division_Account_type__c!= null? integer.valueof(divaccMap.get(requestDetailsvar.Division_Account_type__c)):null;
                eServicesWrapper.esrAllowReporting = requestDetailsvar.reporting__c==true?1:0;
                
                eServicesWrapper.esrremoveReporting = requestDetailsvar.No_Reporting__c == true?1:0;
        
                                 

             eServicesWrapper.esrReportingLevelInd = requestDetailsvar.Reporting_Level__c != null?1:0;
            eServicesWrapper.esrAccessLevelInd =requestDetailsvar.Access_Level_Confidential__c==true?1:0; 
                eServicesWrapper.esrReportingLevel = requestDetailsvar.Reporting_Level__c != null ? integer.valueof(reprtmap.get(requestDetailsvar.Reporting_Level__c)):null;
                eServicesWrapper.esrAccessLevel =requestDetailsvar.Access_Level_Confidential__c==true?1:0; 
                eServicesWrapper.esrClaimsEOBView = requestDetailsvar.CES_ASO_Only_Claims_EOB_View__c;
                eServicesWrapper.esrUserID = usr.FederationIdentifier;
                eServicesWrapper.esrComments = requestDetailsvar.Comments_or_Special_Instructions__c;
                eServicesWrapper.esrAcknowledgement = requestDetailsvar.Please_check_the_acknowledgement__c;
                requestJSONWrapper.EServiceSelection = eServicesWrapper;
                List<Enrolees__c> polenrolleList = [Select id,CreatedDate,List_groups_here__c,User_ID__c,Discontinue_Paper__c,Last_Name__c,Platform__c,Division_Account_type__c,Select_Division_Account_Change_Type__c,Policy__c,Employer_Name__c,Customer_Number__c,Communication_Center_Only__c,Permissions__c,Confirm_it_has_been_atleast_48_hours__c,Inactivate_Policy_Under_User__c,Bill_groups__c,Allow_Reporting__c,Reporting_Level__c,Access_Level_Confidential__c,Verify_the_selected_permissions__c,ESP_Enrollment__c,First_Name__c,Relationship__c,MiddleName__c,Name,PrimaryCarePhysician__c,SSN__c,Gender__c,Address__c,City__c,State__c,Zip__c,Date_of_Birth__c,CoordinationofBenefitsBegin_Date__c,CoordinationofBenefitsEnd_Date__c,PriorCoverageBeginDate__c,PriorCoverageEndDate__c,AnnualSalary__c,MedicarePartAStartDate__c,MedicarePartAEndDate__c,MedicarePartBStartDate__c,
                                                    MedicarePartBEndDate__c,Verify_change_permission_existing_policy__c,Verify_update_useraccess_existing_policy__c,Request_Details__r.RequestType__c,MedicarePartDStartDate__c,All_users_have_same_permission_as_policy__c,MedicarePartDEndDate__c,HomePhone__c,PrimaryCareDentist__c,ExistingPatient__c,Employee_ID__c,Email__c,DeliveryPreference__c,CorrectedUpdatedSSN__c,CPTIN__c,Request_Details__c from Enrolees__c where Request_Details__c = :requestDetailsvar.id 
                                                    and recordtype.name='Policies'];
                List<ERM_RequestWrapper.EServicePolicies> policyWrapList = new List<ERM_RequestWrapper.EServicePolicies>();
                map<id,List<ERM_EServices_Policy_User__c>> userdataMap= new map<id,List<ERM_EServices_Policy_User__c>>();
                for(ERM_EServices_Policy_User__c userlist : [select id,Bill_groups__c,Policy__r.Policy__c,Communication_Center_Only__c,CreatedById,ESP_Enrollment__c,First_Name__c,LastModifiedById,Last_Name__c,List_groups_here__c,Name,OwnerId,Permissions__c,Platform__c,Policy__c,Re_enter_User_Email__c,Request_Details_Platform__c,Request_Type__c,Email__c,
                                                             User_ID__c,Phone_Number__c,Verify_the_selected_permissions__c 
                                                             from ERM_EServices_Policy_User__c where  Policy__r.recordtype.name='Policies' and Policy__r.Request_Details__c =:requestDetailsvar.id ]){
                 if(!userdataMap.containsKey(userlist.Policy__c)){
                     userdataMap.put(userlist.Policy__c, new list<ERM_EServices_Policy_User__c>{userlist});
                         }else{
                     userdataMap.get(userlist.Policy__c).add(userlist);      
                      }                                                                                                                                                                                        
                }
                for(Enrolees__c enrWrap : polenrolleList){
                    ERM_RequestWrapper.EServicePolicies polcywrap = new ERM_RequestWrapper.EServicePolicies();
                    polcywrap.espEServicePlatform = enrWrap.Platform__c;
                    polcywrap.espAccountType =enrWrap.Division_Account_type__c!= null? integer.valueof(divaccMap.get(enrWrap.Division_Account_type__c)):null;
                    polcywrap.espAccountTypeChange = enrWrap.Select_Division_Account_Change_Type__c!= null?integer.valueof(divaccMap.get(enrWrap.Select_Division_Account_Change_Type__c)):null;
                    polcywrap.espPolicy = enrWrap.Policy__c;
                    polcywrap.espUserID = enrWrap.User_ID__c;
		    polcywrap.espPaperInvoice = enrWrap.Discontinue_Paper__c == true?1:0;

                    polcywrap.espEmployerName = enrWrap.Employer_Name__c;
                    polcywrap.espCustomerNumber = enrWrap.Customer_Number__c;
                    polcywrap.espComminicationCenterOnly = enrWrap.Communication_Center_Only__c;
                    polcywrap.espSamePermissionAsPolicy = enrWrap.All_users_have_same_permission_as_policy__c;
                    if(enrWrap.Permissions__c !=null){
                        if(enrWrap.Permissions__c.contains('Eligibility Inquiry'))
                            polcywrap.espEligibilityInquiry = true;
                        else
                            polcywrap.espEligibilityInquiry = false;    
                        if(enrWrap.Permissions__c.contains('Eligibility Update'))
                            polcywrap.espEligibilityUpdate = true;
                        else
                            polcywrap.espEligibilityUpdate = false;   
                        if(enrWrap.Permissions__c.contains('eServices Electronic Eligibility (e3)'))
                            polcywrap.espE3 = true;
                        else
                            polcywrap.espE3 = false; 
                        
                        if(enrWrap.Permissions__c.contains('Claim View (ASO Only)'))
                            polcywrap.espClaimView = true;
                        else
                            polcywrap.espClaimView = false;    
                        if(enrWrap.Permissions__c.contains('Bill View'))
                            polcywrap.espBillView = true;
                        else
                            polcywrap.espBillView = false;   
                        if(enrWrap.Permissions__c.contains('Bill Pay'))
                            polcywrap.espBillPay = true;
                        else
                            polcywrap.espBillPay = false;  
                        
                        if(enrWrap.Permissions__c.contains('Banking'))
                            polcywrap.espBanking = true;
                        else
                            polcywrap.espBanking = false;    
                        
                        if(enrWrap.Permissions__c.contains('Reporting'))
                            polcywrap.espReporting = true;
                        else 
                            polcywrap.espReporting = false;   
                    }
                    polcywrap.espWait48Hours = enrWrap.Confirm_it_has_been_atleast_48_hours__c;
                    polcywrap.espInactivatePolicy = enrWrap.Inactivate_Policy_Under_User__c;
                    
                    polcywrap.espBillGroupDes = enrWrap.Bill_groups__c ;
                    polcywrap.espBillGroups = enrWrap.List_groups_here__c;
                    polcywrap.espAllowReporting = enrWrap.Allow_Reporting__c;
                    polcywrap.espReportingLevel = enrWrap.Reporting_Level__c != null ? integer.valueof(reprtmap.get(enrWrap.Reporting_Level__c)):null;
                    polcywrap.espAccessLevel = enrWrap.Access_Level_Confidential__c==true?1:0;
                    polcywrap.espAllUserHasSamePermission = enrWrap.All_users_have_same_permission_as_policy__c;
                    polcywrap.espVerification = checkverification(enrWrap);
                    polcywrap.espEnrollment = enrWrap.ESP_Enrollment__c; 
                    polcywrap.espsubmited = true;
                    List<ERM_RequestWrapper.EServiceUserSelection> ploicyuserList = new List<ERM_RequestWrapper.EServiceUserSelection>();
                    if(userdataMap.containsKey(enrWrap.id)){
                    for(ERM_EServices_Policy_User__c userdata:userdataMap.get(enrWrap.id) ){
                        ERM_RequestWrapper.EServiceUserSelection userwrap = new ERM_RequestWrapper.EServiceUserSelection();
                        userwrap.eupPolicyID= userdata.Policy__r.Policy__c;
                        userwrap.eupFirstName=userdata.First_Name__c;
                        userwrap.eupLastName=userdata.Last_Name__c;
                        userwrap.eupEmail=userdata.Email__c;
                        userwrap.eupPhone=userdata.Phone_Number__c;
                        userwrap.eupUserID=userdata.User_ID__c;
                        userwrap.eupComminicationCenterOnly=userdata.Communication_Center_Only__c;
                        userwrap.eupVerification = userdata.Verify_the_selected_permissions__c;
                        if(userdata.Permissions__c !=null){
                        if(userdata.Permissions__c.contains('Eligibility Inquiry'))
                            userwrap.eupEligibilityInquiry = true;
                        else
                            userwrap.eupEligibilityInquiry = false;    
                        if(userdata.Permissions__c.contains('Eligibility Update'))
                            userwrap.eupEligibilityUpdate = true;
                        else
                            userwrap.eupEligibilityUpdate = false;   
                        if(userdata.Permissions__c.contains('eServices Electronic Eligibility (e3)'))
                            userwrap.eupE3 = true;
                        else
                            userwrap.eupE3 = false; 
                        
                        if(userdata.Permissions__c.contains('Claim View (ASO Only)'))
                            userwrap.eupClaimView = true;
                        else
                            userwrap.eupClaimView = false;    
                        if(userdata.Permissions__c.contains('Bill View'))
                            userwrap.eupBillView = true;
                        else
                            userwrap.eupBillView = false;   
                        if(userdata.Permissions__c.contains('Bill Pay'))
                            userwrap.eupBillPay = true;
                        else
                            userwrap.eupBillPay = false;  
                        
                        if(userdata.Permissions__c.contains('Banking'))
                            userwrap.eupBanking = true;
                        else
                            userwrap.eupBanking = false;    
                        
                        if(userdata.Permissions__c.contains('Reporting'))
                            userwrap.eupReporting = true;
                        else 
                            userwrap.eupReporting = false;   
                    }
                        userwrap.eupSubmited=true;
                        userwrap.eupAccessLevel =0;
                        userwrap.eupBillGroupDes= userdata.Bill_groups__c;
                        userwrap.eupBillGroups=userdata.List_groups_here__c;

                        ploicyuserList.add(userwrap);
                    }
                        
                    }
                    polcywrap.EServicePolicyUsers = ploicyuserList;
                    
                    policyWrapList.add(polcywrap);
                }
                requestJSONWrapper.EServicePolicies=policyWrapList;
                
                ERM_RequestWrapper.EServiceUserSelection userwrap = new ERM_RequestWrapper.EServiceUserSelection();
                userwrap = eupObject(requestDetailsvar);
                requestJSONWrapper.EServiceUserSelection=userwrap;
                System.debug('request wrapper@@'+JSON.serialize(requestJSONWrapper));
                
                
            }
             System.debug('request wrapper@@'+JSON.serialize(requestJSONWrapper));
            wrapper = doPostCallouttoERM(requestDetailsvar.id,caserec.id,JSON.serialize(requestJSONWrapper),attachList,commentlist);
            
        }catch(exception e){
            wrapper.status='0';
            wrapper.returnMessage = e.getMessage();
        }
        return json.serialize(wrapper) ;
    }
    Public static boolean checkverification(Enrolees__c enrwrap){
        boolean verifcation = false;
        if(enrwrap.Request_Details__r.RequestType__c != changepolicy
          && enrwrap.Request_Details__r.RequestType__c != useraccess
          && enrwrap.Request_Details__r.RequestType__c != changeemppolicy){
            verifcation = enrwrap.Verify_the_selected_permissions__c;
        }
        if(enrwrap.Request_Details__r.RequestType__c == changepolicy
          ||enrwrap.Request_Details__r.RequestType__c == changeemppolicy){
            verifcation = enrwrap.Verify_change_permission_existing_policy__c;
        }
        if(enrwrap.Request_Details__r.RequestType__c == useraccess){
            verifcation = enrwrap.Verify_update_useraccess_existing_policy__c;
        }
        return verifcation;
    }
    Public static ERM_RequestWrapper.EServiceUserSelection eupObject(Stream_Request_Details__c	 requestDetailsvar ){
        ERM_RequestWrapper.EServiceUserSelection userwrap = new ERM_RequestWrapper.EServiceUserSelection();
        userwrap.eupPolicyID= requestDetailsvar.Policy_Number__c;
                userwrap.eupFirstName=requestDetailsvar.First_Name__c;
                userwrap.eupLastName=requestDetailsvar.Last_Name__c;
                userwrap.eupEmail=requestDetailsvar.User_Email__c;
                userwrap.eupPhone=requestDetailsvar.User_Phone__c;
        		userwrap.eupFirstNameNew=requestDetailsvar.User_First_Name__c;
                userwrap.eupLastNamenew=requestDetailsvar.User_Last_Name__c;
                userwrap.eupEmailnew=requestDetailsvar.User_Email_Updated__c;
                userwrap.eupPhonenew=requestDetailsvar.Phone_Number__c;
        		userwrap.eupUserIDNew = requestDetailsvar.Request_new_User_ID__c;


        if(requestDetailsvar.requesttype__c =='Update/Inactivate/Reactivate an Existing User Profile'
          || requestDetailsvar.requesttype__c =='Add/Update Multiple Policies to an Existing User Profile'){
            userwrap.eupUserID=requestDetailsvar.Optum_ID__c;
        }else{
                userwrap.eupUserID=requestDetailsvar.Employee_ID__c;
        }
                userwrap.eupCustomerNumber = requestDetailsvar.Customer_Number__c;
				userwrap.eupPolicy =requestDetailsvar.Policy_Number__c;
                if(requestDetailsvar.INactivate_the_user_profile_abo__c== 'INactivate the user profile'){
                    userwrap.eupInactivate = true;
                }
                if(requestDetailsvar.INactivate_the_user_profile_abo__c== 'REactivate the user profile'){
                    userwrap.eupReactivate = true;
                }
				userwrap.eupFirstNameNewInd = requestDetailsvar.User_First_Name__c!=null?true:false;
        		userwrap.eupLastNameNewInd = requestDetailsvar.User_Last_Name__c!=null?true:false;
        		userwrap.eupPhoneNewInd = requestDetailsvar.User_Phone__c!=null?true:false;
        		userwrap.eupUserIDNewInd = requestDetailsvar.Request_new_User_ID__c!=null?true:false;
        		userwrap.eupEmailNewInd = requestDetailsvar.User_Email_Updated__c!=null?true:false;
        


                userwrap.eupComminicationCenterOnly=requestDetailsvar.Communication_Center_Only__c;
                userwrap.eupIsCMA=requestDetailsvar.Check_to_make_this_user_CMA__c;
        		userwrap.eupremoveReporting = requestDetailsvar.No_Reporting__c == true?1:0;
        
           userwrap.eupreportinglevel = requestDetailsvar.Reporting_Level__c != null ? integer.valueof(reprtmap.get(requestDetailsvar.Reporting_Level__c)):null;
                                 

             userwrap.eupreportinglevelind = requestDetailsvar.Reporting_Level__c != null?1:0;
            userwrap.eupAccessLevelInd = requestDetailsvar.Access_Level_Confidential__c == true?1:0;
        
            if(userwrap.eupAccessLevelInd == 1){
                userwrap.eupAccessLevel = 1;
            }
            
        
        
        		

        return userWrap;
    }
    Public static returnWrap doPostCallouttoERM(string reqid , string caseid,String requestJSONWrapper,List<Attachments__c> attachList,list<casecomment>commentlist){
        string returnMessage='';
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'ERMCreateRequest';
        wsCallOutFW.requestBody = requestJSONWrapper;
        HttpResponse  response = wsCallOutFW.getResponse();
        returnWrap wrapper = new returnWrap();
        
        try {
            if(response.getStatusCode() == 200){
                wrapper.status='200';
                wrapper.returnMessage = response.getBody().split(':')[1];
                
                Stream_Request_Details__c reqDetails = new Stream_Request_Details__c();
                reqDetails.Is_Submitted__c = true;
                reqDetails.id=reqid;
                update reqDetails;
                
                system.debug('..........'+attachList);
                if(attachList.size()>0){
                    insert attachList;
                }
                if(commentlist.size()>0){
                    update commentlist;
                    }
                updateCase(caseid,wrapper.returnMessage);
            }
            else if(response.getStatusCode() == 501){
                map<string,object>errorParsing = (map<string,object>)json.deserializeUntyped(response.getBody());
                wrapper.status='0';
                wrapper.returnMessage = (string)errorParsing.get('ErrorMessage');
            }
            else{
                wrapper.status='0';
                wrapper.returnMessage = response.getstatus();
            }
            
            System.debug('HTTP Response Code: ' + response.getStatusCode());
            System.debug('Response Body: ' + response.getBody()); 
        } catch (Exception e) {
            wrapper.status='0';
            
            wrapper.returnMessage = e.getMessage();
                      
        }
        
        return wrapper;
    }
    
    @future
    Public static void updateCase(string caseid,string referenceid){
        Case updateCase = new Case();       
        updateCase.id=caseid;
        updatecase.status='Open';
        updatecase.No_More_Comments__c = true;
        updatecase.External_Reference_ID__c = referenceid;
        update updatecase;
    }
    
    /*Method will be called by Trigger : ERM_permissionValidation */
    Public static void validatePermission(List<ERM_EServices_Policy_User__c> policyId){        
        Set<id> eServicePolicyId=new set<id>();
        for(ERM_EServices_Policy_User__c eSer: policyId){
            eServicePolicyId.add(eSer.Policy__c);
        }           
        try{
            List<Enrolees__c> enroleeLst=[select id , Permissions__c from Enrolees__c where id=:eServicePolicyId Limit 1];
            System.debug('enroleeLst==='+enroleeLst);
            
            for(ERM_EServices_Policy_User__c eServ:policyId){
                if(eServ.Permissions__c==null){
                    system.debug('debugging eserv'+eServ.Permissions__c);
                }else{
                    List<String> lstAlpha2 = eServ.Permissions__c.split(';');
                    for(String strAlpha:lstAlpha2){
                        if(!enroleeLst[0].Permissions__c.contains(strAlpha)){
                            eServ.Permissions__c.addError(errorMessage);
                        }
                    } 
                }
            }
            
        }catch(Exception e){
            System.Debug('The following error occured' + e);
        }
        
    }
    public static string checkNUllFUnction(string paramName){
        paramName = paramName != null ? paramName : '';
        return paramName;
    }
    public static integer checkNUllinteger(integer paramName){
        paramName = paramName != null ? paramName : 0;
        return paramName;
    }

    @AuraEnabled
    Public static Stream_Request_Details__c getStreamrequestdata(string caseId){
        Stream_Request_Details__c requestDetails = [select Appealed__c,Case__r.Status from Stream_Request_Details__c where Case__c=: caseId];
        return requestDetails;
    }
    
    @AuraEnabled  
    Public Static returnWrap appealDataInsertion(String CaseObjId,String appealPickVal,String appealNotes){
        System.debug('values==='+ ' ' +CaseObjId+ ' ' +appealPickVal+ ' ' +appealNotes);
        
        Case caseRec=[Select id,Status,External_Reference_ID__c from Case where id=:CaseObjId limit 1];
        DateTime todaysDate = System.today();
        
        Map<string,string>appealMap = new Map<String,string>();
        
        for(ERM_To_Stream__mdt ermStreamMdt:[Select id,Type__c,key__c,value__c from ERM_To_Stream__mdt where Type__c='appeaID']){
            appealMap.put(ermStreamMdt.value__c,ermStreamMdt.Key__c);               
        }
        Integer appealReasonCode;
        if(appealMap.containskey(appealPickVal)){
            appealReasonCode=Integer.valueof(appealMap.get(appealPickVal));
        }
        
        appealwrapCls apealWrapJSON=new appealwrapCls();
        apealWrapJSON.aplRequestID=Integer.valueof(caseRec.External_Reference_ID__c);
        apealWrapJSON.aplReasonCode=appealReasonCode;
        apealWrapJSON.aplReasonNotes=appealNotes;
        apealWrapJSON.aplAddBy=0;
        apealWrapJSON.aplAddDate=String.valueof(todaysDate);
        system.debug('appealData===' +JSON.serialize(apealWrapJSON));
        
        string returnMessage='';
        string url='';
        returnWrap wrapper = new returnWrap();
         
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'ERMAppealRequest';
        wsCallOutFW.requestBody = JSON.serialize(apealWrapJSON);
        HttpResponse  response = wsCallOutFW.getResponse();
       
        
        try {
            
            System.debug('body==' +response.getBody()); 
            if(response.getStatusCode() == 200){
                insertAppealData(CaseObjId,todaysDate,appealPickVal,appealNotes);
                wrapper.status='200';
                wrapper.returnMessage = response.getBody();                              
            } else if(response.getStatusCode() == 501){
                map<string,object>errorParsing = (map<string,object>)json.deserializeUntyped(response.getBody());
                wrapper.status='0';
                wrapper.returnMessage = (string)errorParsing.get('ErrorMessage');
            } else{
                wrapper.status='0';
                wrapper.returnMessage = response.getstatus();
            }            
            System.debug('HTTP Response Code: ' + response.getStatusCode()); 
            System.debug('Response Body: ' + response.getBody());   
        } catch(System.CalloutException e) {
            wrapper.status='0';           
            wrapper.returnMessage = e.getMessage();
            
        }        
        return wrapper;
    }
    Public class w2reportsdata {
        Public string reportDates;
        Public string requestyear;
        Public string invoicemonths;
    }
    Public static string repordtDates(string reprtdate){
        string reportDates ='';
        if(reprtdate !=null){
        string[] reprtdateList = reprtdate.split('/');
        Map<string,string> mapwithMonths = new Map<string,string>();
        mapwithMonths.put('January', '01');
        mapwithMonths.put('February', '02');
        mapwithMonths.put('March', '03');
        mapwithMonths.put('April', '04');
        mapwithMonths.put('May', '05');
        mapwithMonths.put('June', '06');
        mapwithMonths.put('July', '07');
        mapwithMonths.put('August', '08');
        mapwithMonths.put('September', '09');
         mapwithMonths.put('October', '10');
         mapwithMonths.put('November', '11');
        mapwithMonths.put('December', '12');
        for(integer i=0;i<reprtdateList[1].split(';').size();i++){
		string monthname =  reprtdateList[1].split(';')[i];           
            if(reprtdateList[1].split(';').size()>1){
        reportDates = reportDates+  mapwithMonths.get(monthname)+'/'+reprtdateList[0]+',';
            }else{
              reportDates = reportDates+  mapwithMonths.get(monthname)+'/'+reprtdateList[0];
            }
            }
        }
        return reportDates;
    }
    Public static  boolean  checkboolean(Stream_Request_Details__c	requestDetailsvar ,string checkboolean){
        boolean check=false;
        if(requestDetailsvar.Coverage_Type__c.contains(checkboolean)){
            check=true;
        }
        return check;
    }
    Public static void insertAppealData(String caseid,Datetime todaysDate,String appealPickVal,String appealNotes){
        
        Stream_Request_Details__c streamReqRecord=[Select id,Case__r.IsEscalated,Case__r.External_Reference_ID__c,Bypass_Validation_Rule__c,Appeal_Notes__c,Appeal_Date__c,Appeal_Reason__c,Appealed__c,Case__r.Status from  Stream_Request_Details__c where Case__c =:caseid LIMIT 1];
        
        Case caseRec = new Case();
        caseRec.Status='Open';
        caseRec.id=caseid;
        caseRec.No_More_Comments__c=true;
        update caseRec;
        
        if(streamReqRecord!=null){
            streamReqRecord.Appeal_Notes__c=appealNotes;
            streamReqRecord.Appealed__c=true;
            streamReqRecord.Appeal_Reason__c=appealPickVal;
            streamReqRecord.Appeal_Date__c=Date.valueOf(todaysDate);
            streamReqRecord.Bypass_Validation_Rule__c=true;
            update streamReqRecord;                
        }
        
    }
    
    /* All Wrapper classes */
    
    Public class returnWrap {
        Public string status;
        Public string returnMessage;
    }  
    
    Public class appealwrapCls{
        Public Integer aplRequestID;
        Public Integer aplReasonCode;
        Public String aplReasonNotes;
        Public Integer aplAddBy;
        Public String aplAddDate;        
    }
    Public class requestDetails{
        @AuraEnabled Public string platform;
        @AuraEnabled Public string reqType;
        @AuraEnabled public string reqid;
    }
    
   
    
    public class enrolleeWrapper{
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String middleName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String SSN {get;set;}
        @AuraEnabled public String updatedSSN {get;set;}
        @AuraEnabled public Date DateOfBirth {get;set;}
        @AuraEnabled public String EmployeeId {get;set;}
        @AuraEnabled public String gender {get;set;}
        @AuraEnabled public String address {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String zip {get;set;}
        @AuraEnabled public String relationship {get;set;} 
        @AuraEnabled public String HomePhone {get;set;} 
        @AuraEnabled public String PrimaryCarePhysician {get;set;} 
        @AuraEnabled public String PrimaryCareDentist {get;set;} 
        @AuraEnabled public Integer anuualSalary {get;set;} 
        @AuraEnabled public Date cobBeginDate {get;set;} 
        @AuraEnabled public Date cobEndDate {get;set;} 
        @AuraEnabled public Date medCareAStrtDate {get;set;} 
        @AuraEnabled public Date medCareAEndDate {get;set;} 
        @AuraEnabled public Date medCareBStrtDate {get;set;} 
        @AuraEnabled public Date medCareBEndDate {get;set;} 
        @AuraEnabled public Date medCareDStrtDate {get;set;} 
        @AuraEnabled public Date medCareDEndDate {get;set;} 
        @AuraEnabled public Date priorCovBegnDate {get;set;} 
        @AuraEnabled public Date priorCovEndDate {get;set;}
        @AuraEnabled public String deliveryPreffered {get;set;}
        @AuraEnabled public String emailAttr {get;set;}
        @AuraEnabled public Boolean existingPatient {get;set;}
    }
    
    public class SearchResultWrapper1{       
        @AuraEnabled public SAEMemberProviderSearchCoveragesResult resultWrapper {get;set;}
        @AuraEnabled public Integer statusCode{get;set;}
        @AuraEnabled public String message{get;set;}                
        @AuraEnabled public Boolean hasAccess{get;set;}      
        @AuraEnabled public SAEHouseHoldWrapper resultWrapper1 {get;set;}
    }
    
    Public class attachmentWrapper{
        Public string serverPath;
        Public string fileName;
        
    }
    
    public class pendedWrap{
        Public String requestID;
        Public String requestStatus;
        
    }
}