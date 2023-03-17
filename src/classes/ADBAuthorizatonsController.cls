public without sharing class ADBAuthorizatonsController {
    
    @AuraEnabled public static ADBAuthorizationResponseWrapper getAuthNotifications(String userId, String memberId, String policy, String memFirstName, String relationship, String consumerApplication) {
        ADBAuthorizationResponseWrapper responseWrapper = new ADBAuthorizationResponseWrapper();
        ADBMedicalClaimRequestWrapper requestWrapper = new ADBMedicalClaimRequestWrapper();
        List<ADBAuthorizationResponseWrapper.Notifications> authNotificationData = new List<ADBAuthorizationResponseWrapper.Notifications>();
        List<ADBAuthorizationResponseWrapper.Errors> authErrorData = new List<ADBAuthorizationResponseWrapper.Errors>();
        try{
            requestWrapper.userId = userId;
            requestWrapper.memberId = memberId;
            requestWrapper.policy = policy;
            requestWrapper.firstName = memFirstName;
            requestWrapper.relationship = relationship;
            requestWrapper.consumerApplication = consumerApplication;
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBAuthorizationEndpoint', JSON.serialize(requestWrapper), null);
            HttpResponse response = wsCallOutFW.getResponse();
            String strBody=response.getBody().replace('unet-notifications-response','unetResponse');										  
            response.setBody(strBody);
            
            // Faking the prod response
            /*HttpResponse response = new HttpResponse();
StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'ADBAuthMockData'];//ADBAuthErrorMockData //ADBAuthMockData
String strBody = requestTemplate.Body.toString();
String jsonbody=strBody.replace('unet-notifications-response','unetResponse');											  
response.setBody(jsonbody);
system.debug('response Auth service'+response);
response.setStatusCode(200);*/
            
            // Checking the status code is success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400) {
                responseWrapper = (ADBAuthorizationResponseWrapper) JSON.deserialize(response.getBody(), ADBAuthorizationResponseWrapper.class);
                system.debug('responseWrapper'+responseWrapper);
                if(responseWrapper!= null && responseWrapper.unetResponse != null){
                    if(responseWrapper.unetResponse.notifications != null){
                        ADBAuthorizationResponseWrapper.UnetResponse rs = responseWrapper.unetResponse;
                        for(Integer i=0; i < rs.notifications.size(); i++){
                            
                            ADBAuthorizationResponseWrapper.Notifications tempNote = new ADBAuthorizationResponseWrapper.Notifications();
                            tempNote.notificationNumber = rs.notifications[i].notificationNumber;
                            String advancedNotificationDate = rs.notifications[i].advancedNotificationDate;
                            tempNote.advancedNotificationDate = getFormattedDate(advancedNotificationDate); 
                            tempNote.ProgramRecordIndicator = rs.notifications[i].programRecordIndicator;
                            tempNote.ProgramRecordIndicator.description= rs.notifications[i].programRecordIndicator.description;
                            tempNote.ParsInfos = rs.notifications[i].parsInfos;
                            tempNote.ParsInfos[0] = rs.notifications[i].parsInfos[0];
                            String cancelDate = rs.notifications[i].parsInfos[0].cancelDate;
                            tempNote.parsInfos[0].cancelDate = getFormattedDate(cancelDate);
                            String effectiveDate = rs.notifications[i].parsInfos[0].effectiveDate;
                            tempNote.parsInfos[0].effectiveDate = getFormattedDate(effectiveDate);
                            tempNote.parsInfos[0].cptDetails[0] = rs.notifications[i].parsInfos[0].cptDetails[0];
                            tempNote.parsInfos[0].cptDetails[0].procedure = rs.notifications[i].parsInfos[0].cptDetails[0].procedure;
                            tempNote.parsInfos[0].cptDetails[0].procedure.code = rs.notifications[i].parsInfos[0].cptDetails[0].procedure.code;
                            tempNote.parsInfos[0].remark = rs.notifications[i].parsInfos[0].remark;
                            tempNote.parsInfos[0].remark.code = rs.notifications[i].parsInfos[0].remark.code;
                            tempNote.parsInfos[0].remark.description = rs.notifications[i].parsInfos[0].remark.description;
                            authNotificationData.add(tempNote);
                        }
                        rs.notifications = authNotificationData;
                    }else{
                        for(Integer i=0; i < responseWrapper.unetResponse.errors.size(); i++){
                            ADBAuthorizationResponseWrapper.Errors tempError = new ADBAuthorizationResponseWrapper.Errors();
                            tempError.code = responseWrapper.unetResponse.errors[i].code;
                            tempError.name = responseWrapper.unetResponse.errors[i].name;
                            tempError.description = responseWrapper.unetResponse.errors[i].description;
                            authErrorData.add(tempError);
                        }
                        responseWrapper.unetResponse.errors = authErrorData;
                    }
                }
            } 
        }catch(Exception e){
            system.debug('ADBAuthorizatonsController.getAuthNotifications Exception ::' + e.getMessage());
        }
        return responseWrapper; 
    }
    
    // Used to format date
    @AuraEnabled public static String getFormattedDate (String seleteDate){
        String formattedDate = ''; 
        if(String.isNotBlank(seleteDate)){
            list<String> splitDate = (seleteDate).split('-');
            String splitDateList = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            formattedDate= splitDateList;                                 
        }
        return formattedDate;
    }    
}