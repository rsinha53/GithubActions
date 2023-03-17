({
	toggleSection : function(cmp, event, helper) {
        var iconName = cmp.find("languageChevInactive").get("v.iconName");
        if(iconName === "utility:chevrondown") {
            cmp.set("v.icon", "utility:chevronright");
            cmp.set("v.toggleClass", "slds-hide");
        } else {
            cmp.set("v.icon", "utility:chevrondown");
            cmp.set("v.toggleClass", "slds-show");
        }
    }
})