public with sharing class ACETIdCardRequestController extends ACETErrorHandler {
    public String currentTrackingId {get;set;}
    public String Resolved { get; set; }
    public Interaction__c Interaction { get; set; }
    public Contact Subject { get; set; } 
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public string memberId{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string familyMember{get;set;}
    public List<SelectOption> familyMembers{get;set;}
    public List<ACETMemberDetail.FamilyMember> FamilyInfo {get;set;}
    public personWrapper memDetailWrap{get;set;}
    public List<ACETFormsHistoryResult>  formshistory{set;get;}
    public string serviceName;
    ACETGetFamilyMemberWebService ACETGetMemWebService;
    ACETGetIndividualWebService ACETGetIndWebservice;
    public ACETMemberDetail memberDetail{set;get;}
    public string reponseMessage{get;set;}
    public string correlationID{get;set;}
    public string coverageGroupNumber{get;set;}
    public string coverageEffectiveDate;
    public string coverageSRK;
    public string DynamicParams{get;set;}
    public string reqDate{get;set;}
    public map<string,string> memberTokenMap{get;set;}
    public string documentType;
    public List<ACETFindDocWebservice.documentKey> findDocKeys{get;set;}
    public string documentId{get;set;}
    public string surrogateKey{get; set;}    
    public string selectedFamilyId{get;set;} 
    public integer familySize{get;set;}  
    public Map<String, List<ACETFormsHistoryResult>> formHistoryResultMap{get;set;}
    public Map<String, boolean> formHistorySizeMap{get;set;}
    public boolean notResearchUser {get;set;}
    public Interaction__c ordHistStartdate {get;set;}
    public String ordHistEnddate {get;set;}
    
    public  ACETIdCardRequestController()
    { 
      try{
        memDetailWrap = new PersonWrapper();
        memberId = apexpages.currentpage().getparameters().get('memberId');
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string familyInfoStr = apexpages.currentpage().getparameters().get('familyMembers');
        string subjectId= apexpages.currentpage().getparameters().get('contactId');
        string groupId= apexpages.currentpage().getparameters().get('groupId');
        memberTokenMap = new map<string,string>();
        formHistoryResultMap =new Map<String,List<ACETFormsHistoryResult>>();
        formHistorySizeMap =new Map<String, boolean>();
        getloggedinProfileName();
        
        familyMembers = new List<SelectOption>();
        familyMembers.add(new SelectOption('--None--','--None--'));
        system.debug('familyInfo--->'+familyInfoStr);
        system.debug('subjectId --->'+subjectId );
        if(subjectId != Null && subjectId != '' )
        {
             Subject = ACETMemberQueryUtil.queryContact(subjectId);
        }
        if(InteractionId != null && InteractionId != '')
        {
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        }
        initHighlightPanelAdditionalInfo();
        init();
       }catch(Exception e){
        setErrorMsg('MG997',e);
       }
    }
    private void getloggedinProfileName(){ 
       try{
        notResearchUser = true;
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedinProfileName = PROFILE[0].Name;
        if(loggedinProfileName.contains('Research'))
        { 
            notResearchUser = false;
        }
       }catch(Exception e){
        setErrorMsg('MG997',e);
       }
    }
    public Object getFamilyMembers()
    {
        Continuation getMembershipContinuation; 
        ACETGetMemWebservice = new ACETGetFamilyMemberWebService();
        memberDetail = new ACETMemberDetail();
        coverageGroupNumber = apexpages.currentpage().getparameters().get('coverageGroupNumber');
        coverageEffectiveDate = apexpages.currentpage().getparameters().get('coverageEffectiveDate');
        coverageSRK = apexpages.currentpage().getparameters().get('coverageSRK');
        try{
        system.debug('coverageSRK --->'+coverageSRK+'---'+coverageGroupNumber +'----'+coverageEffectiveDate );
        if(coverageGroupNumber != Null && coverageGroupNumber != '' && coverageEffectiveDate != Null && coverageEffectiveDate !='')
        {
             memberDetail.SurrogateKey = coverageSRK;
             memberDetail.PreferredCoverage = new ACETMemberDetail.CoverageLine();
             memberDetail.PreferredCoverage.groupNumber = coverageGroupNumber;
             memberDetail.PreferredCoverage.effectiveDate = coverageEffectiveDate;
             memberDetail.PreferredCoverage.SurrogateKey = coverageSRK;         
        
        }
        system.debug('inside call membership :'+MemberDetail.SurrogateKey);
        if(!String.IsEmpty(MemberDetail.SurrogateKey)) {
            ACETGetMemWebservice = new ACETGetFamilyMemberWebService();
            system.debug('starting getmembership service');
            getMembershipContinuation = ACETGetMemWebservice.StartRequest(MemberDetail.SurrogateKey,MemberDetail,'GetMembershipCallback',null); 
                        system.debug('request prepared getmembership service');
        }
        }catch(Exception e){
         setErrorMsg('MG997',e);
        } 
        return getMembershipContinuation;   
    }
    public PageReference GetMembershipCallback() {
       try{
        system.debug('inside call bacl method'); 
        ACETWSCalloutResult getMembershipResponse;
        FamilyInfo = new list<ACETMemberDetail.FamilyMember>();
        getMembershipResponse = ACETGetMemWebservice.ProcessResponse(ACETGetMemWebservice.RequestLabel, MemberDetail);
        system.debug('inside call back method' + getMembershipResponse); 
        if(getMembershipResponse.Success) {
            system.debug('>>>>>>> >>>>>> '+MemberDetail);
            MemberDetail = (ACETMemberDetail)getMembershipResponse.Response;
            system.debug('@@@ family Members '+MemberDetail.FamilyMembers);
            if(MemberDetail.FamilyMembers != Null)
            {
                for(ACETMemberDetail.FamilyMember familyMem:MemberDetail.FamilyMembers)
                {
                    if(familyMem.Relationship == 'Self')
                    FamilyInfo.add(familyMem);
                }
                for(ACETMemberDetail.FamilyMember familyMem:MemberDetail.FamilyMembers)
                {
                    if(familyMem.Relationship == 'Spouse')
                    FamilyInfo.add(familyMem);
                }
                for(ACETMemberDetail.FamilyMember familyMem:MemberDetail.FamilyMembers)
                {
                    if(familyMem.Relationship != 'Spouse' && familyMem.Relationship != 'Self')
                    FamilyInfo.add(familyMem);
                }
            }
            familySize = FamilyInfo.size();
        }else{
            if(getMembershipResponse.statusCode==400){
              setErrorMsg('GN'+'400B',null);
            }else{
              setErrorMsg('GN'+getMembershipResponse.statusCode,null);
            }
        }
        
        if(MemberDetail.FamilyMembers != null)
        {
            for(ACETMemberDetail.FamilyMember familyMem:MemberDetail.FamilyMembers)
            {
                memberTokenMap.put(familyMem.FamilyId,'');
                formHistoryResultMap.put(familyMem.FamilyId, new List<ACETFormsHistoryResult>()); 
                 formHistorySizeMap.put(familyMem.FamilyId,false);     
            }
        
        }
        system.debug('MemberDetail second callback '+JSON.serialize(MemberDetail)); 
       }catch(Exception e){
        setErrorMsg('MG997',e);
       } 
        return null;
    }      
    
    private void initHighlightPanelAdditionalInfo(){
      try{
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        } 
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        
           
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
       }catch(Exception e){
         setErrorMsg('MG997',e);   
       } 
    }
    
    public void init(){
      try{
        //isClaim = true;
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'ID Card Request';
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }    
       // toggleShowPlanBenefits();
       //Added for user story US927032 
       //Changed to 365 from 90days as a part of US1067783 
       ordHistStartdate = new Interaction__c();
       ordHistStartdate.tst_Date_Field__c = Date.today()-365;
       Date d = ordHistStartdate.tst_Date_Field__c+365;
       String futureDate = d.month() +'/' + d.day() +'/' + d.year();
       //String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
       ordHistEnddate= futureDate;     
       }catch(Exception e){
         setErrorMsg('MG997',e);
       }  
    }
    //Added the below method for user story US927032 
    public void calculateEnddate(){
      try{
        if(ordHistStartdate.tst_Date_Field__c != null){
            Date d = ordHistStartdate.tst_Date_Field__c+365;
            String futureDate = d.month() +'/' + d.day() +'/' + d.year();
            //String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
            ordHistEnddate= futureDate;
        }
       } 
        catch(Exception e){
         setErrorMsg('MG997',e);
        }
    }
    public void getPersonInfo()
    {
        system.debug('Member ID before'+selectedFamilyId);
       if(String.isNotBlank(selectedFamilyId)) {
          if (!formHistoryResultMap.containsKey(selectedFamilyId)) { 
                    formHistoryResultMap.put(selectedFamilyId, new List<ACETFormsHistoryResult>());
            }else {
                formshistory = new List<ACETFormsHistoryResult>();
                ACETFormsHistoryWebService formsHistoryWebService = new ACETFormsHistoryWebService();
                //formsHistoryWebService.init('ACET',Integer.ValueOf(label.ACETIDCardDocumentType),cleanDate(String.valueOf(system.today().addDays(-90).format())),cleanDate(String.valueOf(system.today().format())),String.valueOf(selectedFamilyId),'MemberID'); //String.valueOf(memberId)  '54654802300'
                system.debug('-----ordHistStartdate.tst_Date_Field__c-----'+string.valueof(ordHistStartdate.tst_Date_Field__c));
                system.debug('-----ordHistEnddate-----'+string.valueof(ordHistEnddate));
                formsHistoryWebService.init('ACET',Integer.ValueOf(label.ACETIDCardDocumentType),cleanDate(String.valueOf(ACETUtility.format(ordHistStartdate.tst_Date_Field__c))),String.valueOf(ordHistEnddate),String.valueOf(selectedFamilyId),'MemberID');
                ACETWSCalloutResult searchResult =  formsHistoryWebService.queryPaginatedData(1,1,1);
                system.debug('searchResult------'+searchResult.Response);
               if(searchResult.Message  == ''){
                formshistory.addAll( (List<ACETFormsHistoryResult>) searchResult.Response);
                formHistoryResultMap.get(selectedFamilyId).clear();
                formHistoryResultMap.get(selectedFamilyId).addAll((List<ACETFormsHistoryResult>)searchResult.Response);
                 if(formHistoryResultMap.get(selectedFamilyId)!=null && formHistoryResultMap.get(selectedFamilyId).size()==0){
                    formHistorySizeMap.put(selectedFamilyId,true);
                }else{
                   formHistorySizeMap.put(selectedFamilyId,false);
                }
              }
            else{
                 if(searchResult.statusCode==400){
                    setErrorMsg('GN'+'400B',null);
                 }else{
                     setErrorMsg('GN'+searchResult.statusCode,null);
                  }
                 //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,searchResult.message));
            }
           } 
         }     
      }
    
    public void findDocument()
    {
        documentType = 'IDCARDS';
        system.debug('DynamicParams is '+DynamicParams);
        List<String> keyparams = (List<String>)JSON.deserialize(DynamicParams, List<String>.class);
        system.debug('keyparams is '+keyparams[0]);
        ACETFindDocWebservice.documentKey key;
        findDocKeys = new List<ACETFindDocWebservice.documentKey>();
        for(String par: keyparams){
            String [] str = par.split(',');
            
            key = new ACETFindDocWebservice.documentKey();
            key.name = str[0];
            key.value = str[1];
            system.debug('!!!keys'+key);
            findDocKeys.add(key);
            
        }
        system.debug('!!!findDocKeys'+findDocKeys);
        
        ACETFindDocWebservice FindDocService = new ACETFindDocWebservice();
        FindDocService.init(documentType,findDocKeys);                           
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult = FindDocService.queryPaginatedData(1,1,1);
        
        if(oACETWSCalloutResult.success)
        {
            List<Map<String,String>> documents = new List<Map<String,String>>();
            documents = (List<Map<String,String>>)oACETWSCalloutResult.Response;
            documentId = '';
            for(Map<String,String> document : documents){
                if(documentId==''){
                    for(String checkData:document.keySet()) {
                        if(checkData.endsWith('RUNDATE')) {
                            String dateReq = document.get(checkData);
                            dateReq = Integer.valueOf(dateReq.split('-')[1])+'/'+Integer.valueOf(dateReq.split('-')[2])+'/'+Integer.valueOf(dateReq.split('-')[0]);
                            if(reqDate==dateReq){
                            String documentNumber = checkData.replace('RUNDATE','');
                            documentId = document.get(documentNumber+'DocumentId');
                            break;
                            }
                        }
                        
                    }
                }
            }
        }
        else{
            if(oACETWSCalloutResult.statusCode==403){
            setErrorMsg('GN'+'500',null);
            }else if(oACETWSCalloutResult.statusCode==400){
             setErrorMsg('GN'+'400B',null);
            }else{
              setErrorMsg('GN'+oACETWSCalloutResult.statusCode,null);
            }
            //Apexpages.addMessage(new ApexPages.message(oACETWSCalloutResult.MessageSeverity,oACETWSCalloutResult.Message));
        }
    }
    
    public void submitOrderCall()
    {
        string memberEid= ApexPages.currentPage().getParameters().get('selectedMember');
        string selectedGroupId= ApexPages.currentPage().getParameters().get('selectedGroupId');
        string BenBundleId= ApexPages.currentPage().getParameters().get('BenBundleId');
        
        system.debug('!!!memberEid'+memberEid);
        system.debug('!!!selectedGroupId'+selectedGroupId);
        system.debug('!!!BenBundleId'+BenBundleId);
        ACETSubmitfulfillmentrequest submitRequestWS = new ACETSubmitfulfillmentrequest();
        ACETWSCalloutResult WSReponse = submitRequestWS.submitFulfillmentRequest(memberEid,selectedGroupId,BenBundleId);
        if(WSReponse.Success)
        {
            memberTokenMap.put(memberEid,string.valueOf(WSReponse.Response));
            currentTrackingId = string.valueOf(WSReponse.Response);
        }else
        { 
           if(WSReponse.statusCode==429){
             setErrorMsg('MGD'+WSReponse.statusCode,null);
           }else if(WSReponse.statusCode==400||WSReponse.statusCode==422){
             setErrorMsg('GN'+'400B',null);
           }else{
             setErrorMsg('GN'+'500',null);
          }
            //reponseMessage = 'Web Service or External System is temporarily unavailable.';
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Web Service or External System is temporarily unavailable.'));
        }
    
    }
    
    public String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        String newDay= '';
        if(s[0].length() == 1){
            newMonth = '0'+s[0];
        }else{
            newMonth = s[0];
        }
        if(s[1].length() == 1){
            newDay = '0'+s[1];
        }else{
            newDay = s[1];
        }
        newDate = newMonth+'/'+newDay+'/'+s[2];
        system.debug('-------cleaned date-------'+newDate);
        return newDate;
    }
    
    public class personWrapper{
        public String personOrganization{get;set;}
        public String personFirstName{get;set;}
        public String personMiddleName{get;set;}
        public String personLastName{get;set;}
        public String personFullName{get;set;}
        public String personSuffix{get;set;}
        public String personAddOne{get;set;}
        public String personAddTwo{get;set;}
        public String personCity{get;set;}
        public String personState{get;set;}
        public String personZipCode{get;set;}
        public string groupNumber{get;set;}
        public string benefitBundleOptionID{get;set;}
        public string memberId{get;set;}
        
    }
}