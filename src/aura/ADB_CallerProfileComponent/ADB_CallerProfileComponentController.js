({
    onInit : function(component, event, helper) {
        var decodedMemberId = component.get("v.decodedMemberId");
        if (decodedMemberId != "" && decodedMemberId!= null){
            var formattedNumber = decodedMemberId.substring(0, 3).replace(/[0-9]/g, 'X') + '-' + decodedMemberId.substring(3, 5).replace(/[0-9]/g, 'X') + '-' + decodedMemberId.substring(5, 9);
            // set formatted Number to the UI
            component.set("v.memberNumber", formattedNumber); 
        } 
        // Current Call Function
        helper.getCurrentCall(component, event, helper);
		
        // Show Subject Name
        if(component.get("v.selectedMemberDOB") == component.get("v.callerDateofBirth")) {
            component.set("v.sameCallerSubject", true);
        }else{
            component.set("v.sameCallerSubject", false);
        }
    },

    unMaskNumber : function(component, event, helper){
        // Unmasking the ssn number
        var number = component.get("v.decodedMemberId");
        component.set("v.memberNumber", number); 
    },
    
    copyNumber: function(component, event, helper) {
        var number = component.get("v.decodedMemberId");
        helper.copyTextHelper(component,event,number);
    },
    
    /*page refresh after data save*/    
    isRefreshed: function(component, event, helper) {
        location.reload();
    }
})