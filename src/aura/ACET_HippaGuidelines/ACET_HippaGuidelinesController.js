({
    doInit : function(cmp) {
        var action = cmp.get("c.getHippaGuideLinesUrl");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var responseUrl = response.getReturnValue();
                cmp.set("v.hipaaEndpointUrl",responseUrl);
                //US2705857 - Sravan - Start
                var autoCall = cmp.get("v.showButton");
                if(!autoCall){
                    cmp.autoCallHippaGuidelines();
                    var closePanel = $A.get("e.force:closeQuickAction");
                    closePanel.fire();
                }
                //US2705857 - Sravan - End 
            }
        })
        $A.enqueueAction(action);
    },
    
     handleHippaGuideLines : function(cmp) {
        var hipaaEndPointUrl = cmp.get("v.hipaaEndpointUrl");
        var policySelectedIndex = cmp.get("v.policySelectedIndex");
        if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
            window.open(hipaaEndPointUrl, '_blank');
        }

        var cardDetails = new Object();
        cardDetails.componentName = "HIPAA Guidelines";
        cardDetails.componentOrder = 3;
        cardDetails.noOfColumns = "slds-size_1-of-1";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "fieldName": "HIPAA Guidelines",
                "fieldType": "outputText",
                "fieldValue": "Accessed"
            }
        ];
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), policySelectedIndex, cardDetails);
    }



})