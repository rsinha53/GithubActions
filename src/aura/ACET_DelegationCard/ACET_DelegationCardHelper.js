({
    getSopLink : function(component, event, helper) {
        var getSopLink = component.get("c.getSopLink");
        getSopLink.setCallback(this, function(response){ 
            var state = response.getState();
            if(state =='SUCCESS'){
                var sopLinkValue = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(sopLinkValue) && !$A.util.isEmpty(sopLinkValue)){
                    component.set("v.sopLinkValue",sopLinkValue);
                }
                this.scrollToolTipIntoView(component, event, helper);
            }

        });
        $A.enqueueAction(getSopLink);
    },

    getToolTip : function(component, event, helper){
        var delegatedValue = component.get("v.delegatedValue");
        if(!$A.util.isUndefinedOrNull(delegatedValue) && !$A.util.isEmpty(delegatedValue)){
        var getToolTip = component.get("c.getToolTip");
        getToolTip.setParams({ delegatedValue : delegatedValue, isToolTipVal: true });
        getToolTip.setCallback(this, function(response){
            var state = response.getState();
            if(state =='SUCCESS'){
                var toolTipValue = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(toolTipValue) && !$A.util.isEmpty(toolTipValue)){
                    component.set("v.toolTipValue",toolTipValue);
                    var cardDetails = component.get("v.cardDetails");
                    var cardData = cardDetails.cardData;
                    if(!$A.util.isUndefinedOrNull(cardData) && !$A.util.isEmpty(cardData)){
                        for(var key in cardData){
                            if(cardData[key].fieldName == 'Tip'){
                                cardData[key].fieldValue = component.get("v.toolTipValue");
                            }
                        }
                        cardDetails.cardData = cardData;
                        component.set("v.cardDetails",cardDetails);
                        this.getToolTipSopDoc(component, event, helper);
                    }
                }
            }
        });

        $A.enqueueAction(getToolTip);
        }
    },

    getToolTipSopDoc : function(component, event, helper){
        var delegatedValue = component.get("v.delegatedValue");
        if(!$A.util.isUndefinedOrNull(delegatedValue) && !$A.util.isEmpty(delegatedValue)){
        var getToolTip = component.get("c.getToolTip");
        getToolTip.setParams({ delegatedValue : delegatedValue, isToolTipVal:false });
        getToolTip.setCallback(this, function(response){
            var state = response.getState();
            if(state =='SUCCESS'){
                var toolTipValue = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(toolTipValue) && !$A.util.isEmpty(toolTipValue)){
                    component.set("v.toolTipSopDoc",toolTipValue);
                    var cardDetails = component.get("v.cardDetails");
                    var cardData = cardDetails.cardData;
                    if(!$A.util.isUndefinedOrNull(cardData) && !$A.util.isEmpty(cardData)){
                        for(var key in cardData){
                            if(cardData[key].fieldName == 'SOP'){
                                cardData[key].fieldValue = component.get("v.toolTipSopDoc");
                            }
                        }
                        cardDetails.cardData = cardData;
                        component.set("v.cardDetails",cardDetails);

                    }
                }
            }
        });

        $A.enqueueAction(getToolTip);
        }
    },

    scrollToolTipIntoView : function(component,event,helper) {
        var elementId = component.find("toolTipId")
        if (!$A.util.isUndefinedOrNull(elementId)) {
            elementId.getElement().scrollIntoView({
                behavior: 'smooth',
                block: 'start',
                inline: 'end'
            });
        }
    }
})