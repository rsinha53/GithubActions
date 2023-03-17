public without sharing class ACETMemberDetailController extends ACETErrorHandler{ 
    public transient List<Case> CaseHistory {get;set;}
    public boolean doNotToggle;
    public boolean toggleOnPageLoad; 
    public boolean searchOnLoad { get; set; }
    public String originatorDOB  { get; set; }
    Public String sniEligibility {get;set;}

    //bhanu:optimization public Boolean displayHippaIcon  { get; set; }
    public Set<String> ServiceErrorMSGs  { get; set; }
    //bhanu:optimization public boolean isServiceError  { get; set; }
    public String coveragesSize  { get; set; }
    public String currentAgentProfile  { get; set; }
    public Map<String,String> familymemberRelatioshipMap  { get; set; }
    public String IndividualIdentifier  { get; set; }
    public List<QuickLinks> QuickLinksList {get;set;}
    //bhanu:optimization public boolean ThirdPartyActionFlag  { get; set; } 
    public Interaction__c Interaction  { get; set; }
    public Contact Subject  { get; set; }
    public List<Contact> FamilyMembers  { get; set; }
    public List<Contact> FamilyInfo  { get; set; }
    public String SourceOriginator  { get; set; }
    public boolean isMisdirectCaseCreation { get; set; }
    public Boolean isGroupServError{get;set;}
    public Boolean holdCodeAlert{get; set;} //Added by Krishna for Member holds popup
    public ACETCallTopicsDataWrapper wrapper  { get; set; }
    public string ProviderId { get; set; }
    public boolean memberEnrollment { get; set; }  
    public String IsGroupDetail{get;set;}
    public String GroupNumber { get; set; }
    public String EmployerName { get; set; }
    public String Zip { get; set; }
    public String State { get; set; }
    public String phonenum { get; set; }
    public String firstName { get; set; }
     public String lastName { get; set; }
     public String mnfMemberId {get;set;}
    public Double Offset{get;set;}
    public String DOB { get; set; }
    public String levelFundingValue {get;set;}
    public boolean IsShowActivePhysiciansOnly  { get; set; }    
    //If the interaction is passed to member search page, it is considerated as provider flow, otherwise considerated as member flow
    public Boolean IsProviderFlow  { get; set; }
    public boolean notResearchUser  { get; set; }
    public String CoverageSRK { get; set; }
    public list<PrimaryCarePhysicianWrapper> lstPrimaryCarePhysicianWrapper  { get; set; }
    //public list<ROIWrapper> lstROIWrapper { get; set; }   
    //external fields displayed in panel from member detail
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo  { get; set; }
    List<String> doseInfo = new List<String>(); // Madhura for Covid work US3407186
    public String hpAdditionInfoStr { get{
        return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
    }   
    set;
    }
    public String FamilyInfoStr { get; set; }
    //fields from OIL services
    public ACETMemberDetail MemberDetail  { get; set; }
    //originator selection box  
    public String Originator  { get; set; }
    public List<SelectOption> Originators  { get; set; }
    Public List <ACETMemberDetail.SpecialtyBenefits_CoverageLine > Specialty_BenefitsCoverageLineList {get;set;}
    Public List <ACETMemberDetail.SpecialtyBenefits_CoverageLine > Specialty_BenefitsCoverageLineAll {get;set;}
    Public String listcustinfojson{get;set;}
    Public List<ACETMemberDetail.customerPurchaseinfo> listcustinfo {get;set;}
    
    public String CoverageTypeValue  { get; set; }
    public String groupNameValue  { get; set; }
    public String effectiveDateValue  { get; set; }
    public String endDateValue  { get; set; }
    public String groupNumberValue  { get; set; }
    public String sourceCodeValue   { get; set; }
    //public Interaction__c CaseStub {get;set;}
    
    public List<SelectOption> CoverageTypeOption  { get; set; }
    public List<SelectOption> groupNameOption  { get; set; }
    public List<SelectOption> groupNumberOption  { get; set; }
    public List<SelectOption> sourceCodeOption  { get; set; }

    public Boolean IsShowActiveCoveragesOnly  { get; set; }
    public List<ACETMemberDetail.CoverageLine> Coverages  { get; set; }        
    public ACETMemberDetail.CoverageLine PreferredCoverage  { get; set; }
    public String ProferredCoverageGUID  { get; set; }

    public List<ACETMemberDetail.otherContact> ROIcontacts  { get; set; }
    public String selectedSurrogateKey  { get; set; }     
    public String MemberDetailResultJson { get; set; }
    
    public List<ACETMemberDetail.PCPAssignment> PCPAssignment  { get; set; }    
    //added by Avish on 06072017 for User Story US652217
    public String BundleOptionID  { get; set; }

    //User Story - US:405397,405471
    public Integer alertNumber { get; set; }
    public Boolean isAlertModal { get; set; }
    public list<Alert__c> lstMemAlert { get; set; }
    public String consumerDashURL { get; set; }

    //User Story - US412557, US404372, US412570
    //public String  UserGroupName { get; set; }//bhanu : Optimization
    public Boolean UHGRestricted { get; set; }
    public Boolean GlobalRestricted { get; set; }
    public Boolean DisableOpenTopicDetail { get; set; }
    public Boolean RedirecttoMisdirect { get; set; }
    public String  ErrorMessage { get; set; }
    public String  DefaultValue { get; set; }

    public String groupId {get; set;}
    public String memNotFound {get; set;}
    public String interactionId {get; set;}
    public String ssn{get; set;}
    public String scrId {get; set;}
    
    public boolean isGroupFlow;
    public ACETGroupDetail groupDetails { get; set; }
    public list<Alert__c> lstGroupAlert { get; set; }

    public String providerType { get; set; }

    //Start: User Story - US605469
    transient ACETGetIndividualWebService ACETGetIndWebservice;
    transient ACETFindMembershipWebservice ACETFindMemWebservice;
    
    transient ACETGetFamilyMemberWebService ACETGetFamMemWebservice;
    transient ACETGetEmployerDetailAdapterWebService ACETGetEmployerService;
    public boolean isshowGroupALert { get; set; }
    //End: User Story - US605469

    public Boolean isROI {get; set;}

  //bhanu:optimization Public String Selectedthirdparty  { get; set; }
  //bhanu:optimization Public String SelectedthirdpartyID  { get; set; }
  //bhanu:optimization Public String SelectedthirdpartyORg  { get; set; }
    public User currentUser {get;set;}

    //public Case CaseEndDate  { get; set; }

    //Added by Pavan for Consumer Dashboard  
    public String baseURL { get; set; }
    public string surrogateKey {get; set;}
    //public List<selectOption> CallTopicOptions {get; set;}
    
    //Added by Abhinav for Onshore Restriction
    public boolean isOnshore{get;set;}
    public boolean isRestrict{get;set;}
    public String lstSRKS{get;set;} //Added for US843625 
    
    public String devOrgId {get;set;}
    
    public Id selThirdPartyId {get;set;}
    public String tpChoosenName {get;set;}
    private Third_Party__c thirdPartyObj;
    public String ProvTypeCode {get;set;}
    Public String TaxId{get;set;}
    public String providerTINTypeCode{get;set;}
    public String addressId{get;set;}
    public String ProvideraddressTypeCode{get;set;}
    public String ProviderTypeCode { get; set; }
    public String providerStatusCode {get;set;}
    public String providerTINStatusCode{get;set;}
    public Map<String,String> mapSectionids {get;set;}
    public Integer HoldRestStatus;
    public String selectedvalue{get;set;}
	public string parentPEOId{get;set;}		
	
	//Ancillary Plans US3732426 Styx
    public list<AncillaryPlans> AncillaryPlansList{get;set;}
    public Boolean noresults{get;set;}
    public Boolean showancillary{get;set;}
	public Integer ancillaryCount{get;set;}
    //End of US3732426 Styx
    
    public ACETMemberDetailController (){
    try{
        //bhanu:optimization : moved this code to page actrion
		//Ancillary Plans US3732426 Styx
        noresults = true;
        showancillary = false;
        ancillaryCount = 0;
        //End of US3732426 Styx
        devOrgId = UserInfo.getOrganizationId();
        System.debug('!@devOrgId'+devOrgId);
        ProvTypeCode = ApexPages.currentPage().getParameters().get('ProvTypeCode ');
        System.debug('!@devOrgId'+ProvTypeCode);
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        System.debug('!@ interactionId'+interactionId);
        ProviderId= apexpages.currentpage().getparameters().get('ProviderId');
        System.debug('!@ ProviderId'+ProviderId);
        TaxId= apexpages.currentpage().getparameters().get('TaxId');
        providerTINTypeCode= apexpages.currentpage().getparameters().get('providerTINTypeCode');
        addressId= apexpages.currentpage().getparameters().get('addressId');
        ProvideraddressTypeCode= apexpages.currentpage().getparameters().get('ProvideraddressTypeCode');
        ProviderTypeCode = apexpages.currentpage().getparameters().get('ProviderTypeCode');
        providerStatusCode = apexpages.currentpage().getparameters().get('providerStatusCode');
        providerTINStatusCode= apexpages.currentpage().getparameters().get('providerTINStatusCode');
        isGroupServError = false;
        try{
      if (!String.isEmpty(interactionId)) {
        Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
      }
    }catch(Exception e){
      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
      setErrorMsg('GN997',e);//GN997-->Unknown Error 

    }
        //mapSectionids = 'tab-scoped-1:Coverages;tab-scoped-2:Coverage Details;tab-scoped-3:Coverage Level Change Log';
        mapSectionids = new Map<String,String>();
        mapSectionids.put('tab-scoped-1','Coverages');
        mapSectionids.put('tab-scoped-2','Coverage Details');
        mapSectionids.put('tab-scoped-3','Coverage Level Change Log');
        //CaseStub = new Interaction__c();
        QuickLinksList = new List<QuickLinks>();
        memNotFound = ApexPages.currentPage().getParameters().get('mnf');
        if(memNotFound == '1'){
            QuickLinksList.add(new QuickLinks('tab-scoped-11__item___gendet','General Information'));
        }else{ //(memNotFound == '0')
            QuickLinksList.add(new QuickLinks('ROIInfo','Other Contact'));
            QuickLinksList.add(new QuickLinks('tab-scoped-1__item___policydet','Coverages'));
            QuickLinksList.add(new QuickLinks('tab-scoped-2__item___policydet','Coverage Details')); 
            QuickLinksList.add(new QuickLinks('tab-scoped-3__item___policydet','Coverage Level Change Log'));
            QuickLinksList.add(new QuickLinks('tab-scoped-11__item___gendet','General Information'));
            QuickLinksList.add(new QuickLinks('tab-scoped-22__item___gendet','Family Members'));
            QuickLinksList.add(new QuickLinks('tab-scoped-33__item___gendet','Demographics'));
            QuickLinksList.add(new QuickLinks('primaryCare','PCP Information'));
            QuickLinksList.add(new QuickLinks('cseHist','Case History'));
        }
     }catch(Exception e){
      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
      setErrorMsg('GN997',e);//GN997-->Unknown Error 

    }
        
    }
    public void init(){
        //CaseStub = new Interaction__c();
    try{
        CoverageTypeOption=new list<SelectOption>();
        groupNameOption=new list<SelectOption>();
        groupNumberOption=new list<SelectOption>();
        sourceCodeOption=new list<SelectOption>();
        //endDateOption=System.today();
        //effectiveDateOption=System.today();
        CoverageTypeOption.add(new SelectOption('--All--','--All--'));
         groupNumberOption.add(new SelectOption('--All--','--All--'));
         groupNameOption.add(new SelectOption('--All--','--All--'));
         sourceCodeOption.add(new SelectOption('--All--','--All--'));
        doNotToggle = false;
        toggleOnPageLoad =false;
        currentUser = getUserInfo(UserInfo.getUserId());
        System.debug('!@ currentUser'+currentUser);
        currentAgentProfile = currentUser.profile.name;
        System.debug('!@ currentAgentProfile'+currentAgentProfile);
        if(currentUser.Agent_Type__c == 'Onshore')
            isOnshore = true;
        else
            isOnshore = false;
        isRestrict = false;
        timeZone tz = UserInfo.getTimeZone();
        Offset = tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        
        familymemberRelatioshipMap = new Map<String,String>();
        IsGroupDetail = ApexPages.currentPage().getParameters().get('fromGroupDetail');
        System.debug('!@ IsGroupDetail'+IsGroupDetail);
        ssn = ApexPages.currentPage().getParameters().get('ssn');
        scrId = ApexPages.currentPage().getParameters().get('scr');
        memNotFound = ApexPages.currentPage().getParameters().get('mnf');//@@added by Ranjit: (member not found)
        Originators = new List<SelectOption>();
        Originators.add(new SelectOption('None' , '--None--'));
        
        isGroupFlow = false;
        memberEnrollment = false; 
        isROI = false;
        //UserGroupName =''; //bhanu : Optimization 
        DisableOpenTopicDetail = false;   
       System.debug('!@ MeberDetail Page Complete URL'+ApexPages.currentPage().getUrl());
        SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator');
         System.debug('!@ SourceOriginator'+SourceOriginator);
        //added by sumit 
        lstPrimaryCarePhysicianWrapper = new list<PrimaryCarePhysicianWrapper>();

        PrimaryCarePhysicianWrapper objPrimaryCarePhysician = new PrimaryCarePhysicianWrapper();

        lstPrimaryCarePhysicianWrapper.add(objPrimaryCarePhysician);
        //lstROIWrapper = new list<ROIWrapper>();
      
      /*List<Group> lstgroup = [select Name from group where Id in (SELECT GroupId FROM GroupMember where UserOrGroupId = :UserInfo.getUserId())];
        if(lstgroup.size() > 0){
            UserGroupName =  lstgroup[0].Name;  
        }*/ //bhanu : Optimization
        
        
        IndividualIdentifier = ApexPages.currentPage().getParameters().get('Id');
        System.debug('!@ IndividualIdentifier'+IndividualIdentifier);
        groupId = ApexPages.currentPage().getParameters().get('groupId ');
        System.debug('!@ groupId'+groupId);
        if(groupId != Null && groupId != '')
        {
            isGroupFlow = true;
        }
        //Start: User Story - US605469    
       //String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        System.debug('!@ interactionId'+interactionId);
        Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
        isshowGroupALert = false;
      //bhanu:optimization displayHippaIcon = false;
        //End: User Story - US605469
        //getloggedinProfileName();
        if(ApexPages.currentPage().getParameters().get('IsMember ') != '' && ApexPages.currentPage().getParameters().get('IsMember ') != null && ApexPages.currentPage().getParameters().get('IsMember ').contains('false') || isGroupFlow ){
            if(Interaction != null && Interaction.Originator__c != null){
                originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name)); 
                originator = Interaction.Originator__c ;
                System.debug('!@ originator'+originator);
            }
        }
        
       if(Interaction !=null ){
                If(Interaction.Originator__c !=null && Interaction.Originator__r.Contact_Type__c !=null && Interaction.Originator__r.Contact_Type__c !=''){
                    System.debug('!@ MDInteraction.Originator__r.Contact_Type__c'+Interaction.Originator__r.Contact_Type__c);
                }else if(Interaction.Contact_Type__c !=null && Interaction.Contact_Type__c !=''){
                    System.debug('!@ MDInteraction.Contact_Type__c'+Interaction.Contact_Type__c);
                }
            }
        Originators.add(new SelectOption('thirdPartId' , 'Third Party')); 
        notResearchUser = true;
        if(currentUser.Profile.Name.contains('Research')){
             notResearchUser = false;
             }
       //CallTopicOptions = new List<selectOption>(); 
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        if(interaction != null && memNotFound == '1') 
        {    
          
            if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }
        string addInfo1 = ApexPages.currentPage().getParameters().get('additionalInfo');
            System.debug('!@ addInfo1'+addInfo1);
        if(addInfo1 != null)
        {
            AdditionalInfo   = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo1, ACETHighlightsPanelAdditionalInfo.class);
        }
            

            // Modified by Abhinav Balla as part of US800993 for Member not Found highlight panel and General information flows - Start        
            Zip     = ApexPages.currentPage().getParameters().get('mnfzipcode');
            lastName    = ApexPages.currentPage().getParameters().get('mnfLastName');
            firstName   = ApexPages.currentPage().getParameters().get('mnffirstName');
            State       = ApexPages.currentPage().getParameters().get('mnfState');
            phonenum = ApexPages.currentPage().getParameters().get('mnfPhoneNumber');
            EmployerName = ApexPages.currentPage().getParameters().get('mnfEmployerName');
            System.debug('!@ EmployerName'+EmployerName);
            GroupNumber    = ApexPages.currentPage().getParameters().get('mnfGroupNumber');
            System.debug('!@ GroupNumber'+GroupNumber);
            mnfMemberId = ApexPages.currentPage().getParameters().get('mnfMemberId');
            System.debug('!@ mnfMemberId'+mnfMemberId);
            DOB    = ApexPages.currentPage().getParameters().get('mnfDOB');
            DOB = ACETUtility.formatDateFromDashToSlash(DOB);

            if(AdditionalInfo!=null){
                //AdditionalInfo.Interaction = Interaction;
                AdditionalInfo.FirstName = firstName;
                AdditionalInfo.LastName = lastName;
                AdditionalInfo.EmployerName = EmployerName;
                AdditionalInfo.GroupNumber = GroupNumber;
                AdditionalInfo.MemberId = mnfMemberId;
                AdditionalInfo.Zip = Zip;
                AdditionalInfo.DOB = DOB;
                AdditionalInfo.State = State;
                AdditionalInfo.PhoneNumber = phonenum;   
                AdditionalInfo.isMemNotFound = memNotFound;  
            }
        } 
        if(interaction != null && interaction.Originator_Type__c == 'Other'){
            AdditionalInfo.RelationshipType = ApexPages.currentPage().getParameters().get('RelationshipType');
            System.debug('!@ AdditionalInfo.RelationshipType'+AdditionalInfo.RelationshipType);
            
        }
      }catch(Exception e){
          system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
          setErrorMsg('GN997',e);//GN997-->Unknown Error 
      }    
        
    }
    @TestVisible
    private void getloggedinProfileName(){
    try{    
        notResearchUser = true;
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedinProfileName = PROFILE[0].Name;
        if(loggedinProfileName.contains('Research'))
        { notResearchUser = false;}
   }catch(Exception e){
      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
      setErrorMsg('GN997',e);//GN997-->Unknown Error 

     }
    
    }
    
    public string city{get; set;} 
    public string zipCode{get; set;} 
    public string providerState{get;set;}
    //added by Vishakha on 11/02/2016 for User Story - US:405397,405471- getting all the alert related to the member
    public void getNoOfMemAlert(){
    try{
        ACETInteractionHighlightsPanelController AlertNo = new ACETInteractionHighlightsPanelController();
        if(MemberDetail != null){
            if(MemberDetail.Addresses != null && MemberDetail.Addresses.size() > 0){
                city = MemberDetail.Addresses[0].City;
                zipCode = MemberDetail.Addresses[0].zip;
                providerState = '';
                for(ACETMemberDetail.Address addr : MemberDetail.Addresses) {
                    if(String.isNotBlank(addr.State) && addr.State == 'PR') {
                        providerState = addr.State;
                    }
                }
            }
        }
        System.debug('provider state' +providerState);
       if(MemberDetail != null && AdditionalInfo != null){
            lstMemAlert = AlertNo.getNoAlert('Member',MemberDetail.MemberId,AdditionalInfo.GroupNumber, AdditionalInfo.BenefitBundleOptionId);
            if(lstMemAlert!=null && lstMemAlert.size()>0 ){
                list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
                for(Alert__c varalert : lstMemAlert){
                    Interaction_Alert__c intAlert = new Interaction_Alert__c();
                    intAlert.Alert__c = varAlert.id;
                    intAlert.Interaction__c = Interaction.id;
                    intAlert.ID_Number__c = MemberDetail.MemberId;// added by vishakha 11/30 for US442332
                    intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(Interaction.id)+ MemberDetail.MemberId;
                    lstIntAlert.add(intAlert); 
                }
                try{
                    upsert lstIntAlert Intercation_Alert_Unique_Id_del__c  ;
                }
                Catch(DMLException e){
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Exception during insertion on Interaction Alert.')); //Commented For Testing By Chandan
                    setErrorMsg('GN997',e);//GN997-->Unknown Error 

                }
            }
        }
     }catch(Exception e){
      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
      setErrorMsg('GN997',e); //GN997-->Unknown Error
     }

    }
    public void btnHideWindowAlertWinodw() {

    }
    public void createConsumerDashURL(){
        try{
            List<Contact> contactList = new List<Contact>();
            //Contact varContact = [select FirstName , lastName from Contact where Id=:apexpages.currentpage().getparameters().get('contactId')];
            if(Subject != null)
                contactList = [select FirstName , lastName from Contact where Id=:Subject.Id];
            User usr = currentUser;//getUserInfo(userinfo.getUserId());//[select FederationIdentifier from user where id=:userinfo.getUserId()];
            String dtformat='';
            if(AdditionalInfo.DOB!=null){
                string [] dobval = AdditionalInfo.DOB.split('/');
                Datetime dt = Datetime.newInstance(integer.valueof(dobval[2]), integer.valueof(dobval[0]), integer.valueof(dobval[1]));
                dtformat = dt.format('YYYY-MM-dd');
            }
            surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
            if(contactList!=null && contactList.size() > 0){
                for(Contact con : contactList ){
                    consumerDashURL = ACETURLEncryptionUtility.getEncryptedConsumerDashURL(usr.FederationIdentifier, AdditionalInfo.MemberId, con.FirstName, con.LastName, dtformat, AdditionalInfo.GroupNumber, surrogateKey);
            } 
        }
       } 
        Catch(Exception e)
        {
            system.debug(LoggingLevel.INFO, 'Exception is '+e.getMessage()+'at line '+e.getLineNumber());
            setErrorMsg('GN997',e); //GN997-->Unknown Error
        }
    }
public integer caseListSize {get; set;}
    public List<Case> getMemberCaseHistory()  {
        String Id = ApexPages.currentPage().getParameters().get('Id');
        String SRKkey = ApexPages.currentPage().getParameters().get('SRK');
        transient List<Case> cases = new List<Case>([SELECT CaseNumber,Caller__c,Contact.Name, CreatedBy.Name, CreatedDate, Topic__c, Status, 
                                      Originator_Type__c, Interaction_Type__c, Interaction__r.Name,  Interaction__c, Rollup_Fulfillment__c,Original_Type__c, Originator_name__c,
                                      (SELECT Id, Name FROM Create_Letters__r) FROM Case WHERE Surrogate_Key__c = :SRKkey 
                                      order BY CreatedDate desc limit 500]); // Remove Rollup_Fulfillment__c due to deployment issues:Swetha
                                      
        return cases;
    }
    public List<Case> getMemberCaseHistory(Set<String> srkChain)  {
        String Id = ApexPages.currentPage().getParameters().get('Id');
        String SRKkey = ApexPages.currentPage().getParameters().get('SRK');
        transient List<Case> cases = new List<Case>([SELECT Parent.Id,Caller__c,Parent.CaseNumber,CaseNumber, Contact.Name, CreatedBy.Name, CreatedDate, Topic__c, Status, 
                                      Originator_Type__c, Interaction_Type__c, Interaction__r.Name, Interaction__c,Subject_Name__c, Rollup_Fulfillment__c,Original_Type__c, Originator_name__c,    
                                      (SELECT Id, Name FROM Create_Letters__r) FROM Case WHERE Surrogate_Key__c in :srkChain 
                                      order BY CreatedDate desc limit 500]); // Remove Rollup_Fulfillment__c due to deployment issues:Swetha
                                      
        //Added for US843625 
        if(srkChain!=Null && !srkChain.isEmpty()){
            lstSRKS='';
            for(String s:srkChain) {
            lstSRKS+= (lstSRKS==''?'':',')+s;
           }
        }
        return cases;
    }
    public void renderMisdirectCaseSection(){
        isMisdirectCaseCreation=true;  
    }

    //Start: User Story - US605469
    public void changeOriginator(){
        
        //get membership information for originator
        Contact originatorObj;
        System.debug('!@ Originator'+Originator);
    if(Originator != 'currentTp'){
          if(Originator != 'None'){
              originatorObj = ACETMemberQueryUtil.queryPersonContact(Originator);
          }
          if(originatorObj != null){
              //bhanu:optimization displayHippaIcon = true;
              if(familymemberRelatioshipMap != null && familymemberRelatioshipMap.get(originatorObj.eid__c) != null){
                  MemberDetail.OriginatorRelationShip = familymemberRelatioshipMap.get(originatorObj.eid__c);
              } 
          System.debug('!@originatorObj.Contact_Type__c'+originatorObj.Contact_Type__c);
          originatorObj.Contact_Type__c = 'Member';
          try{
            upsert originatorObj;
           }catch(Exception e){
                system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                setErrorMsg('GN997',e); //996-->Exception during Dml Transaction.
            }
          }
  
          if(Subject != null && originatorObj.id == Subject.id){
              originatorDOB = null;
          }else{
              if(MemberDetail != null && MemberDetail.OriginatorRelationShip != null && MemberDetail.OriginatorRelationShip.contains('Self')){
                  originatorDOB = MemberDetail.OriginatorRelationShip;
              }else{
                  originatorDOB = String.valueOf(originatorObj.birthDate);
              }
          }
          
          String famRelationshipCheck = ApexPages.currentPage().getParameters().get('familyRelationshipCheck');             
          if(famRelationshipCheck == '1'){
              AdditionalInfo.OriginatorRelationship = MemberDetail.OriginatorRelationShip;
          }        
          
          initHighlightPanelAdditionalInfo(false);
          Interaction.Originator__c = Originator; 
          System.debug('!@ Originator'+Originator);
          Interaction.Third_Party__c = null;
        }else{
          system.debug('!@ selThirdPartyId,tpChoosenName-->>> ' + selThirdPartyId );
          thirdPartyObj = ACETMemberQueryUtil.queryThirdParty(selThirdPartyId);
          Interaction.Third_Party__c = thirdPartyObj.id;
          System.debug('!@ thirdPartyObj.id'+thirdPartyObj.id);
            
          Interaction.Originator_Name__c = thirdPartyObj.FullName__c;
            System.debug('!@ thirdPartyObj.FullName__c'+thirdPartyObj.FullName__c);
        
          Interaction.Originator__c = null;
          if(Interaction != null && Interaction.Originator_Type__c != 'Producer'){
            AdditionalInfo.RelationshipType = thirdPartyObj.Third_Party_Relationships__r[0].Name;
          }
         
          AdditionalInfo.contactName = thirdPartyObj.FullName__c;
            System.debug('!@ AdditionalInfo.contactName'+AdditionalInfo.contactName);
          AdditionalInfo.OriginatorRelationship = thirdPartyObj.Third_Party_Relationships__r[0].Name;
          try{
             update Interaction;
            }catch(Exception e){
                system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                setErrorMsg('GN997',e);//996-->Exception during Dml Transaction
            }
          try{
      if(originatorObj != null){
          System.debug('!@ inside ChangeOriginator else'+originatorObj.Contact_Type__c);
          originatorObj.Contact_Type__c = 'Member';
            upsert originatorObj;
          }
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e); //996-->Exception during Dml Insertion.
          }
        }
         try{
         update Interaction;
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//996-->Exception during Dml Transaction
        }
        
        Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id); // need to query
        getNoOfMemAlert();
        if(interaction.Originator_Type__c == 'Other'){
            AdditionalInfo.OriginatorRelationship = ApexPages.currentPage().getParameters().get('OriginatorRelationship');
        } 

    }

    
    public void toggleSBenfits(){
        Specialty_BenefitsCoverageLineList = new List<ACETMemberDetail.SpecialtyBenefits_CoverageLine>();
        Specialty_BenefitsCoverageLineList.clear();
        if(IsShowActiveCoveragesOnly==null){
            IsShowActiveCoveragesOnly = true;
        }
        ACETMemberDetail.SpecialtyBenefits_CoverageLine  CoverageLine = new ACETMemberDetail.SpecialtyBenefits_CoverageLine();
        for(ACETMemberDetail.SpecialtyBenefits_CoverageLine sb : Specialty_BenefitsCoverageLineAll){
            if(sb.isActive=='active' && IsShowActiveCoveragesOnly)
                Specialty_BenefitsCoverageLineList.add(sb);
            else if(!IsShowActiveCoveragesOnly)
                Specialty_BenefitsCoverageLineList.add(sb);
        }
        if(IsShowActiveCoveragesOnly && Specialty_BenefitsCoverageLineList.size()==0 && Specialty_BenefitsCoverageLineAll.size()>0){
               Specialty_BenefitsCoverageLineList = Specialty_BenefitsCoverageLineAll;
               IsShowActiveCoveragesOnly = false;
           }
    }
    
    public void toggleSCoverages(){
                Coverages = new List<ACETMemberDetail.CoverageLine>();
        List<ACETMemberDetail.CoverageLine> CRCoverages = new List<ACETMemberDetail.CoverageLine>();
        Coverages.clear();
        boolean isPreferredCFound =false;
        if(MemberDetail != null && MemberDetail.CoverageLines != null){     
            for(ACETMemberDetail.CoverageLine c : MemberDetail.CoverageLines){
              if(!(c.CoverageType.equalsIgnoreCase('DENTAL') || c.CoverageType.equalsIgnoreCase('VISION'))){

                if(c.benefitPlanId != null && !string.ISBLANK(c.benefitPlanId) ){
                    if(c.benefitPlanId.length() > 2){ 
                        if(c.benefitPlanId.toLowerCase().subString(0,2) != 'mr' || c.benefitPlanId.toLowerCase().subString(0,2) != 'MR'){
                            if(!IsShowActiveCoveragesOnly || c.getIsActive()){ //|| c.getIsActive()
                                Coverages.add(c);
                                if(c.SourceCode == 'CR'){ 
                                    CRCoverages.add(c);
                                }
                            } 
                            else if(IsShowActiveCoveragesOnly == False){
                                Coverages = new List<ACETMemberDetail.CoverageLine>();
                                Coverages.addAll(MemberDetail.CoverageLines);
                            }
                        }
                    }
                
                }                       
            
              }
            }
            for(ACETMemberDetail.CoverageLine c : MemberDetail.CoverageLines){
                    if(c.isPreferred){
                    isPreferredCFound = true;
                    //c.isPreferred = false;
                    }
                }
            }
        coveragesSize =  String.valueOf(CRCoverages.size());
        
        if(CRCoverages.size() < 1 ){
            MemberDetail.Network = '';
            MemberDetail.FundingArragement = '';
            MemberDetail.BenefitPlanId = '';
            MemberDetail.MemberStatus = '';
            MemberDetail.SitusState = '';
            MemberDetail.BundleOptionID = '';
            MemberDetail.EligibilityStatus = '';
            MemberDetail.GroupSize = '';
            MemberDetail.QMSCOIndicator = '';
        }
        else
            selectPreferredCoverage();
    }

     public void toggleShowCoverages(){
      try{ 
        MemberDetail.Network = '';
        MemberDetail.FundingArragement = '';
        MemberDetail.BenefitPlanId = '';
        MemberDetail.MemberStatus = '';
        MemberDetail.SitusState = '';
        MemberDetail.BundleOptionID = '';
        MemberDetail.EligibilityStatus = '';
        MemberDetail.GroupSize = '';
        MemberDetail.QMSCOIndicator = '';
            if(IsShowActiveCoveragesOnly == null){
                IsShowActiveCoveragesOnly = true;   //true
            }else{
                IsShowActiveCoveragesOnly = !IsShowActiveCoveragesOnly;
            }
         CoverageTypeOption=new list<SelectOption>();
       groupNameOption=new list<SelectOption>();
       groupNumberOption=new list<SelectOption>();
       sourceCodeOption=new list<SelectOption>();
       CoverageTypeOption.add(new SelectOption('--All--','--All--'));
       groupNumberOption.add(new SelectOption('--All--','--All--'));
       groupNameOption.add(new SelectOption('--All--','--All--'));
       sourceCodeOption.add(new SelectOption('--All--','--All--'));
       if(memberDetail.CoverageTypeSet!=null && memberDetail.CoverageTypeSet.size()>0){
           for(String c:memberDetail.CoverageTypeSet){
           if(c != null){
               CoverageTypeOption.add(new SelectOption(c,c));
               }
           }
       }
        if(memberDetail.groupNumberSet!=null && memberDetail.groupNumberSet.size()>0){
           for(String c:memberDetail.groupNumberSet){
           if(c != null){
               groupNumberOption.add(new SelectOption(c,c));
               }
           }
       }
        if(memberDetail.groupNameSet!=null && memberDetail.groupNameSet.size()>0){
           for(String c:memberDetail.groupNameSet){
           if(c != null){
               groupNameOption.add(new SelectOption(c,c));
               }
           }
       }
        if(memberDetail.sourceCodeSet!=null && memberDetail.sourceCodeSet.size()>0){
           for(String c:memberDetail.sourceCodeSet){
           if(c != null){
               sourceCodeOption.add(new SelectOption(c,c));
               }
           }
       }
          toggleSCoverages();
          toggleSBenfits();
      toggleSCoverages();
          toggleSBenfits();
          
          
      }catch(exception e){
          system.debug(LoggingLevel.INFO, e.getstacktracestring());
          setErrorMsg('GN997',e);//GN997-->Unknown Error

      }
    }
    public void showCoverages(){
     try{ 
        MemberDetail.Network = '';
        MemberDetail.FundingArragement = '';
        MemberDetail.BenefitPlanId = '';
        MemberDetail.MemberStatus = '';
        MemberDetail.SitusState = '';
        MemberDetail.BundleOptionID = '';
        MemberDetail.EligibilityStatus = '';
        MemberDetail.GroupSize = '';
        MemberDetail.QMSCOIndicator = '';
        
            if(IsShowActiveCoveragesOnly == null){
                IsShowActiveCoveragesOnly = true;   //true
            }else{
                IsShowActiveCoveragesOnly = !IsShowActiveCoveragesOnly;
            }
        
        CoverageTypeOption=new list<SelectOption>();
       groupNameOption=new list<SelectOption>();
       groupNumberOption=new list<SelectOption>();
       sourceCodeOption=new list<SelectOption>();
       CoverageTypeOption.add(new SelectOption('--All--','--All--'));
       groupNumberOption.add(new SelectOption('--All--','--All--'));
       groupNameOption.add(new SelectOption('--All--','--All--'));
       sourceCodeOption.add(new SelectOption('--All--','--All--'));
       if(memberDetail.CoverageTypeSet!=null && memberDetail.CoverageTypeSet.size()>0){
           for(String c:memberDetail.CoverageTypeSet){
               CoverageTypeOption.add(new SelectOption(c,c));
           }
       }
        if(memberDetail.groupNumberSet!=null && memberDetail.groupNumberSet.size()>0){
           for(String c:memberDetail.groupNumberSet){
           if(c != null){
               groupNumberOption.add(new SelectOption(c,c));
               }
           }
       }
        if(memberDetail.groupNameSet!=null && memberDetail.groupNameSet.size()>0){
           for(String c:memberDetail.groupNameSet){
           if(c != null){
               groupNameOption.add(new SelectOption(c,c));
               }
           }
       }
        if(memberDetail.sourceCodeSet!=null && memberDetail.sourceCodeSet.size()>0){
           for(String c:memberDetail.sourceCodeSet){
           if(c != null){
               sourceCodeOption.add(new SelectOption(c,c));
               }
           }
       }
        Coverages = new List<ACETMemberDetail.CoverageLine>();
        List<ACETMemberDetail.CoverageLine> CRCoverages = new List<ACETMemberDetail.CoverageLine>();
        boolean isPreferredCFound =false;
        if(MemberDetail != null && MemberDetail.CoverageLines != null){     
            for(ACETMemberDetail.CoverageLine c : MemberDetail.CoverageLines){
               
               if(!(c.CoverageType.equalsIgnoreCase('DENTAL') || c.CoverageType.equalsIgnoreCase('VISION'))){
                                    
                if(c.benefitPlanId != null && !string.ISBLANK(c.benefitPlanId) ){
                    if(c.benefitPlanId.length() > 2 ){
                        if(c.benefitPlanId.toLowerCase().subString(0,2) != 'mr' || c.benefitPlanId.toLowerCase().subString(0,2) != 'MR'){
                            if(!IsShowActiveCoveragesOnly || c.getIsActive()){ //|| c.getIsActive()
                                    Coverages.add(c);
                                    if(c.SourceCode == 'CR'){ 
                                        CRCoverages.add(c);
                                    }
                            }
                            else if(IsShowActiveCoveragesOnly == False){
                                Coverages = new List<ACETMemberDetail.CoverageLine>();
                                Coverages.addAll(MemberDetail.CoverageLines);
                            }
                        }
                    }
                }                            
            }
            }
            for(ACETMemberDetail.CoverageLine c : MemberDetail.CoverageLines){
                    if(c.isPreferred){
                    isPreferredCFound = true;
                    //c.isPreferred = false;
                    }
            }
        }
        coveragesSize =  String.valueOf(CRCoverages.size());
        
        if(CRCoverages.size() < 1 ){
            MemberDetail.Network = '';
            MemberDetail.FundingArragement = '';
            MemberDetail.BenefitPlanId = '';
            MemberDetail.MemberStatus = '';
            MemberDetail.SitusState = '';
            MemberDetail.BundleOptionID = '';
            MemberDetail.EligibilityStatus = '';
            MemberDetail.GroupSize = '';
            MemberDetail.QMSCOIndicator = '';
            
        }
     }catch(exception e){
          system.debug(LoggingLevel.INFO, e.getstacktracestring());
          setErrorMsg('GN997',e);//GN997-->Unknown Error

      } 
    }
    public void selectPreferredCoverage(){ 
     try{
        if(ProferredCoverageGUID == '' ){
                system.debug('either page load or no coverage or toggle');
        }
        If(memNotFound != '1'){
            Set<String> PolicyNumber = new Set<String>();
            RedirecttoMisdirect = false;
            DisableOpenTopicDetail = false;
            system.debug(LoggingLevel.INFO, 'cl guid : '+ProferredCoverageGUID);
            if(Coverages != null){
                system.debug(LoggingLevel.INFO, 'Coverages----- >>1 ');
                if( (ProferredCoverageGUID == '' || ProferredCoverageGUID == null)){
                        system.debug(LoggingLevel.INFO, 'Coverages----- >>2 ');
                        //select preffered coverage now
                        String dateToCompare = null;
                        for(ACETMemberDetail.CoverageLine cl : Coverages){
                            system.debug(LoggingLevel.INFO, 'Coverages----- >>3 ');
                            if(cl.isSubscriber && cl.SourceCode.equalsIgnoreCase('CR') && cl.CoverageType.equalsIgnoreCase('MEDICAL') && (cl.benefitPlanId.toLowerCase().subString(0,2) != 'mr') ){ 
                                system.debug(LoggingLevel.INFO, 'Coverages----- >>4 ');
                                cl.isPreferred = isPreferredCoverage(cl.SourceCode,cl.CoverageType,cl.getIsActive(),ACETUtility.formatDatewithslash(cl.EffectiveDate),dateToCompare,cl.benefitPlanId);
                                if(cl.isPreferred){
                                    dateToCompare = ACETUtility.formatDatewithslash(cl.EffectiveDate);
                                }
                            }
                        }
                }
                for(ACETMemberDetail.CoverageLine cl : Coverages){
                    if( cl.benefitPlanId != null && !string.ISBLANK(cl.benefitPlanId) && cl.benefitPlanId.toLowerCase().subString(0,2) != 'mr' || cl.benefitPlanId.toLowerCase().subString(0,2) != 'MR'){
                        if(cl.GUID == ProferredCoverageGUID){ // Prakash 02-01-17 (toggleOnPageLoad && cl.isPreferred)  || 
                            PreferredCoverage = cl;
                            selectedSurrogateKey = cl.SurrogateKey;
                            
                            scrId = cl.subscriberID;
                            system.debug(LoggingLevel.INFO, 'PreferredCoverage@@ ' + PreferredCoverage + ' >>>selectedSurrogateKey>>> ' + selectedSurrogateKey);
                            cl.isPreferred = true;//false
                            toggleOnPageLoad =false;
          
                        }
                        PolicyNumber.add(cl.PolicyNumber);
                     }
                }
            }else{
                toggleOnPageLoad = false;
            }
            MemberDetail.PreferredCoverage = PreferredCoverage;
            // US3584877 Start : Added By Manish
            MemberDetail.custPurchaseinfo = PreferredCoverage.custPurchaseinfo;
	        MemberDetail.bookOfBusinessTypeCode = '';
            MemberDetail.bookOfBusinessTypeDesc = '';
            // US3584877 End
         system.debug(LoggingLevel.INFO,' Member detail preffered coverage after select preffered coverage : '+MemberDetail.PreferredCoverage);
            
        system.debug(LoggingLevel.INFO,' Member detail preffered coverage after select preffered coverage : '+PreferredCoverage);
            if(MemberDetail.PreferredCoverage != null)
                MemberDetail.EnrolleeSurrogateKey = MemberDetail.PreferredCoverage.EnrolleeSurrogateKey; 
        }
        system.debug('MemberDetail.EnrolleeSurrogateKey :: '+MemberDetail.EnrolleeSurrogateKey);
        System.debug(LoggingLevel.INFO,'selectedSurrogateKey @@ ' + selectedSurrogateKey);
    
       }catch(exception e){
          system.debug(LoggingLevel.INFO, e.getstacktracestring());
          setErrorMsg('GN997',e);//GN997-->Unknown Error

       }
    }
     private boolean isPreferredCoverage(String sourceCode, String coverageType, boolean isActive, String effDateStr, String dateToCompare,String planBenefitIdCov){
       try{
         system.debug(sourceCode+' :: '+coverageType+' :: '+isActive+ ' :: '+effDateStr +' :: '+dateToCompare);        
        String covBenefitPlanId = planBenefitIdCov != null && planBenefitIdCov != '' ? planBenefitIdCov.toLowerCase().subString(0,2): '';
        if(sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && (covBenefitPlanId != 'mr')){
               return true;  
            
         }
       }catch(exception e){
          system.debug(LoggingLevel.INFO, e.getstacktracestring());
          setErrorMsg('GN997',e);//GN997-->Unknown Error

       }
      return false;     
    }



    private void initInteractionAndSubject(){
        system.debug('Interaction:--IN----> '+memNotFound);
        if(memNotFound != '1') 
        {
            String Id = ApexPages.currentPage().getParameters().get('Id');
            system.debug(LoggingLevel.INFO, '@@@@Id: ' + Id);    
            String MemberFName = ApexPages.currentPage().getParameters().get('firstName');
            String MemberLName = ApexPages.currentPage().getParameters().get('lastName');
            String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
            system.debug(LoggingLevel.INFO, 'InteractionId: ' + InteractionId); 
            system.debug(LoggingLevel.INFO, 'isMember'+ApexPages.currentPage().getParameters().get('IsMember ')) ;  
            try{  
                //if (!String.isEmpty(interactionId))
                //commented by Sumit
              //  memberdetail.memberid = Id;
                if(ApexPages.currentPage().getParameters().get('IsMember ').contains('false')){                                                        
                    //Query Provider Interaction details
                    Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
                    system.debug('Interaction:--1----> ' + Interaction );
                    //Added swetha : update interaction from vccdParams
                    Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);
                    try{
                      update interaction;
                    }catch(Exception e){
                      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                      setErrorMsg('GN997',e);//996-->Exception during Dml Transaction                                                  

                    }
                    IsProviderFlow = true;                   
                } else {
                    IsProviderFlow = false;
                }
                //setup originator options
                Originators = new List<SelectOption>();
                system.debug(LoggingLevel.INFO, 'Interaction:----> ' + Interaction );
                //added by Khoushik for Surrogate Ids related Story
                system.debug(LoggingLevel.INFO, 'MemberDetail: ' + MemberDetail.SurrogateKey);
                if(!String.IsEmpty(MemberDetail.SurrogateKey)) {
                    Map<String, ISL_Webservice_Config__c> WSConfigurations = new Map<String, ISL_Webservice_Config__c>();
                    WSConfigurations = ISL_Webservice_Config__c.getAll();
                    String dob = ApexPages.currentPage().getParameters().get('subjectdob');
                    String Params =  ApexPages.currentPage().getParameters().get('vccdParams');
                    String Phone ='';
                    if(Params != '' && Params != null){
                        JSONParser parser = JSON.CreateParser(Params);

                        While(parser.nextToken() !=null){
                            if((Parser.getCurrentToken() == JSONToken.FIELD_Name) && (parser.getText() =='Phone')){
                                parser.nexttoken();
                                Phone = Parser.getText();
                            }
                        }
                    }
                    try{
                        ACETOILIndividual acetOilData = new ACETOILIndividual();
                        acetOilData.FirstName = String.isBlank(MemberDetail.FirstName) ? MemberFName : MemberDetail.FirstName; //MemberDetail.FirstName; //
                        acetOilData.LastName = String.isBlank(MemberDetail.LastName) ? MemberLName : MemberDetail.LastName; // MemberDetail.LastName;   //
                        String indiIdentifier = ApexPages.currentPage().getParameters().get('individualIdentifier');
                        acetOilData.EId = indiIdentifier;
                        acetOilData.Phone = Phone;
                        acetOilData.suffix = MemberDetail.Suffix;
                        acetOilData.middleInitial = MemberDetail.MiddleInitial;
                        acetOilData.SurrogateKeys = MemberDetail.SurrogateKeys;
                        if(!String.isEmpty(dob)) {
                            acetOilData.Birthdate = date.parse(dob);
                        } 
                        ACETConstituent acetcon = new ACETConstituent(); 
                        system.debug('acetOilData--->'+acetOilData);
                        Map<String, List<Case>> ACETSRKCaseMap = acetcon.MergeNSplitCases(acetOilData); //SRK Code
                                                Subject = acetcon.GetConstitentContact(acetOilData);

                        //Subject = acetcon.Subject;   
                        system.debug(LoggingLevel.INFO, 'Subject inside controller '+Subject);

                        //save member and member family to contact
                        createMemberAndFamilyMembers();

                        //create a new interaction if not passed from provider page        
                        if(ApexPages.currentPage().getParameters().get('IsMember ').contains('true')){

                            if(Interaction == null || Interaction.Originator__c == null){ 
                               createInteraction();
                            }
                            
                            else if(Interaction != null && Interaction.Originator__c != null ){
                                System.debug(LoggingLevel.INFO,'Interaction.Originator__c@@@='+Interaction.Originator__c);
                             
                                originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name)); 
                                originator = Interaction.Originator__c ;
                            } 
                        }
                        acetcon.ReparentCases(Interaction.Id, ACETSRKCaseMap); //SRK code
                        
                        if(acetcon.srkerrormessage){
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Unexpected error occurred. Please try again. If problem persists, contact the Help Desk.'));
                        }
                    }catch(Exception e){
                        //some error occured in Merge and split
                       system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                       setErrorMsg('GN997',e);//GN997-->Unknown Error

                   }                  
                }
                /*else {
                    //save member and member family to contact
                    createMemberAndFamilyMembers();
                    //create a new interaction if not passed from provider page        
                    if(ApexPages.currentPage().getParameters().get('IsMember ').contains('true')){
                        createInteraction();
                    }
                }  */ //bhanu:optimization    
                Originators = new List<SelectOption>();
                //redirected from provider page, add provider as originator
                string isProducerFlow = ApexPages.currentPage().getParameters().get('isFromProducer');
                system.debug(LoggingLevel.INFO, 'IsProviderFlow:----> ' + IsProviderFlow);
                system.debug(LoggingLevel.INFO, 'isProducerFlow:----> ' + isProducerFlow);
                system.debug(LoggingLevel.INFO, 'originators:----> ' + originators);
                if(IsProviderFlow ||  (isProducerFlow== 'true')){ 
                    if(Interaction.Originator_Type__c == 'Other')
                    {
                        originators.add(new SelectOption(Interaction.Originator_Name__c, Interaction.Originator_Name__c));
                        //Originators.add(new SelectOption('thirdPartId' , 'Third Party')); 
                    }else if(isGroupFlow)
                    {
                        if(Interaction.Third_Party__c != Null && AdditionalInfo != null && AdditionalInfo.contactName != null)
                        {                            
                originators.add(new SelectOption(AdditionalInfo.contactName, AdditionalInfo.contactName));
                        }else
                        {
                            if(Interaction != null && Interaction.Originator__c != null)
                                originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));
                        }       
                    }else
                    {           
                        system.debug(LoggingLevel.INFO, 'IsProviderFlow:----> ' + IsProviderFlow);
                        if(Interaction != null && Interaction.Originator__c != null){
                            originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));   
                            
                        }     
                    }
                }else {
                    //member flow, add current member and member family
                    //originator is already specified from case fast track
                    String fastTrack = ApexPages.currentPage().getParameters().get('fastTrack');
                    if(Interaction != null && Interaction.Originator__c != null && fastTrack == 'true'){
                        originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name)); 
                    }else{
                        initMemberOriginators();    
                    }
                }
                system.debug(LoggingLevel.INFO, 'originators:--2----> ' + originators);               
            }catch(exception e){
                system.debug(LoggingLevel.INFO, e.getstacktracestring());
                setErrorMsg('GN997',e);//GN997-->Unknown Error

            }
        }                                                      
    }
    public void memberNotFound(){
      try{
        Originators = new List<SelectOption>();
       //String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        if(interactionId==null)
         interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        System.debug('InteractionId@@@@@ ='+InteractionId);
        Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
        system.debug(LoggingLevel.INFO, 'originators:---3---> ' + originators);
        if(memNotFound == '1'){    
          
            if(Interaction != null && Interaction.Originator__c != null) {
                originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));
            } else if(Interaction != null && Interaction.Originator_Name__c != null) {
              originators.add(new SelectOption(Interaction.Originator_Name__c, Interaction.Originator_Name__c));
            } else if(Interaction != null && Interaction.Third_party__c != null && Interaction.Originator_Type__c == 'Other') {
                originators.add(new SelectOption(Interaction.Third_party__c, Interaction.Third_party__r.FullName__c));
            }
        }
        system.debug(LoggingLevel.INFO, '--------IN MNF----->'+ interaction + '--------->'+memNotFound);
      }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//GN997-->Unknown Error

      }
        
    }

    private void initMemberOriginators(){
       try{
        Originators = new List<SelectOption>();
        Originators.add(new SelectOption('None' , '--None--'));

        /*** Code added by Avish on 06232017 for workaroud for benefit end to end testing ***/
        String benefitSRKBravo = '908034187,908034179,908034180,908034182,908034184,908034183,908034189,908034191,908034190,908034193,908034183,907018366';   
        if(benefitSRKBravo.contains(MemberDetail.SurrogateKey)){
            system.debug(LoggingLevel.INFO, 'Benefit Bravo : ' + MemberDetail.SurrogateKey);
            Originators.add(new SelectOption('thirdPartId' , 'Third Party'));  
        }else{

            system.debug(LoggingLevel.INFO, FamilyMembers);
            if(FamilyMembers != null){
                for(Contact fm : FamilyMembers){
          if(fm.id!=null)
                    Originators.add(new SelectOption(fm.id , fm.FirstName + ' ' + fm.LastName));     
                } 
            } 
            Originators.add(new SelectOption('thirdPartId' , 'Third Party')); 
        system.debug('initMemberOriginators ### ' + Originator);
            
            if(Originator == 'currentTp'){ 
              originators.add(new SelectOption('currentTp', Interaction.Originator_Name__c));
              system.debug('selThirdPartyId ### ' + selThirdPartyId);
              thirdPartyObj = ACETMemberQueryUtil.queryThirdParty(selThirdPartyId);
            if(thirdPartyObj != null)
                AdditionalInfo.OriginatorRelationship = thirdPartyObj.Third_Party_Relationships__r[0].Name;
            }else{
                if(tpChoosenName!=null)
                originators.add(new SelectOption('currentTp', tpChoosenName));
            }
        }
        if(interaction.Originator_Type__c == 'Other'){
            AdditionalInfo.RelationshipType = ApexPages.currentPage().getParameters().get('RelationshipType');
        } 
        system.debug(LoggingLevel.INFO, 'MemberDetail.SurrogateKey Benefit After : ' + MemberDetail.SurrogateKey);
       
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//GN997-->Unknown Error
        }
    }

    private void createMemberAndFamilyMembers(){
      try{
        String Id = ApexPages.currentPage().getParameters().get('Id');
        String indiIdentifier = ApexPages.currentPage().getParameters().get('individualIdentifier');
        system.debug(LoggingLevel.INFO, 'Id >>>>>>>>> '+Id);
        String firstName = ApexPages.currentPage().getParameters().get('firstName');
        String lastName = ApexPages.currentPage().getParameters().get('lastName');
        //Added for populating date of birth for subject : starts
        String dob = ApexPages.currentPage().getParameters().get('subjectdob');
        Date dDOB;
        if(!String.isEmpty(dob)){
            dDOB  = date.parse(dob);
        }
        // Sumit Jain Adding 
        String Params =  ApexPages.currentPage().getParameters().get('vccdParams');
        String Phone ='';
        if(Params != null && Params != ''){ //added by Ranjit to resolve the Member Detail Error
            JSONParser parser = JSON.CreateParser(Params);

            While(parser.nextToken() !=null){
                if((Parser.getCurrentToken() == JSONToken.FIELD_Name) && (parser.getText() =='Phone')){
                    parser.nexttoken();
                    Phone = Parser.getText();
                }

            }
        }

        //Sumit Jain Closing
        //Added for populating date of birth for subject : Ends        
        FamilyMembers = new List<Contact>();
        Map<String,Account> EIDVsAccountMap = new Map<String, Account>();
        FamilyMembers.add(Subject);
        //add other family members
        system.debug(LoggingLevel.INFO, '11111MemberDetail :: ' + MemberDetail);
        system.debug(LoggingLevel.INFO, '11111FamilyMembers :: ' + MemberDetail.FamilyMembers);
        if(MemberDetail.FamilyMembers != null){
            for(ACETMemberDetail.FamilyMember fm : MemberDetail.FamilyMembers){
                system.debug(LoggingLevel.INFO, '2323fm'+fm);
                system.debug(LoggingLevel.INFO, '2323checking duplicate eid'+ fm.EId + '::' + Subject.EID__c);
                if(fm.EId != indiIdentifier){
                    Account acc = new Account();
                    acc.FirstName= fm.FirstName;
                    acc.LastName = fm.LastName;
                    acc.EID__c=fm.EID;
                    acc.EID__pc = fm.EID;
                    acc.PersonBirthdate = Date.parse(fm.dob);
                    acc.RecordTypeId =ACETMemberQueryUtil.getPersonAccountRecordType();
                    EIDVsAccountMap.put(fm.EID, acc);

                }             
            } 
            FamilyInfoStr = JSON.serialize(MemberDetail.FamilyMembers);           
        }
        system.debug(LoggingLevel.INFO, '232323FamilyMembers :: ' + FamilyMembers);

       try{
         Database.upsert(EIDVsAccountMap.values(), Account.Fields.EID__c,false);
       }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//GN997-->Unknown Error
        }
        List<String> eids = new List<string>();
        for(String str: EIDVsAccountMap.keySet()){
           if(String.IsNotBlank(str)){
                eids.add(str);
            }
        }
        system.debug('------eids----------'+eids);
        if(eids!=Null && !eids.isEmpty()){
             List<contact> conts=[Select Id,FirstName,LastName,EID__c,birthdate,accountid from contact where EID__c IN:eids];
            if(conts!=Null && !conts.isEmpty()){
            for(Contact con:conts){
               system.debug('-------con-----'+con);
               FamilyMembers.add(con);
            }
           }
        }
        


        FamilyInfo = FamilyMembers;    
       }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//GN997-->Unknown Error
        }
    }

    private void createInteraction(){
     try{
        Interaction = new Interaction__c();
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        System.debug('!@ interactionId'+interactionId);
        Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);  
        Interaction.Originator__c = Subject.Id;

        //for now, we only have the use case as member calls themselves
        Interaction.Interaction_Type__c = SourceOriginator;
        Interaction.Originator_Type__c = 'Member';

        // Swetha
        Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);

        //Insert Interaction;
       try{
        Update Interaction; 
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//996-->Exception during Dml Transaction
        }
        Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        system.debug(LoggingLevel.INFO, 'Interaction:::'+Interaction);
       }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//GN997-->Unknown Error
        }
    }

    //Start: User Story - US605469, added isshowAlert
    @TestVisible
    private void initHighlightPanelAdditionalInfo(boolean isshowALert){
      try{
        isshowGroupALert = isshowALert; 
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        System.debug('!@ addInfo'+addInfo);
       try{
            if(addInfo != null)
            {
                AdditionalInfo   = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
                system.debug(LoggingLevel.INFO, '@@AdditionalInfo.providerType@@ ' + AdditionalInfo.providerType);
            }
       }catch(Exception e){
            setErrorMsg('GN997',e);//GN997-->Unknown Error
            system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
       }
        system.debug(LoggingLevel.INFO, '----Interaction:::--->'+Interaction);  
       if(AdditionalInfo!=null){
        if(memNotFound != '1') 
        {           
            AdditionalInfo.GroupNumber = MemberDetail.PreferredCoverage != null ? MemberDetail.PreferredCoverage.GroupNumber : '';
            AdditionalInfo.GroupName =  MemberDetail.PreferredCoverage != null ? MemberDetail.PreferredCoverage.GroupName : ''; 
            AdditionalInfo.Relationship = MemberDetail.Relationship;    
            AdditionalInfo.SitusState = MemberDetail.SitusState;
            AdditionalInfo.OnshoreIndicator = MemberDetail.PreferredCoverage != null ? MemberDetail.PreferredCoverage.OnshoreRestriction : ''; 
            AdditionalInfo.OnshoreIndicatorVerbiage = MemberDetail.PreferredCoverage != null ? memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage:'';
            AdditionalInfo.DOB = MemberDetail.DOB;
            AdditionalInfo.Age = MemberDetail.Age;
            AdditionalInfo.BenefitPlanId = MemberDetail.BenefitPlanId;
            //Added by Pavan for US923050
            AdditionalInfo.BenefitBundleOptionId = MemberDetail.BundleOptionID;
            AdditionalInfo.hsaPlan = memberDetail.hsaAvailable;
            AdditionalInfo.EndDate = MemberDetail.EndDate;
            AdditionalInfo.EffectiveDate = MemberDetail.EffectiveDate;
            AdditionalInfo.PolicyNumber = MemberDetail.PolicyNumber;
            AdditionalInfo.Product = MemberDetail.Product;
            AdditionalInfo.ProductType = MemberDetail.ProductType;   
            AdditionalInfo.Network = MemberDetail.Network;
            AdditionalInfo.Gender = MemberDetail.Gender;
            AdditionalInfo.GatedPlan = MemberDetail.gatedPlanIndicator ; 
            AdditionalInfo.MemberStatus = MemberDetail.MemberStatus;
            AdditionalInfo.FirstName = MemberDetail.FirstName;
            System.debug('!@ AdditionalInfo.FirstName'+AdditionalInfo.FirstName);
            //if(MemberDetail.LastName != null && MemberDetail.LastName != '')
                //AdditionalInfo.LastName = String.escapeSingleQuotes(MemberDetail.LastName);
            AdditionalInfo.LastName = MemberDetail.LastName;
            System.debug('!@ AdditionalInfo.LastName'+AdditionalInfo.LastName);
            AdditionalInfo.MemberId = MemberDetail.MemberId;     
            System.debug('!@ AdditionalInfo.MemberId'+AdditionalInfo.MemberId);
            AdditionalInfo.OriginatorRelationship = MemberDetail.OriginatorRelationship;
            AdditionalInfo.IsMember = ApexPages.currentPage().getParameters().get('IsMember ');//added by Vishakha
            if(Interaction != null && Interaction.Originator_Type__c != 'Producer'){
              AdditionalInfo.RelationshipType = MemberDetail.Relationship;
            }
            //Added by Sai Kolluru for US3407186
            if(!String.isBlank(AdditionalInfo.MemberId)){
                AdditionalInfo.covidVaccineDosageList = doseInfo;
            }
            String famRelationshipCheck = ApexPages.currentPage().getParameters().get('familyRelationshipCheck'); 
    
            if(famRelationshipCheck == '1'){
                
                Contact originatorObj;
                
                if(Originator != 'None'){
                    originatorObj = ACETMemberQueryUtil.queryContact(Originator);
                    if(originatorObj != null){
                       if(originatorObj.Contact_Type__c == 'Member'&& AdditionalInfo.IsMember== 'true'){
                           System.debug('!@ originatorObj.name'+originatorObj.name);
                           AdditionalInfo.contactName = originatorObj.name;
                       }else if(originatorObj.Contact_Type__c == 'Member' && Interaction.Originator_Type__c == 'Provider'){
                           AdditionalInfo.contactName = Interaction.Contact_Name__c;
                       }
                // system.debug('familymemberRelatioshipMap@@ ' + familymemberRelatioshipMap + ' @@@familymemberRelatioshipMap.get(originatorObj.eid__c)@@ ' + familymemberRelatioshipMap.get(originatorObj.eid__c));
                        if(familymemberRelatioshipMap != null && originatorObj.eid__c != null && familymemberRelatioshipMap.get(originatorObj.eid__c) != null){
                            MemberDetail.OriginatorRelationShip = familymemberRelatioshipMap.get(originatorObj.eid__c);
                            if(Interaction != null && Interaction.Originator_Type__c != 'Producer'){
                              AdditionalInfo.OriginatorRelationship = MemberDetail.OriginatorRelationShip;
                            }
                        } 
                    
                    } 
                }   
            }else if(String.isNotBlank(Originator)){
                system.debug('Originator111@@@ ' + Originator);
                Contact originatorObj;
                
                if(Originator != 'None'){
                    originatorObj = ACETMemberQueryUtil.queryContact(Originator);
                    system.debug('originatorObj111@@@ ' + originatorObj);
                    if(originatorObj != null){
                      if(originatorObj.Contact_Type__c == 'Member'){
                           System.debug('!@ originatorObj.name'+originatorObj.name);
                        AdditionalInfo.contactName = originatorObj.name;
                      }
                        //system.debug('familymemberRelatioshipMap@@ ' + familymemberRelatioshipMap + ' @@@familymemberRelatioshipMap.get(originatorObj.eid__c)@@ ' + familymemberRelatioshipMap.get(originatorObj.eid__c));
                        if(familymemberRelatioshipMap!=null && familymemberRelatioshipMap.get(originatorObj.eid__c) != null){
                            MemberDetail.OriginatorRelationShip = familymemberRelatioshipMap.get(originatorObj.eid__c);
                            if(Interaction != null && Interaction.Originator_Type__c != 'Producer'){
                              AdditionalInfo.OriginatorRelationship = MemberDetail.OriginatorRelationShip;
                            }
                        }                     
                    } 
                } 
            }  else{                         
                AdditionalInfo.OriginatorRelationship = MemberDetail.OriginatorRelationShip;//MemberDetail.Relationship;
        }   
                
            AdditionalInfo.OriginatorDOB = originatorDOB ;
            system.debug(LoggingLevel.INFO, 'Interaction:::'+Interaction + ' :: Interaction.Highlight_Panel_GroupInfo__c :: ' + Interaction.Highlight_Panel_GroupInfo__c);
            system.debug(LoggingLevel.INFO, 'memNotFound :::'+memNotFound);
            if(Interaction != null && Interaction.Highlight_Panel_GroupInfo__c != null)
            {
                ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
                AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
                AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
                AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
                AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
                AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
                AdditionalInfo.RatingMethod = '';
                AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate;
                if(Interaction != null && Interaction.Originator_Type__c != 'Producer'){
                  AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ; 
                }

            }
            if (ApexPages.currentPage().getParameters().get('isFromProducer') == 'true')
            {   
                AdditionalInfo.GroupN = '';
            } 
        }else if(interaction != null && memNotFound == '1') 
        {    

            // Modified by Abhinav Balla as part of US800993 for Member not Found highlight panel and General information flows - Start        
            Zip     = ApexPages.currentPage().getParameters().get('mnfzipcode');
            lastName    = ApexPages.currentPage().getParameters().get('mnfLastName');
            firstName   = ApexPages.currentPage().getParameters().get('mnffirstName');
            State       = ApexPages.currentPage().getParameters().get('mnfState');
            phonenum = ApexPages.currentPage().getParameters().get('mnfPhoneNumber');
            EmployerName = ApexPages.currentPage().getParameters().get('mnfEmployerName');
            GroupNumber    = ApexPages.currentPage().getParameters().get('mnfGroupNumber');
            mnfMemberId = ApexPages.currentPage().getParameters().get('mnfMemberId');
            DOB    = ApexPages.currentPage().getParameters().get('mnfDOB');
            DOB = ACETUtility.formatDateFromDashToSlash(DOB);

            system.debug(LoggingLevel.INFO, '!!!@@@firstName'+firstName);
            system.debug(LoggingLevel.INFO, '!!!@@@phonenum'+phonenum);

            //AdditionalInfo.Interaction = Interaction;
            AdditionalInfo.FirstName = firstName;
            AdditionalInfo.LastName = lastName;
            AdditionalInfo.EmployerName = EmployerName;
            AdditionalInfo.GroupNumber = GroupNumber;
            AdditionalInfo.MemberId = mnfMemberId;
            AdditionalInfo.Zip = Zip;
            AdditionalInfo.DOB = DOB;
            AdditionalInfo.State = State;
            AdditionalInfo.PhoneNumber = phonenum;   
            AdditionalInfo.isMemNotFound = memNotFound; 

            system.debug(LoggingLevel.INFO, '!!!@@@AdditionalInfo'+AdditionalInfo);
            // Modified by Abhinav Balla as part of US800993 for Member not Found highlight panel and General information flows - End   
        }  
        if(interaction.Originator_Type__c == 'Other'){
            if( ApexPages.currentPage().getParameters().get('RelationshipType') != null && ApexPages.currentPage().getParameters().get('RelationshipType') != '')
        AdditionalInfo.RelationshipType = ApexPages.currentPage().getParameters().get('RelationshipType');
      else if(interaction.Third_Party__r.Employer_Name__c != null || interaction.Third_Party__r.Producer_Name__c != null){
        String Urlstr = ApexPages.currentPage().getURL();
        Integer reltype = URLstr.indexOf('RelationshipType');
        if(reltype != -1){
          reltype = reltype + 25;
          integer rel = URLstr.indexOf('%22Relationship%') ;
          if(rel != -1){
            rel = rel - 6 ;
            if(reltype != null && rel != null)
            AdditionalInfo.RelationshipType = URLstr.substring(reltype, rel );
            AdditionalInfo.RelationshipType = AdditionalInfo.RelationshipType.replace('+', ' ');
          }
        }
      }
        }  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
       }
        
      }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//GN997-->Unknown Error
        }

    }

    public void updateThirdParty(){
    }

    public List<SelectOption> getCallTopicOptions(){ 
        List<SelectOption> CallTopics = new List<SelectOption>();
        try{
        //string memNtFnd = ApexPages.currentPage().getParameters().get('mnf');
        if(memNotFound==null)
            memNotFound = ApexPages.currentPage().getParameters().get('mnf');
        System.debug('memNotFound='+memNotFound);
        //if(memNtFnd != '1')
        if(memNotFound != '1'){
            System.debug('memNotFound If='+memNotFound);
              //Modified for HSA Topic Logic
              if(Interaction != null && MemberDetail!=Null){
                  CallTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Detail', Interaction.Originator_Type__c,MemberDetail.OriginatorRelationShip,Interaction.Third_Party__c,MemberDetail.Relationship);
              }else if(Interaction != null){
                  CallTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Detail', Interaction.Originator_Type__c,'',Interaction.Third_Party__c,'');
              }
        }      
        else{
            System.debug('memNotFound else='+memNotFound);
            CallTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Not Found', 'Member');
            System.debug('CallTopics==='+CallTopics);
        }    
       }catch(Exception e){
             //Some error has occurred
             setErrorMsg('GN997',e);//GN997-->Unknown Error
             system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
       }
        return CallTopics;
    }
    
    //Added the below method to display calltopics based on the onshore/offshore restrictions from selected coverage
    /*public void restrictedCoverageTopics() {
        
        //System.debug('Member Detail Coverages:::::'+memberDetail.PreferredCoverage.onShoreRestrictionCode);
        String onShoreRestrictionCode = String.isNotBlank(memberDetail.PreferredCoverage.onShoreRestrictionCode)?memberDetail.PreferredCoverage.onShoreRestrictionCode:' ';
        string memNtFnd = ApexPages.currentPage().getParameters().get('mnf');
        String agentType = currentUser.Agent_Type__c;//getUserInfo(UserInfo.getUserId()).Agent_Type__c;
        if(memNtFnd != '1')
            CallTopicOptions = ACETCallTopicsPicklistUtility.getCallTopicOptionsWithRestrictions('Member Detail', Interaction.Originator_Type__c, agentType, onShoreRestrictionCode);
        else
            CallTopicOptions = ACETCallTopicsPicklistUtility.getCallTopicOptionsWithRestrictions('Member Not Found', 'Member', agentType, '');      
    
        //System.debug('CallTopicOptions::::: '+CallTopicOptions);
    } */
    
    public void toggleShowPrimaryPhysician(){
      try{
        if(IsShowActivePhysiciansOnly == null){
            IsShowActivePhysiciansOnly = true;   
        }else{
            IsShowActivePhysiciansOnly = !IsShowActivePhysiciansOnly;
        }

        lstPrimaryCarePhysicianWrapper = new list<PrimaryCarePhysicianWrapper>();
      }catch(Exception e){
             //Some error has occurred
             setErrorMsg('GN997',e);//GN997-->Unknown Error
             system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
        } 
        

    } 

    public void selectPrimaryPhysician(){

        IsShowActivePhysiciansOnly = False;
        lstPrimaryCarePhysicianWrapper = new list<PrimaryCarePhysicianWrapper>();

    } 

    //Added by sumit
    public class PrimaryCarePhysicianWrapper{
        public PrimaryCarePhysicianWrapper(){
            //caseEndDate =  new Case();
            pcpInt = new Interaction__c();
        }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string pcpLocatorId { get; set; } 
        public string pcpAssignmentType { get; set; }
        public string effectiveDate { get; set; }
        public string endDate { get; set; }
        public string identifierType { get; set; }
        public string id { get; set; } 
        public boolean isActive { get; set; }
        //public Case caseEndDate  { get; set; }
        public Interaction__c pcpInt { get; set; }
    }   
    /*public class ROIWrapper{
        public boolean isActive { get; set; } 
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string middleIntial { get; set; }
        public string effectiveDate { get; set; }
        public string terminateDate { get; set; }
        public string ROIDoc { get; set; }
    }*/
    /*public void ROIWrapperRecordsCreator(){
        system.debug(LoggingLevel.INFO, '--------Subject------>'+ Subject);
        if(Subject != null && Subject.LastName == 'Grimm'){
            lstROIWrapper = new list<ROIWrapper>();
            ROIWrapper objROI = new ROIWrapper();
            objROI.isActive = true;
            objROI.firstName = 'Warner';
            objROI.lastName = 'Test';
            objROI.middleIntial = 'Bill';
            objROI.effectiveDate = '01/10/2016';
            objROI.terminateDate = '04/10/2016';
            lstROIWrapper.add(objROI);
            ROIWrapper objROI2 = new ROIWrapper();
            objROI2.isActive = false;
            objROI2.firstName = 'Beck';
            objROI2.lastName = 'Test';
            objROI2.middleIntial = 'Konrad';
            objROI2.effectiveDate = '02/10/2016';
            objROI2.terminateDate = '05/10/2016';
            lstROIWrapper.add(objROI2);
        }
    } */

    //Start: User Story - US605469
    public object CallGetMembership(){
        Continuation continuationInst; 
        Set<String> groupNumbers = new Set<String>();
        
        system.debug(LoggingLevel.INFO, 'MemberDetail.PreferredCoverage '+MemberDetail.PreferredCoverage);

        PreferredCoverage = (PreferredCoverage != null ? PreferredCoverage :  MemberDetail.PreferredCoverage);
        system.debug(LoggingLevel.INFO, 'PreferredCoverage inside call membership after reassigning '+PreferredCoverage);
        
        //if(PreferredCoverage != null){//Commented as every thing need to be controlled by MemberDetail.PreferredCoverage
        if(MemberDetail.PreferredCoverage != null){
            if(MemberDetail.SurrogateKey != null && !String.IsEmpty(MemberDetail.SurrogateKey)) {
                        
       //GetFamilyMembership webservice callout
        try{
             String Id = ApexPages.currentPage().getParameters().get('Id');
             ACETGetFamMemWebservice = new ACETGetFamilyMemberWebService();
             continuationInst = ACETGetFamMemWebservice.StartRequest(Id, MemberDetail,'GetMembershipCallback',continuationInst);
        }catch(Exception e){
             //Some error has occurred
             setErrorMsg('GN997',e);//GN997-->Web Service or External System is temporarily unavailable
             system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
        } 

                //GetEmployerGroup webservice callout
                if(groupNumbers.size() == 1){
                    
                }else{
                    for(String groupNumber : groupNumbers){
                        
                    }
                }
             
  
                
                
          try{
                ACETGetEmployerService = new ACETGetEmployerDetailAdapterWebService();
                //Below line commented to decide based on memberdetail.PreferredCoverage
                //continuationInst = ACETGetEmployerService.StartRequest(PreferredCoverage.groupNumber, 'GetMembershipCallback' ,continuationInst);
                continuationInst = ACETGetEmployerService.StartRequest(MemberDetail.PreferredCoverage.groupNumber, 'GetMembershipCallback' ,continuationInst);
          }catch(Exception e){
              //Some error has occurred
               system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
               setErrorMsg('GN997',e);//GN997-->Web Service or External System is temporarily unavailable
  
           } 

         }
        }else{
            //if continuation does not exist for second call out : add previous service error on UI if exist
        try{
            if(MemberDetail.isServiceError != null && MemberDetail.isServiceError){
              if(ServiceErrorMSGs.contains (ACETWebserviceHelper.getErrorMessageFromCode(500)))
               ServiceErrorMSGs=new Set<String>{ACETWebserviceHelper.getErrorMessageFromCode(500)};      
               if(ServiceErrorMSGs!=null && ServiceErrorMSGs.size()>0){ 
                for(String msg : ServiceErrorMSGs){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' '+msg));//Commented For Testing By Chandan
                }
               } 
            }
            //init UI with current data
            if(MemberDetail != null)
                MemberDetailResultJson =   json.serialize(MemberDetail);

          //bhanu:optimization initInteractionAndSubject(); 
          //bhanu:optimization initHighlightPanelAdditionalInfo(false);            
            //bhanu:optimization getNoOfMemAlert();  // Userstory : US717636
            }catch(Exception e){
              //Some error has occurred
               system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
               setErrorMsg('GN997',e);//GN997-->Web Service or External System is temporarily unavailable
               
           } 
        }   
        return  continuationInst;
    }
    public Object GetMembershipCallback() {
        String subjectFNm = ApexPages.currentPage().getParameters().get('firstName');
        String subjectLNm = ApexPages.currentPage().getParameters().get('lastName');
        String dob = ApexPages.currentPage().getParameters().get('subjectdob');

        //  Madhura - to test in 201 due to no lower environment E2E test data
        
        doseInfo = ACETLGT_CovidVaccineAPIService.getCovidVaccineIndicatorDetails(subjectFNm,subjectLNm,dob);
        system.debug('doseInfo in controller '+doseInfo);

        system.debug(LoggingLevel.INFO, 'inside GetMembershipCallback');
        system.debug(LoggingLevel.INFO, 'GetMembershipCallback '+MemberDetail.SurrogateKey);
        ACETWSCalloutResult getMemCalloutResults;
        ACETWSCalloutResult getFamMemCalloutResults;
        ACETWSCalloutResult GetcustomerPurchaseResults;
        ACETWSCalloutResult getEmployerGroupResult;
        system.debug(LoggingLevel.INFO, 'inside GetMembershipCallback');

       
         try{
            getFamMemCalloutResults = ACETGetFamMemWebservice.ProcessResponse(ACETGetFamMemWebservice.RequestLabel, MemberDetail);
            if(getFamMemCalloutResults.Success) {
                system.debug(LoggingLevel.INFO, '>>>>>>> >>>>>> '+MemberDetail);
                MemberDetail = (ACETMemberDetail)getFamMemCalloutResults.Response;
                 //MemberDetail.isServiceError = false;
                for(ACETMemberDetail.FamilyMember fm : MemberDetail.FamilyMembers){
                    familymemberRelatioshipMap.put(fm.eid,fm.RelationShip);
                }
                // US2962032 Start moved from getmembershipcallout 
                BundleOptionID =  MemberDetail.BundleOptionID; 
                    if(MemberDetail.PreferredCoverage != null){
                    memberDetail.EffectiveDate = MemberDetail.PreferredCoverage.EffectiveDate;
                    memberDetail.EndDate = MemberDetail.PreferredCoverage.EndDate;
                    memberDetail.PolicyNumber =  MemberDetail.PreferredCoverage.PolicyNumber;
                    memberDetail.Product =  MemberDetail.PreferredCoverage.Product;
                    memberDetail.ProductType =  MemberDetail.PreferredCoverage.ProductType;              
                    system.debug(LoggingLevel.INFO, '23232311 memberDetail'+memberDetail);
                }
                // US2962032 end  
            }
            else{
                MemberDetail.Network = '';
                MemberDetail.FundingArragement = '';
                MemberDetail.BenefitPlanId = '';
                MemberDetail.MemberStatus = '';
                MemberDetail.SitusState = '';
                MemberDetail.BundleOptionID = '';
                MemberDetail.EligibilityStatus = '';
                MemberDetail.GroupSize = '';
                MemberDetail.QMSCOIndicator = '';              
                MemberDetail.isServiceError = true;
                MemberDetail.CoverageLevelCode = '';
                MemberDetail.isServiceError = true;
                MemberDetail.PreferredCoverage.OnshoreRestriction ='';
                MemberDetail.PreferredCoverage.OnshoreRestrictionVerbiage ='';
        
                //ServiceErrorMSGs.add(getFamMemCalloutResults.Message+'error');
                ServiceErrorMSGs.add(getFamMemCalloutResults.Message);
                setErrorMsg('GN'+getFamMemCalloutResults.statusCode,null); 
                
            }
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'getFamMemCalloutResults'+e.getstacktracestring());
            setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 
        }
        system.debug(LoggingLevel.INFO, 'GetMembershipCallback '+MemberDetail.SurrogateKey);
        system.debug('%%% Benefit Plan'+MemberDetail.BenefitPlanId + '  ' +MemberDetail.BundleOptionID );
       
        try{
            getEmployerGroupResult = ACETGetEmployerService.ProcessResponse(ACETGetEmployerService.RequestLabel, MemberDetail);
            system.debug(LoggingLevel.INFO, 'getEmployerGroupResult ::  ' + getEmployerGroupResult + ' ::getEmployerGroupResult.Success :: ' + getEmployerGroupResult.Success);
            if(getEmployerGroupResult.Success) {
                MemberDetail = (ACETMemberDetail)getEmployerGroupResult.Response;
                system.debug(LoggingLevel.INFO, 'MemberDetail >> '+JSON.serialize(MemberDetail));
                parentPEOId = MemberDetail.parentPEOId;
               if(memberDetail.listcustinfo.size()>0){
               listcustinfojson = json.serialize(memberDetail.listcustinfo);
               }
                
             if(Coverages!= null){
                    /**************************************************************************************/
                    //Onshore restriction logic for a group with multiple populations to a contract option
                    /**************************************************************************************/
                 try{   
                 system.debug(LoggingLevel.INFO,'memberDetail.preferredCoverage= '+ memberDetail.preferredCoverage);
                 system.debug(LoggingLevel.INFO,'%%%%controller haspopulation = '+Memberdetail.haspopulation );
                 if(memberDetail.preferredCoverage!=null)
                    system.debug (LoggingLevel.INFO, 'onshorerestrictioncode =' + memberDetail.preferredCoverage.onshorerestrictioncode);
                  
                  //if(Memberdetail.haspopulation!=null && Memberdetail.haspopulation &&  memberdetail.PreferredCoverage!=null && memberdetail.PreferredCoverage.onshorerestrictioncode!=null && memberdetail.PreferredCoverage.onshorerestrictioncode.contains(';'))
                    if(Memberdetail.haspopulation!=null && Memberdetail.haspopulation && String.isNotBlank(memberdetail.contractOptionPopulations) && memberdetail.contractOptionPopulations.contains(','))
                    {
                        
                        
                        system.debug('~~~Multi pop error and code'+memberDetail.PreferredCoverage.OnshoreRestrictionError+memberDetail.PreferredCoverage.OnshoreRestrictionCode);
                        
                        if(( MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '08' ||  MemberDetail.PreferredCoverage.OnshoreRestrictionCode=='07' ||
                              (MemberDetail.PreferredCoverage.OnshoreRestrictionCode =='06'  && (Interaction.Originator_Type__c == 'Member' || Interaction.Originator_Type__c == 'Provider' )) ||
                              (MemberDetail.PreferredCoverage.OnshoreRestrictionCode =='05' && Interaction.Originator_Type__c != 'Member' && Interaction.Originator_Type__c != 'Provider')||
                              (MemberDetail.PreferredCoverage.OnshoreRestrictionCode =='04'  && Interaction.Originator_Type__c == 'Member')
                              ) ){
                            isRestrict = (isOnshore == false)?true:false;
                            MemberDetail.PreferredCoverage.OnshoreRestriction = 'Yes';                                                  
                              
                          }
                          else if(MemberDetail.PreferredCoverage.OnshoreRestrictionCode=='01' || MemberDetail.PreferredCoverage.OnshoreRestrictionCode=='02' || MemberDetail.PreferredCoverage.OnshoreRestrictionCode=='03'){
                          
                              isRestrict = false;
                              MemberDetail.PreferredCoverage.OnshoreRestriction = 'No';                                                  
                            
                          
                          }
                          else if(MemberDetail.PreferredCoverage.OnshoreRestrictionCode =='00'){
                              isRestrict = false;
                              MemberDetail.PreferredCoverage.OnshoreRestriction = '';    
                              memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage ='';                                                  
                            
                          }else {
                              isRestrict = false;
                              MemberDetail.PreferredCoverage.OnshoreRestriction = (String.isBlank(memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage))?'':'No';                                                 
                            
                        }

                        system.debug(LoggingLevel.INFO, '@@@@multi pop IsRestrict '+IsRestrict +MemberDetail.PreferredCoverage.OnshoreRestriction);
                              
                    } 
                    /*************************************************************************************/
                    //Onshore restriction logic for a group with single/No populations to a contract option
                    /*************************************************************************************/
                    else{
                    
                                                
                        system.debug(LoggingLevel.INFO,'@@@@code'+MemberDetail.PreferredCoverage.OnshoreRestrictionCode );
                        system.debug(LoggingLevel.INFO,'@@@@code'+MemberDetail.PreferredCoverage.OnshoreRestrictionVerbiage);
                        system.debug(LoggingLevel.INFO,'@@@@'+MemberDetail.PreferredCoverage.OnshoreRestriction);
                        system.debug(LoggingLevel.INFO,'@@@@IsOnshore'+isOnshore);
                        if(( MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '07' || MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '08')|| 
                            (MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '05' && Interaction.Originator_Type__c != 'Member' && Interaction.Originator_Type__c != 'Provider' )||
                            (MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '06' && (Interaction.Originator_Type__c == 'Member' || Interaction.Originator_Type__c == 'Provider'))||
                            (MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '04' && Interaction.Originator_Type__c == 'Member' )
                        
                            ){
                            isRestrict = (isOnshore == false)?true:false;
                            MemberDetail.PreferredCoverage.OnshoreRestriction = 'Yes';
                        }
                        else if(MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '03' || MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '02'||MemberDetail.PreferredCoverage.OnshoreRestrictionCode == '01'){
                            isRestrict = false;
                            MemberDetail.PreferredCoverage.OnshoreRestriction = 'No'; 
                        }
                        else if(MemberDetail.PreferredCoverage.OnshoreRestrictionCode =='00'){
                              isRestrict = false;
                              MemberDetail.PreferredCoverage.OnshoreRestriction = '';  
                              memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage ='';                                                
                            
                          }else {
                              isRestrict = false;
                              MemberDetail.PreferredCoverage.OnshoreRestriction = (String.isBlank(memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage))?'':'No';                                                  
                            
                          }
                        system.debug(LoggingLevel.INFO, '@@@@IsRestrict '+IsRestrict +MemberDetail.PreferredCoverage.OnshoreRestriction);
                        
                    }  
                   }catch(Exception e){
                   system.debug(LoggingLevel.INFO, 'Exception Happened '+e.getstacktracestring());
                   setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 
                  }
                    system.debug('%%% CoveragesList'+Coverages);
                              
            }
            else{
              MemberDetail.SitusState = '';
              MemberDetail.FundingArragement = '';
              MemberDetail.GroupSize = '';
              memberDetail.coverageGroupContractOptionId = '';
              memberDetail.coverageGroupContractOptionEffDate = '';
              memberDetail.enrollmentMethod = '';
              memberdetail.responsibilityType = '';
              memberdetail.continuationType = '';
              MemberDetail.PreferredCoverage.OnshoreRestriction = '';
              memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage='';
              memberDetail.PreferredCoverage.OnshoreRestrictionCode='00';
                //bhanu:optimization isServiceError = true;
                MemberDetail.isServiceError = true;
                ServiceErrorMSGs.add(getEmployerGroupResult.Message);
                setErrorMsg('GN'+getEmployerGroupResult.statusCode,null); 
   
            }
          }
    else{
                MemberDetail.isServiceError = true;
                
                  isGroupServError = true;
                ServiceErrorMSGs.add(getEmployerGroupResult.Message);
                System.debug('ServiceErrorMSGs='+ServiceErrorMSGs);
                setErrorMsg('GN'+getEmployerGroupResult.statusCode,null); 

            }
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'getEmployerGroupResult '+e.getstacktracestring());
            setErrorMsg('GN997',e); 

        }
        system.debug(LoggingLevel.INFO, 'GetMembershipCallback '+MemberDetail.SurrogateKey);
        if(MemberDetail != null)        
            MemberDetailResultJson =   json.serialize(MemberDetail);

         try{
          initInteractionAndSubject(); 
         }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'Exception Occured '+e.getstacktracestring());
            setErrorMsg('GN997',e);//GN997-->Unknown Error

        }
        try{
         initHighlightPanelAdditionalInfo(false);
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'Exception Occured '+e.getstacktracestring());
            setErrorMsg('GN997',e);//GN997-->Unknown Error

        }
        try{
         getNoOfMemAlert();  // User Story: US717636 
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'Exception Occured '+e.getstacktracestring());
            setErrorMsg('GN997',e);//GN997-->Unknown Error
        }
        try{
         createConsumerDashURL();
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'Exception Occured '+e.getstacktracestring());
            setErrorMsg('GN997',e);//GN997-->Unknown Error
        }
        //restrictedCoverageTopics();
        system.debug(LoggingLevel.INFO, 'originators:---4---> ' + originators);
        system.debug(LoggingLevel.INFO, 'MemberDetail.isServiceErrort ::  '+ MemberDetail.isServiceError + ' :: MemberDetail.isServiceError :: ' + MemberDetail.isServiceError);
        try{
         if(MemberDetail.isServiceError != null && MemberDetail.isServiceError){
            if(ServiceErrorMSGs.contains (ACETWebserviceHelper.getErrorMessageFromCode(500)))
             ServiceErrorMSGs=new Set<String>{ACETWebserviceHelper.getErrorMessageFromCode(500)}; 
                if(ServiceErrorMSGs!=null && ServiceErrorMSGs.size()>0){ 
                        for(String msg : ServiceErrorMSGs){
                           // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' '+msg)); //Commented For Testing By Chandan
                        }
                }
          }
            
            
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'Exception Occured '+e.getstacktracestring());
            setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 

        }
        system.debug(LoggingLevel.INFO, 'originators:---5---> ' + originators);
        system.debug(LoggingLevel.INFO, 'finished callback 2 membership service : '+json.serialize(Coverages));
        system.debug(LoggingLevel.INFO, 'GetMembershipCallback '+MemberDetail.SurrogateKey);
        return null;
    }
    // Method to redirect to Error Page when Selected Coverage is Restricted
    public PageReference RedirectToRestrictedPage() {
        
        PageReference pageRef ;
        pageRef = page.ACETRestriction;
        pageRef.setRedirect(true);
        return pageRef;    
    }
    
    
    
    public void clearDetail(){
       CoverageTypeValue ='--All-';
       groupNameValue= '--All-' ;
       effectiveDateValue =null;
       endDateValue = null; 
       groupNumberValue = '--All-' ;
       sourceCodeValue = '--All-' ;
    }
    
    public Object CallWSonPageLoad()
    {   
        System.debug('memNotFound='+memNotFound);
        //memNotFound = ApexPages.currentPage().getParameters().get('mnf');
        if(memNotFound==null)
          memNotFound = ApexPages.currentPage().getParameters().get('mnf');
        //memNotFound = '0';
        Continuation PageLoadContinuation;

        MemberDetail = new ACETMemberDetail();
        if(scrId==null)
            scrId = ApexPages.currentPage().getParameters().get('scr');
        MemberDetail.SCRId=scrId;
        String Id = ApexPages.currentPage().getParameters().get('Id');        
        MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        searchOnLoad=false;
        system.debug(LoggingLevel.INFO,'CoverageTypeValue='+CoverageTypeValue);
        if(CoverageTypeValue!=null && CoverageTypeValue!='--All--'){
          MemberDetail.CoverageTypeValue=CoverageTypeValue;
          searchOnLoad=true;
        }
        if(groupNameValue!=null && groupNameValue!='--All--'){
           MemberDetail.groupNameValue=groupNameValue;
            searchOnLoad=true;
        }
        try{
            System.debug(LoggingLevel.INFO,'effectiveDateValue='+effectiveDateValue);
            Integer entYear = 0;
            Integer entEndYear = 0;
            if(effectiveDateValue != null && !string.isblank(effectiveDateValue ) )
                entYear = (Integer) Integer.ValueOf(effectiveDateValue.substring(effectiveDateValue.length()-4, effectiveDateValue.length()));
            if(endDateValue != null && !string.isblank(endDateValue) )
                entEndYear = (Integer) Integer.ValueOf(endDateValue.substring(endDateValue.length()-4, endDateValue.length()));
            if(!String.isBlank(effectiveDateValue) && entYear <= 3999 ){
                MemberDetail.effectiveDateValue= effectiveDateValue != null ?date.parse(effectiveDateValue):null;
                searchOnLoad=true;
            }else if(entYear > 3999){
                MemberDetail.effectiveDateValue= effectiveDateValue != null ?date.parse('12/31/3999'):null;
            }
            System.debug(LoggingLevel.INFO,'MemberDetail.effectiveDateValue='+MemberDetail.effectiveDateValue);
            if(!String.isBlank(endDateValue) && entEndYear <= 3999){
                MemberDetail.endDateValue= endDateValue != null ?date.parse(endDateValue):null;
                searchOnLoad=true;
            }else if(entYear > 3999){
                MemberDetail.endDateValue= endDateValue != null ?date.parse('12/31/3999'):null;
        }
         }catch(Exception e){
            setErrorMsg('GN997',e);//GN997-->Unknown Error

            system.debug('exception@@ ' + e);
        }
        if(groupNumberValue!=null && groupNumberValue!='--All--'){
            MemberDetail.groupNumberValue=groupNumberValue;
            searchOnLoad=true;
            }
        if(sourceCodeValue!=null && sourceCodeValue!='--All--'){
            MemberDetail.sourceCodeValue=sourceCodeValue;
            searchOnLoad=true;
        }
        if(memNotFound == '1'){
            memberNotFound();
            CallWSonPageLoadCallback();
        }
        //if(true){

        //}
        if(memNotFound != '1'){
            //GetIndividual webservice callout
    try{
    if(!String.isEmpty(MemberDetail.SurrogateKey)){
        ACETGetIndWebservice = new ACETGetIndividualWebService();
        PageLoadContinuation = ACETGetIndWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'CallWSonPageLoadCallback',null);  
     }
    }catch(Exception e){
    system.debug(LoggingLevel.INFO, 'Exception Occured in ACETGetIndividualWebService'+e.getstacktracestring());
        setErrorMsg('GN997',e);//GN997-->Web Service or External System is temporarily unavailable.

      } 
      
      //FindMembership webservice callout
    try{
    if(!String.isEmpty(MemberDetail.SurrogateKey)){
            ACETFindMemWebservice = new ACETFindMembershipWebservice();
    //  PageLoadContinuation = ACETFindMemWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'CallWSonPageLoadCallback',PageLoadContinuation); 
      }
    }catch(Exception e){
    system.debug(LoggingLevel.INFO, 'Exception Occured in ACETFindMembershipWebservice'+e.getstacktracestring());
        setErrorMsg('GN997',e);//GN997-->Web Service or External System is temporarily unavailable.

      }
            
    }

        return PageLoadContinuation; 
    }

    public Object CallWSonPageLoadCallback() {
        Object chainedContinuation;
        MemberDetail.isServiceError = false;
        ServiceErrorMSGs = new Set<String>();
       //memNotFound = ApexPages.currentPage().getParameters().get('mnf');
        if(memNotFound==null)
         memNotFound = ApexPages.currentPage().getParameters().get('mnf');
        if(memNotFound != '1'){ 
            ACETWSCalloutResult getIndCalloutResults;
            ACETWSCalloutResult findMemCalloutResults;
            ACETWSCalloutResult getFamMemCalloutResults;
            try{
            ACETFindMemCustPurchaseWebservice fmcp = new ACETFindMemCustPurchaseWebservice();
               Specialty_BenefitsCoverageLineAll = new List<ACETMemberDetail.SpecialtyBenefits_CoverageLine>();
               listcustinfo = new List<ACETMemberDetail.customerPurchaseinfo>();
              ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('Find Membership Customer Purchases API', ACETFindMemCustPurchaseWebservice.getRequestBody(MemberDetail), null);
                       HttpResponse response = wsCallOutFW.getResponse();
                      system.debug('response - SearchAssessmentListService' + response.getBody());
                 findMemCalloutResults  = fmcp.ProcessResponse(response.getBody(), memberDetail);
                if(findMemCalloutResults.Success) {
                    //MemberDetail.isServiceError = false;
                    MemberDetail = (ACETMemberDetail)findMemCalloutResults.Response;
              system.debug('MemberDetail FMCP  >>>>>> '+MemberDetail);
                    Specialty_BenefitsCoverageLineAll.addAll(MemberDetail.specialityBenefits);
                    if(MemberDetail.listcustinfo != null){
                     listcustinfo.addall(MemberDetail.listcustinfo);
                    }
                    coveragesSize =  String.valueOf(MemberDetail.CoverageLines!=null?MemberDetail.CoverageLines.size():0);
             if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }
       if(sniEligibility == null || sniEligibility==''){
        ACETLGT_EligibilityService es = new ACETLGT_EligibilityService();
        ACETWSCalloutResult CalloutResult = null;
           if(memberDetail.PreferredCoverage!=null){
               CalloutResult = es.getEligibility(ApexPages.currentPage().getParameters().get('Id'),MemberDetail.PreferredCoverage.GroupNumber,ApexPages.currentPage().getParameters().get('firstName'),ApexPages.currentPage().getParameters().get('lastName'),ApexPages.currentPage().getParameters().get('subjectdob'));
           }
        if (CalloutResult != null && CalloutResult.Success == true)
        {               

             ACETLGT_EligibilityService.Eligibilitywrap  er = (ACETLGT_EligibilityService.Eligibilitywrap)CalloutResult.Response;
              

            sniEligibility  = er.sniEligibility;
              sniEligibility = sniEligibility=='engaged'?'Engaged':
            sniEligibility=='eligible'?'Eligible':
            sniEligibility=='not eligible'?'Not Eligible':sniEligibility;
           
           if(er.hassnipermission=='true' ){
           MemberDetail.accTypes = er.accountTypes;
           MemberDetail.serviceGrp = er.serviceGroup;
            }
         
          }
          }
                    toggleOnPageLoad = true;
                    showCoverages();
                    system.debug('PreferredCoverage >>>>>> '+PreferredCoverage);
                    if(MemberDetail.SurrogateKey != null && MemberDetail.SurrogateKey != ''){
                        chainedContinuation = CallGetMembership();
                        CaseHistory = getMemberCaseHistory(MemberDetail.SurrogateKeys);
                    }
                }
                else{
                    MemberDetail.isServiceError = true;
                    ServiceErrorMSGs.add(findMemCalloutResults.Message);
                    setErrorMsg('GN'+findMemCalloutResults.statusCode,null);
                }                   
            }catch(Exception e){
                MemberDetail.isServiceError = true;
                setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 
            }
            
            try{
                getIndCalloutResults = ACETGetIndWebservice.ProcessResponse(ACETGetIndWebservice.RequestLabel, MemberDetail);
                
                system.debug(LoggingLevel.INFO, 'after call out '+getIndCalloutResults);
                if(getIndCalloutResults.Success) {
                    //MemberDetail.isServiceError = false;
                    MemberDetail = (ACETMemberDetail)getIndCalloutResults.Response;
                }
                else{
                    MemberDetail.isServiceError = true;
                    ServiceErrorMSGs.add(getIndCalloutResults.Message);
                    setErrorMsg('GN'+getIndCalloutResults.statusCode,null);
                }                   
            }catch(Exception e){
                MemberDetail.isServiceError = true;
                setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 
            }
        }
        try{
            //bhanu:optimization initHighlightPanelAdditionalInfo(true);//bhanu:Optimization : no need to init as we are not going to page untill next callback finish
            
            if(memNotFound != '1'){
                //createConsumerDashURL();//bhanu:Optimization  : No need to call here as Subject is null  
            try{        
                 toggleShowPrimaryPhysician();
            }catch(Exception e){
                system.debug(LoggingLevel.INFO, 'Exception Occured '+e.getstacktracestring());
                setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 
                }
                //ROIWrapperRecordsCreator(); 
                if(isGroupFlow == true){
                    getNoOfMemAlert();
                }
                if(MemberDetail.ROIcontacts != null){
                    if(MemberDetail.ROIcontacts.size() != 0){
                        isROI = true;   
                    }

                }

            }
            system.debug(LoggingLevel.INFO, 'CallWSonPageLoad '+MemberDetail.SurrogateKey);
      System.debug(LoggingLevel.INFO,'MemberDetail.isServiceError='+MemberDetail.isServiceError);
            if(MemberDetail.isServiceError != null && MemberDetail.isServiceError){
                if(ServiceErrorMSGs.contains (ACETWebserviceHelper.getErrorMessageFromCode(500)))
                   ServiceErrorMSGs=new Set<String>{ACETWebserviceHelper.getErrorMessageFromCode(500)};  
                if(ServiceErrorMSGs!=null && ServiceErrorMSGs.size()>0){ 
                    for(String msg : ServiceErrorMSGs){
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' '+msg));
                    }
                } 
            }
            system.debug(LoggingLevel.INFO, 'ServiceErrorMSGs '+ServiceErrorMSGs);
            
            //bhanu:optimization if(MemberDetail != null){
          //bhanu:optimization     MemberDetailResultJson =   json.serialize(MemberDetail);    
          //bhanu:optimization }           
            
            
        }catch(Exception e){
            //Some error has occurred
            system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
            setErrorMsg('GN997',e);  
        }     
        return chainedContinuation; 
    }    
    /*Call for UpdateindividualMembership*/
    public PageReference UpdatePCPOBGYN()   {

    try{
        String memberId = additionalInfo.MemberId;
        //String scrId = ApexPages.currentPage().getParameters().get('scr');//bhanu:optimization : already a class level variable
        String groupNumber= additionalInfo.GroupNumber;
        String lastName= additionalInfo.LastName;
        String firstname= additionalInfo.FirstName;
        //String ssn = ApexPages.currentPage().getParameters().get('ssn');//bhanu:optimization : already a class level variable
        String gender=additionalInfo.Gender;
        string dob=additionalInfo.DOB;
        string relationshipcode= MemberDetail.RelationShipCode;
        String currentpcpId = ApexPages.currentPage().getParameters().get('currentpcpId');
        String currentpcptype = ApexPages.currentPage().getParameters().get('currentpcptype');
        String currentpcpAssignmentType = ApexPages.currentPage().getParameters().get('currentpcpAssignmentType');

        Date Enddate = Date.parse(ApexPages.currentPage().getParameters().get('currentpcpeffectiveEndDate')); 
        Date StartDate = Date.parse(ApexPages.currentPage().getParameters().get('currentpcpeffectiveStartDate')); 
        
        String currentpcpeffectiveEndDate = ACETUtility.formatDatewithslash(ApexPages.currentPage().getParameters().get('currentpcpeffectiveEndDate'));
        String currentpcpeffectiveStartDate = ACETUtility.formatDatewithslash(ApexPages.currentPage().getParameters().get('currentpcpeffectiveStartDate'));
        List<ACETMemberDetail.Phone> PhoneList;
        try{
        ACETUpdateIndividualWebService UpdIndWebsrevice = new ACETUpdateIndividualWebService(); 
        if(currentpcpeffectiveEndDate!='' && currentpcpeffectiveEndDate != null){   
            
            ACETWSCalloutResult TermCalloutResult = UpdIndWebsrevice.updateMembers(memberId,  scrId, groupNumber, lastName, firstname, '', '', ssn, gender, dob, relationshipcode, '', '', '', PhoneList, currentpcpId, currentpcptype, currentpcpAssignmentType, string.valueOf(StartDate), string.valueOf(Enddate),'','','');
            
            if (TermCalloutResult.Success)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Termination successful'));//Need to code-Chandan
                setErrorMsg('GN211',null); 

            }
            else
            {
                //ApexPages.addMessage(new ApexPages.Message(TermCalloutResult.MessageSeverity,TermCalloutResult.Message));
                setErrorMsg('GN'+TermCalloutResult.statusCode,null); 
            } 
               
        }
       }catch(Exception e){
           setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 
           system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());     


       }
    }catch(Exception e){
         //Some error has occurred
          setErrorMsg('GN997',e);//GN997 -->Web Service or External System is temporarily unavailable 
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());     
     } 
        return null;
    }
 
    //function is used when changing subject from family member section
    @RemoteAction
    public static ACETWSCalloutResult findMember(String memberId, String firstName, String lastName, String dob){
    try{
        ACETFindMemberWebService service = new ACETFindMemberWebService();
        service.init(memberId, firstName, lastName, formatDateForWS(dob), '', '');
        return service.queryPaginatedData(1,10,1); 
    
    
    }catch(Exception e){
         system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
      //setErrorMsg('GN997',e);//GN997-->Unknown Error 

         return null;
    }
    }

    private static user getUserInfo(String userId) {
     User userInfo ;
     try{
        userInfo = [select Agent_Type__c,Profile.Name,FederationIdentifier from User where Id=: userId];
        
      }catch(Exception e){
        //Some error has occurred
        //setErrorMsg('GN997',e);//GN997-->Unknown Error 

        system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());     
      }
      return userInfo;
    }
    
    public List<SelectOption> getDisplayCallTopicOptions(){
        List<SelectOption> CallTopics = new List<SelectOption>();
        
        return CallTopics;
    }
    public void refreshSection(){
    }
    public void addTPtoOriginator(){
  
     try{
        //String tpChoosenId = Apexpages.currentPage().getParameters().get('tpChoosenId');
       tpChoosenName = Apexpages.currentPage().getParameters().get('tpChoosenName');
       selThirdPartyId = Apexpages.currentPage().getParameters().get('selThirdPartyRecId');
       System.debug('selThirdPartyId-->>> ' + selThirdPartyId);
       if(!String.Isblank(tpChoosenName)){
        boolean status=true;
        SelectOption TPOrign= new SelectOption('currentTp',tpChoosenName);
           for(SelectOption op:originators){
               if(op.getValue()=='currentTp'){
                  op.setLabel(tpChoosenName);
                  status=false;
               }
           }
        if(status)originators.add(TPOrign);
        originator='currentTp';
        Interaction.Originator_Name__c = tpChoosenName;
        Interaction.Originator__c = null;
        try{
         update Interaction;
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//996--> Exception during Dml Transaction
        }
            
        }
       }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//GN997-->Unknown Error 
            
      } 
    }
    public static string formatDateForWS(string datestr){
        if(dateStr != null && !string.IsBlank(dateStr)){
            String[] datelst = dateStr.split('/');
            return datelst[2]+'-'+datelst[0]+'-'+datelst[1];
        }else
        return null;
    }
    public void showHoldCode(){
        if(currentAgentProfile == 'ACET Member' || currentAgentProfile == 'ACET Provider') {
            callHoldRestrictions();
        }
        holdCodeAlert = true;
    }   
    public void hideHoldCode(){
        holdCodeAlert = false;
    }
    public void callHoldRestrictions(){
        try{
            System.debug('enter hold restrictions');
            ACETHoldRestrictionsWebservice holdRestWS = new ACETHoldRestrictionsWebservice();
            ACETWSCalloutResult WSResponse = holdRestWS.holdRestriction(MemberDetail.MemberId, AdditionalInfo.GroupNumber, '', 'All', 'All');
            System.debug('hold restrictions member detail: ' + WSResponse);
            if(!WSResponse.success){
              if(WSResponse.statusCode!=null){
                HoldRestStatus = WSResponse.statusCode;
               }
            }
            ACETMemberDetail tempMem = (ACETMemberDetail) WSResponse.response;
            if(tempMem!=null){
            memberDetail.holdCodeList = tempMem.holdCodeList;
            }
        }catch(Exception e){
             system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
             setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }
    }
      public void showHoldErrorMsgs(){
          if(HoldRestStatus!=null){
            if(HoldRestStatus==400){
               setErrorMsg('GN'+'400B');
               HoldRestStatus=null;
            }else{
               setErrorMsg('GN'+HoldRestStatus);
               HoldRestStatus=null;
             }
          }   
      }
	
	/**
    * @description 
    * @author Hasara | 08-06-2021 | Styx
    **/
    public void getAncillaryData(){
        ACETLGT_AncillaryPlansController.AncillaryData data = new ACETLGT_AncillaryPlansController.AncillaryData();
        if(ancillaryCount==0 && MemberDetail != null && MemberDetail.PreferredCoverage != null && AdditionalInfo!=null){
            String benEffectiveDate = new ACETLGT_FindIndMemberShipsWebService().getBenefitEffectiveDate(memberDetail.PreferredCoverage.EffectiveDate,memberDetail.PreferredCoverage.COEffectiveDate);
        	String benEndDate = new ACETLGT_FindIndMemberShipsWebService().getBenefitEndDate(memberDetail.PreferredCoverage.EndDate,memberDetail.PreferredCoverage.COEndDate);
            data.groupNumber =  MemberDetail.PreferredCoverage.GroupNumber!=NULL?MemberDetail.PreferredCoverage.GroupNumber.escapeHtml4():'';
            data.benefitBundleOptionId = AdditionalInfo.BenefitBundleOptionId;
            data.identifier = MemberDetail.SurrogateKey!=NULL?MemberDetail.SurrogateKey.escapeHtml4():'';
            data.membersearch = true;
            data.asofdate = calculateAsofDate(MemberDetail);
            data.effectivedate = benEffectiveDate;
            data.enddate = benEndDate;
            system.debug('@requestdata '+data);
            AncillaryPlansList = processAncillaryData(data);
            ancillaryCount=ancillaryCount+1;
        } 
    }
    
    public string calculateAsofDate(ACETMemberDetail memberDetail){
        Boolean isActive =  new ACETLGT_FindIndMemberShipsWebService().isActiveCoverage(memberDetail.PreferredCoverage.EffectiveDate, memberDetail.PreferredCoverage.EndDate);
        Boolean isFuture = Date.Parse(memberDetail.PreferredCoverage.EffectiveDate) > Date.today() ? True : False;
        Boolean isTermed = (String.isNotBlank(memberDetail.PreferredCoverage.EndDate) && memberDetail.PreferredCoverage.EndDate!='12/31/9999' && Date.Parse(memberDetail.PreferredCoverage.EndDate) < Date.today() )? True : False;
        String accumAsOfDate = (isTermed?memberDetail.PreferredCoverage.EndDate:(isFuture?memberDetail.PreferredCoverage.EffectiveDate:ACETWebserviceHelper.formatDateFromDashToSlash(String.ValueOf(Date.today()))));
        return accumAsOfDate;
    }
  
    public list<AncillaryPlans> processAncillaryData(ACETLGT_AncillaryPlansController.AncillaryData data){
        ACETLGT_AncillaryPlansController.AncillaryWrapper outputResp = ACETLGT_AncillaryPlansController.getAncillaryPlansData(JSON.serialize(data));
        list<AncillaryPlans> ancillaryPlansInputList = new list<AncillaryPlans>();
        String resp = outputResp.response;
        system.debug('@@finalresp'+resp);
        Map<String, Object> jsonresponse = (Map<String, Object>)JSON.deserializeUntyped(resp);
        if ((Boolean)jsonresponse.get('Success')) {
            Map<String, Object> finalrespMap = (Map<String, Object>)jsonresponse.get('Response');
            Map<String, Object> finalresp =  (Map<String, Object>)finalrespMap.get('searchResult');
            ACETAncillaryPlansResponse.SearchOutput output = (ACETAncillaryPlansResponse.SearchOutput)JSON.deserialize(JSON.serialize(finalresp.get('searchOutput')), ACETAncillaryPlansResponse.SearchOutput.class);
            if(output.benefitBundle!=null && output.benefitBundle.size()>0){ 
                list<ACETAncillaryPlansResponse.Plan> plans = new list<ACETAncillaryPlansResponse.Plan>();
                plans = output.benefitBundle[0].plan;
                for(integer i=0; i<plans.size(); i++){
                    AncillaryPlans outputwrap = new AncillaryPlans();
                    outputwrap.planname = plans[i].planName;
                    outputwrap.plantype = plans[i].planType;
                    outputwrap.planLanguage = plans[i].planLanguage;
                    list<ACETAncillaryPlansResponse.Incentives> incentives = plans[i].incentives;
                    list<AncillaryPlans.incentives> incentiveList = new list<AncillaryPlans.incentives>();
                    incentiveList = processIncentives(incentives);
                    Integer sizeinc = incentiveList.size();
                    switch on sizeinc{
                        when 0{
                            outputwrap.incentivecheck = false;
                        }
                        when else{
                            outputwrap.incentivecheck = true;
                            outputwrap.incentives = incentiveList;
                        }
                    }
                    outputwrap.accordioncheck = false;
                    ancillaryPlansInputList.add(outputwrap);
                }
                system.debug('@@finaloutput'+ancillaryPlansInputList);
            }
             noresults = ancillaryPlansInputList.size()>0?false:true;
        }else if((Integer)jsonresponse.get('statusCode')==404){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' No Ancillary Plans exist for the selected Member.')); 
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' '+(String)jsonresponse.get('Message')));
        }
        return ancillaryPlansInputList;
    }
    
    public list<AncillaryPlans.incentives> processIncentives(list<ACETAncillaryPlansResponse.Incentives> incentives){
        list<AncillaryPlans.incentives> incentiveList = new list<AncillaryPlans.incentives>();
        if(incentives!=null){
            for(integer k=0; k<incentives.size(); k++){
                AncillaryPlans.Incentives incentivewrap = new AncillaryPlans.Incentives();
                String reward = incentives[k].rewardMethod;
                switch on reward{
                    when '01'{
                        incentivewrap.rewardmethod = 'Spending Account';
                    }
                    when '02'{
                        incentivewrap.rewardmethod = 'Cost Share Check';
                    }
                    when '03'{
                        incentivewrap.rewardmethod = 'Cost Share Gift Card';
                    }
                    when '04'{
                        incentivewrap.rewardmethod = 'ACH / Direct Deposit'; 
                    }
                    when else{
                        incentivewrap.rewardmethod = '';
                    }
                }
                incentivewrap.dailyrewardamount = incentives[k].dailyMaxRewardAmount;
                incentivewrap.annualrewardamount = incentives[k].annualMaxRewardAmount;
                incentivewrap.effectivedate = ACETWebserviceHelper.formatDateFromDashToSlash(incentives[k].effectiveDate);
                incentivewrap.expirationdate = ACETWebserviceHelper.formatDateFromDashToSlash(incentives[k].expirationDate);
                String calculation = incentives[k].calculationBasis;
                if(calculation=='01'){
                    incentivewrap.calculationbasis = 'Date Certain';
                }else if(calculation=='02'){
                    incentivewrap.calculationbasis = 'On Renewal';
                }
                incentiveList.add(incentivewrap);
            }
        }
        return incentiveList;
    }
    public void toggleAncillaryData(){
        String indexno = ApexPages.currentPage().getParameters().get('toggleParam');
        Integer index = Integer.valueOf(indexno);
        system.debug('test '+indexno);
        if(AncillaryPlansList[index].accordioncheck){
            AncillaryPlansList[index].accordioncheck=false;
        }else{
        	AncillaryPlansList[index].accordioncheck=true;
        }
    }
    
    public void toggleancillarytab(){
        if(showancillary){
            showancillary=false;
        }else{
            showancillary=true;
        }
    }
}