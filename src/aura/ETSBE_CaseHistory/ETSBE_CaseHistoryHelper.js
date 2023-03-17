({ hideCaseSpinner: function (component) {
        var spinner = component.find("case-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    showCaseSpinner: function (component) {
        var spinner = component.find("case-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
})