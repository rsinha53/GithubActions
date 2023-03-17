public with sharing class ACETViewMemberListingController extends ACETErrorHandler {
    public List<String> listbundles{get;set;}
    public List<String> listpops{get;set;}
    public string view {get;set;}
    public string status {get;set;}
    public string bundleID {get;set;}
    public String selectedPop {get;set;}
    public Boolean hasPop {get;set;}
    public string inquiryDate {get; set;}
    public string selectedSubscriber {get; set;}
    public string selectedStatus {get; set;}
    public string groupID {get; set;}
    public Boolean isSubscriberOnly {get; set;}
    public Boolean GoToLink {get;set;}
    public Contact Subject {get;set;}
    public ACETGroupDetail groupDetails {get; set;}
    Transient public List<ACETViewMemberListingResultsWrapper> searchMemberListingResults {get;set;}
  Transient   public List<ACETViewMemberListingResultsWrapper> filteredList{get;set;} 
    public List<AcetGroupDetail.PolicyContract> GroupPolicyResultsList {get; set;}
    public List<List<String>> resultsList{get;set;}
    public static String ErrorMessage {get; set;}
    public Interaction__c Interaction { get; set; } 
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETDatatableWrapper DTWrapper {get; set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String startRecord {get; set;}
    public String callTopic{get;set;}
    
    public static ACETGroupDetail groupPlanDetails{get;set;}
    public static List<ACETGroupDetail.GroupPlanWrapper> GroupPlanSearchResults {get; set;}
    public List<SelectOption> options{get;set;}
    public List<SelectOption> getbenefitBundle{get;set;}
    public List<SelectOption> populationsList{get;set;}
    public List<String> values{get;set;}
    public String MemberId{get;set;}
    public String FirstName{get;set;}  
    public String dateOfBirth{get;set;}  
    public String hpAdditionInfoStr {get{
        return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
    }set;}
    public String contractStatus,effDate,endDate;
    public String contractId{get;set;}
    public String bundles{get;set;}
    public String allPops{get;set;}
    public Integer cobraCount{get;set;}
   Transient public list<ACETViewMemberListingResultsWrapper> finalList{get;set;}   
    public String continuationType{get;set;}     
    public class applicationException extends Exception {}
    public String filterStatus {get;set;}
    public Boolean isLargeGroup {get;set;}
    
    public ACETViewMemberListingController() {
      try{   
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        groupID = apexpages.currentpage().getparameters().get('groupId');
        contractId = apexpages.currentpage().getparameters().get('contractId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        contractStatus = apexpages.currentpage().getparameters().get('status');
        effDate= apexpages.currentpage().getparameters().get('effDate');
        endDate= apexpages.currentpage().getparameters().get('endDate');
        continuationType= apexpages.currentpage().getparameters().get('continuationType');
        continuationType = (continuationType != null && continuationType.contains('State'))?continuationType.split('/')[0]:(continuationType != null)?continuationType :'';
        filterStatus = apexpages.currentpage().getparameters().get('filterStatus');            
        system.debug('GroupID information ====>'+groupID+startRecord);      
        isLargeGroup = false;  
        groupDetails = new ACETGroupDetail();
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        initHighlightPanelAdditionalInfo();
        }catch(Exception e){
          setErrorMsg('MGD997',e);
        }
             
    }
    
    public void passParamsStartRecord() {
        startRecord = apexpages.currentpage().getparameters().get('startRecordV');
        system.debug('Start Record ====>'+startRecord);   
    }
    //View Dropdown values
    public List<SelectOption> getviewList () {
        List<SelectOption> viewList = new List<SelectOption>();
        viewList.add(new SelectOption('Subscriber','Subscriber Only'));
        viewList.add(new SelectOption('All Members','All Members'));
        return viewList;
    }
    
    //Status Dropdown values
    public List<SelectOption> getstatusList () {
        List<SelectOption> statusList = new List<SelectOption>();
        statusList.add(new SelectOption('All','All'));
        statusList.add(new SelectOption('Active','Active'));
        statusList.add(new SelectOption('Termed','Termed'));
        statusList.add(new SelectOption('Pend','Pend'));
        statusList.add(new SelectOption('Future','Future'));
        return statusList;
    }
    
    //Below method calls on page load. By default it takes view,status and date values to get the data from cirrus also populates Benefit Bundle Id's
    public void getMemberListingOnLoad() {
      try{ 
        system.debug('Start Record ====>'+startRecord); 
        Date dateVal = Date.Today();
        searchMemberListingResults = new List<ACETViewMemberListingResultsWrapper>();
        filteredList = new List<ACETViewMemberListingResultsWrapper>();
        finalList = new List<ACETViewMemberListingResultsWrapper>();
        selectedSubscriber = apexpages.currentpage().getparameters().get('subscriber');
        status = 'All';
        system.debug('@@@ status'+status);
        bundleId = 'All'; 
        selectedPop = 'All';
        isSubscriberOnly = isSubscriber(selectedSubscriber);
        populationsList = new List<SelectOption>();
        getBenefitBundle = getBenefitBundleID(groupID);
        system.debug('!!!@@@bundles'+getBenefitBundle );
        getMemberListingResults(groupID,convertDateFormat(AcetUtility.format(dateVal)),isSubscriberOnly,status,bundleId,selectedPop);
        
        system.debug('!!!aftervalues'+values);
       }catch(Exception e) {
         setErrorMsg('MGD997',e);
       } 
    }
        
    // Onclick of search functionality -- Starts
    public void search() {
      try{
        searchMemberListingResults = new List<ACETViewMemberListingResultsWrapper>();
        //filteredList = new List<ACETViewMemberListingResultsWrapper>();
        finalList = new List<ACETViewMemberListingResultsWrapper>();
        Map<String,String> viewMap = getMapViewValues();
        Map<String,String> statusMap = getMapStatusValues();
        isSubscriberOnly = isSubscriber(viewMap.get(view));
        getMemberListingResults(groupID,convertDateFormat(inquiryDate),isSubscriberOnly,statusMap.get(status),bundleID,selectedPop);
       }catch(Exception e) {
        setErrorMsg('MGD997',e);
       }
        
    }
    
    public void clear() {
       try{
        view = 'Subscriber';
        status = 'All';
        Date dateVal = Date.Today();
        inquiryDate = AcetUtility.format(dateVal);
        bundleId = '';
        
        Map<String,String> viewMap = getMapViewValues();
        Map<String,String> statusMap = getMapStatusValues();
        isSubscriberOnly = isSubscriber(viewMap.get(view));
        getMemberListingResults(groupID,convertDateFormat(inquiryDate),isSubscriberOnly,statusMap.get(status),bundleID,selectedPop);
       }catch(Exception e) {
        setErrorMsg('MGD997',e);
       }
       
    }
    
    /******************************************************************************************************************
      This method calls the webservice in a loop to get all the Members of the group till the hasNextPage in the response 
      returns false. Following are the Salesforce limitations to display greater than 1000 records
       1) Will throw an error when View State is reached above 135KB (Workaround to use html table)
       2) 101 SOQL limit error for more than 2000 records as we get 20 records per call.
       3) Load time will increase with number of calls made.
    *******************************************************************************************************************/ 
    public void getMemberListingResults(string groupID,string inquiryDate,Boolean view,string statusValue,string bundleId, String selectedPopulation) {
        system.debug('Start Record ====>'+startRecord);
        continuationType= apexpages.currentpage().getparameters().get('continuationType');
        continuationType = (continuationType != null && continuationType.contains('State'))?continuationType.split('/')[0]:(continuationType != null)?continuationType :'';
        
        system.debug('====> Cont'+continuationType);
        
        List<ACETViewMemberListingResultsWrapper> bundleList = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> statusList = new List<ACETViewMemberListingResultsWrapper>();
        filteredList = new List<ACETViewMemberListingResultsWrapper>();
        finalList = new List<ACETViewMemberListingResultsWrapper>();
        
        List<ACETViewMemberListingResultsWrapper> searchResults = null;
        try {
            ApexPages.currentPage().getParameters().put('autosearch','0');
            
            integer Index = 0,j;
            ACETViewMemberListingWebService getMemberListing = new ACETViewMemberListingWebService();
            system.debug('!!!stat' +statusValue);
            if(statusValue== 'Future')
                status = 'ActiveFuture';
            else 
                status = statusValue;
            
            system.debug('~~~status before for'+status+index);                 
                 system.debug('~~~status'+status+'~'+index+'~'+j);   
                getMemberListing.init(groupID,inquiryDate,view,status,bundleId);
                ACETWSCalloutResult GetMemListingResponse; 
                Integer i = 1;
                                Integer MemberListingRecordsPerCall =  integer.valueof(System.Label.ACETMemberListingRecordsPerCall);

                Boolean checker = true;
                do{   
                system.debug('***i'+i);
                    GetMemListingResponse = getmemberlisting.querypaginateddata(i ,MemberListingRecordsPerCall, 1);
                    system.debug('***'+GetMemListingResponse);
                    if(GetMemListingResponse.Success){
                        List<ACETViewMemberListingResultsWrapper> tempList = (List<ACETViewMemberListingResultsWrapper>)GetMemListingResponse.Response;
                        system.debug('tempList = ' + tempList);
                        system.debug('searchMemberListingResults===>'+searchMemberListingResults.size());
                        //system.debug('!!!!!!! New' + getmemberlisting.querypaginateddata(1 , 20, 1));
                        if(searchMemberListingResults.size() >= 980){ 
                          integer k = 0;
                          while(searchMemberListingResults.size() < 1000){ 
                            searchMemberListingResults.add(tempList[k]);
                            k++;
                          }
                        } else {
                          searchMemberListingResults.addAll(tempList);
                          system.debug('***checker'+checker);
                        }
                    }else{
                        if(GetMemListingResponse.statusCode==409||GetMemListingResponse.statusCode==500){
                        // setErrorMsg('GN'+'500',null);
                        }
                    }
                   
                    i=i+1;
                    if(GetMemListingResponse.hasNextPage == false){
                        checker = false;
                      
                    } else if(searchMemberListingResults.size() > 999){ 
                        checker = false;
                    }
                    if(searchMemberListingResults.size() > 999){ 
                        isLargeGroup = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This group exceeds 1,000 members. Select the Email PDF button to receive the Member Listing.'));

                    } else {
                        isLargeGroup = false;
                    }
                } while(checker == true);
                
                system.debug('$$$bundleId'+bundleId);
                system.debug('$$$all bundles'+getBenefitBundle );
                    
                // ***** Logic to filter Results to show Members with only Bundle Option Id's present in Contract Option selected
                if(bundleId == 'All' && searchMemberListingResults != null){
                    system.debug('$$$Inside bundles'+getBenefitBundle );
                    for(ACETViewMemberListingResultsWrapper fil: searchMemberListingResults ){
                        system.debug('$$$filteritem'+fil );
                        //ACETViewMemberListingResultsWrapper item = new ACETViewMemberListingResultsWrapper();
                        for(SelectOption s:getBenefitBundle ){
                        system.debug('$$$selectoption'+S + '   ' +fil.bundleId + ' ' +s.getValue());
                            if(fil.bundleId == s.getValue())
                                bundleList.add(fil);
                        }
                    
                    }
                }
                else
                {
                    bundleList = searchMemberListingResults ;
                }
                if(bundleList != null){
                
                    if( statusValue == 'Future')
                    {
                        for(ACETViewMemberListingResultsWrapper sta: bundleList){
                            if(sta.Status.toLowerCase() == statusValue.toLowerCase())
                                statusList.add(sta);
                        }
                    }
                    else
                        statusList = bundleList ;
                    
                }
                
                if(selectedPopulation != 'All'  && selectedPopulation != null && selectedPopulation != '' && selectedPopulation != 'undefined'){
                    for(ACETViewMemberListingResultsWrapper pop: statusList){
                         string pop1 = pop.population.deleteWhitespace();
                       string pop2 =  selectedPopulation.deleteWhitespace();
                        if(pop1.trim() == pop2.trim()){
                            filteredList.add(pop);
                        }
                    }
    
                } else if(selectedPopulation == 'All' && populationsList.size()>1 ){
                    
                    for(ACETViewMemberListingResultsWrapper pop: statusList){
                        for(SelectOption so:populationsList ){
                           string pop1 = pop.population.deleteWhitespace();
                       string pop2 =  so.getValue().deleteWhitespace();
                        if(pop1.trim() == pop2.trim()){
                                filteredList.add(pop);
                            }
                        }
                    }
                }
                else 
                if(statusList.size()<1000){
                    filteredList = statusList;
                }
                system.debug('$$$finalsize'+finalList.size() + ' ' +finalList);

            cobraCount = 0;
            if(filteredList != null){
                for(ACETViewMemberListingResultsWrapper filItem:filteredList){
                    if(filItem.continuationType == 'Y'){
                        cobraCount = cobraCount + 1 ; 
                        //filItem.continuationType = (continuationType != null && continuationType.contains('State'))?continuationType.split('/')[0]:(continuationType != null)?continuationType :'';
                        filItem.continuationType = continuationType;
                    }
                    else
                        filItem.continuationType = '';
                    if(filteredList.size()<1000){
                    finalList.add(filItem);
		                }else{
                    isLargeGroup = true;
                    }
                }
            }
            
            finalList.sort();
            
        }
        catch(Exception ex) {
           setErrorMsg('MGD997',ex);
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable));   
        }
    }
    
    public static ACETWSCalloutResult callwebservice(string groupId)
    {
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.getEmployerGroupDetail(groupId);
        System.debug('Allowing.................'+responseData);
        return responseData;
    }
    
    //Benefit Bundle Option ID Dropdown values
    public List<selectOption> getBenefitBundleID(String groupID)
    {
        groupPlanDetails = new ACETGroupDetail(); 
        List<String> values = new List<String>();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        populationsList.add(new SelectOption('All','All'));
        bundles='';
        allPops ='';
        GroupPolicyResultsList = new List<AcetGroupDetail.PolicyContract>();
        /*contractId = apexpages.currentpage().getparameters().get('contractId');
        contractStatus = apexpages.currentpage().getparameters().get('status');
        effDate= apexpages.currentpage().getparameters().get('effDate');*/
        system.debug('!!!'+contractId + '   ' +contractStatus+'  ' +effDate+'  ' +endDate);
        try {
            ACETWSCalloutResult responseGroupPlanData = callwebservice(groupID);
            System.debug('!!!@@@Response1...'+responseGroupPlanData);
            if(responseGroupPlanData.Success) {
                GroupPlanSearchResults = new List<ACETGroupDetail.GroupPlanWrapper>();
                groupPlanDetails = (ACETGroupDetail)responseGroupPlanData.response;
                System.debug('!!!@@@Response2...'+groupPlanDetails.polContract);
                if(groupPlanDetails.polContract != null){
                    Integer popCount = 0;
                    for(ACETGroupDetail.PolicyContract pol:groupPlanDetails.polContract ){
                        System.debug(contractStatus + ':' + pol.policyActualStatus + ',' + contractId + ':' + pol.policyConId + ',' + effDate + ':' + pol.effectiveDate + ',' + endDate + ':' + pol.endDate);
                        if(contractStatus == pol.policyActualStatus && contractId == pol.policyConId && effDate == pol.effectiveDate && endDate == pol.endDate){
                                System.debug('Adding the policy contracts' );
                                GroupPolicyResultsList.add(pol);
                                
                            }
                        if(contractId == pol.policyConId && contractStatus == pol.policyActualStatus && effDate == pol.effectiveDate && endDate == pol.endDate)
                        {
                            system.debug('!!!Condition matched');
                            if(pol.GroupPlanBenefitList != null) { 
                                for(ACETGroupDetail.GroupPlanWrapper groupPlan:pol.GroupPlanBenefitList ) {
                                    if(groupPlan.bundleID!=Null && groupPlan.bundleID!=''){
                                        bundles = bundles+(groupPlan.bundleID+',');
                                    }
                                    values.add(groupPlan.bundleID+' ('+groupPlan.effecDate+' - '+groupPlan.endDate+')');
                                    options.add(new SelectOption(groupPlan.bundleID,groupPlan.bundleID+' ('+groupPlan.effecDate+' - '+groupPlan.endDate+')'));
                                 }
                                 system.debug('!!!values'+values);
                            }
                            if(pol.population != null && popCount == 0) {
                                List<String> pops = pol.population.split(', ');
                                allPops = pol.population;
                                System.debug('Testing pops '+pops);
                                for(Integer i = 0; i < pops.size(); i++){
                                    if(pops[i] != null && pops[i] != '' && pops[i] != ' '){
                                        populationsList.add(new SelectOption(pops[i],pops[i]));
                                        hasPop = true;
                                    }
                                }
                                popCount++;
                            }
                        }
                        
                    } 
                    if(bundles!=Null && bundles!=''){
                         bundles= bundles.removeEnd(',');
                     }
                }         
            }
            else{ 
              if(responseGroupPlanData.statusCode==400){
                setErrorMsg('GN'+'400B',null);
              }else{
                 setErrorMsg('GN'+responseGroupPlanData.statusCode,null);
                 }
                //ApexPages.addMessage(new ApexPages.Message(responseGroupPlanData.MessageSeverity, responseGroupPlanData.Message));  
            }
            System.debug('HEREHEREHERE ' + GroupPolicyResultsList);
        }  
        catch(Exception ex)
        { 
            setErrorMsg('MGD997',ex);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
        }   
        return options;
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
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            System.debug('Group Additional information'+deserializedExceptionData);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
            
            
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
       }catch(Exception e){
         setErrorMsg('MGD997',e);
        } 
    }
    public void setMemberListingData(){
       try{ 
        MemberId = ApexPages.currentPage().getParameters().get('MemberId');
        dateOfBirth= ApexPages.currentPage().getParameters().get('dateOfBirth');
        GoToLink = Boolean.valueof(ApexPages.currentPage().getParameters().get('GoToLink'));
        groupID = apexpages.currentpage().getparameters().get('groupId');
        }catch(Exception e){
         setErrorMsg('MGD997',e);
        }
    }
    
    public static string convertDateFormat(String selectedDate) {
    
       String[] splitDateList;
        if(selectedDate != null) {
            splitDateList = selectedDate.split('/');
        }
        return (splitDateList[2]+'-'+splitDateList[0]+'-'+splitDateList[1]);
    }
    
    public static Map<String,String> getMapViewValues() {
        Map<String,String> mapReponseViewValues = new Map<String,String>();
        mapReponseViewValues.put('All Members','');
        mapReponseViewValues.put('Subscriber','Subscriber');
        return mapReponseViewValues;
    } 
    
    public static Map<String,String> getMapStatusValues() {
        Map<String,String> mapReponseStatusValues = new Map<String,String>();
        
        mapReponseStatusValues.put('All','All');
        mapReponseStatusValues.put('Active','Active');
        mapReponseStatusValues.put('Termed','Term');
        mapReponseStatusValues.put('Pend','Pend');
        mapReponseStatusValues.put('Future','Future');
        return mapReponseStatusValues;
    }
    
    public static Boolean isSubscriber(String selectedSubscriberVal) {
        Boolean isSelected = false;
        if(selectedSubscriberVal == 'Subscriber') {
            isSelected = true;
        }
        return isSelected;
    } 
    
  public PageReference startMemberListing() {
  string emailstring = UserInfo.getUserEmail();
  if(emailstring.contains('@uhg.com')||emailstring.contains('@optum.com')||emailstring.contains('@uhc.com')||emailstring.contains('@umr.com')){
      apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'You will receive an email when the Member Listing request has been completed.'));
List<ACETViewMemberListingResultsWrapper> finalListadded ;
       string request = apexpages.currentpage().getparameters().get('values');
       string      statusPDF = apexpages.currentpage().getparameters().get('status');
       groupId = apexpages.currentpage().getparameters().get('groupnumber');
       string    inquiryDate = apexpages.currentpage().getparameters().get('inquiryDate');
       string bundleID = apexpages.currentpage().getparameters().get('bundleId');
       string selectedPopulation = apexpages.currentpage().getparameters().get('selPop');
       string continuationType = apexpages.currentpage().getparameters().get('contType');
       string allpops = apexpages.currentpage().getparameters().get('allPop');
       string bundles = apexpages.currentpage().getparameters().get('bundles');
       string hasPop = apexpages.currentpage().getparameters().get('hasPop');
       string contractId = apexpages.currentpage().getparameters().get('contractId');
       string contenttype = apexpages.currentpage().getparameters().get('contenttype');
       string   groupName =  apexpages.currentpage().getparameters().get('groupName');

       Integer   startRecord = 1;
       string renderAs = 'PDF';
       string  baseURL=URL.getSalesforceBaseUrl().toExternalForm();
         
        if(bundles!=Null && bundles!=''){
           listbundles = bundles.split(',');
        }
        if(allpops!=Null && allpops!=''){
        listpops = allpops.split(',');
        }
                
        String tempcobraCount = apexpages.currentpage().getparameters().get('cobCount');
        if(tempcobraCount!=Null && tempcobraCount!=''){
         cobraCount =Integer.valueOf(tempcobraCount);
        }
        else{
         cobraCount=0;
        }
        integer i=1;
 string hasPopstr ;
        system.debug('hasPopstr =====>'+hasPop);
        if(hasPop !='false'){
        hasPopstr ='yes';
        }else{
        hasPopstr ='no';
        }
     System.enqueueJob(new ACETGetMemberListingResults(inquiryDate,request,statusPDF,groupId,bundleID,listbundles,selectedPopulation,listpops,continuationType,i,hasPopstr,groupName,contractId,cobraCount,finalListadded,contenttype));
}else{
      apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Message: Insufficient privileges.'));

}
           return null;

  }  
    
   

}