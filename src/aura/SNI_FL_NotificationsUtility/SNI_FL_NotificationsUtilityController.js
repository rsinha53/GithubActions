({
	init : function(component, event, helper) {
        console.log('Notification---------');
         let currentUser = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.currentUser",currentUser);
		 var action = component.get('c.getFirstTimePopupData');
         action.setParams({
             "contentType": component.get("v.typeContent")
        });
         action.setCallback(this, function(actionResult) {
            var stateResponse = actionResult.getState();
             console.log('Notification stateResponse-----'+stateResponse);
            if(stateResponse == 'SUCCESS') {
                var result = actionResult.getReturnValue();
                console.log('******'+result);
                //console.log('Notification result-----'+result);
                var urlString = window.location.href;
 				var baseURL = urlString.substring(0, urlString.indexOf("/s"));
                var settingUrl = baseURL+'/s/settings/'+currentUser;
                var res = result.replaceAll('/{currentUserId}',settingUrl);
                component.set('v.popupDesign', res);
            }
        }); 
        $A.enqueueAction(action); 
	}
})