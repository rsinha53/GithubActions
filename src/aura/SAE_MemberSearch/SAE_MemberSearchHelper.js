({
	searchMembers : function(component,event,helper) {
		var action = component.get('c.findMembers');
        var memId = component.find('memNameID').get("v.value");
        console.log('memId@@@' + memId);
        component.set("v.memberIdOpt",memId);
        component.set("v.Nodata",null);
        component.set("v.data",null);
        if(memId == '77777777'){
            // US1944108 - Accommodate Multiple Payer ID's
            var payerValue = cmp.get('v.payerValue');
            console.log('Iffff');
            action.setParams({"memberId":memId, "payerID": payerValue}); // US1944108
            action.setCallback(this, function(response) {
                var state = response.getState(); // get the response state
                console.log('state@@@' + state);
                if(state == 'SUCCESS') {
                    var result = JSON.parse(response.getReturnValue());
                    var dataRes = result.combinedEligibility[0].patientDetails.patientInfo[0];
                    var multiInfoRes = result.multiMemberInfo;
                    console.log(dataRes);
                    component.set("v.data",dataRes);
                    component.set("v.multiInfoData",multiInfoRes);
                }
            });
        }else{
            console.log('elseeeee');
            component.set("v.data",null);
            component.set("v.Nodata",null);
            action.setParams({"memberId":memId});
            action.setCallback(this, function(response) {
                var state = response.getState(); // get the response state
                console.log('state@@@' + state);
                if(state == 'SUCCESS') {
                    var result = JSON.parse(response.getReturnValue());
                    console.log(result);
                    component.set("v.Nodata",result);
                }
            });
        }
        $A.enqueueAction(action);
	}
})