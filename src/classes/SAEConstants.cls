public without sharing class SAEConstants
{

    public static String STARGATE_STG_SERVICENAME = 'Stargate';
    public static String STARGATE_PRD_SERVICENAME = 'Stargate_prod';

    // ISL_Webservice_Config__c - SAE_PolicySearch
    public static String SAE_POLICYSEARCH_NAME = 'SAE_PolicySearch';
    public static String SAE_POLICYSEARCH_COMMON_NAME = 'SAE_PolicySearch';
    public static String SAE_POLICYSEARCH_VALUE = 'https://api-gateway-stage.linkhealth.com/elink-extended/api/coverageAttributes/v2.0';
    public static Boolean SAE_POLICYSEARCH_ERRORLOG_ENABLED = false;
    public static Boolean SAE_POLICYSEARCH_ISAVAILABLE = true;
    public static Integer SAE_POLICYSEARCH_PAGESIZE = 0;
    public static String SAE_POLICYSEARCH_SERVICENAME = 'SAE_PolicySearch';
    public static String SAE_POLICYSEARCH_ISLWEBSERVICE_EID = '';
    public static Boolean SAE_POLICYSEARCH_SCOPEHEADER_FLAG = true;
    public static String SAE_POLICYSEARCH_STATICRESOURCE_NAME = 'SAEExtendedCoverageWSResponse';
    public static String SAE_NetworkStatusService_STATICRESOURCE_NAME = 'SAENetworkStatusWSResponse';
    public static String SAE_POLICYSEARCH_TRANSACTION_ID = 'uk5gepl1%2BBGe%2B7Z7IJ7o0fj%2BTG89hft8j6d4dxa3s2K%2FKDOxWlipGU9XVqEj4vjer2FHSsyVJb5TEzhlO4mBDNy3qmYTPi78cMnYtGRJASrhbuuKYqrNt8lSrr4rj%2FUdoW%2BO2DPXjdUdzQZn28pDiazuPQgjRISToHmKeWfnroFBMpURqH9EOoYWqjjEAsoX';
    public static String SAE_NOPOLICY_TRANSACTION_ID = 'qew32epl1%2BBGe%2B7Z7IJ7o%eqweqwewqekjhj3s2K%2FKDOxWlipGU9XVqEj4vj';
    public static String SAE_NOCDHPPOLICY_TRANSACTION_ID = 'qew32epl1%2BBGe%2B7Z7IJ7o%eqweqwewqeksadasadsajhj3s2K%2FKDOxWlipGU9XVqEj4vj';
    // ISL_Webservice_Config__c - SAE_ProviderSearch
    public static String SAE_MEMBERPROVIDER_NAME = 'SAE_ProviderSearch';
    public static String SAE_MEMBERPROVIDER_SERVICENAME = '';
    public static String SAE_MEMBERPROVIDER_STATICRESOURCE_NAME = 'SAEEligibilityResponseMockData';
    public static String SAE_MEMBERPROVIDER_VALUE = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0';
    public static String SAE_MEMBERPROVIDER_TRANSACTION_ID = null;
    public static String queryParameter = 'searchOption=NameDateOfBirth&payerID=87726&lastName=Galleco&firstName=Caleb&providerLastName=WILSON&providerFirstName=GARY&dateOfBirth=1956-11-03&groupNumber=&serviceStart=&serviceEnd=&taxIdNumber=751281410&providerNameID=0000012348&npi=1234549014';

    // Policy Details
    public static String SAE_POLICYDETAILS_TYPE = 'POS';
    public static String SAE_POLICYDETAILS_GROUPNUMBER = 'N/A';

    // COB
    public static String SAE_COB_STATICRESOURCE_NAME = 'SAE_COB_WS_Response_NEW';
    public static String SAE_COB_LASTUPDATED_DATE = null;
    public static String SAE_COB_COMMENTS = 'Not Applicable';
    public static String SAE_COB_MEDICAREINDICATOR = 'Medicare applies';
    public static String SAE_COBHISTORY_PRIMARYGROUPINDICATOR = 'N';
    public static String SAE_COBHISTORY_PAYERNAME = 'HORIZON BCBS OF NEW JERSEY' ;
    public static String SAE_COBHISTORY_COVERAGETYPE = 'Commercial';
    public static String SAE_COBHISTORY_POLICYEFFECTIVEDATES = '06/01/2015 - 07/31/2019';

    // HouseHold
    public static String SAE_HOUSEHOLD_DETAIL_MAINMEMBER_FIRSTNAME = 'AMANDA';
    public static String SAE_HOUSEHOLD_DETAIL_MAINMEMBER_LASTNAME = 'ADAM';
    public static String SAE_HOUSEHOLD_DETAIL_MAINMEMBER_MEMBERID = '956876492';

    // Member Provider
    public static String SAE_MEMBERPROVIDER_MEMBERID = '956876492';
    public static String SAE_MEMBERPROVIDER_DOB = '1977-06-08';
    public static String SAE_MEMBERPROVIDER_FNAME = 'AMANDA';
    public static String SAE_MEMBERPROVIDER_LNAME = '';
    public static String SAE_MEMBERPROVIDER_GROUPNUMBER = null;
    public static String SAE_MEMBERPROVIDER_SEARCHOPTION = 'MemberIDDateOfBirth';
    public static String SAE_MEMBERPROVIDER_PAYERID = '87726';

    // Bookmark Links
    public static String SAE_BOOKMARKLINKS_DISPLAYNAME_SAMPLE = 'Sample';
    public static String SAE_BOOKMARKLINKS_URL_SAMPLE = 'sample.page';
    public static Boolean SAE_BOOKMARKLINKS_ACTIVE = true;

    // Profiles
    public static String SAE_PROFILE_SYSADMIN_NAME = 'System Administrator';
    public static String SAE_PROFILE_PROVIDERSERVICE_NAME = 'Provider Service';

    // Users
    public static String SAE_USER_SYSADMIN_LASTNAME = 'Admin';
    public static String SAE_USER_PROVIDER_LASTNAME = 'Provider';
    public static String SAE_USER_SYSADMIN_ALIAS = 'standt';
    public static String SAE_USER_PROVIDER_ALIAS = 'provus';
    public static String SAE_USER_SYSADMIN_EMAIL = 'sysadmin@testorg.com';
    public static String SAE_USER_PROVIDER_EMAIL = 'provider@testorg.com';
    public static String SAE_USER_EMAILENCODINGKEY = 'UTF-8';
    public static String SAE_USER_LANGLOCALEKEY  = 'en_US';
    public static String SAE_USER_LOCALESIDKEY = 'en_US';
    public static String SAE_USER_TIMEZONESIDKEY = 'America/Los_Angeles';
    public static String SAE_USER_ADMIN_USERNAME = 'saesysadmin@testorg.com.acet';
    public static String SAE_USER_PROVIDER_USERNAME = 'saeprovider@testorg.com.acet';

    // 400 Error Code
    public static final String GN400 = 'GN400';
    // 500 Error Code
    public static final String GN500A = 'GN500A';
    // 404 Error Code
    public static final String GN404 = 'GN404';
	// 100 Error Code
    public static final String GN100 = 'GN100';
	
    //Exception Error Message
    public static final String debugMsg = 'Error Occured {ClassName} at {LineNumber}';

    //Coverage code translation values - US1974546
    public static final Map<String,String> COVERAGELEVEL = new Map<String,String>{
            '1' => 'SUBSCRIBER ONLY',
            '2' => 'SUBSCRIBER AND CHILD(REN)',
            '3' => 'SUBSCRIBER AND SPOUSE',
            '4' => 'SUBSCRIBER AND FAMILY',
            '5' => 'SUBSCRIBER AND FAMILY WITH STUDENT',
            '6' => 'SPOUSE AND CHILD ONLY',
            '7' => 'SUBSCRIBER, SPOUSE AND ONE CHILD',
            '8' => 'SUBSCRIBER AND ONE DEPENDENT',
            '9' => 'SUBSCRIBER AND ONE CHILD'
        };

    //Find Individual Service (Member Standalone Search)
    public static final String SAE_OIL_ENDPOINT = 'https://api.optum.com:8444/api/eisl/individuals/v2.0/search';
    public static final String SAE_INDIVIDUAL_RESPONSE_NAME = 'SAEMemberStandaloneSearchWebServiceResponse';

    // Topic Access
    public static final String TA_TOPIC = 'View Payments';
    public static final String TA_TYPE = 'Issue Resolved';
    public static final String TA_SUBTYPE = 'Verify Eligibility';
    public static final String TA_PERMISSION = 'System Administrator';

    //ClaimSearch
    public static final String SAE_CLAIM_SUMMARY_RESPONSE_NAME = 'SAEClaimSummaryResponse';
    public static final String SAE_CLAIM_DETAILS_RESPONSE_NAME = 'SAEClaimDetailsResponse';

    //SAE PCP History
    public static final String SAE_PCP_HISTORY_ENDPOINT ='https://api-gateway-stage.linkhealth.com/elink-extended/api/pcpEmployerHistory/v2.0';
    public static final String SAE_PCP_HISTORY_TRANSCATIONID='JtQ%2Fcb3JfuOrPTbdYtIao5H9s30ZliureXFogLFHUIKcgGI91XVGB78StJt7Q4CqG4OY18NTENci218QBCwJ0BNbhSRx4jViMjedpis6LdX5Hq%2BqB8ZlWFU2lVI2A1ASwZ8VKwJjEMcRTVg871%2BoWr7V3MnbJIvvygVn3bbEGPk%3D';
    public static String SAE_PCP_HISTORY_STATICRESOURCE_NAME = 'SAEPCPHISTORYRESPONSE';
	
	//SAE Access Token Scheduler
    public static String SAE_GetACCESSTOKENSCHEDULER = 'SAEGetAccessTokenScheduler';
    public static String SAE_GetACCESSTOKENSCHEDULER_ENDPOINT = '50f766e3-c685-4e7d-a7d6-423c76b24cd5';

    //Authorization Constatnts
    public static final String FIND_AUTH_RESP = 'FindAuthMock';
    public static String FIND_AUTH_TRANSACTION_ID = 'uk5gepl1%2BBGe%2B7Z7IJ7o0fj%2BTG89hft8j6d4dxa3s2K%2FKDOxWlipGU9XVqEj4vjer2FHSsyVJb5TEzhlO4mBDNy3qmYTPi78cMnYtGRJASrhbuuKYqrNt8lSrr4rj%2FUdoW%2BO2DPXjdUdzQZn28pDiazuPQgjRISToHmKeWfnroFBMpURqH9EOoYWqjjEAsoX';
    public static final String FIND_AUTH_RESOURCE_URL = 'https://api.optum.com:8443/api/eisl/clinical/medicalhealthservicecaseauthorizations/v3.0/search';
    public static final String GET_AUTH_RESP = 'GetAuthMock';
    public static final String GET_AUTH_RESOURCE_URL = 'https://api.optum.com:8443/api/eisl/clinical/medicalhealthservicecaseauthorizations/v3.0/read';
    
    // US1741780 Copay Coinsurance constants COPAY_COINSURANCE_RESOURCE_URL 
    public static final String COPAY_COINSURANCE_RESP = 'ACET_CopayCoInsuranceMock';
    public static final String COPAY_COINSURANCE_RESOURCE_URL = 'https://api-gateway-stage.linkhealth.com/elink-services/api/copayAdditionalCoinsuranceDetailsV4';
   //Find Medical Authorization  Callout Response Status Code Custom Error Messages Map US2331223 _by Vishnu
    public static final Map<Integer,String> viewAuthStatusCodeErrorMSG = new Map<Integer,String>{
			400 => 'Unexpected error occurred. Please try again. If problem persists contact help desk.',
            404 => 'No Results Found',
            500 => 'Unexpected error occurred. Please try again. If problem persists contact help desk.'};
    
    //this map contains the status codes ann it's fault code values
    Public Static final Map<Integer, Set<String>> RESPONSECODE_FAULTCODE_MAP=new  Map<Integer, Set<String>>{
                                                                                                            400 =>new Set<String>{'ED270UG','AAA:Fault Code','ED270IP','ED270BP','ED270BR'},
                                                                                                            500 =>new Set<String>{'ED270SE','ED270UE','AEFNEE'},
                                                                                                            404 =>new Set<String>{'AEFNND'},
                                                                                                            422 =>new Set<String>{'ED270NP'},
                                                                                                            424 =>new Set<String>{'ED270UR','AAA:42'},
                                                                                                            406 =>new Set<String>{'ED270IA'}
                                                                                                        };

    //US2076634 - HIPAA Guidelines Button - Sravan
    public static final String KNOWLEDGE_CENTRAL_URL = 'KnowledgeCentral_Url';

    public static final String ONE_SOURCE_LINK = 'OneSourceLink';

    // US2678228
    public static String SAE_PROPERUSE_STATICRESOURCE_NAME = 'ProperUseAPIResource';
	public static String SAE_PROPERUSE_VALUE = 'https://gateway-stage.optum.com/api/dev/cdm/dg/jwt-properuses/v2.0/proper-uses?group-name=PAT_DABA';

    // US2646403
    public static String SAE_RCED_STATICRESOURCE_NAME = 'RCEDAPIResource';
	public static String SAE_RCED_API_VALUE = 'https://gateway-stage.optum.com/api/systest/cel/consumer/eligibilities/v1/read/testClassEndPoint';
	public static String SAE_CLAIM_DOCUMENTS_API_VALUE = 'https://gateway-stage.optum.com/api/ecs/doc360/document-results/v1/search/testClassEndPoint';

    // US3137520
    public final static String ORGNAME_QA = 'qa';

    //US3219740
    public final static String PROVIDER_NOTIFICATION_TOOL = 'ProviderNotificationTool';

     //US3583813
    public final static String SOP_LINK = 'SopLink';

}