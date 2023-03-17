({
   onInit: function(component, event, helper) {
        console.log("init is called of audit details");


   },
    toggleSection: function (component, event, helper) {

        helper.getAuditDetailsList(component);
        var auditDetailsList= component.get("v.auditDetailsList");
        var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        auditDetailsList.componentOrder = auditDetailsList.componentOrder + (20*currentIndexOfOpenedTabs);
        component.set("v.auditDetailsList", auditDetailsList);

        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
})