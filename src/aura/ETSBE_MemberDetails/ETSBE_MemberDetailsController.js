({
	doInit : function(component, event, helper) {
        console.log('in pcp section');
		console.log(component.get("v.memberCardData.PCPAssignments"));
       // alert(component.get("v.subjectCard"));
        
	},
	
	handleSelect: function (component, event,helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        //debugger;
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
        else if(selectedMenuItemValue =='UnMaskEEID'){
            //alert('UnMask');
            var unMask = component.find("unMaskedEEID");
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedEEID");
            $A.util.addClass(mask, "slds-hide");
        }
    },

    
	//US2137922: Added by Ravindra
    refreshPatientDetails: function (component, event, helper) {
        //debugger;
      
        var policySelectedIndex = component.get("v.policySelectedIndex");
        var memberCardData = component.get("v.memberCardData");
        console.log(JSON.parse(JSON.stringify(memberCardData)));
        if (!$A.util.isEmpty(memberCardData) && memberCardData.CoverageLines.length > 0) {
            component.set("v.patientInfo", memberCardData.CoverageLines[policySelectedIndex].patientInfo);
            component.set("v.transactionId", memberCardData.CoverageLines[policySelectedIndex].transactionId);
            component.set("v.policyMemberId",memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId);
        }
    },

    navigateToPCPHistory: function (component, event, helper) {
        var appevent = $A.get("e.c:SAE_PCPHistoryEvent");
        appevent.setParams({
            "historyViewed": true,
            "transactionId": component.get("v.transactionId")
        });
        appevent.fire();
    }
})