({
	 myUhcServiceDetails : function(component, event, helper){
        var action = component.get("c.callMyUhcService");
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.callerDateofBirth");
        var memFirstName = component.get("v.firstName");
        var memLastName = component.get("v.lastName");
        var memberPolicy = component.get("v.policy");
        action.setParams({ memberId : memberId,
                          memDob : memDob,
                          memFirstName : memFirstName,
                          memLastName : memLastName,
                          memberPolicy : memberPolicy});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var uhcDetails = response.getReturnValue();
                if (!$A.util.isEmpty(uhcDetails) && !$A.util.isUndefined(uhcDetails)) {
                    if (!$A.util.isEmpty(uhcDetails.registrationStatus) && !$A.util.isUndefined(uhcDetails.registrationStatus)) {
                        component.set("v.registeredStatus", uhcDetails.registrationStatus);
                        if(uhcDetails.registrationStatus == 'Registered'){
                            component.set("v.myUhcFlagNotification", 'Member is registered. Click the flag for Advocate actions.');
                        }else if(uhcDetails.registrationStatus == 'Locked Out'){
                            component.set("v.myUhcFlagNotification", 'Member is registered, locked out of HS ID. Click the flag for Advocate actions.'); 
                        }else if(uhcDetails.registrationStatus == 'Not Registered'){
                            component.set("v.myUhcFlagNotification", 'Member not registered with HS ID, promote registration. Click the flag for Advocate actions.'); 
                        }
                    }
                    if (!$A.util.isEmpty(uhcDetails.formattedLoggedInDate) && !$A.util.isUndefined(uhcDetails.formattedLoggedInDate)) {
                        component.set("v.lastLogOnDate", uhcDetails.formattedLoggedInDate);
                    }
                }
            }
			component.set('v.showSpinner',false);									 
        });
        $A.enqueueAction(action); 
    }
})