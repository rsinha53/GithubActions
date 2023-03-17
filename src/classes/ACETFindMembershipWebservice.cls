public with sharing class ACETFindMembershipWebservice extends ACETWebService{ 
    public ACETFindMembershipWebservice() {
	
         if(!Test.isRunningTest()){
        super('Stargate');
        }
    }
    public override void getEndpoint(){
        GetEndpointDetail('FindMembershipEndpoint');
    }
    
    public void getRequestBody(String identifier){
        RequestBody = '{"findMembershipsRequest":{"identifier":"'+identifier+'","identifierType":"SRK","groupNumber":"","coverageType":"","effectiveStartDate":"1800-01-01","effectiveEndDate":"9999-12-31","systemSpecificIndicator":"","pagination":{"pageNumber":1,"pageSize":50,"startRecord":""}}}';               
    } 

    public ACETWSCalloutResult findMembership(String memberId, ACETMemberDetail memberDetail){ 
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }   
       
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            HttpResponse  response;
 
            getEndpoint();
            getRequestBody(MemberDetail.SurrogateKey);
            
            if(memberDetail.coverageTypeSet==null) memberDetail.coverageTypeSet=new Set<String>();
            if(memberDetail.groupNumberSet==null) memberDetail.groupNumberSet=new Set<String>();
            if(memberDetail.groupNameSet==null) memberDetail.groupNameSet=new Set<String>();
            if(memberDetail.sourceCodeSet==null) memberDetail.sourceCodeSet=new Set<String>();
            
            response = Send(OAuthConfig);
            if(response!=null){
            calloutResult.statusCode=response.getStatusCode();
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                
                    String responseBody;
                        responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = response.getBody().contains('\"desc\":')?responseBody.replace('\"desc\":', '\"desc_Z\":'):response.getBody();
                        
                        //replace date with date2 as date is a preserved keyword
                        responseBody = response.getBody().contains('\"type\":')?responseBody.replace('\"type\":', '\"type_Z\":'):response.getBody();
                        responseBody = response.getBody().contains('\"id\":')?responseBody.replace('\"id\":', '\"idstr\":'):response.getBody();
                        system.debug('responseBody: ' + responseBody);
                                                                
                        ACETFindMembershipAdaptorJSON2Apex jSON2Apex = ACETFindMembershipAdaptorJSON2Apex.parse(responseBody);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        
                        memberDetail.CoverageLines = new List<ACETMemberDetail.CoverageLine>();   
                        List<ACETFindMembershipAdaptorJSON2Apex.cls_memberships> memberships = null;  
                        if(jSON2Apex != null && jSON2Apex.findMembershipsResponse != null && jSON2Apex.findMembershipsResponse.memberships != null)               
                            memberships = jSON2Apex.findMembershipsResponse.memberships;
                        system.debug('memberships --- : ' + memberships);
                       if(memberships!=null){

                       
                        boolean isAdvanceSearched=false;
                        
                        
                        for(ACETFindMembershipAdaptorJSON2Apex.cls_memberships membership : memberships){
                        system.debug('membership each memeber ship enrolleeSystemSpecificIdentifiers  '+membership.enrolleeSystemSpecificIdentifiers );
                            system.debug('membership.coverages ---- : ' + membership.coverages);
                            if(membership != null && membership.coverages != null){
                                for(ACETFindMembershipAdaptorJSON2Apex.cls_coverages c : membership.coverages){
                                     
                                    memberDetail.CoverageTypeSet.add(c.coverageTypeDescription);
                                    memberDetail.groupNumberSet.add(c.GroupNumber);
                                    memberDetail.groupNameSet.add(c.GroupName);
                                    memberDetail.sourceCodeSet.add(membership.sourceSysCode);
                                    
                                    boolean isFiltered=True;
                                    
                                    if(memberDetail.CoverageTypeValue!=null && memberDetail.CoverageTypeValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!c.coverageTypeDescription.equalsIgnoreCase(memberDetail.CoverageTypeValue)){
                                         isFiltered=false;
                                           
                                        }
                                    } 
                                    System.debug('memberDetail.groupNameValue='+memberDetail.groupNameValue);
                                    System.debug('memberDetail.groupNameValue='+c.groupName);
                                    if(isFiltered && memberDetail.groupNameValue!=null && memberDetail.groupNameValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!c.groupName.equalsIgnoreCase(memberDetail.groupNameValue)){
                                         isFiltered=false;
                                           
                                        }
                                    }
                                    if(isFiltered && memberDetail.groupNumberValue!=null && memberDetail.groupNumberValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!c.groupNumber.equalsIgnoreCase(memberDetail.groupNumberValue)){
                                         isFiltered=false;
                                           
                                        }
                                    }
                                    if(isFiltered && memberDetail.sourceCodeValue!=null && memberDetail.sourceCodeValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!membership.sourceSysCode.equalsIgnoreCase(memberDetail.sourceCodeValue)){
                                        isFiltered=false;  
                                        }
                                    }
                                    Date effDate=c.membershipEffectiveDate!=null && c.membershipEffectiveDate != '9999-12-31'?(Date)date.parse(formatDate(c.membershipEffectiveDate)):null;
                                    Date expDate=c.membershipExpirationDate != null && c.membershipExpirationDate != '9999-12-31'?(Date)date.parse(formatDate(c.membershipExpirationDate)):null;
                                    system.debug('----effDate---->'+ effDate);
                                    system.debug('----expDate---->'+ expDate);
                                    system.debug('----isAdvanceSearched ---->'+ isAdvanceSearched );        
                                    if(isAdvanceSearched == False && memberDetail.effectiveDateValue == null && memberDetail.endDateValue ==  null){
                                       //MemberDetail.effectiveDateValue=Date.today().addYears(-3);
                                        Date lastThreeYrDate=Date.today().addYears(-3);
                                        Date NextOneYrDate = Date.today().addYears(1);
                                        if(effDate!=null && expDate!=null && expDate >= lastThreeYrDate && effDate <= NextOneYrDate ){
                                            system.debug('----1---->');        
                                        }
                                        else if(c.membershipExpirationDate == '9999-12-31' && effDate < NextOneYrDate ){
                                            system.debug('----2---->');
                                        }else{
                                            isFiltered=false;
                                        }                                        
                                    }
                                    else if(c.membershipExpirationDate != '9999-12-31'){
                                        isAdvanceSearched=true;                                        
                                        system.debug('----isFiltered---->'+isFiltered +'-----memberDetail.effectiveDateValue--->'+memberDetail.effectiveDateValue+'-----memberDetail.endDateValue---->'+memberDetail.endDateValue +'-----effDate----'+effDate +'----expDate----'+expDate );
                                        system.debug('----effectiveDateValue---->'+(effDate < memberDetail.effectiveDateValue)+'-----endDateValue--->'+(expDate > memberDetail.endDateValue));
                                        if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null){
                                            If(effDate < memberDetail.effectiveDateValue){
                                                system.debug('----11---->');
                                                isFiltered=false;
                                            }
                                            if(isFiltered && expDate > memberDetail.endDateValue){
                                                system.debug('----1-1---->');
                                                isFiltered=false;
                                            }                                      
                                        }else if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue ==  null && isFiltered && effDate!=null && effDate < memberDetail.effectiveDateValue){
                                            system.debug('----12---->');
                                            isFiltered=false;
                                        }else if(memberDetail.effectiveDateValue == null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null && expDate > memberDetail.endDateValue){
                                            system.debug('----13---->');
                                            isFiltered=false;
                                        }
                                        
                                    }else if(c.membershipExpirationDate == '9999-12-31'){
                                        isAdvanceSearched=true;
                                        expDate=c.membershipExpirationDate != null ? (Date)date.parse(formatDate('3999-12-31')): null;
                                        if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null){
                                            If(effDate < memberDetail.effectiveDateValue){
                                                system.debug('----11---->');
                                                isFiltered=false;
                                            }
                                            if(isFiltered && expDate > memberDetail.endDateValue){
                                                system.debug('----1-1---->');
                                                isFiltered=false;
                                            }                                      
                                        }else if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue ==  null && isFiltered && effDate!=null && effDate < memberDetail.effectiveDateValue){
                                            system.debug('----12---->');
                                            isFiltered=false;
                                        }else if(memberDetail.effectiveDateValue == null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null && expDate > memberDetail.endDateValue){
                                            system.debug('----13---->');
                                            isFiltered=false;
                                        }
                                    }
                                    System.debug('isFiltered='+isFiltered);                                   
                                    if(isAdvanceSearched)
                                        memberDetail.isAdvanceSearched=true;
                                    
                                   if(isFiltered){
                                    ACETMemberDetail.CoverageLine cl = new ACETMemberDetail.CoverageLine();
                                    /*if(isAdvanceSearched)
                                        cl.isAdvanceSearched=true;*/
                                    cl.CoverageType = String.isNotBlank(c.coverageTypeDescription)?c.coverageTypeDescription:'';
                                    cl.CoverageTypeCode = String.isNotBlank(c.coverageType)?c.coverageType:'';
                                    cl.CoverageLevel = String.isNotBlank(c.coverageLevelCode)?c.coverageLevelCode:'';
                                    cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                    system.debug('Effective -- >'+cl.EffectiveDate);
                                    cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                    cl.PolicyNumber = (c.legacyAttributes != null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                    cl.GroupName = String.isNotBlank(c.GroupName)?c.GroupName:'';
                                    cl.GroupNumber = String.isNotBlank(c.groupNumber)?c.groupNumber:'';
                                    if(c.product != null ){
                                        cl.Product = c.product.productName;
                                        cl.ProductType = c.product.productType;
                                    }
                                    cl.SourceCode = membership.sourceSysCode;
                                    if(c.subscriberSystemSpecificIdentifiers!=null && !c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                        for(ACETFindMembershipAdaptorJSON2Apex.cls_subscriberSystemSpecificIdentifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                            if(sssi.type_z == 'subscriberSurrogateKey'){
                                                cl.SurrogateKey = sssi.idstr;
                                                 system.debug('2323checking SRK list findmembership' + cl.SurrogateKey);  
                                            }
                                            
                                        }
                                    }
                                       
								list<string> customerPurchaseIdlist = new list<string>(); //US2962032: extracting customerPurchaseIds for get cpcallout  
                                           for(ACETFindMembershipAdaptorJSON2Apex.customerPurchase custpur : c.benefit.customerPurchase){
                                               customerPurchaseIdlist.add(custpur.customerPurchaseId);
                                     }
                                     cl.customerPurchaseIdsliststring = String.join((Iterable<String>)customerPurchaseIdlist, ',');  
                                    memberDetail.CoverageLines.add(cl); 
                                    }   
                                 }
                                }                                                                                                                                  
                         }
                        }
                         if(memberDetail.CoverageLines.size() > 0){
                            memberDetail.PreferredCoverage = memberDetail.CoverageLines[0];     
                         }
                         system.debug('memberDetail.PreferredCoverage '+memberDetail.PreferredCoverage);
                         if(memberDetail.PreferredCoverage!=null){
                 memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                             memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                             memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                             memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                             memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                             memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
              }
                         //memberDetail.Network = 
                                            
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = memberDetail;
                        
                    
                }
            }
             else if(response.getStatusCode() == 500){                
                //currently servce returns 500 if no records found
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = true;                
                calloutResult.Response = new ACETMemberDetail();
                system.debug(calloutResult);                
             }  
            } 
            else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;//Web Service or External System is temporarily unavailable.
            }
            }catch(Exception e){
                system.debug(e);
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;//Web Service or External System is temporarily unavailable.
           }
        
        return calloutResult;    
    } 
    
    //to remove to global util class
    public String formatDate(String dateString){
     try{  
        if(String.isBlank(dateString)) return null;
        List<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
     }catch(Exception e){
          System.debug('Exception Happened='+e); 
          return null;
      }
    }
    
    public String getAgeFromBirthday(String birthDate){
      try{
        if(String.isBlank(birthDate)) return null;
        Date d = Date.valueOf(birthDate);
        return String.valueOf(d.daysBetween(Date.today())/365);
      }catch(Exception e){
          System.debug('Exception Happened='+e); 
          return null;
      }
    }
    
    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';
        
        return 'xxx-xx-' + ssn.substring(ssn.length() - 4);
    }
    public Continuation StartRequest(String memberId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {   
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }     

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
         getEndpoint();
         getRequestBody(MemberDetail.SurrogateKey);
         oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
         return oContinuation;         
    }
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){
           
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }     
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        //integer i = 1;
        try{
         
            HttpResponse response = GetHttpResponse(HttpRequestLabel);
            //response.setStatusCode(400); 
            if(response!=null){
            
            calloutResult.statusCode=response.getStatusCode();
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    String responseBody;
                        responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = responseBody.replace('\"desc\":', '\"desc_Z\":');
                        
                        //replace date with date2 as date is a preserved keyword
                        responseBody = responseBody.replace('\"type\":', '\"type_Z\":');
                        responseBody = responseBody.replace('\"id\":', '\"idstr\":');
                        system.debug('responseBody: ' + responseBody);
                        Set<String> SRKKeys;                                        
                        ACETFindMembershipAdaptorJSON2Apex jSON2Apex = ACETFindMembershipAdaptorJSON2Apex.parse(responseBody);
                        memberDetail.CoverageLines = new List<ACETMemberDetail.CoverageLine>(); 
                        List<ACETFindMembershipAdaptorJSON2Apex.cls_memberships> memberships = (jSON2Apex!=null  && jSON2Apex.findMembershipsResponse!=null) ? jSON2Apex.findMembershipsResponse.memberships:null;
                        system.debug('memberships --- : ' + memberships);
                        String dateToCompare;
                        Integer coverageCount = 0;
                       if(memberships!=null && memberships.size()>0){
                        memberDetail.coverageTypeSet=new Set<String>();
                        memberDetail.groupNumberSet=new Set<String>();
                        memberDetail.groupNameSet=new Set<String>();
                        memberDetail.sourceCodeSet=new Set<String>();
                        
                        boolean isAdvanceSearched=false;
                        
                        memberDetail.AffiliationIndicator = false;
                        Map<String, Set<String>> affiliationsMap = new Map<String, Set<String>>();
                        String identifierID;
                        for(ACETFindMembershipAdaptorJSON2Apex.cls_memberships membership : memberships){
                        Set<String> benefitIdSet = new Set<String>();
                        identifierID = '';
                        if(membership.enrolleeSystemSpecificIdentifiers!=null && !membership.enrolleeSystemSpecificIdentifiers.isEmpty()){
                            //iteration start
                            for(ACETFindMembershipAdaptorJSON2Apex.cls_enrolleeSystemSpecificIdentifiers eachIdentifier:membership.enrolleeSystemSpecificIdentifiers){
                                    system.debug('eachIdentifier.type_Z '+eachIdentifier.type_Z);
                                    if(eachIdentifier.type_Z =='enrolleeIndividualIdentifier'){
                                   // memberDetail.EID = eachIdentifier.idstr;
                                    break;
                                    }
                            }
                        }
                            //////end of iteration
                         system.debug('membership each memeber   '+membership);

                            boolean isSelf=false;
                            boolean isSubscriber=false;
                            
                            
                            system.debug('membership.coverages ---- : ' + membership.coverages);
                            if(membership != null && membership.coverages != null){
                            
                                for(ACETFindMembershipAdaptorJSON2Apex.cls_coverages c : membership.coverages){
                                    
                                    memberDetail.CoverageTypeSet.add(c.coverageTypeDescription);
                                    memberDetail.groupNumberSet.add(c.GroupNumber);
                                    memberDetail.groupNameSet.add(c.GroupName);
                                    memberDetail.sourceCodeSet.add(membership.sourceSysCode);
                                    
                                    boolean isFiltered=True;
                                    
                                    
                                    if(memberDetail.CoverageTypeValue!=null && memberDetail.CoverageTypeValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!c.coverageTypeDescription.equalsIgnoreCase(memberDetail.CoverageTypeValue)){
                                         isFiltered=false;
                                           
                                        }
                                    } 
                                    if(isFiltered && memberDetail.groupNameValue!=null && memberDetail.groupNameValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!c.GroupName.equalsIgnoreCase(memberDetail.groupNameValue)){
                                         isFiltered=false;
                                           
                                        }
                                    }
                                    System.debug('memberDetail.groupNumberValue='+memberDetail.groupNumberValue);
                                    System.debug('c.GroupNumber='+c.GroupNumber);
                                    if(isFiltered && memberDetail.groupNumberValue!=null && memberDetail.groupNumberValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!c.GroupNumber.equalsIgnoreCase(memberDetail.groupNumberValue)){
                                         isFiltered=false;
                                           
                                        }
                                    }
                                    if(isFiltered && memberDetail.sourceCodeValue!=null && memberDetail.sourceCodeValue!='--All--'){
                                        isAdvanceSearched=true;
                                        if(!membership.sourceSysCode.equalsIgnoreCase(memberDetail.sourceCodeValue)){
                                        isFiltered=false;
                                           
                                        }
                                    }

                                    Date effDate=c.membershipEffectiveDate!=null && c.membershipEffectiveDate != '9999-12-31'?(Date)date.parse(formatDate(c.membershipEffectiveDate)):null;
                                    Date expDate=c.membershipExpirationDate != null && c.membershipExpirationDate != '9999-12-31'?(Date)date.parse(formatDate(c.membershipExpirationDate)):null;
                                    system.debug('----effDate---->'+ effDate);
                                    system.debug('----expDate---->'+ expDate);
                                    system.debug('----isAdvanceSearched ---->'+ isAdvanceSearched );        
                                    if(isAdvanceSearched == False && memberDetail.effectiveDateValue == null && memberDetail.endDateValue ==  null){
                                       //MemberDetail.effectiveDateValue=Date.today().addYears(-3);
                                        Date lastThreeYrDate=Date.today().addYears(-3);
                                        Date NextOneYrDate = Date.today().addYears(1);
                                        if(effDate!=null && expDate!=null && expDate >= lastThreeYrDate && effDate <= NextOneYrDate ){
                                            system.debug('----1---->');        
                                        }
                                        else if(c.membershipExpirationDate == '9999-12-31' && effDate < NextOneYrDate ){
                                            system.debug('----2---->');
                                        }else{
                                            isFiltered=false;
                                        }                                        
                                    }

                                    else if(isAdvanceSearched == True && c.membershipExpirationDate != '9999-12-31'){
                                        isAdvanceSearched=true;                                        
                                        system.debug('----isFiltered---->'+isFiltered +'-----memberDetail.effectiveDateValue--->'+memberDetail.effectiveDateValue+'-----memberDetail.endDateValue---->'+memberDetail.endDateValue +'-----effDate----'+effDate +'----expDate----'+expDate );
                                        system.debug('----effectiveDateValue---->'+(effDate < memberDetail.effectiveDateValue)+'-----endDateValue--->'+(expDate > memberDetail.endDateValue));
                                        if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null){
                                            If(effDate < memberDetail.effectiveDateValue){
                                                system.debug('----11---->');
                                                isFiltered=false;
                                            }
                                            if(isFiltered && expDate > memberDetail.endDateValue){
                                                system.debug('----1-1---->');
                                                isFiltered=false;
                                            }                                      
                                        }else if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue ==  null && isFiltered && effDate!=null && effDate < memberDetail.effectiveDateValue){
                                            system.debug('----12---->');
                                            isFiltered=false;
                                        }else if(memberDetail.effectiveDateValue == null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null && expDate > memberDetail.endDateValue){
                                            system.debug('----13---->');
                                            isFiltered=false;
                                        }
                                        
                                    }else if(c.membershipExpirationDate == '9999-12-31'){
                                    system.debug('in fmv4--->'+c);
                                        isAdvanceSearched=true;
                                        expDate=c.membershipExpirationDate != null ? (Date)date.parse(formatDate('3999-12-31')): null;
                                        if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null){
                                            If(effDate < memberDetail.effectiveDateValue){
                                                system.debug('----11---->');
                                                isFiltered=false;
                                            }
                                            if(isFiltered && expDate > memberDetail.endDateValue){
                                                system.debug('----1-1---->');
                                                isFiltered=false;
                                            }                                      
                                        }else if(memberDetail.effectiveDateValue != null && memberDetail.endDateValue ==  null && isFiltered && effDate!=null && effDate < memberDetail.effectiveDateValue){
                                            system.debug('----12---->');
                                            isFiltered=false;
                                        }else if(memberDetail.effectiveDateValue == null && memberDetail.endDateValue !=  null && isFiltered && effDate!=null && expDate > memberDetail.endDateValue){
                                            system.debug('----13---->');
                                            isFiltered=false;
                                        }
                                    }
                                    System.debug('isFiltered='+isFiltered);
                                     if(isAdvanceSearched)
                                        memberDetail.isAdvanceSearched=true;
                                    System.debug('isAdvanceSearched='+memberDetail.isAdvanceSearched);
                                    
                                    if(isFiltered){
                                    ACETMemberDetail.CoverageLine cl = new ACETMemberDetail.CoverageLine();
                                    //cl.isAdvanceSearched=isAdvanceSearched;
                                  //  SRKKeys = new set<String>();
                                    cl.isSubscriber =false;
                                    cl.CoverageType = c.coverageTypeDescription;
                                    cl.CoverageTypeCode = c.coverageType;
                                    cl.CoverageLevel = c.coverageLevelCode;
                                    cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                    cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                    cl.PolicyNumber = c.legacyAttributes!=null?c.legacyAttributes.policyNumber:'';
                                    cl.GroupName = c.GroupName;
                                    cl.GroupNumber = c.groupNumber;
                                    if(c.product!=null){
                                    cl.Product = c.product.productName;
                                    cl.ProductType = c.product.productType;
                                    cl.bookOfBusinessTypeCode = c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null?c.benefit.bookOfBusinessTypeCode:'';
                                    }
                                    
                                    
                                    cl.relationShipCode=c.relationshipCode;
                                    if(c.relationshipCode=='18'){
                                        isSelf=True;
                                    }
                                    if(ApexPages.currentPage().getParameters().get('scr') != null && !String.IsBLANK(ApexPages.currentPage().getParameters().get('scr')) && ApexPages.currentPage().getParameters().get('scr') != 'undefined')
                                        MemberDetail.SCRId= ApexPages.currentPage().getParameters().get('scr');
                                    else if(ApexPages.currentPage().getParameters().get('memberId') != null && !String.IsBLANK(ApexPages.currentPage().getParameters().get('memberId')) && ApexPages.currentPage().getParameters().get('memberId') != 'undefined')
                                        MemberDetail.SCRId= ApexPages.currentPage().getParameters().get('memberId');
                                    else if(ApexPages.currentPage().getParameters().get('Id') != null && !String.IsBLANK(ApexPages.currentPage().getParameters().get('Id')) && ApexPages.currentPage().getParameters().get('Id') != 'undefined')
                                        MemberDetail.SCRId= ApexPages.currentPage().getParameters().get('Id');
                                    System.debug('SCRId='+memberDetail.SCRId);
                                    System.debug('membership.identifiers='+membership.identifiers);
                                    if(membership.identifiers!=null){
                                            for(ACETFindMembershipAdaptorJSON2Apex.cls_identifiers identifierDtl : membership.identifiers){
                                                if(identifierDtl.type_Z == 'SCR'){
                                                    if(identifierDtl.idstr==memberDetail.SCRId){
                                                        System.debug('Subsciber Member Id='+identifierDtl.idstr);
                                                        cl.isSubscriber=True;
                                                    }   
                                                    cl.subscriberID = (identifierDtl.idstr != null)?identifierDtl.idstr:''; 
                                                    
                                                } else if(identifierDtl.type_Z == 'MCH') {
                                                    identifierID = (identifierDtl.idstr != null)?identifierDtl.idstr:'';
                                                }
                                             
                                            }
                                      }
                                    
                                    
                                    System.debug('-----Today Date------->'+ Acetutility.format(date.today()) + '-------membershipEffectiveDate---->'+ formatDate(c.membershipEffectiveDate));
                                    Date todaydate = (Date) date.today();
                                    Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                    if(EffectiveDate!=null){
                                        if(todaydate <= EffectiveDate)
                                            cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                        else
                                            cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                    }
                                   cl.SourceCode = membership.sourceSysCode;
                                   cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                   
                                   
                                   if(c.benefit != null){
                                       if(c.benefit.benefitPlanId != null && c.benefit.benefitPlanId != '' && c.benefit.benefitPlanId.length() > 2 && c.benefit.benefitPlanId.substring(0,1).isAlpha()) {
                                           cl.benefitPlanId = c.benefit.benefitPlanId;
                                          
                                       }
                                        if(membership.sourceSysCode == 'CR' && c.coverageTypeDescription == 'MEDICAL' && c.benefit.benefitPlanId.substring(0,2) != 'MR') {
                                            String memEffDate = c.membershipEffectiveDate.split('-')[0] + c.membershipEffectiveDate.split('-')[1] + c.membershipEffectiveDate.split('-')[2];
                                            String memExpDate = c.membershipExpirationDate.split('-')[0] + c.membershipExpirationDate.split('-')[1] + c.membershipExpirationDate.split('-')[2];
                                            String curr = string.valueOf(Date.today());
                                            curr = curr.split('-')[0] + curr.split('-')[1] + curr.split('-')[2];
                                            if(memEffDate <= curr && curr <= memExpDate) {
                                                benefitIdSet.add(c.benefit.benefitPlanId);
                                            }
                                        }
                                   }   
                                   cl.isPreferred = False;                                 
                                   system.debug('--------membership.sourceSysCode---->'+membership.sourceSysCode+'-------c.coverageTypeDescription----->'+c.coverageTypeDescription+'----cl.isActive----'+cl.isActive +'--------cl.benefitPlanId------->'+ cl.benefitPlanId);
                                   string coverageBenefitPlanId;
                                   if(cl.benefitPlanId != null && cl.benefitPlanId != '' && cl.benefitPlanId.substring(0,1).isAlpha())
                                       coverageBenefitPlanId = cl.benefitPlanId.toLowerCase().subString(0,2);
                                   
                                   system.debug('$$$coverage Line'+cl);
                                   system.debug('$$$parameters'+memberDetail.EligibilityCoverage);
                                   system.debug('$$$--->'+cl.isSubscriber +'$$$---->>'+ membership.sourceSysCode.equalsIgnoreCase('CR')+'$$--->'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'$$--->'+ coverageBenefitPlanId +'---->'+memberDetail.isMemberEligibility);
                                   if(cl.isSubscriber && membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr') && memberDetail.isMemberEligibility != true){ 
                                    system.debug('--------cl.GroupNumber---->'+cl.GroupNumber+'------------>'+membership.coverages);
                                        Date effDte=  c.membershipEffectiveDate != null && c.membershipEffectiveDate != '9999-12-31'? Date.parse(ACETUtility.formatDateFromDashToSlash(c.membershipEffectiveDate)) : null;
                                        if(cl.isActive){
                                            cl.isPreferred= isPreferredCoverage(membership.sourceSysCode, c.coverageTypeDescription, cl.isActive, c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                            if( dateToCompare == null || cl.isPreferred){
                                                dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                            }
                                            coverageCount += 1;
                                        }else{
                                            cl.isPreferred = true;
                                            coverageCount += 1;
                                        }
                                   }
                                   else if (memberDetail.isMemberEligibility == true
                                        && memberDetail.EligibilityCoverage!=null
                                        && memberDetail.EligibilityCoverage.CoverageType == cl.coverageType
                                        && memberDetail.EligibilityCoverage.GroupNumber == cl.groupNumber
                                        && memberDetail.EligibilityCoverage.BenefitPlanId == cl.benefitPlanId
                                        && memberDetail.EligibilityCoverage.EffectiveDate == cl.effectiveDate
                                        && memberdetail.EligibilityCoverage.EndDate == cl.endDate )
                                   {
                                        system.debug('$$$isPreferred');
                                        cl.isPreferred=true;
                                   }
                                   system.debug('=========coverageCount =======>>'+ coverageCount );
                                   if(c.subscriberSystemSpecificIdentifiers != null){
                                    
                                    if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                        for(ACETFindMembershipAdaptorJSON2Apex.cls_subscriberSystemSpecificIdentifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                            if(sssi.type_z == 'subscriberSurrogateKey'){
                                                cl.SurrogateKey = sssi.idstr; 
                                                
                                                // SRKKeys.add(cl.SurrogateKey);
                                                // memberDetail.SurrogateKeys.add(cl.SurrogateKey);  
                                            }
                                            
                                        }
                                    }
                                    }
                                 if(membership.enrolleeSystemSpecificIdentifiers!=null && !membership.enrolleeSystemSpecificIdentifiers.isEmpty() ){

                                     for(ACETFindMembershipAdaptorJSON2Apex.cls_enrolleeSystemSpecificIdentifiers enrolidentifiers : membership.enrolleeSystemSpecificIdentifiers){
                                        if(enrolidentifiers.type_Z == 'enrolleeSurrogateKey'){
                                            system.debug('!!!@@@ En surrogate key'+enrolidentifiers.idstr+'srk'+memberDetail.SurrogateKey);
                                            if(!String.isEmpty(enrolidentifiers.idstr))
                                                memberDetail.SurrogateKeys.add(enrolidentifiers.idstr);
                                            memberDetail.SurrogateKey = String.isEmpty(enrolidentifiers.idstr) ? memberDetail.SurrogateKey : enrolidentifiers.idstr;
                                            cl.EnrolleeSurrogateKey = enrolidentifiers.idstr;
                                           
                                              system.debug('!!!@@@ memberDetail.SurrogateKeys'+memberDetail.SurrogateKeys);
                                            
                                        }   
                                     
                                    }
                                 }
                                        list<string> customerPurchaseIdlist = new list<string>(); //US2962032: extracting customerPurchaseIds for get cpcallout  
                                           for(ACETFindMembershipAdaptorJSON2Apex.customerPurchase custpur : c.benefit.customerPurchase){
                                               customerPurchaseIdlist.add(custpur.customerPurchaseId);
                                     }
                                     cl.customerPurchaseIdsliststring = String.join((Iterable<String>)customerPurchaseIdlist, ',');  
                                    cl.coverageMemberId = identifierID;
                                    memberDetail.CoverageLines.add(cl);
                                    
                                    system.debug('memberDetail.CoverageLines after findmembership :: '+memberDetail.CoverageLines);
                                         if(cl.isPreferred){
                                            memberDetail.PreferredCoverage = cl;
                                            memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                                             memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                                             memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                                             memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                                             memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                                             memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                                        }
                                     }  
                                    }
                                  }
                                  if(identifierID != '' && benefitIdSet.isEmpty() != true) {
                                      affiliationsMap.put(identifierID, benefitIdSet);
                                  }
                                /* If nothing preffered choosing the first one -Chandan
                                    else if(memberDetail.CoverageLines.size()>0){
                                            ACETMemberDetail.CoverageLine c = memberDetail.CoverageLines[0];
                                            c.isPreferred=true;
                                            if(c.isPreferred){
                                                 memberDetail.PreferredCoverage = c;
                                                 memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                                                 memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                                                 memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                                                 memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                                                 memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                                                 memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                                            }
                                            
                                    }
                                //End of the Logic*/
                                    //Code End By Chandan -US1365690
                                } 
                                if(affiliationsMap.size() > 1) {
                                    memberDetail.AffiliationIndicator = true;
                                } else if(affiliationsMap.size() == 1) {
                                    List<Set<String>> benefitSetList = affiliationsMap.values();
                                    Set<String> benefitSet = benefitSetList[0];
                                    if(benefitSet.size() > 1) {
                                        memberDetail.AffiliationIndicator = true;
                                    }
                                }
                                if(CoverageCount == 1){
                                        for(ACETMemberDetail.CoverageLine c : memberDetail.CoverageLines){ 
                                            string cvrgBenefitPlnid;
                                            if(c.benefitPlanId != null && c.benefitPlanId != '' && c.benefitPlanId.length() > 2 && c.benefitPlanId.toLowerCase().subString(0,1).isAlpha())                                       
                                                cvrgBenefitPlnid = c.benefitPlanId.toLowerCase().subString(0,2);
                                            if(c.isSubscriber && c.SourceCode.equalsIgnoreCase('CR') && c.CoverageType.equalsIgnoreCase('MEDICAL') && c.isActive && cvrgBenefitPlnid != 'mr' ){  
                                               c.isPreferred= True;  
                                            }
                                            if(c.isPreferred){
                                                 memberDetail.PreferredCoverage = c;
                                                 memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                                                 memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                                                 memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                                                 memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                                                 memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                                                 memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                                            }
                                        } 
                                    }
                                    
                                    else if(CoverageCount > 1){
                                        string fromGroupDetail = apexPages.currentpage().getparameters().get('fromGroupDetail');
                                        string URL = ApexPages.currentPage().getUrl();
                                        integer strStart = URL.indexOf('groupFlowGroupNumber%22%3A%22');
                                        integer strEnd = URL.indexOf('groupFlowGroupName');
                                        string GroupFlowGroupNum;
                                   
                                       if(strStart != -1 && strEnd != -1 )
                                        	GroupFlowGroupNum = URL.substring(strStart + 29 , strEnd - 9);
                                       else
                                            GroupFlowGroupNum = '';
                                        
                                        for(ACETMemberDetail.CoverageLine c : memberDetail.CoverageLines){ 
                                            string cvrgBenefitPlnid;
                                            if(c.benefitPlanId != null && c.benefitPlanId != '' && c.benefitPlanId.length() > 2&& c.benefitPlanId.toLowerCase().subString(0,1).isAlpha())                                       
                                                cvrgBenefitPlnid = c.benefitPlanId.toLowerCase().subString(0,2);
                                            //if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.CoverageType.equalsIgnoreCase('MEDICAL') && c.isActive && cvrgBenefitPlnid != 'mr' ){
                                            if(fromGroupDetail != null && fromGroupDetail != '' && GroupFlowGroupNum != null && GroupFlowGroupNum != '' ){
                                               if(c.isSubscriber && c.SourceCode.equalsIgnoreCase('CR') && c.CoverageType.equalsIgnoreCase('MEDICAL') && c.isActive && cvrgBenefitPlnid != 'mr' && c.GroupNumber == GroupFlowGroupNum ){ //&& c.relationshipCode=='18'
                                                    c.isPreferred= True;
                                                    system.debug('-------1-----'+c.GroupNumber);  
                                               }else{
                                                    c.isPreferred= False;
                                               }                                            
                                            }else if(c.isSubscriber && c.SourceCode.equalsIgnoreCase('CR') && c.CoverageType.equalsIgnoreCase('MEDICAL') && c.isActive && cvrgBenefitPlnid != 'mr' ){ //&& c.relationshipCode=='18'
                                                c.isPreferred= True;
                                                system.debug('-------2-----'+c.GroupNumber);  
                                            }
                                            else{
                                                c.isPreferred= False;
                                            }
                                            if(c.isPreferred){
                                                 memberDetail.PreferredCoverage = c;
                                                 memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                                                 memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                                                 memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                                                 memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                                                 memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                                                 memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                                            }
                                        } 
                                    }
                                                                                                                                                                  
                        }
                         if(CoverageCount == 0){
                    system.debug('-----------coverage count--kk-------'+memberDetail.CoverageLines);
                        List<ActiveCovg> lstActvcovg = new List<ActiveCovg>();
                        List<FutureCovg> lstfutcovg = new List<FutureCovg>();
                        List<TermedCovg> lstTermcovg = new List<TermedCovg>();
                        List<ACETMemberDetail.CoverageLine> coveragelnes = new List<ACETMemberDetail.CoverageLine>();
                        
                         for(ACETMemberDetail.CoverageLine c : memberDetail.CoverageLines){ 
                             string cvrgBenefitPlanid;
                             if(c.benefitPlanId != null && c.benefitPlanId != '' && c.benefitPlanId.length() > 2&& c.benefitPlanId.toLowerCase().subString(0,1).isAlpha())                                       
                             cvrgBenefitPlanid = c.benefitPlanId.toLowerCase().subString(0,2);
                              if(c.SourceCode.equalsIgnoreCase('CR') && c.CoverageType.equalsIgnoreCase('MEDICAL') && cvrgBenefitPlanid!= 'mr'){
                                    Date objEffectiveDate = Date.newInstance(Integer.valueOf(c.EffectiveDate.split('/')[2]), Integer.valueOf(c.EffectiveDate.split('/')[0]), Integer.valueOf(c.EffectiveDate.split('/')[1]));
                                    Date objEndDate = Date.newInstance(Integer.valueOf(c.EndDate.split('/')[2]), Integer.valueOf(c.EndDate.split('/')[0]), Integer.valueOf(c.EndDate.split('/')[1]));
                                     if(Date.today() >= objEffectiveDate && Date.today() <= objEndDate){ //Active
                                        ActiveCovg actcov =new ActiveCovg();
                                         actcov.groupnumber =c.GroupNumber;
                                         actcov.objeffectivedate=objEffectiveDate;
                                         actcov.objEndDate =objEndDate;
                                         actcov.covg=c;
                                         lstActvcovg.add(actcov);
                                     }else if(objEffectiveDate > Date.today()){ //Future
                                         FutureCovg futcov =new FutureCovg();
                                         futcov.groupnumber =c.GroupNumber;
                                         futcov.objeffectivedate=objEffectiveDate;
                                         futcov.objEndDate =objEndDate;
                                         futcov.covg =c;
                                         lstfutcovg.add(futcov);
                                     }else if(objEndDate < Date.today()){//TERMED
                                        TermedCovg termcov =new TermedCovg();
                                         termcov.groupnumber =c.GroupNumber;
                                         termcov.objeffectivedate=objEffectiveDate;
                                         termcov.objEndDate =objEndDate;
                                         termcov.covg =c;
                                         lstTermcovg.add(termcov);
                                     }
                              }                         
                           }
                           system.debug('------before---lstActvcovg--------'+lstActvcovg);
                           system.debug('------before---lstfutcovg--------'+lstfutcovg);
                           system.debug('------before---lstTermcovg--------'+lstTermcovg);

                           lstActvcovg.sort();
                           lstfutcovg.sort();
                           lstTermcovg.sort();
                           system.debug('---------lstActvcovg--------'+lstActvcovg);
                           system.debug('---------lstfutcovg--------'+lstfutcovg);
                           system.debug('---------lstTermcovg--------'+lstTermcovg);
                           if(lstActvcovg!= Null && lstActvcovg.size() > 0){
                               lstActvcovg[0].covg.isPreferred = true;
                               memberDetail.PreferredCoverage = lstActvcovg[0].covg;
                               memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                               memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                               memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                               memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                               memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                               memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                           }else if(lstfutcovg!=Null && lstfutcovg.size()>0){
                               lstfutcovg[0].covg.isPreferred = true;
                               memberDetail.PreferredCoverage = lstfutcovg[0].covg;
                               memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                               memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                               memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                               memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                               memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                               memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                           }else if(lstTermcovg!=Null && lstTermcovg.size()>0){
                               lstTermcovg[0].covg.isPreferred = true;
                               memberDetail.PreferredCoverage = lstTermcovg[0].covg;
                               memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                               memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                               memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                               memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                               memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                               memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                           }
                        }
                        
                         
                        system.debug('------memberdetail-coverages-----------'+memberDetail.CoverageLines);
                          system.debug('232323checking SRK list memberDetail.SurrogateKeys' + memberDetail.SurrogateKeys);
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = memberDetail;
                        
                   
                }
            }else {
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;                
                calloutResult.Response = memberDetail;
                calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
             }
            }else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;//'Web Service or External System is temporarily unavailable.'
           
             }
            }catch(Exception e){
                system.debug(e.getstacktracestring());
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;//'Web Service or External System is temporarily unavailable.'
           }
        
        return calloutResult;    
    }
    
    private boolean isPreferredCoverage(String sourceCode, String coverageType, boolean isActive, String effDateStr, String dateToCompare,String planBenefitIdCov, string groupNumber){ //, String relationshipCode
     try{  
        system.debug(sourceCode+' --::-- '+coverageType+' :: '+isActive+ ' :: '+effDateStr +' :: '+dateToCompare); //' :: '+relationshipCode
        String covBenefitPlanId;
        string GroupFlowGroupNum;
        string fromGroupDetail = apexPages.currentpage().getparameters().get('fromGroupDetail');
        string URL = ApexPages.currentPage().getUrl();
        system.debug('URL@@@ ' + URL);
        if(String.isNotBlank(URL)){
            integer strStart = URL.indexOf('groupFlowGroupNumber%22%3A%22');
            integer strEnd = URL.indexOf('groupFlowGroupName');
            system.debug('-------URL-----'+URL);
            system.debug('-------strpos -----'+strStart+'==='+strEnd);
            if(strStart != -1 && strEnd != -1 )
                GroupFlowGroupNum = URL.substring(strStart + 29 , strEnd - 9);
            else
                GroupFlowGroupNum = '';
            system.debug('-----GroupFlowGroupNum-----'+ GroupFlowGroupNum);
        }
        if(planBenefitIdCov != null && planBenefitIdCov != ''&& planBenefitIdCov.toLowerCase().subString(0,1).isAlpha())
            covBenefitPlanId = planBenefitIdCov.toLowerCase().subString(0,2);
        if(fromGroupDetail != null && fromGroupDetail != '' && GroupFlowGroupNum != null && GroupFlowGroupNum != '' ){
            if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') && groupNumber == GroupFlowGroupNum){ //relationshipCode.equalsIgnoreCase('18') &&
                Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETUtility.formatDateFromDashToSlash(effDateStr)) : null;
                Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETUtility.formatDateFromDashToSlash(dateToCompare)) : null;
                if(tempDate == null){
                    return false;
                }else if(effDate > tempDate){
                    system.debug('----TRUE ------');
                    return true;
                }
                
             }
         }else if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') ){ //relationshipCode.equalsIgnoreCase('18') &&
                Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETUtility.formatDateFromDashToSlash(effDateStr)) : null;
                Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETUtility.formatDateFromDashToSlash(dateToCompare)) : null;
                if(tempDate == null){
                    return false;
                }else if(effDate > tempDate){
                    system.debug('----TRUE ------');
                    return true;
                }
                
             }
         return false; 
     }catch(Exception e){
            return false;
       }
    }
    private boolean isActiveCoverage(String effDateStr, String endDateStr,String test){
    try{
        Date effDate =  Date.parse(ACETUtility.formatDateFromDashToSlash(effDateStr));
        if(Integer.valueOf(endDateStr.split('-')[0]) >= effdate.year()){
            return true;
        }
        
        Date endDate =  Date.parse(ACETUtility.formatDateFromDashToSlash(endDateStr));
        if(Date.today() > effDate && Date.today() <= endDate ){
            return true;
        }
        return false;
        }catch(Exception e){
            return false;
        }
    } 
 public Boolean isActiveCoverage(String EffectiveDate, String EndDate){
            if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
            
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
        }           
  public class ActiveCovg implements Comparable{
        public String groupnumber{get;set;}
        public Date objeffectivedate{get;set;}
        public Date objenddate{get;set;}
        public ACETMemberDetail.CoverageLine covg{get;set;}
                
        public Integer compareTo(Object compareTo){
            ActiveCovg compareToAct = (ActiveCovg)compareTo;
             
            if(objenddate > compareToAct.objenddate){
                return 1;
            }
            return -1;
        }
    }
    public class FutureCovg implements Comparable{
        public String groupnumber{get;set;}
        public Date objeffectivedate{get;set;}
        public Date objenddate{get;set;}
        public ACETMemberDetail.CoverageLine covg{get;set;}
                
        public Integer compareTo(Object compareTo){
            FutureCovg compareToFut = (FutureCovg)compareTo;
             
            if(objeffectivedate > compareToFut.objeffectivedate){
                return 1;
            }
            return -1;
        }
    }
    public class TermedCovg implements Comparable{
        public String groupnumber{get;set;}
        public Date objeffectivedate{get;set;}
        public Date objenddate{get;set;}
        public ACETMemberDetail.CoverageLine covg{get;set;}
                
        public Integer compareTo(Object compareTo){
            TermedCovg compareToTerm = (TermedCovg)compareTo;
             
            if(objenddate < compareToTerm.objenddate){
                return 1;
            }
            return -1;
        }
    }                
}