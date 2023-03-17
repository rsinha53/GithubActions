public class ACETFindProducerWebservice extends ACETWebservice
{
    private string p_producerID;
    private string p_producerTaxID;
    private string p_producerSSN;
    private string p_companyName;
    private string p_groupNumber;
    private string p_LastName;
    private string p_FirstName;
    private string p_State;
    private string p_FilterBy;
    private string p_SortBy;
    private string p_SortOrder;
    private string p_producerFlag;
    private string currentDate;
    
    //init service query params
    public void init(String producerSSN,String producerTaxID,String producerID, String companyName,string groupNumber, String LastName, String FirstName, String State,
                        String SortBy, String SortOrder, String FilterBy){ 
        p_producerID = producerID;
        p_companyName = companyName;
        p_groupNumber = groupNumber;
        p_LastName = LastName;
        p_FirstName = FirstName;
        p_State = State;
        p_SortBy = SortBy;
        p_SortOrder = SortOrder;
        p_FilterBy = FilterBy;
        p_producerSSN = producerSSN;
        p_producerTaxID = producerTaxID;
        p_producerFlag = '';                                
    }
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('FindProducersEndPoint');
    }
    public ACETFindProducerWebservice()
    {
        super('Stargate');
    }
    
    private void getAdapterReqBody(String producerSSN,String producerTaxID, String producerID, String companyName, string groupNumber, String LastName, String FirstName, String State, String FilterBy, String producerFlag)
    {
        currentDate = cleanDate(Date.today().format());
        system.debug('!!!curerntDate'+CurrentDate);
        
        if(groupNumber != Null && groupNumber != '')
        {
            if(producerFlag == '0') 
            {  
                system.debug('!!!inside Past');
                RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"past","producerAndGroupFlag":"Y","pageNumber": "1","recordsPerPage": "50"},"findProducerRequest":{'
                          +'"memberGroupNumber":"'+groupNumber+'","memberGroupName":""'
                          +',"requestedDate":"'+currentDate+'"}}}';
            }
            else if(producerFlag == '1')
            {
                system.debug('!!!inside present');
                RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"present","producerAndGroupFlag":"Y","pageNumber": "1","recordsPerPage": "50"},"findProducerRequest":{'
                          +'"memberGroupNumber":"'+groupNumber+'","memberGroupName":""'
                          +',"requestedDate":"'+currentDate+'"}}}';
            }
            else if(producerFlag == '2') 
            {
                system.debug('!!!inside Future');
                RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"future","producerAndGroupFlag":"Y","pageNumber": "1","recordsPerPage": "50"},"findProducerRequest":{'
                          +'"memberGroupNumber":"'+groupNumber+'","memberGroupName":""'
                          +',"requestedDate":"'+currentDate+'"}}}';
            }
        }
        else
        {
            
            if(producerID != null && producerID.isNumeric()) {
                RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"","producerAndGroupFlag":"N","pageNumber": "1","recordsPerPage": "50"},"findProducerRequest":{'
                          +'"producerId":"'+producerID+'"'
                          +',"producerSSN":"'+producerSSN+'"'
                          +',"producerTIN":"'+producerTaxID+'"'
                          +',"memberGroupNumber":"'+groupNumber+'","memberGroupName":""'
                          +',"producerFirstName":"'+FirstName+'"'
                          +',"producerMiddleInitial":"","producerLastName":"'+LastName+'"'
                          +',"producerCompanyName":"'+companyName+'"'
                          +',"producerState":"'+State+'"'
                          +',"producerStatus":""'
                          +',"requestedDate":"'+currentDate+'"'
                          +',"legacyBrokerCode":""}}}'; 
            } else {
                RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"","producerAndGroupFlag":"N","pageNumber": "1","recordsPerPage": "50"},"findProducerRequest":{'
                          +'"producerId":""'
                          +',"producerSSN":"'+producerSSN+'"'
                          +',"producerTIN":"'+producerTaxID+'"'
                          +',"memberGroupNumber":"'+groupNumber+'","memberGroupName":""'
                          +',"producerFirstName":"'+FirstName+'"'
                          +',"producerMiddleInitial":"","producerLastName":"'+LastName+'"'
                          +',"producerCompanyName":"'+companyName+'"'
                          +',"producerState":"'+State+'"'
                          +',"producerStatus":""'
                          +',"requestedDate":"'+currentDate+'"'
                          +',"legacyBrokerCode":"'+producerID+'"}}}'; 
            }
        }
    }
     
    @TestVisible private void GetRequestBody(String producerID, String companyName, String LastName, String FirstName, String State, String FilterBy)
    {
        if(!String.isEmpty(producerID)){
            RequestBody = '{"findProducer": {'
                           + '"findProducerRequestType": {'
                           +'"body":{'
                           +'"request":[{'
                           + '"producerIdentifier":  {"id" : "' + producerID + '"} '                              
                           + '}]}}}}';
        }else if(!String.isEmpty(companyName)){
            RequestBody = '{"findProducer": {'   
                           +'"findProducerRequestType": {'
                           +'"body":{'
                           +'"request":[{'
                           +'"producerCompanyName": "' + companyName + '" '                              
                           + '}]}}}}';
        }else{
            RequestBody = '{"findProducer": {'   
                           +'"findProducerRequestType": {'
                           +'"body":{'
                           +'"request":[{'
                           +'"producerFirstName": "' + FirstName + '",'    
                           +'"producerLastName": "' + LastName + '" '                          
                           + '}]}}}}';            
        }
    }
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){  
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProducerSearchResult> producersSearchResult;     
        List<ACETFindProducersAdaptJSON2Apex.FindProducerResponse> SRProducers;  
        ACETProducerSearchResult Producer;
        
        try
        {
            GetEndpoint();
            
            getAdapterReqBody(p_producerSSN,p_producerTaxID,p_producerID,p_companyName,p_groupNumber,p_LastName, p_FirstName, p_State, p_FilterBy, p_producerFlag); 
            RequestBody = RequestBody.replace('"pageNumber": "1"','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"pageSize": "1"','"pageSize": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": "1"','"startRecord": "' + startRecord + '"');
            system.debug('RequestBody --->'+RequestBody );
            HttpResponse Response = Send(OAuthConfig);
            system.debug('**OAuthConfig.response'+response);
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            if (Response.getStatusCode() == 200)
            {
                if(response.getBody() != null){
                  
                   String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    system.debug('**responseBody in find group ==>'+responseBody);
                    
                    ACETFindProducersAdaptJSON2Apex ACTFPJSON2Apex = (ACETFindProducersAdaptJSON2Apex)JSON.deserialize(responseBody, ACETFindProducersAdaptJSON2Apex.class);
                    system.debug('**ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                    system.debug('**response code: ' + ACTFPJSON2Apex.response.serviceAttributes.responseCode);
                    
                    producersSearchResult= new List<ACETProducerSearchResult>(); 
                    SRProducers = ACTFPJSON2Apex.response.FindProducerResponse;
                    system.debug('**SRProducers :----> ' + SRProducers );
                    if(SRProducers != Null)
                    {
                        for (ACETFindProducersAdaptJSON2Apex.FindProducerResponse producers: SRProducers){
                            Producer = new ACETProducerSearchResult();
                            Producer.ProducerID = (producers.producerId != null)?producers.producerId:'';
                            Producer.CompanyName = (producers.producerCompanyName != null)?producers.producerCompanyName:'';
                            Producer.LastName = (producers.producerName.lastName != null)?producers.producerName.lastName:'';
                            Producer.FirstName = (producers.producerName.firstName != null)?producers.producerName.firstName:'';
                            Producer.MiddleInitial = (producers.producerName.middleInitial != null)?producers.producerName.middleInitial:'';
                            Producer.ProducerType = (producers.producerType != null)?producers.producerType:'';
                            Producer.producerMemberGrpStartDate = producers.memberGroupDetails[0].producerMemberGrpStartDate;
                            Producer.producerMemberGrpEndDate = producers.memberGroupDetails[0].producerMemberGrpEndDate;
                            Producer.producerContact = (producers.producerContact != null)?producers.producerContact:'';
                            Producer.producerState  = (producers.producerState != null)?producers.producerState:'';
                            Producer.producerCity = (producers.producerCity != null)?producers.producerCity:'';
                            Producer.producerPhoneNumber = (producers.producerPhoneNumber != null)?producers.producerPhoneNumber:'';
                            Producer.producerEffectiveAsOfDate = (producers.producerEffectiveAsOfDate != null)?producers.producerEffectiveAsOfDate:'';
                            Producer.producerLegacyBrokerCode  = (producers.legacyBrokerCode != null)?producers.legacyBrokerCode:'';
                            if(Producer.ProducerType == 'B')
                            {
                                Producer.producerTIN = (producers.producerTIN != null || producers.producerTIN != '')?producers.producerTIN:'';
                            }
                            else if(Producer.ProducerType == 'I')
                            {
                                Producer.producerTIN = (producers.producerSSN != null || producers.producerSSN != '')?getMaskedSSN(producers.producerSSN):'';
                            }
                            else
                            {
                                Producer.producerTIN = '';
                            }
                            producersSearchResult.add(Producer);
                        }
                        
                        if (producersSearchResult != null)
                        {
                            ACETProducerSearchResult.SortBy = p_SortBy;
                            ACETProducerSearchResult.SortOrder = p_SortOrder;
                            producersSearchResult.Sort();
                            oACETWSCalloutResult.Success = true;
                            oACETWSCalloutResult.Message = '';
                            oACETWSCalloutResult.Response = producersSearchResult;
                            oACETWSCalloutResult.pageNumber =  ACTFPJSON2Apex.response.serviceAttributes.pageNumber; 
                            oACETWSCalloutResult.pageSize = ACTFPJSON2Apex.response.serviceAttributes.recordsPerPage;  
                            oACETWSCalloutResult.recordCount = ACTFPJSON2Apex.response.serviceAttributes.recordsPerPage; 
                            oACETWSCalloutResult.totalCount = ACTFPJSON2Apex.response.serviceAttributes.totalNumberOfRecords; 
                              
                        }
                    }else
                    {
                        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                        oACETWSCalloutResult.Response = new List<ACETMemberSearchResult>();
                        oACETWSCalloutResult.Message = 'Search criteria returned no matches.';                
                        oACETWSCalloutResult.recordCount = '0';  
                        oACETWSCalloutResult.statusCode=Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode);
                        if(Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode)==404){                        
                         oACETWSCalloutResult.Success = true;
                        }else{
                         oACETWSCalloutResult.Success = false;
                        }
                    }
                    
                        
                }     
            }
            else if(response.getStatusCode() == 500||response.getStatusCode() == 404){
                
                //currently servce returns 500 if no records found
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                oACETWSCalloutResult.Success = true;                
                oACETWSCalloutResult.Response = new List<ACETProducerSearchResult>();
                oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
                system.debug(oACETWSCalloutResult);                
            }else{
               oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;        
            }
            
                
            
        }catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;
        }
        
        return oACETWSCalloutResult;    
    
    }
    
    
    public ACETWSCalloutResult FindProducers(String producerSSN,String producerTaxID,String producerID, String companyName,string groupNumber, String LastName, String FirstName, String State,
                        String SortBy, String SortOrder, String FilterBy, String producerFlag)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProducerSearchResult> producersSearchResult;     
        List<ACETFindProducersAdaptJSON2Apex.FindProducerResponse> SRProducers;  
        ACETProducerSearchResult Producer;
        
        try
        {
            GetEndpoint();
            
            getAdapterReqBody(producerSSN,producerTaxID,producerID,companyName,groupNumber,LastName, FirstName, State, FilterBy, producerFlag); 
            system.debug('RequestBody --->'+RequestBody );
            HttpResponse Response = Send(OAuthConfig);
            system.debug('**OAuthConfig.response'+response+'----Body----'+response.getBody());
             //Response.setStatusCode(005);
             ACETFindProducersAdaptJSON2Apex ACTFPJSON2Apex;
            if (Response.getStatusCode() == 200)
            {
                if(response.getBody() != null){
                  
                   String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    system.debug('**responseBody in find group ==>'+responseBody);
                    
                    ACTFPJSON2Apex = (ACETFindProducersAdaptJSON2Apex)JSON.deserialize(responseBody, ACETFindProducersAdaptJSON2Apex.class);
                    system.debug('**ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                    
                    producersSearchResult= new List<ACETProducerSearchResult>(); 
                    SRProducers = ACTFPJSON2Apex.response.FindProducerResponse;
                    system.debug('**SRProducers :----> ' + SRProducers );
                    if(SRProducers != Null)
                    {
                        for (ACETFindProducersAdaptJSON2Apex.FindProducerResponse producers: SRProducers){
                            Producer = new ACETProducerSearchResult();
                            Producer.ProducerID = (producers.producerId != null)?producers.producerId:'';
                            Producer.CompanyName = (producers.producerCompanyName != null)?producers.producerCompanyName:'';
                            Producer.Status = (producers.producerStatus != null)?producers.producerStatus:'';
                            Producer.LastName = (producers.producerName.lastName != null)?producers.producerName.lastName:'';
                            Producer.FirstName = (producers.producerName.firstName != null)?producers.producerName.firstName:'';
                            Producer.MiddleInitial = (producers.producerName.middleInitial != null)?producers.producerName.middleInitial:'';
                            if(String.ISNOTBLANK(Producer.LastName))
                            {
                                Producer.hasName = true;
                                Producer.Name = Producer.FirstName;
                                if(Producer.MiddleInitial != null && Producer.MiddleInitial != ''){
                                   Producer.Name = Producer.Name + ' '+Producer.MiddleInitial;
                                }
                                Producer.Name = Producer.Name +' ' +Producer.LastName ;
                            }else if(String.ISNOTBLANK(Producer.CompanyName)){
                                Producer.hasName = false;
                                Producer.Name = Producer.CompanyName;
                            }
                            Producer.ProducerType = (producers.producerType != null)?producers.producerType:'';
                            Producer.producerMemberGrpStartDate = producers.memberGroupDetails[0].producerMemberGrpStartDate;
                            Producer.producerMemberGrpEndDate = producers.memberGroupDetails[0].producerMemberGrpEndDate;
                            Producer.producerContact = (producers.producerContact != null)?producers.producerContact:'';
                            Producer.producerState  = (producers.producerState != null)?producers.producerState:'';
                            Producer.producerCity = (producers.producerCity != null)?producers.producerCity:'';
                            //US911732 start
                            if(!(producers.producerPhoneNumber.contains('-')) && producers.producerPhoneNumber != null && producers.producerPhoneNumber != ''){
                                if(producers.producerPhoneNumber.length() == 10){
                                    producers.producerPhoneNumber = producers.producerPhoneNumber.substring(0,3) + '-' + producers.producerPhoneNumber.substring(3,6) + '-' + producers.producerPhoneNumber.substring(6,10);
                                } else if(producers.producerPhoneNumber.length() == 11){
                                    producers.producerPhoneNumber = producers.producerPhoneNumber.substring(0,1) + '-' + producers.producerPhoneNumber.substring(1,4) + '-' + producers.producerPhoneNumber.substring(4,7) + '-' + producers.producerPhoneNumber.substring(7,11);
                                }
                            }
                            //US911732 end
                            Producer.producerPhoneNumber = (producers.producerPhoneNumber != null)?producers.producerPhoneNumber:'';
                            Producer.producerEffectiveAsOfDate = (producers.producerEffectiveAsOfDate != null)?producers.producerEffectiveAsOfDate:'';
                            Producer.producerLegacyBrokerCode  = (producers.legacyBrokerCode != null)?producers.legacyBrokerCode:'';
                            producer.producerUnMaskedSSN = (producers.producerSSN != null || producers.producerSSN != '')?producers.producerSSN:'';
                            /*if(Producer.ProducerType == 'B')
                            {
                                Producer.producerTIN = (producers.producerTIN != null || producers.producerTIN != '')?producers.producerTIN:'';
                            }
                            else if(Producer.ProducerType == 'I')
                            {
                                Producer.producerTIN = (producers.producerSSN != null || producers.producerSSN != '')?getMaskedSSN(producers.producerSSN):'';
                            }
                            else
                            {
                                Producer.producerTIN = '';
                            }*/
                            //US911732 start
                            if(!(producers.producerTIN.contains('-')) && producers.producerTIN != null && producers.producerTIN != ''){
                                producers.producerTIN = producers.producerTIN.substring(0,2) + '-' + producers.producerTIN.substring(2,producers.producerTIN.length());
                            }
                            if(!(producers.producerSSN.contains('-')) && producers.producerSSN != null && producers.producerSSN != ''){
                                producers.producerSSN = producers.producerSSN.substring(0,3) + '-' + producers.producerSSN.substring(3,5) + '-' + producers.producerSSN.substring(5,9);
                            }
                            //US911732 end
                            Producer.producerSSN = (producers.producerSSN != null || producers.producerSSN != '')?producers.producerSSN:'';
                            Producer.producerTIN = (producers.producerTIN != null || producers.producerTIN != '')?producers.producerTIN:'';
                            Producer.coverageType = (producers.coverageType != null || producers.coverageType != '')?producers.coverageType:'';
                            Producer.producerRoleType = (producers.producerRoleType!= null || producers.producerRoleType!= '')?producers.producerRoleType:'';
                            Producer.producerRole = (producers.producerRole != null || producers.producerRole != '')?producers.producerRole:'';
                            Producer.producerServiceRightsOnly = (producers.producerServiceRightsOnly != null || producers.producerServiceRightsOnly != '')?producers.producerServiceRightsOnly:'';
                            Producer.producerCRID = (producers.producerCRID != null || producers.producerCRID != '')?producers.producerCRID:'';
                            Producer.producerSplitPercent = (producers.producerSplitPercent != null || producers.producerSplitPercent != '')?producers.producerSplitPercent:'';
                            Producer.producerStreetLine1 = (producers.producerStreetLine1 != null || producers.producerStreetLine1 != '')?producers.producerStreetLine1:'';
                            Producer.producerStreetLine2 = (producers.producerStreetLine2 != null || producers.producerStreetLine2 != '')?producers.producerStreetLine2:'';
                            Producer.producerZipCode = (producers.producerZipCode != null || producers.producerZipCode != '')?producers.producerZipCode :'';
                            Producer.producerZipCodeSuffix = (producers.producerZipCodeSuffix != null || producers.producerZipCodeSuffix != '')?producers.producerZipCodeSuffix:'';                
                            producersSearchResult.add(Producer);
                        }
                    }else
                    { 
                        oACETWSCalloutResult.Message = 'Search criteria returned no matches.';
                        oACETWSCalloutResult.Response = new List<ACETProducerSearchResult>();
                        oACETWSCalloutResult.pageNumber = '0'; 
                        oACETWSCalloutResult.pageSize = '0';
                        oACETWSCalloutResult.recordCount = '0';
                        oACETWSCalloutResult.totalCount = '0';
                        oACETWSCalloutResult.statusCode = Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode);
                        if(Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode)==404){                        
                         oACETWSCalloutResult.Success = true;
                        }else{
                         oACETWSCalloutResult.Success = false;
                        }
                    }
                        
                }     
            }
            else if(response.getStatusCode() == 500){
                
                //currently servce returns 500 if no records found
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                oACETWSCalloutResult.Success = false;                
                oACETWSCalloutResult.Response = new List<ACETProducerSearchResult>();
                oACETWSCalloutResult.pageNumber = '0'; 
                oACETWSCalloutResult.pageSize = '0';
                oACETWSCalloutResult.recordCount = '0';
                oACETWSCalloutResult.totalCount = '0';
                oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
                system.debug(oACETWSCalloutResult);                
            } else if(response.getStatusCode() == 404){
                oACETWSCalloutResult.Success = true;                
                oACETWSCalloutResult.Response = new List<ACETProducerSearchResult>();
                oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            }
            else{
               oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;        
            }

            if (producersSearchResult != null && producersSearchResult.size()>0)
            {
                ACETProducerSearchResult.SortBy = SortBy;
                ACETProducerSearchResult.SortOrder = SortOrder;
                producersSearchResult.Sort();
                
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = producersSearchResult;
            }else
            {
                oACETWSCalloutResult.Message = 'Search criteria returned no matches.';
                oACETWSCalloutResult.Response = new List<ACETProducerSearchResult>();
                oACETWSCalloutResult.pageNumber = '0'; 
                oACETWSCalloutResult.pageSize = '0';
                oACETWSCalloutResult.recordCount = '0';
                oACETWSCalloutResult.totalCount = '0';
                oACETWSCalloutResult.statusCode = Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode);
                 if(Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode)==404){                        
                      oACETWSCalloutResult.Success = true;
                   }else{
                      oACETWSCalloutResult.Success = false;
                   }
            }   
            
        }catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;
        }
        
        return oACETWSCalloutResult;
    }  
                        
    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';
        
        return 'xxx-xx-' + ssn.substring(ssn.length() - 4);
    } 
    
      public String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        if(s[0].length() == 1){
            newDate = '0'+s[0];
        }else{
            newDate = s[0];
        }
        newDate = newDate+'/'+s[1]+'/'+s[2];
        return newDate;
    }
       
}