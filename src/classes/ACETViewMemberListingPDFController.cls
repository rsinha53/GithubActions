public with sharing class ACETViewMemberListingPDFController {

    public List<ACETViewMemberListingResultsWrapper> searchMemberListingResults {get;set;}
    public List<ACETViewMemberListingResultsWrapper> filteredList{get;set;} 
    public list<ACETViewMemberListingResultsWrapper> finalList{get;set;}   
    //public List<MemberListingWrapper> membListWrap {get; set;}
    public String statusPDF {get; set;}
    public String groupName {get; set;}
    public String groupId {get; set;}
    public String request {get; set;}
    public String bundleID {get; set;}
    public String selectedPopulation{get;set;}
    public Boolean hasPop{get;set;}
    public String dateValues {get; set;}
    public String inquiryDate {get; set;}
    public String renderAs {get; set;}
    public List<SelectOption> options{get;set;}
    public String bundles{get;set;}
    public String allpops{get;set;}
    public List<String> listbundles{get;set;}
    public List<String> listpops{get;set;}
    //public Integer pageNumber {get; set;}
    // public Integer pageSize {get; set;}
    public Integer startRecord {get; set;}
    public String groupNameId{get;set;}
    public ACETDatatableWrapper DTWrapper {get; set;}
    public ACETWSCalloutResult searchResults {get; set;}
    public String baseURL{get;set;}
    public String contractId{get;set;}
    public String continuationType{get;set;}
    public Integer cobraCount{get;set;}
    public String selectedPopulationReplaced{get;set;}
    public String allPopsReplaced;
    public ACETViewMemberListingPDFController() {
        //searchMemberListingResults = new List<ACETViewMemberListingResultsWrapper>();
        //String groupNameId;
        listbundles = new List<String>();
        listpops = new List<String>();
        cobraCount = 0;
        request = apexpages.currentpage().getparameters().get('view');
        statusPDF = apexpages.currentpage().getparameters().get('status');
        groupId = apexpages.currentpage().getparameters().get('groupId');
        string groupnumber = apexpages.currentpage().getparameters().get('groupnumber');
        groupName = apexpages.currentpage().getparameters().get('groupName');
        inquiryDate = apexpages.currentpage().getparameters().get('inqDate');
        bundleID = apexpages.currentpage().getparameters().get('bundleId');
        selectedPopulation = EncodingUtil.urlEncode((apexpages.currentpage().getparameters().get('population')), 'UTF-8');
        selectedPopulationReplaced = apexpages.currentpage().getparameters().get('population');
        continuationType = apexpages.currentpage().getparameters().get('contType');
        allpops = EncodingUtil.urlEncode((apexpages.currentpage().getparameters().get('allPop')), 'UTF-8');
        allpopsReplaced = apexpages.currentpage().getparameters().get('allPop');
        bundles = apexpages.currentpage().getparameters().get('bundles');
        if(apexpages.currentpage().getparameters().get('hasPop') == 'true'){
            hasPop = true;
        } else {
            hasPop = false;
        }
        contractId = apexpages.currentpage().getparameters().get('contractId');
        startRecord = 1;
        renderAs = 'PDF';
        System.debug('Entering Values:::'+request+groupNameId);
        system.debug('----------bundles------'+bundles);
         baseURL=URL.getSalesforceBaseUrl().toExternalForm();
         
        if(bundles!=Null && bundles!=''){
          listbundles = bundles.split(',');
        }
        if(allpopsReplaced!=Null && allpopsReplaced!=''){
          listpops = allpopsReplaced.split(',');
        }
        if(groupnumber != null && groupnumber !=''){
           groupId = groupnumber;
          }      
        String tempcobraCount = apexpages.currentpage().getparameters().get('cobCount');
        if(tempcobraCount!=Null && tempcobraCount!=''){
         cobraCount =Integer.valueOf(tempcobraCount);
        }
        else{
         cobraCount=0;
        }
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        if(pageName.containsIgnoreCase('excel')){
            Apexpages.currentPage().getHeaders().put('Content-Disposition', 'attachment; filename="Member Listing '
                                                     +groupName+'.xls"');
        }
		
    }

   /******************************************************************************************************************
      This method calls the webservice in a loop to get all the Members of the group till the hasNextPage in the response 
      returns false to display on PDF and Excel. Following are the Salesforce limitations to display greater than 1000 records
       1) 101 SOQL limit error for more than 2000 records as we get 20 records per call.
       2) Load time will increase with number of calls made.
    *******************************************************************************************************************/ 
 public List<ACETViewMemberListingResultsWrapper> getSearchMemberListingResultsResp() {
        Map<String,String> viewMap = ACETViewMemberListingController.getMapViewValues();
        Map<String,String> statusMap = ACETViewMemberListingController.getMapStatusValues();
        searchResults = new ACETWSCalloutResult(); 
        searchMemberListingResults = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> bundleList = new List<ACETViewMemberListingResultsWrapper>();
        List<ACETViewMemberListingResultsWrapper> statusList = new List<ACETViewMemberListingResultsWrapper>();
        filteredList = new List<ACETViewMemberListingResultsWrapper>();
        finalList = new List<ACETViewMemberListingResultsWrapper>();
        dateValues = ACETViewMemberListingController.convertDateFormat(inquiryDate);
        Boolean isSubscriber = ACETViewMemberListingController.isSubscriber(viewMap.get(request));
        String Status;
        String statusValue = statusMap.get(statusPDF);
        integer Index = 0,j;
       Integer MemberListingRecordsPerCall = integer.valueof(System.Label.ACETMemberListingRecordsPerCall);

        ACETViewMemberListingWebService getMemberListing = new ACETViewMemberListingWebService();
        system.debug('!!!stat' +statusValue);
        if(statusValue== 'Future')
            status = 'ActiveFuture';
        else 
            status = statusValue;

        system.debug('~~~status before for'+status+index); 
            
             system.debug('~~~status'+status+'~'+index+'~'+j);   
        
            getMemberListing.init(groupId,dateValues,isSubscriber,status,bundleID); 
     
            Integer i = 1;
            Boolean checker = true;
            do{   
                system.debug('***i'+i);
                searchResults = getmemberlisting.querypaginateddata(i , MemberListingRecordsPerCall, 1);
                system.debug('***'+searchResults );
                if(searchResults.Success){
                       List<ACETViewMemberListingResultsWrapper> tempList = (List<ACETViewMemberListingResultsWrapper>)searchResults.Response;
                       searchMemberListingResults.addAll(tempList);
                       system.debug('***checker'+checker);
                       system.debug('!!!!!!! New '+i+ ':' + searchMemberListingResults);

                }
                i=i+1;
                if(searchResults.hasNextPage == false){
                    checker = false;
                }
                
            } while(checker == true);
        
             if(searchMemberListingResults != null){
                    system.debug('$$$Inside filtering');
                    system.debug('$$$Inside'+options);
                    for(ACETViewMemberListingResultsWrapper fil: searchMemberListingResults ){
                        //filteredList.add(fil);
                        for(string s:listbundles){
                            if(fil.bundleId == s){
                                bundleList.add(fil);
                            }
                        }
                    
                    }
                }
                else
                    bundleList = searchMemberListingResults ;
                
                
                if(bundleList != null){
                    
                    if( statusValue == 'Future')
                    {
                        for(ACETViewMemberListingResultsWrapper sta: bundleList){
                            if(sta.Status.toLowerCase() == statusValue.toLowerCase()){
                                statusList.add(sta);
                            }
                        }
                    }
                    
                    else
                        statusList = bundleList ;
                }
                
                if(selectedPopulationReplaced != 'All' && selectedPopulationReplaced != null && selectedPopulationReplaced != '' && selectedPopulationReplaced != 'undefined'){
                    for(ACETViewMemberListingResultsWrapper pop: statusList ){
                         string pop1 = pop.population.deleteWhitespace();
                            string pop2 =  selectedPopulationReplaced.deleteWhitespace();
                            if(pop1.trim() == pop2.trim()){
                            filteredList.add(pop);
                        }
                    }
    
                } else if(selectedPopulationReplaced == 'All' ){
                    system.debug('~~~'+selectedPopulationReplaced+listpops);
                    for(ACETViewMemberListingResultsWrapper pop: statusList){
                        for(string s:listpops){
                            string pop1 = pop.population.deleteWhitespace();
                            string pop2 =  s.deleteWhitespace();
                            if(pop1.trim() == pop2.trim()){
                                filteredList.add(pop);
                            }
                        }
                    }
                }else {
                    filteredList = statusList ;
                }

            
            if(filteredList != null){
                for(ACETViewMemberListingResultsWrapper filItem:filteredList){
                    if(filItem.continuationType == 'Y'){
                        filItem.continuationType = continuationType;
                    }
                    else{
                        filItem.continuationType = '';
                    }
                    finalList.add(filItem);
                }
            }
            finalList.sort();
            
        return finalList;
        //US1023353 changes end by Abhinav
    }
}