@isTest
public class ACET_ClaimRelatedDocumentControllerTest {

    static testMethod void ACET_ClaimRelatedDocument_JSON2ApexTest(){
        Test.startTest();
        String requestBody='{}';
        ACET_ClaimRelatedDocument_JSON2Apex.parse(requestBody);
        Test.stopTest();
    }
    static testMethod void ACET_ClaimrelatedRequestTest(){
        Test.startTest();
        ACET_ClaimrelatedRequest req = new ACET_ClaimrelatedRequest();
        req.indexName='Test';
        req.Criteria=null;
        ACET_ClaimrelatedRequest.criteria criteria= new ACET_ClaimrelatedRequest.criteria();
        criteria.filterClauses=null;
        ACET_ClaimrelatedRequest.filterClauses filterClauses= new ACET_ClaimrelatedRequest.filterClauses();
        filterClauses.name='Test';
        filterClauses.type_Z='Test';
        filterClauses.value='Test';
        String requestBody='{}';
         ACET_ClaimrelatedRequest.parse(requestBody);
        Test.stopTest();
    }
}