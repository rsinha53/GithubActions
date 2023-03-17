({
    hideAdditionalDetailsSpinner: function (cmp) {
        var spinner = cmp.find("additional-details");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    }
})