({
    // US3304569 - Thanish - 17th Mar 2021
    benefitDetailsErrorMessage: "Unexpected Error Occurred in the Benefit Details Card. Please try again. If problem persists please contact the help desk",

    showBenefitResultSpinner: function (cmp) {
        var spinner = cmp.find("benefit-result-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    hideBenefitResultSpinner: function (cmp) {
        var spinner = cmp.find("benefit-result-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    setDefaultAutodoc: function(cmp){
        var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
        var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
        var memberAutodoc = new Object();
        memberAutodoc.type = 'card';
        memberAutodoc.componentName = "Member Details";
        memberAutodoc.autodocHeaderName = "Member Details";
        memberAutodoc.noOfColumns = "slds-size_6-of-12";
        memberAutodoc.componentOrder = 2;
        var cardData = [];
        cardData = defaultAutoDocMember.cardData.filter(function(el){
            if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                return el;
            }
        });
        memberAutodoc.cardData = cardData;
        var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, defaultAutoDocPolicy);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, memberAutodoc);
    },
    
    // US3125215 - Thanish - 22nd Dec 2020
    getBenefitLanguageDetails : function(cmp) {
        let action = cmp.get("c.getBenefitLanguageDetails");
        action.setParams({ 
            "transactionId": cmp.get("v.transactionId"),
            "benefitCode": cmp.get("v.serviceTypeDescription_API"),
            "componentName": cmp.get("v.titleLabel"),
            "componentOrder": cmp.get("v.componentOrder") + 2
        });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            this.hideBenefitResultSpinner(cmp);
            this.setDefaultAutodoc(cmp);
            cmp.set("v.isServiceCalled", true);
            if (state == "SUCCESS") {
                // US3304569 - Thanish - 17th Mar 2021
                let result = response.getReturnValue();
                if(result.statusCode != 200){
                    this.fireToastMessage("We hit a snag.", this.benefitDetailsErrorMessage, "error", "dismissible", "30000");
                }
                cmp.set("v.languageDetails", result.languageCard);
                cmp.set("v.componentOrder",result.languageCard.componentOrder);
            } else {
                this.fireToastMessage("We hit a snag.", this.benefitDetailsErrorMessage, "error", "dismissible", "30000");
            }
        });
        $A.enqueueAction(action);
    },
    
    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    // US3125215 - Thanish - 22nd Dec 2020 - removed unwanted ones
})