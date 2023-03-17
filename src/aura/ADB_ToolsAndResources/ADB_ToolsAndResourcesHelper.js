({
	 openAvayaCallbackUrl: function(component, event, helper) {
        var action = component.get("c.getAvayaCallbackUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response value'+response);
                var resp = response.getReturnValue();
                console.log('opening Avaya url value--'+resp   );
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
        });
        $A.enqueueAction(action);
    },
     openEviveUrl: function(component, event, helper) {
        var action = component.get("c.getEviveUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },
     openICUEPolicyAdminUrl: function(component, event, helper) {
        var action = component.get("c.getICUEPolicyAdminUrl");
         var userId = component.get("v.agentUserId");
         var memberXrefId = component.get("v.memberXrefId");
         action.setParams({ cdbXrefId : memberXrefId,
                          userId: userId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },
     openInitiateEngagementIntakeUrl: function(component, event, helper) {
        var action = component.get("c.getInitiateEngagementIntakeUrl");
         var userId = component.get("v.agentUserId");
         var subscriberId = component.get("v.decodedMemberId");
         action.setParams({ subscriberId : subscriberId,
                          userId: userId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },
     openICUEHomeUrl: function(component, event, helper) {
        var action = component.get("c.getICUEHomeUrl");
         var userId = component.get("v.agentUserId");
         var memberXrefId = component.get("v.memberXrefId");
         console.log('memberXrefId for Member Prefernces'+memberXrefId);
         action.setParams({ cdbXrefId : memberXrefId,
                          userId: userId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },
     openMyHealthDirectLoginUrl: function(component, event, helper) {
        var userId = component.get("v.agentUserId");
        var action = component.get("c.getMyHealthDirectUrl");
        action.setParams({userId: userId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                    window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
        });
        $A.enqueueAction(action);
    },
     openRallyCostEstimatorUrl: function(component, event, helper) {
        var action = component.get("c.getRallyCostEstimatorUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    // Added Rally Impersonation function: US2991881 - Sunil Vennam
    openRallyImpersonation: function(component, event, helper) {
        var action = component.get("c.getRallyImpersonationUrl");
        var userId = component.get("v.agentUserId");
        var memberId = component.get("v.decodedMemberId");
        var firstname = component.get("v.memberFirstName");
        var lastname = component.get("v.memberLastName");
        var memberDob = component.get("v.memberDateofBirth");
        var policy = component.get("v.memberPolicy");
        console.log(memberId+firstname+lastname+memberDob+'//'+policy);
        /*var userId = 'svennam3'; 
        var memberId = '713797013';
        var firstname = 'BETHEL';
        var lastname = 'WILLIAMS';
        var memberDob = '02/27/1985';
        var policy = '0701439';*/
        console.log('memberXrefId for Member Prefernces'+userId);
        action.setParams({ memberId : memberId,
                          userId: userId,
                          firstname : firstname,
                          lastname: lastname,
                          memberDob : memberDob,
                          policy: policy});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('url'+resp);
                if(resp != null && resp != ''){
                    window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
            
        });
        $A.enqueueAction(action);
    },
     openHealthMessageCenterUrl: function(component, event, helper) {
        var action = component.get("c.getHealthMessageCenterUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },
    openThirdPartReferralUrl: function(component, event, helper) {
        var action = component.get("c.getThirdPartReferralUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },
  
	 openMyUhcSupervisorUrl: function(component, event, helper) {
        var action = component.get("c.getMyUhcSupervisorUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },

    getCastLightPolicy: function(component, event, helper) {
        var action = component.get("c.getCastLightMetadata");
        var policyNumber = component.get("v.memberPolicy");

        action.setParams({
            policy: policyNumber
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                    component.set("v.castLightIndicator",resp.castLightIndicator);
                    component.set("v.clientName",resp.clientName);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getCastLightSsoUrl: function(component, event, helper) {
        var action = component.get("c.getCastLightUrl");
        var userId = component.get("v.agentUserId");
        var subscriberId = component.get("v.SSN");
        var firstName = component.get("v.memberFirstName");
        var lastName = component.get("v.memberLastName");
        var memberDob = component.get("v.memberDateofBirth");
        var clientName = component.get("v.clientName");

        var convertedDOB;
        var arrDOB;
        if(!$A.util.isEmpty(memberDob)){
            arrDOB = memberDob.split('/');
            if(!$A.util.isEmpty(arrDOB) && arrDOB.length == 3){
                convertedDOB = arrDOB[2] + '-' + arrDOB[0] + '-' + arrDOB[1];
            }
        }

        // comment out subscriberId, firstName, lastName, prior to production deployment
        // subscriberId = '676765460';

        action.setParams({
            clientname : clientName,
            subscriberId : subscriberId,
            userId : userId,
            firstname : firstName,
            lastname : lastName,
            memberDob : convertedDOB,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                    window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
        });
        $A.enqueueAction(action);
    },

})