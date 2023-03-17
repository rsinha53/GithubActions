({
    updateEHub : function(component, event, helper) {
        var recordId = component.get("v.recordId"); 
        console.log('recordId='+recordId);
        if (recordId) { 
            var action = component.get("c.updateEHub");
            var objectType = component.get("v.sobjecttype");
            console.log('objectType:'+objectType);
            action.setParams({
                "recordId": recordId,
                 "objectType" : objectType
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('updateEHub state='+state);
                var result = response.getReturnValue();
                console.log('updateEHub result=');
                console.log(result);
               if(result && result.elligHubCheck){
                if (state === "SUCCESS") {
                    var statusCode=result.statusCode;
                    console.log('updateEHub statusCode='+statusCode);
                    if(statusCode){
                       //if(statusCode==200 || statusCode==201 ) As Update message not required
                       //helper.fireToastMessage('Info!', result.message, 'info', 'sticky', 5);
                       if(statusCode!=200 && statusCode!=201 )
                        helper.fireToast(result.message);
                    }else{
                        var errorCode='EHub500';
                        helper.errorMessage(component,errorCode,helper);
                    }
                }
                else{
                     var errorCode='EHub500';
                     helper.errorMessage(component,errorCode,helper);
                }
               } 
            });
            $A.enqueueAction(action);

        }
    },
	fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
    },
    errorMessage:function (component,errorCode, helper) {
        var action = component.get("c.getErrorMessage");
        action.setParams({
            "errorCode":errorCode
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                helper.fireToast(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})