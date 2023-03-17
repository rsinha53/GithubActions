public class ACETFindEmployerGroupSearchWebService extends ACETWebService{
    public class applicationException extends Exception {}
    private String taxId;
    private String g_groupId;
    private String g_groupTaxId;
    private String g_gName;
    private String g_state;
    
    public override void getEndpoint(){
        GetEndpointDetail('FindEmployerGroupEndpoint');
    }
    
	public ACETFindEmployerGroupSearchWebService() {
        if(!Test.isRunningTest())
			super('Stargate');
    }
    public void getRequestBodyAdapterId(String groupId){
    
       RequestBody = '{"findEmployerGroupsRequest": {'
                               + '"groupNumber":  "' + groupId + '" ,'  
                               +'"pagination": {'
                               +'"pageNumber": "1",'
                               +'"pageSize": "1"'
                               +'}'  
                               + '}}';
    }
    
   public void getRequestBodyAdapterTaxId(String groupTaxId){   
       RequestBody = '{"findEmployerGroupsRequest": {'
                               + '"taxIdentificationNumber":  "' + groupTaxId + '" ,'
                               +'"pagination": {'
                               +'"pageNumber": "1",'
                               +'"pageSize": "1"'
                               +'}'      
                               + '}}'; 
  }                          
                                 
    public void getRequestBodyAdapterName(String groupName, String state){
        
    
        RequestBody = '{"findEmployerGroupsRequest": {'
                           + '"groupName":  "' + groupName + '", ' 
                           + '"state":  "' + state + '" ,' 
                           +'"pagination": {'
                           +'"pageNumber": "1",'
                           +'"pageSize": "1"'
                           +'}'    
                           + '}}';
                                         
    }

     //init service query params
    public void init(String groupId, String groupTaxId, String gname, String state){ 
        g_groupId = groupId;
        g_groupTaxId = groupTaxId;
        g_gname = gname;
        g_state = state;
                                        
    }
    
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){                    
       ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
       List<ACETGroupSearchResult> groupSearchResult = new List<ACETGroupSearchResult>();
       ACETGroupSearchResult sr = new ACETGroupSearchResult(); 
                    
            try {
            ServiceName = 'findEmployerGroupsService';
            getEndpoint();
            
            if (!String.isEmpty(g_groupId)) {
                getRequestBodyAdapterId(g_groupId);
            }
            else if (!String.isEmpty(g_groupTaxId)) {
                getRequestBodyAdapterTaxId(g_groupTaxId);
            }
            else {
                getRequestBodyAdapterName(g_gName,g_state);  
            }
            RequestBody = RequestBody.replace('"pageNumber": "1"','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"pageSize": "1"','"pageSize": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": "1"','"startRecord": "' + startRecord + '"');
            
            system.debug('**RequestBody'+RequestBody);
            HttpResponse response = Send(OAuthConfig);
            system.debug('**OAuthConfig'+OAuthConfig);
            system.debug('**OAuthConfig.response'+response);
            if(response.getStatusCode() == 200){
               
                
                if(response.getBody() != null){
                    //replace desc with descr as desc is preserved keyword
                    String responseBody = response.getBody().replace('\"desc\":', '\"descr\":');
                    
                    system.debug('**responseBody in find group ==>'+responseBody);
                    
                    Type resultType = Type.forName('ACETFindEmployerGroupCallableJSON2Apex'); 
                    ACETFindEmployerGroupCallableJSON2Apex ACTFGJSON2Apex = (ACETFindEmployerGroupCallableJSON2Apex)JSON.deserialize(responseBody, resultType);
                    system.debug('**ACTFGJSON2Apex : ' + ACTFGJSON2Apex );
                    
                    list<ACETFindEmployerGroupCallableJSON2Apex.EmployerGroup> listgroups = ACTFGJSON2Apex.findEmployerGroupsResponse.employerGroup;
                    
                    system.debug('*****groups'+listgroups );
                     
                    groupSearchResult = new List<ACETGroupSearchResult>();

                    for(ACETFindEmployerGroupCallableJSON2Apex.EmployerGroup gr: listgroups){
                        
                        if(g_groupId != null && g_groupId == gr.groupNumber)
                        {
                            system.debug('*****NEW inside group Number if'+gr);
                    
                            sr = new ACETGroupSearchResult(); 
                                    
                            sr.groupName = (gr.groupName != null)?gr.groupName:''; 
                            sr.groupId = (gr.groupNumber != null)?gr.groupNumber:''; 
                            sr.sourcesystem = (gr.sourceSysCode!= null)?gr.sourceSysCode:''; 
                             
                            if(gr.groupContract != null)
                            {
                                // Created by Harish for the US748853
                                if(gr.groupContract.expirationDate != Null && gr.groupContract.status.descr == 'Active')
                                {
                                    sr.status =(Date.valueOf(gr.groupContract.expirationDate) < date.today())?'Terminated':'Active';
                                }else{                              
                                sr.status = (gr.groupContract.status != null)?gr.groupContract.status.descr:''; 
                                }
                                //END
                                sr.renewalDate = (gr.groupContract.renewalDate != null)?String.valueof(Acetutility.format(Date.valueOf(gr.groupContract.renewalDate))):''; 
                            }
                            else
                            {
                                sr.status = '';
                                sr.renewalDate = '';
                            }
                            
                            taxId = '';
                            if(gr.taxIdentificationNumber != null)
                            {
                                Integer taxIdSize =  gr.taxIdentificationNumber.size();
                            
                                for (Integer j = taxIdSize ; j > 0; j--) 
                                {
                                    if(taxId == '' || taxId == null)
                                    {
                                        taxId = gr.taxIdentificationNumber[j-1];
                                    }
                                    else
                                    {
                                        taxId = taxId + ', ' +gr.taxIdentificationNumber[j-1];
                                    }
                                
                                }
                            }
                            system.debug('*****NEW inside group Number if after for loop'+gr);
                    
                            sr.taxId = taxId;
                            
                            if(gr.address != null)
                            {   
                                sr.addresses = ''; 
                                sr.addresses = sr.addresses + ((gr.address.addressLine1 != null && gr.address.addressLine1 != '')?gr.address.addressLine1:''); 
                                sr.addresses = sr.addresses + ((gr.address.addressLine2 != null && gr.address.addressLine2 != '')?(', ' + gr.address.addressLine2):''); 
                                sr.addresses = sr.addresses + ((gr.address.addressLine3 != null && gr.address.addressLine3 != '')?(', ' + gr.address.addressLine3):''); 
                                sr.city = (gr.address.city  != null)?gr.address.city :''; 
                                sr.state = (gr.address.stateCode != null)?gr.address.stateCode:''; 
                                sr.zipcode = (gr.address.postalCode != null)?gr.address.postalCode :''; 
                                
                            } 
                            else
                            {
                               sr.addresses = '';
                               sr.city = '';
                               sr.state = '';
                               sr.zipcode = '';
                               
                            }   
                            groupSearchResult.add(sr);
                            system.debug('@@@groupSearchResult groupId'+groupSearchResult);
                    
                        }
                        else if(g_groupTaxId != null && g_groupTaxId != '')
                        {
                            System.debug('gr:::'+gr);
                            taxId ='';
                            if(gr.taxIdentificationNumber != null)
                            {
                                Integer taxIdSize =  gr.taxIdentificationNumber.size();
                                
                                for (Integer j = taxIdSize ; j > 0; j--) 
                                {
                                    if(taxId == '' || taxId == null)
                                    {
                                        taxId = gr.taxIdentificationNumber[j-1];
                                    }
                                    else
                                    {
                                        taxId = taxId + ', ' +gr.taxIdentificationNumber[j-1];
                                    }
                                
                                }
                            }
                            
                            
                            if(taxId.contains(g_groupId))
                            {
                                sr = new ACETGroupSearchResult(); 
                                
                                sr.groupName = (gr.groupName != null)?gr.groupName:''; 
                                sr.groupId = (gr.groupNumber != null)?gr.groupNumber:''; 
                                sr.sourcesystem = (gr.sourceSysCode!= null)?gr.sourceSysCode:''; 
                             
                                if(gr.groupContract != null)
                                {
                                    // Created by Harish for the US748853
                                    if(gr.groupContract.expirationDate != Null && gr.groupContract.status.descr == 'Active')
                                    {
                                        sr.status =(Date.valueOf(gr.groupContract.expirationDate) < date.today())?'Terminated':'Active';
                                    }else{                              
                                    sr.status = (gr.groupContract.status != null)?gr.groupContract.status.descr:''; 
                                    } 
                                    //END                                  
                                    sr.renewalDate = (gr.groupContract.renewalDate != null)?String.valueof(Acetutility.format(Date.valueOf(gr.groupContract.renewalDate))):''; 
                                }
                                else
                                {
                                    sr.status = '';
                                    sr.renewalDate = '';
                                }
                                    
                                sr.taxId = taxId;
                                
                                if(gr.address != null)
                                {
                                    sr.addresses = ''; 
                                    sr.addresses = sr.addresses + ((gr.address.addressLine1 != null && gr.address.addressLine1 != '')?gr.address.addressLine1:''); 
                                    sr.addresses = sr.addresses + ((gr.address.addressLine2 != null && gr.address.addressLine2 != '')?(', ' + gr.address.addressLine2):''); 
                                    sr.addresses = sr.addresses + ((gr.address.addressLine3 != null && gr.address.addressLine3 != '')?(', ' + gr.address.addressLine3):''); 
                                    sr.city = (gr.address.city  != null)?gr.address.city :''; 
                                    sr.state = (gr.address.stateCode != null)?gr.address.stateCode:''; 
                                    sr.zipcode = (gr.address.postalCode != null)?gr.address.postalCode :''; 
                                
                               }
                               else
                               {
                                   sr.addresses = '';
                                   sr.city = '';
                                   sr.state = '';
                                   sr.zipcode = '';
                                   
                               }
                               
                                groupSearchResult.add(sr);
                               
                                system.debug('###groupSearchResult inside else if tax id'+groupSearchResult);
                            }
                                  
                        }
                        else 
                        {
                            system.debug('@@@inside'+groupSearchResult);
                            sr = new ACETGroupSearchResult(); 
                         
                            sr.groupName = (gr.groupName != null)?gr.groupName:''; 
                            sr.groupId = (gr.groupNumber != null)?gr.groupNumber:''; 
                            sr.sourcesystem = (gr.sourceSysCode!= null)?gr.sourceSysCode:''; 
                             
                            if(gr.groupContract != null)
                            {
                                // Created by Harish for the US748853
                                if(gr.groupContract.expirationDate != Null && gr.groupContract.status.descr == 'Active')
                                {
                                    sr.status =(Date.valueOf(gr.groupContract.expirationDate) < date.today())?'Terminated':'Active';
                                }else{                              
                                    sr.status = (gr.groupContract.status != null)?gr.groupContract.status.descr:''; 
                                } 
                                //End  
                                sr.renewalDate = (gr.groupContract.renewalDate != null)?String.valueof(Acetutility.format(Date.valueOf(gr.groupContract.renewalDate))):''; 
                            }
                            else
                            {
                                sr.status = '';
                                sr.renewalDate = '';
                            }
                            taxId = '';
                                    
                            if(gr.taxIdentificationNumber != null)
                            {
                                Integer taxIdSize =  gr.taxIdentificationNumber.size();
                                for (Integer j = taxIdSize ; j > 0; j--) 
                                {
                                    if(taxId == '' || taxId == null)
                                    {
                                        taxId = gr.taxIdentificationNumber[j-1];
                                    }
                                    else
                                    {
                                        taxId = taxId + ', ' +gr.taxIdentificationNumber[j-1];
                                    }
                                
                                }
                            } 
                            sr.taxId = taxId;
                            
                            if(gr.address != null)
                            {
                                sr.addresses = ''; 
                                sr.addresses = sr.addresses + ((gr.address.addressLine1 != null && gr.address.addressLine1 != '')?gr.address.addressLine1:''); 
                                sr.addresses = sr.addresses + ((gr.address.addressLine2 != null && gr.address.addressLine2 != '' )?(', ' + gr.address.addressLine2):''); 
                                sr.addresses = sr.addresses + ((gr.address.addressLine3 != null && gr.address.addressLine3 != '' )?(', ' + gr.address.addressLine3):''); 
                                
                                sr.city = (gr.address.city  != null)?gr.address.city :''; 
                                sr.state = (gr.address.stateCode != null)?gr.address.stateCode:''; 
                                sr.zipcode = (gr.address.postalCode != null)?gr.address.postalCode :''; 
                                
                           }
                           else
                           {
                               sr.addresses = '';
                               sr.city = '';
                               sr.state = '';
                               sr.zipcode = '';
                               
                           }
                            
                            groupSearchResult.add(sr);
                                
                            system.debug('$$$groupSearchResult inside else if group Name'+groupSearchResult);
                        }                        
                   }
                                       
                    searchResult.Success = true;
                    searchResult.Message = '';
                    searchResult.Response = groupSearchResult;
                    searchResult.statusCode =response.getStatusCode();
                    system.debug('@@@groupSearchResult'+groupSearchResult);
                    
                    ACETFindEmployerGroupCallableJSON2Apex.Pagination pagination = ACTFGJSON2Apex.findEmployerGroupsResponse.pagination;                                                                         
                    searchResult.pageNumber =  pagination.pageNumber; 
                    searchResult.pageSize = pagination.pageSize; 
                    searchResult.recordCount = pagination.recordCount;
                    searchResult.totalCount = pagination.totalCount;
                    searchResult.totalPages = pagination.totalPages; 
                    
                    system.debug('@@@searchResult'+SearchResult);
                     
              }  
                
            }else if(response.getStatusCode() == 500 || response.getStatusCode() == 404 || response.getStatusCode() == 400){
                
                //currently servce returns 500 if no records found
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = true;                
                searchResult.Response = new List<ACETGroupSearchResult>();
                searchResult.statusCode =response.getStatusCode();

                system.debug(searchResult);                
            }
            }catch(Exception e){
                    system.debug(e);
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = label.ACETOILNotAvailable;
           }
        
        return searchResult;    
    } 

}