@isTest
global class ETSBE_HttpCalloutMock {
    
    global class ETSBE_ExtendedCoverageWSMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
			response.setBody('{"alternateId":"956876492","benefitPlanId":"","benefitPackageLogNumber":"ACIS006","cesGroupNumber":"0706577","claimSourceSystemCode":"01","cosmosDivision":"","coverageStartDate":"2016-01-01","coverageLevel":"4","coverageEndDate":"9999-12-31","dependentSequenceNumber":"001","eligibilitySourceSystemCode":"01","genderCode":"F","governmentProgramCode":"","groupNumber":"N/A","groupPanelNumber":"N/A","individualRelationshipCode":"EE","legacyPanelNumber":"","legalEntityCode":"20020","lineOfBusiness":"N/A","marketSite":"0013478","marketType":"50","mbi":"","medicareIndicator":null,"nhpIndicator":"","obligorID":"01","pcid":"00003","platform":"UNET","planFeatureCode":null,"planVariation":"0031","policyNumber":"0706577","productCode":"Q","productID":"","productType":"POS","postalAddress":{"city":"SCHERERVILLE","country":"US","state":"IN","street1":"1018 WILLOWBROOK DRIVE","street2":"","zip":"46375","zip4":""},"referralRequired":"NO","relationshipCode":"000","reportingCode":"0031","serviceBenefitDescription":null,"serviceBenefitNotes":null,"serviceBenefitDetails":[],"sharedArrangement":"00","sourceCode":"CS","sourceID":"07065770030384576502003","state":"IN","stateOfIssueCode":"IL","subscriberID":"00303845765","tciTableNumber":"017874","xrefId":"9782567","xrefIdPartitionNumber":"167","memberInfo":{"relationship":"Subscriber","firstName":"AMANDA","lastName":"ADAM","dob":"1977-06-08","memberID":"956876492","members":[{"relationship":"Spouse","firstName":"PETER","lastName":"ADAM","dob":"1976-01-30","memberID":"956876492"},{"relationship":"Child","firstName":"LUKE","lastName":"ADAM","dob":"2007-05-01","memberID":"956876492"},{"relationship":"Child","firstName":"LOGAN","lastName":"ADAM","dob":"2008-12-19","memberID":"956876492"},{"relationship":"Child","firstName":"LEIA","lastName":"ADAM","dob":"2013-11-12","memberID":"956876492"}],"dos":"2019-01-01"},"primaryCareProvider":{"pcpMessage":"No Primary Care Physician on file for this plan.","pcpFirstName":"N/A","pcpMiddleName":"N/A","pcpLastName":"N/A","providerAddress":{"addressLine1":"N/A","addressLine2":"N/A","city":"N/A","state":"N/A","zip":"N/A"},"pcpPhoneNumber":"N/A","providerNpi":"N/A","taxId":"N/A","pcpSpeciality":"N/A","pcpStartDate":"N/A","pcpEndDate":"N/A","acoNetworkDescription":"N/A","acoNetworkId":"N/A","affiliateHospitalName":"N/A","providerGroupName":"N/A","pcpFound":false},"additionalPlanDetails":{"cdhp":"N/A","cobUpdateInformation":{"cobUpdateMessage":"Member COB update overdue.","cobLastUpdate":"2018-03-14"},"fundingType":"Self-Funded","hsa":"N/A","insuranceTypeCode":null,"primaryPayer":"Primary","virtualVisits":"Virtual Visit benefits exist for this plan","umDelegationFlag":null},"payerInfo":null,"additionalCoverage":[{"phoneNumber":"","payerName":"testing","cobMemberId":"","cobPolicyNumber":"","policyEffectiveStartDate":"08-03-2020","policyEffectiveEndDate":"08-03-2020","notes":"N/A","description":"N/A","cobPolicyGroupNumber":"","coverageType":"Primary","cobPolicyHolderName":"","street1":"","city":"","state":"","zip":"","primaryGroupIndicator":"Yes"}]}');
            response.setStatusCode(200);
            return response; 
        }
    }
    global class ETSBE_producerMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
			response.setBody('{"response":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"0c5ddc5d","totalNumberOfRecords":"1","producerGroupAssociation":"","producerAndGroupFlag":"N","pageNumber":"1","recordsPerPage":"50","responseCode":"200","responseDescription":"Trace of all the success calls"},"findProducerResponse":[{"producerGroupValidated":" ","producerStatus":"Active","requestedDate":"04-06-2020","producerId":"001107","producerCompanyName":"","producerType":"I","legacyBrokerCode":"","producerSSN":"123456789","producerTIN":"123456789","producerState":"IL","producerContact":"","producerCity":"CAROL STREAM","producerPhoneNumber":"6306680111","producerName":{"firstName":"CLIFFORD","middleInitial":"L","lastName":"FULLHART"},"coverageType":"","producerRoleType":"","producerRole":"","producerServiceRightsOnly":"","producerCRID":"","producerSplitPercent":"","producerStreetLine1":"475 THORNHILL DR","producerStreetLine2":"","producerZipCode":"60188","producerZipCodeSuffix":"2464","memberGroupDetails":[{"groupNumber":"","groupName":"","producerMemberGrpStartDate":"","producerMemberGrpEndDate":""}]}]}}}');
            response.setStatusCode(200);
            return response; 
        }
    }
    global class ETSBE_producerDetailMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{	"response": {		"serviceAttributes": {			"applicationIdentifier": "ACET",			"requestIdentifier": "74a0a206-7fbb-4568-ad39-5de31abb6db3",			"responseCode": "200",			"responseDescription": "Success:Trace of all the success calls",			"producerGroupAssociation": "null",			"totalNumberOfRecords": "1",			"pageNumber": "1",			"recordsPerPage": "50"		},		"getProducerResponse": {			"producerID": "167106",			"producerCompanyName": "",			"producerName": {				"firstName": "SAMUEL",				"middleInitial": "J",				"lastName": "GRUBBS"			},			"producerSSN": "263835154",			"producerTIN": "",			"producerType": "I ",			"type": "BR",			"producerContact": " ",			"producerEffectiveStartDate": "08/23/2007",			"producerEffectiveEndDate": "12/31/9999",			"producerAddress": {				"addressTypeCode": "M",				"addressLine1": "4527 ARGYLE LN",				"addressLine2": "",				"city": "TALLAHASSEE",				"state": "FL",				"zipCode": "32309",				"phoneNumber": "8502514860"			},			"producerStatus": "Active",			"legacyBrokerCode": "",			"memberGroupDetails": [{				"groupNumber": "",				"groupName": " "			}]		}	}}}');
            response.setStatusCode(200);
            return response; 
        }
    }
     global class ETSBE_producerMockNull implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"response":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"0c5ddc5d","totalNumberOfRecords":"1","producerGroupAssociation":"","producerAndGroupFlag":"N","pageNumber":"1","recordsPerPage":"50","responseCode":"200","responseDescription":"Trace of all the success calls"}}}');
            response.setStatusCode(200);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor404 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"AEFNND","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(404);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor400 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"ED270UG","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(400);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor500 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"ED270SE","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(500);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor5001 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"ED270UE","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(500);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor5002 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"AEFNEE","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(500);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor5003 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"AAA:Fault Code","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(500);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor5004 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"ED270IP","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(500);
            return response; 
        }
    }
    global class ETSBEWebserviceMockFor5005 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"ED270BP","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(500);
            return response; 
        }
    }
     global class ETSBEWebserviceMockFor422 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody('{"returnCode":0,"errorMessage":"","faultCode":"ED270NP","attributes":{"networkStatus":"In-Network","primarySpecialty":null},"apiParameters":{}}');
            response.setStatusCode(422);
            return response; 
        }
    }
}