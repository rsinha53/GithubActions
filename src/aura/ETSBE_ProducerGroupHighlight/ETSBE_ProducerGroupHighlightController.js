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
    },
	fetchproducerData : function(cmp, event, helper) {
       
		var action = cmp.get("c.getProducerDetail");
         var tabName='';
        action.setParams({ producerId : event.getParam("producerId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.producerDetail",response.getReturnValue());
                var producerInfo = cmp.get("v.producerDetail");
               
               alert(producerInfo);
                if(producerInfo.firstName != ''){
                    tabName = producerInfo.firstName;
                }else{
                    tabName = producerInfo.agencyName;
                }
               var appEvent = $A.get("e.c:ETSBE_TabName");
            appEvent.setParams({"TabName":tabName,"SearchType":"Producer"});
                appEvent.fire();
			}
        });
        $A.enqueueAction(action);
        
        
    }
})