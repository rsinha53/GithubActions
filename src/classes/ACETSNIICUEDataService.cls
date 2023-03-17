/*
**********************************************************************************
Class Name:  ACETSNIICUEDataService
Description : ICUE will use this service to create workorder in SNI
Author: Ravi Kishore,
Created Date : 12-04-2020
Modification History :
**********************************************************************************
*/
@RestResource(urlMapping='/SNI/CreateWorkorder')
global with sharing class ACETSNIICUEDataService {

    @HttpPost
   // global static ResponseWrapper createWorkOrders() {
    global static void createWorkOrders() {
        RestResponse restRes = RestContext.response;
        ResponseWrapper resObj = new ResponseWrapper();
        ACETSNIICUEDataParser dataParser = new ACETSNIICUEDataParser();
        RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
        String jsonBody = req.requestBody.toString(); //the body of the rquest
        try{
            dataParser =  (ACETSNIICUEDataParser)JSON.deserialize(jsonBody, ACETSNIICUEDataParser.class);
            resObj = ACETSNIWorkOrderCreation.checkExistingWO(dataParser);
            ResponseBody body = new ResponseBody();
            body.message = resObj.message;
            body.workOrderId = resObj.workOrderId;
            restRes.responseBody = Blob.valueOf(JSON.serialize(body));
            restRes.statusCode =  integer.valueOf(resObj.status);
        }
        Catch(Exception ex){
            resObj.message = ex.getMessage();
            resObj.workOrderId = ''; 
            restRes.responseBody = Blob.valueOf(JSON.serialize(resObj));
            restRes.statusCode = 500;
		}
       // return resObj;
    }
    
    global without sharing class ResponseWrapper {
     
        global String message {get;set;} 
        global String workOrderId {get;set;}
        global String status {get;set;}
        global ResponseWrapper() {
            this.message = '';
            this.workOrderId = '';
            this.status = '';
        }
    }
    global without sharing class ResponseBody {
     
        global String message {get;set;} 
        global String workOrderId {get;set;} 
        global ResponseBody() {
            this.message = '';
            this.workOrderId = '';
        }
    }
    
}