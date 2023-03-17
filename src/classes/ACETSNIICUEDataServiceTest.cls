@isTest
public class ACETSNIICUEDataServiceTest {
@isTest static void ACETSNIICUEDataServiceTestSuccess(){
   Test.startTest();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/SNI/CreateWorkorder';
    req.httpMethod = 'POST';
    ACETSNIICUEDataParser objSni = new ACETSNIICUEDataParser();
    String JSONString = JSON.serialize(objSni);
    req.requestBody = blob.valueof(JSONString);
    RestContext.request = req;
    RestContext.response= res;
    ACETSNIICUEDataService.createWorkOrders();

    Test.stopTest();
}
  
}