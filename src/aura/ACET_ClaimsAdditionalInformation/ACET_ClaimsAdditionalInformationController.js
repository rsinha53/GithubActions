({
	doInit : function(component, event, helper) {
        
    },
    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();
        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
            var additionalClaimInfoCNF = component.get("v.additionalClaimInfoCNF");
            component.set("v.additionalClaimInfoCNF",additionalClaimInfoCNF);
            helper.showSpinner(component, event, helper);
            setTimeout(function() {
                helper.hideSpinner(component, event, helper);
            }, 100);
        } else {
            helper.hideSpinner(component, event, helper);
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
    additionalClaimInfoCNFChange: function (component, event, helper) {
        console.log("additionalClaimInfoCNFChange: "+component.get("v.additionalClaimInfoCNF"));
    }
})