({
    providerIdChange : function(component, event, helper) {
        // helper.getAffData(component);
    },
    
    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();
        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
            // US3291540 - Sanka
            if(!component.get("v.isServiceSuccess")){
                helper.getAffData(component);
            }
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
})