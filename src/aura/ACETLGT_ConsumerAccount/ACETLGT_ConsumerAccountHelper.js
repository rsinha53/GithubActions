({
	checkProfile : function(cmp, event, helper) {
        //US1935707
        
        var action = cmp.get("c.getProfileUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                //console.log('storeResponse::: '+storeResponse);
                cmp.set("v.usInfo", storeResponse);
                //helper.checkProfileType(cmp, event, helper);
            }
        });
        $A.enqueueAction(action);
		
	},
    createGUID: function(component, event, helper) {
        var len = 20;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.guid",GUIkey);
    },
    //US1935707: Research user - User doesnt see misdirect button
    checkProfileType: function(component, event, helper){
        
        var userProfileName = component.get("v.usInfo").Profile_Name__c;
        if (userProfileName == $A.get("$Label.c.ACETResearchUserProfile")){
            component.set("v.showSave", "false");
		}
    }  
})