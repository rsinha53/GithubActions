({
    getFileJson : function(component, event, helper){
        helper.showSpinner(component, event);
        var action = component.get("c.getLatestCaseAttachment");
        action.setParams({ caseId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state==>'+state);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.message =='SUCCESS'){
                    helper.loadData(component, event, resp);
                }
                else{
                    helper.showToast(component, event, 'Error','error',resp.message);
                    helper.closePopUpWindow(component, event);
                }
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    togFieldMap: function(component, event, helper){
        helper.toggleFieldMapping(component, event);
    },
    tabChange: function(component, event, helper){
        var tabList = component.get("v.tabList");
        var tabsSize = component.get("v.tabsSize");
        var completedCount = 0;
        for(var i=0; i<tabsSize; i++){
            if(tabList[i]["completed"]==true || tabList[i]["skipTab"]==true){
                completedCount = completedCount+1;
            }
        }
        component.set("v.completedCount",completedCount);
        if(completedCount/tabsSize==1){
            component.set("v.allTabsCompleted",true);
        }else{
            component.set("v.allTabsCompleted",false);
        }
    },
    closePopUp: function(component, event, helper){
        helper.closePopUpWindow(component, event);
        helper.showToast(component, event, 'Warning', 'warning', 'Case mapping failed');
    },
    handleSubmit: function(component, event, helper){
        helper.showSpinner(component, event);
        var fileJson = helper.assignSkipTabs(component, event,component.get("v.file"));
        if(helper.validateTabs(fileJson)){
            var action = component.get("c.createJSON");
            action.setParams({ jSONFile : fileJson,
                              caseId : component.get("v.recordId")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state=='SUCCESS'){
                    var resp = response.getReturnValue();
                    var message = 'Case successfully mapped.'; 
                    var type="success";
                    if(resp!='SUCCESS'){
                        message = resp;
                        type="error";
                    }
                    helper.hideSpinner(component, event);
                    helper.showToast(component, event, type, type, message);
                    helper.closePopUpWindow(component, event);
                }
                else{
                    helper.hideSpinner(component, event);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            helper.showToast(component, event, 'Error','error','Please Map atleaset one Tab');
            helper.hideSpinner(component, event);
        }
    },
})