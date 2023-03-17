@isTest
global class ExampleCalloutMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    //res.setStatus('OK');
    res.setStatusCode(200);
     /* WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
      insert newrec;*/
       Map<String, Object> testmap=new  Map<String, Object>();
      testmap.put('access_token','ABCDEFGHIOYVJG66873VGt');
      testmap.put('id','+91 8317687698');
    res.setBody(JSON.serialize(testmap));
    return res;
  }
}