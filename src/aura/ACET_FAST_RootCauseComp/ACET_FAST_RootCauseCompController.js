({
    loadData : function(component, event, helper){
        var inputJson = {
            "rc1":'',
            "rc1KeyCode":'',
            "rc2":'',
            "rc2KeyCode":'',
            "rc3":'',
            "rc3KeyCode":'',
            "rc4":'',
            "rc4KeyCode":'',
            "rc5":'',
            "rc5KeyCode":''
        };
        component.set("v.rcJsonWrap",inputJson);
        helper.getrcCaseItemRec(component, event);
    },
    handleSelect: function (component, event, helper){
        var selectedMenuItemValue = event.getParam("value");
        if(selectedMenuItemValue =='updateRootCause'){
            helper.initiateWrapper(component, event,'Open');
        }
    },
    updateRootCause: function(component, event, helper){
        helper.initiateWrapper(component, event,'Open');
    },
    upsertRootCause: function(component, event, helper){
       	var wrapJson = component.get("v.rcJsonWrap");
        var rcWrapper = component.get("v.rootCauseWrapper");
        rcWrapper.rootCause1 = wrapJson.rc1;
        rcWrapper.rootCause1Code = wrapJson.rc1KeyCode;
        rcWrapper.rootCause2 = wrapJson.rc2;
        rcWrapper.rootCause2Code = wrapJson.rc2KeyCode;
        rcWrapper.rootCause3 = wrapJson.rc3;
        rcWrapper.rootCause3Code = wrapJson.rc3KeyCode;
        rcWrapper.rootCause4 = wrapJson.rc4;
        rcWrapper.rootCause4Code = wrapJson.rc4KeyCode;
        rcWrapper.rootCause5 = wrapJson.rc5;
        rcWrapper.rootCause5Code = wrapJson.rc5KeyCode;
        helper.showSpinner(component, event);
        var wJSONVar = JSON.stringify(rcWrapper);
        var caseItemId = component.get("v.recordId");
        var action = component.get("c.saveRootCause"); 
        action.setParams({
            "wrapperJSON" : wJSONVar,
            "caseItemId" : caseItemId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result==>"+JSON.stringify(result));
                if(result.finalMessage == 'Success'){
                    component.set("v.editRootCause",false);
                    component.set("v.rootCauseCaseItem",result.rcCaseItem);
                    helper.showToast(component, event, "Success","success","Root Cause Updated Successfully");
                    $A.get("e.force:refreshView").fire();
                }else{
                    helper.showToast(component, event, "Error","error",result.finalMessage);
                }
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    closePopUp: function(component, event, helper){
       helper.closePopUpAction(component, event); 
    },
    openPopUp: function(component, event, helper){
        helper.openPopUpAction(component, event);
    },
})