public with sharing class ETSBE_BrokerSearchWebservice extends ACETWebservice{
    public override void GetEndpoint()
    {
        GetEndpointDetail('BasicsFindProducerEndpoint');
    }
    
    public ETSBE_BrokerSearchWebservice() {
        super('Stargate');
    }
    
    public void GetRequestBody(String producerId){
    	RequestBody = '{"request":{"serviceAttributes":{'+      
        	+'"applicationIdentifier":"ACET",'
        	+'"requestIdentifier":"",'
        	+'"requestedDate":"",'
        	+'"producerGroupAssociation":"",'
        	+'"producerAndGroupFlag":"N",'
        	+'"pageNumber":"1",'        
        	+'"recordsPerPage":"20"},' 
        +'"findProducerRequest":{'
			+'"producerID":"' + producerId + '",'
			+'"producerSSN":"",'
			+'"producerTIN":"",'
			+'"producerFirstName":"",'
			+'"producerMiddleInitial":"",'
			+'"producerLastName":"",'
			+'"producerCompanyName":"",'
			+'"producerState":"",'
			+'"producerStatus":"",'
			+'"legacyProducerSystem":"",'
			+'"legacyProducerID":"",'
			+'"customerNumber":"",'
			+'"customerName":"",'
			+'"adminSystem":""}}}';
    }
    
    public ACETWSCalloutResult findProducer(String producerId){
    	ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
    	try{
            getEndpoint();
            GetRequestBody(producerId);
            system.debug('>>>RequestBody'+RequestBody );
            HttpResponse response = Send(OAuthConfig);
            system.debug('response ---->'+response.getBody());

            List<ETSBE_ProducerResults> resultsList = new List<ETSBE_ProducerResults>();
            ETSBE_ProducerResults producerResult;

            if(response.getStatusCode() == 200){
            	if(response.getBody() != null){
            		ETSBE_BrokerSearchJSON2Apex brokerJson2Apex = (ETSBE_BrokerSearchJSON2Apex) JSON.deserialize(response.getBody(), ETSBE_BrokerSearchJSON2Apex.class);
            		if(brokerJson2Apex != null && brokerJson2Apex.response != null && brokerJson2Apex.response.findProducerResponse != null){
            			for(ETSBE_BrokerSearchJSON2Apex.ProducerResults prodResult:brokerJson2Apex.response.findProducerResponse){
            				System.debug('SETTING PRODUCER: ' + prodResult);
            				producerResult = new ETSBE_ProducerResults();
            				producerResult.producerCustomerValidated = (prodResult.producerCustomerValidated != null)?prodResult.producerCustomerValidated:'';
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
            				System.debug('LEGACY PROD: ' + prodResult.legacyProducers);
            				producerResult.legacyProducerIDList = '';
            				if(prodResult.legacyProducers != null){
            					for(ETSBE_BrokerSearchJSON2Apex.LegacyProducers legacy:prodResult.legacyProducers){
            						ETSBE_ProducerResults.LegacyProducers addLegacy = new ETSBE_ProducerResults.LegacyProducers();
            						addLegacy.legacyProducerSystem = (legacy.legacyProducerSystem != null)?legacy.legacyProducerSystem:'';
            						addLegacy.legacyProducerID = (legacy.legacyProducerID != null)?legacy.legacyProducerID:'';
            						if(producerResult.legacyProducerIDList == ''){
            							producerResult.legacyProducerIDList = addLegacy.legacyProducerID;
            						} else {
            							producerResult.legacyProducerIDList = producerResult.legacyProducerIDList + ',' + addLegacy.legacyProducerID;
            						}
            						producerResult.legacyProducers.add(addLegacy);
            					}
            				}
            				System.debug('LEGACY PROD FINAL: ' + producerResult.legacyProducers);
            				producerResult.customerDetails = new List<ETSBE_ProducerResults.CustomerDetails>();
            				if(prodResult.customerDetails != null){
            					for(ETSBE_BrokerSearchJSON2Apex.CustomerDetails custDetails:prodResult.customerDetails){
            						ETSBE_ProducerResults.CustomerDetails addCustomer = new ETSBE_ProducerResults.CustomerDetails();
            						addCustomer.customerNumber = (custDetails.customerNumber != null)?custDetails.customerNumber:'';
            						addCustomer.customerName = (custDetails.customerName != null)?custDetails.customerName:'';
            						addCustomer.adminSystem = (custDetails.adminSystem != null)?custDetails.adminSystem:'';
            						addCustomer.producerCustomerStartDate = (custDetails.producerCustomerStartDate != null)?custDetails.producerCustomerStartDate:'';
            						addCustomer.producerCustomerEndDate = (custDetails.producerCustomerEndDate != null)?custDetails.producerCustomerEndDate:'';
            						producerResult.customerDetails.add(addCustomer);
            					}
            				}
            				producerResult.coverageType = (prodResult.coverageType != null)?prodResult.coverageType:'';
            				producerResult.producerRoleType = (prodResult.producerRoleType != null)?prodResult.producerRoleType:'';
            				producerResult.producerRole = (prodResult.producerRole != null)?prodResult.producerRole:'';
            				producerResult.producerServiceRightsOnly = (prodResult.producerServiceRightsOnly != null)?prodResult.producerServiceRightsOnly:'';
            				producerResult.ProducerCRID = (prodResult.ProducerCRID != null)?prodResult.ProducerCRID:'';
            				producerResult.producerSplitPercent = (prodResult.producerSplitPercent != null)?prodResult.producerSplitPercent:'';
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
            				resultsList.add(producerResult);
            			}
            		}
            	}
            	calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = resultsList;
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