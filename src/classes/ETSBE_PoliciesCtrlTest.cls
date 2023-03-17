@isTest
public class ETSBE_PoliciesCtrlTest {

     @testSetup static void setup() {
        ISL_Webservice_Config__c configObj = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_POLICYSEARCH_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_POLICYSEARCH_SERVICENAME,
            SAEConstants.SAE_POLICYSEARCH_VALUE
        );
        System.assertNotEquals(configObj, null);
        TTS_Access__c ttsObj = SAETestDataFactory.createTTSAccess(
            SAEConstants.TA_TOPIC,
            SAEConstants.TA_TYPE,
            SAEConstants.TA_SUBTYPE,
            SAEConstants.TA_PERMISSION
        );
    }
    
    static testMethod void test_getMemberPolicyNetworkInfo() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMock());
        Map<String, Object> response = new Map<String, Object>();
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals('In-Network', response.get('networkStatus'));
        System.debug('Test Result::: '+ response);
        
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor400());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor500());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor5001());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor5002());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor5003());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor5004());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor5005());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor404());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
         Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBEWebserviceMockFor422());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForElse());
        response =  ETSBE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertEquals(null, response.get('networkStatus'));
        ETSBE_PoliciesCtrl.getErrorMessage('404');
    } 
    
    static testMethod void test_getOptumExlusions(){
        List<UHG_Restricted_Plans__mdt> expectedOutcome = new List<UHG_Restricted_Plans__mdt>();
        expectedOutcome = ETSBE_PoliciesCtrl.getOptumExlusions();
        System.debug('Test Result::: '+ expectedOutcome);
        // System.assertEquals('X168504',expectedOutcome[0].DeveloperName);
        System.assertNotEquals(expectedOutcome, NULL);
    }

    static testMethod void test_getTTSFilterMapKeyStr() {
        Test.startTest();
        list<String> lstStr = ETSBE_PoliciesCtrl.getTTSFilterMapKeyStr('View Payments');
        System.assertNotEquals(lstStr, NULL);
        ETSBE_MemberCoveragesResult coverages = new ETSBE_MemberCoveragesResult();
        ETSBE_MemberCoveragesResult.FinancialsWrapper financials  = new ETSBE_MemberCoveragesResult.FinancialsWrapper();
        financials.yearType = 'Test';
        financials.displayYear = 'Test';
        financials.isHra = true;
        financials.hraVal = 123;
        ETSBE_MemberCoveragesResult.Financials fin = new ETSBE_MemberCoveragesResult.Financials();
        fin.dedFound = true;
        fin.deductible = 123;
        fin.dedAmountRem = 123;
        fin.dedSatisfied = 123;
        fin.dedPrecentage = 123;
        fin.dedFoundFam = true;
        fin.deductibleFam = 123;
        fin.dedAmountRemFam = 123;
        fin.dedSatisfiedFam = 123;
        fin.dedFamPrecentage = 123;
        fin.outOPFound = true;
        fin.outOP = 123;
        fin.outOPRemAmount = 123;
        fin.outOPSatisfied = 123;
        fin.oopPrecentage = 123;
        fin.outOPFoundFam = true;
        fin.outOPFam = 123;
        fin.outOPRemAmountFam = 123;
        fin.outOPSatisfiedFam = 123;
        fin.oopFamPrecentage = 123;
        fin.OOP_Limit_2_Found = true;
        fin.OOP_Limit_2 = 123;
        fin.OOP_Limit_2_Satisfied = 123;
        fin.OOP_Limit_2_Rem = 123;
        fin.OOP_Limit_2_Precentage = 123;
        fin.OOP_Limit_2_Found_Family = true;
        fin.OOP_Limit_2_Family = 123;
        fin.OOP_Limit_2_Satisfied_Family = 123;
        fin.OOP_Limit_2_Rem_Family = 123;
        fin.OOP_Limit_2_Precentage_Family = 123;
        fin.CopayMax_Found = true;
        fin.CopayMax = 123;
        fin.CopayMax_Satisfied = 123;
        fin.CopayMax_Remaining = 123;
        fin.CopayMax_Precentage = 123;
        fin.CopayMax_Found_Family = true;
        fin.CopayMax_Family = 123;
        fin.CopayMax_Satisfied_Family = 123;
        fin.CopayMax_Remaining_Family = 123;
        fin.CopayMax_Precentage_Family = 123;
        fin.DedCarryOverAmt = 123;
        fin.ComDED = 123;
        fin.ComOOP = 123;
        fin.CrossApplyOOP = 123;
        fin.OOP2Remaining = 123;
        fin.CrossApplyOOP2 = 123;
        fin.CopayMaxSatisfied = 123;
        fin.CopayMaxRemaining = 123;
        fin.CrossApplyCopayMax = 123;
        fin.DedCarryOverAmt_Family = 123;
        fin.ComDED_Family = 123;
        fin.ComOOP_Family = 123;
        fin.CrossApplyOOP_Family = 123;
        fin.OOP2Remaining_Family = 123;
        fin.CrossApplyOOP2_Family = 123;
        fin.CopayMaxSatisfied_Family = 123;
        fin.CopayMaxRemaining_Family = 123;
        fin.CrossApplyCopayMax_Family = 123;
        financials.inNetwork = fin;
        financials.onNetwork = fin;
        financials.tierOne = fin;
        
        Test.stopTest();
    }
    
    static testMethod void test_getTTSFilterMapValueStr() {
        Test.startTest();
        list<String> lstStr = ETSBE_PoliciesCtrl.getTTSFilterMapValueStr('View Payments', 'Issue Resolved');
        System.assertNotEquals(lstStr, NULL);
        Test.stopTest();
    }
    @isTest static void TestGetCoverageLevel()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        ETSBE_PoliciesCtrl.getCoverageLevel(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }

    @isTest static void TestGetCoverageLevel_Exception()
    {
        Test.startTest();
        ISL_Webservice_Config__c cs = ISL_Webservice_Config__c.getValues('SAE_PolicySearch');
        delete cs;

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        ETSBE_PoliciesCtrl.getCoverageLevel(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
      
        Test.stopTest();
    }

}