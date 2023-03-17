({
    hideCredentialSpinner: function (cmp) {
        var spinner = cmp.find("credential-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    }
})