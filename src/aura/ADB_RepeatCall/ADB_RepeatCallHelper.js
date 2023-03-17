({
    getRepeatCallerInfo : function(component, helper){
        console.log('getting Repeat Caller');
        var fName = component.get('v.firstName');
        var lName = component.get('v.lastName');
        var memId = component.get('v.decodedMemberId');
        var dob = component.get('v.callerDateofBirth');
        if(!$A.util.isEmpty(dob)){
            var dobs = dob.split('/');
            if(!$A.util.isEmpty(dobs)){
                dob = dobs[2] + '-' + dobs[0] + '-' + dobs[1];
                
                //setting request body
                var reqBody = '{"_Request": "script:ACET_Dashboard_RepeatCaller",'+
                    '"_ENT_ContactFirstNm": "'+fName+'",'+
                    '"_ENT_ContactLastNm": "'+lName+'",'+
                    '"_ENT_ContactConstituentID": "'+memId+'",'+
                    '"_ENT_ContactDOB": "'+dob+'"}';
                
                //	calling the api
                var action = component.get("c.getRepeatCallerInfo");
                console.log('JSON.stringify(reqBody) : ', reqBody);
                action.setParams({
                    reqBody : reqBody
                });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var retValue = response.getReturnValue();
                        component.set("v.description", retValue.description);
                        component.set("v.numberOfOccurrences", retValue.count);
                    }
					component.set('v.showSpinner',false);									 
                });
                $A.enqueueAction(action);
            }
        }
		component.set('v.showSpinner',false);										  
    }
})