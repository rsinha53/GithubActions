({
    openEngageOne: function(component, event, helper) {
        var engageOneUrl = component.get("v.engageOneUrl");
        window.open(engageOneUrl, 'EngageOne', 'toolbars=0,width=1200,height=500,left=0,top=0,scrollbars=1,resizable=1');
    },
    templatenamesHelper: function(component, event, helper,Service_Level) {
        if(!$A.util.isUndefinedOrNull(Service_Level) && (Service_Level =='OL' || Service_Level=='LF')){
        var opts = [
        { value: "None", label: "--None--" , selected: true },
        { value: "Deductible Letter - Oxford Family", label: "Deductible Letter - Oxford Family" },
        { value: "Deductible Letter - Oxford Individual", label: "Deductible Letter - Oxford Individual"},
        { value: "Foreign Travel", label: "Foreign Travel"},
        { value: "HIPAA Letter", label: "HIPAA Letter"},
        { value: "Proof of Lost Coverage", label: "Proof of Lost Coverage"}
        ];
                component.set('v.options', opts);
        }else{
            var opts = [
        { value: "None", label: "--None--" , selected: true },
        { value: "Deductible Letter - Oxford Family", label: "Deductible Letter - Oxford Family" },
        { value: "Deductible Letter - Oxford Individual", label: "Deductible Letter - Oxford Individual"},
        { value: "Foreign Travel", label: "Foreign Travel"},
        { value: "HIPAA Letter", label: "HIPAA Letter"},
        { value: "OON Cost Estimate Letter", label: "OON Cost Estimate Letter"},
        { value: "Proof of Lost Coverage", label: "Proof of Lost Coverage"}
		];
    component.set('v.options', opts);
        }

    },
    toastmessagehelper: function(component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": 'sticky'
        });
        toastEvent.fire();
    },
    
    refreshCaseSubtab: function(component, event, helper){
    	var caseNum = component.get('v.record.CaseNumber');
        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
//        alert('here');
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                
                for (var i=0; i<tabInfo.length; i++){   
                    console.log('enclosing');
                    console.log(varEnclosingTabId);
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 
                    	if(tabInfo[i].title.includes(caseNum)){
//                    		alert('refreshing main tab');
                    		workspaceAPI.refreshTab({
                                tabId: tabInfo[i].tabId,
                                includeAllSubtabs: false
                                }); 
                    	}
                        for (var j=0; j<tabInfo[i].subtabs.length; j++){      
                        	console.log(tabInfo[i].subtabs[j].title);

                            if (tabInfo[i].subtabs[j].title.includes(caseNum)){      
//                    		alert('refreshing sub tab');
                                workspaceAPI.refreshTab({
                                tabId: tabInfo[i].subtabs[j].tabId,
                                includeAllSubtabs: false
                                });                          
                            }
                        }
                    
                    }
                }
                
            }
        });
    },
    getErrorMsg: function(prefix, statusCode, errorLoc, component) {
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
              //  component.set(errorLoc, errorMsg);
            }
        });
        $A.enqueueAction(action);
    }
})