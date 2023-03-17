public with sharing class ACETViewMemberListingWebservice extends ACETWebservice{
    private String g_groupId;
    private String g_inquiryDate;
    private Boolean g_view;
    private String g_status;
    private String g_bundleID;
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('CirrusMemberListing');
    }
    
    //US843696 - Changes start - added by Abhinav Balla
    
    public ACETViewMemberListingWebservice () {
        if(!Test.isRunningTest())
        	super('StargateJWT');  // US2819526 Sunil
    }
    //US843696 - Changes End - added by Abhinav Balla 
    
    public void init(String groupID,String inquiryDate,Boolean view,String status,String bundleID) {
        g_groupId = groupID;
        g_inquiryDate = inquiryDate;
        g_view = view;
        g_status = status;
        g_bundleID = bundleID;
    }
    private void GetRequestBody(String groupID,String inquiryDate,Boolean view,String status,String bundleID)
    {
            /*if(bundleID != 'All') {
                if(status == 'All')
                {
                    RequestBody = '{'
                    +'"inquiryDate":"'+inquiryDate+'",'
                    +'"memGroupID":"'+groupID+'",'
                    +'"subscriberOnly":'+view+','
                    +'"coverageOptionID":"'+bundleID+'"'
                    +'}';
                        
                }
                else
                {
                    RequestBody = '{'
                    +'"inquiryDate":"'+inquiryDate+'",'
                    +'"memGroupID":"'+groupID+'",'
                    +'"subscriberOnly":'+view+','
                    +'"memberStatus":"'+status+'",'
                    +'"coverageOptionID":"'+bundleID+'"'
                    +'}';
                } 
            }
            else {
                if(status == 'All')
                {
                    RequestBody = '{'
                    +'"inquiryDate":"'+inquiryDate+'",'
                    +'"memGroupID":"'+groupID+'",'
                    +'"subscriberOnly":'+view
                    +'}';
                }
                else
                {
                    RequestBody = '{'
                    +'"inquiryDate":"'+inquiryDate+'",'
                    +'"memGroupID":"'+groupID+'",'
                    +'"subscriberOnly":'+view+','
                    +'"memberStatus":"'+status+'"'
                    +'}';
                }
            }*/
            
            if(bundleID != 'All') {
                    RequestBody = '{'
                    +'"inquiryDate":"'+inquiryDate+'",'
                    +'"memGroupID":"'+groupID+'",'
                    +'"subscriberOnly":'+view+','
                    +'"memberStatus":"'+status+'",'
                    +'"coverageOptionID":"'+bundleID+'"'
                    +'}';
                 
            }
            else {
                RequestBody = '{'
                    +'"inquiryDate":"'+inquiryDate+'",'
                    +'"memGroupID":"'+groupID+'",'
                    +'"subscriberOnly":'+view+','
                    +'"memberStatus":"'+status+'"'
                    +'}';
                
            }
       
    }
   
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {                    
        //Relation Type Mapping from the response
        Map<String,String> relationTypeMap = new Map<String,String>();
        relationTypeMap.put('01','Spouse');
        relationTypeMap.put('07','Nephew or Niece');
        relationTypeMap.put('08','Cousin');
        relationTypeMap.put('09','Adopted Child');
        relationTypeMap.put('10','Foster Child');
        relationTypeMap.put('15','Ward');
        relationTypeMap.put('17','Stepson or Stepdaughter');
        relationTypeMap.put('18','Self');
        relationTypeMap.put('19','Child');
        relationTypeMap.put('23','Sponsored Dependent');
        relationTypeMap.put('24','Dependent of a Minor Dependent');
        relationTypeMap.put('26','Guardian');
        relationTypeMap.put('31','Court Appointed Guardian');
        relationTypeMap.put('38','Collateral Dependent');
        relationTypeMap.put('53','Life Partner');
        relationTypeMap.put('NB','Newborn');

        //Adapter Callout Webservice Code Starts from here
        Integer pageNo;
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETViewMemberListingResultsWrapper> memberListingSearchResults = new List<ACETViewMemberListingResultsWrapper>();
        ACETViewMemberListingJSON2Apex.responseData responseData = new ACETViewMemberListingJSON2Apex.responseData();
        List<ACETViewMemberListingJSON2Apex.MemberList> memberListingResponseData = new List<ACETViewMemberListingJSON2Apex.MemberList>();
        try
        {
            pageNo = pageNumber-1;
            ServiceName = 'GetMembersList';
            GetEndpoint();
            relativeURL = relativeURL +'?size='+pageSize+'&page='+pageNo;
            
            GetRequestBody(g_groupID, g_inquiryDate, g_view, g_status, g_bundleID);
            System.debug('@@@request************'+RequestBody);
            
            HttpResponse Response = Send(OAuthConfig);
            //Response.setStatusCode(404);
            searchResult.statusCode=response!=null?response.getStatusCode():null;
            String responseBody = response.getBody();
            System.debug('Response************'+responseBody);
            if (Response.getStatusCode() == 200) {
                if(responseBody != null) {
                    ACETViewMemberListingJSON2Apex ACETMemberListJSON2Apex = ACETViewMemberListingJSON2Apex.parse(responseBody);
                    responseData = ACETMemberListJSON2Apex.responseData;
                    if(responseData != null && responseData.MemberList != null) {
                        memberListingResponseData = ACETMemberListJSON2Apex.responseData.MemberList;
                        if(memberListingResponseData != null) {
                            searchResult.Success = true;
                            searchResult.Message = ''; 
                            for(ACETViewMemberListingJSON2Apex.MemberList memListresp:memberListingResponseData) {
                                //Demographics Section
                                ACETViewMemberListingResultsWrapper memberListing = new ACETViewMemberListingResultsWrapper();
                                
                                memberListing.firstName = (memListresp.Demographics != null && memListresp.Demographics.nameFirst != null)?memListresp.Demographics.nameFirst:''; // First Name
                                memberListing.lastName = (memListresp.Demographics != null && memListresp.Demographics.nameLast != null)?memListresp.Demographics.nameLast:''; // Last Name
                                String bday = (memListresp.Demographics != null && memListresp.Demographics.birthDate != null)?memListresp.Demographics.birthDate:'';
                                if(bday != ''){
                                    Integer birthdateYear = Integer.valueof(bday.split('-')[0]);
                                    Integer birthdateMonth = Integer.valueof(bday.split('-')[1]);
                                    Integer birthdateDay = Integer.valueof(bday.split('-')[2]);
                                    Integer currentYear = Date.Today().year();
                                    Integer currentMonth = Date.Today().month();
                                    Integer currentDay = Date.Today().day();
                                    if(currentMonth < birthdateMonth){
                                        memberListing.age = String.valueOf(currentYear - birthdateYear - 1);
                                    } else if(currentMonth > birthdateMonth){
                                        memberListing.age = String.valueOf(currentYear - birthdateYear);
                                    } else if(currentMonth == birthdateMonth){
                                        if(currentDay < birthdateDay){
                                            memberListing.age = String.valueOf(currentYear - birthdateYear - 1);
                                        } else if(currentDay >= birthdateDay){
                                            memberListing.age = String.valueOf(currentYear - birthdateYear);
                                        }
                                    }
                                }
                                
                                memberListing.memberID = (memListresp.Demographics != null && memListresp.Demographics.memberID != null)?memListresp.Demographics.memberID:''; // Member ID
                                memberListing.memberDOB = (memListresp.Demographics != null && memListresp.Demographics.birthDate != null)?String.valueof(AcetUtility.format(Date.valueOf(memListresp.Demographics.birthDate))):''; // Member DOB
                                if(memberListing.memberDOB != ''){
                                     List<String> dateParts = memberListing.memberDOB.split('/');
                                    if(dateParts!=null && dateParts.size() == 3){
                                        String mm = (dateParts[0].length() == 1)?('0'+dateParts[0]):dateParts[0];
                                        String dd = (dateParts[1].length() == 1)?('0'+dateParts[1]):dateParts[1];
                                        String yyyy = dateParts[2];
                                        
                                        memberListing.memberDOB = mm +'/' +dd+'/'+yyyy;
                                    } 
                                }
                                //Member Affiliation Section
                                if(memListresp.MemberAffiliation!= null && memListresp.MemberAffiliation.relationshipCode != null) {
                                    memberListing.relationShip = relationTypeMap.get(memListresp.MemberAffiliation.relationshipCode); // Relation Type
                                }
                                else {
                                    memberListing.relationShip = '';
                                }
                                memberListing.contractType = (memListresp.MemberCoverageList!= null && memListresp.memberCoverageList[0].covLevelList != null&& memListresp.memberCoverageList[0].covLevelList[0] != null && memListresp.memberCoverageList[0].covLevelList[0].covLevelDesc!= null)?memListresp.memberCoverageList[0].covLevelList[0].covLevelDesc:'';
                                
                                if(memListresp.MemberAffiliation != null) {
                                    memberListing.billingGroup = (memListresp.MemberAffiliation.billGroupReferenceID != null)?memListresp.MemberAffiliation.billGroupReferenceID:''; // Billing Group // updated from billingPrefID to billGroupReferenceID - US2609420 - sunil vennam
                                    memberListing.billingGroupDesc = (memListresp.MemberAffiliation.billGroupDescription  != null)?memListresp.MemberAffiliation.billGroupDescription :''; // Billing Group //updated from billingPreferenceDescription to billGroupDescription - US2607851 - suni vennam
                                    memberListing.population = (memListresp.MemberAffiliation.populationName != null)?memListresp.MemberAffiliation.populationName.replace(',',''):''; //Population
                                    memberListing.effectiveDate = (memListresp.MemberAffiliation.earliestEffDate!= null)?string.valueOf(AcetUtility.format(Date.valueOf(memListresp.MemberAffiliation.earliestEffDate))):''; //Original Effective Date
                                }
                                else {
                                    memberListing.billingGroup = '';
                                    memberListing.billingGroupDesc = '';
                                    memberListing.population = '';
                                    memberListing.effectiveDate ='';
                                }
                                //Member Coverage List Section - consider only first element from the list
                                
                                memberListing.terminationDate = (memListresp.MemberCoverageList!= null && memListresp.MemberCoverageList[0]!= null && memListresp.MemberCoverageList[0].benPlanExpDate != null)?string.valueOf(AcetUtility.format(Date.valueOf(memListresp.MemberCoverageList[0].benPlanExpDate))):''; //Termination Date
                                memberListing.bundleId = (memListresp.MemberCoverageList!= null && memListresp.MemberCoverageList[0]!= null && memListresp.MemberCoverageList[0].coverageOptionID != null)?memListresp.MemberCoverageList[0].coverageOptionID:''; //Bundle ID
                                memberListing.bundleDescription = (memListresp.MemberCoverageList!= null && memListresp.MemberCoverageList[0]!= null && memListresp.MemberCoverageList[0].coverageOptionDescription != null)?memListresp.MemberCoverageList[0].coverageOptionDescription:''; //Bundle description // US2607851- Sunil Vennam
                                memberListing.Status = (memListresp.MemberCoverageList!= null && memListresp.MemberCoverageList[0]!= null && memListresp.MemberCoverageList[0].memberStatus != null)?memListresp.MemberCoverageList[0].memberStatus:''; //Bundle ID
                              
                                memberListing.continuationType = (memListresp.MemberCoverageList!= null && memListresp.MemberCoverageList[0]!= null && memListresp.MemberCoverageList[0].benefitStatusCode != null)?((memListresp.MemberCoverageList[0].benefitStatusCode != null && memListresp.MemberCoverageList[0].benefitStatusCode == 'C')?'Y':'N'):''; 
                                Map<String,List<String>> termlist =new Map<String,List<String>>();
                                Map<String,List<String>> futlist =new Map<String,List<String>>();
                                List<ACETViewMemberListingJSON2Apex.CovLevelList> lstcov =new List<ACETViewMemberListingJSON2Apex.CovLevelList>();
                                if(memListresp.MemberCoverageList!= null && memListresp.MemberCoverageList[0]!= null && memListresp.MemberCoverageList[0].covLevelList!= null && memListresp.MemberCoverageList[0].covLevelList.size()>0){
                                  lstcov = memListresp.memberCoverageList[0].covLevelList;
                                }
                                if(!String.IsEmpty(memberListing.memberID) && lstcov.size()>1){
                                system.debug('----------size1---entry---');
                                for(ACETViewMemberListingJSON2Apex.CovLevelList  covlst: lstcov){                                   
                                      if(memberListing.Status=='TERM'){
                                        String strdays = String.valueOf(Date.valueOf(g_inquiryDate).daysBetween(Date.valueOf(covlst.covLevelExpDate)));
                                        integer nodays = Integer.valueOf(strdays.remove('-'));
                                         if(!termlist.containsKey(memberListing.memberID)){
                                                termlist.put(memberListing.memberID,new List<String>{nodays+'-'+covlst.covLevelDesc});
                                                }
                                             else{
                                                termlist.get(memberListing.memberID).add(nodays+'-'+covlst.covLevelDesc);
                                                }
                                           }
                                        if(memberListing.Status=='FUTURE'||memberListing.Status=='PEND'){  
                                        
                                        String futstrdays = String.valueOf(Date.valueOf(g_inquiryDate).daysBetween(Date.valueOf(covlst.covLevelEffDate))); 
                                         system.debug('----futstrdays ----'+futstrdays);
                                         integer futnodays = Integer.valueOf(futstrdays.remove('-'));
                                           if(!futlist.containsKey(memberListing.memberID)){
                                                futlist.put(memberListing.memberID,new List<String>{futnodays+'-'+covlst.covLevelDesc});
                                                }
                                             else{
                                                futlist.get(memberListing.memberID).add(futnodays +'-'+covlst.covLevelDesc);
                                                }
                                           } 
                                          
                                        } 
                                    }
                                   
                                system.debug('-------termlist-------'+termlist);
                               for(ACETViewMemberListingJSON2Apex.CovLevelList  covlst: lstcov){
                                  system.debug('--------covlst.covLevelEffDate---------'+covlst.covLevelEffDate);
                                  system.debug('--------covlst.covLevelEffDate---------'+covlst.covLevelExpDate);
                                  system.debug('--------g_inquiryDate---------'+g_inquiryDate);
                                  system.debug('--------covlst.covLevelDesc---------'+covlst.covLevelDesc);
                                  if(memberListing.Status=='ACTIVE' && Date.valueOf(covlst.covLevelEffDate)<=Date.valueOf(g_inquiryDate)&&Date.valueOf(g_inquiryDate)<=Date.valueOf(covlst.covLevelExpDate)){
                                    memberListing.contractType = (covlst.covLevelDesc!= Null && covlst.covLevelDesc!='')?covlst.covLevelDesc:'';  
                                    system.debug('-----ACTIVE-------');
                                    break;                                  
                                  }
                                  else if((memberListing.Status=='FUTURE'|| memberListing.Status=='PEND') && Date.valueOf(g_inquiryDate)<=Date.valueOf(covlst.covLevelEffDate)){
                                      if(lstcov.size()>1){
                                            Map<String,String> futnoofdays =new Map<String,String>();
                                            List<String> futlst= futlist.get(memberListing.memberID);
                                            List<Integer> futnodays =new List<Integer>();
                                            if(futlst!=Null && futlst.size()>0){
                                              for(String s:futlst){
                                               List<String> futstr= s.split('-');
                                                futnoofdays.put(futstr[0],futstr[1]);
                                                futnodays.add(Integer.valueOf(futstr[0]));
                                               }
                                            }
                                            system.debug('------futnoofdaysMap------'+futnoofdays);                                   
                                            futnodays.sort();
                                            system.debug('-------futnodays------'+futnodays);
                                            String futnrstdate =String.valueOf(futnodays.get(0));
                                            system.debug('-------futnrstdate ------'+futnrstdate);
                                            memberListing.contractType = futnoofdays.get(futnrstdate);   
                                          system.debug('-----FUTURE-------');
                                          break;
                                      }else{
                                          memberListing.contractType = (covlst.covLevelDesc!= Null && covlst.covLevelDesc!='')?covlst.covLevelDesc:'';  
                                          system.debug('-----FUTURE-------');
                                          break;
                                        }
                                  }else if(memberListing.Status=='TERM' && Date.valueOf(g_inquiryDate)>=Date.valueOf(covlst.covLevelExpDate)){
                                  if(lstcov.size()>1){                                  
                                    Map<String,String> noofdaysMap =new Map<String,String>();
                                    List<String> strlst= termlist.get(memberListing.memberID);
                                    List<Integer> nodayslst =new List<Integer>();
                                    if(strlst!=Null && strlst.size()>0){
                                      for(String s:strlst){
                                       List<String> lststr= s.split('-');
                                        noofdaysMap.put(lststr[0],lststr[1]);
                                        nodayslst.add(Integer.valueOf(lststr[0]));
                                       }
                                    }
                                    system.debug('-------noofdaysMap------'+noofdaysMap);                                   
                                    nodayslst.sort();
                                    system.debug('-------nodayslst------'+nodayslst);
                                    String nrstdate =String.valueOf(nodayslst.get(0));
                                    system.debug('-------nearestdate------'+nrstdate);
                                  memberListing.contractType = noofdaysMap.get(nrstdate);   
                                  system.debug('-----TERM-------');
                                  break;
                                  }else{
                                     memberListing.contractType = (covlst.covLevelDesc!= Null && covlst.covLevelDesc!='')?covlst.covLevelDesc:'';  
                                          system.debug('-----TERM-------');
                                          break;
                                  }
                                }else{
                                  if((Date.valueOf(covlst.covLevelEffDate)<=Date.valueOf(g_inquiryDate)&&Date.valueOf(g_inquiryDate)<=Date.valueOf(covlst.covLevelExpDate))){
                                      memberListing.contractType = (covlst.covLevelDesc!= Null && covlst.covLevelDesc!='')?covlst.covLevelDesc:'';  
                                      system.debug('-----PEND-------');
                                      break;
                                  }
                                }
                               } 
                                System.debug('searchresultshere ' + memberListing);
                                memberListingSearchResults.add(memberListing);
                            }
                            searchResult.Response = memberListingSearchResults;
                            searchResult.pageNumber =  String.valueOf(ACETMemberListJSON2Apex.ResponseData.pageNumber+1); 
                            searchResult.pageSize = String.valueOf(pageSize);
                            searchResult.totalPages = String.valueOf(ACETMemberListJSON2Apex.ResponseData.pageNumber+1);
                            searchresult.hasNextPage = ACETMemberListJSON2Apex.ResponseData.hasNextPage;
                            if(ACETMemberListJSON2Apex.ResponseData.hasNextPage == true) {
                               System.debug('JSON:::::::::::::::::::::::');
                               searchResult.recordCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber+1)*pageSize+1);
                               searchResult.totalCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber+1)*pageSize+1);
                               
                            }
                            else { 
                               searchResult.recordCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber)*pageSize + ACETMemberListJSON2Apex.ResponseData.size);
                               searchResult.totalCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber)*pageSize + ACETMemberListJSON2Apex.ResponseData.size);
                               
                            }
                            System.debug('JSON:::::::::::::::::::::::1'+searchResult+pageSize+startRecord);
                        }
                        else {
                            searchResult.MessageSeverity = ApexPages.Severity.INFO;
                            searchResult.Success = true;
                            searchResult.Message = 'No Record found for this Search Criteria';                
                            searchResult.Response = new List<ACETViewMemberListingResultsWrapper>();
                            searchresult.hasNextPage = false;
                        }
                    }
                    else {
                        searchResult.Success = true;
                        searchResult.Message = 'Service Failure. Please try again later';
                        searchResult.Response =   new List<ACETViewMemberListingResultsWrapper>();
                        searchresult.hasNextPage = false;
                    }
                }   
            }
            else{

                //currently servce returns 500 if no records found
                searchResult.MessageSeverity = ApexPages.Severity.INFO;               
                searchResult.Response = new List<ACETViewMemberListingResultsWrapper>();
                searchresult.hasNextPage = false;
                searchResult.statusCode=response!=null?response.getStatusCode():null;
                if(response.getStatusCode()==404){
                 searchResult.Success = true; 
                }else{
                 searchResult.Success = false; 
                }
            }

        }
        catch(Exception ex){
            searchResult.Success = false;
            searchResult.Message = ex.getMessage();
            searchResult.MessageSeverity = ApexPages.Severity.ERROR;
            searchResult.statusCode=999;
        }  
        return searchResult;
    }
}