public with sharing class ETSBE_GetBrokerSearchWebservice extends ACETWebservice{
    public override void GetEndpoint()
    {
        GetEndpointDetail('BasicsGetProducerEndpoint');
    }
    
    public ETSBE_GetBrokerSearchWebservice() {
        super('Stargate');
    }
    
    public void GetRequestBody(String producerId){
    	RequestBody = '{"request":{"serviceAttributes":{'+      
        	+'"applicationIdentifier":"ACET",'
        	+'"requestIdentifier":"",'
        	+'"producerGroupAssociation":"",'
        	+'"pageNumber":"1",'        
        	+'"recordsPerPage":"20"},' 
        +'"getProducerRequest":{'
			+'"producerID":"' + producerId + '",'
			+'"customerNumber":"",'
			+'"adminSystem":"",'
			+'"producerEffectiveAsofdate":""}}}';
    }
    
    public ACETWSCalloutResult getProducer(String producerId){
    	ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
    	try{
            getEndpoint();
            GetRequestBody(producerId);
            system.debug('>>>RequestBody'+RequestBody );
            HttpResponse response = Send(OAuthConfig);
            system.debug('response ---->'+response.getBody());

            ETSBE_ProducerResults producerResult;

            if(response.getStatusCode() == 200){
            	if(response.getBody() != null){
            		ETSBE_GetBrokerSearchJSON2Apex brokerJson2Apex = (ETSBE_GetBrokerSearchJSON2Apex) JSON.deserialize(response.getBody(), ETSBE_GetBrokerSearchJSON2Apex.class);
            		if(brokerJson2Apex != null && brokerJson2Apex.response != null && brokerJson2Apex.response.getProducerResponse != null){
            			ETSBE_GetBrokerSearchJSON2Apex.ProducerResults prodResult = brokerJson2Apex.response.getProducerResponse;
        				System.debug('SETTING PRODUCER: ' + prodResult);
        				producerResult = new ETSBE_ProducerResults();
        				producerResult.producerID = (prodResult.producerID != null)?prodResult.producerID:'';
        				producerResult.producerSSN = (prodResult.producerSSN != null)?prodResult.producerSSN:'';
        				producerResult.producerTIN = (prodResult.producerTIN != null)?prodResult.producerTIN:'';
        				producerResult.producerType = (prodResult.producerType != null)?prodResult.producerType:'';
        				producerResult.producerContact = (prodResult.producerContact != null)?prodResult.producerContact:'';
        				producerResult.producerCompanyName = (prodResult.producerCompanyName != null)?prodResult.producerCompanyName:'';
        				producerResult.producerStatus = (prodResult.producerStatus != null)?prodResult.producerStatus:'';
        				producerResult.producerEffectiveStartDate = (prodResult.producerEffectiveStartDate != null)?prodResult.producerEffectiveStartDate:'';
        				producerResult.producerEffectiveEndDate = (prodResult.producerEffectiveEndDate != null)?prodResult.producerEffectiveEndDate:'';
        				producerResult.legacyProducers = new List<ETSBE_ProducerResults.LegacyProducers>();
        				if(prodResult.legacyProducers != null){
        					for(ETSBE_GetBrokerSearchJSON2Apex.LegacyProducers legacy:prodResult.legacyProducers){
        						ETSBE_ProducerResults.LegacyProducers addLegacy = new ETSBE_ProducerResults.LegacyProducers();
        						addLegacy.legacyProducerSystem = (legacy.legacyProducerSystem != null)?legacy.legacyProducerSystem:'';
        						addLegacy.legacyProducerID = (legacy.legacyProducerID != null)?legacy.legacyProducerID:'';
        						producerResult.legacyProducers.add(addLegacy);
        					}
        				}
        				producerResult.customerDetails = new List<ETSBE_ProducerResults.CustomerDetails>();
        				if(prodResult.customerDetails != null){
        					for(ETSBE_GetBrokerSearchJSON2Apex.CustomerDetails custDetails:prodResult.customerDetails){
        						ETSBE_ProducerResults.CustomerDetails addCustomer = new ETSBE_ProducerResults.CustomerDetails();
        						addCustomer.customerNumber = (custDetails.customerNumber != null)?custDetails.customerNumber:'';
        						addCustomer.customerName = (custDetails.customerName != null)?custDetails.customerName:'';
        						addCustomer.adminSystem = (custDetails.adminSystem != null)?custDetails.adminSystem:'';
        						addCustomer.producerCustomerStartDate = (custDetails.producerCustomerStartDate != null)?custDetails.producerCustomerStartDate:'';
        						addCustomer.producerCustomerEndDate = (custDetails.producerCustomerEndDate != null)?custDetails.producerCustomerEndDate:'';
        						producerResult.customerDetails.add(addCustomer);
        					}
        				}
        				if(prodResult.producerIndividualName != null){
        					producerResult.producerIndividualName = new ETSBE_ProducerResults.IndividualName();
        					producerResult.producerIndividualName.firstName = (prodResult.producerIndividualName.firstName != null)?prodResult.producerIndividualName.firstName:'';
        					producerResult.producerIndividualName.middleInitial = (prodResult.producerIndividualName.middleInitial != null)?prodResult.producerIndividualName.middleInitial:'';
        					producerResult.producerIndividualName.lastName = (prodResult.producerIndividualName.lastName != null)?prodResult.producerIndividualName.lastName:'';
        				}
        				if(prodResult.producerAddress != null){
        					producerResult.producerAddress = new ETSBE_ProducerResults.Address();
        					producerResult.producerAddress.addressTypeCode = (prodResult.producerAddress.addressTypeCode != null)?prodResult.producerAddress.addressTypeCode:'';
        					producerResult.producerAddress.producerStreetLine1 = (prodResult.producerAddress.producerStreetLine1 != null)?prodResult.producerAddress.producerStreetLine1:'';
        					producerResult.producerAddress.producerStreetLine2 = (prodResult.producerAddress.producerStreetLine2 != null)?prodResult.producerAddress.producerStreetLine2:'';
        					producerResult.producerAddress.producerCity = (prodResult.producerAddress.producerCity != null)?prodResult.producerAddress.producerCity:'';
        					producerResult.producerAddress.producerState = (prodResult.producerAddress.producerState != null)?prodResult.producerAddress.producerState:'';
        					producerResult.producerAddress.producerZipCode = (prodResult.producerAddress.producerZipCode != null)?prodResult.producerAddress.producerZipCode:'';
        					producerResult.producerAddress.producerZipCodeSuffix = (prodResult.producerAddress.producerZipCodeSuffix != null)?prodResult.producerAddress.producerZipCodeSuffix:'';
        					producerResult.producerAddress.producerPhoneNumber = (prodResult.producerAddress.producerPhoneNumber != null)?prodResult.producerAddress.producerPhoneNumber:'';
        				}
        				System.debug('FINAL PRODUCER RESULT: ' + producerResult);
            		}
            	}
            	calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = producerResult;
            } else {
                calloutResult.Success = false;
                calloutResult.statusCode = response!=null?response.getStatusCode():null;
            }
    	}catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in holdRestriction. Details: ' + ex.getstackTraceString()); 
            calloutResult.Success = false;
            calloutResult.Message = ex.getMessage();
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.statusCode=999;
        }
        
        return calloutResult;   
    }
}