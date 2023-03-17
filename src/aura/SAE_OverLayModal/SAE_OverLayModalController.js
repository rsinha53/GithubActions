({
    doInit: function(component, event, helper) {
        var policyStatus = component.get("v.policyStatus") =="true" ? true : false ;
        component.set("v.showModel",policyStatus);
        if(policyStatus){
            var generateICUEURL = component.get('c.generateICUEURL');
            $A.enqueueAction(generateICUEURL);
        }
    },

    handleCloseModal: function(component, event, helper) {
        //Close the Modal Window
        component.find("overlayLib").notifyClose();
    },
    // US2536127 - Avish
    generateICUEURL: function(cmp, event, helper){
        debugger;
        if(cmp.get("v.eventName") == 'Create SRN'){
            // New Public group for Create Auth Pilot - Sarma - 28/10/2020
            if(cmp.get("v.isOpenIcue")){

            var actionicue = cmp.get("c.GenerateICUEURL");
            actionicue.setParams({
                "MemberId": cmp.get("v.MemberId"),
                "firstName": cmp.get("v.FirstName"),
                "lastName": cmp.get("v.LastName"),
                "contactName": cmp.get("v.contactName"),
                "policyNumber" : cmp.get("v.policyNumber"),
                "originatorType": 'Member'
            });

            actionicue.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    console.log('storeResponse'+storeResponse);
                    cmp.set("v.ICUEURL", storeResponse);
                    helper.getICUEURL(cmp, event, helper);
                }
            });
            $A.enqueueAction(actionicue);
            } else {
                // US2891146	Create SRN - Warning Message - Sarma - 25/09/2020
                // Adding new logic to Open create SRN tab
                // This event needed to open the new SRN tab
                var appEvent = $A.get("e.c:ACET_OpenICUEEvent");
                appEvent.setParams({
                    "memberTabId": cmp.get('v.memberTabId')
                });
                appEvent.fire();
            }

        } else if(cmp.get("v.eventName") == 'Save Case'){
            
            var appEvent = $A.get("e.c:ACET_SaveCaseEvent");
            //var compEvent = cmp.getEvent("ACET_SaveCaseEvent");
            appEvent.setParams({
                "showPopUp": true,
                "memberTabId": cmp.get("v.memberTabId")
            });            
            appEvent.fire();
            cmp.find("overlayLib").notifyClose();
        }
        
    }
})