public with sharing class ETSBE_GetSolarisWebservice extends ACETWebService{
    public String GrantType;
    public String AccessToken;
    public String ClientId ;
    public String ClientSecret ;
    public String RequestBodyStr;
    
    public void getTokenEndpoint(){
        GetEndpointDetail('GetSolarisTokenEndpoint');
        BaseURL = '';
    }
    public override void getEndpoint(){
    	GetEndpointDetail('GetSolarisEndpoint');
    	if (WSConfigurations.containsKey(OrgName + '_GetSolarisBaseURL')){
            BaseURL = WSConfigurations.get(OrgName + '_GetSolarisBaseURL').Value__c; 
        }
    }
    public void getRequestBodyWS(String searchNumber, String searchType) {
        RequestBody = 'searchStr='+searchNumber.trim()+'&type='+searchType;      
    }
    
    public void getOAuthToken(){
    	//Currently getting token every call as per solaris meetings
    	if (WSConfigurations.containsKey('ISLConAccessToken'))  {
            OAuthConfig = WSConfigurations.get('ISLConAccessToken');
        }
        System.debug('INSIDE TOKEN GEN2' + OAuthConfig);
        ETSBE_SolarisApiOAuthWebservice oAuth = new ETSBE_SolarisApiOAuthWebservice();
        
        //uncomment after testing
        AccessToken = oAuth.GetAccessToken();
        OAuthConfig.Value__c = AccessToken;
        //uncomment after testing
        
        System.debug('INSIDE TOKEN GEN3' + OAuthConfig);
        system.debug('-------accesstoken-----------'+accesstoken);
    }

    public ACETWSCalloutResult findGroupContact(String groupPolicyNumber){
        AccessToken = '';
        Endpoint='';
        ClientId='';
        ClientSecret='';
        
        system.debug('-------groupNum-----------'+groupPolicyNumber);
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
        	getEndpoint();
        	getRequestBodyWS(groupPolicyNumber, 'group');
        	if(String.isNotBlank(RequestBody))   { 
	            RelativeURL = RelativeURL + '?' + RequestBody;
	        }
        	Method = 'GET';
        	HttpResponse response;  
            getOAuthToken();
            
            response = Send(OAuthConfig);
            

        	System.debug('###RESPONSE:'+response);
            System.debug('###RESPONSE-BODY:'+response.getBody());
            List<ETSBE_SolarisGroupDetailResult> groupResultList = new List<ETSBE_SolarisGroupDetailResult>();
            ETSBE_SolarisGroupDetailResult groupResult;
            if(response.getStatusCode() == 200){
            	System.debug('INSIDE RESPONSE');
            	ETSBE_SolarisResultJSON2Apex solarisJson2apex = (ETSBE_SolarisResultJSON2Apex)JSON.deserialize(response.getBody(), ETSBE_SolarisResultJSON2Apex.class);
	            if(solarisJson2apex != null){
	            	if(solarisJson2apex.groupResults.size() > 0){
	            		for(ETSBE_SolarisResultJSON2Apex.GroupResults searchResult:solarisJson2apex.groupResults){
		            		groupResult = new ETSBE_SolarisGroupDetailResult();
		            		groupResult.groupName = (searchResult.accountName != null)?searchResult.accountName:'';
		            		groupResult.salesforceInternalId = (searchResult.id != null)?searchResult.id:'';
		            		groupResult.groupId = (searchResult.customerNumber != null)?searchResult.customerNumber:'';
		            		groupResult.policyNumber = (searchResult.policyNumber != null)?searchResult.policyNumber:'';
                            if(groupResult.groupId == '' && groupResult.policyNumber != ''){
                                groupResult.groupId = groupResult.policyNumber;
                            }
		            		groupResult.renewalEffectiveDate = '';
		            		if(searchResult.renewalEffectiveDate != null){
		            			groupResult.renewalEffectiveDate = searchResult.renewalEffectiveDate.split('-')[1] + '/' + searchResult.renewalEffectiveDate.split('-')[2] + '/' + searchResult.renewalEffectiveDate.split('-')[0];
		            		}
		            		groupResult.fundingType = (searchResult.fundingType != null)?searchResult.fundingType:'';
		            		groupResult.salesOffice = (searchResult.salesOffice != null)?searchResult.salesOffice:'';
		            		groupResult.generalAgentName = (searchResult.gaName != null)?searchResult.gaName:'';
		            		groupResult.brokerSalesforceId = (searchResult.primaryRewardAccount != null)?searchResult.primaryRewardAccount:'';
		            		groupResult.brokerName = (searchResult.PrimaryRewardAccountName != null)?searchResult.PrimaryRewardAccountName:'';
		            		groupResult.situsState = (searchResult.situsState != null)?searchResult.situsState:'';
		            		groupResult.lineOfBusiness = (searchResult.marketSegment != null)?searchResult.marketSegment:'';
		            		groupResult.businessMinorMarket = (searchResult.businessMinorMarket != null)?searchResult.businessMinorMarket:'';
		            		if(groupResult.businessMinorMarket.contains('Minor')){
		            			groupResult.businessMinorMarket = groupResult.businessMinorMarket.remove('Minor');
		            		} else if(groupResult.businessMinorMarket.contains('minor')){
		            			groupResult.businessMinorMarket = groupResult.businessMinorMarket.remove('minor');
		            		} else if(groupResult.businessMinorMarket.contains('MINOR')){
		            			groupResult.businessMinorMarket = groupResult.businessMinorMarket.remove('MINOR');
		            		}
		            		groupResult.businessMajorMarket = (searchResult.businessMajorMarket != null)?searchResult.businessMajorMarket:'';
		            		if(groupResult.businessMajorMarket.contains('Major')){
		            			groupResult.businessMajorMarket = groupResult.businessMajorMarket.remove('Major');
		            		} else if(groupResult.businessMajorMarket.contains('major')){
		            			groupResult.businessMajorMarket = groupResult.businessMajorMarket.remove('major');
		            		} else if(groupResult.businessMajorMarket.contains('MAJOR')){
		            			groupResult.businessMajorMarket = groupResult.businessMajorMarket.remove('MAJOR');
		            		}
		            		groupResult.businessMarketRegion = (searchResult.businessMarketRegion != null)?searchResult.businessMarketRegion:'';
		            		if(groupResult.businessMarketRegion.contains('Region')){
		            			groupResult.businessMarketRegion = groupResult.businessMarketRegion.remove('Region');
		            		} else if(groupResult.businessMarketRegion.contains('region')){
		            			groupResult.businessMarketRegion = groupResult.businessMarketRegion.remove('region');
		            		} else if(groupResult.businessMarketRegion.contains('REGION')){
		            			groupResult.businessMarketRegion = groupResult.businessMarketRegion.remove('REGION');
		            		}
		            		groupResult.platform = (searchResult.platform != null)?searchResult.platform:'';
		            		groupResult.sourceCode = 'SO';
		            		groupResult.contacts = new List<ETSBE_SolarisGroupDetailResult.Contact>();
		            		if(searchResult.contacts != null && !searchResult.contacts.isEmpty()){
			            		for(ETSBE_SolarisResultJSON2Apex.Contact contact: searchResult.contacts){
			            			ETSBE_SolarisGroupDetailResult.Contact newContact = new ETSBE_SolarisGroupDetailResult.Contact();
			            			newContact.name = (contact.name != null)?contact.name:'';
                                    if(contact.name != null){
                                        List<String> conLst = contact.name.split(' ');
                                        if(conLst.size() > 1){
                                            newContact.firstName = conLst[0];
                                            newContact.lastName = conLst[1];
                                        }
                                        else{
                                            newContact.lastName = contact.name;
                                        }
                                    }
			            			newContact.id = (contact.id != null)?contact.id:'';
			            			newContact.title = (contact.title != null)?contact.title:'';
			            			newContact.email = (contact.email != null)?contact.email:'';
			            			newContact.workPhone = (contact.workPhone != null)?contact.workPhone:'';
			            			newContact.workPhoneExt = (contact.workPhoneExt != null)?contact.workPhoneExt:'';
			            			newContact.cellPhone = (contact.cellPhone != null)?contact.cellPhone:'';
			            			groupResult.contacts.add(newContact);
			            		}
		            		}
		            		groupResult.groupTeamMembers = new List<ETSBE_SolarisGroupDetailResult.TeamMember>();
		            		if(searchResult.teamMembers != null && !searchResult.teamMembers.isEmpty()){
			            		for(ETSBE_SolarisResultJSON2Apex.TeamMember teamMember: searchResult.teamMembers){
			            			ETSBE_SolarisGroupDetailResult.TeamMember newMember = new ETSBE_SolarisGroupDetailResult.TeamMember();
			            			newMember.name = (teamMember.name != null)?teamMember.name:'';
                                    if(newMember.name != null){
                                        List<String> conLst = newMember.name.split(' ');
                                        if(conLst.size() > 1){ 
                                            newMember.firstName = conLst[0];
                                            newMember.lastName = conLst[1];
                                        }else{
                                            newMember.lastName = newMember.name;
                                        }
                                    }
			            			newMember.role = (teamMember.role != null)?teamMember.role:'';
			            			newMember.phone = (teamMember.phone != null)?teamMember.phone:'';
			            			groupResult.groupTeamMembers.add(newMember);
			            		}
		            		}
		            		groupResultList.add(groupResult);
	            		}
	            	}
            	}
            }
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.Response = groupResultList;
    	} catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    

    
    public ACETWSCalloutResult findGeneralAgent(String searchString, string searchType){
    	System.debug('-----------------------------------------------------HERE IS A SEPARATOR 5---------------------------------------------------');
    	ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
    	try{
        	getEndpoint();
        	getRequestBodyWS(EncodingUtil.urlEncode(searchString, 'UTF-8'), searchType);
        	if(String.isNotBlank(RequestBody))   { 
	            RelativeURL = RelativeURL + '?' + RequestBody;
	        }
        	Method = 'GET';
        	HttpResponse response;  
            getOAuthToken();
            response = Send(OAuthConfig);
        	System.debug('###RESPONSE:'+response);
            System.debug('###RESPONSE-BODY:'+response.getBody());
            List<ETSBE_SolarisGeneralAgentDetailResult> gaResultList = new List<ETSBE_SolarisGeneralAgentDetailResult>();
            List<ETSBE_SolarisResultJSON2Apex.BrokerResults> searchResults;
            if(response.getStatusCode() == 200){
            	System.debug('INSIDE RESPONSE');
            	ETSBE_SolarisResultJSON2Apex solarisJson2apex = (ETSBE_SolarisResultJSON2Apex)JSON.deserialize(response.getBody(), ETSBE_SolarisResultJSON2Apex.class);
	            if(solarisJson2apex != null){
	            	if(solarisJson2apex.brokerResults != null && !solarisJson2apex.brokerResults.isEmpty()){
	            		searchResults = solarisJson2apex.brokerResults;
	            		for(ETSBE_SolarisResultJSON2Apex.BrokerResults searchResult: searchResults){
	            			ETSBE_SolarisGeneralAgentDetailResult gaResult = new ETSBE_SolarisGeneralAgentDetailResult();
	        			   	gaResult.rewardAccountNumber = (searchResult.rewardAccountNumber != null)?searchResult.rewardAccountNumber:'';
	        			   	gaResult.agencyBrokerName = (searchResult.rewardAccountName != null)?searchResult.rewardAccountName:'';
	        			   	gaResult.salesforceInternalId = (searchResult.id != null)?searchResult.id:'';
	        			   	gaResult.generalAgents = new List<ETSBE_SolarisGeneralAgentDetailResult.GeneralAgent>();
	        			   	if(searchResult.rewardAccountContacts != null && !searchResult.rewardAccountContacts.isEmpty()){
			            		for(ETSBE_SolarisResultJSON2Apex.GeneralAgent generalAgent: searchResult.rewardAccountContacts){
			            			ETSBE_SolarisGeneralAgentDetailResult.GeneralAgent newGA = new ETSBE_SolarisGeneralAgentDetailResult.GeneralAgent();
			            			newGa.name = (generalAgent.name != null)?generalAgent.name:'';
			            			newGa.salesforceInternalId = (generalAgent.Id != null)?generalAgent.Id:'';
			            			newGa.type = (generalAgent.type != null)?generalAgent.type:'';
			            			newGa.workPhone = (generalAgent.workPhone != null)?generalAgent.workPhone:'';
			            			newGa.mobilePhone = (generalAgent.mobilePhone != null)?generalAgent.mobilePhone:'';
			            			newGa.email = (generalAgent.email != null)?generalAgent.email:'';
			            			newGa.street = (generalAgent.street != null)?generalAgent.street:'';
			            			newGa.city = (generalAgent.city != null)?generalAgent.city:'';
			            			newGa.state = (generalAgent.state != null)?generalAgent.state:'';
			            			newGa.zip = (generalAgent.zip != null)?generalAgent.zip:'';
			            			gaResult.generalAgents.add(newGa);
			            		}
		            		}
		            		gaResult.producers = new List<ETSBE_SolarisGeneralAgentDetailResult.Producer>();
	        			   	if(searchResult.producers != null && !searchResult.producers.isEmpty()){
			            		for(ETSBE_SolarisResultJSON2Apex.Producer producer: searchResult.producers){
			            			ETSBE_SolarisGeneralAgentDetailResult.Producer newProducer = new ETSBE_SolarisGeneralAgentDetailResult.Producer();
			            			newProducer.name = (producer.name != null)?producer.name:'';
			            			newProducer.type = (producer.type != null)?producer.type:'';
			            			newProducer.email = (producer.email != null)?producer.email:'';
			            			newProducer.phone = (producer.phone != null)?producer.phone:'';
			            			newProducer.franchiseCode = (producer.franchiseCode != null)?producer.franchiseCode:'';
			            			newProducer.street = (producer.street != null)?producer.street:'';
			            			newProducer.city = (producer.city != null)?producer.city:'';
			            			newProducer.state = (producer.state != null)?producer.state:'';
			            			newProducer.zip = (producer.zip != null)?producer.zip:'';
			            			gaResult.producers.add(newProducer);
			            		}
	        			   	}
	        			   	gaResultList.add(gaResult);
	            		}
	            	}
            	}
            }
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.Response = gaResultList;
    	} catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    

    
    public void sendClosedCase(String accountId, String caseId, String receivedDate, String subject, String contactName, String originatorType, String issueType, String closedDate, String caseAge){
        AccessToken = '';
        Endpoint='';
        ClientId='';
        ClientSecret='';
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
    	try{
        	HttpRequest req = new HttpRequest();
	        HttpResponse res;
	        Http newHttp = new Http();
	        getOAuthToken();
        	req.setHeader('authorization', 'Bearer '+OAuthConfig.Value__c);
        	req.setHeader('Content-Type', 'application/json');
        	req.setMethod('PUT');
        	getEndpoint();
        	Endpoint = BaseURL + RelativeURL;
        	req.setEndpoint(Endpoint);
        	String reqBody = '{"request":{'
        	+ '"accountId":"'+ accountId + '",'
        	+ '"caseId":"' + caseId + '",'
        	+ '"recievedDate":"' + receivedDate + '",'
        	+ '"subject":' + subject + ','
        	+ '"contactName":"' + contactName + '",'
        	+ '"originatorType":"' + originatorType + '",'
        	+ '"issueType":"' + issueType + '",'
        	+ '"closedDate":"' + closedDate + '",'
        	+ '"age":"' + caseAge + '"'
        	+ '}}';
        	System.debug('SEND CASE REQBODY' + reqBody);
        	req.setBody(reqBody);
        	res = newHttp.Send(req);
    		System.debug('HERE IS THE RESPONSE: ' + res);
    		System.debug('HERE IS THE RESPONSE: ' + res.getBody());
    		if(res.getBody().contains('Success')){
    			calloutResult.Success = true;
	            calloutResult.Message = '';
	            calloutResult.Response = res;
    		} else if(res.getBody().contains('Failure')) {
    			System.debug('FAILURE 1: ');
    			calloutResult.Success = false;
	            calloutResult.Message = 'Could not add new Customer Admin. Please try again.';
	            calloutResult.Response = res;
	            System.debug('FAILURE 1: ' + calloutResult.Message);
    		}   
    	} catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
    }
    
    //how do I get a new token?
    //what is the timeout of the token so I'm not getting one constantly?
}