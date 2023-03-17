({
	callPolicyWS : function(component, event, helper) {
       
        var selectedTransId = component.get("v.transId");
        console.log('selectedTransId::'+selectedTransId);
        
        //US1888880
        let isRunSpinner = component.get("v.isFireSpinner");
        if(isRunSpinner) {
        	helper.showPolicyDetailSpinner(component);
        }
        
        var action = component.get("c.getPolicyData");
        action.setParams({ transactionId : selectedTransId });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //US1888880
            	helper.hidePolicyDetailSpinner(component);
                var resValues = response.getReturnValue();
                console.log('###RESP:',JSON.stringify( resValues));
                //console.log('From server: ' + JSON.stringify(resValues));
                //console.log('From server: ' + JSON.stringify(resValues.resultWrapper));
                //console.log('From server: ' + JSON.stringify(resValues.resultWrapper.policyRes));
                //console.log('From server: ' + resValues.resultWrapper.policyRes.fundingType);
                
                component.set("v.policyDetails", response.getReturnValue());
                console.log('policies : ', component.get("v.policyDetails"));

                //US2138475 - Autodoc Policy Click - Sanka
                var componentId = component.get('v.AutodocPageFeature') + 'policyDetailsSection';
                component.set('v.componentId',componentId);

                if(component.get('v.InitialLoad')){
                    component.set("v.originPage", component.get('v.AutodocPageFeature'));
                }
                component.set('v.InitialLoad',false);
				var tabKey = component.get("v.AutodocKey");
                /*setTimeout(function(){
                    //window.lgtAutodoc.refreshPolicyTable('policyDetailsSection');
                    if( component.get('v.originPage') == component.get('v.AutodocPageFeature') )
                    {
                        window.lgtAutodoc.initAutodoc(tabKey);//componentId
                    }
                },1);*/
                
                // value binding is pending
            }
            else if (state === "INCOMPLETE") {
                // do something
                //US1888880
            	helper.hidePolicyDetailSpinner(component);
            }
            else if (state === "ERROR") {
                //US1888880
            	helper.hidePolicyDetailSpinner(component);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);		
	},//US1888880 - Malinda : Spinner-show method
    showPolicyDetailSpinner: function (component) {
        var spinner = component.find("policy-details-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },//US1888880 - Malinda : Spinner-hide method     
    hidePolicyDetailSpinner: function (component) {
        var spinner = component.find("policy-details-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        //return null;
    }
})