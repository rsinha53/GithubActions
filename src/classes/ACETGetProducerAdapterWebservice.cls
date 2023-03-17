public class ACETGetProducerAdapterWebservice extends ACETWebservice
{
    public ACETProducerResult producerDetailresult { get; set;}
    public List<ACETProducerResult.ACETProducerDemography> addressDemographics { set; get;}
    private string currentDate;
    public string flag {get; set;}
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('GetProducerEndpoint');
    }
    public ACETGetProducerAdapterWebservice()
    {
        super('Stargate');
    }
    private void GetRequestBody(String ProducerId, String flagstatus)
    {
       currentDate =  cleanDate(ACETUtility.format(Date.today()));
       system.debug('Date value'+currentDate);

        RequestBody = '{"request": {'+
                            '"serviceAttributes": {'+
                                    '"applicationIdentifier": "ACET",'+
                                    '"requestIdentifier": "74a0a206-7fbb-4568-ad39-5de31abb6db3",'+
                                    '"producerGroupAssociation":"'+flagstatus+'",'+
                                    '"pageNumber": "1",'+
                                    '"recordsPerPage": "50"'+
                             '},'+
                              '"getProducerRequest": {'+
                                 '"producerID":"'+ProducerId+'",'+
                                 '"memberGroupNumber": "",'+ 
                                 '"producerEffectiveAsofdate":"'+currentDate+'",'+   //'+currentDate+'
                                 '"legacyBrokerCode": ""'+
                            '}'+
                            '}}';
        System.debug('Request Body Json'+RequestBody);                       
    }
    
    public ACETProducerResult parseSuccessAdapterResponse(String ResponseBody)
    {
        producerDetailresult = new ACETProducerResult(); 
        producerDetailresult.addressInfo= new ACETProducerResult.ACETProducerDemography();
        producerDetailresult.addresslist = new  list<ACETProducerResult.ACETProducerDemography>();
        producerDetailresult.producerGrouplist = new  list<ACETProducerResult.ACETGroupInfoWrapper>();
        ACETGetProducerAdapterJSON2Apex.cls_getProducerResponse PDDetails; 
        ACETGetProducerAdapterJSON2Apex ACTGPJSON2Apex = (ACETGetProducerAdapterJSON2Apex)JSON.deserialize(ResponseBody, ACETGetProducerAdapterJSON2Apex.class);
        PDDetails = ACTGPJSON2Apex.response.getProducerResponse;
        generalProducerMapping(PDDetails);
        producerGroupMapping(PDDetails);// Added by Harish for US705141
        return producerDetailresult;
    } 
    
    private void producerGroupMapping(ACETGetProducerAdapterJSON2Apex.cls_getProducerResponse PDDetails)
    {
      try{
           if(PDDetails.memberGroupDetails != null)
           {
                producerDetailresult.producerGrouplist = new  list<ACETProducerResult.ACETGroupInfoWrapper>();                
                system.debug('Group Address information'+PDDetails.memberGroupDetails);
                for(ACETGetProducerAdapterJSON2Apex.cls_memberGroupDetails producerGroupAddress :PDDetails.memberGroupDetails)
                {   
                    ACETProducerResult.ACETGroupInfoWrapper pGroupaddress = new ACETProducerResult.ACETGroupInfoWrapper();             
                    pGroupaddress.groupNumber = (producerGroupAddress.groupNumber != null)?producerGroupAddress.groupNumber:'';
                    pGroupaddress.groupName = (producerGroupAddress.groupName != null)?producerGroupAddress.groupName:'';
                    pGroupaddress.status = (flag != null && flag=='present')?'Active':(flag != null && flag=='future')?'Future':(flag != null && flag=='past')?'InActive':'';
                    producerDetailresult.producerGrouplist.add(pGroupaddress);
                }
           } 
      }catch(Exception ex){
                  system.debug(LoggingLevel.INFO, 'Issues in general producer detail' + ex);                 
                }
    }
    
      private void generalProducerMapping(ACETGetProducerAdapterJSON2Apex.cls_getProducerResponse PDDetails)
      {
        try{
        system.debug('response for getproducers======='+PDDetails);
        if(PDDetails != null)
        {
                        producerDetailresult = new ACETProducerResult();                                             
                        producerDetailresult.ProducerID = (PDDetails.producerID != null)?PDDetails.producerID:'';
                        producerDetailresult.CompanyName =(PDDetails.producerCompanyName != null)?PDDetails.producerCompanyName:'';
                        producerDetailresult.LastName =(PDDetails.producerName.lastName != null)?PDDetails.producerName.lastName:'';
                        producerDetailresult.FirstName =(PDDetails.producerName.firstName != null)?PDDetails.producerName.firstName:'';
                        producerDetailresult.MiddleInitial =(PDDetails.producerName.middleInitial != null)?PDDetails.producerName.middleInitial:'';
                        producerDetailresult.legacyBrokerCode =( PDDetails.legacyBrokerCode != null)?PDDetails.legacyBrokerCode:''; 
                        producerDetailresult.primaryContactName =(PDDetails.producerContact != null)?PDDetails.producerContact:''; 
                        producerDetailresult.tax_SSN = (PDDetails.producerSSN != null)?PDDetails.producerSSN:'';
                        system.debug('typeeeeeeeeeeeeeeeeeeeee==='+PDDetails.etype); 
                        producerDetailresult.type = (PDDetails.etype != null)?PDDetails.etype:'';                          
                        producerDetailresult.tax_id = (PDDetails.producerTIN != null)?PDDetails.producerTIN:'';
                        producerDetailresult.ProducerType =(PDDetails.producerType != null)?PDDetails.producerType:'';
                        producerDetailresult.producerEffectiveStartDate =(PDDetails.producerEffectiveStartDate != null)?PDDetails.producerEffectiveStartDate :'';
                        producerDetailresult.producerEffectiveEndDate =(PDDetails.producerEffectiveEndDate != null)?PDDetails.producerEffectiveEndDate :'';
          
                        if(PDDetails.producerType != null)
                        {
                           if(PDDetails.producerType == 'I ')
                           {
                               producerDetailresult.taxSSNType = 'SSN';                          
                           }
                           else if(PDDetails.producerType == 'B ')
                           {
                               producerDetailresult.taxSSNType = 'TIN';
                           }
                        }
                        else
                        {
                           producerDetailresult.taxSSNType = '';
                        }
                                               
        }
        
        if(PDDetails.producerAddress != null)
        {
          
           ACETGetProducerAdapterJSON2Apex.cls_producerAddress demographics  = new ACETGetProducerAdapterJSON2Apex.cls_producerAddress();
           demographics = PDDetails.producerAddress;
           system.debug('Producer Address======'+demographics);
            producerDetailresult.addresslist = new  list<ACETProducerResult.ACETProducerDemography>();
                ACETProducerResult.ACETProducerDemography address = new ACETProducerResult.ACETProducerDemography();
                address.addressType = (demographics.addressTypeCode != null)?demographics.addressTypeCode:'';
                address.streetAddress = ((demographics.addressLine1 != null)?demographics.addressLine1:'')+''+((demographics.addressLine2 != null)?demographics.addressLine2:'');            
                address.city =(demographics.city != null)?demographics.city:'';               
                address.State  =(demographics.state != null)?demographics.state:'';  
                address.zip= (demographics.zipCode != null)?demographics.zipCode:'';
                address.phone =(demographics.phoneNumber != null)?demographics.phoneNumber:'';
                address.country =(demographics.country != null)?demographics.country:'';
                system.debug(address.addressType);
                if(address.addressType=='MAIL')
                address.addressType = 'Mailing';
                else if(address.addressType=='BUSI')
                address.addressType = 'Business';
                producerDetailresult.addresslist.add(address);
        }
        
        } catch(Exception ex){
                  system.debug(LoggingLevel.INFO, 'Issues in general producer detail' + ex);                 
                }
           
      }
    
    // Adding the changes for continuation webservice call
    public Continuation StartRequest(string producerId, String CallbackMethodName, Continuation oContinuation)
    {
        GetEndpoint();
        GetRequestBody(producerId,flag);          
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel)
    {
      ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
    
        try
        {
          HttpResponse Response = GetHttpResponse(HttpRequestLabel);
              //Response.setStatusCode(500);
           oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;//Added for US1517846
              if (Response.getStatusCode() == 200) {
               oACETWSCalloutResult.Success = true;
               oACETWSCalloutResult.Message = '';
               oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));

               if(Response.getBody()!=Null){
                   ACETGetProducerAdapterJSON2Apex.cls_serviceAttributes PDresponse; 
                   ACETGetProducerAdapterJSON2Apex ACTGPJSON2Apex = (ACETGetProducerAdapterJSON2Apex)JSON.deserialize(Response.getBody(), ACETGetProducerAdapterJSON2Apex.class);
                   PDresponse= ACTGPJSON2Apex.response.serviceAttributes;
                    if(Integer.ValueOf(PDresponse.responseCode)!=200){
                       oACETWSCalloutResult.Success = false;
                       oACETWSCalloutResult.statusCode=Integer.ValueOf(PDresponse.responseCode);
                    }
               }
               
              }else {
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                    oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;//Added for US1517846
              }  
          }
    catch(Exception ex){
      system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
      oACETWSCalloutResult.Success = false;
      oACETWSCalloutResult.Message = ex.getMessage();
      oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
      oACETWSCalloutResult.statusCode=999; //Added for US1517846
    }

    system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
    return oACETWSCalloutResult;
  }
  //Added for continuation call
  public ACETWSCalloutResult GetProducer(String ProducerId){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        producerDetailresult = new ACETProducerResult();
        try{
            GetEndpoint();
            GetRequestBody(producerId,flag);
            HttpResponse Response = Send(OAuthConfig);
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;//Added for US1517846
            if (Response.getStatusCode() == 200){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));
                if(Response.getBody()!=Null){
                   ACETGetProducerAdapterJSON2Apex.cls_serviceAttributes PDresponse; 
                   ACETGetProducerAdapterJSON2Apex ACTGPJSON2Apex = (ACETGetProducerAdapterJSON2Apex)JSON.deserialize(Response.getBody(), ACETGetProducerAdapterJSON2Apex.class);
                   PDresponse= ACTGPJSON2Apex.response.serviceAttributes;
                    if(Integer.ValueOf(PDresponse.responseCode)!=200){
                       oACETWSCalloutResult.Success = false;
                       oACETWSCalloutResult.statusCode=Integer.ValueOf(PDresponse.responseCode);
                    }
                  }
                }else {
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                    oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;//Added for US1517846
                }  
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999; //Added for US1517846
        }
        return oACETWSCalloutResult;
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
        return newDate;
    }
    
  
}