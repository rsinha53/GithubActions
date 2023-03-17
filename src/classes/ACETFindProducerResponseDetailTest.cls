@isTest
public class ACETFindProducerResponseDetailTest {
    
    static testMethod void InlineTest(){
        ACETFindProducerResponseDetail.FindProducerResponse findProdRes = new ACETFindProducerResponseDetail.FindProducerResponse();
        Test.startTest();
        ACETFindProducerResponseDetail.parse('{"email":"are02@gmail.com","LastName":"ABCD","FirstName":"ACFPY","Suffix":"","Title":"Engineer","Psw":"","PhoneCode":"","Phone":"100-000-000"}');
        Test.stopTest();
        
    }
}