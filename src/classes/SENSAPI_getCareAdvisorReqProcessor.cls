/*------------------------------------------------------------
Author:         Harshini Thotakura
Description:    Request processor class for the service request "Get Care Advisor Details"   
Test Class:     SENSAPI_GetCareAdvisorReqProcessorTest
History
Date            Author                      Comments
-------------------------------------------------------------
25-10-2022      Harshini Thotakura          Created
------------------------------------------------------------*/
public without sharing class SENSAPI_getCareAdvisorReqProcessor implements IRestRequestProcessor{
    
    public SENSAPI_getCareAdvisorRequest request;
    public SENSAPI_getCareAdvisorResponse responseDetails;
    
    private Account familyAccount; 
    private List<Account> famAccount;
    
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        
        responseDetails = new SENSAPI_getCareAdvisorResponse();
        
        try{             
            initProcessor(requestStructure);
            if(String.isNotBlank(request.subscriberId)){
                String subscriberId = SENSAPI_Utility.getSubscriberId(request.subscriberId);
                
                //fetch the family account details
                famAccount = SENSAPI_Utility.getFamilyAccountWithOwner(subscriberId);
                
                
                if(famAccount.size() > 0){
                    familyAccount = famAccount[0];
                    
                    advisorDetails();
                    responseDetails.status = new SENSAPI_getCareAdvisorResponse.API_Status(true, 200);
                }else{
                    String errorMessage = SENSAPI_Constant.NO_FAMILY_FOUND;
                    responseDetails.status = new SENSAPI_getCareAdvisorResponse.API_Status(false, 400, errorMessage);
                }
                

            }else{
                String errorMessage = SENSAPI_Constant.SUBSCRIBER_ID_REQUIRED;
                responseDetails.status = new SENSAPI_getCareAdvisorResponse.API_Status(false, 400, errorMessage);
            }
            
        }catch(Exception ex) {   
            responseDetails.status = new SENSAPI_getCareAdvisorResponse.API_Status(false, 500, ex.getMessage() + ex.getStackTraceString());
        }    
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    } 
    
    private void advisorDetails(){
        Family_Overview__c familyOverview;
        if(familyAccount.Family_Overview__r.size()>0){
            familyOverview = familyAccount.Family_Overview__r[0];
        }
        list<SENSAPI_getCareAdvisorResponse.careAdvisorDetails> careAdvisor = SENSAPI_Utility.populateCareAdvisorDetails(familyAccount.Owner,familyOverview);
        responseDetails.careAdvisor = careAdvisor;
    }
    
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_getCareAdvisorRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception( SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }        
    }
 
}