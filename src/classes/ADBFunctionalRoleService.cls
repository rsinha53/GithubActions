public without sharing class ADBFunctionalRoleService {
    //check data for functional Role: US2620797 - sunil vennam
    public static String checkAgentDataExists(String userId){
        String finalRole = '';
        ADBFunctionalRoleResponseWrapper result;
        //Query to get the accounts
        List<Agent_Information__c> agents = [SELECT ID, Agent_MSID__c, ICUE_Functional_Role__c, LastModifiedDate FROM Agent_Information__c where Agent_MSID__c =: userId];
        if (agents.isEmpty()){ // Insert new agent information record into database
            result = callFunctionalRoleService(userId);
            if(result.Role!=null){
                // creating account data
                Agent_Information__c a = new Agent_Information__c(
                    Agent_MSID__c = userId,
                    ICUE_Functional_Role__c = result.role
                );
                insert a;
                finalRole = a.ICUE_Functional_Role__c;
            }
            else{
                finalRole = '';
            }
        } else {
            DateTime mD = agents.get(0).LastModifiedDate;
            DateTime tD = System.now();
            Date todayDate;
            Date modifiedDate;
            if(mD!=null && tD!=null){
                todayDate = date.newinstance(tD.year(), tD.month(), tD.day());
                modifiedDate = date.newinstance(mD.year(), mD.month(), mD.day());
            }
            if(modifiedDate!=null && todayDate!=null && modifiedDate == todayDate){
                finalRole = agents.get(0).ICUE_Functional_Role__c;
            } else{
                result = callFunctionalRoleService(userId);
                if(result.Role!=null){
                    // creating agent data
                    Agent_Information__c a = new Agent_Information__c(
                        id = agents.get(0).Id,
                        Agent_MSID__c = userId,
                        ICUE_Functional_Role__c = result.role
                    );
                    update a;
                    finalRole = a.ICUE_Functional_Role__c;
                }
                else{
                    finalRole = agents.get(0).ICUE_Functional_Role__c;
                }
            }
        }
        return finalRole;
    }
    //Call Service for functional Role: US2620797 - sunil vennam
    public static ADBFunctionalRoleResponseWrapper callFunctionalRoleService(String userId){
        ADBFunctionalRoleRequestWrapper request = new ADBFunctionalRoleRequestWrapper();
        ADBFunctionalRoleResponseWrapper responseWrapper = new ADBFunctionalRoleResponseWrapper();
        request.memberDetailRequest  = new ADBFunctionalRoleRequestWrapper.memberDetailRequest();
        request.memberDetailRequest.requestHeader = new ADBFunctionalRoleRequestWrapper.requestHeader();
        request.memberDetailRequest.requestHeader.userID = userId.toUpperCase();
        String serializedBody = JSON.serialize(request);
        // Actual service 
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBFunctionalRoleEndpoint',serializedBody,null);
        HttpResponse response = wsCallOutFW.getResponse();
        system.debug('response for functional role'+ response.getBody());
        if(response.getStatusCode() == 200) {
            // Deserializing response
            responseWrapper = ADBFunctionalRoleResponseWrapper.parse(response.getBody());
            if(responseWrapper!=null && responseWrapper.userDetailsResponse!=null && responseWrapper.userDetailsResponse.userDetails!=null && responseWrapper.userDetailsResponse.userDetails.functionalRoleType!=null){
                responseWrapper.role = responseWrapper.userDetailsResponse.userDetails.functionalRoleType;
            }
        } else {
            responseWrapper.userDetailsResponse.responseHeader.serviceCallStatusCode = String.valueOf(response.getStatusCode());
            responseWrapper.userDetailsResponse.responseHeader.serviceCallStatus = response.getStatus();
        }
        return responseWrapper;  
    } 
}