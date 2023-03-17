({
	hidespecialitySpinner: function (cmp) {
        var spinner = cmp.find("facility-speciality");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    }
})