({
    doInit : function(component, event, helper) {
        // var action = component.get("c.fetchUser");
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "ERM Explore"
            })
            workspaceAPI.setTabIcon({
                icon: "action:preview",
                iconAlt: "ERM Explore"
            })
            .catch(function(error) {
                console.log('response' +JSON.stringify(response));
                console.log(error);
            });
        })
        
        /* action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        
           $A.enqueueAction(action);*/
        
    },
    
    clearSearch: function(component, event, helper) {
        component.set("v.searchVal", null);
        component.find('sourcePickList').set("v.value", null);
        $A.get("e.force:refreshView").fire();
    },
    
    searchRequest: function(component, event, helper) { 
        //alert(component.get("v.searchVal"));
        if(component.get("v.searchVal")==null || component.get("v.searchVal")==''){
            var type = 'error';
            var message = 'Please Enter Search By';
            helper.showToast(message, type);
        }else{
            helper.processRequest(component, event, helper);
        }
        
    },
    
    newrequest:function(component, event, helper){ 
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.source;
        var cust= selectedItem.dataset.index;
        var streamList = component.get("v.listToDiplay");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:STM_NewRequest",
            componentAttributes: {
                platform : recId,
                customerdata:streamList[cust]
            }
        });
        evt.fire();
        
    },
    
    
    requestDetailsFlow:function(component, event, helper){        
        component.set('v.ismodalClicked', true);
        component.set("v.showData", false);
        component.set("v.displaySearchBox",false);
        //component.set('v.nullResults', false);
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        component.set("v.StreamGroupId",id_str);   
        var flow = component.find("flowData");
        var inputVariables = [
            {
                name : "StreamGroupId",
                type : "String",
                value : id_str
            }
        ];
        
        flow.startFlow("ERM_Create_Request", inputVariables);
        
    },
    
    launchFlowWhenNogrpFound :function (component, event, helper){
        component.set('v.ismodalClicked', true);
        component.set('v.nullResults', false);
        component.set("v.displaySearchBox",false);
        var flow = component.find("flowNodata");
        flow.startFlow("ERM_Create_Request");
    },
    
    startEServiceFlow : function(component, event, helper){
       // alert(component.get("v.eServicevalue"));
        
        /* if(component.get("v.eServicevalue")==null || component.get("v.eServicevalue")==''){
               var type = 'error';
               var message = 'Please Select eService Platform';
               helper.showToast(message, type);
        }*/
        //alert('Call Another flow');
         component.set('v.ismodalClicked', true);
         component.set("v.showData", false);
         component.set("v.displaySearchBox",false);
         var flow = component.find("floweService");
         var inputVariables = [
            {
                name : "eServiceName",
                type : "String",
                value : component.get("v.eServicevalue")
            }
          ];
          flow.startFlow("ERM_Create_Request", inputVariables);
        
    }
    
    
    
})