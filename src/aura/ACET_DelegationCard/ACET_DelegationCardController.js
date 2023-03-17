({
    
    //US3583813 - Sravan - Start
    doInit : function(component, event, helper) {
        helper.getSopLink(component, event, helper);
        helper.getToolTip(component, event, helper);
        var cardDetails = new Object();
        cardDetails.componentName = "Delegation Details";
        cardDetails.componentOrder = 7;
        cardDetails.noOfColumns = "slds-size_6-of-12";
        cardDetails.type = "card";
        cardDetails.caseItemsEnabled = true;
        cardDetails.caseItemExtId = "Delegation Details";
        cardDetails.caseItemsExtId = "Delegation Details";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": false,
                "disableCheckbox": false,
                "defaultChecked": false,
                "fieldName": "Tip",
                "fieldType": "outputText",
                "fieldValue": "",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": false,
                "disableCheckbox": false,
                "defaultChecked": false,
                "fieldName": " ",
                "fieldType": "emptySpace",
                "fieldValue": " ",
                "showCheckbox": false,
                "isReportable":true
            },
            {
                "checked": false,
                "disableCheckbox": false,
                "defaultChecked": false,
                "fieldName": "SOP",
                "fieldType": "link",
                "fieldValue": "",
                "showCheckbox": false,
                "isReportable":true
            }
        ];
        component.set("v.cardDetails", cardDetails);
    },

    handleAutoDocEvent : function(component, event, helper){
        var eventData = event.getParam("eventData");
        var policySelectedIndex = component.get("v.policySelectedIndex");
        var sopLinkValue = component.get("v.sopLinkValue");
        if(eventData.fieldName == 'SOP'){
            if(!$A.util.isUndefinedOrNull(sopLinkValue) && !$A.util.isEmpty(sopLinkValue)){
                window.open(sopLinkValue, '_blank');
            }
            var cardDetails = component.get("v.cardDetails");
            if(!$A.util.isUndefinedOrNull(cardDetails) && !$A.util.isEmpty(cardDetails)){
                if(cardDetails.cardData.length == 3){
                cardDetails.cardData.push({
                    "checked": true,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "SOP",
                    "fieldType": "outputText",
                    "fieldValue": "Delegation Details SOP accessed",
                    "showCheckbox": false,
                    "hideField": true,
                    "isReportable":true
                    });
                
                component.set("v.cardDetails", cardDetails);
                console.log('Delegated Card Details'+ JSON.stringify(cardDetails));
                }
            }
            _autodoc.setAutodoc(component.get("v.autodocUniqueId"), policySelectedIndex, cardDetails);
        }
        
    },

    closeCard : function(component, event, helper){
        component.set("v.showDelegation",false);
    },
    //US3583813 - Sravan - End
    showDelegationChange : function(component, event, helper){
        if(component.get("v.showDelegation")){
            helper.scrollToolTipIntoView(component, event, helper);
        }
    }
})