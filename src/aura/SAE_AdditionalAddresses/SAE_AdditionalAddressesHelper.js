({
    getProviderData: function (component, event, helper, offset) {
        helper.showSpinner(component);
        var recNumber = component.get("v.pageOffset");
        var action = component.get("c.getAddresses");
        action.setParams({
            providerId: component.get("v.providerId"),
            taxId: component.get("v.taxId"),
            start: offset,
            endCount: recNumber
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));

                component.set("v.addressData", response.getReturnValue().AdditionalAdresses);
                component.set("v.filteredData", response.getReturnValue().AdditionalAdresses);
                component.set("v.prevBottom", response.getReturnValue().prevOffsetBottom);
                component.set("v.currentBottom", response.getReturnValue().currOffsetBottom);
                component.set("v.nextBottom", response.getReturnValue().nextOffsetBottom);
                component.set("v.totalRecordCount", response.getReturnValue().totalRecordCount);
                component.set("v.recordsInCurrentPage", response.getReturnValue().recordsInCurrentPage);
               
                helper.generatePages(component, event, helper, recNumber);
                helper.setViewAttributes(component);
                helper.hideSpinner(component);
            } else if (state === "INCOMPLETE") {
                helper.hideSpinner(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                            helper.showToast(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                helper.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },

    generatePages: function (component, event, helper, pageSize) {
        var recordCount = component.get("v.totalRecordCount");
        var pageCount = Math.ceil(recordCount / pageSize);
        component.set("v.totalPages", pageCount);

        var lastPageBlock = Math.ceil(pageCount / component.get("v.pageBlockOffset"));
        component.set("v.lastPageBlock", lastPageBlock);

        helper.getNextPageSet(component);
    },

    showSpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

    setViewAttributes: function (component) {
        var currentPageNumber = component.get("v.currentPageNumber");
        var offset = component.get("v.pageOffset");
        var recordCount = component.get("v.totalRecordCount");

        var fromCount = (((currentPageNumber - 1) * offset) + 1);
        var toCount = fromCount + (offset - 1);
        //toCount = recordCount < offset ? recordCount : toCount;
        toCount = recordCount < offset ? recordCount : (toCount > recordCount ? recordCount : toCount);

        component.set("v.fromCount", fromCount);
        component.set("v.toCount", toCount);
    },

    getNextPageSet: function (component) {
        var totalPages = component.get("v.totalPages");
        var pages = [];
        var starting = ((component.get("v.currentPageBlock") - 1) * component.get("v.pageBlockOffset")) + 1;
        var ending = starting + component.get("v.pageBlockOffset");
        ending = ending > totalPages ? totalPages + 1 : ending;
        var pages = [];
        for (var i = starting; i < ending; i++) {
            pages.push(i);
        }
        component.set("v.pageList", pages);

        var hasNext = ending > totalPages ? false : true;
        component.set("v.hasNext", hasNext);

        var hasPrev = starting == 1 ? false : true;
        component.set("v.hasPrev", hasPrev);
    },

    showToast : function(message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "type" : "error",
            "mode": "pester",
            "duration": "10000"
        });
        toastEvent.fire();
    }
})