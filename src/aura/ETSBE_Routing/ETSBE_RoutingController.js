({
	onLoad: function(component, event, helper){ 
		console.log('here1' + component.get("v.recordId"));
        var stat = component.find("isrout").get("v.value");
        var chcksave = component.get("v.chcksave");
        component.find("routsts").set("v.value", "Routed");
        console.log('DISBUTTON0: ' + stat +','+chcksave);
        if(stat == true && chcksave == true){
            component.set("v.showError", true);
            component.set("v.errorMessage", "Case is already Routed");
        }
        else {
            component.set("v.disbutton", false);
        }
        console.log('DISBUTTON1: ' + component.get('v.disbutton'));
        helper.checkResearch(component,event,helper);  
        var action = component.get("c.getQueueFromCase");
        action.setParams({
        	'caseId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('QUEUE1: ' + state);
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
            	console.log('QUEUE2: ' + storeResponse);
                if(storeResponse != null & storeResponse != ''){
                	if(storeResponse.includes('|||||')){
	                	component.set('v.queueName', storeResponse.split('|||||')[1]);
	                	component.set('v.queueId', storeResponse.split('|||||')[0]);
                	} else {
                		component.set('v.queueId', storeResponse);
                	}                    
                }
                var queueName = component.get('v.queueName');
                var queueId = component.get('v.queueId');
                if(queueName == undefined || queueName == null || queueName == '') {
                    component.set("v.disbutton", true); 
                    component.set("v.showError", true);
                    component.set("v.errorMessage", "Case cannot be Routed since there is no association to the Queue");
                } else if(queueId == undefined || queueId == null || queueId == '') {
                    component.set("v.disbutton", true);
                    component.set("v.showError", true);
                    component.set("v.errorMessage", "Case cannot be Routed since there is no association to the Queue");
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleOnSubmit : function(component, event, helper) {
    	console.log('here2' + component.get("v.recordId"));
        event.preventDefault();
        component.find("isrout").set("v.value", true);
        var fields = event.getParam("fields");
        console.log('SUBMITTING: ' + fields);
        component.find("recordViewForm").submit(fields);
        
    },
    CloseQuickaction : function(component, event, helper) {
    	console.log('here3');
                $A.get("e.force:closeQuickAction").fire();
    },
    
    handleOnSuccess : function(component, event, helper) {
    	console.log('here4');
        var record = event.getParam("response");
        component.set("v.chcksave",false);
        component.set("v.disbutton", true);
        console.log('DISBUTTON2: ' + component.get('v.disbutton'));
        component.find("notificationsLibrary").showToast({
            "title": "",
            "message": "Record Saved Successfully.",
            "variant": "success"
        });      
        $A.get("e.force:closeQuickAction").fire();
	},
    handleError: function (cmp, event, helper) {
        cmp.find('notificationsLibrary').showToast({
            "title": "",
            "message": event.getParam("message"),
            "variant": "error"
        });
    }

})