({
	handleSelect: function (component, event,helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        debugger;
        var selectedMenuItemValue = event.getParam("value");
        //alert("Menu item selected with value: " + selectedMenuItemValue);
        if(selectedMenuItemValue =='CopySSN'){
            //component.set("v.mask", true);
            var textforcopy = component.find("unMaskedSSN").get('v.value');
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='CopyEEID'){
            var textforcopy = component.find("unMaskedEEID").get('v.value');
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='UnMaskSSN'){
            //alert('UnMask');
            component.set("v.Mask",true);
            var unMask = component.find("formattedSSN");
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedSSN");
            $A.util.addClass(mask, "slds-hide");
        }
        else if(selectedMenuItemValue =='MaskSSN'){
            //alert('UnMask');
            component.set("v.Mask",false);
            var unMask = component.find("formattedSSN");
            $A.util.addClass(unMask, "slds-hide");
            var mask = component.find("maskedSSN");
            $A.util.removeClass(mask, "slds-hide");
        }
    }
})