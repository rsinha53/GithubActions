/*
 * @Desc: US2034021 - Handle the Find Individuals WS Callout and the related filter logic 
 * @Date: 12-09-2019
 * @Dev: Malinda
 */
public class SAEMemberStandaloneSearchWebService extends ACETWebService {

    static final Integer RESPONSE_SUCCESS_CODE = 200;
    static final String SOURCE_SYS_CODE_CS = 'CS';
    static final String SOURCE_SYS_CODE_CR = 'CR';
    static final String SOURCE_SYS_CODE_PA = 'PA';
    static final String SOURCE_SYS_CODE_AP = 'AP';
    static final String SOURCE_SYS_CODE_CO = 'CO';
    static final String SOURCE_SYS_CODE_OX = 'OX';
    static final String OIL_AUTHENTICATION = 'OIL';
    static final String OIL_RESOURCE = 'SearchMembersEndpoint'; //'MemberStandaloneSearch'; //US2924748 - Avish
    static final string COMMON_ERROR_MESSAGE = 'Unexpected Error Occurred on the Member Results . Please try again. If problem persists please contact the help desk.';

    public SAEMemberStandaloneSearchWebService() {
        super(SAEConstants.STARGATE_STG_SERVICENAME);
        // US3137520
        if (Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c) {
            this(SAEConstants.STARGATE_PRD_SERVICENAME);
        }
    }

    // US3137520
    public SAEMemberStandaloneSearchWebService(String serviceName) {
        super(serviceName);
    }

    //set endpoints
    public override void getEndpoint() {
        GetEndpointDetail(OIL_RESOURCE);
        //BaseURL = 'https://api.optum.com:8444'; //US2924748 - Avish
    }

    //create request body
    public void getRequestBody(String memberId) {
        // US3204295 - Thanish - 3rd Feb 2021
        List < String > parameters = memberId.split('_');
        RequestBody = '{"findIndividualsRequest" : {"searchId" : "' + parameters[0].trim() + '","searchTypeCode" : "","firstName" : "","lastName" : "","birthDate" : "' + (parameters.size() > 1 ? parameters[1] : '') + '","stateCode" : "","postalCode" : "","telephoneNumber" : "","systemSpecificIndicator" : "","trimLeadingZeros":"Y","pagination" : {"pageNumber" : "1","pageSize" : "10","startRecord" : "1"}}}';
        System.debug('###REQUEST-BODY:' + RequestBody);
    }

    public ACETWSCalloutResult findIndividual(String strMemberId) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try {
            String responseStr = '';
            HttpResponse response;
            //US2505481 : Add Mock response in Lower sandboxes
            Boolean isStaticResponseChecked = false;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            System.debug('@@ SAEMemberStandaloneSearchWebService: findIndividual: isStaticResponseChecked: ' + isStaticResponseChecked);

            if (isStaticResponseChecked && !Test.isRunningTest()) {
                // US3204295 - Thanish - 3rd Feb 2021
                List < String > parameters = strMemberId.split('_');
                String searchparameter = 'findIndividualV2Response_' + parameters[0].trim();
                response = SAEUtils.getResponse(searchparameter);
            } else {
                getEndpoint();
                getRequestBody(strMemberId);
                response = Send(OAuthConfig);
            }
            System.debug('###RESPONSE:' + response);
            System.debug('###RESPONSE-BODY:' + response.getBody());

            //MOCK RESP
            //response.setStatusCode(200);
            //String strFakeBody = '{\"findIndividualsResponse\":{\"individuals\":[{\"individualIdentifier\":\"25427949\",\"name\":{\"firstName\":\"Kristina\",\"lastName\":\"Geisler-Nordholm\",\"middleName\":\"F\",\"nameSuffix\":\"\"},\"birthDate\":\"1983-07-07\",\"genderCode\":\"F\",\"socialSecurityNumber\":\"510880458\",\"address\":{\"typeCode\":\"P\",\"addressLine1\":\"4313 Martha Ave\",\"addressLine2\":\"\",\"city\":\"Sachse\",\"postalCode\":\"75048-4376\",\"stateCode\":\"TX\",\"countryCode\":\"US\",\"countryDescription\":\"\"},\"telephone\":[{\"phoneType\":\"1\",\"phoneNumber\":\"785 554 7302\"},{\"phoneType\":\"4\",\"phoneNumber\":\"785 554 7302\"}],\"identifiers\":[{\"id\":\"00510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"ICUE\"},{\"id\":\"00510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"CS\"},{\"id\":\"00510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"CS\"},{\"id\":\"96202728400\",\"type\":\"MBR\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"96202728400\",\"type\":\"MBR\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"PR\"},{\"id\":\"510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"PR\"},{\"id\":\"818977475\",\"type\":\"SRK\",\"sourceSysCode\":\"ICUE\"},{\"id\":\"27335708\",\"type\":\"SRK\",\"sourceSysCode\":\"CS\"},{\"id\":\"725048727\",\"type\":\"SRK\",\"sourceSysCode\":\"c360\"},{\"id\":\"397248989\",\"type\":\"SRK\",\"sourceSysCode\":\"CS\"},{\"id\":\"438835188\",\"type\":\"SRK\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"389635484\",\"type\":\"SRK\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"547534529\",\"type\":\"SRK\",\"sourceSysCode\":\"UID\"},{\"id\":\"261897282\",\"type\":\"SRK\",\"sourceSysCode\":\"PR\"},{\"id\":\"311817136\",\"type\":\"SRK\",\"sourceSysCode\":\"PR\"}]},{\"individualIdentifier\":\"806052436\",\"name\":{\"firstName\":\"Emery\",\"lastName\":\"Nordholm\",\"middleName\":\"J\",\"nameSuffix\":\"\"},\"birthDate\":\"2019-05-11\",\"genderCode\":\"F\",\"socialSecurityNumber\":\"071679548\",\"address\":{\"typeCode\":\"P\",\"addressLine1\":\"4313 Martha Ave\",\"addressLine2\":\"\",\"city\":\"Sachse\",\"postalCode\":\"75048-4376\",\"stateCode\":\"TX\",\"countryCode\":\"US\",\"countryDescription\":\"\"},\"telephone\":[{\"phoneType\":\"1\",\"phoneNumber\":\"785 554 7302\"}],\"identifiers\":[{\"id\":\"00510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"ICUE\"},{\"id\":\"00510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"CS\"},{\"id\":\"96202728402\",\"type\":\"MBR\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"980470457\",\"type\":\"SRK\",\"sourceSysCode\":\"ICUE\"},{\"id\":\"980145771\",\"type\":\"SRK\",\"sourceSysCode\":\"UID\"},{\"id\":\"964861287\",\"type\":\"SRK\",\"sourceSysCode\":\"CS\"},{\"id\":\"964847257\",\"type\":\"SRK\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"966539862\",\"type\":\"SRK\",\"sourceSysCode\":\"UID\"}]},{\"individualIdentifier\":\"274037521\",\"name\":{\"firstName\":\"Lee\",\"lastName\":\"Nordholm\",\"middleName\":\"\",\"nameSuffix\":\"\"},\"birthDate\":\"1983-04-24\",\"genderCode\":\"M\",\"socialSecurityNumber\":\"523650382\",\"address\":{\"typeCode\":\"P\",\"addressLine1\":\"4313 Martha Ave\",\"addressLine2\":\"\",\"city\":\"Sachse\",\"postalCode\":\"75048-4376\",\"stateCode\":\"TX\",\"countryCode\":\"US\",\"countryDescription\":\"\"},\"telephone\":[{\"phoneType\":\"1\",\"phoneNumber\":\"785 554 7302\"}],\"identifiers\":[{\"id\":\"00510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"ICUE\"},{\"id\":\"96202728401\",\"type\":\"MBR\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"PR\"},{\"id\":\"00510880458\",\"type\":\"SCR\",\"sourceSysCode\":\"CS\"},{\"id\":\"762516355\",\"type\":\"SRK\",\"sourceSysCode\":\"ICUE\"},{\"id\":\"439707395\",\"type\":\"SRK\",\"sourceSysCode\":\"RXCL2\"},{\"id\":\"487220780\",\"type\":\"SRK\",\"sourceSysCode\":\"UID\"},{\"id\":\"440004392\",\"type\":\"SRK\",\"sourceSysCode\":\"PR\"},{\"id\":\"439877315\",\"type\":\"SRK\",\"sourceSysCode\":\"CS\"}]}],\"pagination\":{\"pageNumber\":\"1\",\"pageSize\":\"10\",\"recordCount\":\"3\",\"totalCount\":\"3\",\"totalPages\":\"1\",\"moreRecords\":\"false\"}}}}"';
            //response.setBody(strFakeBody);
            //END OF MOCK


            SAEProviderMemberSearchInteractionResult searchWrapper = new SAEProviderMemberSearchInteractionResult();
            List < SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch > lstResultWrapper;
            SAEMemberStandaloneSearchJSON2Apex searchResult;
            Integer StatusCode = response.getStatusCode();
            calloutResult.statusCode = StatusCode;
            if (StatusCode == RESPONSE_SUCCESS_CODE) {
                lstResultWrapper = new List < SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch > ();
                searchResult = (SAEMemberStandaloneSearchJSON2Apex) JSON.deserialize(response.getBody(), SAEMemberStandaloneSearchJSON2Apex.class);
                if (searchResult != null) {

                    //deduplication for the Syscodes
                    Map < String, SAEMemberStandaloneSearchJSON2Apex.individuals > mapIndividuals = new Map < String, SAEMemberStandaloneSearchJSON2Apex.individuals > ();
                    Map < String, Set < String >> mapIdentifiers = new Map < String, Set < String >> ();
                    for (SAEMemberStandaloneSearchJSON2Apex.individuals ind: searchResult.FindIndividualsResponse.individuals) {
                        mapIndividuals.put(ind.individualIdentifier, ind);
                        Set < String > setSysCode = new Set < String > ();
                        for (SAEMemberStandaloneSearchJSON2Apex.Identifiers identifier: ind.Identifiers) {
                            setSysCode.add(identifier.sourceSysCode);
                        }
                        mapIdentifiers.put(ind.individualIdentifier, setSysCode);
                    }

                    System.debug('###mapIndividuals:' + mapIndividuals);
                    System.debug('###mapIdentifiers:' + mapIdentifiers);

                    //Syscode filtering logic
                    ISETSourceCode__mdt[] isetSCMetaData = [SELECT MasterLabel, Desc__c FROM ISETSourceCode__mdt]; //US2584971 - Avish
                    SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch wrapper;
                    if (!mapIndividuals.isEmpty() && !mapIdentifiers.isEmpty()) {
                        for (SAEMemberStandaloneSearchJSON2Apex.individuals individual: mapIndividuals.values()) {
                            if (mapIdentifiers.containsKey(individual.individualIdentifier)) {
                                Set < String > setSysCode = mapIdentifiers.get(individual.individualIdentifier);
                                if (setSysCode != null && !setSysCode.isEmpty()) {
                                    for (String code: setSysCode) {
                                        //US2584971 - Avish
                                        for (ISETSourceCode__mdt sourceCode: isetSCMetaData) {
                                            if (sourceCode.MasterLabel == code) {
                                                wrapper = new SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch();
                                                wrapper.sourceSysCode = code;
                                                wrapper.firstName = String.isNotEmpty(individual.Name.firstName) ? individual.Name.firstName : '';
                                                wrapper.lastName = String.isNotEmpty(individual.Name.lastName) ? individual.Name.lastName : '';
                                                wrapper.middleName = String.isNotEmpty(individual.Name.middleName) ? individual.Name.middleName : '';
                                                wrapper.birthDate = String.isNotEmpty(individual.birthDate) ? SAEUtils.formatDate(individual.birthDate) : '';
                                                wrapper.fullName = wrapper.firstName + ' ' + wrapper.middleName + ' ' + wrapper.lastName;
                                                wrapper.SSN = String.isNotEmpty(individual.socialSecurityNumber) ? individual.socialSecurityNumber : '';
                                                wrapper.address = populateAddress(individual); //US2589590 - Avish
                                                wrapper.emailIds = individual.electronicAddress != null ? individual.electronicAddress : new List<String>();
                                                lstResultWrapper.add(wrapper);
                                            }
                                        }
                                        //US2584971 - Ends
                                    }
                                } else {
                                    System.debug('###EMPTY-SYS-CODES-FOR-INDIVIDUAL:' + individual.individualIdentifier);
                                    System.debug('###mapIndividuals:' + mapIndividuals);
                                }

                            }
                        }

                    } else {
                        System.debug('###EMPTY-INDIVIDUALS');
                        System.debug('###mapIndividuals:' + mapIndividuals);
                        System.debug('###mapIdentifiers:' + mapIdentifiers);
                    }

                    system.debug('lstResultWrapper@@@ ' + lstResultWrapper);
                    searchWrapper.lstSAEMemberStandaloneSearch = lstResultWrapper;

                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = searchWrapper;

                } else {
                    System.debug('###EMPTY-SEARCH-RESULT');
                    calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    calloutResult.Success = false;
                    calloutResult.statusCode = StatusCode;
                    calloutResult.Message = response.getBody();
                }

            } else { /* Added by Avish as a part of regression defect 10142019*/
                system.debug('Error@@@ ' + response.getBody());
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = false;
                calloutResult.statusCode = StatusCode;
                calloutResult.Message = COMMON_ERROR_MESSAGE;

                /*if (StatusCode == 404) {
                    calloutResult.Message = SAEMemberStandaloneSearchWebService.getErrorMessage(SAEConstants.GN404);
                } else if (StatusCode == 500 || StatusCode == 400) {
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                }*/
                /* End of Regression Defect*/
            }

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = COMMON_ERROR_MESSAGE;
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }

    //US2589590 - Avish
    private SAEProviderMemberSearchInteractionResult.Address populateAddress(SAEMemberStandaloneSearchJSON2Apex.individuals individual) {
        SAEProviderMemberSearchInteractionResult.Address addr = new SAEProviderMemberSearchInteractionResult.Address();
        if (individual.address != null) {
            addr.addressLine1 = String.isNotBlank(individual.address.addressLine1) ? individual.address.addressLine1 : '';
            addr.city = String.isNotBlank(individual.address.addressLine1) ? individual.address.city : '';
            addr.stateCode = String.isNotBlank(individual.address.addressLine1) ? individual.address.stateCode : '';
            addr.postalCode = String.isNotBlank(individual.address.addressLine1) ? individual.address.postalCode : '';
        }
        return addr;
    }
    //US2589590 - Avish Ends
    private String formatDateFromDashToSlash(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        if (dateString.contains('/')) {
            return dateString;
        } else {
            List < String > dateParts = dateString.split('-');
            if (dateParts.size() == 3) {
                String mm = dateParts[1];
                String dd = dateParts[2];
                String yyyy = dateParts[0];

                mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0', '') : mm;
                dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0', '') : dd;

                return mm + '/' + dd + '/' + yyyy;
            } else {
                return dateString;
            }
        }
    }

    public static String getErrorMessage(String errorCode) {
        String errorMessage = '';
        AcetErrorMessage__mdt[] ErrorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c
            FROM AcetErrorMessage__mdt
            WHERE DeveloperName =: errorCode
        ];

        if (ErrorCodes.size() > 0) {
            errorMessage = ErrorCodes[0].Error_Message__c;
        }

        return errorMessage;
    }
}