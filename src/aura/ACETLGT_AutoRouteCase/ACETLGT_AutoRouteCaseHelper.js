({
     handleCreateLoad: function (component, event, helper) {
        var type = component.get("v.caseObj.Type__c");
        var options = [];
        var types = Object.keys(component.get('v.typeSubTypeDependency'));
        if(types){
            types.sort();
            console.log('optionsss:::: ' + JSON.parse(JSON.stringify(types)));
            options.push({label:'--None--',value:''});
            var typeVal;
            for(var i=0;i<types.length;i++){
                if(types[i] != 'None' && types[i] != '--None--'){
                    if(types[i].includes('&#x27;')){
                       types[i] = types[i].replace("&#x27;","'");
                    }
                    typeVal = types[i];//.replace("'s","\\'s");
            console.log('typeVal:::: ' + typeVal);
                    options.push({'label':types[i],'value':typeVal});
                }
            }
            console.log('optionsss:::: ' + JSON.parse(JSON.stringify(options)));
            component.set('v.typeOptions',options);
        }
        else{
            component.set('v.typeOptions',[{label:'--None--',value:''}]);
        }
        component.set('v.caseObj.Type__c',types.includes(type)?type:'');
        
        var subTypes = component.get('v.typeSubTypeDependency')[type];
        helper.setSubTypeOptions(component,type);
        
        var subType = component.get("v.caseObj.Subtype__c");
        //component.set('v.caseObj.SubType__c',(subTypes && subTypes.includes(subType))?subType:'');
        
        component.set('v.isLoaded',true);
    },
    handleOnSuccess: function(component,successMessage,helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Saved",
            "type" : "success",
            "message": successMessage,
            "mode":"dismissible",
            "duration":1000
        });
        
        toastEvent.fire();
        helper.handleResetHelper(component,3000);
    },
    handleOnError : function(cmp,errorMessage,dismissable){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "type" : "error",
            "message": errorMessage,
            "mode":dismissable?"dismissible":"sticky"
        });        
        toastEvent.fire();
    },
    handleResetHelper: function(component, timer) { 
        var caseobj = component.get("v.caseObj");
        
        var workspaceAPI = component.find("workspace");
        var caseRecordTabId = sessionStorage.getItem('caseRoute '+component.get('v.recordId'));
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            workspaceAPI.refreshTab({
                tabId: caseRecordTabId
            }); 
        });
                
        sessionStorage.setItem('caseRoute '+component.get('v.recordId'),null);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({
                tabId: focusedTabId
            });
        }); 
    },
    setSubTypeOptions : function(component,type){
        var options = [];
        var subTypes = component.get('v.typeSubTypeDependency')[type];
        if(subTypes && (type!='System Unavailable' || subTypes!='*')){
            options.push({label:'--None--',value:''});
            if(typeof subTypes == 'string'){
                subTypes = subTypes.split(';');
            }
	    subTypes.sort();
            for(var i=0;i<subTypes.length;i++){
                if(subTypes[i] != 'None' && subTypes[i] != '--None--'){
                    options.push({'label':subTypes[i],'value':subTypes[i]});
                }
            }
            component.set('v.subTypeOptions',options);
        }
        else{
            component.set('v.subTypeOptions',[{label:'--None--',value:''}]);
        }
    }
})