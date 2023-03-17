@isTest
public class ACETLGT_HSABankAcccountControllerTest {
    
    /*
    public List<ACETLGT_HSATransactionResult> allTransactions_Test = new List<ACETLGT_HSATransactionResult>();    
    
    public class HSASummaryResultWrapper{
        @AuraEnabled public ACETLGT_HSASummaryResult resultWrapper {get;set;}
    }
    public class HSATransactionResultWrapper{
        @AuraEnabled public List<ACETLGT_HSATransactionResult> transactionResultWrapper {get;set;}
    }
    */
    public  class DataWrapper{
        @Auraenabled
        public string responce;
        @Auraenabled 
        public string wrapperdetails;
        public DataWrapper(String responce){
            this.responce = responce;        
        }       
    }
    

    @isTest
    public static void GetHsaSummaryValues_Test(){
        Object hsaSummaryVal = ACETLGT_HSABankAcccountController.GetHsaSummaryValues('703989993');
        Object hsaSummaryVal_Test = ACETLGT_HSABankAcccountController.GetHsaSummaryValues('703989993');        
    }   
    
    @isTest
    public static void GetHsaTrasactionValues_Test(){
        Object hsaSummaryVal = ACETLGT_HSABankAcccountController.GetHsaTrasactionValues('NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','All');
        Object hsaSummaryVal_Test = ACETLGT_HSABankAcccountController.GetHsaTrasactionValues('NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','All');        
    }   
    
    @isTest
    public static void GetHsaDTTrasactionValues_Test(){        
        ACETLGT_HSABankAcccountController.DataWrapper dtWrap = ACETLGT_HSABankAcccountController.GetHsaDTTrasactionValues('NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','All');
        ACETLGT_HSABankAcccountController.DataWrapper dtWrap_Test = ACETLGT_HSABankAcccountController.GetHsaDTTrasactionValues('NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','All');        
    }  
    
    @isTest
    public static void ACETLGT_HSATransactionJSON2Apex_Test(){        
        ACETLGT_HSATransactionJSON2Apex hsa = new ACETLGT_HSATransactionJSON2Apex();
        List<Object> transactions_test = hsa.transactions;
        Object pagination_test = hsa.Pagination;                                
    }
    
    //	Madhura
    @isTest
    static void testGetHSASummaryValues_500() {
        ACETLGT_HSABankAcccountController.HSASummaryResultWrapper wr = new ACETLGT_HSABankAcccountController.HSASummaryResultWrapper();
        wr = ACETLGT_HSABankAcccountController.GetHsaSummaryValues('22222222');
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaSummaryResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        wr = ACETLGT_HSABankAcccountController.GetHsaSummaryValues('22222222');
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
    }

/*
    @isTest
    static void testGetHSASummaryInValid() {

        ACETLGT_HSATransactionWebservice weSvcie = new ACETLGT_HSATransactionWebservice();
        weSvcie.queryPaginatedData(null, null, null);
    }

    @isTest
    static void  testGetHSATransactionValues_200() {

        ACETLGT_HSATransactionWebservice weSvcie = new ACETLGT_HSATransactionWebservice();
        weSvcie.getRequestBody('NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==','PROCESSED');
        //String respBody = '{"transactions":[{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"12345","status":"PROCESSED","date":"2019-12-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-11-29","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-10-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-09-30","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-08-30","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-07-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-06-28","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-05-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-04-30","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-03-29","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-02-28","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2019-01-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-12-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-11-30","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-10-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-09-28","amount":"4","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-08-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-07-31","amount":"5","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"Interest Payment","status":"PROCESSED","date":"2018-06-29","amount":"2","transactionCode":"804"},{"id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountDescription":"CURRENT YEAR INDIVIDUAL CONTR","status":"PROCESSED","date":"2018-06-13","amount":"15000","transactionCode":"615"}],"pagination":{"pageNumber":"1","pageSize":"20","totalCount":"20"}}';


    }

    @isTest
    static void testCleanDate_valid() {

        ACETLGT_HSATransactionWebservice tr = new ACETLGT_HSATransactionWebservice();
        String dateValValid = tr.cleanDate('01/02/2019');
        
        System.assertEquals(dateValValid , '01/02/2019');
    }

    @isTest
    static void testCleanDate_inValid() {

        ACETLGT_HSATransactionWebservice tr = new ACETLGT_HSATransactionWebservice();
        String dateValInvalid = tr.cleanDate('0/0/0000');

        System.assertEquals(dateValInvalid , '00/00/0000');
    }
    */
    
}