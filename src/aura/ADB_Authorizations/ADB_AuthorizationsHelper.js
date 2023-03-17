({  
    // For getting authorization details
    getAuthorizationDetails: function(component, event, helper){
        var userId = component.get("v.agentUserId"); //"pchinnol";//aattanay
        var memberId = 'S'+component.get("v.decodedMemberId");
        var policy = component.get("v.memberPolicy");
        var memFirstName = component.get("v.firstName");
        var relationship = component.get("v.memberRelationID");
        var consumerApplication = "Acet";
        var action = component.get("c.getAuthNotifications");
        action.setParams({ 
            userId : userId,
            memberId : memberId,
            policy : policy,
            memFirstName : memFirstName,
            relationship : relationship,
            consumerApplication : consumerApplication}); 
        action.setCallback(this, function(response) {
            component.set('v.showSpinner',false);
            var state = response.getState();        
            if (state === "SUCCESS") {
                var authDetails = response.getReturnValue();
               if(authDetails != null && authDetails.unetResponse != null){
                    var authList = authDetails.unetResponse.notifications;
                    var errorList = authDetails.unetResponse.errors;
                    var currentDate = new Date();
                    if (authList != undefined && authList.length != 0) {
                        for (var key in authList){
                            // set flag logic
                            if (authList.hasOwnProperty(key)) {
                                var serviceDate = new Date(authList[key].parsInfos[0].effectiveDate);
                                var reasonCode = authList[key].parsInfos[0].remark.code;
                               if( ( (reasonCode == 'CS')|| (reasonCode == 'DC')|| (reasonCode == 'DI')|| (reasonCode == 'DL')|| (reasonCode == 'DM')
                                   || (reasonCode == 'DN')|| (reasonCode == 'DR')|| (reasonCode == 'DS')|| (reasonCode == 'FD')|| (reasonCode == 'MD') )
                                  && (serviceDate > currentDate) ) {  
                                    authList[key].isFlagVisible = 'true';
                                }else{
                                    authList[key].isFlagVisible = 'false';
                                }
                            }
                        }
                    }
                    if (errorList != undefined && errorList.length != 0) {
                        for (var key in errorList){
                            // check authorization persons and set error message
                            var errorCode = errorList[key].code; 
                            var errorName = errorList[key].name; 
                            var errorDescription = errorList[key].description; 
                            if((errorCode == '500') && (errorName == 'FAULT')){
                                if((errorDescription.includes("8"))&&(errorDescription.includes("998"))){
                                    component.set("v.unAuthorizedMsg", true);
                                }
                            }
                        }
                    }
                    // Sort authorization list  
                    if (authList != undefined && authList.length != 0) {       
                        authList.sort(function(a, b) {
                            var keyA = new Date(a.advancedNotificationDate),
                                keyB = new Date(b.advancedNotificationDate);
                            if (keyA > keyB){return -1;} 
                            if (keyA < keyB) {return 1;}
                            return 0;
                        });
                    }
                    component.set("v.AuthDetails", authList); 
                } 
            }
        });
        $A.enqueueAction(action);  
    }
})