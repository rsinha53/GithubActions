({
	initiateRC : function(component, event, helper) {
		helper.showSpinner(component, event);
        var jsonWp = component.get("v.rcJson");
        var wJSONVar = JSON.stringify(jsonWp);
        console.log("wJSONVar==>"+wJSONVar);
        var action = component.get("c.getRootCauseWrapper");
        action.setParams({"wrapperJSON" : wJSONVar});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result==>"+JSON.stringify(result));
                if(result.fMessage === 'SUCCESS'){
                    component.set("v.rc1List",helper.sortList(result.rc1List));
                    component.set("v.rc2List",helper.sortList(result.rc2List));
                    component.set("v.rc3List",helper.sortList(result.rc3List));
                    component.set("v.rc4List",helper.sortList(result.rc4List));
                    component.set("v.rc5List",helper.sortList(result.rc5List));
                    component.set("v.rcJson",jsonWp);
                    console.log('jsonWp.rc1KeyCode==>'+jsonWp.rc1KeyCode);
                    //component.find("rc1CodeId").set("v.value",jsonWp.rc1KeyCode);
                }else{
                    helper.showToast(component, event, "Error","error",result.fMessage);
                }
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
	},
    handleRC1Change: function(component, event, helper){
        helper.showSpinner(component, event);
        var rcWrapJson = component.get("v.rcJson");
        var rc1Arr = component.get("v.rc1List");
        rcWrapJson.rc1='';
        for(var i = 0; i < rc1Arr.length; i++){
            if(rc1Arr[i].rcCode==rcWrapJson.rc1KeyCode){
                rcWrapJson.rc1 =  rc1Arr[i].rcName;
            }
        }
        
        component.set("v.rc2List",[]);
        component.set("v.rc3List",[]);
        component.set("v.rc4List",[]);
        component.set("v.rc5List",[]);
       	rcWrapJson.rc2 = '';
        rcWrapJson.rc2KeyCode = '';
        rcWrapJson.rc3 = '';
        rcWrapJson.rc3KeyCode = '';
        rcWrapJson.rc4 = '';
        rcWrapJson.rc4KeyCode = '';
        rcWrapJson.rc5 = '';
        rcWrapJson.rc5KeyCode = '';
        
        var action = component.get("c.getrootCause2List"); 
        action.setParams({"prntRCCode":rcWrapJson.rc1KeyCode});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var rc2List = helper.sortList(response.getReturnValue());
                component.set("v.rc2List",rc2List);
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC2Change: function(component, event, helper){
        helper.showSpinner(component, event);
        var rcWrapJson = component.get("v.rcJson");
        var rc2Arr = component.get("v.rc2List");
        rcWrapJson.rc2='';
        for(var i = 0; i < rc2Arr.length; i++){
            if(rc2Arr[i].rcCode==rcWrapJson.rc2KeyCode){
                rcWrapJson.rc2 =  rc2Arr[i].rcName;
            }
        }
        
        component.set("v.rc3List",[]);
        component.set("v.rc4List",[]);
        component.set("v.rc5List",[]);
       	rcWrapJson.rc3 = '';
        rcWrapJson.rc3KeyCode = '';
        rcWrapJson.rc4 = '';
        rcWrapJson.rc4KeyCode = '';
        rcWrapJson.rc5 = '';
        rcWrapJson.rc5KeyCode = '';
        
        var action = component.get("c.getrootCause3List"); 
        action.setParams({"prntRCCode":rcWrapJson.rc2KeyCode});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var rc3List = helper.sortList(response.getReturnValue());
                component.set("v.rc3List",rc3List);
                component.set("v.rcJson",rcWrapJson);
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC3Change: function(component, event, helper){
        helper.showSpinner(component, event);
        var rcWrapJson = component.get("v.rcJson");
        var rc3Arr = component.get("v.rc3List");
        console.log('rc3Arr==>'+JSON.stringify(rc3Arr));
        console.log('rcWrapJson.rc3KeyCode==>'+rcWrapJson.rc3KeyCode);
        rcWrapJson.rc3='';
        for(var i = 0; i < rc3Arr.length; i++){
            console.log('rc3Arr[i].rcCode==>'+rc3Arr[i].rcCode);
            if(rc3Arr[i].rcCode==rcWrapJson.rc3KeyCode){
                console.log('rc3Arr[i].rcName==>'+rc3Arr[i].rcName);
                rcWrapJson.rc3 =  rc3Arr[i].rcName;
            }
        }
        
        component.set("v.rc4List",[]);
        component.set("v.rc5List",[]);
       	rcWrapJson.rc4 = '';
        rcWrapJson.rc4KeyCode = '';
        rcWrapJson.rc5 = '';
        rcWrapJson.rc5KeyCode = '';
        
        var action = component.get("c.getrootCause4List"); 
        action.setParams({"prntRCCode":rcWrapJson.rc3KeyCode});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var rc4List = helper.sortList(response.getReturnValue());
                component.set("v.rc4List",rc4List);
                component.set("v.rcJson",rcWrapJson);
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC4Change: function(component, event, helper){
        helper.showSpinner(component, event);
        var rcWrapJson = component.get("v.rcJson");
        var rc4Arr = component.get("v.rc4List");
        rcWrapJson.rc4='';
        for(var i = 0; i < rc4Arr.length; i++){
            if(rc4Arr[i].rcCode==rcWrapJson.rc4KeyCode){
                rcWrapJson.rc4 =  rc4Arr[i].rcName;
            }
        }
        
        component.set("v.rc5List",[]);
       	rcWrapJson.rc5 = '';
        rcWrapJson.rc5KeyCode = '';
        
        var action = component.get("c.getrootCause5List"); 
        action.setParams({"prntRCCode":rcWrapJson.rc4KeyCode});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var rc5List = helper.sortList(response.getReturnValue());
                component.set("v.rc5List",rc5List);
                component.set("v.rcJson",rcWrapJson);
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC5Change: function(component, event, helper){
        helper.showSpinner(component, event);
        var rcWrapJson = component.get("v.rcJson");
        var rc5Arr = component.get("v.rc5List");
        rcWrapJson.rc5='';
        for(var i = 0; i < rc5Arr.length; i++){
            if(rc5Arr[i].rcCode==rcWrapJson.rc5KeyCode){
                rcWrapJson.rc5 =  rc5Arr[i].rcName;
            }
        }
        component.set("v.rcJson",rcWrapJson);
        helper.hideSpinner(component, event);
    },
})