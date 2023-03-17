public with sharing class ACETViewEmployerGroupController extends ACETErrorHandler 
{
    public ACETCallTopicsDataWrapper wrapper{get;set;}
    @TestVisible private String Subject; 
    public static Set<String> planOptionIds{get;set;}
    public boolean memberEnrollment{get;set;} 
    public ACETGroupDetail groupDetails{get;set;}
    public string groupNumber{get;set;}
    public string parentPEOId{get;set;}
    public Boolean showAcknowledgement{get;set;}
    public String acknowledgementMessage{get;set;}
    public String acknowledgementHeader{get;set;}
    public Integer caseListSize{get;set;}
    public Interaction__c Interaction {get;set;}
    public string OriginatorName{get;set;}
    public List<SelectOption> OriginatorNames{get;set;}
    public string ContactType{get;set;}
    public List<SelectOption> ContactTypes{get;set;}
    Public list<ACETGroupDetail.GroupAffiliationsinfo> grpAffiliationsinfolist {get;set;}
    public String grpAffiliationsinfolistStr{get;set;}//DE450940
    public string ContactName{get;set;}
    public boolean displayCName{get;set;} 
    public boolean isProdHistory{get;set;} 
    public boolean isContHistory{get;set;}
    public boolean isAddrHist{get;set;}
    public String selectedValue;
    public string contName;
    public String SourceOriginator ;
    public contact subjectObj{get;set;}
    public list<Alert__c> lstGroupAlert{get;set;}
    public Integer resultSize{get;set;}
    public boolean isShowGroupALert{get;set;}
    public boolean groupNotFound{get;set;}
    public boolean isGroupALertModal{get;set;}
    //public string statusPopup{get;set;}
    public string OnshoreRestrictionCode {get;set;}
    public string OnshoreRestrictionText {get;set;}
    public string OnshoreRestrictionTooltip {get;set;}
    public String TooltipText { get; set; }
    public String Zip { get; set; }
    public String PhoneNumber { get; set; }
    public String State { get; set; }
    public String EmployerName { get; set; }
    public Double Offset{get;set;} 
    public String swivelBASICS_URL{get; set;}
    public Boolean isGroupHistory{get;set;} 
    public Id personAccrecordtypeId{get;set;}
    Public Boolean isgroupaffliationstab{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
      //return JSON.serialize(AdditionalInfo);
      return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
    }set;}
    public transient list<case> caseHistoryList{get;set;}
    public transient ACETGetEmployerDetailAdapterWebService ACETGetGDWebservice;
    Public List<ACETProducerSearchResult> ProducerSearchResults{get;set;} 
    Public List<ACETProducerSearchResult> ProducerSearchResultsFuture{get;set;}
    Public List<ACETProducerSearchResult> ProducerSearchHistResults{get;set;} 
    Public List<ACETProducerSearchResult> producerTypeBRestuls{get;set;}
    Public List<ACETProducerSearchResult> producerTypeIRestuls{get;set;}
    Public List<ACETProducerSearchResult> producerTypeAllResults{get;set;}
    Public List<ACETProducerSearchResult> producerTypeAgentResults{get;set;}
    Public List<ACETProducerSearchResult> producerTypeGeneralAgentResults{get;set;}
    Public List<ACETProducerSearchResult> producerTypeServiceProviderResults{get;set;}
    Public List<ACETProducerSearchResult> producerHistoryAgentResults{get;set;}
    Public List<ACETProducerSearchResult> producerHistoryGeneralAgentResults{get;set;}
    Public List<ACETProducerSearchResult> producerHistoryServiceProviderResults{get;set;}
    Public Map<String, ACETProducerSearchResultWrapper> producerSearchMap {get;set;}
    Public Map<String, ACETProducerSearchResultWrapper> producerHistorySearchMap {get;set;}
    Public List<SelectOption> producerAddInfoOptions {get;set;}
    Public List<SelectOption> producerAddInfoGeneralOptions {get;set;}
    Public String producerAddInfoGeneralSelected {get;set;}
    Public String producerAddInfoAgentSelected {get;set;}
    Public String producerAddInfoServiceSelected {get;set;}
    Public String producerAddInfoHistGeneralSelected {get;set;}
    Public String producerAddInfoHistAgentSelected {get;set;}
    Public String producerAddInfoHistServiceSelected {get;set;}
    Public String selectedProducer{get;set;}
    Public String producerMaskedSSn{get;set;}
    //private Map<String, String> DisplayTextMap;
    //private Map<String, String> TooltipTextMap;
    public boolean IsRestrict{get;set;}
    public boolean IsOnshore{get;set;}
    
    //public String currentAgentProfile{get;set;}
    public Map<String,ACETProducerSearchResult> prodOrignatMap;
    public string extContactSelected{get;set;}
    public list<SelectOption> extContacts{get;set;}
    public set<string> uniqueContacts {get;set;}
    public list<ACETGroupDetail.groupContactInfo> filteredContactList {get;set;}
    public list<ACETGroupDetail.SpecialtyBenefits_CoverageLine> specialityBenefits {get;set;}
    
    // getEmp V3 changes start
    public Boolean holdCodeAlert{get; set;} //US953096
    public string policyStatusSelected{get;set;}
    public List<SelectOption> PolicyStatus {get;set;}
    public transient list<ACETGroupDetail.PolicyContract> policyContractFiltered{get;set;}
    public string continuationType;     
    public string responsibilityType;
    public string onshorerestriction;
    public String polContractId{get;set;}
    public String polContractEffDate{get;set;}
    public String polContractEndDate{get;set;}
    public String polStatus{get;set;}
    public String polContractSitusState{get;set;}
    public String Urlstr ;//= ApexPages.currentPage().getURL();
    // getEmp V3 changes end
    public ACETViewEmployerGroupController(){
      try{
        isgroupaffliationstab = false;
        caseListSize=0;
        resultSize = 0;
        displayCName = false;
        isProdHistory = false;
        isContHistory = false;
        isAddrHist = false;
        IsRestrict = false;
          showAcknowledgement = false;
          List<Group_Modal_Message__mdt> modalMessage = [SELECT Message__c,Header__c FROM Group_Modal_Message__mdt Where MasterLabel='Child PEO Message'];
          if(modalMessage!=null && modalMessage.size()>0){
              acknowledgementMessage = modalMessage[0].Message__c ;
              acknowledgementHeader = modalMessage[0].Header__c ;
          }
          
          specialityBenefits = new list<ACETGroupDetail.SpecialtyBenefits_CoverageLine>();
        Urlstr = ApexPages.currentPage().getURL();
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        User currentUser = [SELECT Profile.Name, Agent_Type__c FROM User WHERE Id = :UserInfo.getUserId()];
        //currentAgentProfile = currentUser.profile.name;
        if(currentUser.Agent_Type__c == 'Onshore')
            IsOnshore = true;
        else
            IsOnshore = false;
        system.debug('@@@IsOnshore'+IsOnshore );
        personAccrecordtypeId = ACETMemberQueryUtil.getPersonAccountRecordType();
        fetchBASICSsysURL(); 
        
         timeZone tz = UserInfo.getTimeZone();
        offset = tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        
        groupDetails = new ACETGroupDetail();
        wrapper = new ACETCallTopicsDataWrapper();
        isShowGroupALert = false;
        string gnf = apexpages.currentpage().getparameters().get('gnf');
        system.debug('@@@gnf :: ' + gnf);
        groupNotFound = false;
        producerAddInfoOptions = new List<SelectOption>();
        producerAddInfoOptions.add(new SelectOption('None','None'));
        producerAddInfoOptions.add(new SelectOption('Payee','Payee'));
        producerAddInfoOptions.add(new SelectOption('Writing Agent','Writing Agent'));
        producerAddInfoGeneralOptions = new List<SelectOption>();
        producerAddInfoGeneralOptions.add(new SelectOption('None','None'));
        producerAddInfoGeneralOptions.add(new SelectOption('Payee','Payee'));
        contactType = apexpages.currentpage().getparameters().get('RelationshipType');
        if(gnf == '1'){
            groupNotFound = true;
            AdditionalInfo.isGroupNotFound = '1';
            GroupNumber = apexpages.currentpage().getparameters().get('Id');
            
            EmployerName = apexpages.currentpage().getparameters().get('gnfEmployerName');
            Zip = apexpages.currentpage().getparameters().get('gnfzipcode');
            State = apexpages.currentpage().getparameters().get('gnfState');
            PhoneNumber = apexpages.currentpage().getparameters().get('gnfPhoneNumber');
            
            ContactName =Apexpages.currentPage().getParameters().get('contactName');
            AdditionalInfo.EmployerName = EmployerName;
            AdditionalInfo.contactName = ContactName;
            AdditionalInfo.GroupNumber = GroupNumber;
            AdditionalInfo.Zip = Zip ;
            AdditionalInfo.State = State;
            system.debug('@@@gnf-----ContactType-------> :: ' + ContactType);
            if(ContactType != '----None----')
            {
                AdditionalInfo.RelationshipType = ContactType;
                AdditionalInfo.OriginatorRelationship = contactType;

            }
            AdditionalInfo.GroupN = GroupNumber;
            AdditionalInfo.PhoneNumber = PhoneNumber;
            system.debug('@@@gnf------------> :: ' + AdditionalInfo);
        }   
        Subject = apexpages.currentpage().getparameters().get('Subject');
        groupNumber = apexpages.currentpage().getparameters().get('Id');
        
        SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator');
        OriginatorNames = null;
        memberEnrollment = true;
        
        ContactTypes = new list<SelectOption>();
        ContactTypes.add(new SelectOption('----None----','----None----')); 
        extContacts = new list<SelectOption>();
        extContacts.add(new SelectOption('----None----','----None----'));
        
     
        
        initHighlightPanelAdditionalInfo(); 
        initInteraction();
        prodOrignatMap = new Map<String, ACETProducerSearchResult>();
        }catch(Exception ex){
          setErrorMsg('MGD997',ex);
        }
    }
    
     public void fetchBASICSsysURL()
    {
        string sandboxName = ACETUtility.GetOrgName();
        swivelBASICS_URL = ACETUtility.GetSwivelEndpointByOrgName(sandboxName, 'BASICS');
    }  
    // getEmp V3 changes start
    //US953096 starts
    public void showHoldCode(){
        holdCodeAlert = true;
    }   
    public void hideHoldCode(){
        holdCodeAlert = false;
    }
    //US953096 ends
    // getEmp V3 changes end
    
     public PageReference CallWSOnProdHistoryClick() {
        try{
            isProdHistory = true;
          //  ACETFindProducerWebservice ACTFPWS = new ACETFindProducerWebservice();
	  //groupNumber = '0030045' ;    
	  //  ACETWSCalloutResult CalloutResult = ACTFPWS.FindProducers('','','', '',groupNumber, '', '', '', '', '','','0'); 
            ACETFindProducerAPI ACTFPWS = new ACETFindProducerAPI();
	    ACETWSCalloutResult CalloutResult = ACTFPWS.FindProducerDetail('', '', '', '', groupNumber, '', '', '', '', '', '', '0'); 
	    system.debug('CalloutResult:: ' + CalloutResult);         
            if (CalloutResult.Success)
            {   
                ProducerSearchHistResults = new List<ACETProducerSearchResult>();
                ProducerSearchHistResults = (list<ACETProducerSearchResult>)CalloutResult.Response;
                system.debug('ProducerSearchHistResults:: ' + ProducerSearchHistResults);
                producerSerachResultsSplit(ProducerSearchHistResults, 'N');
            }
            else{
               if(CalloutResult.statusCode==001){
                  setErrorMsg('GN'+'400B',null);
                }else if(CalloutResult.statusCode==002||CalloutResult.statusCode==005){
                  setErrorMsg('GN'+'500',null);
                }
                else{
                  setErrorMsg('GN'+CalloutResult.statusCode,null);
                }
                //ApexPages.addMessage(new ApexPages.Message(calloutResult.MessageSeverity, calloutResult.Message));    
            }   
        }
        catch(Exception e){
         setErrorMsg('MGD997',e);
        }
        return null;   
    }
    
    
    
    public void contactHistoryWindow(){
    
        isContHistory = true;
    }
    
    public void addressHistoryWindow() {
        isAddrHist = true;
    }
     public void resetWindow(){
    
        isProdHistory = false;
        isContHistory = false;
        isAddrHist = false;
    
    }
    //getemp V3 starts
    public void updatePolicyContract(){
        AdditionalInfo.EffectiveStartDate = polContractEffDate;
        AdditionalInfo.selectedPolicyContract = polContractId;
        AdditionalInfo.SitusState = polContractSitusState;  // Added by Abhinav for US2667418 - Situs state to highlightspanel and case detail
    }
        
    public void updateTPContactName()
    {
     try{
        selectedValue =Apexpages.currentPage().getParameters().get('selectedVal');
        if(selectedValue != Null)
        {
           
            OriginatorNames.add(new SelectOption('currentTP',selectedValue));
            OriginatorName = 'currentTP';
            ContactTypes = new list<SelectOption>();
            ContactTypes.add(new SelectOption('----None----','----None----'));
            ContactName = '';
            displayCName = true;
            //Interaction.Contact_Name__c = selectedValue;
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    system.debug('JSONBody---->'+JSONBody);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
            }
            update Interaction;
            
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        }
       }
       catch(Exception e){
        setErrorMsg('MGD997',e);
       } 
    }
    
   public void createUpdateContact(){   
      try{  
         String contName;
         list<contact> contactRec = new list<Contact>();
         system.debug('Contact name in update contact'+ContactName);
         system.debug('Originator name in update contact'+OriginatorName);
         if(ContactName == Null && ContactName == '')
         {
             ContactName =Apexpages.currentPage().getParameters().get('contactName');        
         }  
         AdditionalInfo.RelationshipType = ContactType;
         AdditionalInfo.OriginatorRelationship = contactType;
         AdditionalInfo.contactName = ContactName;
         system.debug('ContactName ---->'+ContactName);
         hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
         if(ContactName != Null && ContactName != '')
         {        
             contName = OriginatorName; 
             if(groupDetails != Null && groupDetails.genGroupInfo != Null){
                 contactRec = [select id,AccountId,LastName,Contact_Type__c,EID__c,Tax_Id__c from Contact where EID__c =: groupDetails.genGroupInfo.groupId];
             }
                
            if(ContactType != '----None----')
            {
                AdditionalInfo.RelationshipType = ContactType;
                AdditionalInfo.OriginatorRelationship = contactType;
                AdditionalInfo.contactName = ContactName;
                hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
            }else
            {
                AdditionalInfo.RelationshipType = '';
                hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
            } 
            system.debug('hpAdditionInfoStr ----->'+hpAdditionInfoStr);
            if(contName != Null && prodOrignatMap.containsKey(contName))
            { 
                 List<contact> prodCont = new List<Contact>();
                 ACETProducerSearchResult res = prodOrignatMap.get(contName);
                 prodCont=[select id,AccountId,LastName,Contact_Type__c,EID__c,Tax_Id__c from Contact where EID__c =:res.ProducerID];
                 if(prodCont.size()==0){                 
                     string contactId = createandUpdateProdContact(res.FirstName,res.LastName,res.ProducerID,res.CompanyName);
                     system.debug('contactId----->'+contactId);
                     Interaction.Originator__c = contactId;
                     //Interaction.Contact_Name__c = ContactName;
                     Interaction.Caller_Type__c = ContactType;
                }else{
                     //account accountObj = [select id,name,EID__c,Tax_Id__c from account where id=: contactRec[0].accountId];
                     //string contactId = createUpdateAccountContact(contactRec[0],accountObj,OriginatorName);
                     //Interaction.Contact_Name__c = ContactName;
                     Interaction.Originator__c = prodCont[0].id;
                     Interaction.Caller_Type__c = ContactType;
                }
                
             }
             if(contName != Null && groupDetails.genGroupInfo != null && contName==groupDetails.genGroupInfo.groupName){   // getEmp V3 changes
                    if(contactRec.size()==0){
                     account accountObj = new account();
                     contact contactObj = new contact();
                     string contactId = createUpdateAccountContact(contactObj,accountObj,contName);
                     system.debug('contactId----->'+contactId);
                     Interaction.Originator__c = contactId;
                     //Interaction.Contact_Name__c = ContactName;
                     Interaction.Caller_Type__c = ContactType;  
                  }else{
                     account accountObj = [select id,LastName,EID__c,Tax_Id__c from account where id=: contactRec[0].accountId];
                     string contactId = createUpdateAccountContact(contactRec[0],accountObj,OriginatorName);
                     //Interaction.Contact_Name__c = ContactName;
                     Interaction.Originator__c = contactRec[0].id;
                     Interaction.Caller_Type__c = ContactType;
                    } 
             }
             if(groupDetails != null && groupDetails.genGroupInfo != null) {  
                string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                system.debug('groupName ----->'+groupName );
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    system.debug('JSONBody---->'+JSONBody);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
                 update Interaction;
                 Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);    
             }
          }
          isShowGroupALert = true;
         }
         catch(Exception e){
          setErrorMsg('MGD997',e);
         }
    }
 
    public void addTPtoOriginator(){
         
        try{
           //String tpChoosenId = Apexpages.currentPage().getParameters().get('tpChoosenId');
          String tpChoosenName = Apexpages.currentPage().getParameters().get('tpChoosenName');
          String selThirdPartyId = Apexpages.currentPage().getParameters().get('selThirdPartyRecId');
          System.debug('selThirdPartyId-->>> ' + selThirdPartyId);
          if(!String.Isblank(tpChoosenName)){
           boolean status=true;
           SelectOption TPOrign= new SelectOption('currentTp',tpChoosenName);
              for(SelectOption op:OriginatorNames){
                  if(op.getValue()=='currentTp'){
                     op.setLabel(tpChoosenName);
                     status=false;
                  }
              }
           if(status)OriginatorNames.add(TPOrign);
           OriginatorName='currentTp';
           
           Interaction.Originator_Name__c = tpChoosenName;
           Interaction.Originator__c = null;
           try{
            update Interaction;
           }catch(Exception e){
               system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
               setErrorMsg('GN997',e);//996-->Exception during Dml Transaction
           }
               
           }
          }catch(Exception e){
             system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
             setErrorMsg('GN997',e);//GN997-->Unknown Error 
               
         } 
       }
       
       public void addProdToOriginator(){
         
        try{
           //String tpChoosenId = Apexpages.currentPage().getParameters().get('tpChoosenId');
          String prodChoosenName = Apexpages.currentPage().getParameters().get('prodChoosenName');
          if(!String.Isblank(prodChoosenName)){
           boolean status=true;
           SelectOption prodOrign= new SelectOption(prodChoosenName,prodChoosenName);
            
              for(SelectOption op:OriginatorNames){
                  if(op.getValue()==prodChoosenName){
                     op.setLabel(prodChoosenName);
                     status=false;
                  }
              }
           if(status)OriginatorNames.add(prodOrign);
           //OriginatorName='currentTp';
           
           Interaction.Originator_Name__c = prodChoosenName;
           OriginatorName = prodChoosenName;
           Interaction.Originator__c = null;
           try{
            update Interaction;
           }catch(Exception e){
               
               setErrorMsg('GN997',e);//996-->Exception during Dml Transaction
           }
               
           }
          }catch(Exception e){
             system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
             setErrorMsg('GN997',e);//GN997-->Unknown Error 
               
         } 
       }
       
     public string createUpdateAccountContact(contact contactObj,Account accountObj,string contName)
    {
        try
        {
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                accountObj.EID__c = groupDetails.genGroupInfo.groupId;
                accountObj.EID__pc = groupDetails.genGroupInfo.groupId;
            }
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                accountObj.Tax_Id__c = groupDetails.genGroupInfo.groupTaxId;
                accountObj.Tax_ID__pc = groupDetails.genGroupInfo.groupTaxId;
            }
            accountObj.LastName =contName;
            accountObj.Contact_Type__pc= 'Group/Employer';
            accountObj.RecordTypeId = personAccrecordtypeId;
            
            upsert accountObj;
            Account acc =[SELECT Id,personcontactId from Account where Id=:accountObj.Id];
            contactObj= [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactId];
 
        }catch(Exception ex){
            setErrorMsg('MGD997',ex);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETUnexpectedErrorMessage));
        }  
        return contactObj.id;
    
    }
        public string createandUpdateProdContact(string firstNameParam,string lastNameParam,string producerIdParam,string companyName){
        Account UpsertAccount;
        Contact Subject;
        List<Account> existingAccount =  [SELECT Id,EID__c,personcontactId,FirstName,LastName from Account where EID__c =: producerIdParam AND IsPersonAccount = true];
        if(companyName!=''){
          lastNameParam = companyName;
        }
        if(existingAccount.size() == 0){
            UpsertAccount = new Account();
            UpsertAccount.FirstName = firstNameParam;
            UpsertAccount.LastName =lastNameParam;
            UpsertAccount.EID__c = producerIdParam;
            UpsertAccount.EID__pc = producerIdParam;
            UpsertAccount.Contact_Type__pc= 'Producer';
            UpsertAccount.Tax_ID__pc = producerIdParam;
            UpsertAccount.RecordTypeId = personAccrecordtypeId;
            Insert UpsertAccount;
        }else{
            UpsertAccount = existingAccount[0];
            UpsertAccount.FirstName = firstNameParam;
            UpsertAccount.LastName =lastNameParam;
            upsert UpsertAccount;
        } 
        system.debug('UpsertAccount :: ' + UpsertAccount);
        Account acc =[SELECT Id,personcontactId from Account where Id=:UpsertAccount.Id];
        Subject = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactId];
        system.debug('Subject :: ' + Subject);

        return Subject.Id;
    }
    public void updateProcucertab(){
        try{
                String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
               // ContactName = '';
                OriginatorNames= null;
                
                String fastTrack = ApexPages.currentPage().getParameters().get('fastTrack');
                if(fastTrack == 'true'){                    
                 ContactName = ApexPages.currentPage().getParameters().get('contactName'); 
                   if(Interaction.Originator__c != null){    
                    OriginatorNames= new List<SelectOption>();
                    OriginatorNames.add(new SelectOption(Interaction.Originator__r.Name,Interaction.Originator__r.Name));
                    OriginatorName = Interaction.Originator__r.Name;    
                      }else{
                     String OriginatorName = ApexPages.currentPage().getParameters().get('OriginatorName');               
                    OriginatorNames= new List<SelectOption>();
                    OriginatorNames.add(new SelectOption(OriginatorName,OriginatorName));
                    OriginatorName = Interaction.Originator__r.Name;
                }
                    ContactTypes = new list<SelectOption>(); 
                    ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));
                    ContactName = ApexPages.currentPage().getParameters().get('contactName');                  
                    displayCName = true;
                        
                }else{
                    if(Interaction.Originator_Type__c == 'Producer')
                    {
                        OriginatorNames= new List<SelectOption>();
                        OriginatorNames.add(new SelectOption(Interaction.Originator__r.Name,Interaction.Originator__r.Name));
                        OriginatorName = Interaction.Originator__r.Name;
                        ContactTypes = new list<SelectOption>(); 
                        if(AdditionalInfo != Null)
                        ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));
                        displayCName = true;
                        ContactName = '';
                        ContactName = AdditionalInfo.producerName;
                        displayCName = true;
                    } 
                    if(Interaction.Originator_Type__c == 'Other'){
                        OriginatorNames= new List<SelectOption>();
                        OriginatorNames.add(new SelectOption(Interaction.Originator_Name__c,Interaction.Originator_Name__c));
                        OriginatorName = Interaction.Originator_Name__c;
                        ContactTypes = new list<SelectOption>(); 
                        if(AdditionalInfo != Null && AdditionalInfo.RelationshipType != null)
                            ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));//AdditionalInfo.RelationshipType
                        displayCName = true;
                        ContactName = '';
                        if(groupnotfound == false)
                        ContactName = Interaction.Third_Party__r.first_Name__c ;
                        else{
                            Integer conNamePos = URLstr.indexOf('contactName');
                            Integer ConNameEnd = URLstr.indexOf('%22ConsumerAccountIndicator');
                            system.debug('-----conNamePos --->'+ conNamePos );
                            if(conNamePos != -1 && ConNameEnd != -1)
                            ContactName = URLstr.substring(conNamePos + 20 , ConNameEnd - 6); 
                            ContactName = ContactName.replace('+',' ');   
                        }
                        AdditionalInfo.contactName = ContactName;
                        displayCName = true;    
                    } 
                }
                
                
            }catch(Exception ex){
               setErrorMsg('MGD997',ex);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable ));
            } 
            initInteraction();        
     } 
    
    
    public void createThirdPartySubject()
    {
      try{
        list<contact> contactRec = new list<Contact>();
        if(groupDetails != Null && groupDetails.genGroupInfo != Null)
        {
            contactRec = [select id,EID__c from Contact where EID__c =: groupDetails.genGroupInfo.groupId];
            if(contactRec.size() == 0)
            {    
                Account accountObj = new Account();
                accountObj.LastName =groupDetails.genGroupInfo.groupName;
                accountObj.EID__c = groupDetails.genGroupInfo.groupId;
                accountObj.EID__pc = groupDetails.genGroupInfo.groupId;
                accountObj.Contact_Type__pc= 'Group/Employer';
                accountObj.Tax_Id__c = groupDetails.genGroupInfo.groupTaxId;
                accountObj.Tax_ID__pc = groupDetails.genGroupInfo.groupTaxId;
                accountObj.RecordTypeId = personAccrecordtypeId;
                upsert accountObj;
                Account acc =[SELECT Id,personcontactId from Account where Id=:accountObj.Id];
                subjectObj= [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactId];
                
            }else
            {
                subjectObj = contactRec[0];
                caseHistory();
            }
        }
       }
       catch(Exception ex){
        setErrorMsg('MGD997',ex);
       }
       
    }
    
     private void initHighlightPanelAdditionalInfo(){
     try{
      system.debug('23232323AdditionalInfo' + AdditionalInfo);
       string gnf = apexpages.currentpage().getparameters().get('gnf');
      if(gnf == '1'){
              if(AdditionalInfo == null){
                            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
              }
              string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
              system.debug('addInfo ----->'+addInfo );
              
              if(addInfo != null && addInfo != '')
              {
                  AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
                         
              }
              if(AdditionalInfo == null){
                            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
              }
                groupNotFound = true;
                AdditionalInfo.isGroupNotFound = '1';
                GroupNumber = apexpages.currentpage().getparameters().get('Id');
                
                EmployerName = apexpages.currentpage().getparameters().get('gnfEmployerName');
                Zip = apexpages.currentpage().getparameters().get('gnfzipcode');
                State = apexpages.currentpage().getparameters().get('gnfState');
                PhoneNumber = apexpages.currentpage().getparameters().get('gnfPhoneNumber');
                
                ContactName =Apexpages.currentPage().getParameters().get('contactName');
                AdditionalInfo.EmployerName = EmployerName;
                AdditionalInfo.contactName = ContactName;
                AdditionalInfo.GroupNumber = GroupNumber;
                AdditionalInfo.Zip = Zip ;
                AdditionalInfo.State = State;
                system.debug('@@@gnf-----ContactType-------> :: ' + ContactType);
                if(ContactType != '----None----')
                {
                    AdditionalInfo.RelationshipType = ContactType;
                    AdditionalInfo.OriginatorRelationship = contactType;
    
                }
                AdditionalInfo.GroupN = GroupNumber;
                AdditionalInfo.PhoneNumber = PhoneNumber;
                system.debug('@@@gnf------------> :: ' + AdditionalInfo);
      }
      
      else
      
      {
                if(AdditionalInfo == null){
                    AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
                }
                string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
                system.debug('addInfo ----->'+addInfo );
                
                if(addInfo != null && addInfo != '')
                {
                    AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
                           
                }else{
                         system.debug('232323inside else' + AdditionalInfo);
                }  
                system.debug('232323 grpdetails'+groupDetails + groupDetails.genGroupInfo);   
                if(groupDetails != Null && groupDetails.genGroupInfo != Null)
                {
                        if(AdditionalInfo == null){
                            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
                        }
                        system.debug('AdditionalInfo ----->'+AdditionalInfo );
                        AdditionalInfo.UHCBS = groupDetails.genGroupInfo.UHCBSCOBRA;    
                        AdditionalInfo.GroupN = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                        AdditionalInfo.GroupStatus = groupDetails.genGroupInfo.groupStatus;
                        AdditionalInfo.ServiceTeam = groupDetails.genGroupInfo.groupTeamSize;
                        AdditionalInfo.EffectiveStartDate = groupDetails.genGroupInfo.effectiveStartDate;
                        AdditionalInfo.RiskManagement = groupDetails.genGroupInfo.riskManagement;
                        AdditionalInfo.groupFlowGroupNumber = groupDetails.genGroupInfo.groupId;
                        AdditionalInfo.groupFlowGroupName = groupDetails.genGroupInfo.groupName;
                        AdditionalInfo.trackingGroupNumber = groupDetails.genGroupInfo.groupId;
                        AdditionalInfo.RatingMethod = '';        
                        AdditionalInfo.RenewalDate= groupDetails.genGroupInfo.groupRenewalDate; 
                        AdditionalInfo.producerSubject = groupDetails.genGroupInfo.groupName;
                        //String conname = Apexpages.currentPage().getParameters().get('contactName');
                       // AdditionalInfo.contactName = conname;
                      //  AdditionalInfo.producerOriginator =  Interaction.Originator__r.Name;
                       // system.debug('situsstateeeeeeeeeeeeeeee'+groupDetails.GroupPlanBenefitList[0].stateOfIssueCode);
                        
                        AdditionalInfo.producerId = Interaction.Originator__r.EID__c;    
                } 
        
        }         
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        system.debug('232323AdditionalInfo' + AdditionalInfo);
        }
        catch(Exception e){
         setErrorMsg('MGD997',e);
        }
    }
    
    private void initInteraction(){
     try{
        String Id = ApexPages.currentPage().getParameters().get('Id');
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        createInteraction(); 
       }
       catch(Exception e){ 
        setErrorMsg('MGD997',e);
       }                                   
    }
    
    public void createInteraction(){
      try{ 
        Interaction = new Interaction__c();
        
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        if(interactionId != Null)
        {    
            Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);  
            Interaction.Group_ID__c = groupNumber;            
        }else
        {
            String SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator');
            if(SourceOriginator != Null)
            {
                Interaction.Interaction_Type__c = SourceOriginator ;
            }else
            {
                Interaction.Interaction_Type__c = 'Phone Call';
            
            }
            Interaction.Originator_Type__c = 'Group/Employer';
        
            Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);//added by bhanu
            Interaction.Originator_Type__c = 'Group/Employer';          
            insert Interaction; 
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        }
       }
       catch(Exception e){
        setErrorMsg('MGD997',e);
       } 
    }


    public void updateContactNameField()
    {
      try{
        ContactName = '';
        displayCName = false;
        if(groupDetails != null  && groupDetails.groupExternalContactInfoList != null){
            for(ACETGroupDetail.groupContactInfo contactInfo:groupDetails.groupExternalContactInfoList)
                {
                    system.debug('primconttype: ' + contactInfo.primaryContactType + ' conttype: ' + contactInfo.contactType);
                    
                     if(contactInfo.primaryContactType == ContactType && contactInfo.contactType=='Primary')
                     {
                        system.debug('Benefits Admin Test 4 '+contactInfo.primaryContactType);
                         ContactName = contactInfo.firstName+' '+contactInfo.LastName;
                          AdditionalInfo.contactName = ContactName;
                         //displayCName = true;  //Commented for the user story US752574
                         Interaction.Originator_Type__c = 'Group/Employer';
                         //Interaction.Caller_Type__c = ContactType;
                         createUpdateContact();                
                     }
                }
        }
        if(groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName == groupDetails.genGroupInfo.groupName && ContactType != 'Billing Contact' && ContactType != 'Benefit Administrator') 
        {
            Interaction.Originator_Type__c = 'Group/Employer';
            //Interaction.Caller_Type__c = ContactType;
            
        }
        AdditionalInfo.OriginatorRelationship = contactType; 
        AdditionalInfo.RelationshipType = ContactType;
        if(groupNotFound == true){
                
                ContactName = Apexpages.currentPage().getParameters().get('contactName');
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        system.debug('If primary tab'+hpAdditionInfoStr);
        getNoOfGroupAlert();
       }catch(Exception e){ 
        setErrorMsg('MGD997',e);
       }
    }
    
    public void updateContactType()
    {
       try{
        displayCName = false;
        ContactName = '';
        boolean isProducerSelected = false;
        isshowGroupALert = true;
        selectedValue =Apexpages.currentPage().getParameters().get('selectedVal');
        string selProducerType = Apexpages.currentPage().getParameters().get('producerType');
        
        system.debug('selectedValue ---->'+selectedValue);
        if(selectedValue != Null)
        {
            OriginatorName = selectedValue;
        
        }
        system.debug('OriginatorName ----->'+OriginatorName);
        //if((producerTypeAllResults != Null && !producerTypeAllResults.isEmpty()) && groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName != 'thirdPartId')// && OriginatorName == groupDetails.genGroupInfo.groupName && OriginatorName == 'thirdPartId' && OriginatorName == '----None----')
        
        boolean foundProducer = false;
        if(producerTypeAllResults != null && !producerTypeAllResults.isEmpty()){
          for(ACETProducerSearchResult rec: producerTypeAllResults){
            if(rec.producerPayee == OriginatorName){
              foundProducer = true;
              break;
            }
          }
        } 
        if((selProducerType == '' || selProducerType == null) && foundProducer == true && groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName != 'thirdPartId'){
          isProducerSelected = true;
           ContactTypes = new list<SelectOption>();
           ContactTypes.add(new SelectOption('----None----','----None----'));
           ContactTypes.add(new SelectOption('Agent of Record', 'Agent of Record'));
           ContactTypes.add(new SelectOption('General Agent', 'General Agent'));
           ContactTypes.add(new SelectOption('Service Provider', 'Service Provider'));
           ContactName = ' ';
           displayCName = false;
           AdditionalInfo.RelationshipType = 'Producer Contact';
           AdditionalInfo.OriginatorRelationship = 'Producer Contact';
           hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        }
        if(groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName == groupDetails.genGroupInfo.groupName)
        {
            ContactTypes = new list<SelectOption>();
            ContactTypes.add(new SelectOption('----None----','----None----'));  
            ContactTypes.add(new SelectOption('Benefit Administrator','Benefit Administrator'));  
            ContactTypes.add(new SelectOption('Billing Contact','Billing Contact')); 
            ContactTypes.add(new SelectOption('Additional Contact','Additional Contact'));
            ContactTypes.add(new SelectOption('SBC Contact','SBC Contact'));
            ContactTypes.add(new SelectOption('President','President'));  
            ContactTypes.add(new SelectOption('Owners','Owners'));  
            ContactTypes.add(new SelectOption('Partner','Partner'));  
            ContactTypes.add(new SelectOption('Vice President','Vice President'));  
            ContactTypes.add(new SelectOption('Controller','Controller'));  
            ContactTypes.add(new SelectOption('Assistant Controller','Assistant Controller'));  
            ContactTypes.add(new SelectOption('Chief Executive Officer','Chief Executive Officer'));  
            ContactTypes.add(new SelectOption('Chief Operating Officer','Chief Operating Officer'));  
            ContactTypes.add(new SelectOption('Chief Financial Officer','Chief Financial Officer'));  
            ContactTypes.add(new SelectOption('Member of LLC','Member of LLC'));
            ContactTypes.add(new SelectOption('Banking Contact','Banking Contact'));
            ContactTypes.add(new SelectOption('EDI Coordinator','EDI Coordinator'));
            ContactTypes.add(new SelectOption('Third Party Administrator','Third Party Administrator'));
            ContactTypes.add(new SelectOption('Vendor','Vendor'));
            ContactTypes.add(new SelectOption('Unlisted Contact','Unlisted Contact'));
            ContactTypes.add(new SelectOption('Internal UHC Employee Contact','Internal UHC Employee Contact'));
        }else if(OriginatorName == 'thirdPartId')
        {
            ContactTypes = new list<SelectOption>(); 
            ContactTypes.add(new SelectOption('Third Party','Third Party'));
            Interaction.Originator_Type__c = 'Third Party';
            //Interaction.Caller_Type__c = '';  
                  
        }else if(OriginatorName == '----None----')
        {
            ContactTypes = new list<SelectOption>();
            ContactTypes.add(new SelectOption('----None----','----None----'));
            ContactName = '';
            displayCName = false;        
        }else if(!isProducerSelected)
        {
            
            ContactTypes = new list<SelectOption>();    
            if(AdditionalInfo.RelationshipType == null){
                ContactTypes.add(new SelectOption('Third Party','Third Party')); 
            }
            else{
                ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));
            }
            system.debug('OriginatorName ----->'+OriginatorName);
            //ContactName = '';
            ContactName = OriginatorName;
            system.debug('ContactName ----->'+ContactName );
            //displayCName = true; 
            //Interaction.Caller_Type__c = 'Third Party';
            Interaction.Originator__c = Null;
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
            }
            update Interaction;
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
            isshowGroupALert = true;
        }
        if(groupNotFound == true){
            ContactName = Apexpages.currentPage().getParameters().get('contactName');
        }
	if(groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName != 'thirdPartId' && selProducerType != null && selProducerType != '')
        {
           system.debug('OriginatorName -producer-if condition--->'+OriginatorName);
           isProducerSelected = true;
           ContactTypes = new list<SelectOption>();
           ContactTypes.add(new SelectOption(selProducerType,selProducerType));
           ContactName = ' ';
           displayCName = false;
           AdditionalInfo.RelationshipType = 'Producer Contact';
           AdditionalInfo.OriginatorRelationship = 'Producer Contact';
           hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
            
        }
        getNoOfGroupAlert();
        }catch(Exception e){
         setErrorMsg('MGD997',e);
        }
        
    }
      
    
    public void updateContactNameFieldExt()
    {
      try{
        String contNameRaw = Apexpages.currentPage().getParameters().get('extContName');
        String contName = contNameRaw.unescapeHtml4();
        ContactName = '';
        displayCName = false;
        if(groupDetails != null && groupDetails.groupExternalContactInfoList != null){
            for(ACETGroupDetail.groupContactInfo contactInfo:groupDetails.groupExternalContactInfoList)
            {
                if(contName != '' && contName != null){
                        if((contactInfo.primaryContactType == null || contactInfo.primaryContactType == '') && ContactType == 'Additional Contact' && contName == (contactInfo.firstName+' '+contactInfo.LastName)){
                            ContactName = contactInfo.firstName+' '+contactInfo.LastName;
                            AdditionalInfo.contactName = ContactName; 
                           //displayCName = true; //Commented for the user story US752574
                           Interaction.Originator_Type__c = 'Group/Employer';
                           //Interaction.Caller_Type__c = ContactType;
                           
                           createUpdateContact();
                        }else if(contactInfo.primaryContactType == ContactType && contactInfo.contactType=='Additional' && contName == (contactInfo.firstName+' '+contactInfo.LastName))
                        {
                            ContactName = contactInfo.firstName+' '+contactInfo.LastName;
                              AdditionalInfo.contactName = ContactName; 
                             //displayCName = true; //Commented for the user story US752574
                             Interaction.Originator_Type__c = 'Group/Employer';
                             //Interaction.Caller_Type__c = ContactType;
                             
                             createUpdateContact();                
                        }
               } else {
                 if(contactInfo.primaryContactType == ContactType && contactInfo.contactType=='Primary')
                 {
                     ContactName = contactInfo.firstName+' '+contactInfo.LastName;
                      AdditionalInfo.contactName = ContactName; 
                     //displayCName = true; //Commented for the user story US752574
                     Interaction.Originator_Type__c = 'Group/Employer';
                     //Interaction.Caller_Type__c = ContactType;
                     
                     createUpdateContact();                
                 }
              }
            }
        }
    
        
        if(groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName == groupDetails.genGroupInfo.groupName && ContactType != 'Billing Contact' && ContactType != 'Benefit Administrator') 
        {
            Interaction.Originator_Type__c = 'Group/Employer';
            //Interaction.Caller_Type__c = ContactType;
            
        }
        AdditionalInfo.OriginatorRelationship = contactType; 
        AdditionalInfo.RelationshipType = ContactType;      
        if(groupNotFound == true){
                
                ContactName = Apexpages.currentPage().getParameters().get('contactName');
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        system.debug('If primary tab'+hpAdditionInfoStr);
        getNoOfGroupAlert();
       }catch(Exception e){ 
        setErrorMsg('MGD997',e);
       }
    }
    
    public void updateContactNameFieldProd()
    {
      try{
        String contNameRaw = Apexpages.currentPage().getParameters().get('prodContName');
        String contName = contNameRaw.unescapeHtml4();
        ContactName = '';
        displayCName = false;
        if(contName != '' && contName != null){
            ContactName = contName;
            AdditionalInfo.contactName = ContactName;
            Interaction.Originator_Type__c = 'Group/Employer';
            createUpdateContact();
       }
        AdditionalInfo.OriginatorRelationship = contactType; 
        AdditionalInfo.RelationshipType = ContactType;      
        if(groupNotFound == true){
                
                ContactName = Apexpages.currentPage().getParameters().get('contactName');
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        system.debug('If primary tab'+hpAdditionInfoStr);
        getNoOfGroupAlert();
       }catch(Exception e){ 
        setErrorMsg('MGD997',e);
       }
    }
    
    public void updateAlertValue()
    {
        isshowGroupALert = true;    
    }
     public list<SelectOption> getContactTypes(){
            List<SelectOption> options = new List<SelectOption>();
            return options;      
     } 
     
     public List<SelectOption> getCallTopicOptions(){
         String gnf =Apexpages.currentPage().getParameters().get('gnf');
         List<SelectOption> CallTopics = new List<SelectOption>();
         if(gnf == '1'){
             CallTopics  = ACETCallTopicsPicklistUtility.getCallTopicOptions('Group Not Found', 'Other');
         }else{
             CallTopics  = ACETCallTopicsPicklistUtility.getCallTopicOptions('Group Detail', Interaction.Originator_Type__c);
         }
         return CallTopics;
     }
     
    public List<SelectOption> getOriginatorNames(){
            List<SelectOption> options = new List<SelectOption>();
            system.debug('enter into originator');
            if(Interaction.Originator_Type__c == 'Producer')
            {
                Options.add(new SelectOption(Interaction.Originator__r.Name,Interaction.Originator__r.Name));
                ContactTypes = new list<SelectOption>(); 
                ContactTypes.add(new SelectOption('Producer','Producer'));
                ContactName = Interaction.Originator__r.Name;
                system.debug('ContactName 5---->'+ContactName);
                displayCName = true;
            }else if(Interaction.Originator_Type__c != 'Other')
            {
                Options.add(new SelectOption('----None----','----None----'));
                if(groupDetails != Null && groupDetails.genGroupInfo != Null)
                {
                Options.add(new SelectOption(groupDetails.genGroupInfo.groupName,groupDetails.genGroupInfo.groupName));
                }
                Options.add(new SelectOption('thirdPartId','Third Party'));  
            }
            else{
                Options.add(new SelectOption(Interaction.Originator_Name__c,Interaction.Originator_Name__c));
                ContactTypes = new list<SelectOption>(); 
                ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));
                ContactName = Interaction.Third_Party__r.First_Name__c;
                system.debug('ContactName 5---->'+ContactName);
                displayCName = true;
            }
                   
            return options; 
    
    
    }
    
    public void caseHistory(){
      try{ 
        String Id = ApexPages.currentPage().getParameters().get('Id');
        caseHistoryList = new List<case>();
        if(subjectObj != null)
        {
            caseHistoryList  = [select CaseNumber, Contact.Name,Caller__c,Parent.Id, Parent.CaseNumber,ContactId, CreatedBy.Name, CreatedDate,Group_ID__c, Topic__c, Status, Originator_Type__c, Interaction_Type__c, Rollup_Fulfillment__c,Original_Type__c, 
                                Interaction__c,Interaction__r.Name,Interaction__r.Group_ID__c,
                                (SELECT Id FROM Create_Letters__r) from Case where ContactId =: subjectObj.id OR (Group_ID__c =:Id AND (Originator_Type__c = 'Group/Employer' OR Originator_Type__c = 'Producer')) order by CreatedDate desc limit 500];
            caseListSize = caseHistoryList.size();
            
        }
       }catch(Exception e){
          setErrorMsg('MGD997',e);
        } 
    }

    //Added by Krishna for User story US537355 
    public void getNoOfGroupAlert(){ 
       system.debug('--------alerts IN-----------');
       ACETInteractionHighlightsPanelController AlertNo = new ACETInteractionHighlightsPanelController();     
           if(groupDetails!=null && groupDetails.genGroupInfo!=null && groupDetails.genGroupInfo.groupId!=null){
            String benefitBundleOptions = '';
            if(groupDetails.polContract != null){
                for(ACETGroupDetail.PolicyContract pol:groupDetails.polContract){
                  if(pol.policyConId == AdditionalInfo.selectedPolicyContract){
                      if(benefitBundleOptions == ''){
                          benefitBundleOptions = pol.benefitBundleId;
                      } else {
                          benefitBundleOptions = benefitBundleOptions +', '+pol.benefitBundleId;
                      }
                  }
                }
                //addBundleOptions(benefitBundleOptions);
                AdditionalInfo.AllGroupBenefitBundleOptionId = benefitBundleOptions;
            }
             lstGroupAlert= AlertNo.getNoAlert(null,null,groupDetails.genGroupInfo.groupId,AdditionalInfo.AllGroupBenefitBundleOptionId);
            }
           system.debug('lstGroupAlert is '+lstGroupAlert);
           if(lstGroupAlert != null && lstGroupAlert.size()>0){
               list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
               for(Alert__c varalert : lstGroupAlert){
                   Interaction_Alert__c intAlert = new Interaction_Alert__c();
                   intAlert.Alert__c = varAlert.id;
                   intAlert.Interaction__c = Interaction.Id;
                   intAlert.Alert_Title_at_Display__c = varAlert.Alert_Title__c;
                   intAlert.Alert_Comments_at_Display__c= varAlert.Alert_Comments__c;
                  
                   if(intAlert.Intercation_Alert_Unique_Id_del__c != (String.valueof(varAlert.id)+String.valueof(Interaction.id)+groupDetails.genGroupInfo.groupId)){
                   	   intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(Interaction.id)+groupDetails.genGroupInfo.groupId;
                       lstIntAlert.add(intAlert);
                   }
               }
               try{                   
               upsert lstIntAlert Intercation_Alert_Unique_Id_del__c;
               }
               Catch(DMLException e){
                 setErrorMsg('MGD997',e);
                   //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Exception during insertion on Interaction Alert.'));
               }
           }      
    }
    public void PopulateGroupNotFoundDefaults(){
     try{
        String ContactName =Apexpages.currentPage().getParameters().get('contactName');
        AdditionalInfo.contactName = ContactName;
        String reltype =Apexpages.currentPage().getParameters().get('RelationshipType');
        ContactTypes = new list<SelectOption>();
        if('1' == '1'){            
            
            //pagereference pg = new pageReference(ApexPages.currentPage().getURL());
            //system.debug('-----pg--->'+ pg);
            system.debug('-----Urlstr --->'+ Urlstr );
            Integer reltypeNum = URLstr.indexOf('RelationshipType');
            if(reltypeNum != -1){
            reltypeNum = reltypeNum + 25;
            system.debug('-----reltypeNum--->'+ reltypeNum);
            integer rel = URLstr.indexOf('%22Relationship%') ;
                if(rel != -1){
                    system.debug('-----rel--->'+ rel);
                    rel = rel - 6 ;
                    if(reltypeNum != null && rel != null){
                        AdditionalInfo.RelationshipType = URLstr.substring(reltypeNum, rel );
                        AdditionalInfo.RelationshipType = AdditionalInfo.RelationshipType.replace('+', ' ');
                        system.debug('-----AdditionalInfo.RelationshipType--->'+ AdditionalInfo.RelationshipType);
                        ContactTypes = new list<SelectOption>();
                        ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType ,AdditionalInfo.RelationshipType ));
                        system.debug('-----Urlstr 2--->'+ Urlstr );
                        Integer conNamePos = URLstr.indexOf('contactName');
                        Integer ConNameEnd = URLstr.indexOf('%22ConsumerAccountIndicator');
                        system.debug('-----conNamePos --->'+ conNamePos );
                        if(conNamePos != -1 && ConNameEnd != -1){
                            ContactName = URLstr.substring(conNamePos + 20 , ConNameEnd - 6);
                            AdditionalInfo.contactName = ContactName.replace('+', ' ');
                        }
                    }
                    //ContactType = AdditionalInfo.RelationshipType;
                }
            }
            ContactTypes.add(new SelectOption('----None----','----None----'));  
            ContactTypes.add(new SelectOption('Benefit Administrator','Benefit Administrator'));  
            ContactTypes.add(new SelectOption('Billing Contact','Billing Contact')); 
            ContactTypes.add(new SelectOption('Additional Contact','Additional Contact'));
            ContactTypes.add(new SelectOption('SBC Contact','SBC Contact'));
            ContactTypes.add(new SelectOption('President','President'));  
            ContactTypes.add(new SelectOption('Owners','Owners'));  
            ContactTypes.add(new SelectOption('Partner','Partner'));  
            ContactTypes.add(new SelectOption('Vice President','Vice President'));  
            ContactTypes.add(new SelectOption('Controller','Controller'));  
            ContactTypes.add(new SelectOption('Assistant Controller','Assistant Controller'));  
            ContactTypes.add(new SelectOption('Chief Executive Officer','Chief Executive Officer'));  
            ContactTypes.add(new SelectOption('Chief Operating Officer','Chief Operating Officer'));  
            ContactTypes.add(new SelectOption('Chief Financial Officer','Chief Financial Officer'));  
            ContactTypes.add(new SelectOption('Member of LLC','Member of LLC'));
            ContactTypes.add(new SelectOption('Banking Contact','Banking Contact'));
            ContactTypes.add(new SelectOption('EDI Coordinator','EDI Coordinator'));
            ContactTypes.add(new SelectOption('Third Party Administrator','Third Party Administrator'));
            ContactTypes.add(new SelectOption('Vendor','Vendor'));
            ContactTypes.add(new SelectOption('Unlisted Contact','Unlisted Contact'));
            ContactTypes.add(new SelectOption('Internal UHC Employee Contact','Internal UHC Employee Contact'));
            
        }
       }catch(Exception e){
          setErrorMsg('MGD997',e);
        } 
    }    
    public Object CallGroupDetailCWS()
    {
        Continuation PageLoadContinuation;
        
        if(groupNotFound == true){
             PopulateGroupNotFoundDefaults();           
        }
        else{
            ACETGetGDWebservice = new ACETGetEmployerDetailAdapterWebService();        
            system.debug('Group number information======>'+groupNumber);
            PageLoadContinuation = ACETGetGDWebservice.StartRequest(groupNumber,'GDWebserviceCallBack',null);
        }
        return PageLoadContinuation;
    }
    
    public PageReference GDWebserviceCallBack() {
        try{
        updateSpecialityBenefits();
        planOptionIds = new Set<String>();
        if(!specialityBenefits.isEmpty()){
            for(ACETGroupDetail.SpecialtyBenefits_CoverageLine sp : specialityBenefits){
                planOptionIds.add(sp.planOptionID);
            }
        }
        ACETWSCalloutResult getGDCalloutResults;
        
        
        getGDCalloutResults = ACETGetGDWebservice.ProcessResponse(ACETGetGDWebservice.RequestLabel);
        system.debug('Entery for getGDCalloutResults call-->'+getGDCalloutResults );
        
        if(getGDCalloutResults.Success) {
            groupDetails = (ACETGroupDetail)getGDCalloutResults.Response;
            showAcknowledgement = groupDetails.isChildPEO;
            parentPEOId = groupDetails.parentPEOId;
            
            // getEmp V3 changes
            updatePolicySection();
            //US1158818 changes start
            
            
            
            //US1158818 changes end
            updateOtherInfo();
        }else{
          if(getGDCalloutResults.statusCode==400){
              setErrorMsg('GN'+'400B',null);
          }else{
         setErrorMsg('GN'+getGDCalloutResults.statusCode,null);
         }
        }
       }catch(Exception e){
        setErrorMsg('MGD997',e);
        } 
        return null; 
    } 
    //Added by Krishna 
     public void callProducerWS(){   
         List<ACETProducerSearchResult> producersSearchResult;     
        try{  
        //  ACETFindProducerWebservice ACTFPWS = new ACETFindProducerWebservice();
        //  ACETWSCalloutResult CalloutResult = ACTFPWS.FindProducers('','','', '',groupNumber, '', '', '', '', '','','1'); 
      //    groupNumber= '1285862';
            ACETFindProducerAPI ACTFPWS = new ACETFindProducerAPI();
            ACETWSCalloutResult CalloutResult = ACTFPWS.FindProducerDetail('', '', '', '', groupNumber, '', '', '', '', '', '','1');
            contactHistoryWindow();
       	//	groupNumber= '1285862';        
            if (CalloutResult.Success)
            {
                ProducerSearchResults = new List<ACETProducerSearchResult>();
                ProducerSearchResults = (list<ACETProducerSearchResult>)CalloutResult.Response;
                system.debug('ProducerSearchResults:: ' + ProducerSearchResults);
                producerSerachResultsSplit(ProducerSearchResults, 'Y');
            }
            else{
                if(CalloutResult.statusCode==001){
                  setErrorMsg('GN'+'400B',null);
                }else if(CalloutResult.statusCode==002||CalloutResult.statusCode==005){
                  setErrorMsg('GN'+'500',null);
                }
                else{
                  setErrorMsg('GN'+CalloutResult.statusCode,null);
                }
                //ApexPages.addMessage(new ApexPages.Message(calloutResult.MessageSeverity, calloutResult.Message));    
            }    
      //      ACETFindProducerWebservice ACTFPFWS = new ACETFindProducerWebservice();
      //      groupNumber='1285862';
      //      ACETWSCalloutResult CalloutResultFuture = ACTFPFWS.FindProducers('','','', '',groupNumber, '', '', '', '', '','','2'); 
             ACETFindProducerAPI ACTFPFWS = new ACETFindProducerAPI();
             ACETWSCalloutResult CalloutResultFuture = ACTFPFWS.FindProducerDetail('', '', '', '', groupNumber, '', '', '', '', '', '', '2');
            system.debug('CalloutResult future:: ' + CalloutResultFuture);         
            if (CalloutResultFuture.Success)
            {
                ProducerSearchResultsFuture = new List<ACETProducerSearchResult>();
                ProducerSearchResultsFuture = (list<ACETProducerSearchResult>)CalloutResultFuture.Response;
                system.debug('ProducerSearchResults future:: ' + ProducerSearchResultsFuture);
                producerSerachResultsSplit(ProducerSearchResultsFuture, 'N');
            }
            else{
                 if(CalloutResultFuture.statusCode==001){
                  setErrorMsg('GN'+'400B',null);
                }else if(CalloutResultFuture.statusCode==002||CalloutResultFuture.statusCode==005){
                  setErrorMsg('GN'+'500',null);
                }
                else{
                  setErrorMsg('GN'+CalloutResultFuture.statusCode,null);
                }
                //ApexPages.addMessage(new ApexPages.Message(calloutResult.MessageSeverity, CalloutResultFuture.Message));    
            } 
            if(producerTypeAllResults!= Null)
            {
                for(ACETProducerSearchResult rec: producerTypeAllResults){
                    if(Interaction.Originator_Type__c == 'Group/Employer'){
                    
                        if(rec.hasName){
                            if(rec.MiddleInitial != '' && rec.MiddleInitial != null){
                                //OriginatorNames.add(new SelectOption(rec.FirstName+' '+rec.MiddleInitial+' '+rec.LastName,rec.FirstName+' '+rec.MiddleInitial+' '+rec.LastName)); 
                                prodOrignatMap.put(rec.FirstName+' '+rec.MiddleInitial+' '+rec.LastName,rec); 
                            } else {
                                //OriginatorNames.add(new SelectOption(rec.FirstName+' '+rec.LastName,rec.FirstName+' '+rec.LastName)); 
                                prodOrignatMap.put(rec.FirstName+' '+rec.LastName,rec); 
                            }
                            
                        }else {
                            prodOrignatMap.put(rec.CompanyName,rec);
                        }
                        if(rec.producerRole == 'P' && rec.producerPayee != '' && rec.producerPayee != null){
                          OriginatorNames.add(new SelectOption(rec.producerPayee,rec.producerPayee));
                        }
                    }
                }
                
            }
            
            OriginatorNames.sort();
           }catch(Exception e){
            setErrorMsg('MGD997',e);
          } 
    }
    
    public PageReference RedirectToRestrictedPage() {
        
            PageReference pageRef ;
            
                pageRef = page.ACETRestriction;
                system.debug('@@@redirect'+pageref);
                pageRef.getParameters().put('blockpage','group');
                pageRef.setRedirect(true);
            
        return pageRef;    
    }
    
    public void findSelectedProducerMap(){
        selectedProducer = '';
        producerMaskedSSn = '';
        String prodMapKey = Apexpages.currentPage().getParameters().get('prodMapKey');
        if(producerSearchMap.get(prodMapKey) != null){
            selectedProducer = JSON.serialize(producerSearchMap.get(prodMapKey));
            ACETProducerSearchResultWrapper results = producerSearchMap.get(prodMapKey);
            if(results.producerWritAgentSSN != null && results.producerWritAgentSSN != ''){
                producerMaskedSSn = 'XXX-XX-' + results.producerWritAgentSSN.substring(results.producerWritAgentSSN.length() - 4);
            }
        }
    }
    

    public void findSelectedProducerHistoryMap(){
        selectedProducer = '';
        producerMaskedSSn = '';
        String prodMapKey = Apexpages.currentPage().getParameters().get('prodHistoryMapKey');
        if(producerHistorySearchMap.get(prodMapKey) != null){
            selectedProducer = JSON.serialize(producerHistorySearchMap.get(prodMapKey));
            ACETProducerSearchResultWrapper results = producerHistorySearchMap.get(prodMapKey);
            if(results.producerWritAgentSSN != null && results.producerWritAgentSSN != ''){
                producerMaskedSSn = 'XXX-XX-' + results.producerWritAgentSSN.substring(results.producerWritAgentSSN.length() - 4);
            }
        }
       
    }
    public void producerSerachResultsSplit(List<ACETProducerSearchResult> producerSearchresults , String presentFlag){
     try{
            if(producerSearchresults!=null){
             /*if(presentFlag == 'Y')
             {
                producerTypeBRestuls= new List<ACETProducerSearchResult>();
                producerTypeIRestuls= new List<ACETProducerSearchResult>();
                producerTypeAllResults= new List<ACETProducerSearchResult>();
             }
             for(ACETProducerSearchResult rec: producerSearchresults){
                  if(rec.producerType == 'B'){
                    producerTypeAllResults.add(rec);
                  }
                  else if(rec.producerType == 'I'){
                    producerTypeAllResults.add(rec);
                  }
              }*/
              //ADDING PAST CODE FOR NOW, MIGHT NEED TO MOVE LATER WHEN WE GET REAL DATA
              if(presentFlag == 'Y'){
                     producerTypeAgentResults = new List<ACETProducerSearchResult>();
                     producerTypeGeneralAgentResults = new List<ACETProducerSearchResult>();
                     producerTypeServiceProviderResults = new List<ACETProducerSearchResult>();
                     producerHistoryAgentResults = new List<ACETProducerSearchResult>();
                     producerHistoryGeneralAgentResults = new List<ACETProducerSearchResult>();
                     producerHistoryServiceProviderResults = new List<ACETProducerSearchResult>();
                     producerSearchMap = new Map<String, ACETProducerSearchResultWrapper>();
                     producerHistorySearchMap = new Map<String, ACETProducerSearchResultWrapper>();
                     producerTypeAllResults = new List<ACETProducerSearchResult>();
              }
              String currentDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
              for(ACETProducerSearchResult rec: producerSearchresults){
                    //PAST PRODUCER CODE STARTS HERE
                    String endDate = '';
                    if(rec.producerMemberGrpEndDate != null && rec.producerMemberGrpEndDate != ''){
                        endDate = rec.producerMemberGrpEndDate.split('/')[2] + '-' + rec.producerMemberGrpEndDate.split('/')[0] + '-' + rec.producerMemberGrpEndDate.split('/')[1];
                    }
                    if(endDate != '' && (Date.valueOf(endDate) < Date.valueOf(currentDate))){
                        if(rec.producerRoleType == 'A'){
                            Boolean found = false;
                            if(rec.producerRole == 'W'){
                                rec.producerWritingAgent = rec.Name;
                            } else if(rec.producerRole == 'P'){
                                rec.producerPayee = rec.Name;
                            }
                            for(Integer i = 0; i < producerHistoryAgentResults.size(); i++){
                                if(producerHistoryAgentResults.size() > 0){
                                    if(rec.producerCRID == producerHistoryAgentResults[i].producerCRID){
                                        if(rec.producerRole == 'W'){
                                            producerHistoryAgentResults[i].producerWritingAgent = rec.Name;
                                        } else if(rec.producerRole == 'P'){
                                            producerHistoryAgentResults[i].producerPayee = rec.Name;
                                        }
                                        found = true;
                                    }
                                }
                                
                            }
                            //TODO add code for maps here
                            if(producerHistorySearchMap.containsKey(rec.producerCRID + rec.producerRole + rec.producerMemberGrpStartDate + rec.producerMemberGrpEndDate) == false){
                                ACETProducerSearchResultWrapper additionalProducerResultsInfo = new ACETProducerSearchResultWrapper();
                                if(rec.producerRole == 'W'){
                                    additionalProducerResultsInfo.producerWritAgentAddress = rec.producerStreetLine1;
                                    if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                        additionalProducerResultsInfo.producerWritAgentAddress = additionalProducerResultsInfo.producerWritAgentAddress + ' ' + rec.producerStreetLine2;
                                    }
                                    additionalProducerResultsInfo.producerWritAgentAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                                    if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                        additionalProducerResultsInfo.producerWritAgentAddressCityState = additionalProducerResultsInfo.producerWritAgentAddressCityState + rec.producerZipCodeSuffix;
                                    }
                                    additionalProducerResultsInfo.producerWritAgentSSN = rec.producerUnMaskedSSN;
                                    additionalProducerResultsInfo.producerWritAgentLegacyCode = rec.producerLegacyId;
                                    additionalProducerResultsInfo.producerWritAgentPhoneNumber = rec.producerPhoneNumber;
                                    additionalProducerResultsInfo.producerWritAgentId = rec.ProducerId;
                                    additionalProducerResultsInfo.producerWritAgentType = rec.ProducerType;
                                } else if(rec.producerRole == 'P'){
                                    additionalProducerResultsInfo.producerPayeeAddress = rec.producerStreetLine1;
                                    if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                        additionalProducerResultsInfo.producerPayeeAddress = additionalProducerResultsInfo.producerPayeeAddress + ' ' + rec.producerStreetLine2;
                                    }
                                    additionalProducerResultsInfo.producerPayeeAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                                    if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                        additionalProducerResultsInfo.producerPayeeAddressCityState = additionalProducerResultsInfo.producerPayeeAddressCityState + rec.producerZipCodeSuffix;
                                    }
                                    additionalProducerResultsInfo.producerPayeeTaxId = rec.ProducerTIN;
                                    additionalProducerResultsInfo.producerPayeeLegacyCode = rec.producerLegacyId;
                                    additionalProducerResultsInfo.producerPayeePhoneNumber = rec.producerPhoneNumber;
                                    additionalProducerResultsInfo.producerPayeeId = rec.ProducerId;
                                    additionalProducerResultsInfo.producerPayeeType = rec.ProducerType;
                                }
                                producerHistorySearchMap.put(rec.producerCRID + rec.producerRole + rec.producerMemberGrpStartDate + rec.producerMemberGrpEndDate, additionalProducerResultsInfo);
                            }
                            if(found == false){ 
                                producerHistoryAgentResults.add(rec);
                            }
                          } else if(rec.producerRoleType == 'O'){
                            Boolean found = false;
                            for(Integer i = 0; i < producerHistoryGeneralAgentResults.size(); i++){
                                if(producerHistoryGeneralAgentResults.size() > 0){
                                    if(rec.producerCRID == producerHistoryGeneralAgentResults[i].producerCRID){
                                        found = true;
                                    }
                                }
                            }
                            if(found == false){
                            producerHistoryGeneralAgentResults.add(rec);
                            }
                            if(producerHistorySearchMap.containsKey(rec.producerCRID + rec.producerRole) == false){
                                ACETProducerSearchResultWrapper additionalProducerResultsInfo = new ACETProducerSearchResultWrapper();
                                additionalProducerResultsInfo.producerPayeeAddress = rec.producerStreetLine1;
                                if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                    additionalProducerResultsInfo.producerPayeeAddress = additionalProducerResultsInfo.producerPayeeAddress + ' ' + rec.producerStreetLine2;
                                }
                                additionalProducerResultsInfo.producerPayeeAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                                if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                    additionalProducerResultsInfo.producerPayeeAddressCityState = additionalProducerResultsInfo.producerPayeeAddressCityState + rec.producerZipCodeSuffix;
                                }
                                additionalProducerResultsInfo.producerPayeeTaxId = rec.ProducerTIN;
                                additionalProducerResultsInfo.producerPayeeLegacyCode = rec.producerLegacyId;
                                additionalProducerResultsInfo.producerPayeePhoneNumber = rec.producerPhoneNumber;
                                additionalProducerResultsInfo.producerPayeeId = rec.ProducerId;
                                additionalProducerResultsInfo.producerPayeeType = rec.ProducerType;
                                producerHistorySearchMap.put(rec.producerCRID + rec.producerRole + rec.producerMemberGrpStartDate + rec.producerMemberGrpEndDate, additionalProducerResultsInfo);
                            }
                          }
                          else if(rec.producerRoleType == 'P'){
                            Boolean found = false;
                            if(rec.producerRole == 'W'){
                                rec.producerWritingAgent = rec.Name;
                            } else if(rec.producerRole == 'P'){
                                rec.producerPayee = rec.Name;
                            }
                            for(Integer i = 0; i < producerHistoryServiceProviderResults.size(); i++){
                                if(producerHistoryServiceProviderResults.size() > 0){
                                    if(rec.producerCRID == producerHistoryServiceProviderResults[i].producerCRID){
                                        //TODO need to take current and future into account when comparing
                                        //currently the results are doubled
                                        if(rec.producerRole == 'W'){
                                            producerHistoryServiceProviderResults[i].producerWritingAgent = rec.Name;
                                        } else if(rec.producerRole == 'P'){
                                            producerHistoryServiceProviderResults[i].producerPayee = rec.Name;
                                        }
                                        found = true;
                                    }
                                }
                            }
                            //TODO add code for maps here
                            if(producerHistorySearchMap.containsKey(rec.producerCRID + rec.producerRole) == false){
                                ACETProducerSearchResultWrapper additionalProducerResultsInfo = new ACETProducerSearchResultWrapper();
                                if(rec.producerRole == 'W'){
                                    additionalProducerResultsInfo.producerWritAgentAddress = rec.producerStreetLine1;
                                    if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                        additionalProducerResultsInfo.producerWritAgentAddress = additionalProducerResultsInfo.producerWritAgentAddress + ' ' + rec.producerStreetLine2;
                                    }
                                    additionalProducerResultsInfo.producerWritAgentAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                                    if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                        additionalProducerResultsInfo.producerWritAgentAddressCityState = additionalProducerResultsInfo.producerWritAgentAddressCityState + rec.producerZipCodeSuffix;
                                    }
                                    additionalProducerResultsInfo.producerWritAgentSSN = rec.producerUnMaskedSSN;
                                    additionalProducerResultsInfo.producerWritAgentLegacyCode = rec.producerLegacyId;
                                    additionalProducerResultsInfo.producerWritAgentPhoneNumber = rec.producerPhoneNumber;
                                    additionalProducerResultsInfo.producerWritAgentId = rec.ProducerId;
                                    additionalProducerResultsInfo.producerWritAgentType = rec.ProducerType;
                                } else if(rec.producerRole == 'P'){
                                    additionalProducerResultsInfo.producerPayeeAddress = rec.producerStreetLine1;
                                    if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                        additionalProducerResultsInfo.producerPayeeAddress = additionalProducerResultsInfo.producerPayeeAddress + ' ' + rec.producerStreetLine2;
                                    }
                                    additionalProducerResultsInfo.producerPayeeAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                                    if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                        additionalProducerResultsInfo.producerPayeeAddressCityState = additionalProducerResultsInfo.producerPayeeAddressCityState + rec.producerZipCodeSuffix;
                                    }
                                    additionalProducerResultsInfo.producerPayeeTaxId = rec.ProducerTIN;
                                    additionalProducerResultsInfo.producerPayeeLegacyCode = rec.producerLegacyId;
                                    additionalProducerResultsInfo.producerPayeePhoneNumber = rec.producerPhoneNumber;
                                    additionalProducerResultsInfo.producerPayeeId = rec.ProducerId;
                                    additionalProducerResultsInfo.producerPayeeType = rec.ProducerType;
                                }
                                producerHistorySearchMap.put(rec.producerCRID + rec.producerRole + rec.producerMemberGrpStartDate + rec.producerMemberGrpEndDate, additionalProducerResultsInfo);
                            }
                            if(found == false){ 
                                producerHistoryServiceProviderResults.add(rec);
                            }
                          }
                          //PAST PRODUCER CODE ENDS HERE
                    } else {
                  if(rec.producerRoleType == 'A'){
                    Boolean found = false;
                    if(rec.producerRole == 'W'){
                        rec.producerWritingAgent = rec.Name;
                    } else if(rec.producerRole == 'P'){
                        rec.producerPayee = rec.Name;
                    }
                    for(Integer i = 0; i < producerTypeAgentResults.size(); i++){
                        if(producerTypeAgentResults.size() > 0){
                            if(rec.producerCRID == producerTypeAgentResults[i].producerCRID){
                                //TODO need to take current and future into account when comparing
                                //currently the results are doubled
                                if(rec.producerRole == 'W'){
                                    producerTypeAgentResults[i].producerWritingAgent = rec.Name;
                                } else if(rec.producerRole == 'P'){
                                    producerTypeAgentResults[i].producerPayee = rec.Name;
                                }
                                found = true;
                            }
                        }
                        
                    }
                    if(producerSearchMap.containsKey(rec.producerCRID + rec.producerRole) == false){
                        ACETProducerSearchResultWrapper additionalProducerResultsInfo = new ACETProducerSearchResultWrapper();
                        if(rec.producerRole == 'W'){
                            additionalProducerResultsInfo.producerWritAgentAddress = rec.producerStreetLine1;
                            if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                additionalProducerResultsInfo.producerWritAgentAddress = additionalProducerResultsInfo.producerWritAgentAddress + ' ' + rec.producerStreetLine2;
                            }
                            additionalProducerResultsInfo.producerWritAgentAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                            if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                additionalProducerResultsInfo.producerWritAgentAddressCityState = additionalProducerResultsInfo.producerWritAgentAddressCityState + rec.producerZipCodeSuffix;
                            }
                            additionalProducerResultsInfo.producerWritAgentSSN = rec.producerUnMaskedSSN;
                            additionalProducerResultsInfo.producerWritAgentLegacyCode = rec.producerLegacyId;
                            additionalProducerResultsInfo.producerWritAgentPhoneNumber = rec.producerPhoneNumber;
                            additionalProducerResultsInfo.producerWritAgentId = rec.ProducerId;
                            additionalProducerResultsInfo.producerWritAgentType = rec.ProducerType;
                        } else if(rec.producerRole == 'P'){
                            additionalProducerResultsInfo.producerPayeeAddress = rec.producerStreetLine1;
                            if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                additionalProducerResultsInfo.producerPayeeAddress = additionalProducerResultsInfo.producerPayeeAddress + ' ' + rec.producerStreetLine2;
                            }
                            additionalProducerResultsInfo.producerPayeeAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                            if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                additionalProducerResultsInfo.producerPayeeAddressCityState = additionalProducerResultsInfo.producerPayeeAddressCityState + rec.producerZipCodeSuffix;
                            }
                            additionalProducerResultsInfo.producerPayeeTaxId = rec.ProducerTIN;
                            additionalProducerResultsInfo.producerPayeeLegacyCode = rec.producerLegacyId;
                            additionalProducerResultsInfo.producerPayeePhoneNumber = rec.producerPhoneNumber;
                            additionalProducerResultsInfo.producerPayeeId = rec.ProducerId;
                            additionalProducerResultsInfo.producerPayeeType = rec.ProducerType;
                        }
                        producerSearchMap.put(rec.producerCRID + rec.producerRole, additionalProducerResultsInfo);
                    }
                    if(found == false){ 
                        producerTypeAgentResults.add(rec);
                    }
                  }
                  else if(rec.producerRoleType == 'O'){
                    //TODO need to take current and future into account when comparing
                    rec.producerPayee = rec.Name;
                    Boolean found = false;
                    for(Integer i = 0; i < producerTypeGeneralAgentResults.size(); i++){
                        if(producerTypeGeneralAgentResults.size() > 0){
                            if(rec.producerCRID == producerTypeGeneralAgentResults[i].producerCRID){
                                found = true;
                            }
                        }
                    }
                    if(found == false){
                    producerTypeGeneralAgentResults.add(rec);
                    }
                    if(producerSearchMap.containsKey(rec.producerCRID + rec.producerRole) == false){
                        ACETProducerSearchResultWrapper additionalProducerResultsInfo = new ACETProducerSearchResultWrapper();
                        additionalProducerResultsInfo.producerPayeeAddress = rec.producerStreetLine1;
                        if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                            additionalProducerResultsInfo.producerPayeeAddress = additionalProducerResultsInfo.producerPayeeAddress + ' ' + rec.producerStreetLine2;
                        }
                        additionalProducerResultsInfo.producerPayeeAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                        if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                            additionalProducerResultsInfo.producerPayeeAddressCityState = additionalProducerResultsInfo.producerPayeeAddressCityState + rec.producerZipCodeSuffix;
                        }
                        additionalProducerResultsInfo.producerPayeeTaxId = rec.ProducerTIN;
                        additionalProducerResultsInfo.producerPayeeLegacyCode = rec.producerLegacyId;
                        additionalProducerResultsInfo.producerPayeePhoneNumber = rec.producerPhoneNumber;
                        additionalProducerResultsInfo.producerPayeeId = rec.ProducerId;
                        additionalProducerResultsInfo.producerPayeeType = rec.ProducerType;
                        producerSearchMap.put(rec.producerCRID + rec.producerRole, additionalProducerResultsInfo);
                    }
                  }
                  else if(rec.producerRoleType == 'P'){
                    Boolean found = false;
                    if(rec.producerRole == 'W'){
                        rec.producerWritingAgent = rec.Name;
                    } else if(rec.producerRole == 'P'){
                        rec.producerPayee = rec.Name;
                    }
                    for(Integer i = 0; i < producerTypeServiceProviderResults.size(); i++){
                        if(producerTypeServiceProviderResults.size() > 0){
                            if(rec.producerCRID == producerTypeServiceProviderResults[i].producerCRID){
                                //TODO need to take current and future into account when comparing
                                if(rec.producerRole == 'W'){
                                    producerTypeServiceProviderResults[i].producerWritingAgent = rec.Name;
                                } else if(rec.producerRole == 'P'){
                                    producerTypeServiceProviderResults[i].producerPayee = rec.Name;
                                }
                                found = true;
                            }
                        }
                    }
                    if(producerSearchMap.containsKey(rec.producerCRID + rec.producerRole) == false){
                        ACETProducerSearchResultWrapper additionalProducerResultsInfo = new ACETProducerSearchResultWrapper();
                        if(rec.producerRole == 'W'){
                            additionalProducerResultsInfo.producerWritAgentAddress = rec.producerStreetLine1;
                            if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                additionalProducerResultsInfo.producerWritAgentAddress = additionalProducerResultsInfo.producerWritAgentAddress + ' ' + rec.producerStreetLine2;
                            }
                            additionalProducerResultsInfo.producerWritAgentAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                            if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                additionalProducerResultsInfo.producerWritAgentAddressCityState = additionalProducerResultsInfo.producerWritAgentAddressCityState + rec.producerZipCodeSuffix;
                            }
                            additionalProducerResultsInfo.producerWritAgentSSN = rec.producerUnMaskedSSN;
                            additionalProducerResultsInfo.producerWritAgentLegacyCode = rec.producerLegacyId;
                            additionalProducerResultsInfo.producerWritAgentPhoneNumber = rec.producerPhoneNumber;
                            additionalProducerResultsInfo.producerWritAgentId = rec.ProducerId;
                            additionalProducerResultsInfo.producerWritAgentType = rec.ProducerType;
                        } else if(rec.producerRole == 'P'){
                            additionalProducerResultsInfo.producerPayeeAddress = rec.producerStreetLine1;
                            if(rec.producerStreetLine2 != '' && rec.producerStreetLine2 != null){
                                additionalProducerResultsInfo.producerPayeeAddress = additionalProducerResultsInfo.producerPayeeAddress + ' ' + rec.producerStreetLine2;
                            }
                            additionalProducerResultsInfo.producerPayeeAddressCityState = rec.producerCity + ' ' + rec.producerState + ', ' + rec.producerZipCode;
                            if(rec.producerZipCodeSuffix != null && rec.producerZipCodeSuffix != '') {
                                additionalProducerResultsInfo.producerPayeeAddressCityState = additionalProducerResultsInfo.producerPayeeAddressCityState + rec.producerZipCodeSuffix;
                            }
                            additionalProducerResultsInfo.producerPayeeTaxId = rec.ProducerTIN;
                            additionalProducerResultsInfo.producerPayeeLegacyCode = rec.producerLegacyId;
                            additionalProducerResultsInfo.producerPayeePhoneNumber = rec.producerPhoneNumber;
                            additionalProducerResultsInfo.producerPayeeId = rec.ProducerId;
                            additionalProducerResultsInfo.producerPayeeType = rec.ProducerType;
                        }
                        producerSearchMap.put(rec.producerCRID + rec.producerRole, additionalProducerResultsInfo);
                    }
                    if(found == false){ 
                        producerTypeServiceProviderResults.add(rec);
                    }
                  }
              }
              producerTypeAllResults.add(rec);
         }
              
            }
        }catch(Exception e){
         setErrorMsg('MGD997',e);
        }    
    }
    
    private void updateOtherInfo(){
      try{
        system.debug('--------alerts start-----------');
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        initInteraction();
        initHighlightPanelAdditionalInfo();
        createThirdPartySubject();
        getNoOfGroupAlert();
        system.debug('--------alerts end-----------');
        OriginatorNames= new List<SelectOption>();
        if(Interaction.Originator_Type__c == 'Producer')
        {
            OriginatorNames= new List<SelectOption>();
            OriginatorNames.add(new SelectOption(Interaction.Originator__r.Name,Interaction.Originator__r.Name));
            OriginatorName = Interaction.Originator__r.Name;
            ContactTypes = new list<SelectOption>();
            if(AdditionalInfo.RelationshipType != null)
            { 
            ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));
            }
            displayCName = true;
            ContactName = '';
            
            string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
            ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
            if(obj != null)
            {
                String JSONBody = JSON.serialize(obj);
                system.debug('JSONBody---->'+JSONBody);
                Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
            }
            update Interaction;
            ContactName = AdditionalInfo.producerName;
            
        }else If(Interaction.Originator_Type__c != 'Other')
        { 
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                OriginatorNames= new List<SelectOption>();
                OriginatorNames.add(new SelectOption('----None----','----None----'));
            
                OriginatorNames.add(new SelectOption(groupDetails.genGroupInfo.groupName,groupDetails.genGroupInfo.groupName));
                
                OriginatorNames.add(new SelectOption('thirdPartId','Third Party')); 
                string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    system.debug('JSONBody---->'+JSONBody);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
                update Interaction;
            }
             //added by khoushik for Group not found flow
             
             
             
             
        }
        else{
                OriginatorNames= new List<SelectOption>();
                OriginatorNames.add(new SelectOption(Interaction.Originator_Name__c,Interaction.Originator_Name__c));
                OriginatorName = Interaction.Originator_Name__c;
                ContactTypes = new list<SelectOption>(); 
                if(AdditionalInfo.RelationshipType != null)
                    ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));
                if(Interaction != null && Interaction.Third_Party__c != null)
                    ContactName = Interaction.Third_Party__r.First_Name__c;
                system.debug('ContactName 5---->'+ContactName);
                displayCName = true;
            }
         }catch(Exception e){
         setErrorMsg('MGD997',e);
        }   
    } 
    
    public void updateSpecialityBenefits(){
        ACETGetEmployerGroupAPI getEmployerGroupAPIObj = new ACETGetEmployerGroupAPI(); 
        ACETWSCalloutResult getGDCalloutResultsSP =  getEmployerGroupAPIObj.getEmployerGroupDetail(groupNumber);
        if(getGDCalloutResultsSP.Success) {
            ACETGroupDetail groupDetailsSP = (ACETGroupDetail)getGDCalloutResultsSP.Response;
            groupDetailsSP.SpecialityBenefits.sort();
            ACETGroupDetail.SpecialtyBenefits_CoverageLine sp = new ACETGroupDetail.SpecialtyBenefits_CoverageLine();
            sp.formatDate(groupDetailsSP.SpecialityBenefits);
            specialityBenefits = groupDetailsSP.SpecialityBenefits;
        }
    }
    
    // getEmp V3 changes start
    public void updatePolicySection(){
      try{
        system.debug('Inside status change'); 
        system.debug('Inside status change contracts'+groupDetails.polContract); 
        policyStatusSelected = ApexPages.currentPage().getParameters().get('policyStatus');
        system.debug('Inside status change policy status'+policyStatusSelected);
        if(policyStatusSelected == null)
            policyStatusSelected = 'Active';
        policyContractFiltered = new list<ACETGroupDetail.PolicyContract>();
        ACETGroupDetail.PolicyContract policyItem = new ACETGroupDetail.PolicyContract();
        if(groupDetails.polContract != null){ 
            for(ACETGroupDetail.PolicyContract pol:groupDetails.polContract ){
                if(pol.policyStatus == policyStatusSelected){
                    System.debug('PolContractHere ' + pol);
                    policyItem = pol ;
                    policyContractFiltered.add(policyItem);
                }
            }
        }
            policyContractFiltered.sort();
        }catch(Exception e){
         setErrorMsg('MGD997',e);
        }
    }
    Public Void updategroupaffliations(){
       isgroupaffliationstab = true;
                 grpAffiliationsinfolist = new list<ACETGroupDetail.GroupAffiliationsinfo>();
        if(groupDetails != null && groupDetails.grpAffiliationsinfo != null && 
           groupDetails.grpAffiliationsinfo.childGroupidlist != null && groupDetails.grpAffiliationsinfo.childGroupidlist.size() > 0){
            for(Integer i = 0;i < groupDetails.grpAffiliationsinfo.childGroupidlist.size(); i++){
                ACETGroupDetail.GroupAffiliationsinfo affinfo = new ACETGroupDetail.GroupAffiliationsinfo();
                affinfo.childGroupid = groupDetails.grpAffiliationsinfo.childGroupidlist[i];
                affinfo.childGroupname = groupDetails.grpAffiliationsinfo.childGroupnamelist[i];
                grpAffiliationsinfolist.add(affinfo);
            }
        }else{
            grpAffiliationsinfolist.add(groupDetails.grpAffiliationsinfo);
        } 
        grpAffiliationsinfolistStr = JSON.serialize(grpAffiliationsinfolist);
        System.debug('>>>>>grpAffiliationsinfolistStr :'+grpAffiliationsinfolistStr);
    } 
    public void getInserteventlog(){
        string ssnvalue =  Apexpages.currentPage().getParameters().get('ssn');
        string constituentEID = Apexpages.currentPage().getParameters().get('constituentEID');
        string constituentType = Apexpages.currentPage().getParameters().get('constituentType');
        string catagoryValue = Apexpages.currentPage().getParameters().get('catagoryValue');
        system.debug('SSN Value==='+ssnvalue);
        try{
            PHI_Access_Log__c PHILog = new PHI_Access_Log__c();
            PHILog.Access_Location__c = constituentType;
            PHILog.Type__c = catagoryValue; //'SSN';
            PHILog.EID__c = constituentEID;
            PHILog.SSN__c = ssnvalue; //SSNUnMaskValue;
            //US1056408 Checkmarx code
            if(PHI_Access_Log__c.SObjectType.getDescribe().isCreateable()){
                insert PHILog;
            }
        }
        catch(DMLException e){
            system.debug('Issue wheile inserting PHI'+e);
        }
    }
    
}