public class ACETFindMemberWebService extends ACETWebService { 
    private String m_memberId;
    private String m_firstName;
    private String m_lastName;
    private String m_dob;
    private String m_state;
    private String m_zip;
    
    public override void getEndpoint(){
        GetEndpointDetail('SearchMembersEndpoint');       
    }
      public ACETFindMemberWebService() {
        super('Stargate');
    } 
    public void getRequestBody(String memberId, String firstname, String lastName, String dob,String state, String zip){
        
        RequestBody =   '{"findIndividualsRequest": {"searchId": "'+memberId+'","searchTypeCode": "","firstName": "'+firstname+'","lastName": "'+lastName+'",'
                +'"birthDate": "'+dob+'",'
                +'"stateCode": "'+state+'",' 
                +'"postalCode": "'+zip+'",'
                +'"telephoneNumber": "",'
                +'"systemSpecificIndicator": "",'
                +'"pagination": {'
                +'"pageNumber": "1",'
                +'"pageSize": "1",'
                +'"startRecord": "1"'
                +'}'
            +'}'
        +'}';            
                                       
    } 
    //init service query params
    public void init(String memberId, String firstname, String lastName, String dob,String state, String zip){ 
        m_memberId = memberId;
        m_firstName = firstName;
        m_lastName = lastName;
        m_dob = dob;
        m_state = state;
        m_zip = zip;                                
    }
    
    //implement pagianted data service
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){                    
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETMemberSearchResult> memberSearchResult;
        String TempMemberId = m_memberId;
        
        try{
            ServiceName = 'FindIndividualsService';
            getEndpoint();
            getRequestBody(m_memberId,m_firstname,m_lastName,m_dob,m_state,m_zip);                          
            
            RequestBody = RequestBody.replace('"pageNumber": "1"','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"pageSize": "1"','"pageSize": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": "1"','"startRecord": "' + startRecord + '"');
                                   
            HttpResponse response;  
            response = Send(OAuthConfig);                       
              searchResult.statusCode=response.getStatusCode();       
           if(response!=null){
            system.debug(response.getStatusCode());
            searchResult.statusCode=response.getStatusCode();       
            if(response.getStatusCode() == 200){ 
                system.debug(response.getBody());                            
                if(response.getBody() != null){
                    //replace date with date2 as date is preserved keyword
                        String responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');
                        ACETFindIndividualResultJSON2Apex  ACTFMJSON2Apex = (ACETFindIndividualResultJSON2Apex)JSON.deserialize(responseBody, ACETFindIndividualResultJSON2Apex.class);
                        system.debug('ACTFMJSON2Apex : ' + ACTFMJSON2Apex );
                       memberSearchResult = new List<ACETMemberSearchResult>();
                        List<ACETFindIndividualResultJSON2Apex.Individuals> members = ACTFMJSON2Apex.findIndividualsResponse.individuals;
                        system.debug('232323members::' + members);
                       integer randomSRK = 123;
                       if(members!=null && members.size()>0){
                        for(ACETFindIndividualResultJSON2Apex.Individuals m : members){
                            ACETMemberSearchResult sr = new ACETMemberSearchResult();   
                            sr.ID = m.individualIdentifier;
                            sr.individualIdentifier = m.individualIdentifier;//Account Defect : bhanu
                            sr.LastName = m.name != null && m.name.lastName != null ? m.name.lastName : '' ;
                            sr.FirstName = m.name != null && m.name.FirstName != null ? m.name.FirstName : '';
                            sr.MiddleInitial = m.name != null && m.name.middleName != null ? m.name.middleName : '';
                            sr.Gender = m.genderCode;
                            sr.DOB = !String.isEmpty(m.birthDate) ? formatDate(m.birthDate) : sr.DOB;
                            sr.SSNum = m.socialSecurityNumber;
                            sr.SSN = !String.isEmpty(m.socialSecurityNumber) ? 'xxx-xx-'+ m.socialSecurityNumber.substring(5,9) : 'xxx-xx-'+sr.SSN;
                            //sr.Address = m.address != null ? m.address.addressline1 : sr.Address;
                            sr.Address='';
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.addressline1!= Null && m.address.addressline1!= '')?m.address.addressline1:'');                    
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.city!=Null && m.address.city!= '')?', '+m.address.city:'');
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.statecode!=Null && m.address.statecode!= '')?', '+m.address.statecode:'');            
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.postalCode!=Null && m.address.postalCode!= '')?', '+m.address.postalCode:'');
                            sr.Address= sr.Address.removeStart(',');  
                            sr.City = m.address != null ? m.address.city : sr.city; 
                            sr.State = m.address != null ? m.address.statecode : sr.State;
                            sr.Zip = m.address != null ? m.address.postalCode : sr.Zip;
                            sr.SourceCode = '';
                           system.debug('232323 Identifiers:::'+m.Identifiers); 
                            if (m.Identifiers != null && m.Identifiers.size() > 0) {
                                Set<String> sourceCodeSet = new Set<String>();   
                                List<String> MCHlst = new List<String>();
                                sr.ID ='';
                                for (ACETFindIndividualResultJSON2Apex.Identifiers Identifiers: m.Identifiers) {
                                    system.debug('232323 Identifiers.type_Z :::'+Identifiers.type_Z );                                                                      
                                    if (Identifiers.type_Z == 'SRK' && Identifiers.sourceSysCode == 'CR') {
                                        sr.SurrogateKeys.add(Identifiers.id);
                                        sr.SurrogateKey = Identifiers.id;
                                        
                                    }
                                    if (Identifiers.type_Z == 'MCH' && Identifiers.sourceSysCode=='CR') {
                                       Integer membIdsize=0;
                                       if(String.isNotBlank(m_memberId)) {
                                         membIdsize = m_memberId.length();
                                       }
                                       //check input string MemberId/SSN/Name search
                                       if(membIdsize ==11){
                                         if(identifiers.id.trim().substring(0,identifiers.id.trim().length()-2)==m_memberId.trim().substring(0,m_memberId.trim().length()-2)){
                                              sr.IDs.add(Identifiers.id);
                                              sr.ID = Identifiers.id;  
                                         }
                                        }else{
                                         sr.IDs.add(Identifiers.id);
                                         MCHlst.add(Identifiers.id);
                                        }
                                    }
                                   if (Identifiers.type_Z == 'SCR') {
                                        sr.IDs.add(Identifiers.id);
                                        System.debug('m_memberId='+m_memberId);
                                        System.debug('m.socialSecurityNumber='+m.socialSecurityNumber);
                                        if(String.isNotBlank(m_memberId) && !(m_memberId.trim()).equalsIgnoreCase(m.socialSecurityNumber.trim()) ){
                                             System.debug('It came here@@@ for SCR');
                                             if(String.isNotBlank(Identifiers.id) && (m_memberId.trim().substring(0,m_memberId.trim().length()-2)).equalsIgnoreCase((Identifiers.id.trim()).substring(0,Identifiers.id.trim().length()-2))){
                                                        sr.SCRID = Identifiers.id;  } 
                                         }
                                         else if(Identifiers.sourceSysCode=='CR'){ 
                                                   sr.SCRID = Identifiers.id;
                                          }
                                          else if(String.isBlank(sr.SCRID)){ 
                                                    sr.SCRID = Identifiers.id;
                                          }
                                    }
                                    if (Identifiers.type_Z == 'SRK' || Identifiers.type_Z == 'MCH' || Identifiers.type_Z == 'MBR' || Identifiers.type_Z == 'SCR') {
                                        sourceCodeSet.add(Identifiers.sourceSysCode);
                                    }
                                 }
                                if(sourceCodeSet!=null && sourceCodeSet.size()>0){
                                        for(String sc : sourceCodeSet){
                                            if(String.isEmpty(sr.SourceCode)){
                                                sr.SourceCode = sc;
                                            }else{
                                                sr.SourceCode = sr.SourceCode + ',' + sc;
                                            }
                                        }
                                }
                                if(sr.ID ==''){
                                 if(MCHlst!=Null && MCHlst.size()>0){
                                   sr.ID = MCHlst[MCHlst.size()-1];
                                  }
                                }
                               // if(!String.isBlank(sr.SurrogateKeysStr)){
                               if(String.isNotBlank(sr.SurrogateKeysStr) && String.isNotBlank(sr.SourceCode)){
                                    sr.SourceCode = (sr.SourceCode).subString(0,(sr.SourceCode).length() - 2);
                                }
                            }
                            if(String.isEmpty(sr.SurrogateKey) ){
                                if( sr.SurrogateKeys==null || sr.SurrogateKeys.isEmpty()){//Code Changed by chandan
                                    sr.SurrogateKey = '' + String.valueOf(randomSRK);//bhanu : hardcoding for the callable service
                                }else{
                                    for(String key : sr.SurrogateKeys){
                                        sr.SurrogateKey = key;
                                    }
                                }                                
                            }                            
                            randomSRK ++;
                             system.debug('232323 SurrogateKeys:::'+sr.SurrogateKeys);   
                            memberSearchResult.add(sr); 
                        }
                       }
                        searchResult.Success = true;
                        searchResult.Message = '';
                        searchResult.Response = memberSearchResult; 
                        searchResult.statusCode=response.getStatusCode();  
                                                
                        ACETFindIndividualResultJSON2Apex.Pagination pagination = ACTFMJSON2Apex.findIndividualsResponse.pagination; 
                        if(pagination!=null){
                            searchResult.pageNumber =  pagination.pageNumber; 
                            searchResult.pageSize = pagination.pageSize; 
                            searchResult.recordCount = pagination.recordCount;
                            searchResult.totalCount = pagination.totalCount;
                            searchResult.totalPages = pagination.totalPages;  
                            searchResult.statusCode=response.getStatusCode();  
                        }
                }                 
            }else if(response.getStatusCode() == 404){                
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = false;                
                searchResult.Response = new List<ACETMemberSearchResult>();
                searchResult.Message = 'Search criteria returned no matches.';                
                searchResult.recordCount = '0';                
                system.debug(searchResult);  
                searchResult.statusCode=response.getStatusCode();                
            }else {
                searchResult = ParseFailureResponse(response); 
                searchResult.Message = 'Problem with FindIndividual Webservice: ' + searchResult.Message;                              
                searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                searchResult.Success = false;                                                             
                searchResult.recordCount = '0';   
                searchResult.statusCode=response.getStatusCode();               
                system.debug(searchResult);
             }                
            }
            
            else{//Response is null
                searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                searchResult.Success = false;
                searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                searchResult.recordCount = '0';
                searchResult.statusCode=999; 
            }
            //End
            }catch(Exception e){
                    system.debug(e.getStackTraceString());
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                    searchResult.recordCount = '0';
                    searchResult.statusCode=999;       

           }
        
        return searchResult;        
    }
    
    public ACETWSCalloutResult findMemberWS(){
        
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETMemberSearchResult> memberSearchResult;
        String TempMemberId = m_memberId;
        
        try{
            ServiceName = 'FindIndividualsService';
            getEndpoint();
            getRequestBody(m_memberId,m_firstname,m_lastName,m_dob,m_state,m_zip);                          
            
                                   
            HttpResponse response;  
            response = Send(OAuthConfig);
            searchResult.statusCode=response.getStatusCode();    
                         system.debug('sampath --->'+response.getStatusCode());
                          
            if(response!=null){
             system.debug(response.getStatusCode());
             searchResult.statusCode=response.getStatusCode();     
                                      system.debug('sampath --->'+response.getStatusCode());
  
                     
            if(response.getStatusCode() == 200){ 
                system.debug(response.getBody());                            
                if(response.getBody() != null){
                    //replace date with date2 as date is preserved keyword
                        String responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');
                        ACETFindIndividualResultJSON2Apex  ACTFMJSON2Apex = (ACETFindIndividualResultJSON2Apex)JSON.deserialize(responseBody, ACETFindIndividualResultJSON2Apex.class);
                        system.debug('ACTFMJSON2Apex : ' + ACTFMJSON2Apex );
                       memberSearchResult = new List<ACETMemberSearchResult>();
                        List<ACETFindIndividualResultJSON2Apex.Individuals> members = ACTFMJSON2Apex.findIndividualsResponse.individuals;
                        system.debug('232323members::' + members);
                       integer randomSRK = 123;
                      if(members!=null && members.size()>0){
                        for(ACETFindIndividualResultJSON2Apex.Individuals m : members){
                            ACETMemberSearchResult sr = new ACETMemberSearchResult();   
                            sr.ID = m.individualIdentifier;
                            sr.individualIdentifier = m.individualIdentifier;//Account Defect : bhanu
                            sr.LastName = m.name != null && m.name.lastName != null ? m.name.lastName : '' ;
                            sr.FirstName = m.name != null && m.name.FirstName != null ? m.name.FirstName : '';
                            sr.MiddleInitial = m.name != null && m.name.middleName != null ? m.name.middleName : '';
                            sr.Gender = m.genderCode;
                            sr.DOB = !String.isEmpty(m.birthDate) ? formatDate(m.birthDate) : sr.DOB;
                            sr.SSNum = m.socialSecurityNumber;
                            sr.SSN = !String.isEmpty(m.socialSecurityNumber) ? 'xxx-xx-'+ m.socialSecurityNumber.substring(5,9) : 'xxx-xx-'+sr.SSN;
                            //sr.Address = m.address != null ? m.address.addressline1 : sr.Address;
                            sr.Address='';
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.addressline1!= Null && m.address.addressline1!= '')?m.address.addressline1:'');                    
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.city!=Null && m.address.city!= '')?', '+m.address.city:'');
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.statecode!=Null && m.address.statecode!= '')?', '+m.address.statecode:'');            
                            sr.Address= sr.Address+ ((m.address!= Null && m.address.postalCode!=Null && m.address.postalCode!= '')?', '+m.address.postalCode:'');
                            sr.Address= sr.Address.removeStart(',');  
                            sr.City = m.address != null ? m.address.city : sr.city; 
                            sr.State = m.address != null ? m.address.statecode : sr.State;
                            sr.Zip = m.address != null ? m.address.postalCode : sr.Zip;
                            sr.SourceCode = '';
                            
                            
                           system.debug('232323 Identifiers:::'+m.Identifiers); 
                            if (m.Identifiers != null && m.Identifiers.size() > 0) {
                                Set<String> sourceCodeSet = new Set<String>();        
                                List<String> MCHlst = new List<String>();
                                sr.ID =''; 
                                for (ACETFindIndividualResultJSON2Apex.Identifiers Identifiers: m.Identifiers) {
                                        system.debug('232323 Identifiers.type_Z :::'+Identifiers.type_Z ); 
                                        if (Identifiers.type_Z == 'SRK' && Identifiers.sourceSysCode == 'CR') {
                                            sr.SurrogateKeys.add(Identifiers.id);
                                            sr.SurrogateKey = Identifiers.id;
                                            
                                        }
                                    if (Identifiers.type_Z == 'MCH' && Identifiers.sourceSysCode=='CR') {
                                       Integer membIdsize=0;
                                       if(String.isNotBlank(m_memberId)) {
                                         membIdsize = m_memberId.length();
                                       }
                                       //check input string MemberId/SSN/Name search
                                       if(membIdsize ==11){
                                         if(identifiers.id.trim().substring(0,identifiers.id.trim().length()-2)==m_memberId.trim().substring(0,m_memberId.trim().length()-2)){
                                              sr.IDs.add(Identifiers.id);
                                              sr.ID = Identifiers.id;  
                                         }
                                        }else{
                                         sr.IDs.add(Identifiers.id);
                                         MCHlst.add(Identifiers.id);
                                        }
                                      }
                                        if (Identifiers.type_Z == 'SCR') {
                                        sr.IDs.add(Identifiers.id);
                                        System.debug('m_memberId='+m_memberId);
                                        System.debug('m.socialSecurityNumber='+m.socialSecurityNumber);
                                            if(String.isNotBlank(m_memberId) &&  !(m_memberId.trim()).equalsIgnoreCase(m.socialSecurityNumber.trim()) ){
                                                    System.debug('It came here@@@ for SCR');
                                                    if(String.isNotBlank(Identifiers.id) && (m_memberId.trim().substring(0,m_memberId.trim().length()-2)).equalsIgnoreCase((Identifiers.id.trim()).substring(0,Identifiers.id.trim().length()-2))){
                                                        sr.SCRID = Identifiers.id;  } 
                                            }
                                            else if(Identifiers.sourceSysCode=='CR'){ 
                                                   sr.SCRID = Identifiers.id;
                                               }
                                            else if(String.isBlank(sr.SCRID)){ 
                                                    sr.SCRID = Identifiers.id;
                                            }
                                        }
                                        if (Identifiers.type_Z == 'SRK' || Identifiers.type_Z == 'MCH' || Identifiers.type_Z == 'MBR' || Identifiers.type_Z == 'SCR') {
                                            sourceCodeSet.add(Identifiers.sourceSysCode);
                                        }
                                    }
                               if(sourceCodeSet!=null && sourceCodeSet.size()>0){
                                for(String sc : sourceCodeSet){
                                    if(String.isEmpty(sr.SourceCode)){
                                        sr.SourceCode = sc;
                                    }else{
                                        sr.SourceCode = sr.SourceCode + ',' + sc;
                                    }
                                  }
                               }
                               if(sr.ID ==''){
                                 if(MCHlst!=Null && MCHlst.size()>0){
                                   sr.ID = MCHlst[MCHlst.size()-1];
                                  }
                                }
                                //if(!String.isBlank(sr.SurrogateKeysStr)){
                                if(String.isNotBlank(sr.SurrogateKeysStr) && String.isNotBlank(sr.SourceCode)){
                                    sr.SourceCode = (sr.SourceCode).subString(0,(sr.SourceCode).length() - 2);
                                }
                            }
                            if(String.isEmpty(sr.SurrogateKey) ){
                                if( sr.SurrogateKeys==null || sr.SurrogateKeys.isEmpty()){
                                    sr.SurrogateKey = '' + String.valueOf(randomSRK);//bhanu : hardcoding for the callable service
                                }else{
                                    for(String key : sr.SurrogateKeys){
                                        sr.SurrogateKey = key;
                                    }
                                }                                
                            }                            
                            randomSRK ++;
                             system.debug('232323 SurrogateKeys:::'+sr.SurrogateKeys);   
                            memberSearchResult.add(sr); 
                          }
                        }
                        searchResult.Success = true;
                        searchResult.Message = '';
                        searchResult.Response = memberSearchResult; 
                }                 
             }else if(response.getStatusCode() == 404){                
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = false;                
                searchResult.Response = new List<ACETMemberSearchResult>();
                searchResult.Message = 'Search criteria returned no matches.';                
                searchResult.recordCount = '0';         
                searchResult.statusCode=response.getStatusCode();       
                                system.debug('sampath --->'+response.getStatusCode());

                system.debug(searchResult);                
             }else {

                searchResult = ParseFailureResponse(response); 
                searchResult.Message = 'Problem with FindIndividual Webservice: ' + searchResult.Message;                              
                searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                searchResult.Success = false;                                                             
                searchResult.recordCount = '0';    
               searchResult.statusCode=response.getStatusCode();       
                                     system.debug('sampath --->'+response.getStatusCode());

                system.debug(searchResult);                
             }
            
            }
            else{//when response is null
                searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                searchResult.Success = false;
                searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                searchResult.recordCount = '0';
                searchResult.statusCode=999;
            }
            //End
            }catch(Exception e){
                    system.debug(e.getStackTraceString());
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                    searchResult.recordCount = '0';
                    searchResult.statusCode=999;       

           }
        
        return searchResult;        
        
    }
   
    public ACETWSCalloutResult findMembers(String memberId, String firstname, String lastName, String dob,String state, String zip){
        //Delete this method
        return null;
    }
    
    //to remove to global util class
    public String formatDate(String dateString){
      try{
        if(dateString == null) return null;
        
        List<String> dateParts = dateString.split('-');
        if(dateParts!=null && dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
      }
        catch(Exception e){
            System.debug('Exception occured='+e);
            return null;
        }
    }    
 }