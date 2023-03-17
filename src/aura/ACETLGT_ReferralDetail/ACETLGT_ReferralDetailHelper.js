({
    getReferralDetail: function(component, event, helper) {
        debugger;
        var action = component.get("c.getReferralDetailResults");
        action.setParams({
            firstName: component.get('v.firstName'),
            lastName: component.get('v.lastName'),
            birthDate: component.get('v.birthDate'),
            srk: component.get('v.srk')
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('----state---' + state);
            //check if result is successfull
            if (state == "SUCCESS") {
                var result = a.getReturnValue();
                console.log('------result--------' + result);
               if(result.statusCode!= null && result.statusCode!=200){
                     helper.getErrorMsg('GN', result.statusCode,  component,event,helper);  
                }
                if (result.statusCode==200 && !$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                  //component.set("v.referralMap",result.referralMap);
                    console.log(result.referralMap);
                    for (var singleKey in result.referralMap) {
                        if (singleKey == component.get('v.refId')) {
                            console.log(result.referralMap[singleKey].providerlst);
                            component.set('v.providerList', result.referralMap[singleKey].providerlst);
                            component.set('v.diagnosisList', result.referralMap[singleKey].diagnosisList);
                            component.set('v.serviceList', result.referralMap[singleKey].servicelst);
                            component.set("v.referralDetail", result.referralMap[singleKey]);
                            var refDet = component.get('v.referralDetail');
                            if(refDet.noteText!=null && refDet.noteText!=''){
                            	component.set('v.notesNotBlank', true);
                            }
                            var tabKey = component.get("v.AutodocKey") + component.get("v.GUIkey");

                            setTimeout(function() {
//                                alert("====");
                                window.lgtAutodoc.initAutodoc(tabKey);
//                                alert("==done?==");
                            }, 1);
                        }
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
      getErrorMsg: function(prefix, statusCode, component,event,helper) {
     
        //build action to query global error handling component
        var errorMsg;
        var action = component.get("c.getStdErrMsg");
        action.setParams({
            prefix: prefix,
            resultStatusCode: statusCode
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                errorMsg = response.getReturnValue();
                //component.set(errorLoc, errorMsg);
               if(errorMsg != 'undefined' && errorMsg != null){
                  helper.fireToast("Error:", errorMsg,component,event,helper);
               }
            }
        });
        $A.enqueueAction(action);
    },
    fireToast: function(title, messages,component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
    }
})