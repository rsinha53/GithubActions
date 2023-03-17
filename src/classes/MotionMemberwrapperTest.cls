@isTest
public with sharing class MotionMemberwrapperTest {
    static testMethod void testParse() {
        String json = '{'+
       	'    \"PageDetails\": {'+
		'        \"Total\": 264,'+
		'        \"Offset\": 1,'+
		'        \"Limit\": 25,'+
		'        \"TotalPages\": 11,'+
		'        \"LastPage\": false'+
		'    },'+
		'    \"data\": ['+
        '            {'+
		'            \"RegisteredMemberID\": 133084,'+
		'            \"EligibleMemberID\": null,'+
		'            \"EmailAddress\": \"AutoCG_test_TCDPANG_DARREN_JOHNS_ATEST092322843612\",'+
		'            \"GroupName\": \"AutoCG_test_TCDPANG_HSA_ACIS001\",'+
		'            \"Status\": \"Active\",'+
		'            \"GenderCode\": \"F\",'+
		'            \"Phone\": \"3142345645\",'+
		'            \"Address\": \"0923228436 1265173242\",'+
		'            \"State\": \"MINNESOTA\",'+
		'            \"Role\": \"Admin\",'+
		'            \"ClientName\": \"Small Business\",'+
		'            \"Weight\": null,'+
		'            \"PlanType\": \"FI-OPTUMB HSA\",'+
		'            \"MaxDailyEarnings\": null,'+
		'            \"TimeZone\": null,'+
		'            \"MonthlyEmail\": false,'+
		'            \"WeeklyEMail\": false,'+
		'            \"OptOutAllEmails\": false,'+
		'            \"SyncFrequency\": 0,'+
		'            \"FraudTier\": null,'+
		'            \"FraudLockout\": false,'+
		'            \"DoNotLockAccount\": false,'+
		'            \"AlternateActivityEligible\": false,'+
		'            \"AlternateActivityOptInStatus\": false,'+
		'            \"ActiveMEMBERFlag\": true,'+
		'            \"AccountActiveFlag\": false,'+
		'            \"Id\": 0,'+
		'            \"LookupClientId\": 245,'+
		'            \"ClientMemberId\": null,'+
		'            \"FirstName\": \"DARREN\",'+
		'            \"LastName\": \"JOHNS\",'+
		'            \"PlanId\": 116915,'+
		'            \"Gender\": \"ERROR\",'+
		'            \"SSN\": null,'+
		'            \"HomePhone\": null,'+
		'            \"City\": \"0923228436\",'+
		'            \"StateCode\": null,'+
		'            \"ZipCode\": \"12651\",'+
		'            \"Active\": false,'+
		'            \"Relationship\": \"EE\",'+
		'            \"BirthDate\": \"1971-07-05T00:00:00\",'+
		'            \"PlanState\": null,'+
		'            \"IsPreload\": false,'+
		'            \"Height\": null,'+
		'            \"OfferCode\": \"TCDPANG\",'+
		'            \"CancelledDateTime\": \"9999-12-31T23:59:59\",'+
		'            \"ProgramStartDate\": \"2020-01-01T00:00:00\",'+
		'            \"UhcMemberId\": null,'+
		'            \"AlternateId\": null,'+
		'            \"EmployerAssignedId\": null,'+
		'            \"AccountType\": null'+
		'        }'+
		'    ]'+
		'}';
       /* ''+
        '     \"memberRecord\":'+
        ''+
        '     ['+
        ''+
        '          {'+
        ''+
        '               \"RegisteredMemberID\":618825,'+
        '               \"EligibleMemberID\":1009501,'+
        '               \"FirstName\":\"TIM\",'+
        '               \"LastName\":\"TODD\",'+
        '               \"BirthDate\":\"1998-07-04T00:00:00\",'+
        '               \"DependentCode\":\"EE\",'+
        '               \"EmailAddress\":\"AutoCG_test_TCBQDSV_TIM_TODD_ATEST0285518859061773\",'+
        '               \"Address1\":\"0285518859 0617737566\",'+
        '               \"City\":\"\",'+
        '               \"State\":\"\",              '+
        '               \"PlanType\":\"HSA\",'+
        '               \"Gender\":\"F\",'+
        '               \"GroupName\":\"AutoCG_test_TCBQDSV_HSA_ACIS001\",'+
        '               \"LookupRuleGroupID\":78793,'+
        '               \"ClientName\":\"Key Accounts UHCM\",'+
        '               \"Status\":\"Active\"'+
        ''+
        '          },'+
        ''+
        '          {'+
        ''+
        '               \"RegisteredMemberID\":646711,'+
        '               \"EligibleMemberID\":1037387,'+
        '               \"FirstName\":\"TIM\",'+
        '               \"LastName\":\"TODD\",'+
        '               \"BirthDate\":\"2006-11-08T00:00:00\",'+
        '               \"DependentCode\":\"EE\",'+
        '               \"EmailAddress\":\"AutoCG_test_TCBQDSV_TIM_TODD_ATEST0898417051112537\",'+
        '               \"Address1\":\"0898417051 1125377566\",'+
        '               \"City\":\"\",'+
        '               \"State\":\"\",'+
        '               \"PlanType\":\"HSA\",'+
        '               \"Gender\":\"F\",'+
        '               \"GroupName\":\"AutoCG_test_TCBQDSV_HSA_ACIS001\",'+
        '               \"LookupRuleGroupID\":78793,'+
        '               \"ClientName\":\"Key Accounts UHCM\",'+
        '               \"Status\":\"Active\"'+
        ''+
        '          }'+
        ''+
        '     ],'+
        ''+
        '     \"pagination\":'+
        ''+
        '     {'+
        ''+
        '               \"TotalPages\":1,'+
        '               \"NumberOfRecordsPerPage\":25,'+
        '               \"CurrentPageNumber\":1,'+
        '               \"TotalRecordsCount\":2,'+
        '               \"LastPageFlag\":true'+
        ''+
        '     }'+
        ''+
        '}';*/
        MotionMemberwrapper obj = MotionMemberwrapper.parse(json);
        System.assert(obj != null);
        system.debug('response'+obj );
        
        Motion_MemberSearchResults.setCredentialData(obj);
        Motion_MemberSearchResults.setPaginations(obj.Pagination);
    }
}