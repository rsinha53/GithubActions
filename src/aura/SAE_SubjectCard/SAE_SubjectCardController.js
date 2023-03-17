({
	doInit : function(component, event, helper) {
		
	},
    
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
            var unMask = component.find("formattedSSN");
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedSSN");
            $A.util.addClass(mask, "slds-hide");
        }
        else if(selectedMenuItemValue =='UnMaskEEID'){
            //alert('UnMask');
            var unMask = component.find("unMaskedEEID");
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedEEID");
            $A.util.addClass(mask, "slds-hide");
        }
    }
})