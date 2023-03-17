({
	//Added : Create New Case
    getUserInfo: function (component, event, helper) {
        console.log('getUser info...');
        var action = component.get("c.getUser");
        action.setCallback(this, function (response) {
            var state = response.getState();
             console.log('state getuser info...'+state);
            if (state === "SUCCESS") {
               
                var userRes = response.getReturnValue();
                component.set("v.userInfo", userRes);
            }
        });
        $A.enqueueAction(action);
    },
	//Added : Get Org Name
     getorgInfo: function (component, event, helper) {
        var action = component.get("c.getorg");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var orgRes = response.getReturnValue();
                component.set("v.orgInfo", orgRes);
            }
        });
        $A.enqueueAction(action);
    },
    
    prepareHighlightPanelInfo: function (cmp, event, helper){
        console.log('in Highlight info');
        var hlpd = cmp.get("v.interaction");
        var hgltData = JSON.stringify(hlpd);
        var mbrGrpNo=cmp.get("v.groupNo");
        var mbrGrpName=cmp.get("v.groupName");
        console.log('Hightlight Panel- hgltData:::'+hgltData);
		if(hgltData != undefined){
			var action = cmp.get("c.prepareHighlightsInfo");
			action.setParams({
					highlightPanelInfo : hgltData,
					mbrGrpNo : mbrGrpNo,
					mbrGrpName : mbrGrpName
				});
			
			action.setCallback(this, function(response) {
				var state = response.getState();            
				if (state === "SUCCESS") {              
				   
					var hlpdResponse = response.getReturnValue();
					console.log('-------hlpdResponse-----'+hlpdResponse);
					cmp.set("v.HighlightPaneldetail", hlpdResponse);
					cmp.set("v.HighlightPanelString", JSON.stringify(hlpdResponse));              
				}
			});
			$A.enqueueAction(action);
		}
    },
})