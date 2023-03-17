({
    initRecords : function(component, event, helper) {
        helper.getReferenceRecords(component,event);
    },
    cSelected: function(component, event, helper){
        helper.showSpinner(component,event);
        var refLst = component.get("v.refList");
        var index = 0;
        for (var i = 0; i < refLst.length; i++) {
            if (refLst[i].selectedCheckBox == true) {
                index ++;
            }
		}
        if(index == 0){
            helper.hideSpinner(component,event);
            helper.showToast(component, event, 'Error', 'warning', 'You are not selected any record');
        } else {
            var action = component.get("c.completeSelected");
            action.setParams({
                'pagreRefWrapList': component.get("v.refList"),
                'rpId':component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    var storeResponse = result.pRefWrapList;
                    component.set("v.refList", storeResponse);
                    component.set("v.isCaseItemLayout", result.isCaseItem);
                    if(storeResponse!=undefined && storeResponse!=null && storeResponse.length>0){
                        component.set("v.recordListSize",storeResponse.length);
                    }else{
                        component.set("v.recordListSize",0);
                    }
                    component.set("v.slectButtonLabel",'Select All');
                    helper.hideSpinner(component,event);
                    helper.showToast(component, event, 'Success', 'success', 'Records Completed Successfully');
                }else{
                    helper.hideSpinner(component,event);
                    helper.showToast(component, event, 'Error', 'error', 'an error occured while saving');
                }
            });
            $A.enqueueAction(action); 
        }
    },
    dSelected: function(component, event, helper){
        helper.showSpinner(component,event);
        var refLst = component.get("v.refList");
        var index = 0;
        for (var i = 0; i < refLst.length; i++) {
            if (refLst[i].selectedCheckBox == true) {
                index ++;
            }
        }
        if(index == 0){
            helper.hideSpinner(component,event);
            helper.showToast(component, event, 'Error', 'warning', 'You are not selected any record');
        } else {
            var action = component.get("c.deleteSelected");
            action.setParams({
                'pagreRefWrapList': component.get("v.refList"),
                'rpId':component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    var storeResponse = result.pRefWrapList;
                    component.set("v.refList", storeResponse);
                     component.set("v.isCaseItemLayout", result.isCaseItem);
                    if(storeResponse!=undefined && storeResponse!=null && storeResponse.length>0){
                        component.set("v.recordListSize",storeResponse.length);
                    }else{
                        component.set("v.recordListSize",0);
                    }
                    component.set("v.slectButtonLabel",'Select All');
                    helper.hideSpinner(component,event);
                    helper.showToast(component, event, 'Success', 'success', 'Records Deleted Successfully');
                }else{
                    helper.hideSpinner(component,event);
                    helper.showToast(component, event, 'Error', 'error', 'an error occured while deleting');
                }
            });
            $A.enqueueAction(action);
        }
    },
    multiSelectAction: function(component, event, helper){
        helper.showSpinner(component,event);
        var currentButtonLabel= component.get("v.slectButtonLabel"); 
        var refRPList = component.get("v.refList");
        if(currentButtonLabel=='Select All'){
            component.set("v.slectButtonLabel",'Deselect All');
            refRPList.forEach(element => (element.selectedCheckBox=true));
        }else{
            refRPList.forEach(element => (element.selectedCheckBox=false));
            component.set("v.slectButtonLabel",'Select All');
        }
        component.set("v.refList",refRPList);
        helper.hideSpinner(component,event);
    },
})