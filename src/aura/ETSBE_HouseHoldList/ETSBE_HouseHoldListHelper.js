({
	callHouseHoldWS : function(component,event,helper) {
        console.log('calling method...');
		var action = component.get("c.getHouseHoldMembers");
        
        action.setParams({
            "transactionId": component.get("v.transId")                        
        });
        
        //US1888880
        let isRunSpinner = component.get("v.isFireSpinner");
        if(isRunSpinner) {
        	helper.showPolicyHouseSpinner(component);
        }

        action.setCallback(this, function(response) {            
            var state = response.getState(); // get the response state
            console.log('state@@@' + state);
            if(state == 'SUCCESS') {
                //US1888880
            	helper.hidePolicyHouseSpinner(component);
                var result = response.getReturnValue();                                
                console.log('HS list::'+result.resultWrapper.houseHoldList);  
                component.set("v.ChangedHouseHoldData",result.resultWrapper.houseHoldList); 
            } else {
                //US1888880
            	helper.hidePolicyHouseSpinner(component);
            }
        });
        
        $A.enqueueAction(action);
	},
    householddata: function (component,event,helper) {
        var houseHoldList2 = component.get("v.houseHoldData");
        console.log('houseHoldList 2::'+JSON.stringify(houseHoldList2));
        component.set("v.ChangedHouseHoldData",houseHoldList2);
        //hidePolicyHouseSpinner(component);

        // Thanish - 15th Nov 2019 - Autodoc fix
        /*setTimeout(function(){
            //window.lgtAutodoc.refreshPolicyTable('houseHoldTable');
            window.lgtAutodoc.initAutodoc('houseHoldTable');
        },1500);*/
    },
    //US1888880 - Malinda : Spinner-show method
    showPolicyHouseSpinner: function (component) {
        var spinner = component.find("policy-household-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },//US1888880 - Malinda : Spinner-hide method     
    hidePolicyHouseSpinner: function (component) {
        var spinner = component.find("policy-household-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        //return null;
    }
})