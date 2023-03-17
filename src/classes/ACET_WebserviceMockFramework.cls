public without sharing class ACET_WebserviceMockFramework {

	public static HttpResponse getMockResponse(String serviceName, Map < String, String > requestParamsMap, String requestBody, Map < String, Object > wsConfigMap) {
		System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: serviceName: ' + serviceName);
		System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: requestParamsMap: ' + requestParamsMap);
		System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: requestBody: ' + requestBody);
		System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: wsConfigMap: ' + wsConfigMap);
		HttpResponse httpRes = new HttpResponse();
		String searchParameter;
		if(serviceName.equalsIgnoreCase('CaseProvidersSearch')) {
            ACET_CaseProvidersReq reqbody = (ACET_CaseProvidersReq)System.JSON.deserialize(requestBody, ACET_CaseProvidersReq.class);
            searchparameter = 'CPS_' + reqbody.member.memberID;
		}else if(serviceName.equalsIgnoreCase('CaseSubmitPOCA')) {
            ACET_CreateAuthorizationRequest reqbody = (ACET_CreateAuthorizationRequest)System.JSON.deserialize(requestBody, ACET_CreateAuthorizationRequest.class);
			searchparameter = 'CaseSubmit_' + reqbody.caseDetails.member.sourceMemberID;
		}else if(serviceName.equalsIgnoreCase('PaymentReadCheck')) {
            ACET_ViewPaymentsReadCheckWS.RequestBody reqbody = (ACET_ViewPaymentsReadCheckWS.RequestBody)System.JSON.deserialize(requestBody, ACET_ViewPaymentsReadCheckWS.RequestBody.class);// ACET_ViewPaymentsReadCheckWS.RequestBody ACET_ClaimrelatedRequest.parse(requestBody);
           	String sartValue = reqbody.data.checkNumber.substring(0,3);
            searchparameter = ((sartValue!='400') && (sartValue!='404') && (sartValue!='500'))?'PaymentReadCheckResp':'PaymentReadCheckResp_'+sartValue;
		}else if(serviceName.equalsIgnoreCase('PaymentCheckSearch'))
        {
           ACET_ViewPaymentsRequest.RequestBody reqbody = (ACET_ViewPaymentsRequest.RequestBody)System.JSON.deserialize(requestBody, ACET_ViewPaymentsRequest.RequestBody.class);
            String sartValue = reqbody.data.checkNumber.substring(0,3);
			String nextKey = reqbody.data.pagingState.nextKey;
			searchparameter = ((sartValue!='400') && (sartValue!='404') && (sartValue!='500'))? ((nextKey == '0160') ? 'PaymentCheckSearchRespNoPagination' : 'PaymentCheckSearchResp' ) :'PaymentCheckSearchResp_'+sartValue;
        }else if (serviceName.equalsIgnoreCase('LinkEligibilityMemberSearch')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkEligibilityMemberSearch');
			String searchOption = requestParamsMap.containsKey('searchOption') ? requestParamsMap.get('searchOption') : '';
			String memberId = requestParamsMap.containsKey('memberId') ? requestParamsMap.get('memberId') : '';
			String firstName = requestParamsMap.containsKey('firstName') ? requestParamsMap.get('firstName') : '';
			String lastName = requestParamsMap.containsKey('lastName') ? requestParamsMap.get('lastName') : '';
			String groupNumber = requestParamsMap.containsKey('groupNumber') ? requestParamsMap.get('groupNumber') : '';
			String dateOfBirth = requestParamsMap.containsKey('dateOfBirth') ? requestParamsMap.get('dateOfBirth') : '';
			switch on searchOption {
				when 'MemberIDNameGroupNumberDateOfBirth' {
					searchparameter = memberId + '_' + firstName + '_' + lastName + '_' + groupNumber + '_' + dateOfBirth;
				}
				when 'MemberIDNameDateOfBirth' {
					searchparameter = memberId + '_' + firstName + '_' + lastName + '_' + dateOfBirth;
				}
				when 'MemberIDName' {
					searchparameter = memberId + '_' + firstName + '_' + lastName;
				}
				when 'MemberIDLastNameDateOfBirth' {
					searchparameter = memberId + '_' + lastName + '_' + dateOfBirth;
				}
				when 'MemberIDFirstNameDateOfBirth' {
					searchparameter = memberId + '_' + firstName + '_' + dateOfBirth;
				}
				when 'NameDateOfBirth' {
					searchparameter = firstName + '_' + lastName + '_' + dateOfBirth;
				}
				when 'MemberIDDateOfBirth' {
					searchparameter = memberId + '_' + dateOfBirth;
				}
                when
				else {}
			}
		}
        // US3636832- Migration of authSummary and authDetail APIs to new framework
        else if (serviceName.equalsIgnoreCase('FindAuthorization')) {
            Map<String, Object> requestMap1 = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
            Map<String, Object> requestMap2 = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestMap1.get('authSummaryRequest')));
            Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestMap2.get('member')));

            String firstName= (String) requestMap.get('firstName');
            String lastName= (String) requestMap.get('lastName');

            searchparameter = 'findAuth_'+ firstName.trim().toLowerCase() + '_' +lastName.trim().toLowerCase();
        }else if (serviceName.equalsIgnoreCase('GetAuthorization')) {
            Map<String, Object> requestMap1 = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
            Map<String, Object> requestMap2 = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestMap1.get('authDetailsRequest')));
            List<Object> requestMap = (List<Object>)JSON.deserializeUntyped(JSON.serialize(requestMap2.get('identifiers')));

            Map<String, Object> a= (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestMap[0]));
            Map<String, Object> x= (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestMap[1]));
            String AUTH_ID= (String)a.get('id');
            String XREF_ID= (String)x.get('id');
            searchparameter = 'readAuth_'+AUTH_ID.trim()+'_'+XREF_ID.trim();

        }// US3636832 ends
		/*** US3076045 - Avish **/
		else if (serviceName.equalsIgnoreCase('LinkExtendedCoverage')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkExtendedCoverage');
            String transactionId = requestParamsMap.containsKey('transactionId') ? requestParamsMap.get('transactionId') : '';
            if(String.isNotBlank(transactionId)){
                searchparameter = 'ExtendedCoverage_' + transactionId.remove('-').remove('%').substring(0, 23);
            }								
		}
		//setting mock data for LinkCopayCoInsurance
        else if (serviceName.equalsIgnoreCase('LinkCopayCoInsurance')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkCopayCoInsurance');
            String patientKey = requestParamsMap.containsKey('patientKey') ? (requestParamsMap.get('patientKey').length() > 10 ? requestParamsMap.get('patientKey').substring(0, 10) : '') : '';
            String policyId = requestParamsMap.containsKey('policyId') ? requestParamsMap.get('policyId') : '';
            String serviceTypeDescriptions = requestParamsMap.containsKey('serviceTypeDescriptions') ? (requestParamsMap.get('serviceTypeDescriptions').length() > 10 ? requestParamsMap.get('serviceTypeDescriptions').substring(0, 10) : '') : '';            
            //String searchparameter = 'copay_' + requestObj.policyId + '_' + (requestObj.patientKey.length() > 10 ? requestObj.patientKey.substring(0, 10) : requestObj.patientKey) + '_' + (requestObj.serviceTypeDescription_API.length() > 10 ? requestObj.serviceTypeDescription_API.substring(0, 10) : requestObj.serviceTypeDescription_API);
            searchparameter = 'copay_' + policyId + '_' + patientKey + '_' +serviceTypeDescriptions;
            
        }
        //US2860984 - setup mock for claim summary
		else if (serviceName.equalsIgnoreCase('LinkClaimSearch')) {
				System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkClaimSearch');
				String claimNumber = requestParamsMap.containsKey('claimNumber') ? requestParamsMap.get('claimNumber') : '';
						searchparameter = 'ClaimSummary' + '_' + claimNumber;

		}
        //ketki
        else if (serviceName.equalsIgnoreCase('LinkClaimSearchByMember')) {
				System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkClaimSearchByMember');
            	String tin = requestParamsMap.containsKey('tin') ? requestParamsMap.get('tin') : '';
						searchparameter = 'ClaimSummaryByTin' +'_'+tin;

		}

         //Added by mani--Start
        else if (serviceName.equalsIgnoreCase('LinkTimelyFiling')) {
				System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: TimelyFillingSummry');
            	String contractid = requestParamsMap.containsKey('unet-contract-id') ? requestParamsMap.get('unet-contract-id') : '';
						searchparameter = 'contractDetail_EI_tax_id'+'_'+contractid;

		}

        else if (serviceName.equalsIgnoreCase('LinkContractorID')) {
				System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkContractorID');
            	String tax_id_nbr = requestParamsMap.containsKey('tax_id_nbr') ? requestParamsMap.get('tax_id_nbr') : '';
				searchparameter = 'contractSummary_E_and_I'+'_'+tax_id_nbr;

		}

        else if (serviceName.equalsIgnoreCase('LinkPaymentDetail')) {
				System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkPaymentDetail');
            	String transactionId = requestParamsMap.containsKey('transactionId') ? requestParamsMap.get('transactionId') : '';
						searchparameter = 'claimPayment_'+transactionId;

		}
		//vishnu Kasu Prior Auth
        else if (serviceName.equalsIgnoreCase('LinkPriorAuthInquiry')) {
           String procedureCodes = requestParamsMap.containsKey('cptCode') ? requestParamsMap.get('cptCode') : '';
			String diagnosisCode = requestParamsMap.containsKey('diagnosisCode') ? requestParamsMap.get('diagnosisCode') : '';
			String taxIdNumber = requestParamsMap.containsKey('taxIdNumber') ? requestParamsMap.get('taxIdNumber') : '';
            searchparameter = taxIdNumber+'_'+procedureCodes+'_'+diagnosisCode;
        }
        else if(serviceName.equalsIgnoreCase('BenefitCheckClaim')){
            ACET_BenefitCheckRequest req = (ACET_BenefitCheckRequest) System.JSON.deserialize(requestBody, ACET_BenefitCheckRequest.class);
            searchparameter = 'BenefitCheckClaim_'+req.procedures[0].code+'_'+req.Diagnosis[0].code;
        }
        else if (serviceName.equalsIgnoreCase('LinkRelatedDocuments')) {
            ACET_ClaimrelatedRequest reqbody = ACET_ClaimrelatedRequest.parse(requestBody);
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkRelatedDocuments'+reqbody.indexName);
            String claimno='';
            if(reqbody.indexName=='u_prov_attch'){
                integer size = reqbody.criteria.filterClauses.size();
                if(size > 0){
                    for(Integer i = 0; i < size; i++){
                        if(reqbody.criteria.filterClauses[i].name=='u_clm_nbr'){
                            claimno=reqbody.criteria.filterClauses[i].value;
                        }
                    }
                }
                searchparameter = reqbody.indexName+'_'+claimno;
            }else{
               searchparameter = reqbody.indexName;
            }
		}
        //Added by mani - End

		//setting mock data for claim details
		else if (serviceName.equalsIgnoreCase('LinkClaimDetail')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkClaimDetail');
			String claimNumber = requestParamsMap.containsKey('claimNumber') ? requestParamsMap.get('claimNumber') : '';
					searchparameter = 'ClaimDetail' + '_' + claimNumber;
				}
		// US3125207 - Sanka  - 21st Dec 2020
		else if (serviceName.equalsIgnoreCase('LinkBenefitSummary')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkBenefitSummary');
			String transactionId = requestParamsMap.containsKey('transactionId') ? requestParamsMap.get('transactionId') : '';
			searchparameter = 'LinkBenefitSummary_' + transactionId.substring(0, 23);
		}
		// US3125215 - Thanish - 22nd Dec 2020
		else if (serviceName.equalsIgnoreCase('LinkBenefitSearch')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkBenefitSearch');
            // US3446590 - Thanish - 21st Apr 2021
			String searchPhrase = requestParamsMap.containsKey('searchPhrase') ? requestParamsMap.get('searchPhrase') : '';
            String transactionId = requestParamsMap.containsKey('transactionId') ? requestParamsMap.get('transactionId') : '';
            if(searchPhrase.equalsIgnoreCase('out') && transactionId.equalsIgnoreCase('-sDxstu2gYQdVkiV6h1XYQB59hl6uSo1GO6nC576jNd8RisN_n-k3HDmPQqe_EKk6Pg-UxSe1_gRYvND27LyCWCaYaRNXUq_gwYXNJD563YuZShMqfVAV_KKjY12R3E2JiY8yYscoMDSCZ1hoNwhV5FsQvlCllS6-YE8s_YrVNk897721')){
                searchparameter = 'LinkBenefitSearch_dash';
            } else{
			searchparameter = 'LinkBenefitSearch_' + searchPhrase.toLowerCase();
			}
		}
		// US3125266 - Thanish - 5th Jan 2021
		else if (serviceName.equalsIgnoreCase('LinkBenefitLanguage')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkBenefitLanguage');
			searchparameter = 'LinkBenefitLanguageDetailsMock';
		}
        else if (serviceName.equalsIgnoreCase('LinkExtendedNetworkStatus')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkExtendedNetworkStatus');
			searchparameter = 'NetworkStatusMock';
		}
        else if (serviceName.equalsIgnoreCase('MedNecService')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: MedNecService');
            ACET_MedNecServiceRequest reqbody = ACET_MedNecServiceRequest.parse(requestBody);
			searchparameter = 'MedNec_' + (string.isNotBlank(reqbody.searchInput.policy) ? reqbody.searchInput.policy : '')
                + '_' + (string.isNotBlank(reqbody.searchInput.firstName) ? reqbody.searchInput.firstName : '');
		}
// US2585028 - COB UNET
		else if (serviceName.equalsIgnoreCase('ADBLoyaltyEndpoint')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: ADBLoyaltyEndpoint');
            // US3308070 - Thanish - 2nd Mar 2021
            ADBLoyaltyRequestWrapper loyaltyRequest = (ADBLoyaltyRequestWrapper) JSON.deserialize(requestBody, ADBLoyaltyRequestWrapper.class);
            if(loyaltyRequest!=null && loyaltyRequest.readInput!=null){
                searchparameter = 'RCED_'+loyaltyRequest.readInput.searchId+'_'+loyaltyRequest.readInput.policyNumber+'_'+loyaltyRequest.readInput.sourceCode;
            }else{
			searchparameter = 'ADBLoyaltyEndpointMock';
		}
            System.debug('subscriberId -- ' + loyaltyRequest.readInput.searchId);
            System.debug('policyNumber -- ' + loyaltyRequest.readInput.policyNumber);
            System.debug('sourceCode -- ' + loyaltyRequest.readInput.sourceCode);
        }
		//Ketki - US3238439 - 11th Feb 2021
         else if (serviceName.equalsIgnoreCase('IPAMarketAssociationService')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: IPAMarketAssociationService');
            String marketNbr = requestParamsMap.containsKey('prov-market-nbr') ? requestParamsMap.get('prov-market-nbr') : '';
            searchparameter = 'IPAMarketAssociation' +'_'+marketNbr;
          }
        else if (serviceName.equalsIgnoreCase('LinkAdditionalMemberInfo')) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkAdditionalMemberInfo');
			String transactionId = requestParamsMap.containsKey('transactionId') ? requestParamsMap.get('transactionId') : '';
            system.debug('transactionId' + transactionId);
            if(String.isNotEmpty(transactionId))
            searchParameter = 'LinkAdditionalMemberInfo_' + transactionId.remove('-').remove('%').substring(0, 23);
                else
                searchparameter = '';
		}
		 //Nikhil - US3305198 - 26th Feb 2021
        else if (serviceName.equalsIgnoreCase('LinkBenefitTherapyService')) {
            String patientKey = requestParamsMap.containsKey('patientKey') ? (requestParamsMap.get('patientKey').length() > 10 ? requestParamsMap.get('patientKey').substring(0, 10) : requestParamsMap.get('patientKey')) : '';
            String policyId = requestParamsMap.containsKey('policyId') ? requestParamsMap.get('policyId') : '';
            searchparameter = 'BenefitTherapy' + '_' + policyId + '_' + patientKey;
        }

          else if (serviceName.equalsIgnoreCase('LinkViewPCPReferrals')) {
                    System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkViewPCPReferrals');
                    searchparameter = 'ReferralService_'+  (requestParamsMap.containsKey('memberId') ? requestParamsMap.get('memberId') : '') +
                        '_'+ (requestParamsMap.containsKey('policyNumber') ? requestParamsMap.get('policyNumber') : '');
                    if( requestParamsMap.containsKey('alloff') && requestParamsMap.get('alloff') == '1' )  searchparameter = searchparameter+'_'+requestParamsMap.get('alloff');
                    if( requestParamsMap.get('newReferralNumber') != NULL){
                        string temp = requestParamsMap.get('newReferralNumber');
                        if(string.isNotBlank(temp)) searchparameter = searchparameter + '_'+ (temp.length() >=1 ? temp.substring(0,1): '');
                    }
                }

                else if (serviceName.equalsIgnoreCase('LinkB360BenefitSummary')) {
        			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkB360BenefitSummary');
        			String transactionId = requestParamsMap.containsKey('transactionId') ? requestParamsMap.get('transactionId') : '';
                    if(String.isNotBlank(transactionId)) searchparameter = 'BenefitSummary_' + transactionId.remove('-').remove('%').substring(0, 23);
        		}

                else if (serviceName.equalsIgnoreCase('LinkB360BenefitDetail')) {
        			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkB360BenefitDetail');
        			String transactionId = requestParamsMap.containsKey('transactionId') ? requestParamsMap.get('transactionId') : '';
                    if(String.isNotBlank(transactionId)) searchparameter = 'BenefitDetail_' + transactionId.remove('-').remove('%').substring(0, 23);
        		}

                 else if (serviceName.equalsIgnoreCase('SNIWebService')) {
        			System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: SNIWebService');
        			searchparameter = 'SNI_MockData';
        		}
        		else if (serviceName.equalsIgnoreCase('SelectionAssociatesAPI')) {
                    ACET_SelectAssociateRequest selectedAssociateRequest = (ACET_SelectAssociateRequest) JSON.deserialize(requestBody, ACET_SelectAssociateRequest.class);
            		if(selectedAssociateRequest!=null && selectedAssociateRequest.officeId!=null
						&& selectedAssociateRequest.departmentCode !=null && selectedAssociateRequest.teamCode!=null){
                		searchparameter = 'IndividualsSelectAssociate_'+selectedAssociateRequest.officeId+'_'+selectedAssociateRequest.departmentCode+'_'+selectedAssociateRequest.teamCode;
            		}else{
						searchparameter = 'IndividualsSelectAssociate';
					}
                    System.debug('officeId -- ' + selectedAssociateRequest.officeId);
                    System.debug('departmentCode -- ' + selectedAssociateRequest.departmentCode);
                    System.debug('teamCode -- ' + selectedAssociateRequest.teamCode);
        		}
		//setting mock data for claim Action - Nikhil
        else if (serviceName.equalsIgnoreCase('LinkClaimAction')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkClaimAction');
            String claimNumber = requestParamsMap.containsKey('claimNumber') ? requestParamsMap.get('claimNumber') : '';
            searchparameter = 'claimAction' + '_' + claimNumber;
        }
        //setting mock data for claim Recon - Nikhil
        else if (serviceName.equalsIgnoreCase('LinkClaimRecon')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkClaimRecon');
            String ticketNumber = requestParamsMap.containsKey('ticketNumber') ? requestParamsMap.get('ticketNumber') : '';
            searchparameter = 'claimRecon' + '_' + ticketNumber;
        }
        //setting mock data for claim Attachment List - Nikhil
        else if (serviceName.equalsIgnoreCase('LinkClaimAttachmentList')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkClaimAttachmentList');
            String ticketNumber = requestParamsMap.containsKey('ticketNumber') ? requestParamsMap.get('ticketNumber') : '';
            searchparameter = 'claimAttachmentList' + '_' + ticketNumber;
        }else if (serviceName.equalsIgnoreCase('LinkClaimPaymentImage')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: LinkClaimPaymentImage');
            searchparameter = 'LinkClaimPaymentImage';
        }else if(serviceName.equalsIgnoreCase('PurgedORSGetContent')){
            //US3178047
            searchparameter = 'PurgedORSGetContent';
        }else if(serviceName.equalsIgnoreCase('LinkBulkRecovery')){
            //US3449703
			String checkNbr = requestParamsMap.containsKey('chkNbr') ? requestParamsMap.get('chkNbr') : '';
            searchparameter = checkNbr +'_'+'BulkRecoveryResponse';
        }
	else if (serviceName.equalsIgnoreCase('ADBNPSEndpoint')) {
    System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: ADBNPSEndpoint');
    ADBNPSDetailsWrapper reqbody = (ADBNPSDetailsWrapper)System.JSON.deserialize(requestBody, ADBNPSDetailsWrapper.class);
    String memberId = reqbody.memberId;
    if(String.isNotBlank(memberId)){
	searchparameter = 'NPSMockResponse_' +memberId;
    }
	}else if (serviceName.equalsIgnoreCase('ADBMyUhcServiceEndpoint')) {
    System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: ADBMyUhcServiceEndpoint');
    ADBMyUhcDetailsWrapper reqbody = (ADBMyUhcDetailsWrapper)System.JSON.deserialize(requestBody, ADBMyUhcDetailsWrapper.class);
    searchparameter = 'MyUHCMockResponse_' +reqbody.memberId+'_'+reqbody.firstName+'_' +reqbody.lastName+'_'+reqbody.dob+'_'+reqbody.groupId;
	}
else if (serviceName.equalsIgnoreCase('ADBRepeatCallerEndpoint')) { 
		System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: ADBRepeatCallerEndpoint'); 
		requestBody = requestBody.replaceAll('_ENT', 'Z_ENT');
		ADBRepeatCallerWrapper reqbody = (ADBRepeatCallerWrapper)System.JSON.deserialize(requestBody, ADBRepeatCallerWrapper.class);
    system.debug('@@ reqbody'+reqbody);
		searchparameter = 'RepeatCallMockResponse_' +reqbody.Z_ENT_ContactConstituentID+'_'+reqbody.Z_ENT_ContactFirstNm+'_' +reqbody.Z_ENT_ContactLastNm+'_'+reqbody.Z_ENT_ContactDOB; 
	} 
	else if (serviceName.equalsIgnoreCase('Covid19_ImmunizationEndpoint')) {
            System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: Covid19_ImmunizationEndpoint');
            system.debug('@@ requestBody'+requestBody);
            String fName = requestBody.substringBetween('fst_nm: {_eq: \\"','\\"}');
            String lName = requestBody.substringBetween('lst_nm: {_eq: \\"','\\"}');
            String dob = requestBody.substringBetween('bth_dt: {_eq: \\"','\\"}');
            
            searchparameter = 'Covid19MockResponse_' +fName+'_'+lName+'_'+dob;
		}else if(serviceName.equalsIgnoreCase('LinkAppealSearch')){
         			String taxId = requestParamsMap.containsKey('tin') ? requestParamsMap.get('tin') : '999999999';
         			searchparameter = taxId + '_AppealResponse';
         		}
        /*  else if (serviceName.equalsIgnoreCase('LinkExtendedCoverage')) {
			String transactionId = requestParamsMap.get('transactionId');
			searchParameter = 'ExtendedCoverage_' + transactionId.remove('-').remove('%').substring(0, 23);
		} else if (serviceName.equalsIgnoreCase('EAIPGetProfileInfo')) {

		} else if (serviceName.equalsIgnoreCase('ORSSelectIssue')) {

		} */
		System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: searchparameter: ' + searchparameter);
		if (String.isNotBlank(searchParameter)) {
			httpRes = getMockData(searchParameter, wsConfigMap);
		}
		System.debug('@@ ACET_WebserviceMockFramework: getMockResponse: httpRes: ' + httpRes);
		return httpRes;
	}

	/* public static HttpResponse getMockData(String searchParameter, Map < String, Object > wsConfigMap) {
		HttpResponse httpRes = new HttpResponse();
		String responseString = '';
		String wsConfigStatus = '';
		String status = '';
		try {
			String mockResponseFileName = [SELECT FileName__c FROM Mock_Response_Details__c WHERE SearchParameter__c =: searchparameter].FileName__c;
			System.debug('@@ ACET_WebserviceMockFramework: getMockData: mockResponseFileName: ' + mockResponseFileName);
			if (String.isNotBlank(mockResponseFileName)) {
				responseString = [SELECT VersionData from ContentVersion WHERE ContentDocument.Title =: mockResponseFileName AND IsLatest = true LIMIT 1].VersionData.toString();
			}
			System.debug('@@ ACET_WebserviceMockFramework: getMockData: responseString: ' + responseString);
			if (String.isNotBlank(responseString)) {
				httpRes.setStatusCode(200);
				httpRes.setStatus('Getting Mock Data');
				httpRes.setBody(responseString);
			} else {
				httpRes.setStatusCode(500);
				wsConfigStatus = wsConfigMap.containsKey('E500__c') ? (String) wsConfigMap.get('E500__c') : null;
				status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : status;
				httpRes.setStatus(status);
				httpRes.setBody(responseString);
			}
		} catch (QueryException qe) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockData: qe: ' + qe.getStackTraceString());
			httpRes.setStatusCode(500);
			wsConfigStatus = wsConfigMap.containsKey('E500__c') ? (String) wsConfigMap.get('E500__c') : null;
			status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : status;
			httpRes.setStatus(status);
			httpRes.setBody(responseString);
		}
		System.debug('@@ ACET_WebserviceMockFramework: getMockData: httpRes: ' + httpRes);
		return httpRes;
	} */

	public static HttpResponse getMockData(String searchParameter, Map < String, Object > wsConfigMap) {
		HttpResponse httpRes = new HttpResponse();
		AcetLinkStaticResponse__mdt acetStaticResponse;
		String responseString = '';
		String wsConfigStatus = '';
		String status = '';
		try {
            Mock_Response_Details__c mockResponseRec = [SELECT Status_Code__c, FileName__c FROM Mock_Response_Details__c WHERE SearchParameter__c =: searchparameter LIMIT 1];
		System.debug('@@ ACET_WebserviceMockFramework: getMockData: acetStaticResponse: ' + acetStaticResponse);
		if (String.isNotBlank(mockResponseRec.FileName__c)) {
			responseString = [SELECT Body FROM StaticResource WHERE Name =: mockResponseRec.FileName__c LIMIT 1].Body.toString();
		}
		System.debug('@@ ACET_WebserviceMockFramework: getMockData: responseString: ' + responseString);
		if (String.isNotBlank(responseString)) {
			httpRes.setStatusCode(Integer.valueOf(mockResponseRec.Status_Code__c) );
			httpRes.setStatus('Getting Mock Data');
			httpRes.setBody(responseString);
		}else {
			httpRes.setStatusCode(999);
			wsConfigStatus = wsConfigMap.containsKey('E500__c') ? (String) wsConfigMap.get('E500__c') : null;
			status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : status;
			httpRes.setStatus(status);
			httpRes.setBody(responseString);
		}

/*if(wsConfigMap.containsKey('is_Down_Time__c') && Boolean.valueOf(wsConfigMap.get('is_Down_Time__c')))
{
			if(wsConfigMap.containsKey('is_Have_Fault_Code__c') && Boolean.valueOf(wsConfigMap.get('is_Have_Fault_Code__c')))
			{
				String faultCode=String.isBlank(String.valueOf(wsConfigMap.get('Fault_Code__c')))?null:String.valueOf(wsConfigMap.get('Fault_Code__c'));
				String respMsg='{"faultCode":"'+faultCode+'","message":"Unexpected error occurred. Please try again. If problem persists contact help desk."}';
				httpRes.setBody(respMsg);
			}else
			{
				httpRes.setBody('');
			}
			httpRes.setStatusCode(Integer.valueOf(wsConfigMap.get('Status_Code__c')));
			//wsConfigStatus = wsConfigMap.containsKey('E500__c') ? (String) wsConfigMap.get('E500__c') : null;
			status = 'Mock Error';//String.isNotBlank(wsConfigStatus) ? wsConfigStatus : status;
			httpRes.setStatus(status);

}
else
{

		String mockResponseFileName = [SELECT FileName__c FROM Mock_Response_Details__c WHERE SearchParameter__c =: searchparameter].FileName__c;
		System.debug('@@ ACET_WebserviceMockFramework: getMockData: acetStaticResponse: ' + acetStaticResponse);
		if (String.isNotBlank(mockResponseFileName)) {
			responseString = [SELECT Body FROM StaticResource WHERE Name =: mockResponseFileName LIMIT 1].Body.toString();
		}
		System.debug('@@ ACET_WebserviceMockFramework: getMockData: responseString: ' + responseString);
		if (String.isNotBlank(responseString)) {
			httpRes.setStatusCode(200);
			httpRes.setStatus('Getting Mock Data');
			httpRes.setBody(responseString);
		}/* else {
			httpRes.setStatusCode(500);
			wsConfigStatus = wsConfigMap.containsKey('E500__c') ? (String) wsConfigMap.get('E500__c') : null;
			status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : status;
			httpRes.setStatus(status);
			httpRes.setBody(responseString);
		}
}*/
		} catch (QueryException qe) {
			System.debug('@@ ACET_WebserviceMockFramework: getMockData: qe: ' + qe.getStackTraceString());
			httpRes.setStatusCode(500);
			wsConfigStatus = wsConfigMap.containsKey('E500__c') ? (String) wsConfigMap.get('E500__c') : null;
			status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : status;
			httpRes.setStatus(status);
			httpRes.setBody(responseString);
		}
		System.debug('@@ ACET_WebserviceMockFramework: getMockData: httpRes: ' + httpRes);
		return httpRes;
	}

}