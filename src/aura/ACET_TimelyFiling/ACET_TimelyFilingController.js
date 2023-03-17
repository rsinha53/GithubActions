({
    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
        // US3474282 - Thanish - 19th Jul 2021 - commented unwanted code
        //Added by mani
    },
    onInit:function (component, event, helper) {
        helper.hideSpinner(component, event, helper);
        //component.set("v.firstSrvDate",'01/01/2020');
        //component.set("v.ContractorID",'264777940');
        var obj = component.get("v.PolicyDetails");
        console.log("23 Policy details"+JSON.stringify(obj));
        component.set("v.platform",obj.platform);
        component.set("v.marketType",obj.marketType);
        component.set("v.marketSite",obj.marketSite);
        component.set("v.productCode",obj.productCode);
        console.log("Tax id"+component.get("v.taxId"));
        console.log("provider Id"+component.get("v.providerId"));
        var platform = component.get("v.platform");
        var ProviderID= component.get("v.providerId");
        if(ProviderID == '--'){
            component.set("v.providerId",'');
        }
        helper.getContractorID(component, event, helper);

    }
})