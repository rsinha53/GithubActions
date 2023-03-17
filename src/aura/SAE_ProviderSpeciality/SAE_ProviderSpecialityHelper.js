({
   hidespecialitySpinner: function (cmp) {
        var spinner = cmp.find("physician-speciality");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    }
})