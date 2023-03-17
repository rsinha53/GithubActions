({
    doInit : function(cmp, event, helper) {
        cmp.set("v.addressColumns", [
            {label:"Street Address 1", fieldName:"streetAddress", type:"text"},
            {label:"City", fieldName:"city", type:"text"},
            {label:"State", fieldName:"state", type:"text"},
            {label:"Zip Code", fieldName:"zip", type:"text"},
            {label:"Address Type", fieldName:"addressType", type:"text"},
            {label:"Phone", fieldName:"phone", type:"text"}
        ]);
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
        cmp.set("v.addressColumns", [
    					{label:"Street Address 1", fieldName:"streetAddress", type:"text"},
    		    		{label:"City", fieldName:"city", type:"text"},
    		    		{label:"State", fieldName:"state", type:"text"},
    		    		{label:"Zip Code", fieldName:"zip", type:"text"},
    		    		{label:"Address Type", fieldName:"addressType", type:"text"},
    		    		{label:"Phone", fieldName:"phone", type:"text"}
    		    		
    		    	]);
		var action = cmp.get("c.getProducerDetail");
         var tabName='';
        action.setParams({ producerId : event.getParam("producerId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.producerData",response.getReturnValue());
                var producerInfo = cmp.get("v.producerData");
               
               
                if(producerInfo.agencyName != ''){
                    tabName = producerInfo.agencyName;
                }else{
                    if(producerInfo.lastname != '')
                    tabName = producerInfo.lastname;
                    if(producerInfo.firstName != '')
                     tabName = producerInfo.firstName;   
                }
                //alert(tabName);
                if(!$A.util.isUndefined(tabName)){
                   var appEvent = $A.get("e.c:ETSBE_TabName");
                	appEvent.setParams({"TabName":tabName,"SearchType":"Producer"});
                    appEvent.fire();
                }
			}
        });
        $A.enqueueAction(action);
        
        
    }
})