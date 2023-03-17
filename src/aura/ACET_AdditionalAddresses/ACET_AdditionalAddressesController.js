({
    getResults : function(cmp,event,helper) {
        var pageNum = event.getParam('requestedPageNumber');
        cmp.set("v.pageNumber",pageNum);
        if(!$A.util.isEmpty(pageNum)) {
            helper.showSpinner(cmp);
            helper.getProviderData(cmp);
        }
    },
    
    fireAutodocEvent : function(cmp, event) {
        var rowIndex = event.currentTarget.parentElement.parentElement.getAttribute("data-index");
        var tableDetails = cmp.get("v.tableDetails");
        var tableBody = tableDetails.tableBody;
        var autodocEvent = cmp.getEvent("AutodocEvent");
        autodocEvent.setParams({
            "autodocCmpName" : tableDetails.componentName,
            "cmpType" : tableDetails.type,
            "eventData": tableBody[rowIndex]});
        autodocEvent.fire();
    },
    
    toggleSection: function (cmp, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = cmp.find(sectionAuraId).getElement();
        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        
        var webservicecalled = cmp.get("v.webservicecalled");
        if(!webservicecalled){
            helper.showSpinner(cmp);
            helper.getProviderData(cmp);
        }
        
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
    
    activeToggle: function (cmp, event, helper){
        helper.showSpinner(cmp);
        helper.getProviderData(cmp);
    }
})