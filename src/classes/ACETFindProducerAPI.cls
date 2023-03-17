/* Class Name:ACETFindProducerAPI
* Author:Chandan
* Created Date: 04/15/2021
* Description: API Class to FindProducerAPI
**/
public with sharing class ACETFindProducerAPI{
    
    public String RequestBody;
    public string p_ProducerID;
    public string p_ProducerSSN;
    public string p_ProducerTIN;
    public string p_FirstName;
    public string p_MiddleInitial;
    public string p_LastName;
    public string p_CompanyName;
	public string p_State;
    public string p_Status;
    public string p_legacyProducerSystem;
    public string p_legacyProducerId;
    public string p_customerNumber;
    public string p_customerName;
    public string p_producerFlag;
    public string p_groupNumber;
    public string p_adminSystem;
    
    public string p_SortBy;
    public string p_SortOrder;
    public string p_FilterBy;
    public string currentDate = cleanDate(ACETUtility.format(Date.today())); //'01/31/2019';
    
    public void init(String producerID,String producerSSN, String producerTIN, String firstName, String middleInitial, 
                                   String lastName,  String companyName, String State, String status, string groupNumber, 
                                   String legacyProducerSystem,  String legacyProducerID, String customerNumber, String customerName,
                                   String adminSystem){ 
    
               	    
            p_ProducerID = producerID;
            p_ProducerSSN = producerSSN;
            p_ProducerTIN = producerTIN;
            p_FirstName = firstName;
            p_MiddleInitial = middleInitial;
            p_LastName = lastName;
            p_CompanyName = companyName;
            p_State = State;
            p_Status = status;
            p_legacyProducerSystem = legacyProducerSystem;
            p_legacyProducerId = legacyProducerId;
            p_customerNumber = customerNumber;
            p_customerName = customerName;
            p_adminSystem = adminSystem;  
            p_groupNumber = groupNumber;
                                      
    }
        
    
    private String getAdapterReqBody(String producerSSN,String producerTIN,String producerID, String companyName,string groupNumber, 
                           				String LastName, String FirstName, String State,String SortBy, String SortOrder, String FilterBy, 
                                     		String producerFlag)
    {
        
        ACETFindProducerRequestDetail findProducerReq = new ACETFindProducerRequestDetail();
        ACETFindProducerRequestDetail.ServiceAttributes service = new ACETFindProducerRequestDetail.ServiceAttributes();
        ACETFindProducerRequestDetail.FindProducerRequest findProducer=new ACETFindProducerRequestDetail.FindProducerRequest();
        
        service.applicationIdentifier='ACET';
        service.requestIdentifier='';
        service.requestedDate=currentDate;
        service.producerGroupAssociation = !(groupNumber != Null && groupNumber != '')?'':
                                                producerFlag=='0'?'past':
                                                producerFlag=='1'?'present':
                                                'future';
        service.producerAndGroupFlag='N';
        service.pageNumber= '1';
	    service.recordsPerPage= '100';        
        
        if(!(groupNumber != Null && groupNumber != '')){
            findProducer.producerID = groupNumber != Null && groupNumber != ''?null:producerID != null && producerID.isNumeric()?producerID:'';
            findProducer.producerSSN = p_ProducerSSN;
            findProducer.producerTIN = p_ProducerTIN;
            findProducer.producerFirstName = p_FirstName;
            findProducer.producerMiddleInitial = p_MiddleInitial;
            findProducer.producerLastName = p_LastName;
            findProducer.producerCompanyName = p_CompanyName;
            findProducer.producerState = p_State;
            findProducer.producerStatus = p_Status;
            findProducer.legacyProducerSystem = p_legacyProducerSystem;
            findProducer.legacyProducerId = p_legacyProducerId;
            findProducer.customerNumber = p_customerNumber;
            findProducer.customerName = p_customerName;
            findProducer.adminSystem = p_adminSystem;
            findProducer.memberGroupNumber = p_groupNumber;
            RequestBody = findProducerReq.addSearchInput(service,findProducer);
        }
        else{
        RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"'+service.producerGroupAssociation+'","producerAndGroupFlag":"Y","pageNumber":"1","recordsPerPage":"50"},"findProducerRequest":{"customerNumber":"'+groupNumber+'"}}}';
        }
        System.debug('Find Producer API Request1='+RequestBody);
        return RequestBody;
    }
    
    public string GetRequestBody()
    {
    
        ACETFindProducerRequestDetail findProducerReq = new ACETFindProducerRequestDetail();
        ACETFindProducerRequestDetail.ServiceAttributes service = new ACETFindProducerRequestDetail.ServiceAttributes();
        ACETFindProducerRequestDetail.FindProducerRequest findProducer=new ACETFindProducerRequestDetail.FindProducerRequest();
        
        service.applicationIdentifier='ACET';
        service.requestIdentifier='';
        service.requestedDate=cleanDate(ACETUtility.format(Date.today()));
        service.producerGroupAssociation = '';
        service.producerAndGroupFlag='N';
        service.pageNumber= '1';
	    service.recordsPerPage= '100';        
             
        findProducer.producerID= p_ProducerID;
        findProducer.producerSSN= p_producerSSN;
        findProducer.producerTIN= p_ProducerTIN;
        findProducer.producerFirstName= p_firstName;
        findProducer.producerMiddleInitial= p_middleInitial;
        findProducer.producerLastName= p_lastName;
        findProducer.producerCompanyName= p_companyName;
        findProducer.producerState= p_state;
        findProducer.producerStatus= p_status;
        findProducer.legacyProducerSystem= p_legacyProducerSystem;
        findProducer.legacyProducerId= p_legacyProducerId;
        findProducer.customerNumber= p_customerNumber;
        findProducer.customerName= p_customerName;
        findProducer.adminSystem=p_adminSystem;
  
        RequestBody = findProducerReq.addSearchInput(service,findProducer);
        System.debug('Find Producer API Request='+RequestBody);
        return RequestBody;
    }
        
    public ACETWSCalloutResult FindProducerDetail(String producerSSN,String producerTIN,String producerID, String companyName,
                                                  	String groupNumber, String LastName, String FirstName, String State,
                        								String SortBy, String SortOrder, String FilterBy, String producerFlag){ 
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        List<ACETProducerSearchResult> producersSearchResult;     
        List<ACETFindProducerResponseDetail.FindProducerResponse> SRProducers;
        ACETProducerSearchResult Producer;
		String responseStr;
       	try{
         	RequestBody = getAdapterReqBody(producerSSN, producerTIN, producerID, companyName, groupNumber, LastName, FirstName, 
                                                        State, SortBy, SortOrder, FilterBy, producerFlag); 
            system.debug('RequestBody --->'+RequestBody );
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ACETFindProducerAPI',RequestBody,null);
            HttpResponse httpRes  = wsCallOutFW.getResponse();
            system.debug('**OAuthConfig.response'+responseStr);
            calloutResult.statusCode=httpRes != null? httpRes.getStatusCode():null;
            responseStr = httpRes!=null?httpRes.getBody():'';
            system.debug('Find Producer API---responseStr---'+responseStr);
            if(responseStr!=null && String.isNotBlank(responseStr) && calloutResult.statusCode!=null && calloutResult.statusCode==200){ 
                ACETFindProducerResponseDetail JSON2Apex = ACETFindProducerResponseDetail.parse(responseStr);
                system.debug('Find Producer API----22--'+json2Apex);
                
                if(json2Apex.response!=null){
                    String responseBody = httpRes.getBody().replace('\"date\":', '\"date2\":');
                    system.debug('**responseBody in find group ==>'+responseBody);
                    
                    ACETFindProducerResponseDetail ACTFPJSON2Apex = (ACETFindProducerResponseDetail)JSON.deserialize(responseBody, ACETFindProducerResponseDetail.class);
                    system.debug('**ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                    
                  	producersSearchResult= new List<ACETProducerSearchResult>(); 
                    SRProducers = ACTFPJSON2Apex.response.FindProducerResponse;
                    system.debug('**JSON2Apex :----> ' + JSON2Apex );
                    system.debug('**SRProducers :----> ' + SRProducers );
                        //Logic need to be developed here
                        calloutResult.Success =true;
                        calloutResult.Message ='';
                        calloutResult.MessageSeverity=ApexPages.Severity.Info; 
                        calloutResult.Response=JSON2Apex.response;
                     if(SRProducers != Null)
                    {
                        for (ACETFindProducerResponseDetail.FindProducerResponse producers: SRProducers){
                            if(producers !=null){
                            Producer = new ACETProducerSearchResult();
                            Producer.ProducerID = (producers.producerId != null)?producers.producerId:'';
                            Producer.CompanyName = (producers.producerCompanyName != null)?producers.producerCompanyName:'';
                            Producer.Status = (producers.producerStatus != null)?producers.producerStatus:'';
                            Producer.LastName = (producers.ProducerIndividualName.lastName != null)?producers.ProducerIndividualName.lastName:'';
                            Producer.FirstName = (producers.ProducerIndividualName.firstName != null)?producers.ProducerIndividualName.firstName:'';
                            Producer.MiddleInitial = (producers.ProducerIndividualName.middleInitial != null)?producers.ProducerIndividualName.middleInitial:'';
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
                            Producer.ProducerType = (producers.producerType != null && producers.producerType != '')?
                                					producers.producerType:'';
                            Producer.producerContact = (producers.producerContact != null && producers.producerContact != '')?
                                					   producers.producerContact:'';
                            Producer.producerState  = (producers.producerAddress.producerState != null && producers.producerAddress.producerState != '')?
                                					 producers.producerAddress.producerState:'';
                            Producer.producerCity = (producers.producerAddress.producerCity != null && producers.producerAddress.producerCity != '')?
                                					 producers.producerAddress.producerCity:'';
                            //US911732 start
                            if(!(producers.producerAddress.producerPhoneNumber.contains('-')) && producers.producerAddress.producerPhoneNumber != null && producers.producerAddress.producerPhoneNumber != ''){
                                if(producers.producerAddress.producerPhoneNumber.length() == 10){
                                    producers.producerAddress.producerPhoneNumber = producers.producerAddress.producerPhoneNumber.substring(0,3) + '-' + producers.producerAddress.producerPhoneNumber.substring(3,6) + '-' + producers.producerAddress.producerPhoneNumber.substring(6,10);
                                } else if(producers.producerAddress.producerPhoneNumber.length() == 11){
                                    producers.producerAddress.producerPhoneNumber = producers.producerAddress.producerPhoneNumber.substring(0,1) + '-' + producers.producerAddress.producerPhoneNumber.substring(1,4) + '-' + producers.producerAddress.producerPhoneNumber.substring(4,7) + '-' + producers.producerAddress.producerPhoneNumber.substring(7,11);
                                }
                            }
                            //US911732 end
                            Producer.producerPhoneNumber = (String.isNotBlank(producers.producerAddress.producerPhoneNumber) && producers.producerAddress.producerPhoneNumber != null && producers.producerAddress.producerPhoneNumber != '')?
                                							producers.producerAddress.producerPhoneNumber:'';
                            if(String.isNotBlank(producers.producerEffectiveStartDate) && producers.producerEffectiveStartDate != null && producers.producerEffectiveStartDate != '')
                                 							Producer.producerEffectiveAsOfDate = producers.producerEffectiveStartDate;
                            else 
                            Producer.producerEffectiveAsOfDate = '';
                            
                            Producer.producerLegacySystem  = (producers.legacyProducers.size()>0 && producers.legacyProducers[0].legacyProducerSystem != null && producers.legacyProducers[0].legacyProducerSystem != '')?
                                							producers.legacyProducers[0].legacyProducerSystem:'';
                            Producer.producerLegacyId = (producers.legacyProducers.size()>0 && producers.legacyProducers[0].legacyProducerId != null && producers.legacyProducers[0].legacyProducerId != '')?
                                						 producers.legacyProducers[0].legacyProducerId:'';
                            
                            Producer.customerNumber = (producers.customerDetails.size()>0 && producers.customerDetails[0].customerNumber != null && producers.customerDetails[0].customerNumber != '')?
                                					producers.customerDetails[0].customerNumber:'';
                            Producer.customerName = (producers.customerDetails.size()>0 && producers.customerDetails[0].customerName != null && producers.customerDetails[0].customerName != '')?
                                					producers.customerDetails[0].customerName:'';
                            Producer.adminSystem = (producers.customerDetails.size()>0 && producers.customerDetails[0].adminSystem != null && producers.customerDetails[0].adminSystem != '')?
                                					producers.customerDetails[0].adminSystem:'';
                            Producer.producerMemberGrpStartDate = (producers.customerDetails!=null && producers.customerDetails.size()>0 && producers.customerDetails[0].producerCustomerStartDate != null &&
                                                                  producers.customerDetails[0].producerCustomerStartDate !='')?
                                									producers.customerDetails[0].producerCustomerStartDate:'';
                            Producer.producerMemberGrpEndDate = (producers.customerDetails!=null && producers.customerDetails.size()>0 && producers.customerDetails[0].producerCustomerEndDate != null && 
                                                                producers.customerDetails[0].producerCustomerEndDate != '')?
                                								producers.customerDetails[0].producerCustomerEndDate:'';       
                            producer.producerUnMaskedSSN = (producers.producerSSN != null && producers.producerSSN != '')?producers.producerSSN:'';
                           
                            if(!(producers.producerTIN.contains('-')) && producers.producerTIN != null && producers.producerTIN != ''){
                                producers.producerTIN = producers.producerTIN.substring(0,2) + '-' + producers.producerTIN.substring(2,producers.producerTIN.length());
                            }
                            if(!(producers.producerSSN.contains('-')) && producers.producerSSN != null && producers.producerSSN != ''){
                                producers.producerSSN = producers.producerSSN.substring(0,3) + '-' + producers.producerSSN.substring(3,5) + '-' + producers.producerSSN.substring(5,9);
                            }
                            //US911732 end
                            Producer.producerSSN = (producers.producerSSN != null && producers.producerSSN != '')?producers.producerSSN:'';
                            Producer.producerTIN = (producers.producerTIN != null && producers.producerTIN != '')?producers.producerTIN:'';
                            Producer.coverageType = (producers.coverageType != null && producers.coverageType != '')?producers.coverageType:'';
                            Producer.producerRoleType = (producers.producerRoleType!= null && producers.producerRoleType!= '')?producers.producerRoleType:'';
                            Producer.producerRole = (producers.producerRole != null && producers.producerRole != '')?producers.producerRole:'';
                            Producer.producerServiceRightsOnly = (producers.producerServiceRightsOnly != null && producers.producerServiceRightsOnly != '')?producers.producerServiceRightsOnly:'';
                            Producer.producerCRID = (producers.producerCRID != null && producers.producerCRID != '')?producers.producerCRID:'';
                            Producer.producerSplitPercent = (producers.producerSplitPercent != null && producers.producerSplitPercent != '')?producers.producerSplitPercent:'';
                            Producer.producerStreetLine1 = (producers.producerAddress.producerStreetLine1 != null && producers.producerAddress.producerStreetLine1 != '')?producers.producerAddress.producerStreetLine1:'';
                            Producer.producerStreetLine2 = (producers.producerAddress.producerStreetLine2 != null && producers.producerAddress.producerStreetLine2 != '')?producers.producerAddress.producerStreetLine2:'';
                            Producer.producerZipCode = (producers.producerAddress.producerZipCode != null && producers.producerAddress.producerZipCode != '')?producers.producerAddress.producerZipCode :'';
                            Producer.producerZipCodeSuffix = (producers.producerAddress.producerZipCodeSuffix != null && producers.producerAddress.producerZipCodeSuffix != '')?producers.producerAddress.producerZipCodeSuffix:'';                
                            
                            producersSearchResult.add(Producer);
                            }
                        }
                         calloutResult.Response = producersSearchResult;
                        }
                    else
                    { 
                            calloutResult.Message = 'Search criteria returned no matches.';
                            calloutResult.Response = new List<ACETProducerSearchResult>();
                            calloutResult.pageNumber = '0'; 
                            calloutResult.pageSize = '0';
                            calloutResult.recordCount = '0';
                            calloutResult.totalCount = '0';
                            calloutResult.statusCode = Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode);
                        if(Integer.valueOf(ACTFPJSON2Apex.response.serviceAttributes.responseCode)==404){                        
                     		calloutResult.Success = true;
                        }else{
                         	calloutResult.Success = false;
                        }
                    }
                    }
                else{
                    system.debug('Find Producer API----response OR findProducerResponse is null');
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message =ACETUtility.getErrorMessage('GN500');
                    //calloutResult.statusCode = 999;
                }
            }
            else{
                 calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                 calloutResult.Success = false;
                 if(calloutResult.statusCode!=null && calloutResult.statusCode ==400)
                      calloutResult.Message =ACETUtility.getErrorMessage('GN400');//+mes.description 
                 else if(calloutResult.statusCode!=null && calloutResult.statusCode == 404)
                      calloutResult.Message = ACETUtility.getErrorMessage('GN404');//+mes.description
                 else if(calloutResult.statusCode!=null && calloutResult.statusCode ==500)
                      calloutResult.Message =ACETUtility.getErrorMessage('GN500');//+mes.description 
                 else if(calloutResult.statusCode!=null)
                      calloutResult.Message =ACETUtility.getErrorMessage('GN500');//+mes.description; 
                 else{
                      calloutResult.Message =ACETUtility.getErrorMessage('GN500');
                      calloutResult.statusCode = 999;
                      }
                        
               }
                
            
        }catch(Exception e){
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN500');
            calloutResult.statusCode=999;
        }
        System.debug('calloutResult.Message='+calloutResult.Message);
        System.debug('calloutResult.statusCode='+calloutResult.statusCode);
        System.debug('calloutResult.MessageSeverity='+calloutResult.MessageSeverity);
        return calloutResult;
    }
    
    
     public ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){  
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
         try{
        List<ACETProducerSearchResult> producersSearchResult;     
        List<ACETFindProducerResponseDetail.FindProducerResponse> SRProducers;  
        ACETProducerSearchResult producer;
        {
            RequestBody = getAdapterReqBody(p_producerSSN,p_ProducerTIN,p_producerID,p_companyName,p_groupNumber,p_LastName, p_FirstName, p_State, p_SortBy, p_SortOrder,p_FilterBy, p_producerFlag);
            RequestBody = RequestBody.replace('"pageNumber": "1"','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"pageSize": "1"','"pageSize": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": "1"','"startRecord": "' + startRecord + '"');
			system.debug('RequestBody --->'+RequestBody );	
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ACETFindProducerAPI',RequestBody,null);
            HttpResponse response  = wsCallOutFW.getResponse();
            system.debug('**OAuthConfig.response'+response);
            oACETWSCalloutResult.statusCode=response!=null? response.getStatusCode():null;
            
            if (Response.getStatusCode() == 200)
            {
                if(response.getBody() != null){
                  
                   String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    system.debug('**responseBody in find group ==>'+responseBody);
                    
                    ACETFindProducerResponseDetail ACTFPJSON2Apex = (ACETFindProducerResponseDetail)JSON.deserialize(responseBody, ACETFindProducerResponseDetail.class);
                    system.debug('**ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                    system.debug('**Response code: ' + ACTFPJSON2Apex.response.serviceAttributes.responseCode);
                    
                    producersSearchResult= new List<ACETProducerSearchResult>(); 
                    SRProducers = ACTFPJSON2Apex.response.FindProducerResponse;
                    system.debug('**SRProducers :----> ' + SRProducers );
                    if(SRProducers != Null)
                    {
                        for (ACETFindProducerResponseDetail.FindProducerResponse producers: SRProducers){
                            Producer = new ACETProducerSearchResult();
                            Producer.ProducerID = (producers.producerId != null && producers.producerId != '')?producers.producerId:'';
                            Producer.CompanyName = (producers.producerCompanyName != null || producers.producerCompanyName != '')?producers.producerCompanyName:'';
                            Producer.LastName = (producers.ProducerIndividualName.lastName != null || producers.ProducerIndividualName.lastName != '')?producers.ProducerIndividualName.lastName:'';
                            Producer.FirstName = (producers.ProducerIndividualName.firstName != null || producers.ProducerIndividualName.firstName != '')?producers.ProducerIndividualName.firstName:'';
                            Producer.MiddleInitial = (producers.ProducerIndividualName.middleInitial != null || producers.ProducerIndividualName.middleInitial != '')?producers.ProducerIndividualName.middleInitial:'';
                            Producer.ProducerType = (producers.producerType != null || producers.producerType != '')?producers.producerType:'';
                            Producer.producerContact = (producers.producerContact != null || producers.producerContact != '')?producers.producerContact:'';
                            Producer.producerState  = (producers.producerAddress.producerState != null || producers.producerAddress.producerState != '')?producers.producerAddress.producerState:'';
                            Producer.producerCity = (producers.producerAddress.producerCity != null || producers.producerAddress.producerCity != '')?producers.producerAddress.producerCity:'';
                            Producer.producerPhoneNumber = (producers.producerAddress.producerPhoneNumber != null || producers.producerAddress.producerPhoneNumber != '')?producers.producerAddress.producerPhoneNumber:'';
                            
                            if(String.isNotBlank(producers.producerEffectiveStartDate) && producers.producerEffectiveStartDate != null && producers.producerEffectiveStartDate != ''){
                                 Producer.producerEffectiveAsOfDate = producers.producerEffectiveStartDate;
                            }
                            
                            if(producers.memberGroupDetails!=null && producers.memberGroupDetails.size()>0 && producers.memberGroupDetails[0].producerMemberGrpStartDate != null && producers.memberGroupDetails[0].producerMemberGrpStartDate !=''){
                            Producer.producerMemberGrpStartDate = producers.memberGroupDetails[0].producerMemberGrpStartDate;
                            }
                            if(producers.memberGroupDetails!=null && producers.memberGroupDetails.size()>0 && producers.memberGroupDetails[0].producerMemberGrpEndDate != null && producers.memberGroupDetails[0].producerMemberGrpEndDate !=''){
                            Producer.producerMemberGrpEndDate = producers.memberGroupDetails[0].producerMemberGrpEndDate;
                            }
                            
                            if(producers.legacyProducers!=null && producers.legacyProducers.size() > 0){
                              	Producer.producerLegacySystem  = (producers.legacyProducers[0].legacyProducerSystem != null)?producers.legacyProducers[0].legacyProducerSystem:'';
                            	Producer.producerLegacyId = (producers.legacyProducers[0].legacyProducerId != null )?producers.legacyProducers[0].legacyProducerId:'';    
                            }
                            
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
        String newMonth= '';
        if(s[0].length() == 1){
            newDate = '0'+s[0];
        }else{
            newDate = s[0];
        }
        if(s[1].length() == 1){
            newMonth = '0'+s[1];
        }else{
            newMonth = s[1];
        }
        newDate = newDate+'/'+newMonth+'/'+s[2];
        return newDate;
    }
}