({
    initiateWrapper: function(component, event, openPopUp){
        this.showSpinner(component, event);
        var caseItemId = component.get("v.recordId");
        var action = component.get("c.getRootCauseValues"); 
        action.setParams({"caseItemId":caseItemId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result==>here"+JSON.stringify(result)); 
                component.set("v.rootCauseWrapper",result);
                console.log('result.rootCauseCaseItem==>'+JSON.stringify(result.rootCauseCaseItem));
                console.log('id is ==>'+result.rootCauseCaseItem.hasOwnProperty('Id'));
                if(result.rootCauseCaseItem.hasOwnProperty('Id')==true){
                    console.log('inside');
                    component.set("v.rootcauseCaseItemId",result.rootCauseCaseItem.Id); 
                }
                
                if(openPopUp === 'Open'){
                    var inputJson = {
                        "rc1":result.rootCause1,
                        "rc1KeyCode":result.rootCause1Code,
                        "rc2":result.rootCause2,
                        "rc2KeyCode":result.rootCause2Code,
                        "rc3":result.rootCause3,
                        "rc3KeyCode":result.rootCause3Code,
                        "rc4":result.rootCause4,
                        "rc4KeyCode":result.rootCause4Code,
                        "rc5":result.rootCause5,
                        "rc5KeyCode":result.rootCause5Code
                    };
                    component.set("v.rcJsonWrap",inputJson);
                    this.openPopUpAction(component, event);
                }
            }
            this.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    getrcCaseItemRec: function(component, event){
        var caseItemId = component.get("v.recordId");
        var action = component.get("c.getRCcaseItem"); 
        action.setParams({"caseItemId":caseItemId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.rootCauseCaseItem",result);
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    closePopUpAction: function(component, event){
        component.set("v.editRootCause",false); 
    },
    openPopUpAction: function(component, event){
        component.set("v.editRootCause",true); 
    },
    showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
})