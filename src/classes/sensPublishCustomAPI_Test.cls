@isTest
public class sensPublishCustomAPI_Test{


    static testMethod void  getSensPublishDetailstTestMethod(){
        
        Sens_Publish__c  senPub = new Sens_Publish__c ();
        senPub.Family_Status__c = 'test';
        insert senPub;
        
        CHN_Qualified_Data__c chnqua = new CHN_Qualified_Data__c();
        chnqua.CHN_Qualified__c = true;
        insert chnqua;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
       
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        sensPublishCustomAPI.getSensPublishDetails();       
        Test.stopTest(); 
       
    }

    static testMethod void  updateMethodTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        List<Sens_Publish__c>  senPubLst = new List<Sens_Publish__c>();
        Sens_Publish__c  senPub = new Sens_Publish__c ();
        senPub.Family_Status__c = 'test';
        senPubLst.add(senPub);
        insert senPubLst;
        Date dt = date.valueOf('1982-02-22');
        Map<String,String> bodySet = new Map<String,String>();
        bodySet.put('MemberId','2323232323');
        bodySet.put('PolicyId','1313131313');
        bodySet.put('DOB','1982-02-22');
        req.requestURI ='/services/apexrest/abc/xyz/';
        req.requestBody = Blob.valueOf(JSON.serializePretty(bodySet));
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        sensPublishCustomAPI.getSensMemberInfo();
        Test.stopTest();
    }
}