({
    hideproviderphysicianSpinner: function (cmp) {
        var spinner = cmp.find("provider-physician");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    }
})