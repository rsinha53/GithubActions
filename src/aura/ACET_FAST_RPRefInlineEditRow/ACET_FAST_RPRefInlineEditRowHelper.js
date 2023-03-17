({
    getReferenceRecords : function(component,event){
        this.showSpinner(component,event);
        var action = component.get("c.getReferences");
        action.setParams({ "rpId" : component.get("v.rpRecId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var storeResponse = result.pRefWrapList;
                if(storeResponse!=undefined && storeResponse!=null && storeResponse.length>0){
                    component.set("v.recordListSize",storeResponse.length);
                }else{
                    component.set("v.recordListSize",0);
                }
                component.set("v.refList", storeResponse);
                component.set("v.iscItem",result.isCaseItem);
                this.hideSpinner(component,event);
            }else{
                this.hideSpinner(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event) {
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showToast: function(component, event, title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
        });
        toastEvent.fire();
    },
})