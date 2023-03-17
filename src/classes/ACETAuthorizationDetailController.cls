public with sharing class ACETAuthorizationDetailController extends ACETErrorHandler {
    
    public Interaction__c Interaction { get; set;}
    public Contact Subject {get;set;}
    public String SourceOriginator {get;set;}
    public String CaseReason {get;set;}
    public String CasesStatus {get;set;}      
    public String Expected_Dscharg_Date {get;set;}     
    public String ExpectedDischargeDate {get;set;} 
    public String ActualDschargDate {get;set;}  
    public String ExpectedAdmitDate {get;set;}
    public String AuthId {get;set;}
    public String ActualAdmitDate {get;set;}
    public String PreDetermination {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public list<ACETAuthorizationSearchResult> lstAcetAuthorization{get;set;}
    public string AuthorizationNumber {get;set;}
    public string AuthorizationType {get;set;}
    public string XrefId {get;set;}
    public string SRK {get;set;}
    public list<InnerNotes> lstInnerNotes {get;set;}
    public list<InnerFacilityLine> lstInnerFacilityLine {get;set;}
    public String hpAdditionInfoStr {get;set;}    
    public string strType {get;set;}
    public boolean InpatientDisplay  {get;set;}
    public boolean OutpatientDisplay  {get;set;}
    public boolean OutpatientFacilityDisplay  {get;set;}
    public set<String> externalids{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETCaseItemWrapper caseItem {get;set;}
    public Boolean allowedUser {get;set;}            // Added for US961280 
    public Boolean isResearchUser {get;set;}        // Added for US961280 
    public String baseURL{get;set;}                // Added for US1041621 
    
    public ACETAuthorizationDetailController(ACETCallTopicCreateCaseItem controller) {
      string surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
    if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        } 
        
        System.debug(controller.caseitemwrap);
        System.debug('authorization number ' + ApexPages.currentPage().getParameters().get('AuthorizationNumber'));
        init();
    }
    
    public ACETAuthorizationDetailController() {
        //System.debug(controller.caseitemwrap);
        //System.debug('authorization number ' + ApexPages.currentPage().getParameters().get('AuthorizationNumber'));
        //init();
    }
    public void init() {
        Interaction = new Interaction__c();
        //AuthorizationDetail = new ACETAuthorizationDetailResult();
        
        lstInnerFacilityLine     = new list<InnerFacilityLine>(); 
        
        Subject = new Contact();
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AuthorizationNumber = ApexPages.currentPage().getParameters().get('AuthorizationNumber');
        CaseReason = ApexPages.currentPage().getParameters().get('caseStatusReason');
        PreDetermination = ApexPages.currentPage().getParameters().get('PreDetermination');
        CasesStatus = ApexPages.currentPage().getParameters().get('caseStatusReason');     
        ActualDschargDate = ApexPages.currentPage().getParameters().get('ActualDschargDate');          
        System.debug('@@MnZ: '+CaseReason);
        ExpectedDischargeDate = ApexPages.currentPage().getParameters().get('ExpectedDischargeDate');
        ActualAdmitDate = ApexPages.currentPage().getParameters().get('ActualAdmitDate'); 
        ExpectedAdmitDate = ApexPages.currentPage().getParameters().get('ExpectedAdmitDate');          
        AuthId = ApexPages.currentPage().getParameters().get('AuthId');
        AuthorizationType=ApexPages.currentPage().getParameters().get('Type');
        XrefId=ApexPages.currentPage().getParameters().get('XrefId');
        SRK=ApexPages.currentPage().getParameters().get('SRK');
        caseItem = new ACETCaseItemWrapper();
        caseItem.caseObj = new Case();
        caseItem.caseObj.topic__c = 'View Authorizations';
        caseItem.topic = caseItem.caseObj.topic__c ;
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            system.debug('*****Interaction *****'+Interaction);
            
            SourceOriginator = Interaction.Interaction_Type__c;
            
            system.debug('********SourceOriginator ********'+SourceOriginator);            
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
            system.debug('*****subject *****'+subject );
        }
        
        strType = ApexPages.currentPage().getParameters().get('Type');
        string strauthDeailInfo = ApexPages.currentPage().getParameters().get('authDeailInfo');
        //@Rama: Added code to remove 'null' coming as string in the url Parameters
        strauthDeailInfo = strauthDeailInfo.remove('null');
        ACETAuthorizationSearchResult objAcetAuthrizationResult = new ACETAuthorizationSearchResult();
        if(!String.isEmpty(strType)){
            if(strType=='InpatientCases'){
                list<string> lstAuthDetail = strauthDeailInfo.split('_');
                objAcetAuthrizationResult.Authorization_Number = !string.isEmpty(lstAuthDetail[0])?lstAuthDetail[0]:'';
                objAcetAuthrizationResult.Case_Status  = !string.isEmpty(lstAuthDetail[1])?lstAuthDetail[1]:'';
                objAcetAuthrizationResult.Pre_Determination = !string.isEmpty(lstAuthDetail[2])?lstAuthDetail[2]:'';
                objAcetAuthrizationResult.Create_Date = !string.isEmpty(lstAuthDetail[3])?lstAuthDetail[3]:'';
                objAcetAuthrizationResult.Expected_Admit_Date = !string.isEmpty(lstAuthDetail[4])?lstAuthDetail[4]:'';
                objAcetAuthrizationResult.Actual_Admit_Date = !string.isEmpty(lstAuthDetail[5])?lstAuthDetail[5]:'';
                objAcetAuthrizationResult.Expected_Dscharg_Date = !string.isEmpty(lstAuthDetail[6])?lstAuthDetail[6]:'';
                objAcetAuthrizationResult.Actual_Dscharg_Date = !string.isEmpty(lstAuthDetail[7])?lstAuthDetail[7]:'';
                
                objAcetAuthrizationResult.Facility_Status = !string.isEmpty(lstAuthDetail[8])?lstAuthDetail[8]:'';
                objAcetAuthrizationResult.Primary_Diagnosis = !string.isEmpty(lstAuthDetail[9])?lstAuthDetail[9]:'';
                objAcetAuthrizationResult.POS =  !string.isEmpty(lstAuthDetail[10])?lstAuthDetail[10]:'';
                objAcetAuthrizationResult.ServiceDescDetail = !string.isEmpty(lstAuthDetail[11])?lstAuthDetail[11]:'';
                objAcetAuthrizationResult.LOS = !string.isEmpty(lstAuthDetail[12])?lstAuthDetail[12]:'';
                
                
                InpatientDisplay  = true;
            }
            else if(strType=='OutpatientFacilityCases'){
                list<string> lstAuthDetail = strauthDeailInfo.split('_');
                objAcetAuthrizationResult.Authorization_Number = !string.isEmpty(lstAuthDetail[0])?lstAuthDetail[0]:'';
                objAcetAuthrizationResult.Case_Status  = !string.isEmpty(lstAuthDetail[1])?lstAuthDetail[1]:'';
                objAcetAuthrizationResult.Pre_Determination = !string.isEmpty(lstAuthDetail[2])?lstAuthDetail[2]:'';
                
                objAcetAuthrizationResult.ServiceProvider = !string.isEmpty(lstAuthDetail[3])?lstAuthDetail[3]:'';
                objAcetAuthrizationResult.Primary_Diagnosis = !string.isEmpty(lstAuthDetail[4])?lstAuthDetail[4]:'';
                objAcetAuthrizationResult.Procedure_Code = !string.isEmpty(lstAuthDetail[5])?lstAuthDetail[5]:'';
                objAcetAuthrizationResult.POS = !string.isEmpty(lstAuthDetail[6])?lstAuthDetail[6]:'';
                objAcetAuthrizationResult.ServiceDescDetail = !string.isEmpty(lstAuthDetail[7])?lstAuthDetail[7]:'';
                
                
                
                OutpatientFacilityDisplay  = true;
            }
            else if(strType=='OutpatientCases'){
                list<string> lstAuthDetail = strauthDeailInfo.split('_');
                objAcetAuthrizationResult.Authorization_Number = !string.isEmpty(lstAuthDetail[0])?lstAuthDetail[0]:'';
                objAcetAuthrizationResult.Case_Status  = !string.isEmpty(lstAuthDetail[1])?lstAuthDetail[1]:'';
                objAcetAuthrizationResult.Pre_Determination = !string.isEmpty(lstAuthDetail[2])?lstAuthDetail[2]:'';
                objAcetAuthrizationResult.Create_Date = !string.isEmpty(lstAuthDetail[3])?lstAuthDetail[3]:'';
                objAcetAuthrizationResult.Start_Date = !string.isEmpty(lstAuthDetail[4])?lstAuthDetail[4]:'';
                objAcetAuthrizationResult.End_Date = !string.isEmpty(lstAuthDetail[5])?lstAuthDetail[5]:'';
                objAcetAuthrizationResult.ServiceProviderStatus = !string.isEmpty(lstAuthDetail[6])?lstAuthDetail[6]:'';
                objAcetAuthrizationResult.Primary_Diagnosis = !string.isEmpty(lstAuthDetail[7])?lstAuthDetail[7]:'';
                objAcetAuthrizationResult.Procedure_Code = !string.isEmpty(lstAuthDetail[8])?lstAuthDetail[8]:'';
                objAcetAuthrizationResult.Count = !string.isEmpty(lstAuthDetail[9])?lstAuthDetail[9]:'';
                objAcetAuthrizationResult.POS = !string.isEmpty(lstAuthDetail[10])?lstAuthDetail[10]:'';
                objAcetAuthrizationResult.ServiceDescDetail = !string.isEmpty(lstAuthDetail[11])?lstAuthDetail[11]:'';
                
                OutpatientDisplay = true;
            }
        }
        
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        
        //ViewAuthorization
        string viewAuthorization = ApexPages.currentPage().getParameters().get('ViewAuthorization');
        
        lstAcetAuthorization = new list<ACETAuthorizationSearchResult>();
        lstAcetAuthorization.add(objAcetAuthrizationResult); 
        
        String consumerAccountIndicator = ApexPages.currentPage().getParameters().get('consumerAccountIndicator');
        string dob = ApexPages.currentPage().getParameters().get('dob');
        system.debug('--------160--'+dob);
        string effectiveDate = ApexPages.currentPage().getParameters().get('effectiveDate');
        string endDate = ApexPages.currentPage().getParameters().get('endDate');
        string groupNumber = ApexPages.currentPage().getParameters().get('GroupNumber');
         system.debug('--------100--'+GroupNumber);
        string groupName = ApexPages.currentPage().getParameters().get('groupName');
        string Network   = ApexPages.currentPage().getParameters().get('Network');
        string OriginatorRelationship = ApexPages.currentPage().getParameters().get('OriginatorRelationship');
        string PolicyNumber = ApexPages.currentPage().getParameters().get('PolicyNumber');
        string Product = ApexPages.currentPage().getParameters().get('Product');
        string productType = ApexPages.currentPage().getParameters().get('productType');
        string Relationship = ApexPages.currentPage().getParameters().get('Relationship');
        string SitusState = ApexPages.currentPage().getParameters().get('SitusState');
        string BenefitBundle = ApexPages.currentPage().getParameters().get('benefitBundleOption');
        
        string Memberid= ApexPages.currentPage().getParameters().get('Memberid');
        string BenefitPlanId= ApexPages.currentPage().getParameters().get('BenefitPlanId');

        
        
        InteractionId = ApexPages.currentPage().getParameters().get('InteractionId');
        AdditionalInfo.MemberId=Memberid;
        system.debug('----179---'+Memberid);
        AdditionalInfo.BenefitPlanId =BenefitPlanId;
        system.debug('----196---'+BenefitPlanId);

        AdditionalInfo.consumerAccountIndicator  = consumerAccountIndicator;
        AdditionalInfo.dob = dob;
        AdditionalInfo.effectiveDate  = effectiveDate ;
        AdditionalInfo.endDate  = endDate ;
        AdditionalInfo.GroupNumber  = groupNumber ;
        AdditionalInfo.groupName  = groupName ;
        AdditionalInfo.Network    = Network   ;
        AdditionalInfo.OriginatorRelationship  = OriginatorRelationship ;
        AdditionalInfo.PolicyNumber  = PolicyNumber ;
        AdditionalInfo.Product  = Product ;
        AdditionalInfo.productType  = productType ;
        AdditionalInfo.Relationship  = Relationship ;
        AdditionalInfo.SitusState  = SitusState ;
        AdditionalInfo.BenefitBundleOptionId = BenefitBundle;

        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);  
        
        //Added by Srinivasrao M on 06152017 for highlight panel issue
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(hpAdditionInfoStr, ACETHighlightsPanelAdditionalInfo.class);
        }   
        
        
        //Added by Abhinav for US1041621 
        
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance ;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUECreateAuthorization');
        }
        
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        String tempBaseURL = 'userId={0}&functionId=Initiate_Hsc_Intake&landingPage=initiateHSCIntake&applicationId=ACET&primaryServiceReferenceNum={1}';
        List<String> fillers = new String[]{usr.FederationIdentifier, AuthorizationNumber };
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        System.debug('tempbaseURL-->'+tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c,'AES256',tempbaseURL);
        getloggedinProfileName();
       
    }
    
    //Added by Abhinav Balla for US961280 
    private void getloggedinProfileName(){ 
        String userRole = ACETUtility.GetUserRoleName();
        allowedUser = false;
        List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', null, null);
        for(Call_Topic_Access__c acc : accesses){
            if(acc.Call_Topic__c == 'Create Authorization'){
                String roles = acc.Limit_To_Roles__c;
                system.debug('$$$$roles'+roles);
                if(roles.contains(';'))
                {
                    system.debug('$$$$multipleroles'+roles);
                    List<String> rolesList = new List<String>(roles.split(';'));
                    for(String role : rolesList){
                        if(role == userRole){
                            allowedUser = true;
                        }
                        system.debug('$$$$$$$'+ role + ' roles ' + userRole);
                    }
                }
                else if(String.isNotBlank(roles) && roles.containsNone(';') && roles == userRole)
                {
                    allowedUser = true;
                }
                               
            }
            system.debug('$$$$$$$'+ acc.Call_Topic__c + 'roles ' + acc.Limit_To_Roles__c);

            
        }
        if(ACETUtility.GetUserProfileName() == 'Research User' && allowedUser == true){
            isResearchUser = true;
            allowedUser = false;
        } else if(ACETUtility.GetUserProfileName() == 'Research User' && allowedUser == false){
            isResearchUser = false;
            allowedUser = false;
        }
        else if(ACETUtility.GetUserProfileName() != 'Research User') {
            isResearchUser = false;
        }
    }
    
    public static string displayDateTimeFormat(string strDatetimeFormat){
        list<string> lstSplit = strDatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
        integer myHour = Integer.valueOf(lsttimeformat[0]);
        string strAMPM = myHour>=12?'PM':'AM';
        Integer myClockHour = 12;
        Integer myTime = myHour>12?myHour-myClockHour:myHour;
        
        string strDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0]+' '+myTime+':'+lsttimeformat[1]+' '+strAMPM;
        return strDateFormat;
    }
    
    public static string strDateFormat(string strDateFormat){
        list<string> lstDateformat = strDateFormat.split('-');
        
        return lstDateformat[1]+'/'+lstDateformat[2]+'/'+lstDateformat[0];
    }
    
    // Updated by Rama: Begin 
    public ACETAuthorizationDetailResult AuthorizationDetail {get;set;}
    public void CallGetAuthorizationWS(){
        try {
        String federationID = ACETProviderUtility.getFederationIDByUserID();
        system.debug(LoggingLevel.INFO,'federationID:: ' + federationID); 
        
        ACETWSCalloutResult getAuthServiceCalloutResult = ACETProviderUtility.getAuthorizationDetail(AuthId,SRK,AuthorizationType,federationID,null);
        if(getAuthServiceCalloutResult.Success!=null && getAuthServiceCalloutResult.Success){   
            AuthorizationDetail = (ACETAuthorizationDetailResult)getAuthServiceCalloutResult.Response;
            InnerFacilityLine objInnerFacility = new InnerFacilityLine();
            objInnerFacility.strAuthorizationNumber = AuthorizationDetail.Facility_Authorization_Number;
            objInnerFacility.strPos = AuthorizationDetail.POS;
            objInnerFacility.strSrvcDetail = AuthorizationDetail.Service_Detail;
            objInnerFacility.strSrvcDesc = AuthorizationDetail.Service_Desc;
            objInnerFacility.strProviderStatus = AuthorizationDetail.Facility_Provider_Status;
            objInnerFacility.strDecisionOutcome = AuthorizationDetail.Facility_Decision_Outcome;
            objInnerFacility.strDecisionSubType = AuthorizationDetail.Facility_Decision_Sub_Type;
            objInnerFacility.strNotificationDateTime = '';
            objInnerFacility.strDecisionRenderedDate = AuthorizationDetail.Facility_Decision_Rendered_Date;
            objInnerFacility.strCliamRemarkCode = AuthorizationDetail.Facility_Claim_Remark_Code;
            objInnerFacility.strGapOutCome = AuthorizationDetail.Facility_Gap_Outcome;
            objInnerFacility.strDecisionReason = AuthorizationDetail.Facility_Decision_Reason;
            objInnerFacility.strDecisionComment =AuthorizationDetail.Facility_Decision_Comment;
            lstInnerFacilityLine.add(objInnerFacility);
        }else {
            if(getAuthServiceCalloutResult.statusCode==400){
                  setErrorMsg('GN'+'400B',null);
                }
            else if(getAuthServiceCalloutResult.statusCode==404) {
                setErrorMsg('VAUTH404B',null);
            }
            else{
              setErrorMsg('GN'+getAuthServiceCalloutResult.statusCode,null);
            }
          }
    }catch(Exception e){
         setErrorMsg('MGD997',e);
        }
    }
    public void Createcaseanditem(Case cs,Map<String,ACETCaseitemwrapper> caseitemwrap)
    {
        List<Case> caselist = new List<Case>();
        List<Case_Item__c> caseitemlist = new List<Case_Item__c>();
        for(String s:caseitemwrap.keyset()){
            
                if(caseitemwrap.get(s).caseobj.Type__c == cs.Type__c)
                {
                    Case_Item__c item = new Case_Item__c();
                    //item.Type__c = cs.Type__c;
                    //item.Subtype__c = cs.Subtype__c;
                    item.Case__c = cs.Id;
                    caseitemlist.add(item);
                }
                
                else{
                    Case clonedcase = cs.clone();
                    caselist.add(clonedcase);
                    Case_Item__c item = new Case_Item__c();
                    //item.Type__c = clonedcase.Type__c;
                    //item.Subtype__c = clonedcase.Subtype__c;
                    item.Case__c = clonedcase.Id;
                    caseitemlist.add(item);
                }
            
        }
        insert caselist;
        insert caseitemlist;
    }
    
    public class InnerFacilityLine {
        public string strAuthorizationNumber{get;set;}
        public string strPos{get;set;}
        public string strSrvcDetail{get;set;}
        public string strSrvcDesc{get;set;}
        public string strProviderStatus{get;set;}
        public string strDecisionOutcome{get;set;}
        public string strDecisionSubType{get;set;}
        public string strNotificationDateTime{get;set;}
        public string strDecisionRenderedDate{get;set;}
        public string strCliamRemarkCode{get;set;}
        public string strGapOutCome{get;set;}
        public string strDecisionReason{get;set;}
        public string strDecisionComment{get;set;}
    }
    
    public class InnerNotes {
        public string temp{get;set;}
        
    }   
}