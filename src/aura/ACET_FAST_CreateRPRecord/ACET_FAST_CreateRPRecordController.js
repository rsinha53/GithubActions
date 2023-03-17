({
	closeAction : function(component, event, helper) {
		component.set("v.showPopUp",false);
	},
    onRecordSubmit: function(component, event, helper){
        event.preventDefault();
        var caseRectypeName = component.get("v.caseRecordTypeName");
        
        if(caseRectypeName=='Reactive Resolution'){
            var showValidationError = false;
            var vaildationFailReason = "";
            var requiredMessage="Complete this field.";
            if($A.util.isEmpty(component.find("slaRoute").get("v.value"))){
                showValidationError = true;
                vaildationFailReason = vaildationFailReason+"* SLA Routed Date"+" \n";
            }
            if($A.util.isEmpty(component.find("rpOutcome").get("v.value"))){
                showValidationError = true;
                vaildationFailReason = vaildationFailReason+"* Resolution Partner Outcome";
            }
            console.log("showValidationError==>"+showValidationError);
            if (!showValidationError) {                
                var eventFields = event.getParam("fields");
                component.find('FastForm').submit(eventFields);  
            } else {
                helper.showToast(component, event, "Below Fields are mandatory", "error",vaildationFailReason);
            }
        } 
        else if(caseRectypeName==='Proactive Action'){
            component.find('PipForm').submit(eventFields);
        }
        else{
            console.log("caseRectypeName==>"+caseRectypeName);
            var message = "RP records can be created only for Reactive Resolution or Proactive Action recordtypes";
            helper.showToast(component, event, "Error", "error",message); 
        }
    },
    handleOnSuccess : function(component, event, helper){
        var payload = event.getParams().response;
        console.log('payload.id==>'+payload.id);
        var recId = payload.id;
        var action = component.get("c.getRPNameId");        
        action.setParams({
            "recId": recId
        });      
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state-->'+state);
            if (state === "SUCCESS") {
                var finalResult = response.getReturnValue();
                console.log('rpName-->'+finalResult.rpName);
                var workspaceAPI = component.find("workspace");
                workspaceAPI.openTab({
                    url: '/lightning/r/PIR_Resolution_Partner__c/'+finalResult.rpID+'/view',
                    focus: true
                }).then(function(response) {})
                .catch(function(error) {
                });
                component.set("v.showPopUp",false);
                var message='Resolution Partner '+ finalResult.rpName+' saved successfully';
                helper.showToast(component, event, "Success", "Success",message);
                if(component.get("v.isCaseTab")==false){
                    helper.closeCurrentTab(component,event);
                }
                $A.get('e.force:refreshView').fire(); 
            }   
        });
        $A.enqueueAction(action);       
    },
})