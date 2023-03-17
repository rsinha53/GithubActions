({
	 onInit: function(component, event, helper) {
        var tableDetails = component.get("v.claimLevelDiagnosisDetailsResult");
        var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = component.get("v.maxAutoDocComponents");

         tableDetails.componentOrder = tableDetails.componentOrder + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        component.set("v.claimLevelDiagnosisList", tableDetails);
        console.log("table with pop up ", JSON.stringify(tableDetails));
    },

    toggleSection: function (component, event, helper) {
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