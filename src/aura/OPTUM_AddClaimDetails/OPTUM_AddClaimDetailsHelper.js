({
    fetchData: function(component, event, helper) {
        var f = component.get("v.fid");
        var s = component.get("v.sid");
        var sc = component.get("v.sClaim");
        var aID = component.get("v.aid");
        component.set("v.flag", true);
        component.set("v.Spinner", true);
        var action = component.get("c.showAddClaimsDetails");
        action.setParams({
            "faroId": component.get("v.fid"),
            "accountId": component.get("v.aid"),
            "claimNumber": component.get("v.sClaim"),
            "syntheticId": component.get("v.sid")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
            if ((responseValue != null) && (component.isValid()) && (state === "SUCCESS")) {
                component.set("v.Spinner", false);
                // checking undefined as part of DE432850 
                if (!($A.util.isUndefinedOrNull(responseValue.result)) && !($A.util.isUndefinedOrNull(responseValue.result.data.claim))){
                    component.set("v.admNotes", responseValue.result.data.claim.adminNotes);
                    component.set("v.rmiNotes", responseValue.result.data.claim.rmiNotes);
                    var claimsaddData = component.get("v.admNotes");
                    if (claimsaddData != undefined) {
                        for (var row = 0; row < claimsaddData.length; row++) {
                            var claimDate = claimsaddData[row].noteTs;
                            claimsaddData[row].noteTs = $A.localizationService.formatDate(claimDate, "MM/dd/YYYY hh:mm a");
                        }
                    }
                    var rNotes = component.get("v.rmiNotes");
                    if (rNotes != undefined) {
                        for (var row = 0; row < rNotes.length; row++) {
                            var claimDate = rNotes[row].actionTs;
                            rNotes[row].actionTs = $A.localizationService.formatDate(claimDate, "MM/dd/YYYY hh:mm a");
                        }
                    }
                }
				else {
                    component.set("v.admNotes", "");
                    component.set("v.rmiNotes", "");
					if (responseValue != null && !($A.util.isUndefinedOrNull(responseValue.status))) {
                                if (responseValue.status.messages[0].name != 'Success') {
                                    component.set("v.showErrorMessage", responseValue.status.messages[0].description);
                                } else {
                                    var data = responseValue.result.data;
                                    if (Object.keys(data).length === 0) {
                                        component.set("v.showErrorMessage", responseValue.status.messages[0].description);
                                    }
                                }
                    } 
                }
            } else if ((responseValue == null) || (state === "ERROR")) {
                component.set("v.APIResponse", true);
                component.set("v.Spinner", false);
            } else if (state === "INCOMPLETE") {
                component.set("v.Spinner", false);
            }
			 helper.autoDocRmiNotes(component, event, helper);
             helper.autoDocAdminNotes(component, event, helper);
        });
        $A.enqueueAction(action);
    },
	 autoDocRmiNotes : function(cmp, event, helper) {
        var autoDocTabData = cmp.get("v.rmiNotes");
        var dataLength = autoDocTabData.length;
        var action = cmp.get('c.getAutoDocRmiNotes');
        var rmiDetails = [];
        if(autoDocTabData != null){
         for(var i=0; i< dataLength; i++){
             rmiDetails.push(autoDocTabData[i]);                  
         }
		}
        action.setParams({
            "rmiNotesList":rmiDetails
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                cmp.set("v.autoDocRmiDetails" ,response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    autoDocAdminNotes : function(cmp, event, helper) {
         var autoDocTabData = cmp.get("v.admNotes");
         var dataLength = autoDocTabData.length;
         var action = cmp.get('c.getAutoDocAdminNotes');
         var adminDetails = [];
         if(autoDocTabData != null){
         for(var i=0; i< dataLength; i++){
             adminDetails.push(autoDocTabData[i]);                  
         }
		} 
         action.setParams({
            "adminNotesList": adminDetails
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                cmp.set("v.autoDocAdminDetails" ,response.getReturnValue());
             }
        });
        $A.enqueueAction(action);
    }
})