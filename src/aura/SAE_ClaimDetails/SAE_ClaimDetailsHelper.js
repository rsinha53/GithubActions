({
    //US1956058 : Malinda
	callClaimDetail : function(component, event, helper) {
        let claim = component.get("v.selectedClaim");
        let action = component.get("c.searchClaimDetails");
        action.setParams({ strParamTin : '420982971'
                          ,strParamPayerId : '87726'
                          ,strParamClaimNo : claim.claimNumber
                          ,strProcessedDate : claim.processDate });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let resValues = response.getReturnValue();
                if(resValues.statusCode !== 200) {
                    resValues.resultClaimDetailsWrapper.totalPatientResponsiblity = '--';
                } else {
                    let totalPatientResp = '$'+resValues.resultClaimDetailsWrapper.totalPatientResponsiblity
                    resValues.resultClaimDetailsWrapper.totalPatientResponsiblity = totalPatientResp;
                }
                component.set("v.claimDetails", resValues);
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})